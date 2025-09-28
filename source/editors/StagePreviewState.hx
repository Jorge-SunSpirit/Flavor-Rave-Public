package editors;

import StageData;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUITabMenu;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.sound.FlxSound;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import flixel.util.FlxTimer;
import flixel.text.FlxText;

using StringTools;

#if !flash
import flixel.addons.display.FlxRuntimeShader;
#end
#if sys
import sys.FileSystem;
import sys.io.File;
#end

class StagePreviewState extends MusicBeatState
{
	#if (haxe >= "4.0.0")
	public var variables:Map<String, Dynamic> = new Map();
	public var modchartTweens:Map<String, FlxTween> = new Map<String, FlxTween>();
	public var modchartSprites:Map<String, FunkinLua.ModchartSprite> = new Map<String, FunkinLua.ModchartSprite>();
	public var modchartTimers:Map<String, FlxTimer> = new Map<String, FlxTimer>();
	public var modchartSounds:Map<String, FlxSound> = new Map<String, FlxSound>();
	public var modchartTexts:Map<String, FunkinLua.ModchartText> = new Map<String, FunkinLua.ModchartText>();
	public var modchartSaves:Map<String, FlxSave> = new Map<String, FlxSave>();
	#else
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

	public static var curStage:String = 'stage';

	public var allowExtra:Bool = false;
	public var boyfriendGroup:FlxSpriteGroup;
	public var dadGroup:FlxSpriteGroup;
	public var gfGroup:FlxSpriteGroup;
	public var extraGroup:FlxSpriteGroup;

	public var dad:Character = null;
	public var gf:Character = null;
	public var boyfriend:Character = null;
	public var extraChar:Character = null;

	public static var bfName:String = 'hidden';
	public static var dadName:String = 'hidden';
	public static var gfName:String = 'hidden';
	public static var extraName:String = 'hidden';

	public var particleGroup:FlxTypedGroup<FlxSprite>;

	var camPos:FlxPoint;

	public var camFollow:FlxPoint;
	public var camFollowPos:FlxObject;

	public var camGame:FlxCamera;
	public var camHUD:FlxCamera;

	public var defaultCamZoom:Float = 1;

	public var boyfriendCameraOffset:Array<Float> = null;
	public var opponentCameraOffset:Array<Float> = null;
	public var girlfriendCameraOffset:Array<Float> = null;
	public var extraCameraOffset:Array<Float> = null;
	public var centerCameraOffset:Array<Float> = null;

	// Flixel UI
	var UI_box:FlxUITabMenu;

	// Lua shit
	public static var instance:StagePreviewState;
	public var luaArray:Array<PreviewLua> = [];
	private var luaDebugGroup:FlxTypedGroup<FunkinLua.DebugLuaText>;
	public var introSoundsSuffix:String = '';

	override public function create()
	{
		FlxG.mouse.visible = true;
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		Paths.clearStoredMemory();

		// for lua
		instance = this;

		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD, false);

		FlxG.cameras.setDefaultDrawTarget(camGame, true);
		FRFadeTransition.nextCamera = camHUD;

		persistentUpdate = true;
		persistentDraw = true;

		var stageData:StageFile = StageData.getStageFile(curStage);
		if (stageData == null)
		{ // Stage couldn't be found, create a dummy stage for preventing a crash
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
				camera_extra: [0, 0],
				camera_center: [0, 0],
				camera_speed: 1,
				camera_boundaries: null
			};
		}

		Paths.setCurrentLevel(stageData.directory);
		defaultCamZoom = stageData.defaultZoom;
		BF_X = stageData.boyfriend[0];
		BF_Y = stageData.boyfriend[1];
		GF_X = stageData.girlfriend[0];
		GF_Y = stageData.girlfriend[1];
		DAD_X = stageData.opponent[0];
		DAD_Y = stageData.opponent[1];

		boyfriendCameraOffset = stageData.camera_boyfriend;
		if (boyfriendCameraOffset == null) // Fucks sake should have done it since the start :rolling_eyes:
			boyfriendCameraOffset = [0, 0];

		opponentCameraOffset = stageData.camera_opponent;
		if (opponentCameraOffset == null)
			opponentCameraOffset = [0, 0];

		girlfriendCameraOffset = stageData.camera_girlfriend;
		if (girlfriendCameraOffset == null)
			girlfriendCameraOffset = [0, 0];

		extraCameraOffset = stageData.camera_extra;
		if (extraCameraOffset == null)
			extraCameraOffset = [0, 0];

		centerCameraOffset = stageData.camera_center;
		if (centerCameraOffset == null)
			centerCameraOffset = [0, 0];

		boyfriendGroup = new FlxSpriteGroup(BF_X, BF_Y);
		dadGroup = new FlxSpriteGroup(DAD_X, DAD_Y);
		gfGroup = new FlxSpriteGroup(GF_X, GF_Y);

		if (stageData.extra != null)
		{
			EXTRA_X = stageData.extra[0];
			EXTRA_Y = stageData.extra[1];
		}
		extraGroup = new FlxSpriteGroup(EXTRA_X, EXTRA_Y);

		add(gfGroup);
		if (allowExtra) add(extraGroup);
		add(dadGroup);
		add(boyfriendGroup);

		#if LUA_ALLOWED
		luaDebugGroup = new FlxTypedGroup<FunkinLua.DebugLuaText>();
		luaDebugGroup.cameras = [camHUD];
		add(luaDebugGroup);
		#end

		// STAGE SCRIPTS
		#if (MODS_ALLOWED && LUA_ALLOWED)
		var doPush:Bool = false;
		var luaFile:String = 'stages/' + curStage + '.lua';
		if (FileSystem.exists(Paths.modFolders(luaFile)))
		{
			luaFile = Paths.modFolders(luaFile);
			doPush = true;
		}
		else
		{
			luaFile = Paths.getPreloadPath(luaFile);
			if (FileSystem.exists(luaFile))
			{
				doPush = true;
			}
		}

		if (doPush)
			luaArray.push(new PreviewLua(luaFile));
		#end

		var shadows:Bool = (stageData.shadows == null) ? false : stageData.shadows;
		var pBright:Float = (stageData.player_brightness == null) ? 1.0 : stageData.player_brightness;
		var sDark:Float = (stageData.shadow_darkness == null) ? 0.5 : stageData.shadow_darkness;

		gf = new Character(0, 0, gfName);
		gf.hasShadow = shadows;
		gf.shadowDarkness = sDark;
		gf.color = FlxColor.fromRGBFloat(pBright, pBright, pBright);
		startCharacterPos(gf);
		gf.scrollFactor.set(0.95, 0.95);
		gf.visible = !stageData.hide_girlfriend;
		gfGroup.add(gf);

		extraChar = new Character(0, 0, extraName);
		extraChar.hasShadow = shadows;
		extraChar.shadowDarkness = sDark;
		extraChar.color = FlxColor.fromRGBFloat(pBright, pBright, pBright);
		startCharacterPos(extraChar);
		extraChar.scrollFactor.set(0.95, 0.95);
		extraChar.visible = allowExtra;
		extraGroup.add(extraChar);

		dad = new Character(0, 0, dadName);
		dad.hasShadow = shadows;
		dad.shadowDarkness = sDark;
		dad.color = FlxColor.fromRGBFloat(pBright, pBright, pBright);
		startCharacterPos(dad, true);
		dadGroup.add(dad);

		boyfriend = new Character(0, 0, bfName, true);
		boyfriend.hasShadow = shadows;
		boyfriend.shadowDarkness = sDark;
		boyfriend.color = FlxColor.fromRGBFloat(pBright, pBright, pBright);
		startCharacterPos(boyfriend);
		boyfriendGroup.add(boyfriend);

		camPos = new FlxPoint(girlfriendCameraOffset[0], girlfriendCameraOffset[1]);
		if (gf != null)
		{
			camPos.x += gf.getGraphicMidpoint().x + gf.cameraPosition[0];
			camPos.y += gf.getGraphicMidpoint().y + gf.cameraPosition[1];
		}
		else
		{
			camPos.x = centerCameraOffset[0];
			camPos.y = centerCameraOffset[1];
		}

		camFollow = new FlxPoint();
		camFollowPos = new FlxObject(0, 0, 1, 1);

		snapCamFollowToPos(camPos.x, camPos.y);
		add(camFollowPos);

		FlxG.camera.follow(camFollowPos, LOCKON, 1);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow);
		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);
		FlxG.fixedTimestep = false;

		particleGroup = new FlxTypedGroup<FlxSprite>();
		add(particleGroup);

		UI_box = new FlxUITabMenu(null, [{name: 'tab1', label: 'Settings'}, {name: 'tab2', label: 'Character'}], true);
		UI_box.cameras = [camHUD];
		UI_box.resize(250, 120);
		UI_box.x = FlxG.width - 275;
		UI_box.y = 25;
		add(UI_box);

		addSettingsUI();
		addCharacterUI();

		callOnLuas('onCreatePost', []);

		super.create();

		Paths.clearUnusedMemory();

		FRFadeTransition.nextCamera = camHUD;
	}

	var stageList:Array<String> = [];
	var stageDropdown:FlxUIDropDownMenuCustom;
	var zoomStepper:FlxUINumericStepper;

	function addSettingsUI()
	{
		var tab_group = new FlxUI(null, UI_box);
		tab_group.name = "tab1";

		// Generate stage array
		{
			#if MODS_ALLOWED
			var directories:Array<String> = [
				Paths.mods('stages/'),
				Paths.mods(Paths.currentModDirectory + '/stages/'),
				Paths.getPreloadPath('stages/')
			];
			for (mod in Paths.getGlobalMods())
				directories.push(Paths.mods(mod + '/stages/'));
			#else
			var directories:Array<String> = [Paths.getPreloadPath('stages/')];
			#end

			var tempMap:Map<String, Bool> = new Map<String, Bool>();
			var stageFile:Array<String> = CoolUtil.coolTextFile(Paths.txt('stageList'));
			for (i in 0...stageFile.length)
			{ // Prevent duplicates
				var stageToCheck:String = stageFile[i];
				if (!tempMap.exists(stageToCheck))
				{
					stageList.push(stageToCheck);
				}
				tempMap.set(stageToCheck, true);
			}
			#if MODS_ALLOWED
			for (i in 0...directories.length)
			{
				var directory:String = directories[i];
				if (FileSystem.exists(directory))
				{
					for (file in CoolUtil.readDirectory(directory))
					{
						var path = haxe.io.Path.join([directory, file]);
						if (!FileSystem.isDirectory(path) && file.endsWith('.json'))
						{
							var stageToCheck:String = file.substr(0, file.length - 5);
							if (!tempMap.exists(stageToCheck))
							{
								tempMap.set(stageToCheck, true);
								stageList.push(stageToCheck);
							}
						}
					}
				}
			}
			#end

			if (stageList.length < 1)
				stageList.push('stage');
		}

		stageDropdown = new FlxUIDropDownMenuCustom(10, 30, FlxUIDropDownMenuCustom.makeStrIdLabelArray(stageList, true), function(stage:String)
		{
			curStage = stageList[Std.parseInt(stage)];
			MusicBeatState.resetState();
		});
		stageDropdown.selectedLabel = curStage;

		var resetCam:FlxButton = new FlxButton(140, stageDropdown.y - 20, "Reset Camera", function()
		{
			snapCamFollowToPos(camPos.x, camPos.y);
		});

		zoomStepper = new FlxUINumericStepper(stageDropdown.x, stageDropdown.y + 45, 0.01, FlxG.camera.zoom, 0.01, 4, 2);

		var resetZoom:FlxButton = new FlxButton(140, resetCam.y + 25, "Reset Zoom", function()
		{
			FlxG.camera.zoom = defaultCamZoom;
			zoomStepper.value = FlxG.camera.zoom;
		});

		// Also done by pressing RESET
		var refresh:FlxButton = new FlxButton(140, resetZoom.y + 25, "Refresh", function()
		{
			MusicBeatState.resetState();
		});

		tab_group.add(refresh);
		tab_group.add(resetZoom);
		tab_group.add(resetCam);
		tab_group.add(new FlxText(zoomStepper.x, zoomStepper.y - 18, 0, 'Zoom:'));
		tab_group.add(zoomStepper);
		tab_group.add(new FlxText(stageDropdown.x, stageDropdown.y - 18, 0, 'Stage:'));
		tab_group.add(stageDropdown);
		UI_box.addGroup(tab_group);
	}

	var characterList:Array<String> = [];
	var char1Dropdown:FlxUIDropDownMenuCustom;
	var char2Dropdown:FlxUIDropDownMenuCustom;
	var char3Dropdown:FlxUIDropDownMenuCustom;
	var char4Dropdown:FlxUIDropDownMenuCustom;

	function addCharacterUI()
	{
		var tab_group = new FlxUI(null, UI_box);
		tab_group.name = "tab2";

		char1Dropdown = new FlxUIDropDownMenuCustom(10, 30, FlxUIDropDownMenuCustom.makeStrIdLabelArray([''], true), function(char:String)
		{
			bfName = characterList[Std.parseInt(char)];
			MusicBeatState.resetState();
		});
		reloadCharacterDropDown(char1Dropdown, boyfriend, true);

		char2Dropdown = new FlxUIDropDownMenuCustom(140, char1Dropdown.y, FlxUIDropDownMenuCustom.makeStrIdLabelArray([''], true), function(char:String)
		{
			dadName = characterList[Std.parseInt(char)];
			MusicBeatState.resetState();
		});
		reloadCharacterDropDown(char2Dropdown, dad);

		char3Dropdown = new FlxUIDropDownMenuCustom(char1Dropdown.x, char1Dropdown.y + 40, FlxUIDropDownMenuCustom.makeStrIdLabelArray([''], true), function(char:String)
		{
			gfName = characterList[Std.parseInt(char)];
			MusicBeatState.resetState();
		});
		reloadCharacterDropDown(char3Dropdown, gf);

		char4Dropdown = new FlxUIDropDownMenuCustom(char2Dropdown.x, char2Dropdown.y + 40, FlxUIDropDownMenuCustom.makeStrIdLabelArray([''], true), function(char:String)
		{
			extraName = characterList[Std.parseInt(char)];
			MusicBeatState.resetState();
		});
		reloadCharacterDropDown(char4Dropdown, extraChar);

		tab_group.add(new FlxText(char4Dropdown.x, char4Dropdown.y - 18, 0, 'Extra:'));
		tab_group.add(char4Dropdown);
		tab_group.add(new FlxText(char3Dropdown.x, char3Dropdown.y - 18, 0, 'Girlfriend:'));
		tab_group.add(char3Dropdown);
		tab_group.add(new FlxText(char2Dropdown.x, char2Dropdown.y - 18, 0, 'Opponent:'));
		tab_group.add(char2Dropdown);
		tab_group.add(new FlxText(char1Dropdown.x, char1Dropdown.y - 18, 0, 'Player:'));
		tab_group.add(char1Dropdown);
		UI_box.addGroup(tab_group);
	}

	function reloadCharacterDropDown(dropdown:FlxUIDropDownMenuCustom, char:Character, search:Bool = false)
	{
		if (search)
		{			
			var charsLoaded:Map<String, Bool> = new Map();
	
			#if MODS_ALLOWED
			characterList = [];
			var directories:Array<String> = [Paths.mods('characters/'), Paths.mods(Paths.currentModDirectory + '/characters/'), Paths.getPreloadPath('characters/')];
			for (mod in Paths.getGlobalMods())
				directories.push(Paths.mods(mod + '/characters/'));
			for (i in 0...directories.length)
			{
				var directory:String = directories[i];
				if (FileSystem.exists(directory))
				{
					for (file in CoolUtil.readDirectory(directory))
					{
						var path = haxe.io.Path.join([directory, file]);
						if (!sys.FileSystem.isDirectory(path) && file.endsWith('.json'))
						{
							var charToCheck:String = file.substr(0, file.length - 5);
							if (!charsLoaded.exists(charToCheck))
							{
								characterList.push(charToCheck);
								charsLoaded.set(charToCheck, true);
							}
						}
					}
				}
			}
			#else
			characterList = CoolUtil.coolTextFile(Paths.txt('characterList'));
			#end
		}

		dropdown.setData(FlxUIDropDownMenuCustom.makeStrIdLabelArray(characterList, true));
		dropdown.selectedLabel = char.curCharacter;
	}

	override function getEvent(id:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>)
	{
		if (id == FlxUINumericStepper.CHANGE_EVENT && (sender is FlxUINumericStepper))
		{
			switch (sender)
			{
				case zoomStepper:
				{
					FlxG.camera.zoom = zoomStepper.value;
				}
			}
		}
	}

	#if (!flash && sys)
	public var runtimeShaders:Map<String, Array<String>> = new Map<String, Array<String>>();

	public function createRuntimeShader(name:String):FlxRuntimeShader
	{
		if (!ClientPrefs.shaders)
			return new FlxRuntimeShader();

		#if (!flash && MODS_ALLOWED && sys)
		if (!runtimeShaders.exists(name) && !initLuaShader(name))
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
		if (!ClientPrefs.shaders)
			return false;

		if (runtimeShaders.exists(name))
		{
			FlxG.log.warn('Shader $name was already initialized!');
			return true;
		}

		var foldersToCheck:Array<String> = [Paths.mods('shaders/')];
		if (Paths.currentModDirectory != null && Paths.currentModDirectory.length > 0)
			foldersToCheck.insert(0, Paths.mods(Paths.currentModDirectory + '/shaders/'));

		for (mod in Paths.getGlobalMods())
			foldersToCheck.insert(0, Paths.mods(mod + '/shaders/'));

		foldersToCheck.insert(0, Paths.getPreloadPath('shaders/'));

		for (folder in foldersToCheck)
		{
			if (FileSystem.exists(folder))
			{
				var frag:String = folder + name + '.frag';
				var vert:String = folder + name + '.vert';
				var found:Bool = false;
				if (FileSystem.exists(frag))
				{
					frag = File.getContent(frag);
					found = true;
				}
				else
					frag = null;

				if (FileSystem.exists(vert))
				{
					vert = File.getContent(vert);
					found = true;
				}
				else
					vert = null;

				if (found)
				{
					runtimeShaders.set(name, [frag, vert]);
					// trace('Found shader $name!');
					return true;
				}
			}
		}
		FlxG.log.warn('Missing shader $name .frag AND .vert files!');
		return false;
	}
	#end

	public function getControl(key:String)
	{
		var pressed:Bool = Reflect.getProperty(controls, key);
		return pressed;
	}

	public function addTextToDebug(text:String, color:FlxColor)
	{
		#if LUA_ALLOWED
		luaDebugGroup.forEachAlive(function(spr:FunkinLua.DebugLuaText)
		{
			spr.y += 20;
		});

		if (luaDebugGroup.members.length > 34)
		{
			var blah = luaDebugGroup.members[34];
			blah.destroy();
			luaDebugGroup.remove(blah);
		}
		luaDebugGroup.insert(0, new FunkinLua.DebugLuaText(text, luaDebugGroup, color));
		#end
	}

	// If this doesn't return FlxSprite then everything breaks, so no Dynamic
	public function getLuaObject(tag:String, text:Bool = true):FlxSprite
	{
		if (modchartSprites.exists(tag))
			return modchartSprites.get(tag);
		if (text && modchartTexts.exists(tag))
			return modchartTexts.get(tag);
		if (variables.exists(tag))
			return variables.get(tag);
		return null;
	}

	function startCharacterPos(char:Character, ?gfCheck:Bool = false)
	{
		if (gfCheck && char.curCharacter.startsWith('gf'))
		{ // IF DAD IS GIRLFRIEND, HE GOES TO HER POSITION
			char.setPosition(GF_X, GF_Y);
			char.scrollFactor.set(0.95, 0.95);
			char.danceEveryNumBeats = 2;
		}
		char.x += char.positionArray[0];
		char.y += char.positionArray[1];
	}

	public function addBehindGF(obj:FlxObject)
	{
		insert(members.indexOf(gfGroup), obj);
	}

	public function addBehindBF(obj:FlxObject)
	{
		insert(members.indexOf(boyfriendGroup), obj);
	}

	public function addBehindDad(obj:FlxObject)
	{
		insert(members.indexOf(dadGroup), obj);
	}

	override public function update(elapsed:Float)
	{
		callOnLuas('onUpdate', [elapsed]);
		super.update(elapsed);

		if (getControl('BACK'))
		{
			MusicBeatState.switchState(new editors.MasterEditorMenu());
			FlxG.sound.playMusic(Paths.music(ClientPrefs.mainmenuMusic));
			FlxG.mouse.visible = false;
		}
		else if (getControl('RESET'))
		{
			MusicBeatState.resetState();
		}

		// Debug UI visibility (lil buggy)
		if (FlxG.keys.justPressed.H)
			UI_box.visible = !UI_box.visible;

		// camFollow controls
		{
			var press:String = FlxG.keys.pressed.CONTROL ? '_P' : '';
			var amt:Float = FlxG.keys.pressed.SHIFT ? 10 : 1;

			if (getControl('UI_UP' + press))
				camFollow.y -= amt;
			else if (getControl('UI_DOWN' + press))
				camFollow.y += amt;

			if (getControl('UI_LEFT' + press))
				camFollow.x -= amt;
			else if (getControl('UI_RIGHT' + press))
				camFollow.x += amt;
		}

		camFollow.x = Math.floor(camFollow.x);
		camFollow.y = Math.floor(camFollow.y);
		camFollowPos.setPosition(camFollow.x, camFollow.y);

		FlxG.watch.addQuick("camFollow", [camFollow.x, camFollow.y]);

		setOnLuas('cameraX', camFollow.x);
		setOnLuas('cameraY', camFollow.y);
		callOnLuas('onUpdatePost', [elapsed]);
	}

	function snapCamFollowToPos(x:Float, y:Float)
	{
		camFollow.set(x, y);
		camFollowPos.setPosition(x, y);
	}

	override function destroy()
	{
		for (lua in luaArray)
		{
			lua.call('onDestroy', []);
			lua.stop();
		}

		luaArray = [];

		#if hscript
		if (PreviewLua.hscript != null)
			PreviewLua.hscript = null;
		#end

		super.destroy();
	}

	public function callOnLuas(event:String, args:Array<Dynamic>, ignoreStops = true, exclusions:Array<String> = null):Dynamic
	{
		var returnVal:Dynamic = PreviewLua.Function_Continue;
		#if LUA_ALLOWED
		if (exclusions == null)
			exclusions = [];
		for (script in luaArray)
		{
			if (exclusions.contains(script.scriptName))
				continue;

			var ret:Dynamic = script.call(event, args);
			if (ret == PreviewLua.Function_StopLua && !ignoreStops)
				break;

			// had to do this because there is a bug in haxe where Stop != Continue doesnt work
			var bool:Bool = ret == PreviewLua.Function_Continue;
			if (!bool)
			{
				returnVal = cast ret;
			}
		}
		#end
		// trace(event, returnVal);
		return returnVal;
	}

	public function setOnLuas(variable:String, arg:Dynamic)
	{
		#if LUA_ALLOWED
		for (i in 0...luaArray.length)
		{
			luaArray[i].set(variable, arg);
		}
		#end
	}
}
