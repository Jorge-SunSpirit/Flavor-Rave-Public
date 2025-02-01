package;

import cpp.Int16;
#if discord_rpc
import Discord.DiscordClient;
#end
import editors.MasterEditorMenu;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxSpriteGroup;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.addons.text.FlxTypeText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.utils.Assets;
import haxe.Json;
import shaders.TwoToneMask;
import flixel.sound.FlxSound;

using StringTools;

#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end

typedef ThaiDialogueFile = {
	var dialogue:Array<DialogueArray>;
	var allowEscape:Null<Bool>;
}

typedef DialogueArray = {
	var tvArt:Null<String>; // Leave blank to not change!
	var chara:Null<String>; // synthetic or sundried (Blank or Null will default to Sundried)
	var animation:Null<String>; // what animation the dickhead plays
	var text:Null<String>;
	var bgm:Null<String>;//BGM
	var sound:Null<String>;//sound
	var command:Null<String>;//Command (Jorge sorry that this is only impl in FirstState)

	var allowExit:Null<Bool>; //Only will be used in the main choicer
	var choices:Array<ChoicerArray>;//All of the choices (Will force change the dialogue) 
}

typedef ChoicerArray = {
	var text:Null<String>;
	var jsonreDirect:Null<String>; //Opens another Json after selecting an option
	var songCheck:Null<String>;
}

class SunSynthState extends MusicBeatState
{
	var dialogueData:ThaiDialogueFile;
	var currentJson:String = 'base';

	public static var curSelected:Int = 0;
	public var allowInput:Bool = true;
	var inBaseChoicer:Bool = true;
	public static var initPortrait:String = '';

	var colorTween1:FlxSprite = new FlxSprite(-9000, -9000).makeGraphic(1, 1, 0xFF1ABBD4);
	var colorTween2:FlxSprite = new FlxSprite(-9000, -9000).makeGraphic(1, 1, 0xFF1B7AB1);
	var colorShader:TwoToneMask = new TwoToneMask(MainMenuState.initChecker[2], MainMenuState.initChecker[3]);

	var menuArt:FlxSprite;
	var sun:FlxSprite;
	var syn:FlxSprite;
	var dialogueBox:FlxSprite;
	var backdrop:FlxBackdrop;
	var liveIcon:FlxSprite;
	var dialogueVoice:FlxSound;
	var brb:FlxSprite;
	var modiOpti:FlxSprite;
	
	var letmeout:Bool = true;
	var allowEscape:Bool = false;
	var dialogueText:FlxTypeText;
	var currentDialogue:Int = 0;
	public var finishThing:Void->Void = null;
	public var nextDialogueThing:Void->Void = null;
	public var skipDialogueThing:Void->Void = null;

	var choicerStuff:FlxTypedGroup<SSMenuItem>;

	public static var instance:SunSynthState;

	override function create()
	{
		FlxG.mouse.visible = ClientPrefs.menuMouse;
		CoolUtil.difficulties = ["Normal"];
		Paths.currentModDirectory = "";
		instance = this;

		#if discord_rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Watching the SynSun Stream", null);
		#end

		FlxG.sound.music.fadeOut(1, 0.18);
		for (vocal in FreeplayState.vocalTracks)
		{
			if (vocal != null)
			{
				vocal.fadeOut(1, 0.18);
			}
		}

		backdrop = new FlxBackdrop(Paths.image('mainmenu/checkerboard'));
		backdrop.setPosition(MainMenuState.initChecker[0], MainMenuState.initChecker[1]);
		backdrop.velocity.set(-40, -40);
		backdrop.antialiasing = false;
		backdrop.shader = colorShader.shader;
		add(backdrop);
		colorTween1.color = MainMenuState.initChecker[2];
		colorTween2.color = MainMenuState.initChecker[3];

		menuArt = new FlxSprite(375,-56).loadGraphic(Paths.image('mainmenu/art/$initPortrait'));
		menuArt.antialiasing = ClientPrefs.globalAntialiasing;
		add(menuArt);

		var scan:FlxSprite = new FlxSprite().loadGraphic(Paths.image('mainmenu/scanlines'));
		scan.screenCenter();
		scan.antialiasing = ClientPrefs.globalAntialiasing;
		add(scan);

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('mainmenu/BG'));
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		
		var deskbg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('mainmenu/desk'));
		deskbg.screenCenter();
		deskbg.antialiasing = ClientPrefs.globalAntialiasing;
		add(deskbg);

		liveIcon = new FlxSprite(10,10).loadGraphic(Paths.image('mainmenu/SynSun/live'));
		liveIcon.antialiasing = ClientPrefs.globalAntialiasing;
		liveIcon.alpha = MainMenuState.initChecker[4];
		add(liveIcon);
		laziestTweenLoop(true);

		sun = new FlxSprite(730,-4);
		sun.frames = Paths.getSparrowAtlas('mainmenu/SynSun/Sundried');//curSong
		sun.animation.addByIndices("idle", "SD All in One", [0], "", 24, true);
		sun.animation.addByIndices("greeting", "SD All in One", CoolUtil.numberArray(36, 1), "", 24, false);
		sun.animation.addByIndices("think", "SD All in One", CoolUtil.numberArray(55, 37), "", 24, false);
		sun.animation.addByIndices("exhale", "SD All in One", CoolUtil.numberArray(74, 56), "", 24, false);
		sun.animation.addByIndices("excited", "SD All in One", CoolUtil.numberArray(93, 75), "", 24, false);
		sun.animation.addByIndices("determined", "SD All in One", CoolUtil.numberArray(112, 94), "", 24, false);
		sun.animation.addByIndices("nervous", "SD All in One", CoolUtil.numberArray(131, 113), "", 24, false);
		sun.animation.addByIndices("blush", "SD All in One", CoolUtil.numberArray(150, 132), "", 24, false);
		sun.animation.addByIndices("sad", "SD All in One", CoolUtil.numberArray(169, 151), "", 24, false);
		sun.animation.addByIndices("happy", "SD All in One", CoolUtil.numberArray(188, 170), "", 24, false);
		sun.animation.addByIndices("laugh", "SD All in One", CoolUtil.numberArray(207, 189), "", 24, false);
		sun.animation.addByIndices("phone", "SD All in One", CoolUtil.numberArray(283, 208), "", 24, true);
		sun.animation.addByIndices("reset", "SD All in One", CoolUtil.numberArray(36, 30), "", 24, false);
		sun.antialiasing = ClientPrefs.globalAntialiasing;
		add(sun);

		syn = new FlxSprite(720,133);
		syn.frames = Paths.getSparrowAtlas('mainmenu/SynSun/Synthetic');//curSong
		syn.animation.addByIndices('idle', 'Syn All in One', [0], "", 24, true);
		syn.animation.addByIndices('greeting', 'Syn All in One', CoolUtil.numberArray(56, 0), "", 24, false);
		syn.animation.addByIndices('happy', 'Syn All in One', CoolUtil.numberArray(30, 0), "", 24, false);
		syn.animation.addByIndices('idle_rand', 'Syn All in One', CoolUtil.numberArray(178, 57), "", 24, false);
		syn.animation.addByIndices('alert', 'Syn All in One', CoolUtil.numberArray(202, 179), "", 24, false);
		syn.animation.addByIndices('upset', 'Syn All in One', CoolUtil.numberArray(231, 203), "", 24, false);
		syn.animation.addByIndices('quiet', 'Syn All in One', CoolUtil.numberArray(269, 232), "", 24, false);
		syn.animation.addByIndices('confused', 'Syn All in One', CoolUtil.numberArray(293, 270), "", 24, false);
		syn.animation.addByIndices('hueh', 'Syn All in One', CoolUtil.numberArray(316, 294), "", 24, false);
		syn.animation.addByIndices('p03', 'Syn All in One', CoolUtil.numberArray(339, 317), "", 24, false);
		syn.animation.addByIndices('sad', 'Syn All in One', CoolUtil.numberArray(359, 340), "", 24, false);
		syn.animation.addByIndices('search', 'Syn All in One', CoolUtil.numberArray(379, 360), "", 24, false);
		syn.animation.addByIndices('Bored', 'Syn All in One', CoolUtil.numberArray(423, 380), "", 24, true);
		syn.animation.addByIndices('reset', 'Syn All in One', CoolUtil.numberArray(56, 33), "", 24, false);
		syn.antialiasing = ClientPrefs.globalAntialiasing;
		add(syn);
		
		choicerStuff = new FlxTypedGroup<SSMenuItem>();
		add(choicerStuff);

		dialogueBox = new FlxSprite().loadGraphic(Paths.image('mainmenu/SynSun/sunbox'));
		dialogueBox.screenCenter();
		dialogueBox.antialiasing = ClientPrefs.globalAntialiasing;
		dialogueBox.alpha = 0.001;
		add(dialogueBox);

		dialogueText = new FlxTypeText(474, 548, 768, "", 24);
		dialogueText.font = Paths.font("Krungthep.ttf");
		dialogueText.setBorderStyle(OUTLINE, FlxColor.BLACK);
		dialogueText.borderSize = 2;
		dialogueText.delay = 0.01;
		dialogueText.antialiasing = ClientPrefs.globalAntialiasing;
		add(dialogueText);

		modiOpti = new FlxSprite(0, 687).loadGraphic(Paths.image('dreamcast/buttons2', 'tbd'));
		modiOpti.antialiasing = ClientPrefs.globalAntialiasing;
		modiOpti.alpha = 0.001;
		add(modiOpti);

		brb = new FlxSprite().loadGraphic(Paths.image('gallery/images/synsunbrb'));
		brb.screenCenter();
		brb.antialiasing = ClientPrefs.globalAntialiasing;
		brb.alpha = 0.001;
		add(brb);

		FlxTween.color(colorTween1, 1, colorShader.color1, 0xFF1ABBD4);
		FlxTween.color(colorTween2, 1, colorShader.color2, 0xFF1B7AB1);

		new FlxTimer().start(0.2, function(tmr:FlxTimer)
		{
			allowInput = true;
			loadDialogueJSon('base');
		});

		super.create();
	}


	override function update(elapsed:Float)
	{
		super.update(elapsed);

		colorShader.color1 = colorTween1.color;
		colorShader.color2 = colorTween2.color;

		if (allowInput)
		{
			if (choicerStuff.length >= 2)
			{
				if (controls.ACCEPT)
				{
					selectItem();
				}
				else if (controls.UI_UP_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(-1);
				}
				else if (controls.UI_DOWN_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(1);
				}
				else if (controls.BACK && letmeout)
				{
					if (!inBaseChoicer)
					{
						FlxG.sound.play(Paths.sound('cancelMenu'));
						killChoicer();
						backToMainChoicer();
					}
					else
					{
						allowInput = false;
						FlxTransitionableState.skipNextTransIn = true;
						FlxTransitionableState.skipNextTransOut = true;
						MainMenuState.initChecker = [backdrop.x, backdrop.y, colorTween1.color, colorTween2.color];
						FlxG.sound.play(Paths.sound('cancelMenu'));
						MusicBeatState.switchState(new MainMenuState());
					}
				}

				if(ClientPrefs.menuMouse)
				{
					if(FlxG.mouse.wheel != 0)
					{
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.5);
						// Mouse wheel logic goes here, for example zooming in / out:
						if (FlxG.mouse.wheel < 0)
							changeItem(1);
						else if (FlxG.mouse.wheel > 0)
							changeItem(-1);		
					}
	
					choicerStuff.forEach(function(spr:SSMenuItem)
					{
						if(FlxG.mouse.overlaps(spr))
						{
							if(FlxG.mouse.justPressed)
							{
								if (spr.ID != 0)
									changeItem(spr.ID);
								else
								{
									allowInput = false;
									selectItem();
								}
							}
						}
					});
				}
			}
			else 
			{
				if (controls.ACCEPT || ClientPrefs.menuMouse && FlxG.mouse.justPressed)
				{
					if (!dialogueEnded)
					{
						dialogueText.skip();
		
						if (skipDialogueThing != null)
							skipDialogueThing();
					}
					else
					{
						//FlxG.sound.play(Paths.sound('confirmMenu'));
						if (dialogueData.dialogue[currentDialogue] != null)
							startDialogue();
						else
							backToMainChoicer();
					}
				}
			}

			if (controls.BACK && !letmeout && allowEscape)
			{
				backToMainChoicer();
			}
		}
	}

	var dialogueEnded:Bool = false;

	function startDialogue():Void
	{
		var curDialogue:DialogueArray = null;
		do
		{
			curDialogue = dialogueData.dialogue[currentDialogue];
		}
		while (curDialogue == null);

		if (curDialogue.tvArt == null || curDialogue.tvArt.length < 1)
			curDialogue.tvArt = '';
		if (curDialogue.chara == null || curDialogue.chara.length < 1)
			curDialogue.chara = 'sun';
		if (curDialogue.animation == null || curDialogue.animation.length < 1)
			curDialogue.animation = '';
		if (curDialogue.text == null || curDialogue.text.length < 1)
			curDialogue.text = '';
		if (curDialogue.sound == null || curDialogue.sound.length < 1)
			curDialogue.sound = '';
		if (curDialogue.bgm == null || curDialogue.bgm.length < 1)
			curDialogue.bgm = '';
		if (curDialogue.command == null || curDialogue.command.length < 1)
			curDialogue.command = '';
		if (curDialogue.allowExit == null)
			letmeout = false;
		if (curDialogue.choices == null || curDialogue.choices.length < 2)
			curDialogue.choices = null;

		killVoice();
		currentDialogue++;

		if (curDialogue.command == '' || curDialogue.command == 'autoSkip')
		{
			allowInput = curDialogue.command == 'autoSkip' ? false : true;
			var character:FlxSprite = syn;
			letmeout = curDialogue.allowExit;

			switch (curDialogue.chara)
			{
				case 'synthetic' | 'synth' | 'syn':
					character = syn;
					curDialogue.chara = 'syn';
					dialogueBox.loadGraphic(Paths.image('mainmenu/SynSun/synbox'));
				case 'sundried' | 'sun' | 'dried':
					curDialogue.chara = 'sun';
					character = sun;
					dialogueBox.loadGraphic(Paths.image('mainmenu/SynSun/sunbox'));
			}

			if (curDialogue.animation != '')
				character.animation.play(curDialogue.animation);

			if (curDialogue.sound != '' && Paths.fileExists('sounds/sunsynth/dialogue/${curDialogue.chara}/${curDialogue.sound}.ogg', SOUND))
				dialogueVoice = new FlxSound().loadEmbedded(Paths.sound('sunsynth/dialogue/${curDialogue.chara}/${curDialogue.sound}'));
			else
				dialogueVoice = new FlxSound();

			dialogueVoice.play();

			if (curDialogue.tvArt != '')
				menuArt.loadGraphic(Paths.image('mainmenu/SynSun/tv/${curDialogue.tvArt}'));

			if (curDialogue.bgm != '')
			{
				switch (curDialogue.bgm)
				{
					default:
						FlxG.sound.playMusic(Paths.music(curDialogue.bgm), 0);
						ClientPrefs.mainmenuMusic = curDialogue.bgm;
						ClientPrefs.saveSettings();
						for (vocal in FreeplayState.vocalTracks)
						{
							if (vocal != null)
							{
								vocal.stop();
							}
						}
						FlxG.sound.music.fadeIn(1, 0, 0.18);
					case 'stop':
						FlxG.sound.music.fadeOut(1, 0);
					case 'resume':
						FlxG.sound.music.fadeIn(1, 0, 0.18);
				}
			}

			if (curDialogue.text != '')
			{
				dialogueText.resetText(curDialogue.text);
				dialogueText.start(0.04, true);
				dialogueText.completeCallback = function()
				{
					if (curDialogue.command == 'autoSkip')
						endDialogue();
					else
						dialogueEnded = true;
				};
			}
			else
				endDialogue();
			
			if (curDialogue.choices != null && curDialogue.choices.length >= 2)
			{
				createChoicer(curDialogue.choices);
				changeItem();
			}
		}
		else
		{
			allowInput = false;

			dialogueEnded = true;
			dialogueText.skip();

			switch (curDialogue.command.toLowerCase())
			{
				default:
				{
					// Invalid command, immediately end incase this is an older build playing newer commands so we don't softlock
					endDialogue();
				}
				case 'songstart':
				{
					PlayState.isStoryMode = true;
					PlayState.storyDifficulty = 0;
					for (i in 0...WeekData.weeksList.length)
					{
						var weekFile:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
						if (weekFile.fileName == 'xextra_0')
							PlayState.storyWeek = i;
					}
					openSubState(new CharaSelect('sunsyn', ['sundried', 'synthetic'], "xextra_0"));
				}
				case 'brb':
				{
					brb.alpha = 1;
					new FlxTimer().start(6, function(tmr:FlxTimer)
					{
						brb.alpha = 0.001;
						endDialogue();
					});
				}
			}
		}

		dialogueEnded = false; 

		if (nextDialogueThing != null)
			nextDialogueThing();
	}

	public function loadNoPressure()
	{
		PlayState.storyPlaylist = ['n0.pressur3.temp'];
		PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase(),PlayState.storyPlaylist[0].toLowerCase());
		PlayState.campaignScore = 0;
		PlayState.campaignSicks = 0;
		PlayState.campaignGoods = 0;
		PlayState.campaignShits = 0;
		PlayState.campaignMisses = 0;
		PlayState.campaignEarlys = 0;
		PlayState.campaignLates = 0;
		PlayState.restartScore = 0;
		PlayState.restartHits = 0;
		PlayState.restartMisses = 0;
		PlayState.restartAccuracy = 0.00;
		FreeplayState.destroyFreeplayVocals();
		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		LoadingState.loadAndSwitchState(new PlayState());
	}

	public function closeCharaSelect()
	{
		currentDialogue = 0;
		curSelected = 0;
		loadDialogueJSon('things-cancelsinging');
	}

	public function endDialogue():Void
	{
		if (dialogueData.dialogue[currentDialogue] != null)
			startDialogue();
		else
			backToMainChoicer();
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= choicerStuff.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = choicerStuff.length - 1;

		var bullShit:Int = 0;

		for (item in choicerStuff.members)
		{
			item.ID = bullShit - curSelected;
			bullShit++;

			FlxTween.cancelTweensOf(item);
			FlxTween.tween(item, {y: 294 + (item.ID * 92)}, 0.3, {ease: FlxEase.circOut});
			
			if (item.ID < 0 && item.ID != 0)
				FlxTween.tween(item, {x: 15 + (item.ID * 50),"scale.x":0.9 + (item.ID * 0.05), "scale.y":1 + (item.ID * 0.05)}, 0.3, {ease: FlxEase.circOut});
			if (item.ID > 0 && item.ID != 0)
				FlxTween.tween(item, {x: 15 - (item.ID * 50),"scale.x":0.9 - (item.ID * 0.05), "scale.y":1 - (item.ID * 0.05)}, 0.3, {ease: FlxEase.circOut});
			if (item.ID == 0)
				FlxTween.tween(item, {x: 15,"scale.x":1, "scale.y":1}, 0.3, {ease: FlxEase.circOut});


			item.highlighted((item.ID == 0 ? true : false));
		}
	}

	function loadDialogueJSon(json:String)
	{
		allowInput = false;
		var jsonPath:String = 'images/mainmenu/SynSun/dialogue/$json.json';
		var path:String = '';
		var tjson:ThaiDialogueFile;
		
		#if MODS_ALLOWED
			path = Paths.modFolders(jsonPath);
			if (!FileSystem.exists(path)) 
				path = Paths.getPreloadPath(jsonPath);
			if (!FileSystem.exists(path))
				path = Paths.getPreloadPath('images/mainmenu/SynSun/dialogue/base.json');

			tjson = cast Json.parse(File.getContent(path));
		#else
			path = Paths.getPreloadPath(jsonPath);
			if (!Assets.exists(path))
				path = Paths.getPreloadPath('images/mainmenu/SynSun/dialogue/base.json');

			tjson = cast Json.parse(Assets.getText(path)); 
		#end

		dialogueData = tjson;
		dialogueBox.alpha = 1;
		currentJson = json;
		if (dialogueData.allowEscape == null)
			tjson.allowEscape = true;

		

		if (dialogueData.allowEscape)
		{
			modiOpti.loadGraphic(Paths.image('dreamcast/buttons', 'tbd'));
			FlxTween.cancelTweensOf(modiOpti);
			FlxTween.tween(modiOpti, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		}
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			allowEscape = tjson.allowEscape;
		});
		startDialogue();
	}

	function killVoice():Void
	{
		if (dialogueVoice != null)
		{
			dialogueVoice.stop();
			dialogueVoice.destroy();
		}
	}
	

	function createChoicer(thechoicerArray:Array<ChoicerArray>)
	{
		allowInput = false;
		var thearray:Array<ChoicerArray> = [];

		for (choicer in thechoicerArray)
		{
			if (choicer.songCheck == null || choicer.songCheck == '' || choicer.songCheck != null && Highscore.checkBeaten(choicer.songCheck, 0))
				thearray.push(choicer);
		}

		if (currentJson == 'peoplebase' || currentJson == 'placesbase')
		{
			#if MODS_ALLOWED
			var curMJase:String = 'placesmodded';
			if (currentJson == 'peoplebase')
				curMJase = 'peoplemodded';

			var modsDirectories:Array<String> = Paths.getGlobalMods();
			for (folder in modsDirectories)
			{
				//This idea works and it's almost great. BUT 
				var modPath:String = Paths.modFolders('images/mainmenu/SynSun/dialogue/${curMJase}.json', folder);
				if (FileSystem.exists(modPath))
				{
					var json:ThaiDialogueFile = cast Json.parse(File.getContent(modPath));
					var choicerStuff:Array<ChoicerArray> = json.dialogue[0].choices;
					for (choicer in choicerStuff)
					{
						if (choicer.songCheck == null || choicer.songCheck == '' || choicer.songCheck != null && Highscore.checkBeaten(choicer.songCheck, 0))
							thearray.push(choicer);
					}
				}
			}
			#end
		}
		
		for (i in 0...thearray.length)
		{
			var thechoices:SSMenuItem = new SSMenuItem(15, 0 + (i * 98), thearray[i].text, thearray[i].jsonreDirect);
			thechoices.ID = i;
			choicerStuff.add(thechoices);
		}

		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			allowInput = true;
		});

		modiOpti.loadGraphic(Paths.image('dreamcast/buttons2', 'tbd'));
		FlxTween.cancelTweensOf(modiOpti);
		FlxTween.tween(modiOpti, {alpha: 1}, 0.4, {ease: FlxEase.circOut});
	}

	function killChoicer()
	{
		//Kills choicer
		for (i in 0...choicerStuff.members.length) {
			var obj = choicerStuff.members[0];
			obj.kill();
			choicerStuff.remove(obj, true);
			obj.destroy();
		}
	}

	function selectItem()
	{
		allowInput = false;
		var theJsonFile:String = '';
		inBaseChoicer = false;
		for (item in choicerStuff.members)
		{
			if (item.ID == 0)
				theJsonFile = item.json;
		}
		FlxTween.tween(modiOpti, {alpha: 0.001}, 0.5, {ease: FlxEase.circOut});
		killChoicer();

		currentDialogue = 0;
		curSelected = 0;
		new FlxTimer().start(0.2, function(tmr:FlxTimer)
		{
			allowInput = true;
			loadDialogueJSon(theJsonFile);
		});

		FlxG.sound.play(Paths.sound('confirmMenu'));
	}

	function backToMainChoicer()
	{
		allowEscape = false;
		inBaseChoicer = true;
		currentDialogue = 0;
		curSelected = 0;
		loadDialogueJSon('base');
	}

	function laziestTweenLoop(bool:Bool)
	{
		FlxTween.cancelTweensOf(liveIcon);
		FlxTween.tween(liveIcon, {alpha: (bool ? 1 : 0)}, 0.7, {ease: FlxEase.linear, startDelay: 1,
			onComplete: function(flxTween:FlxTween)
			{
				laziestTweenLoop(!bool);
			}});
	}
}

class SSMenuItem extends FlxSpriteGroup
{
	var bg:FlxSprite;
	var text:FlxText;

	public var json:String;

	public function new(x:Float = 0, y:Float = 0, item:String, hson:String)
	{
		super(x, y);
		json = hson;

		bg = new FlxSprite();
		bg.frames = Paths.getSparrowAtlas('freeplay/button');//curSong
		bg.animation.addByPrefix('highlighted', 'button_selected', 24, false);
		bg.animation.addByPrefix('idle', 'button_deselected', 24, false);
		bg.animation.play('idle');
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		text = new FlxText(38, 20, 604, item, 40);
		text.setFormat(Paths.font("Krungthep.ttf"), 40, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		text.antialiasing = ClientPrefs.globalAntialiasing;
		text.borderSize = 4;
		add(text);
	}

	public function highlighted(bool:Bool)
	{
		if (bool)
			bg.animation.play('highlighted');
		else
			bg.animation.play('idle');
	}
}