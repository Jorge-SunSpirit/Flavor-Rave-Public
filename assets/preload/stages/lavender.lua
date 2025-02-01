function onCreate()
	addHaxeLibrary('FlxBackdrop', 'flixel.addons.display');

	posX = -450;
	posY = -940;
	scale = 1;

	makeLuaSprite('Sky', 'lavender/sky', posX, posY);
	setScrollFactor('Sky', 0.05, 0.05);
	scaleObject('Sky', scale, scale);
	addLuaSprite('Sky', false);

	makeLuaSprite('Sun', 'lavender/sun', posX, posY);
	setScrollFactor('Sun', 0.1, 0.1);
	scaleObject('Sun', scale, scale);
	addLuaSprite('Sun', false);
	
	makeLuaSprite('Clouds', 'lavender/clouds', posX, posY);
	setScrollFactor('Clouds', 0.2, 0.2);
	scaleObject('Clouds', scale, scale);
	addLuaSprite('Clouds', false);

	makeLuaSprite('BackMountains', 'lavender/backmountains', posX, posY);
	setScrollFactor('BackMountains', 0.35, 0.35);
	scaleObject('BackMountains', scale, scale);
	addLuaSprite('BackMountains', false);
	
	makeLuaSprite('FrontMountains', 'lavender/frontmountains', posX, posY);
	setScrollFactor('FrontMountains', 0.52, 0.52);
	scaleObject('FrontMountains', scale, scale);
	addLuaSprite('FrontMountains', false);

	makeLuaSprite('Garden', 'lavender/gardenback', posX, posY);
	setScrollFactor('Garden', 1, 0.9);
	scaleObject('Garden', scale, scale);
	addLuaSprite('Garden', false);

	makeLuaSprite('Main', 'lavender/main', posX, posY);
	setScrollFactor('Main', 1, 1);
	scaleObject('Main', scale, scale);
	addLuaSprite('Main', false);

	makeLuaSprite('Flower', 'lavender/flowerfront', posX - 50, posY);
	setScrollFactor('Flower', 1.1, 1.1);
	scaleObject('Flower', 1.1, 1.1);
	addLuaSprite('Flower', true);

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
