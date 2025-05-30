package;

import flixel.FlxSprite;

class AttachedText extends AlphabetText
{
	public var offsetX:Float = 0;
	public var offsetY:Float = 0;
	public var sprTracker:FlxSprite;
	public var copyVisible:Bool = true;
	public var copyAlpha:Bool = false;

	public function new(text:String = "", ?offsetX:Float = 0, ?offsetY:Float = 0, size:Int = 8, font:String = "") {
		super(0, 0, 0, text, size, font);

		this.isMenuItem = false;
		this.offsetX = offsetX;
		this.offsetY = offsetY;
	}

	override function update(elapsed:Float) {
		if (sprTracker != null) {
			setPosition(sprTracker.x + offsetX, sprTracker.y + offsetY);
			if(copyVisible) {
				visible = sprTracker.visible;
			}
			if(copyAlpha) {
				alpha = sprTracker.alpha;
			}
		}

		super.update(elapsed);
	}
}