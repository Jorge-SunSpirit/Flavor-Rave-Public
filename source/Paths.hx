package;

import animateatlas.AtlasFrameMaker;
import flash.media.Sound;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame.FlxFrameAngle;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import haxe.Json;
import haxe.xml.Access;
import lime.utils.Assets;
import openfl.display.BitmapData;
import openfl.display3D.textures.Texture;
import openfl.geom.Rectangle;
import openfl.system.System;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

@:access(openfl.display.BitmapData)
class Paths
{
	inline public static var SOUND_EXT = "ogg";
	inline public static var VIDEO_EXT = "mp4";

	#if MODS_ALLOWED
	public static var ignoreModFolders:Array<String> = [
		'characters',
		'custom_events',
		'custom_notetypes',
		'data',
		'songs',
		'music',
		'sounds',
		'shaders',
		'videos',
		'images',
		'stages',
		'weeks',
		'fonts',
		'scripts'
	];
	#end

	public static function excludeAsset(key:String) {
		if (!dumpExclusions.contains(key))
			dumpExclusions.push(key);
	}

	public static var dumpExclusions:Array<String> =
	[
		'assets/images/sunsynTrans.png',
		'assets/images/songTrans.png',
		'assets/images/transitionAnim.png',
		'assets/images/alphabet.png',
		'assets/music/freakyMenu.$SOUND_EXT',
		'assets/shared/music/110th-street.$SOUND_EXT',
	];

	// haya I love you for the base cache dump I took to the max
	public static function clearUnusedMemory()
	{
		// clear non local assets in the tracked assets list
		for (key in currentTrackedAssets.keys())
		{
			// if it is not currently contained within the used local assets
			if (!localTrackedAssets.contains(key) && !dumpExclusions.contains(key))
			{
				destroyGraphic(currentTrackedAssets.get(key)); // get rid of the graphic
				currentTrackedAssets.remove(key); // and remove the key from local cache map
			}
		}

		// run the garbage collector for good measure lmfao
		System.gc();
	}

	// define the locally tracked assets
	public static var localTrackedAssets:Array<String> = [];

	@:access(flixel.system.frontEnds.BitmapFrontEnd._cache)
	public static function clearStoredMemory()
	{
		// clear anything not in the tracked assets list
		for (key in FlxG.bitmap._cache.keys())
		{
			if (!currentTrackedAssets.exists(key))
				destroyGraphic(FlxG.bitmap.get(key));
		}

		// clear all sounds that are cached
		for (key => asset in currentTrackedSounds)
		{
			if (!localTrackedAssets.contains(key) && !dumpExclusions.contains(key) && asset != null)
			{
				Assets.cache.clear(key);
				currentTrackedSounds.remove(key);
			}
		}
		// flags everything to be cleared out next unused memory clear
		localTrackedAssets = [];
		#if !html5 openfl.Assets.cache.clear("songs"); #end
	}

	inline static function destroyGraphic(graphic:FlxGraphic)
	{
		// free some gpu memory
		if (graphic != null && graphic.bitmap != null && graphic.bitmap.__texture != null)
			graphic.bitmap.__texture.dispose();
		FlxG.bitmap.remove(graphic);
	}

	static public var currentModDirectory:String = '';
	static public var currentLevel:String;
	static public var allowModLoading:Bool = false;
	static public function setCurrentLevel(name:String)
	{
		currentLevel = name.toLowerCase();
	}

	public static function getPath(file:String, type:AssetType, ?library:Null<String> = null)
	{
		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null)
		{
			var levelPath:String = '';
			if(currentLevel != 'shared') {
				levelPath = getLibraryPathForce(file, currentLevel);
				if (OpenFlAssets.exists(levelPath, type))
					return levelPath;
			}

			levelPath = getLibraryPathForce(file, "shared");
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;
		}

		return getPreloadPath(file);
	}

	static public function getLibraryPath(file:String, library = "preload")
	{
		return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);
	}

	inline static function getLibraryPathForce(file:String, library:String)
	{
		var returnPath = '$library:assets/$library/$file';
		return returnPath;
	}

	inline public static function getPreloadPath(file:String = '')
	{
		return 'assets/$file';
	}

	inline static public function file(file:String, type:AssetType = TEXT, ?library:String)
	{
		return getPath(file, type, library);
	}

	inline static public function txt(key:String, ?library:String)
	{
		return getPath('data/$key.txt', TEXT, library);
	}

	inline static public function xml(key:String, ?library:String)
	{
		return getPath('data/$key.xml', TEXT, library);
	}

	inline static public function json(key:String, ?library:String)
	{
		return getPath('data/$key.json', TEXT, library);
	}

	inline static public function shaderFragment(key:String, ?library:String)
	{
		return getPath('shaders/$key.frag', TEXT, library);
	}
	inline static public function shaderVertex(key:String, ?library:String)
	{
		return getPath('shaders/$key.vert', TEXT, library);
	}
	inline static public function lua(key:String, ?library:String)
	{
		return getPath('$key.lua', TEXT, library);
	}

	static public function video(key:String, ?extension:String)
	{
		extension = extension != null ? extension : VIDEO_EXT;
		#if MODS_ALLOWED
		var file:String = modsVideo(key, extension);
		if(FileSystem.exists(file)) {
			return file;
		}
		#end
		return 'assets/videos/$key.$extension';
	}

	static public function sound(key:String, ?async:Bool = false, ?library:String):Sound
	{
		return returnSound('sounds', key, async, library);
	}

	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String)
	{
		return sound(key + FlxG.random.int(min, max), false, library);
	}

	inline static public function music(key:String, ?library:String):Sound
	{
		return returnSound('music', key, false, library);
	}

	inline static public function voices(song:String, suffix:String = ""):Any
	{
		var suffixPath:String = suffix != "" ? '-$suffix' : "";
		return returnSound('songs', '${formatToSongPath(song)}/Voices$suffixPath');
	}

	inline static public function inst(song:String):Any
	{
		return returnSound('songs', '${formatToSongPath(song)}/Inst');
	}

	inline static public function image(key:String, ?library:String, ?textureCompression:Bool, ?posInfos:haxe.PosInfos):FlxGraphic
	{
		textureCompression = textureCompression != null ? textureCompression : ClientPrefs.gpuTextures;

		#if MODS_ALLOWED
		var modKey:String = modsImages(key);

		if (FileSystem.exists(modKey))
		{
			if (!currentTrackedAssets.exists(modKey))
			{
				var newGraphic:FlxGraphic = returnGraphic(modKey, BitmapData.fromFile(modKey), textureCompression);
				newGraphic.persist = true;
				currentTrackedAssets.set(modKey, newGraphic);
			}

			if (!localTrackedAssets.contains(modKey))
				localTrackedAssets.push(modKey);

			return currentTrackedAssets.get(modKey);
		}
		#end

		var path = getPath('images/$key.png', IMAGE, library);

		if (OpenFlAssets.exists(path, IMAGE))
		{
			if (!currentTrackedAssets.exists(path))
			{
				var newGraphic:FlxGraphic = returnGraphic(path, OpenFlAssets.getBitmapData(path), textureCompression);
				newGraphic.persist = true;
				currentTrackedAssets.set(path, newGraphic);
			}

			if (!localTrackedAssets.contains(path))
				localTrackedAssets.push(path);

			return currentTrackedAssets.get(path);
		}

		var error:String = 'Image with key "$key" could not be found' + (library == null ? '' : ' in the library "$library"') + '! ' + '(${posInfos.fileName}, ${posInfos.lineNumber})';

		#if FORCE_DEBUG_VERSION
		FlxG.log.warn(error);
		#else
		trace(error);
		#end

		return null;
	}

	static public function getTextFromFile(key:String, ?ignoreMods:Bool = false):String
	{
		#if sys
		#if MODS_ALLOWED
		if (!ignoreMods && FileSystem.exists(modFolders(key)))
			return File.getContent(modFolders(key));
		#end

		if (FileSystem.exists(getPreloadPath(key)))
			return File.getContent(getPreloadPath(key));

		if (currentLevel != null)
		{
			var levelPath:String = '';
			if(currentLevel != 'shared') {
				levelPath = getLibraryPathForce(key, currentLevel);
				if (FileSystem.exists(levelPath))
					return File.getContent(levelPath);
			}

			levelPath = getLibraryPathForce(key, 'shared');
			if (FileSystem.exists(levelPath))
				return File.getContent(levelPath);
		}
		#end
		return Assets.getText(getPath(key, TEXT));
	}

	inline static public function font(key:String)
	{
		#if MODS_ALLOWED
		var file:String = modsFont(key);
		if(FileSystem.exists(file)) {
			return file;
		}
		#end
		return 'assets/fonts/$key';
	}

	inline static public function fileExists(key:String, type:AssetType, ?ignoreMods:Bool = false, ?library:String)
	{
		#if MODS_ALLOWED
		if(FileSystem.exists(mods(currentModDirectory + '/' + key)) || FileSystem.exists(mods(key))) {
			return true;
		}
		#end

		if(OpenFlAssets.exists(getPath(key, type))) {
			return true;
		}
		return false;
	}

	inline static public function getSparrowAtlas(key:String, ?library:String, ?textureCompression:Bool, ?posInfos:haxe.PosInfos):FlxAtlasFrames
	{
		textureCompression = textureCompression != null ? textureCompression : ClientPrefs.gpuTextures;

		#if MODS_ALLOWED
		var imageLoaded:FlxGraphic = image(key, library, textureCompression, posInfos);
		var xmlExists:Bool = false;

		if (FileSystem.exists(modsXml(key)))
			xmlExists = true;

		return FlxAtlasFrames.fromSparrow((imageLoaded != null ? imageLoaded : image(key, library, textureCompression, posInfos)), (xmlExists ? File.getContent(modsXml(key)) : file('images/$key.xml', library)));
		#else
		return FlxAtlasFrames.fromSparrow(image(key, library, textureCompression, posInfos), file('images/$key.xml', library));
		#end
	}


	inline static public function getPackerAtlas(key:String, ?library:String, ?textureCompression:Bool, ?posInfos:haxe.PosInfos)
	{
		textureCompression = textureCompression != null ? textureCompression : ClientPrefs.gpuTextures;

		#if MODS_ALLOWED
		var imageLoaded:FlxGraphic = image(key, library, textureCompression, posInfos);
		var txtExists:Bool = false;

		if (FileSystem.exists(modsTxt(key)))
			txtExists = true;

		return FlxAtlasFrames.fromSpriteSheetPacker((imageLoaded != null ? imageLoaded : image(key, library, textureCompression, posInfos)), (txtExists ? File.getContent(modsTxt(key)) : file('images/$key.txt', library)));
		#else
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library, textureCompression, posInfos), file('images/$key.txt', library));
		#end
	}

	inline static public function formatToSongPath(path:String) {
		var invalidChars = ~/[~&\\;:<>#]/;
		var hideChars = ~/[,'"%?!]/;

		var path = invalidChars.split(path.replace(' ', '-')).join("-");
		return hideChars.split(path).join("").toLowerCase();
	}

	// completely rewritten asset loading? fuck!
	public static var currentTrackedTextures:Map<String, Texture> = [];
	public static var currentTrackedAssets:Map<String, FlxGraphic> = [];

	public static function returnGraphic(key:String, bitmap:BitmapData, ?textureCompression:Bool):FlxGraphic
	{
		textureCompression = textureCompression != null ? textureCompression : ClientPrefs.gpuTextures;

		if (textureCompression)
		{
			var newTexture:Texture = FlxG.stage.context3D.createTexture(bitmap.width, bitmap.height, BGRA, false);
			newTexture.uploadFromBitmapData(bitmap);
			currentTrackedTextures.set(key, newTexture);	
			bitmap.dispose();
			bitmap.disposeImage();
			bitmap = null;
			return FlxGraphic.fromBitmapData(BitmapData.fromTexture(newTexture), false, key);
		}
		else
		{
			return FlxGraphic.fromBitmapData(bitmap, false, key);
		}
	}

	public static var currentTrackedSounds:Map<String, Sound> = [];
	public static function returnSound(path:String, key:String, ?async:Bool = false, ?library:String) {
		#if MODS_ALLOWED
		var file:String = modsSounds(path, key);
		//trace(file);
		if(FileSystem.exists(file)) {
			if(!currentTrackedSounds.exists(file)) {
				if(async) Sound.loadFromFile(file).onComplete(sound -> {currentTrackedSounds.set(file, sound);});
				else currentTrackedSounds.set(file, Sound.fromFile(file));
			}
			if(!localTrackedAssets.contains(key)) localTrackedAssets.push(key);
			return currentTrackedSounds.get(file);
		}
		#end
		// I hate this so god damn much
		var gottenPath:String = getPath('$path/$key.$SOUND_EXT', SOUND, library);
		gottenPath = gottenPath.substring(gottenPath.indexOf(':') + 1, gottenPath.length);
		// trace(gottenPath);
		if(!currentTrackedSounds.exists(gottenPath))
		#if MODS_ALLOWED
		{
			if(async) Sound.loadFromFile('./$gottenPath').onComplete(sound -> {currentTrackedSounds.set(gottenPath, sound);});
			else currentTrackedSounds.set(gottenPath, Sound.fromFile('./$gottenPath'));
		}
		#else
		{
			var folder:String = '';
			if(path == 'songs') folder = 'songs:';

			var soundPath:String = folder + getPath('$path/$key.$SOUND_EXT', SOUND, library);
			if(async) OpenFlAssets.loadSound(soundPath).onComplete(sound -> {currentTrackedSounds.set(gottenPath, sound);})
			else currentTrackedSounds.set(gottenPath, OpenFlAssets.getSound(soundPath));
		}
		#end
		if(!localTrackedAssets.contains(gottenPath)) localTrackedAssets.push(gottenPath);
		return currentTrackedSounds.get(gottenPath);
	}

	public static function convertBMP(bitmap:BitmapData, key:String):BitmapData
	{
		var texture:Texture = FlxG.stage.context3D.createTexture(bitmap.width, bitmap.height, BGRA, false);
		texture.uploadFromBitmapData(bitmap);
		currentTrackedTextures.set(key, texture);
		bitmap.dispose();
		bitmap.disposeImage();
		bitmap = null;
		if(!localTrackedAssets.contains(key)) localTrackedAssets.push(key);
		return BitmapData.fromTexture(texture);
	}	

	#if MODS_ALLOWED
	inline static public function mods(key:String = '') {
		return 'mods/' + key;
	}

	inline static public function modsFont(key:String) {
		return modFolders('fonts/' + key);
	}

	inline static public function modsJson(key:String) {
		return modFolders('data/' + key + '.json');
	}

	inline static public function modsVideo(key:String, ?extension:String) {
		extension = extension != null ? extension : VIDEO_EXT;
		return modFolders('videos/$key.$extension');
	}

	inline static public function modsSounds(path:String, key:String) {
		return modFolders(path + '/' + key + '.' + SOUND_EXT);
	}

	inline static public function modsImages(key:String) {
		return modFolders('images/' + key + '.png');
	}

	inline static public function modsXml(key:String) {
		return modFolders('images/' + key + '.xml');
	}

	inline static public function modsTxt(key:String) {
		return modFolders('images/' + key + '.txt');
	}

	/* Goes unused for now

	inline static public function modsShaderFragment(key:String, ?library:String)
	{
		return modFolders('shaders/'+key+'.frag');
	}
	inline static public function modsShaderVertex(key:String, ?library:String)
	{
		return modFolders('shaders/'+key+'.vert');
	}
	*/

	static public function modFolders(key:String, ?forceWhichFolder:String) {
		//Prioritize currentModDirectory
		var modDirString:String = currentModDirectory;
		if (forceWhichFolder != null && forceWhichFolder.length > 0)
			modDirString = forceWhichFolder;

		if(modDirString != null && modDirString.length > 0) {
			var fileToCheck:String = mods(modDirString + '/' + key);
			if(FileSystem.exists(fileToCheck)) {
				return fileToCheck;
			}
		}

		//If it cannot find it, let us check every existing mod folder if forceWhichFolder is null
		if (allowModLoading && (forceWhichFolder == null || forceWhichFolder.length < 0))
		{
			var modsDirectories:Array<String> = Paths.getModDirectories();
			for (folder in modsDirectories)
			{
				if(folder != null && folder.length > 0) {
					var fileToCheck:String = mods(folder + '/' + key);
					if(FileSystem.exists(fileToCheck)) {
						return fileToCheck;
					}
				}
			}
		}

		//then obligitory globalmodcheck
		for(mod in getGlobalMods()){
			var fileToCheck:String = mods(mod + '/' + key);
			if(FileSystem.exists(fileToCheck))
				return fileToCheck;
		}
		return 'mods/' + key;
	}

	public static var globalMods:Array<String> = [];

	static public function getGlobalMods()
		return globalMods;

	static public function pushGlobalMods() // prob a better way to do this but idc
	{
		globalMods = [];
		var path:String = 'modsList.txt';
		if(FileSystem.exists(path))
		{
			var list:Array<String> = CoolUtil.coolTextFile(path);
			for (i in list)
			{
				var dat = i.split("|");
				if (dat[1] == "1")
				{
					var folder = dat[0];
					var path = Paths.mods(folder + '/pack.json');
					if(FileSystem.exists(path)) {
						try{
							var rawJson:String = File.getContent(path);
							if(rawJson != null && rawJson.length > 0) {
								var stuff:Dynamic = Json.parse(rawJson);
								var global:Bool = Reflect.getProperty(stuff, "runsGlobally");
								if(global)globalMods.push(dat[0]);
							}
						} catch(e:Dynamic){
							trace(e);
						}
					}
				}
			}
		}
		return globalMods;
	}

	static public function getModDirectories():Array<String> {
		var list:Array<String> = [];
		var modsFolder:String = mods();
		if(FileSystem.exists(modsFolder)) {
			for (folder in FileSystem.readDirectory(modsFolder)) {
				var path = haxe.io.Path.join([modsFolder, folder]);
				if (sys.FileSystem.isDirectory(path) && !ignoreModFolders.contains(folder) && !list.contains(folder)) {
					list.push(folder);
				}
			}
		}
		return list;
	}
	#end
}
