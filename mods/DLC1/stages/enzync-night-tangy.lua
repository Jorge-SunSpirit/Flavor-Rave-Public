function onCreate()
	addHaxeLibrary('FlxBackdrop', 'flixel.addons.display');

	posX = -900;
	posY = -500;
	scale = 1.1;

	makeLuaSprite('Sky', 'enzync-night/sky', posX, posY);
	setScrollFactor('Sky', 0.3, 0.3);
	scaleObject('Sky', scale, scale);
	setProperty('Sky.flipX', true);
	addLuaSprite('Sky', false);
	
	makeLuaSprite('Sky-cool', 'stages/livewire-extras/sky-cool', posX, posY);
	setScrollFactor('Sky-cool', 0.3, 0.3);
	scaleObject('Sky-cool', scale, scale);
	setProperty('Sky-cool.flipX', true);
	addLuaSprite('Sky-cool', false);
	setProperty('Sky-cool.alpha', 0.0001);

	makeLuaSprite('backcity', 'enzync-night/back', posX, posY);
	setScrollFactor('backcity', 0.7, 0.7);
	scaleObject('backcity', scale, scale);
	setProperty('backcity.flipX', true);
	addLuaSprite('backcity', false);
	
	makeLuaSprite('backcity-cool', 'stages/livewire-extras/back-cool', posX, posY);
	setScrollFactor('backcity-cool', 0.7, 0.7);
	scaleObject('backcity-cool', scale, scale);
	setProperty('backcity-cool.flipX', true);
	addLuaSprite('backcity-cool', false);
	setProperty('backcity-cool.alpha', 0.0001);

	makeAnimatedLuaSprite('backcitylights', 'stages/livewire-extras/BackCityLights', posX - 0, posY + 243);
	addAnimationByPrefix('backcitylights', 'idle', 'LivewireLights', 26, false);
	setScrollFactor('backcitylights', 0.7, 0.7);
	scaleObject('backcitylights', scale, scale);
	addLuaSprite('backcitylights', false);
	setProperty('backcitylights.flipX', true);
	setProperty('backcitylights.alpha', 0.0001);

	makeLuaSprite('building', 'stages/livewire-extras/buildingsmirror', posX, posY);
	setScrollFactor('building', 0.92, 0.92);
	scaleObject('building', scale, scale);
	setProperty('building.flipX', true);
	addLuaSprite('building', false);

	makeLuaSprite('building-cool', 'stages/livewire-extras/buildingsmirror-cool', posX, posY);
	setScrollFactor('building-cool', 0.92, 0.92);
	scaleObject('building-cool', scale, scale);
	setProperty('building-cool.flipX', true);
	addLuaSprite('building-cool', false);
	setProperty('building-cool.alpha', 0.0001);

	makeAnimatedLuaSprite('news', 'stages/livewire-extras/NewsOverlay', -700, -500);
	addAnimationByPrefix('news', 'paper1', 'OverlayA', 24, false);
	addAnimationByPrefix('news', 'paper2', 'OverlayB', 24, false);
	setScrollFactor('news', 0.92, 0.92);
	addLuaSprite('news', false);
	scaleObject('news', 2, 2);
	setBlendMode('news', 'multiply');
	setProperty('news.alpha', 0.0001);

	makeAnimatedLuaSprite('buildinglights', 'stages/livewire-extras/BuildingLights', posX + 1278, posY + 326);
	addAnimationByPrefix('buildinglights', 'idle', 'LWLights2', 26, false);
	setScrollFactor('buildinglights', 0.92, 0.92);
	scaleObject('buildinglights', scale, scale);
	addLuaSprite('buildinglights', false);
	setProperty('buildinglights.flipX', true);
	setProperty('buildinglights.alpha', 0.0001);
	
	makeLuaSprite('front', 'enzync-night/foreground', posX, posY);
	setScrollFactor('front', 1, 1);
	scaleObject('front', scale, scale);
	setProperty('front.flipX', true);
	addLuaSprite('front', false);
	
	makeLuaSprite('front-cool', 'stages/livewire-extras/foreground-cool', posX, posY);
	setScrollFactor('front-cool', 1, 1);
	scaleObject('front-cool', scale, scale);
	setProperty('front-cool.flipX', true);
	addLuaSprite('front-cool', false);
	setProperty('front-cool.alpha', 0.0001);
	
	makeLuaSprite('leftlight', 'enzync-night/leftlights', -900, -500);
	setScrollFactor('leftlight', 0.92, 0.92);
	scaleObject('leftlight', 1.1, 1.1);
	addLuaSprite('leftlight', false);
	setProperty('leftlight.flipX', true);
	--setProperty('leftlight.alpha', 0.0001);
	
	makeLuaSprite('rightlight', 'enzync-night/rightlights', -900, -500);
	setScrollFactor('rightlight', 1, 1);
	scaleObject('rightlight', 1.1, 1.1);
	addLuaSprite('rightlight', false);
	setProperty('rightlight.flipX', true);
	--setProperty('rightlight.alpha', 0.0001);
	
	makeLuaSprite('spotlight', 'enzync-night/biglight', -900, -500);
	setScrollFactor('spotlight', 1.05, 1.05);
	scaleObject('spotlight', 1.1, 1.1);
	addLuaSprite('spotlight', true);
	setProperty('spotlight.flipX', true);
	--setProperty('spotlight.alpha', 0.0001);
	
	makeLuaSprite('SourBG', 'closeup/SourBG', -50, -0);
	setScrollFactor('SourBG', 0, 0);
	scaleObject('SourBG', 1.2, 1.2);
	addLuaSprite('SourBG', false);
	setProperty('SourBG.alpha', 0.0001);
	setObjectCamera('SourBG', 'effect');
	
	makeLuaSprite('SweetBG', 'closeup/SweetBG', -50, -0);
	setScrollFactor('SweetBG', 0, 0);
	scaleObject('SweetBG', 1.2, 1.2);
	addLuaSprite('SweetBG', false);
	setProperty('SweetBG.alpha', 0.0001);
	setObjectCamera('SweetBG', 'effect');
	
	makeLuaSprite('TangyBG', 'stages/livewire-extras/tangyBG', -0, -50);
	setScrollFactor('TangyBG', 0, 0);
	scaleObject('TangyBG', 1.2, 1.2);
	addLuaSprite('TangyBG', false);
	setProperty('TangyBG.alpha', 0.0001);
	setObjectCamera('TangyBG', 'effect');
    screenCenter('TangyBG');
	
	makeLuaSprite('TangyBGAngryEnd', 'stages/livewire-extras/TangyAngryBG', -400, -250);
	setScrollFactor('TangyBGAngryEnd', 0.3, 0.3);
	scaleObject('TangyBGAngryEnd', 1.5, 1.5);
	addLuaSprite('TangyBGAngryEnd', false);
	setProperty('TangyBGAngryEnd.alpha', 0.0001);
    screenCenter('TangyBGAngryEnd');
	
	makeLuaSprite('TangyBGAngry', 'stages/livewire-extras/TangyAngryBG', -0, -0);
	setScrollFactor('TangyBGAngry', 0, 0);
	scaleObject('TangyBGAngry', 1.1, 1.1);
	addLuaSprite('TangyBGAngry', false);
	setProperty('TangyBGAngry.alpha', 0.0001);
	setObjectCamera('TangyBGAngry', 'effect');
    screenCenter('TangyBGAngry');
end

function onCreatePost()
end

function onBeatHit()
	if curBeat % 1 == 0 then
		playAnim('backcitylights', 'idle');
		playAnim('buildinglights', 'idle');
	end
end