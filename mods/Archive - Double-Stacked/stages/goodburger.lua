function onCreate()
	addHaxeLibrary('FlxBackdrop', 'flixel.addons.display');

	posX = -0;
	posY = -0;
	scale = 0.5;
	
	makeLuaSprite('bgkitchen', 'uncle-hearty/farbg', posX, posY);
	setScrollFactor('bgkitchen', 0.7, 0.7);
	scaleObject('bgkitchen', scale, scale);
	addLuaSprite('bgkitchen', false);

	makeAnimatedLuaSprite('umami', 'uncle-hearty/umami_bg', 636, 200);
	addAnimationByPrefix('umami', 'idle', 'DS_Umami_BackgroundBop', 24, true);
	playAnim('umami', 'idle');
	setProperty('umami.alpha', 0.0001);
	setScrollFactor('umami', 0.8, 0.8);
	scaleObject('umami', 0.6, 0.6);
	addLuaSprite('umami', false);
	
	for i = 0,3,1 do
		makeLuaSprite('ad' .. i, 'uncle-hearty/ads/BasicScreen', 0, 0);
		scaleObject('ad' .. i, scale, scale);
		setScrollFactor('ad' .. i, 0.8, 0.8);
		addLuaSprite('ad' .. i, false);
	end
	setProperty('ad0.x', 415);
	setProperty('ad0.y', 141);
	scaleObject('ad0', 0.46, 0.46);
	
	setProperty('ad1.x', 575);
	setProperty('ad1.y', 137);
	
	setProperty('ad2.x', 742);
	setProperty('ad2.y', 137);
	
	setProperty('ad3.x', 915);
	setProperty('ad3.y', 141);
	scaleObject('ad3', 0.46, 0.46);

	makeLuaSprite('bg', 'uncle-hearty/mainbg', posX, posY);
	setScrollFactor('bg', 0.8, 0.8);
	scaleObject('bg', scale, scale);
	addLuaSprite('bg', false);
	
	makeLuaSprite('dork', 'uncle-hearty/customers/Richard', -400, -25);
	setScrollFactor('dork', 0.9, 1);
	scaleObject('dork', 0.8, 0.8);
	addLuaSprite('dork', false);

	makeLuaSprite('dramablack', '', -100, -100);
    makeGraphic('dramablack', 1280*2, 720*2, '000000');
    setScrollFactor('dramablack', 0, 0);
    screenCenter('dramablack');
	setProperty('dramablack.alpha', 0.00001);
    addLuaSprite('dramablack', false);

	makeLuaSprite('burgertime', 'uncle-hearty/spotlight', posX, posY);
	setScrollFactor('burgertime', 0.7, 0.7);
	setProperty('burgertime.alpha', 0.0001);
	scaleObject('burgertime', scale, scale);
	addLuaSprite('burgertime', false);
	
	makeLuaSprite('chairs', 'uncle-hearty/chairs', posX, posY);
	setScrollFactor('chairs', 1, 1);
	scaleObject('chairs', scale, scale);
	addLuaSprite('chairs', false);
	
	makeLuaSprite('table', 'uncle-hearty/fronttable', posX, posY);
	setScrollFactor('table', 1, 1);
	scaleObject('table', scale, scale);
	addLuaSprite('table', false);
	
	makeLuaSprite('tray', 'uncle-hearty/trays', posX, posY);
	setScrollFactor('tray', 1, 1);
	scaleObject('tray', scale, scale);
	addLuaSprite('tray', false);
	
	changeBillboards();
end

function onBeatHit()
	if curBeat % 2 == 0 then
		playAnim('leftcrowd', 'idle');
		playAnim('rightcrowd', 'idle');
	end
end

local lightningStrikeBeat = 0;
local lightningOffset = 8;
local hasSpawnedChara = false;

function onBeatHit()
	if hasSpawnedChara == false and getRandomBool(10) and curBeat > lightningStrikeBeat + lightningOffset then
		spawnDork(getRandomBool(50))
	end
	
	if curBeat % 2 == 0 then
		setProperty('dork.y', 0);
		doTweenY('dorkbump', 'dork', -10, 0.15, "circOut");
	end
	
	if curBeat % 32 == 0 then
		changeBillboards();
	end
end

function changeBillboards()
	runHaxeCode([[
		var ads:Array<String> = ['BasicScreen', 'BasicScreen2', 'BasicScreen3', 'GloopoGulp', 'GrandsSlam', 'MachinesSalad', 'DrinksOnMe', 'Sause', 'Bellameal', 'OCChowdown'];
		var rareArray:Array<String> = ['ort', 'ort'];
		for (i in 0...4)
		{
			var randInt:Int = FlxG.random.int(0, ads.length - 1);
			ads.remove(randInt);
			var ad:String = ads[randInt];
			if (FlxG.random.int(1, 100) == 1)
				ad = rareArray[FlxG.random.int(0, rareArray.length - 1)];
			
			var spriteName:String = 'uncle-hearty/ads/' + ad;
			var sprite:ModchartSprite = game.getLuaObject('ad'+i);
			sprite.loadGraphic(Paths.image(spriteName));
		}
	]])
end

function spawnDork(bool)
	if bool == true then
		setProperty('dork.x', -400);
		setProperty('dork.velocity.x', 90);
		setProperty('dork.flipX', true);
	else
		setProperty('dork.x', 1300);
		setProperty('dork.velocity.x', -90);
		setProperty('dork.flipX', false);
	end
	
	runHaxeCode([[
		var charas:Array<String> = ['MrThrowdown', 'Richard', 'Savory', 'SundriedSynthetic', 'Sutazu', 'Sven', 'tbdtan', 'koolguykyle'];
		var spriteName:String = 'uncle-hearty/customers/' + charas[FlxG.random.int(0, charas.length - 1)];
		var sprite:ModchartSprite = game.getLuaObject('dork');
		sprite.loadGraphic(Paths.image(spriteName));
	]])
	
	hasSpawnedChara = true;
	runTimer("dorkisMovin", 20, 1)
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'dorkisMovin' then
		hasSpawnedChara = false;
		lightningStrikeBeat = curBeat;
		lightningOffset = getRandomInt(10,50);
	end
end