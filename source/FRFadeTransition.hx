package;

import Conductor.BPMChangeEvent;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.util.FlxTimer;

class FRFadeTransition extends MusicBeatSubstate {
	public static var finishCallback:Void->Void;
	private var leTween:FlxTween = null;
	public static var nextCamera:FlxCamera;
	public static var type:String = 'hueh';
	var isTransIn:Bool = false;
	var transBlack:FlxSprite;

	public function new(duration:Float, isTransIn:Bool) {
		super();

		this.isTransIn = isTransIn;

		var sprite:String = 'transitionAnim';
		switch (type)
		{
			default:
				sprite = 'transitionAnim';
			case 'synsun':
				sprite = 'sunsynTrans';
			case 'songTrans':
				sprite = 'songTrans';
		}


		transBlack = new FlxSprite();
		transBlack.frames = Paths.getSparrowAtlas(sprite, 'preload');

		switch (type)
		{
			default:
				transBlack.animation.addByPrefix('transition', 'transition', 30, false);
				transBlack.animation.addByPrefix('idleempty', 'empty', 30, false);
				transBlack.animation.addByPrefix('idlefull', 'Full', 30, false);
			case 'synsun':
				transBlack.animation.addByPrefix('transin', 'transIN', 30, false);
				transBlack.animation.addByPrefix('transout', 'transOUT', 30, false);
				transBlack.animation.addByPrefix('idleempty', 'empty', 30, false);
				transBlack.animation.addByPrefix('idlefull', 'Full', 30, false);
			case 'songTrans':
				transBlack.animation.addByPrefix('transin', 'disk_transition_in', 24, false);
				transBlack.animation.addByPrefix('transout', 'disk_transition_out', 24, false);
				transBlack.animation.addByPrefix('idleempty', 'disk_transition_empty', 24, false);
				transBlack.animation.addByPrefix('idlefull', 'disk_transition_full', 24, false);
		}

		transBlack.antialiasing = ClientPrefs.globalAntialiasing;
		transBlack.scrollFactor.set();
		add(transBlack);

		if(isTransIn) 
		{
			var anim:String = 'transition';
			transBlack.animation.play('idlefull', true);
			switch (type)
			{
				default:
					anim = 'transition';
				case 'synsun' | 'songTrans':
					anim = 'transout';
			}
			transBlack.animation.play(anim, true, anim == 'transition');

			new FlxTimer().start(duration, function(tmr:FlxTimer)
				{
					close();
				});
		} 
		else 
		{
			var anim:String = 'transition';
			switch (type)
			{
				default:
					anim = 'transition';
				case 'synsun' | 'songTrans':
					anim = 'transin';
			}
			transBlack.animation.play('idleempty', true);
			transBlack.animation.play(anim, true);

			new FlxTimer().start(duration, function(tmr:FlxTimer)
			{
				if(finishCallback != null) {
					finishCallback();
				}
			});
		}

		if(nextCamera != null) {
			transBlack.cameras = [nextCamera];
		}
		nextCamera = null;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
	}

	override function destroy() {
		if(leTween != null) {
			finishCallback();
			leTween.cancel();
		}
		super.destroy();
	}
}