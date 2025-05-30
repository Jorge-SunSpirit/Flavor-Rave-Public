package;

import Language.LanguageText;
import options.OptionsState;
#if discord_rpc
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
import haxe.Json;
import achievements.Achievements;
import shaders.ColorSwap;

#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var storySongs:Array<SongMetadata> = [];
	var collabsongs:Array<SongMetadata> = [];
	var bonussongs:Array<SongMetadata> = [];
	var uncategorizedsongs:Array<SongMetadata> = [];

	var selector:LanguageText;
	private static var curSelected:Int = 0;
	public var curDifficulty:Int = -1;
	private static var lastDifficultyName:String = '';

	var diffText:LanguageText;
	public var previewText:LanguageText;
	var helpText:LanguageText;

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

		#if discord_rpc
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

			#if FORCE_DEBUG_VERSION
				FlxG.log.warn('[WD] ${leWeek.weekName} (${leWeek.fileName}) is normally locked, but forcing unlocked due to debug.');
			#else
			if (!leWeek.startUnlocked && !WeekData.weekCompleted.exists(leWeek.fileName))
			{
				continue;
			}
			#end

			for (j in 0...leWeek.songs.length)
			{
				leSongs.push(leWeek.songs[j][0]);
			}

			WeekData.setDirectoryFromWeek(leWeek);
			for (song in leWeek.songs)
			{
				var cSelect:Array<String> = ['sour', 'sweet'];
				var theStage:String = 'emptystage';
				var isOneP:Bool = false;
				var visualname:String = '';
				var selectionHSB:Array<Float> = [0, 0, 0];

				// read the metadata
				var metadata:Metadata = null;
				var hasmeta:Bool = false;

				try
				{
					var rawJson = null;
					#if MODS_ALLOWED
					var moddyFile:String = Paths.modsJson(Paths.formatToSongPath(song[0]) + '/meta');
					if (FileSystem.exists(moddyFile))
						rawJson = File.getContent(moddyFile).trim();
					#end
					if (rawJson == null)
					{
						#if sys
						rawJson = File.getContent(Paths.json(Paths.formatToSongPath(song[0]) + '/meta')).trim();
						#else
						rawJson = Assets.getText(Paths.json(Paths.formatToSongPath(song[0]) + '/meta')).trim();
						#end
					}
		
					while (!rawJson.endsWith("}"))
						rawJson = rawJson.substr(0, rawJson.length - 1);
		
					hasmeta = true;
					metadata = cast Json.parse(rawJson);
					//trace('[${song[0]}] Metadata Found!!!');
				}
				catch (e)
				{
					hasmeta = false;
					//trace('[${song[0]}] Metadata either doesn\'t exist or contains an error!');
				}

				//It crashes workaround will def work!!!
				
				if (hasmeta && metadata.freeplay != null)
				{
					if (metadata.freeplay.characters != null)
						cSelect = metadata.freeplay.characters;
					if (metadata.freeplay.stage != null)
						theStage = metadata.freeplay.stage;
					if (metadata.freeplay.isOnePlayer != null)
						isOneP = metadata.freeplay.isOnePlayer;
					if (metadata.song != null && metadata.song.name != null)
						visualname = metadata.song.name;
					if (metadata.freeplay.selectionHSB != null)
						selectionHSB = metadata.freeplay.selectionHSB;
				}

				var p1:String = cSelect[0];
				var p2:String = cSelect[1];
				addSong(song[0], i, [p1, p2], theStage, isOneP, visualname, selectionHSB, leWeek.categoryType);

				if (Highscore.checkBeaten(song[0], 0) && Highscore.checkSongFC(song[0], 0))
					Achievements.unlockAchievement(song[0] + '-FC');
				if (Highscore.checkBeaten(song[0], 0, 'left') && Highscore.checkSongSideFC(song[0] + '-opponent', 0))
					Achievements.unlockAchievement(song[0] + '-LEFTFC');
				if (Highscore.checkBeaten(song[0], 0, 'right') && Highscore.checkSongSideFC(song[0], 0))
					Achievements.unlockAchievement(song[0] + '-RIGHTFC');
				if (Highscore.checkBeaten("That's a Wrap", 0) && Highscore.checkBeaten("Fubuki", 0)) //I hate my life
					Achievements.unlockAchievement('fullclear');
				if (Highscore.checkBeaten("n0.pressur3.temp", 0))
					Achievements.unlockAchievement('synsunfound');
			}
		}
		WeekData.loadTheFirstEnabledMod();
		Achievements.checkfullclearer();

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

		sortSongs();
		for (i in 0...songs.length)
		{
			var namer:String = (songs[i].visualName != '' ? songs[i].visualName : songs[i].songName);
			Paths.currentModDirectory = songs[i].folder;
			var songObject:FMenuItem = new FMenuItem(582 - (i * 40), 450, namer);
			songObject.ID = i;
			grpSongs.add(songObject);
		}

		WeekData.setDirectoryFromWeek();

		diffText = new LanguageText(8, 600, 0, "", 30, 'krungthep');
		diffText.setStyle(FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(diffText);

		previewText = new LanguageText(diffText.x, diffText.y + 35, 0,
			'${Language.option.get("setting_playback_rate", "Playback Rate").toUpperCase}: < '
			+ FlxMath.roundDecimal(ClientPrefs.getGameplaySetting('songspeed', 1), 2) + "x >", 30, 'krungthep');
		previewText.setStyle(FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
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
	public function addSong(songName:String, weekNum:Int, charaSelect:Array<String>, stage:String, isOnePW:Bool = false, visuName:String = '', hsb:Array<Float>, ?categ:String = '')
	{
		trace(songName + ' ' + categ);
		switch (categ.toLowerCase())
		{
			case 'story':
				storySongs.push(new SongMetadata(songName, weekNum, charaSelect, stage, isOnePW, visuName, hsb));
			case 'collab':
				collabsongs.push(new SongMetadata(songName, weekNum, charaSelect, stage, isOnePW, visuName, hsb));
			case 'extra':
				bonussongs.push(new SongMetadata(songName, weekNum, charaSelect, stage, isOnePW, visuName, hsb));
			default:
				uncategorizedsongs.push(new SongMetadata(songName, weekNum, charaSelect, stage, isOnePW, visuName, hsb));
		}
	}

	public function sortSongs()
	{
		for (i in 0...storySongs.length)
			songs.push(storySongs[i]);

		for (i in 0...collabsongs.length)
			songs.push(collabsongs[i]);

		for (i in 0...bonussongs.length)
			songs.push(bonussongs[i]);

		for (i in 0...uncategorizedsongs.length)
			songs.push(uncategorizedsongs[i]);
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
									openSubState(new CharaSelect('freeplay', songs[curSelected].charaSelect.copy(), songs[curSelected].songName, 0, songs[curSelected].force1P));
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
				openSubState(new CharaSelect('freeplay', songs[curSelected].charaSelect.copy(), songs[curSelected].songName, 0, songs[curSelected].force1P));
			}
			else if(controls.RESET)
			{
				persistentUpdate = false;
				var type:String = "";
				openSubState(new ResetScoreSubState(songs[curSelected].songName + type, curDifficulty));
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
		previewText.text = '${Language.option.get("setting_playback_rate", "Playback Rate").toUpperCase()}: '
			+ FlxMath.roundDecimal(ClientPrefs.getGameplaySetting('songspeed', 1), 2) + "x";
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

			item.highlighted((item.ID == 0 ? true : false), songs[curSelected].hsbArray);
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
	public var visualName:String = "";
	public var week:Int = 0;
	public var folder:String = "";
	public var charaSelect:Array<String> = ['sour', 'sweet'];
	public var theStage:String = "";
	public var force1P:Bool = false;
	public var hsbArray:Array<Float> = [0, 0, 0];

	public function new(song:String, week:Int, charaSelect:Array<String>, theStage:String, force1P:Bool = false, vName:String = '', hsbArray:Array<Float>)
	{
		this.songName = song;
		this.visualName = vName;
		this.week = week;
		this.folder = Paths.currentModDirectory;
		this.charaSelect = charaSelect;
		this.theStage = theStage;
		this.force1P = force1P;
		this.hsbArray = hsbArray;
		if(this.folder == null) this.folder = '';
	}
}

class FMenuItem extends FlxSpriteGroup
{
	var bg:FlxSprite;
	var text:LanguageText;
	public var colorSwap:ColorSwap;

	public function new(x:Float = 0, y:Float = 0, item:String)
	{
		super(x, y);

		colorSwap = new ColorSwap();
		bg = new FlxSprite();
		bg.frames = Paths.getSparrowAtlas('freeplay/button');//curSong
		bg.animation.addByPrefix('highlighted', 'button_selected', 24, false);
		bg.animation.addByPrefix('idle', 'button_deselected', 24, false);
		bg.animation.play('idle');
		bg.shader = colorSwap.shader;
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		text = new LanguageText(38, 16, 604, item, 40, 'krungthep');
		text.setStyle(FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		text.borderSize = 4;
		add(text);
	}

	public function highlighted(bool:Bool, hsb:Array<Float>)
	{
		if (bool)
		{
			bg.animation.play('highlighted');
			colorSwap.hue = hsb[0];
			colorSwap.saturation = hsb[1];
			colorSwap.brightness = hsb[2];
		}
		else
		{
			bg.animation.play('idle');
			colorSwap.hue = 0;
			colorSwap.saturation = 0;
			colorSwap.brightness = 0;
		}
	}
}