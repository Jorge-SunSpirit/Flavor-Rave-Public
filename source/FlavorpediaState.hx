package;

import Language.LanguageText;
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
import SubtitlesObject;

#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

typedef CharacterList = {
	var character:Array<CharacterArray>;
}

typedef CharacterArray = {
	var chara:Null<String>; // handles the render
	var flavorText:Null<String>; // All of the dialogue
	var tag:Null<String>; // the tag
	var bgs:Null<String>; // the bg
	var voicelines:Array<String>;//add voicelines here, ideally it would be ['1', '2', '3', etc] The directory it will use is (sounds/flavorpedia/(charaname)/(sound))
	var subtitles:Null<String>;
	var songCheck:Null<String>; // leave blank if unlocked by default
	var link:Null<String>;
}

class FlavorpediaState extends MusicBeatState
{
	var allowInput:Bool = false;

	var curSelected:Int = 0;

	var linkSprite:FlxSprite;
	var voicelineSprite:FlxSprite;
	var charaVoice:FlxSound;
	var arrows:FlxSpriteGroup;

	var characters:FlxTypedGroup<FlxSprite>;
	var tags:FlxTypedGroup<FlxSprite>;
	var backgrounds:FlxTypedGroup<FlxSprite>;

	var charaStuff:Array<Array<Dynamic>> = [];
	var flavorText:LanguageText;

	var subtitles:SubtitlesObject;

	public var bufferArray:Array<CharacterArray> = [];

	override function create()
	{
		FlxG.mouse.visible = ClientPrefs.menuMouse;

		#if discord_rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Viewing the Flavorpedia", null);
		#end

		backgrounds = new FlxTypedGroup<FlxSprite>();
		add(backgrounds);
		characters = new FlxTypedGroup<FlxSprite>();
		add(characters);
		tags = new FlxTypedGroup<FlxSprite>();
		add(tags);

		flavorText = new LanguageText(706, 268, 494, "", 18, 'krungthep');
		flavorText.setStyle(FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(flavorText);

		var path:String = Paths.getPreloadPath('data/flavorpediaData.json');
		var rawJson = Assets.getText(path);
		var json:CharacterList = cast Json.parse(rawJson);
		//trace(json);

		bufferArray = json.character;
		//trace(bufferArray);

		for (peep in bufferArray)
		{
			var isBeaten:Bool = peep.songCheck != null && Highscore.checkBeaten(peep.songCheck, 0) || peep.songCheck == null;

			#if FORCE_DEBUG_VERSION
			if (!isBeaten) FlxG.log.warn('[FP] ${peep.chara} is normally locked, but forcing unlocked due to debug.');
			isBeaten = true;
			#end

			if (isBeaten)
				charaStuff.push([Language.flavor.get("flavorpedia_" + peep.chara, peep.chara), 
				Language.flavor.get("flavorpedia_" + peep.chara + "_desc", peep.flavorText), 
				Language.flavor.get("flavorpedia_" + peep.chara + "_tag", peep.tag), 
				Language.flavor.get("flavorpedia_" + peep.chara + "_bg", peep.bgs), 
				peep.voicelines,
				Language.flavor.get("flavorpedia_" + peep.chara + "_subtitles", peep.subtitles),  
				peep.link]);
				//charaStuff.push([peep.chara, peep.flavorText, peep.tag, peep.bgs, peep.voicelines, peep.link]);
		}

		#if MODS_ALLOWED
		var modsDirectories:Array<String> = Paths.getGlobalMods();
		for (folder in modsDirectories)
		{
			//This idea works and it's almost great. BUT 
			var modPath:String = Paths.modFolders('data/flavorpediaData.json', folder);
			trace(FileSystem.exists(modPath));
			if (FileSystem.exists(modPath))
			{
				json = cast Json.parse(File.getContent(modPath));
				bufferArray = json.character;

				for (peep in bufferArray)
				{
					var isBeaten:Bool = peep.songCheck != null && Highscore.checkBeaten(peep.songCheck, 0) || peep.songCheck == null;
		
					#if FORCE_DEBUG_VERSION
					if (!isBeaten) FlxG.log.warn('[FP] ${peep.chara} is normally locked, but forcing unlocked due to debug.');
					isBeaten = true;
					#end
		
					
					if (isBeaten)
						charaStuff.push([Language.flavor.get("flavorpedia_" + peep.chara, peep.chara), 
						Language.flavor.get("flavorpedia_" + peep.chara + "_desc", peep.flavorText), 
						Language.flavor.get("flavorpedia_" + peep.chara + "_tag", peep.tag), 
						Language.flavor.get("flavorpedia_" + peep.chara + "_bg", peep.bgs), 
						peep.voicelines,
						Language.flavor.get("flavorpedia_" + peep.chara + "_subtitles", peep.subtitles),  
						peep.link]);
				}

			}
		}
		#end

		for (i in 0...charaStuff.length)
		{
			var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('flavorpedia/bgs/' + charaStuff[i][3]));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.screenCenter();
			bg.ID = i;
			if (i != curSelected) bg.alpha = 0.0001;
			backgrounds.add(bg);

			var tag:FlxSprite = new FlxSprite(640, 0).loadGraphic(Paths.image('flavorpedia/tags/' + charaStuff[i][2]));
			tag.antialiasing = ClientPrefs.globalAntialiasing;
			tag.ID = i;
			if (i != curSelected) tag.alpha = 0.0001;
			tags.add(tag);

			var chara:FlxSprite = new FlxSprite().loadGraphic(Paths.image('flavorpedia/renders/' + charaStuff[i][0]));
			chara.antialiasing = ClientPrefs.globalAntialiasing;
			chara.ID = i;
			if (i != curSelected) chara.alpha = 0.0001;
			characters.add(chara);
		}
		
		voicelineSprite = new FlxSprite(20, 640).loadGraphic(Paths.image('flavorpedia/voiceline'));
		voicelineSprite.antialiasing = ClientPrefs.globalAntialiasing;
		add(voicelineSprite);

		linkSprite = new FlxSprite((voicelineSprite.x + voicelineSprite.width) + 10, 640).loadGraphic(Paths.image('flavorpedia/link'));
		linkSprite.antialiasing = ClientPrefs.globalAntialiasing;
		linkSprite.alpha = 0.001;
		add(linkSprite);

		subtitles = new SubtitlesObject(0,0);
		subtitles.screenCenter(Y);
		subtitles.y += 270;
		subtitles.antialiasing = ClientPrefs.globalAntialiasing;
		add(subtitles);

		arrows = new FlxSpriteGroup();
		add(arrows);

		for (i in 0...2)
		{
			var arrow:FlxSprite = new FlxSprite(7 + (i * 558)).loadGraphic(Paths.image('gallery/arrow'));
			arrow.screenCenter(Y);
			arrow.ID = i;
			arrow.antialiasing = ClientPrefs.globalAntialiasing;
			if (i == 0)
				arrow.flipX = true;
			arrows.add(arrow);
		}

		flavorText.text = charaStuff[curSelected][1];

		new FlxTimer().start(0.2, function(tmr:FlxTimer)
		{
			allowInput = true;
		});

		super.create();
	}


	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (allowInput)
		{
			if (FlxG.keys.justPressed.SPACE)
			{
				playVoice();
			}

			if (FlxG.keys.justPressed.ENTER)
			{
				openLink();
			}

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

			if(ClientPrefs.menuMouse)
			{
				if(FlxG.mouse.overlaps(voicelineSprite))
				{
					if(FlxG.mouse.justPressed)
					{
						playVoice();
					}
				}

				if(FlxG.mouse.overlaps(linkSprite))
				{
					if(FlxG.mouse.justPressed)
					{
						openLink();
					}
				}

				arrows.forEach(function(spr:FlxSprite)
				{
					if (FlxG.mouse.overlaps(spr) && FlxG.mouse.justPressed)
						changeItem((spr.ID == 0 ? -1 : 1));
				});
			}

			if (controls.BACK)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new FlavorpediaSelectorState());
			}
			
		}
	}

	var dialogueEnded:Bool = false;

	function changeItem(huh:Int = 0)
	{
		var goingLeft:Bool = (huh > 0);
		curSelected += huh;

		if (curSelected >= charaStuff.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = charaStuff.length - 1;

		var bullShit:Int = 0;

		backgrounds.forEach(function(spr:FlxSprite)
		{
			FlxTween.cancelTweensOf(spr);
			FlxTween.tween(spr, {alpha: 0.001}, 0.7, {ease: FlxEase.circOut});
			if (curSelected == spr.ID)
			{
				FlxTween.cancelTweensOf(spr);
				FlxTween.tween(spr, {alpha: 1}, 0.7, {ease: FlxEase.circOut});
			}
		});	
		tags.forEach(function(spr:FlxSprite)
		{
			FlxTween.cancelTweensOf(spr);
			FlxTween.tween(spr, {alpha: 0.001}, 0.7, {ease: FlxEase.circOut});
			if (curSelected == spr.ID)
			{
				FlxTween.cancelTweensOf(spr);
				FlxTween.tween(spr, {alpha: 1}, 0.7, {ease: FlxEase.circOut});
			}
		});
		characters.forEach(function(spr:FlxSprite)
		{
			var transSpritesEnd:Float = (goingLeft ? -640 : 1280);
			var mainSpriteStart:Float = (!goingLeft ? -640 : 1280);

			FlxTween.cancelTweensOf(spr);
			spr.x = 0;
			FlxTween.tween(spr, {x: transSpritesEnd, alpha: 0.001}, 0.7, {ease: FlxEase.circOut});
			if (curSelected == spr.ID)
			{
				spr.alpha = 1;
				spr.x = mainSpriteStart;
				FlxTween.cancelTweensOf(spr);
				FlxTween.tween(spr, {x: 0, alpha: 1}, 0.7, {ease: FlxEase.circOut});
			}
		});
		
		FlxTween.tween(flavorText, {alpha: 0.0001}, 0.35, {ease: FlxEase.circOut, onComplete: function(twn:FlxTween)
		{
			flavorText.text = charaStuff[curSelected][1];
			FlxTween.tween(flavorText, {alpha: 1}, 0.35, {ease: FlxEase.circOut});
		}});

		if(charaStuff[curSelected][6] != null && charaStuff[curSelected][6] != '')
			{
				FlxTween.cancelTweensOf(linkSprite.alpha);
				FlxTween.tween(linkSprite, {alpha: 1}, 0.2, {ease: FlxEase.circOut});
			}
		else
			{
				FlxTween.cancelTweensOf(linkSprite.alpha);
				FlxTween.tween(linkSprite, {alpha: 0.001}, 0.2, {ease: FlxEase.circOut});
			}

		var arrowDir:Int = -1;
		if (huh == -1) arrowDir = 0; else if (huh == 1) arrowDir = 1;

		arrows.forEach(function(spr:FlxSprite)
			{
				if (spr.ID == arrowDir)
				{
					FlxTween.cancelTweensOf(spr.scale.x);
					FlxTween.cancelTweensOf(spr.scale.y);
					FlxTween.tween(spr, {"scale.x": 1.2, "scale.y": 1.2}, 0.1, {ease: FlxEase.circOut, onComplete: function(twn:FlxTween)
					{
						FlxTween.tween(spr, {"scale.x": 1, "scale.y": 1}, 0.1, {ease: FlxEase.circOut});
					}});
				}
			});
	}

	function playVoice()
	{
		FlxTween.cancelTweensOf(voicelineSprite);
		FlxTween.tween(voicelineSprite, {"scale.x": 0.8, "scale.y": 0.8}, 0.5, {ease: FlxEase.circOut, onComplete: function(twn:FlxTween)
		{
			FlxTween.tween(voicelineSprite, {"scale.x": 1, "scale.y": 1}, 0.5, {ease: FlxEase.circOut});
		}});

		try
		{
			killVoice();
			var dialogueArray:Array<String> = charaStuff[curSelected][4];
			var dialogue:String = dialogueArray[FlxG.random.int(0, dialogueArray.length - 1)];
			charaVoice = new FlxSound().loadEmbedded(Paths.sound('flavorpedia/${charaStuff[curSelected][0]}/${dialogue}'));
			charaVoice.onComplete = function() {
				FlxG.sound.music.fadeIn(4, 0.12, 0.8); 
				for (vocal in FreeplayState.vocalTracks)
				{
					if (vocal != null)
					{
						vocal.fadeIn(4, 0.12, 0.8); 
					}
				}
			}
			charaVoice.play();

			if (ClientPrefs.subtitles)
			{
				subtitles.justincase();
				if (ClientPrefs.subtitles)
					subtitles.setupSubtitles(charaStuff[curSelected][5]);
			}

			FlxG.sound.music.fadeOut(0.2, 0.12);
			for (vocal in FreeplayState.vocalTracks)
			{
				if (vocal != null)
				{
					vocal.fadeOut(0.2, 0.12);
				}
			}
		}
		catch (e)
		{
			trace('Sound not found');
		}
	}

	function openLink()
	{
		if(charaStuff[curSelected][6] != null && charaStuff[curSelected][6] != '')
		{
			FlxTween.cancelTweensOf(linkSprite.scale.x);
			FlxTween.cancelTweensOf(linkSprite.scale.y);
			FlxTween.tween(linkSprite, {"scale.x": 0.8, "scale.y": 0.8}, 0.1, {ease: FlxEase.circOut, onComplete: function(twn:FlxTween)
			{
				FlxTween.tween(linkSprite, {"scale.x": 1, "scale.y": 1}, 0.1, {ease: FlxEase.circOut});
			}});
			CoolUtil.browserLoad(charaStuff[curSelected][6]);
		}
	}

	function killVoice():Void
	{
		if (charaVoice != null)
		{
			charaVoice.stop();
			charaVoice.destroy();
		}
	}

}