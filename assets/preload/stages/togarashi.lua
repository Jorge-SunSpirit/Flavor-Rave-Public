function onCreate()
	addHaxeLibrary('FlxBackdrop', 'flixel.addons.display');

	posX = -1200;
	posY = -700;
	scale = 1.5;

	makeLuaSprite('Sky', 'togarashi/sky', posX, posY);
	setScrollFactor('Sky', 0.2, 0.2);
	scaleObject('Sky', scale, scale);
	addLuaSprite('Sky', false);

	makeLuaSprite('backcity', 'togarashi/back', posX, posY);
	setScrollFactor('backcity', 0.5, 0.5);
	scaleObject('backcity', scale, scale);
	addLuaSprite('backcity', false);

	makeLuaSprite('middle', 'togarashi/middle', posX, posY);
	setScrollFactor('middle', 0.8, 0.8);
	scaleObject('middle', scale, scale);
	addLuaSprite('middle', false);

	makeLuaSprite('front', 'togarashi/main', posX, posY);
	setScrollFactor('front', 1, 1);
	scaleObject('front', scale, scale);
	addLuaSprite('front', false);
	
	makeAnimatedLuaSprite('contest2', 'togarashi/RightCrowd', 660, 420);
	addAnimationByPrefix('contest2', 'idle', 'Mazapan', 24, false);
	playAnim('contest2', 'idle');
	setProperty('contest2.alpha', 0.0001);
	setScrollFactor('contest2', 1, 1);
	scaleObject('contest2', 0.7, 0.7);
	addLuaSprite('contest2', false);
	
	makeAnimatedLuaSprite('gays', 'togarashi/omgilovegaypeople', 850, 350);
	addAnimationByPrefix('gays', 'idle', 'gays', 24, false);
	playAnim('gays', 'idle');
	finishAnim('gays');
	setProperty('gays.alpha', 1);
	setScrollFactor('gays', 1, 1);
	scaleObject('gays', 0.8, 0.8);
	addLuaSprite('gays', false);
	
	makeAnimatedLuaSprite('lantern', 'togarashi/lantern', 70, 220);
	addAnimationByPrefix('lantern', 'lantern', 'Lantern instance', 24, true);
	playAnim('lantern', 'idle');
	setProperty('lantern.alpha', 1);
	setScrollFactor('lantern', 1, 1);
	scaleObject('lantern', scale, scale);
	addLuaSprite('lantern', false);
	
	makeAnimatedLuaSprite('gays2', 'togarashi/FurikakeNori', 370, 360);
	addAnimationByPrefix('gays2', 'idle', 'FuriNori', 24, false);
	playAnim('gays2', 'idle');
	finishAnim('gays2');
	setProperty('gays2.alpha', 1);
	setScrollFactor('gays2', 1, 1);
	scaleObject('gays2', 0.47, 0.47);
	addLuaSprite('gays2', false);
	
	makeLuaSprite('fronter', 'togarashi/front', posX, posY);
	setScrollFactor('fronter', 1, 1);
	scaleObject('fronter', scale, scale);
	addLuaSprite('fronter', false);
	
	makeAnimatedLuaSprite('contest1', 'togarashi/LeftCrowd', -400, 130);
	addAnimationByPrefix('contest1', 'idle', 'LeftCrowd', 24, false);
	playAnim('contest1', 'idle');
	setProperty('contest1.alpha', 0.0001);
	setScrollFactor('contest1', 1, 1);
	scaleObject('contest1', 1.3, 1.3);
	addLuaSprite('contest1', false);

	makeAnimatedLuaSprite('contest3', 'togarashi/MiddleCrowd', 1400, 200);
	addAnimationByPrefix('contest3', 'idle', 'MiddleCrowd', 24, false);
	playAnim('contest3', 'idle');
	setProperty('contest3.alpha', 0.0001);
	setScrollFactor('contest3', 1, 1);
	scaleObject('contest3', 1.3, 1.3);
	addLuaSprite('contest3', false);
	
	makeAnimatedLuaSprite('gate', 'togarashi/gate', posX, posY);
	addAnimationByPrefix('gate', 'idle', 'GateBump', 24, false);
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
	setObjectCamera('barTop', 'hud');

	makeLuaSprite('barBottom', 'closeup/TightBars', 0, 822);
	setScrollFactor('barBottom', 0, 0);
	scaleObject('barBottom', 1.1, 1);
	addLuaSprite('barBottom', false);
	setObjectCamera('barBottom', 'hud');

	makeAnimatedLuaSprite('borderfire', 'togarashi/borderburn', posX, posY);
	addAnimationByPrefix('borderfire', 'idle', 'BorderBurn', 30, true);
	playAnim('borderfire', 'idle');
	setScrollFactor('borderfire', 0, 0);
    screenCenter('borderfire');
	addLuaSprite('borderfire', false);
	setObjectCamera('borderfire', 'hud');
	setProperty('borderfire.alpha', 0.0001);

end

function onBeatHit()
	if curBeat % 2 == 0 then
		playAnim('gate', 'idle');
	end
	if curBeat % 4 == 0 then
		playAnim('gays', 'idle');
		playAnim('gays2', 'idle');
	end
end
