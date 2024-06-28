function onCreate()

	posX = -1000;
	posY = -700;
	scale = 1.5;

	makeLuaSprite('sky', 'bg1/sky', posX, posY);
	setScrollFactor('sky', 0, 0);
	scaleObject('sky', scale, scale);
	addLuaSprite('sky', false);

	makeLuaSprite('clouds', 'bg1/clouds', posX, posY);
	setScrollFactor('clouds', 0.15, 0.2);
	scaleObject('clouds', scale, scale);
	addLuaSprite('clouds', false);

	makeLuaSprite('farhill', 'bg1/farhill', posX, posY);
	setScrollFactor('farhill', 0.2, 1);
	scaleObject('farhill', scale, scale);
	addLuaSprite('farhill', false);

	makeLuaSprite('midhill', 'bg1/midhill', posX, posY);
	setScrollFactor('midhill', 0.25, 1);
	scaleObject('midhill', scale, scale);
	addLuaSprite('midhill', false);

	makeLuaSprite('hillR', 'bg1/hillR', posX, posY);
	setScrollFactor('hillR', 0.3, 1);
	scaleObject('hillR', scale, scale);
	addLuaSprite('hillR', false);

	makeLuaSprite('hillL', 'bg1/hillL', posX, posY);
	setScrollFactor('hillL', 0.3, 1);
	scaleObject('hillL', scale, scale);
	addLuaSprite('hillL', false);

	makeLuaSprite('atmosphere', 'bg1/atmosphere', posX, posY);
	setScrollFactor('atmosphere', 0.3, 1);
	scaleObject('atmosphere', scale, scale);
	addLuaSprite('atmosphere', false);

	makeLuaSprite('trees', 'bg1/trees', posX, posY);
	setScrollFactor('trees', 0.4, 1);
	scaleObject('trees', scale, scale);
	addLuaSprite('trees', false);

	makeLuaSprite('streetlamps', 'bg1/streetlamps', posX, posY);
	setScrollFactor('streetlamps', 0.6, 1);
	scaleObject('streetlamps', scale, scale);
	addLuaSprite('streetlamps', false);

	makeLuaSprite('streetlights', 'bg1/streetlights', posX, posY);
	setScrollFactor('streetlights', 0.6, 1);
	scaleObject('streetlights', scale, scale);
	addLuaSprite('streetlights', false);

	makeLuaSprite('parking', 'bg1/parking', posX, posY);
	setScrollFactor('parking', 1, 1);
	scaleObject('parking', scale, scale);
	addLuaSprite('parking', false);

	-- Spotlights (11_1, 11_2) should move independently, rotating back and forth.
	makeLuaSprite('venuespotL', 'bg1/venuespotL', posX, posY);
	setScrollFactor('venuespotL', 0.45, 1);
	scaleObject('venuespotL', scale, scale);
	addLuaSprite('venuespotL', false);

	makeLuaSprite('venuespotR', 'bg1/venuespotR', posX, posY);
	setScrollFactor('venuespotR', 0.45, 1);
	scaleObject('venuespotR', scale, scale);
	addLuaSprite('venuespotR', false);

	makeLuaSprite('venue', 'bg1/venue', posX, posY);
	setScrollFactor('venue', 0.5, 1);
	scaleObject('venue', scale, scale);
	addLuaSprite('venue', false);

	makeAnimatedLuaSprite('stans', 'bg1/stans', 600, 270);
	addAnimationByPrefix('stans', 'idle', 'Fans', 24, false);
	setScrollFactor('stans', 0.7, 1);
	scaleObject('stans', 0.7, 0.7);
	playAnim('stans', 'idle');
	finishAnim('stans');
	addLuaSprite('stans', false);

	makeLuaSprite('sweettruck', 'bg1/sweettruck', posX, posY);
	setScrollFactor('sweettruck', 0.7, 1);
	scaleObject('sweettruck', scale, scale);
	addLuaSprite('sweettruck', false);

	makeLuaSprite('sweettrucklight', 'bg1/sweettrucklight', posX, posY);
	setScrollFactor('sweettrucklight', 0.7, 1);
	scaleObject('sweettrucklight', scale, scale);
	addLuaSprite('sweettrucklight', false);

	makeLuaSprite('sourvan', 'bg1/sourvan', posX, posY);
	setScrollFactor('sourvan', 0.8, 1);
	scaleObject('sourvan', scale, scale);
	addLuaSprite('sourvan', false);

	makeLuaSprite('sourvanlight', 'bg1/sourvanlight', posX, posY);
	setScrollFactor('sourvanlight', 0.8, 1);
	scaleObject('sourvanlight', scale, scale);
	addLuaSprite('sourvanlight', false);

	makeLuaSprite('sweetbus', 'bg1/sweetbus', posX, posY);
	setScrollFactor('sweetbus', 0.8, 1);
	scaleObject('sweetbus', scale, scale);
	addLuaSprite('sweetbus', false);

	makeLuaSprite('sweetbuslight', 'bg1/sweetbuslight', posX, posY);
	setScrollFactor('sweetbuslight', 0.8, 1);
	scaleObject('sweetbuslight', scale, scale);
	addLuaSprite('sweetbuslight', false);

	makeAnimatedLuaSprite('kyle', 'bg1/koolguykyle', 2200, 70);
	addAnimationByPrefix('kyle', 'idle', 'kool_guy_kyle', 24, false);
	playAnim('kyle', 'idle');
	finishAnim('kyle');
	setScrollFactor('kyle', 0.95, 1);
	scaleObject('kyle', 0.7, 0.7);
	addLuaSprite('kyle', false);

	makeLuaSprite('equipment', 'bg1/equipment', posX, posY);
	setScrollFactor('equipment', 0.95, 1);
	scaleObject('equipment', scale, scale);
	addLuaSprite('equipment', false);

	-- TRANSITION
	makeLuaSprite('transition', 'closeup/TransitionOut', -2600, 0);
	setScrollFactor('transition', 0, 0);
	addLuaSprite('transition', false);
	setObjectCamera('transition', 'hud');

	makeLuaSprite('barTop', 'closeup/TightBars', 0, -102);
	setScrollFactor('barTop', 0, 0);
	scaleObject('barTop', 1.1, 1);
	addLuaSprite('barTop', true);
	setObjectCamera('barTop', 'hud');

	makeLuaSprite('barBottom', 'closeup/TightBars', 0, 822);
	setScrollFactor('barBottom', 0, 0);
	scaleObject('barBottom', 1.1, 1);
	addLuaSprite('barBottom', true);
	setObjectCamera('barBottom', 'hud');
end

function onUpdate(elapsed)
	setProperty('sweettrucklight.alpha', getProperty('sweettrucklight.alpha') - ((crochet / 1000) * elapsed * 2));
	setProperty('sourvanlight.alpha', getProperty('sourvanlight.alpha') - ((crochet / 1000) * elapsed * 2));
	setProperty('sweetbuslight.alpha', getProperty('sweetbuslight.alpha') - ((crochet / 1000) * elapsed * 2));
	setProperty('streetlights.alpha', getProperty('streetlights.alpha') - ((crochet / 1000) * elapsed * 2));
	setProperty('venuespotR.alpha', getProperty('venuespotR.alpha') - ((crochet / 1000) * elapsed * 2));
	setProperty('venuespotL.alpha', getProperty('venuespotL.alpha') - ((crochet / 1000) * elapsed * 2));
end

function onBeatHit()
	if curBeat % 2 == 0 then
		setProperty('sweettrucklight.alpha', 1);
		setProperty('sourvanlight.alpha', 1);
		setProperty('sweetbuslight.alpha', 1);
		playAnim('stans', 'idle');
		playAnim('kyle', 'idle');
	end
	if curBeat % 4 == 0 then
		setProperty('streetlights.alpha', 1);
		setProperty('venuespotR.alpha', 1);
		setProperty('venuespotL.alpha', 1);
	end
end