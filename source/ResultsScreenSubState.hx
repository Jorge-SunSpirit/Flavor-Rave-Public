package;

import Language.LanguageText;
import Language.LanguageTypeText;
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
	public static var chara1:String = 'sour';
	public static var chara2:String = 'sour';
	public var background:FlxSprite;
	public var stroke:FlxSprite;
	public var strokefinal:FlxSprite;
	public var charaSprite:FlxSprite;
	public var dialoguebox:FlxSprite;
	public var resultbox:FlxSprite;
	
	public var dialogueText:LanguageTypeText;
	public var comboText:LanguageText;
	
	public var finalresult:FlxSprite;
	public var rank:FlxSprite;

	public var pauseMusic:FlxSound;

	var rankingLetter:String;
	public static var resultType:String = 'default';

	override function create()
	{
		var delayTimer:Float = fullCombo ? 3.5 : 0.1;
		var thingie:String = resultType == 'fakeout' ? chara2 : chara1;
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
				FlxG.sound.play(CoolUtil.getAnnouncerLine('rating-FC'), 1);
			});
		}

		background = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		background.scrollFactor.set();
		background.alpha = 0.0001;
		add(background);

		strokefinal = new FlxSprite().loadGraphic(Paths.image('results/character/${thingie}/static_stroke'));
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
		switch (resultType)
		{
			case 'mute':
				trace('We aint startin no music??????');
			case 'fakeout':
				pauseMusic.loadEmbedded(Paths.music('results_jingle_fakeout'), false, true);
			default:
				if (rankingLetter == 'S')
					pauseMusic.loadEmbedded(Paths.music('results_jingle_s'), false, true);
				else
					pauseMusic.loadEmbedded(Paths.music('results_jingle'), false, true);
		}
		FlxG.sound.list.add(pauseMusic);
 
		var characterPath:String = 'images/results/character/${thingie}/dialogue.json';
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
		var imMadName:String = 'man';
		var imMadBox:String = 'box';

		for (dialogue in dioArray) 
		{
			switch (resultType)
			{
				case 'fakeout':
					if (dialogue.rank == "A")
					{
						imMadName = dialogue.name;
						imMadBox = dialogue.boxSprite;
					}
				default:
					if (dialogue.rank == rankingLetter)
					{
						imMadName = dialogue.name;
						imMadBox = dialogue.boxSprite;
					}
			}
		}

		charaSprite = new FlxSprite(FlxG.width, -34).loadGraphic(Paths.image('results/character/${chara1}/render'));
		charaSprite.antialiasing = ClientPrefs.globalAntialiasing;
		charaSprite.scale.set(1.5, 1.5);
		charaSprite.updateHitbox();
		add(charaSprite);

		var charaSprite2:FlxSprite = new FlxSprite(FlxG.width, -34).loadGraphic(Paths.image('results/character/${chara2}/render'));
		charaSprite2.antialiasing = ClientPrefs.globalAntialiasing;
		charaSprite2.scale.set(1.5, 1.5);
		charaSprite2.updateHitbox();
		add(charaSprite2);

		dialoguebox = new FlxSprite(0, 456).loadGraphic(Paths.image('results/character/${thingie}/${imMadBox}'));
		dialoguebox.antialiasing = ClientPrefs.globalAntialiasing;
		dialoguebox.alpha = 0.001;
		add(dialoguebox);

		dialogueText = new LanguageTypeText(62.8, 570, 713, Language.flavor.get("results_" + thingie + "_" + rankingLetter, imMadName), 24, 'krungthep');
		dialogueText.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.25);
		dialogueText.alpha = 0.001;
		add(dialogueText);

		resultbox = new FlxSprite(865, 474).loadGraphic(Paths.image('results/scorebox'));
		resultbox.antialiasing = ClientPrefs.globalAntialiasing;
		resultbox.alpha = 0.001;
		resultbox.scale.set(0.6, 0.6);
		resultbox.updateHitbox();
		add(resultbox);
		
		var score:String = Language.gameplay.get("score_score", "Score") + ": "
			+ (PlayState.isStoryMode ? PlayState.campaignScore : PlayState.instance.songScore) + '\n';

		var biggercombo:Int = PlayState.instance.highestCombo + 1;
		var biggestCombro:String = (PlayState.isStoryMode ? "" : Language.gameplay.get("results_highest_combo", "Highest Combo") + ": "+ biggercombo + '\n');

		var misses:String = Language.gameplay.get("score_misses", "Misses") + ": "
			+ (PlayState.isStoryMode ? PlayState.campaignMisses : PlayState.instance.songMisses) + '\n';

		comboText = new LanguageText(878, PlayState.isStoryMode ? 565 : 550, 400, '${score}${biggestCombro}${misses}', 30, 'carat');
		comboText.setStyle(FlxColor.WHITE, LEFT);
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
		rank.scale.set(0.0001,0.0001);
		add(rank);

		if (!ClientPrefs.lowQuality)
		{
			//gotta hide the normally invisible stuff
			var hideborderthignieawmdsa1 = new FlxSprite(-640, -180).makeGraphic(640, 1440, FlxColor.BLACK);
			hideborderthignieawmdsa1.scrollFactor.set();
			hideborderthignieawmdsa1.antialiasing = false;
			insert(999996, hideborderthignieawmdsa1);
			var hideborderthignieawmdsa2 = new FlxSprite(1280, -180).makeGraphic(640, 1440, FlxColor.BLACK);
			hideborderthignieawmdsa2.scrollFactor.set();
			hideborderthignieawmdsa2.antialiasing = false;
			insert(999997, hideborderthignieawmdsa2);

			var hideborderthignieawmdsa3 = new FlxSprite(-640, -360).makeGraphic(2560, 360, FlxColor.BLACK);
			hideborderthignieawmdsa3.scrollFactor.set();
			hideborderthignieawmdsa3.antialiasing = false;
			insert(999998, hideborderthignieawmdsa3);
			var hideborderthignieawmdsa = new FlxSprite(-640, 720).makeGraphic(2560, 360, FlxColor.BLACK);
			hideborderthignieawmdsa.scrollFactor.set();
			hideborderthignieawmdsa.antialiasing = false;
			insert(999999, hideborderthignieawmdsa);
		}

		var homestatic:FlxSprite = new FlxSprite();
		homestatic.frames = Paths.getSparrowAtlas('sweetroom/static', 'tbd');
		homestatic.animation.addByPrefix('idle', 'static', 24, true);
		homestatic.antialiasing = ClientPrefs.globalAntialiasing;
		homestatic.animation.play('idle');
		homestatic.alpha = 0.001;
		add(homestatic);

		//Prob can get rid of this code but idk yet
		var mean:Float = 0;

		mean = CoolUtil.floorDecimal(mean / PlayState.rep.replay.songNotes.length, 2);
		
		var usedPractice:Bool = (ClientPrefs.getGameplaySetting('practice', false) || ClientPrefs.getGameplaySetting('botplay', false));
		var isLeaderboardCompatible:String = "Rejected";
		if (!usedPractice && !PlayState.chartingMode) {
			isLeaderboardCompatible = "Accepted";
		}

		switch(resultType)
		{
			case 'mute':
				new FlxTimer().start(delayTimer, function(tmr:FlxTimer)
				{
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
								if(Paths.fileExists("sounds/announcer/" + ClientPrefs.announcer +'/ratings/' + rankingLetter + '.ogg', SOUND))
								{
									FlxG.sound.play(CoolUtil.getAnnouncerLine('ratings/' + rankingLetter), 1);
								}
							});
						}});	
						canpressbuttons = true;
					});
				});
			case 'fakeout':
				new FlxTimer().start(delayTimer, function(tmr:FlxTimer)
					{
						pauseMusic.play(true);
						FlxTween.tween(background, {alpha: 0.5}, 0.5);
						FlxTween.tween(finalresult, {alpha: 1}, 0.5, {ease: FlxEase.expoOut, startDelay: 1});
						stroke.animation.play('idle');
						stroke.alpha = 1;
						FlxTween.tween(charaSprite, {x: -58}, 0.7, {ease: FlxEase.expoOut, startDelay: 0.5});
						
						FlxTween.color(stroke, 0.3, stroke.color, 0xFFFFFFFF, {startDelay: 1, onComplete: function(twn:FlxTween){}});

						new FlxTimer().start(1.5, function(tmr:FlxTimer) { //Potentially add a glitch effect
							FlxTween.tween(homestatic, {alpha: 0.5}, 0.2, {ease: FlxEase.expoOut});
							FlxTween.tween(homestatic, {alpha: 0}, 1, {ease: FlxEase.expoOut, startDelay: 0.828});

							strokefinal.alpha = 1;
							FlxTween.tween(charaSprite, {x: -1280, angle: 15}, 0.5, {ease: FlxEase.expoInOut});
							FlxTween.tween(charaSprite2, {x: -58}, 0.3, {ease: FlxEase.expoInOut, startDelay: 0.2});

							FlxTween.tween(stroke, {alpha: 0}, 0.5, {ease: FlxEase.expoOut, startDelay: 0.7});
						});

						FlxTween.tween(dialoguebox, {alpha: 1}, 0.5, {ease: FlxEase.expoOut, startDelay: 2.75, onComplete: function(twn:FlxTween)
						{
							dialogueText.alpha = 1;
							dialogueText.start(0.04, true);
						}});
						FlxTween.tween(resultbox, {alpha: 1}, 0.5, {ease: FlxEase.expoOut, startDelay: 3});
						FlxTween.tween(comboText, {alpha: 1}, 0.5, {ease: FlxEase.expoOut, startDelay: 3.5});
						
						new FlxTimer().start(4.8, function(tmr:FlxTimer) {
							FlxTween.tween(rank, {"scale.x": 1.2, "scale.y": 1.2}, 0.1, {ease: FlxEase.cubeIn, onComplete: function(twn:FlxTween)
							{
								FlxTween.tween(rank, {"scale.x": 1, "scale.y": 1}, 0.3, {ease: FlxEase.bounceOut});
			
								new FlxTimer().start(1, function(tmr:FlxTimer) {
								FlxG.sound.play(CoolUtil.getAnnouncerLine('ratings/Fakeout'), 1);
								});
							}});	
							canpressbuttons = true;
						});
					});
			default:
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
										if(Paths.fileExists("sounds/announcer/" + ClientPrefs.announcer +'/ratings/' + rankingLetter + '.ogg', SOUND))
										{
											FlxG.sound.play(CoolUtil.getAnnouncerLine('ratings/' + rankingLetter), 1);
										}
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
										if(Paths.fileExists("sounds/announcer/" + ClientPrefs.announcer +'/ratings/' + rankingLetter + '.ogg', SOUND))
										{
											FlxG.sound.play(CoolUtil.getAnnouncerLine('ratings/' + rankingLetter), 1);
										}
									});
								}});	
								canpressbuttons = true;
							});
						});
					}
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

		if (canpressbuttons && !PlayState.isStoryMode && FlxG.keys.justPressed.F1 && !PlayState.loadRep)
		{
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = PlayState.storyDifficulty;
			MusicBeatState.resetState();
		}

		super.update(elapsed);
	}
}
