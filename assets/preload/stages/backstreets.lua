function onCreate()
	addHaxeLibrary('FlxBackdrop', 'flixel.addons.display');

	posX = -500;
	posY = -700;
	scale = 1.2;

	makeLuaSprite('Sky', 'backstreet/Sky', posX, posY);
	setScrollFactor('Sky', 0, 0);
	scaleObject('Sky', scale, scale);
	addLuaSprite('Sky', false);

	makeLuaSprite('BGCity', 'backstreet/BGCity', posX, posY);
	setScrollFactor('BGCity', 0.2, 0.9);
	scaleObject('BGCity', scale, scale);
	addLuaSprite('BGCity', false);

	makeLuaSprite('Road', 'backstreet/Road', posX, posY);
	setScrollFactor('Road', 1, 1);
	scaleObject('Road', scale, scale);
	addLuaSprite('Road', false);

	makeLuaSprite('LeftBuildings', 'backstreet/LeftBuildings', posX, posY);
	setScrollFactor('LeftBuildings', 1, 1);
	scaleObject('LeftBuildings', scale, scale);
	addLuaSprite('LeftBuildings', false);

	makeLuaSprite('Signs', 'backstreet/Signs', posX, posY);
	setScrollFactor('Signs', 1, 1);
	scaleObject('Signs', scale, scale);
	addLuaSprite('Signs', false);

	makeLuaSprite('RightBuildings', 'backstreet/RightBuildings', posX, posY);
	setScrollFactor('RightBuildings', 1, 1);
	scaleObject('RightBuildings', scale, scale);
	addLuaSprite('RightBuildings', false);

	makeAnimatedLuaSprite('MovingPieces', 'backstreet/MovingPieces', posX, posY + 445);
	addAnimationByPrefix('MovingPieces', 'idle', 'TogaAnim', 24, true);
	playAnim('MovingPieces', 'idle');
	scaleObject('MovingPieces', scale, scale);
	addLuaSprite('MovingPieces', false);
	setScrollFactor('MovingPieces', 1, 1);

	makeLuaSprite('black', '', -100, -100);
	makeGraphic('black', 1280*2, 720*2, '000000');
	setScrollFactor('black', 0, 0);
	screenCenter('black');
	setProperty('black.alpha', 0.0001);
	addLuaSprite('black', false);
end