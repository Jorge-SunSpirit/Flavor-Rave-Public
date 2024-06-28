package;

#if sys
import sys.io.File;
#end
import Controls.Control;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import haxe.Json;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.net.FileReference;
import openfl.utils.Dictionary;

class Ana
{
	public var hitTime:Float;
	public var nearestNote:Array<Dynamic>;
	public var hit:Bool;
	public var hitJudge:String;
	public var key:Int;

	public function new(_hitTime:Float, _nearestNote:Array<Dynamic>, _hit:Bool, _hitJudge:String, _key:Int)
	{
		hitTime = _hitTime;
		nearestNote = _nearestNote;
		hit = _hit;
		hitJudge = _hitJudge;
		key = _key;
	}
}

class Analysis
{
	public var anaArray:Array<Ana>;

	public function new()
	{
		anaArray = [];
	}
}

typedef ReplayJSON =
{
	public var replayGameVer:String;
	public var timestamp:Date;
	public var songName:String;
	public var songDiff:Int;
	public var songNotes:Array<Dynamic>;
	public var songJudgements:Array<String>;
	public var noteSpeed:Float;
	public var chartPath:String;
	public var isDownscroll:Bool;
	public var sf:Float;
	public var sm:Bool;
	public var ana:Analysis;
}

class Replay
{
	public static var version:String = "1.2"; // replay file version

	public var path:String = "";
	public var replay:ReplayJSON;

	public function new(path:String)
	{
		this.path = path;
		replay = {
			songName: "No Song Found",
			songDiff: 1,
			noteSpeed: 1.5,
			isDownscroll: false,
			songNotes: [],
			replayGameVer: version,
			chartPath: "",
			sm: false,
			timestamp: Date.now(),
			sf: ClientPrefs.safeFrames,
			ana: new Analysis(),
			songJudgements: []
		};
	}

	public static function LoadReplay(path:String):Replay
	{
		var rep:Replay = new Replay(path);

		rep.LoadFromJSON();

		trace('basic replay data:\nSong Name: ' + rep.replay.songName + '\nSong Diff: ' + rep.replay.songDiff);

		return rep;
	}

	public function SaveReplay(notearray:Array<Dynamic>, judge:Array<String>, ana:Analysis)
	{
		#if FEATURE_STEPMANIA
		var chartPath = PlayState.isSM ? PlayState.pathToSm + "/converted.json" : "";
		#else
		var chartPath = "";
		#end

		var json = {
			"songName": PlayState.SONG.song,
			"songDiff": PlayState.storyDifficulty,
			"chartPath": chartPath,
			"sm": PlayState.isSM,
			"timestamp": Date.now(),
			"replayGameVer": version,
			"sf": ClientPrefs.safeFrames,
			"noteSpeed": (FlxG.save.data.scrollSpeed > 1 ? FlxG.save.data.scrollSpeed : PlayState.SONG.speed),
			"isDownscroll": ClientPrefs.downScroll,
			"songNotes": notearray,
			"songJudgements": judge,
			"ana": ana
		};

		var data:String = Json.stringify(json, null, "");

		var time = Date.now().getTime();

		path = 'replay-${PlayState.SONG.id}-time$time.mythReplay'; // for score screen shit

		/*
		#if sys
		File.saveContent('replays/$path', data);
		#end
		*/

		LoadFromJSON(data);

		replay.ana = ana;
	}

	public function LoadFromJSON(?data:String)
	{
		try
		{
			var jsonData;
			#if sys
			jsonData = data != null ? data : File.getContent(Sys.getCwd() + "replays/" + path);
			#else
			jsonData = data != null ? data : "";
			#end

			var repl:ReplayJSON = cast Json.parse(jsonData);
			replay = repl;
		}
		catch (e)
		{
			trace('failed!\n' + e.message);
		}
	}
}
