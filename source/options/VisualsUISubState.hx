package options;

#if discord_rpc
import Discord.DiscordClient;
#end
import Controls;
import NoteSkin;
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

class VisualsUISubState extends BaseOptionsMenu
{
	var noteOptionID:Int = -1;
	var notes:FlxTypedGroup<StrumNote>;
	var notesTween:Array<FlxTween> = [];
	var noteY:Float = 90;
	var noteSkinData:Array<NoteArray> = [];

	public function new()
	{
		title = 'Visuals and UI';
		rpcTitle = 'Visuals & UI Settings Menu'; //for Discord Rich Presence

		// for note skins
		notes = new FlxTypedGroup<StrumNote>();
		for (i in 0...Note.colArray.length)
		{
			var note:StrumNote = new StrumNote(370 + (560 / Note.colArray.length) * i, -200, i, 0);
			note.centerOffsets();
			note.centerOrigin();
			note.playAnim('static');
			notes.add(note);
		}

		//awesome...
		CoolUtil.difficulties = ["Normal"];
		var noteSkins:Array<String> = [];

		for (skinName in NoteSkin.noteSkinNames)
		{
			var skin:NoteArray = NoteSkin.noteSkins.get(skinName);

			var isBeaten:Bool = skin.songReq == '' || skin.songReq != '' && Highscore.checkBeaten(skin.songReq, 0);

			#if FORCE_DEBUG_VERSION
			if (!isBeaten) FlxG.log.warn('[UI] ${skinName} note skin is normally locked, but forcing unlocked due to debug.');
			isBeaten = true;
			#end

			if (isBeaten) noteSkins.push(skinName);
		}

		var option:Option = new Option('Note Skins:',
				"Select your prefered Note skin.",
				'noteSkin',
				'string',
				'Default',
				noteSkins);
		addOption(option);
		option.onChange = onChangeNoteSkin;
		noteOptionID = optionsArray.length - 1;

		var option:Option = new Option('Note Splashes',
			"If unchecked, hitting \"Sick!\" notes won't show particles.",
			'noteSplashes',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Hide HUD',
			'If checked, hides most HUD elements.',
			'hideHud',
			'bool',
			false);
		addOption(option);

		/*
		var option:Option = new Option('Time Bar:',
			"What should the Time Bar display?",
			'timeBarType',
			'string',
			'Combined',
			['Time Left', 'Time Elapsed', 'Song Name', 'Combined', 'Disabled']);
		addOption(option);
		*/

		var option:Option = new Option('Flashing Lights',
			"Uncheck this if you're sensitive to flashing lights!",
			'flashing',
			'bool',
			true);
		addOption(option);

		/*
		var option:Option = new Option('Score Text Zoom on Hit',
			"If unchecked, disables the Score text zooming\neverytime you hit a note.",
			'scoreZoom',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Health Bar Transparency',
			'How much transparent should the health bar and icons be.',
			'healthBarAlpha',
			'percent',
			1);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);
		*/

		var option:Option = new Option('Lane Transparency:',
			'How much transparent should the note lanes be.',
			'laneAlpha',
			'percent',
			0);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);

		var option:Option = new Option('Dynamic Lane Transparency',
			"If checked, song events can control lane opacity for songs\nOnly works if Lane Transparency is set to 0.",
			'dynamicLaneOpacity',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Combo Stacking',
			"If unchecked, Ratings and Combo won't stack, saving on System Memory and making them easier to read.",
			'comboStacking',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Timing Indicator:',
			"Shows the timing of the note that was hit.\nSimple: Displays either EARLY or LATE if not Marvelous\nPrecise: Displays note hit timing in milliseconds",
			'timingIndicator',
			'string',
			'Precise',
			['None', 'Simple', 'Precise']);
		addOption(option);

		/*
		var option:Option = new Option('NPS Display',
			"Shows your current Notes Per Second on the info bar.",
			'displayNPS',
			'bool',
			true);
		addOption(option);

		// do we really need this? i mean ui lua scripts exists.
		var option:Option = new Option('Judgement Counter',
			"Show your judgements that you've gotten in the song.",
			'judgementCounter',
			'bool',
			true);
		addOption(option);
		*/

		#if !mobile
		var option:Option = new Option('FPS Counter',
			'If unchecked, hides the FPS Counter.',
			'showFPS',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Memory Counter',
			'If unchecked, hides the Memory Counter.',
			'showMemory',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Peak Counter',
			'If unchecked, hides the Peak Counter.',
			'showPeak',
			'bool',
			true);
		addOption(option);

		/*
		var option:Option = new Option('Counter Border',
			'If unchecked, disables the Counter Border, increases performance at the cost of readability.',
			'fpsBorder',
			'bool',
			false);
		addOption(option);		
		*/
		#end

		var option:Option = new Option('Watermarks',
			'Enable and disable all watermarks from the engine.',
			'watermarks',
			'bool',
			false);
		addOption(option);
		
		var option:Option = new Option('Mouse Navigation',
			'Check this if you want to add\nthe ability to navigate Menus with your Mouse.',
			'menuMouse',
			'bool',
			false);
		addOption(option);

		super();
		add(notes);
		onChangeNoteSkin(); //So it shows up when entering the menu
	}

	override function changeSelection(change:Int = 0)
	{
		super.changeSelection(change);
		
		if(noteOptionID < 0) return;

		for (i in 0...Note.colArray.length)
		{
			var note:StrumNote = notes.members[i];
			if(notesTween[i] != null) notesTween[i].cancel();
			if(curSelected == noteOptionID)
				notesTween[i] = FlxTween.tween(note, {y: noteY}, Math.abs(note.y / (200 + noteY)) / 3, {ease: FlxEase.quadInOut});
			else
				notesTween[i] = FlxTween.tween(note, {y: -200}, Math.abs(note.y / (200 + noteY)) / 3, {ease: FlxEase.quadInOut});
		}
	}

	function onChangeNoteSkin()
	{
		notes.forEachAlive(function(note:StrumNote) {
			changeNoteSkin(note);
			note.centerOffsets();
			note.centerOrigin();
		});
	}

	function changeNoteSkin(note:StrumNote)
	{
		var skin:String = "NOTE_assets";
		var customSkin:String = NoteSkin.noteSkins.get(ClientPrefs.noteSkin).note;

		if (customSkin != null && customSkin != '')
			skin = customSkin;
		
		note.color = customSkin != '' ? 0xFFFFFFFF : 0xFF4B4B4B;

		note.texture = skin; //Load texture and anims
		note.reloadNote();
		note.playAnim('static');
	}
}
