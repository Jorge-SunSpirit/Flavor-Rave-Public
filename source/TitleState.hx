package;

import Language.LanguageText;
#if discord_rpc
import Discord.DiscordClient;
#end
#if desktop
import sys.thread.Thread;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.sound.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.Json;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import options.GraphicsSettingsSubState;
import shaders.ColorSwap;
import achievements.Achievements;

using StringTools;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end

class TitleState extends MusicBeatState
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	public static var initialized:Bool = false;
	public static var firstStart:Bool = true;

	var blackScreen:FlxSprite;
	public var colorSwap:ColorSwap;

	var sky:FlxSprite;
	var light1:FlxSprite;
	var light2:FlxSprite;
	var city:FlxSprite;
	var savory:FlxSprite;
	var smoky:FlxSprite;
	var spicy:FlxSprite;
	var umami:FlxSprite;
	var bitter:FlxSprite;
	var salty:FlxSprite;
	var tangy:FlxSprite;
	var sands:FlxSprite;

	var topBoarder:FlxSprite;
	var bottomBoarder:FlxSprite;
	var logo:FlxSprite;
	var titleText:FlxSprite;

	var curWacky:Array<String> = [];

	override public function create():Void
	{
		/*
		#if sys
		if (!sys.FileSystem.exists(Sys.getCwd() + "/replays"))
			sys.FileSystem.createDirectory(Sys.getCwd() + "/replays");
		#end
		*/

		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		#if LUA_ALLOWED
		Paths.pushGlobalMods();
		#end

		// Just to load a mod on start up if ya got one. For mods that change the menu music and bg
		WeekData.loadTheFirstEnabledMod();

		FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = 60;
		FlxG.mouse.useSystemCursor = true;
		FlxG.sound.muteKeys = muteKeys;
		FlxG.sound.volumeDownKeys = volumeDownKeys;
		FlxG.sound.volumeUpKeys = volumeUpKeys;
		FlxG.keys.preventDefaultKeys = [TAB];

		PlayerSettings.init();

		curWacky = FlxG.random.getObject(getIntroTextShit());

		super.create();

		FlxG.save.bind('FlavorRave', CoolUtil.getSavePath());

		ClientPrefs.loadPrefs();
		Language.init();
		NoteSkin.init();
		Achievements.init();

		FlxG.autoPause = ClientPrefs.autoPause;
		FlxG.mouse.visible = ClientPrefs.menuMouse;

		Highscore.load();

		if(!initialized)
		{
			persistentUpdate = true;
			persistentDraw = true;
		}

		if (FlxG.save.data.weekCompleted != null)	
			WeekData.weekCompleted = FlxG.save.data.weekCompleted;

		Highscore.checkBonusWeeks();

		#if discord_rpc
		if (!DiscordClient.isInitialized)
		{
			DiscordClient.initialize();
			FlxG.stage.application.onExit.add (function (exitCode) {
				DiscordClient.shutdown();
			});
		}
		#end

		#if sys
		if (!initialized && (Argument.parse(Sys.args()) || Argument.parseDefine()))
		{
			initialized = true;
			FlxG.sound.playMusic(Paths.music(ClientPrefs.mainmenuMusic), 0);
			return;
		}
		#end

		if (initialized)
			startIntro();
		else
		{
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				startIntro();
			});
		}
	}

	function startIntro()
	{
		Paths.currentModDirectory = "";
		CoolUtil.difficulties = ["Normal"];
		Conductor.bpm = 128.0;
		persistentUpdate = true;

		var transBlack:FlxSprite = new FlxSprite();
		transBlack.frames = Paths.getSparrowAtlas('sunsynTrans', 'preload');
		transBlack.animation.addByPrefix('transin', 'transIN', 30, false);
		transBlack.animation.addByPrefix('transout', 'transOUT', 30, false);
		transBlack.animation.addByPrefix('idleempty', 'empty', 30, false);
		transBlack.animation.addByPrefix('idlefull', 'Full', 30, false);
		transBlack.antialiasing = ClientPrefs.globalAntialiasing;
		transBlack.alpha = 0.0001;
		add(transBlack);
		transBlack.frames = Paths.getSparrowAtlas('songTrans', 'preload');
		transBlack.animation.addByPrefix('transin', 'disk_transition_in', 24, false);
		transBlack.animation.addByPrefix('transout', 'disk_transition_out', 24, false);
		transBlack.animation.addByPrefix('idleempty', 'disk_transition_empty', 24, false);
		transBlack.animation.addByPrefix('idlefull', 'disk_transition_full', 24, false);

		colorSwap = new ColorSwap();

		var potoat:FlxSprite = new FlxSprite(0,-113).loadGraphic(Paths.image('closeup/RaveParticle', 'tbd'));
		potoat.antialiasing = ClientPrefs.globalAntialiasing;
		potoat.alpha = 0.001;
		add(potoat);

		//-113 is base y pos
		//sky
		sky = new FlxSprite(0,-113).loadGraphic(Paths.image('title/Flavor Rave Title_sky'));
		sky.antialiasing = ClientPrefs.globalAntialiasing;
		sky.alpha = 0.001;
		add(sky);
		// funny Lights
		light1 = new FlxSprite(93,19).loadGraphic(Paths.image('title/flavor rave title_spotlight'));
		light1.antialiasing = ClientPrefs.globalAntialiasing;
		light1.alpha = 0.001;
		light1.origin.set(167,288);
		add(light1);
		light2 = new FlxSprite(863,19).loadGraphic(Paths.image('title/flavor rave title_spotlight'));
		light2.antialiasing = ClientPrefs.globalAntialiasing;
		light2.alpha = 0.001;
		light2.origin.set(167,288);
		add(light2);
		//city
		city = new FlxSprite(0,-113).loadGraphic(Paths.image('title/Flavor Rave Title_city'));
		city.antialiasing = ClientPrefs.globalAntialiasing;
		city.alpha = 0.001;
		add(city);

		tangy = new FlxSprite(0,-113).loadGraphic(Paths.image('title/Flavor Rave Title_Tangy_Silhouette'));
		tangy.antialiasing = ClientPrefs.globalAntialiasing;
		tangy.alpha = 0.001;
		add(tangy);

		salty = new FlxSprite(0,-113).loadGraphic(Paths.image('title/Flavor Rave Title_Salty_silhouette'));
		salty.antialiasing = ClientPrefs.globalAntialiasing;
		salty.alpha = 0.001;
		add(salty);

		//savory & Smokey
		savory = new FlxSprite(0,-113).loadGraphic(Paths.image('title/Flavor Rave Title_Savory_Silhouette'));
		savory.antialiasing = ClientPrefs.globalAntialiasing;
		savory.alpha = 0.001;
		add(savory);

		smoky = new FlxSprite(0,-113).loadGraphic(Paths.image('title/Flavor Rave Title_Smoky_silhouette'));
		smoky.antialiasing = ClientPrefs.globalAntialiasing;
		smoky.alpha = 0.001;
		add(smoky);
		//Umami & Spicy
		umami = new FlxSprite(0,-113).loadGraphic(Paths.image('title/Flavor Rave Title_Umami_silhouette'));
		umami.antialiasing = ClientPrefs.globalAntialiasing;
		umami.alpha = 0.001;
		add(umami);

		spicy = new FlxSprite(0,-113).loadGraphic(Paths.image('title/Flavor Rave Title_Spicy_silhouette'));
		spicy.antialiasing = ClientPrefs.globalAntialiasing;
		spicy.alpha = 0.001;
		add(spicy);

		bitter = new FlxSprite(0,-113).loadGraphic(Paths.image('title/Flavor Rave Title_Bitter_silhouette'));
		bitter.antialiasing = ClientPrefs.globalAntialiasing;
		bitter.alpha = 0.001;
		add(bitter);

		topBoarder = new FlxSprite(0,0).loadGraphic(Paths.image('title/top_boarder'));
		topBoarder.antialiasing = ClientPrefs.globalAntialiasing;
		topBoarder.alpha = 0.001;
		add(topBoarder);

		bottomBoarder = new FlxSprite(95, 647).loadGraphic(Paths.image('title/bottom_boarder'));
		bottomBoarder.antialiasing = ClientPrefs.globalAntialiasing;
		bottomBoarder.alpha = 0.001;
		add(bottomBoarder);

		//sweetSour sprite here
		sands = new FlxSprite(0,-113).loadGraphic(Paths.image('title/Flavor Rave Title_Sweet+Sour'));
		sands.antialiasing = ClientPrefs.globalAntialiasing;
		sands.alpha = 0.001;
		add(sands);

		logo = new FlxSprite(20, 45).loadGraphic(Paths.image('title/logo'));
		logo.scale.set(0.45, 0.45);
		logo.updateHitbox();
		logo.y -= 40;
		logo.antialiasing = ClientPrefs.globalAntialiasing;
		logo.alpha = 0.001;
		add(logo);

		titleText = new FlxSprite(76,611).loadGraphic(Paths.image('title/pressenter'));
		titleText.antialiasing = ClientPrefs.globalAntialiasing;
		titleText.alpha = 0.001;
		titleText.screenCenter(X);
		add(titleText);

		#if !PUBLIC_BUILD
		var versionShit:LanguageText = new LanguageText(0, FlxG.height - 24, FlxG.width - 2, Main.VERSION, 16, 'krungthep');
		versionShit.setStyle(FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		#end

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(blackScreen);
		blackScreen.alpha = 0.001;


		if (!initialized)
		{
			#if VIDEOS_ALLOWED
			var video:VideoHandler = new VideoHandler();
			video.canSkip = true;
			video.skipKeys = [FlxKey.ESCAPE, FlxKey.ENTER];
			video.onEndReached.add(function()
			{
				skipIntro();
			});

			if (video.load(Paths.video('FRIntro')))
				video.play();
			else
				skipIntro();
			#else
			skipIntro();
			#end
		}

		if (initialized)
			skipIntro();
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;
	var newTitle:Bool = false;
	var titleTimer:Float = 0;
	public static var canInput:Bool = false;
	var angleShit1:Float = 0;

	override function update(elapsed:Float)
	{
		angleShit1 += 0.01 / FramerateTools.timeMultiplier();

		if (light1 != null && light2 != null)
		{
			light1.angle -= Math.sin(angleShit1) / FramerateTools.timeMultiplier() * 0.2;
			light2.angle += Math.sin(angleShit1) / FramerateTools.timeMultiplier() * 0.2;
		}

		#if FORCE_DEBUG_VERSION
		if (controls.RESET)
		{
			FlxG.sound.music.stop();
			canInput = false;
			initialized = false;
			MusicBeatState.resetState();
		}
		#end

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		var pressedEnter:Bool = canInput && (FlxG.keys.justPressed.ENTER || controls.ACCEPT || FlxG.mouse.justPressed && ClientPrefs.menuMouse);

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null && gamepad.justPressed.START)
			pressedEnter = true;
		
		if (newTitle) {
			titleTimer += CoolUtil.boundTo(elapsed, 0, 1);
			if (titleTimer > 2) titleTimer -= 2;
		}

		if (initialized && !transitioning && skippedIntro)
		{
			if (newTitle && !pressedEnter)
			{
				var timer:Float = titleTimer;
				if (timer >= 1)
					timer = (-timer) + 2;
				
				timer = FlxEase.quadInOut(timer);
				
			}
			
			if (pressedEnter)
			{
				titleText.alpha = 1;
				
				if(titleText != null) FlxFlicker.flicker(titleText, 1, 0.06, false, false);

				FlxG.camera.flash(ClientPrefs.flashing ? FlxColor.WHITE : 0x4CFFFFFF, 1);
				FlxG.sound.play(Paths.sound('confirmMenu'));

				transitioning = true;

				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					WeekData.reloadWeekFiles(true);

					if (#if FORCE_DEBUG_VERSION true #else ClientPrefs.pastOGWeek #end)
					{
						FRFadeTransition.type = 'synsun';
						MusicBeatState.switchState(new MainMenuState());
					}
					else
					{
						MusicBeatState.switchState(new StoryMenuState());
					}

					if (firstStart && ClientPrefs.mainmenuMusic != 'freakyMenu') //Fun fact, it'll never not be synsun transition with the music change
					{
						FlxG.sound.music.fadeOut(1.8, 0, function(twn:FlxTween){FlxG.sound.music.stop();});
						firstStart = false;
					}
				});
			}
		}

		if (initialized && pressedEnter && !skippedIntro)
		{
			skipIntro();
		}

		super.update(elapsed);
	}

	override function beatHit()
	{
		if (skippedIntro)
			spawnParticle();
		super.beatHit();
		logoBump();
	}

	var skippedIntro:Bool = false;
	function spawnParticle()
	{
		var scale:Float = FlxG.random.float(0.6, 1);
		
		var parti:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('closeup/RaveParticle', 'tbd'));
		parti.antialiasing = ClientPrefs.globalAntialiasing;
		parti.x = FlxG.random.int(0, 1270);
		parti.y = 720;
		parti.scale.set(scale, scale);
		insert(members.indexOf(topBoarder), parti);

		FlxTween.tween(parti, {y: parti.y - 600, alpha: 0}, FlxG.random.float(1, 7), {
		onComplete: function(tween:FlxTween){
			parti.destroy();
			remove(parti);
			parti = null;
		}});
	}

	// jorge i know you said "no way it'll ever be null" but sometimes it's null when using the cmd arguments
	// god fucking damn it - jor 2025
	function logoBump()
	{
		if (skippedIntro && curBeat % 2 == 0)
		{
			FlxTween.cancelTweensOf(light1);
			FlxTween.cancelTweensOf(light2);
			FlxTween.tween(light1, {alpha: 1}, 0.1, {ease: FlxEase.quadInOut, onComplete: function(twn:FlxTween)
				{
					FlxTween.tween(light1, {alpha: 0}, 1, {ease: FlxEase.quadInOut});
				}});
			FlxTween.tween(light2, {alpha: 1}, 0.1, {ease: FlxEase.quadInOut, onComplete: function(twn:FlxTween)
				{
					FlxTween.tween(light2, {alpha: 0}, 1, {ease: FlxEase.quadInOut});
				}});
		}
		if (logo != null)
		{
			logo.scale.set(0.48, 0.48);
			FlxTween.cancelTweensOf(logo);
			FlxTween.tween(logo, {"scale.x": 0.45, "scale.y": 0.45}, 0.1, {});
		}
	}

	function skipIntro():Void
	{
		if (!initialized)
		{
			if (firstStart) FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
			FlxG.sound.music.fadeIn(3, 0, 0.7);
			initialized = true;
		}
		bringinTitle(firstStart);
	}

	function bringinTitle(fancy:Bool = true)
	{
		sky.alpha = 1;
		city.alpha = 1;
		savory.alpha = 1;
		smoky.alpha = 1;
		umami.alpha = 1;
		spicy.alpha = 1;
		bitter.alpha = 1;
		tangy.alpha = 1;
		salty.alpha = 1;
		sands.alpha = 1;
		bottomBoarder.alpha = 1;
		topBoarder.alpha = 1;

		if (fancy)
		{
			city.y = 720;
			savory.y = 720;
			smoky.y = 720;
			umami.y = 720;
			spicy.y = 720;
			bitter.y = 720;
			tangy.y = 720;
			salty.y = 720;
			sands.y = 720;
			topBoarder.y = -75;
			bottomBoarder.y = 720;
			blackScreen.alpha = 1;

			FlxTween.tween(blackScreen, {alpha: 0}, 1.5, {ease: FlxEase.circInOut});

			FlxTween.tween(city, {y: -113}, 1, {ease: FlxEase.circOut, startDelay: 0.7});
			
			FlxTween.tween(sands, {y: -113}, 1, {ease: FlxEase.circOut, startDelay: 1.2});
			FlxTween.tween(spicy, {y: -113}, 1, {ease: FlxEase.circOut, startDelay: 1.5});
			FlxTween.tween(bitter, {y: -113}, 1, {ease: FlxEase.circOut, startDelay: 1.5});
			FlxTween.tween(umami, {y: -113}, 1, {ease: FlxEase.circOut, startDelay: 1.6});
			FlxTween.tween(savory, {y: -113}, 1, {ease: FlxEase.circOut, startDelay: 1.7});
			FlxTween.tween(salty, {y: -113}, 1, {ease: FlxEase.circOut, startDelay: 1.9});
			FlxTween.tween(tangy, {y: -113}, 1, {ease: FlxEase.circOut, startDelay: 1.8});
			FlxTween.tween(smoky, {y: -113}, 1, {ease: FlxEase.circOut, startDelay: 1.8});
			FlxTween.tween(topBoarder, {y: 0}, 0.5, {ease: FlxEase.circOut, startDelay: 2});
			FlxTween.tween(bottomBoarder, {y: 647}, 0.5, {ease: FlxEase.circOut, startDelay: 2});

			new FlxTimer().start(3, function(deadTime:FlxTimer)
			{
				FlxG.camera.flash(FlxColor.WHITE, 4);
				FlxG.sound.play(CoolUtil.getAnnouncerLine('titlecall'));
				titleText.alpha = 1;
				logo.alpha = 1;
				
				skippedIntro = true;

				if (Highscore.checkBeaten("Caramelize", 0))
					spicy.loadGraphic(Paths.image('title/Flavor Rave Title_Spicy'));

				if (Highscore.checkBeaten("Wasabi", 0))
					smoky.loadGraphic(Paths.image('title/Flavor Rave Title_Smoky'));

				if (Highscore.checkBeaten("Applewood", 0))
					umami.loadGraphic(Paths.image('title/Flavor Rave Title_Umami'));

				if (Highscore.checkBeaten("Tres Leches", 0))
					savory.loadGraphic(Paths.image('title/Flavor Rave Title_Savory'));

				if (Highscore.checkBeaten("Lodestar Shanty", 0))
					salty.loadGraphic(Paths.image('title/Flavor Rave Title_Salty'));

				if (Highscore.checkBeaten("Livewire", 0))
					tangy.loadGraphic(Paths.image('title/Flavor Rave Title_Tangy'));

				if (Highscore.checkBeaten("Stirring", 0))
					bitter.loadGraphic(Paths.image('title/Flavor Rave Title_Bitter'));

				new FlxTimer().start(0.5, function(tmr:FlxTimer)
				{
					canInput = true;
				});
			});

		}
		else
		{
			FlxG.camera.flash(FlxColor.WHITE, 4);
			skippedIntro = true;
			titleText.alpha = 1;
			logo.alpha = 1;

			new FlxTimer().start(0.5, function(tmr:FlxTimer)
			{
				canInput = true;
			});

			if (Highscore.checkBeaten('Caramelize', 0))
				spicy.loadGraphic(Paths.image('title/Flavor Rave Title_Spicy'));
	
			if (Highscore.checkBeaten('Wasabi', 0))
				smoky.loadGraphic(Paths.image('title/Flavor Rave Title_Smoky'));
	
			if (Highscore.checkBeaten('Applewood', 0))
				umami.loadGraphic(Paths.image('title/Flavor Rave Title_Umami'));
	
			if (Highscore.checkBeaten('Tres Leches', 0))
				savory.loadGraphic(Paths.image('title/Flavor Rave Title_Savory'));
	
			if (Highscore.checkBeaten('Lodestar Shanty', 0))
				salty.loadGraphic(Paths.image('title/Flavor Rave Title_Salty'));
	
			if (Highscore.checkBeaten('Livewire', 0))
				tangy.loadGraphic(Paths.image('title/Flavor Rave Title_Tangy'));
	
			if (Highscore.checkBeaten('Stirring', 0))
				bitter.loadGraphic(Paths.image('title/Flavor Rave Title_Bitter'));
		}
	}
}
