local funnyBoppers = false;

function onCreate()
	posX = -1000;
	posY = -600;
	scale = 1;

	makeLuaSprite('Sky2', 'corianda/introsky', posX, posY);
	setScrollFactor('Sky2', 0, 0.1);
	scaleObject('Sky2', scale, scale);
	addLuaSprite('Sky2', false);
	
	makeLuaSprite('cenBuilding', 'corianda/introbuilding', posX, posY);
	setScrollFactor('cenBuilding', 0.85, 0.85);
	scaleObject('cenBuilding', scale, scale);
	addLuaSprite('cenBuilding', true);
	
	setProperty('isCameraOnForcedPos', true);
	setProperty('camFollow.x', 470);
	setProperty('camFollow.y', -1110);
	setProperty('camera.target.y', -1110)
	doTweenY('moveCam', 'camFollow', -1110, 0.1);
	
	setScrollFactor('dad', 0.85, 0.85);
	setProperty('boyfriend.x', getProperty('boyfriend.x') - 200);
	setProperty('boyfriend.y', getProperty('boyfriend.y') - 500);
	setProperty('dad.x', getProperty('dad.x') - 100);
	setProperty('dad.y', getProperty('dad.y') - 600);
	setProperty('defaultCamZoom', 0.9);
	doTweenZoom('zoomcamera', 'camGame', 0.72, 0.1);
	setProperty('front.visible', false);
	scaleObject('boyfriend', 1.5, 1.5);
	runHaxeCode([[
	game.boyfriendCameraOffset = [-500, -250]
	]]);
	
	makeLuaSprite('black', '', -100, -100);
    makeGraphic('black', 1280*2, 720*2, '000000');
    setScrollFactor('black', 0, 0);
    screenCenter('black');
    addLuaSprite('black', true);
	
	makeLuaSprite('barTop', 'closeup/TightBars', 0, 0);
	setScrollFactor('barTop', 0, 0);
	scaleObject('barTop', 1.1, 1);
	addLuaSprite('barTop', false);
	setObjectCamera('barTop', 'effect');

	makeLuaSprite('barBottom', 'closeup/TightBars', 0, 628);
	setScrollFactor('barBottom', 0, 0);
	scaleObject('barBottom', 1.1, 1);
	addLuaSprite('barBottom', false);
	setObjectCamera('barBottom', 'effect');
	
	makeLuaSprite('fade', 'corianda/introfade', 0, -1300);
	setScrollFactor('fade', 0, 0);
	scaleObject('fade', scale, scale);
	addLuaSprite('fade', false);
	setObjectCamera('fade', 'effect')
	
	makeLuaSprite('transition', 'corianda/hattransition', 1280, 0);
	setScrollFactor('transition', 0, 0);
	scaleObject('transition', scale, scale);
	addLuaSprite('transition', false);
	setObjectCamera('transition', 'effect');
end

function thingie(num)
	num = tonumber(num)
	if num == 10 then
		doTweenAlpha('black', 'black', 0, 2);
	end
	if num == 70 then
		doTweenY('moveCam', 'camFollow', 0, 3);
	end
	if num == 128 then
		setProperty('isCameraOnForcedPos', false);
	end
	if num == 224 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.x', 140);
		setProperty('camFollow.y', -100);
		setProperty('dad.skipDance', true)
	end
	if num == 228 then
		playAnim('dad', 'jump', true);
		doTweenY('barTop', 'barTop', -102, 0.25, "circinout");
		doTweenY('barBottom', 'barBottom', 822, 0.25, "circinout");		
	end
	if num == 236 then
		doTweenY('fade', 'fade', 1300, 0.5);
	end
	if num == 238 then
		runHaxeCode([[
		game.boyfriendCameraOffset = [0, 10]
		]]);
		setProperty('defaultCamZoom', 0.72);
		setProperty('isCameraOnForcedPos', false);
		doTweenZoom('zoomcamera', 'camGame', 0.9, 0.1);
		setProperty('Sky2.visible', false);
		setProperty('cenBuilding.visible', false);
		setProperty('front.visible', true);
		
		setScrollFactor('dad', 1, 1);
		setProperty('boyfriend.x', getProperty('boyfriend.x') + 200);
		setProperty('boyfriend.y', getProperty('boyfriend.y') + 500);
		setProperty('dad.x', getProperty('dad.x') + 100);
		setProperty('dad.y', getProperty('dad.y') + 400);
		scaleObject('boyfriend', 1, 1);
	end
	if num == 896 then
		doTweenY('barTop', 'barTop', 0, 1, "circinout");
		doTweenY('barBottom', 'barBottom', 628, 1, "circinout");
	end
	if num == 990 then
		doTweenX('transition', 'transition', -2600, 0.18);
	end
	if num == 992 then
		setProperty('BGCityRave.alpha', 1);
		setProperty('RoadRave.alpha', 1);
		setProperty('clones.alpha', 1);
		playAnim('clones', 'idle');
	end
	if num == 1008 then
		playAnim('clones', 'caseOpens');
		doTweenY('barTop', 'barTop', -102, 0.25, "circinout");
		doTweenY('barBottom', 'barBottom', 822, 0.25, "circinout");		
	end
	if num == 1024 then
		funnyBoppers = true;
		setProperty('clonesFG.alpha', 1);
		playAnim('clonesFG', 'appear');
	end
	if num == 1408 then
		setProperty('BGCityRave.alpha', 0.0001);
		setProperty('RoadRave.alpha', 0.0001);
		funnyBoppers = false;
		playAnim('clones', 'vanish', true);
		playAnim('clonesFG', 'vanish', true);
	end
end

local danced = false
function onBeatHit()
	if curBeat % 2 == 0 and funnyBoppers then
		--BG folk
		playAnim('clonesFG', 'idle');
		if danced then
			danced = false;
			playAnim('clones', 'danceLeft');
		else
			danced = true;
			playAnim('clones', 'danceRight');
		end
	end
end