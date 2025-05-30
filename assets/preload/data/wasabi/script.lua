funkyBumps = 0;
who = 'normal';

function onCreate()
	setProperty('isCameraOnForcedPos', true);
	setProperty('camFollow.y', 317);
	setProperty('camFollow.x', 670);
	setProperty('dad.alpha', 0.00001);
	setProperty('boyfriend.alpha', 0.00001);

	makeLuaSprite('floorPurse', 'backstreet/FloorPerspective', 200, -300);
	setScrollFactor('floorPurse', 1, 1);
	scaleObject('floorPurse', 1.75, 1.75);
	addLuaSprite('floorPurse', false);
	setProperty('floorPurse.alpha', 0.0001);

	makeLuaSprite('SkyMono', 'backstreet/SkyMono', -500, -700);
	setScrollFactor('SkyMono', 0, 0);
	scaleObject('SkyMono', 1.3, 1.3);
	addLuaSprite('SkyMono', false);

	makeLuaSprite('BGCityMono', 'backstreet/BGCityMono', -500, 1000);
	setScrollFactor('BGCityMono', 0.2, 0.9);
	scaleObject('BGCityMono', 1.2, 1.2);
	addLuaSprite('BGCityMono', false);

	makeAnimatedLuaSprite('moon', 'backstreet/Moon', 540, -360);
	addAnimationByPrefix('moon', 'normal', 'NormalMoon', 24, true);
	addAnimationByPrefix('moon', 'sour', 'SourMoon', 24, false);
	addAnimationByPrefix('moon', 'smok', 'SmokyMoon', 24, false);
	scaleObject('moon', 1.1, 1.1);
	playAnim('moon', 'normal', true);
	setScrollFactor('moon', 0.1, 0.1);	
	addLuaSprite('moon', false);
	setProperty('moon.alpha', 0.0001);

	makeLuaSprite('RoadMono', 'backstreet/RoadMono', -500, 1000);
	setScrollFactor('RoadMono', 1, 1);
	scaleObject('RoadMono', 1.2, 1.2);
	addLuaSprite('RoadMono', false);

	makeLuaSprite('LeftBuildingsMono', 'backstreet/LeftBuildingsMono', -500, 1000);
	setScrollFactor('LeftBuildingsMono', 1, 1);
	scaleObject('LeftBuildingsMono', 1.2, 1.2);
	addLuaSprite('LeftBuildingsMono', false);

	makeLuaSprite('RightBuildingsMono', 'backstreet/RightBuildingsMono', -500, 1000);
	setScrollFactor('RightBuildingsMono', 1, 1);
	scaleObject('RightBuildingsMono', 1.2, 1.2);
	addLuaSprite('RightBuildingsMono', false);

	makeLuaSprite('barTop', 'closeup/TightBars', 0, -102);
	setScrollFactor('barTop', 0, 0);
	scaleObject('barTop', 1.1, 1);
	addLuaSprite('barTop', false);
	setObjectCamera('barTop', 'effect');

	makeLuaSprite('barBottom', 'closeup/TightBars', 0, 822);
	setScrollFactor('barBottom', 0, 0);
	scaleObject('barBottom', 1.1, 1);
	addLuaSprite('barBottom', false);
	setObjectCamera('barBottom', 'effect');

	makeAnimatedLuaSprite('smokeTop', 'backstreet/smokebordertop', -75, -302);
	addAnimationByPrefix('smokeTop', 'idle', 'BorderSmokyBottom', 24, true);
	setScrollFactor('smokeTop', 0, 0);
	scaleObject('smokeTop', 1, 1);
	addLuaSprite('smokeTop', false);
	setObjectCamera('smokeTop', 'effect');

	makeAnimatedLuaSprite('smokeBottom', 'backstreet/smokeborderbottom', -75, 722);
	addAnimationByPrefix('smokeBottom', 'idle', 'BorderSmokyBottom', 24, true);
	setScrollFactor('smokeBottom', 0, 0);
	scaleObject('smokeBottom', 1, 1);
	addLuaSprite('smokeBottom', false);
	setObjectCamera('smokeBottom', 'effect');

	makeLuaSprite('dramablack', '', -100, -100);
    makeGraphic('dramablack', 1280*2, 720*2, '000000');
    setScrollFactor('dramablack', 0, 0);
    screenCenter('dramablack');
    addLuaSprite('dramablack', true);
	setProperty('dramablack.alpha', 0.0001);

	makeAnimatedLuaSprite('trans', 'backstreet/transition', posX, posY);
	addAnimationByPrefix('trans', 'idle', 'SmokeTrans', 24, false);
	playAnim('trans', 'idle');
	finishAnim('trans');
	setScrollFactor('trans', 0, 0);
	scaleObject('trans', 1.2, 1.2);
	addLuaSprite('trans', false);
    screenCenter('trans');
	setObjectCamera('trans', 'effect');
	setProperty('trans.alpha', 0.0001);
end

function onStepHit()
	if curStep >= 240 and curStep <= 272 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 317);
		setProperty('camFollow.x', 670);
	end
	if curStep >= 360 and curStep <= 383 then
		doTweenAlpha('black', 'black', 0.9, 0.3);
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 250);
		setProperty('camFollow.x', 360);
	end
	if curStep >= 832 and curStep <= 864 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 317);
		setProperty('camFollow.x', 670);
	end
	if curStep >= 1104 and curStep <= 1392 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 190);
		setProperty('camFollow.x', 800);
	end
	if curStep >= 1424 and curStep <= 1487 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 317);
		setProperty('camFollow.x', 670);
	end
end

function thingie(num)
	num = tonumber(num)
	if num == 2 then
		doTweenY('BGCityMono', 'BGCityMono', -700, 0.4, "circinout");
	end
	if num == 5 then
		doTweenY('RoadMono', 'RoadMono', -700, 0.4, "circinout");
	end
	if num == 8 then
		doTweenY('LeftBuildingsMono', 'LeftBuildingsMono', -700, 0.4, "circinout");
	end
	if num == 11 then
		doTweenY('RightBuildingsMono', 'RightBuildingsMono', -700, 0.4, "circinout");
	end
	if num == 16 then
		setProperty('SkyMono.alpha', 0.0001);
		setProperty('BGCityMono.alpha', 0.0001);
		setProperty('RoadMono.alpha', 0.0001);
		setProperty('LeftBuildingsMono.alpha', 0.0001);
		setProperty('RightBuildingsMono.alpha', 0.0001);
		setProperty('dad.alpha', 1);
		setProperty('boyfriend.alpha', 1);
	end
	if num == 80 then
		setProperty('isCameraOnForcedPos', false);
	end
	if num == 272 then
		setProperty('isCameraOnForcedPos', false);
		doTweenAlpha('black', 'black', 0.7, 1);
		doTweenY('smokeTop', 'smokeTop', -100, 1, "circinout");
		doTweenY('smokeBottom', 'smokeBottom', 528, 1, "circinout");
	end
	if num == 368 then
		if not middlescroll then
			noteTweenAlpha('dad4', 0, 0, 1, "circout")
			noteTweenAlpha('dad5', 1, 0, 1, "circout")
			noteTweenAlpha('dad6', 2, 0, 1, "circout")
			noteTweenAlpha('dad7', 3, 0, 1, "circout")
		end
	end
	if num == 382 then
		doTweenAlpha('dad', 'dad', 0.00001, 0.2);
		runTimer('smokintime', 0.2);
		doTweenAlpha('trans', 'trans', 1, 0.2);
	end
	if num == 387 then
		doTweenY('barTop', 'barTop', 0, 0.2, "circinout");
		doTweenY('barBottom', 'barBottom', 628, 0.2, "circinout");
		setProperty('smokeTop.alpha', 0.0001);
		setProperty('smokeBottom.alpha', 0.0001);
		setProperty('isCameraOnForcedPos', false);
		setProperty('floorPurse.alpha', 1);
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.x', 1415);
		setProperty('camFollow.y', 213);
		setProperty('camera.target.x', 1415)
		setProperty('camera.target.y', 213)
		setProperty('dad.x', getProperty('boyfriend.x') + 240);
		setProperty('dad.y', getProperty('boyfriend.y') - 220);
	end
	if num == 400 then
		doTweenAlpha('dad', 'dad', 1, 0.2);
		if not middlescroll then
			noteTweenX('bf', 0, defaultPlayerStrumX0, 1, "circinout")
			noteTweenX('bf1', 1, defaultPlayerStrumX1, 1, "circinout")
			noteTweenX('bf2', 2, defaultPlayerStrumX2, 1, "circinout")
			noteTweenX('bf3', 3, defaultPlayerStrumX3, 1, "circinout")
			noteTweenX('dad4', 4, defaultOpponentStrumX0, 1, "circinout")
			noteTweenX('dad5', 5, defaultOpponentStrumX1, 1, "circinout")
			noteTweenX('dad6', 6, defaultOpponentStrumX2, 1, "circinout")
			noteTweenX('dad7', 7, defaultOpponentStrumX3, 1, "circinout")
		end
	end
	if num == 410 then
		if not middlescroll and not opponentPlay then
			noteTweenAlpha('dad4', 0, defaultOpponentAlpha0, 0.2, "circout")
			noteTweenAlpha('dad5', 1, defaultOpponentAlpha1, 0.2, "circout")
			noteTweenAlpha('dad6', 2, defaultOpponentAlpha2, 0.2, "circout")
			noteTweenAlpha('dad7', 3, defaultOpponentAlpha3, 0.2, "circout")
		elseif not middlescroll then
			noteTweenAlpha('dad4', 0, defaultPlayerAlpha0, 0.2, "circout")
			noteTweenAlpha('dad5', 1, defaultPlayerAlpha1, 0.2, "circout")
			noteTweenAlpha('dad6', 2, defaultPlayerAlpha2, 0.2, "circout")
			noteTweenAlpha('dad7', 3, defaultPlayerAlpha3, 0.2, "circout")
		end
	end
	if num == 416 then
		doTweenAlpha('black', 'black', 0, 1);
	end
	if num == 785 then
		runTimer('smokintime', 0.2);
		if not middlescroll then
			noteTweenX('bf', 4, defaultPlayerStrumX0, 1, "circinout")
			noteTweenX('bf1', 5, defaultPlayerStrumX1, 1, "circinout")
			noteTweenX('bf2', 6, defaultPlayerStrumX2, 1, "circinout")
			noteTweenX('bf3', 7, defaultPlayerStrumX3, 1, "circinout")
			noteTweenX('dad4', 0, defaultOpponentStrumX0, 1, "circinout")
			noteTweenX('dad5', 1, defaultOpponentStrumX1, 1, "circinout")
			noteTweenX('dad6', 2, defaultOpponentStrumX2, 1, "circinout")
			noteTweenX('dad7', 3, defaultOpponentStrumX3, 1, "circinout")
		end
	end
	if num == 790 then
		doTweenY('barTop', 'barTop', -102, 0.25, "circinout");
		doTweenY('barBottom', 'barBottom', 822, 0.25, "circinout");
		setProperty('floorPurse.alpha', 0.0001);
		setProperty('isCameraOnForcedPos', false);
	end
	if num == 864 then
		setProperty('isCameraOnForcedPos', false);
	end
	if num == 992 then
		doTweenAlpha('dramablack', 'dramablack', 1, 0.7);
	end
	if num == 1004 then
		runHaxeCode('game.boyfriend.setColorTransform(1, 1, 1, 1, 255, 255, 255, 0);')
		runHaxeCode('game.dad.setColorTransform(1, 1, 1, 1, 255, 255, 255, 0);')
		setProperty('boyfriend.alpha', 0);
		setProperty('black.alpha', 1);
	end
	if num == 1008 then
		doTweenAlpha('dramablack', 'dramablack', 0, 2);
	end
	if num == 1072 then
		doTweenAlpha('boyfriend', 'boyfriend', 1, 2);
	end
	if num == 1120 then
		funkyBumps = 1;
		doTweenAlpha('moon', 'moon', 1, 2);
		playAnim('trans', 'normal');
	end
	if num == 1136 then
		setProperty('SkyMono.alpha', 1);
		setProperty('BGCityMono.alpha', 1);
		setProperty('RoadMono.alpha', 1);
		setProperty('LeftBuildingsMono.alpha', 1);
		setProperty('RightBuildingsMono.alpha', 1);
		runHaxeCode('game.boyfriend.setColorTransform(1, 1, 1, 1, 0, 0, 0, 0);')
		runHaxeCode('game.dad.setColorTransform(1, 1, 1, 1, 0, 0, 0, 0);')
		setProperty('boyfriend.color', 0x00000000);
		setProperty('dad.color', 0x00000000);
		funkyBumps = 2;
	end
	if num == 1392 then
		setProperty('black.alpha', 0);
		setProperty('moon.alpha', 0);
		setProperty('SkyMono.alpha', 0.0001);
		setProperty('BGCityMono.alpha', 0.0001);
		setProperty('RoadMono.alpha', 0.0001);
		setProperty('LeftBuildingsMono.alpha', 0.0001);
		setProperty('RightBuildingsMono.alpha', 0.0001);
		setProperty('isCameraOnForcedPos', false);
		setProperty('boyfriend.color', 0xFFFFFF);
		setProperty('dad.color', 0xFFFFFF);
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'smokintime' then
		playAnim('trans', 'idle');
	end
end

function onBeatHit()
	if curBeat % 2 == 0 and funkyBumps >= 1 then
		playAnim('moon', who, true);
	end
end

function onMoveCamera(focus)
	if focus == 'dad' and funkyBumps == 2 then
		if who ~= 'smok' then playAnim('moon', 'smok', true); end
		who = 'smok';
	elseif focus == 'boyfriend' and funkyBumps == 2 then
		if who ~= 'sour' then playAnim('moon', 'sour', true); end
		who = 'sour';
	end
	
	if funkyBumps == 1 then
		who = 'normal';
	end
end