function onCreate()
	addHaxeLibrary('FlxBackdrop', 'flixel.addons.display');

	posX = -900;
	posY = -500;
	scale = 1.1;

	makeLuaSprite('Sky', 'enzync/sky', posX, posY);
	setScrollFactor('Sky', 0.3, 0.3);
	scaleObject('Sky', scale, scale);
	addLuaSprite('Sky', false);

	makeLuaSprite('backcity', 'enzync/back', posX, posY);
	setScrollFactor('backcity', 0.7, 0.7);
	scaleObject('backcity', scale, scale);
	addLuaSprite('backcity', false);

	makeLuaSprite('building', 'enzync/buildings', posX, posY);
	setScrollFactor('building', 0.92, 0.92);
	scaleObject('building', scale, scale);
	addLuaSprite('building', false);

	makeLuaSprite('front', 'enzync/foreground', posX, posY);
	setScrollFactor('front', 1, 1);
	scaleObject('front', scale, scale);
	addLuaSprite('front', false);
	
	makeAnimatedLuaSprite('backbops', 'enzync/backfriends', 640, 520);
	addAnimationByPrefix('backbops', 'idle', 'CameoBops', 24, false);
	setScrollFactor('backbops', 0.96, 0.96);
	scaleObject('backbops', 0.4, 0.4);
	playAnim('backbops', 'idle');
	finishAnim('backbops');
	addLuaSprite('backbops', false);
	
	makeAnimatedLuaSprite('backbops2', 'enzync/backbusiness', -225, 532);
	addAnimationByPrefix('backbops2', 'idle', 'backbusiness', 24, false);
	setScrollFactor('backbops2', 0.96, 0.96);
	scaleObject('backbops2', 0.4, 0.4);
	playAnim('backbops2', 'idle');
	finishAnim('backbops2');
	addLuaSprite('backbops2', false);
	
	makeAnimatedLuaSprite('saff', 'enzync/saff', 1780, 435);
	addAnimationByPrefix('saff', 'idle', 'Saff', 24, false);
	scaleObject('saff', 0.8, 0.8);
	playAnim('saff', 'idle');
	finishAnim('saff');
	addLuaSprite('saff', false);

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

function onBeatHit()
	if curBeat % 2 == 0 then
		playAnim('backbops', 'idle');
		playAnim('backbops2', 'idle');
		playAnim('saff', 'idle');
	end
end