package;

import flixel.FlxG;
import flixel.math.FlxMath;

/**
	A set of functions designed to help with timing issues that could occur on framerates different than the target.
**/
class FramerateTools
{
	/**
		The framerate that the game is targeting.
	**/
	inline public static var baseFramerate:Int = 60;

	/**
		A multiplier based on how many frames that have been rendered in comparison to the base framerate.
	**/
	inline public static function timeMultiplier():Float
	{
		return (1 / baseFramerate) / FlxG.elapsed;
	}

	/**
		Convert an ease from the base framerate to the current running framerate.
	**/
	inline public static function easeConvert(ease:Float):Float
	{
		return ease / timeMultiplier();
	}

	/**
		Convert a lerp from the base framerate to the current running framerate.
	**/
	inline public static function lerpConvert(a:Float, b:Float, ratio:Float):Float
	{
		return FlxMath.lerp(a, b, easeConvert(ratio));
	}

	/**
		Convert a duration (in frames) from the base framerate to the current running framerate.
	**/
	inline public static function frameConvert(frames:Float):Float
	{
		return 1 / FlxG.elapsed * frames / baseFramerate;
	}
}
