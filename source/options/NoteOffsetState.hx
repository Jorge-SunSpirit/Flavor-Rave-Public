package options;

import NoteSkin.NoteArray;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxStringUtil;

using StringTools;

class NoteOffsetState extends MusicBeatState
{
	var dad:Character;
	var boyfriend:Character;
	var gf:Character;

	public var camHUD:FlxCamera;
	public var camGame:FlxCamera;
	public var camOther:FlxCamera;

	var coolText:FlxText;
	var rating:FlxSprite;
	var comboNums:FlxSpriteGroup;
	var dumbTexts:FlxTypedGroup<FlxText>;

	public var grpNoteLanes:FlxTypedGroup<FlxSprite>;
	public var strumLineNotes:FlxTypedGroup<StrumNote>;

	var barPercent:Float = 0;
	var delayMin:Int = -1000;
	var delayMax:Int = 1000;
	var timeBarBG:FlxSprite;
	var timeBar:FlxBar;
	var timeTxt:FlxText;
	var beatText:Alphabet;
	var beatTween:FlxTween;

	var changeModeText:FlxText;

	var bumpers:Array<BGSprite> = [];
	var lights_2:Array<BGSprite> = [];
	var lights_4:Array<BGSprite> = [];

	override public function create()
	{
		// Cameras
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camOther = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camOther.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD, false);
		FlxG.cameras.add(camOther, false);

		FlxG.cameras.setDefaultDrawTarget(camGame, true);
		FRFadeTransition.nextCamera = camOther;
		FlxG.camera.scroll.set(120, 100);
		FlxG.camera.zoom = 0.65;

		persistentUpdate = true;
		FlxG.sound.pause();

		// STAGE
		{
			var posX:Int = -1000;
			var posY:Int = -700;
			var scale:Float = 1.5;

			var sky:BGSprite = new BGSprite('bg1/sky', posX, posY, 0, 0, 'tbd');
			sky.setGraphicSize(Std.int(sky.width * scale));
			sky.updateHitbox();
			add(sky);

			var clouds:BGSprite = new BGSprite('bg1/clouds', posX, posY, 0.15, 0.2, 'tbd');
			clouds.setGraphicSize(Std.int(clouds.width * scale));
			clouds.updateHitbox();
			add(clouds);

			var farhill:BGSprite = new BGSprite('bg1/farhill', posX, posY, 0.2, 1, 'tbd');
			farhill.setGraphicSize(Std.int(farhill.width * scale));
			farhill.updateHitbox();
			add(farhill);

			var midhill:BGSprite = new BGSprite('bg1/midhill', posX, posY, 0.25, 1, 'tbd');
			midhill.setGraphicSize(Std.int(midhill.width * scale));
			midhill.updateHitbox();
			add(midhill);

			var hillR:BGSprite = new BGSprite('bg1/hillR', posX, posY, 0.3, 1, 'tbd');
			hillR.setGraphicSize(Std.int(hillR.width * scale));
			hillR.updateHitbox();
			add(hillR);

			var hillL:BGSprite = new BGSprite('bg1/hillL', posX, posY, 0.3, 1, 'tbd');
			hillL.setGraphicSize(Std.int(hillL.width * scale));
			hillL.updateHitbox();
			add(hillL);

			var atmosphere:BGSprite = new BGSprite('bg1/atmosphere', posX, posY, 0.3, 1, 'tbd');
			atmosphere.setGraphicSize(Std.int(atmosphere.width * scale));
			atmosphere.updateHitbox();
			add(atmosphere);

			var trees:BGSprite = new BGSprite('bg1/trees', posX, posY, 0.4, 1, 'tbd');
			trees.setGraphicSize(Std.int(trees.width * scale));
			trees.updateHitbox();
			add(trees);

			var streetlamps:BGSprite = new BGSprite('bg1/streetlamps', posX, posY, 0.6, 1, 'tbd');
			streetlamps.setGraphicSize(Std.int(streetlamps.width * scale));
			streetlamps.updateHitbox();
			add(streetlamps);

			var streetlights:BGSprite = new BGSprite('bg1/streetlights', posX, posY, 0.6, 1, 'tbd');
			streetlights.setGraphicSize(Std.int(streetlights.width * scale));
			streetlights.updateHitbox();
			add(streetlights);

			var parking:BGSprite = new BGSprite('bg1/parking', posX, posY, 1, 1, 'tbd');
			parking.setGraphicSize(Std.int(parking.width * scale));
			parking.updateHitbox();
			add(parking);

			var venuespotL:BGSprite = new BGSprite('bg1/venuespotL', posX, posY, 0.45, 1, 'tbd');
			venuespotL.setGraphicSize(Std.int(venuespotL.width * scale));
			venuespotL.updateHitbox();
			add(venuespotL);

			var venuespotR:BGSprite = new BGSprite('bg1/venuespotR', posX, posY, 0.45, 1, 'tbd');
			venuespotR.setGraphicSize(Std.int(venuespotR.width * scale));
			venuespotR.updateHitbox();
			add(venuespotR);

			var venue:BGSprite = new BGSprite('bg1/venue', posX, posY, 0.5, 1, 'tbd');
			venue.setGraphicSize(Std.int(venue.width * scale));
			venue.updateHitbox();
			add(venue);

			var stans:BGSprite = new BGSprite('bg1/stans', 600, 270, 0.7, 1, [], 'tbd');
			stans.animation.addByPrefix('idle', 'Fans', 24, false);
			stans.animation.finish();
			stans.setGraphicSize(Std.int(stans.width * 0.7));
			stans.updateHitbox();
			add(stans);

			var sweettruck:BGSprite = new BGSprite('bg1/sweettruck', posX, posY, 0.7, 1, 'tbd');
			sweettruck.setGraphicSize(Std.int(sweettruck.width * scale));
			sweettruck.updateHitbox();
			add(sweettruck);

			var sweettrucklight:BGSprite = new BGSprite('bg1/sweettrucklight', posX, posY, 0.7, 1, 'tbd');
			sweettrucklight.setGraphicSize(Std.int(sweettrucklight.width * scale));
			sweettrucklight.updateHitbox();
			add(sweettrucklight);

			var sourvan:BGSprite = new BGSprite('bg1/sourvan', posX, posY, 0.8, 1, 'tbd');
			sourvan.setGraphicSize(Std.int(sourvan.width * scale));
			sourvan.updateHitbox();
			add(sourvan);

			var sourvanlight:BGSprite = new BGSprite('bg1/sourvanlight', posX, posY, 0.8, 1, 'tbd');
			sourvanlight.setGraphicSize(Std.int(sourvanlight.width * scale));
			sourvanlight.updateHitbox();
			add(sourvanlight);

			var sweetbus:BGSprite = new BGSprite('bg1/sweetbus', posX, posY, 0.8, 1, 'tbd');
			sweetbus.setGraphicSize(Std.int(sweetbus.width * scale));
			sweetbus.updateHitbox();
			add(sweetbus);

			var sweetbuslight:BGSprite = new BGSprite('bg1/sweetbuslight', posX, posY, 0.8, 1, 'tbd');
			sweetbuslight.setGraphicSize(Std.int(sweetbuslight.width * scale));
			sweetbuslight.updateHitbox();
			add(sweetbuslight);

			/*
			var kyle:BGSprite = new BGSprite('bg1/koolguykyle', 2200, 70, 0.95, 1, [], 'tbd');
			kyle.animation.addByPrefix('idle', 'kool_guy_kyle', 24, false);
			kyle.animation.finish();
			kyle.setGraphicSize(Std.int(kyle.width * 0.7));
			kyle.updateHitbox();
			add(kyle);
			*/

			var equipment:BGSprite = new BGSprite('bg1/equipment', posX, posY, 0.95, 1, 'tbd');
			equipment.setGraphicSize(Std.int(equipment.width * scale));
			equipment.updateHitbox();
			add(equipment);

			// Init lights
			bumpers = [stans, /* kyle */];
			lights_2 = [sweettrucklight, sourvanlight, sweetbuslight];
			lights_4 = [streetlights, venuespotL, venuespotR];
		}

		// Characters
		gf = new Character(570, 35, 'showman');
		gf.x += gf.positionArray[0];
		gf.y += gf.positionArray[1];
		gf.scrollFactor.set(0.95, 0.95);
		boyfriend = new Character(1020, 130, 'sweet', true);
		boyfriend.x += boyfriend.positionArray[0];
		boyfriend.y += boyfriend.positionArray[1];
		dad = new Character(-50, 100, 'sour');
		dad.x += dad.positionArray[0];
		dad.y += dad.positionArray[1];
		add(gf);
		add(boyfriend);
		add(dad);

		// Combo stuff
		grpNoteLanes = new FlxTypedGroup<FlxSprite>();
		grpNoteLanes.cameras = [camHUD];
		add(grpNoteLanes);

		coolText = new FlxText(0, 0, 0, '', 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.35;

		var ratingFolder:String = 'ratings/sweet/';

		if (ClientPrefs.noteSkin != 'Default')
		{
			var skin:NoteArray = NoteSkin.noteSkins.get(ClientPrefs.noteSkin);

			if (skin.ratings_folder != null)
			{
				if (skin.ratings_folder != '')
					ratingFolder = 'ratings/' + skin.ratings_folder + '/';
				else
					ratingFolder = '';
			}
		}

		rating = new FlxSprite().loadGraphic(Paths.image(ratingFolder + 'marvelous'));
		rating.cameras = [camHUD];
		rating.setGraphicSize(Std.int(rating.width * 0.7));
		rating.updateHitbox();
		rating.antialiasing = ClientPrefs.globalAntialiasing;
		
		add(rating);

		comboNums = new FlxSpriteGroup();
		comboNums.cameras = [camHUD];
		add(comboNums);

		var seperatedScore:Array<String> = [];
		for (i in 0...3)
		{
			seperatedScore.push("" + FlxG.random.int(0, 9));
		}
		
		for (i in 0...seperatedScore.length)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(ratingFolder + 'num' + i));
			numScore.cameras = [camHUD];
			numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			numScore.updateHitbox();
			numScore.x = (numScore.x - ((numScore.width * 0.5) * seperatedScore.length)) + (numScore.width * i);
			numScore.antialiasing = ClientPrefs.globalAntialiasing;
			comboNums.add(numScore);
		}

		strumLineNotes = new FlxTypedGroup<StrumNote>();
		strumLineNotes.cameras = [camHUD];
		add(strumLineNotes);

		// generateStaticArrows()
		for (i in 0...2)
		{
			for (j in 0...4)
			{
				var targetAlpha:Float = 1;
	
				if (i == 0 && ClientPrefs.middleScroll)
					targetAlpha = ClientPrefs.opponentStrums ? 0.35 : 0;
	
				var x:Float = ClientPrefs.middleScroll ? PlayState.STRUM_X_MIDDLESCROLL : PlayState.STRUM_X;
				var y:Float = ClientPrefs.downScroll ? FlxG.height - 150 : 50;
				var char:Character = i == 0 ? dad : boyfriend;

				var babyArrow:StrumNote = new StrumNote(x, y, j, i, char.note);
				babyArrow.downScroll = ClientPrefs.downScroll;
				babyArrow.alpha = targetAlpha;
	
				if (i == 0 && ClientPrefs.middleScroll)
				{
					babyArrow.x += 310;
	
					if (j > 1)
						babyArrow.x += FlxG.width / 2 + 25;
				}
	
				grpNoteLanes.add(babyArrow.bgLane);
				strumLineNotes.add(babyArrow);
				babyArrow.postAddedToGroup();
			}
		}

		dumbTexts = new FlxTypedGroup<FlxText>();
		dumbTexts.cameras = [camHUD];
		add(dumbTexts);
		createTexts();

		repositionCombo();

		// Note delay stuff
		
		beatText = new Alphabet(0, 0, 'Beat Hit!', true);
		beatText.scaleX = 0.6;
		beatText.scaleY = 0.6;
		beatText.x += 260;
		beatText.alpha = 0;
		beatText.acceleration.y = 250;
		beatText.visible = false;
		add(beatText);
		
		timeTxt = new FlxText(0, 600, FlxG.width, "", 32);
		timeTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeTxt.scrollFactor.set();
		timeTxt.borderSize = 2;
		timeTxt.visible = false;
		timeTxt.cameras = [camHUD];

		barPercent = ClientPrefs.noteOffset;
		updateNoteDelay();
		
		timeBarBG = new FlxSprite(0, timeTxt.y + 8).loadGraphic(Paths.image('timeBar'));
		timeBarBG.setGraphicSize(Std.int(timeBarBG.width * 1.2));
		timeBarBG.updateHitbox();
		timeBarBG.cameras = [camHUD];
		timeBarBG.screenCenter(X);
		timeBarBG.visible = false;

		timeBar = new FlxBar(0, timeBarBG.y + 4, LEFT_TO_RIGHT, Std.int(timeBarBG.width - 8), Std.int(timeBarBG.height - 8), this, 'barPercent', delayMin, delayMax);
		timeBar.scrollFactor.set();
		timeBar.screenCenter(X);
		timeBar.createFilledBar(0xFF000000, 0xFFFFFFFF);
		timeBar.numDivisions = 800; //How much lag this causes?? Should i tone it down to idk, 400 or 200?
		timeBar.visible = false;
		timeBar.cameras = [camHUD];

		add(timeBarBG);
		add(timeBar);
		add(timeTxt);

		///////////////////////

		var blackBox:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 40, FlxColor.BLACK);
		blackBox.scrollFactor.set();
		blackBox.alpha = 0.6;
		blackBox.cameras = [camHUD];
		add(blackBox);

		changeModeText = new FlxText(0, 4, FlxG.width, "", 32);
		changeModeText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER);
		changeModeText.scrollFactor.set();
		changeModeText.cameras = [camHUD];
		add(changeModeText);
		updateMode();

		Conductor.bpm = 128.0;
		FlxG.sound.playMusic(Paths.music('offsetSong'), 1, true);

		super.create();
	}

	var holdTime:Float = 0;
	var onComboMenu:Bool = true;
	var holdingObjectType:Null<Bool> = null;

	var startMousePos:FlxPoint = new FlxPoint();
	var startComboOffset:FlxPoint = new FlxPoint();

	override public function update(elapsed:Float)
	{
		for (light in lights_2)
		{
			light.alpha = light.alpha - ((Conductor.crochet / 1000) * elapsed * 2);
		}

		for (light in lights_4)
		{
			light.alpha = light.alpha - ((Conductor.crochet / 1000) * elapsed * 2);
		}

		var addNum:Int = 1;
		if(FlxG.keys.pressed.SHIFT) addNum = 10;

		if(onComboMenu)
		{
			var controlArray:Array<Bool> = [
				FlxG.keys.justPressed.LEFT,
				FlxG.keys.justPressed.RIGHT,
				FlxG.keys.justPressed.UP,
				FlxG.keys.justPressed.DOWN,
			
				FlxG.keys.justPressed.A,
				FlxG.keys.justPressed.D,
				FlxG.keys.justPressed.W,
				FlxG.keys.justPressed.S
			];

			if(controlArray.contains(true))
			{
				for (i in 0...controlArray.length)
				{
					if(controlArray[i])
					{
						switch(i)
						{
							case 0:
								ClientPrefs.comboOffset[0] -= addNum;
							case 1:
								ClientPrefs.comboOffset[0] += addNum;
							case 2:
								ClientPrefs.comboOffset[1] += addNum;
							case 3:
								ClientPrefs.comboOffset[1] -= addNum;
							case 4:
								ClientPrefs.comboOffset[2] -= addNum;
							case 5:
								ClientPrefs.comboOffset[2] += addNum;
							case 6:
								ClientPrefs.comboOffset[3] += addNum;
							case 7:
								ClientPrefs.comboOffset[3] -= addNum;
						}
					}
				}
				repositionCombo();
			}

			// probably there's a better way to do this but, oh well.
			if (FlxG.mouse.justPressed)
			{
				holdingObjectType = null;
				FlxG.mouse.getScreenPosition(camHUD, startMousePos);
				if (startMousePos.x - comboNums.x >= 0 && startMousePos.x - comboNums.x <= comboNums.width &&
					startMousePos.y - comboNums.y >= 0 && startMousePos.y - comboNums.y <= comboNums.height)
				{
					holdingObjectType = true;
					startComboOffset.x = ClientPrefs.comboOffset[2];
					startComboOffset.y = ClientPrefs.comboOffset[3];
					//trace('yo bro');
				}
				else if (startMousePos.x - rating.x >= 0 && startMousePos.x - rating.x <= rating.width &&
						 startMousePos.y - rating.y >= 0 && startMousePos.y - rating.y <= rating.height)
				{
					holdingObjectType = false;
					startComboOffset.x = ClientPrefs.comboOffset[0];
					startComboOffset.y = ClientPrefs.comboOffset[1];
					//trace('heya');
				}
			}
			if(FlxG.mouse.justReleased) {
				holdingObjectType = null;
				//trace('dead');
			}

			if(holdingObjectType != null)
			{
				if(FlxG.mouse.justMoved)
				{
					var mousePos:FlxPoint = FlxG.mouse.getScreenPosition(camHUD);
					var addNum:Int = holdingObjectType ? 2 : 0;
					ClientPrefs.comboOffset[addNum + 0] = Math.round((mousePos.x - startMousePos.x) + startComboOffset.x);
					ClientPrefs.comboOffset[addNum + 1] = -Math.round((mousePos.y - startMousePos.y) - startComboOffset.y);
					repositionCombo();
				}
			}

			if(controls.RESET)
			{
				for (i in 0...ClientPrefs.comboOffset.length)
				{
					ClientPrefs.comboOffset[i] = 0;
				}
				repositionCombo();
			}
		}
		else
		{
			if(controls.UI_LEFT_P)
			{
				barPercent = Math.max(delayMin, Math.min(ClientPrefs.noteOffset - 1, delayMax));
				updateNoteDelay();
			}
			else if(controls.UI_RIGHT_P)
			{
				barPercent = Math.max(delayMin, Math.min(ClientPrefs.noteOffset + 1, delayMax));
				updateNoteDelay();
			}

			var mult:Int = 1;
			if(controls.UI_LEFT || controls.UI_RIGHT)
			{
				holdTime += elapsed;
				if(controls.UI_LEFT) mult = -1;
			}

			if(controls.UI_LEFT_R || controls.UI_RIGHT_R) holdTime = 0;

			if(holdTime > 0.5)
			{
				barPercent += 100 * elapsed * mult;
				barPercent = Math.max(delayMin, Math.min(barPercent, delayMax));
				updateNoteDelay();
			}

			if(controls.RESET)
			{
				holdTime = 0;
				barPercent = 0;
				updateNoteDelay();
			}
		}

		if(controls.ACCEPT)
		{
			onComboMenu = !onComboMenu;
			updateMode();
		}

		if(controls.BACK)
		{
			if(zoomTween != null) zoomTween.cancel();
			if(beatTween != null) beatTween.cancel();

			persistentUpdate = false;
			FRFadeTransition.nextCamera = camOther;
			MusicBeatState.switchState(new OptionsState());

			if (OptionsState.whichState == 'playstate') FlxG.sound.playMusic(Paths.music('110th-street'));
			else FlxG.sound.playMusic(Paths.music(ClientPrefs.mainmenuMusic));

			FlxG.mouse.visible = false;
		}

		Conductor.songPosition = FlxG.sound.music.time;
		super.update(elapsed);
	}

	var zoomTween:FlxTween;
	var lastBeatHit:Int = -1;
	override public function beatHit()
	{
		super.beatHit();

		if(lastBeatHit == curBeat)
		{
			return;
		}

		if (curBeat % 2 == 0)
		{
			dad.dance();
			boyfriend.dance();
			gf.dance();

			for (light in lights_2)
			{
				light.alpha = 1;
			}

			for (bump in bumpers)
			{
				bump.animation.play('idle');
			}
		}
		
		if (curBeat % 4 == 2)
		{
			FlxG.camera.zoom = 0.7475;

			if(zoomTween != null) zoomTween.cancel();
			zoomTween = FlxTween.tween(FlxG.camera, {zoom: 0.65}, 1, {ease: FlxEase.circOut, onComplete: function(twn:FlxTween)
				{
					zoomTween = null;
				}
			});

			beatText.alpha = 1;
			beatText.y = 320;
			beatText.velocity.y = -150;
			if(beatTween != null) beatTween.cancel();
			beatTween = FlxTween.tween(beatText, {alpha: 0}, 1, {ease: FlxEase.sineIn, onComplete: function(twn:FlxTween)
				{
					beatTween = null;
				}
			});

			for (light in lights_4)
			{
				light.alpha = 1;
			}
		}

		lastBeatHit = curBeat;
	}

	function repositionCombo()
	{
		rating.screenCenter();
		rating.x = coolText.x - 40 + ClientPrefs.comboOffset[0];
		rating.y -= 60 + ClientPrefs.comboOffset[1];

		comboNums.screenCenter();
		comboNums.x = coolText.x + ClientPrefs.comboOffset[2];
		comboNums.y += 80 - ClientPrefs.comboOffset[3];
		reloadTexts();
	}

	function createTexts()
	{
		for (i in 0...4)
		{
			var text:FlxText = new FlxText(10, 48 + (i * 30), 0, '', 24);
			text.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			text.scrollFactor.set();
			text.borderSize = 2;
			dumbTexts.add(text);
			text.cameras = [camHUD];

			if(i > 1)
			{
				text.y += 24;
			}
		}
	}

	function reloadTexts()
	{
		for (i in 0...dumbTexts.length)
		{
			switch(i)
			{
				case 0: dumbTexts.members[i].text = 'Rating Offset:';
				case 1: dumbTexts.members[i].text = '[' + ClientPrefs.comboOffset[0] + ', ' + ClientPrefs.comboOffset[1] + ']';
				case 2: dumbTexts.members[i].text = 'Numbers Offset:';
				case 3: dumbTexts.members[i].text = '[' + ClientPrefs.comboOffset[2] + ', ' + ClientPrefs.comboOffset[3] + ']';
			}
		}
	}

	function updateNoteDelay()
	{
		ClientPrefs.noteOffset = Math.round(barPercent);
		timeTxt.text = 'Current offset: ' + Math.floor(barPercent) + ' ms';
	}

	function updateMode()
	{
		grpNoteLanes.visible = onComboMenu;
		strumLineNotes.visible = onComboMenu;
		rating.visible = onComboMenu;
		comboNums.visible = onComboMenu;
		dumbTexts.visible = onComboMenu;
		
		timeBarBG.visible = !onComboMenu;
		timeBar.visible = !onComboMenu;
		timeTxt.visible = !onComboMenu;
		beatText.visible = !onComboMenu;

		if(onComboMenu)
			changeModeText.text = '< Combo Offset (Press Accept to Switch) >';
		else
			changeModeText.text = '< Note/Beat Delay (Press Accept to Switch) >';

		changeModeText.text = changeModeText.text.toUpperCase();
		FlxG.mouse.visible = onComboMenu;
	}
}
