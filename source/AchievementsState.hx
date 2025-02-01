package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.addons.text.FlxTypeText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.sound.FlxSound;
import achievements.Achievements;
import Math;

class AchievementsState extends MusicBeatState
{
	var showmanSound:FlxSound;
	var sidebar:FlxSprite;
	var topBoarder:FlxSprite;
	var bottomBoarder:FlxSprite;
	var accolades:FlxSprite;
	var grpAch:FlxTypedGroup<AchievementItem>;
	
	var showman:FlxSprite;
	var box:FlxSprite;
	var dialogueText:FlxTypeText;

	public static var firstJoin:Bool = true;
	var selectedSomethin:Bool = true;

	var curSelected:Int = 0;

	override function create()
	{
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('achievements/menu/menuBG'));
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		sidebar = new FlxSprite(-369).loadGraphic(Paths.image('mainmenu/sidebar_full'));
		sidebar.antialiasing = ClientPrefs.globalAntialiasing;
		add(sidebar);

		showman = new FlxSprite(-530,-4);
		showman.frames = Paths.getSparrowAtlas('achievements/menu/ShowmanMenu');//curSong
		showman.animation.addByIndices("idle", "ShowmanIntro", [100], "", 24, false);
		showman.animation.addByIndices("greeting", "ShowmanIntro", CoolUtil.numberArray(100, 1), "", 24, false);
		showman.animation.play('idle');
		showman.antialiasing = ClientPrefs.globalAntialiasing;
		add(showman);

		grpAch = new FlxTypedGroup<AchievementItem>();
		add(grpAch);

		for (i in 0...Achievements.achievementArray.length)
		{
			var theA:Achievement = Achievements.achivementVarMap.get(Achievements.achievementArray[i]);
			if (!theA.hidden || theA.hidden && ClientPrefs.achievementMap.get(theA.name))
			{
				var menuItem:AchievementItem;
				menuItem = new AchievementItem(1280, 106 + (i * 150), theA.name, !ClientPrefs.achievementMap.get(theA.name), theA.icon);
				menuItem.ID = i;
				grpAch.add(menuItem);
				FlxTween.tween(menuItem, {x: 654}, 0.4, {ease: FlxEase.sineOut});
			}
		}

		topBoarder = new FlxSprite(0,-75).loadGraphic(Paths.image('pause/top_boarder', 'shared'));
		topBoarder.antialiasing = ClientPrefs.globalAntialiasing;
		add(topBoarder);

		bottomBoarder = new FlxSprite(95, 720).loadGraphic(Paths.image('pause/bottom_boarder', 'shared'));
		bottomBoarder.antialiasing = ClientPrefs.globalAntialiasing;
		add(bottomBoarder);

		box = new FlxSprite(0, 720).loadGraphic(Paths.image('achievements/menu/showmanbox'));
		box.antialiasing = ClientPrefs.globalAntialiasing;
		add(box);

		dialogueText = new FlxTypeText(36, 566, 540, "", 20);
		dialogueText.font = Paths.font("Krungthep.ttf");
		dialogueText.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.25);
		dialogueText.antialiasing = ClientPrefs.globalAntialiasing;
		add(dialogueText);

		accolades = new FlxSprite(0,-120).loadGraphic(Paths.image('achievements/menu/Menu Name'));
		accolades.antialiasing = ClientPrefs.globalAntialiasing;
		add(accolades);

		if (firstJoin)
		{
			new FlxTimer().start(0.5, function(tmr:FlxTimer)
			{
				FlxG.sound.music.fadeOut(0.2, 0.12);
				showman.animation.play('greeting');
				firstJoin = false;
				showmanSound = new FlxSound().loadEmbedded(Paths.sound('achievement/challenge'));
				showmanSound.onComplete = function() {FlxG.sound.music.fadeIn(4, 0.12, 0.8);}
				new FlxTimer().start(0.5, function(tmr:FlxTimer){showmanSound.play();});
			});
		}

		FlxTween.tween(accolades, {y: 0}, 0.4, {ease: FlxEase.quartOut, startDelay: 0.3});
		FlxTween.tween(topBoarder, {y: 0}, 0.4, {ease: FlxEase.quartOut, startDelay: 0.1});
		FlxTween.tween(bottomBoarder, {y: 647}, 0.4, {ease: FlxEase.quartOut, startDelay: 0.1});
		FlxTween.tween(sidebar, {x: 911}, 0.5, {ease: FlxEase.sineOut});
		FlxTween.tween(showman, {x: 0}, 0.5, {ease: FlxEase.sineOut});
		FlxTween.tween(box, {y: 0}, 0.5, {ease: FlxEase.sineOut, startDelay: 0.3});

		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			selectedSomethin = false;
			changeItem();
		});

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!selectedSomethin)
		{
			if (controls.UI_RIGHT_P || controls.BACK)
				leaveState();

			if (controls.UI_UP_P)
			{
				changeItem(-1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			if (controls.UI_DOWN_P)
			{
				changeItem(1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}

			#if !PUBLIC_BUILD
			if (controls.RESET)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				//resets State
				ClientPrefs.achievementMap = new Map<String, Dynamic>();
				ClientPrefs.saveSettings();
				Achievements.init();
				MusicBeatState.resetState();
			}

			if (FlxG.keys.justPressed.P)
			{
				grpAch.members[curSelected].unlock();
				Achievements.unlockAchievement(grpAch.members[curSelected].fakeName, true);
			}		
			#end

			if(ClientPrefs.menuMouse)
			{
				if(FlxG.mouse.wheel != 0)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.5);
					// Mouse wheel logic goes here, for example zooming in / out:
					if (FlxG.mouse.wheel < 0)
						changeItem(1);
					else if (FlxG.mouse.wheel > 0)
						changeItem(-1);
				}

				grpAch.forEach(function(spr:AchievementItem)
				{
					if(FlxG.mouse.overlaps(spr))
					{
						if(FlxG.mouse.justPressed)
						{
							if (spr.ID != 0)
								changeItem(spr.ID);
						}
					}
				});
			}
		}
	}

	function changeItem(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected >= grpAch.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = grpAch.length - 1;

		var bullShit:Int = 0;

		for (item in grpAch.members)
		{
			item.ID = bullShit - curSelected;
			bullShit++;
			item.isSelected(item.ID == 0 ? true : false);
			FlxTween.cancelTweensOf(item);
			FlxTween.tween(item, {y: 106 + (item.ID * 150)}, 0.5, {ease: FlxEase.circOut});
		
			if (item.ID == 0)
				updateText(item.dialogueText);
		}
	}

	function updateText(text:String)
	{
		dialogueText.resetText(text);
		dialogueText.start(getDynamicTime(text), true);
		//Maybe random voice audio
	}

	function getDynamicTime(text:String):Float
	{
		trace("comparing between 0.04 and " + (2/text.length));
		return Math.min(0.04, 2 / text.length);
	}

	function leaveState()
	{
		selectedSomethin = true;
		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		MainMenuState.fromSpecificState = 2;
		FlxTween.tween(sidebar, {x: -369}, 0.5, {ease: FlxEase.sineIn});
		FlxTween.tween(topBoarder, {y: -75}, 0.3, {ease: FlxEase.quartOut, startDelay: 0.2});
		FlxTween.tween(bottomBoarder, {y: 720}, 0.3, {ease: FlxEase.quartOut, startDelay: 0.2});
		FlxTween.tween(accolades, {y: -120}, 0.3, {ease: FlxEase.quartOut, startDelay: 0.2});
		FlxTween.tween(showman, {x: -1280}, 0.5, {ease: FlxEase.sineIn});
		FlxTween.tween(box, {y: 720}, 0.5, {ease: FlxEase.sineOut});
		grpAch.forEach(function(obj:AchievementItem)
		{
			FlxTween.cancelTweensOf(obj);
			FlxTween.tween(obj, {x: 1280}, 0.3, {ease: FlxEase.sineOut});
		});
		dialogueText.resetText('');
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			MusicBeatState.switchState(new MainMenuState());
		});
	}
}

class AchievementItem extends FlxSpriteGroup
{
	var selection:FlxSprite;
	public var fakeName:String;
	var box:FlxSprite;
	var nameText:FlxText;
	var theA:Achievement;

	public var dialogueText:String = "This seems to be locked. Come back when you've met the proper requisites!";

	public function new(x:Float = 0, y:Float = 0, ach:String, locked:Bool, aicon:String)
	{
		super(x, y);
		fakeName = ach;
		theA = Achievements.achivementVarMap.get(ach);
		var icon:String = 'locked';
		var boxThignie:String = locked ? 'Box_Locked' : 'Box_Unlocked';
		var fancyname:String = locked ? "Unknown" : theA.fancyName;
		
		if (!locked)
		{
			dialogueText = theA.showmanDialogue;
			if (Paths.fileExists('images/achievements/icons/$icon.png', IMAGE))
				icon = aicon;
		}

		box = new FlxSprite(0, 0).loadGraphic(Paths.image('achievements/menu/$boxThignie'));
		box.antialiasing = ClientPrefs.globalAntialiasing;
		add(box);

		selection = new FlxSprite(0, 0).loadGraphic(Paths.image('achievements/menu/Box_Highlighted'));
		selection.antialiasing = ClientPrefs.globalAntialiasing;
		selection.visible = false;
		add(selection);
		//wah

		var icon:FlxSprite = new FlxSprite(20, 20).loadGraphic(Paths.image('achievements/icons/$icon'));
		icon.antialiasing = ClientPrefs.globalAntialiasing;
		add(icon);

		nameText = new FlxText(126, 25, 469, fancyname);
		nameText.setFormat(Paths.font("Krungthep.ttf"), 35, FlxColor.WHITE, FlxTextAlign.LEFT);
		nameText.setBorderStyle(OUTLINE, 0xFF000000, 3.5, 1);
		nameText.antialiasing = ClientPrefs.globalAntialiasing;
		nameText.updateHitbox();
		add(nameText);

		var chapterText:FlxText = new FlxText(126, 70, 435, theA.unlockCondition);
		chapterText.setFormat(Paths.font("Krungthep.ttf"), 20, FlxColor.WHITE, FlxTextAlign.LEFT);
		chapterText.setBorderStyle(OUTLINE, 0xFF220B2B, 2, 1);
		chapterText.antialiasing = ClientPrefs.globalAntialiasing;
		chapterText.updateHitbox();
		add(chapterText);
	}

	public function isSelected(what:Bool = false)
		selection.visible = what;

	public function unlock()
	{
		box.loadGraphic(Paths.image('achievements/menu/Box_Unlocked'));
		nameText.text = theA.fancyName;
	}
}
