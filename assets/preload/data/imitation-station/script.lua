function onCreate()
	addHaxeLibrary('FlxBackdrop', 'flixel.addons.display');

	setProperty('gf.alpha', 0.0001);

	setProperty('isCameraOnForcedPos', true);
	setProperty('camFollow.y', 350);
	setProperty('camFollow.x', 710);

	makeLuaSprite('leftlight', 'enzync-night/leftlights', -900, -500);
	setScrollFactor('leftlight', 0.92, 0.92);
	scaleObject('leftlight', 1.1, 1.1);
	addLuaSprite('leftlight', false);
	setProperty('leftlight.alpha', 0.0001);
	
	makeLuaSprite('rightlight', 'enzync-night/rightlights', -900, -500);
	setScrollFactor('rightlight', 1, 1);
	scaleObject('rightlight', 1.1, 1.1);
	addLuaSprite('rightlight', false);
	setProperty('rightlight.alpha', 0.0001);
	
	makeLuaSprite('spotlight', 'enzync-night/biglight', -900, -500);
	setScrollFactor('spotlight', 1.05, 1.05);
	scaleObject('spotlight', 1.1, 1.1);
	addLuaSprite('spotlight', true);
	setProperty('spotlight.alpha', 0.0001);
	
	runHaxeCode([[
		var ddto:FlxBackdrop = new FlxBackdrop(Paths.image('enzync-night/scrollingBG'), 0x11);
		ddto.antialiasing = ClientPrefs.globalAntialiasing;
		game.insert(game.members.indexOf(game.getLuaObject('rightlight')) + 1, ddto);
		setVar('ddto', ddto);
		
		var windows:FlxBackdrop = new FlxBackdrop(Paths.image('enzync-night/ddtowindow'), 0x11);
		windows.antialiasing = ClientPrefs.globalAntialiasing;
		game.insert(game.members.indexOf(game.getLuaObject('ddto')) + 1, windows);
		setVar('windows', windows);
	]]);

	setScrollFactor('ddto', 0, 0);
	scaleObject('ddto', 1.2, 1.2);
	setProperty('ddto.velocity.x', -40);
	setProperty('ddto.velocity.y', -40);
	setProperty('ddto.alpha', 0.001);
	
	setScrollFactor('windows', 0, 0);
	scaleObject('windows', 1.2, 1.2);
	setProperty('windows.velocity.x', -50);
	setProperty('windows.alpha', 0.001);
	
	makeAnimatedLuaSprite('infinite', 'enzync-night/infinitespeed', 0, 0);
	addAnimationByPrefix('infinite', 'idle', 'RedSpeed', 24, true);
	setScrollFactor('infinite', 0, 0);
	addLuaSprite('infinite', false);
	scaleObject('infinite', 1.5, 1.5);
    screenCenter('infinite');
	setProperty('infinite.alpha', 0.0001);
	
	makeAnimatedLuaSprite('badending', 'enzync-night/HomeStatic', 0, 0);
	addAnimationByPrefix('badending', 'idle', 'HomeStatic', 24, true);
	setScrollFactor('badending', 0, 0);
	addLuaSprite('badending', false);
	scaleObject('badending', 1.2, 1.2);
    screenCenter('badending');
	setProperty('badending.alpha', 0.0001);

	makeLuaSprite('SkyDay', 'enzync/sky', -900, -500);
	setScrollFactor('SkyDay', 0.3, 0.3);
	scaleObject('SkyDay', 1.1, 1.1);
	addLuaSprite('SkyDay', false);
	setProperty('SkyDay.alpha', 0.0001);

	makeLuaSprite('citynight', 'enzync-night/closeupcity', 0, 250);
	setScrollFactor('citynight', 0.4, 0.4);
	scaleObject('citynight', 1.2, 1.2);
	screenCenter('citynight');
	addLuaSprite('citynight', false);
	setProperty('citynight.alpha', 0.0001);
	
	makeLuaSprite('cityday', 'enzync-night/closeupcityday', 0, 250);
	setScrollFactor('cityday', 0.4, 0.4);
	scaleObject('cityday', 1.2, 1.2);
	screenCenter('cityday');
	addLuaSprite('cityday', false);
	setProperty('cityday.alpha', 0.0001);

	makeLuaSprite('morning', 'enzync-night/morninglight', 0, 0);
	setScrollFactor('morning', 1.2, 1.2);
	scaleObject('morning', 1.1, 1.1);
	screenCenter('morning');
	addLuaSprite('morning', false);
	setObjectCamera('morning', 'hud');
	setProperty('morning.alpha', 0.0001);

	makeLuaSprite('barTop', 'closeup/TightBars', 0, -102);
	setScrollFactor('barTop', 0, 0);
	scaleObject('barTop', 1.1, 1);
	addLuaSprite('barTop', false);
	setObjectCamera('barTop', 'hud');

	makeLuaSprite('barBottom', 'closeup/TightBars', 0, 822);
	setScrollFactor('barBottom', 0, 0);
	scaleObject('barBottom', 1.1, 1);
	addLuaSprite('barBottom', false);
	setObjectCamera('barBottom', 'hud');

	makeLuaSprite('fade', 'enzync-night/bgfade', 0, 1060);
	setScrollFactor('fade', 0, 0);
	scaleObject('fade', 1, 1);
	addLuaSprite('fade', false);
	setObjectCamera('fade', 'hud')

	makeLuaSprite('black', '', -100, -100);
    makeGraphic('black', 1280*2, 720*2, '000000');
    setScrollFactor('black', 0, 0);
    screenCenter('black');
    addLuaSprite('black', true);
	
	setProperty('ratingCharNote', true);
end

function onStepHit()
	if curStep == 1 then
		doTweenAlpha('black', 'black', 0.9);
		setProperty('dad.color', 0x00000000);
		setProperty('boyfriend.hasMissAnimations', true);
		setProperty('dad.hasMissAnimations', true);
		setProperty('boyfriend.color', 0x00000000);
	end
	if curStep == 16 then
		doTweenAlpha('black', 'black', 0.8, 0.15);
		setProperty('leftlight.alpha', 1);
	end
	if curStep == 22 then
		doTweenAlpha('black', 'black', 0.7, 0.15);
		setProperty('rightlight.alpha', 1);
	end
	if curStep == 32 then
		doTweenAlpha('black', 'black', 0.6, 0.15);
		setProperty('leftlight.alpha', 0);
		setProperty('rightlight.alpha', 0);
	end
	if curStep == 48 then
		doTweenAlpha('black', 'black', 0.5, 0.15);
		setProperty('leftlight.alpha', 1);
	end
	if curStep == 54 then
		doTweenAlpha('black', 'black', 0.4, 0.15);
		setProperty('rightlight.alpha', 1);
	end
	if curStep == 64 then
		doTweenAlpha('black', 'black', 0.3, 0.15);
		setProperty('leftlight.alpha', 0);
		setProperty('rightlight.alpha', 0);
	end
	if curStep == 80 then
		doTweenAlpha('black', 'black', 0.2, 0.15);
		setProperty('leftlight.alpha', 1);
	end
	if curStep == 88 then
		doTweenAlpha('black', 'black', 0.1, 0.15);
		setProperty('rightlight.alpha', 1);
	end
	if curStep == 96 then
		doTweenAlpha('black', 'black', 0, 0.15);
		setProperty('leftlight.alpha', 0);
		setProperty('rightlight.alpha', 0);
	end
	if curStep == 112 then
		setProperty('leftlight.alpha', 1);
		setProperty('rightlight.alpha', 1);
		setProperty('spotlight.alpha', 1);
		setProperty('dad.color', 0xFFFFFF);
		setProperty('boyfriend.color', 0xFFFFFF);
		setProperty('boyfriend.hasMissAnimations', false);
		setProperty('dad.hasMissAnimations', false);
	end
	if curStep == 128 then
	setProperty('isCameraOnForcedPos', false);
	end
	if curStep == 640 then
		doTweenY('barTop', 'barTop', 0, 0.5, "circinout");
		doTweenY('barBottom', 'barBottom', 628, 0.5, "circinout");
		doTweenAlpha('ddto', 'ddto', 1, 2);
		doTweenAlpha('spotlight', 'spotlight', 0.001, 2);
	end
	if curStep == 646 then
		doTweenAlpha('windows', 'windows', 1, 2);
		doTweenAlpha('gf', 'gf', 1, 3);
	end
	if curStep == 700 then
		doTweenAlpha('gf', 'gf', 0.0001, 2);
	end
	if curStep == 768 then
		doTweenAlpha('gf', 'gf', 1, 3);
	end
	if curStep == 826 then
		doTweenAlpha('gf', 'gf', 0.0001, 2);
	end
	if curStep == 896 then
		setProperty('infinite.alpha', 1);
		setProperty('ddto.alpha', 0);
		setProperty('windows.alpha', 0);
	end
	if curStep == 900 then
		doTweenAlpha('gf', 'gf', 1, 1);
	end
	if curStep == 956 then
		doTweenAlpha('gf', 'gf', 0.0001, 2);
	end
	if curStep == 1024 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 300);
		setProperty('camFollow.x', 710);
		doTweenAlpha('badending', 'badending', 1, 2);
		doTweenAlpha('gf', 'gf', 1, 2);
	end
	if curStep == 1090 then
		doTweenAlpha('gf', 'gf', 0.0001, 2);
	end
	if curStep == 1152 then
		setProperty('infinite.alpha', 0);
		doTweenY('fade', 'fade', -1060, 1);
	end
	if curStep == 1158 then
		setProperty('isCameraOnForcedPos', false);
		setProperty('badending.alpha', 0);
		setProperty('citynight.alpha', 1);
		setProperty('gf.alpha', 0);
		setProperty('backcity.alpha', 0);
		setProperty('building.alpha', 0);
		setProperty('front.alpha', 0);
		setProperty('leftlight.alpha', 0);
		setProperty('rightlight.alpha', 0);
	end
	if curStep == 1434 then
		doTweenAlpha('SkyDay', 'SkyDay', 1, 14);
		doTweenAlpha('cityday', 'cityday', 1, 14);
		doTweenAlpha('morning', 'morning', 0.8, 16);
	end
end