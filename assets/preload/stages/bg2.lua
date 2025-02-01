function onCreate()

	posX = -1400;
	posY = -950;
	scale = 1.7;

	makeLuaSprite('sky', 'bg2/SourSweet_bg2_1', posX, posY);
	setScrollFactor('sky', 0.1, 1);
	scaleObject('sky', scale, scale);
	addLuaSprite('sky', false);

	makeLuaSprite('bg', 'bg2/SourSweet_bg2_2', posX, posY);
	setScrollFactor('bg', 0.8, 1);
	scaleObject('bg', scale, scale);
	addLuaSprite('bg', false);

	makeLuaSprite('backlight', 'bg2/backlightoff', posX, posY);
	setScrollFactor('backlight', 0.8, 1);
	scaleObject('backlight', scale, scale);
	addLuaSprite('backlight', false);

	precacheImage('bg2/backlightall');
	precacheImage('bg2/backlightsour1');
	precacheImage('bg2/backlightsour2');
	precacheImage('bg2/backlightsweet1');
	precacheImage('bg2/backlightsweet2');
	
	makeLuaSprite('bglights', 'bg2/SourSweet_bg2_2_lights', posX, posY);
	setScrollFactor('bglights', 0.8, 1);
	scaleObject('bglights', scale, scale);
	addLuaSprite('bglights', false);
	
	makeLuaSprite('leftLights', 'bg2/Left_Light_1', posX, posY);
	setScrollFactor('leftLights', 1.1, 1);
	scaleObject('leftLights', scale, scale);
	addLuaSprite('leftLights', true);
	
	makeLuaSprite('rightLights', 'bg2/Right_Light_1', posX, posY);
	setScrollFactor('rightLights', 1.1, 1);
	scaleObject('rightLights', scale, scale);
	addLuaSprite('rightLights', true);

	makeLuaSprite('foreground', 'bg2/SourSweet_bg2_3', posX, posY);
	setScrollFactor('foreground', 1.1, 1);
	scaleObject('foreground', scale, scale);
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

	-- EVENTS
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
	
	makeAnimatedLuaSprite('SourCutin', 'closeup/SourCutin', -1280, 91);
	addAnimationByPrefix('SourCutin', 'idle', 'SourCutin', 24, true);
	playAnim('SourCutin', 'idle');
	setScrollFactor('SourCutin', 0, 0);
	addLuaSprite('SourCutin', true);
	setObjectCamera('SourCutin', 'effect');
	
	makeAnimatedLuaSprite('SweetCutIn', 'closeup/SweetCutIns', 1280, 359);
	addAnimationByPrefix('SweetCutIn', 'idle', 'SugarCutin', 24, true);
	playAnim('SweetCutIn', 'idle');
	setScrollFactor('SweetCutIn', 0, 0);
	addLuaSprite('SweetCutIn', true);
	setObjectCamera('SweetCutIn', 'effect');
	
	toggleLights(3);

	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end