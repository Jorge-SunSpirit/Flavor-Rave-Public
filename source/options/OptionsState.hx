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
import flixel.group.FlxSpriteGroup;
import flixel.addons.display.FlxBackdrop;
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

class OptionsState extends MusicBeatState
{
	var options:Array<String> = ['Controls', 'Adjust Delay and Combo', 'Graphics', 'Visuals and UI', 'Gameplay', 'Mods'];
	private var grpOptions:FlxTypedGroup<OptionsItem>;
	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;
	public static var whichState:String = "default";
	var allowInput = true;
	var backdrop:FlxBackdrop;
	var bgthingie:FlxSprite;

	function openSelectedSubstate(label:String) {
		FlxTween.cancelTweensOf(bgthingie);
		FlxTween.tween(bgthingie, {x: -615}, 0.2, {ease: FlxEase.sineOut});

		for (item in grpOptions.members)
		{
			FlxTween.cancelTweensOf(item);
			FlxTween.tween(item, {x: -623}, 0.2, {ease: FlxEase.sineOut, startDelay: 0.05 + (item.ID * 0.01)});
		}

		allowInput = false;

		switch(label) {
			case 'Controls':
				openSubState(new ControlsSubState());
			case 'Graphics':
				openSubState(new GraphicsSettingsSubState());
			case 'Visuals and UI':
				openSubState(new VisualsUISubState());
			case 'Gameplay':
				openSubState(new GameplaySettingsSubState());
			case 'Adjust Delay and Combo':
				MusicBeatState.switchState(new NoteOffsetState());
			case 'Mods':
				MusicBeatState.switchState(new ModsMenuState());
		}
	}

	override function create() {
		persistentUpdate = persistentDraw = true;
		FlxG.mouse.visible = ClientPrefs.menuMouse;

		#if discord_rpc
		DiscordClient.changePresence("Options Menu", null);
		#end

		backdrop = new FlxBackdrop(Paths.image('options/checkerboard'));
		backdrop.velocity.set(-20, -20);
		backdrop.antialiasing = ClientPrefs.globalAntialiasing;
		add(backdrop);

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuOptions'));
		bg.updateHitbox();

		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		bgthingie = new FlxSprite().loadGraphic(Paths.image('pause/bg', 'shared'));
		bgthingie.antialiasing = ClientPrefs.globalAntialiasing;
		add(bgthingie);

		if (whichState == 'playstate') options.remove('Mods');

		grpOptions = new FlxTypedGroup<OptionsItem>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var item = new OptionsItem(77 + (i * 61), 157 + (i * 137), options[i]);
			item.ID = i;
			grpOptions.add(item);
		}

		var topBoarder:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image('pause/top_boarder', 'shared'));
		topBoarder.antialiasing = ClientPrefs.globalAntialiasing;
		add(topBoarder);

		var bottomBoarder:FlxSprite = new FlxSprite(95, 647).loadGraphic(Paths.image('pause/bottom_boarder', 'shared'));
		bottomBoarder.antialiasing = ClientPrefs.globalAntialiasing;
		add(bottomBoarder);

		changeSelection();
		ClientPrefs.saveSettings();

		super.create();
	}

	override function closeSubState() {
		super.closeSubState();
		ClientPrefs.saveSettings();
		changeSelection();
		FlxTween.cancelTweensOf(bgthingie);
		FlxTween.tween(bgthingie, {x: 0}, 0.2, {ease: FlxEase.sineOut});
		allowInput = true;
	}
	
	override function update(elapsed:Float) {
		super.update(elapsed);

		if (allowInput)
		{
			if (controls.UI_UP_P) {
				changeSelection(-1);
			}
			if (controls.UI_DOWN_P) {
				changeSelection(1);
			}
	
			if (controls.BACK) {
				FlxG.sound.play(Paths.sound('cancelMenu'));
				switch(whichState)
				{
					default:
						MusicBeatState.switchState(new MainMenuState());
					case 'playstate':
						MusicBeatState.switchState(new PlayState());
						FlxG.sound.music.volume = 0;
					case 'freeplay':
						MusicBeatState.switchState(new FreeplayState());
					case 'storymenu':
						MusicBeatState.switchState(new StoryMenuState());
				}
			}
	
			if (controls.ACCEPT) {
				openSelectedSubstate(options[curSelected]);
			}
		}

		grpOptions.forEach(function(spr:OptionsItem) 
		{
			if (ClientPrefs.menuMouse) 
			{
				if (FlxG.mouse.overlaps(spr)) 
				{
					if (FlxG.mouse.justPressed) 
					{
						if (curSelected != Std.int(spr.ID)) 
						{
							curSelected = Std.int(spr.ID);
							changeSelection();
						}
						else 
							openSelectedSubstate(options[curSelected]);
					}
				}
			}
		});
	}

	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.ID = bullShit - curSelected;
			bullShit++;

			FlxTween.cancelTweensOf(item);
			FlxTween.tween(item, {x: 77 + (item.ID * 61), y: 157 + (item.ID * 137)}, 0.2, {ease: FlxEase.sineOut});

			item.isSelected(false);
			if (item.ID == 0)
				item.isSelected(true);
		}

		if (change != 0)
			FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}

class OptionsItem extends FlxSpriteGroup
{
	var selection:FlxSprite;
	public var weekienumbie:Int;

	public function new(x:Float = 0, y:Float = 0, weekName:String)
	{
		super(x, y);

		var box:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('options/BoxDeselected'));
		box.antialiasing = ClientPrefs.globalAntialiasing;
		box.scale.set(0.9, 0.9);
		add(box);

		selection = new FlxSprite(0, 0).loadGraphic(Paths.image('options/BoxSelect'));
		selection.antialiasing = ClientPrefs.globalAntialiasing;
		selection.scale.set(0.9, 0.9);
		add(selection);

		var weekText:FlxText = new FlxText(16, 40, 593, weekName);
		weekText.setFormat(Paths.font("Krungthep.ttf"), 38, FlxColor.WHITE, FlxTextAlign.CENTER);
		weekText.setBorderStyle(OUTLINE, 0xFF220B2B, 3.5, 1);
		weekText.antialiasing = ClientPrefs.globalAntialiasing;
		weekText.updateHitbox();
		add(weekText);
	}

	public function isSelected(what:Bool = false)
		selection.visible = what;
}