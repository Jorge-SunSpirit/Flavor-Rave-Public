package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.graphics.frames.FlxAtlasFrames;
import shaders.AlphaMask;

class CDPlayer extends FlxSpriteGroup
{
	var bgSprite:FlxSprite;
	var charaSprite:FlxSprite;
	public function new(x:Float = 0, y:Float = 0, character:String, isBoyfriend:Bool) 
	{
		super(x, y);
		var side:String = (isBoyfriend ? 'right':'left');
		var chara:String = character;
		//trace(chara + ' ' + isBoyfriend);

		if (!Paths.fileExists('images/countdown/portraits/${chara}.png', IMAGE))
			chara = (isBoyfriend ? 'sweet' : 'sour');

		bgSprite = new FlxSprite().loadGraphic(Paths.image('countdown/${side}box'));
		bgSprite.antialiasing = ClientPrefs.globalAntialiasing;
		add(bgSprite);

		charaSprite = new FlxSprite().loadGraphic(Paths.image('countdown/portraits/$chara'));
		charaSprite.antialiasing = ClientPrefs.globalAntialiasing;
		charaSprite.flipX = isBoyfriend;
		charaSprite.shader = new AlphaMask(Paths.image('countdown/${side}box-mask')).shader;
		add(charaSprite);
	}
}