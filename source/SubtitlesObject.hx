package;

import Language.LanguageText;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxDirectionFlags;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;

#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

class SubtitlesObject extends FlxSpriteGroup
{
	var curArray:Int = 0;
	var awsomearray:Array<String> = [];
	var descBox:FlxSprite;
	var descText:LanguageText;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		//Stealing this from options menu
		descBox = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		descBox.alpha = 0.0001;
		add(descBox);
		insert(1000, descBox);

		descText = new LanguageText(50, 0, 1180, "", 28, 'krungthep');
		descText.setStyle(FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		descText.alpha = 0.001;
		add(descText);
		insert(1001, descText);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	public function setupSubtitles(hueh:String)
	{
		if (hueh == null || hueh == "") //Didn't think of this earlier. This is overall better than in the individual classes
			return;
		//setup array which is split as [NL]
		//Examp "This is a thing:dur:4[NL]Yeah man:dur:5"
		curArray = 0;
		awsomearray = hueh.split('[NL]');
		descBox.alpha = 0.6;
		descText.alpha = 1;
		startTextTimer(awsomearray[curArray]);
	}

	var startTimer:FlxTimer;
	function startTextTimer(textNdur:String)
	{
		//setup timer from array, time is taken at the end of the sentence split with :dur:
		//Examp "Apples are cool:dur:5" Text - Split - duration
		//When the timer ends check if there is anything else after the current dialogue. If so restart text.
		var dur:Float = 4;
		if (textNdur.split(':dur:')[1] != null)
			dur = Std.parseFloat(textNdur.split(':dur:')[1]);
		
		descText.text = textNdur.split(':dur:')[0];
		descBox.setPosition(descText.x - 10, descText.y - 10);
		descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
		descBox.updateHitbox();

		startTimer = new FlxTimer().start(dur, function(tmr:FlxTimer)
		{
			if (curArray < awsomearray.length - 1)
			{
				curArray += 1;
				startTextTimer(awsomearray[curArray]);
			}
			else
			{
				descText.text = '';
				descText.alpha = 0.001;
				descBox.alpha = 0.001;
			}
		});
	}

	public function justincase()
	{
		if (startTimer != null) startTimer.cancel();
	}
}
