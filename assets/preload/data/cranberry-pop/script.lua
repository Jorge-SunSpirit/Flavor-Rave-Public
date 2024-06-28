posX = 0;
posYcut = -10;
posY = 0;

function onCreate()
	addHaxeLibrary('FlxBackdrop', 'flixel.addons.display');
	
	makeLuaSprite('sweetBG', 'closeup/SweetBG', posX, posY);
	setScrollFactor('sweetBG', 0, 0);
	addLuaSprite('sweetBG', false);
	setProperty('sweetBG.alpha', 0.0001);
	
	makeLuaSprite('sourBG', 'closeup/SourBG', posX, posY);
	setScrollFactor('sourBG', 0, 0);
	addLuaSprite('sourBG', false);
	setProperty('sourBG.alpha', 0.0001);
	
	makeLuaSprite('bothBG', 'closeup/BothBG', posX, posY);
	setScrollFactor('bothBG', 0, 0);
	addLuaSprite('bothBG', false);
	setProperty('bothBG.alpha', 0.0001);
	
	runHaxeCode([[
		var topSweetRow:FlxBackdrop = new FlxBackdrop(Paths.image('closeup/sweetroll'), 0x01);
		topSweetRow.antialiasing = ClientPrefs.globalAntialiasing;
		topSweetRow.y = -600;
		game.addBehindGF(topSweetRow);
		setVar('topSweetRow', topSweetRow);
		
		var bottomSweetRow:FlxBackdrop = new FlxBackdrop(Paths.image('closeup/sweetroll'), 0x01);
		bottomSweetRow.antialiasing = ClientPrefs.globalAntialiasing;
		bottomSweetRow.y = 1280;
		game.addBehindGF(bottomSweetRow);
		setVar('bottomSweetRow', bottomSweetRow);
	]]);
	setScrollFactor('topSweetRow', 0, 0);
	setProperty('topSweetRow.velocity.x', -30);
	setScrollFactor('bottomSweetRow', 0, 0);
	setProperty('bottomSweetRow.velocity.x', 30);
	
	runHaxeCode([[
		var topSourRow:FlxBackdrop = new FlxBackdrop(Paths.image('closeup/sourroll'), 0x01);
		topSourRow.antialiasing = ClientPrefs.globalAntialiasing;
		topSourRow.y = -600;
		game.addBehindGF(topSourRow);
		setVar('topSourRow', topSourRow);
		
		var bottomSourRow:FlxBackdrop = new FlxBackdrop(Paths.image('closeup/sourroll'), 0x01);
		bottomSourRow.antialiasing = ClientPrefs.globalAntialiasing;
		bottomSourRow.y = 1280;
		game.addBehindGF(bottomSourRow);
		setVar('bottomSourRow', bottomSourRow);
	]]);
	setScrollFactor('topSourRow', 0, 0);
	setProperty('topSourRow.velocity.x', -30);
	setScrollFactor('bottomSourRow', 0, 0);
	setProperty('bottomSourRow.velocity.x', 30);
	
	makeAnimatedLuaSprite('sourBack', 'closeup/SourCloseBack', 300, 150);
	addAnimationByPrefix('sourBack', 'idle', 'SourBack', 24, true);
	playAnim('sourBack', 'idle');
	addLuaSprite('sourBack', true);
	setProperty('sourBack.alpha', 0.0001);
	
	makeAnimatedLuaSprite('sweetBack', 'closeup/SweetCloseBack', 1700, 150);
	addAnimationByPrefix('sweetBack', 'idle', 'SweetBack', 24, true);
	playAnim('sweetBack', 'idle');
	addLuaSprite('sweetBack', true);
	setProperty('sweetBack.alpha', 0.0001);

	makeAnimatedLuaSprite('SourCutin', 'closeup/SourCutin', -1280, 91);
	addAnimationByPrefix('SourCutin', 'idle', 'SourCutin', 24, false);
	playAnim('SourCutin', 'idle');
	finishAnim('SourCutin');
	setScrollFactor('SourCutin', 0, 0);
	addLuaSprite('SourCutin', false);
	setObjectCamera('SourCutin', 'hud');

	makeAnimatedLuaSprite('SweetCutIn', 'closeup/SweetCutIns', 1280, 359);
	addAnimationByPrefix('SweetCutIn', 'idle', 'SugarCutin', 24, false);
	playAnim('SweetCutIn', 'idle');
	finishAnim('SweetCutIn');
	setScrollFactor('SweetCutIn', 0, 0);
	addLuaSprite('SweetCutIn', false);
	setObjectCamera('SweetCutIn', 'hud');

	triggerEvent('Alt Idle Animation', 'Dad', '-sad');
	triggerEvent('Alt Idle Animation', 'BF', '-sad');
	playAnim('dad', 'idle-sad', true)
	playAnim('boyfriend', 'idle-sad', true)
end

function onCreatePost()
	--black bars and crap
	--triggerEvent('Spawn Particles', 'closeup/sourparticle,closeup/sweetparticle', '')
end

function onStepHit()
	-- Center camera stuff
	if curStep >= 192 and curStep <= 256 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 360);
		setProperty('camFollow.x', 820);
	elseif curStep >= 448 and curStep <= 494 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 360);
		setProperty('camFollow.x', 820);
	elseif curStep >= 192 and curStep <= 494 then --
		setProperty('isCameraOnForcedPos', false);
	end
	
	if curStep >= 1154 and curStep <= 1216 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 360);
		setProperty('camFollow.x', 820);
	elseif curStep >= 1248 and curStep <= 1408 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 360);
		setProperty('camFollow.x', 820);
	elseif curStep >= 1518 and curStep <= 1551 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 360);
		setProperty('camFollow.x', 820);
	elseif curStep >= 1154 and curStep <= 1551 then --
		setProperty('isCameraOnForcedPos', false);
	end
end

function eventStepThingie(num)
	if num == '494' then
		cutIn(0);
	end
	if num == '510' then
		cutIn(10); -- hueh
		cutIn(2); -- hueh
	end
	if num == '515' then
		cutIn(1);
	end 
	if num == '570' then
		cutIn(3);
	end 
	if num == '572' then
		cutIn(4);
	end 
	if num == '634' then
		cutIn(5);
	end 
	if num == '638' then
		cutIn(6);
	end 
	if num == '768' then
		cutIn(9);
	end
end

function cutIn(num)
	if num == 0 then -- adds the cutins
		doTweenY('barTop', 'barTop', 0, 0.5, "circinout");
		doTweenY('barBottom', 'barBottom', 628, 0.5, "circinout");
		doTweenX('SourCutin', 'SourCutin', 0, 1, "cubeinout");
		doTweenX('SweetCutIn', 'SweetCutIn', 0, 1, "cubeinout");

		runTimer('cutinAnim', 0.2);
	end
	if num == 1 then -- tween away cutins
		doTweenX('SourCutin', 'SourCutin', 1280, 0.5, "circinout");
		doTweenX('SweetCutIn', 'SweetCutIn', -1280, 0.5, "circinout");
	end
	
	--Moving tweens
	if num == 2 then -- tween in sourBack and BF
		doTweenX('boyfriendGroup', 'boyfriendGroup', 1000, 0.7, "cubeinout");
		doTweenX('sourBack', 'sourBack', 300, 0.7, "cubeinout");
		
		doTweenY('topSweetRow', 'topSweetRow', 50, 0.7, "cubeinout");
		doTweenY('bottomSweetRow', 'bottomSweetRow', 450, 0.7, "cubeinout");
	end
	if num == 3 then -- tween away BF and sourBack
		doTweenX('boyfriendGroup', 'boyfriendGroup', 1800, 0.7, "cubeinout");
		doTweenX('sourBack', 'sourBack', -500, 0.7, "cubeinout");
		
		doTweenY('topSweetRow', 'topSweetRow', -180, 0.7, "cubeinout");
		doTweenY('bottomSweetRow', 'bottomSweetRow', 1280, 0.7, "cubeinout");
	end
	
	if num == 4 then -- tween in sweetback and dad
		doTweenAlpha('sourBG', 'sourBG', 1, 0.4);
		doTweenX('dadGroup', 'dadGroup', 300, 0.7, "cubeinout");
		doTweenX('sweetBack', 'sweetBack', 900, 0.7, "cubeinout");
		
		doTweenY('topSourRow', 'topSourRow', 50, 0.7, "cubeinout");
		doTweenY('bottomSourRow', 'bottomSourRow', 450, 0.7, "cubeinout");
	end
	if num == 5 then -- tween away sweetback and dad
		doTweenAlpha('sourBG', 'sourBG', 0.0001, 0.4);
		doTweenX('dadGroup', 'dadGroup', -500, 0.7, "cubeinout");
		doTweenX('sweetBack', 'sweetBack', 1700, 0.7, "cubeinout");
		
		doTweenY('topSourRow', 'topSourRow', -180, 0.7, "cubeinout");
		doTweenY('bottomSourRow', 'bottomSourRow', 1280, 0.7, "cubeinout");
	end
	
	if num == 6 then -- tween in bf and dad
		doTweenAlpha('bothBG', 'bothBG', 1, 0.4);
		doTweenX('dadGroup', 'dadGroup', 300, 0.7, "cubeinout");
		doTweenX('boyfriendGroup', 'boyfriendGroup', 1000, 0.7, "cubeinout");
		
		doTweenY('topSourRow', 'topSourRow', 50, 0.7, "cubeinout");
		doTweenY('bottomSweetRow', 'bottomSweetRow', 450, 0.7, "cubeinout");
	end
	
	if num == 7 then -- tween out bf and dad
		doTweenAlpha('bothBG', 'bothBG', 0.0001, 0.4);
		doTweenX('dadGroup', 'dadGroup', -500, 0.7, "cubeinout");
		doTweenX('boyfriendGroup', 'boyfriendGroup', 1800, 0.7, "cubeinout");
		
		doTweenY('topSourRow', 'topSourRow', -180, 0.7, "cubeinout");
		doTweenY('bottomSweetRow', 'bottomSweetRow', 1280, 0.7, "cubeinout");
	end
	
	
	
	--Reset
	if num == 9 then -- reset
		doTweenY('barTop', 'barTop', -102, 0.25, "circinout");
		doTweenY('barBottom', 'barBottom', 822, 0.25, "circinout");
		
		doTweenY('topSourRow', 'topSourRow', -600, 0.7, "cubeinout");
		doTweenY('bottomSourRow', 'bottomSourRow', 1280, 0.7, "cubeinout");
		doTweenY('topSweetRow', 'topSweetRow', -600, 0.7, "cubeinout");
		doTweenY('bottomSweetRow', 'bottomSweetRow', 1280, 0.7, "cubeinout");
		
		doTweenX('transition', 'transition', 1280, 0.8);
		runTimer('hueh', 0.4);
		setProperty("cameraSpeed", 1);
	end
	
	--Initialize
	if num == 10 then -- initialize while the cutins are active
		doTweenX('dadGroup', 'dadGroup', -500, 0.1);
		setProperty("cameraSpeed", 100);
		doTweenZoom('zoomcamera', 'camGame', 1, 0.1);
		setProperty('defaultCamZoom', 1);
		setProperty('camZooming', true);
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 525);
		setProperty('camFollow.x', 900);
		setProperty('sweetBG.alpha', 1);
		setProperty('sourBack.alpha', 1);
		setProperty('sweetBack.alpha', 1);
		setProperty('gf.alpha', 0.001);
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'hueh' then
		setProperty('isCameraOnForcedPos', false);
		setProperty('camFollow.y', 400);
		setProperty('camFollow.x', 850);
		doTweenX('boyfriendGroup', 'boyfriendGroup', 1000, 0.01);
		doTweenX('dadGroup', 'dadGroup', -50, 0.01);
		setProperty('sweetBG.alpha', 0.001);
		setProperty('sourBG.alpha', 0.001);
		setProperty('bothBG.alpha', 0.001);
		setProperty('sourBack.alpha', 0.001);
		setProperty('sweetBack.alpha', 0.001);
		setProperty('gf.alpha', 1);
		setProperty('defaultCamZoom', 0.5);
		triggerEvent('Clear Particles', '', '');
	end

	if tag == 'cutinAnim' then
		playAnim('SourCutin', 'idle');
		playAnim('SweetCutIn', 'idle');
	end
end