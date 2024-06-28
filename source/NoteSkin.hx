package;

import haxe.Json;
import openfl.utils.Assets;

#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end

typedef NoteSkinFile = {
	var noteSkins:Array<NoteArray>;
}

typedef NoteArray = {
	var skinName:String; // Used for Options
	var note:String;
	var noteSplash:Array<Dynamic>;
	var ratings_folder:String;
	var songReq:String; // Used for Options
}

class NoteSkin
{
    public static var noteSkinNames:Array<String> = [];
    public static var noteSkins:Map<String, NoteArray> = new Map<String, NoteArray>();

    public static function init():Void
    {
        // Clear the array & map since this gets called in WeekData.reloadWeekFiles()
        noteSkinNames = [];
        noteSkins.clear();

        var path:String = Paths.getPreloadPath('data/noteSkinData.json');
        var json:NoteSkinFile = cast Json.parse(Assets.getText(path));

        for (noteSkin in json.noteSkins)
        {
            noteSkinNames.push(noteSkin.skinName);
            noteSkins.set(noteSkin.skinName, noteSkin);
        }

        #if MODS_ALLOWED
        var modsDirectories:Array<String> = Paths.getModDirectories();
		for (folder in modsDirectories)
		{
            //This idea works and it's almost great. BUT 
            var modPath:String = Paths.modFolders('data/noteSkinData.json', folder);
            trace(modPath);

            if (FileSystem.exists(modPath))
            {
                json = cast Json.parse(File.getContent(modPath));

                for (noteSkin in json.noteSkins)
                {
                    noteSkinNames.push(noteSkin.skinName);
                    noteSkins.set(noteSkin.skinName, noteSkin);
                }
            }
        }
        #end

        // Check if the note skin in the save data still exists.
        if (!noteSkins.exists(ClientPrefs.noteSkin))
        {
            ClientPrefs.noteSkin = 'Default';
            ClientPrefs.saveSettings();
        }
    }
}
