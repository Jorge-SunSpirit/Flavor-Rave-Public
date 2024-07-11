package;

import openfl.media.Sound;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.Json;
import openfl.utils.Assets;

using StringTools;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end

typedef GOFile = {
	var image:String;
	var animation:String;
	var spriteOffset:Array<Float>;
	var scale:Float;
	var no_antialiasing:Bool;
	var flip_x:Bool;
	var goSound:Array<GOSound>;
}

typedef GOSound = {
	var sound:String;
	var opponent:String;
}

class GameOverSubState extends MusicBeatSubstate
{
	var chara:GOCharater;
	var yesbutt:FlxSprite;
	var nobutt:FlxSprite;
	var tryagain:FlxSprite;
	var camFollow:FlxPoint;
	var camFollowPos:FlxObject;
	var updateCamera:Bool = false;
	var playingDeathSound:Bool = false;
	var curSelected:Int = 0;

	public static var instance:GameOverSubState;

	override function create()
	{
		instance = this;

		super.create();
	}

	public function new(goChara:String)
	{
		super();

		Conductor.songPosition = 0;

		var bgSky:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image('gameover/bg'));
		bgSky.antialiasing = ClientPrefs.globalAntialiasing;
		bgSky.scrollFactor.set(0, 0);
		add(bgSky);

		chara = new GOCharater(FlxG.width, FlxG.height, goChara);
		chara.scrollFactor.set(0, 0);
		chara.offset.x = chara.spriteOffset[0];
		add(chara);

		var outshined:FlxSprite = new FlxSprite(0,-200).loadGraphic(Paths.image('gameover/outshined'));
		outshined.antialiasing = ClientPrefs.globalAntialiasing;
		outshined.scrollFactor.set(0, 0);
		outshined.scale.set(0.8, 0.8);
		outshined.updateHitbox();
		outshined.screenCenter(X);
		outshined.angle = 5;
		add(outshined);

		tryagain = new FlxSprite(293,392).loadGraphic(Paths.image('gameover/tryagain'));
		tryagain.antialiasing = ClientPrefs.globalAntialiasing;
		tryagain.scrollFactor.set(0, 0);
		tryagain.alpha = 0.001;
		add(tryagain);

		yesbutt = new FlxSprite(86,485);
		yesbutt.frames = Paths.getSparrowAtlas('gameover/YesButton');//curSong
		yesbutt.animation.addByPrefix('idle', 'YesButton0000', 24, false);
		yesbutt.animation.addByPrefix('highlight', 'YesButtonSelect0000', 24, false);
		yesbutt.antialiasing = ClientPrefs.globalAntialiasing;
		yesbutt.scrollFactor.set(0, 0);
		yesbutt.alpha = 0.001;
		add(yesbutt);

		nobutt = new FlxSprite(468,485);
		nobutt.frames = Paths.getSparrowAtlas('gameover/NoButton');//curSong
		nobutt.animation.addByPrefix('idle', 'NoButton0000', 24, false);
		nobutt.animation.addByPrefix('highlight', 'NoButtonSelect0000', 24, false);
		nobutt.antialiasing = ClientPrefs.globalAntialiasing;
		nobutt.scrollFactor.set(0, 0);
		nobutt.alpha = 0.001;
		add(nobutt);

		var blackShit:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
		blackShit.scrollFactor.set(0, 0);
		add(blackShit);

		camFollow = new FlxPoint(0, 0);
		Conductor.bpm = 100.0;

		FlxTween.cancelTweensOf(FlxG.camera);
		FlxG.camera.angle = 0;
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;
		FlxG.camera.zoom = 1;

		camFollowPos = new FlxObject(0, 0, 1, 1);
		camFollowPos.setPosition(0, 0);
		add(camFollowPos);

		FlxG.sound.play(Paths.sound('newgameover'));

		FlxTween.tween(blackShit, {alpha: 0}, 0.1, {ease: FlxEase.sineOut, startDelay: 1.147});
		FlxTween.tween(chara, {'offset.y': chara.spriteOffset[1]}, 1, {ease: FlxEase.cubeOut, startDelay: 1.147});
		FlxTween.tween(outshined, {y: 40, angle: 0}, 0.5, {ease: FlxEase.sineOut, startDelay: 2.251});
		new FlxTimer().start(4, function(deadTime:FlxTimer)
		{
			coolStartDeath();
			changeItem();
			FlxTween.tween(tryagain, {alpha: 1}, 0.2, {ease: FlxEase.sineOut});
			FlxTween.tween(yesbutt, {alpha: 1}, 0.3, {ease: FlxEase.sineOut});
			FlxTween.tween(nobutt, {alpha: 1}, 0.3, {ease: FlxEase.sineOut});
		});

	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (playingDeathSound && !isEnding)
		{
			if (controls.ACCEPT)
			{
				switch (curSelected)
				{
					case 0:
						endBullshit(true);
					case 1:
						endBullshit(false);
				}
				
			}

			if (controls.UI_LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				endBullshit(false);
			}

			if(ClientPrefs.menuMouse)
			{
				if(FlxG.mouse.overlaps(yesbutt))
				{
					if (FlxG.mouse.justMoved && curSelected != 0)
					{
						curSelected = 0;
						changeItem();
						FlxG.sound.play(Paths.sound('scrollMenu'));
					}
					if(FlxG.mouse.justPressed)
					{
						endBullshit(true);
					}
				}

				if(FlxG.mouse.overlaps(nobutt))
				{
					if (FlxG.mouse.justMoved && curSelected != 1)
					{
						curSelected = 1;
						changeItem();
						FlxG.sound.play(Paths.sound('scrollMenu'));
					}
					if(FlxG.mouse.justPressed)
					{
						endBullshit(false);
					}
				}
			}

		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
		
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected > 1)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = 1;

		nobutt.animation.play((curSelected == 1 ? 'highlight' : 'idle'));
		yesbutt.animation.play((curSelected == 0 ? 'highlight' : 'idle'));
	}

	override function beatHit()
	{
		super.beatHit();
	}

	var isEnding:Bool = false;

	function coolStartDeath(?volume:Float = 1):Void
	{
   		if(Paths.fileExists('sounds/gameover/' + chara.goSound + '.ogg', SOUND))
		{
			FlxG.sound.playMusic(Paths.music('gameOver'), 0.2);
			playingDeathSound = true;
			FlxG.sound.play(Paths.sound('gameover/' + chara.goSound), 1, false, null, true, function() {
				if(!isEnding)
				{
					FlxG.sound.music.fadeIn(0.2, 1, 4);
				}
			});
		}
		else
		{
			FlxG.sound.playMusic(Paths.music('gameOver'));
			playingDeathSound = true;
		}
	}

	function endBullshit(thingie:Bool):Void
	{
		isEnding = true;
		FlxTween.tween(tryagain, {alpha: 0}, 0.5, {ease: FlxEase.sineOut});
		FlxTween.tween(yesbutt, {alpha: 0}, 0.5, {ease: FlxEase.sineOut});
		FlxTween.tween(nobutt, {alpha: 0}, 0.5, {ease: FlxEase.sineOut});
		FlxG.sound.music.stop();
		FlxG.sound.play(Paths.music('gameOverEnd'));
		if (thingie)
		{
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					MusicBeatState.resetState();
				});
			});
		}
		else
		{
			PlayState.seenCutscene = false;
			PlayState.chartingMode = false;

			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					WeekData.loadTheFirstEnabledMod();
					if (PlayState.isStoryMode)
						MusicBeatState.switchState(new StoryMenuState());
					else
						MusicBeatState.switchState(new FreeplayState());

					FlxG.sound.playMusic(Paths.music(ClientPrefs.mainmenuMusic));
				});
			});
		}
	}
	
}

class GOCharater extends FlxSprite
{
	var song:String;

	var bg:FlxSprite;
	var text:FlxSprite;
	public var spriteOffset:Array<Float> = [0,0];
	public var goSound:String;

	public function new(x:Float = 0, y:Float = 0, name:String)
	{
		super(x, y);

		var characterPath:String = 'characters/gameover/' + name + '.json';
		var path:String = '';
		#if MODS_ALLOWED
			path = Paths.modFolders(characterPath);
			if (!FileSystem.exists(path)) 
				path = Paths.getPreloadPath(characterPath);
			if (!FileSystem.exists(path))
				path = Paths.getPreloadPath('characters/gameover/bf.json');

			//trace(path + ' Mods_Allowed');
		#else
			path = Paths.getPreloadPath(characterPath);
			if (!Assets.exists(path))
				path = Paths.getPreloadPath('characters/gameover/bf.json');
		#end

		//trace(path);
		
		#if MODS_ALLOWED
		var rawJson = File.getContent(path);
		#else
		var rawJson = Assets.getText(path);
		#end
		var json:GOFile = cast Json.parse(rawJson);

		frames = Paths.getSparrowAtlas(json.image);
		animation.addByPrefix('idle', json.animation, 24, true);
		animation.play('idle');
		antialiasing = ClientPrefs.globalAntialiasing;
		if(json.no_antialiasing) 
			antialiasing = false;

		spriteOffset = json.spriteOffset;
		flipX = json.flip_x;
		setGraphicSize(Std.int(width * json.scale));
		updateHitbox();

		var soundArray:Array<GOSound> = json.goSound;
		var theArrayofAllTime:Array<String> = [];
		var chara:String = (!PlayState.instance.opponentPlay ? PlayState.instance.dad.curCharacter : PlayState.instance.boyfriend.curCharacter);

		for (sound in soundArray) {
			if (sound.opponent == '' || sound.opponent == chara)
				theArrayofAllTime.push(sound.sound);
		}
		goSound = theArrayofAllTime[FlxG.random.int(0, theArrayofAllTime.length - 1)];
		//trace(goSound);
	}
}
