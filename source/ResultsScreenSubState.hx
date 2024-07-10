package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.FlxInput;
import flixel.input.FlxKeyManager;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.addons.text.FlxTypeText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.Exception;
import openfl.display.BitmapData;
import openfl.geom.Matrix;
import haxe.Json;

using StringTools;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end

typedef Dioson = {
	var dialogue:Array<TheDialogue>;
}

typedef TheDialogue = {
	var name:String;
	var rank:String;
	var boxSprite:String;
}

class ResultsScreenSubState extends MusicBeatSubstate
{
	public static var fullCombo:Bool = false;
	var canpressbuttons:Bool = false;
	var fcSongSprite:BGSprite;
	public static var chara:String = 'sour';
	public var background:FlxSprite;
	public var stroke:FlxSprite;
	public var strokefinal:FlxSprite;
	public var charaSprite:FlxSprite;
	public var dialoguebox:FlxSprite;
	public var resultbox:FlxSprite;
	
	public var dialogueText:FlxTypeText;
	public var comboText:FlxText;
	
	public var finalresult:FlxSprite;
	public var rank:FlxSprite;

	public var pauseMusic:FlxSound;

	var rankingLetter:String;

	override function create()
	{
		var delayTimer:Float = fullCombo ? 3.5 : 0.1;
		if (fullCombo)
		{
			fcSongSprite = new BGSprite('ratingFC', 0, 0, 0, 0, ['FC']);
			fcSongSprite.alpha = 0.001;
			add(fcSongSprite);
	
			
			fcSongSprite.alpha = 1;
			fcSongSprite.dance();
			new FlxTimer().start(2.5, function(tmr:FlxTimer) {
				FlxTween.tween(fcSongSprite, {alpha: 0.0001}, 1, {ease: FlxEase.quadInOut, onComplete: function(twn:FlxTween) {}});
			});

			new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxG.sound.play(Paths.sound('rating-FC'), 1);
			});
		}

		background = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		background.scrollFactor.set();
		background.alpha = 0.0001;
		add(background);

		strokefinal = new FlxSprite().loadGraphic(Paths.image('results/character/${chara}/static_stroke'));
		strokefinal.antialiasing = ClientPrefs.globalAntialiasing;
		strokefinal.alpha = 0.001;
		add(strokefinal);

		stroke = new FlxSprite();
		stroke.frames = Paths.getSparrowAtlas('results/stroke');
		stroke.animation.addByPrefix('idle', 'stroke instance 1', 24, false);
		stroke.antialiasing = ClientPrefs.globalAntialiasing;
		stroke.animation.play('idle');
		stroke.alpha = 0.001;
		stroke.color = 0xFF000000;
		add(stroke);

		rankingLetter = PlayState.instance.ratingLetter;

		switch (rankingLetter)
		{
			case 'D' | 'C' | 'B' | 'A' | 'S':
				trace('Valid :D');
			default:
				trace('Not valid????');
				rankingLetter = 'D';
		}

		pauseMusic = new FlxSound();
		if (rankingLetter == 'S')
			pauseMusic.loadEmbedded(Paths.music('results_jingle_s'), false, true);
		else
			pauseMusic.loadEmbedded(Paths.music('results_jingle'), false, true);
		FlxG.sound.list.add(pauseMusic);

		var characterPath:String = 'images/results/character/${chara}/dialogue.json';
		var path:String = '';
		#if MODS_ALLOWED
			path = Paths.modFolders(characterPath);
			if (!FileSystem.exists(path)) 
				path = Paths.getPreloadPath(characterPath);
			if (!FileSystem.exists(path))
				path = Paths.getPreloadPath('images/results/character/sour/dialogue.json');
		#else
			path = Paths.getPreloadPath(characterPath);
			if (!Assets.exists(path))
				path = Paths.getPreloadPath('images/results/character/sour/dialogue.json');
		#end
		#if MODS_ALLOWED
		var rawJson = File.getContent(path);
		#else
		var rawJson = Assets.getText(path);
		#end
		var json:Dioson = cast Json.parse(rawJson);
		var dioArray:Array<TheDialogue> = json.dialogue;
		var theArrayofAllTime:Array<TheDialogue> = [];

		for (dialogue in dioArray) 
		{
			if (dialogue.rank == rankingLetter)
				theArrayofAllTime.push(dialogue);
		}

		if (theArrayofAllTime[0] == null)
		{
			theArrayofAllTime.push(dioArray[0]);
		}

		charaSprite = new FlxSprite(FlxG.width, -34).loadGraphic(Paths.image('results/character/${chara}/render'));
		charaSprite.antialiasing = ClientPrefs.globalAntialiasing;
		charaSprite.scale.set(1.5, 1.5);
		charaSprite.updateHitbox();
		add(charaSprite);

		var rand:Int = FlxG.random.int(0, theArrayofAllTime.length - 1);
		dialoguebox = new FlxSprite(0, 456).loadGraphic(Paths.image('results/character/${chara}/${theArrayofAllTime[rand].boxSprite}'));
		dialoguebox.antialiasing = ClientPrefs.globalAntialiasing;
		dialoguebox.alpha = 0.001;
		add(dialoguebox);

		dialogueText = new FlxTypeText(62.8, 570, 713, theArrayofAllTime[rand].name, 24);
		dialogueText.font = Paths.font("Krungthep.ttf");
		dialogueText.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.25);
		dialogueText.antialiasing = ClientPrefs.globalAntialiasing;
		dialogueText.alpha = 0.001;
		add(dialogueText);

		resultbox = new FlxSprite(865, 474).loadGraphic(Paths.image('results/scorebox'));
		resultbox.antialiasing = ClientPrefs.globalAntialiasing;
		resultbox.alpha = 0.001;
		resultbox.scale.set(0.6, 0.6);
		resultbox.updateHitbox();
		add(resultbox);
		
		var score:String = "Score: " + (PlayState.isStoryMode ? PlayState.campaignScore : PlayState.instance.songScore) + '\n';
		var biggercombo:Int = PlayState.instance.highestCombo + 1;
		var biggestCombro:String = (PlayState.isStoryMode ?  "" : "Highest Combo: " + biggercombo + '\n');
		var misses:String = "Combo Breaks: " + (PlayState.isStoryMode ? PlayState.campaignMisses : PlayState.instance.songMisses) + '\n';

		comboText = new FlxText(878, PlayState.isStoryMode ? 565 : 550, 400,
		'${score}${biggestCombro}${misses}').setFormat(Paths.font("FOT-Carat Std UB.otf"), 30, FlxColor.WHITE, LEFT);
		comboText.scrollFactor.set();
		comboText.alpha = 0.001;
		add(comboText);

		finalresult = new FlxSprite(0, 0).loadGraphic(Paths.image('results/FINAL_RESULTS'));
		finalresult.antialiasing = ClientPrefs.globalAntialiasing;
		finalresult.alpha = 0.001;
		finalresult.scale.set(0.6, 0.6);
		finalresult.updateHitbox();
		add(finalresult);
		
		rank = new FlxSprite(878, 79).loadGraphic(Paths.image('results/Score${rankingLetter}'));
		rank.antialiasing = ClientPrefs.globalAntialiasing;
		rank.scale.set(0.001,0.001);
		add(rank);

		//Prob can get rid of this code but idk yet
		var mean:Float = 0;

		mean = CoolUtil.floorDecimal(mean / PlayState.rep.replay.songNotes.length, 2);
		
		var usedPractice:Bool = (ClientPrefs.getGameplaySetting('practice', false) || ClientPrefs.getGameplaySetting('botplay', false));
		var isLeaderboardCompatible:String = "Rejected";
		if (!usedPractice && !PlayState.chartingMode) {
			isLeaderboardCompatible = "Accepted";
		}

		if (rankingLetter == 'S')
		{
			new FlxTimer().start(delayTimer, function(tmr:FlxTimer)
			{
				pauseMusic.play(true);
				FlxTween.tween(background, {alpha: 0.5}, 0.2);
				FlxTween.tween(finalresult, {alpha: 1}, 0.5, {ease: FlxEase.expoOut, startDelay: 1});
				stroke.animation.play('idle');
				stroke.alpha = 1;
				FlxTween.tween(charaSprite, {x: -58}, 0.5, {ease: FlxEase.expoOut, startDelay: 0.397});
				
				new FlxTimer().start(0.775, function(tmr:FlxTimer) {
					FlxTween.color(stroke, 0.1, stroke.color, 0xFFFFFFFF, { onComplete: function(twn:FlxTween)
						{
							FlxTween.tween(stroke, {alpha: 0}, 0.2, {ease: FlxEase.expoOut, startDelay: 0.1});
							strokefinal.alpha = 1;
						}
					});
				});
				FlxTween.tween(dialoguebox, {alpha: 1}, 0.5, {ease: FlxEase.expoOut, startDelay: 1.5, onComplete: function(twn:FlxTween)
				{
					dialogueText.alpha = 1;
					dialogueText.start(0.04, true);
				}});
				FlxTween.tween(resultbox, {alpha: 1}, 0.5, {ease: FlxEase.expoOut, startDelay: 2.5});
				FlxTween.tween(comboText, {alpha: 1}, 0.5, {ease: FlxEase.expoOut, startDelay: 3});
				
				new FlxTimer().start(6.48, function(tmr:FlxTimer) {
					FlxTween.tween(rank, {"scale.x": 1.2, "scale.y": 1.2}, 0.1, {ease: FlxEase.cubeIn, onComplete: function(twn:FlxTween)
					{
						FlxTween.tween(rank, {"scale.x": 1, "scale.y": 1}, 0.3, {ease: FlxEase.bounceOut});
	
						new FlxTimer().start(1, function(tmr:FlxTimer) {
							if(Paths.fileExists('sounds/ratings/${rankingLetter}.ogg', SOUND))
								FlxG.sound.play(Paths.sound('ratings/${rankingLetter}'), 1);
						});
						canpressbuttons = true;
					}});	
				});
			});
		}
		else
		{
			new FlxTimer().start(delayTimer, function(tmr:FlxTimer)
			{
				pauseMusic.play(true);
				FlxTween.tween(background, {alpha: 0.5}, 0.5);
				FlxTween.tween(finalresult, {alpha: 1}, 0.5, {ease: FlxEase.expoOut, startDelay: 1});
				stroke.animation.play('idle');
				stroke.alpha = 1;
				FlxTween.tween(charaSprite, {x: -58}, 0.7, {ease: FlxEase.expoOut, startDelay: 0.5});
				
				new FlxTimer().start(1, function(tmr:FlxTimer) {
					FlxTween.color(stroke, 0.3, stroke.color, 0xFFFFFFFF, { onComplete: function(twn:FlxTween)
						{
							FlxTween.tween(stroke, {alpha: 0}, 0.5, {ease: FlxEase.expoOut, startDelay: 0.2});
							strokefinal.alpha = 1;
						}
					});
				});
				FlxTween.tween(dialoguebox, {alpha: 1}, 0.5, {ease: FlxEase.expoOut, startDelay: 2, onComplete: function(twn:FlxTween)
				{
					dialogueText.alpha = 1;
					dialogueText.start(0.04, true);
				}});
				FlxTween.tween(resultbox, {alpha: 1}, 0.5, {ease: FlxEase.expoOut, startDelay: 2});
				FlxTween.tween(comboText, {alpha: 1}, 0.5, {ease: FlxEase.expoOut, startDelay: 2.5});
				
				new FlxTimer().start(4.8, function(tmr:FlxTimer) {
					FlxTween.tween(rank, {"scale.x": 1.2, "scale.y": 1.2}, 0.1, {ease: FlxEase.cubeIn, onComplete: function(twn:FlxTween)
					{
						FlxTween.tween(rank, {"scale.x": 1, "scale.y": 1}, 0.3, {ease: FlxEase.bounceOut});
	
						new FlxTimer().start(1, function(tmr:FlxTimer) {
							if(Paths.fileExists('sounds/ratings/${rankingLetter}.ogg', SOUND))
								FlxG.sound.play(Paths.sound('ratings/${rankingLetter}'), 1);
						});
					}});	
					canpressbuttons = true;
				});
			});
		}
		
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		super.create();
	}

	var frames = 0;

	override function update(elapsed:Float)
	{
		// keybinds

		if (canpressbuttons && (PlayerSettings.player1.controls.ACCEPT || FlxG.mouse.justPressed && ClientPrefs.menuMouse))
		{
			
			if (PlayState.isStoryMode) {
				PlayState.returnToState('story');
			}
			else {
				PlayState.returnToState('freeplay');
			}
		}

		if (canpressbuttons && FlxG.keys.justPressed.F1 && !PlayState.loadRep)
		{
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = PlayState.storyDifficulty;
			MusicBeatState.resetState();
		}

		super.update(elapsed);
	}
}
