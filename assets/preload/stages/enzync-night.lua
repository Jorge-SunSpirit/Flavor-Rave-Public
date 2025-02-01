function onCreate()
	addHaxeLibrary('FlxBackdrop', 'flixel.addons.display');

	posX = -900;
	posY = -500;
	scale = 1.1;

	makeLuaSprite('Sky', 'enzync-night/sky', posX, posY);
	setScrollFactor('Sky', 0.3, 0.3);
	scaleObject('Sky', scale, scale);
	addLuaSprite('Sky', false);

	makeLuaSprite('backcity', 'enzync-night/back', posX, posY);
	setScrollFactor('backcity', 0.7, 0.7);
	scaleObject('backcity', scale, scale);
	addLuaSprite('backcity', false);

	makeLuaSprite('building', 'enzync-night/buildings', posX, posY);
	setScrollFactor('building', 0.92, 0.92);
	scaleObject('building', scale, scale);
	addLuaSprite('building', false);

	makeLuaSprite('front', 'enzync-night/foreground', posX, posY);
	setScrollFactor('front', 1, 1);
	scaleObject('front', scale, scale);
	addLuaSprite('front', false);

	makeAnimatedLuaSprite('backbops', 'enzync-night/momogogo', 720, 510);
	addAnimationByPrefix('backbops', 'idle', 'MomoGogo', 24, false);
	setScrollFactor('backbops', 0.96, 0.96);
	scaleObject('backbops', 0.4, 0.4);
	playAnim('backbops', 'idle');
	finishAnim('backbops');
	addLuaSprite('backbops', false);

	makeAnimatedLuaSprite('backbops2', 'enzync-night/prime', -285, 518);
	addAnimationByPrefix('backbops2', 'idle', 'PrimeIdle', 24, false);
	setScrollFactor('backbops2', 0.96, 0.96);
	scaleObject('backbops2', 0.45, 0.45);
	playAnim('backbops2', 'idle');
	finishAnim('backbops2');
	addLuaSprite('backbops2', false);

end

function onBeatHit()
	if curBeat % 2 == 0 then
		playAnim('backbops', 'idle');
		playAnim('backbops2', 'idle');
		playAnim('rude1', 'idle');
	end
end