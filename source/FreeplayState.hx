package;

import options.OptionsState;
#if desktop
import Discord.DiscordClient;
#end
import WeekData;
import editors.ChartingState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import lime.utils.Assets;
import openfl.utils.Assets as OpenFlAssets;
import sys.FileSystem;
import sys.FileSystem;
import sys.FileSystem;

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	private static var curSelected:Int = 0;
	public var curDifficulty:Int = -1;
	private static var lastDifficultyName:String = '';

	var diffText:FlxText;
	public var previewText:FlxText;
	var helpText:FlxText;

	private var grpSongs:FlxTypedGroup<FMenuItem>;
	private var curPlaying:Bool = false;

	var bg:FlxSprite;
	var char1:FlxSprite;
	var char2:FlxSprite;
	var vinyl:FlxSprite;

	public var acceptInput:Bool = true;

	// changers shit
	public static var instance:FreeplayState;

	override function create()
	{
		FlxG.mouse.visible = ClientPrefs.menuMouse;
		
		persistentUpdate = true;
		PlayState.isStoryMode = false;
		WeekData.reloadWeekFiles(false);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		// for changers
		instance = this;

		for (i in 0...WeekData.weeksList.length)
		{
			if (WeekData.weekIsLocked(WeekData.weeksList[i])) continue;

			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var leSongs:Array<String> = [];
			var leChars:Array<String> = [];

			#if FORCE_DEBUG_VERSION
				FlxG.log.warn('[WD] ${leWeek.weekName} (${leWeek.fileName}) is normally locked, but forcing unlocked due to debug.');
			#else
			if (!leWeek.startUnlocked && !WeekData.weekCompleted.exists(leWeek.fileName))
				continue;
			#end

			for (j in 0...leWeek.songs.length)
			{
				leSongs.push(leWeek.songs[j][0]);
				leChars.push(leWeek.songs[j][1]);
			}

			WeekData.setDirectoryFromWeek(leWeek);
			for (song in leWeek.songs)
			{
				var colors:Array<Int> = song[2];
				if(colors == null || colors.length < 3)
				{
					colors = [146, 113, 253];
				}
				var cSelect:Array<String> = (song[3] != null ? song[3] : ['sour', 'sweet']);
				var theStage:String = (song[4] != null ? song[4] : 'emptystage');
				//trace(cSelect);
				var p1:String = cSelect[0];
				var p2:String = cSelect[1];
				addSong(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2]), [p1, p2], theStage);
			}
		}

		WeekData.loadTheFirstEnabledMod();

		bg = new FlxSprite().loadGraphic(Paths.image('freeplay/stage/emptystage'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		bg.screenCenter();

		char1 = new FlxSprite(-145, 35).loadGraphic(Paths.image('freeplay/chars/sour'));
		char1.antialiasing = ClientPrefs.globalAntialiasing;
		char1.updateHitbox();
		add(char1);
		char2 = new FlxSprite(355, 0).loadGraphic(Paths.image('freeplay/chars/sweet'));
		char2.antialiasing = ClientPrefs.globalAntialiasing;
		char2.updateHitbox();
		char2.flipX = true;
		add(char2);

		var topborders:FlxSprite = new FlxSprite().loadGraphic(Paths.image('freeplay/topborders'));
		topborders.antialiasing = ClientPrefs.globalAntialiasing;
		add(topborders);

		var rightborder:FlxSprite = new FlxSprite(730, 0).loadGraphic(Paths.image('freeplay/rightborder'));
		rightborder.scale.set(1.2, 1.2);
		rightborder.antialiasing = ClientPrefs.globalAntialiasing;
		add(rightborder);

		vinyl = new FlxSprite(984, 206).loadGraphic(Paths.image('freeplay/disk'));
		vinyl.scale.set(1.3, 1.3);
		vinyl.antialiasing = ClientPrefs.globalAntialiasing;
		add(vinyl);

		grpSongs = new FlxTypedGroup<FMenuItem>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			Paths.currentModDirectory = songs[i].folder;
			var songObject:FMenuItem = new FMenuItem(582 - (i * 40), 450, songs[i].songName);
			songObject.ID = i;
			grpSongs.add(songObject);
		}

		WeekData.setDirectoryFromWeek();

		diffText = new FlxText(8, 600, 0, "", 24);
		diffText.setFormat(Paths.font("Krungthep.ttf"), 30, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		diffText.antialiasing = ClientPrefs.globalAntialiasing;
		add(diffText);

		previewText = new FlxText(diffText.x, diffText.y + 35, 0, "PLAYBACK RATE: < " + FlxMath.roundDecimal(ClientPrefs.getGameplaySetting('songspeed', 1), 2) + "x >", 24);
		previewText.setFormat(Paths.font("Krungthep.ttf"), 30, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		previewText.antialiasing = ClientPrefs.globalAntialiasing;
		add(previewText);

		if(curSelected >= songs.length) curSelected = 0;
		if(lastDifficultyName == '')
		{
			lastDifficultyName = CoolUtil.defaultDifficulty;
		}
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));
		
		changeSelection(0, false, true);
		changeDiff();

		var modiOpti:FlxSprite = new FlxSprite(0, 676).loadGraphic(Paths.image('story_menuy/options'));
		modiOpti.antialiasing = ClientPrefs.globalAntialiasing;
		modiOpti.updateHitbox();
		add(modiOpti);

		super.create();
	}

	override function closeSubState() {
		super.closeSubState();
		changeSelection(0, false);
		changeDiff(0);
		persistentUpdate = true;
	}

	//Redundant and might be worth removing but keeping just incase
	public function addSong(songName:String, weekNum:Int, songCharacter:String, color:Int, charaSelect:Array<String>, stage:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter, color, charaSelect, stage));
	}

	var instPlaying:Int = -1;
	public static var vocalTracks:Map<String, FlxSound> = new Map<String, FlxSound>();
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7 && acceptInput)
			FlxG.sound.music.volume += 0.5 * elapsed;

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
		var space = FlxG.keys.justPressed.SPACE;
		var ctrl = FlxG.keys.justPressed.CONTROL;
		var mbutt = FlxG.keys.justPressed.M;

		var shiftMult:Int = 1;
		if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

		if (acceptInput)
		{
			if(songs.length > 1)
			{
				if (upP)
				{
					changeSelection(-shiftMult);
					holdTime = 0;
				}
				if (downP)
				{
					changeSelection(shiftMult);
					holdTime = 0;
				}

				if(controls.UI_DOWN || controls.UI_UP)
				{
					var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
					holdTime += elapsed;
					var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

					if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
					{
						changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
						changeDiff();
					}
				}

				if(ClientPrefs.menuMouse)
				{
					if(FlxG.mouse.wheel != 0)
					{
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.5);
						// Mouse wheel logic goes here, for example zooming in / out:
						if (FlxG.mouse.wheel < 0)
							changeSelection(shiftMult, false);
						else if (FlxG.mouse.wheel > 0)
							changeSelection(-shiftMult, false);		
						changeDiff();
					}

					grpSongs.forEach(function(spr:FMenuItem)
					{
						if(FlxG.mouse.overlaps(spr))
						{
							if(FlxG.mouse.justPressed)
							{
								if (spr.ID != 0)
									changeSelection(spr.ID);
								else
								{
									FlxG.sound.play(Paths.sound('confirmMenu'));
									openSubState(new CharaSelect('freeplay', songs[curSelected].charaSelect[1], songs[curSelected].charaSelect[0], songs[curSelected].songName));
								}
							}
						}
					});
				}
			}

			if (controls.UI_LEFT_P)
				changeDiff(-1);
			else if (controls.UI_RIGHT_P)
				changeDiff(1);
			else if (upP || downP) changeDiff();
			
			if (controls.BACK)
			{
				persistentUpdate = false;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
			}

			if(mbutt)
			{
				persistentUpdate = false;
				openSubState(new GameplayChangersSubState());
			}
			else if(ctrl)
			{
				persistentUpdate = false;
				OptionsState.whichState = 'freeplay';
				LoadingState.loadAndSwitchState(new OptionsState());
			}
			else if(space && allowSelect)
			{
				if(instPlaying != curSelected)
				{
					#if PRELOAD_ALL
					destroyFreeplayVocals();
					FlxG.sound.music.volume = 0;
					Paths.currentModDirectory = songs[curSelected].folder;
					var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
					PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
					if (PlayState.SONG.needsVoices)
					{
						try
						{
							var p1ID:String = PlayState.SONG.player1.split('-')[0];
							var p2ID:String = PlayState.SONG.player2.split('-')[0];
							vocalTracks.set(p1ID, new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song, p1ID)));
							vocalTracks.set(p2ID, new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song, p2ID)));
						}
						catch (e:Dynamic)
						{
							trace(e + ", resorting to Voices.ogg");
							vocalTracks.clear();
							vocalTracks.set("", new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song)));
						}
					}
					else
					{
						vocalTracks.set("", new FlxSound());
					}
					FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7);
					for (vocal in vocalTracks)
					{
						FlxG.sound.list.add(vocal);
						vocal.play();
						vocal.persist = true;
						vocal.looped = true;
						vocal.volume = 0.7;
					}
					instPlaying = curSelected;
					#end
				}
			}
			else if (accepted && allowSelect)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
				openSubState(new CharaSelect('freeplay', songs[curSelected].charaSelect[1], songs[curSelected].charaSelect[0], songs[curSelected].songName));
			}
			else if(controls.RESET)
			{
				persistentUpdate = false;
				var type:String = "";
				openSubState(new ResetScoreSubState(songs[curSelected].songName + type, curDifficulty, songs[curSelected].songCharacter));
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
		}
		super.update(elapsed);
	}

	public function loadSong() {
		persistentUpdate = false;
		var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
		var poop:String = Highscore.formatSong(songLowercase, curDifficulty);

		PlayState.SONG = Song.loadFromJson(poop, songLowercase);
		PlayState.isStoryMode = false;
		PlayState.storyDifficulty = curDifficulty;

		if (FlxG.keys.pressed.SHIFT){
			PlayState.chartingMode = true;
			LoadingState.loadAndSwitchState(new ChartingState());
		}else{
			LoadingState.loadAndSwitchState(new PlayState());
		}

		FlxG.sound.music.volume = 0;
				
		destroyFreeplayVocals();
	}

	public static function destroyFreeplayVocals()
	{
		for (vocal in vocalTracks)
		{
			if (vocal != null)
			{
				vocal.stop();
				vocal.destroy();
			}

			vocal = null;
		}

		vocalTracks.clear();
	}

	var allowSelect:Bool = true;

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficulties.length-1;
		if (curDifficulty >= CoolUtil.difficulties.length)
			curDifficulty = 0;

		lastDifficultyName = CoolUtil.difficulties[curDifficulty];

		Paths.currentModDirectory = songs[curSelected].folder;

		try
		{
			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
			PlayState.storyDifficulty = curDifficulty;
			allowSelect = true;
		}
		catch (e)
		{
			FlxG.log.warn('${songs[curSelected].songName}: Song doesn\'t exist!');
			allowSelect = false;
		}

		diffText.visible = CoolUtil.difficulties.length > 1;
		previewText.visible = ClientPrefs.getGameplaySetting('songspeed', 1) != 1 || CoolUtil.difficulties.length > 1;
		diffText.text = 'DIFFICULTY: < ${CoolUtil.difficultyString()} >';
		previewText.text = "PLAYBACK RATE: " + FlxMath.roundDecimal(ClientPrefs.getGameplaySetting('songspeed', 1), 2) + "x";
	}

	function changeSelection(change:Int = 0, playSound:Bool = true, ?instantScroll:Bool = false)
	{
		if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'));

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		Paths.currentModDirectory = songs[curSelected].folder;
		PlayState.storyWeek = songs[curSelected].week;

		var img = Paths.image('freeplay/stage/' + songs[curSelected].theStage);
		if (img == null) img = Paths.image('freeplay/stage/emptystage');
		bg.loadGraphic(img);

		img = Paths.image('freeplay/chars/' + songs[curSelected].charaSelect[0]);
		char1.loadGraphic(img);
		char1.visible = (img != null);

		img = Paths.image('freeplay/chars/' + songs[curSelected].charaSelect[1]);
		char2.loadGraphic(img);
		char2.visible = (img != null);

		var type:String = "";
		var scrollSpeed:Float = (instantScroll ? 0.01 : 0.3);

		if (change != 0)
		{
			FlxTween.cancelTweensOf(vinyl);
			FlxTween.tween(vinyl, {angle: vinyl.angle + (change == 1 ? 450 : -450)}, 0.4, {ease: FlxEase.quadOut});	
		}
		
		var bullShit:Int = 0;

		for (item in grpSongs.members)
		{
			item.ID = bullShit - curSelected;
			bullShit++;

			FlxTween.cancelTweensOf(item);
			
			if (item.ID >= 0)
				FlxTween.tween(item, {x: 582 + (item.ID * 96), y: 450 + (item.ID * 106)}, scrollSpeed, {ease: FlxEase.circOut});
			else
				FlxTween.tween(item, {x: 582 - (item.ID * 96), y: 450 + (item.ID * 106)}, scrollSpeed, {ease: FlxEase.circOut});

			item.highlighted((item.ID == 0 ? true : false));
		}

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		var diffStr:String = WeekData.getCurrentWeek().difficulties;
		if(diffStr != null) diffStr = diffStr.trim(); //Fuck you HTML5

		if(diffStr != null && diffStr.length > 0)
		{
			var diffs:Array<String> = diffStr.split(',');
			var i:Int = diffs.length - 1;
			while (i > 0)
			{
				if(diffs[i] != null)
				{
					diffs[i] = diffs[i].trim();
					if(diffs[i].length < 1) diffs.remove(diffs[i]);
				}
				--i;
			}

			if(diffs.length > 0 && diffs[0].length > 0)
			{
				CoolUtil.difficulties = diffs;
			}
		}
		
		if(CoolUtil.difficulties.contains(CoolUtil.defaultDifficulty))
		{
			curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(CoolUtil.defaultDifficulty)));
		}
		else
		{
			curDifficulty = 0;
		}

		var newPos:Int = CoolUtil.difficulties.indexOf(lastDifficultyName);
		//trace('Pos of ' + lastDifficultyName + ' is ' + newPos);
		if(newPos > -1)
		{
			curDifficulty = newPos;
		}
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var color:Int = -7179779;
	public var folder:String = "";
	public var charaSelect:Array<String> = ['sour', 'sweet'];
	public var theStage:String = "";

	public function new(song:String, week:Int, songCharacter:String, color:Int, charaSelect:Array<String>, theStage:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.color = color;
		this.folder = Paths.currentModDirectory;
		this.charaSelect = charaSelect;
		this.theStage = theStage;
		if(this.folder == null) this.folder = '';
	}
}

class FMenuItem extends FlxSpriteGroup
{
	var bg:FlxSprite;
	var text:FlxText;

	public function new(x:Float = 0, y:Float = 0, item:String)
	{
		super(x, y);

		bg = new FlxSprite();
		bg.frames = Paths.getSparrowAtlas('freeplay/button');//curSong
		bg.animation.addByPrefix('highlighted', 'button_selected', 24, false);
		bg.animation.addByPrefix('idle', 'button_deselected', 24, false);
		bg.animation.play('idle');
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		text = new FlxText(38, 16, 604, item, 40);
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