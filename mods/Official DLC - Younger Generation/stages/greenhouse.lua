function onCreate()
	addHaxeLibrary('FlxBackdrop', 'flixel.addons.display');

	posX = -1200;
	posY = -580;
	scale = 1.75;

	makeLuaSprite('sky', 'stages/greenhouse/sky', posX, posY);
	setScrollFactor('sky', 0.2, 0.2);
	scaleObject('sky', scale, scale);
	addLuaSprite('sky', false);

	makeLuaSprite('trees', 'stages/greenhouse/bg', posX, posY);
	setScrollFactor('trees', 0.4, 0.8);
	scaleObject('trees', scale, scale);
	addLuaSprite('trees', false);
	
	makeLuaSprite('greenhouse', 'stages/greenhouse/greenhouse_Tablemerged', posX, posY);
	setScrollFactor('greenhouse', 1, 1);
	scaleObject('greenhouse', scale, scale);
	addLuaSprite('greenhouse', false);

	makeLuaSprite('fgFlora', 'stages/greenhouse/fgFlora', posX, posY);
	setScrollFactor('fgFlora', 1.2, 1.2);
	scaleObject('fgFlora', scale, scale);
	addLuaSprite('fgFlora', true);
	
	makeLuaSprite('overlayAdd', 'stages/greenhouse/addOverlay', posX, posY);
	setScrollFactor('overlayAdd', 0, 0);
	scaleObject('overlayAdd', scale, scale);
	setBlendMode('overlayAdd', 'overlay');
	screenCenter('overlayAdd');
	addLuaSprite('overlayAdd', true);

end
