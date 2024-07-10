package;

import Conductor.Rating;
import DialogueBoxDreamcast;
import DialogueBoxPsych;
import FunkinLua;
import Note.EventNote;
import Replay.Ana;
import Replay.Analysis;
import Section.SwagSection;
import Song.SwagSong;
import StageData;
import shaders.WiggleEffect.WiggleEffectType;
import animateatlas.AtlasFrameMaker;
import controls.InputMethods;
import editors.CharacterEditorState;
import editors.ChartingState;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.animation.FlxAnimationController;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.graphics.FlxGraphic;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.Lib;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.events.KeyboardEvent;
import openfl.filters.BitmapFilter;
import openfl.utils.Assets as OpenFlAssets;
import window.windowMod.FlxWindowModifier;

using StringTools;
#if discord_rpc
import Discord.DiscordClient;
#end

#if !flash 
import flixel.addons.display.FlxRuntimeShader;
import openfl.filters.ShaderFilter;
#end

#if sys
import sys.FileSystem;
import sys.io.File;
#end

#if VIDEOS_ALLOWED
import hxvlc.flixel.FlxVideo;
#end

class PlayState extends MusicBeatState
{
	public static var STRUM_X = 42;
	public static var STRUM_X_MIDDLESCROLL = -278;

	public static var ratingStuff:Array<Dynamic> = [
		['You Suck!', 0.2], //From 0% to 19%
		['Shit', 0.4], //From 20% to 39%
		['Bad', 0.5], //From 40% to 49%
		['Bruh', 0.6], //From 50% to 59%
		['Meh', 0.69], //From 60% to 68%
		['Nice', 0.7], //69%
		['Good', 0.8], //From 70% to 79%
		['Great', 0.9], //From 80% to 89%
		['Sick!', 1], //From 90% to 99%
		['Perfect!!', 1] //The value on this one isn't used actually, since Perfect is always "1"
	];

	//event variables
	private var isCameraOnForcedPos:Bool = false;

	#if (haxe >= "4.0.0")
	public var boyfriendMap:Map<String, Character> = new Map();
	public var dadMap:Map<String, Character> = new Map();
	public var gfMap:Map<String, Character> = new Map();
	public var extraMap:Map<String, Character> = new Map();
	public var variables:Map<String, Dynamic> = new Map();
	public var modchartTweens:Map<String, FlxTween> = new Map<String, FlxTween>();
	public var modchartSprites:Map<String, ModchartSprite> = new Map<String, ModchartSprite>();
	public var modchartTimers:Map<String, FlxTimer> = new Map<String, FlxTimer>();
	public var modchartSounds:Map<String, FlxSound> = new Map<String, FlxSound>();
	public var modchartTexts:Map<String, ModchartText> = new Map<String, ModchartText>();
	public var modchartSaves:Map<String, FlxSave> = new Map<String, FlxSave>();
	#else
	public var boyfriendMap:Map<String, Character> = new Map<String, Character>();
	public var dadMap:Map<String, Character> = new Map<String, Character>();
	public var gfMap:Map<String, Character> = new Map<String, Character>();
	public var extraMap:Map<String, Character> = new Map<String, Character>();
	public var variables:Map<String, Dynamic> = new Map<String, Dynamic>();
	public var modchartTweens:Map<String, FlxTween> = new Map();
	public var modchartSprites:Map<String, ModchartSprite> = new Map();
	public var modchartTimers:Map<String, FlxTimer> = new Map();
	public var modchartSounds:Map<String, FlxSound> = new Map();
	public var modchartTexts:Map<String, ModchartText> = new Map();
	public var modchartSaves:Map<String, FlxSave> = new Map();
	#end

	public var BF_X:Float = 770;
	public var BF_Y:Float = 100;
	public var DAD_X:Float = 100;
	public var DAD_Y:Float = 100;
	public var GF_X:Float = 400;
	public var GF_Y:Float = 130;
	public var EXTRA_X:Float = 100;
	public var EXTRA_Y:Float = 130;

	public var noteKillOffset:Float = 350;

	public var allowExtra:Bool = false;
	public var boyfriendGroup:FlxSpriteGroup;
	public var dadGroup:FlxSpriteGroup;
	public var gfGroup:FlxSpriteGroup;
	public var extraGroup:FlxSpriteGroup;
	public static var curStage:String = '';
	public static var isPixelStage:Bool = false;
	public static var metadata:Metadata = null;
	public static var hasMetadata:Bool = false;
	public static var SONG:SwagSong = null;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;

	public var spawnTime:Float = 2000;

	// Ability to have separate vocals
	public var vocalTracks:Map<String, FlxSound> = new Map<String, FlxSound>();
	public var vocals(get, never):FlxSound;
	public var separateVocals(get, never):Bool;

	public var dad:Character = null;
	public var gf:Character = null;
	public var boyfriend:Character = null;
	public var extraChar:Character = null;

	public var particleGroup:FlxTypedGroup<FlxSprite>;

	public var notes:FlxTypedGroup<Note>;
	public var unspawnNotes:Array<Note> = [];
	public var eventNotes:Array<EventNote> = [];
	public var speakerNotes:Array<Note> = [];

	private var strumLine:FlxSprite;

	//Handles the new epic mega sexy cam code that i've done
	public var camFollow:FlxPoint;
	public var camFollowPos:FlxObject;
	private static var prevCamFollow:FlxPoint;
	private static var prevCamFollowPos:FlxObject;

	public var grpNoteLanes:FlxTypedGroup<FlxSprite>;
	public var strumLineNotes:FlxTypedGroup<StrumNote>;
	public var opponentStrums:FlxTypedGroup<StrumNote>;
	public var playerStrums:FlxTypedGroup<StrumNote>;
	public var grpNoteSplashes:FlxTypedGroup<NoteSplash>;

	//lil music note group thingy :)))))))))
	public var grpMusicNotes:FlxTypedGroup<FlxSprite>;
	public var cachedNotes:Array<String>;

	public var camZooming:Bool = false;
	public var camZoomingMult:Float = 1;
	public var camZoomingDecay:Float = 1;
	public var camZoomingFreq:Int = 16;
	private var curSong:String = "";
	private var curWeek:WeekData = null;

	public var gfSpeed:Int = 1;
	public var health:Float = 1;
	public var combo:Int = 0;
	public var highestCombo:Int = 0;

	public var flavorHUD:FlavorHUD;
	public var lastSungP1:Character = null;
	public var lastSungP2:Character = null;
	public var prevlastSungP1:Character = null;
	public var prevlastSungP2:Character = null;
	public var songPercent:Float = 0;

	public var ratingsData:Array<Rating> = [];
	public var marvelous:Int = 0;
	public var sicks:Int = 0;
	public var goods:Int = 0;
	public var bads:Int = 0;
	public var shits:Int = 0;
	public var earlys:Int = 0;
	public var lates:Int = 0;

	public static var campaignMarvelous:Int = 0;
	public static var campaignSicks:Int = 0;
	public static var campaignGoods:Int = 0;
	public static var campaignBads:Int = 0;
	public static var campaignShits:Int = 0;
	public static var campaignEarlys:Int = 0;
	public static var campaignLates:Int = 0;

	private var generatedMusic:Bool = false;
	public var endingSong:Bool = false;
	public var startingSong:Bool = true;
	private var updateTime:Bool = true;
	public static var changedDifficulty:Bool = false;
	public static var chartingMode:Bool = false;

	//Gameplay settings
	public var songSpeedTween:FlxTween;
	public var songSpeed(default, set):Float = 1;
	public var songSpeedType:String = "multiplicative";
	public var playbackRate(default, set):Float = 1;	
	public var healthGain:Float = 1;
	public var healthLoss:Float = 1;
	public var instakillOnMiss:Bool = false;
	public var cpuControlled:Bool = false;
	public var practiceMode:Bool = false;
	public var opponentPlay:Bool = false;
	public var disableCharNotes:Bool = false;
	
	public var botplaySine:Float = 0;
	public var botplayTxt:FlxText;

	public var camHUD:FlxCamera;
	public var camGame:FlxCamera;
	public var camOther:FlxCamera;
	public var cameraSpeed:Float = 1;
	public var defcameraSpeed:Float = 1;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];
	var dialogueJson:DialogueFile = null;

	var dreamcastIntro:DreamcastDialogueFile = null;
	var dreamcastEnd:DreamcastDialogueFile = null;

	var titleCard:FlxSprite = new FlxSprite();
	var coriBorder:FlxTypedGroup<CoriandaBorder> = null;
	var playedTitleCard:Bool = false;

	public var happyEnding:Bool = false;

	var heyTimer:Float;

	public var songScore:Int = 0;
	public var songHits:Int = 0;
	public var songMisses:Int = 0;

	public static var campaignScore:Int = 0;
	public static var campaignHits:Int = 0;
	public static var campaignMisses:Int = 0;

	public var accuracy:Float = 0.00;
	public var notesHitArray:Array<Date> = [];
	public var nps:Int = 0;
	public var maxNPS:Int = 0;

	// stores the last judgement object
	public static var lastRating:FlxSprite;
	// stores the last combo sprite object
	public static var lastCombo:FlxSprite;
	// stores the last timing object
	public static var lastTiming:FlxText;
	// stores the last combo score objects in an array
	public static var lastScore:Array<FlxSprite> = [];

	var judgementCounter:FlxText;
	var timingTxtTween:FlxTween;
	var ratingTween:FlxTween;
	var numScoreTween:FlxTween;

	public static var seenCutscene:Bool = false;
	
	// Result screen shit
	public var saveNotes:Array<Dynamic> = [];
	public var saveJudgements:Array<String> = [];
	public var replayAna:Analysis = new Analysis(); // replay analysis
	public static var rep:Replay;
	public static var loadRep:Bool = false;
	public static var inResults:Bool = false;
	public static var isSM:Bool = false;

	public var defaultCamZoom:Float = 1.05;
	var defaultStageZoom:Float = 1.05;

	//Thank you Holofunk dev team. Y'all the gyattest
	var camNoteExtend:Float = 0;
	public var camNoteX:Float = 0;
	public var camNoteY:Float = 0;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;
	private var singAnimations:Array<String> = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];
	private var holdAnimations:Array<String> = ['holdLEFT', 'holdDOWN', 'holdUP', 'holdRIGHT'];

	public var inCutscene:Bool = false;
	public var skipCountdown:Bool = false;
	public var hasTitleCard:Bool = false;
	public var titleCardStep:Int = 1;

	var songLength:Float = 0;

	public var boyfriendCameraOffset:Array<Float> = null;
	public var opponentCameraOffset:Array<Float> = null;
	public var girlfriendCameraOffset:Array<Float> = null;
	public var centerCameraOffset:Array<Float> = null;
	public var cameraBoundaries:Array<Float> = null;

	#if discord_rpc
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	var detailsResultsText:String = "";
	#end

	//Achievement shit
	var keysPressed:Array<Bool> = [];
	var boyfriendIdleTime:Float = 0.0;
	var boyfriendIdled:Bool = false;

	// Lua shit
	public static var instance:PlayState;
	public var luaArray:Array<FunkinLua> = [];
	private var luaDebugGroup:FlxTypedGroup<DebugLuaText>;
	public var introSoundsSuffix:String = '';

	// Debug buttons
	private var debugKeysChart:Array<FlxKey>;
	private var debugKeysCharacter:Array<FlxKey>;

	// Less laggy controls
	private var keysArray:Array<Dynamic>;
	private var controlArray:Array<String>;

	// Check if vocalTracks is longer than 1
	function get_separateVocals():Bool
	{
		var count:Int = 0;

		for (key in vocalTracks.keys())
			count++;

		return count > 1;
	}

	// Either give player track or "" track
	function get_vocals():FlxSound
	{
		var playerTrack:String = opponentPlay ? SONG.player2 : SONG.player1;
		return vocalTracks.get(separateVocals ? playerTrack : "");
	}

	override public function create()
	{
		FlxG.mouse.visible = false;

		playedTitleCard = false; // fixes crashes when ending a song. lol.

		//trace('Playback Rate: ' + playbackRate);
		Paths.clearStoredMemory();

		// for lua
		instance = this;

		debugKeysChart = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));
		debugKeysCharacter = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_2'));
		PauseSubState.songName = null; //Reset to default

		keysArray = [
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_left')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_down')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_up')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_right'))
		];

		controlArray = [
			'NOTE_LEFT',
			'NOTE_DOWN',
			'NOTE_UP',
			'NOTE_RIGHT'
		];

		//Ratings
		ratingsData.push(new Rating('marvelous')); //default rating

		var rating:Rating = new Rating('sick');
		rating.ratingMod = 0.9;
		rating.score = 350;
		rating.noteSplash = true;
		rating.breakCombo = false;
		rating.health = 0.04;
		ratingsData.push(rating);

		var rating:Rating = new Rating('good');
		rating.ratingMod = 0.7;
		rating.score = 200;
		rating.noteSplash = false;
		rating.breakCombo = false;
		rating.health = 0.015;
		ratingsData.push(rating);

		var rating:Rating = new Rating('bad');
		rating.ratingMod = 0.4;
		rating.score = 100;
		rating.noteSplash = false;
		rating.breakCombo = false;
		rating.health = 0;
		ratingsData.push(rating);

		var rating:Rating = new Rating('shit');
		rating.ratingMod = 0;
		rating.score = 50;
		rating.noteSplash = false;
		rating.breakCombo = true;
		rating.health = -0.03;
		ratingsData.push(rating);

		// For the "Just the Two of Us" achievement
		for (i in 0...keysArray.length)
		{
			keysPressed.push(false);
		}

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		// Gameplay settings
		playbackRate = ClientPrefs.getGameplaySetting('songspeed', 1);
		healthGain = ClientPrefs.getGameplaySetting('healthgain', 1);
		healthLoss = ClientPrefs.getGameplaySetting('healthloss', 1);
		instakillOnMiss = ClientPrefs.getGameplaySetting('instakill', false);
		practiceMode = ClientPrefs.getGameplaySetting('practice', false);
		cpuControlled = ClientPrefs.getGameplaySetting('botplay', false);
		opponentPlay = ClientPrefs.getGameplaySetting('opponentplay', false);

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camOther = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camOther.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD, false);
		FlxG.cameras.add(camOther, false);
		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();

		grpMusicNotes = new FlxTypedGroup<FlxSprite>();
		cachedNotes = [];

		FlxG.cameras.setDefaultDrawTarget(camGame, true);
		FRFadeTransition.nextCamera = camOther;

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('cranberry-pop', 'cranberry-pop');

		Conductor.mapBPMChanges(SONG);
		Conductor.bpm = SONG.bpm;

		metadata = null;

		// read the metadata
		try
		{
			var rawJson = null;
		
			#if MODS_ALLOWED
			var moddyFile:String = Paths.modsJson(SONG.id + '/meta');

			if (FileSystem.exists(moddyFile))
			{
				rawJson = File.getContent(moddyFile).trim();
			}
			#end

			if (rawJson == null)
			{
				#if sys
				rawJson = File.getContent(Paths.json(SONG.id + '/meta')).trim();
				#else
				rawJson = Assets.getText(Paths.json(SONG.id + '/meta')).trim();
				#end
			}

			while (!rawJson.endsWith("}"))
				rawJson = rawJson.substr(0, rawJson.length - 1);

			metadata = cast Json.parse(rawJson);
			hasMetadata = true;
		}
		catch (e)
		{
			hasMetadata = false;
			trace('[${SONG.song}] Metadata either doesn\'t exist or contains an error!');
		}

		curWeek = WeekData.getCurrentWeek();
		curSong = hasMetadata ? metadata.song.name : SONG.song;
		titleCardStep = (hasMetadata && metadata.song.titleCardStep != null ? metadata.song.titleCardStep : 1);

		#if discord_rpc
		storyDifficultyText = CoolUtil.difficulties[storyDifficulty];

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
			detailsText = "Story Mode: " + curWeek.weekName;
		else
			detailsText = "Freeplay";

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		// String for when the game is paused
		detailsResultsText = "Results - " + detailsText;
		#end

		curStage = SONG.stage;
		//trace('stage is: ' + curStage);
		if(SONG.stage == null || SONG.stage.length < 1) {
			curStage = 'stage';	
		}
		SONG.stage = curStage;

		var stageData:StageFile = StageData.getStageFile(curStage);
		if(stageData == null) { //Stage couldn't be found, create a dummy stage for preventing a crash
			stageData = {
				directory: "",
				defaultZoom: 0.9,
				isPixelStage: false,

				boyfriend: [770, 100],
				girlfriend: [400, 130],
				opponent: [100, 100],
				extra: [0, 130],
				hide_girlfriend: false,

				shadows: null,
				player_brightness: null,
				shadow_darkness: null,

				camera_boyfriend: [0, 0],
				camera_opponent: [0, 0],
				camera_girlfriend: [0, 0],
				camera_center: [0, 0],
				camera_speed: 1,
				camera_boundaries: null
			};
		}

		defaultStageZoom = stageData.defaultZoom;
		isPixelStage = stageData.isPixelStage;
		BF_X = stageData.boyfriend[0];
		BF_Y = stageData.boyfriend[1];
		GF_X = stageData.girlfriend[0];
		GF_Y = stageData.girlfriend[1];
		DAD_X = stageData.opponent[0];
		DAD_Y = stageData.opponent[1];

		if(stageData.camera_speed != null)
		{
			defcameraSpeed = stageData.camera_speed;
			cameraSpeed = stageData.camera_speed;
		}

		boyfriendCameraOffset = stageData.camera_boyfriend;
		if(boyfriendCameraOffset == null) //Fucks sake should have done it since the start :rolling_eyes:
			boyfriendCameraOffset = [0, 0];

		opponentCameraOffset = stageData.camera_opponent;
		if(opponentCameraOffset == null)
			opponentCameraOffset = [0, 0];

		girlfriendCameraOffset = stageData.camera_girlfriend;
		if(girlfriendCameraOffset == null)
			girlfriendCameraOffset = [0, 0];

		centerCameraOffset = stageData.camera_center;
		if(centerCameraOffset == null)
			centerCameraOffset = [0, 0];

		if(stageData.camera_boundaries != null)
			cameraBoundaries = stageData.camera_boundaries;

		boyfriendGroup = new FlxSpriteGroup(BF_X, BF_Y);
		dadGroup = new FlxSpriteGroup(DAD_X, DAD_Y);
		gfGroup = new FlxSpriteGroup(GF_X, GF_Y);

		allowExtra = hasMetadata && metadata.song.extraCharacter != null && metadata.song.extraCharacter[0];

		if (allowExtra)
		{
			if (stageData.extra != null)
			{
				EXTRA_X = stageData.extra[0];
				EXTRA_Y = stageData.extra[1];
			}

			extraGroup = new FlxSpriteGroup(EXTRA_X, EXTRA_Y);
		}

		defaultCamZoom = defaultStageZoom;

		add(gfGroup); //Needed for blammed lights

		if (allowExtra)
			add(extraGroup);

		add(dadGroup);
		add(boyfriendGroup);

		add(grpMusicNotes);

		#if LUA_ALLOWED
		luaDebugGroup = new FlxTypedGroup<DebugLuaText>();
		luaDebugGroup.cameras = [camOther];
		add(luaDebugGroup);
		#end

		// "GLOBAL" SCRIPTS
		#if LUA_ALLOWED
		var filesPushed:Array<String> = [];
		var foldersToCheck:Array<String> = [Paths.getPreloadPath('scripts/')];

		#if MODS_ALLOWED
		foldersToCheck.insert(0, Paths.mods('scripts/'));
		if(Paths.currentModDirectory != null && Paths.currentModDirectory.length > 0)
			foldersToCheck.insert(0, Paths.mods(Paths.currentModDirectory + '/scripts/'));

		for(mod in Paths.getGlobalMods())
			foldersToCheck.insert(0, Paths.mods(mod + '/scripts/'));
		#end

		for (folder in foldersToCheck)
		{
			if(FileSystem.exists(folder))
			{
				for (file in FileSystem.readDirectory(folder))
				{
					if(file.endsWith('.lua') && !filesPushed.contains(file))
					{
						luaArray.push(new FunkinLua(folder + file));
						filesPushed.push(file);
					}
				}
			}
		}
		#end


		// STAGE SCRIPTS
		#if (MODS_ALLOWED && LUA_ALLOWED)
		var doPush:Bool = false;
		var luaFile:String = 'stages/' + curStage + '.lua';
		if(FileSystem.exists(Paths.modFolders(luaFile))) {
			luaFile = Paths.modFolders(luaFile);
			doPush = true;
		} else {
			luaFile = Paths.getPreloadPath(luaFile);
			if(FileSystem.exists(luaFile)) {
				doPush = true;
			}
		}

		if(doPush)
			luaArray.push(new FunkinLua(luaFile));
		#end

		var gfVersion:String = SONG.gfVersion;
		if(gfVersion == null || gfVersion.length < 1)
		{
			gfVersion = 'gf';
			SONG.gfVersion = gfVersion; //Fix for the Chart Editor
		}

		var shadows:Bool = (stageData.shadows == null) ? false : stageData.shadows;
		var pBright:Float = (stageData.player_brightness == null) ? 1.0 : stageData.player_brightness;
		var sDark:Float = (stageData.shadow_darkness == null) ? 0.5 : stageData.shadow_darkness;

		if (!stageData.hide_girlfriend)
		{
			gf = new Character(0, 0, gfVersion);
			gf.hasShadow = shadows;
			gf.shadowDarkness = sDark;
			gf.color = FlxColor.fromRGBFloat(pBright, pBright, pBright);
			startCharacterPos(gf);
			gf.scrollFactor.set(0.95, 0.95);
			gfGroup.add(gf);
			startCharacterLua(gf.curCharacter);

			Paths.image(gf.noteSplash[0]);
			cachePopUpScore(gf);
		}

		if (allowExtra)
		{
			var isPlayer:Bool = metadata.song.extraCharacter[1];
			extraChar = new Character(0, 0, SONG.player4, isPlayer);
			extraChar.hasShadow = shadows;
			extraChar.shadowDarkness = sDark;
			extraChar.color = FlxColor.fromRGBFloat(pBright, pBright, pBright);
			startCharacterPos(extraChar);
			extraChar.scrollFactor.set(0.95, 0.95);
			extraGroup.add(extraChar);
			startCharacterLua(extraChar.curCharacter);

			if (isPlayer ? !opponentPlay : opponentPlay)
			{
				Paths.image(extraChar.noteSplash[0]);
				cachePopUpScore(extraChar);
			}
		}

		dad = new Character(0, 0, SONG.player2);
		dad.hasShadow = shadows;
		dad.shadowDarkness = sDark;
		dad.color = FlxColor.fromRGBFloat(pBright, pBright, pBright);
		dad.beingControlled = (opponentPlay ? true : false);
		startCharacterPos(dad, true);
		dadGroup.add(dad);
		startCharacterLua(dad.curCharacter);

		boyfriend = new Character(0, 0, SONG.player1, true);
		boyfriend.hasShadow = shadows;
		boyfriend.shadowDarkness = sDark;
		boyfriend.color = FlxColor.fromRGBFloat(pBright, pBright, pBright);
		boyfriend.beingControlled = (opponentPlay ? false : true);
		startCharacterPos(boyfriend);
		boyfriendGroup.add(boyfriend);
		startCharacterLua(boyfriend.curCharacter);

		Paths.image(opponentPlay ? dad.noteSplash[0] : boyfriend.noteSplash[0]);

		var camPos:FlxPoint = new FlxPoint(girlfriendCameraOffset[0], girlfriendCameraOffset[1]);
		if(gf != null)
		{
			camPos.x += gf.getGraphicMidpoint().x + gf.cameraPosition[0];
			camPos.y += gf.getGraphicMidpoint().y + gf.cameraPosition[1];
		}
		else
		{
			camPos.x = centerCameraOffset[0];
			camPos.y = centerCameraOffset[1];
		}

		var file:String = Paths.json(SONG.id + '/dialogue'); //Checks for json/Psych Engine dialogue
		if (OpenFlAssets.exists(file)) {
			dialogueJson = DialogueBoxPsych.parseDialogue(file);
		}

		// Checks for Dreamcast dialogue
		if (hasMetadata && metadata.dialogue != null)
		{
			var file:String = Paths.json(SONG.id + '/' + metadata.dialogue.introDialogue);

			if (OpenFlAssets.exists(file))
				dreamcastIntro = DialogueBoxDreamcast.parseDialogue(file);

			file = Paths.json(SONG.id + '/' + metadata.dialogue.endDialogue);

			if (OpenFlAssets.exists(file))
				dreamcastEnd = DialogueBoxDreamcast.parseDialogue(file);
		}

		var file:String = Paths.txt(SONG.id + '/' + SONG.id + 'Dialogue'); //Checks for vanilla/Senpai dialogue
		if (OpenFlAssets.exists(file)) {
			dialogue = CoolUtil.coolTextFile(file);
		}
		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;
		doof.nextDialogueThing = startNextDialogue;
		doof.skipDialogueThing = skipDialogue;

		Conductor.songPosition = -(countdownTime * 1000) * countdownLoop;

		strumLine = new FlxSprite(ClientPrefs.middleScroll ? STRUM_X_MIDDLESCROLL : STRUM_X, 50).makeGraphic(FlxG.width, 10);
		if(ClientPrefs.downScroll) strumLine.y = FlxG.height - 150;
		strumLine.scrollFactor.set();

		grpNoteLanes = new FlxTypedGroup<FlxSprite>();
		add(grpNoteLanes);

		strumLineNotes = new FlxTypedGroup<StrumNote>();
		add(strumLineNotes);
		add(grpNoteSplashes);

		opponentStrums = new FlxTypedGroup<StrumNote>();
		playerStrums = new FlxTypedGroup<StrumNote>();

		// startCountdown();

		generateSong(SONG.song);

		// After all characters being loaded, it makes then invisible 0.01s later so that the player won't freeze when you change characters
		// add(strumLine);

		camFollow = new FlxPoint();
		camFollowPos = new FlxObject(0, 0, 1, 1);

		snapCamFollowToPos(camPos.x, camPos.y);
		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}
		if (prevCamFollowPos != null)
		{
			camFollowPos = prevCamFollowPos;
			prevCamFollowPos = null;
		}
		add(camFollowPos);

		FlxG.camera.follow(camFollowPos, LOCKON, 1);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow);

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;
		moveCameraSection();

		flavorHUD = new FlavorHUD(boyfriend, dad, hasMetadata ? metadata.song : null);
		flavorHUD.y = FlxG.height * (!ClientPrefs.downScroll ? 0.87 : 0.03);
		flavorHUD.visible = !ClientPrefs.hideHud;
		flavorHUD.alpha = ClientPrefs.healthBarAlpha;
		flavorHUD.screenCenter(X);
		add(flavorHUD);
		lastSungP1 = boyfriend;
		lastSungP2 = dad;
		prevlastSungP1 = boyfriend;
		prevlastSungP2 = dad;

		// do we really need this? i mean ui lua scripts exists.
		judgementCounter = new FlxText(20, 0, FlxG.width,
			"").setFormat(Paths.font("Krungthep.ttf"), 20, FlxColor.WHITE,
				LEFT).setBorderStyle(OUTLINE, FlxColor.BLACK, 2, 2);
		judgementCounter.scrollFactor.set();
		judgementCounter.borderSize = 2;
		judgementCounter.borderQuality = 2;
		judgementCounter.antialiasing = ClientPrefs.globalAntialiasing;
		judgementCounter.screenCenter(Y);
		judgementCounter.visible = (!ClientPrefs.hideHud && ClientPrefs.judgementCounter);
		add(judgementCounter);

		botplayTxt = new FlxText(0, strumLine.y + 32, FlxG.width - 800,
			"BOTPLAY").setFormat(Paths.font("Krungthep.ttf"), 32, FlxColor.WHITE,
				CENTER).setBorderStyle(OUTLINE, FlxColor.BLACK, 2, 2);
		if(!cpuControlled && practiceMode)
		{
			botplayTxt.text = "PRACTICE\nMODE";
			botplayTxt.y -= 16;
		}
		botplayTxt.screenCenter(X);
		botplayTxt.antialiasing = ClientPrefs.globalAntialiasing;
		botplayTxt.visible = cpuControlled || practiceMode;
		add(botplayTxt);

		grpNoteLanes.cameras = [camHUD];
		strumLineNotes.cameras = [camHUD];
		grpNoteSplashes.cameras = [camHUD];
		notes.cameras = [camHUD];
		flavorHUD.cameras = [camHUD];
		judgementCounter.cameras = [camHUD];
		botplayTxt.cameras = [camHUD];
		doof.cameras = [camHUD];

		#if LUA_ALLOWED
		for (notetype in noteTypeMap.keys())
		{
			#if MODS_ALLOWED
			var luaToLoad:String = Paths.modFolders('custom_notetypes/' + notetype + '.lua');
			if(FileSystem.exists(luaToLoad))
			{
				luaArray.push(new FunkinLua(luaToLoad));
			}
			else
			{
				luaToLoad = Paths.getPreloadPath('custom_notetypes/' + notetype + '.lua');
				if(FileSystem.exists(luaToLoad))
				{
					luaArray.push(new FunkinLua(luaToLoad));
				}
			}
			#elseif sys
			var luaToLoad:String = Paths.getPreloadPath('custom_notetypes/' + notetype + '.lua');
			if(OpenFlAssets.exists(luaToLoad))
			{
				luaArray.push(new FunkinLua(luaToLoad));
			}
			#end
		}
		for (event in eventPushedMap.keys())
		{
			#if MODS_ALLOWED
			var luaToLoad:String = Paths.modFolders('custom_events/' + event + '.lua');
			if(FileSystem.exists(luaToLoad))
			{
				luaArray.push(new FunkinLua(luaToLoad));
			}
			else
			{
				luaToLoad = Paths.getPreloadPath('custom_events/' + event + '.lua');
				if(FileSystem.exists(luaToLoad))
				{
					luaArray.push(new FunkinLua(luaToLoad));
				}
			}
			#elseif sys
			var luaToLoad:String = Paths.getPreloadPath('custom_events/' + event + '.lua');
			if(OpenFlAssets.exists(luaToLoad))
			{
				luaArray.push(new FunkinLua(luaToLoad));
			}
			#end
		}
		#end
		noteTypeMap.clear();
		noteTypeMap = null;
		eventPushedMap.clear();
		eventPushedMap = null;

		// SONG SPECIFIC SCRIPTS
		#if LUA_ALLOWED
		var filesPushed:Array<String> = [];
		var foldersToCheck:Array<String> = [Paths.getPreloadPath('data/' + SONG.id + '/')];

		#if MODS_ALLOWED
		foldersToCheck.insert(0, Paths.mods('data/' + SONG.id + '/'));
		if(Paths.currentModDirectory != null && Paths.currentModDirectory.length > 0)
			foldersToCheck.insert(0, Paths.mods(Paths.currentModDirectory + '/data/' + SONG.id + '/'));

		for(mod in Paths.getGlobalMods())
			foldersToCheck.insert(0, Paths.mods(mod + '/data/' + SONG.id + '/' ));// using push instead of insert because these should run after everything else
		#end

		for (folder in foldersToCheck)
		{
			if(FileSystem.exists(folder))
			{
				for (file in FileSystem.readDirectory(folder))
				{
					if(file.endsWith('.lua') && !filesPushed.contains(file))
					{
						luaArray.push(new FunkinLua(folder + file));
						filesPushed.push(file);
					}
				}
			}
		}
		#end

		particleGroup = new FlxTypedGroup<FlxSprite>();
		add(particleGroup);

		if (isStoryMode && !seenCutscene)
		{
			switch (SONG.id)
			{
				default:
				{
					if (dreamcastIntro != null)
						startDreamcastDialogue(dreamcastIntro);
					else
						startCountdown();
				}
			}

			seenCutscene = true;
		}
		else if (!isStoryMode && !seenCutscene)
		{
			switch (SONG.id)
			{
				default:
				{
					if (dreamcastIntro != null && (metadata.control != null && metadata.control.freeplayDialogue))
						startDreamcastDialogue(dreamcastIntro);
					else
						startCountdown();
				}
			}

			seenCutscene = true;
		}
		else
			startCountdown();

		RecalculateRating();

		// PRECACHING THINGS THAT GET USED FREQUENTLY TO AVOID LAGSPIKES
		if (ClientPrefs.hitsoundVolume > 0) Paths.sound('hitsound', true);
		for (i in 1...4) Paths.sound('missnote$i', true);
		Paths.sound('rating-FC', true);

		if (PauseSubState.songName != null) Paths.music(PauseSubState.songName);
		else Paths.music('110th-street');

		#if discord_rpc
		updateRichPresence(false);
		#end

		if (!loadRep) {
			rep = new Replay("na");
		}

		if(!ClientPrefs.controllerMode)
		{
			FlxG.stage.application.window.onKeyDown.add(InputMethods.onKeyDown);
			FlxG.stage.application.window.onKeyUp.add(InputMethods.onKeyRelease);

			//FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			//FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
		}

		// Have to do this here so that it gets cached in cacheCountdown()
		{
			var songIdx:Int = 0;
			for (weekSong in curWeek.songs)
			{
				if (Paths.formatToSongPath(weekSong[0]) == SONG.id)
					break;
				else
					songIdx++;
			}
	
			var charaData:Array<String> = curWeek.songs[songIdx][3];
			chara1 = (curWeek.songs[songIdx][3] != null ? charaData[1] : 'sweet');
			chara2 = (curWeek.songs[songIdx][3] != null ? charaData[0] : 'sour');
		}

		Conductor.safeZoneOffset = (ClientPrefs.safeFrames / 60) * 1000;
		callOnLuas('onCreatePost', []);

		super.create();

		cacheCountdown();
		cachePopUpScore();

		Paths.clearUnusedMemory();

		FRFadeTransition.nextCamera = camOther;
	}

	public function findByTime(time:Float):Array<Dynamic>
	{
		for (i in rep.replay.songNotes)
		{
			// trace('checking ' + Math.round(i[0]) + ' against ' + Math.round(time));
			if (i[0] == time)
				return i;
		}
		return null;
	}

	public function findByTimeIndex(time:Float):Int
	{
		for (i in 0...rep.replay.songNotes.length)
		{
			// trace('checking ' + Math.round(i[0]) + ' against ' + Math.round(time));
			if (rep.replay.songNotes[i][0] == time)
				return i;
		}
		return -1;
	}
	
	#if (!flash && sys)
	public var runtimeShaders:Map<String, Array<String>> = new Map<String, Array<String>>();
	public function createRuntimeShader(name:String):FlxRuntimeShader
	{
		if(!ClientPrefs.shaders) return new FlxRuntimeShader();

		#if (!flash && MODS_ALLOWED && sys)
		if(!runtimeShaders.exists(name) && !initLuaShader(name))
		{
			FlxG.log.warn('Shader $name is missing!');
			return new FlxRuntimeShader();
		}

		var arr:Array<String> = runtimeShaders.get(name);
		return new FlxRuntimeShader(arr[0], arr[1]);
		#else
		FlxG.log.warn("Platform unsupported for Runtime Shaders!");
		return null;
		#end
	}

	public function initLuaShader(name:String, ?glslVersion:Int = 120)
	{
		if(!ClientPrefs.shaders) return false;

		if(runtimeShaders.exists(name))
		{
			FlxG.log.warn('Shader $name was already initialized!');
			return true;
		}

		var foldersToCheck:Array<String> = [Paths.mods('shaders/')];
		if(Paths.currentModDirectory != null && Paths.currentModDirectory.length > 0)
			foldersToCheck.insert(0, Paths.mods(Paths.currentModDirectory + '/shaders/'));

		for(mod in Paths.getGlobalMods())
			foldersToCheck.insert(0, Paths.mods(mod + '/shaders/'));

		foldersToCheck.insert(0, Paths.getPreloadPath('shaders/'));
		
		for (folder in foldersToCheck)
		{
			if(FileSystem.exists(folder))
			{
				var frag:String = folder + name + '.frag';
				var vert:String = folder + name + '.vert';
				var found:Bool = false;
				if(FileSystem.exists(frag))
				{
					frag = File.getContent(frag);
					found = true;
				}
				else frag = null;

				if (FileSystem.exists(vert))
				{
					vert = File.getContent(vert);
					found = true;
				}
				else vert = null;

				if(found)
				{
					runtimeShaders.set(name, [frag, vert]);
					//trace('Found shader $name!');
					return true;
				}
			}
		}
		FlxG.log.warn('Missing shader $name .frag AND .vert files!');
		return false;
	}
	#end

	function set_songSpeed(value:Float):Float
	{
		if(generatedMusic)
		{
			var ratio:Float = value / songSpeed; //funny word huh
			if(ratio != 1)
			{
				for (note in notes) note.resizeByRatio(ratio);
				for (note in unspawnNotes) note.resizeByRatio(ratio);
			}
		}
		songSpeed = value;
		noteKillOffset = 350 / songSpeed;
		return value;
	}

	function set_playbackRate(value:Float):Float
	{
		if(generatedMusic)
		{
			for (vocal in vocalTracks)
			{
				if (vocal != null)
					vocal.pitch = value;
			}
			FlxG.sound.music.pitch = value;
		}
		playbackRate = value;
		FlxG.timeScale = value;

		setOnLuas('playbackRate', playbackRate);
		return value;
	}

	public function addTextToDebug(text:String, color:FlxColor) {
		#if LUA_ALLOWED
		luaDebugGroup.forEachAlive(function(spr:DebugLuaText) {
			spr.y += 20;
		});

		if(luaDebugGroup.members.length > 34) {
			var blah = luaDebugGroup.members[34];
			blah.destroy();
			luaDebugGroup.remove(blah);
		}
		luaDebugGroup.insert(0, new DebugLuaText(text, luaDebugGroup, color));
		#end
	}

	public function reloadHealthBarColors() {
		if (prevlastSungP1 != lastSungP1 || prevlastSungP2 != lastSungP2)
			flavorHUD.reloadHealth(lastSungP1, lastSungP2);
	}

	public function addCharacterToList(newCharacter:String, type:Int) {
		switch(type) {
			case 0:
				if(!boyfriendMap.exists(newCharacter)) {
					var newBoyfriend:Character = new Character(0, 0, newCharacter, true);
					boyfriendMap.set(newCharacter, newBoyfriend);
					boyfriendGroup.add(newBoyfriend);
					startCharacterPos(newBoyfriend);
					newBoyfriend.alpha = 0.00001;
					startCharacterLua(newBoyfriend.curCharacter);
					Paths.image(newBoyfriend.note);

					var baseChar:String = newBoyfriend.curCharacter.split('-')[0];
					if (!cachedNotes.contains(baseChar))
					{
						Paths.image('strumnote/' + baseChar);
						cachedNotes.push(baseChar);
					}

					if (!opponentPlay)
					{
						Paths.image(newBoyfriend.noteSplash[0]);
						cachePopUpScore(newBoyfriend);
					}
				}

			case 1:
				if(!dadMap.exists(newCharacter)) {
					var newDad:Character = new Character(0, 0, newCharacter);
					dadMap.set(newCharacter, newDad);
					dadGroup.add(newDad);
					startCharacterPos(newDad, true);
					newDad.alpha = 0.00001;
					startCharacterLua(newDad.curCharacter);
					Paths.image(newDad.note);

					var baseChar:String = newDad.curCharacter.split('-')[0];
					if (!cachedNotes.contains(baseChar))
					{
						Paths.image('strumnote/' + baseChar);
						cachedNotes.push(baseChar);
					}

					if (opponentPlay)
					{
						Paths.image(newDad.noteSplash[0]);
						cachePopUpScore(newDad);
					}
				}

			case 2:
				if (gf != null && !gfMap.exists(newCharacter))
				{
					var newGf:Character = new Character(0, 0, newCharacter);
					newGf.scrollFactor.set(0.95, 0.95);
					gfMap.set(newCharacter, newGf);
					gfGroup.add(newGf);
					startCharacterPos(newGf);
					newGf.alpha = 0.00001;
					startCharacterLua(newGf.curCharacter);
					Paths.image(newGf.note);

					var baseChar:String = newGf.curCharacter.split('-')[0];
					if (!cachedNotes.contains(baseChar))
					{
						Paths.image('strumnote/' + baseChar);
						cachedNotes.push(baseChar);
					}

					// CACHING!
					Paths.image(newGf.noteSplash[0]);
					cachePopUpScore(newGf);
				}

			case 3:
				if (allowExtra && extraChar != null && !extraMap.exists(newCharacter))
				{
					var isPlayer:Bool = metadata.song.extraCharacter[1];
					var newExtra:Character = new Character(0, 0, newCharacter, isPlayer);
					newExtra.scrollFactor.set(0.95, 0.95);
					extraMap.set(newCharacter, newExtra);
					extraGroup.add(newExtra);
					startCharacterPos(newExtra);
					newExtra.alpha = 0.00001;
					startCharacterLua(newExtra.curCharacter);
					Paths.image(newExtra.note);

					var baseChar:String = newExtra.curCharacter.split('-')[0];
					if (!cachedNotes.contains(baseChar))
					{
						Paths.image('strumnote/' + baseChar);
						cachedNotes.push(baseChar);
					}

					if (isPlayer ? !opponentPlay : opponentPlay)
					{
						Paths.image(newExtra.noteSplash[0]);
						cachePopUpScore(newExtra);
					}
				}
		}
	}

	function startCharacterLua(name:String)
	{
		#if LUA_ALLOWED
		var doPush:Bool = false;
		var luaFile:String = 'characters/' + name + '.lua';
		#if MODS_ALLOWED
		if(FileSystem.exists(Paths.modFolders(luaFile))) {
			luaFile = Paths.modFolders(luaFile);
			doPush = true;
		} else {
			luaFile = Paths.getPreloadPath(luaFile);
			if(FileSystem.exists(luaFile)) {
				doPush = true;
			}
		}
		#else
		luaFile = Paths.getPreloadPath(luaFile);
		if(Assets.exists(luaFile)) {
			doPush = true;
		}
		#end

		if(doPush)
		{
			for (script in luaArray)
			{
				if(script.scriptName == luaFile) return;
			}
			luaArray.push(new FunkinLua(luaFile));
		}
		#end
	}

	// If this doesn't return FlxSprite then everything breaks, so no Dynamic
	public function getLuaObject(tag:String, text:Bool = true):FlxSprite {
		if (modchartSprites.exists(tag)) return modchartSprites.get(tag);
		if (text && modchartTexts.exists(tag)) return modchartTexts.get(tag);
		if (variables.exists(tag)) return variables.get(tag);
		return null;
	}

	function startCharacterPos(char:Character, ?gfCheck:Bool = false) {
		if(gfCheck && char.curCharacter.startsWith('gf')) { //IF DAD IS GIRLFRIEND, HE GOES TO HER POSITION
			char.setPosition(GF_X, GF_Y);
			char.scrollFactor.set(0.95, 0.95);
			char.danceEveryNumBeats = 2;
		}
		char.x += char.positionArray[0];
		char.y += char.positionArray[1];
	}

	public function startVideo(name:String, ?extension:String)
	{
		#if VIDEOS_ALLOWED
		inCutscene = true;

		final filepath:String = Paths.video(name, extension);
		if (#if sys !FileSystem.exists(filepath) #else !OpenFlAssets.exists(filepath) #end)
		{
			FlxG.log.warn('Couldnt find video file: $name');
			startAndEnd();
			return;
		}

		var video:FlxVideo = new FlxVideo();

		video.onEndReached.add(function():Void
		{
			video.dispose();
			startAndEnd();
			return;
		}, true);

		if (video.load(filepath))
		{
			video.play();
		}
		else
		{
			video.dispose();
			startAndEnd();
			return;
		}
		#else
		FlxG.log.warn('Platform not supported!');
		startAndEnd();
		return;
		#end
	}

	function startAndEnd()
	{
		if(endingSong)
			endSong();
		else
			startCountdown();
	}

	var dialogueCount:Int = 0;
	public var psychDialogue:DialogueBoxPsych;
	//You don't have to add a song, just saying. You can just do "startDialogue(dialogueJson);" and it should work
	public function startDialogue(dialogueFile:DialogueFile, ?song:String = null):Void
	{
		// TO DO: Make this more flexible, maybe?
		if(psychDialogue != null) return;

		if(dialogueFile.dialogue.length > 0) {
			inCutscene = true;
			Paths.sound('dialogue');
			Paths.sound('dialogueClose');
			psychDialogue = new DialogueBoxPsych(dialogueFile, song);
			psychDialogue.scrollFactor.set();
			if(endingSong) {
				psychDialogue.finishThing = function() {
					psychDialogue = null;
					endSong();
				}
			} else {
				psychDialogue.finishThing = function() {
					psychDialogue = null;
					startCountdown();
				}
			}
			psychDialogue.nextDialogueThing = startNextDialogue;
			psychDialogue.skipDialogueThing = skipDialogue;
			psychDialogue.cameras = [camHUD];
			add(psychDialogue);
		} else {
			FlxG.log.warn('Your dialogue file is badly formatted!');
			if(endingSong) {
				endSong();
			} else {
				startCountdown();
			}
		}
	}

	public function startDreamcastDialogue(dialogueFile:DreamcastDialogueFile):Void
	{
		if (dialogueFile == null)
		{
			FlxG.log.warn("Your dialogue file doesn't exist!");
			startAndEnd();
			return;
		}

		if (dialogueFile.dialogue.length > 0)
		{
			inCutscene = true;
			flavorHUD.allowScroll = false;
			var dreamcastDialogue:DialogueBoxDreamcast = new DialogueBoxDreamcast(dialogueFile);
			dreamcastDialogue.finishThing = function()
			{
				startAndEnd();
			}
			dreamcastDialogue.nextDialogueThing = startNextDialogue;
			dreamcastDialogue.skipDialogueThing = skipDialogue;
			dreamcastDialogue.cameras = [camHUD];
			add(dreamcastDialogue);
		}
		else
		{
			FlxG.log.warn("Your dialogue file is badly formatted!");
			startAndEnd();
		}
	}

	var startTimer:FlxTimer;
	var finishTimer:FlxTimer = null;

	// For being able to mess with the sprites on Lua
	public var locked:FlxSprite;
	public var andsprite:FlxSprite;
	public var loaded:FlxSprite;
	public var rave:FlxSprite;
	public var player1Box:CDPlayer;
	public var player2Box:CDPlayer;
	public var playerIndicator:FlxText;
	public var chara1:String = 'sweet';
	public var chara2:String = 'sour';
	public var countdownSuffix:String = '';
	public static var startOnTime:Float = 0;

	function cacheCountdown()
	{
		/* Image */
		var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
		introAssets.set('default',
		[
			'countdown/leftbox',
			'countdown/leftbox-mask',
			'countdown/rightbox',
			'countdown/rightbox-mask',
			'countdown/portraits/$chara1',
			'countdown/portraits/$chara2',

			'countdown/locked',
			'countdown/and',
			'countdown/loaded',
			'countdown/rave',

			'countdown/locked' + countdownSuffix,
			'countdown/and' + countdownSuffix,
			'countdown/loaded' + countdownSuffix,
			'countdown/rave' + countdownSuffix
		]);

		for (asset in introAssets.get('default'))
			Paths.image(asset);


		/* Sound */
		Paths.sound('TONALFX_LNL');
		try {Paths.sound('newintroLNL' + countdownSuffix);}
		catch(e) {Paths.sound('newintroLNL');}

		Paths.sound('TONALFX_go');
		try {Paths.sound('newgo' + countdownSuffix);}
		catch(e) {Paths.sound('newgo');}
	}

	private var countdownTime:Float = 0.667;
	private var countdownLoop:Int = 7;

	public function startCountdown():Void
	{
		if(startedCountdown) {
			callOnLuas('onStartCountdown', []);
			return;
		}

		inCutscene = false;
		var ret:Dynamic = callOnLuas('onStartCountdown', [], false);

		if(ret != FunkinLua.Function_Stop) {
			hasTitleCard = Paths.fileExists('images/titlecard/${curSong}.png', IMAGE);

			if (skipCountdown || hasTitleCard || startOnTime > 0) skipArrowStartTween = true;

			generateStaticArrows(0);
			generateStaticArrows(1);
			for (i in 0...playerStrums.length) {
				setOnLuas('defaultPlayerStrumX' + i, playerStrums.members[i].x);
				setOnLuas('defaultPlayerStrumY' + i, playerStrums.members[i].y);
				setOnLuas('defaultPlayerAlpha' + i, playerStrums.members[i].alpha);
			}
			for (i in 0...opponentStrums.length) {
				setOnLuas('defaultOpponentStrumX' + i, opponentStrums.members[i].x);
				setOnLuas('defaultOpponentStrumY' + i, opponentStrums.members[i].y);
				setOnLuas('defaultOpponentAlpha' + i, opponentStrums.members[i].alpha);
				//if(ClientPrefs.middleScroll) opponentStrums.members[i].visible = false;
			}
			
			startedCountdown = true;
			Conductor.songPosition = -(countdownTime * 1000) * countdownLoop;
			setOnLuas('startedCountdown', true);
			callOnLuas('onCountdownStarted', []);

			var swagCounter:Int = 0;

			if(startOnTime < 0) startOnTime = 0;

			if (startOnTime > 0) {
				clearNotesBefore(startOnTime);
				setSongTime(startOnTime - 350);
				return;
			}
			/*
			else if (skipCountdown)
			{
				setSongTime(0);
				return;
			}
			*/

			if (hasTitleCard)
			{
				titleCard = new FlxSprite();
				titleCard.frames = Paths.getSparrowAtlas('titlecard/${curSong}');
				titleCard.animation.addByPrefix('idle', 'card', 24, false);
				titleCard.antialiasing = ClientPrefs.globalAntialiasing;
				titleCard.cameras = [camHUD];
				titleCard.screenCenter();
				titleCard.alpha = 0.001;
				add(titleCard);

				// Hide UI stuff
				for (i in 0...4)
				{
					playerStrums.members[i].alpha = 0.001;
					opponentStrums.members[i].alpha = 0.001;
				}

				flavorHUD.allowScroll = false;
				flavorHUD.alpha = 0.001;
			}
			else
			{
				flavorHUD.allowScroll = true;
			}

			if (skipCountdown)
			{
				Conductor.songPosition = -CoolUtil.calcSectionLength(0.5) * 1000;

				startTimer = new FlxTimer().start(CoolUtil.calcSectionLength(0.25), function(tmr:FlxTimer)
				{
					if (gf != null && tmr.loopsLeft % Math.round(gfSpeed * gf.danceEveryNumBeats) == 0 && gf.animation.curAnim != null && !gf.singing && !gf.stunned)
						gf.dance();

					if (extraChar != null && tmr.loopsLeft % extraChar.danceEveryNumBeats == 0 && extraChar.animation.curAnim != null && !extraChar.singing && !extraChar.stunned)
						extraChar.dance();

					if (tmr.loopsLeft % boyfriend.danceEveryNumBeats == 0 && boyfriend.animation.curAnim != null && !boyfriend.singing && !boyfriend.stunned)
						boyfriend.dance();

					if (tmr.loopsLeft % dad.danceEveryNumBeats == 0 && dad.animation.curAnim != null && !dad.singing && !dad.stunned)
						dad.dance();
				}, 2);
			}
			else
			{
				new FlxTimer().start(countdownTime - 0.575, function(tmr:FlxTimer)
				{
					FlxG.sound.play(Paths.sound('TONALFX_LNL'), 0.6).pitch = playbackRate;
				});

				startTimer = new FlxTimer().start(countdownTime, function(tmr:FlxTimer)
				{
					if (gf != null && tmr.loopsLeft % Math.round(gfSpeed * gf.danceEveryNumBeats) == 0 && gf.animation.curAnim != null && !gf.singing && !gf.stunned)
					{
						gf.dance();
					}
					if (tmr.loopsLeft % boyfriend.danceEveryNumBeats == 0 && boyfriend.animation.curAnim != null && !boyfriend.singing && !boyfriend.stunned)
					{
						boyfriend.dance();
					}
					if (tmr.loopsLeft % dad.danceEveryNumBeats == 0 && dad.animation.curAnim != null && !dad.singing && !dad.stunned)
					{
						dad.dance();
					}
					if (extraChar != null && tmr.loopsLeft % extraChar.danceEveryNumBeats == 0 && extraChar.animation.curAnim != null && !extraChar.singing && !extraChar.stunned)
					{
						extraChar.dance();
					}

					switch (swagCounter)
					{
						case 0:
							if (!cpuControlled && !ClientPrefs.middleScroll) {
								playerIndicator = new FlxText(playerStrums.members[0].x, playerStrums.members[0].y + (ClientPrefs.downScroll ? -150 : 150), 450,
								"YOU").setFormat(Paths.font("Krungthep.ttf"), 42, FlxColor.WHITE, CENTER).setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 3, 2);
								playerIndicator.cameras = [camHUD];
								playerIndicator.scrollFactor.set();
								playerIndicator.alpha = 0;
								playerIndicator.antialiasing = ClientPrefs.globalAntialiasing;
								insert(members.indexOf(notes), playerIndicator);
								if (opponentPlay) {
									playerIndicator.setPosition(opponentStrums.members[0].x, opponentStrums.members[0].y + (ClientPrefs.downScroll ? -150 : 150)); 
								}
							}

							player1Box = new CDPlayer(FlxG.width, 0, chara1, true);
							player1Box.cameras = [camHUD];
							add(player1Box);
							player2Box = new CDPlayer(-642, 356, chara2, false);
							player2Box.cameras = [camHUD];
							add(player2Box);

							var img = Paths.image('countdown/locked' + countdownSuffix);
							if (img == null) img = Paths.image('countdown/locked');

							locked = new FlxSprite(-623, 187).loadGraphic(img);
							locked.antialiasing = ClientPrefs.globalAntialiasing;
							locked.cameras = [camHUD];
							add(locked);

							img = Paths.image('countdown/loaded' + countdownSuffix);
							if (img == null) img = Paths.image('countdown/loaded');

							loaded = new FlxSprite(1903, 352).loadGraphic(img);
							loaded.antialiasing = ClientPrefs.globalAntialiasing;
							loaded.cameras = [camHUD];
							add(loaded);

							img = Paths.image('countdown/and' + countdownSuffix);
							if (img == null) img = Paths.image('countdown/and');

							andsprite = new FlxSprite(584, 298).loadGraphic(img);
							andsprite.antialiasing = ClientPrefs.globalAntialiasing;
							andsprite.cameras = [camHUD];
							andsprite.screenCenter();
							andsprite.alpha = 0.001;
							add(andsprite);

							FlxTween.tween(player2Box, {x: 0}, Conductor.crochet / 1000, {ease: FlxEase.cubeInOut});
							FlxTween.tween(player1Box, {x: FlxG.width - player1Box.width}, Conductor.crochet / 1000, {ease: FlxEase.cubeInOut, startDelay: 0.4});

							FlxTween.tween(locked, {x: 42}, Conductor.crochet / 1000, {ease: FlxEase.cubeInOut});
							FlxTween.tween(andsprite, {alpha: 1}, Conductor.crochet / 1000, {ease: FlxEase.cubeInOut, startDelay: 0.28});
							FlxTween.tween(loaded, {x: 622}, Conductor.crochet / 1000, {ease: FlxEase.cubeInOut, startDelay: 0.4});

							var snd;
							{
								try {snd = Paths.sound('newintroLNL' + countdownSuffix);}
								catch(e) {snd = Paths.sound('newintroLNL');}
							}

							FlxG.sound.play(snd, 0.6).pitch = playbackRate;
						case 1:
						case 2:
							new FlxTimer().start(countdownTime - 0.1, function(tmr:FlxTimer)
							{
								FlxG.sound.play(Paths.sound('TONALFX_go'), 0.6).pitch = playbackRate;
							});
						case 3:
							FlxTween.tween(player1Box, {alpha: 0}, Conductor.crochet / 1000, {ease: FlxEase.cubeInOut, onComplete: function(twn:FlxTween)
							{
								remove(player1Box);
								player1Box.destroy();
							}});
							FlxTween.tween(player2Box, {alpha: 0}, Conductor.crochet / 1000, {ease: FlxEase.cubeInOut, onComplete: function(twn:FlxTween)
							{
								remove(player2Box);
								player2Box.destroy();
							}});
							FlxTween.tween(locked, {alpha: 0}, Conductor.crochet / 1000, {ease: FlxEase.cubeInOut, onComplete: function(twn:FlxTween)
							{
								remove(locked);
								locked.destroy();
							}});
							FlxTween.tween(loaded, {alpha: 0}, Conductor.crochet / 1000, {ease: FlxEase.cubeInOut, onComplete: function(twn:FlxTween)
							{
								remove(loaded);
								loaded.destroy();
							}});
							FlxTween.tween(andsprite, {alpha: 0}, Conductor.crochet / 1000, {ease: FlxEase.cubeInOut, onComplete: function(twn:FlxTween)
							{
								remove(andsprite);
								andsprite.destroy();
							}});

							var atlas = Paths.getSparrowAtlas('countdown/rave' + countdownSuffix);
							if (atlas == null) atlas = Paths.getSparrowAtlas('countdown/rave');

							rave = new FlxSprite();
							rave.frames = atlas;
							rave.animation.addByPrefix('idle', 'RaveText', 24, false);
							rave.animation.play('idle');
							rave.setGraphicSize(Std.int(rave.width * 0.9));
							rave.screenCenter();
							rave.cameras = [camHUD];
							rave.antialiasing = ClientPrefs.globalAntialiasing;
							add(rave);

							FlxTween.tween(rave, {alpha: 0}, Conductor.crochet / 1000, {ease: FlxEase.cubeInOut, startDelay: Conductor.crochet / 200, onComplete: function(twn:FlxTween)
							{
								remove(rave);
								rave.destroy();
							}});

							var snd;
							{
								try {snd = Paths.sound('newgo' + countdownSuffix);}
								catch(e) {snd = Paths.sound('newgo');}
							}

							FlxG.sound.play(snd, 0.6).pitch = playbackRate;
						case 4:
					}
	
					notes.forEachAlive(function(note:Note) {
						if(ClientPrefs.opponentStrums || note.recalculatePlayerNote(opponentPlay))
						{
							note.copyAlpha = false;
							note.alpha = note.multAlpha;
							if(ClientPrefs.middleScroll && note.recalculateOpponentNote(opponentPlay)) {
								note.alpha *= 0.35;
							}
						}
					});
					callOnLuas('onCountdownTick', [swagCounter]);
	
					swagCounter += 1;
				}, countdownLoop);
			}
		}
	}

	public function addBehindGF(obj:FlxObject)
	{
		insert(members.indexOf(gfGroup), obj);
	}
	public function addBehindBF(obj:FlxObject)
	{
		insert(members.indexOf(boyfriendGroup), obj);
	}
	public function addBehindDad (obj:FlxObject)
	{
		insert(members.indexOf(dadGroup), obj);
	}

	public function clearNotesBefore(time:Float)
	{
		var i:Int = unspawnNotes.length - 1;
		while (i >= 0) {
			var daNote:Note = unspawnNotes[i];
			if(daNote.strumTime - 350 < time)
			{
				daNote.active = false;
				daNote.visible = false;
				daNote.ignoreNote = true;

				daNote.kill();
				unspawnNotes.remove(daNote);
				daNote.destroy();
			}
			--i;
		}

		i = notes.length - 1;
		while (i >= 0) {
			var daNote:Note = notes.members[i];
			if(daNote.strumTime - 350 < time)
			{
				daNote.active = false;
				daNote.visible = false;
				daNote.ignoreNote = true;

				daNote.kill();
				notes.remove(daNote, true);
				daNote.destroy();
			}
			--i;
		}
	}

	public function updateScore(miss:Bool = false)
	{
		accuracy = CoolUtil.floorDecimal(ratingPercent * 100, 2);
		flavorHUD.score.text = 'Score: $songScore';
		if(!instakillOnMiss || practiceMode) flavorHUD.score.text += ' | Misses: $songMisses';
		if(!cpuControlled && accuracy > 0) flavorHUD.score.text += ' | $accuracy% ($ratingLetter)';

		judgementCounter.text = 'Marvelous: $marvelous\nSicks: $sicks\nGoods: $goods\nBads: $bads\nShits: $shits\nMisses: $songMisses';

		callOnLuas('onUpdateScore', [miss]);
	}

	#if discord_rpc
	public function updateRichPresence(showTime:Bool = true, details:String = null)
	{
		if(details == null) details = detailsText;

		DiscordClient.changePresence(
			details,
			curSong + (CoolUtil.difficulties.length > 1 ? " (" + storyDifficultyText + ")" : ""),
			flavorHUD.iconP2.getCharacter(),
			showTime,
			showTime ? ((songLength - Conductor.songPosition) / playbackRate) - ClientPrefs.noteOffset : null
		);
	}
	#end

	public function setSongTime(time:Float)
	{
		if(time < 0) time = 0;

		FlxG.sound.music.pause();
		for (vocal in vocalTracks)
		{
			vocal.pause();
		}

		FlxG.sound.music.time = time;
		FlxG.sound.music.pitch = playbackRate;
		FlxG.sound.music.play();

		for (vocal in vocalTracks)
		{
			if (Conductor.songPosition <= vocal.length)
			{
				vocal.time = time;
				vocal.pitch = playbackRate;
			}
			vocal.play();
		}

		Conductor.songPosition = time;
		songTime = time;
	}

	function startNextDialogue() {
		dialogueCount++;
		callOnLuas('onNextDialogue', [dialogueCount]);
	}

	function skipDialogue() {
		callOnLuas('onSkipDialogue', [dialogueCount]);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		FlxG.sound.playMusic(Paths.inst(SONG.song), 1, false);
		FlxG.sound.music.pitch = playbackRate;
		FlxG.sound.music.onComplete = finishSong.bind();
		for (vocal in vocalTracks)
		{
			vocal.play();
			vocal.pitch = playbackRate;
		}

		if(startOnTime > 0)
		{
			setSongTime(startOnTime - 500);
		}
		startOnTime = 0;

		if(paused) {
			//trace('Oopsie doopsie! Paused sound');
			FlxG.sound.music.pause();
			for (vocal in vocalTracks)
			{
				vocal.pause();
			}
		}

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		#if discord_rpc
		updateRichPresence();
		#end
		setOnLuas('songLength', songLength);
		callOnLuas('onSongStart', []);

		if (!Main.focused && !cpuControlled && canPause && !paused && !ClientPrefs.autoPause)
		{
			openPauseMenu();
		}
	}

	var debugNum:Int = 0;
	private var noteTypeMap:Map<String, Bool> = new Map<String, Bool>();
	private var eventPushedMap:Map<String, Bool> = new Map<String, Bool>();
	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());
		songSpeedType = ClientPrefs.getGameplaySetting('scrolltype','multiplicative');

		switch(songSpeedType)
		{
			case "multiplicative":
				songSpeed = (SONG.speed * ClientPrefs.getGameplaySetting('scrollspeed', 1)) / playbackRate;
			case "constant":
				songSpeed = ClientPrefs.getGameplaySetting('scrollspeed', 1);
		}

		var songData = SONG;
		Conductor.bpm = songData.bpm;

		if (hasMetadata && metadata.control != null)
			happyEnding = metadata.control.happyEnding;

		if (SONG.needsVoices)
		{
			try
			{
				vocalTracks.set(SONG.player1, new FlxSound().loadEmbedded(Paths.voices(SONG.song, SONG.player1.split('-')[0])));
				vocalTracks.set(SONG.player2, new FlxSound().loadEmbedded(Paths.voices(SONG.song, SONG.player2.split('-')[0])));
			}
			catch (e)
			{
				trace(e + ", resorting to Voices.ogg");
				vocalTracks.clear();
				vocalTracks.set("", new FlxSound().loadEmbedded(Paths.voices(SONG.song)));
			}
		}
		else
		{
			vocalTracks.set("", new FlxSound());
		}

		for (vocal in vocalTracks)
		{
			vocal.pitch = playbackRate;
			FlxG.sound.list.add(vocal);
		}

		FlxG.sound.list.add(new FlxSound().loadEmbedded(Paths.inst(SONG.song)));

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped

		var file:String = Paths.json(SONG.id + '/events');
		#if MODS_ALLOWED
		if (FileSystem.exists(Paths.modsJson(SONG.id + '/events')) || FileSystem.exists(file)) {
		#else
		if (OpenFlAssets.exists(file)) {
		#end
			var eventsData:Array<Dynamic> = Song.loadFromJson('events', SONG.id).events;
			for (event in eventsData) //Event Notes
			{
				for (i in 0...event[1].length)
				{
					var newEventNote:Array<Dynamic> = [event[0], event[1][i][0], event[1][i][1], event[1][i][2]];
					var subEvent:EventNote = {
						strumTime: (newEventNote[0] + ClientPrefs.noteOffset),
						event: newEventNote[1],
						value1: newEventNote[2],
						value2: newEventNote[3]
					};
					subEvent.strumTime -= eventNoteEarlyTrigger(subEvent);
					eventNotes.push(subEvent);
					eventPushed(subEvent);
				}
			}
		}

		//Speaker Chart
		var file:String = Paths.json(SONG.id + '/speaker');
		#if MODS_ALLOWED
		if (FileSystem.exists(Paths.modsJson(SONG.id + '/speaker')) || FileSystem.exists(file)) {
		#else
		if (OpenFlAssets.exists(file)) {
		#end
			var speakerData:Array<SwagSection> = Song.loadFromJson('speaker', SONG.id).notes;
			for (section in speakerData) //Speaker Chart Notes
			{
				for (songNotes in section.sectionNotes)
					{
						var daStrumTime:Float = songNotes[0];
						var daNoteData:Int = Std.int(songNotes[1] % 4);
		
						var gottaHitNote:Bool = section.mustHitSection;
		
						if(songNotes[1] > 3) {
							gottaHitNote = !section.mustHitSection;
						}
		
						var oldNote:Note;
						if(speakerNotes.length > 0) {
							oldNote = speakerNotes[Std.int(speakerNotes.length - 1)];
						}
						else {
							oldNote = null;
						}
		
						var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
		
						if (boyfriend.note != null || dad.note != null)
							swagNote.texture = (gottaHitNote ? boyfriend.note : dad.note);
		
						swagNote.scrollFactor.set();
						swagNote.mustPress = gottaHitNote;
						swagNote.sustainLength = songNotes[2];
						swagNote.gfNote = (section.gfSection && (songNotes[1]<4));
						swagNote.extraCharNote = (section.extraCharSection && (songNotes[1]<4));
						swagNote.noteType = songNotes[3];
		
						if(!Std.isOfType(songNotes[3], String)) swagNote.noteType = editors.ChartingState.noteTypeList[songNotes[3]]; //Backward compatibility + compatibility with Week 7 charts
						
						var susLength:Float = swagNote.sustainLength;
						susLength = susLength / Conductor.stepCrochet;
						
						if(susLength > 0) {
							swagNote.isParent = true;
						}
		
						speakerNotes.push(swagNote);
		
						var type:Int = 0;
						var floorSus:Int = Math.floor(susLength);
						if(floorSus > 0) {
							for (susNote in 0...floorSus+1)
							{
								oldNote = speakerNotes[Std.int(speakerNotes.length - 1)];
		
								var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + (Conductor.stepCrochet / FlxMath.roundDecimal(songSpeed, 2)), daNoteData, oldNote, true);
								sustainNote.texture = (gottaHitNote ? boyfriend.note : dad.note);
								sustainNote.scrollFactor.set();
								sustainNote.mustPress = gottaHitNote;
								sustainNote.gfNote = (section.gfSection && (songNotes[1]<4));
								sustainNote.extraCharNote = (section.extraCharSection && (songNotes[1]<4));
								sustainNote.noteType = swagNote.noteType;
								speakerNotes.push(sustainNote);
		
								if(sustainNote.mustPress) { // general offset
									sustainNote.x += FlxG.width / 2;
								}
								else if(ClientPrefs.middleScroll) {
									sustainNote.x += 310;
									if(daNoteData > 1) { //Up and Right
										sustainNote.x += FlxG.width / 2 + 25;
									}
								}
		
								sustainNote.parent = swagNote;
								swagNote.children.push(sustainNote);
								sustainNote.spotInLine = type;
								type++;
							}
						}
		
						if(swagNote.mustPress) {
							swagNote.x += FlxG.width / 2; // general offset
						}
						else if(ClientPrefs.middleScroll) {
							swagNote.x += 310;
							if(daNoteData > 1) { //Up and Right 
								swagNote.x += FlxG.width / 2 + 25;
							}
						}
		
						if(!noteTypeMap.exists(swagNote.noteType)) {
							noteTypeMap.set(swagNote.noteType, true);
						}
					}
			}
		}

		for (section in noteData)
		{
			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if(songNotes[1] > 3) {
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if(unspawnNotes.length > 0) {
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				}
				else {
					oldNote = null;
				}

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);

				if (boyfriend.note != null || dad.note != null)
				swagNote.texture = (gottaHitNote ? boyfriend.note : dad.note);

				swagNote.scrollFactor.set();
				swagNote.mustPress = gottaHitNote;
				swagNote.sustainLength = songNotes[2];
				swagNote.gfNote = (section.gfSection && (songNotes[1]<4));
				swagNote.extraCharNote = (section.extraCharSection && (songNotes[1]<4));
				swagNote.noteType = songNotes[3];

				if(!Std.isOfType(songNotes[3], String)) swagNote.noteType = editors.ChartingState.noteTypeList[songNotes[3]]; //Backward compatibility + compatibility with Week 7 charts
				
				var susLength:Float = swagNote.sustainLength;
				susLength = susLength / Conductor.stepCrochet;
				
				if(susLength > 0) {
					swagNote.isParent = true;
				}

				unspawnNotes.push(swagNote);

				var type:Int = 0;
				var floorSus:Int = Math.floor(susLength);
				if(floorSus > 0) {
					for (susNote in 0...floorSus+1)
					{
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

						var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + (Conductor.stepCrochet / FlxMath.roundDecimal(songSpeed, 2)), daNoteData, oldNote, true);
						sustainNote.texture = (gottaHitNote ? boyfriend.note : dad.note);
						sustainNote.scrollFactor.set();
						sustainNote.mustPress = gottaHitNote;
						sustainNote.gfNote = (section.gfSection && (songNotes[1]<4));
						sustainNote.extraCharNote = (section.extraCharSection && (songNotes[1]<4));
						sustainNote.noteType = swagNote.noteType;
						unspawnNotes.push(sustainNote);

						if(sustainNote.mustPress) { // general offset
							sustainNote.x += FlxG.width / 2;
						}
						else if(ClientPrefs.middleScroll) {
							sustainNote.x += 310;
							if(daNoteData > 1) { //Up and Right
								sustainNote.x += FlxG.width / 2 + 25;
							}
						}

						sustainNote.parent = swagNote;
						swagNote.children.push(sustainNote);
						sustainNote.spotInLine = type;
						type++;
					}
				}

				if(swagNote.mustPress) {
					swagNote.x += FlxG.width / 2; // general offset
				}
				else if(ClientPrefs.middleScroll) {
					swagNote.x += 310;
					if(daNoteData > 1) { //Up and Right 
						swagNote.x += FlxG.width / 2 + 25;
					}
				}

				if(!noteTypeMap.exists(swagNote.noteType)) {
					noteTypeMap.set(swagNote.noteType, true);
				}
			}
			daBeats += 1;
		}
		for (event in songData.events) //Event Notes
		{
			for (i in 0...event[1].length)
			{
				var newEventNote:Array<Dynamic> = [event[0], event[1][i][0], event[1][i][1], event[1][i][2]];
				var subEvent:EventNote = {
					strumTime: (newEventNote[0] + ClientPrefs.noteOffset),
					event: newEventNote[1],
					value1: newEventNote[2],
					value2: newEventNote[3]
				};
				subEvent.strumTime -= eventNoteEarlyTrigger(subEvent);
				eventNotes.push(subEvent);
				eventPushed(subEvent);
			}
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);
		if(eventNotes.length > 1) { //No need to sort if there's a single one or none at all
			eventNotes.sort(sortByTime);
		}
		if(speakerNotes.length > 1) { 
			speakerNotes.sort(sortByShit);
		}
		checkEventNote();
		checkSpeakerNote();
		generatedMusic = true;
	}

	function eventPushed(event:EventNote) {
		switch(event.event) {
			case 'Change Character':
				var charType:Int = 0;
				switch (event.value1.toLowerCase())
				{
					case 'extra' | 'extrachar':
						charType = 3;
					case 'gf' | 'girlfriend':
						charType = 2;
					case 'dad' | 'opponent':
						charType = 1;
					default:
						charType = Std.parseInt(event.value1);
						if (Math.isNaN(charType)) charType = 0;
				}

				var newCharacter:String = event.value2;
				addCharacterToList(newCharacter, charType);

			case 'Change Note Skin' | 'Change Strum Skin':
				if (event.value2 == null || event.value2.length < 1)
					return;

				Paths.image(event.value2);

			case 'Change Ratings':
				var charType:Int = 0;
				switch (event.value1.toLowerCase())
				{
					case 'extra' | 'extrachar':
						charType = 3;
					case 'gf' | 'girlfriend':
						charType = 2;
					case 'dad' | 'opponent':
						charType = 1;
					default:
						charType = Std.parseInt(event.value1);
						if (Math.isNaN(charType)) charType = 0;
				}

				// This is nasty
				var isPlayer:Bool = charType == 0 || charType == 2 || (charType == 3 && metadata.song.extraCharacter[1]);
				var isOpponent:Bool = charType == 1 || charType == 2 || (charType == 3 && !metadata.song.extraCharacter[1]);

				if ((isPlayer && opponentPlay) || (isOpponent && !opponentPlay) || (event.value2 == null || event.value2.length < 1))
					return;

				cachePopUpScore(event.value2);

			case 'Change Note Splash':
				var charType:Int = 0;
				switch (event.value1.toLowerCase())
				{
					case 'extra' | 'extrachar':
						charType = 3;
					case 'gf' | 'girlfriend':
						charType = 2;
					case 'dad' | 'opponent':
						charType = 1;
					default:
						charType = Std.parseInt(event.value1);
						if (Math.isNaN(charType)) charType = 0;
				}

				// So nasty I'm using it here too :)
				var isPlayer:Bool = charType == 0 || charType == 2 || (charType == 3 && metadata.song.extraCharacter[1]);
				var isOpponent:Bool = charType == 1 || charType == 2 || (charType == 3 && !metadata.song.extraCharacter[1]);

				if ((isPlayer && opponentPlay) || (isOpponent && !opponentPlay) || (event.value2 == null || event.value2.length < 1))
					return;

				var splashName:String = event.value2.substr(0, event.value2.indexOf(',')).trim();
				Paths.image(splashName);

			case 'Play SFX':
				Paths.sound(event.value1, true);

			case 'Corianda Border':
				if (coriBorder == null)
				{
					coriBorder = new FlxTypedGroup<CoriandaBorder>();
					coriBorder.cameras = [camHUD];
					for (i in 0...2)
					{
						var border:CoriandaBorder = new CoriandaBorder(i == 0);
						border.y = i == 1 ? (FlxG.width / 2) + 80 : -border.height;
						coriBorder.add(border);
					}
					insert(members.indexOf(strumLineNotes), coriBorder);
				}
		}

		if(!eventPushedMap.exists(event.event)) {
			eventPushedMap.set(event.event, true);
		}
	}

	function eventNoteEarlyTrigger(event:EventNote):Float
	{
		var returnedValue:Float = callOnLuas('eventEarlyTrigger', [event.event]);

		if (returnedValue != 0)
			return returnedValue;

		switch (event.event)
		{
			case 'Change Ratings' | 'Change Note Splash':
				return 10; // Plays 10ms before so that it shows on the next note hit

			case 'Kill Henchmen': // Better timing so that the kill sound matches the beat intended
				return 280; // Plays 280ms before the actual position
		}

		return 0;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	function sortByTime(Obj1:EventNote, Obj2:EventNote):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	public var skipArrowStartTween:Bool = false; //for lua
	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var char:Character = boyfriend;
			var targetAlpha:Float = 1;

			if (player < 1 && ClientPrefs.middleScroll)
				targetAlpha = ClientPrefs.opponentStrums ? 0.35 : 0;

			char = (player == 0 ? dad : boyfriend);

			if (ClientPrefs.middleScroll && opponentPlay)
			{
				char = (player == 0 ? boyfriend : dad);
			}
			
			var babyArrow:StrumNote = new StrumNote(ClientPrefs.middleScroll ? STRUM_X_MIDDLESCROLL : STRUM_X, strumLine.y, i, player, char.note);
			babyArrow.downScroll = ClientPrefs.downScroll;
			if (!isStoryMode && !skipArrowStartTween)
			{
				//babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {/*y: babyArrow.y + 10,*/ alpha: targetAlpha}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}
			else
			{
				babyArrow.alpha = targetAlpha;
			}

			if (player == 1)
			{
				if (opponentPlay && ClientPrefs.middleScroll) opponentStrums.add(babyArrow);
				else playerStrums.add(babyArrow);
			}
			else
			{
				if(ClientPrefs.middleScroll)
				{
					babyArrow.x += 310;
					if(i > 1) { //Up and Right
						babyArrow.x += FlxG.width / 2 + 25;
					}
				}
				if (opponentPlay && ClientPrefs.middleScroll) playerStrums.add(babyArrow);
				else opponentStrums.add(babyArrow);
			}

			grpNoteLanes.add(babyArrow.bgLane);
			strumLineNotes.add(babyArrow);
			babyArrow.postAddedToGroup();
		}
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			FlxG.mouse.visible = ClientPrefs.menuMouse;

			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				for (vocal in vocalTracks)
				{
					vocal.pause();
				}
			}

			if (startTimer != null && !startTimer.finished)
				startTimer.active = false;
			if (finishTimer != null && !finishTimer.finished)
				finishTimer.active = false;
			if (songSpeedTween != null)
				songSpeedTween.active = false;

			var chars:Array<Character> = [boyfriend, gf, dad, extraChar];
			for (char in chars) {
				if(char != null && char.colorTween != null) {
					char.colorTween.active = false;
				}
			}

			for (tween in modchartTweens) {
				tween.active = false;
			}
			for (timer in modchartTimers) {
				timer.active = false;
			}

			FlxG.timeScale = 1;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			FlxG.mouse.visible = false;

			if (FlxG.sound.music != null && !startingSong)
			{
				FlxG.sound.music.time = Conductor.songPosition;
				resyncVocals();
				FlxG.sound.music.play();
				for (vocal in vocalTracks)
				{
					vocal.play();
				}
			}

			if (startTimer != null && !startTimer.finished)
				startTimer.active = true;
			if (finishTimer != null && !finishTimer.finished)
				finishTimer.active = true;
			if (songSpeedTween != null)
				songSpeedTween.active = true;

			var chars:Array<Character> = [boyfriend, gf, dad, extraChar];
			for (char in chars) {
				if(char != null && char.colorTween != null) {
					char.colorTween.active = true;
				}
			}

			for (tween in modchartTweens) {
				tween.active = true;
			}
			for (timer in modchartTimers) {
				timer.active = true;
			}
			paused = false;
			callOnLuas('onResume', []);

			#if discord_rpc
			updateRichPresence(startTimer != null && startTimer.finished);
			#end

			FlxG.timeScale = playbackRate;
		}

		super.closeSubState();
	}

	override public function onFocus():Void
	{
		#if discord_rpc
		if (health > 0 && !paused)
			updateRichPresence(Conductor.songPosition > 0.0);
		#end

		super.onFocus();
	}

	override public function onFocusLost():Void
	{
		if (!cpuControlled && !startingSong && canPause && !paused && !ClientPrefs.autoPause)
		{
			openPauseMenu();
		}

		#if discord_rpc
		if (health > 0 && !paused && ClientPrefs.autoPause)
			updateRichPresence(false, detailsPausedText);
		#end

		super.onFocusLost();
	}

	function resyncVocals():Void
	{
		if (_exiting || finishTimer != null) return;

		FlxG.sound.music.pitch = playbackRate;
		for (vocal in vocalTracks)
		{
			if (FlxG.sound.music.time <= vocal.length)
			{
				vocal.time = FlxG.sound.music.time;
				vocal.pitch = playbackRate;
			}
		}
	}

	public var paused:Bool = false;
	public var canReset:Bool = true;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var limoSpeed:Float = 0;

	var prevMusicTime:Float = 0;

	override public function update(elapsed:Float)
	{
		#if SONG_ROLLBACK
		if (ClientPrefs.songRollback && FlxG.sound.music.playing && elapsed >= FlxG.maxElapsed)
		{
			FlxG.log.add('Game stalled for 1/10 of a second or more, rolling back');
			FlxG.sound.music.time = Conductor.songPosition;
			resyncVocals();
			elapsed = 0;
			return;
		}
		#end

		callOnLuas('onUpdate', [elapsed]);

		if (!endingSong)
		{
			if (startedCountdown)
			{
				if (FlxG.sound.music.time == prevMusicTime || startingSong)
				{
					Conductor.songPosition += elapsed * 1000;
				}
				else
				{
					Conductor.songPosition = FlxG.sound.music.time;
					prevMusicTime = Conductor.songPosition;
				}
			}

			if (startingSong)
			{
				if (startedCountdown && Conductor.songPosition >= 0)
					startSong();
				else if (!startedCountdown)
					Conductor.songPosition = -(countdownTime * 1000) * countdownLoop;
			}
			else
			{
				if (!paused)
				{
					for (vocal in vocalTracks)
					{
						if (FlxG.sound.music.time <= vocal.length && Math.abs(vocal.time - FlxG.sound.music.time) >= (20 * playbackRate))
						{
							FlxG.log.add('Vocals resynced at ${FlxStringUtil.formatTime(FlxG.sound.music.time / 1000, true)}');
							resyncVocals();
							break;
						}
					}

					songTime += FlxG.game.ticks - previousFrameTime;
					previousFrameTime = FlxG.game.ticks;

					// Interpolation type beat
					if (Conductor.lastSongPos != Conductor.songPosition)
					{
						songTime = (songTime + Conductor.songPosition) / 2;
						Conductor.lastSongPos = Conductor.songPosition;
					}

					if (updateTime)
					{
						var curTime:Float = Math.max(0, Conductor.songPosition - ClientPrefs.noteOffset);
						songPercent = (curTime / songLength);
					}
				}
			}
		}

		FlxG.watch.addQuick("Current BPM", Conductor.bpm);
		FlxG.watch.addQuick("Current Section", curSection);
		FlxG.watch.addQuick("Current Beat", curBeat);
		FlxG.watch.addQuick("Current Step", curStep);
		FlxG.watch.addQuick('Playback Rate', playbackRate);
		FlxG.watch.addQuick("Note Speed", songSpeed);
		FlxG.watch.addQuick('Song Time', FlxStringUtil.formatTime(FlxG.sound.music.time / 1000, true));
		FlxG.watch.addQuick('Time Left', FlxStringUtil.formatTime(Math.abs(FlxG.sound.music.time - FlxG.sound.music.length) / 1000, true));

		if(!inCutscene) {
			var lerpVal:Float = CoolUtil.boundTo(elapsed * 2.4 * cameraSpeed, 0, 1);
			camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));
			if(!startingSong && !endingSong && boyfriend.animation.curAnim != null && boyfriend.animation.curAnim.name.startsWith('idle')) {
				boyfriendIdleTime += elapsed;
				if(boyfriendIdleTime >= 0.15) { // Kind of a mercy thing for making the achievement easier to get as it's apparently frustrating to some playerss
					boyfriendIdled = true;
				}
			} else {
				boyfriendIdleTime = 0;
			}
		}

		// reverse iterate to remove oldest notes first and not invalidate the iteration
		// stop iteration as soon as a note is not removed
		// all notes should be kept in the correct order and this is optimal, safe to do every frame/update

		var balls = notesHitArray.length - 1;
		while (balls >= 0)
		{
			var cock:Date = notesHitArray[balls];
			if (cock != null && cock.getTime() + 1000 < Date.now().getTime())
				notesHitArray.remove(cock);
			else
				balls = 0;
			balls--;
		}
		nps = notesHitArray.length;
		if (nps > maxNPS)
			maxNPS = nps;

		if (generatedMusic && !endingSong && !ClientPrefs.lowQuality)
			moveCameraSection();

		super.update(elapsed);

		setOnLuas('curDecStep', curDecStep);
		setOnLuas('curDecBeat', curDecBeat);

		if(botplayTxt.visible) {
			botplaySine += 180 * elapsed;
			botplayTxt.alpha = 1 - Math.sin((Math.PI * botplaySine) / 180);
		}

		if (controls.PAUSE && startedCountdown && canPause)
		{
			var ret:Dynamic = callOnLuas('onPause', [], false);
			if(ret != FunkinLua.Function_Stop) {
				openPauseMenu();
			}
		}

		if (FlxG.keys.anyJustPressed(debugKeysChart) && !endingSong && !inCutscene && !isStoryMode)
		{
			openChartEditor();
		}

		if (health > 2)
			health = 2;

		if (FlxG.keys.anyJustPressed(debugKeysCharacter) && !endingSong && !inCutscene) {
			FlxG.timeScale = 1;
			persistentUpdate = false;
			paused = true;
			cancelMusicFadeTween();
			MusicBeatState.switchState(new CharacterEditorState(SONG.player2));
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125 * camZoomingDecay), 0, 1));
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125 * camZoomingDecay), 0, 1));
		}

		#if FORCE_DEBUG_VERSION
		if (FlxG.keys.pressed.CONTROL && (FlxG.keys.pressed.I || FlxG.keys.pressed.J || FlxG.keys.pressed.K || FlxG.keys.pressed.L || FlxG.keys.pressed.U))
		{
			isCameraOnForcedPos = !FlxG.keys.pressed.U;

			if (FlxG.keys.pressed.I)
			{
				if (FlxG.keys.pressed.SHIFT)
					camFollow.y += -50;
				else
					camFollow.y += -1;
			}
			else if (FlxG.keys.pressed.K)
			{
				if (FlxG.keys.pressed.SHIFT)
					camFollow.y += 50;
				else
					camFollow.y += 1;
			}

			if (FlxG.keys.pressed.J)
			{
				if (FlxG.keys.pressed.SHIFT)
					camFollow.x += -50;
				else
					camFollow.x += -1;
			}
			else if (FlxG.keys.pressed.L)
			{
				if (FlxG.keys.pressed.SHIFT)
					camFollow.x += 50;
				else
					camFollow.x += 1;
			}
		}

		FlxG.watch.addQuick("camFollow", [camFollow.x, camFollow.y]);
		#end

		// RESET = Quick Game Over Screen
		if (!ClientPrefs.noReset && controls.RESET && canReset && !inCutscene && startedCountdown && !endingSong)
		{
			health = 0;
			trace("RESET = True");
		}
		doDeathCheck();

		if (unspawnNotes[0] != null)
		{
			var time:Float = spawnTime;
			if(songSpeed < 1) time /= songSpeed;
			if(unspawnNotes[0].multSpeed < 1) time /= unspawnNotes[0].multSpeed;

			while (unspawnNotes.length > 0 && unspawnNotes[0].strumTime - Conductor.songPosition < time)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.insert(0, dunceNote);
				dunceNote.spawned=true;
				callOnLuas('onSpawnNote', [notes.members.indexOf(dunceNote), dunceNote.noteData, dunceNote.noteType, dunceNote.isSustainNote]);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			if (!inCutscene) {
				var char:Character = (opponentPlay ? dad : boyfriend);
				if(!cpuControlled) {
					keyShit();
				} else if(char.animation.curAnim != null && char.holdTimer > Conductor.stepCrochet * 0.0011 * char.singDuration && char.animation.curAnim.name.startsWith('sing') && !char.animation.curAnim.name.endsWith('miss')) {
					char.dance();
					//boyfriend.animation.curAnim.finish();
				}
			}

			if(startedCountdown)
			{
				var fakeCrochet:Float = (60 / SONG.bpm) * 1000;
				notes.forEachAlive(function(daNote:Note)
				{
					var strumGroup:FlxTypedGroup<StrumNote> = playerStrums;
					if(!daNote.mustPress) strumGroup = opponentStrums;

					var strumX:Float = strumGroup.members[daNote.noteData].x;
					var strumY:Float = strumGroup.members[daNote.noteData].y;
					var strumAngle:Float = strumGroup.members[daNote.noteData].angle;
					var strumDirection:Float = strumGroup.members[daNote.noteData].direction;
					var strumAlpha:Float = strumGroup.members[daNote.noteData].alpha;
					var strumScroll:Bool = strumGroup.members[daNote.noteData].downScroll;

					strumX += daNote.offsetX;
					strumY += daNote.offsetY;
					strumAngle += daNote.offsetAngle;
					strumAlpha *= daNote.multAlpha;

					if (strumScroll) //Downscroll
					{
						//daNote.y = (strumY + 0.45 * (Conductor.songPosition - daNote.strumTime) * songSpeed);
						daNote.distance = (0.45 * (Conductor.songPosition - daNote.strumTime) * songSpeed * daNote.multSpeed);
					}
					else //Upscroll
					{
						//daNote.y = (strumY - 0.45 * (Conductor.songPosition - daNote.strumTime) * songSpeed);
						daNote.distance = (-0.45 * (Conductor.songPosition - daNote.strumTime) * songSpeed * daNote.multSpeed);
					}

					var angleDir = strumDirection * Math.PI / 180;
					if (daNote.copyAngle)
						daNote.angle = strumDirection - 90 + strumAngle;

					if(daNote.copyAlpha)
						daNote.alpha = strumAlpha;

					if(daNote.copyX)
						daNote.x = strumX + Math.cos(angleDir) * daNote.distance;

					if(daNote.copyY)
					{
						daNote.y = strumY + Math.sin(angleDir) * daNote.distance;

						//Jesus fuck this took me so much mother fucking time AAAAAAAAAA
						if(strumScroll && daNote.isSustainNote)
						{
							if (daNote.isSustainEnd()) {
								daNote.y += 10.5 * (fakeCrochet / 400) * 1.5 * songSpeed + (46 * (songSpeed - 1));
								daNote.y -= 46 * (1 - (fakeCrochet / 600)) * songSpeed;
								if(PlayState.isPixelStage) {
									daNote.y += 8 + (6 - daNote.originalHeightForCalcs) * PlayState.daPixelZoom;
								} else {
									daNote.y -= 19;
								}
							}
							daNote.y += (Note.swagWidth / 2) - (60.5 * (songSpeed - 1));
							daNote.y += 27.5 * ((SONG.bpm / 100) - 1) * (songSpeed - 1);
						}
					}

					if (daNote.recalculateOpponentNote(opponentPlay) && daNote.wasGoodHit && !daNote.hitByOpponent && !daNote.ignoreNote)
					{
						opponentNoteHit(daNote);
					}

					if(!daNote.blockHit && daNote.recalculatePlayerNote(opponentPlay) && cpuControlled && daNote.canBeHit) {
						if(daNote.isSustainNote) {
							if(daNote.canBeHit) {
								goodNoteHit(daNote);
							}
						} else if(daNote.strumTime <= Conductor.songPosition || daNote.isSustainNote) {
							goodNoteHit(daNote);
						}
					}

					var center:Float = strumY + Note.swagWidth / 2;
					if(strumGroup.members[daNote.noteData].sustainReduce && daNote.isSustainNote && (daNote.recalculatePlayerNote(opponentPlay) || !daNote.ignoreNote) &&
						(daNote.recalculateOpponentNote(opponentPlay) || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
					{
						if (strumScroll)
						{
							if(daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= center)
							{
								var swagRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);
								swagRect.height = (center - daNote.y) / daNote.scale.y;
								swagRect.y = daNote.frameHeight - swagRect.height;

								daNote.clipRect = swagRect;
							}
						}
						else
						{
							if (daNote.y + daNote.offset.y * daNote.scale.y <= center)
							{
								var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
								swagRect.y = (center - daNote.y) / daNote.scale.y;
								swagRect.height -= swagRect.y;

								daNote.clipRect = swagRect;
							}
						}
					}

					// Kill extremely late notes and cause misses
					if (Conductor.songPosition > noteKillOffset + daNote.strumTime)
					{
						if (daNote.recalculatePlayerNote(opponentPlay) && !cpuControlled &&!daNote.ignoreNote && !endingSong && (daNote.tooLate || !daNote.wasGoodHit)) {
							noteMiss(daNote);
						}

						daNote.active = false;
						daNote.visible = false;

						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				});
			}
			else
			{
				notes.forEachAlive(function(daNote:Note)
				{
					daNote.canBeHit = false;
					daNote.wasGoodHit = false;
				});
			}
		}
		checkEventNote();
		checkSpeakerNote();

		#if FORCE_DEBUG_VERSION
		if(!endingSong && !startingSong) {
			if (FlxG.keys.justPressed.ONE) {
				KillNotes();
				if (FlxG.sound.music.onComplete != null) FlxG.sound.music.onComplete();
				else finishSong();
			}
			if(FlxG.keys.justPressed.TWO) { //Go 10 seconds into the future :O
				setSongTime(Conductor.songPosition + 10000);
				clearNotesBefore(Conductor.songPosition);
			}
		}
		#end

		setOnLuas('cameraX', camFollowPos.x);
		setOnLuas('cameraY', camFollowPos.y);
		setOnLuas('botPlay', cpuControlled);
		callOnLuas('onUpdatePost', [elapsed]);
	}

	function openResultsScreen()
	{
		persistentUpdate = false;
		persistentDraw = true;
		paused = true;

		if (!cpuControlled && (!isStoryMode && songMisses == 0 || isStoryMode && campaignMisses == 0) && !playedFC)
			ResultsScreenSubState.fullCombo = true;

		ResultsScreenSubState.chara = opponentPlay ? chara2 : chara1;
		openSubState(new ResultsScreenSubState());

		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			inResults = true;
		});

		#if discord_rpc
		updateRichPresence(false, detailsResultsText);
		#end
	}

	function openPauseMenu()
	{
		persistentUpdate = false;
		persistentDraw = true;
		paused = true;

		// 1 / 1000 chance for Gitaroo Man easter egg
		/*if (FlxG.random.bool(0.1))
		{
			// gitaroo man easter egg
			cancelMusicFadeTween();
			MusicBeatState.switchState(new GitarooPause());
			clearSongPitch();
		}
		else {*/
		if(FlxG.sound.music != null) {
			FlxG.sound.music.pause();
			for (vocal in vocalTracks)
			{
				vocal.pause();
			}
		}
		openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		//}

		#if discord_rpc
		updateRichPresence(false, detailsPausedText);
		#end
	}

	function openChartEditor()
	{
		FlxG.timeScale = 1;
		persistentUpdate = false;
		paused = true;
		cancelMusicFadeTween();
		MusicBeatState.switchState(new ChartingState());
		chartingMode = true;

		#if discord_rpc
		DiscordClient.changePresence("Chart Editor", null, null, true);
		#end
	}

	public var isDead:Bool = false; //Don't mess with this on Lua!!!
	function doDeathCheck(?skipHealthCheck:Bool = false) {
		if (((skipHealthCheck && instakillOnMiss) || health <= 0) && !practiceMode && !isDead) 
		{
			var ret:Dynamic = callOnLuas('onGameOver', [], false);
			if(ret != FunkinLua.Function_Stop) {
				boyfriend.stunned = true;

				paused = true;

				for (vocal in vocalTracks)
				{
					vocal.stop();
				}
				FlxG.sound.music.stop();

				persistentUpdate = false;
				persistentDraw = false;
				for (tween in modchartTweens) {
					tween.active = true;
				}
				for (timer in modchartTimers) {
					timer.active = true;
				}

				openSubState(new GameOverSubState(opponentPlay ? chara2 : chara1));

				#if discord_rpc
				updateRichPresence(false, "Outshined - " + detailsText);
				#end
				isDead = true;
				return true;
			}
		}
		return false;
	}

	public function checkEventNote() {
		while(eventNotes.length > 0) {
			var leStrumTime:Float = eventNotes[0].strumTime;
			if(Conductor.songPosition < leStrumTime) {
				break;
			}

			var value1:String = '';
			if(eventNotes[0].value1 != null)
				value1 = eventNotes[0].value1;

			var value2:String = '';
			if(eventNotes[0].value2 != null)
				value2 = eventNotes[0].value2;

			triggerEventNote(eventNotes[0].event, value1, value2);
			eventNotes.shift();
		}
	}

	public function checkSpeakerNote() {
		while(speakerNotes.length > 0) {
			var leStrumTime:Float = speakerNotes[0].strumTime;
			if(Conductor.songPosition < leStrumTime) {
				break;
			}
			
			speakerNoteHit(speakerNotes[0]);
			speakerNotes.shift();
		}
	}

	public function getControl(key:String) {
		var pressed:Bool = Reflect.getProperty(controls, key);
		//trace('Control result: ' + pressed);
		return pressed;
	}

	public function triggerEventNote(eventName:String, value1:String, value2:String) {
		switch(eventName) {
			case 'Force Idle On Beat':
				var val:Null<Int> = Std.parseInt(value1);
				if(val == null) val = 0;

				forceIdleOnBeat = val >= 1 ? true : false;

			case 'Hide Character':
				var charType:Int = 0;
				switch (value1.toLowerCase().trim())
				{
					case 'extra' | 'extrachar':
						charType = 3;
					case 'gf' | 'girlfriend':
						charType = 2;
					case 'dad' | 'opponent':
						charType = 1;
					default:
						charType = Std.parseInt(value1);
						if (Math.isNaN(charType)) charType = 0;
				}

				var val:Null<Int> = Std.parseInt(value2);
				if (val == null) val = 0;

				var charAlpha:Float = val >= 1 ? 0.00001 : 1;

				switch (charType)
				{
					case 0:
						boyfriend.alpha = charAlpha;

					case 1:
						dad.alpha = charAlpha;

					case 2:
						if (gf != null)
							gf.alpha = charAlpha;
					case 3:
						if (extraChar != null)
							extraChar.alpha = charAlpha;
				}
			case 'Hey!':
				var value:Int = 2;
				switch(value1.toLowerCase().trim()) {
					case 'bf' | 'boyfriend' | '0':
						value = 0;
					case 'gf' | 'girlfriend' | '1':
						value = 1;
					case 'dad' | 'opponent' | '2':
						value = 2;
					case 'extra' | 'extrachar' | '3':
						value = 3;
				}

				var time:Float = Std.parseFloat(value2);
				if(Math.isNaN(time) || time <= 0) time = 0.6;
				
				switch (value)
				{
					default:
						boyfriend.playAnim('hey', true);
						boyfriend.specialAnim = true;
						boyfriend.heyTimer = time;
					case 1:
						if (gf != null) 
						{
							gf.playAnim('cheer', true);
							gf.specialAnim = true;
							gf.heyTimer = time;
						}
					case 2:
						dad.playAnim('hey', true);
						dad.specialAnim = true;
						dad.heyTimer = time;
					case 3:
						if (extraChar != null) 
						{
							extraChar.playAnim('cheer', true);
							extraChar.specialAnim = true;
							extraChar.heyTimer = time;
						}
				}

			case 'Set GF Speed':
				var value:Int = Std.parseInt(value1);
				if(Math.isNaN(value) || value < 1) value = 1;
				gfSpeed = value;

			case 'Move Opponent Tween':
				var split:Array<String> = value1.split(',');
				var funX:Float = DAD_X;
				var funY:Float = DAD_Y;
				var val2:Float = Std.parseFloat(value2);
			
				if (Math.isNaN(val2) || val2 == 0)
					val2 = 0.0001;

				if (split[0] != null && split[0].toLowerCase() != 'default')
					funX = Std.parseFloat(split[0].trim());
				if (split[1] != null && split[1].toLowerCase() != 'default')
					funY = Std.parseFloat(split[1].trim());


				FlxTween.cancelTweensOf(dadGroup);
				FlxTween.tween(dadGroup, {x: funX, y: funY}, val2, {ease: FlxEase.circOut});

			case 'Move Boyfriend Tween':
				var split:Array<String> = value1.split(',');
				var funX:Float = BF_X;
				var funY:Float = BF_Y;
				var val2:Float = Std.parseFloat(value2);
			
				if (Math.isNaN(val2) || val2 == 0)
					val2 = 0.0001;

				if (split[0] != null && split[0].toLowerCase() != 'default')
					funX = Std.parseFloat(split[0].trim());
				if (split[1] != null && split[1].toLowerCase() != 'default')
					funY = Std.parseFloat(split[1].trim());


				FlxTween.cancelTweensOf(boyfriendGroup);
				FlxTween.tween(boyfriendGroup, {x: funX, y: funY}, val2, {ease: FlxEase.circOut});
			case 'Change Camera Zoom':
				var val1:Float = Std.parseFloat(value1);
				var val2:Float = Std.parseFloat(value2);

				if (Math.isNaN(val1))
					val1 = defaultStageZoom;

				// if value2 isn't a numerical value, then rely on defaultCamZoom
				if (Math.isNaN(val2))
				{
					var forceBool:Bool = false;
					if (value2 == 'true')
						forceBool = true;
	
					defaultCamZoom = val1;
					if (forceBool)
						FlxG.camera.zoom = val1;
				}
				else
				{
					FlxTween.cancelTweensOf(FlxG.camera.zoom);
					FlxTween.tween(FlxG.camera, {zoom: val1}, val2, {ease: FlxEase.cubeInOut, onComplete:
						function (twn:FlxTween)
						{
							defaultCamZoom = val1;
						}
					});
				}

			case 'Add Camera Zoom':
				if(FlxG.camera.zoom < 1.35) {
					var camZoom:Float = Std.parseFloat(value1);
					var hudZoom:Float = Std.parseFloat(value2);
					if(Math.isNaN(camZoom)) camZoom = 0.015;
					if(Math.isNaN(hudZoom)) hudZoom = 0.03;

					FlxG.camera.zoom += camZoom;
					camHUD.zoom += hudZoom;
				}
			
			case 'Change Camera Bump frequency':
				var val1:Null<Int> = Std.parseInt(value1);
				var val2:Null<Float> = Std.parseFloat(value2);
				if (val1 == null || Math.isNaN(val1)) val1 = 16;
				if (val2 == null || Math.isNaN(val2)) val2 = 1;

				if (val1 > 0 && val1 <= 16) camZoomingFreq = val1;

				camZoomingMult = val2;
				

			case 'Play Animation':
				//trace('Anim to play: ' + value1);
				var char:Character = dad;
				switch(value2.toLowerCase().trim()) {
					case 'bf' | 'boyfriend':
						char = boyfriend;
					case 'gf' | 'girlfriend':
						char = gf;
					case 'extra' | 'extrachar':
						char = extraChar;
					default:
						var val2:Int = Std.parseInt(value2);
						if(Math.isNaN(val2)) val2 = 0;

						switch(val2) {
							case 1: char = boyfriend;
							case 2: char = gf;
							case 3: char = extraChar;
						}
				}

				if (char != null)
				{
					char.playAnim(value1, true);
					char.specialAnim = true;
				}

			case 'Camera Follow Pos':
				if(camFollow != null)
				{
					var val1:Float = Std.parseFloat(value1);
					var val2:Float = Std.parseFloat(value2);
					if(Math.isNaN(val1)) val1 = 0;
					if(Math.isNaN(val2)) val2 = 0;

					isCameraOnForcedPos = false;
					if(!Math.isNaN(Std.parseFloat(value1)) || !Math.isNaN(Std.parseFloat(value2))) {
						camFollow.x = val1;
						camFollow.y = val2;
						isCameraOnForcedPos = true;
					}
				}

			case 'Alt Idle Animation':
				var char:Character = dad;
				switch(value1.toLowerCase().trim()) {
					case 'gf' | 'girlfriend':
						char = gf;
					case 'extra' | 'extraChar':
						char = extraChar;
					case 'boyfriend' | 'bf':
						char = boyfriend;
					default:
						var val:Int = Std.parseInt(value1);
						if(Math.isNaN(val)) val = 0;

						switch(val) {
							case 1: char = boyfriend;
							case 2: char = gf;
							case 3: char = extraChar;
						}
				}

				if (char != null)
				{
					char.idleSuffix = value2;
					char.recalculateDanceIdle();
				}
			
			case 'Toggle Character Trail':
				var char:Character = dad;

				switch(value1.toLowerCase().trim()) {
					case 'gf' | 'girlfriend':
						char = gf;
					case 'extra' | 'extraChar':
						char = extraChar;
					case 'boyfriend' | 'bf':
						char = boyfriend;	
				}

				switch(value2.toLowerCase().trim())
				{
					case 'true':
						if (value1 == null || value1 == '')
						{
							if (gf != null) gf.allowTrail = true;
							if (extraChar != null) extraChar.allowTrail = true;
							dad.allowTrail = true;
							boyfriend.allowTrail = true;
						}
						else
							char.allowTrail = true;
					default:
						if (value1 == null || value1 == '')
							{
								if (gf != null) gf.allowTrail = false;
								if (extraChar != null) extraChar.allowTrail = false;
								dad.allowTrail = false;
								boyfriend.allowTrail = false;
							}
							else
								char.allowTrail = false;
				}

			case 'Screen Shake':
				var valuesArray:Array<String> = [value1, value2];
				var targetsArray:Array<FlxCamera> = [camGame, camHUD];
				for (i in 0...targetsArray.length) {
					var split:Array<String> = valuesArray[i].split(',');
					var duration:Float = 0;
					var intensity:Float = 0;
					if(split[0] != null) duration = Std.parseFloat(split[0].trim());
					if(split[1] != null) intensity = Std.parseFloat(split[1].trim());
					if(Math.isNaN(duration)) duration = 0;
					if(Math.isNaN(intensity)) intensity = 0;

					if(duration > 0 && intensity != 0) {
						targetsArray[i].shake(intensity, duration);
					}
				}


			case 'Change Character':
				var charType:Int = 0;
				switch(value1.toLowerCase().trim()) {
					case 'extra' | 'extraChar':
						charType = 3;
					case 'gf' | 'girlfriend':
						charType = 2;
					case 'dad' | 'opponent':
						charType = 1;
					default:
						charType = Std.parseInt(value1);
						if(Math.isNaN(charType)) charType = 0;
				}

				switch(charType) {
					case 0:
						if(boyfriend.curCharacter != value2) {
							if(!boyfriendMap.exists(value2)) {
								addCharacterToList(value2, charType);
							}

							var lastAlpha:Float = boyfriend.alpha;
							boyfriend.alpha = 0.00001;
							boyfriend = boyfriendMap.get(value2);
							boyfriend.beingControlled = (opponentPlay ? false : true);
							boyfriend.alpha = lastAlpha;
							boyfriend.dance();
							flavorHUD.iconP1.changeIcon(boyfriend.healthIcon);

							for (strum in playerStrums)
							{
								if (strum.texture == boyfriend.note) return;
								strum.texture = boyfriend.note;
							}

							for (note in notes)
								if (note.mustPress && !note.customTexture && noteSkinChangeCharNote) note.texture = (boyfriend.note);

							for (note in unspawnNotes)
								if (note.mustPress && !note.customTexture && noteSkinChangeCharNote) note.texture = (boyfriend.note);
							
							if (healthCharNote)
							{
								prevlastSungP1 = lastSungP1;
								lastSungP1 = boyfriend;
							}
						}
						setOnLuas('boyfriendName', boyfriend.curCharacter);

					case 1:
						if(dad.curCharacter != value2) {
							if(!dadMap.exists(value2)) {
								addCharacterToList(value2, charType);
							}

							var wasGf:Bool = dad.curCharacter.startsWith('gf');
							var lastAlpha:Float = dad.alpha;
							dad.alpha = 0.00001;
							dad = dadMap.get(value2);
							dad.beingControlled = (opponentPlay ? true : false);
							if(!dad.curCharacter.startsWith('gf')) {
								if(wasGf && gf != null) {
									gf.visible = true;
								}
							} else if(gf != null) {
								gf.visible = false;
							}
							dad.alpha = lastAlpha;
							dad.dance();
							flavorHUD.iconP2.changeIcon(dad.healthIcon);

							for (strum in opponentStrums)
							{
								if (strum.texture == dad.note) return;
								strum.texture = dad.note;
							}

							for (note in notes)
								if (!note.mustPress && !note.customTexture && noteSkinChangeCharNote) note.texture = (dad.note);

							for (note in unspawnNotes)
								if (!note.mustPress && !note.customTexture && noteSkinChangeCharNote) note.texture = (dad.note);
						
							if (healthCharNote)
							{
								prevlastSungP2 = lastSungP2;
								lastSungP2 = dad;
							}
						}
						setOnLuas('dadName', dad.curCharacter);

					case 2:
						if(gf != null)
						{
							if(gf.curCharacter != value2)
							{
								if(!gfMap.exists(value2))
								{
									addCharacterToList(value2, charType);
								}

								var lastAlpha:Float = gf.alpha;
								gf.alpha = 0.00001;
								gf = gfMap.get(value2);
								gf.alpha = lastAlpha;
								gf.dance();

								for (note in notes)
									if (note.gfNote && noteSkinChangeCharNote) note.texture = (gf.note);
	
								for (note in unspawnNotes)
									if (note.gfNote  && noteSkinChangeCharNote) note.texture = (gf.note);
							}
							setOnLuas('gfName', gf.curCharacter);
						}
					case 3:
						if(extraChar != null)
						{
							if(extraChar.curCharacter != value2)
							{
								if(!extraMap.exists(value2))
								{
									addCharacterToList(value2, charType);
								}

								var lastAlpha:Float = extraChar.alpha;
								extraChar.alpha = 0.00001;
								extraChar = extraMap.get(value2);
								extraChar.alpha = lastAlpha;
								extraChar.dance();

								for (note in notes)
									if (note.extraCharNote && noteSkinChangeCharNote) note.texture = (extraChar.note);
	
								for (note in unspawnNotes)
									if (note.extraCharNote && noteSkinChangeCharNote) note.texture = (extraChar.note);
							}
							setOnLuas('extraCharName', extraChar.curCharacter);
						}
				}
				reloadHealthBarColors();

			case 'Change Note Skin':
				if (value2 == null || value2.length < 1)
					return;

				var charType:Int = 0;
				switch (value1.toLowerCase().trim())
				{
					case 'dad' | 'opponent':
						charType = 1;
					default:
						charType = Std.parseInt(value1);
						if (Math.isNaN(charType)) charType = 0;
				}

				if (ClientPrefs.noteSkin != 'Default' && (charType == 1 && opponentPlay || charType == 0 && !opponentPlay))
					return;

				switch (charType)
				{
					case 0:
					{
						for (strum in playerStrums)
						{
							if (strum.texture == value2) return;
							strum.texture = value2;
						}

						for (note in notes)
							if (note.mustPress && !note.customTexture) note.texture = (value2);

						for (note in unspawnNotes)
							if (note.mustPress && !note.customTexture) note.texture = (value2);
					}
					case 1:
					{
						for (strum in opponentStrums)
						{
							if (strum.texture == value2) return;
							strum.texture = value2;
						}

						for (note in notes)
							if (!note.mustPress && !note.customTexture) note.texture = (value2);

						for (note in unspawnNotes)
							if (!note.mustPress && !note.customTexture) note.texture = (value2);
					}
				}

			// ookay fuck you too haxe
			case 'Change Strum Skin':
				if (value2 == null || value2.length < 1)
					return;

				var charType:Int = 0;
				switch (value1.toLowerCase().trim())
				{
					case 'dad' | 'opponent':
						charType = 1;
					default:
						charType = Std.parseInt(value1);
						if (Math.isNaN(charType)) charType = 0;
				}

				if (ClientPrefs.noteSkin != 'Default' && (charType == 1 && opponentPlay || charType == 0 && !opponentPlay))
					return;

				switch (charType)
				{
					case 0:
					{
						for (strum in playerStrums)
						{
							if (strum.texture == value2) return;
							strum.texture = value2;
						}
					}
					case 1:
					{
						for (strum in opponentStrums)
						{
							if (strum.texture == value2) return;
							strum.texture = value2;
						}
					}
				}

			case 'Change Ratings':
				var charType:Int = 0;
				switch (value1.toLowerCase().trim())
				{
					case 'extra' | 'extrachar':
						charType = 3;
					case 'gf' | 'girlfriend':
						charType = 2;
					case 'dad' | 'opponent':
						charType = 1;
					default:
						charType = Std.parseInt(value1);
						if (Math.isNaN(charType)) charType = 0;
				}

				// I did it here too? I'm so sorry
				var isPlayer:Bool = charType == 0 || charType == 2 || (charType == 3 && metadata.song.extraCharacter[1]);
				var isOpponent:Bool = charType == 1 || charType == 2 || (charType == 3 && !metadata.song.extraCharacter[1]);

				if ((isPlayer && opponentPlay) || (isOpponent && !opponentPlay) || (value2 == null || value2.length < 1))
					return;

				var char:Character = boyfriend;

				switch (charType)
				{
					case 1:
						char = dad;
					case 2:
						char = gf;
					case 3:
						char = extraChar;
				}

				if (char.ratings_folder != value2)
					char.ratings_folder = value2;

			case 'Change Note Splash':
				var charType:Int = 0;
				switch (value1.toLowerCase().trim())
				{
					case 'extra' | 'extrachar':
						charType = 3;
					case 'gf' | 'girlfriend':
						charType = 2;
					case 'dad' | 'opponent':
						charType = 1;
					default:
						charType = Std.parseInt(value1);
						if (Math.isNaN(charType)) charType = 0;
				}

				var isPlayer:Bool = charType == 0 || charType == 2 || (charType == 3 && metadata.song.extraCharacter[1]);
				var isOpponent:Bool = charType == 1 || charType == 2 || (charType == 3 && !metadata.song.extraCharacter[1]);

				if ((isPlayer && opponentPlay) || (isOpponent && !opponentPlay) || (value2 == null || value2.length < 1))
					return;

				var splashArray:Array<String> = value2.split(',');
				for (data in splashArray) data = data.trim();
				for (float in 1...splashArray.length - 1)
				{
					if (Math.isNaN(float))
						return;
				}

				var char:Character = boyfriend;

				switch (charType)
				{
					case 1:
						char = dad;
					case 2:
						char = gf;
					case 3:
						char = extraChar;
				}

				char.noteSplash = [
					splashArray[0],
					Std.parseFloat(splashArray[1]),
					Std.parseFloat(splashArray[2]),
					Std.parseFloat(splashArray[3]),
					Std.parseFloat(splashArray[4])
				];

			case 'Force BF/DAD on character specific notes':
				//Nikku can use other note skins while still singing
				switch(value1.toLowerCase().trim())
				{
					case 'true' | '1' | 'on':
						disableCharNotes = true;
					default:
						disableCharNotes = false;
				}
			case 'Change Scroll Speed':
				if (songSpeedType == "constant")
					return;
				var val1:Float = Std.parseFloat(value1);
				var val2:Float = Std.parseFloat(value2);
				if(Math.isNaN(val1)) val1 = 1;
				if(Math.isNaN(val2)) val2 = 0;

				var newValue:Float = (SONG.speed * ClientPrefs.getGameplaySetting('scrollspeed', 1) * val1) / playbackRate;

				if(val2 <= 0)
				{
					songSpeed = newValue;
				}
				else
				{
					songSpeedTween = FlxTween.tween(this, {songSpeed: newValue}, val2, {ease: FlxEase.linear, onComplete:
						function (twn:FlxTween)
						{
							songSpeedTween = null;
						}
					});
				}

			case 'Set Property':
				var killMe:Array<String> = value1.split('.');
				if(killMe.length > 1) {
					FunkinLua.setVarInArray(FunkinLua.getPropertyLoopThingWhatever(killMe, true, true), killMe[killMe.length-1], value2);
				} else {
					FunkinLua.setVarInArray(this, value1, value2);
				}

			case 'Note Camera Movement':
				camNoteExtend = Std.parseFloat(value1);

				if (Math.isNaN(camNoteExtend))
					camNoteExtend = 0;

			case 'Play SFX':
				var val2:Float = Std.parseFloat(value2);

				if (Math.isNaN(val2))
					val2 = 1;

				FlxG.sound.play(Paths.sound(value1), val2).pitch = playbackRate;

			case 'Corianda Border':
				if (coriBorder != null)
				{
					var duration:Null<Float> = Std.parseFloat(value1);

					if (duration == null || Math.isNaN(duration))
						duration = 1;

					for (border in coriBorder.members)
						border.tween(duration);
				}

			case 'Screen Flash':
				var duration:Float = Std.parseFloat(value1);
				var color:FlxColor = FlxColor.WHITE;

				if (Math.isNaN(duration))
					duration = 0.3;

				if (value2.length > 0)
					color = FlxColor.fromString(value2);

				FlxG.camera.flash(color, duration, null, true);
			
			case 'Call on Luas':
				var value2Arr:Array<String> = value2.split(',');
				
				callOnLuas(value1, value2Arr);

			case 'Clear Particles':
				for (particle in particleGroup)
				{
					if (particle != null)
					{
						FlxTween.cancelTweensOf(particle);
						particle.destroy();
						particleGroup.remove(particle);
						particle = null;
					}
				}

			case 'Note':
				if (value2 == 'true')
					addTextToDebug(value1, FlxColor.WHITE);
			case 'Set Camera Speed':
				var duration:Float = Std.parseFloat(value1);
				if (Math.isNaN(duration))
					duration = defcameraSpeed;

				cameraSpeed = duration;
			case 'Set Lane Transparency':
				var opacity:Float = Std.parseFloat(value1);
				var speed:Float = Std.parseFloat(value2);
				if (Math.isNaN(opacity))
					opacity = 0.001;
				if (Math.isNaN(speed))
					speed = 0.1;

				if (ClientPrefs.laneAlpha == 0 && ClientPrefs.dynamicLaneOpacity)
				{
					for (strum in opponentStrums)
						FlxTween.tween(strum.bgLane, {alpha: opacity}, speed, {ease: FlxEase.circOut});
					for (strum in playerStrums)
						FlxTween.tween(strum.bgLane, {alpha: opacity}, speed, {ease: FlxEase.circOut});
				}		
		}
		callOnLuas('onEvent', [eventName, value1, value2]);
	}

	function moveCameraSection():Void {
		if(SONG.notes[curSection] == null) return;

		if (extraChar != null && SONG.notes[curSection].extraCharSection)
		{
			if (!isCameraOnForcedPos) moveCamera('extraChar');
			
			callOnLuas('onMoveCamera', ['extra']);
			return;
		}

		if (gf != null && SONG.notes[curSection].gfSection)
		{
			if (!isCameraOnForcedPos) moveCamera('gf');

			callOnLuas('onMoveCamera', ['gf']);
			return;
		}

		if (!SONG.notes[curSection].mustHitSection)
		{
			if (!isCameraOnForcedPos) moveCamera('dad');

			callOnLuas('onMoveCamera', ['dad']);
		}
		else
		{
			if (!isCameraOnForcedPos) moveCamera('boyfriend');
			
			callOnLuas('onMoveCamera', ['boyfriend']);
		}
	}

	public function moveCamera(moveCameraTo:Dynamic)
	{
		var tempPos:FlxPoint = new FlxPoint();

		switch (moveCameraTo)
		{
			case 'dad' | true:
				tempPos.set(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
				tempPos.x += dad.cameraPosition[0] + opponentCameraOffset[0];
				tempPos.y += dad.cameraPosition[1] + opponentCameraOffset[1];
				noteCamera(dad, false);
			default:
				tempPos.set(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
				tempPos.x -= boyfriend.cameraPosition[0] - boyfriendCameraOffset[0];
				tempPos.y += boyfriend.cameraPosition[1] + boyfriendCameraOffset[1];
				noteCamera(boyfriend, true);
			case 'gf':
				tempPos.set(gf.getMidpoint().x, gf.getMidpoint().y);
				tempPos.x += gf.cameraPosition[0] + girlfriendCameraOffset[0];
				tempPos.y += gf.cameraPosition[1] + girlfriendCameraOffset[1];
				noteCamera(gf, false);
			case 'extraChar':
				tempPos.set(extraChar.getMidpoint().x, extraChar.getMidpoint().y);
				tempPos.x += extraChar.cameraPosition[0];
				tempPos.y += extraChar.cameraPosition[1];
				noteCamera(extraChar, metadata.song.extraCharacter[1]);	
		}

		tempPos.x += camNoteX;
		tempPos.y += camNoteY;

		if (cameraBoundaries != null)
		{
			tempPos.x = FlxMath.bound(tempPos.x, cameraBoundaries[0], cameraBoundaries[2]);
			tempPos.y = FlxMath.bound(tempPos.y, cameraBoundaries[1], cameraBoundaries[3]);
		}

		tempPos.copyTo(camFollow);
		tempPos.destroy();
	}

	private function noteCamera(focusedChar:Character, mustHit:Bool)
	{
		if (camNoteExtend == 0)
			return;

		if (((focusedChar == boyfriend || focusedChar == extraChar) && mustHit) || ((focusedChar == dad || focusedChar == gf) && !mustHit))
		{
			camNoteX = 0;
			if (focusedChar.animation.curAnim.name.startsWith('singLEFT'))
				camNoteX -= camNoteExtend;
			if (focusedChar.animation.curAnim.name.startsWith('singRIGHT'))
				camNoteX += camNoteExtend;
			if (focusedChar.animation.curAnim.name.startsWith('idle'))
				camNoteX = 0;

			camNoteY = 0;
			if (focusedChar.animation.curAnim.name.startsWith('singDOWN'))
				camNoteY += camNoteExtend;
			if (focusedChar.animation.curAnim.name.startsWith('singUP'))
				camNoteY -= camNoteExtend;
			if (focusedChar.animation.curAnim.name.startsWith('idle'))
				camNoteY = 0;
		}
	}

	function snapCamFollowToPos(x:Float, y:Float) {
		camFollow.set(x, y);
		camFollowPos.setPosition(x, y);
	}

	public function finishSong(?ignoreNoteOffset:Bool = false):Void
	{
		var finishCallback:Void->Void = endSong; //In case you want to change it in a specific song.

		if (dreamcastEnd != null)
		{
			finishCallback = function()
			{
				canPause = false;
				endingSong = true;
				startDreamcastDialogue(dreamcastEnd);
			};
		}

		updateTime = false;
		FlxG.sound.music.volume = 0;
		for (vocal in vocalTracks)
		{
			vocal.volume = 0;
			vocal.pause();
		}
		if(ClientPrefs.noteOffset <= 0 || ignoreNoteOffset) {
			finishCallback();
		} else {
			finishTimer = new FlxTimer().start(ClientPrefs.noteOffset / 1000, function(tmr:FlxTimer) {
				finishCallback();
			});
		}
	}

	public var playedFC = false;
	public var transitioning = false;
	public function endSong():Void
	{
		//Should kill you if you tried to cheat
		if (!startingSong)
		{
			notes.forEach(function(daNote:Note)
			{
				if (daNote.strumTime < songLength - Conductor.safeZoneOffset)
					health -= 0.06 * healthLoss;
			});

			for (daNote in unspawnNotes)
			{
				if (daNote.strumTime < songLength - Conductor.safeZoneOffset)
					health -= 0.06 * healthLoss;
			}

			if (doDeathCheck())
				return;
		}

		canPause = false;
		endingSong = true;
		camZooming = false;
		inCutscene = false;
		updateTime = false;

		seenCutscene = false;

		var ret:Dynamic = callOnLuas('onEndSong', [], false);

		if (ret != FunkinLua.Function_Stop && !transitioning)
		{
			if (!loadRep)
				rep.SaveReplay(saveNotes, saveJudgements, replayAna);

			var usedPractice:Bool = (ClientPrefs.getGameplaySetting('practice', false) || ClientPrefs.getGameplaySetting('botplay', false));

			if (!usedPractice && !chartingMode)
			{
				var percent:Float = ratingPercent;
				if (Math.isNaN(percent)) percent = 0;

				var type:String = opponentPlay ? "-opponent" : "";

				Highscore.saveScore(SONG.id + type, songScore, storyDifficulty, percent);
				Highscore.saveCombo(SONG.id + type, ratingFC, storyDifficulty);
				Highscore.saveAccuracy(SONG.id + type, accuracy, storyDifficulty);
				Highscore.saveLetter(SONG.id + type, ratingLetter, storyDifficulty);
			}

			playbackRate = 1;

			if (chartingMode)
			{
				openChartEditor();
				return;
			}

			if (isStoryMode)
			{
				campaignMarvelous += marvelous;
				campaignSicks += sicks;
				campaignGoods += goods;
				campaignBads += bads;
				campaignShits += shits;

				campaignEarlys += earlys;
				campaignLates += lates;

				campaignScore += songScore;
				campaignHits += songHits;
				campaignMisses += songMisses;

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					if (ClientPrefs.scoreScreen && !cpuControlled && !practiceMode)
					{
						openResultsScreen();
					}
					else
					{
						returnToState('story');
					}
				}
				else
				{

					trace('LOADING NEXT SONG: ${Paths.formatToSongPath(storyPlaylist[0])}');

					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;

					prevCamFollow = camFollow;
					prevCamFollowPos = camFollowPos;

					SONG = Song.loadFromJson(storyPlaylist[0], storyPlaylist[0]);
					FlxG.sound.music.stop();

					cancelMusicFadeTween();
					LoadingState.loadAndSwitchState(new PlayState());
				}
			}
			else
			{
				if (ClientPrefs.scoreScreen && !cpuControlled && !practiceMode)
				{
					openResultsScreen();
				}
				else
				{
					returnToState('freeplay');
				}
			}
			transitioning = true;
		}
	}

	public static function returnToState(state:String)
	{
		WeekData.loadTheFirstEnabledMod();
		FRFadeTransition.type = 'songTrans';
		ResultsScreenSubState.fullCombo = false;

		if (FlxTransitionableState.skipNextTransIn)
			FRFadeTransition.nextCamera = null;

		switch (state.toLowerCase())
		{
			case 'story' | 'credits':
			{
				if (FlxG.sound.music != null)
				{
					FlxG.sound.music.stop();
					FlxG.sound.music.destroy();
					FlxG.sound.music = null;
				}

				var nextState:FlxState;
				var songName:String = hasMetadata ? metadata.song.name : SONG.song;

				if (songName == 'Sugarcoat It' && !ClientPrefs.pastOGWeek) //Change it from a song check to a week check later
				{
					trace("introduce ito's wife");
					nextState = new SunSynthFirstState();
				}
				else
				{
					FlxG.sound.playMusic(Paths.music(ClientPrefs.mainmenuMusic)); //this doesn't work for some reason
					nextState = (state == 'credits') ? new CreditsState() : new StoryMenuState();
				}

				if (songName == 'n0.pressur3.temp')
					nextState = new MainMenuState();

				MusicBeatState.switchState(nextState);
				if(!ClientPrefs.getGameplaySetting('practice', false) && !ClientPrefs.getGameplaySetting('botplay', false))
					WeekData.weekCompleted.set(WeekData.weeksList[storyWeek], true);

				var type:String = ClientPrefs.getGameplaySetting('opponentplay', false) ? "-opponent" : "";
				Highscore.saveWeekScore(WeekData.getWeekFileName() + type, campaignScore, storyDifficulty);
				FlxG.save.data.weekCompleted = WeekData.weekCompleted;
				FlxG.save.flush();

				changedDifficulty = false;
			}
			case 'freeplay':
			{
				trace('WENT BACK TO FREEPLAY??');

				cancelMusicFadeTween();

				MusicBeatState.switchState(new FreeplayState());
				FlxG.sound.playMusic(Paths.music(ClientPrefs.mainmenuMusic));
				changedDifficulty = false;
			}
		}
	}


	public function KillNotes() {
		while(notes.length > 0) {
			var daNote:Note = notes.members[0];
			daNote.active = false;
			daNote.visible = false;

			daNote.kill();
			notes.remove(daNote, true);
			daNote.destroy();
		}
		unspawnNotes = [];
		eventNotes = [];
	}

	public function getRatesScore(rate:Float, score:Float):Float
	{
		var rateX:Float = 1;
		var lastScore:Float = score;
		var pr = rate - 0.05;
		if (pr < 1.00)
			pr = 1;

		while (rateX <= pr)
		{
			if (rateX > pr)
				break;
			lastScore = score + ((lastScore * rateX) * 0.022);
			rateX += 0.05;
		}

		var actualScore = Math.round(score + (Math.floor((lastScore * pr)) * 0.022));

		return actualScore;
	}

	public var totalPlayed:Int = 0;
	public var totalNotesHit:Float = 0.0;
	public var showRating:Bool = ClientPrefs.showRating;
	public var showTiming:Bool = ClientPrefs.timingIndicator != 'None';

	private function cachePopUpScore(char:Character = null, folder:String = '')
	{
		var suffix:String = '';

		if (char == null)
			char = opponentPlay ? dad : boyfriend;

		if (isPixelStage)
		{
			folder = 'pixelUI/';
			suffix = '-pixel';
		}

		if (char.ratings_folder != null && char.ratings_folder != '')
			folder = 'ratings/' + char.ratings_folder + '/';

		Paths.image(folder + "marvelous" + suffix);
		Paths.image(folder + "sick" + suffix);
		Paths.image(folder + "good" + suffix);
		Paths.image(folder + "bad" + suffix);
		Paths.image(folder + "shit" + suffix);
		
		for (i in 0...10) {
			Paths.image(folder + 'num' + i + suffix);
		}
	}

	var ratingCharNote:Bool = false;
	var healthCharNote:Bool = false; //These are separate just incase
	var noteSkinCharNote:Bool = false;
	var noteSkinChangeCharNote:Bool = true;

	private function popUpScore(note:Note = null):Void
	{
		var noteDiffSigned:Float = (note.strumTime - Conductor.songPosition + ClientPrefs.ratingOffset);
		var noteDiff:Float = Math.abs(noteDiffSigned);
		//trace(noteDiff, ' ' + Math.abs(note.strumTime - Conductor.songPosition));

		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.35;
		//

		var score:Float = 400;

		//tryna do MS based judgment due to popular demand
		var daRating:Rating = Conductor.judgeNote(note, cpuControlled ? 0 : noteDiff / playbackRate);

		totalNotesHit += daRating.ratingMod;
		note.ratingMod = daRating.ratingMod;
		if(!note.ratingDisabled) daRating.increase();
		if(loadRep) { // Replay
			noteDiff = findByTime(note.strumTime)[3];
			note.rating = rep.replay.songJudgements[findByTimeIndex(note.strumTime)];
		}
		else { // No Replay
			note.rating = daRating.name;
		}
		score = daRating.score;
		if(daRating.breakCombo) {
			songMisses++;
			combo = 0;
		}
		health += daRating.health * healthGain;

		if (!loadRep)
		{
			var array = [note.strumTime, note.sustainLength, note.noteData, cpuControlled ? 0 : noteDiffSigned];
			if (note.isSustainNote) array[1] = -1;
			saveNotes.push(array);
			saveJudgements.push(note.rating);
		}

		if(playbackRate >= 1.05)
			score = getRatesScore(playbackRate, score);

		if(daRating.noteSplash && !note.noteSplashDisabled)
		{
			spawnNoteSplashOnNote(note);
		}

		//if(!practiceMode && !cpuControlled) {
			songScore += Math.round(score);
			if(!note.ratingDisabled)
			{
				songHits++;
				totalPlayed++;
				RecalculateRating(false);
			}
		//}

		var folder:String = "";
		var sufix:String = '';
		var char:Character = (opponentPlay ? dad : boyfriend);

		if (ratingCharNote)
		{
			if (note.gfNote) 
				char = gf;
	
			if (allowExtra && note.extraCharNote) 
				char = extraChar;
		}

		if (isPixelStage)
		{
			folder = 'pixelUI/';
			sufix = '-pixel';
		}


		if (char.ratings_folder != null && char.ratings_folder != '')
			folder = 'ratings/' + char.ratings_folder + '/';

		var rating:FlxSprite = new FlxSprite().loadGraphic(Paths.image(folder + daRating.image + sufix));
		rating.cameras = [camHUD];
		rating.screenCenter();
		rating.x = coolText.x - 40;
		rating.y -= 60;
		if (ClientPrefs.comboStacking) {
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);
		}
		rating.x += ClientPrefs.comboOffset[0];
		rating.y -= ClientPrefs.comboOffset[1];
		rating.visible = (!ClientPrefs.hideHud && showRating);
		
		if (showRating) {
			insert(members.indexOf(strumLineNotes), rating);
			if (!ClientPrefs.comboStacking) {
				if (lastRating != null) {
					lastRating.destroy();
				}
				lastRating = rating;
			}	
		}

		var msTiming:Float = CoolUtil.floorDecimal(noteDiffSigned, 3);
		if (cpuControlled && !loadRep) {
			msTiming = 0;		
		}
		else if (loadRep) {
			msTiming = CoolUtil.floorDecimal(findByTime(note.strumTime)[3], 3);
		}

		var timingTxt:FlxText = new FlxText(0, 0, 0, '');
		timingTxt.cameras = [camHUD];

		var color:FlxColor = FlxColor.WHITE;
		var msFloor:Int = Math.floor(msTiming);

		if (ClientPrefs.timingIndicator == 'Precise')
		{
			timingTxt.text = msTiming + "ms";
			switch (daRating.name)
			{
				case 'shit':
					color = FlxColor.BROWN;
				case 'bad':
					color = FlxColor.RED;
				case 'good':
					color = FlxColor.GREEN;
				case 'sick':
					color = FlxColor.CYAN;
				case 'marvelous':
					color = FlxColor.YELLOW;
			}
		}
		else
		{
			timingTxt.text = msFloor == 0 ? 'EXACT' : msFloor < 0 ? 'LATE' : 'EARLY';
			color = msFloor == 0 ? FlxColor.YELLOW : msFloor < 0 ? FlxColor.RED : FlxColor.CYAN;
			timingTxt.alpha = daRating.name != 'marvelous' ? 1.0 : 0.0;
		}

		// for results screen
		if (daRating.name != 'marvelous') msFloor < 0 ? lates++ : earlys++;

		timingTxt.setFormat(Paths.font("Krungthep.ttf"), 28, color, CENTER).setBorderStyle(OUTLINE, FlxColor.BLACK, 1.25, 2);
		timingTxt.screenCenter();
		timingTxt.x = coolText.x + 100;
		timingTxt.y = rating.y + 100;
		if (ClientPrefs.comboStacking) {
			timingTxt.acceleration.y = 600;
			timingTxt.velocity.y -= 150;
			timingTxt.velocity.x += FlxG.random.int(1, 10);
		}
		timingTxt.antialiasing = ClientPrefs.globalAntialiasing;
		timingTxt.visible = (!ClientPrefs.hideHud && showTiming && !cpuControlled);

		if (showTiming) {
			insert(members.indexOf(strumLineNotes), timingTxt);	
			//if (!ClientPrefs.comboStacking) {
				if (lastTiming != null) {
					lastTiming.destroy();
				}
				lastTiming = timingTxt;
			//}
		}

		if (!isPixelStage)
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = ClientPrefs.globalAntialiasing;
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.85));
		}

		timingTxt.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		if(combo > highestCombo) {
			highestCombo = combo;
		}

		if(combo >= 1000) {
			seperatedScore.push(Math.floor(combo / 1000) % 10);
		}

		seperatedScore.push(Math.floor(combo / 100) % 10);
		seperatedScore.push(Math.floor(combo / 10) % 10);
		seperatedScore.push(combo % 10);

		if(lastScore != null) {
			while (lastScore.length > 0) {
				if(numScoreTween != null) {
					numScoreTween.cancel();
				}
				numScoreTween = null;

				lastScore[0].destroy();
				lastScore.remove(lastScore[0]);
			}
		}

		var daLoop:Int = 0;
		var xThing:Float = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(folder + 'num' + Std.int(i) + sufix));
			numScore.cameras = [camHUD];
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * daLoop) - 90;
			numScore.y += 80;			
			if (ClientPrefs.comboStacking) {
				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);
			}
			numScore.x += ClientPrefs.comboOffset[2];
			numScore.y -= ClientPrefs.comboOffset[3];
			numScore.visible = (!ClientPrefs.hideHud);

			//if (combo >= 10 || combo == 0)
			insert(members.indexOf(strumLineNotes), numScore);
			if (!ClientPrefs.comboStacking) {
				lastScore.push(numScore);
			}

			if (!isPixelStage)
			{
				numScore.antialiasing = ClientPrefs.globalAntialiasing;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			else
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			numScore.updateHitbox();

			if (!ClientPrefs.comboStacking) {
				numScoreTween = FlxTween.tween(numScore.scale, {x: isPixelStage ? daPixelZoom - 0.45 : 0.45, y: isPixelStage ? daPixelZoom - 0.45 : 0.45}, 0.2, {
					onComplete: function(twn:FlxTween) {
						numScoreTween = FlxTween.tween(numScore, {alpha: 0}, 0.2, {
							onComplete: function(twn:FlxTween) {
								numScore.destroy();
							},
							startDelay: Conductor.crochet * 0.002
						});
					}
				});
			}
			else {
				numScoreTween = FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(twn:FlxTween) {
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});
			}

			daLoop++;
			if(numScore.x > xThing) xThing = numScore.x;
		}
		/*
			trace(combo);
			trace(seperatedScore);
		 */

		coolText.text = Std.string(seperatedScore);
		// add(coolText);

		if (!ClientPrefs.comboStacking) {
			if(timingTxtTween != null) {
				timingTxtTween.cancel();
			}
			timingTxtTween = FlxTween.tween(timingTxt.scale, {x: 0.85, y: 0.85}, 0.2, {
				onComplete: function(twn:FlxTween) {
					timingTxtTween = FlxTween.tween(timingTxt, {alpha: 0}, 0.2, {
						onComplete: function(twn:FlxTween) {
							timingTxtTween = null;
							timingTxt.destroy();
						},
						startDelay: Conductor.crochet * 0.002
					});
				}
			});
		}
		else {
			timingTxtTween = FlxTween.tween(timingTxt, {alpha: 0}, 0.2, {
				onComplete: function(twn:FlxTween) {
					timingTxt.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});
		} 

		if (!ClientPrefs.comboStacking) {
			if(ratingTween != null) {
				ratingTween.cancel();
			}
			ratingTween = FlxTween.tween(rating.scale, {x: isPixelStage ? daPixelZoom - 1.25 : 0.65, y: isPixelStage ? daPixelZoom - 1.25 : 0.65}, 0.2, {
				onComplete: function(twn:FlxTween) {
					ratingTween = FlxTween.tween(rating, {alpha: 0}, 0.2, {
						onComplete: function(twn:FlxTween) {
							ratingTween = null;
							rating.destroy();
						},
						startDelay: Conductor.crochet * 0.002
					});
				}
			}); 
		}
		else {
			ratingTween = FlxTween.tween(rating, {alpha: 0}, 0.2, {
				onComplete: function(twn:FlxTween) {
					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});
		}
	}

	public var strumsBlocked:Array<Bool> = [];
	private function onKeyPress(event:KeyboardEvent):Void
	{
		var eventKey:FlxKey = event.keyCode;
		var key:Int = getKeyFromEvent(eventKey);
		//trace('Pressed: ' + eventKey);

		if (!cpuControlled && startedCountdown && !paused && key > -1 && (FlxG.keys.checkStatus(eventKey, JUST_PRESSED) || ClientPrefs.controllerMode))
		{
			if(!boyfriend.stunned && generatedMusic && !endingSong)
			{
				var ana:Ana = new Ana(Conductor.songPosition, null, false, "miss", key);

				var canMiss:Bool = !ClientPrefs.ghostTapping;

				// heavily based on my own code LOL if it aint broke dont fix it
				var sortedNotesList:Array<Note> = [];
				for (daNote in notes)
				{
					if (strumsBlocked[daNote.noteData] != true && daNote.canBeHit && daNote.recalculatePlayerNote(opponentPlay) && !daNote.tooLate && !daNote.wasGoodHit && !daNote.isSustainNote && !daNote.blockHit)
					{
						if(daNote.noteData == key) sortedNotesList.push(daNote);
						canMiss = true;
					}
				}
				sortedNotesList.sort(sortHitNotes);

				if (sortedNotesList.length > 0) {
					var epicNote:Note = sortedNotesList[0];
					if (sortedNotesList.length > 1) {
						for (bad in 1...sortedNotesList.length)
						{
							var doubleNote:Note = sortedNotesList[bad];
							// no point in jack detection if it isn't a jack
							if (doubleNote.noteData != epicNote.noteData)
								break;
	
							if (Math.abs(doubleNote.strumTime - epicNote.strumTime) < 1) {
								notes.remove(doubleNote, true);
								doubleNote.destroy();
								break;
							} else if (doubleNote.strumTime < epicNote.strumTime)
							{
								// replace the note if its ahead of time
								epicNote = doubleNote; 
								break;
							}
						}
					}

					// eee jack detection before was not super good
					var noteDiffSigned:Float = (epicNote.strumTime - Conductor.songPosition + ClientPrefs.ratingOffset);
					goodNoteHit(epicNote);
					ana.hit = true;
					ana.hitJudge = Conductor.judgeNote(epicNote, noteDiffSigned).name;
					ana.nearestNote = [epicNote.strumTime, epicNote.noteData, epicNote.sustainLength];
				}
				else{
					callOnLuas('onGhostTap', [key]);
					if (canMiss) {
						noteMissPress(key);
						ana.hit = false;
						ana.hitJudge = "shit";
						ana.nearestNote = [];
					}
				}

				// I dunno what you need this for but here you go
				//									- Shubs

				// Shubs, this is for the "Just the Two of Us" achievement lol
				//									- Shadow Mario
				keysPressed[key] = true;	
			}

			var spr:StrumNote = (opponentPlay ? opponentStrums.members[key] : playerStrums.members[key]);
			if(strumsBlocked[key] != true && spr != null && spr.animation.curAnim.name != 'confirm')
			{
				spr.playAnim('pressed');
				spr.resetAnim = 0;
			}
			callOnLuas('onKeyPress', [key]);
		}
		//trace('pressed: ' + controlArray);
	}

	function sortHitNotes(a:Note, b:Note):Int
	{
		if (a.lowPriority && !b.lowPriority)
			return 1;
		else if (!a.lowPriority && b.lowPriority)
			return -1;

		return FlxSort.byValues(FlxSort.ASCENDING, a.strumTime, b.strumTime);
	}

	private function onKeyRelease(event:KeyboardEvent):Void
	{
		var eventKey:FlxKey = event.keyCode;
		var key:Int = getKeyFromEvent(eventKey);
		if(!cpuControlled && startedCountdown && !paused && key > -1)
		{
			var spr:StrumNote = (opponentPlay ? opponentStrums.members[key] : playerStrums.members[key]);
			if(spr != null)
			{
				spr.playAnim('static');
				spr.resetAnim = 0;
			}
			callOnLuas('onKeyRelease', [key]);
		}
		//trace('released: ' + controlArray);
	}

	private function getKeyFromEvent(key:FlxKey):Int
	{
		if(key != NONE)
		{
			for (i in 0...keysArray.length)
			{
				for (j in 0...keysArray[i].length)
				{
					if(key == keysArray[i][j])
					{
						return i;
					}
				}
			}
		}
		return -1;
	}

	// Hold notes
	private function keyShit():Void
	{
		// HOLDING
		var parsedHoldArray:Array<Bool> = parseKeys();

		// TO DO: Find a better way to handle controller inputs, this should work for now
		if(ClientPrefs.controllerMode)
		{
			var anas:Array<Ana> = [null, null, null, null];
			var parsedArray:Array<Bool> = parseKeys('_P');
			if(parsedArray.contains(true))
			{
				for (i in 0...parsedArray.length)
				{
					if(parsedArray[i] && strumsBlocked[i] != true) 
					{
						onKeyPress(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, true, -1, keysArray[i][0]));
						anas[i] = new Ana(Conductor.songPosition, null, false, "miss", i);
					}
				}
			}

			if (!loadRep)
				for (i in anas)
					if (i != null)
						replayAna.anaArray.push(i); // put em all there
		}

		var char:Character = boyfriend;
		if(opponentPlay) {
			char = dad;
		}
		if (startedCountdown && !char.stunned && generatedMusic)
		{
			// rewritten inputs???
			notes.forEachAlive(function(daNote:Note)
			{
				// hold note functions
				if (strumsBlocked[daNote.noteData] != true && daNote.isSustainNote && parsedHoldArray[daNote.noteData] && daNote.canBeHit
					&& daNote.recalculatePlayerNote(opponentPlay) && !daNote.tooLate && !daNote.wasGoodHit && !daNote.blockHit && daNote.sustainActive) {
					goodNoteHit(daNote);
				}

				// hold release functions
				if (daNote.recalculatePlayerNote(opponentPlay) && !cpuControlled && daNote.isSustainNote && daNote.sustainActive && !parsedHoldArray[daNote.noteData] && !cpuControlled && !daNote.ignoreNote && !endingSong 
					&& (daNote.tooLate || !daNote.wasGoodHit)) { // Hold notes
					// trace("User released key while playing a sustain at: " + daNote.spotInLine);
					for (i in daNote.parent.children) {
						i.alpha = 0.1;
						i.multAlpha = 0.1;
						i.sustainActive = false;
						health -= (0.08 * healthLoss) / daNote.parent.children.length;
					}
				}
			});

			if (char.animation.curAnim != null && char.holdTimer > Conductor.stepCrochet * 0.0011 * char.singDuration && char.animation.curAnim.name.startsWith('sing') && !char.animation.curAnim.name.endsWith('miss'))
			{
				char.dance();
			}			
		}

		// TO DO: Find a better way to handle controller inputs, this should work for now
		if(ClientPrefs.controllerMode || strumsBlocked.contains(true))
		{
			var parsedArray:Array<Bool> = parseKeys('_R');
			if(parsedArray.contains(true))
			{
				for (i in 0...parsedArray.length)
				{
					if(parsedArray[i] || strumsBlocked[i] == true)
						onKeyRelease(new KeyboardEvent(KeyboardEvent.KEY_UP, true, true, -1, keysArray[i][0]));
				}
			}
		}
	}

	private function parseKeys(?suffix:String = ''):Array<Bool>
	{
		var ret:Array<Bool> = [];
		for (i in 0...controlArray.length)
		{
			ret[i] = Reflect.getProperty(controls, controlArray[i] + suffix);
		}
		return ret;
	}

	function noteMiss(daNote:Note):Void { //You didn't hit the key and let it go offscreen, also used by Hurt Notes
		//Dupe note remove
		notes.forEachAlive(function(note:Note) {
			if (daNote != note && daNote.recalculatePlayerNote(opponentPlay) && daNote.noteData == note.noteData && daNote.isSustainNote == note.isSustainNote && Math.abs(daNote.strumTime - note.strumTime) < 1) {
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		});

		if (daNote.isSustainNote && !daNote.sustainActive){
			return;
		}

		combo = 0;
		if (!daNote.isSustainNote) {
			health -= daNote.missHealth * healthLoss;
		}

		var char:Character = boyfriend;
		if(opponentPlay) {
			char = dad;
		}

		if(!disableCharNotes && daNote.gfNote) {
			char = gf;
		}

		if(!disableCharNotes && daNote.extraCharNote) {
			char = extraChar;
		}

		if(instakillOnMiss)
		{
			vocals.volume = 0;
			char.holding = false;
			doDeathCheck(true);
		}

		//For testing purposes
		//trace(daNote.missHealth);
		songMisses++;
		totalNotesHit -= 1;
		vocals.volume = 0;
		char.holding = false;
		//rhythm gaming
		//if(!practiceMode) songScore -= 10;

		totalPlayed++;
		RecalculateRating(true);

		if(char != null && !daNote.noMissAnimation)
		{
			var animToPlay:String = singAnimations[Std.int(Math.abs(daNote.noteData))] + 'miss' + daNote.animSuffix;
			char.playAnim(animToPlay, true);

			if (daNote.noteType.startsWith('Duo Character Sing'))
			{
				char = (opponentPlay ? gf : extraChar);
				char.playAnim(animToPlay, true);
			}
		}

		if(!loadRep)
		{
			saveNotes.push([
				Conductor.songPosition,
				0,
				Std.int(Math.abs(daNote.noteData)),
				-ClientPrefs.shitWindow
			]);
			saveJudgements.push("miss");
		}
		FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2)).pitch = playbackRate;
		callOnLuas('noteMiss', [notes.members.indexOf(daNote), daNote.noteData, daNote.noteType, daNote.isSustainNote]);
	}

	function noteMissPress(direction:Int = 1):Void //You pressed a key when there was no notes to press for this key
	{
		if(ClientPrefs.ghostTapping) return; //fuck it

		if (!boyfriend.stunned)
		{
			health -= 0.04 * healthLoss;
			if(instakillOnMiss)
			{
				vocals.volume = 0;
				doDeathCheck(true);
			}

			if (opponentPlay) { // Flip on play opponent
				if (combo > 5 && gf != null && gf.animOffsets.exists('cheer')) {
					gf.playAnim('cheer');
				}
			}
			else {
				if (combo > 5 && gf != null && gf.animOffsets.exists('sad')) {
					gf.playAnim('sad');
				}
			}
			combo = 0;

			//rhythm gaming
			//if(!practiceMode) songScore -= 10;
			if(!endingSong) {
				songMisses++;
				totalNotesHit -= 1;
			}
			totalPlayed++;
			RecalculateRating(true);

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2)).pitch = playbackRate;

			var char:Character = (opponentPlay ? dad : boyfriend);

			char.playAnim(singAnimations[Std.int(Math.abs(direction))] + 'miss', true);
			
			vocals.volume = 0;
			char.holding = false;

			if(!loadRep){
				saveNotes.push([
					Conductor.songPosition,
					0,
					Std.int(Math.abs(direction)),
					-ClientPrefs.shitWindow
				]);
				saveJudgements.push("miss");
			}
		}
		callOnLuas('noteMissPress', [direction]);
	}

	function playAnimNote(char:Character, note:Note, ?altAnim:String = "")
	{
		var animToPlay:String = "";
		animToPlay = singAnimations[Std.int(Math.abs(note.noteData))];

		if (note.isParent && note.children.length > 0) {
			if (char.animation.getByName(holdAnimations[Std.int(Math.abs(note.noteData))] + "start") != null) {
				animToPlay = holdAnimations[Std.int(Math.abs(note.noteData))] + "start";
			}
			else if (char.animation.getByName(holdAnimations[Std.int(Math.abs(note.noteData))]) != null) {
				animToPlay = holdAnimations[Std.int(Math.abs(note.noteData))];
			}
		}
		else if (note.isSustainNote) {
			if (char.animation.getByName(holdAnimations[Std.int(Math.abs(note.noteData))]) != null) {
				animToPlay = holdAnimations[Std.int(Math.abs(note.noteData))];
			}
		}

		if (note.isSustainNote && note.isSustainEnd()){
			if (char.animation.getByName(holdAnimations[Std.int(Math.abs(note.noteData))] + "end") != null) {
				animToPlay = holdAnimations[Std.int(Math.abs(note.noteData))] + "end";
			}
		}

		if (note.isSustainNote && !note.isSustainEnd()) {
			char.holding = true;
		}
		else {
			char.holding = false;
		}

		if (char.animation.getByName(animToPlay + altAnim) != null) {
			animToPlay += altAnim;
		}

		if (char != null) {
			if (char.animation.curAnim != null) {
				if (!note.isSustainNote || (note.isSustainNote && !note.isSustainEnd())) {
					if ((!animToPlay.startsWith("hold") || char.animation.curAnim.name != animToPlay)) {
						char.playAnim(animToPlay, true);
					}
				}
			}
			char.holdTimer = 0;
		}
	}

	function makeMusicNote(char:Character, charName:String, dir:Int):Void
	{
		var musicNote:FlxSprite = new FlxSprite().loadGraphic(Paths.image('strumnote/' + charName.split('-')[0]));

		var xPos:Float = char.initFacing != char.facing ? -char.musicNoteOffset[0] : char.musicNoteOffset[0];
		var noteWidth:Float = char.initFacing != char.facing ? -(musicNote.width / 2) : (musicNote.width / 2);

		musicNote.setPosition(char.getMidpoint().x + xPos + noteWidth, char.getMidpoint().y + char.musicNoteOffset[1] + (musicNote.height / 2));
		musicNote.antialiasing = ClientPrefs.globalAntialiasing;
		add(musicNote);
		grpMusicNotes.add(musicNote);

		musicNote.scale.set(0.5, 0.5);
		musicNote.alpha = 1;

		var randAngle:Float = 0;

		switch (dir) // DOWN AND UP WERE MIRRORED. FUCK.
		{
			case 0:
				randAngle = FlxG.random.int(240, 300);
			case 2:
				randAngle = FlxG.random.int(150, 210);
			case 1:
				randAngle = FlxG.random.int(330, 390);
			case 3:
				randAngle = FlxG.random.int(60, 120);
		}
		if (randAngle > 360) randAngle = randAngle % 360;
		// i cannot radian properly, go go gadget multiply

		randAngle *= 0.0174533;

		musicNote.velocity.x = (FlxG.random.int(200, 400) * Math.sin(randAngle));
		musicNote.velocity.y = (FlxG.random.int(200, 400) * Math.cos(randAngle));

		FlxTween.tween(musicNote.velocity, {x: 0, y:0}, 1, {ease: FlxEase.cubeOut});
		FlxTween.tween(musicNote.scale, {x: 2, y:2}, 1, {ease: FlxEase.cubeOut});
		FlxTween.tween(musicNote, {alpha: 0}, 1, {ease: FlxEase.cubeOut, onComplete: function(twn:FlxTween) {
			musicNote.destroy();
		}});
	}

	function opponentNoteHit(note:Note):Void
	{
		if (SONG.id != 'tutorial')
			camZooming = true;

		var char:Character = dad;
		if(opponentPlay) {
			char = boyfriend;
		}
		if(!disableCharNotes && note.gfNote) {
			char = gf;
		}
		if(!disableCharNotes && note.extraCharNote) {
			char = extraChar;
		}

		if (healthCharNote)
		{
			if (!opponentPlay)
			{
				prevlastSungP2 = lastSungP2;
				lastSungP2 = char;
				flavorHUD.iconP2.changeIcon(char.healthIcon);
			}
			else
			{
				prevlastSungP1 = lastSungP1;
				lastSungP1 = char;
				flavorHUD.iconP1.changeIcon(char.healthIcon);
			}
			reloadHealthBarColors();
		}

		if (noteSkinCharNote)
			triggerEventNote('Change Strum Skin', opponentPlay ? 'bf' : 'dad', char.note);

		if (note.isParent) {
			for (i in note.children) {
				i.sustainActive = true;		
			}
		}

		if(note.noteType == 'Hey!' && char.animOffsets.exists('hey')) {
			char.playAnim('hey', true);
			char.specialAnim = true;
			char.heyTimer = 0.6;
		} else if(!note.noAnimation) {
			var altAnim:String = note.animSuffix;

			if (SONG.notes[curSection] != null)
			{
				var altNote:Bool = SONG.notes[curSection].altAnim || note.noteType.contains('Alt');

				if (altNote) {
					altAnim = '-alt';
					if (!note.isSustainNote) makeMusicNote(char, char.curCharacter, note.noteData);
				}
			}

			playAnimNote(char, note, altAnim);

			if(note.noteType.startsWith('Duo Character Sing')) 
				playAnimNote((!opponentPlay ? gf : extraChar), note, altAnim);
		}

		if (SONG.needsVoices && !separateVocals)
			vocals.volume = 1;

		var time:Float = 0.15;
		if(note.isSustainNote && !note.isSustainEnd()) {
			time += 0.15;
		}
		StrumPlayAnim(opponentPlay ? false : true, Std.int(Math.abs(note.noteData)), time, char);
		note.hitByOpponent = true;

		var isSus:Bool = note.isSustainNote; //GET OUT OF MY HEAD, GET OUT OF MY HEAD, GET OUT OF MY HEAD
		var leData:Int = Math.round(Math.abs(note.noteData));
		var leType:String = note.noteType;
		callOnLuas('opponentNoteHit', [notes.members.indexOf(note), leData, leType, isSus]);
		callOnLuas((opponentPlay ? 'goodNoteHitFix' : 'opponentNoteHitFix'), [notes.members.indexOf(note), leData, leType, isSus]);

		if (!note.isSustainNote)
		{
			note.kill();
			notes.remove(note, true);
			note.destroy();
		}
	}

	function goodNoteHit(note:Note):Void
	{
		if (!note.wasGoodHit)
		{
			if(cpuControlled && (note.ignoreNote || note.hitCausesMiss)) return;

			if (SONG.id != 'tutorial')
				camZooming = true;

			if (ClientPrefs.hitsoundVolume > 0 && !note.hitsoundDisabled)
				FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.hitsoundVolume);

			var char:Character = boyfriend;
			if(opponentPlay) {
				char = dad;
			}
			if(!disableCharNotes && note.gfNote) {
				char = gf;
			}
			if(!disableCharNotes && note.extraCharNote) {
				char = extraChar;
			}

			if (healthCharNote)
			{
				if (opponentPlay)
				{
					prevlastSungP2 = lastSungP2;
					lastSungP2 = char;
					flavorHUD.iconP2.changeIcon(char.healthIcon);
				}
				else
				{
					prevlastSungP1 = lastSungP1;
					lastSungP1 = char;
					flavorHUD.iconP1.changeIcon(char.healthIcon);
				}
				reloadHealthBarColors();
			}

			if (noteSkinCharNote)
					triggerEventNote('Change Strum Skin', opponentPlay ? 'dad' : 'bf', char.note);

			// add newest note to front of notesHitArray
			// the oldest notes are at the end and are removed first
			if(!note.isSustainNote) {
				notesHitArray.unshift(Date.now());
			}

			if(note.hitCausesMiss) {
				noteMiss(note);
				if(!note.noteSplashDisabled && !note.isSustainNote) {
					spawnNoteSplashOnNote(note);
				}

				if(!note.noMissAnimation)
				{
					switch(note.noteType) {
						case 'Hurt Note': //Hurt note
						if(boyfriend.animation.getByName('hurt') != null) {
							boyfriend.playAnim('hurt', true);
							boyfriend.specialAnim = true;
						}
					}
				}

				note.wasGoodHit = true;
				if (!note.isSustainNote)
				{
					note.kill();
					notes.remove(note, true);
					note.destroy();
				}
				return;
			}

			if (!note.isSustainNote)
			{
				combo += 1;
				if(combo > 9999) combo = 9999;
				popUpScore(note);
				/* Enable Sustains to be hit. 
				//This is to prevent hitting sustains if you hold a strum before the note is coming without hitting the note parent. 
				(I really hope I made me understand lol.) */
				if (note.isParent)
					for (i in note.children)
						i.sustainActive = true;
			}
			else if (note.isSustainNote)
			{
				health += note.hitHealth * healthGain;
			}

			if(!note.noAnimation) {
				var altAnim:String = note.animSuffix;

				if (SONG.notes[curSection] != null)
				{
					var altNote:Bool = SONG.notes[curSection].altAnim || note.noteType.contains('Alt');

					if (altNote) {
						altAnim = '-alt';
						if (!note.isSustainNote) makeMusicNote(char, char.curCharacter, note.noteData);
					}
				}
				
				playAnimNote(char, note, altAnim);

				if(note.noteType.startsWith('Duo Character Sing')) 
					playAnimNote((opponentPlay ? gf : extraChar), note, altAnim);

				if(char != null)
				{
					if(note.noteType == 'Hey!') {
						if(char.animOffsets.exists('hey')) {
							char.playAnim('hey', true);
							char.specialAnim = true;
							char.heyTimer = 0.6;
						}
	
						if(char.animOffsets.exists('cheer')) {
							char.playAnim('cheer', true);
							char.specialAnim = true;
							char.heyTimer = 0.6;
						}
					}
				}
			}

			if(cpuControlled) {
				var time:Float = 0.15;
				if(note.isSustainNote && !note.isSustainEnd()) {
					time += 0.15;
				}
				StrumPlayAnim(opponentPlay ? true : false, Std.int(Math.abs(note.noteData)), time, char);
			} else {
				var spr = (opponentPlay ? opponentStrums.members[note.noteData] : playerStrums.members[note.noteData]);
				if(spr != null)
				{
					spr.playAnim('confirm', true);
					spr.holding = char.holding;
				}
			}
			note.wasGoodHit = true;
			vocals.volume = 1;

			var isSus:Bool = note.isSustainNote; //GET OUT OF MY HEAD, GET OUT OF MY HEAD, GET OUT OF MY HEAD
			var leData:Int = Math.round(Math.abs(note.noteData));
			var leType:String = note.noteType;
			callOnLuas('goodNoteHit', [notes.members.indexOf(note), leData, leType, isSus]);
			callOnLuas((opponentPlay ? 'opponentNoteHitFix' : 'goodNoteHitFix'), [notes.members.indexOf(note), leData, leType, isSus]);

			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		}
	}

	function speakerNoteHit(note:Note):Void
	{
		var char:Character = dad;

		if(note.mustPress)
			char = boyfriend;

		if(note.gfNote) 
			char = gf;

		if(note.extraCharNote && extraChar != null) 
			char = extraChar;

		if (note.isParent) {
			for (i in note.children) {
				i.sustainActive = true;		
			}
		}

		if(note.noteType == 'Hey!' && char.animOffsets.exists('hey')) {
			char.playAnim('hey', true);
			char.specialAnim = true;
			char.heyTimer = 0.6;
		} else if(!note.noAnimation) {
			var altAnim:String = note.animSuffix;

			if (SONG.notes[curSection] != null)
			{
				var altNote:Bool = SONG.notes[curSection].altAnim || note.noteType.contains('Alt');
	
				if (altNote) {
					altAnim = '-alt';
					if (!note.isSustainNote) makeMusicNote(char, char.curCharacter, Std.int(note.noteData));
				}
			}

			playAnimNote(char, note, altAnim);

			var isSus:Bool = note.isSustainNote; //GET OUT OF MY HEAD, GET OUT OF MY HEAD, GET OUT OF MY HEAD
			var leData:Int = Math.round(Math.abs(note.noteData));
			var leType:String = note.noteType;
			var mustPress:Bool = note.mustPress;
			callOnLuas('speakerNoteHit', [speakerNotes.indexOf(note), leData, leType, isSus, mustPress]);
		}
	}

	public function spawnNoteSplashOnNote(note:Note) {
		if(ClientPrefs.noteSplashes && note != null) {
			var strum:StrumNote = (opponentPlay ? opponentStrums.members[note.noteData] : playerStrums.members[note.noteData]);
			if(strum != null) {
				spawnNoteSplash(strum.x, strum.y, note.noteData, note, (opponentPlay ? 1 : 0));
			}
		}
	}

	public function spawnNoteSplash(x:Float, y:Float, data:Int, ?note:Note = null, ?player:Int) {
		var skin:String = 'noteSplashes';
		var char:Character = boyfriend;
		var scale:Float = 1;
		var opacity:Float = 0.6;
		char = (player == 1 ? dad : boyfriend);

		if (note != null)
		{
			if (note.gfNote) 
				char = gf;
	
			if (allowExtra && note.extraCharNote) 
				char = extraChar;
		}

		if(SONG.splashSkin != null && SONG.splashSkin.length > 0) skin = SONG.splashSkin;

		if(char.noteSplash != null)
		{
			skin = char.noteSplash[0];
			x += char.noteSplash[1];
			y += char.noteSplash[2];
			scale = char.noteSplash[3];
			opacity = char.noteSplash[4];
		}

		var splash:NoteSplash = grpNoteSplashes.recycle(NoteSplash);
		splash.setupNoteSplash(x, y, data, skin, scale, opacity);
		grpNoteSplashes.add(splash);
	}

	function createTrail(char:Character)
	{
		var trailSprite:FlxSprite = new FlxSprite(char.x, char.y);
		trailSprite.scale.copyFrom(char.scale);
		trailSprite.updateHitbox();
		trailSprite.alpha = 0.7;
		trailSprite.blend = ADD;
		trailSprite.flipX = char.flipX;
		trailSprite.antialiasing = char.antialiasing;
		trailSprite.color = FlxColor.fromRGB(char.healthColorArray[0], char.healthColorArray[1], char.healthColorArray[2]);
		trailSprite.frames = char.frames;
		trailSprite.animation.addByPrefix('hueh', char.animation.frameName, 0, false);
		trailSprite.animation.play('hueh', true);
		trailSprite.offset.copyFrom(char.offset);
		addBehindDad(trailSprite);
		FlxTween.tween(trailSprite, {alpha: 0}, 1.5, {
			ease: FlxEase.linear,
			onComplete: function(twn:FlxTween) {
				remove(trailSprite);
				trailSprite.destroy();
			}
		});
	}

	override function destroy() {
		for (lua in luaArray) {
			lua.call('onDestroy', []);
			lua.stop();
		}
		luaArray = [];

		#if hscript
		if(FunkinLua.hscript != null) FunkinLua.hscript = null;
		#end

		if(!ClientPrefs.controllerMode)
		{
			FlxG.stage.application.window.onKeyDown.remove(InputMethods.onKeyDown);
			FlxG.stage.application.window.onKeyUp.remove(InputMethods.onKeyRelease);
			
			//FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			//FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
		}
		FlxG.timeScale = 1;
		if (FlxG.sound.music != null) FlxG.sound.music.pitch = 1;
		super.destroy();
	}

	public static function cancelMusicFadeTween() {
		if(FlxG.sound.music.fadeTween != null) {
			FlxG.sound.music.fadeTween.cancel();
		}
		FlxG.sound.music.fadeTween = null;
	}

	var lastStepHit:Int = -1;
	override function stepHit()
	{
		if (camZooming && curStep % camZoomingFreq == 0)
		{
			FlxG.camera.zoom += 0.015 * camZoomingMult;
			camHUD.zoom += 0.03 * camZoomingMult;
		}

		super.stepHit();
		
		if(curStep == lastStepHit) {
			return;
		}

		lastStepHit = curStep;

		if (hasTitleCard && curStep == titleCardStep && !playedTitleCard)
		{
			playedTitleCard = true;
			titleCard.animation.play('idle');
			titleCard.alpha = 1;
			new FlxTimer().start(4, function(tmr:FlxTimer)
			{
				FlxTween.tween(titleCard, {alpha: 0}, 1, {ease: FlxEase.cubeInOut, onComplete: function(twn:FlxTween)
				{
					remove(titleCard);
					titleCard.destroy();
				}});

				if (playerIndicator != null)
				{
					FlxTween.tween(playerIndicator, {alpha: 1}, 0.25, {
						startDelay: 0.25,
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween) 
						{
							FlxTween.tween(playerIndicator, {alpha: 0}, 1.5, {
								startDelay: 3.0,
								ease: FlxEase.cubeInOut,
								onComplete: function(twn:FlxTween) 
								{
									remove(playerIndicator);
									playerIndicator.destroy();					
								}
							});					
						}
					});
				}

				for (i in 0...4)
				{
					var targetAlpha:Float = 1;

					if (ClientPrefs.middleScroll)
						targetAlpha = ClientPrefs.opponentStrums ? 0.35 : 0;

					var playerSide = opponentPlay ? opponentStrums : playerStrums;
					var opponentSide = !opponentPlay ? opponentStrums : playerStrums;

					FlxTween.tween(playerSide.members[i], {alpha: 1}, 1, {ease: FlxEase.circOut});
					FlxTween.tween(opponentSide.members[i], {alpha: targetAlpha}, 1, {ease: FlxEase.circOut});
				}

				FlxTween.tween(flavorHUD, {alpha: ClientPrefs.healthBarAlpha}, 1, {
					ease: FlxEase.circOut,
					onComplete: function(twn:FlxTween)
					{
						flavorHUD.allowScroll = true;
					}
				});
			});
		}

		setOnLuas('curStep', curStep);
		callOnLuas('onStepHit', []);
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	var lastBeatHit:Int = -1;

	var forceIdleOnBeat:Bool = false;

	override function beatHit()
	{
		super.beatHit();

		if(lastBeatHit >= curBeat) {
			//trace('BEAT HIT: ' + curBeat + ', LAST HIT: ' + lastBeatHit);
			return;
		}

		if (generatedMusic)
		{
			if (ClientPrefs.sortNotesByOrder)
			{
				notes.sort(FlxSort.byY, ClientPrefs.downScroll ? FlxSort.ASCENDING : FlxSort.DESCENDING);
			}
		}

		flavorHUD.beatHit();

		if (gf != null && curBeat % Math.round(gfSpeed * gf.danceEveryNumBeats) == 0 && gf.animation.curAnim != null && !gf.singing && !gf.stunned)
		{
			gf.dance(forceIdleOnBeat);
		}
		if (extraChar != null && curBeat % extraChar.danceEveryNumBeats == 0 && extraChar.animation.curAnim != null && !extraChar.singing && !extraChar.stunned)
		{
			extraChar.dance(forceIdleOnBeat);
		}
		if (curBeat % boyfriend.danceEveryNumBeats == 0 && boyfriend.animation.curAnim != null && !boyfriend.singing && !boyfriend.stunned)
		{
			boyfriend.dance(forceIdleOnBeat);
		}
		if (curBeat % dad.danceEveryNumBeats == 0 && dad.animation.curAnim != null && !dad.singing && !dad.stunned)
		{
			dad.dance(forceIdleOnBeat);
		}

		if (gf != null && gf.allowTrail)
			createTrail(gf);
		if (extraChar != null && extraChar.allowTrail)
			createTrail(extraChar);
		if (boyfriend.allowTrail)
			createTrail(boyfriend);
		if (dad.allowTrail)
			createTrail(dad);

		if (generatedMusic && !endingSong && ClientPrefs.lowQuality)
			moveCameraSection();

		lastBeatHit = curBeat;

		setOnLuas('curBeat', curBeat); //DAWGG?????
		callOnLuas('onBeatHit', []);
	}

	override function sectionHit()
	{
		super.sectionHit();

		if (SONG.notes[curSection] != null)
		{
			if (SONG.notes[curSection].changeBPM)
			{
				Conductor.bpm = SONG.notes[curSection].bpm;
				setOnLuas('curBpm', Conductor.bpm);
				setOnLuas('crochet', Conductor.crochet);
				setOnLuas('stepCrochet', Conductor.stepCrochet);
			}
			setOnLuas('mustHitSection', SONG.notes[curSection].mustHitSection);
			setOnLuas('altAnim', SONG.notes[curSection].altAnim);
			setOnLuas('gfSection', SONG.notes[curSection].gfSection);
			setOnLuas('extraCharSection', SONG.notes[curSection].extraCharSection);
		}
		
		setOnLuas('curSection', curSection);
		callOnLuas('onSectionHit', []);
	}

	public function callOnLuas(event:String, args:Array<Dynamic>, ignoreStops = true, exclusions:Array<String> = null):Dynamic {
		var returnVal:Dynamic = FunkinLua.Function_Continue;
		#if LUA_ALLOWED
		if(exclusions == null) exclusions = [];
		for (script in luaArray) {
			if(exclusions.contains(script.scriptName))
				continue;

			var ret:Dynamic = script.call(event, args);
			if(ret == FunkinLua.Function_StopLua && !ignoreStops)
				break;
			
			// had to do this because there is a bug in haxe where Stop != Continue doesnt work
			var bool:Bool = ret == FunkinLua.Function_Continue;
			if(!bool) {
				returnVal = cast ret;
			}
		}
		#end
		//trace(event, returnVal);
		return returnVal;
	}

	public function setOnLuas(variable:String, arg:Dynamic) {
		#if LUA_ALLOWED
		for (i in 0...luaArray.length) {
			luaArray[i].set(variable, arg);
		}
		#end
	}

	function StrumPlayAnim(isDad:Bool, id:Int, time:Float, char:Character) {
		var spr:StrumNote = null;
		if(isDad) {
			spr = opponentStrums.members[id];
		} else {
			spr = playerStrums.members[id];
		}

		if(spr != null) {
			spr.playAnim('confirm', true);
			spr.resetAnim = time;
			spr.holding = char.holding;
		}
	}

	public var ratingName:String = '?';
	public var ratingPercent:Float;
	public var ratingFC:String;
	public var ratingLetter:String;
	public function RecalculateRating(badHit:Bool = false) {
		setOnLuas('score', songScore);
		setOnLuas('misses', songMisses);
		setOnLuas('hits', songHits);

		var ret:Dynamic = callOnLuas('onRecalculateRating', [], false);
		if(ret != FunkinLua.Function_Stop)
		{
			if(totalPlayed < 1) //Prevent divide by 0
				ratingName = '?';
			else
			{
				// Rating Percent
				ratingPercent = Math.min(1, Math.max(0, totalNotesHit / totalPlayed));
				//trace((totalNotesHit / totalPlayed) + ', Total: ' + totalPlayed + ', notes hit: ' + totalNotesHit);

				// Rating Name
				if(ratingPercent >= 1)
				{
					ratingName = ratingStuff[ratingStuff.length-1][0]; //Uses last string
				}
				else
				{
					for (i in 0...ratingStuff.length-1)
					{
						if(ratingPercent < ratingStuff[i][1])
						{
							ratingName = ratingStuff[i][0];
							break;
						}
					}
				}
			}

			// Rating FC
			ratingFC = "";
			if (marvelous > 0) ratingFC = "(MFC)" + " " + ratingLetter;
			if (sicks > 0) ratingFC = "(SFC)" + " " + ratingLetter;
			if (goods > 0) ratingFC = "(GFC)" + " " + ratingLetter;
			if (bads > 0 || shits > 0) ratingFC = "(FC)" + " " + ratingLetter;
			if (songMisses > 0 && songMisses < 10) ratingFC = "(SDCB)" + " " + ratingLetter;
			else if (songMisses >= 10) ratingFC = "(Clear)" + " " + ratingLetter;

			// Rating Letter
			ratingLetter = "";
			// WIFE TIME :)))) (based on Wife3)

			var wifeConditions:Array<Bool> = [
				accuracy >= 95, // S
				accuracy >= 80, // A
				accuracy >= 70, // B
				accuracy >= 60, // C
				accuracy >= 50, // D
				accuracy < 50, // D
			];

			for (i in 0...wifeConditions.length)
			{
				var b = wifeConditions[i];

				if (b)
				{
					switch (i)
					{
						case 0:
							ratingLetter += "S";
						case 1:
							ratingLetter += "A";
						case 2:
							ratingLetter += "B";
						case 3:
							ratingLetter += "C";
						case 4:
							ratingLetter += "D";
					}
					break;
				}
			}
			if (accuracy == 0 && !practiceMode) ratingLetter = "D";
			else if (cpuControlled) ratingLetter = "BOTPLAY";
			// else if (practiceMode) ratingLetter = "PRACTICE";
		}
		updateScore(badHit); // score will only update after rating is calculated, if it's a badHit, it shouldn't bounce -Ghost
		setOnLuas('rating', ratingPercent);
		setOnLuas('ratingName', ratingName);
		setOnLuas('ratingFC', ratingFC);
		setOnLuas('ratingLetter', ratingLetter);
	}

	var curLight:Int = -1;
	var curLightEvent:Int = -1;
}