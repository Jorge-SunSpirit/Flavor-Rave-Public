package;

import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class CoriandaBorder extends FlxSpriteGroup
{
	private var playState:PlayState = PlayState.instance;

	private var mid:FlxBackdrop;
	private var front:FlxBackdrop;

	private var inView:Bool = false;
	private var flip:Int = 1;

	public function new(FlipY:Bool):Void
	{
		super();

		mid = new FlxBackdrop(Paths.image('corianda/bordermid'), X);
		mid.antialiasing = ClientPrefs.globalAntialiasing;

		front = new FlxBackdrop(Paths.image('corianda/borderfront'), X);
		front.antialiasing = ClientPrefs.globalAntialiasing;

		add(mid);
		add(front);

		this.flipY = FlipY;
		flip = !flipY ? -1 : 1;
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
		flip = !flipY ? -1 : 1;

		if (inView)
		{
			mid.velocity.set(-60 * flip);
			front.velocity.set(-80 * flip);
		}
	}

	public function tween(duration:Float = 1):Void
	{
		var delay:Float = 1 / duration;
		var viewFlip:Int = flip * (inView ? -1 : 1);
		
		// Just incase
		FlxTween.cancelTweensOf(mid);
		FlxTween.cancelTweensOf(front);

		FlxTween.tween(mid, {y: mid.y + (mid.height * viewFlip)}, duration, {ease: FlxEase.circInOut, startDelay: 0.1 / delay});
		FlxTween.tween(front, {y: mid.y + (front.height * viewFlip)}, duration, {ease: FlxEase.circInOut, startDelay: !inView ? 0.2 / delay : 0});

		inView = !inView;
	}
}