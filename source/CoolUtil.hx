package;

import flash.media.Sound;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.sound.FlxSound;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import lime.utils.Assets as LimeAssets;
import openfl.utils.Assets;

using StringTools;
#if sys
import sys.FileSystem;
import sys.io.File;
#else
import openfl.utils.Assets;
#end

import ClientPrefs;

class CoolUtil
{
	public static var defaultDifficulties:Array<String> = [
		'Easy',
		'Normal',
		'Hard'
	];
	public static var defaultDifficulty:String = 'Normal'; //The chart that has no suffix and starting difficulty on Freeplay/Story Mode

	public static var difficulties:Array<String> = [];

	inline public static function colorFromString(color:String):FlxColor
	{
		var hideChars = ~/[\t\n\r]/;
		var color:String = hideChars.split(color).join('').trim();
		if(color.startsWith('0x')) color = color.substring(color.length - 6);

		var colorNum:Null<FlxColor> = FlxColor.fromString(color);
		if(colorNum == null) colorNum = FlxColor.fromString('#$color');
		return colorNum != null ? colorNum : FlxColor.WHITE;
	}

	inline public static function floorDecimal(value:Float, decimals:Int):Float {
		if(decimals < 1)
		{
			return Math.floor(value);
		}

		var tempMult:Float = 1;
		for (i in 0...decimals)
		{
			tempMult *= 10;
		}
		var newValue:Float = Math.floor(value * tempMult);
		return newValue / tempMult;
	}

	inline public static function quantize(f:Float, snap:Float){
		// changed so this actually works lol
		var m:Float = Math.fround(f * snap);
		trace(snap);
		return (m / snap);
	}
	
	public static function getDifficultyFilePath(num:Null<Int> = null)
	{
		if(num == null) num = PlayState.storyDifficulty;

		var fileSuffix:String = difficulties[num];
		if(fileSuffix != defaultDifficulty)
		{
			fileSuffix = '-' + fileSuffix;
		}
		else
		{
			fileSuffix = '';
		}
		return Paths.formatToSongPath(fileSuffix);
	}

	public static function difficultyString():String
	{
		return difficulties[PlayState.storyDifficulty].toUpperCase();
	}

	inline public static function boundTo(value:Float, min:Float, max:Float):Float {
		return Math.max(min, Math.min(max, value));
	}
	
	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = [];
		#if sys
		if(FileSystem.exists(path)) daList = File.getContent(path).trim().split('\n');
		#else
		if(Assets.exists(path)) daList = Assets.getText(path).trim().split('\n');
		#end

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	public static function coolReplace(string:String, sub:String, by:String):String
		return string.split(sub).join(by);

	//Example: "winter-horrorland" to "Winter Horrorland". Used for replays
	public static function coolSongFormatter(song:String):String
    {
        var swag:String = coolReplace(song, '-', ' ');
        var splitSong:Array<String> = swag.split(' ');

		for (i in 0...splitSong.length)
		{
            var firstLetter = splitSong[i].substring(0, 1);
            var coolSong:String = coolReplace(splitSong[i], firstLetter, firstLetter.toUpperCase());
			var splitCoolSong:Array<String> = coolSong.split('');

			coolSong = Std.string(splitCoolSong[0]).toUpperCase();

			for (e in 0...splitCoolSong.length)
				coolSong += Std.string(splitCoolSong[e+1]).toLowerCase();

			coolSong = coolReplace(coolSong, 'null', '');

            for (l in 0...splitSong.length)
            {
                var stringSong:String = Std.string(splitSong[l+1]);
                var stringFirstLetter:String = stringSong.substring(0, 1);

				var splitStringSong = stringSong.split('');
				stringSong = Std.string(splitStringSong[0]).toUpperCase();

				for (l in 0...splitStringSong.length)
					stringSong += Std.string(splitStringSong[l+1]).toLowerCase();

				stringSong = coolReplace(stringSong, 'null', '');

                coolSong += ' $stringSong';
            }

			song = coolSong.replace(' Null', '');
            return song;
        }

        return swag;
	}

	#if sys
	// Hi Linux! Why do you not read this in alphabetical order :(
	public static function readDirectory(directory:String):Array<String>
	{
		var list:Array<String> = FileSystem.readDirectory(directory);
		list.sort(function(a, b) return a > b ? 1 : -1);
		return list;
	}

	public static function coolPathArray(path:String):Array<String>
	{
		return readDirectory(FileSystem.absolutePath(path));
	}
	#end

	public static function listFromString(string:String):Array<String>
	{
		var daList:Array<String> = [];
		daList = string.trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}
	public static function dominantColor(sprite:flixel.FlxSprite):Int{
		var countByColor:Map<Int, Int> = [];
		for(col in 0...sprite.frameWidth){
			for(row in 0...sprite.frameHeight){
			  var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);
			  if(colorOfThisPixel != 0){
				  if(countByColor.exists(colorOfThisPixel)){
				    countByColor[colorOfThisPixel] =  countByColor[colorOfThisPixel] + 1;
				  }else if(countByColor[colorOfThisPixel] != 13520687 - (2*13520687)){
					 countByColor[colorOfThisPixel] = 1;
				  }
			  }
			}
		 }
		var maxCount = 0;
		var maxKey:Int = 0;//after the loop this will store the max color
		countByColor[flixel.util.FlxColor.BLACK] = 0;
			for(key in countByColor.keys()){
			if(countByColor[key] >= maxCount){
				maxCount = countByColor[key];
				maxKey = key;
			}
		}
		return maxKey;
	}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}

	public static function browserLoad(site:String) {
		#if linux
		Sys.command('/usr/bin/xdg-open', [site]);
		#else
		FlxG.openURL(site);
		#end
	}

	public static function calcSectionLength(multiplier:Float = 1.0):Float
	{
		return Conductor.stepCrochet / (64 / multiplier);
	}

	/** Quick Function to Fix Save Files for Flixel 5
		if you are making a mod, you are gonna wanna change "ShadowMario" to something else
		so Base Psych saves won't conflict with yours
		@BeastlyGabi
	**/
	public static function getSavePath(folder:String = 'TeamTBD'):String {
		@:privateAccess
		return #if (flixel < "5.0.0") folder #else FlxG.stage.application.meta.get('company')
			+ '/'
			+ FlxSave.validate(FlxG.stage.application.meta.get('file')) #end;
	}

	// Awesome function to get the proper voice clip for the selected announcer! If said voice clip doesn't exist, just use the default announcer's.
	public static function getAnnouncerLine(line:String, ?async:Bool = false):Sound
	{
		if (Paths.fileExists("sounds/announcer/" + ClientPrefs.announcer + "/" + line + ".ogg", SOUND))
		{
			return Paths.sound("announcer/" + ClientPrefs.announcer + "/" + line);
		}

		return Paths.sound("announcer/default/" + line);
	}
}
