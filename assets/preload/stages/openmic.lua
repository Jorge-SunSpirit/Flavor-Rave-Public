function onCreate()
	addHaxeLibrary('FlxBackdrop', 'flixel.addons.display');

	posX = -705;
	posY = -360;
	scale = 1;

	makeLuaSprite('bg', 'open-mic/bg', posX, posY);
	setScrollFactor('bg', 1, 1);
	scaleObject('bg', scale, scale);
	addLuaSprite('bg', false);
	
	makeLuaSprite('hanglights2', 'open-mic/hanglights2', posX, posY);
	setScrollFactor('hanglights2', 1.05, 1.05);
	scaleObject('hanglights2', scale, scale);
	addLuaSprite('hanglights2', false);
	setBlendMode('hanglights2', 'add')

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
	
	makeLuaSprite('floor', 'open-mic/floor', posX, posY);
	setScrollFactor('floor', 1, 1);
	scaleObject('floor', scale, scale);
	addLuaSprite('floor', true);

	makeLuaSprite('lights', 'open-mic/spotlights', posX, posY);
	setScrollFactor('lights', 1.1, 1);
	scaleObject('lights', scale, scale);
	addLuaSprite('lights', true);
	setBlendMode('lights', 'add')

	makeLuaSprite('orblight', 'open-mic/orblight', posX, posY - 250);
	setScrollFactor('orblight', 1.11, 1.05);
	scaleObject('orblight', scale, scale);
	addLuaSprite('orblight', true);
	
	makeLuaSprite('orblight2', 'open-mic/orblight2', posX, posY - 250);
	setScrollFactor('orblight2', 1.1, 1.05);
	scaleObject('orblight2', scale, scale);
	addLuaSprite('orblight2', true);
	
	makeLuaSprite('tables', 'open-mic/tables', posX, posY);
	setScrollFactor('tables', 1.5, 1.2);
	scaleObject('tables', scale, scale);
	addLuaSprite('tables', true);

end