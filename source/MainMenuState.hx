package;

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
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import options.OptionsState;
import shaders.TwoToneMask;
import achievements.Achievements;

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
	var scrollText:FlxBackdrop;
	var liveIcon:FlxSprite;
	var synsunIcon:FlxSprite;
	var lilIconInt:Int = 0;
	var achievementIcon:FlxSprite;
	var synthRand:Bool = false;
	var glowwowo:FlxSprite;
	var border:FlxSprite;
	//Stealing this from DDTO
	var colorTween1:FlxSprite = new FlxSprite(-9000, -9000).makeGraphic(1, 1, 0xFF1ABBD4);
	var colorTween2:FlxSprite = new FlxSprite(-9000, -9000).makeGraphic(1, 1, 0xFF1B7AB1);
	var colorShader:TwoToneMask = new TwoToneMask(0xFF1ABBD4, 0xFF1B7AB1);
	var glowTimer:FlxTimer;
	public static var fromSpecificState:Int = 0;

	public static var canClickSynthetic:Bool = false;

	var optionShit:Array<Array<Dynamic>> = [
		['story',0xFF3CFDFD, 0xFFFCFC9B],
		['freeplay',0xFFD1FC59, 0xFF53BE7E],
		['fp',0xFFAD34C2, 0xFFACE6FF],
		['gallery',0xFFC62121, 0xFF483646],
		['options',0xFF583268, 0xFFE2E75D],
		['credits',0xFFFF6FB0, 0xFF71E5FF ]
	];

	var debugKeys:Array<FlxKey>;

	public static var instance:MainMenuState;

	override function create()
	{
		FlxG.mouse.visible = true;

		#if MODS_ALLOWED
		Paths.pushGlobalMods();
		Paths.pushTranslationMods();
		#end
		WeekData.loadTheFirstEnabledMod();

		instance = this;

		#if discord_rpc
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

		scrollText = new FlxBackdrop(Paths.image('mainmenu/SynSun/scrolltext/story'), X);
		scrollText.setPosition(0, 400);
		scrollText.velocity.set(-40, 0);
		scrollText.antialiasing = ClientPrefs.globalAntialiasing;
		add(scrollText);
		FlxTween.tween(scrollText, {y: 329}, (0.5), {ease: FlxEase.sineOut});

		border = new FlxSprite().loadGraphic(Paths.image('mainmenu/border'));
		border.screenCenter();
		border.antialiasing = ClientPrefs.globalAntialiasing;
		border.alpha = 0.001;
		FlxTween.tween(border, {alpha: 1}, (0.5), {ease: FlxEase.sineOut});
		add(border);

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

		synsunIcon = new FlxSprite(1066, 720).loadGraphic(Paths.image('mainmenu/synsunbutton'));
		synsunIcon.antialiasing = ClientPrefs.globalAntialiasing;
		add(synsunIcon);
		FlxTween.tween(synsunIcon, {y: 574}, 0.5, {ease: FlxEase.sineOut});

		achievementIcon = new FlxSprite(884, 720).loadGraphic(Paths.image('mainmenu/achbutton'));
		achievementIcon.antialiasing = ClientPrefs.globalAntialiasing;
		add(achievementIcon);
		FlxTween.tween(achievementIcon, {y: 574}, 0.5, {ease: FlxEase.sineOut});

		sidebar = new FlxSprite(fromSpecificState == 2 ? -369 : -2018).loadGraphic(Paths.image('mainmenu/sidebar_full'));
		sidebar.antialiasing = ClientPrefs.globalAntialiasing;
		add(sidebar);
		FlxTween.tween(sidebar, {x: -1649}, fromSpecificState == 1 ? 0.001 : 0.5, {ease: FlxEase.sineOut});

		glowwowo = new FlxSprite(0, 0).loadGraphic(Paths.image('mainmenu/buttons/selectglow'));
		glowwowo.antialiasing = ClientPrefs.globalAntialiasing;
		glowwowo.alpha = 0.001;
		glowwowo.scale.y = 0.001;
		add(glowwowo);

		menuItems = new FlxTypedGroup<MMenuItem>();
		add(menuItems);
		
		for (i in 0...optionShit.length)
		{
			var menuObject:MMenuItem = new MMenuItem(fromSpecificState == 1 ? -10 : -452, 12 + (i * 115), optionShit[i][0]);
			menuObject.ID = i;
			menuItems.add(menuObject);
			if (fromSpecificState != 1)
				FlxTween.tween(menuObject, {x: -10}, (0.5), {ease: FlxEase.sineOut, startDelay: (0.1 + (0.1 * i))});


			//preload assets
			var potoat:FlxSprite = new FlxSprite(0,-113).loadGraphic(Paths.image('mainmenu/SynSun/scrolltext/' + optionShit[i][0]));
			potoat.antialiasing = ClientPrefs.globalAntialiasing;
			potoat.alpha = 0.001;
			add(potoat);
		}

		if (firstStart)
		{
			synthRand = true;
			var randInt:Int = FlxG.random.int(1, 10);
			var pookiedookiebear:String = ""; //Thanks chibi
			new FlxTimer().start(0.5, function(tmr:FlxTimer)
			{
				FlxG.sound.music.fadeOut(0.2, 0.12);
				firstStart = false;
				sunsynSound = new FlxSound().loadEmbedded(Paths.sound('sunsynth/greetings/greeting${randInt}'));
				switch (randInt) //Hard coded but it's ok. I'm happy with this :)
				{
					case 1:
						pookiedookiebear = "Sun-Dried: Hi there!:dur:1.269[NL]Synthetic: What's shakin'!:dur:1.140";
						syn.animation.play('greeting');
						sun.animation.play('greeting');
					case 2:
						pookiedookiebear = "Sun-Dried: It's so good to see you again.:dur:2.328";
						sun.animation.play('greeting');
					case 3:
						pookiedookiebear = "Sun-Dried: Let's get started!:dur:1.345[NL]Synthetic: Jump to it!:dur:0.965";
						syn.animation.play('greeting');
						sun.animation.play('greeting');
					case 4:
						pookiedookiebear = "Synthetic: If I had hands, I'd wave hello.:dur:2.358";
						syn.animation.play('greeting');
					case 5:
						pookiedookiebear = "Synthetic: It's groovin' time,:dur:1.566[NL]WOOOO:dur:0.76";
						syn.animation.play('greeting');
					case 6:
						pookiedookiebear = "Sun-Dried: Hai!:dur:1.167";
						sun.animation.play('greeting');
					case 7:
						pookiedookiebear = "Synthetic: Welcome back!:dur:1.404[NL]Sun-Dried: We missed you!:dur:1.676";
						syn.animation.play('greeting');
						sun.animation.play('greeting');
					case 8:
						pookiedookiebear = "Sun-Dried: Ready to rave?:dur:1.331[NL]Synthetic: You know it, Sunny!:dur:1.371";
						syn.animation.play('greeting');
						sun.animation.play('greeting');
					case 9:
						pookiedookiebear = "Sun-Dried: We got company, Synthetic.:dur:2.134";
						sun.animation.play('greeting');
					case 10:
						pookiedookiebear = "Synthetic: Wanna listen to some tunes?:dur:2.026";
						syn.animation.play('greeting');
				}
				sunsynSound.onComplete = function() {
					FlxG.sound.music.fadeIn(4, 0.12, 0.8);
					new FlxTimer().start(4, function(tmr:FlxTimer)
					{
						canClickSynthetic = true;
					});
				}
				new FlxTimer().start(0.7, function(tmr:FlxTimer)
					{
						sunsynSound.play();
						if (ClientPrefs.subtitles)
						{
							var subtitles:SubtitlesObject = new SubtitlesObject(0,0);
							subtitles.screenCenter(Y);
							subtitles.y += 270;
							subtitles.antialiasing = ClientPrefs.globalAntialiasing;
							add(subtitles);
							subtitles.justincase();
							subtitles.setupSubtitles(Language.flavor.get("mainmenu_" + randInt, pookiedookiebear));
						}
					
					});
			});

			//Subtitle support for this menu
		}
		// Don't lock them out of the Password screen if they don't wait!!!
		else if (!canClickSynthetic)
		{
			canClickSynthetic = true;
		}

		fromSpecificState = 0;

		new FlxTimer().start(1.1, function(tmr:FlxTimer)
		{
			selectedSomethin = false;
			synthRand = false;
			changeItem();
			synthLoop();
		});

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

			if (controls.UI_LEFT_P)
				totheAchievementState();

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				TitleState.firstStart = false;
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

			if (FlxG.mouse.overlaps(syn) && FlxG.mouse.justPressed && canClickSynthetic)
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new PasswordState());
			}

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

				if (FlxG.mouse.overlaps(synsunIcon) && lilIconInt != 1)
				{
					highlightSprite(achievementIcon, 0);
					highlightSprite(synsunIcon, 1);
				}
				else if (!FlxG.mouse.overlaps(synsunIcon) && lilIconInt == 1)
				{
					highlightSprite(achievementIcon, 0);
					highlightSprite(synsunIcon, 0);
				}

				if (FlxG.mouse.overlaps(achievementIcon) && lilIconInt != 2)
				{
					highlightSprite(synsunIcon, 0);
					highlightSprite(achievementIcon, 2);
				}
				else if (!FlxG.mouse.overlaps(achievementIcon) && lilIconInt == 2)
				{
					highlightSprite(synsunIcon, 0);
					highlightSprite(achievementIcon, 0);
				}

				if (FlxG.mouse.overlaps(synsunIcon) && FlxG.mouse.justPressed && lilIconInt == 1)
					totheSunSynthState();

				if (FlxG.mouse.overlaps(achievementIcon) && FlxG.mouse.justPressed && lilIconInt == 2)
					totheAchievementState();
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
		FlxTween.tween(sidebar, {x: -2018}, 0.3, {ease: FlxEase.sineOut});
		FlxTween.cancelTweensOf(synsunIcon);
		FlxTween.tween(synsunIcon, {x: 1380}, 0.3, {ease: FlxEase.sineOut});
		FlxTween.cancelTweensOf(achievementIcon);
		FlxTween.tween(achievementIcon, {y: 720}, 0.3, {ease: FlxEase.sineOut});
		FlxTween.cancelTweensOf(glowwowo);
		FlxTween.tween(glowwowo, {alpha: 0.001, "scale.y": 0.001}, 0.1, {ease: FlxEase.sineOut});
		FlxTween.cancelTweensOf(scrollText);
		FlxTween.tween(scrollText, {y: 500}, (0.3), {ease: FlxEase.sineOut});
		FlxTween.cancelTweensOf(border);
		FlxTween.tween(border, {alpha: 0.001}, (0.5), {ease: FlxEase.sineOut});
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

	function totheAchievementState()
	{
		selectedSomethin = true;
		SunSynthState.initPortrait = optionShit[curSelected][0];
		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		FlxTween.tween(sidebar, {x: -369}, 0.5, {ease: FlxEase.sineIn});
		FlxTween.cancelTweensOf(synsunIcon);
		FlxTween.tween(synsunIcon, {y: 720}, 0.3, {ease: FlxEase.sineOut});
		FlxTween.cancelTweensOf(achievementIcon);
		FlxTween.tween(achievementIcon, {x: 0}, 0.3, {ease: FlxEase.sineOut});
		FlxTween.cancelTweensOf(glowwowo);
		FlxTween.tween(glowwowo, {alpha: 0.001, "scale.y": 0.001}, 0.1, {ease: FlxEase.sineOut});
		menuItems.forEach(function(obj:MMenuItem)
		{
			FlxTween.cancelTweensOf(obj);
			FlxTween.tween(obj, {x: -452}, 0.2, {ease: FlxEase.sineOut, startDelay: 0 + (0.05 * obj.ID)});

		});
		
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			initChecker = [backdrop.x, backdrop.y, colorTween1.color, colorTween2.color, liveIcon.alpha];
			MusicBeatState.switchState(new AchievementsState());
		});
	}

	function highlightSprite(sprite:FlxSprite, int:Int)
	{
		lilIconInt = int;
		var scale:Float = int != 0 ? 1.2 : 1;
		FlxTween.cancelTweensOf(sprite);
		FlxTween.tween(sprite, {"scale.x": scale, "scale.y": scale}, 0.1, {ease: FlxEase.sineOut});
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
				scrollText.loadGraphic(Paths.image('mainmenu/SynSun/scrolltext/' + obj.name));
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
	public var name:String;

	public function new(x:Float = 0, y:Float = 0, item:String)
	{
		super(x, y);

		name = item;

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