package;

import flixel.group.FlxSpriteGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;

#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end

#if discord_rpc
import Discord.DiscordClient;
#end

using StringTools;

typedef GalleryFile = {
	var artwork:Array<Artwork>;
}

typedef Artwork = {
	var image:String;
	var caption:String;
	var artist:String;
	var url:String;
	var songCheck:String;
	var isModded:Bool;
}

class GalleryState extends MusicBeatState
{
	var curGallSelected:Int = 0;
	var curSelected:Int = 0;

	var switchState:FlxSprite;
	var artwork:FlxSprite;
	var authorText:FlxText;
	var arrows:FlxSpriteGroup;
	var gallerybuttons:FlxSpriteGroup;
	var returnSprite:FlxSprite;
	var gallerymain:FlxSprite;
	var gallerycg:FlxSprite;

	var galleryData:Array<Artwork> = [];
	var isMain:Bool = true;
	var inGallery:Bool = false;
	var canPressButtons:Bool = false;

	override function create()
	{
		persistentUpdate = persistentDraw = true;

		#if discord_rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Viewing the Gallery", null);
		#end

		CoolUtil.difficulties = ["Normal"];

		var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('gallery/bg'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		
		artwork = new FlxSprite(0, 0).loadGraphic(Paths.image('Fumo'));
		artwork.antialiasing = ClientPrefs.globalAntialiasing;
		artwork.alpha = 0.001;
		add(artwork);

		gallerybuttons = new FlxSpriteGroup();
		add(gallerybuttons);

		gallerymain = new FlxSprite(1280, 40).loadGraphic(Paths.image('gallery/premenu/gallery-main'));
		gallerymain.antialiasing = ClientPrefs.globalAntialiasing;
		gallerymain.ID = 0;
		gallerybuttons.add(gallerymain);

		gallerycg = new FlxSprite(-1280, 366).loadGraphic(Paths.image('gallery/premenu/gallery-cg'));
		gallerycg.antialiasing = ClientPrefs.globalAntialiasing;
		gallerycg.ID = 1;
		gallerybuttons.add(gallerycg);

		var fg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('gallery/fg_overwlay'));
		fg.antialiasing = ClientPrefs.globalAntialiasing;
		add(fg);

		switchState = new FlxSprite(824, 652).loadGraphic(Paths.image('gallery/menubuttonThignie'));
		switchState.antialiasing = ClientPrefs.globalAntialiasing;
		add(switchState);

		authorText = new FlxText(0, 0, FlxG.width, "", 35);
		authorText.font = Paths.font("Krungthep.ttf");
		authorText.setBorderStyle(OUTLINE, FlxColor.BLACK);
		authorText.borderSize = 4;
		authorText.antialiasing = ClientPrefs.globalAntialiasing;
		artwork.alpha = 1;
		add(authorText);

		arrows = new FlxSpriteGroup();
		add(arrows);

		for (i in 0...2)
		{
			var arrow:FlxSprite = new FlxSprite(94 + (i * 1033)).loadGraphic(Paths.image('gallery/arrow'));
			arrow.screenCenter(Y);
			arrow.ID = i;
			arrow.antialiasing = ClientPrefs.globalAntialiasing;
			if (i == 0)
				arrow.flipX = true;
			arrows.add(arrow);
			arrow.alpha = 0.001;
		}

		FlxTween.tween(gallerymain, {x: 0}, 0.5, {ease: FlxEase.sineOut});
		FlxTween.tween(gallerycg, {x: 0}, 0.5, {ease: FlxEase.sineOut});
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			canPressButtons = true;
			changeItem();
		});

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null && FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume += 0.5 * elapsed;

		if (canPressButtons)
		{
			if (controls.BACK)
			{
				if (!inGallery)	MusicBeatState.switchState(new MainMenuState());
				else	backtoSelector();

				FlxG.sound.play(Paths.sound('cancelMenu'));
				switchState.scale.set(1.2, 1.2);
				FlxTween.tween(switchState, {"scale.x": 1,"scale.y": 1}, 0.1, {ease: FlxEase.sineOut});
			}

			if (controls.UI_UP_P && !inGallery)
				changeItem(-1);

			if (controls.UI_DOWN_P && !inGallery)
				changeItem(1);
	
			if (controls.UI_LEFT_P && inGallery)
				changeGalleryItem(-1, 0);
	
			if (controls.UI_RIGHT_P && inGallery)
				changeGalleryItem(1, 1);
	
			if (controls.ACCEPT && inGallery && galleryData[curGallSelected].url != null)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				CoolUtil.browserLoad(galleryData[curGallSelected].url);
			}

			if (controls.ACCEPT && !inGallery)
			{
				loadGallState(curSelected == 0);
			}
	
			if (ClientPrefs.menuMouse)
			{
				if (inGallery)
				{
					arrows.forEach(function(spr:FlxSprite)
					{
						if (FlxG.mouse.overlaps(spr) && FlxG.mouse.justPressed)
							changeGalleryItem((spr.ID == 0 ? -1 : 1), (spr.ID == 0 ? 0 : 1));
					});
		
					if (FlxG.mouse.overlaps(switchState) && FlxG.mouse.justPressed)
					{
						FlxG.sound.play(Paths.sound('cancelMenu'));
						backtoSelector();
						switchState.scale.set(1.2, 1.2);
						FlxTween.tween(switchState, {"scale.x": 1,"scale.y": 1}, 0.1, {ease: FlxEase.sineOut});
					}
				}
				else
				{
					gallerybuttons.forEach(function(spr:FlxSprite)
					{
						if (FlxG.mouse.overlaps(spr) && curSelected != spr.ID && FlxG.mouse.justMoved)
						{
							curSelected = spr.ID;
							changeItem();
						}

						if (FlxG.mouse.overlaps(spr) && FlxG.mouse.justPressed)
						{
							loadGallState(spr.ID == 0);
						}
					});
					if (FlxG.mouse.overlaps(switchState) && FlxG.mouse.justPressed)
					{
						FlxG.sound.play(Paths.sound('cancelMenu'));
						MusicBeatState.switchState(new MainMenuState());
						switchState.scale.set(1.2, 1.2);
						FlxTween.tween(switchState, {"scale.x": 1,"scale.y": 1}, 0.1, {ease: FlxEase.sineOut});
					}
				}
			}
		}
		

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		super.update(elapsed);
	}

	function changeItem(int:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'));

		curSelected += int;

		if (curSelected >= 2)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = 1;

		gallerybuttons.forEach(function(spr:FlxSprite)
		{
			FlxTween.cancelTweensOf(spr);
			if (spr.ID == curSelected)
			{
				spr.color = 0xFFFFFFFF;
				FlxTween.tween(spr, {"scale.x": 1.1, "scale.y": 1.1}, 0.1, {ease: FlxEase.circOut});
			}
			else
			{
				spr.color = 0xFF696969;
				FlxTween.tween(spr, {"scale.x": 1, "scale.y": 1}, 0.1, {ease: FlxEase.circOut});
			}
		});
	}

	function changeGalleryItem(huh:Int = 0, lor:Int = 2)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'));

		curGallSelected += huh;

		if (curGallSelected >= galleryData.length)
			curGallSelected = 0;
		if (curGallSelected < 0)
			curGallSelected = galleryData.length - 1;

		var curArtwork:Artwork = galleryData[curGallSelected];

		var library:Null<String> = curArtwork.isModded ? null : (isMain ? null : 'tbd');
		artwork.loadGraphic(Paths.image(isMain ? 'gallery/images/${curArtwork.image}' : 'dreamcast/art_BG/${curArtwork.image}', library));
		artwork.setGraphicSize(0, Std.int(FlxG.height * 0.7));
		artwork.updateHitbox();

		if (artwork.width > FlxG.width)
			artwork.setGraphicSize(Std.int(FlxG.width * 0.8));

		artwork.updateHitbox();
		artwork.screenCenter();
		artwork.y -= 30;

		authorText.text = curArtwork.caption + '\nArtist: ' + curArtwork.artist;
		authorText.y = artwork.y + artwork.height + 25;

		arrows.forEach(function(spr:FlxSprite)
		{
			if (spr.ID == lor)
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

	override function beatHit()
	{
		super.beatHit();
	}

	function loadGallState(main:Bool)
	{
		isMain = main;
		canPressButtons = false;
		inGallery = true;
		galleryData = [];
		curGallSelected = 0;

		var fileName:String = isMain ? 'galleryData' : 'galleryCGData';

		var path:String = Paths.getPreloadPath('data/$fileName.json');
		var rawJson = Assets.getText(path);
		var json:GalleryFile = cast Json.parse(rawJson);
		var preGall:Array<Artwork> = [];

		preGall = json.artwork;

		for (peep in preGall)
		{
			peep.isModded = false;

			if (peep.songCheck == null || peep.songCheck != null && Highscore.checkBeaten(peep.songCheck, 0))
				galleryData.push(peep);
		}

		#if MODS_ALLOWED
		var modsDirectories:Array<String> = Paths.getModDirectories();
		for (folder in modsDirectories)
		{
			//This idea works and it's almost great. BUT 
			var modPath:String = Paths.modFolders('data/$fileName.json', folder);

			if (FileSystem.exists(modPath))
			{
				json = cast Json.parse(File.getContent(modPath));
				preGall = json.artwork;

				for (peep in preGall)
				{
					peep.isModded = true;

					if (peep.songCheck == null || peep.songCheck != null && Highscore.checkBeaten(peep.songCheck, 0))
						galleryData.push(peep);
				}
			}
		}
		#end

		FlxTween.cancelTweensOf(gallerymain.x);
		FlxTween.cancelTweensOf(gallerycg.x);
		FlxTween.cancelTweensOf(artwork.alpha);
		FlxTween.cancelTweensOf(authorText.alpha);
		FlxTween.tween(gallerymain, {x: 1280}, 0.5, {ease: FlxEase.sineOut});
		FlxTween.tween(gallerycg, {x: -1280}, 0.5, {ease: FlxEase.sineOut});
		FlxTween.tween(artwork, {alpha: 1}, 0.5, {ease: FlxEase.sineOut});
		FlxTween.tween(authorText, {alpha: 1}, 0.5, {ease: FlxEase.sineOut});
		arrows.forEach(function(spr:FlxSprite)
		{
			FlxTween.cancelTweensOf(spr.alpha);
			FlxTween.tween(spr, {alpha: 1}, 0.5, {ease: FlxEase.sineOut});
		});
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			canPressButtons = true;
		});

		changeGalleryItem();
	}

	function backtoSelector()
	{
		inGallery = false;
		canPressButtons = false;
		FlxTween.cancelTweensOf(gallerymain.x);
		FlxTween.cancelTweensOf(gallerycg.x);
		FlxTween.cancelTweensOf(artwork.alpha);
		FlxTween.cancelTweensOf(authorText.alpha);
		FlxTween.tween(gallerymain, {x: 0}, 0.5, {ease: FlxEase.sineOut});
		FlxTween.tween(gallerycg, {x: 0}, 0.5, {ease: FlxEase.sineOut});
		FlxTween.tween(artwork, {alpha: 0.0001}, 0.5, {ease: FlxEase.sineOut});
		FlxTween.tween(authorText, {alpha: 0.0001}, 0.5, {ease: FlxEase.sineOut});
		arrows.forEach(function(spr:FlxSprite)
		{
			FlxTween.cancelTweensOf(spr.alpha);
			FlxTween.tween(spr, {alpha: 0.001}, 0.5, {ease: FlxEase.sineOut});
		});
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			canPressButtons = true;
		});
	}
}
