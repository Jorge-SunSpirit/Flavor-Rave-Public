package;

#if desktop
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
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
// import flxanimate.FlxAnimate;
import options.OptionsState;
import shaders.TwoToneMask;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var mythicalEngineVersion:String = '1.0.0'; //This is also used for Discord RPC
	public static var psychEngineVersion:String = '0.6.3'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;
	public static var firstStart:Bool = true;
	public static var initChecker:Array<Dynamic> = [0,0,0xFF1ABBD4, 0xFF1B7AB1, 1];
	public var selectedSomethin:Bool = true;

	var menuItems:FlxTypedGroup<MMenuItem>;
	var menuArt:FlxSprite;
	var sun:FlxSprite;
	var syn:FlxSprite;
	var sunsynSound:FlxSound;
	var sidebar:FlxSprite;
	var backdrop:FlxBackdrop;
	var liveIcon:FlxSprite;
	var synsunIcon:FlxSprite;
	var synsunBool:Bool = false;
	var synthRand:Bool = false;
	var glowwowo:FlxSprite;
	//Stealing this from DDTO
	var colorTween1:FlxSprite = new FlxSprite(-9000, -9000).makeGraphic(1, 1, 0xFF1ABBD4);
	var colorTween2:FlxSprite = new FlxSprite(-9000, -9000).makeGraphic(1, 1, 0xFF1B7AB1);
	var colorShader:TwoToneMask = new TwoToneMask(0xFF1ABBD4, 0xFF1B7AB1);
	var glowTimer:FlxTimer;
	public static var fromFirstState:Bool = false;

	var optionShit:Array<Array<Dynamic>> = [
		['story',0xFF3CFDFD, 0xFFFFFF77],
		['freeplay',0xFFD1FC59, 0xFF26592D],
		['fp',0xFF8E2D9D, 0xFFC9ECFF],
		['gallery',0xFFB61E1E, 0xFF282222],
		['options',0xFF271F2A, 0xFFE2E75D],
		['credits',0xFFFF6FB0, 0xFF71E5FF ]
	];

	var debugKeys:Array<FlxKey>;

	public static var instance:MainMenuState;

	override function create()
	{
		FlxG.mouse.visible = ClientPrefs.menuMouse;

		#if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();

		instance = this;

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music(ClientPrefs.mainmenuMusic));
		}

		// persistentUpdate = persistentDraw = true;

		backdrop = new FlxBackdrop(Paths.image('mainmenu/checkerboard'));
		backdrop.setPosition(initChecker[0], initChecker[1]);
		backdrop.velocity.set(-40, -40);
		backdrop.antialiasing = false;
		backdrop.shader = colorShader.shader;
		add(backdrop);
		colorTween1.color = initChecker[2];
		colorTween2.color = initChecker[3];

		menuArt = new FlxSprite(1280,-56).loadGraphic(Paths.image('mainmenu/art/' + optionShit[curSelected][0]));
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
		syn.animation.addByIndices('idle_rand', 'Syn All in One', CoolUtil.numberArray(178, 57), "", 24, false);
		syn.animation.addByIndices('happy', 'Syn All in One', CoolUtil.numberArray(31, 0), "", 24, false);
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

		liveIcon = new FlxSprite(10,10).loadGraphic(Paths.image('mainmenu/SynSun/live'));
		liveIcon.antialiasing = ClientPrefs.globalAntialiasing;
		liveIcon.alpha = initChecker[4];
		add(liveIcon);
		laziestTweenLoop(true);

		sidebar = new FlxSprite(-774).loadGraphic(Paths.image('mainmenu/sidebar'));
		sidebar.antialiasing = ClientPrefs.globalAntialiasing;
		add(sidebar);
		FlxTween.tween(sidebar, {x: 0}, fromFirstState ? 0.001 : 0.5, {ease: FlxEase.sineOut});

		synsunIcon = new FlxSprite(1280, 550).loadGraphic(Paths.image('mainmenu/synsunbutton'));
		synsunIcon.antialiasing = ClientPrefs.globalAntialiasing;
		add(synsunIcon);
		FlxTween.tween(synsunIcon, {x: 1037}, 0.5, {ease: FlxEase.sineOut});

		if (firstStart)
		{
			synthRand = true;
			new FlxTimer().start(0.5, function(tmr:FlxTimer)
			{
			FlxG.sound.music.fadeOut(0.2, 0.12);
			syn.animation.play('greeting');
			sun.animation.play('greeting');
			firstStart = false;
			sunsynSound = new FlxSound().loadEmbedded(Paths.sound('sunsynth/greetings/greeting${FlxG.random.int(1, 10)}'));
			sunsynSound.onComplete = function() {FlxG.sound.music.fadeIn(4, 0.12, 0.8);}
			new FlxTimer().start(0.7, function(tmr:FlxTimer){sunsynSound.play();});
			});
		}

		glowwowo = new FlxSprite(0, 0).loadGraphic(Paths.image('mainmenu/buttons/selectglow'));
		glowwowo.antialiasing = ClientPrefs.globalAntialiasing;
		glowwowo.alpha = 0.001;
		glowwowo.scale.y = 0.001;
		add(glowwowo);

		menuItems = new FlxTypedGroup<MMenuItem>();
		add(menuItems);
		
		for (i in 0...optionShit.length)
		{
			var menuObject:MMenuItem = new MMenuItem(fromFirstState ? -10 : -452, 12 + (i * 115), optionShit[i][0]);
			menuObject.ID = i;
			menuItems.add(menuObject);
			if (!fromFirstState)
				FlxTween.tween(menuObject, {x: -10}, (0.5), {ease: FlxEase.sineOut, startDelay: (0.1 + (0.1 * i))});
		}

		fromFirstState = false;

		new FlxTimer().start(1.1, function(tmr:FlxTimer)
		{
			selectedSomethin = false;
			synthRand = false;
			changeItem();
			synthLoop();
		});

		#if !PUBLIC_BUILD
		var versionShit:FlxText = new FlxText(0, FlxG.height - 24, FlxG.width - 2, Main.VERSION, 12);
		versionShit.antialiasing = ClientPrefs.globalAntialiasing;
		versionShit.setFormat(Paths.font("Krungthep.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		#end

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8 && (sunsynSound != null && !sunsynSound.playing || sunsynSound == null && !firstStart))
		{
			FlxG.sound.music.volume += 0.5 * elapsed;
			for (vocal in FreeplayState.vocalTracks)
			{
				if (vocal != null)
				{
					vocal.volume += 0.5 * elapsed;
				}
			}
		}

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.UI_RIGHT_P)
				totheSunSynthState();

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				selectItem();
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end

			if (ClientPrefs.menuMouse)
			{

				menuItems.forEach(function(spr:MMenuItem)
				{
					if (FlxG.mouse.overlaps(spr) && curSelected != spr.ID && FlxG.mouse.justMoved)
					{
						curSelected = spr.ID;
						changeItem();
					}
					if (FlxG.mouse.overlaps(spr) && FlxG.mouse.justPressed)
					{
						selectedSomethin = true;
						selectItem();
					}
				});

				if (FlxG.mouse.overlaps(synsunIcon) && !synsunBool)
					highlightSynSun(true);
				else if (!FlxG.mouse.overlaps(synsunIcon) && synsunBool)
					highlightSynSun(false);

				if (FlxG.mouse.overlaps(synsunIcon) && FlxG.mouse.justPressed && synsunBool)
					totheSunSynthState();
			}
		}

		super.update(elapsed);

		colorShader.color1 = colorTween1.color;
		colorShader.color2 = colorTween2.color;
	}

	public function selectItem()
	{
		selectedSomethin = true;
		FlxG.sound.play(Paths.sound('confirmMenu'));
		//trace('Quick test');

		menuItems.forEach(function(spr:MMenuItem)
		{
			if (curSelected != spr.ID)
			{
				FlxTween.tween(spr, {alpha: 0}, 0.4, {
					ease: FlxEase.quadOut,
					onComplete: function(twn:FlxTween)
					{
						spr.kill();
					}
				});
			}
			else
			{
				glowwowo.y = spr.y;
				if (glowTimer != null) glowTimer.cancel();
				FlxTween.tween(glowwowo, {y: 298, alpha: 1, "scale.y": 1}, 1, {ease: FlxEase.sineOut});
				FlxTween.tween(spr, {y: 298}, 1, {ease: FlxEase.sineOut, onComplete: function(twn:FlxTween)
				{
					var daChoice:String = optionShit[curSelected][0];
					FlxTween.cancelTweensOf(glowwowo);
					FlxTween.tween(glowwowo, {alpha: 0.001, "scale.y": 0.001}, 0.2, {ease: FlxEase.sineOut, startDelay: 0.1});
					FlxTween.tween(spr, {x: -453}, 0.2, {ease: FlxEase.sineOut});

					switch (daChoice)
					{
						case 'story':
							MusicBeatState.switchState(new StoryMenuState());
						case 'freeplay':
							MusicBeatState.switchState(new FreeplayState());
						case 'gallery':
							MusicBeatState.switchState(new GalleryState());
						case 'credits':
							MusicBeatState.switchState(new CreditsState());
						case 'options':
							OptionsState.whichState = 'default';
							LoadingState.loadAndSwitchState(new OptionsState());
						case 'fp':
							MusicBeatState.switchState(new FlavorpediaSelectorState());
					}
				}});
			}
		});	
	}

	function totheSunSynthState()
	{
		selectedSomethin = true;
		SunSynthState.initPortrait = optionShit[curSelected][0];
		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		FlxTween.tween(sidebar, {x: -774}, 0.3, {ease: FlxEase.sineOut});
		FlxTween.cancelTweensOf(synsunIcon);
		FlxTween.tween(synsunIcon, {x: 1380}, 0.3, {ease: FlxEase.sineOut});
		FlxTween.cancelTweensOf(glowwowo);
		FlxTween.tween(glowwowo, {alpha: 0.001, "scale.y": 0.001}, 0.1, {ease: FlxEase.sineOut});
		menuItems.forEach(function(obj:MMenuItem)
		{
			FlxTween.cancelTweensOf(obj);
			FlxTween.tween(obj, {x: -452}, 0.2, {ease: FlxEase.sineOut, startDelay: 0 + (0.05 * obj.ID)});

		});
		
		new FlxTimer().start(0.8, function(tmr:FlxTimer)
		{
			initChecker = [backdrop.x, backdrop.y, colorTween1.color, colorTween2.color, liveIcon.alpha];
			MusicBeatState.switchState(new SunSynthState());
		});
	}

	function highlightSynSun(bool:Bool)
	{
		synsunBool = bool;
		var scale:Float = bool ? 1.2 : 1;
		FlxTween.cancelTweensOf(synsunIcon);
		FlxTween.tween(synsunIcon, {"scale.x": scale, "scale.y": scale}, 0.1, {ease: FlxEase.sineOut});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		if (glowTimer != null) glowTimer.cancel();

		FlxTween.cancelTweensOf(glowwowo);
		FlxTween.tween(glowwowo, {alpha: 0.001, "scale.y": 0.001}, 0.1, {ease: FlxEase.sineOut});

		menuItems.forEach(function(obj:MMenuItem)
		{
			FlxTween.cancelTweensOf(obj);
			if (obj.ID == curSelected)
			{
				FlxTween.tween(obj, {x: 10}, 0.25, {ease: FlxEase.sineOut});
				obj.highlighted(true);

				glowTimer = new FlxTimer().start(0.1, function(tmr:FlxTimer)
				{
					glowwowo.y = obj.y;
					FlxTween.cancelTweensOf(glowwowo);
					FlxTween.tween(glowwowo, {alpha: 1, "scale.y": 1}, 0.2, {ease: FlxEase.sineOut});
				});
			}
			else
			{
				FlxTween.tween(obj, {x: -20}, 0.25, {ease: FlxEase.sineOut});
				obj.highlighted(false);
			}	
		});

		FlxTween.cancelTweensOf(colorTween1);
		FlxTween.cancelTweensOf(colorTween2);
		FlxTween.color(colorTween1, 1, colorShader.color1, optionShit[curSelected][1]);
		FlxTween.color(colorTween2, 1, colorShader.color2, optionShit[curSelected][2]);

		menuArt.x = 1280;
		FlxTween.cancelTweensOf(menuArt);
		FlxTween.tween(menuArt, {x: 375}, 0.5, {ease: FlxEase.sineOut});

		var img = Paths.image('mainmenu/art/' + optionShit[curSelected][0]);
		menuArt.loadGraphic(img);
		menuArt.visible = (img != null);
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

	var synthTimer:FlxTimer;
	function synthLoop()
	{
		synthTimer = new FlxTimer().start(3, function(tmr:FlxTimer)
		{
			if (!synthRand && FlxG.random.int(1, 10) == 3)
			{
				synthRand = true;
				syn.animation.play('idle_rand');
				synthTimer = new FlxTimer().start(5, function(tmr:FlxTimer)
				{
					synthRand = false;
					syn.animation.play('idle');
					synthLoop();
				});
			}
			else
				synthLoop();
		});
	}

	var dumbTimer:FlxTimer;
	override public function onFocusLost():Void
	{
		if (synthTimer != null && !synthTimer.finished)
			synthTimer.cancel();
		dumbTimer = new FlxTimer().start(5, function(tmr:FlxTimer)
		{
			if (!selectedSomethin)
			{
				synthRand = true;
				sun.animation.play('phone');
				syn.animation.play('Bored');
			}
		});
		super.onFocusLost();
	}

	override public function onFocus():Void
	{
		if (dumbTimer != null && !dumbTimer.finished)
			dumbTimer.cancel();
		if (!selectedSomethin)
		{
			synthRand = false;
			syn.animation.play('reset');
			sun.animation.play('reset');
		}
		synthLoop();
		super.onFocus();
	}
}

class MMenuItem extends FlxSpriteGroup
{
	var song:String;

	var bg:FlxSprite;
	var text:FlxSprite;

	public function new(x:Float = 0, y:Float = 0, item:String)
	{
		super(x, y);

		bg = new FlxSprite().loadGraphic(Paths.image('mainmenu/buttons/'+ item +'back'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		text = new FlxSprite().loadGraphic(Paths.image('mainmenu/buttons/'+ item +'front'));
		text.antialiasing = ClientPrefs.globalAntialiasing;
		text.scale.set(0.9, 0.9);
		add(text);
	}

	public function highlighted(bool:Bool)
	{
		FlxTween.cancelTweensOf(text);
		if (bool)
			FlxTween.tween(text, {"scale.x": 1.1,"scale.y": 1.1}, 0.1, {ease: FlxEase.sineOut});
		else
			FlxTween.tween(text, {"scale.x": 0.9,"scale.y": 0.9}, 0.1, {ease: FlxEase.sineOut});
	}

}