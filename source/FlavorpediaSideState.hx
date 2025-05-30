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

#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

typedef SideCharacterList = {
	var character:Array<SideCharacterArray>;
}

typedef SideCharacterArray = {
	var chara:Null<String>; // handles the render
	var name:Null<String>; // Chara name
	var design:Null<String>; // Chara designer
	var desc:Null<String>; // Chara description
	var place:Null<String>; // Chara place
	var songCheck:Null<String>; // leave blank if unlocked by default
	var link:Null<String>;
}

class FlavorpediaSideState extends MusicBeatState
{
	var allowInput:Bool = false;

	var curSelected:Int = 0;

	var howmanyperRow:Int = 4;
	var whereamIontherowInt:Int = 0;
	var howmanyTotalRows:Int = 0;

	var place:FlxSprite;
	var selector:FlxSprite;
	var bigicon:FlxSprite;
	var icons:FlxTypedGroup<FlxSprite>;

	var charaStuff:Array<Array<Dynamic>> = [];

	var flavorName:LanguageText;
	var flavorcreator:LanguageText;
	var flavordesc:LanguageText;
	var flavorplace:LanguageText;

	public var bufferArray:Array<SideCharacterArray> = [];

	override function create()
	{
		FlxG.mouse.visible = ClientPrefs.menuMouse;

		#if discord_rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Viewing the Flavorpedia", null);
		#end

		place = new FlxSprite(578, 401).loadGraphic(Paths.image('flavorpedia/side/stageprev/Not Found'));
		place.antialiasing = ClientPrefs.globalAntialiasing;
		place.scale.set(1.2,1.2);
		place.updateHitbox();
		add(place);

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('flavorpedia/side/SideCharBG'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		bigicon = new FlxSprite(669, 94).loadGraphic(Paths.image('flavorpedia/side/icons/saff'));
		bigicon.antialiasing = ClientPrefs.globalAntialiasing;
		add(bigicon);

		icons = new FlxTypedGroup<FlxSprite>();
		add(icons);

		selector = new FlxSprite(-200, -200).loadGraphic(Paths.image('flavorpedia/side/IconSelect'));
		selector.antialiasing = ClientPrefs.globalAntialiasing;
		selector.scale.set(0.8,0.8);
		selector.updateHitbox();
		add(selector);

		var titleBar:FlxSprite = new FlxSprite().loadGraphic(Paths.image('flavorpedia/side/TitleBar'));
		titleBar.antialiasing = ClientPrefs.globalAntialiasing;
		add(titleBar);

		flavorName = new LanguageText(845, 110, 420, "", 50, 'carat');
		flavorName.setStyle(FlxColor.WHITE, LEFT);
		add(flavorName);

		flavorcreator = new LanguageText(845, 190, 420, "", 30, 'krungthep');
		flavorcreator.setStyle(FlxColor.WHITE, LEFT);
		add(flavorcreator);

		flavordesc = new LanguageText(684, 270, 554, "", 20, 'krungthep');
		flavordesc.setStyle(FlxColor.WHITE, CENTER);
		add(flavordesc);

		flavorplace = new LanguageText(687, 670, 554, "", 40, 'krungthep');
		flavorplace.setStyle(FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		flavorplace.setBorderStyle(OUTLINE, FlxColor.BLACK);
		flavorplace.borderSize = 3;
		add(flavorplace);

		var path:String = Paths.getPreloadPath('data/flavorpediaSideData.json');
		var rawJson = Assets.getText(path);
		var json:SideCharacterList = cast Json.parse(rawJson);
		//trace(json);

		bufferArray = json.character;

		for (peep in bufferArray)
		{
			if (peep.songCheck != null)
			{
				var isBeaten:Bool = Highscore.checkBeaten(peep.songCheck, 0) || peep.songCheck == null;

				#if FORCE_DEBUG_VERSION
				if (!isBeaten) FlxG.log.warn('[FP] ${peep.name} is normally locked, but forcing unlocked due to debug.');
				isBeaten = true;
				#end

				if (isBeaten)
					charaStuff.push([peep.chara, 
						Language.flavor.get("flavorpediaside_" + peep.name + "_name", peep.name), 
						Language.flavor.get("flavorpediaside_" + peep.name + "_design", peep.design), 
						Language.flavor.get("flavorpediaside_" + peep.name + "_desc", peep.desc), 
						peep.place, 
						peep.songCheck, 
						peep.link]);
				else
					charaStuff.push([Language.flavor.get("flavorpediaside_blank", "blank"), "???", "???", "???", Language.flavor.get("flavorpediaside_notfound", "Not Found"), '', '']);
			}
		}

		#if MODS_ALLOWED
		var modsDirectories:Array<String> = Paths.getGlobalMods();
		for (folder in modsDirectories)
		{
			//This idea works and it's almost great. BUT 
			var modPath:String = Paths.modFolders('data/flavorpediaSideData.json', folder);
			trace(FileSystem.exists(modPath));
			if (FileSystem.exists(modPath))
			{
				json = cast Json.parse(File.getContent(modPath));
				bufferArray = json.character;

				for (peep in bufferArray)
				{
					if (peep.songCheck != null)
					{
						var isBeaten:Bool = Highscore.checkBeaten(peep.songCheck, 0) || peep.songCheck == null;
		
						#if FORCE_DEBUG_VERSION
						if (!isBeaten) FlxG.log.warn('[FP] ${peep.name} is normally locked, but forcing unlocked due to debug.');
						isBeaten = true;
						#end
		
						if (isBeaten)
							charaStuff.push([peep.chara, 
							Language.flavor.get("flavorpediaside_" + peep.name + "_name", peep.name), 
							Language.flavor.get("flavorpediaside_" + peep.name + "_design", peep.design), 
							Language.flavor.get("flavorpediaside_" + peep.name + "_desc", peep.desc), 
							peep.place, 
							peep.songCheck, 
							peep.link]);
						else
							charaStuff.push([Language.flavor.get("flavorpediaside_blank", "blank"), "???", "???", "???", Language.flavor.get("flavorpediaside_notfound", "Not Found"), '', '']);
					}
				}

			}
		}
		#end

		for (i in 0...charaStuff.length)
		{
			var icon:FlxSprite = new FlxSprite(34 + (i % 4 * 146), 82 + (whereamIontherowInt * 153)).loadGraphic(Paths.image('flavorpedia/side/icons/' + charaStuff[i][0]));
			icon.antialiasing = ClientPrefs.globalAntialiasing;
			icon.scale.set(0.8,0.8);
			icon.updateHitbox();
			icons.add(icon);
			if (i % 4 == 3)
			{
				howmanyTotalRows += 1;
				whereamIontherowInt += 1;
			}
			if (i == charaStuff.length - 1 && i % 4 != 3)
				howmanyTotalRows += 1;

			icon.ID = i;
		}

		//flavorText.text = charaStuff[curSelected][3];

		new FlxTimer().start(0.2, function(tmr:FlxTimer)
		{
			allowInput = true;
			changeItem();
		});

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (allowInput)
		{
			//Have to make this a else if loop to prevent frame perfect inputs and breaking the menu
			if (controls.UI_LEFT_P)
			{
				allowInput = false;
				changeItem(-1, true);
			}
			else if (controls.UI_RIGHT_P)
			{
				allowInput = false;
				changeItem(1, true);
			}
			else if (controls.UI_UP_P)
			{
				allowInput = false;
				changeItem(-4, true);
			}
			else if (controls.UI_DOWN_P)
			{
				allowInput = false;
				changeItem(4, true);
			}

			if (controls.BACK)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new FlavorpediaSelectorState());
			}

			if (controls.ACCEPT)
			{
				if ((charaStuff[curSelected][0] == 'jorge' || charaStuff[curSelected][0] == 'richard') && FlxG.keys.pressed.G)
				{
					CoolUtil.browserLoad('https://www.youtube.com/watch?v=0MW9Nrg_kZU');
				}
				else if (charaStuff[curSelected][6] != null && charaStuff[curSelected][6] != '')
				{
					CoolUtil.browserLoad(charaStuff[curSelected][6]);
				}
			}

			if(ClientPrefs.menuMouse)
			{
				if(FlxG.mouse.wheel != 0)
					scrollMenu(FlxG.mouse.wheel);

				icons.forEach(function(spr:FlxSprite)
				{
					if(FlxG.mouse.overlaps(spr) && FlxG.mouse.justPressed)
					{
						if (curSelected == spr.ID)
						{
							if ((charaStuff[curSelected][0] == 'jorge' || charaStuff[curSelected][0] == 'richard') && FlxG.keys.pressed.G)
							{
								CoolUtil.browserLoad('https://www.youtube.com/watch?v=0MW9Nrg_kZU');
							}
							else if (charaStuff[curSelected][6] != null && charaStuff[curSelected][6] != '')
							{
								CoolUtil.browserLoad(charaStuff[curSelected][6]);
							}
						}
						else
						{
							curSelected = spr.ID;
							allowInput = false;
							changeItem(false);
						}
					}
				});
			}
		}
	}

	function changeItem(huh:Int = 0, playSound:Bool = false)
	{
		curSelected += huh;
		whereamIontherowInt = 0;

		if (curSelected >= charaStuff.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = charaStuff.length - 1;

		if (playSound && (curSelected != charaStuff.length - 1 || curSelected != 0))
			FlxG.sound.play(Paths.sound('scrollMenu'));

		if (!selector.visible) selector.visible = true;

		flavorName.text = charaStuff[curSelected][1];
		flavorcreator.text = charaStuff[curSelected][2];
		flavordesc.text = charaStuff[curSelected][3];
		flavorplace.text = charaStuff[curSelected][4];
		bigicon.loadGraphic(Paths.image('flavorpedia/side/icons/' + charaStuff[curSelected][0]));
		place.loadGraphic(Paths.image('flavorpedia/side/stageprev/' + charaStuff[curSelected][4]));

		var currentPosition:Float = icons.members[curSelected].y;
		var baseY:Float = 0;

		if (currentPosition > 720 - 136)
			baseY = -153;
		if (currentPosition <= 65)
			baseY = 153;

		if (baseY != 0)
		{
			for (item in icons.members)
			{
				FlxTween.cancelTweensOf(item);
				if (curSelected <= 3)
					FlxTween.tween(item, {y: 82 + (whereamIontherowInt * 153)}, 0.1, {ease: FlxEase.circOut});
				else if (curSelected >= icons.members.length - 4)
					FlxTween.tween(item, {y: 684 - (howmanyTotalRows * 153) + (whereamIontherowInt * 153)}, 0.1, {ease: FlxEase.circOut});
				else
					FlxTween.tween(item, {y: item.y + baseY}, 0.1, {ease: FlxEase.circOut});

				if (item.ID % 4 == 3)
					whereamIontherowInt += 1;
			}
		}
		var delay:Float = (baseY == 0 ? 0 : 0.1);
		new FlxTimer().start(delay, function(tmr:FlxTimer) {
			FlxTween.cancelTweensOf(selector);
			FlxTween.tween(selector, {x: icons.members[curSelected].x, y:icons.members[curSelected].y}, 0.1, {ease: FlxEase.circOut});
			allowInput = true;
		});
	}

	function scrollMenu(direction:Int)
	{
		var baseY:Float = 0;
		selector.visible = false;

		if (direction > 0 && icons.members[0].y < 72)
			baseY = 50;
		if (direction < 0 && icons.members[icons.members.length - 1].y > 720 - 136)
			baseY = -50;

		if (baseY != 0)
		{
			for (item in icons.members)
			{
				FlxTween.cancelTweensOf(item);
				FlxTween.tween(item, {y: item.y + baseY}, 0.1, {ease: FlxEase.circOut});
			}
		}
	}
}
