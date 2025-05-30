function onCreate()
	addHaxeLibrary('FlxBackdrop', 'flixel.addons.display');

	posX = -1350;
	posY = -940;
	scale = 2.5;

	makeLuaSprite('Sky', 'stages/chicory/sky', posX, posY);
	setScrollFactor('Sky', 0.6, 0.6);
	scaleObject('Sky', scale, scale);
	addLuaSprite('Sky', false);
	
	makeLuaSprite('SkyDark', 'stages/chicory/sky-dark', posX, posY);
	setScrollFactor('SkyDark', 0.6, 0.6);
	scaleObject('SkyDark', scale, scale);
	addLuaSprite('SkyDark', false);
	setProperty('SkyDark.alpha', 0.0001);

	makeLuaSprite('Restaurant', 'stages/chicory/main', posX, posY);
	setScrollFactor('Restaurant', 1, 1);
	scaleObject('Restaurant', scale, scale);
	addLuaSprite('Restaurant', false);
	
	makeLuaSprite('RestaurantDark', 'stages/chicory/main-dark', posX, posY);
	setScrollFactor('RestaurantDark', 1, 1);
	scaleObject('RestaurantDark', scale, scale);
	addLuaSprite('RestaurantDark', false);
	setProperty('RestaurantDark.alpha', 0.0001);

	makeLuaSprite('mommiddle', 'stages/chicory/her/close', posX, posY);
	setScrollFactor('mommiddle', 1, 1);
	scaleObject('mommiddle', scale, scale);
	addLuaSprite('mommiddle', false);
	setProperty('mommiddle.alpha', 0.0001);
	
	makeLuaSprite('mombitter', 'stages/chicory/her/by_bitter', posX, posY);
	setScrollFactor('mombitter', 1, 1);
	scaleObject('mombitter', scale, scale);
	addLuaSprite('mombitter', false);
	setProperty('mombitter.alpha', 0.0001);
	
	makeLuaSprite('momsweet', 'stages/chicory/her/by_sweet', posX, posY);
	setScrollFactor('momsweet', 1, 1);
	scaleObject('momsweet', scale, scale);
	addLuaSprite('momsweet', false);
	setProperty('momsweet.alpha', 0.0001);

	makeLuaSprite('Light', 'stages/chicory/lights', posX, posY);
	setScrollFactor('Light', 1, 1);
	scaleObject('Light', scale, scale);
	addLuaSprite('Light', true);
	
	makeLuaSprite('LightDark', 'stages/chicory/lights-dark', posX, posY);
	setScrollFactor('LightDark', 1, 1);
	scaleObject('LightDark', scale, scale);
	addLuaSprite('LightDark', true);
	setProperty('LightDark.alpha', 0.0001);
	
	makeLuaSprite('Glow', 'stages/chicory/lightsglow', posX, posY);
	setScrollFactor('Glow', 1, 1);
	scaleObject('Glow', scale, scale);
	addLuaSprite('Glow', true);
	
	makeLuaSprite('Tables', 'stages/chicory/tables', posX, posY);
	setScrollFactor('Tables', 1.1, 1.1);
	scaleObject('Tables', scale, scale);
	addLuaSprite('Tables', true);
	
	makeLuaSprite('TablesDark', 'stages/chicory/tables-dark', posX, posY);
	setScrollFactor('TablesDark', 1.1, 1.1);
	scaleObject('TablesDark', scale, scale);
	addLuaSprite('TablesDark', true);
	setProperty('TablesDark.alpha', 0.0001);
	
	makeLuaSprite('momtable', 'stages/chicory/her/table', posX, posY);
	setScrollFactor('momtable', 1.1, 1.1);
	scaleObject('momtable', scale, scale);
	addLuaSprite('momtable', true);
	setProperty('momtable.alpha', 0.0001);

	makeLuaSprite('momfront', 'stages/chicory/her/middle', posX, posY);
	setScrollFactor('momfront', 1.25, 1.25);
	scaleObject('momfront', scale, scale);
	addLuaSprite('momfront', true);
	setProperty('momfront.alpha', 0.0001);

end
