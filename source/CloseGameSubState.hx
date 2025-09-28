package;

import Language.LanguageText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class CloseGameSubState extends MusicBeatSubstate
{
	var curSelected:Int = 1;
	var selectGrp:FlxTypedGroup<LanguageText> = new FlxTypedGroup<LanguageText>();
	var startingFrame:Bool = true;

	public function new()
	{
		super();

		var background:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		background.alpha = 0.5;
		add(background);

		var box:FlxSprite = new FlxSprite().loadGraphic(Paths.image('popup_blank'));
		box.antialiasing = ClientPrefs.globalAntialiasing;
		box.updateHitbox();
		box.screenCenter();
		add(box);

		var text:LanguageText = new LanguageText(0, box.y + 76, box.frameWidth * 0.95, Language.flavor.get('close_game', "Are you sure you want to close the game?"), 32, 'krungthep');
		text.setStyle(FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		text.borderSize = 2;
		text.screenCenter(X);
		add(text);

		var textYes:LanguageText = new LanguageText(box.x + (box.width * 0.18), box.y + (box.height * 0.65), 0, Language.flavor.get('setting-yes', "Yes"), 48, 'krungthep');
		textYes.setStyle(FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		textYes.borderSize = 4;
		textYes.alpha = 0.5;
		textYes.ID = 0;

		var textNo:LanguageText = new LanguageText(box.x + (box.width * 0.7), box.y + (box.height * 0.65), 0, Language.flavor.get('setting-no', "No"), 48, 'krungthep');
		textNo.setStyle(FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		textNo.borderSize = 4;
		textNo.ID = 1;

		selectGrp.add(textYes);
		selectGrp.add(textNo);
		add(selectGrp);

		changeItem();
	}

	override function update(elapsed:Float):Void
	{
		if (startingFrame)
		{
			startingFrame = false;
			return;
		}

		super.update(elapsed);

		if (controls.BACK)
			selectItem();

		if (controls.UI_LEFT_P)
			changeItem(-1);
		if (controls.UI_RIGHT_P)
			changeItem(1);

		if (controls.ACCEPT)
			selectItem(curSelected);
	}

	function changeItem(huh:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'));

		curSelected += huh;

		if (curSelected >= selectGrp.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = selectGrp.length - 1;

		selectGrp.forEach(function(txt:FlxText)
		{
			if (txt.ID == curSelected)
				txt.alpha = 1;
			else
				txt.alpha = 0.5;
		});
	}

	function selectItem(selection:Int = 1):Void
	{
		if (selection == 0)
		{
			Sys.exit(0);
		}
		else
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			TitleState.inSubState = false;
			close();
		}
	}
}
