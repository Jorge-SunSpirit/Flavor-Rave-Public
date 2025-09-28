package achievements;

import achievements.AchievementPopup;
import haxe.Exception;
import haxe.Json;
import flixel.FlxG;
import lime.utils.Assets;
import haxe.Json;
import achievements.AchievementPopup;

using StringTools;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end

typedef AchievementList = {
	var achievements:Array<Achievement>;
}

typedef Achievement =
{
	var name:String;
	var fancyName:String;
	var unlockCondition:String;
	var showmanDialogue:String;
	var showmanEmote:String;
	var hidden:Bool;
	var icon:String;
}

class Achievements {
	public static var achivementVarMap:Map<String, Achievement> = new Map<String, Achievement>();
	public static var achievementArray:Array<String> = [];
	public static var goCharacterMap:Map<String, Bool> = new Map<String, Bool>();
	public static var songBothSideClearMap:Array<String> = [
		"applewood",
		"caramelize",
		"cranberry-pop",
		"flavorscape",
		"game-jammed",
		"heartstrings",
		"ignatius",
		"imitation-station",
		"megaheartz",
		"n0.pressur3.temp",
		"rainbow-sorbet",
		"rockcandy",
		"sugarcoat-it",
		"timeshock",
		"tres-leches",
		"wasabi",
		"fubuki",
		"livewire",
		"carrera-loca",
		"stirring",
		"thats-a-wrap"];

	public static function init()
	{
		var temp:Map<String, Bool> = ClientPrefs.achievementMap;

		var path:String = Paths.getPreloadPath('data/achievements.json');
		var rawJson = Assets.getText(path);
		var json:AchievementList = cast Json.parse(rawJson);
		var bufferArray:Array<Achievement> = [];
		achievementArray = []; //Purges the array
		bufferArray = json.achievements;

		for (peep in bufferArray)
		{
			//Remove the nulls from the map just incase
			var theBool:Bool = ClientPrefs.achievementMap.get(peep.name) ? true : false;
			//Adds the achievement to the list
			temp.set(peep.name, theBool); 
			achivementVarMap.set(peep.name, peep);
			//Adds the achievements to an Array
			achievementArray.push(peep.name);
		}

		#if MODS_ALLOWED
		var modsDirectories:Array<String> = Paths.getGlobalMods();
		for (folder in modsDirectories)
		{
			//This idea works and it's almost great. BUT 
			var modPath:String = Paths.modFolders('data/achievements.json', folder);
			trace(FileSystem.exists(modPath));
			if (FileSystem.exists(modPath))
			{
				json = cast Json.parse(File.getContent(modPath));
				bufferArray = json.achievements;

				for (peep in bufferArray)
				{
					//Remove the nulls from the map just incase
					var theBool:Bool = ClientPrefs.achievementMap.get(peep.name) ? true : false;
					//Adds the achievement to the list
					temp.set(peep.name, theBool);
					achivementVarMap.set(peep.name, peep);
					//Adds the achievements to an Array
					achievementArray.push(peep.name);
				}
			}
		}
		#end
		ClientPrefs.achievementMap = temp;

		getGOCharacters();
	}

	public static function unlockAchievement(name:String, forcePop:Bool = false)
	{
		if (achivementVarMap.get(name) != null && !ClientPrefs.achievementMap.get(name))
		{
			if (!forcePop && !ClientPrefs.achievementMap.get(name)) startPopup(name);
			ClientPrefs.achievementMap.set(name, true);
			ClientPrefs.saveSettings();
		}
		if (forcePop) startPopup(name);
	}

	@:allow(achievements.AchievementPopup)
	private static var _popups:Array<AchievementPopup> = [];

	public static var showingPopups(get, never):Bool;
	public static function get_showingPopups()
		return _popups.length > 0;


	static var _lastUnlock:Int = -999;
	public static function startPopup(achieve:String, endFunc:Void->Void = null) {
		for (popup in _popups)
		{
			if(popup == null) continue;
			popup.intendedY += 130;
		}

		// earrape prevention
		var time:Int = openfl.Lib.getTimer();
		if(Math.abs(time - _lastUnlock) >= 200) //If last unlocked happened in less than 100 ms (0.1s) ago, then don't play sound
		{
			FlxG.sound.play(Paths.sound('achievementUnlock'), 0.5);
			_lastUnlock = time;
		}

		var newPop:AchievementPopup = new AchievementPopup(achieve, endFunc);
		_popups.push(newPop);
	}

	public static function checkfullclearer()
	{
		var hasEverBeenfalse:Bool = false;
		for (key in songBothSideClearMap) 
		{
			if (Highscore.checkBeaten(key, 0, 'both'))
			{
				//Yeah idk man
			}
			else
			{
				hasEverBeenfalse = true;
			}
		}
		if (!hasEverBeenfalse)
			Achievements.unlockAchievement('fullclearer');
		
		ClientPrefs.saveSettings();
	}

	public static function getGOCharacters()
	{
		#if MODS_ALLOWED
		var directories:Array<String> = [Paths.mods('characters/gameover/'), Paths.mods(Paths.currentModDirectory + '/characters/gameover/'), Paths.getPreloadPath('characters/gameover/')];
		for(mod in Paths.getGlobalMods())
			directories.push(Paths.mods(mod + '/characters/gameover/'));
		#else
		var directories:Array<String> = [Paths.getPreloadPath('characters/gameover/')];
		#end

		var tempMap:Map<String, Bool> = new Map<String, Bool>();
		var characters:Array<String> = [];

		#if MODS_ALLOWED
		for (i in 0...directories.length) 
		{
			var directory:String = directories[i];
			if(FileSystem.exists(directory)) 
			{
				for (file in CoolUtil.readDirectory(directory)) 
				{
					var path = haxe.io.Path.join([directory, file]);
					if (!FileSystem.isDirectory(path) && file.endsWith('.json')) 
					{
						var charToCheck:String = file.substr(0, file.length - 5);
						if(!tempMap.exists(charToCheck)) 
						{
							tempMap.set(charToCheck, false);
							characters.push(charToCheck);
						}
					}
				}
			}
		}
		#end

		for (i in 0...characters.length)
		{
			//standard remove null from map and checks for gameovers properly. So if mods are missing that adds them, then it'll ignore it
			var theBool:Bool = ClientPrefs.goCharacterMap.get(characters[i]) ? true : false;
			tempMap.set(characters[i], theBool);
		}
		ClientPrefs.goCharacterMap = tempMap;
	}
}