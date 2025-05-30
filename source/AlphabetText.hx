package;

import Language.LanguageText;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.text.FlxText;

class AlphabetText extends LanguageText
{
	public var isMenuItem:Bool = false;
	public var targetY:Int = 0;
	public var changeX:Bool = true;
	public var changeY:Bool = true;

	public var distancePerItem:FlxPoint = new FlxPoint(20, 120);
	public var startPosition:FlxPoint = new FlxPoint(0, 0); // for the calculations

	public function new(X:Float = 0, Y:Float = 0, FieldWidth:Float = 0, ?Text:String, Size:Int = 8, ?Font:String)
	{
		super(X, Y, FieldWidth, Text, Size, Font);
		this.startPosition.x = X;
		this.startPosition.y = Y;
	}

	override function update(elapsed:Float)
	{
		if (isMenuItem)
		{
			var lerpVal:Float = CoolUtil.boundTo(elapsed * 9.6, 0, 1);

			if (changeX)
				x = FlxMath.lerp(x, (targetY * distancePerItem.x) + startPosition.x, lerpVal);

			if (changeY)
				y = FlxMath.lerp(y, (targetY * 1.3 * distancePerItem.y) + startPosition.y, lerpVal);
		}

		super.update(elapsed);
	}

	public function snapToPosition()
	{
		if (isMenuItem)
		{
			if (changeX)
				x = (targetY * distancePerItem.x) + startPosition.x;

			if (changeY)
				y = (targetY * 1.3 * distancePerItem.y) + startPosition.y;
		}
	}
}
