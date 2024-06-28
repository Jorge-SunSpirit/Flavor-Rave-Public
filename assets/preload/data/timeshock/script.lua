posX = 0;
posYcut = -10;
posY = 0;

fogY = 450;
fogScale = 2;

fogSlowdown = false;

function onCreate()
	makeAnimatedLuaSprite('Rave', 'closeup/RAVE-BG', -750, fogY);
	addAnimationByPrefix('Rave', 'idle', 'RaveBG', 24, true);
	setScrollFactor('Rave', 0.1, 0.1);
	addLuaSprite('Rave', false);
	scaleObject('Rave', 1.4, 1.4);
    screenCenter('Rave');
	setProperty('Rave.alpha', 0.0001);

	makeLuaSprite('dramalight', 'bg2/dramaglow', -1000, posY);
	setScrollFactor('dramalight', 0, 0);
	scaleObject('dramalight', 8, 1.3);
	addLuaSprite('dramalight', false);
	setProperty('dramalight.alpha', 0.0001);

	makeAnimatedLuaSprite('fogLeft', 'bg2/fogleft', -750, fogY);
	addAnimationByPrefix('fogLeft', 'idle', 'fogleft', 24, true);
	setScrollFactor('fogLeft', 0.9, 0.95);
	scaleObject('fogLeft', fogScale, fogScale);
	addLuaSprite('fogLeft', false);
	setProperty('fogLeft.alpha', 0.0001);

	makeAnimatedLuaSprite('fogRight', 'bg2/fogright', 850, fogY + 100);
	addAnimationByPrefix('fogRight', 'idle', 'fogright', 24, true);
	setScrollFactor('fogRight', 0.9, 0.95);
	scaleObject('fogRight', fogScale, fogScale);
	addLuaSprite('fogRight', false);
	setProperty('fogRight.alpha', 0.0001);
	
	makeLuaSprite('spotlight', 'closeup/spotlight', posX, posY);
	setScrollFactor('spotlight', 0, 0);
	addLuaSprite('spotlight', true);
	scaleObject('spotlight', 1.4, 1.4);
    screenCenter('spotlight');
	setProperty('spotlight.alpha', 0.0001);

	makeLuaSprite('vin', 'closeup/raveglow', 0, 0);
	setScrollFactor('vin', 0, 0);
	addLuaSprite('vin', false);
	setObjectCamera('vin', 'hud');
	setProperty('vin.alpha', 0.0001);

	setProperty('boyfriend.color', 0x00000000);
	setProperty('dad.color', 0x00000000);
	
	makeLuaSprite('black', '', -100, -100);
    makeGraphic('black', 1280*2, 720*2, '000000');
    setScrollFactor('black', 0, 0);
    screenCenter('black');
    addLuaSprite('black', true);

    makeLuaSprite('white', '', -100, -100);
    makeGraphic('white', 2560, 1440, 'FFFFFF');
    setScrollFactor('white', 0, 0);
    screenCenter('white');
    addLuaSprite('white', true);
end

function onCreatePost()
	setProperty('black.color', 0x00000000);
	setProperty('white.alpha', 0.0001);
	setProperty('bglights.alpha', 0.0001);
	toggleLights(3);

	setProperty('isCameraOnForcedPos', true);
    setProperty('camFollow.y', 410);
    setProperty('camFollow.x', 727);
    setProperty('camera.target.x', 727);
    setProperty('camera.target.y', 410);

end

function thingie(num)
	--Like how it's in funny hard code
	num = tonumber(num)
	if num == 1 then
		doTweenAlpha('black', 'black', 0.001, 0.1, "cubeinout");
	end
	if num == 122 then
		doTweenAlpha('white', 'white', 1, 0.55, 'cubeinout');
	end
	if num == 128 then
		setProperty('fogLeft.alpha', 0.75);
		setProperty('fogRight.alpha', 0.75);

		setProperty('fogLeft.x', -1150);
		setProperty('fogLeft.velocity.x', 100);

		setProperty('fogRight.x', 1000);
		setProperty('fogRight.velocity.x', -100);
		doTweenAlpha('white', 'white', 0.001, 0.2, 'cubeinout');

		runTimer('THEFOG', 1);
	end
	if num == 256 then
		setProperty('dad.color', 0xFFFFFF);
		toggleLights(1);
	end
	if num == 384 then 
		setProperty('dad.color', 0x00000000);
		setProperty('boyfriend.color', 0xFFFFFF);
		toggleLights(0);
	end
	if num == 496 then
		doTweenAlpha('fogLeft', 'fogLeft', 0, 1.5);
		doTweenAlpha('fogRight', 'fogRight', 0, 1.5);
	end
	if num == 512 then
		setProperty('bglights.alpha', 1);
		setProperty('dad.color', 0xFFFFFF);
		toggleLights(2);
	end
	
	if num == 1024 then
		toggleLights(1);
	end
	if num == 1032 then
		toggleLights(0);
	end
	if num == 1040 then
		toggleLights(1);
	end
	if num == 1048 then
		toggleLights(0);
	end
	if num == 1056 then
		toggleLights(1);
	end
	if num == 1064 then
		toggleLights(0);
	end
	if num == 1072 then
		toggleLights(2);
	end
	if num == 1408 then
		toggleLights(0);
		setProperty('bglights.alpha', 0.0001);
		setProperty('dad.color', 0x00000000);
	end
	if num == 1680 then
		toggleLights(2);
		doTweenAlpha('dramalight', 'dramalight', 1, 5, 'cubeinout');
		setProperty('dad.color', 0xFFFFFF);
	end
	if num == 1700 then
		doTweenAlpha('vin', 'vin', 1, 6);
	end
	if num == 1888 then
		doTweenAlpha('white', 'white', 1, 2.5, 'cubeinout');
	end
	if num == 1920 then
		cutIn(10);
		toggleLights(3);
		setProperty('vin.alpha', 0.0001);
		setProperty('white.alpha', 0.0001);
		setProperty('black.alpha', 0.0001);
	end
	if num == 2172 then
		setProperty('black.alpha', 1);
		cutIn(9);
	end
	if num == 2176 then
		toggleLights(0);
		setProperty('bglights.alpha', 1);
		setProperty('crowd0.alpha', 1);
		setProperty('crowd1.alpha', 1);
		setProperty('crowd2.alpha', 1);
		setProperty('black.alpha', 0.001);
	end
	if num == 2178 then
		setProperty('defaultCamZoom', 0.4);
		setProperty('camZooming', true);
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 260);
		setProperty('camFollow.x', 727);
	end
	if num == 2464 then
		doTweenAlpha('dramalight', 'dramalight', 0.0001, 3, 'cubeinout');
		setProperty('boyfriend.color', 0x00000000);
		setProperty('dad.color', 0x00000000);
		toggleLights(3);
		setProperty('bglights.alpha', 0.0001);
	end
end

function onStepHit()
	--Center Camera
	if curStep >= 0 and curStep <= 256 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 410);
		setProperty('camFollow.x', 727);
	elseif curStep >= 536 and curStep <= 896 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 410);
		setProperty('camFollow.x', 727);
	elseif curStep >= 1024 and curStep <= 1088 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 410);
		setProperty('camFollow.x', 727);
	elseif curStep >= 1104 and curStep <= 1152 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 410);
		setProperty('camFollow.x', 727);
	elseif curStep >= 1280 and curStep <= 1408 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 410);
		setProperty('camFollow.x', 727);
	elseif curStep >= 1664 and curStep <= 1856 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 410);
		setProperty('camFollow.x', 727);
	elseif curStep >= 1888 and curStep <= 1936 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 435);
		setProperty('camFollow.x', 700);
	elseif curStep >= 2112 and curStep <= 2174 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 440);
		setProperty('camFollow.x', 700);
	elseif curStep >= 2175 and curStep <= 2527 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 310);
		setProperty('camFollow.x', 700);
	elseif curStep >= 0 and curStep <= 2112 then
		setProperty('isCameraOnForcedPos', false);
	end
	
	
end

function toggleLights(num)
	if num == 0 then
		setProperty('leftLights.alpha', 0.0001);
		setProperty('rightLights.alpha', 1);
	end
	if num == 1 then
		setProperty('leftLights.alpha', 1);
		setProperty('rightLights.alpha', 0.0001);
	end
	if num == 2 then
		setProperty('leftLights.alpha', 1);
		setProperty('rightLights.alpha', 1);
	end
	if num == 3 then
		setProperty('leftLights.alpha', 0.0001);
		setProperty('rightLights.alpha', 0.0001);
	end
end

function cutIn(num)
	if num == 0 then -- adds the cutins
		doTweenX('SourCutin', 'SourCutin', 0, 1, "cubeinout");
		doTweenX('SweetCutIn', 'SweetCutIn', 0, 1, "cubeinout");
	end
	if num == 1 then -- tween away cutins
		doTweenX('SourCutin', 'SourCutin', 1280, 0.5, "circinout");
		doTweenX('SweetCutIn', 'SweetCutIn', -1280, 0.5, "circinout");
	end
	
	--Moving tweens
	if num == 2 then -- tween in sourBack and BF
		doTweenX('boyfriendGroup', 'boyfriendGroup', 1000, 0.7, "cubeinout");
	end
	if num == 3 then -- tween away BF and sourBack
		doTweenX('boyfriendGroup', 'boyfriendGroup', 1800, 0.7, "cubeinout");
	end
	
	if num == 4 then -- tween in sweetback and dad
		doTweenX('dadGroup', 'dadGroup', 300, 0.7, "cubeinout");
	end
	if num == 5 then -- tween away sweetback and dad
		doTweenX('dadGroup', 'dadGroup', -500, 0.7, "cubeinout");
	end
	
	if num == 6 then -- tween in bf and dad
		doTweenX('dadGroup', 'dadGroup', 300, 0.7, "cubeinout");
		doTweenX('boyfriendGroup', 'boyfriendGroup', 1000, 0.7, "cubeinout");
	end
	
	if num == 7 then -- tween out bf and dad
		doTweenX('dadGroup', 'dadGroup', -500, 0.7, "cubeinout");
		doTweenX('boyfriendGroup', 'boyfriendGroup', 1800, 0.7, "cubeinout");
	end
	
	--Reset
	if num == 9 then -- reset
		doTweenX('transition', 'transition', 1280, 0.8);
		runTimer('hueh', 0.4);
	end
	
	--Initialize
	if num == 10 then -- initialize while the cutins are active
		--doTweenX('dadGroup', 'dadGroup', -500, 0.1);
		--doTweenY('boyfriendGroup', 'boyfriendGroup', 100, 0.01);
		setProperty('defaultCamZoom', 1);
		setProperty('camZooming', true);
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 490);
		setProperty('camFollow.x', 777);
		setProperty('Rave.alpha', 1);
		setProperty('spotlight.alpha', 1);
		setProperty('sourBack.alpha', 1);
		setProperty('sweetBack.alpha', 1);
		setProperty('foreground.visible', false);
		setProperty('leftLights.visible', false);
		setProperty('rightLights.visible', false);
		setProperty('crowd0.visible', false);
		setProperty('crowd1.visible', false);
		setProperty('crowd2.visible', false);
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'hueh' then
		setProperty('isCameraOnForcedPos', false);
		setProperty('camFollow.y', 400);
		setProperty('camFollow.x', 850);
		doTweenX('boyfriendGroup', 'boyfriendGroup', 950, 0.01);
		doTweenY('boyfriendGroup', 'boyfriendGroup', 150, 0.01);
		doTweenX('dadGroup', 'dadGroup', 0, 0.01);
		setProperty('Rave.alpha', 0.001);
		setProperty('spotlight.alpha', 0.001);
		setProperty('sourBack.alpha', 0.001);
		setProperty('sweetBack.alpha', 0.001);
		setProperty('defaultCamZoom', 0.6);
		setProperty('foreground.visible', true);
		setProperty('leftLights.visible', true);
		setProperty('rightLights.visible', true);
		setProperty('crowd0.visible', true);
		setProperty('crowd1.visible', true);
		setProperty('crowd2.visible', true);
	end
	if tag == 'cloud0' then
		doTweenY('crowd0', 'crowd0', -950, 0.15, "circout");
	end
	if tag == 'cloud1' then
		doTweenY('crowd1', 'crowd1', -950, 0.15, "circout");
	end
	if tag == 'cloud2' then
		doTweenY('crowd2', 'crowd2', -950, 0.15, "circout");
	end
	if tag == 'THEFOG' then
		fogSlowdown = true;
	end
end

function onBeatHit()
	bopCrowd();
end

function bopCrowd(hueh)
	setProperty('crowd0.y', -900);
	setProperty('crowd1.y', -900);
	setProperty('crowd2.y', -900);
	
	runTimer('cloud0', 0.001);
	runTimer('cloud1', 0.1);
	runTimer('cloud2', 0.2);
end

function onUpdate(elapsed)
	if fogSlowdown == true then
		setProperty('fogLeft.velocity.x', (getProperty('fogLeft.velocity.x') - (elapsed * 20)));
		setProperty('fogRight.velocity.x', (getProperty('fogRight.velocity.x') + (elapsed * 20)));

		if getProperty('fogLeft.velocity.x') <= 0 then
			setProperty('fogLeft.velocity.x', 0);
			setProperty('fogRight.velocity.x', 0);
			fogSlowdown = false;
		end
	end
end
