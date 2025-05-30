import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.sound.FlxSound;
import flixel.util.FlxColor;

import funkin.vis.dsp.SpectralAnalyzer;
import openfl.media.SoundChannel;


// Cool visualizer bar for That's a Wrap!, based on code for Cerulean Symphony's Will. Yay!

@:access(flixel.sound.FlxSound)
@:access(openfl.media.SoundChannel)
class VisualizerBar extends FlxSpriteGroup
{
	// Visualizer's corresponding analyzer. Don't touch this! Setting certain variables will adjust things as needed.
	var analyzer:SpectralAnalyzer;

	// Music / Sound file the analyzer keeps track of. To set this to a song's instrumental or vocals, do so in an "onSongStart" function.
	var sound:FlxSound;

	// How many bars are in the visualizer itself. Don't try to update this one. It won't work. Probably.
	var barAmount:Int = 8;

	// Controls the width / height of the visualizer. Whichever one is used corresponds to the opposite of the visualizer's direction.
	// (Height is used for horizontal visualizers, width for vertical ones.). This same logic works for the next few variables.
	var totalWidth:Float = FlxG.width;
	var totalHeight:Float = FlxG.height;

	// Controls gaps between the bars. Doesn't automatically set itself.
	var gapSize:Float = 5;

	// You see I'd call these variables "maxSize" but this class is STUPID and already HAS that variable name.
	var maxLength:Float = 200;
	var minLength:Float = 10;

	// Direction the bars like, bop to? I don't know how to really describe this.
	var direction:String = "raise";
	var flipped:Bool = false;

	function new(x:Float = 0, y:Float = 0, ?direction:String = "raise", ?amount:Int = 8, ?color:FlxColor = FlxColor.WHITE)
	{
		super(x, y);
		barAmount = amount;
		this.direction = direction;

		for (i in 0...barAmount)
		{
			var bar:FlxSprite = new FlxSprite(gapSize, gapSize).makeGraphic(1, 1, 0xFFFFFFFF); // That's right we're gonna cheat!
			bar.color = color;
			bar.scale.set(minLength, minLength);
			switch(direction)
			{
				case "left" | "right" | "vertical":
					bar.y += ((totalHeight - gapSize) / barAmount) * i;
					bar.scale.y = (totalHeight - gapSize) / barAmount - gapSize;
					bar.updateHitbox();
				default:
					bar.x += ((totalWidth - gapSize) / barAmount) * i;
					bar.scale.x = (totalWidth - gapSize) / barAmount - gapSize;
					bar.updateHitbox();

			}
			// bar.visible = false;
			add(bar);
		}
	}

	override function update(elapsed)
	{
		super.update(elapsed);
		if (analyzer == null)
		{
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing) return;
				sound = FlxG.sound.music;
				analyzer = new SpectralAnalyzer(sound._channel.__audioSource, barAmount, 0.1, 40);
    			analyzer.fftN = 256;
			}
			else return;
		}
		var levels = analyzer.getLevels();
		for(i in 0...barAmount)
		{
			// Level ranges from 0 to 5. This makes it better! Yay!
			var size:Float = levels[i].value * maxLength + 10;
			if (size > maxLength) size = maxLength;
			var bar = (flipped ? barAmount - (i + 1) : i);
			// This is SUPER scuffed but the only way I could get this to work. Fuck my stupid Weeg life.
			switch(direction)
			{
				case "right":
					this.members[bar].scale.x = size;
					this.members[bar].updateHitbox();
					this.members[bar].x = FlxG.width - this.members[bar].width - gapSize;

					this.members[bar].y = gapSize;
					this.members[bar].y += ((totalHeight - gapSize) / barAmount) * bar;
					this.members[bar].scale.y = (totalHeight - gapSize) / barAmount - gapSize;
				case "left":
					this.members[bar].scale.x = size;
					this.members[bar].updateHitbox();
					this.members[bar].x = gapSize;

					this.members[bar].y = gapSize;
					this.members[bar].y += ((totalHeight - gapSize) / barAmount) * bar;
					this.members[bar].scale.y = (totalHeight - gapSize) / barAmount - gapSize;
				case "vertical":
					this.members[bar].scale.x = size;
					this.members[bar].updateHitbox();
					this.members[bar].screenCenter(X);

					this.members[bar].y = gapSize;
					this.members[bar].y += ((totalHeight - gapSize) / barAmount) * bar;
					this.members[bar].scale.y = (totalHeight - gapSize) / barAmount - gapSize;
				case "raise":
					this.members[bar].scale.y = size;
					this.members[bar].updateHitbox();
					this.members[bar].y = FlxG.height - this.members[bar].height - gapSize;

					this.members[bar].x = gapSize;
					this.members[bar].x += ((totalWidth - gapSize) / barAmount) * bar;
					this.members[bar].scale.x = (totalWidth - gapSize) / barAmount - gapSize;
				case "lower":
					this.members[bar].scale.y = size;
					this.members[bar].updateHitbox();
					this.members[bar].y = gapSize;

					this.members[bar].x = gapSize;
					this.members[bar].x += ((totalWidth - gapSize) / barAmount) * bar;
					this.members[bar].scale.x = (totalWidth - gapSize) / barAmount - gapSize;
				case "horizontal":
					this.members[bar].scale.y = size;
					this.members[bar].updateHitbox();
					this.members[bar].screenCenter(Y);

					this.members[bar].x = gapSize;
					this.members[bar].x += ((totalWidth - gapSize) / barAmount) * bar;
					this.members[bar].scale.x = (totalWidth - gapSize) / barAmount - gapSize;
			}
		}
	}
}