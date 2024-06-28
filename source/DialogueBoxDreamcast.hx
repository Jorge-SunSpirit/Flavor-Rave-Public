package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.Json;
import openfl.utils.Assets;

using StringTools;

typedef DreamcastDialogueFile =
{
	var dialogue:Array<DreamcastDialogueLine>;
}

typedef DreamcastDialogueLine =
{
	var background:Null<String>; // Leave blank to not change!
	var border:Null<String>; // border around the dialogue
	var chara:Null<Array<Dynamic>>; // uses icons and replaces character icon && box
	var text:Null<String>;
	var voice:Null<String>; // Used for talking sfx
	var bgm:Null<String>; // BGM
	var bgmVolume:Null<Float>; // BGM Volume
	var sound:Null<Array<Dynamic>>; // sound
	var command:Null<String>;
	var endImmediately:Null<Bool>; // If a command ends immediately
	var number:Null<Float>; // Used for any command that uses a float
	var textAlign:Null<String>; // Aligns text
}

class DialogueBoxDreamcast extends FlxSpriteGroup
{
	var dialogueData:DreamcastDialogueFile;

	var background:FlxSprite;
	var background2:FlxSprite;
	var border:FlxSprite;
	var box:FlxSprite;
	var charaIcon:HealthIcon;
	var dialogueText:FlxTypeText;
	var modiOpti:FlxSprite;

	public var finishThing:Void->Void = null;
	public var nextDialogueThing:Void->Void = null;
	public var skipDialogueThing:Void->Void = null;

	var currentDialogue:Int = 0;

	public function new(dialogueData:DreamcastDialogueFile)
	{
		super();

		this.dialogueData = dialogueData;
		
		FlxG.timeScale = 1;

		var bg = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), FlxColor.BLACK);
		bg.screenCenter();
		bg.alpha = 1;
		add(bg);

		background = new FlxSprite(0, 12).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		background.setGraphicSize(Std.int(background.width * 0.74));
		background.updateHitbox();
		background.screenCenter(X);
		background.antialiasing = ClientPrefs.globalAntialiasing;
		add(background);

		background2 = new FlxSprite(0, 12).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		background2.setGraphicSize(Std.int(background2.width * 0.74));
		background2.updateHitbox();
		background2.screenCenter(X);
		background2.antialiasing = ClientPrefs.globalAntialiasing;
		background2.alpha = 0.001;
		add(background2);

		border = new FlxSprite(0, 0).loadGraphic(Paths.image('dreamcast/borders/black'));
		border.antialiasing = ClientPrefs.globalAntialiasing;
		add(border);

		box = new FlxSprite(0, 0).loadGraphic(Paths.image('dreamcast/textbox/default'));
		box.antialiasing = ClientPrefs.globalAntialiasing;
		add(box);

		charaIcon = new HealthIcon('sweet', true);
		charaIcon.scale.set(0.75, 0.75);
		charaIcon.updateHitbox();
		charaIcon.setPosition(974, 458);
		add(charaIcon);

		dialogueText = new FlxTypeText(250, 570, 776, "", 24);
		dialogueText.font = Paths.font("Krungthep.ttf");
		dialogueText.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.25);
		dialogueText.antialiasing = ClientPrefs.globalAntialiasing;
		add(dialogueText);

		modiOpti = new FlxSprite(0, 687).loadGraphic(Paths.image('dreamcast/buttons'));
		modiOpti.antialiasing = ClientPrefs.globalAntialiasing;
		modiOpti.color = 0xFF747474;
		add(modiOpti);

		startDialogue();
	}

	var allowInput:Bool = true;

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		#if FORCE_DEBUG_VERSION
		if (FlxG.keys.pressed.CONTROL && (FlxG.keys.pressed.I || FlxG.keys.pressed.J || FlxG.keys.pressed.K || FlxG.keys.pressed.L))
		{
			trace(charaIcon.x + " X " + charaIcon.y + ' y');
			// Camera positioning and velocity changes
			if (FlxG.keys.pressed.I)
				charaIcon.y += -1;
			else if (FlxG.keys.pressed.K)
				charaIcon.y += 1;

			if (FlxG.keys.pressed.J)
				charaIcon.x += -1;
			else if (FlxG.keys.pressed.L)
				charaIcon.x += 1;
		}
		#end

		if (allowInput)
		{
			if (PlayerSettings.player1.controls.ACCEPT)
			{
				if (!dialogueEnded)
				{
					dialogueText.skip();

					if (skipDialogueThing != null)
						skipDialogueThing();
				}
				else
				{
					if (dialogueData.dialogue[currentDialogue] != null)
						startDialogue();
					else
						closeDialogue();
				}
			}
			else if (PlayerSettings.player1.controls.BACK)
			{
				closeDialogue();
			}
		}
	}

	public static function parseDialogue(path:String):DreamcastDialogueFile
	{
		return cast Json.parse(Assets.getText(path));
	}

	var dialogueEnded:Bool = false;

	function startDialogue():Void
	{
		var curDialogue:DreamcastDialogueLine = null;
		do
		{
			curDialogue = dialogueData.dialogue[currentDialogue];
		}
		while (curDialogue == null);

		if (curDialogue.background == null || curDialogue.background.length < 1)
			curDialogue.background = '';
		if (curDialogue.border == null || curDialogue.border.length < 1)
			curDialogue.border = '';
		if (curDialogue.chara == null || curDialogue.chara.length < 2)
			curDialogue.chara = ['', 0, false];
		if (curDialogue.text == null || curDialogue.text.length < 1)
			curDialogue.text = '';
		if (curDialogue.voice == null || curDialogue.voice.length < 1)
			curDialogue.voice = '';
		if (curDialogue.sound == null || curDialogue.sound.length < 2)
			curDialogue.sound = ['', ''];
		if (curDialogue.bgm == null || curDialogue.bgm.length < 1)
			curDialogue.bgm = '';
		if (curDialogue.command == null || curDialogue.command.length < 1)
			curDialogue.command = '';
		if (curDialogue.textAlign == null || curDialogue.textAlign.length < 1)
			curDialogue.textAlign = 'left';

		if (curDialogue.bgmVolume == null)
			curDialogue.bgmVolume = 1;

		if (curDialogue.endImmediately == null)
			curDialogue.endImmediately = false;

		if (curDialogue.command == '' || curDialogue.command == 'autoskip')
		{
			// Only allow input if it's not autoskip
			allowInput = (curDialogue.command != 'autoskip');

			// Maybe find a way to streamline this?
			updateIcon(curDialogue.chara[0], curDialogue.chara[1], curDialogue.chara[2]);
			dialogueText.resetText(curDialogue.text);
			dialogueText.start(0.04, true);
			switch (curDialogue.textAlign.toLowerCase())
			{
				case 'right':
					dialogueText.alignment = RIGHT;
				case 'center':
					dialogueText.alignment = CENTER;
				default:
					dialogueText.alignment = LEFT;
			}
			dialogueText.completeCallback = function()
			{
				dialogueEnded = true;

				if (curDialogue.command == 'autoskip')
					endDialogue();
			};

			//trace(curDialogue.sound);
			if (curDialogue.voice != '' && Paths.fileExists('dreamcast/${curDialogue.voice}.ogg', SOUND))
				dialogueText.sounds = [FlxG.sound.load(Paths.sound('dreamcast/${curDialogue.voice}'), 0.6)];
			else
				dialogueText.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];

			new FlxTimer().start(0.1, function(tmr:FlxTimer)
			{
				try
				{
					if (curDialogue.sound[0] != '')
						FlxG.sound.play(Paths.sound('dialogue/${curDialogue.sound[0]}/${curDialogue.sound[1]}'));
				}
				catch (e)
				{
					#if FORCE_DEBUG_VERSION
					FlxG.log.warn("Sound file not found! Wrong cords?");
					#else
					trace("Sound file not found! Wrong cords?");
					#end
				}
			});	
			
			// 
			if (curDialogue.background != '')
			{
				if (currentDialogue != 0 && (dialogueData.dialogue[currentDialogue-1].background == null || dialogueData.dialogue[currentDialogue-1].background != null && dialogueData.dialogue[currentDialogue-1].background != curDialogue.background))
				{
					FlxTween.cancelTweensOf(background);
					FlxTween.cancelTweensOf(background2);
					background2.loadGraphic(Paths.image('dreamcast/art_BG/${curDialogue.background}'));
					FlxTween.tween(background2, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
					FlxTween.tween(background, {alpha: 0.001}, 0.5, {ease: FlxEase.circOut, onComplete: function(twn:FlxTween)
					{
						background.loadGraphic(Paths.image('dreamcast/art_BG/${curDialogue.background}'));
						background.alpha = 1;
						background2.alpha = 0.001;
					}});
				}
				else
				{
					background.loadGraphic(Paths.image('dreamcast/art_BG/${curDialogue.background}'));
				}
			}

			if (curDialogue.border != '')
				border.loadGraphic(Paths.image('dreamcast/borders/${curDialogue.border}'));

			if (curDialogue.chara[0] != '')
				box.loadGraphic(Paths.image('dreamcast/textbox/${curDialogue.chara[0]}'));

			if (curDialogue.bgm != '')
			{
				switch (curDialogue.bgm)
				{
					default:
						FlxG.sound.playMusic(Paths.music(curDialogue.bgm), 0);
						FlxG.sound.music.fadeIn(1, 0, curDialogue.bgmVolume);
					case 'stop':
						FlxG.sound.music.fadeOut(1, 0);
					case 'resume':
						FlxG.sound.music.fadeIn(1, 0, curDialogue.bgmVolume);
					case 'volume':
						FlxG.sound.music.volume = curDialogue.bgmVolume;
				}
			}

			dialogueEnded = false;
		}
		else
		{
			allowInput = false;

			switch (curDialogue.command.toLowerCase())
			{
				default:
				{
					// Invalid command, immediately end incase this is an older build playing newer commands so we don't softlock
					endDialogue();
				}
				case 'pausemusic':
				{
					if (curDialogue.number == null)
						curDialogue.number = 1;

					FlxG.sound.music.fadeOut(curDialogue.number, 0, function(twn:FlxTween)
					{
						FlxG.sound.music.pause();

						if (!curDialogue.endImmediately)
							endDialogue();
					});

					if (curDialogue.endImmediately)
						endDialogue();
				}
				case 'resumemusic':
				{
					if (curDialogue.number == null)
						curDialogue.number = 1;

					FlxG.sound.music.play();
					FlxG.sound.music.fadeIn(curDialogue.number, 0, curDialogue.bgmVolume, function(twn:FlxTween)
					{
						if (!curDialogue.endImmediately)
							endDialogue();
					});

					if (curDialogue.endImmediately)
						endDialogue();
				}
				case 'stopmusic':
				{
					FlxG.sound.music.stop();
					endDialogue();
				}
				case 'musicvolume':
				{
					FlxG.sound.music.volume = curDialogue.bgmVolume;
					endDialogue();
				}
				case 'musicfadeout':
				{
					if (curDialogue.number == null)
						curDialogue.number = 1;

					// Since we use bgmVolume, anything fading out to 0 will need bgmVolume or else it'll go to 1 (sorry LOL)
					FlxG.sound.music.fadeOut(curDialogue.number, curDialogue.bgmVolume, function(twn:FlxTween)
					{
						if (!curDialogue.endImmediately)
							endDialogue();
					});

					if (curDialogue.endImmediately)
						endDialogue();
				}
				case 'fadein':
				{
					if (curDialogue.number == null)
						curDialogue.number = 1.5;

					PlayState.instance.camOther.fade(0xFF000000, curDialogue.number, true, function()
					{
						if (!curDialogue.endImmediately)
						{
							new FlxTimer().start(0.5, function(tmr:FlxTimer)
							{
								endDialogue();
							});
						}
					});

					if (curDialogue.endImmediately)
					{
						new FlxTimer().start(0.5, function(tmr:FlxTimer)
						{
							endDialogue();
						});
					}
				}
				case 'fadeout':
				{
					if (curDialogue.number == null)
						curDialogue.number = 1.5;

					FlxG.sound.music.fadeOut(curDialogue.number, 0);
					PlayState.instance.camOther.fade(0xFF000000, curDialogue.number, false, function()
					{
						if (!curDialogue.endImmediately)
						{
							new FlxTimer().start(0.5, function(tmr:FlxTimer)
							{
								endDialogue();
							});
						}
					});

					if (curDialogue.endImmediately)
					{
						new FlxTimer().start(0.5, function(tmr:FlxTimer)
						{
							endDialogue();
						});
					}
				}
				case 'flash':
				{
					if (curDialogue.number == null)
						curDialogue.number = 0.4;

					PlayState.instance.camOther.fade(0xFFFFFFFF, curDialogue.number, true, function()
					{
						if (!curDialogue.endImmediately)
							endDialogue();
					});

					if (curDialogue.endImmediately)
						endDialogue();
				}
				case 'playsound':
				{
					if (curDialogue.number == null)
						curDialogue.number = 1;

					FlxG.sound.play(Paths.sound(curDialogue.text), curDialogue.number, function()
					{
						if (!curDialogue.endImmediately)
							endDialogue();
					});

					if (curDialogue.endImmediately)
						endDialogue();
				}
				case 'timer':
				{
					if (curDialogue.number == null)
						curDialogue.number = 0;

					new FlxTimer().start(curDialogue.number, function(tmr:FlxTimer)
					{
						endDialogue();
					});
				}
				case 'shake':
				{
					if (curDialogue.number == null)
						curDialogue.number = 1;

					PlayState.instance.camHUD.shake(0.004, curDialogue.number, function()
					{
						if (!curDialogue.endImmediately)
							endDialogue();
					});

					if (curDialogue.endImmediately)
						endDialogue();
				}
			}
		}

		modiOpti.color = allowInput ? 0xFFFFFFFF : 0xFF4B4B4B;
		currentDialogue++;

		if (nextDialogueThing != null)
			nextDialogueThing();
	}

	function endDialogue():Void
	{
		dialogueEnded = true;
		dialogueText.skip();

		if (dialogueData.dialogue[currentDialogue] != null)
			startDialogue();
		else
			closeDialogue();
	}

	function closeDialogue():Void
	{
		allowInput = false;

		if (FlxG.sound.music.playing)
			FlxG.sound.music.fadeOut(Conductor.stepCrochet / 256, 0);

		new FlxTimer().start(0.1, function(tmr:FlxTimer)
		{
			FlxG.timeScale = PlayState.instance.playbackRate;
			finishThing();
			kill();
		});
	}

	function updateIcon(chara:String, expression:Int, isVisible:Bool)
	{
		// I don't remember if it's null it'll use the current value or replace it with null
		charaIcon.changeIcon((chara != null ? chara : 'sweet'));
		charaIcon.animation.curAnim.curFrame = expression;
		charaIcon.visible = isVisible;
	}
}
