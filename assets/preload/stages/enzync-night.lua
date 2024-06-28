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

end