function onCreate()
	makeAnimatedLuaSprite('Rave', 'closeup/RAVE-BG', -0, -60);
	addAnimationByPrefix('Rave', 'idle', 'RaveBG', 42, true);
	setScrollFactor('Rave', 0, 0);
	addLuaSprite('Rave', false);
	scaleObject('Rave', 1.5, 1.5);
    screenCenter('Rave');
	setProperty('Rave.alpha', 0.0001);

	makeLuaSprite('vin', 'closeup/raveglow', 0, 0);
	setScrollFactor('vin', 0, 0);
	addLuaSprite('vin', false);
	setObjectCamera('vin', 'effect');
	setProperty('vin.alpha', 0.0001);

	makeLuaSprite('white', '', -100, -100);
	makeGraphic('white', 1280*2, 720*2, 'ffffff');
	setScrollFactor('white', 0, 0);
	screenCenter('white');
	setProperty('white.alpha', 0.0001);
	addLuaSprite('white', true);
end

function thingie(num)
	num = tonumber(num)
	if num == 773 then
		doTweenAlpha('vin', 'vin', 1, 6);
	end
	if num == 832 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.x', 868);
		setProperty('camFollow.y', 369);
	end
	if num == 840 then
		doTweenX('moveCamX', 'camFollow', 868, 5);
		doTweenY('moveCamY', 'camFollow', -1251, 5);
		doTweenAlpha('white', 'white', 1, 5);
	end
	if num == 896 then
		setProperty('white.alpha', 0.0001);
		setProperty('camFollow.x', 748);
		setProperty('camera.target.x', 748);
		setProperty('Rave.alpha', 1);
		setProperty('defaultCamZoom', 0.72);
		doTweenY('bf', 'boyfriendGroup', -1550, 1, 'quadOut');
	end
	if num == 960 then
		doTweenY('dad', 'dadGroup', -1550, 1, 'quadOut');
	end
	if num == 1152 then
		setProperty('vin.alpha', 0.0001);
		setProperty('boyfriendGroup.y', getProperty('BF_Y'));
		setProperty('dadGroup.y', getProperty('DAD_Y'));
		
		setProperty('Rave.alpha', 0.0001);
		setProperty('camFollow.x', 868);
		setProperty('camFollow.y', 369);
		setProperty('camera.target.x', 868);
		setProperty('camera.target.y', 369);
		setProperty('isCameraOnForcedPos', false);
	end
end