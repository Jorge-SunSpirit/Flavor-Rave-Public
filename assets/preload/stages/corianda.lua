function onCreate()
	addHaxeLibrary('FlxBackdrop', 'flixel.addons.display');

	posX = -1000;
	posY = -600;
	scale = 1.2;

	makeLuaSprite('Sky', 'corianda/nightsky', posX, posY);
	setScrollFactor('Sky', 0, 0);
	scaleObject('Sky', scale, scale);
	addLuaSprite('Sky', false);

	makeLuaSprite('BGCity', 'corianda/backtown', posX, posY);
	setScrollFactor('BGCity', 0.85, 0.85);
	scaleObject('BGCity', scale, scale);
	addLuaSprite('BGCity', false);
	
	makeLuaSprite('BGCityRave', 'corianda/nightsky-rave', posX, posY);
	setScrollFactor('BGCityRave', 0.85, 0.85);
	scaleObject('BGCityRave', scale, scale);
	addLuaSprite('BGCityRave', false);
	setProperty('BGCityRave.alpha', 0.0001);
	
	makeLuaSprite('BGCityLight', 'corianda/backtownlights', posX, posY);
	setScrollFactor('BGCityLight', 0.85, 0.85);
	scaleObject('BGCityLight', scale, scale);
	addLuaSprite('BGCityLight', false);

	makeLuaSprite('Road', 'corianda/mainstreet', posX, posY);
	setScrollFactor('Road', 1, 1);
	scaleObject('Road', scale, scale);
	addLuaSprite('Road', false);
	
	makeLuaSprite('RoadRave', 'corianda/mainstreet-rave', posX, posY);
	setScrollFactor('RoadRave', 1, 1);
	scaleObject('RoadRave', scale, scale);
	addLuaSprite('RoadRave', false);
	setProperty('RoadRave.alpha', 0.0001);
	
	makeAnimatedLuaSprite('clones', 'corianda/savory_clones', -100, -600);
	addAnimationByPrefix('clones', 'idle', 'TheGang_caseidle', 24, false);
	addAnimationByPrefix('clones', 'caseOpens', 'TheGang_caseopens', 24, false);
	addAnimationByPrefix('clones', 'danceLeft', 'TheGang_danceleft', 24, false);
	addAnimationByPrefix('clones', 'danceRight', 'TheGang_danceright', 24, false);
	addAnimationByPrefix('clones', 'vanish', 'TheGang_vanish', 24, false);
	setScrollFactor('clones', 1, 1);
	scaleObject('clones', scale, scale);
	addLuaSprite('clones', false);
	setProperty('clones.alpha', 0.0001);
	
	makeLuaSprite('RoadLight', 'corianda/mainstreetlights', posX, posY);
	setScrollFactor('RoadLight', 1, 1);
	scaleObject('RoadLight', scale, scale);
	addLuaSprite('RoadLight', false);
	
	makeAnimatedLuaSprite('clonesFG', 'corianda/savory_clones_FG', -400, 400);
	addAnimationByPrefix('clonesFG', 'appear', 'appear', 24, false);
	addAnimationByPrefix('clonesFG', 'idle', 'idle', 24, false);
	addAnimationByPrefix('clonesFG', 'vanish', 'vanish', 24, false);
	setScrollFactor('clonesFG', 1.2, 1.2);
	scaleObject('clonesFG', 1.3, 1.3);
	addLuaSprite('clonesFG', true);
	setProperty('clonesFG.alpha', 0.0001);

	makeLuaSprite('front', 'corianda/frontbanners', posX, posY);
	setScrollFactor('front', 1.03, 1);
	scaleObject('front', scale, scale);
	addLuaSprite('front', true);

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

function onUpdate(elapsed)
	setProperty('RoadLight.alpha', getProperty('RoadLight.alpha') - ((crochet / 1000) * elapsed * 2));
	setProperty('BGCityLight.alpha', getProperty('BGCityLight.alpha') - ((crochet / 1000) * elapsed * 2));
end

function onBeatHit()
	if curBeat % 2 == 0 then
		setProperty('RoadLight.alpha', 1);
	end
	if curBeat % 4 == 0 then
		setProperty('BGCityLight.alpha', 1);
	end
end