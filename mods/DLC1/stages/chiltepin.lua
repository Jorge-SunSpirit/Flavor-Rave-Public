function onCreate()
	addHaxeLibrary('FlxBackdrop', 'flixel.addons.display');

	posX = -350;
	posY = -540;
	scale = 1.5;

	makeLuaSprite('Sky', 'stages/chiltepin/sky', posX, posY);
	setScrollFactor('Sky', 0.1, 0.1);
	scaleObject('Sky', scale, scale);
	addLuaSprite('Sky', false);

	makeLuaSprite('Restaurant', 'stages/chiltepin/bushes', posX, posY);
	setScrollFactor('Restaurant', 0.6, 0.9);
	scaleObject('Restaurant', scale, scale);
	addLuaSprite('Restaurant', false);
	
	makeLuaSprite('Ground', 'stages/chiltepin/ground', posX, posY);
	setScrollFactor('Ground', 1, 1);
	scaleObject('Ground', scale, scale);
	addLuaSprite('Ground', false);

end
