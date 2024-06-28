function onCreate()
	addHaxeLibrary('FlxBackdrop', 'flixel.addons.display');

	posX = -500;
	posY = -300;
	scale = 1.2;

	makeLuaSprite('bg', 'open-mic/farbg', posX, posY);
	setScrollFactor('bg', 1, 1);
	scaleObject('bg', scale, scale);
	addLuaSprite('bg', false);

	makeLuaSprite('lights', 'open-mic/lights', posX, posY);
	setScrollFactor('lights', 1, 1);
	scaleObject('lights', scale, scale);
	addLuaSprite('lights', false);

	makeAnimatedLuaSprite('sour', 'open-mic/SuaveSour', -330, 47);
	addAnimationByPrefix('sour', 'idle', 'idle', 24, false);
	addAnimationByPrefix('sour', 'danceLeft', 'dance left', 24, false);
	addAnimationByPrefix('sour', 'danceRight', 'dance right', 24, false);
	setScrollFactor('sour', 1, 1);
	scaleObject('sour', 1.1, 1.1);
	addLuaSprite('sour', true);

	makeAnimatedLuaSprite('tbone', 'open-mic/TBone', 1350, 70);
	addAnimationByPrefix('tbone', 'idle', 'idle', 24, false);
	addAnimationByPrefix('tbone', 'danceLeft', 'play left', 24, false);
	addAnimationByPrefix('tbone', 'danceRight', 'play right', 24, false);
	setScrollFactor('tbone', 1, 1);
	scaleObject('tbone', 1.1, 1.1);
	addLuaSprite('tbone', true);

	makeLuaSprite('tables', 'open-mic/tables', posX, posY);
	setScrollFactor('tables', 1.2, 1.2);
	scaleObject('tables', scale, scale);
	addLuaSprite('tables', true);

end