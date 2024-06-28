package;

import Controls.Control;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import options.OptionsState;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<PMenuItem>;

	var menuItems:Array<String> = [];
	var menuItemsOG:Array<String> = ['Resume', 'Restart Song', 'Change Difficulty', 'Options', 'Exit to Menu'];
	var difficultyChoices = [];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;
	var practiceText:FlxText;
	var skipTimeText:FlxText;
	var skipTimeTracker:Alphabet;
	var curTime:Float = Math.max(0, Conductor.songPosition);
	var canpressbuttons:Bool = false;
	//var botplayText:FlxText;

	public static var songName:String = '';

	public function new(x:Float, y:Float)
	{
		super();

		if(CoolUtil.difficulties.length < 2) menuItemsOG.remove('Change Difficulty'); //No need to change difficulty if there is only one!

		if(PlayState.chartingMode)
		{
			menuItemsOG.insert(2, 'Leave Charting Mode');
			
			var num:Int = 0;
			if(!PlayState.instance.startingSong)
			{
				num = 1;
				menuItemsOG.insert(3, 'Skip Time');
			}
			menuItemsOG.insert(3 + num, 'End Song');
			menuItemsOG.insert(4 + num, 'Toggle Practice Mode');
			menuItemsOG.insert(5 + num, 'Toggle Botplay');
		}
		menuItems = menuItemsOG;

		for (i in 0...CoolUtil.difficulties.length) {
			var diff:String = '' + CoolUtil.difficulties[i];
			difficultyChoices.push(diff);
		}
		difficultyChoices.push('BACK');


		pauseMusic = new FlxSound();
		if (songName != null) pauseMusic.loadEmbedded(Paths.music(songName), true, true);
		else pauseMusic.loadEmbedded(Paths.music('110th-street'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		var bgthingie:FlxSprite = new FlxSprite(1280).loadGraphic(Paths.image('pause/bg'));
		bgthingie.antialiasing = ClientPrefs.globalAntialiasing;
		add(bgthingie);

		var disk:FlxSprite = new FlxSprite(1280, 36).loadGraphic(Paths.image('pause/disk'));
		disk.antialiasing = ClientPrefs.globalAntialiasing;
		disk.angularVelocity = 50;
		add(disk);

		var levelInfo:FlxText = new FlxText(20, 15, 0, PlayState.hasMetadata ? PlayState.metadata.song.name : PlayState.SONG.song, 32);
		levelInfo.antialiasing = ClientPrefs.globalAntialiasing;
		levelInfo.setFormat(Paths.font("Krungthep.ttf"), 32);
		levelInfo.setBorderStyle(OUTLINE, 0xFF220B2B, 2, 1);
		levelInfo.updateHitbox();
		add(levelInfo);

		var levelDifficulty:FlxText = new FlxText(20, 15 + 32, 0, (PlayState.hasMetadata ? PlayState.metadata.song.artist + " :Composer" : CoolUtil.difficultyString()), 32);
		levelDifficulty.antialiasing = ClientPrefs.globalAntialiasing;
		levelDifficulty.setFormat(Paths.font('Krungthep.ttf'), 25);
		levelDifficulty.setBorderStyle(OUTLINE, 0xFF220B2B, 2, 1);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		var blueballedTxt:FlxText = new FlxText(20, 15 + 57, 0, (PlayState.hasMetadata && PlayState.metadata.song.charter != null ? PlayState.metadata.song.charter : "N/A") + " :Charter", 32);
		blueballedTxt.antialiasing = ClientPrefs.globalAntialiasing;
		blueballedTxt.setFormat(Paths.font('Krungthep.ttf'), 25);
		blueballedTxt.setBorderStyle(OUTLINE, 0xFF220B2B, 2, 1);
		blueballedTxt.updateHitbox();
		if (PlayState.hasMetadata && PlayState.metadata.song.charter != null)
			add(blueballedTxt);

		practiceText = new FlxText(20, 15 + 101, 0, "PRACTICE MODE", 32);
		practiceText.antialiasing = ClientPrefs.globalAntialiasing;
		practiceText.setFormat(Paths.font('Krungthep.ttf'), 32);
		practiceText.setBorderStyle(OUTLINE, 0xFF220B2B, 2, 1);
		practiceText.x = FlxG.width - (practiceText.width + 20);
		practiceText.updateHitbox();
		practiceText.visible = PlayState.instance.practiceMode;
		add(practiceText);

		grpMenuShit = new FlxTypedGroup<PMenuItem>();
		add(grpMenuShit);

		regenMenu();

		var topBoarder:FlxSprite = new FlxSprite(0,-75).loadGraphic(Paths.image('pause/top_boarder'));
		topBoarder.antialiasing = ClientPrefs.globalAntialiasing;
		add(topBoarder);

		var bottomBoarder:FlxSprite = new FlxSprite(95, 720).loadGraphic(Paths.image('pause/bottom_boarder'));
		bottomBoarder.antialiasing = ClientPrefs.globalAntialiasing;
		add(bottomBoarder);

		var paused:FlxSprite = new FlxSprite(10,10).loadGraphic(Paths.image('pause/pause'));
		paused.antialiasing = ClientPrefs.globalAntialiasing;
		add(paused);

		blueballedTxt.alpha = 0;
		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);
		blueballedTxt.x = FlxG.width - (blueballedTxt.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		FlxTween.tween(blueballedTxt, {alpha: 1, y: blueballedTxt.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});

		FlxTween.tween(bgthingie, {y: 0, x: 0}, 0.5, {ease: FlxEase.quartOut, startDelay: 0});
		FlxTween.tween(disk, {x: FlxG.width - disk.width - 10}, 0.5, {ease: FlxEase.quartOut, startDelay: 0});
		FlxTween.tween(topBoarder, {y: 0}, 0.4, {ease: FlxEase.quartOut, startDelay: 0.2});
		FlxTween.tween(bottomBoarder, {y: 647}, 0.4, {ease: FlxEase.quartOut, startDelay: 0.2});


		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			canpressbuttons = true;
		});
	}

	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
		var escape = controls.BACK;

		if (upP && canpressbuttons) changeSelection(-1);
		if (downP && canpressbuttons) changeSelection(1);
		if (escape && canpressbuttons) close();

		if (ClientPrefs.menuMouse && canpressbuttons)
		{
			if (FlxG.mouse.wheel != 0)
			{
				// Mouse wheel logic goes here, for example zooming in / out:
				if (FlxG.mouse.wheel < 0)
					changeSelection(1);
				else if (FlxG.mouse.wheel > 0)
					changeSelection(-1);	
			}
	
			grpMenuShit.forEach(function(spr:PMenuItem)
			{
				if (FlxG.mouse.overlaps(spr))
				{
					if (FlxG.mouse.justPressed)
					{
						//This menu technically works but like, DUDE it doesn't function correctly???
						if (spr.ID != 0)
							changeSelection(spr.ID);
						else
							selectItem();
					}
				}
			});
		}

		var daSelected:String = menuItems[curSelected];
		switch (daSelected)
		{
			case 'Skip Time':
				if (controls.UI_LEFT_P && canpressbuttons)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					curTime -= 1000;
					holdTime = 0;
				}
				if (controls.UI_RIGHT_P && canpressbuttons)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					curTime += 1000;
					holdTime = 0;
				}

				if((controls.UI_LEFT || controls.UI_RIGHT) && canpressbuttons)
				{
					holdTime += elapsed;
					if(holdTime > 0.5)
					{
						curTime += 45000 * elapsed * (controls.UI_LEFT ? -1 : 1);
					}

					if(curTime >= FlxG.sound.music.length) curTime -= FlxG.sound.music.length;
					else if(curTime < 0) curTime += FlxG.sound.music.length;

					for (item in grpMenuShit.members)
					{
						if (item.hasSkipTime)
							item.updateSkipTimeText(curTime);
					}
				}
		}

		if (accepted && canpressbuttons)
		{
			selectItem();
		}
	}

	function selectItem()
	{
		var daSelected:String = menuItems[curSelected];
		if (menuItems == difficultyChoices)
		{
			if(menuItems.length - 1 != curSelected && difficultyChoices.contains(daSelected)) {
				var name:String = PlayState.SONG.song;
				var poop = Highscore.formatSong(name, curSelected);
				PlayState.SONG = Song.loadFromJson(poop, name);
				PlayState.storyDifficulty = curSelected;
				MusicBeatState.resetState();
				FlxG.sound.music.volume = 0;
				PlayState.changedDifficulty = true;
				PlayState.chartingMode = false;
				return;
			}

			menuItems = menuItemsOG;
			regenMenu();
		}

		switch (daSelected)
		{
			case "Resume":
				close();
			case 'Change Difficulty':
				menuItems = difficultyChoices;
				canpressbuttons = false;
				regenMenu();
			case 'Toggle Practice Mode':
				PlayState.instance.practiceMode = !PlayState.instance.practiceMode;
				PlayState.changedDifficulty = true;
				practiceText.visible = PlayState.instance.practiceMode;
			case "Restart Song":
				restartSong();
			case "Leave Charting Mode":
				restartSong();
				PlayState.chartingMode = false;
			case 'Skip Time':
				if(curTime < Conductor.songPosition)
				{
					PlayState.startOnTime = curTime;
					restartSong(true);
				}
				else
				{
					if (curTime != Conductor.songPosition)
					{
						PlayState.instance.clearNotesBefore(curTime);
						PlayState.instance.setSongTime(curTime);
					}
					close();
				}
			case "End Song":
				close();
				PlayState.instance.finishSong(true);
			case 'Toggle Botplay':
				PlayState.instance.cpuControlled = !PlayState.instance.cpuControlled;
				PlayState.changedDifficulty = true;
				PlayState.instance.botplayTxt.visible = PlayState.instance.cpuControlled;
				PlayState.instance.botplayTxt.alpha = 1;
				PlayState.instance.botplaySine = 0;
			case 'Options':
				PlayState.instance.paused = true; // For lua
				PlayState.instance.vocals.volume = 0;
				MusicBeatState.switchState(new OptionsState());

				FlxG.sound.playMusic(Paths.music('110th-street'), pauseMusic.volume);
				FlxTween.tween(FlxG.sound.music, {volume: 1}, 0.8);
				FlxG.sound.music.time = pauseMusic.time;

				FlxTween.tween(FlxG.sound.music, {volume: 1}, 0.8);

				OptionsState.whichState = 'playstate';
			case "Exit to Menu":
				PlayState.seenCutscene = false;
				FlxG.mouse.visible = ClientPrefs.menuMouse;
				WeekData.loadTheFirstEnabledMod();
				FRFadeTransition.type = 'songTrans';
				if(PlayState.isStoryMode) {
					MusicBeatState.switchState(new StoryMenuState());
				} else {
					MusicBeatState.switchState(new FreeplayState());
				}
				PlayState.cancelMusicFadeTween();
				FlxG.sound.playMusic(Paths.music(ClientPrefs.mainmenuMusic));
				PlayState.changedDifficulty = false;
				PlayState.chartingMode = false;
		}
	}

	public static function restartSong(noTrans:Bool = false)
	{
		PlayState.instance.paused = true; // For lua
		FlxG.sound.music.volume = 0;
		PlayState.instance.vocals.volume = 0;

		if(noTrans)
		{
			FlxTransitionableState.skipNextTransOut = true;
			FlxG.resetState();
		}
		else
		{
			MusicBeatState.resetState();
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		FlxG.sound.play(Paths.sound('scrollMenu'));

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.ID = bullShit - curSelected;
			bullShit++;

			FlxTween.cancelTweensOf(item);
			FlxTween.tween(item, {x: 77 + (item.ID * 61), y: 157 + (item.ID * 127)}, 0.2, {ease: FlxEase.sineOut});

			item.highlighted(false);
			if (item.ID == 0)
				item.highlighted(true);
		}
	}

	function regenMenu():Void {
		for (i in 0...grpMenuShit.members.length) {
			var obj = grpMenuShit.members[0];
			obj.kill();
			grpMenuShit.remove(obj, true);
			obj.destroy();
		}

		for (i in 0...menuItems.length) {
			var item = new PMenuItem(-13 + (i * -61), -123 + (i * -127), menuItems[i]);
			item.ID = i;
			grpMenuShit.add(item);

			FlxTween.tween(item, {x: 77 + (i * 61), y: 157 + (i * 127)}, 0.5, {ease: FlxEase.quartOut, startDelay: 0.5 + (i * 0.05)});
			new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					canpressbuttons = true;
					curSelected = 0;
					changeSelection();
				});
		}
	}
}



class PMenuItem extends FlxSpriteGroup
{
	var song:String;

	var bg:FlxSprite;
	var tinybg:FlxSprite;
	var text:FlxText;
	var skipTimeText:FlxText;
	public var hasSkipTime:Bool = false;
	var curTime:Float = Math.max(0, Conductor.songPosition);

	public function new(x:Float = 0, y:Float = 0, item:String)
	{
		super(x, y);

		if (item == 'Skip Time')
		{
			tinybg = new FlxSprite(290,14);
			tinybg.frames = Paths.getSparrowAtlas('pause/buttons');
			tinybg.animation.addByPrefix('idle', 'button_deselected', 24, false);
			tinybg.animation.play('idle');
			tinybg.scale.set(0.85, 0.85);
			tinybg.updateHitbox();
			tinybg.antialiasing = ClientPrefs.globalAntialiasing;
			add(tinybg);

			skipTimeText = new FlxText(550, 20, 108, item, 30);
			skipTimeText.setFormat(Paths.font("Krungthep.ttf"), 30, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			skipTimeText.antialiasing = ClientPrefs.globalAntialiasing;
			skipTimeText.borderSize = 2;
			add(skipTimeText);
			updateSkipTimeText(curTime);
			hasSkipTime = true;

			skipTimeText.visible = false;
			tinybg.visible = false;
		}

		bg = new FlxSprite();
		bg.frames = Paths.getSparrowAtlas('pause/buttons');//curSong
		bg.animation.addByPrefix('highlighted', 'button_selected', 24, false);
		bg.animation.addByPrefix('idle', 'button_deselected', 24, false);
		bg.animation.play('idle');
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		text = new FlxText(38, 20, 406, item, 50);
		text.setFormat(Paths.font("Krungthep.ttf"), 50, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		text.antialiasing = ClientPrefs.globalAntialiasing;
		text.borderSize = 4;
		if (text.height > 80)
		{
			text.size = 35;
			text.y += 10;
		}
		add(text);
	}

	public function highlighted(bool:Bool)
	{
		FlxTween.cancelTweensOf(bg);
		FlxTween.cancelTweensOf(text);
		if (bool)
		{
			FlxTween.tween(bg, {"scale.x": 1.2, "scale.y": 1.2}, 0.2, {ease: FlxEase.sineOut});
			FlxTween.tween(text, {"scale.x": 1.2, "scale.y": 1.2}, 0.2, {ease: FlxEase.sineOut});
			bg.animation.play('highlighted');
		}
		else
		{
			FlxTween.tween(bg, {"scale.x": 1, "scale.y": 1}, 0.2, {ease: FlxEase.sineOut});
			FlxTween.tween(text, {"scale.x": 1, "scale.y": 1}, 0.2, {ease: FlxEase.sineOut});
			bg.animation.play('idle');
		}

		if (hasSkipTime)
		{
			skipTimeText.visible = bool;
			tinybg.visible = bool;
		}
	}
	
	public function updateSkipTimeText(curTimie:Float = 0)
	{
		skipTimeText.text = FlxStringUtil.formatTime(Math.max(0, Math.floor(curTimie / PlayState.instance.playbackRate / 1000)), false) + ' / ' + FlxStringUtil.formatTime(Math.max(0, Math.floor(FlxG.sound.music.length / PlayState.instance.playbackRate / 1000)), false);
	}
}