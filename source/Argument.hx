#if sys
package;

import editors.*;
import funkin.util.macro.MacroUtil;
import options.*;

using StringTools;

class Argument
{
	inline public static function parseDefine():Bool
		return parse([MacroUtil.getDefine('ARG')]);

	public static function parse(args:Array<String>):Bool
	{
		switch (args[0])
		{
			default:
			{
				return false;
			}

			case '-h' | '--help':
			{
				var exePath:Array<String> = Sys.programPath().split(#if windows '\\' #else '/' #end);
				var exeName:String = exePath[exePath.length - 1].replace('.exe', '');

				Sys.println('
Usage:
  ${exeName} (menu | story | freeplay | mods | credits | options)
  ${exeName} play "Song Name" ["Mod Folder"] [-s | --story] [-d=<val> | --diff=<val>]
  ${exeName} chart "Song Name" ["Mod Folder"] [-d=<val> | --diff=<val>]
  ${exeName} debug ["Mod Folder"]
  ${exeName} character <char> ["Mod Folder"]
  ${exeName} (sunsynth | sunsynthfirst | gallery | flavorpedia | flavorpediamain | flavorpediaside | stagepreview)
  ${exeName} -h | --help

Options:
  -h       --help        Show this screen.
  -s       --story       Enables story mode when in play state.
  -d=<val> --diff=<val>  Sets the difficulty for the song. [default: ${CoolUtil.defaultDifficulty.toLowerCase().trim()}]
');

				Sys.exit(0);
			}

			case 'menu':
			{
				LoadingState.loadAndSwitchState(new MainMenuState());
			}

			case 'story':
			{
				LoadingState.loadAndSwitchState(new StoryMenuState());
			}

			case 'freeplay':
			{
				LoadingState.loadAndSwitchState(new FreeplayState());
			}

			case 'mods':
			{
				LoadingState.loadAndSwitchState(new ModsMenuState());
			}

			case 'credits':
			{
				LoadingState.loadAndSwitchState(new CreditsState());
			}

			case 'options':
			{
				LoadingState.loadAndSwitchState(new OptionsState());
			}

			case 'play':
			{
				var modFolder:String = null;
				var diff:String = null;
				for (i in 2...args.length)
				{
					if (args[i] == '-s' || args[i] == '--story')
						PlayState.isStoryMode = true;

					else if (args[i].startsWith('-d=') || args[i].startsWith('--diff='))
						diff = (args[i].split('='))[1];

					else if (modFolder != null)
						modFolder = args[i];
				}

				setupSong(args[1], modFolder, diff);
				LoadingState.loadAndSwitchState(new PlayState(), true);
			}

			case 'chart':
			{
				var modFolder:String = null;
				var diff:String = null;
				for (i in 2...args.length)
				{
					if (args[i].startsWith('-d') || args[i].startsWith('--diff'))
						diff = (args[i].split('='))[1];

					else if (modFolder != null)
						modFolder = args[i];
				}

				setupSong(args[1], args[2], diff);
				LoadingState.loadAndSwitchState(new ChartingState(), true);
			}

			case 'debug':
			{
				if (args[1] != null) Paths.currentModDirectory = args[1];
				LoadingState.loadAndSwitchState(new MasterEditorMenu());
			}

			case 'character':
			{
				if (args[2] != null) Paths.currentModDirectory = args[2];
				LoadingState.loadAndSwitchState(new CharacterEditorState(args[1] != null ? args[1] : Character.DEFAULT_CHARACTER));
			}


			// Flavor Rave specific
			case 'sunsynth':
			{
				LoadingState.loadAndSwitchState(new SunSynthState());
			}

			case 'sunsynthfirst':
			{
				LoadingState.loadAndSwitchState(new SunSynthFirstState());
			}

			case 'gallery':
			{
				LoadingState.loadAndSwitchState(new GalleryState());
			}

			case 'flavorpedia':
			{
				LoadingState.loadAndSwitchState(new FlavorpediaSelectorState());
			}

			case 'flavorpediamain':
			{
				LoadingState.loadAndSwitchState(new FlavorpediaState());
			}

			case 'flavorpediaside':
			{
				LoadingState.loadAndSwitchState(new FlavorpediaSideState());
			}

			case 'stagepreview':
			{
				LoadingState.loadAndSwitchState(new StagePreviewState());
			}
		}

		return true;
	}

	static function setupSong(songName:String, ?modFolder:String, ?diff:String):Void
	{
		WeekData.reloadWeekFiles(PlayState.isStoryMode);

		if (modFolder == null)
		{
			var songFound:Bool = false;
			for (weekData in WeekData.weeksList)
			{
				if (songFound)
					break;

				var week:WeekData = WeekData.weeksLoaded.get(weekData);

				for (weekSong in week.songs)
				{
					if (Paths.formatToSongPath(weekSong[0]) == Paths.formatToSongPath(songName))
					{
						WeekData.setDirectoryFromWeek(week);
						songFound = true;
						break;
					}
				}
			}
		}
		else
		{
			Paths.currentModDirectory = modFolder;
		}

		var defaultDiff:Bool = diff == null || (diff != null && diff.toLowerCase().trim() == CoolUtil.defaultDifficulty.toLowerCase().trim());
		var jsonName:String = songName + (!defaultDiff ? '-${diff}' : '');
		PlayState.SONG = Song.loadFromJson(jsonName, songName);
	}
}
#end
