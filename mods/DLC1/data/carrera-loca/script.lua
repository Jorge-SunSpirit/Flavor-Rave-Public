local nighttime = false;
local camauto = true;

function onCreate()	

	makeAnimatedLuaSprite('SavoryLegs', 'stages/corianda-run/SavoryLegs', 500, -30);
	addAnimationByPrefix('SavoryLegs', 'idle', 'SavoryLegs', 26, true);
	playAnim('SavoryLegs', 'idle', true);
	setScrollFactor('SavoryLegs', 0.9, 0.7);
	addLuaSprite('SavoryLegs', false);

	makeLuaSprite('CutBG1', 'stages/corianda-run/CL/CLSky', 0, -0);
	setScrollFactor('CutBG1', 0, 0);
	scaleObject('CutBG1', 1.1, 1.1);
	addLuaSprite('CutBG1', false);
	setProperty('CutBG1.alpha', 0.0001);
	setObjectCamera('CutBG1', 'effect');
	
	makeLuaSprite('CutBG2', 'stages/corianda-run/CL/CLCity', 0, -0);
	setScrollFactor('CutBG2', 0, 0);
	scaleObject('CutBG2', 1.1, 1.1);
	addLuaSprite('CutBG2', false);
	setProperty('CutBG2.alpha', 0.0001);
	setObjectCamera('CutBG2', 'effect');

	makeLuaSprite('CutBG3', 'stages/corianda-run/CL/CLSavory', 0, -0);
	setScrollFactor('CutBG3', 0, 0);
	scaleObject('CutBG3', 1.1, 1.1);
	addLuaSprite('CutBG3', false);
	setProperty('CutBG3.alpha', 0.0001);
	setObjectCamera('CutBG3', 'effect');
	
	makeLuaSprite('CutBG4', 'stages/corianda-run/CL/CLGroundSide', 0, -0);
	setScrollFactor('CutBG4', 0, 0);
	scaleObject('CutBG4', 1.1, 1.1);
	addLuaSprite('CutBG4', false);
	setProperty('CutBG4.alpha', 0.0001);
	setObjectCamera('CutBG4', 'effect');
	
	makeLuaSprite('CutBG5', 'stages/corianda-run/CL/Rave', 0, -0);
	setScrollFactor('CutBG5', 0, 0);
	scaleObject('CutBG5', 1.1, 1.1);
	addLuaSprite('CutBG5', false);
	setProperty('CutBG5.alpha', 0.0001);
	setObjectCamera('CutBG5', 'effect');

	makeLuaSprite('CutBG6', 'stages/corianda-run/CL/CLSourRave', 0, -0);
	setScrollFactor('CutBG6', 0, 0);
	scaleObject('CutBG6', 1.1, 1.1);
	addLuaSprite('CutBG6', false);
	setProperty('CutBG6.alpha', 0.0001);
	setObjectCamera('CutBG6', 'effect');
	
	makeLuaSprite('CutBG7', 'stages/corianda-run/CL/CLGround', -100, -0);
	setScrollFactor('CutBG7', 0, 0);
	scaleObject('CutBG7', 1.1, 1.1);
	addLuaSprite('CutBG7', false);
	setProperty('CutBG7.alpha', 0.0001);
	setObjectCamera('CutBG7', 'effect');
	
	makeLuaSprite('CutBG8', 'stages/corianda-run/CL/CLDecor', -100, -0);
	setScrollFactor('CutBG8', 0, 0);
	scaleObject('CutBG8', 1.1, 1.1);
	addLuaSprite('CutBG8', false);
	setProperty('CutBG8.alpha', 0.0001);
	setObjectCamera('CutBG8', 'effect');
	
	makeLuaSprite('CutBG9', 'stages/corianda-run/sunset/skyscroll', 0, -880);
	setScrollFactor('CutBG9', 0, 0);
	scaleObject('CutBG9', 1, 1);
	addLuaSprite('CutBG9', false);
	setProperty('CutBG9.alpha', 0.0001);
	setObjectCamera('CutBG9', 'effect');
	
	makeLuaSprite('CutBG10', 'stages/corianda-run/sunset/sun', 0, -643);
	setScrollFactor('CutBG10', 0, 0);
	scaleObject('CutBG10', 1, 1);
	addLuaSprite('CutBG10', false);
	setProperty('CutBG10.alpha', 0.0001);
	setObjectCamera('CutBG10', 'effect');
	
	makeLuaSprite('CutBG11', 'stages/corianda-run/sunset/hills', -0, -0);
	setScrollFactor('CutBG11', 0, 0);
	scaleObject('CutBG11', 1, 1);
	addLuaSprite('CutBG11', false);
	setProperty('CutBG11.alpha', 0.0001);
	setObjectCamera('CutBG11', 'effect');

	makeLuaSprite('CutBG12', 'stages/corianda-run/sunset/hillsafter', -0, -0);
	setScrollFactor('CutBG12', 0, 0);
	scaleObject('CutBG12', 1, 1);
	addLuaSprite('CutBG12', false);
	setProperty('CutBG12.alpha', 0.0001);
	setObjectCamera('CutBG12', 'effect');

	addHaxeLibrary('FlxBackdrop', 'flixel.addons.display');

	runHaxeCode([[
		var clouds:FlxBackdrop = new FlxBackdrop(Paths.image('stages/corianda-run/clouds'), 0x01);
		clouds.antialiasing = ClientPrefs.globalAntialiasing;
		game.insert(game.members.indexOf(game.getLuaObject('SavoryLegs')) - 1, clouds);
		setVar('clouds', clouds);
	
		var wall:FlxBackdrop = new FlxBackdrop(Paths.image('stages/corianda-run/wall'), 0x01);
		wall.antialiasing = ClientPrefs.globalAntialiasing;
		game.insert(game.members.indexOf(game.getLuaObject('SavoryLegs')) + 1, wall);
		setVar('wall', wall);
		
		var wallrave:FlxBackdrop = new FlxBackdrop(Paths.image('stages/corianda-run/wallrave'), 0x01);
		wallrave.antialiasing = ClientPrefs.globalAntialiasing;
		game.insert(game.members.indexOf(game.getLuaObject('wall')) + 1, wallrave);
		setVar('wallrave', wallrave);
		
		var speedlines:FlxBackdrop = new FlxBackdrop(Paths.image('stages/corianda-run/speedlines'), 0x01);
		speedlines.antialiasing = ClientPrefs.globalAntialiasing;
		game.insert(game.members.indexOf(game.getLuaObject('wallrave')) + 1, speedlines);
		speedlines.y = -400;
		setVar('speedlines', speedlines);
	]]);

	setScrollFactor('wall', 0.9, 0.7);
	setProperty('wall.velocity.x', -3500);	
	setScrollFactor('clouds', 0.9, 0.7);
	setProperty('clouds.velocity.x', -800);
	setProperty('clouds.y', -150);
	setScrollFactor('wallrave', 0.9, 0.7);
	setProperty('wallrave.velocity.x', -4000);	
	setProperty('wallrave.alpha', 0.0001);
	setScrollFactor('speedlines', 1.8, 1.8);
	setProperty('speedlines.velocity.x', -6000);	
	setProperty('speedlines.alpha', 0.0001);

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

	makeLuaSprite('whitehueh', 'dreamcast/art_BG/whitehueh', 0, 0);
	setScrollFactor('whitehueh', 0, 0);
	addLuaSprite('whitehueh', true);
	setObjectCamera('whitehueh', 'effect');
	setProperty('whitehueh.alpha', 0.0001);

	makeLuaSprite('black', '', -100, -100);
    makeGraphic('black', 1280*2, 720*2, '000000');
    setScrollFactor('black', 0, 0);
    screenCenter('black');
	setObjectCamera('black', 'effect')
	addLuaSprite('black', true);

	makeAnimatedLuaSprite('Ensemble', 'stages/corianda-run/Ensemble', 0, 0);
	addAnimationByPrefix('Ensemble', 'idle', 'Ensemble', 26, false);
    screenCenter('Ensemble');
	setProperty('Ensemble.alpha', 0.0001);
	setObjectCamera('Ensemble', 'effect')
	addLuaSprite('Ensemble', true);

	makeLuaSprite('transition', 'corianda/hattransition', 1280, 0);
	setScrollFactor('transition', 0, 0);
	scaleObject('transition', 1, 1);
	addLuaSprite('transition', true);
	setObjectCamera('transition', 'effect');
end

function onCreatePost()
	setProperty('boyfriend.danceEveryNumBeats', 4);
	setScrollFactor('boyfriend', 0.9, 0.7);
	setScrollFactor('dadGroup', 1.7, 1.4);
	setProperty('boyfriend.x', -1500);
	setProperty('SavoryLegs.x', -1500);
	setProperty('dadGroup.x', -2100);
end

function frantic(num)
	if num == '1' then
		cameraSetTarget('bf');
		setProperty('camFollow.x', 650);
		setProperty('camFollow.y', -164);
		setProperty('defaultCamZoom', 0.9);
	end
	if num == '2' then
		cameraSetTarget('dad');
		setProperty('camFollow.x', 320);
		setProperty('camFollow.y', 127);
		setProperty('defaultCamZoom', 0.7);
	end
end

function thingie(num)
	num = tonumber(num)
	if num == 1 then
		setProperty('black.alpha', 0.0001);
	end
	if num == 60 then
		doTweenX('SavoryLegs', 'SavoryLegs', 622, 1.98, "quadinout");
		doTweenX('boyfriend', 'boyfriend', 550, 2, "quadinout");
	end 
	if num == 94 then
		doTweenX('dadGroup', 'dadGroup', -700, 1.3, "quadinout");
	end 
	if num == 568 then
		doTweenAlpha('whitehueh', 'whitehueh', 1, 0.7);
	end
	if num == 580 then
		setProperty('speedlines.alpha', 1);
		setProperty('clouds.alpha', 0.0001);
		doTweenColor('wallCol;', 'wall', 'B4F7FA', '0.1', 'linear');
		setProperty('whitehueh.alpha', 0.0001);
		setProperty('RaveSpeed.alpha', 1);
		setProperty('wall.velocity.x', -4000);
	end
	if num == 1063 then
		doTweenX('transition', 'transition', -2600, 0.22);
	end
	if num == 1064 then
		setProperty('black.alpha', 1);
	end
	if num == 1072 then
		setProperty('Ensemble.alpha', 1);
		playAnim('Ensemble', 'idle', true);
	end
	if num == 1088 then
		setProperty('Ensemble.alpha', 0.0001);
		setProperty('black.alpha', 0.0001);
		setProperty('RaveSpeed.alpha', 0.0001);
		setProperty('RaveSpeedSavory.alpha', 1);
		setProperty('wall.alpha', 0.0001);
		setProperty('wallrave.alpha', 1);
	end
	if num == 1344 then
		setProperty('speedlines.alpha', 0.0001);
		doTweenX('CutBG1X', 'CutBG1', -200, 10);
		doTweenX('CutBG2X', 'CutBG2', -280, 10);
		doTweenX('CutBG3X', 'CutBG3', -400, 10);
		setProperty('CutBG1.alpha', 1);
		setProperty('CutBG2.alpha', 1);
		setProperty('CutBG3.alpha', 1);
	end
	if num == 1412 then
		doTweenX('CutBG4X', 'CutBG4', -200, 7);
		doTweenX('CutBG5X', 'CutBG5', -270, 7);
		doTweenX('CutBG6X', 'CutBG6', -300, 7);
		doTweenAlpha('CutBG4A', 'CutBG4', 1, 1);
		doTweenAlpha('CutBG5A', 'CutBG5', 1, 1);
		doTweenAlpha('CutBG6A', 'CutBG6', 1, 1);
	end
	if num == 1440 then
		doTweenX('CutBG7X', 'CutBG7', -300, 10);
		doTweenX('CutBG8X', 'CutBG8', -400, 10);
		setProperty('CutBG1.alpha', 0.0001);
		setProperty('CutBG2.alpha', 0.0001);
		setProperty('CutBG3.alpha', 0.0001);
		setProperty('CutBG4.alpha', 0.0001);
		setProperty('CutBG5.alpha', 0.0001);
		setProperty('CutBG6.alpha', 0.0001);
		setProperty('CutBG7.alpha', 1);
		setProperty('CutBG8.alpha', 1);
		setProperty('wall.alpha', 1);
		setProperty('clouds.alpha', 1);
		setProperty('RaveSpeedSavory.alpha', 0.0001);
		setProperty('wall.alpha', 1);
		setProperty('wallrave.alpha', 0.0001);
	end
	if num == 1472 then
		doTweenAlpha('CutBG9A', 'CutBG9', 1, 1);
		doTweenAlpha('CutBG10A', 'CutBG10', 1, 1);
		doTweenAlpha('CutBG11A', 'CutBG11', 1, 1);
		doTweenAlpha('CutBG12A', 'CutBG12', 1, 1);
	end
	if num == 1488 then
		setProperty('CutBG7.alpha', 0.0001);
		setProperty('CutBG8.alpha', 0.0001);
		doTweenY('CutBG11Y', 'CutBG11', 50, 12, "quadinout");
		doTweenY('CutBG12Y', 'CutBG12', 50, 12, "quadinout");
		doTweenY('CutBG9Y', 'CutBG9', 0, 11, "quadinout");
		doTweenY('CutBG10Y', 'CutBG10', 100, 10, "quadinout");
		doTweenAlpha('CutBG12A', 'CutBG12', 0.0001, 7);
	end
	if num == 1584 then
		doTweenColor('wallCol;', 'wall', '315199', '0.001', 'linear');
		doTweenColor('cityscrollCol;', 'cityscroll', '0A101C', '0.001', 'linear');
		doTweenColor('cloudsCol;', 'clouds', 'C7EAFF', '0.001', 'linear');
		setProperty('RaveSpeed.alpha', 0.0001);
		setProperty('sky.alpha', 0.0001);
		setProperty('skynight.alpha', 1);
	end
	if num == 1600 then
		doTweenAlpha('CutBG9A', 'CutBG9', 0.0001, 1);
		doTweenAlpha('CutBG10A', 'CutBG10', 0.0001, 1);
		doTweenAlpha('CutBG11A', 'CutBG11', 0.0001, 1);
	end
	if num == 1728 then
		camauto = false;
	end
	if num == 1824 then
		camauto = true;
	end
	if num == 1855 then
		nighttime = true;
	end
	if num == 2140 then
		doTweenX('SavoryLegs', 'SavoryLegs', 2172, 0.8, "quadinout");
		doTweenX('boyfriend', 'boyfriend', 2100, 0.8, "quadinout");
		doTweenX('dadGroup', 'dadGroup', 1800, 1, "quadinout");
	end 
end

function onMoveCamera(focus)
	if focus == 'boyfriend' and camauto then
		setProperty('camFollow.x', 650);
		setProperty('camFollow.y', -164);
		setProperty('defaultCamZoom', 0.9);
	elseif focus == 'dad' and camauto then
		setProperty('camFollow.x', 375);
		setProperty('camFollow.y', 127);
		setProperty('defaultCamZoom', 0.7);
	end
end

function onBeatHit()
	if curBeat % 4 == 0 and nighttime then
		setProperty('cityscrollnight.alpha', 1);
	end
end