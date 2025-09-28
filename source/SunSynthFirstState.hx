package;

import Language.LanguageTypeText;
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
import SunSynthState.ThaiDialogueFile;
import SunSynthState.DialogueArray;
import MainMenuState.MMenuItem;

//Listen, look. It looks and sounds stupid that this code is here. BUT This is so when we want to call it in lua it actually exists.
import shaders.DropShadowShader;
import shaders.DifferenceShader;
import shaders.InvertMask;
import VisualizerBar;

using StringTools;

#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end

class SunSynthFirstState extends MusicBeatState
{
	var dialogueData:ThaiDialogueFile;
	var currentJson:String = 'base';

	public static var curSelected:Int = 0;
	var allowInput:Bool = true;
	var inBaseChoicer:Bool = true;

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
	var blackScreen:FlxSprite;
	var sidebar:FlxSprite;
	var transBlack:FlxSprite;
	var menuItems:FlxTypedGroup<MMenuItem>;
	var optionShit:Array<String> = ['story','freeplay','fp','gallery','options','credits'];

	var dialogueText:LanguageTypeText;
	var currentDialogue:Int = 0;
	public var finishThing:Void->Void = null;
	public var nextDialogueThing:Void->Void = null;
	public var skipDialogueThing:Void->Void = null;

	override function create()
	{
		#if discord_rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		FlxG.sound.playMusic(Paths.music(ClientPrefs.mainmenuMusic), 0); //Entering this menu with no music playing will crash

		//If for whatever reason the game crashes it saves as soon as you enter the menu
		ClientPrefs.pastOGWeek = true;
		ClientPrefs.saveSettings();

		backdrop = new FlxBackdrop(Paths.image('mainmenu/checkerboard'));
		backdrop.setPosition(MainMenuState.initChecker[0], MainMenuState.initChecker[1]);
		backdrop.velocity.set(-40, -40);
		backdrop.antialiasing = false;
		backdrop.shader = colorShader.shader;
		add(backdrop);
		colorTween1.color = MainMenuState.initChecker[2];
		colorTween2.color = MainMenuState.initChecker[3];
		MainMenuState.fromSpecificState = 1;

		menuArt = new FlxSprite(375,-56).loadGraphic(Paths.image('mainmenu/SynSun/tv/synsun'));
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

		sidebar = new FlxSprite(-774).loadGraphic(Paths.image('mainmenu/sidebar'));
		sidebar.antialiasing = ClientPrefs.globalAntialiasing;
		add(sidebar);

		menuItems = new FlxTypedGroup<MMenuItem>();
		add(menuItems);
		
		for (i in 0...optionShit.length)
		{
			var menuObject:MMenuItem = new MMenuItem(-452, 12 + (i * 115), optionShit[i]);
			menuObject.ID = i;
			menuItems.add(menuObject);
		}

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(blackScreen);

		dialogueBox = new FlxSprite().loadGraphic(Paths.image('mainmenu/SynSun/sunbox'));
		dialogueBox.screenCenter();
		dialogueBox.antialiasing = ClientPrefs.globalAntialiasing;
		dialogueBox.alpha = 0.001;
		add(dialogueBox);

		dialogueText = new LanguageTypeText(474, 548, 768, "", 24, 'krungthep');
		dialogueText.setBorderStyle(OUTLINE, FlxColor.BLACK);
		dialogueText.borderSize = 2;
		dialogueText.delay = 0.01;
		add(dialogueText);

		transBlack = new FlxSprite();
		transBlack.frames = Paths.getSparrowAtlas('sunsynTrans', 'preload');
		transBlack.animation.addByPrefix('transin', 'transIN', 30, false);
		transBlack.animation.addByPrefix('transout', 'transOUT', 30, false);
		transBlack.antialiasing = ClientPrefs.globalAntialiasing;
		transBlack.alpha = 0.0001;
		add(transBlack);

		FlxTween.color(colorTween1, 1, colorShader.color1, 0xFF1ABBD4);
		FlxTween.color(colorTween2, 1, colorShader.color2, 0xFF1B7AB1);

		new FlxTimer().start(0.2, function(tmr:FlxTimer)
		{
			allowInput = true;
			loadDialogueJSon('introduction');
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
			if (controls.ACCEPT)
			{
				if (!dialogueEnded)
				{
					dialogueText.skip();

					if (skipDialogueThing != null)
						skipDialogueThing();
				}
				else
				{
					endDialogue();
				}
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
			curDialogue.chara = '';
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

		killVoice();
		currentDialogue++;

		if (curDialogue.command == '')
		{
			allowInput = true;

			var character:FlxSprite = syn;
	
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
				case 'sunb':
					curDialogue.chara = 'sun';
					dialogueBox.loadGraphic(Paths.image('mainmenu/SynSun/blank'));
				case 'synb':
					curDialogue.chara = 'syn';
					dialogueBox.loadGraphic(Paths.image('mainmenu/SynSun/blank'));
				default:
					dialogueBox.loadGraphic(Paths.image('mainmenu/SynSun/blank'));
			}
			
			if (curDialogue.animation != '')
				character.animation.play(curDialogue.animation);
	
			dialogueText.resetText(curDialogue.text);
			dialogueText.start(0.04, true);
			dialogueText.completeCallback = function()
			{
				dialogueEnded = true;
			};
	
			if (curDialogue.sound != '' && Paths.fileExists('sounds/sunsynth/dialogue/${curDialogue.chara}/${curDialogue.sound}.ogg', SOUND))
				dialogueVoice = new FlxSound().loadEmbedded(Paths.sound('sunsynth/dialogue/${curDialogue.chara}/${curDialogue.sound}'));
			else
				dialogueVoice = new FlxSound();
	
			dialogueVoice.play();
	
			if (curDialogue.tvArt != '')
				menuArt.loadGraphic(Paths.image('mainmenu/SynSun/tv/${curDialogue.tvArt}'));
	
			if (curDialogue.bgm != '')
			{
				FlxG.sound.music.stop();
				FlxG.sound.playMusic(Paths.music(curDialogue.bgm), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.18);
			}
	
			dialogueEnded = false;
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
				case 'transition':
				{
					transAnimation();
					laziestTweenLoop(true);
				}
				case 'menuoption':
				{
					summonStuff();
				}
			}
		}

		if (nextDialogueThing != null)
			nextDialogueThing();
	}

	function endDialogue():Void
	{
		if (dialogueData.dialogue[currentDialogue] != null)
			startDialogue();
		else
			exitToMenu();
	}

	function loadDialogueJSon(json:String)
	{
		var jsonPath:String = 'synsun/$json.json';
		var jsonPathsuffix:String = 'synsun/$json' + Language.flavor.get("synsun_suffix", "") + '.json';
		var path:String = '';
		var tjson:ThaiDialogueFile;
		
		#if MODS_ALLOWED
			//Awesome if chain hueh
			path = Paths.modFolders(jsonPathsuffix);
			if (!FileSystem.exists(path)) 
				path = Paths.modFolders(jsonPath);
			if (!FileSystem.exists(path)) 
				path = Paths.getPreloadPath(jsonPath);
			if (!FileSystem.exists(path))
				path = Paths.getPreloadPath('synsun/error.json');

			tjson = cast Json.parse(File.getContent(path));
		#else
			path = Paths.getPreloadPath(jsonPath);
			if (!Assets.exists(path))
				path = Paths.getPreloadPath('synsun/error.json');

			tjson = cast Json.parse(Assets.getText(path)); 
		#end

		dialogueData = tjson;
		dialogueBox.alpha = 1;
		currentJson = json;
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

	function exitToMenu()
	{
		allowInput = false;
		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		MainMenuState.initChecker = [backdrop.x, backdrop.y, colorTween1.color, colorTween2.color];
		MainMenuState.firstStart = false;
		MusicBeatState.switchState(new MainMenuState());
	}

	function laziestTweenLoop(bool:Bool)
	{
		FlxTween.cancelTweensOf(liveIcon);
		FlxTween.tween(liveIcon, {alpha: (bool ? 1 : 0)}, 0.7, {ease: FlxEase.linear, startDelay: 1,
			onComplete: function(flxTween:FlxTween)
			{
				laziestTweenLoop(!bool);
			}}
		);
	}

	function summonStuff()
	{
		endDialogue();
		FlxTween.tween(sidebar, {x: 0}, 0.5, {ease: FlxEase.sineOut});
		menuItems.forEach(function(obj:MMenuItem)
		{
			FlxTween.cancelTweensOf(obj);
			FlxTween.tween(obj, {x: -10}, 0.5, {ease: FlxEase.sineOut, startDelay: 0.1 + (obj.ID * 0.1)});
		});
	}

	function transAnimation()
	{
		transBlack.animation.play("transin", true);
		transBlack.alpha = 1;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			transBlack.animation.play("transout", true);
			blackScreen.visible = false;
			endDialogue();
		});
	}
}
