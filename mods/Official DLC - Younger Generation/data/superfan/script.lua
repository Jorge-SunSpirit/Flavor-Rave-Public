local alpha = 0.0001;
local spawnflyingcreatures = false;
local gummySpeed = 1300;
local hypermodeGummy = false;

function onCreate()
	--Preload Sprites
	summonbird()
	summonbutterfly()
	spawnDing()

	makeLuaSprite('blackdrama', '', -100, -100);
    makeGraphic('blackdrama', 1280*2, 720*2, '000000');
    setScrollFactor('blackdrama', 0, 0);
    screenCenter('blackdrama');
	addLuaSprite('blackdrama', false);
	setProperty('blackdrama.alpha', 0.0001);
	
	makeAnimatedLuaSprite('gummyrunnu', 'stages/superfan-extras/GummyRunning', -700, 185);
	addAnimationByPrefix('gummyrunnu', 'runnormal', 'GummyRun', 24, true);
	addAnimationByPrefix('gummyrunnu', 'GummyFaster', 'FASTER', 24, true);
	playAnim('gummyrunnu', 'runnormal');
	addLuaSprite('gummyrunnu', false);
	setScrollFactor('gummyrunnu', 1, 1);
	scaleObject('gummyrunnu', 0.8, 0.8);
	setProperty('gummyrunnu.alpha', 0.0001);
	
	--1280
	makeAnimatedLuaSprite('gumXylo', 'stages/superfan-extras/XyloTime', 0, 1280);
	addAnimationByIndices('gumXylo', 'note1', 'XyloTime', "0,1,2,3,4,5", 30);
	addAnimationByIndices('gumXylo', 'note2', 'XyloTime', "6,7,8,9,10,11", 30);
	playAnim('gumXylo', 'note2');
	addLuaSprite('gumXylo', true);
	setObjectCamera('gumXylo', 'effect');
	scaleObject('gumXylo', 1.1, 1.1);
	screenCenter('gumXylo', 'x');
	setProperty('gumXylo.alpha', 0.0001);
	runHaxeCode([[
		var closeupscroll:FlxBackdrop = new FlxBackdrop(Paths.image('stages/superfan-extras/closeupscroll'), 0x11);
		closeupscroll.antialiasing = ClientPrefs.globalAntialiasing;
		game.insert(game.members.indexOf(game.getLuaObject('doodlebg')) + 1, closeupscroll);
		setVar('closeupscroll', closeupscroll);
	]]);

	setScrollFactor('closeupscroll', 0.1, 0.1);
	scaleObject('closeupscroll', 1.1, 1.1);
	setProperty('closeupscroll.velocity.x', -380);
	setProperty('closeupscroll.velocity.y', -50);
	setProperty('closeupscroll.alpha', 0.0001);
	
	makeLuaSprite('intropad', 'stages/superfan-extras/intropad', -0, -0);
	setScrollFactor('intropad', 0, 0);
	addLuaSprite('intropad', false);
	setObjectCamera('intropad', 'effect');
    screenCenter('intropad');
	
	makeAnimatedLuaSprite('gummyintro', 'stages/superfan-extras/IntroAnim', 0, 0);
	addAnimationByPrefix('gummyintro', 'idle', 'IntroAnim', 24, false);
	setScrollFactor('gummyintro', 0, 0);
	addLuaSprite('gummyintro', false);
	setObjectCamera('gummyintro', 'effect');
	scaleObject('gummyintro', 0.95, 0.95);
	setProperty('gummyintro.alpha', 0.0001);
    screenCenter('gummyintro');

	makeAnimatedLuaSprite('gummyyay', 'stages/superfan-extras/GummyYay', 161, 50);
	addAnimationByPrefix('gummyyay', 'idle', 'GummyYay', 24, false);
	setScrollFactor('gummyyay', 0, 0);
	addLuaSprite('gummyyay', false);
	setObjectCamera('gummyyay', 'effect');
	setProperty('gummyyay.alpha', 0.0001);

	makeAnimatedLuaSprite('smokyyay', 'stages/superfan-extras/SmokyYay', 502, 56);
	addAnimationByPrefix('smokyyay', 'idle', 'SmokyYay', 24, false);
	setScrollFactor('smokyyay', 0, 0);
	addLuaSprite('smokyyay', false);
	setObjectCamera('smokyyay', 'effect');
	setProperty('smokyyay.alpha', 0.0001);
	
	makeAnimatedLuaSprite('doodletime', 'stages/superfan-extras/PaintTransition', 0, 0);
	addAnimationByPrefix('doodletime', 'idle', 'PaintTransition', 30, false);
	setScrollFactor('doodletime', 0, 0);
	addLuaSprite('doodletime', false);
	setObjectCamera('doodletime', 'effect');
	setProperty('doodletime.alpha', 0.0001);
    screenCenter('doodletime');
	
	makeLuaSprite('endart', 'stages/superfan-extras/endingart', 0, 0);
	setScrollFactor('endart', 0, 0);
	scaleObject('endart', 1, 1);
	addLuaSprite('endart', true);
	setProperty('endart.alpha', 0.0001);
	setObjectCamera('endart', 'effect');
	
	makeLuaSprite('black', '', -100, -100);
    makeGraphic('black', 1280*2, 720*2, '000000');
    setScrollFactor('black', 0, 0);
    screenCenter('black');
	setObjectCamera('black', 'effect')
	addLuaSprite('black', true);
	
	makeLuaSprite('whitehueh', 'dreamcast/art_BG/whitehueh', 0, 0);
	setScrollFactor('whitehueh', 0, 0);
	addLuaSprite('whitehueh', true);
	setObjectCamera('whitehueh', 'effect');
	setProperty('whitehueh.alpha', 0.0001);
	
end

function onCreatePost()
	addCharacterToList('smoky-sf-closeup', 'boyfriend');
	setObjectOrder('gummyrunnu', getObjectOrder('boyfriendGroup')-1);
end

function centercam(num)
	if num == '1' then
		setProperty('camFollow.x', 685);
		setProperty('camFollow.y', 252);
		setProperty('isCameraOnForcedPos', true);
	end
	if num == '2' then
		setProperty('isCameraOnForcedPos', false);
	end
end

function onStepHit()
	if curStep == 1 then
		setProperty('black.alpha', 0.0001);
	end
	if curStep == 8 then
		playAnim('gummyintro', 'idle');
		setProperty('gummyintro.alpha', 1);
	end
	if curStep == 58 then
		doTweenAlpha('gummyintro', 'gummyintro', 0.0001, 0.4);
	end
	if curStep == 112 then
		doTweenAlpha('intropad', 'intropad', 0.0001, 1);
	end
	
	if curStep == 768 then
		--Up close sprites
		setProperty('blackdrama.alpha', 0.5);
		triggerEvent('Change Character','bf','smoky-sf-closeup');
		setProperty('defaultCamZoom', 1);
		setProperty('camGame.zoom', 1);
		setProperty('camera.target.x', 482);
		setProperty('camera.target.y', 252);
		setProperty('camFollow.x', 482);
		setProperty('camFollow.y', 252);
		
		setProperty('boyfriend.x', 200);
		setProperty('boyfriend.y', 0);
		setProperty('dadGroup.y', 5000);	
	end
	if curStep == 832 then
		setProperty('gummyrunnu.velocity.x', gummySpeed);
		setProperty('gummyrunnu.alpha', 1);
	end
	if curStep == 1034 then
		doTweenAlpha('whitehueh', 'whitehueh', 1, 1.55);
	end
	if curStep == 1052 then
		doTweenAlpha('whitehueh', 'whitehueh', 0.0001, 0.7);
		setProperty('blackdrama.alpha', 0.0001);
		doTweenY('gumXylo', 'gumXylo', 170, 1.2, "quadOut");
		setProperty('gumXylo.alpha', 1);
		setProperty('closeupscroll.alpha', 1);
		gummySpeed = 3400;
		if not getProperty('gummyrunnu.flipX') then
			setProperty('gummyrunnu.velocity.x', gummySpeed);
		else
			setProperty('gummyrunnu.velocity.x', gummySpeed * -1);
		end
		playAnim('gummyrunnu', 'GummyFaster');
		hypermodeGummy = true;
	end
	if curStep == 1124 then
		doTweenY('gumXylo', 'gumXylo', 1280, 1.2, "quadinOut");
	end
	if curStep == 1180 then
		doTweenY('gumXylo', 'gumXylo', 170, 1.2, "quadOut");
	end
	if curStep == 1312 then
		--zoom out
		hypermodeGummy = false;
		setProperty('closeupscroll.alpha', 0.0001);
		triggerEvent('Change Character','bf','smoky');
		setProperty('dadGroup.y', 75);
		setProperty('defaultCamZoom', 0.8);
		setProperty('gummyrunnu.velocity.x', 0);
		setProperty('gummyrunnu.alpha', 0);
		setProperty('gumXylo.alpha', 0);
		triggerEvent('Clear Particles','','');
	end
	if curStep == 1440 then
		playAnim('doodletime', 'idle');
		setProperty('doodletime.alpha', 1);
	end
	if curStep == 1456 then
		setProperty('intropad.alpha', 1);
		doTweenX('gummyyay', 'gummyyay', 121, 4);
		doTweenX('smokyyay', 'smokyyay', 542, 4);
		setProperty('gummyyay.alpha', 1);
		setProperty('smokyyay.alpha', 1);
		setProperty('doodletime.alpha', 0.0001);
	end
	if curStep == 1472 then
		setProperty('gummyyay.alpha', 0.0001);
		setProperty('smokyyay.alpha', 0.0001);
		setProperty('intropad.alpha', 0.0001);
		alpha = 1;
		spawnflyingcreatures = true;
		setProperty('doodlebg.alpha', 1);
	end
	if curStep == 1856 then
		alpha = 0.0001;
		spawnflyingcreatures = false;
		setProperty('doodlebg.alpha', 0.0001);
	end
	
	if curStep == 2112 then
		setProperty('endart.alpha', 1);
		doTweenAlpha('camHUD', 'camHUD', 0, 2, 'circout')
	end
	
	if getRandomBool(10) and spawnflyingcreatures then
		summonrandThingie()
	end
	
	if hypermodeGummy and curStep % 1 == 0 then
		spawnthetrail();
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'papergone' then
		playAnim('paperburn', 'idle');
	end
end

function opponentNoteHit(membersIndex, noteData, noteType, isSustainNote)
	if not isSustainNote and not opponentPlay then
		if getProperty('gumXylo.animation.curAnim.name') == 'note1' then
			playAnim('gumXylo', 'note2');
		else
			playAnim('gumXylo', 'note1');
		end
		if hypermodeGummy then
			spawnDing()
		end
	end
end

function goodNoteHit(membersIndex, noteData, noteType, isSustainNote)
	if not isSustainNote and opponentPlay then
		if getProperty('gumXylo.animation.curAnim.name') == 'note1' then
			playAnim('gumXylo', 'note2');
		else
			playAnim('gumXylo', 'note1');
		end
		if hypermodeGummy then
			spawnDing()
		end
	end
end

function summonrandThingie()
	if getRandomBool(50) then 
		summonbutterfly()
	else
		summonbird()
	end
end

function onUpdate()
	if getProperty('gummyrunnu.x') > 1300 and not getProperty('gummyrunnu.flipX') then
		flipGummy();
	end
	if getProperty('gummyrunnu.x') < -800 and getProperty('gummyrunnu.flipX') then
		flipGummy();
	end
end

function summonbird()
	runHaxeCode([[
		var scale:Float = FlxG.random.float(0.6, 1);
		
		var parti:FlxSprite = new FlxSprite(2500, 0);
		parti.frames = Paths.getSparrowAtlas('stages/superfan-extras/bird');
		parti.animation.addByPrefix('idle', 'Bird instance 1', 24, true);
		parti.animation.play('idle');
		parti.antialiasing = ClientPrefs.globalAntialiasing;
		parti.y = FlxG.random.int(100, 2000);
		parti.scale.set(scale, scale);
		parti.alpha = ]]..alpha..[[;
		parti.velocity.y = -50;
		parti.scrollFactor.set(FlxG.random.float(1, 1.2),FlxG.random.float(1, 1.2));
		game.particleGroup.add(parti);

		FlxTween.tween(parti, {x: -1000}, FlxG.random.float(7, 14), {
		onComplete: function(tween:FlxTween){
			parti.destroy();
			game.particleGroup.remove(parti);
			parti = null;
		}});
	]])
end

function summonbutterfly()
	runHaxeCode([[
		var scale:Float = FlxG.random.float(0.6, 1);
		
		var parti:FlxSprite = new FlxSprite(-1000, 0);
		parti.frames = Paths.getSparrowAtlas('stages/superfan-extras/butterfly');
		parti.animation.addByPrefix('idle', 'Butterfly instance 1', 24, true);
		parti.antialiasing = ClientPrefs.globalAntialiasing;
		parti.animation.play('idle');
		parti.y = FlxG.random.int(100, 2000);
		parti.scale.set(scale, scale);
		parti.alpha = ]]..alpha..[[;
		parti.velocity.y = -50;
		parti.scrollFactor.set(FlxG.random.float(1, 1.2),FlxG.random.float(1, 1.2));
		game.particleGroup.add(parti);

		FlxTween.tween(parti, {x: 2500}, FlxG.random.float(7, 14), {
		onComplete: function(tween:FlxTween){
			parti.destroy();
			game.particleGroup.remove(parti);
			parti = null;
		}});
	]])
end

function flipGummy()
	if getProperty('gummyrunnu.flipX') then -- if it's time to flip then flip
		setProperty('gummyrunnu.flipX', false);
		setObjectOrder('gummyrunnu', getObjectOrder('boyfriendGroup')-1);
		setScrollFactor('gummyrunnu', 1, 1);
		setProperty('gummyrunnu.velocity.x', gummySpeed);
		setProperty('gummyrunnu.y', 185);
	else
		setProperty('gummyrunnu.flipX', true);
		setObjectOrder('gummyrunnu', getObjectOrder('boyfriendGroup')+1);
		setScrollFactor('gummyrunnu', 1.1, 1.1);
		setProperty('gummyrunnu.velocity.x', gummySpeed * -1);
		setProperty('gummyrunnu.y', 375);
	end
end

function spawnthetrail()
	runHaxeCode([[
		var colors:Array<Dynamic> = [0xff31a2fd, 0xff31fd8c, 0xfff794f7, 0xfff96d63, 0xfffba633, 0xff95E0FA, 0xff8CD465, 0xffFC95D3, 0xff9E72D2];

		var trailSprite:FlxSprite = new FlxSprite(game.getLuaObject('gummyrunnu').x, game.getLuaObject('gummyrunnu').y);
		trailSprite.scale.set(game.getLuaObject('gummyrunnu').scale.x, game.getLuaObject('gummyrunnu').scale.y);
		trailSprite.updateHitbox();
		trailSprite.alpha = 0.7;
		trailSprite.blend = "add";
		trailSprite.flipX = game.getLuaObject('gummyrunnu').flipX;
		trailSprite.antialiasing = game.getLuaObject('gummyrunnu').antialiasing;
		trailSprite.color = colors[FlxG.random.int(0, colors.length - 1)];
		trailSprite.frames = game.getLuaObject('gummyrunnu').frames;
		trailSprite.animation.addByPrefix('hueh', game.getLuaObject('gummyrunnu').animation.frameName, 0, false);
		trailSprite.animation.play('hueh', true);
		trailSprite.offset.set(game.getLuaObject('gummyrunnu').offset.x, game.getLuaObject('gummyrunnu').offset.y);
		trailSprite.scrollFactor.set(game.getLuaObject('gummyrunnu').scrollFactor.x, game.getLuaObject('gummyrunnu').scrollFactor.y);
		game.insert(game.members.indexOf(game.getLuaObject('gummyrunnu')) - 1, trailSprite);
		game.add(trailSprite);
		
		//:]
		FlxTween.tween(trailSprite, {alpha: 0}, 0.45, {
		onComplete: function(tween:FlxTween){
			trailSprite.destroy();
			trailSprite = null;
		}});
	]])
end

function spawnDing()
	runHaxeCode([[
		var scale:Float = FlxG.random.float(0.6, 1);
		
		var parti:FlxSprite = new FlxSprite(FlxG.random.int(0, 1115), FlxG.random.int(0, 613)).loadGraphic(Paths.image('stages/superfan-extras/ding'));
		parti.antialiasing = ClientPrefs.globalAntialiasing;
		parti.scale.set(0.001, 0.001);
		parti.angle = FlxG.random.int(-25, 25);
		parti.cameras = [game.camEffect];
		game.add(parti);
		
		FlxTween.tween(parti.scale, {x: 1.1, y: 1.1}, 0.14, {
		onComplete: function(tween:FlxTween){
			FlxTween.tween(parti.scale, {x: 0, y: 0}, 0.22, {
			onComplete: function(tween:FlxTween){
				parti.destroy();
				parti = null;
			}});
		}});
	]])
end