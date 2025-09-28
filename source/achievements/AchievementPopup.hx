package achievements;

import Language.LanguageText;
import openfl.events.Event;
import openfl.geom.Matrix;
import flash.display.BitmapData;
import openfl.Lib;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import achievements.Achievements;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import flixel.FlxCamera;
import flixel.util.FlxTimer;
import flixel.FlxSprite;

class AchievementPopup extends openfl.display.Sprite {
	public var onFinish:Void->Void = null;
	var alphaTween:FlxTween;
	var lastScale:Float = 1;
	public function new(achieve:String, onFinish:Void->Void)
	{
		super();

		var fancyName:String = 'Null';
		var iconName:String = 'default';
		var hasAntialias:Bool = ClientPrefs.globalAntialiasing;
		if (Achievements.achivementVarMap.get(achieve) != null)
		{
			//fancyName = Achievements.achivementVarMap.get(achieve).fancyName;
			fancyName = Language.flavor.get("achievement_" + achieve + "_name", Achievements.achivementVarMap.get(achieve).fancyName);
			iconName = Achievements.achivementVarMap.get(achieve).icon;
		}

		// bg
		var graphic = null;
		graphic = Paths.image('achievements/popup_border', false);
		var sizeX = 420;
		var sizeY = 130;
		var imgX = 0;
		var imgY = 0;
		var image = graphic.bitmap;
		graphics.beginBitmapFill(image, new Matrix(sizeX / image.width, 0, 0, sizeY / image.height, imgX, imgY), false, hasAntialias);
		graphics.drawRect(imgX, imgY, sizeX + 10, sizeY + 10);

		// achievement icon
		var graphic = null;
		var image:String = 'achievements/icons/$iconName';
		
		var achievement:Achievement = null;
		if(Achievements.achivementVarMap.get(achieve) != null) achievement = Achievements.achivementVarMap.get(achieve);

		graphic = Paths.image(image, false);
		var sizeX = 106;
		var sizeY = 100;
		var imgX = 0;
		var imgY = 15;
		var image = graphic.bitmap;
		graphics.beginBitmapFill(image, new Matrix(sizeX / image.width, 0, 0, sizeY / image.height, imgX, imgY), false, hasAntialias);
		graphics.drawRect(imgX, imgY, sizeX + 10, sizeY + 10);

		// achievement name/description
		var textX = 103;

		var text:LanguageText = new LanguageText(0, 0, 500, 'TEST!!!', 25, 'carat');
		text.setStyle(FlxColor.WHITE, LEFT);
		text.setBorderStyle(OUTLINE, FlxColor.BLACK);
		text.borderSize = 2;
		drawTextAt(text, fancyName, textX, 22);
		drawTextAt(text, Language.flavor.get("achievement_awarded", "Awarded!"), textX, 75);
		graphics.endFill();

		text.graphic.bitmap.dispose();
		text.graphic.bitmap.disposeImage();
		text.destroy();

		// other stuff
		FlxG.stage.addEventListener(Event.RESIZE, onResize);
		addEventListener(Event.ENTER_FRAME, update);

		FlxG.game.addChild(this); //Don't add it below mouse, or it will disappear once the game changes states

		// fix scale
		lastScale = (FlxG.stage.stageHeight / FlxG.height);
		this.x = 0 * lastScale;
		this.y = 720 * lastScale;
		this.scaleX = lastScale;
		this.scaleY = lastScale;
		intendedY = 0;
	}

	var bitmaps:Array<BitmapData> = [];
	function drawTextAt(text:LanguageText, str:String, textX:Float, textY:Float)
	{
		text.text = str;
		text.updateHitbox();

		var clonedBitmap:BitmapData = text.graphic.bitmap.clone();
		bitmaps.push(clonedBitmap);
		graphics.beginBitmapFill(clonedBitmap, new Matrix(1, 0, 0, 1, textX, textY), false, false);
		graphics.drawRect(textX, textY, text.width + textX, text.height + textY);
	}
	
	var lerpTime:Float = 0;
	var countedTime:Float = 0;
	var timePassed:Float = -1;
	public var intendedY:Float = 0;

	function update(e:Event)
	{
		if(timePassed < 0) 
		{
			timePassed = Lib.getTimer();
			return;
		}

		var time = Lib.getTimer();
		var elapsed:Float = (time - timePassed) / 1000;
		timePassed = time;
		//trace('update called! $elapsed');

		if(elapsed >= 0.5) return; //most likely passed through a loading

		countedTime += elapsed;
		if(countedTime < 3)
		{
			lerpTime = Math.min(1, lerpTime + elapsed);
			y = ((FlxEase.elasticOut(lerpTime) * (-intendedY - 130)) + 720) * lastScale;
		}
		else
		{
			y += FlxG.height * 2 * elapsed * lastScale;
			if(y <= -130 * lastScale)
				destroy();
		}
	}

	private function onResize(e:Event)
	{
		var mult = (FlxG.stage.stageHeight / FlxG.height);
		scaleX = mult;
		scaleY = mult;

		x = (mult / lastScale) * x;
		y = (mult / lastScale) * y;
		lastScale = mult;
	}

	public function destroy()
	{
		Achievements._popups.remove(this);
		//trace('destroyed achievement, new count: ' + Achievements._popups.length);

		if (FlxG.game.contains(this))
		{
			FlxG.game.removeChild(this);
		}
		FlxG.stage.removeEventListener(Event.RESIZE, onResize);
		removeEventListener(Event.ENTER_FRAME, update);
		deleteClonedBitmaps();
	}

	function deleteClonedBitmaps()
	{
		for (clonedBitmap in bitmaps)
		{
			if(clonedBitmap != null)
			{
				clonedBitmap.dispose();
				clonedBitmap.disposeImage();
			}
		}
		bitmaps = null;
	}
}