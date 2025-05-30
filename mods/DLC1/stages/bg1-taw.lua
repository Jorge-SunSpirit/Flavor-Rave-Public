local stageType = 0;

function onCreate()

	posX = -1000;
	posY = -700;
	scale = 1.5;

	makeLuaSprite('sky', 'bg1/sky', posX, posY);
	setScrollFactor('sky', 0, 0);
	scaleObject('sky', scale, scale);
	addLuaSprite('sky', false);

	makeLuaSprite('clouds', 'bg1/clouds', posX, posY);
	setScrollFactor('clouds', 0.15, 0.2);
	scaleObject('clouds', scale, scale);
	addLuaSprite('clouds', false);

	makeLuaSprite('farhill', 'bg1/farhill', posX, posY);
	setScrollFactor('farhill', 0.2, 1);
	scaleObject('farhill', scale, scale);
	addLuaSprite('farhill', false);

	makeLuaSprite('midhill', 'bg1/midhill', posX, posY);
	setScrollFactor('midhill', 0.25, 1);
	scaleObject('midhill', scale, scale);
	addLuaSprite('midhill', false);

	makeLuaSprite('hillR', 'bg1/hillR', posX, posY);
	setScrollFactor('hillR', 0.3, 1);
	scaleObject('hillR', scale, scale);
	addLuaSprite('hillR', false);

	makeLuaSprite('hillL', 'bg1/hillL', posX, posY);
	setScrollFactor('hillL', 0.3, 1);
	scaleObject('hillL', scale, scale);
	addLuaSprite('hillL', false);

	makeLuaSprite('atmosphere', 'bg1/atmosphere', posX, posY);
	setScrollFactor('atmosphere', 0.3, 1);
	scaleObject('atmosphere', scale, scale);
	addLuaSprite('atmosphere', false);

	makeLuaSprite('trees', 'bg1/trees', posX, posY);
	setScrollFactor('trees', 0.4, 1);
	scaleObject('trees', scale, scale);
	addLuaSprite('trees', false);

	makeLuaSprite('streetlamps', 'bg1/streetlamps', posX, posY);
	setScrollFactor('streetlamps', 0.6, 1);
	scaleObject('streetlamps', scale, scale);
	addLuaSprite('streetlamps', false);

	makeLuaSprite('streetlights', 'bg1/streetlights', posX, posY);
	setScrollFactor('streetlights', 0.6, 1);
	scaleObject('streetlights', scale, scale);
	setProperty('streetlights.alpha', 0);
	addLuaSprite('streetlights', false);

	makeLuaSprite('parking', 'bg1/parking', posX, posY);
	setScrollFactor('parking', 1, 1);
	scaleObject('parking', scale, scale);
	addLuaSprite('parking', false);

	makeLuaSprite('venuespotL', 'bg1/venuespot', posX + 1315, posY - 90);
	setScrollFactor('venuespotL', 0.45, 1);
	scaleObject('venuespotL', scale, scale);
	setProperty('venuespotL.alpha', 0);
	setProperty('venuespotL.angle', -35.5);
	setProperty('venuespotL.origin.x', 314);
	setProperty('venuespotL.origin.y', 900);
	addLuaSprite('venuespotL', false);

	makeLuaSprite('venuespotR', 'bg1/venuespot', posX + 1650, posY - 90);
	setScrollFactor('venuespotR', 0.45, 1);
	scaleObject('venuespotR', scale, scale);
	setProperty('venuespotR.alpha', 0);
	setProperty('venuespotR.angle', 35.5);
	setProperty('venuespotR.origin.x', 314);
	setProperty('venuespotR.origin.y', 900);
	addLuaSprite('venuespotR', false);

	makeLuaSprite('venue', 'bg1/venue', posX, posY);
	setScrollFactor('venue', 0.5, 1);
	scaleObject('venue', scale, scale);
	addLuaSprite('venue', false);

	makeLuaSprite('sweettruck', 'bg1/sweettruck', posX, posY);
	setScrollFactor('sweettruck', 0.7, 1);
	scaleObject('sweettruck', scale, scale);
	addLuaSprite('sweettruck', false);

	makeLuaSprite('sweettrucklight', 'bg1/sweettrucklight', posX, posY);
	setScrollFactor('sweettrucklight', 0.7, 1);
	scaleObject('sweettrucklight', scale, scale);
	setProperty('sweettrucklight.alpha', 0);
	addLuaSprite('sweettrucklight', false);

	makeLuaSprite('sourvan', 'bg1/sourvan', posX, posY);
	setScrollFactor('sourvan', 0.8, 1);
	scaleObject('sourvan', scale, scale);
	addLuaSprite('sourvan', false);

	makeLuaSprite('sourvanlight', 'bg1/sourvanlight', posX, posY);
	setScrollFactor('sourvanlight', 0.8, 1);
	scaleObject('sourvanlight', scale, scale);
	setProperty('sourvanlight.alpha', 0);
	addLuaSprite('sourvanlight', false);

	makeLuaSprite('sweetbus', 'bg1/sweetbus', posX, posY);
	setScrollFactor('sweetbus', 0.8, 1);
	scaleObject('sweetbus', scale, scale);
	addLuaSprite('sweetbus', false);

	makeLuaSprite('sweetbuslight', 'bg1/sweetbuslight', posX, posY);
	setScrollFactor('sweetbuslight', 0.8, 1);
	scaleObject('sweetbuslight', scale, scale);
	setProperty('sweetbuslight.alpha', 0);
	addLuaSprite('sweetbuslight', false);

	makeLuaSprite('equipment', 'bg1/equipment', posX, posY);
	setScrollFactor('equipment', 0.95, 1);
	scaleObject('equipment', scale, scale);
	addLuaSprite('equipment', false);
	
	
	posX = -1400;
	posY = -950;
	scale = 1.7;

	makeLuaSprite('sky2', 'bg2/SourSweet_bg2_1', posX, posY);
	setScrollFactor('sky2', 0.1, 1);
	scaleObject('sky2', scale, scale);
	setProperty('sky2.alpha', 0.001);
	addLuaSprite('sky2', false);

	makeLuaSprite('bg', 'bg2/SourSweet_bg2_2', posX, posY);
	setScrollFactor('bg', 0.8, 1);
	scaleObject('bg', scale, scale);
	setProperty('bg.alpha', 0.001);
	addLuaSprite('bg', false);

	makeLuaSprite('backlight', 'bg2/backlightoff', posX, posY);
	setScrollFactor('backlight', 0.8, 1);
	scaleObject('backlight', scale, scale);
	setProperty('backlight.alpha', 0.001);
	addLuaSprite('backlight', false);

	precacheImage('bg2/backlightall');
	precacheImage('bg2/backlightsour1');
	precacheImage('bg2/backlightsour2');
	precacheImage('bg2/backlightsweet1');
	precacheImage('bg2/backlightsweet2');
	
	makeLuaSprite('bglights', 'bg2/SourSweet_bg2_2_lights', posX, posY);
	setScrollFactor('bglights', 0.8, 1);
	scaleObject('bglights', scale, scale);
	setProperty('bglights.alpha', 0.001);
	addLuaSprite('bglights', false);

	makeAnimatedLuaSprite('picante', 'stages/taw-extras/Picante', 510, 225);
	addAnimationByPrefix('picante', 'idle', 'Picante', 24, false);
	setScrollFactor('picante', 1, 1);
	scaleObject('picante', 1, 1);
	addLuaSprite('picante', false);
	setProperty('picante.alpha', 0.0001);
	
	makeAnimatedLuaSprite('flambe', 'stages/taw-extras/Flambe', 1600, 420);
	addAnimationByPrefix('flambe', 'idle', 'Flambe', 24, false);
	setScrollFactor('flambe', 1, 1);
	scaleObject('flambe', 1, 1);
	addLuaSprite('flambe', false);
	setProperty('flambe.alpha', 0.0001);
	
	makeLuaSprite('extraplat', 'bg2/extraplatforms', posX, posY);
	setScrollFactor('extraplat', 1, 1);
	scaleObject('extraplat', scale, scale);
	setProperty('extraplat.alpha', 0.001);
	addLuaSprite('extraplat', false);

	makeAnimatedLuaSprite('neo', 'stages/taw-extras/Neapolitan', -490, 300);
	addAnimationByPrefix('neo', 'Left', 'NeapolitanLeft', 24, false);
	addAnimationByPrefix('neo', 'Right', 'NeapolitanRight', 24, false);
	setScrollFactor('neo', 1, 1);
	scaleObject('neo', 1, 1);
	addLuaSprite('neo', true);
	setProperty('neo.alpha', 0.0001);

	makeLuaSprite('leftLights', 'bg2/Left_Light_1', posX, posY);
	setScrollFactor('leftLights', 1.1, 1);
	scaleObject('leftLights', scale, scale);
	setProperty('leftLights.alpha', 0.001);
	addLuaSprite('leftLights', true);
	
	makeLuaSprite('rightLights', 'bg2/Right_Light_1', posX, posY);
	setScrollFactor('rightLights', 1.1, 1);
	scaleObject('rightLights', scale, scale);
	setProperty('rightLights.alpha', 0.001);
	addLuaSprite('rightLights', true);

	makeLuaSprite('foreground', 'bg2/SourSweet_bg2_3', posX, posY);
	setScrollFactor('foreground', 1.1, 1);
	scaleObject('foreground', scale, scale);
	setProperty('foreground.alpha', 0.001);
	addLuaSprite('foreground', true);

	for i = 0,2,1 do
		makeLuaSprite('crowd' .. i, 'bg2/crowd' .. i, posX, posY);
		scaleObject('crowd' .. i, scale, scale);
		addLuaSprite('crowd' .. i, true);
		setProperty('crowd' .. i .. '.alpha', 0.001);
	end

	setScrollFactor('crowd0', 1.2, 1);
	setScrollFactor('crowd1', 1.3, 1);
	setScrollFactor('crowd2', 1.5, 1);

	-- TRANSITION
	makeLuaSprite('transition', 'closeup/TransitionOut', -2600, 0);
	setScrollFactor('transition', 0, 0);
	addLuaSprite('transition', false);
	setObjectCamera('transition', 'effect');

	makeLuaSprite('barTop', 'closeup/TightBars', 0, -102);
	setScrollFactor('barTop', 0, 0);
	scaleObject('barTop', 1.1, 1);
	addLuaSprite('barTop', true);
	setObjectCamera('barTop', 'effect');

	makeLuaSprite('barBottom', 'closeup/TightBars', 0, 822);
	setScrollFactor('barBottom', 0, 0);
	scaleObject('barBottom', 1.1, 1);
	addLuaSprite('barBottom', true);
	setObjectCamera('barBottom', 'effect');
end

function onCreatePost()
end

local angleShit0 = 0;
local angleShit1 = 0.6;

function onUpdate(elapsed)
	if stageType == 0 then
		baseFrame = (1 / 60) / (elapsed / 1.5);

		angleShit0 = angleShit0 + (0.035 / baseFrame);
		angleShit1 = angleShit1 + (0.035 / baseFrame * 1.01);

		setProperty('sweettrucklight.alpha', getProperty('sweettrucklight.alpha') - ((crochet / 1000) * elapsed * 2.25));
		setProperty('sourvanlight.alpha', getProperty('sourvanlight.alpha') - ((crochet / 1000) * elapsed * 2.25));
		setProperty('sweetbuslight.alpha', getProperty('sweetbuslight.alpha') - ((crochet / 1000) * elapsed * 2.25));
		setProperty('streetlights.alpha', getProperty('streetlights.alpha') - ((crochet / 1000) * elapsed * 2));
		setProperty('venuespotL.alpha', getProperty('venuespotL.alpha') - ((crochet / 1000) * elapsed * 1.334));
		setProperty('venuespotR.alpha', getProperty('venuespotR.alpha') - ((crochet / 1000) * elapsed * 1.334));

		setProperty('venuespotL.angle', getProperty('venuespotL.angle') - ((math.sin(angleShit0) * 0.5) / baseFrame));
		setProperty('venuespotR.angle', getProperty('venuespotR.angle') + ((math.sin(angleShit1) * 0.6) / baseFrame));
	end
end

function onSongStart()
	setProperty('sweettrucklight.alpha', 1);
	setProperty('sourvanlight.alpha', 1);
	setProperty('sweetbuslight.alpha', 1);
	setProperty('streetlights.alpha', 1);
	setProperty('venuespotR.alpha', 1);
	setProperty('venuespotL.alpha', 1);
end

function onBeatHit()
	if curBeat % 2 == 0 and stageType == 0 then
		setProperty('sweettrucklight.alpha', 1);
		setProperty('sourvanlight.alpha', 1);
		setProperty('sweetbuslight.alpha', 1);
	end
	if curBeat % 4 == 0 and stageType == 0 then
		setProperty('streetlights.alpha', 1);
		setProperty('venuespotR.alpha', 1);
		setProperty('venuespotL.alpha', 1);
	end
	if curBeat % 2 == 0 then
		playAnim('picante', 'idle');
		playAnim('flambe', 'idle');
	end
	if curBeat % 1 == 0 then
		if danced then
			danced = false;
			playAnim('neo', 'Left');
		else
			danced = true;
			playAnim('neo', 'Right');
		end
	end
end

function changeStage(which)
	if which == '1' then
		stageType = 1;
		setProperty('sky.alpha', 0);
		setProperty('clouds.alpha', 0);
		setProperty('farhill.alpha', 0);
		setProperty('midhill.alpha', 0);
		setProperty('hillR.alpha', 0);
		setProperty('hillL.alpha', 0);
		setProperty('atmosphere.alpha', 0);
		setProperty('trees.alpha', 0);
		setProperty('streetlamps.alpha', 0);
		setProperty('streetlights.alpha', 0);
		setProperty('parking.alpha', 0);
		setProperty('venuespotL.alpha', 0);
		setProperty('venuespotR.alpha', 0);
		setProperty('venue.alpha', 0);
		setProperty('sweettruck.alpha', 0);
		setProperty('sweettrucklight.alpha', 0);
		setProperty('sourvan.alpha', 0);
		setProperty('sweetbus.alpha', 0);
		setProperty('sweetbuslight.alpha', 0);
		setProperty('equipment.alpha', 0);
		
		setProperty('sky2.alpha', 1);
		setProperty('bg.alpha', 1);
		setProperty('backlight.alpha', 1);
		setProperty('bglights.alpha', 1);
		setProperty('extraplat.alpha', 1);
		setProperty('leftLights.alpha', 1);
		setProperty('rightLights.alpha', 1);
		setProperty('foreground.alpha', 1);
		
		setProperty('boyfriendGroup.x', 770);
		setProperty('boyfriendGroup.y', 175);
		setProperty('extraGroup.x', 1150);
		setProperty('extraGroup.y', -50);
		
		setProperty('dadGroup.x', 15);
		setProperty('dadGroup.y', 100);
		setProperty('gfGroup.x', -200);
		setProperty('gfGroup.y', -50);
		
		runHaxeCode([[
			game.cameraBoundaries = [-1110, -590, 1942, 864];
			game.boyfriendCameraOffset = [0, -60];
			game.opponentCameraOffset = [0, -60];
		]]);
		setProperty('defaultCamZoom', 0.5);
		setObjectOrder('gfGroup', getObjectOrder('extraplat')-1);
		setObjectOrder('extraGroup', getObjectOrder('extraplat')-1);
	else
		stageType = 0;
		setProperty('sky.alpha', 1);
		setProperty('clouds.alpha', 1);
		setProperty('farhill.alpha', 1);
		setProperty('midhill.alpha', 1);
		setProperty('hillR.alpha', 1);
		setProperty('hillL.alpha', 1);
		setProperty('atmosphere.alpha', 1);
		setProperty('trees.alpha', 1);
		setProperty('streetlamps.alpha', 1);
		setProperty('streetlights.alpha', 1);
		setProperty('parking.alpha', 1);
		setProperty('venuespotL.alpha', 1);
		setProperty('venuespotR.alpha', 1);
		setProperty('venue.alpha', 1);
		setProperty('sweettruck.alpha', 1);
		setProperty('sweettrucklight.alpha', 1);
		setProperty('sourvan.alpha', 1);
		setProperty('sweetbus.alpha', 1);
		setProperty('sweetbuslight.alpha', 1);
		setProperty('equipment.alpha', 1);
		
		setProperty('sky2.alpha', 0);
		setProperty('bg.alpha', 0);
		setProperty('backlight.alpha', 0);
		setProperty('bglights.alpha', 0);
		setProperty('extraplat.alpha', 0);
		setProperty('leftLights.alpha', 0);
		setProperty('rightLights.alpha', 0);
		setProperty('foreground.alpha', 0);
		
		setProperty('boyfriendGroup.x', 1400);
		setProperty('boyfriendGroup.y', 220);
		setProperty('extraGroup.x', 1200);
		setProperty('extraGroup.y', 100);
		
		setProperty('dadGroup.x', 0);
		setProperty('dadGroup.y', 150);
		setProperty('gfGroup.x', 340);
		setProperty('gfGroup.y', 100);
		
		runHaxeCode([[
			game.cameraBoundaries = [-1110, -590, 1942, 864];
			game.boyfriendCameraOffset = [0, -60];
			game.opponentCameraOffset = [0, -60];
		]]);
		setProperty('defaultCamZoom', 0.75);
	end
end