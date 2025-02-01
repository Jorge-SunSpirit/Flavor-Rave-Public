package;

import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.util.FlxColor;

class PopupRating extends FlxSpriteGroup
{
	public var coolText:FlxText;

	public var rating:FlxSprite;
	var comboScore:Array<FlxSprite> = [];
	var ratingTween:FlxTween;
	var numScoreTween:FlxTween;

	public function new():Void
	{
		super();
		coolText = new FlxText(0, 0, 0, '', 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.35;
		//I have no idea what coolText is used for but I'm keeping it just incase.
		//update I now know it's used to get the proper screencenter I guess?????

		rating = new FlxSprite();
		rating.visible = (PlayState.instance.showRating);
		rating.alpha = 0.0001;
		add(rating);
	}

	override function update(elapsed:Float):Void
	{
		
	}

	public function pop(folder:String, ratingSprite:String, suffix:String, combo:Int, ?pixel:Bool = false)
	{
		coolText.x = FlxG.width * 0.35;

		rating.loadGraphic(Paths.image(folder + ratingSprite + suffix));
		rating.alpha = 1;

		if (!pixel)
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = ClientPrefs.globalAntialiasing;
		}
		else
			rating.setGraphicSize(Std.int(rating.width * PlayState.daPixelZoom * 0.85));
		
		rating.updateHitbox();
		rating.screenCenter();
		rating.x = coolText.x - 40;
		rating.x += ClientPrefs.comboOffset[0];
		rating.y -= 60;
		rating.y -= ClientPrefs.comboOffset[1];

		if(ratingTween != null) 
			ratingTween.cancel();
		ratingTween = FlxTween.tween(rating.scale, {x: pixel ? PlayState.daPixelZoom - 1.25 : 0.65, y: pixel ? PlayState.daPixelZoom - 1.25 : 0.65}, 0.2, {
			onComplete: function(twn:FlxTween) {
				ratingTween = FlxTween.tween(rating, {alpha: 0.001}, 0.2, {
					onComplete: function(twn:FlxTween) {
						ratingTween = null;
					},
					startDelay: Conductor.crochet * 0.002
				});
			}
		}); 


		//comboScore
		var testString:String = "" + combo;
		var testArray:Array<String> = testString.split("");

		for (i in 0...comboScore.length)
		{
			FlxTween.cancelTweensOf(comboScore[i]);
		}

		purgeCombo();

		for (i in 0...testArray.length)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(folder + 'num' + testArray[i] + suffix));
			add(numScore);
			comboScore.push(numScore);

			if (!pixel)
			{
				numScore.antialiasing = ClientPrefs.globalAntialiasing;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			else
				numScore.setGraphicSize(Std.int(numScore.width * PlayState.daPixelZoom));
			
			numScore.updateHitbox();

			//Take the to center the combo score and make any number after the first go to the immediate right
			numScore.screenCenter();
			numScore.x = coolText.x;
			numScore.y += 80;
			numScore.x += ClientPrefs.comboOffset[2];
			numScore.y -= ClientPrefs.comboOffset[3];
			var apple:Float = numScore.x;
			numScore.x = (apple - ((numScore.width * 0.5) * testArray.length)) + (numScore.width * i);

			FlxTween.tween(numScore, {"scale.x": pixel ? PlayState.daPixelZoom - 0.45 : 0.45, "scale.y": pixel ? PlayState.daPixelZoom - 0.45 : 0.45}, 0.2,
			{
				onComplete: function(twn:FlxTween) 
				{
					FlxTween.tween(numScore, {alpha: 0.001}, 0.2, {startDelay: Conductor.crochet * 0.002});
				}
			});
		}
	}

	function purgeCombo()
	{
		if (comboScore.length < 1)
			return;

		//Kills choicer
		for (i in 0...comboScore.length) {
			var obj = comboScore[0];
			obj.kill();
			comboScore.remove(obj);
			obj.destroy();
		}
	}

	public function cachePopUpSprites(char:Character = null, folder:String = '')
	{
		var suffix:String = '';

		if (PlayState.isPixelStage)
		{
			folder = 'pixelUI/';
			suffix = '-pixel';
		}

		if (char.ratings_folder != null && char.ratings_folder != '')
			folder = 'ratings/' + char.ratings_folder + '/';

		Paths.image(folder + "marvelous" + suffix);
		Paths.image(folder + "sick" + suffix);
		Paths.image(folder + "good" + suffix);
		Paths.image(folder + "bad" + suffix);
		Paths.image(folder + "shit" + suffix);
		
		for (i in 0...10) {
			Paths.image(folder + 'num' + i + suffix);
		}
	}
}