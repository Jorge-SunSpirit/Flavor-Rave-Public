package;

import animateatlas.AtlasFrameMaker;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxDirectionFlags;
import flixel.util.FlxSort;
import NoteSkin;
import Section.SwagSection;
import haxe.Json;
import openfl.utils.Assets;

#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

typedef CharacterFile = {
	var animations:Array<AnimArray>;
	var image:String;
	var scale:Float;
	var sing_duration:Float;
	var shadow_offset:Float;
	var charaFloat:Bool;
	var healthicon:String;

	var position:Array<Float>;
	var camera_position:Array<Float>;

	var noteskin:String;
	
	var musicNoteOffset:Array<Float>;

	var flip_x:Bool;
	var no_antialiasing:Bool;
	var healthbar_colors:Array<Int>;
	var healthbar_image:String;
}

typedef AnimArray = {
	var anim:String;
	var name:String;
	var fps:Int;
	var loop:Bool;
	var indices:Array<Int>;
	var offsets:Array<Int>;
}

class Character extends FlxSprite
{
	public var debugMode:Bool = false;
	public var animOffsets:Map<String, Array<Dynamic>>;

	public var isPlayer:Bool = false;
	public var curCharacter:String = DEFAULT_CHARACTER;

	var spriteType = "sparrow";
	public var colorTween:FlxTween;
	public var holding:Bool = false;
	public var singing:Bool = false;
	public var holdTimer:Float = 0;
	public var heyTimer:Float = 0;
	public var specialAnim:Bool = false;
	public var animationNotes:Array<Dynamic> = [];
	public var stunned:Bool = false;
	public var beingControlled:Bool = false;
	public var singDuration:Float = 4; //Multiplier of how long a character holds the sing pose
	public var idleSuffix:String = '';
	public var danceIdle:Bool = false; //Character use "danceLeft" and "danceRight" instead of "idle"
	public var skipDance:Bool = false;
	public var startedDeath:Bool = false;
	public var missRecolor:Bool = true;

	public var allowTrail:Bool = false; //Needed to do some stuff

	public var healthIcon:String = 'face';
	public var animationsArray:Array<AnimArray> = [];

	public var positionArray:Array<Float> = [0, 0];
	public var cameraPosition:Array<Float> = [0, 0];
	var singAnimations:Array<String> = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];

	public var hasMissAnimations:Bool = false;

	// https://github.com/ThatRozebudDude/FPS-Plus-Public/pull/11
	public var initFacing:FlxDirectionFlags = RIGHT;
	var initWidth:Float;

	//Used on Character Editor
	public var imageFile:String = '';
	public var jsonScale:Float = 1;
	public var noAntialiasing:Bool = false;
	public var originalFlipX:Bool = false;
	public var healthColorArray:Array<Int> = [255, 0, 0];
	public var healthImage:FlxGraphic = null;

	public var note:String = 'NOTE_assets';
	//sprite, x, y, scale, alpha
	public var noteSplash:Array<Dynamic> = ['noteSplashes', 20, 0, 1, 0.6];
	public var ratings_folder:String = '';
	public var musicNoteOffset:Array<Float> = [0, 0];

	private var shadowOffset:Float = 50;
	public var hasShadow:Bool = false;
	public var shadowDarkness:Float = 0.5;
	public var float:Bool;
	var floatshit:Float = 0;

	public static var DEFAULT_CHARACTER:String = 'bf'; //In case a character is missing, it will use BF on its place
	public function new(x:Float, y:Float, ?character:String = 'bf', ?isPlayer:Bool = false)
	{
		super(x, y);

		#if (haxe >= "4.0.0")
		animOffsets = new Map();
		#else
		animOffsets = new Map<String, Array<Dynamic>>();
		#end
		curCharacter = character;
		this.isPlayer = isPlayer;
		antialiasing = ClientPrefs.globalAntialiasing;
		var library:String = null;
		switch (curCharacter)
		{
			//case 'your character name in case you want to hardcode them instead':

			default:
				var characterPath:String = 'characters/' + curCharacter + '.json';

				#if MODS_ALLOWED
				var path:String = Paths.modFolders(characterPath);
				if (!FileSystem.exists(path)) {
					path = Paths.getPreloadPath(characterPath);
				}

				if (!FileSystem.exists(path))
				#else
				var path:String = Paths.getPreloadPath(characterPath);
				if (!Assets.exists(path))
				#end
				{
					path = Paths.getPreloadPath('characters/' + DEFAULT_CHARACTER + '.json'); //If a character couldn't be found, change him to BF just to prevent a crash
				}

				#if MODS_ALLOWED
				var rawJson = File.getContent(path);
				#else
				var rawJson = Assets.getText(path);
				#end

				var json:CharacterFile = cast Json.parse(rawJson);
				//sparrow
				//packer
				//texture
				#if MODS_ALLOWED
				var modTxtToFind:String = Paths.modsTxt(json.image);
				var txtToFind:String = Paths.getPath('images/' + json.image + '.txt', TEXT);
				
				//var modTextureToFind:String = Paths.modFolders("images/"+json.image);
				//var textureToFind:String = Paths.getPath('images/' + json.image, new AssetType();
				
				if (FileSystem.exists(modTxtToFind) || FileSystem.exists(txtToFind) || Assets.exists(txtToFind))
				#else
				if (Assets.exists(Paths.getPath('images/' + json.image + '.txt', TEXT)))
				#end
				{
					spriteType = "packer";
				}
				
				#if MODS_ALLOWED
				var modAnimToFind:String = Paths.modFolders('images/' + json.image + '/Animation.json');
				var animToFind:String = Paths.getPath('images/' + json.image + '/Animation.json', TEXT);
				
				//var modTextureToFind:String = Paths.modFolders("images/"+json.image);
				//var textureToFind:String = Paths.getPath('images/' + json.image, new AssetType();
				
				if (FileSystem.exists(modAnimToFind) || FileSystem.exists(animToFind) || Assets.exists(animToFind))
				#else
				if (Assets.exists(Paths.getPath('images/' + json.image + '/Animation.json', TEXT)))
				#end
				{
					spriteType = "texture";
				}

				switch (spriteType){
					
					case "packer":
						frames = Paths.getPackerAtlas(json.image);
					
					case "sparrow":
						frames = Paths.getSparrowAtlas(json.image);
					
					case "texture":
						frames = AtlasFrameMaker.construct(json.image);
				}
				imageFile = json.image;

				if(json.scale != 1) {
					jsonScale = json.scale;
					setGraphicSize(Std.int(width * jsonScale));
					updateHitbox();
				}

				positionArray = json.position;
				cameraPosition = json.camera_position;

				healthIcon = json.healthicon;
				singDuration = json.sing_duration;
				shadowOffset = json.shadow_offset;
				float = json.charaFloat;

				if (!debugMode)
					initFacing = !!json.flip_x ? LEFT : RIGHT;
				else
					flipX = !!json.flip_x;

				if(json.no_antialiasing) {
					antialiasing = false;
					noAntialiasing = true;
				}

				if (PlayState.instance != null)
				{
					if (ClientPrefs.noteSkin != 'Default' && (this.isPlayer && !PlayState.instance.opponentPlay || !this.isPlayer && PlayState.instance.opponentPlay))
					{
						var skin:NoteArray = NoteSkin.noteSkins.get(ClientPrefs.noteSkin);
						note = skin.note;
						noteSplash = skin.noteSplash;
						ratings_folder = skin.ratings_folder;
					}
					else if (json.noteskin != null)
					{
						var skin:NoteArray = NoteSkin.noteSkins.get(json.noteskin);
						note = skin.note;
						noteSplash = skin.noteSplash;
						ratings_folder = skin.ratings_folder;
					}
				}
				else if (json.noteskin != null)
				{
					var isDefault:Bool = ClientPrefs.noteSkin == 'Default';
					var skin:NoteArray = NoteSkin.noteSkins.get((!isDefault && isPlayer) ? ClientPrefs.noteSkin : json.noteskin);
					note = skin.note;
					noteSplash = skin.noteSplash;
					ratings_folder = skin.ratings_folder;
				}

				if(json.healthbar_colors != null && json.healthbar_colors.length > 2)
					healthColorArray = json.healthbar_colors;

				if(json.healthbar_image != null && json.healthbar_image.length > 2)
					healthImage = Paths.image('health/' + json.healthbar_image);

				antialiasing = !noAntialiasing;
				if(!ClientPrefs.globalAntialiasing) antialiasing = false;
				
				if(json.musicNoteOffset != null && json.musicNoteOffset.length > 1)
					musicNoteOffset = json.musicNoteOffset;

				animationsArray = json.animations;
				if(animationsArray != null && animationsArray.length > 0) {
					for (anim in animationsArray) {
						var animAnim:String = '' + anim.anim;
						var animName:String = '' + anim.name;
						var animFps:Int = anim.fps;
						var animLoop:Bool = !!anim.loop; //Bruh
						var animIndices:Array<Int> = anim.indices;
						if(animIndices != null && animIndices.length > 0) {
							animation.addByIndices(animAnim, animName, animIndices, "", animFps, animLoop);
						} else {
							animation.addByPrefix(animAnim, animName, animFps, animLoop);
						}

						if(anim.offsets != null && anim.offsets.length > 1) {
							var offsetX:Float = anim.offsets[0] / (debugMode ? 1 : json.scale);
							var offsetY:Float = anim.offsets[1] / (debugMode ? 1 : json.scale);
		
							addOffset(anim.anim, offsetX, offsetY);
						}
					}
				} else {
					quickAnimAdd('idle', 'BF idle dance');
				}
				//trace('Loaded file to character ' + curCharacter);
		}

		if (!debugMode)
		{
			initWidth = frameWidth;
			setFacingFlip((initFacing == LEFT ? RIGHT : LEFT), true, false);
			facing = (isPlayer ? LEFT : RIGHT);
		}
		else
		{
			originalFlipX = flipX;
		}

		// good fucking lord why was this a one liner
		if (animOffsets.exists('singLEFTmiss') || animOffsets.exists('singDOWNmiss') ||
			animOffsets.exists('singUPmiss') || animOffsets.exists('singRIGHTmiss'))
			hasMissAnimations = true;

		recalculateDanceIdle();
		dance();
		animation.finish();

		if (!debugMode && facing != initFacing)
		{
			if (animation.getByName('singRIGHT') != null)
			{
				var oldRight = animation.getByName('singRIGHT').frames;
				var oldOffset = animOffsets['singRIGHT'];
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animOffsets['singRIGHT'] = animOffsets['singLEFT'];
				animation.getByName('singLEFT').frames = oldRight;
				animOffsets['singLEFT'] = oldOffset;
			}

			// IF THEY HAVE MISS ANIMATIONS??
			if (animation.getByName('singRIGHTmiss') != null)
			{
				var oldMiss = animation.getByName('singRIGHTmiss').frames;
				var oldOffset = animOffsets['singRIGHTmiss'];
				animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
				animOffsets['singRIGHTmiss'] = animOffsets['singLEFTmiss'];
				animation.getByName('singLEFTmiss').frames = oldMiss;
				animOffsets['singLEFTmiss'] = oldOffset;
			}

			if (animation.getByName('singRIGHT-alt') != null)
			{
				var oldRight = animation.getByName('singRIGHT-alt').frames;
				var oldOffset = animOffsets['singRIGHT-alt'];
				animation.getByName('singRIGHT-alt').frames = animation.getByName('singLEFT-alt').frames;
				animOffsets['singRIGHT-alt'] = animOffsets['singLEFT-alt'];
				animation.getByName('singLEFT-alt').frames = oldRight;
				animOffsets['singLEFT-alt'] = oldOffset;
			}
		}
	}

	public override function draw():Void
	{
		if (!debugMode && hasShadow)
		{
			var origY = y;
			var origAlpha = alpha;
			var origColor = color;

			y += height + offset.y + shadowOffset;
			flipY = !flipY;
			alpha = shadowDarkness;
			color = FlxColor.BLACK;

			super.draw();

			y = origY;
			alpha = origAlpha;
			color = origColor;
			flipY = !flipY;
		}

		super.draw();
	}

	override function update(elapsed:Float)
	{
		floatshit += 0.03 / FramerateTools.timeMultiplier();
		if (!debugMode && float)
			y += Math.sin(floatshit) / FramerateTools.timeMultiplier();


		if(!debugMode && animation.curAnim != null)
		{
			if(heyTimer > 0)
			{
				heyTimer -= elapsed;
				if(heyTimer <= 0)
				{
					if(specialAnim && animation.curAnim.name == 'hey' || animation.curAnim.name == 'cheer')
					{
						specialAnim = false;
						dance();
					}
					heyTimer = 0;
				}
			} else if(specialAnim && animation.curAnim.finished)
			{
				specialAnim = false;
				dance();
			}

			singing = animation.curAnim.name.startsWith("sing") || animation.curAnim.name.startsWith("hold");

			if (beingControlled)
			{
				if (singing)
				{
					holdTimer += elapsed;
				}
				else
					holdTimer = 0;
	
				if (animation.curAnim.name.endsWith('miss') && animation.curAnim.finished && !debugMode)
				{
					dance(true, true);//WHY THE HELL WAS IT TRYING TO GO TO IDLE???????????
				}
	
				if (animation.curAnim.name == 'firstDeath' && animation.curAnim.finished && startedDeath)
				{
					playAnim('deathLoop');
				}
			}
			else
			{
				if (singing)
				{
					holdTimer += elapsed;
				}

				if (holdTimer >= Conductor.stepCrochet * 0.0011 * singDuration)
				{
					dance();
					holdTimer = 0;
				}
			}

			if(animation.curAnim.finished && animation.getByName(animation.curAnim.name + '-loop') != null)
			{
				playAnim(animation.curAnim.name + '-loop');
			}
		}
		
		super.update(elapsed);

		if (!debugMode && animation.curAnim != null) {
			// ANDROMEDAAAAAAAAAAAAAAAAAAAAAAA
			var name = animation.curAnim.name;
			if (name.startsWith("hold")) {
				if (name.endsWith("start") && animation.curAnim.finished) {
					var newName = name.substring(0, name.length - 5);
					var singName = "sing" + name.substring(3, name.length - 5);
					if (animation.getByName(newName) != null) {
						playAnim(newName, true);
					}
					else {
						playAnim(singName, true);
					}
				}
			}
			else if (holding) { // Pause on first frame when holding
				animation.curAnim.curFrame = 0;
			}
		}
	}

	public var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance(force:Bool = false, postmiss:Bool = false)
	{
		if (!debugMode && !skipDance && !specialAnim)
		{
			holding = false;

			if(danceIdle)
			{
				danced = !danced;

				if (danced)
					playAnim('danceRight' + idleSuffix, force, false, postmiss ? 10 : 0);
				else
					playAnim('danceLeft' + idleSuffix, force, false, postmiss ? 10 : 0);
			}
			else if(animation.getByName('idle' + idleSuffix) != null) {
					playAnim('idle' + idleSuffix, force, false, postmiss ? 10 : 0);
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		specialAnim = false;
		if (!hasMissAnimations && missRecolor)	color = 0xFFFFFF;
		
		if (AnimName.endsWith('alt') && animation.getByName(AnimName) == null)
			AnimName = AnimName.split('-')[0];

		if (!hasMissAnimations && AnimName.endsWith('miss') && animation.getByName(AnimName) == null)
		{
			AnimName = AnimName.split('miss')[0];
			if (missRecolor) color = 0x8282FF;
		}

		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			var offsetX:Float = daOffset[0] * (debugMode ? 1 : scale.x);
			var offsetY:Float = daOffset[1] * (debugMode ? 1 : scale.y);

			if (debugMode || spriteType == "packer")
				offset.set(offsetX, offsetY);
			else
				offset.set((facing != initFacing ? -1 : 1) * offsetX + (facing != initFacing ? frameWidth - initWidth : 0), offsetY);
		}
		else
		{
			offset.set();
		}

		if (curCharacter.startsWith('gf'))
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	function sortAnims(Obj1:Array<Dynamic>, Obj2:Array<Dynamic>):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1[0], Obj2[0]);
	}

	public var danceEveryNumBeats:Int = 2;
	private var settingCharacterUp:Bool = true;
	public function recalculateDanceIdle() {
		var lastDanceIdle:Bool = danceIdle;
		danceIdle = (animation.getByName('danceLeft' + idleSuffix) != null && animation.getByName('danceRight' + idleSuffix) != null);

		if(settingCharacterUp)
		{
			danceEveryNumBeats = (danceIdle ? 1 : 2);
		}
		else if(lastDanceIdle != danceIdle)
		{
			var calc:Float = danceEveryNumBeats;
			if(danceIdle)
				calc /= 2;
			else
				calc *= 2;

			danceEveryNumBeats = Math.round(Math.max(calc, 1));
		}
		settingCharacterUp = false;
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}

	public function quickAnimAdd(name:String, anim:String)
	{
		animation.addByPrefix(name, anim, 24, false);
	}
}
