package options;

#if discord_rpc
import Discord.DiscordClient;
#end
import flash.geom.Rectangle;
import flash.text.TextField;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxButtonPlus;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import haxe.Json;
import haxe.format.JsonParser;
import haxe.Http;
import lime.utils.Assets;
import openfl.display.BitmapData;
import openfl.utils.Assets as OpenFlAssets;
import sys.FileSystem;
import sys.io.File;

import flixel.math.FlxMath;

import flixel.addons.display.FlxBackdrop;

import flash.display.Bitmap;
import flash.display.Loader;
import flash.net.URLRequest;
import flash.events.Event;

using StringTools;
/*import haxe.zip.Reader;
import haxe.zip.Entry;
import haxe.zip.Uncompress;
import haxe.zip.Writer;*/


class ModsMenuState extends MusicBeatState
{
	var mods:Array<ModMetadata> = [];

	var bg:FlxSprite;
	var screenEffect:FlxBackdrop;
	var fg:FlxSprite;

	var availableDLC:FlxSprite;

	var noModsTxt:FlxText;
	var descriptionTxt:FlxText;
	var needaReset = false;
	private static var curSelected:Int = 0;
	public static var wayEntered:String = 'options';

	var modsList:Array<Dynamic> = [];

	var visibleWhenNoMods:Array<FlxBasic> = [];
	var visibleWhenHasMods:Array<FlxBasic> = [];

	var officialList:Array<String> = ["DLC1", "Tres Leches (HQ)"]; // Keeps these two on top.

	// DLC List Loading
	private var dlcData:String;
	private var dlcURL:String = "https://itisiweeg.neocities.org/testFile.json";
	// Image loading
	private var urlToUse:URLRequest;
	private var loader:Loader;

	var imagesToLoad:Array<String> = [];
	var downloadingImages:Bool = false;

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
		WeekData.setDirectoryFromWeek();

		#if discord_rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		bg = new FlxSprite().loadGraphic(Paths.image('dlc/bg'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		bg.screenCenter();

		noModsTxt = new FlxText(0, 0, FlxG.width, "DLC THING DIDN'T WORK\nUH OH", 48);
		if(FlxG.random.bool(0.1)) noModsTxt.text += '\nLike I said, I\'m Psychic!.'; //maizono
		noModsTxt.setFormat(Language.font.get('vcr'), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		noModsTxt.scrollFactor.set();
		noModsTxt.borderSize = 2;
		add(noModsTxt);
		noModsTxt.screenCenter();
		visibleWhenNoMods.push(noModsTxt);

		for (i in 0...officialList.length)
		{
			addToModsList([officialList[i], true]);
		}

		var path:String = 'dlcList.txt';
		if(FileSystem.exists(path))
		{
			var leMods:Array<String> = CoolUtil.coolTextFile(path);
			for (i in 0...leMods.length) // should only ever be an even number. 
			{
				if(leMods.length > 1 && leMods[0].length > 0) {
					var modSplit:Array<String> = leMods[i].split('|');
					if(!Paths.ignoreModFolders.contains(modSplit[0].toLowerCase()))
					{
						addToModsList([modSplit[0], true]);
						//trace(modSplit[1]);
					}
				}
			}
		}

		// FIND MOD FOLDERS
		var boolshit = true;
		if (FileSystem.exists("dlcList.txt")){
			for (folder in Paths.getModDirectories())
			{
				if(!Paths.ignoreModFolders.contains(folder))
				{
					addToModsList([folder, true]); //i like it false by default. -bb //Well, i like it True! -Shadow
				}
			}
		}
		saveTxt();

		//grabDLCList();
		var http = new Http(dlcURL);
		http.onData = function(data:String)
		{
			if (data != dlcData)
			{
				trace("DATA LOADED! DATA: " + data);
				dlcData = data;
				grabDLCList();
			}
		}
		http.onError = function (error) {
			trace('error: $error');
		}

		http.request();

		var i:Int = 0;
		var len:Int = modsList.length;
		while (i < modsList.length)
		{
			var values:Array<Dynamic> = modsList[i];
			if(!FileSystem.exists(Paths.mods(values[0])))
			{
				modsList.remove(modsList[i]);
				continue;
			}

			var newMod:ModMetadata = new ModMetadata(values[0]);
			newMod.downloaded = true;
			if (newMod.hidden)
			{
				i++;
				continue;
			}
			mods.push(newMod);
			loadDLCGraphics(newMod);
			i++;
		}

		descriptionTxt = new FlxText(mods[0].alphabet.x, mods[0].bg.y + 70, mods[0].bg.width - 280, "", 30);
		descriptionTxt.setFormat(Language.font.get('despair'), 30, 0xFFFFB5, LEFT);
		descriptionTxt.scrollFactor.set();
		add(descriptionTxt);
		visibleWhenHasMods.push(descriptionTxt);

		availableDLC = new FlxSprite(96, 58);
		availableDLC.frames = Paths.getSparrowAtlas('dlc/menutext');
		availableDLC.animation.addByPrefix('idle', 'menu', 2, true);
		availableDLC.animation.play('idle', true);
		add(availableDLC);

		screenEffect = new FlxBackdrop(Paths.image('dlc/screen'), Y);
		screenEffect.velocity.y = 5;
		screenEffect.blend = "screen";
		add(screenEffect);
		screenEffect.screenCenter();

		fg = new FlxSprite().loadGraphic(Paths.image('dlc/border'));
		fg.antialiasing = ClientPrefs.globalAntialiasing;
		add(fg);
		fg.screenCenter();

		if(curSelected >= mods.length) curSelected = 0;

		changeSelection();
		updatePosition();
		FlxG.sound.play(Paths.sound('scrollMenu'));

		FlxG.mouse.visible = true;

		super.create();
	}

	function loadDLCGraphics(newMod:ModMetadata, ?skipIcon:Bool = false)
	{
		newMod.bg = new FlxSprite(0, 0).loadGraphic(Paths.image('dlc/box_reg'));
		newMod.bg.screenCenter(X);
		add(newMod.bg);

		newMod.downloadedText = new FlxText(newMod.bg.x + 260, newMod.bg.y + 10, newMod.bg.width - 280, (newMod.downloaded ? "" : "NOT INSTALLED - PRESS CONFIRM TO DOWNLOAD"), 24);
		newMod.downloadedText.setFormat(Language.font.get('despair'), 24, 0xFF3737, CENTER);
		add(newMod.downloadedText);

		newMod.typeText = new FlxText(newMod.bg.x + 260, newMod.bg.y + 115, newMod.bg.width - 280, newMod.type, 30);
		newMod.typeText.setFormat(Language.font.get('despair'), 30, 0xFAFFFFF, LEFT);
		add(newMod.typeText);

		newMod.releaseText = new FlxText(newMod.typeText.x, newMod.typeText.y, newMod.typeText.width, "RELEASED: " + newMod.release, 30);
		newMod.releaseText.setFormat(Language.font.get('despair'), 30, 0xFAFFFFF, RIGHT);
		add(newMod.releaseText);

		newMod.alphabet = new FlxText(newMod.bg.x + 260, newMod.bg.y + 30, newMod.bg.width - 280, ">" + newMod.name, 45);
		newMod.alphabet.setFormat(Language.font.get('despair'), 45, 0xFAFFFFF, LEFT);
		add(newMod.alphabet);
		//Don't ever cache the icons, it's a waste of loaded memory
		var loadedIcon:BitmapData = null;
		var iconToUse:String = Paths.mods(newMod.folder + '/pack.png');
		if(FileSystem.exists(iconToUse))
		{
			loadedIcon = BitmapData.fromFile(iconToUse);
		}

		newMod.icon = new AttachedSprite();
		if(loadedIcon != null)
		{
			newMod.icon.loadGraphic(loadedIcon, true, 223, 127);//animated icon support
			var totalFrames = Math.floor(loadedIcon.width / 223) * Math.floor(loadedIcon.height / 127);
			newMod.icon.animation.add("icon", [for (i in 0...totalFrames) i],10);
			newMod.icon.animation.play("icon");
			newMod.hasIcon = true;
		}
		else if (!skipIcon)
		{
			newMod.icon.loadGraphic(Paths.image('dlc/placeholder-icon'));
			newMod.hasIcon = true;
		}
		newMod.icon.sprTracker = newMod.bg;
		newMod.icon.xAdd = 17;
		newMod.icon.yAdd = 13;
		add(newMod.icon);
		if(skipIcon) newMod.icon.visible = false;
	}

	/*function getIntArray(max:Int):Array<Int>{
		var arr:Array<Int> = [];
		for (i in 0...max) {
			arr.push(i);
		}
		return arr;
	}*/
	function addToModsList(values:Array<Dynamic>)
	{
		for (i in 0...modsList.length)
		{
			if(modsList[i][0] == values[0])
			{
				//trace(modsList[i][0], values[0]);
				return;
			}
		}
		modsList.push(values);
	}

	function moveMod(change:Int, skipResetCheck:Bool = false)
	{
		if(mods.length > 1)
		{
			var doRestart:Bool = (mods[0].restart);

			var newPos:Int = curSelected + change;
			if(newPos < 0)
			{
				modsList.push(modsList.shift());
				mods.push(mods.shift());
			}
			else if(newPos >= mods.length)
			{
				modsList.insert(0, modsList.pop());
				mods.insert(0, mods.pop());
			}
			else
			{
				var lastArray:Array<Dynamic> = modsList[curSelected];
				modsList[curSelected] = modsList[newPos];
				modsList[newPos] = lastArray;

				var lastMod:ModMetadata = mods[curSelected];
				mods[curSelected] = mods[newPos];
				mods[newPos] = lastMod;
			}
			changeSelection(change);

			if(!doRestart) doRestart = mods[curSelected].restart;
			if(!skipResetCheck && doRestart) needaReset = true;
		}
	}

	function saveTxt()
	{
		var fileStr:String = '';
		for (values in modsList)
		{
			if(fileStr.length > 0) fileStr += '\n';
			fileStr += values[0] + '|' + (values[1] ? '1' : '0');
		}

		var path:String = 'dlcList.txt';
		File.saveContent(path, fileStr);
		Paths.pushGlobalMods();
	}

	var noModsSine:Float = 0;
	var canExit:Bool = true;
	override function update(elapsed:Float)
	{
		if(noModsTxt.visible)
		{
			noModsSine += 180 * elapsed;
			noModsTxt.alpha = 1 - Math.sin((Math.PI * noModsSine) / 180);
		}

		if (controls.ACCEPT)
		{
			if (mods[curSelected].downloaded == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
				CoolUtil.browserLoad(mods[curSelected].link);
			}
		}

		if(canExit && controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.mouse.visible = false;
			saveTxt();
			Language.init(); // Languages are set up as mods so we need to re-init here
			if(needaReset)
			{
				//MusicBeatState.switchState(new TitleState());
				TitleState.initialized = false;
				FlxG.sound.music.fadeOut(0.3);
				for (vocal in FreeplayState.vocalTracks)
				{
					if (vocal != null)
					{
						vocal.fadeOut(0.3, function(tween:FlxTween)
						{
							vocal = null;
						});
					}
				}
				FreeplayState.vocalTracks.clear();
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				FlxG.camera.fade(FlxColor.BLACK, 0.5, false, FlxG.resetGame, false);
			}
			else
			{
				switch (wayEntered)
				{
					default:
						MusicBeatState.switchState(new OptionsState());
					case 'synsun':
						MusicBeatState.switchState(new SunSynthState());
				}
				wayEntered = 'options';
			}
		}
		if(FlxG.mouse.wheel != 0)
		{
			changeSelection(-FlxG.mouse.wheel);
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		if(controls.UI_UP_P)
		{
			changeSelection(-1);
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		if(controls.UI_DOWN_P)
		{
			changeSelection(1);
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		updatePosition(elapsed);
		super.update(elapsed);
		getDLCImages();
	}

	function setAllLabelsOffset(button:FlxButton, x:Float, y:Float)
	{
		for (point in button.labelOffsets)
		{
			point.set(x, y);
		}
	}

	function changeSelection(change:Int = 0)
	{
		var noMods:Bool = (mods.length < 1);
		for (obj in visibleWhenHasMods)
		{
			obj.visible = !noMods;
		}
		for (obj in visibleWhenNoMods)
		{
			obj.visible = noMods;
		}
		if(noMods) return;

		curSelected += change;
		if(curSelected < 0)
			curSelected = mods.length - 1;
		else if(curSelected >= mods.length)
			curSelected = 0;

		var i:Int = 0;
		for (mod in mods)
		{
			if(i == curSelected)
			{
				mod.bg.loadGraphic(Paths.image('dlc/box_selected'));
				mod.alphabet.alpha = 1;
				descriptionTxt.text = mod.description;
				if (mod.restart){//finna make it to where if nothing changed then it won't reset
					descriptionTxt.text += " (This Mod will restart the game!)";
				}

				// correct layering
				var stuffArray:Array<FlxSprite> = [mod.bg, descriptionTxt, mod.typeText, mod.downloadedText, mod.releaseText, mod.alphabet, mod.icon];
				for (obj in stuffArray)
				{
					remove(obj);
					insert(members.indexOf(availableDLC), obj);
				}
			}
			else
			{
				mod.bg.loadGraphic(Paths.image('dlc/box_reg'));
			}
			i++;
		}
	}

	function updatePosition(elapsed:Float = -1)
	{
		for (i in 0...mods.length)
		{
			var intendedPos:Float = (i * 170) + 120;
			if (mods.length > 3) intendedPos -= (FlxMath.bound(curSelected - 1, 0, mods.length - 3) * 170); // thank you past weeg for writing that code for cerulsymph :D
			if(elapsed == -1)
			{
				mods[i].bg.y = intendedPos;
			}
			else
			{
				mods[i].bg.y = FlxMath.lerp(mods[i].bg.y, intendedPos, CoolUtil.boundTo(elapsed * 12, 0, 1));
			}

			mods[i].alphabet.x = mods[i].typeText.x = mods[i].downloadedText.x = mods[i].bg.x + 260;
			mods[i].alphabet.y = mods[i].bg.y + 30;
			mods[i].downloadedText.y = mods[i].bg.y + 10;

			mods[i].typeText.y = mods[i].releaseText.y = mods[i].bg.y + 115;

			if(i == curSelected)
			{
				descriptionTxt.y = mods[i].bg.y + 70;
			}
		}
	}

	function grabDLCList()
	{
		if (dlcData == null) return;
		var extraData:Array<Dynamic> = [];

		// PLACEHOLDER UNTIL I GET SOMETHING UP AND RUNNING
		var rawData = dlcData;
		if (!rawData.startsWith("{"))
		{
			// Small way to prevent non-JSON formatted files from being loaded.
			trace("FILE LOADED NOT A JSON! TERMINATING!");
			return;
		}
		extraData = Json.parse(rawData).data;
		if (extraData == null) return;
		trace(extraData[1].description);

		for (i in 0...extraData.length)
		{
			var exists:Bool = false;
			for (j in 0...modsList.length)
			{
				if (modsList[j][0] == extraData[i].folder)
				{
					exists = true;
					trace("FOLDER EXISTS! SKIP!");
					break;
				}
			}
			if (!exists)
			{
				trace("FOLDER DOES NOT EXIST: " + extraData[i].folder + "! TRY TO DOWNLOAD IT!");
				imagesToLoad.push(extraData[i].thumb);
				addUndownloadedMod(extraData[i]);
			}
		}

		trace("GOTTA LOAD THESE IMAGES: " + imagesToLoad);

	}

	function addUndownloadedMod(data:Dynamic)
	{
		var metadata = new ModMetadata("");
		metadata.name = data.name;
		metadata.type = data.type;
		metadata.release = data.release;
		metadata.description = data.description;
		metadata.link = data.link;
		mods.insert(0, metadata);

		loadDLCGraphics(metadata, true);
	}

	function getDLCImages()
	{
		if (downloadingImages || imagesToLoad.length < 1) return;
		urlToUse = new URLRequest(imagesToLoad[0]);
		loader = new Loader();

		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, urlImageLoaded);
		loader.load(urlToUse);
		downloadingImages = true;
	}

	function urlImageLoaded(event:Event)
	{
		trace("CONGRATS DIPSHIT! YOU LOADED: " + imagesToLoad[0] + "! Here's it's raw data: " + event.target.content);
		var bitmap:Bitmap = event.target.content;
		for (i in 0...mods.length)
		{
			if (!mods[i].hasIcon)
			{
				trace("adding icon to: " + mods[i].name);
				mods[i].icon.loadGraphic(bitmap.bitmapData);
				mods[i].icon.visible = true;
			}
		}
		imagesToLoad.remove(imagesToLoad[0]);
		downloadingImages = false;
	}

	/*var _file:FileReference = null;
	function installMod() {
		var zipFilter:FileFilter = new FileFilter('ZIP', 'zip');
		_file = new FileReference();
		_file.addEventListener(Event.SELECT, onLoadComplete);
		_file.addEventListener(Event.CANCEL, onLoadCancel);
		_file.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
		_file.browse([zipFilter]);
		canExit = false;
	}

	function onLoadComplete(_):Void
	{
		_file.removeEventListener(Event.SELECT, onLoadComplete);
		_file.removeEventListener(Event.CANCEL, onLoadCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);

		var fullPath:String = null;
		@:privateAccess
		if(_file.__path != null) fullPath = _file.__path;

		if(fullPath != null)
		{
			var rawZip:String = File.getContent(fullPath);
			if(rawZip != null)
			{
				MusicBeatState.resetState();
				var uncompressingFile:Bytes = new Uncompress().run(File.getBytes(rawZip));
				if (uncompressingFile.done)
				{
					trace('test');
					_file = null;
					return;
				}
			}
		}
		_file = null;
		canExit = true;
		trace("File couldn't be loaded! Wtf?");
	}

	function onLoadCancel(_):Void
	{
		_file.removeEventListener(Event.SELECT, onLoadComplete);
		_file.removeEventListener(Event.CANCEL, onLoadCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
		_file = null;
		canExit = true;
		trace("Cancelled file loading.");
	}

	function onLoadError(_):Void
	{
		_file.removeEventListener(Event.SELECT, onLoadComplete);
		_file.removeEventListener(Event.CANCEL, onLoadCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
		_file = null;
		canExit = true;
		trace("Problem loading file");
	}*/
}

class ModMetadata
{
	public var folder:String;
	public var name:String;
	public var description:String;
	public var color:FlxColor;
	public var restart:Bool;//trust me. this is very important
	public var alphabet:FlxText;
	public var bg:FlxSprite;
	public var icon:AttachedSprite;
	public var type:String;
	public var release:String;
	public var hidden:Bool;

	public var releaseText:FlxText;
	public var typeText:FlxText;
	public var downloadedText:FlxText;

	public var downloaded:Bool;
	public var hasIcon:Bool;
	public var link:String;

	public function new(folder:String)
	{
		this.folder = folder;
		this.name = folder;
		this.description = "Roy has teh phire.";
		this.restart = false;
		this.type = "Psych Engine Mod";
		this.release = "IDK LOL";
		this.hidden = false;
		this.downloaded = false;
		this.link = "";
		this.hasIcon = false;

		//Try loading json
		var path = Paths.mods(folder + '/pack.json');
		if(FileSystem.exists(path)) {
			var rawJson:String = File.getContent(path);
			if(rawJson != null && rawJson.length > 0) {
				var stuff:Dynamic = Json.parse(rawJson);
					//using reflects cuz for some odd reason my haxe hates the stuff.var shit
					var colors:Array<Int> = Reflect.getProperty(stuff, "color");
					var description:String = Reflect.getProperty(stuff, "description");
					var name:String = Reflect.getProperty(stuff, "name");
					var restart:Bool = Reflect.getProperty(stuff, "restart");
					var release:String = Reflect.getProperty(stuff, "release");
					var type:String = Reflect.getProperty(stuff, "type");
					var hidden:Bool = Reflect.getProperty(stuff, "hidden");

				if(name != null && name.length > 0)
				{
					this.name = name;
				}
				if(description != null && description.length > 0)
				{
					this.description = description;
				}
				if(name == 'Name')
				{
					this.name = folder;
				}
				if(description == 'Description')
				{
					this.description = "No description provided.";
				}
				if(colors != null && colors.length > 2)
				{
					this.color = FlxColor.fromRGB(colors[0], colors[1], colors[2]);
				}
				if (release != null) this.release = release;
				if (type != null) this.type = type;
				this.hidden = hidden;

				this.restart = restart;
			}
		}
	}
}
