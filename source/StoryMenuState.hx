package;

import Language.LanguageText;
#if discord_rpc
import Discord.DiscordClient;
#end
import WeekData;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import options.OptionsState;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var bgSprite:FlxSprite;
	
	public var curDifficulty:Int = 0;
	var curWeek:Int = 0;
	
	var txtTracklist:LanguageText;
	var theLocation:LanguageText;

	var grpWeekText:FlxTypedGroup<StoryItem>;
	var grpWeekCharacters:FlxTypedGroup<FlxSprite>;

	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
	var storyMenuCat:Array<String> = ['story', 'collab', 'extra'];
	public static var curPage:Int = 0;

	var loadedWeeks:Array<WeekData> = [];

	public static var instance:StoryMenuState;

	override function create()
	{
		instance = this;

		FlxG.mouse.visible = ClientPrefs.menuMouse;

		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		PlayState.isStoryMode = true;
		WeekData.reloadWeekFiles(true);
		if(curWeek >= WeekData.weeksList.length) curWeek = 0;
		persistentUpdate = persistentDraw = true;

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music(ClientPrefs.mainmenuMusic));
		}

		bgSprite = new FlxSprite(640, 0);
		bgSprite.antialiasing = ClientPrefs.globalAntialiasing;
		add(bgSprite);

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('story_menuy/StoryMenuBG'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		grpWeekText = new FlxTypedGroup<StoryItem>();
		add(grpWeekText);

		leftArrow = new FlxSprite(1, 10).makeGraphic(85, 85, FlxColor.BLACK);
		leftArrow.alpha = 0;
		leftArrow.scrollFactor.set();
		add(leftArrow);

		rightArrow = new FlxSprite(555, 10).makeGraphic(85, 85, FlxColor.BLACK);
		rightArrow.alpha = 0;
		rightArrow.scrollFactor.set();
		add(rightArrow);

		var headerSprite:String = 'story_menuy/StoryMenuHeader';
		
		switch (storyMenuCat[curPage])
		{
			case 'extra' | 'bonus':
				headerSprite = 'story_menuy/StoryMenuHeaderBonus';
			case 'collab':
				headerSprite = 'story_menuy/StoryMenuHeaderCollab';
			default:
				headerSprite = 'story_menuy/StoryMenuHeader';
		}

		var bgHeader:FlxSprite = new FlxSprite().loadGraphic(Paths.image(headerSprite));
		bgHeader.antialiasing = ClientPrefs.globalAntialiasing;
		add(bgHeader);

		grpWeekCharacters = new FlxTypedGroup<FlxSprite>();

		#if discord_rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		var num:Int = 0;
		for (i in 0...WeekData.weeksList.length)
		{
			var weekFile:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			WeekData.setDirectoryFromWeek(weekFile);
			var weekNumber:Int = i;
			var isLocked:Bool = WeekData.weekIsLocked(WeekData.weeksList[i]);

			switch (weekFile.categoryType)
			{
				case 'story' | 'collab':
					//trace('This is so we dont accidentally overright it hueh');
				case null:
					weekFile.categoryType = 'extra';
				default:
					weekFile.categoryType = 'extra';
			}

			if (weekFile.categoryType != storyMenuCat[curPage])
				continue;

			if((!isLocked || !weekFile.hiddenUntilUnlocked))
			{
				if (weekFile.fileName != 'xextra_0')
				{
					loadedWeeks.push(weekFile);
					var menuItem:StoryItem;
	
					if (isLocked)
						menuItem = new StoryItem(8, 106 + (i * 150), "Locked", "???", "???", weekNumber);
					else
						menuItem = new StoryItem(8, 106 + (i * 150), weekFile.weekType, Language.flavor.get("story_" + weekFile.fileName + "_storyName", weekFile.storyName), Language.flavor.get("story_" + weekFile.fileName + "_weekName", weekFile.weekName), weekNumber);
					menuItem.ID = i;
					grpWeekText.add(menuItem);
					num++;
				}	
			}
		}

		if (loadedWeeks.length < 1)
		{
			selectedWeek = true;
			return; //This looks ugly but will never see it in game as long as DLC is installed
		}

		WeekData.setDirectoryFromWeek(loadedWeeks[0]);
		var charArray:Array<String> = loadedWeeks[0].weekCharacters;

		for (char in 0...4)
		{	
			var charSprite:FlxSprite = new FlxSprite(640, 266 + (char * 60)).loadGraphic(Paths.image('story_menuy/chartags/' + charArray[char]));
			charSprite.antialiasing = ClientPrefs.globalAntialiasing;
			grpWeekCharacters.add(charSprite);
		}
		add(grpWeekCharacters);
		
		txtTracklist = new LanguageText(671, 540, 570, "", 30, 'krungthep');
		txtTracklist.alignment = LEFT;
		txtTracklist.color = FlxColor.WHITE;
		add(txtTracklist);

		theLocation = new LanguageText(650, 215, 630, "", 35, 'krungthep');
		theLocation.alignment = LEFT;
		theLocation.color = FlxColor.WHITE;
		theLocation.setBorderStyle(OUTLINE, 0xFF420757, 2, 1);
		add(theLocation);

		var modiOpti:FlxSprite = new FlxSprite(0, 676).loadGraphic(Paths.image('story_menuy/options'));
		modiOpti.antialiasing = ClientPrefs.globalAntialiasing;
		modiOpti.updateHitbox();
		add(modiOpti);

		changeWeek();

		super.create();
	}

	override function closeSubState() {
		persistentUpdate = true;
		changeWeek();
		super.closeSubState();
	}

	override function update(elapsed:Float)
	{
		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var leftP = controls.UI_LEFT_P;
		var rightP = controls.UI_RIGHT_P;
		var ctrl = FlxG.keys.justPressed.CONTROL;
		var mbutt = FlxG.keys.justPressed.M;
		if (!selectedWeek)
		{
			if (upP)
			{
				changeWeek(-1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}

			if (downP)
			{
				changeWeek(1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}

			if (rightP)
				changeStoryCat(1);
			else if (leftP)
				changeStoryCat(-1);

			if(mbutt)
			{
				persistentUpdate = false;
				openSubState(new GameplayChangersSubState());
			}
			else if(ctrl)
			{
				persistentUpdate = false;
				OptionsState.whichState = 'storymenu';
				LoadingState.loadAndSwitchState(new OptionsState());
			}
			else if (controls.ACCEPT && !WeekData.weekIsLocked(loadedWeeks[curWeek].fileName))
			{
				var rec:Int = loadedWeeks[curWeek].recommended;
				if (Math.isNaN(loadedWeeks[curWeek].recommended))
					rec = 0;

				FlxG.sound.play(Paths.sound('confirmMenu'));
				openSubState(new CharaSelect('story', loadedWeeks[curWeek].charaSelect, loadedWeeks[curWeek].fileName, rec, loadedWeeks[curWeek].force1P));
			}

			if(ClientPrefs.menuMouse)
			{
				if (FlxG.mouse.wheel != 0)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.5);
					if (FlxG.mouse.wheel < 0)
						changeWeek(1);
					else if (FlxG.mouse.wheel > 0)
						changeWeek(-1);	
				}

				if(FlxG.mouse.justPressed)
				{
					if (FlxG.mouse.overlaps(rightArrow) && ClientPrefs.pastOGWeek)
						changeStoryCat(1);
					if (FlxG.mouse.overlaps(leftArrow) && ClientPrefs.pastOGWeek)
						changeStoryCat(-1);
				}

				grpWeekText.forEach(function(spr:StoryItem)
				{
					if (FlxG.mouse.overlaps(spr) && (!FlxG.mouse.overlaps(rightArrow) || !FlxG.mouse.overlaps(leftArrow)))
					{
						if (FlxG.mouse.justPressed)
						{
							if (spr.ID != 0)
							{
								FlxG.sound.play(Paths.sound('scrollMenu'), 0.5);
								changeWeek(spr.ID);
							}
							else if (!WeekData.weekIsLocked(loadedWeeks[curWeek].fileName))
							{
								var rec:Int = loadedWeeks[curWeek].recommended;
								if (Math.isNaN(loadedWeeks[curWeek].recommended))
									rec = 0;

								FlxG.sound.play(Paths.sound('confirmMenu'));
								openSubState(new CharaSelect('story', loadedWeeks[curWeek].charaSelect, loadedWeeks[curWeek].fileName, rec, loadedWeeks[curWeek].force1P));
							}
						}
					}
				});
			}
		}

		if (controls.BACK && canPressbuttons && !selectedWeek #if !FORCE_DEBUG_VERSION && ClientPrefs.pastOGWeek #end)
		{
			canPressbuttons = false;
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}

		if (loadedWeeks.length < 1 && selectedWeek)
		{
			if(FlxG.mouse.justPressed && ClientPrefs.menuMouse)
			{
				if (FlxG.mouse.overlaps(rightArrow))
					changeStoryCat(1);
				if (FlxG.mouse.overlaps(leftArrow))
					changeStoryCat(-1);
			}

			if (rightP)
				changeStoryCat(1);
			else if (leftP)
				changeStoryCat(-1);
		}

		super.update(elapsed);
	}

	public var selectedWeek:Bool = false;
	var stopspamming:Bool = false;
	var canPressbuttons:Bool = true;

	public function selectWeek()
	{
		if (!WeekData.weekIsLocked(loadedWeeks[curWeek].fileName))
		{
			if (stopspamming == false)
			{
				stopspamming = true;
			}

			// We can't use Dynamic Array .copy() because that crashes HTML5, here's a workaround.
			var songArray:Array<String> = [];
			var leWeek:Array<Dynamic> = loadedWeeks[curWeek].songs;
			for (i in 0...leWeek.length) {
				songArray.push(leWeek[i][0]);
			}

			// Nevermind that's stupid lmao
			PlayState.storyPlaylist = songArray;
			PlayState.isStoryMode = true;
			selectedWeek = true;

			var diffic = CoolUtil.getDifficultyFilePath(curDifficulty);
			if(diffic == null) diffic = '';

			PlayState.storyDifficulty = curDifficulty;

			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
			PlayState.campaignScore = 0;
			PlayState.campaignHits = 0;
			PlayState.campaignMisses = 0;
			PlayState.campaignAccuracy = 0.00;
			PlayState.campaignTotalPlayed = 0;
			PlayState.campaignTotalNotesHit = 0.0;

			PlayState.campaignMarvelous = 0;
			PlayState.campaignSicks = 0;
			PlayState.campaignGoods = 0;
			PlayState.campaignBads = 0;
			PlayState.campaignShits = 0;
			PlayState.campaignEarlys = 0;
			PlayState.campaignLates = 0;

			PlayState.restartScore = 0;
			PlayState.restartHits = 0;
			PlayState.restartMisses = 0;
			PlayState.restartAccuracy = 0.00;

			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				LoadingState.loadAndSwitchState(new PlayState(), true);
				FreeplayState.destroyFreeplayVocals();
			});
		} else {
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}
	}

	function changeStoryCat(change:Int = 0)
	{
		curPage += change;
		if (curPage >= storyMenuCat.length)
			curPage = 0;
		if (curPage < 0)
			curPage = storyMenuCat.length - 1;

		persistentUpdate = false;
		FlxG.sound.play(Paths.sound('scrollMenu'));
		MusicBeatState.switchState(new StoryMenuState());
	}

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek >= loadedWeeks.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = loadedWeeks.length - 1;

		var leWeek:WeekData = loadedWeeks[curWeek];
		WeekData.setDirectoryFromWeek(leWeek);

		var bullShit:Int = 0;

		for (item in grpWeekText.members)
		{
			item.ID = bullShit - curWeek;
			bullShit++;
			item.isSelected(item.ID == 0 ? true : false);
			FlxTween.cancelTweensOf(item);
			FlxTween.tween(item, {y: 106 + (item.ID * 150)}, 0.5, {ease: FlxEase.circOut});
		
			if (item.ID == 0)
				PlayState.storyWeek = item.weekienumbie;
		}

		var assetName:String = leWeek.weekBackground;

		if (Paths.fileExists('images/story_menuy/stageprev/$assetName.png', IMAGE) && !WeekData.weekIsLocked(loadedWeeks[curWeek].fileName))
			bgSprite.loadGraphic(Paths.image('story_menuy/stageprev/$assetName'));
		else
			bgSprite.loadGraphic(Paths.image('story_menuy/stageprev/emptystage'));
	

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		var diffStr:String = WeekData.getCurrentWeek().difficulties;
		if(diffStr != null) diffStr = diffStr.trim(); //Fuck you HTML5

		if(diffStr != null && diffStr.length > 0)
		{
			var diffs:Array<String> = diffStr.split(',');
			var i:Int = diffs.length - 1;
			while (i > 0)
			{
				if(diffs[i] != null)
				{
					diffs[i] = diffs[i].trim();
					if(diffs[i].length < 1) diffs.remove(diffs[i]);
				}
				--i;
			}

			if(diffs.length > 0 && diffs[0].length > 0)
			{
				CoolUtil.difficulties = diffs;
			}
		}
		updateText();
	}

	function updateText()
	{
		var weekArray:Array<String> = loadedWeeks[curWeek].weekCharacters;
	
		for (i in 0...grpWeekCharacters.length) {
			if (Paths.fileExists('images/story_menuy/chartags/' + weekArray[i] + '.png', IMAGE) && !WeekData.weekIsLocked(loadedWeeks[curWeek].fileName))
				grpWeekCharacters.members[i].loadGraphic(Paths.image('story_menuy/chartags/' + weekArray[i]));
			else
				grpWeekCharacters.members[i].loadGraphic(Paths.image('story_menuy/chartags/Empty'));
		}

		var leWeek:WeekData = loadedWeeks[curWeek];
		var stringThing:Array<String> = [];
		for (i in 0...leWeek.songs.length) {
			stringThing.push(leWeek.songs[i][0]);
		}

		txtTracklist.text = '';
		theLocation.text = '';
		for (i in 0...stringThing.length)
		{
			txtTracklist.text += stringThing[i] + '\n';
		}

		txtTracklist.text = txtTracklist.text.toUpperCase();
		txtTracklist.visible = !WeekData.weekIsLocked(loadedWeeks[curWeek].fileName);

		if (loadedWeeks[curWeek].location != null && loadedWeeks[curWeek].location != '' && !WeekData.weekIsLocked(loadedWeeks[curWeek].fileName))
			theLocation.text = loadedWeeks[curWeek].location;
	}
}

class StoryItem extends FlxSpriteGroup
{
	var selection:FlxSprite;
	var scoreText:LanguageText;
	public var weekienumbie:Int;

	public function new(x:Float = 0, y:Float = 0, boxType:String, chapter:String, weekName:String, weekNumberthingie:Int)
	{
		super(x, y);
		var boxThignie:String = 'Extra';
		weekienumbie = weekNumberthingie;

		if (Paths.fileExists('images/story_menuy/Box$boxType.png', IMAGE))
			boxThignie = boxType;

		var box:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('story_menuy/Box$boxThignie'));
		box.antialiasing = ClientPrefs.globalAntialiasing;
		add(box);

		selection = new FlxSprite(0, 0).loadGraphic(Paths.image('story_menuy/BoxSelect'));
		selection.antialiasing = ClientPrefs.globalAntialiasing;
		add(selection);
		//wah

		var chapterText:LanguageText = new LanguageText(22, 15, 301, chapter, 20, 'krungthep');
		chapterText.setStyle(FlxColor.WHITE, FlxTextAlign.LEFT);
		chapterText.setBorderStyle(OUTLINE, 0xFF220B2B, 2, 1);
		chapterText.updateHitbox();
		add(chapterText);

		var weekText:LanguageText = new LanguageText(21, 47, 593, weekName, 50, 'krungthep');
		weekText.setStyle(FlxColor.WHITE, FlxTextAlign.LEFT);
		weekText.setBorderStyle(OUTLINE, 0xFF220B2B, 3.5, 1);
		weekText.updateHitbox();
		add(weekText);
	}

	public function isSelected(what:Bool = false)
		selection.visible = what;
}
