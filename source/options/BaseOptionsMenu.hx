package options;

#if discord_rpc
import Discord.DiscordClient;
#end
import Controls;
import flash.text.TextField;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;

using StringTools;

class BaseOptionsMenu extends MusicBeatSubstate
{
	private var curOption:Option = null;
	private var curSelected:Int = 0;
	private var optionsArray:Array<Option>;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var checkboxGroup:FlxTypedGroup<CheckboxThingie>;
	private var grpTexts:FlxTypedGroup<AttachedText>;

	private var kyle:BGSprite = null;
	private var descBox:FlxSprite;
	private var descText:FlxText;

	public var title:String;
	public var rpcTitle:String;

	public function new()
	{
		super();

		FlxG.mouse.visible = ClientPrefs.menuMouse;

		if(title == null) title = 'Options';
		if(rpcTitle == null) rpcTitle = 'Options Menu';
		
		#if discord_rpc
		DiscordClient.changePresence(rpcTitle, null);
		#end

		// avoids lagspikes while scrolling through menus!
		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		grpTexts = new FlxTypedGroup<AttachedText>();
		add(grpTexts);

		checkboxGroup = new FlxTypedGroup<CheckboxThingie>();
		add(checkboxGroup);

		for (i in 0...optionsArray.length)
		{
			var optionText:Alphabet = new Alphabet(340, 300, optionsArray[i].name, true);
			optionText.isMenuItem = true;
			optionText.targetY = i;
			optionText.scaleX = 0.8;
			optionText.scaleY = 0.8;
			grpOptions.add(optionText);

			if(optionsArray[i].type == 'bool') {
				var checkbox:CheckboxThingie = new CheckboxThingie(optionText.x - 105, optionText.y, optionsArray[i].getValue() == true);
				checkbox.sprTracker = optionText;
				checkbox.offsetY = -100;
				checkbox.offsetX = -50;
				checkbox.ID = i;
				checkboxGroup.add(checkbox);
			} else {
				optionText.x -= 80;
				optionText.startPosition.x -= 80;
				var valueText:AttachedText = new AttachedText('' + optionsArray[i].getValue(), optionText.width, -50, true);
				valueText.sprTracker = optionText;
				valueText.copyAlpha = true;
				valueText.scaleX = 0.8;
				valueText.scaleY = 0.8;
				valueText.ID = i;
				grpTexts.add(valueText);
				optionsArray[i].setChild(valueText);
			}

			if(optionsArray[i].showBoyfriend && kyle == null)
			{
				reloadBoyfriend();
			}
			updateTextFrom(optionsArray[i]);
		}

		var topBoarder:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image('pause/top_boarder', 'shared'));
		topBoarder.antialiasing = ClientPrefs.globalAntialiasing;
		add(topBoarder);
		insert(998, topBoarder);

		var bottomBoarder:FlxSprite = new FlxSprite(95, 647).loadGraphic(Paths.image('pause/bottom_boarder', 'shared'));
		bottomBoarder.antialiasing = ClientPrefs.globalAntialiasing;
		add(bottomBoarder);
		insert(999, bottomBoarder);

		descBox = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		descBox.alpha = 0.6;
		add(descBox);
		insert(1000, descBox);

		descText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);
		insert(1001, descText);

		changeSelection();
		reloadCheckboxes();
	}

	public function addOption(option:Option) {
		if(optionsArray == null || optionsArray.length < 1) optionsArray = [];
		optionsArray.push(option);
	}

	var nextAccept:Int = 5;
	var holdTime:Float = 0;
	var holdValue:Float = 0;
	override function update(elapsed:Float)
	{
		if (controls.UI_UP_P)
		{
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P)
		{
			changeSelection(1);
		}

		if(ClientPrefs.menuMouse){
			if(FlxG.mouse.wheel != 0){
				// Mouse wheel logic goes here, for example zooming in / out:
				if (FlxG.mouse.wheel < 0)
					changeSelection(1);
				else if (FlxG.mouse.wheel > 0)
					changeSelection(-1);	
			}	
		}
		
		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			close();
		}

		if(nextAccept <= 0)
		{
			var usesCheckbox = true;
			if(curOption.type != 'bool')
			{
				usesCheckbox = false;
			}

			if(usesCheckbox)
			{
				if(controls.ACCEPT)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					curOption.setValue((curOption.getValue() == true) ? false : true);
					curOption.change();
					reloadCheckboxes();
				}
			} else {
				if(controls.UI_LEFT || controls.UI_RIGHT) {
					var pressed = (controls.UI_LEFT_P || controls.UI_RIGHT_P);
					if(holdTime > 0.5 || pressed) {
						if(pressed) {
							var add:Dynamic = null;
							if(curOption.type != 'string') {
								add = controls.UI_LEFT ? -curOption.changeValue : curOption.changeValue;
							}
			
							switch(curOption.type)
							{
								case 'int' | 'float' | 'percent':
									holdValue = curOption.getValue() + add;
									if(holdValue < curOption.minValue) holdValue = curOption.minValue;
									else if (holdValue > curOption.maxValue) holdValue = curOption.maxValue;
			
									switch(curOption.type)
									{
										case 'int':
											holdValue = Math.round(holdValue);
											curOption.setValue(holdValue);
			
										case 'float' | 'percent':
											holdValue = FlxMath.roundDecimal(holdValue, curOption.decimals);
											curOption.setValue(holdValue);
									}
			
								case 'string':
									var num:Int = curOption.curOption; //lol
									if(controls.UI_LEFT_P) --num;
									else num++;
			
									if(num < 0) {
										num = curOption.options.length - 1;
									} else if(num >= curOption.options.length) {
										num = 0;
									}
			
									curOption.curOption = num;
									curOption.setValue(curOption.options[num]); //lol
									//trace(curOption.options[num]);
							}
							updateTextFrom(curOption);
							curOption.change();
							FlxG.sound.play(Paths.sound('scrollMenu'));
						} else if(curOption.type != 'string') {
							holdValue += curOption.scrollSpeed * elapsed * (controls.UI_LEFT ? -1 : 1);
							if(holdValue < curOption.minValue) holdValue = curOption.minValue;
							else if (holdValue > curOption.maxValue) holdValue = curOption.maxValue;
			
							switch(curOption.type)
							{
								case 'int':
									curOption.setValue(Math.round(holdValue));
								
								case 'float' | 'percent':
									curOption.setValue(FlxMath.roundDecimal(holdValue, curOption.decimals));
							}
							updateTextFrom(curOption);
							curOption.change();
						}
					}
			
					if(curOption.type != 'string') {
						holdTime += elapsed;
					}		
				} else if(controls.UI_LEFT_R || controls.UI_RIGHT_R) {
					clearHold();
				}
			}

			if(controls.RESET)
			{
				for (i in 0...optionsArray.length)
				{
					var leOption:Option = optionsArray[i];
					leOption.setValue(leOption.defaultValue);
					if(leOption.type != 'bool')
					{
						if(leOption.type == 'string')
						{
							leOption.curOption = leOption.options.indexOf(leOption.getValue());
						}
						updateTextFrom(leOption);
					}
					leOption.change();
				}
				FlxG.sound.play(Paths.sound('cancelMenu'));
				reloadCheckboxes();
			}

			if(ClientPrefs.menuMouse){
				grpOptions.forEach(function(spr:Alphabet)
				{
					if(FlxG.mouse.overlaps(spr))
					{
						/*
						if(FlxG.mouse.justPressed)
						{
							if (curSelected != Std.int(spr.ID))
							{
								curSelected = Std.int(spr.ID);
								changeSelection();
							}
						}*/

						if(usesCheckbox)
						{
							if(FlxG.mouse.justPressed)
							{
								FlxG.sound.play(Paths.sound('scrollMenu'));
								curOption.setValue((curOption.getValue() == true) ? false : true);
								curOption.change();
								reloadCheckboxes();
							}
						}
						else {
							if(FlxG.mouse.pressed || FlxG.mouse.pressedRight) {
								var pressed = (FlxG.mouse.justPressed || FlxG.mouse.justPressedRight);
								if(holdTime > 0.5 || pressed) {
									if(pressed) {
										var add:Dynamic = null;
										if(curOption.type != 'string') {
											add = FlxG.mouse.pressedRight ? -curOption.changeValue : curOption.changeValue;
										}
						
										switch(curOption.type)
										{
											case 'int' | 'float' | 'percent':
												holdValue = curOption.getValue() + add;
												if(holdValue < curOption.minValue) holdValue = curOption.minValue;
												else if (holdValue > curOption.maxValue) holdValue = curOption.maxValue;
						
												switch(curOption.type)
												{
													case 'int':
														holdValue = Math.round(holdValue);
														curOption.setValue(holdValue);
						
													case 'float' | 'percent':
														holdValue = FlxMath.roundDecimal(holdValue, curOption.decimals);
														curOption.setValue(holdValue);
												}
						
											case 'string':
												var num:Int = curOption.curOption; //lol
												if(FlxG.mouse.justPressedRight) --num;
												else num++;
						
												if(num < 0) {
													num = curOption.options.length - 1;
												} else if(num >= curOption.options.length) {
													num = 0;
												}
						
												curOption.curOption = num;
												curOption.setValue(curOption.options[num]); //lol
												//trace(curOption.options[num]);
										}
										updateTextFrom(curOption);
										curOption.change();
										FlxG.sound.play(Paths.sound('scrollMenu'));
									} else if(curOption.type != 'string') {
										holdValue += curOption.scrollSpeed * elapsed * (FlxG.mouse.pressedRight ? -1 : 1);
										if(holdValue < curOption.minValue) holdValue = curOption.minValue;
										else if (holdValue > curOption.maxValue) holdValue = curOption.maxValue;
						
										switch(curOption.type)
										{
											case 'int':
												curOption.setValue(Math.round(holdValue));
											
											case 'float' | 'percent':
												curOption.setValue(FlxMath.roundDecimal(holdValue, curOption.decimals));
										}
										updateTextFrom(curOption);
										curOption.change();
									}
								}
						
								if(curOption.type != 'string') {
									holdTime += elapsed;
								}		
							} else if(FlxG.mouse.justReleased || FlxG.mouse.justReleasedRight) {
								clearHold();
							}
						}
					}
				});			
			}
		}

		if(kyle != null && kyle.animation.curAnim.finished) {
			kyle.dance();
		}

		if(nextAccept > 0) {
			nextAccept -= 1;
		}
		super.update(elapsed);
	}

	function updateTextFrom(option:Option) {
		var text:String = option.displayFormat;
		var val:Dynamic = option.getValue();
		if(option.type == 'percent') val *= 100;
		var def:Dynamic = option.defaultValue;
		option.text = text.replace('%v', val).replace('%d', def);
	}

	function clearHold()
	{
		if(holdTime > 0.5) {
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		holdTime = 0;
	}

	function changeSelection(change:Int = 0)
	{
		curSelected += change;
		if (curSelected < 0)
			curSelected = optionsArray.length - 1;
		if (curSelected >= optionsArray.length)
			curSelected = 0;

		descText.text = optionsArray[curSelected].description;
		descText.screenCenter(Y);
		descText.y += 270;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
			}
		}
		for (text in grpTexts) {
			text.alpha = 0.6;
			if(text.ID == curSelected) {
				text.alpha = 1;
			}
		}

		descBox.setPosition(descText.x - 10, descText.y - 10);
		descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
		descBox.updateHitbox();

		if(kyle != null)
		{
			kyle.visible = optionsArray[curSelected].showBoyfriend;
		}
		curOption = optionsArray[curSelected]; //shorter lol
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	public function reloadBoyfriend()
	{
		var wasVisible:Bool = false;
		if(kyle != null) {
			wasVisible = kyle.visible;
			kyle.kill();
			remove(kyle);
			kyle.destroy();
		}

		kyle = new BGSprite('bg1/koolguykyle', 860, 70, 0.95, 1, ['kool_guy_kyle'], 'tbd');
		kyle.animation.finish();
		kyle.setGraphicSize(Std.int(kyle.width * 0.7));
		kyle.updateHitbox();
		add(kyle);
		kyle.visible = wasVisible;
	}

	function reloadCheckboxes() {
		for (checkbox in checkboxGroup) {
			checkbox.daValue = (optionsArray[checkbox.ID].getValue() == true);
		}
	}
}