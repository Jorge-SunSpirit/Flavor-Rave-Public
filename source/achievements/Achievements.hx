package achievements;

import achievements.AchievementPopup;
import haxe.Exception;
import haxe.Json;
import flixel.FlxG;
import lime.utils.Assets;
import haxe.Json;
import achievements.AchievementPopup;

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
	var hidden:Bool;
	var icon:String;
}

class Achievements {
	public static var achivementVarMap:Map<String, Achievement> = new Map<String, Achievement>();
	public static var achievementArray:Array<String> = [];

	public static function init()
	{
		var temp:Map<String, Dynamic> = ClientPrefs.achievementMap;

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
}