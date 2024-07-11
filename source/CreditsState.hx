package;

import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import lime.utils.Assets;
import haxe.Json;
import shaders.TwoToneMask;

#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end

#if discord_rpc
import Discord.DiscordClient;
#end

using StringTools;


typedef CreditsFile ={
	var peeps:Array<Peeps>;
	var listoroles:Array<String>;
}

typedef Peeps = {
	var realName:String;
	var iconName:String;
	var description:String;
	var color:Array<Int>;
	var twitter:String;
	var whichrole:Int;
	var hiddenType:String;
}

class CreditsState extends MusicBeatState
{
	var backdrop:FlxBackdrop;
	static var backdropPos:Array<Float> = [0, 0];

	var curSelected:Int = 0;
	static var curPage:Int = 0;
	static var pageFlipped:Bool = false;

	var rolelist:Array<String> = [];
	
	private var grpNames:FlxTypedGroup<FlxText>;
	private var cardArray:FlxTypedGroup<CMenuItem>;

	//hueh
	public var bufferArray:Array<Peeps> = [];
	var creditsStuff:Array<Array<Dynamic>> = [];
	var modRoleText:FlxText;

	var buttonL:FlxSprite;
	var buttonR:FlxSprite;

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		persistentUpdate = persistentDraw = true;
		FlxG.mouse.visible = ClientPrefs.menuMouse;

		#if discord_rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Credits", null);
		#end

		if (pageFlipped)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'));
			pageFlipped = false;
		}

		backdrop = new FlxBackdrop(Paths.image('mainmenu/checkerboard'));
		backdrop.setPosition(backdropPos[0], backdropPos[1]);
		backdrop.velocity.set(-40, -40);
		backdrop.antialiasing = false;
		backdrop.shader = new TwoToneMaskShader(0xFF1ABBD4, 0xFF1B7AB1);
		add(backdrop);

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('freeplay/rightborder'));
		bg.flipX = true;
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		cardArray = new FlxTypedGroup<CMenuItem>();
		add(cardArray);

		grpNames = new FlxTypedGroup<FlxText>();
		add(grpNames);

		
		loadAssets();
		

		buttonL = new FlxSprite(621, 644).makeGraphic(71, 68, FlxColor.BLACK);
		buttonL.alpha = 0;
		buttonL.scrollFactor.set();
		add(buttonL);

		buttonR = new FlxSprite(1205, 644).makeGraphic(71, 68, FlxColor.BLACK);
		buttonR.alpha = 0;
		buttonR.scrollFactor.set();
		add(buttonR);

		var fg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('credits/borders'));
		fg.antialiasing = ClientPrefs.globalAntialiasing;
		add(fg);

		modRoleText = new FlxText(684, 640, 526, '', 50);
		modRoleText.setFormat(Paths.font("Krungthep.ttf"), 50, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, 0xFF000000);
		modRoleText.borderSize = 3;
		modRoleText.antialiasing = ClientPrefs.globalAntialiasing;
		modRoleText.text = rolelist[curPage];
		add(modRoleText);

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		backdropPos = [backdrop.x, backdrop.y];

		if (FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume += 0.5 * elapsed;

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.UI_LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changePage(-1);
			}

			if (controls.UI_RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changePage(1);
			}
			
			if (controls.ACCEPT)
			{
				if (creditsStuff[curSelected][0] == 'Jorge - SunSpirit' && FlxG.keys.pressed.G)
				{
					CoolUtil.browserLoad('https://www.youtube.com/watch?v=0MW9Nrg_kZU');
				}
				else if (creditsStuff[curSelected][3] != '')
				{
					CoolUtil.browserLoad(creditsStuff[curSelected][3]);
				}
			}

			if (controls.BACK)
			{
				curPage = 0;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
			}

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

				if(FlxG.mouse.overlaps(buttonL))
				{
					if(FlxG.mouse.justPressed)
					{
						changePage(-1);
					}
				}
				if(FlxG.mouse.overlaps(buttonR))
				{
					if(FlxG.mouse.justPressed)
					{
						changePage(1);
					}
				}

				grpNames.forEach(function(spr:FlxText)
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

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;
		var bullShit:Int = 0;

		if (curSelected >= creditsStuff.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = creditsStuff.length - 1;

		trace(curSelected);

		for (item in grpNames.members)
		{
			item.ID = bullShit - curSelected;
			bullShit++;

			FlxTween.cancelTweensOf(item);

			if (curSelected >= 6 && curSelected <= creditsStuff.length - 3)
				FlxTween.tween(item, {x: 172 + (item.ID * 24), y: 433 + (item.ID * 59)}, 0.5, {ease: FlxEase.circOut});

			if (curSelected <= 4)
			{
				FlxTween.cancelTweensOf(item);

				if (curSelected == 0)
					FlxTween.tween(item, {x: 28 + (item.ID * 24), y: 79 + (item.ID * 59)}, 0.5, {ease: FlxEase.circOut});
				if (curSelected == 1)
					FlxTween.tween(item, {x: 52 + (item.ID * 24), y: 138 + (item.ID * 59)}, 0.5, {ease: FlxEase.circOut});
				if (curSelected == 2)
					FlxTween.tween(item, {x: 76 + (item.ID * 24), y: 197 + (item.ID * 59)}, 0.5, {ease: FlxEase.circOut});
				if (curSelected == 3)
					FlxTween.tween(item, {x: 100 + (item.ID * 24), y: 256 + (item.ID * 59)}, 0.5, {ease: FlxEase.circOut});
				if (curSelected == 4)
					FlxTween.tween(item, {x: 124 + (item.ID * 24), y: 315 + (item.ID * 59)}, 0.5, {ease: FlxEase.circOut});
			}

			if (creditsStuff.length >= 10 && curSelected >= creditsStuff.length - 3)
			{
				FlxTween.cancelTweensOf(item);

				if (curSelected == creditsStuff.length - 3)
					FlxTween.tween(item, {x: 196 + (item.ID * 24), y: 492 + (item.ID * 59)}, 0.5, {ease: FlxEase.circOut});
				if (curSelected == creditsStuff.length - 2)
					FlxTween.tween(item, {x: 220 + (item.ID * 24), y: 551 + (item.ID * 59)}, 0.5, {ease: FlxEase.circOut});
				if (curSelected == creditsStuff.length - 1)
					FlxTween.tween(item, {x: 244 + (item.ID * 24), y: 610 + (item.ID * 59)}, 0.5, {ease: FlxEase.circOut});
			}

			item.color = 0xFFFFFFFF;
			if (item.ID == 0)
			{
				createMenuGraphic();
				item.color = 0xFF95E1FF;
			}
		}
	}

	function changePage(huh:Int = 0)
	{
		pageFlipped = true;
		curPage += huh;

		if (curPage >= rolelist.length)
			curPage = 0;
		if (curPage < 0)
			curPage = rolelist.length - 1;

		reloadAssets();
	}

	function createMenuGraphic()
	{
		var menuCard:CMenuItem = new CMenuItem(1280, 200, creditsStuff[curSelected][0], creditsStuff[curSelected][1], creditsStuff[curSelected][2], creditsStuff[curSelected][4]);
		menuCard.antialiasing = ClientPrefs.globalAntialiasing;
		menuCard.angle = FlxG.random.int(-10, 10);
		cardArray.add(menuCard);

		FlxTween.tween(menuCard, {x: 538, angle: FlxG.random.int(-6, 6)}, 0.5, {ease: FlxEase.circOut});

		if (cardArray.length >= 10)
		{
			FlxTween.tween(cardArray.members[1], {x: 1280}, 0.2, {
				ease: FlxEase.backInOut,
				onComplete: function(flxTween:FlxTween)
				{
					cardArray.remove(cardArray.members[1], true);
				}
			});
		}
	}

	function loadAssets()
	{
		var path:String = Paths.getPreloadPath('data/creditsData.json');
		var rawJson = Assets.getText(path);
		var json:CreditsFile = cast Json.parse(rawJson);

		rolelist = json.listoroles;
		bufferArray = json.peeps;

		for (peep in bufferArray)
		{
			if (peep.whichrole == curPage)
				creditsStuff.push([peep.realName, peep.iconName, peep.description, peep.twitter, peep.color, peep.whichrole]);
		}

		#if MODS_ALLOWED
		var modsDirectories:Array<String> = Paths.getModDirectories();
		for (folder in modsDirectories)
		{
			//This idea works and it's almost great. BUT 
			var modPath:String = Paths.modFolders('data/creditsData.json', folder);

			if (FileSystem.exists(modPath))
			{
				json = cast Json.parse(File.getContent(modPath));
				bufferArray = json.peeps;

				for (peep in bufferArray)
				{
					if (peep.whichrole == curPage)
						creditsStuff.push([peep.realName, peep.iconName, peep.description, peep.twitter, peep.color, peep.whichrole]);
				}

			}
		}
		#end
	
		for (i in 0...creditsStuff.length)
		{
			//Text names
			var nameText:FlxText = new FlxText(52 + (i * 24), 138 + (i * 59), 0, creditsStuff[i][0], 32);
			nameText.setFormat(Paths.font("Krungthep.ttf"), 32, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			nameText.borderSize = 2;
			nameText.antialiasing = ClientPrefs.globalAntialiasing;
			nameText.ID = i;
			grpNames.add(nameText);
		}

		curSelected = 0;
		changeItem();
	}

	function reloadAssets()
	{
		grpNames.clear();
		creditsStuff = [];
		loadAssets();
		modRoleText.text = rolelist[curPage];
	}
}

class CMenuItem extends FlxSpriteGroup
{
	var song:String;

	var bg:FlxSprite;
	var icon:FlxSprite;
	var name:FlxText;
	var text:FlxText;

	public function new(x:Float = 0, y:Float = 0, namee:String = '???', icon:String = 'default', wha:String = '???', ?color:Array<Int>)
	{
		super(x, y);
		var iconString:String = icon.toLowerCase();

		bg = new FlxSprite().loadGraphic(Paths.image('credits/Ticket'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		if (color != null) bg.color = FlxColor.fromRGB(color[0], color[1], color[2]);
		add(bg);

		if (!Paths.fileExists('images/credits/icons/' + iconString + '.png', IMAGE))
			iconString = 'default';

		this.icon = new FlxSprite(57, 99).loadGraphic(Paths.image('credits/icons/' + iconString));
		this.icon.antialiasing = ClientPrefs.globalAntialiasing;
		this.icon.scale.set(0.9, 0.9);
		this.icon.updateHitbox();
		this.icon.origin.set(bg.origin.x - this.icon.origin.x, bg.origin.y - this.icon.origin.y);
		add(this.icon);

		name = new FlxText(234, 104, 451 /* 0 */, namee, 40);
		name.setFormat(Paths.font("Krungthep.ttf"), 40, FlxColor.WHITE, LEFT);
		name.antialiasing = ClientPrefs.globalAntialiasing;
		name.origin.set(bg.origin.x - name.origin.x, bg.origin.y - name.origin.y);
		add(name);

		/* Squish name if too long
		{
			if (name.frameWidth > 451)
				name.scale.x = 451 / name.frameWidth;

			name.updateHitbox();
		}
		*/

		text = new FlxText(234, 178, 451, wha, 30);
		text.setFormat(Paths.font("Krungthep.ttf"), 30, FlxColor.WHITE, LEFT);
		text.antialiasing = ClientPrefs.globalAntialiasing;
		text.origin.set(bg.origin.x - text.origin.x, bg.origin.y - text.origin.y);
		add(text);
	}
}
