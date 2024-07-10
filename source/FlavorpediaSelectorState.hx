package;

import cpp.Int16;
#if discord_rpc
import Discord.DiscordClient;
#end
import editors.MasterEditorMenu;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxSpriteGroup;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.addons.text.FlxTypeText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.utils.Assets;
import haxe.Json;
import shaders.TwoToneMask;
import flixel.sound.FlxSound;

using StringTools;

class FlavorpediaSelectorState extends MusicBeatState
{
	var backdrop:FlxBackdrop;
	static var backdropPos:Array<Float> = [0, 0];
	var allowInput:Bool = false;

	var curSelected:Int = 0;
	var border:FlxSprite;
	var main:FlxSprite;
	var side:FlxSprite;

	override function create()
	{
		FlxG.mouse.visible = ClientPrefs.menuMouse;
		CoolUtil.difficulties = ["Normal"];

		#if discord_rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Viewing the Flavorpedia", null);
		#end
		
		backdrop = new FlxBackdrop(Paths.image('mainmenu/checkerboard'));
		backdrop.setPosition(backdropPos[0], backdropPos[1]);
		backdrop.velocity.set(-40, -40);
		backdrop.antialiasing = false;
		backdrop.shader = new TwoToneMaskShader(0xFF1ABBD4, 0xFF1B7AB1);
		add(backdrop);

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('flavorpedia/premenu/border'));
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		main = new FlxSprite(-92).loadGraphic(Paths.image('flavorpedia/premenu/main'));
		main.antialiasing = ClientPrefs.globalAntialiasing;
		add(main);

		side = new FlxSprite(670).loadGraphic(Paths.image('flavorpedia/premenu/side'));
		side.antialiasing = ClientPrefs.globalAntialiasing;
		add(side);

		new FlxTimer().start(0.2, function(tmr:FlxTimer)
		{
			changeItem();
			allowInput = true;
		});

		super.create();
	}


	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (allowInput)
		{
			if (controls.UI_LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.ACCEPT)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
				switch(curSelected)
				{
					case 0:
						MusicBeatState.switchState(new FlavorpediaState());
					case 1:
						MusicBeatState.switchState(new FlavorpediaSideState());
				}
			}

			if (controls.BACK)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
			}

			if(ClientPrefs.menuMouse)
			{
				if(FlxG.mouse.overlaps(main))
				{
					if (FlxG.mouse.justMoved && curSelected != 0)
					{
						curSelected = 0;
						changeItem();
						FlxG.sound.play(Paths.sound('scrollMenu'));
					}
					if(FlxG.mouse.justPressed)
					{
						FlxG.sound.play(Paths.sound('confirmMenu'));
						MusicBeatState.switchState(new FlavorpediaState());
					}
				}

				if(FlxG.mouse.overlaps(side))
				{
					if (FlxG.mouse.justMoved && curSelected != 1)
					{
						curSelected = 1;
						changeItem();
						FlxG.sound.play(Paths.sound('scrollMenu'));
					}
					if(FlxG.mouse.justPressed)
					{
						FlxG.sound.play(Paths.sound('confirmMenu'));
						MusicBeatState.switchState(new FlavorpediaSideState());
					}
				}
			}
			
		}
	}

	var dialogueEnded:Bool = false;

	function changeItem(huh:Int = 0)
	{
		var goingLeft:Bool = (huh > 0);
		curSelected += huh;

		if (curSelected > 1)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = 1;
		
		switch(curSelected)
		{
			case 0:
				FlxTween.tween(backdrop, {x:0}, 0.1, {ease: FlxEase.circOut});
				FlxTween.tween(main, {x:0}, 0.1, {ease: FlxEase.circOut});
				FlxTween.tween(side, {x:840}, 0.1, {ease: FlxEase.circOut});
			case 1:
				FlxTween.tween(backdrop, {x:-20}, 0.1, {ease: FlxEase.circOut});
				FlxTween.tween(main, {x:-272}, 0.1, {ease: FlxEase.circOut});
				FlxTween.tween(side, {x:601}, 0.1, {ease: FlxEase.circOut});
		}
	}

}