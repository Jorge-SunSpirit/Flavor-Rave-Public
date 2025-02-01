package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.display.StageScaleMode;
import openfl.events.Event;

using StringTools;
//crash handler stuff
#if CRASH_HANDLER
import Discord.DiscordClient;
import haxe.CallStack;
import haxe.io.Path;
import openfl.events.UncaughtErrorEvent;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
#end

#if linux
@:cppInclude('./external/gamemode_client.h')
@:cppFileCode('
	#define GAMEMODE_AUTO
')
#end

#if NO_W11_CORNERS
@:cppFileCode('
	#include <windows.h>
	#include <dwmapi.h>

	#pragma comment(lib, "Dwmapi")
')
#end
class Main extends Sprite
{
	// These are taken from Funkin' 0.3.2
	public static var VERSION(get, never):String;
	public static final VERSION_SUFFIX:String = #if !PUBLIC_BUILD ' DEV' #else '' #end;
	/*
	public static final GIT_BRANCH:String = funkin.util.macro.GitCommit.getGitBranch();
	public static final GIT_HASH:String = funkin.util.macro.GitCommit.getGitCommitHash();
	public static final GIT_HAS_LOCAL_CHANGES:Bool = funkin.util.macro.GitCommit.getGitHasLocalChanges();
	*/

	public static final MIN_FRAMERATE:Int = 60;
	public static final MAX_FRAMERATE:Int = 360;

	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = TitleState; // The FlxState the game starts with.
	var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets
	public static var focused:Bool = true; // Whether the game is currently focused or not.
	public static var fpsVar:FPSDisplay;

	public static var instance:Main;

	/*
	#if !PUBLIC_BUILD
	static function get_VERSION():String
	{
	  return 'v${FlxG.stage.application.meta.get('version')} (${GIT_BRANCH} : ${GIT_HASH}${GIT_HAS_LOCAL_CHANGES ? ' : MODIFIED' : ''})' + VERSION_SUFFIX;
	}
	#else
	*/
	static function get_VERSION():String
	{
	  return 'v${FlxG.stage.application.meta.get('version')}' + VERSION_SUFFIX;
	}
	//#end

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		instance = this;

		super();

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	#if NO_W11_CORNERS
	@:functionCode('
		HWND hwnd = GetActiveWindow();
		const DWM_WINDOW_CORNER_PREFERENCE corner_preference = DWMWCP_DONOTROUND;
		DwmSetWindowAttribute(hwnd, DWMWA_WINDOW_CORNER_PREFERENCE, &corner_preference, sizeof(corner_preference));
	')
	#end
	private function setupGame():Void
	{
		ClientPrefs.loadDefaultKeys();
		var game:FlxGame = new FlxGame(gameWidth, gameHeight, initialState, framerate, framerate, skipSplash, startFullscreen);

#if SOUNDTRAY
		// FlxG.game._customSoundTray wants just the class, it calls new from
		// create() in there, which gets called when it's added to stage
		// which is why it needs to be added before addChild(game) here
		@:privateAccess
		game._customSoundTray = funkin.ui.options.FunkinSoundTray;
#end

		addChild(game);

		#if !mobile
		fpsVar = new FPSDisplay(10, 3, 0xFFFFFF);
		addChild(fpsVar);
		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		if(fpsVar != null) {
			fpsVar.visible = ClientPrefs.showFPS;
		}
		#end

		#if html5
		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
		#end

		FlxG.signals.focusGained.add(function() {
			focused = true;
		});
		FlxG.signals.focusLost.add(function() {
			focused = false;
		});		

		#if CRASH_HANDLER
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
		#end
	}

	// Code was entirely made by sqirra-rng for their fnf engine named "Izzy Engine", big props to them!!!
	// very cool person for real they don't get enough credit for their work
	#if CRASH_HANDLER
	function onCrash(e:UncaughtErrorEvent):Void
	{
		// Always use the non-public build version text for the start of the error message
		// var errMsg:String = 'Flavor Rave v${FlxG.stage.application.meta.get('version')} (${GIT_BRANCH} : ${GIT_HASH}${GIT_HAS_LOCAL_CHANGES ? ' : MODIFIED' : ''})$VERSION_SUFFIX\n\n';
		var errMsg:String = 'Flavor Rave v${FlxG.stage.application.meta.get('version')}\n\n';
		var path:String;
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();

		dateNow = dateNow.replace(" ", "_");
		dateNow = dateNow.replace(":", "'");

		path = "./crash/" + "FlavorRave_" + dateNow + ".txt";

		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errMsg += file + " (line " + line + ")\n";
				default:
					Sys.println(stackItem);
			}
		}

		errMsg += "\nUncaught Error: " + e.error;
		#if windows
		errMsg += "\nPlease report this error to the GitHub page: https://github.com/Jorge-SunSpirit/Flavor-Rave-Public";
		#end
		errMsg += "\n\n> Crash Handler written by: sqirra-rng";

		if (!FileSystem.exists("./crash/"))
			FileSystem.createDirectory("./crash/");

		File.saveContent(path, errMsg + "\n");

		Sys.println(errMsg);
		Sys.println("Crash dump saved in " + Path.normalize(path));

		FlxG.stage.application.window.alert(errMsg, "Error!");
		DiscordClient.shutdown();
		Sys.exit(1);
	}
	#end
}
