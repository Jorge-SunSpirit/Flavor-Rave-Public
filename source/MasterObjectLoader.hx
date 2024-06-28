import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUI;
import flixel.graphics.FlxGraphic;

class MasterObjectLoader
{
	public static var Objects:Array<Dynamic> = [];

	public static function addObject(object:Dynamic):Void
	{
		if (Std.isOfType(object, FlxSprite))
		{
			var sprite:FlxSprite = cast(object, FlxSprite);
			if (sprite.graphic == null)
				return;
		}
		if (Std.isOfType(object, FlxUI))
			return;
		Objects.push(object);
	}

	public static function removeObject(object:Dynamic):Void
	{
		if (Std.isOfType(object, FlxSprite))
		{
			var sprite:FlxSprite = cast(object, FlxSprite);
			if (sprite.graphic == null)
				return;
		}
		if (Std.isOfType(object, FlxUI))
			return;
		Objects.remove(object);
	}

	public static function resetAssets():Void
	{
		for (object in Objects)
		{
			if (Std.isOfType(object, FlxSprite))
			{
				var sprite:FlxSprite = object;
				FlxG.bitmap.remove(sprite.graphic);
				// sprite.destroy();
			}
			if (Std.isOfType(object, FlxGraphic))
			{
				var graph:FlxGraphic = object;
				FlxG.bitmap.remove(graph);
				// graph.destroy();
			}
		}
		Objects = [];
	}
}
