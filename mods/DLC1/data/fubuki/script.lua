function onCreate()
	addHaxeLibrary('FlxBackdrop', 'flixel.addons.display');

	makeLuaSprite('icedragonBG', 'stages/togarashi-winter/icedragonbg', -0, -0);
	setScrollFactor('icedragonBG', 0, 0);
	scaleObject('icedragonBG', 3.3, 3.3);
	addLuaSprite('icedragonBG', false);
	setProperty('icedragonBG.alpha', 0.0001);
    screenCenter('icedragonBG');

	makeLuaSprite('firefoxBG', 'stages/togarashi-winter/firefoxbg', -0, -0);
	setScrollFactor('firefoxBG', 0, 0);
	scaleObject('firefoxBG', 3.3, 3.3);
	addLuaSprite('firefoxBG', false);
	setProperty('firefoxBG.alpha', 0.0001);
    screenCenter('firefoxBG');
	
	makeLuaSprite('nightBG', 'stages/togarashi-winter/skynight', -1200, -600);
	setScrollFactor('nightBG', 0.1, 0.1);
	scaleObject('nightBG', 3.3, 3.3);
	addLuaSprite('nightBG', false);
	setProperty('nightBG.alpha', 0.0001);

	runHaxeCode([[
		var snowstorm:FlxBackdrop = new FlxBackdrop(Paths.image('stages/togarashi-winter/snowcloud'), 0x11);
		snowstorm.antialiasing = ClientPrefs.globalAntialiasing;
		game.insert(game.members.indexOf(game.getLuaObject('nightBG')) + 1, snowstorm);
		setVar('snowstorm', snowstorm);
		
		var scroll:FlxBackdrop = new FlxBackdrop(Paths.image('stages/togarashi-winter/scrollybit'), 0x11);
		scroll.antialiasing = ClientPrefs.globalAntialiasing;
		game.insert(game.members.indexOf(game.getLuaObject('firefoxBG')) + 1, scroll);
		setVar('scroll', scroll);
		
		var clouds:FlxBackdrop = new FlxBackdrop(Paths.image('stages/togarashi-winter/storm'), 0x11);
		clouds.antialiasing = ClientPrefs.globalAntialiasing;
		game.insert(game.members.indexOf(game.getLuaObject('snowstorm')) + 1, clouds);
		setVar('clouds', clouds);
		
		var snow:FlxBackdrop = new FlxBackdrop(Paths.image('stages/togarashi-winter/snow'), 0x11);
		snow.antialiasing = ClientPrefs.globalAntialiasing;
		game.insert(game.members.indexOf(game.boyfriendGroup) + 1, snow);
		setVar('snow', snow);
		
		var ember:FlxBackdrop = new FlxBackdrop(Paths.image('stages/togarashi-winter/embers'), 0x11);
		ember.antialiasing = ClientPrefs.globalAntialiasing;
		game.insert(game.members.indexOf(game.getLuaObject('snow')) + 1, ember);
		setVar('ember', ember);
	]]);

	setScrollFactor('snowstorm', 0.4, 0.4);
	scaleObject('snowstorm', 1.2, 1.2);
	setProperty('snowstorm.velocity.x', 50);
	setProperty('snowstorm.velocity.y', 12);

	setScrollFactor('scroll', 0.4, 0.4);
	scaleObject('scroll', 1.5, 1.5);
	setProperty('scroll.velocity.x', -170);

	setScrollFactor('clouds', 0.7, 0.7);
	scaleObject('clouds', 1.2, 1.2);
	setProperty('clouds.velocity.x', 260);
	setProperty('clouds.velocity.y', 150);
	
	setScrollFactor('snow', 1.2, 1.2);
	scaleObject('snow', 1.2, 1.2);
	setProperty('snow.velocity.x', 800);
	setProperty('snow.velocity.y', 550);
	
	setScrollFactor('ember', 1.2, 1.2);
	scaleObject('ember', 1, 1);
	setProperty('ember.velocity.x', -600);
	setProperty('ember.velocity.y', -350);
	setBlendMode('ember', 'hardlight');

	makeLuaSprite('vin', 'togarashi/burnvin', posX, posY);
	setScrollFactor('vin', 0, 0);
	scaleObject('vin', 1.2, 1.2);
	addLuaSprite('vin', false);
    screenCenter('vin');
	setObjectCamera('vin', 'effect');
	setProperty('vin.alpha', 0.0001);

	makeAnimatedLuaSprite('borderfire', 'togarashi/borderburn', posX, posY);
	addAnimationByPrefix('borderfire', 'idle', 'BorderBurn', 30, true);
	playAnim('borderfire', 'idle');
	setScrollFactor('borderfire', 0, 0);
    screenCenter('borderfire');
	addLuaSprite('borderfire', false);
	setObjectCamera('borderfire', 'effect');
	setProperty('borderfire.alpha', 0.0001);
	
	makeAnimatedLuaSprite('borderice', 'stages/togarashi-winter/sweetborder', posX, posY);
	addAnimationByPrefix('borderice', 'idle', 'SweetBorder', 45, true);
	playAnim('borderice', 'idle');
	scaleObject('borderice', 1.1, 1.1);
	setScrollFactor('borderice', 0, 0);
    screenCenter('borderice');
	addLuaSprite('borderice', false);
	setObjectCamera('borderice', 'effect');
	setProperty('borderice.alpha', 0.0001);

	makeLuaSprite('icedragon', 'stages/togarashi-winter/icedragon', -1480, -0);
	setScrollFactor('icedragon', 0, 0);
	scaleObject('icedragon', 3, 3);
	addLuaSprite('icedragon', false);
	setProperty('icedragon.alpha', 0.0001);
    screenCenter('icedragon', 'y');
	
	makeLuaSprite('firefox', 'stages/togarashi-winter/firefox', -1080, -0);
	setScrollFactor('firefox', 0, 0);
	scaleObject('firefox', 3, 3);
	addLuaSprite('firefox', false);
	setProperty('firefox.alpha', 0.0001);
    screenCenter('firefox', 'y');

	makeAnimatedLuaSprite('borealis', 'stages/togarashi-winter/steamedhams', -1200, -900);
	addAnimationByPrefix('borealis', 'idle', 'NorthernLights', 30, true);
	playAnim('borealis', 'idle');
	scaleObject('borealis', 3, 4);
	setScrollFactor('borealis', 0.24, 0.1);
	addLuaSprite('borealis', false);
	setProperty('borealis.alpha', 0.0001);

	makeLuaSprite('lightfloor', 'stages/togarashi-winter/lightfloor', -870, -840);
	setScrollFactor('lightfloor', 1, 1);
	scaleObject('lightfloor', 2.6, 2.6);
	addLuaSprite('lightfloor', false);
	setProperty('lightfloor.alpha', 0.0001);

	addHaxeLibrary('ColorSwap', 'shaders')
	runHaxeCode([[
		var colorSwap = new ColorSwap();
		game.getLuaObject('borealis').shader = colorSwap.shader;
		game.getLuaObject('lightfloor').shader = colorSwap.shader;
		setVar('colorSwap', colorSwap);
	]])

	makeLuaSprite('black', '', -100, -100);
    makeGraphic('black', 1280*2, 720*2, '000000');
    setScrollFactor('black', 0, 0);
    screenCenter('black');
    addLuaSprite('black', true);
	
	makeLuaSprite('white', '', -100, -100);
    makeGraphic('white', 1280*2, 720*2, 'FFFFFF');
    setScrollFactor('white', 0, 0);
    screenCenter('white');
	setObjectCamera('white', 'effect');
	setProperty('white.alpha', 0.0001);
    addLuaSprite('white', true);
end

function onCreatePost()
	setProperty('dad.missRecolor', false);
	
	setProperty('boyfriendGroup.x', getProperty('BF_X')+100)
	setProperty('boyfriendGroup.y', getProperty('BF_Y')+35)
	
	setProperty('extraChar.alpha', 0.0001);
	setProperty('dad.alpha', 0.0001);
	setProperty('boyfriend.alpha', 0.0001);
	setProperty('boyfriend.color', 0x00000000);
	setProperty('dad.color', 0x00000000);
	setProperty('extraChar.color', 0x00000000);
	
	setProperty('ember.alpha', 0.0001);
	setProperty('scroll.alpha', 0.0001);
	setProperty('isCameraOnForcedPos', true);
	setProperty('camFollow.x', 845);
	setProperty('camFollow.y', 339);
	setProperty('camera.target.x', 845)
	setProperty('camera.target.y', 339)
end

local intendedHue = 0.25; -- The exact middle of the borealis' cycle. Right now, it cycles between values of 0 and 0.5.
local globalTime = 0; -- DO NOT TOUCH! Global timer for the sine wave.
local sineTime = 5; -- Approximately half of the cycle's length, in seconds.
local sineAmp = 0.25; -- How far from the intendedHue the sine wave should go.
function onUpdate(elapsed)
	globalTime = globalTime + elapsed;
	setProperty('colorSwap.hue',  intendedHue + (math.sin(globalTime / sineTime) * sineAmp));
end

function thingie(num)
	num = tonumber(num)
	if num == 24 then
		doTweenAlpha('black', 'black', 0.0001, 7);
	end
	if num == 144 then
		setProperty('isCameraOnForcedPos', false);
		doTweenAlpha('dad', 'dad', 1, 2);
	end
	if num == 208 then
		doTweenAlpha('boyfriend', 'boyfriend', 1, 2);
	end
	if num == 352 then
		doTweenAlpha('extraChar', 'extraChar', 1, 2);
	end
	if num == 400 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.x', 845);
		setProperty('camFollow.y', 339);
	end
	if num == 464 then
		setProperty('isCameraOnForcedPos', false);
	end
	if num == 524 then
		doTweenAlpha('boyfriend', 'boyfriend', 0.0001, 1.2);
		doTweenAlpha('dad', 'dad', 0.0001, 1.2);
		doTweenAlpha('extraChar', 'extraChar', 0.0001, 1.2);
	end
	if num == 544 then
		doTweenAlpha('snowstorm', 'snowstorm', 0.0001, 1);
		doTweenAlpha('clouds', 'clouds', 0.3, 2);
		setProperty('boyfriend.alpha', 1);
		setProperty('dad.alpha', 1);
		setProperty('extraChar.alpha', 1);
		setProperty('boyfriend.color', 0xFFFFFF);
		setProperty('dad.color', 0xFFFFFF);
		setProperty('extraChar.color', 0xFFFFFF);
		setProperty('dad.missRecolor', true);
	end
	if num == 1034 then
		doTweenAlpha('clouds', 'clouds', 0.7, 2);
		doTweenAlpha('white', 'white', 1, 1.5, "easeincirc");
	end
	if num == 1056 then
		setProperty('dad.missRecolor', false);
		doTweenAlpha('white', 'white', 0.0001, 1);
		setProperty('icedragonBG.alpha', 1);
		setProperty('borderice.alpha', 1);
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.x', 845);
		setProperty('camFollow.y', 140);
		setProperty('camera.target.x', 845)
		setProperty('camera.target.y', 140)
		setProperty('boyfriend.color', 0x00000000);
		setProperty('dad.color', 0x00000000);
		setProperty('extraChar.color', 0x00000000);
	end
	if num == 1088 then
		doTweenAlpha('icedragonAlpha', 'icedragon', 1, 5);
		doTweenX('icedragonX', 'icedragon', -1280, 8, "quartout");
	end
	if num == 1312 then
		setProperty('dad.missRecolor', true);
		setProperty('boyfriend.color', 0xFFFFFF);
		setProperty('dad.color', 0xFFFFFF);
		setProperty('extraChar.color', 0xFFFFFF);
		setProperty('icedragonBG.alpha', 0.0001);
		setProperty('borderice.alpha', 0.0001);
		setProperty('icedragon.alpha', 0.0001);
		doTweenX('icedragonX', 'icedragon', -1480, 1, "quartout");
		setProperty('isCameraOnForcedPos', false);
	end
	if num == 1328 then
		doTweenAlpha('clouds', 'clouds', 0.0001, 2);
		doTweenAlpha('snow', 'snow', 0.0001, 3);
	end
	if num == 1344 then
		doTweenAlpha('vin', 'vin', 1, 3);
	end
	if num == 1436 then
		setProperty('black.alpha', 1);
	end
	if num == 1440 then
		setProperty('ember.alpha', 1);
		setProperty('dad.missRecolor', false);
		setProperty('black.alpha', 0.0001);
		setProperty('scroll.alpha', 1);
		setProperty('firefoxBG.alpha', 1);
		setProperty('borderfire.alpha', 1);
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.x', 845);
		setProperty('camFollow.y', 140);
		setProperty('camera.target.x', 845)
		setProperty('camera.target.y', 140)
		setProperty('boyfriend.color', 0x00000000);
		setProperty('dad.color', 0x00000000);
		setProperty('extraChar.color', 0x00000000);
	end
	if num == 1472 then
		doTweenAlpha('firefoxAlpha', 'firefox', 1, 5);
		doTweenX('firefoxX', 'firefox', -1280, 7, "quartout");
	end
	if num == 1696 then
		setProperty('dad.missRecolor', true);
		doTweenAlpha('vin', 'vin', 0.0001, 2);
		doTweenAlpha('ember', 'ember', 0.0001, 1.2);
		setProperty('scroll.alpha', 0.0001);
		setProperty('firefoxBG.alpha', 0.0001);
		setProperty('borderfire.alpha', 0.0001);
		setProperty('firefox.alpha', 0.0001);
		doTweenAlpha('clouds', 'clouds', 0.3, 2);
		doTweenAlpha('snow', 'snow', 1, 4);
		setProperty('boyfriend.color', 0xFFFFFF);
		setProperty('dad.color', 0xFFFFFF);
		setProperty('extraChar.color', 0xFFFFFF);
		setProperty('isCameraOnForcedPos', false);
		doTweenX('firefoxX', 'firefox', -1280, 2, "quartout");
	end
	if num == 1915 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.x', 845);
		doTweenY('moveCam', 'camFollow', -1110, 2.5, "easeincirc");
	end
	if num == 1936 then
		doTweenAlpha('white', 'white', 1, 0.7, "easeincirc");
	end
	if num == 1952 then
		setProperty('clouds.alpha', 0.25);
		setProperty('nightBG.alpha', 1);
		setProperty('lightfloor.alpha', 1);
		setProperty('borealis.alpha', 1);
		setProperty('ember.alpha', 1);
		setBlendMode('clouds', 'overlay');
		setBlendMode('icedragon', 'overlay');
		setBlendMode('firefox', 'overlay');
		doTweenAlpha('white', 'white', 0.0001, 0.7);
	end
	if num == 1968 then
		doTweenY('moveCam', 'camFollow', 200, 4);
	end
	if num == 2016 then
		doTweenAlpha('icedragon', 'icedragon', 0.4, 2);
		doTweenX('icedragonX', 'icedragon', -1280, 3.5, "quartout");
		doTweenAlpha('firefox', 'firefox', 0.4, 2);
		doTweenX('firefoxX', 'firefox', -1280, 5.5, "quartout");
	end
	if num == 2208 then
		setProperty('isCameraOnForcedPos', false);
	end
	if num == 2216 then
		doTweenAlpha('icedragon', 'icedragon', 0.0001, 2);
		doTweenAlpha('firefox', 'firefox', 0.0001, 2);
	end
	if num == 2464 then
		doTweenAlpha('clouds', 'clouds', 0.0001, 3);
		doTweenAlpha('ember', 'ember', 0.0001, 4);
		doTweenAlpha('snow', 'snow', 0.0001, 4);
	end
end


