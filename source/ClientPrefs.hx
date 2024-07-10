package;

import Controls;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.util.FlxSave;

class ClientPrefs {
	public static var downScroll:Bool = false;
	public static var middleScroll:Bool = false;
	public static var opponentStrums:Bool = true;
	public static var showFPS:Bool = false;
	public static var showMemory:Bool = false;
	public static var showPeak:Bool = false;
	public static var fpsBorder:Bool = false;
	public static var sortNotesByOrder:Bool = false;
	public static var flashing:Bool = true;
	public static var globalAntialiasing:Bool = true;
	public static var noteSkin:String = 'Default';
	public static var noteSplashes:Bool = true;
	public static var lowQuality:Bool = false;
	public static var shaders:Bool = true;
	public static var framerate:Int = 60;
	public static var gpuTextures:Bool = false;
	public static var cursing:Bool = true;
	public static var violence:Bool = true;
	public static var hideHud:Bool = false;
	public static var noteOffset:Int = 0;
	public static var ghostTapping:Bool = true;
	public static var timeBarType:String = 'Combined';
	public static var scoreZoom:Bool = true;
	public static var comboStacking = false;
	public static var judgementCounter:Bool = false;
	public static var scoreScreen:Bool = true;
	public static var noReset:Bool = false;
	public static var healthBarAlpha:Float = 1;
	public static var laneAlpha:Float = 0;
	public static var dynamicLaneOpacity:Bool = false;
	public static var displayNPS:Bool = true;
	public static var displayRating:Bool = true;
	public static var showRating:Bool = true;
	public static var timingIndicator:String = 'Precise';
	public static var controllerMode:Bool = false;
	public static var autoPause:Bool = false;
	public static var menuMouse:Bool = false;
	public static var mainmenuMusic:String = 'freakyMenu';
	public static var pastOGWeek:Bool = false;
	public static var hitsoundVolume:Float = 0;
	public static var checkForUpdates:Bool = true;
	public static var watermarks:Bool = false;
	#if SONG_ROLLBACK
	public static var songRollback:Bool = false;
	#end
	public static var gameplaySettings:Map<String, Dynamic> = [
		'scrollspeed' => 1.0,
		'scrolltype' => 'multiplicative', 
		// anyone reading this, amod is multiplicative speed mod, cmod is constant speed mod, and xmod is bpm based speed mod.
		// an amod example would be chartSpeed * multiplier
		// cmod would just be constantSpeed = chartSpeed
		// and xmod basically works by basing the speed on the bpm.
		// iirc (beatsPerSecond * (conductorToNoteDifference / 1000)) * noteSize (110 or something like that depending on it, prolly just use note.height)
		// bps is calculated by bpm / 60
		// oh yeah and you'd have to actually convert the difference to seconds which I already do, because this is based on beats and stuff. but it should work
		// just fine. but I wont implement it because I don't know how you handle sustains and other stuff like that.
		// oh yeah when you calculate the bps divide it by the songSpeed or rate because it wont scroll correctly when speeds exist.
		'songspeed' => 1.0,
		'healthgain' => 1.0,
		'healthloss' => 1.0,
		'instakill' => false,
		'practice' => false,
		'botplay' => false,
		'opponentplay' => false
	];

	public static var comboOffset:Array<Int> = [0, 0, 0, 0];
	public static var ratingOffset:Float = 0;
	public static var marvelousWindow:Float = 16;
	public static var sickWindow:Float = 47;
	public static var goodWindow:Float = 79;
	public static var badWindow:Float = 109;
	public static var shitWindow:Float = 133;
	public static var safeFrames:Float = 10;

	//Every key has two binds, add your key bind down here and then add your control on options/ControlsSubState.hx and Controls.hx
	public static var keyBinds:Map<String, Array<FlxKey>> = [
		//Key Bind, Name for ControlsSubState
		'note_left'		=> [A, LEFT],
		'note_down'		=> [S, DOWN],
		'note_up'		=> [W, UP],
		'note_right'	=> [D, RIGHT],
		
		'ui_left'		=> [A, LEFT],
		'ui_down'		=> [S, DOWN],
		'ui_up'			=> [W, UP],
		'ui_right'		=> [D, RIGHT],
		
		'accept'		=> [SPACE, ENTER],
		'back'			=> [BACKSPACE, ESCAPE],
		'pause'			=> [ENTER, ESCAPE],
		'reset'			=> [R, NONE],
		
		'volume_mute'	=> [ZERO, NONE],
		'volume_up'		=> [NUMPADPLUS, PLUS],
		'volume_down'	=> [NUMPADMINUS, MINUS],
		
		'debug_1'		=> [SEVEN, NONE],
		'debug_2'		=> [EIGHT, NONE]
	];
	public static var defaultKeys:Map<String, Array<FlxKey>> = null;

	public static function loadDefaultKeys() {
		defaultKeys = keyBinds.copy();
		//trace(defaultKeys);
	}

	public static function saveSettings() {
		FlxG.save.data.downScroll = downScroll;
		FlxG.save.data.middleScroll = middleScroll;
		FlxG.save.data.opponentStrums = opponentStrums;
		FlxG.save.data.watermarks = watermarks;
		#if SONG_ROLLBACK
		FlxG.save.data.songRollback = songRollback;
		#end
		FlxG.save.data.showFPS = showFPS;
		FlxG.save.data.showMemory = showMemory;
		FlxG.save.data.showPeak = showPeak;
		//FlxG.save.data.fpsBorder = fpsBorder;
		FlxG.save.data.flashing = flashing;
		FlxG.save.data.globalAntialiasing = globalAntialiasing;
		FlxG.save.data.noteSkin = noteSkin;
		FlxG.save.data.noteSplashes = noteSplashes;
		FlxG.save.data.lowQuality = lowQuality;
		FlxG.save.data.shaders = shaders;
		FlxG.save.data.framerate = framerate;
		FlxG.save.data.gpuTextures = gpuTextures;
		//FlxG.save.data.cursing = cursing;
		//FlxG.save.data.violence = violence;
		FlxG.save.data.noteOffset = noteOffset;
		FlxG.save.data.hideHud = hideHud;
		FlxG.save.data.ghostTapping = ghostTapping;
		FlxG.save.data.timeBarType = timeBarType;
		FlxG.save.data.scoreZoom = scoreZoom;
		FlxG.save.data.comboStacking = comboStacking;
		FlxG.save.data.judgementCounter = judgementCounter;
		FlxG.save.data.scoreScreen = scoreScreen;
		FlxG.save.data.displayNPS = displayNPS;
		FlxG.save.data.displayRating = displayRating;
		FlxG.save.data.showRating = showRating;
		FlxG.save.data.timingIndicator = timingIndicator;		
		FlxG.save.data.noReset = noReset;
		FlxG.save.data.healthBarAlpha = healthBarAlpha;
		FlxG.save.data.laneAlpha = laneAlpha;
		FlxG.save.data.dynamicLaneOpacity = dynamicLaneOpacity;
		FlxG.save.data.comboOffset = comboOffset;

		FlxG.save.data.ratingOffset = ratingOffset;
		FlxG.save.data.marvelousWindow = marvelousWindow;
		FlxG.save.data.sickWindow = sickWindow;
		FlxG.save.data.goodWindow = goodWindow;
		FlxG.save.data.badWindow = badWindow;
		FlxG.save.data.shitWindow = shitWindow;
		//FlxG.save.data.safeFrames = safeFrames;
		FlxG.save.data.gameplaySettings = gameplaySettings;
		FlxG.save.data.controllerMode = controllerMode;
		FlxG.save.data.autoPause = autoPause;
		FlxG.save.data.menuMouse = menuMouse;
		FlxG.save.data.mainmenuMusic = mainmenuMusic;
		FlxG.save.data.hitsoundVolume = hitsoundVolume;
		FlxG.save.data.checkForUpdates = checkForUpdates;
		FlxG.save.data.pastOGWeek = pastOGWeek;
		FlxG.save.flush();

		var save:FlxSave = new FlxSave();
		save.bind('controls_v2', CoolUtil.getSavePath()); //Placing this in a separate save so that it can be manually deleted without removing your Score and stuff
		save.data.customControls = keyBinds;
		save.flush();
		FlxG.log.add("Settings saved!");
	}

	public static function loadPrefs() {
		if(FlxG.save.data.downScroll != null) {
			downScroll = FlxG.save.data.downScroll;
		}
		if(FlxG.save.data.middleScroll != null) {
			middleScroll = FlxG.save.data.middleScroll;
		}
		if(FlxG.save.data.opponentStrums != null) {
			opponentStrums = FlxG.save.data.opponentStrums;
		}
		if(FlxG.save.data.showFPS != null) {
			showFPS = FlxG.save.data.showFPS;
		}
		if(FlxG.save.data.showMemory != null) {
			showMemory = FlxG.save.data.showMemory;
		}
		if(FlxG.save.data.showPeak != null) {
			showPeak = FlxG.save.data.showPeak;
		}
		/*
		if(FlxG.save.data.fpsBorder != null) {
			fpsBorder = FlxG.save.data.fpsBorder;
		}
		*/
		if(FlxG.save.data.flashing != null) {
			flashing = FlxG.save.data.flashing;
		}
		if(FlxG.save.data.globalAntialiasing != null) {
			globalAntialiasing = FlxG.save.data.globalAntialiasing;
		}
		if(FlxG.save.data.noteSplashes != null) {
			noteSplashes = FlxG.save.data.noteSplashes;
		}
		if (FlxG.save.data.noteSkin != null) {
			noteSkin = FlxG.save.data.noteSkin;
		}
		if(FlxG.save.data.lowQuality != null) {
			lowQuality = FlxG.save.data.lowQuality;
		}
		if(FlxG.save.data.shaders != null) {
			shaders = FlxG.save.data.shaders;
		}
		if(FlxG.save.data.framerate != null) {
			framerate = FlxG.save.data.framerate;
		}
		#if !html5
		else
		{
			final refreshRate:Int = FlxG.stage.application.window.displayMode.refreshRate;
			framerate = Std.int(FlxMath.bound(refreshRate, Main.MIN_FRAMERATE, Main.MAX_FRAMERATE));
		}
		#end
		if(framerate > FlxG.drawFramerate) {
			FlxG.updateFramerate = framerate;
			FlxG.drawFramerate = framerate;
		} else {
			FlxG.drawFramerate = framerate;
			FlxG.updateFramerate = framerate;
		}
		if(FlxG.save.data.gpuTextures != null) {
			gpuTextures = FlxG.save.data.gpuTextures;
		}
		/*if(FlxG.save.data.cursing != null) {
			cursing = FlxG.save.data.cursing;
		}
		if(FlxG.save.data.violence != null) {
			violence = FlxG.save.data.violence;
		}*/
		if(FlxG.save.data.hideHud != null) {
			hideHud = FlxG.save.data.hideHud;
		}
		if(FlxG.save.data.noteOffset != null) {
			noteOffset = FlxG.save.data.noteOffset;
		}
		if(FlxG.save.data.ghostTapping != null) {
			ghostTapping = FlxG.save.data.ghostTapping;
		}
		if(FlxG.save.data.timeBarType != null) {
			timeBarType = FlxG.save.data.timeBarType;
		}
		if(FlxG.save.data.scoreZoom != null) {
			scoreZoom = FlxG.save.data.scoreZoom;
		}
		if(FlxG.save.data.comboStacking != null) {
			comboStacking = FlxG.save.data.comboStacking;
		}		
		if(FlxG.save.data.judgementCounter != null) {
			judgementCounter = FlxG.save.data.judgementCounter;
		}		
		if(FlxG.save.data.scoreScreen != null) {
			scoreScreen = FlxG.save.data.scoreScreen;
		}			
		if(FlxG.save.data.noReset != null) {
			noReset = FlxG.save.data.noReset;
		}
		if(FlxG.save.data.healthBarAlpha != null) {
			healthBarAlpha = FlxG.save.data.healthBarAlpha;
		}
		if(FlxG.save.data.laneAlpha != null) {
			laneAlpha = FlxG.save.data.laneAlpha;
		}	
		if(FlxG.save.data.dynamicLaneOpacity != null) {
			dynamicLaneOpacity = FlxG.save.data.dynamicLaneOpacity;
		}		
		if(FlxG.save.data.displayNPS != null) {
			displayNPS = FlxG.save.data.displayNPS;
		}
		if(FlxG.save.data.displayRating != null) {
			displayRating = FlxG.save.data.displayRating;
		}
		if(FlxG.save.data.showRating != null) {
			showRating = FlxG.save.data.showRating;
		}
		if(FlxG.save.data.timingIndicator != null) {
			timingIndicator = FlxG.save.data.timingIndicator;
		}				
		if(FlxG.save.data.comboOffset != null) {
			comboOffset = FlxG.save.data.comboOffset;
		}
		if(FlxG.save.data.ratingOffset != null) {
			ratingOffset = FlxG.save.data.ratingOffset;
		}
		if(FlxG.save.data.marvelousWindow != null) {
			marvelousWindow = FlxG.save.data.marvelousWindow;
		}
		if(FlxG.save.data.sickWindow != null) {
			sickWindow = FlxG.save.data.sickWindow;
		}
		if(FlxG.save.data.goodWindow != null) {
			goodWindow = FlxG.save.data.goodWindow;
		}
		if(FlxG.save.data.badWindow != null) {
			badWindow = FlxG.save.data.badWindow;
		}
		if(FlxG.save.data.shitWindow != null) {
			shitWindow = FlxG.save.data.shitWindow;
		}
		/*
		if(FlxG.save.data.safeFrames != null) {
			safeFrames = FlxG.save.data.safeFrames;
		}
		*/
		if(FlxG.save.data.controllerMode != null) {
			controllerMode = FlxG.save.data.controllerMode;
		}
		if(FlxG.save.data.autoPause != null) {
			autoPause = FlxG.save.data.autoPause;
		}
		if(FlxG.save.data.menuMouse != null) {
			menuMouse = FlxG.save.data.menuMouse;
		}
		if(FlxG.save.data.mainmenuMusic != null) {
			if(Paths.fileExists('music/${mainmenuMusic}.ogg', MUSIC))
				mainmenuMusic = FlxG.save.data.mainmenuMusic;
			else
				mainmenuMusic = 'freakyMenu';
		}			
		if(FlxG.save.data.hitsoundVolume != null) {
			hitsoundVolume = FlxG.save.data.hitsoundVolume;
		}
		if(FlxG.save.data.gameplaySettings != null) {
			var savedMap:Map<String, Dynamic> = FlxG.save.data.gameplaySettings;
			for (name => value in savedMap)
			{
				gameplaySettings.set(name, value);
			}
		}
		
		// flixel automatically saves your volume!
		if(FlxG.save.data.volume != null) {
			FlxG.sound.volume = FlxG.save.data.volume;
		}
		if(FlxG.save.data.mute != null) {
			FlxG.sound.muted = FlxG.save.data.mute;
		}
		if(FlxG.save.data.checkForUpdates != null) {
			checkForUpdates = FlxG.save.data.checkForUpdates;
		}
		if(FlxG.save.data.pastOGWeek != null) {
			pastOGWeek = FlxG.save.data.pastOGWeek;
		}
		if(FlxG.save.data.watermarks != null) {
			watermarks = FlxG.save.data.watermarks;
		}
		#if SONG_ROLLBACK
		if(FlxG.save.data.songRollback != null) {
			songRollback = FlxG.save.data.songRollback;
		}
		#end
		var save:FlxSave = new FlxSave();
		save.bind('controls_v2', CoolUtil.getSavePath());
		if(save != null && save.data.customControls != null) {
			var loadedControls:Map<String, Array<FlxKey>> = save.data.customControls;
			for (control => keys in loadedControls) {
				keyBinds.set(control, keys);
			}
			reloadControls();
		}
	}

	inline public static function getGameplaySetting(name:String, defaultValue:Dynamic):Dynamic {
		return /*PlayState.isStoryMode ? defaultValue : */ (gameplaySettings.exists(name) ? gameplaySettings.get(name) : defaultValue);
	}

	public static function reloadControls() {
		PlayerSettings.player1.controls.setKeyboardScheme(KeyboardScheme.Solo);

		TitleState.muteKeys = copyKey(keyBinds.get('volume_mute'));
		TitleState.volumeDownKeys = copyKey(keyBinds.get('volume_down'));
		TitleState.volumeUpKeys = copyKey(keyBinds.get('volume_up'));
		FlxG.sound.muteKeys = TitleState.muteKeys;
		FlxG.sound.volumeDownKeys = TitleState.volumeDownKeys;
		FlxG.sound.volumeUpKeys = TitleState.volumeUpKeys;
	}
	public static function copyKey(arrayToCopy:Array<FlxKey>):Array<FlxKey> {
		var copiedArray:Array<FlxKey> = arrayToCopy.copy();
		var i:Int = 0;
		var len:Int = copiedArray.length;

		while (i < len) {
			if(copiedArray[i] == NONE) {
				copiedArray.remove(NONE);
				--i;
			}
			i++;
			len = copiedArray.length;
		}
		return copiedArray;
	}
}
