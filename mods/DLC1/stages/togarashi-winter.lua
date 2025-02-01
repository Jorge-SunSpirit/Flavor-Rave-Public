function onCreate()
	addHaxeLibrary('FlxBackdrop', 'flixel.addons.display');

	posX = -1200;
	posY = -700;
	scale = 1.5;

	makeLuaSprite('Sky', 'stages/togarashi-winter/sky', posX, posY);
	setScrollFactor('Sky', 0.2, 0.2);
	scaleObject('Sky', scale, scale);
	addLuaSprite('Sky', false);

	makeLuaSprite('backcity', 'stages/togarashi-winter/back', posX, posY);
	setScrollFactor('backcity', 0.5, 0.5);
	scaleObject('backcity', scale, scale);
	addLuaSprite('backcity', false);

	makeLuaSprite('middle', 'stages/togarashi-winter/middle', posX, posY);
	setScrollFactor('middle', 0.8, 0.8);
	scaleObject('middle', scale, scale);
	addLuaSprite('middle', false);

	makeLuaSprite('front', 'stages/togarashi-winter/main', posX, posY);
	setScrollFactor('front', 1, 1);
	scaleObject('front', scale, scale);
	addLuaSprite('front', false);

	makeAnimatedLuaSprite('frostglaze', 'stages/togarashi-winter/FrostyGlaze', 660, 400);
	addAnimationByPrefix('frostglaze', 'idle', 'FrostedGlaze', 24, false);
	playAnim('frostglaze', 'idle');
	setScrollFactor('frostglaze', 1, 1);
	scaleObject('frostglaze', 0.7, 0.7);
	addLuaSprite('frostglaze', false);

	makeAnimatedLuaSprite('lantern', 'stages/togarashi-winter/lantern', 70, 220);
	addAnimationByPrefix('lantern', 'lantern', 'Lantern instance', 24, true);
	playAnim('lantern', 'idle');
	setProperty('lantern.alpha', 1);
	setScrollFactor('lantern', 1, 1);
	scaleObject('lantern', scale, scale);
	addLuaSprite('lantern', false);
	
	makeLuaSprite('fronter', 'stages/togarashi-winter/front', posX, posY);
	setScrollFactor('fronter', 1, 1);
	scaleObject('fronter', scale, scale);
	addLuaSprite('fronter', false);

	makeAnimatedLuaSprite('SoRetro', 'stages/togarashi-winter/Retro', -400, 180);
	addAnimationByPrefix('SoRetro', 'idle', 'RetroIdle', 24, false);
	playAnim('SoRetro', 'idle');
	setScrollFactor('SoRetro', 1, 1);
	scaleObject('SoRetro', 1.08, 1.08);
	addLuaSprite('SoRetro', false);

	makeAnimatedLuaSprite('troubleman', 'stages/togarashi-winter/Tman', 1560, 130);
	addAnimationByPrefix('troubleman', 'idle', 'TManIdle', 24, false);
	playAnim('troubleman', 'idle');
	setScrollFactor('troubleman', 1, 1);
	scaleObject('troubleman', 1.27, 1.27);
	addLuaSprite('troubleman', false);

	makeAnimatedLuaSprite('gate', 'stages/togarashi-winter/torii_winter', posX, posY);
	addAnimationByPrefix('gate', 'idle', 'torii_winter idle', 12, false);
	playAnim('gate', 'idle');
	finishAnim('gate');
	setProperty('gate.alpha', 1);
	setScrollFactor('gate', 1, 1);
	scaleObject('gate', scale, scale);
	addLuaSprite('gate', false);

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
end

function onBeatHit()
	if curBeat % 2 == 0 then
		playAnim('gate', 'idle');
	end
	if curBeat % 4 == 0 then
		playAnim('frostglaze', 'idle');
		playAnim('SoRetro', 'idle');
		playAnim('troubleman', 'idle');
	end
end