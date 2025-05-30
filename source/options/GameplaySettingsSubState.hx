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

class GameplaySettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = Language.option.get('gameplay_menu', 'Gameplay');
		rpcTitle = 'Gameplay Settings Menu'; //for Discord Rich Presence

		// TODO: can we port over the controller code from psych experimental
		var option:Option = new Option('Controller Mode',
			'Check this if you want to play with\na controller instead of using your Keyboard.',
			'controllerMode',
			'bool',
			false);
		addOption(option);

		#if SONG_ROLLBACK
		var option:Option = new Option('Song Rollback',
			'Rolls back time if the game stalls for over 1/10 of a second.\nFixes events breaking if you resize/move the window.\n\nDisable if you have major performance issues invoking this.',
			'songRollback',
			'bool',
			false);
		addOption(option);
		#end

		//I'd suggest using "Downscroll" as an example for making your own option since it is the simplest here
		var option:Option = new Option('Downscroll', //Name
			'If checked, notes go Down instead of Up, simple enough.', //Description
			'downScroll', //Save data variable name
			'bool', //Variable type
			false); //Default value
		addOption(option);

		var option:Option = new Option('Middlescroll',
			'If checked, your notes get centered.',
			'middleScroll',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Opponent Notes',
			'If unchecked, opponent notes get hidden during gameplay.',
			'opponentStrums',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Ghost Tapping',
			"If checked, you won't get misses from pressing keys\nwhile there are no notes able to be hit.",
			'ghostTapping',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option("Auto Pause",
			"If checked, the game automatically pauses if the screen isn't on focus.",
			'autoPause',
			'bool',
			false);
		addOption(option);
		option.onChange = onChangeAutoPause;

		var option:Option = new Option('Results Screen',
			"If checked, a results screen appears at the end\nof a week and every song in Freeplay.",
			'scoreScreen',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Disable Reset Button',
			"If checked, pressing Reset won't do anything.",
			'noReset',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Hitsound Volume',
			'Funny notes does \"Tick!\" when you hit them.',
			'hitsoundVolume',
			'percent',
			0);
		addOption(option);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		option.onChange = onChangeHitsoundVolume;

		var option:Option = new Option('Rating Offset',
			'Changes how late/early you have to hit for a "Sick!"\nHigher values mean you have to hit later.',
			'ratingOffset',
			'float',
			0);
		option.displayFormat = '%vms';
		option.scrollSpeed = 20;
		option.minValue = -30;
		option.maxValue = 30;
		option.changeValue = 0.1;
		addOption(option);

		var option:Option = new Option('Marvelous!! Hit Window',
			'Changes the amount of time you have\nfor hitting a "Marvelous!!" in milliseconds.',
			'marvelousWindow',
			'float',
			16);
		option.displayFormat = '%vms';
		option.scrollSpeed = 15;
		option.minValue = 0;
		option.maxValue = 166.6;
		option.changeValue = 0.1;
		addOption(option);

		var option:Option = new Option('Sick! Hit Window',
			'Changes the amount of time you have\nfor hitting a "Sick!" in milliseconds.',
			'sickWindow',
			'float',
			47);
		option.displayFormat = '%vms';
		option.scrollSpeed = 15;
		option.minValue = 0;
		option.maxValue = 166.6;
		option.changeValue = 0.1;
		addOption(option);

		var option:Option = new Option('Good Hit Window',
			'Changes the amount of time you have\nfor hitting a "Good" in milliseconds.',
			'goodWindow',
			'float',
			79);
		option.displayFormat = '%vms';
		option.scrollSpeed = 15;
		option.minValue = 0;
		option.maxValue = 166.6;
		option.changeValue = 0.1;
		addOption(option);

		var option:Option = new Option('Bad Hit Window',
			'Changes the amount of time you have\nfor hitting a "Bad" in milliseconds.',
			'badWindow',
			'float',
			109);
		option.displayFormat = '%vms';
		option.scrollSpeed = 15;
		option.minValue = 0;
		option.maxValue = 166.6;
		option.changeValue = 0.1;
		addOption(option);

		var option:Option = new Option('Shit Hit Window',
			'Changes the amount of time you have\nfor hitting a "Shit" in milliseconds.',
			'shitWindow',
			'float',
			133);
		option.displayFormat = '%vms';
		option.scrollSpeed = 15;
		option.minValue = 0;
		option.maxValue = 166.6;
		option.changeValue = 0.1;
		addOption(option);

		/*
		var option:Option = new Option('Safe Frames',
			'Changes how many frames you have for\nhitting a note earlier or late.',
			'safeFrames',
			'float',
			10);
		option.scrollSpeed = 5;
		option.minValue = 2;
		option.maxValue = 10;
		option.changeValue = 0.1;
		addOption(option);
		*/

		super();
	}

	function onChangeAutoPause()
	{
		FlxG.autoPause = ClientPrefs.autoPause;
	}

	function onChangeHitsoundVolume()
	{
		FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.hitsoundVolume);
	}
}