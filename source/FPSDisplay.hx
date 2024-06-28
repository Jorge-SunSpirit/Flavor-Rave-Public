package;

import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import haxe.Int64;
import haxe.Timer;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.utils.Assets as OpenFlAssets;
#if gl_stats
import openfl.display._internal.stats.Context3DStats;
import openfl.display._internal.stats.DrawCallContext;
#end
#if flash
import openfl.Lib;
#end

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

class FPSDisplay extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Int;	
	public var currentMemory(default, null):Int64;
	public var currentPeak(default, null):Int64;
	
	public var bitmap:Bitmap;

	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000, font:String = "vcr.ttf")
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat(OpenFlAssets.getFont(Paths.font(font)).fontName, 14, color);
		text = "FPS: ";
		width += 200;

		cacheCount = 0;
		currentTime = 0;
		times = [];

		#if flash
		addEventListener(Event.ENTER_FRAME, function(e)
		{
			var time = Lib.getTimer();
			__enterFrame(time - currentTime);
		});
		#end
	}

	public function resetPeak()
	{
		currentPeak = 0;
	}

	// Event Handlers
	@:noCompletion
	private #if !flash override #end function __enterFrame(deltaTime:Float):Void
	{
		currentTime += deltaTime;
		times.push(currentTime);

		while (times[0] < currentTime - 1000)
		{
			times.shift();
		}

		var currentCount = times.length;
		currentFPS = Math.round((currentCount + cacheCount) / 2);
		if (currentFPS > ClientPrefs.framerate)
			currentFPS = ClientPrefs.framerate;

		currentMemory = Int64.make(0, System.totalMemory);
		if (currentMemory > currentPeak)
			currentPeak = currentMemory;

		if (currentCount != cacheCount /*&& visible*/)
		{
			text = "";
			if (ClientPrefs.showFPS)
				text += "FPS: " + currentFPS + "\n";

			#if openfl
			if (ClientPrefs.showMemory)
			{
				text += 'RAM: ${ConvertToMemoryFormat(currentMemory)}';
				if (ClientPrefs.showPeak)
					text += ' / ${ConvertToMemoryFormat(currentPeak)}';
				text += "\n";
			}
			#end

			if (text != null || text != '')
			{
				if (Main.fpsVar != null)
					Main.fpsVar.visible = true;
			}

			textColor = 0xFFFFFFFF;
			if (currentMemory < 0 || currentFPS < 60)
				textColor = 0xFFFF0000;

			#if (gl_stats && !disable_cffi && (!html5 || !canvas))
			text += "\ntotalDC: " + Context3DStats.totalDrawCalls();
			text += "\nstageDC: " + Context3DStats.contextDrawCalls(DrawCallContext.STAGE);
			text += "\nstage3DDC: " + Context3DStats.contextDrawCalls(DrawCallContext.STAGE3D);
			#end

			text += (ClientPrefs.watermarks ? "MYTH " + "v" + MainMenuState.mythicalEngineVersion + "\n" : "")
				+ (ClientPrefs.watermarks ? "PSYCH " + "v" + MainMenuState.psychEngineVersion + "\n" : "")
				+ (ClientPrefs.watermarks ? "FR " + "v" + FlxG.stage.application.meta.get('version') + "\n" : "");

			text += "\n";
		}

		if (ClientPrefs.fpsBorder)
		{
			visible = true;
			Main.instance.removeChild(bitmap);

			bitmap = ImageOutline.renderImage(this, 2, 0x000000, 1);

			Main.instance.addChild(bitmap);
			visible = false;
		}
		else
		{
			visible = true;
			if (Main.instance.contains(bitmap))
				Main.instance.removeChild(bitmap);
		}
		
		cacheCount = currentCount;
	}

	private function ConvertToMemoryFormat(currentMemoryory:Int64):String
	{
		if (currentMemoryory >= 0x40000000)
			return (Math.round(cast(currentMemoryory, Float) / 0x400 / 0x400 / 0x400 * 1000) / 1000) + "GB";
		else if (currentMemoryory >= 0x100000)
			return (Math.round(cast(currentMemoryory, Float) / 0x400 / 0x400 * 1000) / 1000) + "MB";
		else if (currentMemoryory >= 0x400)
			return (Math.round(cast(currentMemoryory, Float) / 0x400 * 1000) / 1000) + "KB";
		else
			return currentMemoryory + "B";
	}
}
