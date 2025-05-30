function onCreate()
	makeLuaSprite('sky', 'stages/corianda-run/sky', -400, -400);
	setScrollFactor('sky', 0.1, 0.12);
	scaleObject('sky', 1.2, 1.2);
	addLuaSprite('sky', false);

	makeLuaSprite('skynight', 'stages/corianda-run/skynight', -400, -400);
	setScrollFactor('skynight', 0.1, 0.12);
	scaleObject('skynight', 1.2, 1.2);
	addLuaSprite('skynight', false);
	setProperty('skynight.alpha', 0.001);

	addHaxeLibrary('FlxBackdrop', 'flixel.addons.display');

	runHaxeCode([[
		var cityscroll:FlxBackdrop = new FlxBackdrop(Paths.image('stages/corianda-run/cityscroll'), 0x01);
		cityscroll.antialiasing = ClientPrefs.globalAntialiasing;
		game.insert(game.members.indexOf(game.getLuaObject('skynight')) + 1, cityscroll);
		setVar('cityscroll', cityscroll);
		
		var cityscrollnight:FlxBackdrop = new FlxBackdrop(Paths.image('stages/corianda-run/cityscrolllights'), 0x01);
		cityscrollnight.antialiasing = ClientPrefs.globalAntialiasing;
		game.insert(game.members.indexOf(game.getLuaObject('cityscroll')) + 1, cityscrollnight);
		setVar('cityscrollnight', cityscrollnight);
	]]);
	
	setScrollFactor('cityscroll', 0.2, 0.24);
	setProperty('cityscroll.velocity.x', -150);	
	setProperty('cityscrollnight.alpha', 0.0001);
	setScrollFactor('cityscrollnight', 0.2, 0.24);
	setProperty('cityscrollnight.velocity.x', -150);	
	
	makeAnimatedLuaSprite('RaveSpeed', 'stages/corianda-run/RaveBG', -500, -550);
	addAnimationByPrefix('RaveSpeed', 'idle', 'RaveBG', 26, true);
	setScrollFactor('RaveSpeed', 0, 0.1);
	playAnim('RaveSpeed', 'idle', true);
	scaleObject('RaveSpeed', 2, 2);
	setProperty('RaveSpeed.alpha', 0.0001);
	addLuaSprite('RaveSpeed', false);
	
	makeAnimatedLuaSprite('RaveSpeedSavory', 'stages/corianda-run/RaveBGSavory', -500, -550);
	addAnimationByPrefix('RaveSpeedSavory', 'idle', 'RaveBG', 26, true);
	setScrollFactor('RaveSpeedSavory', 0, 0.1);
	playAnim('RaveSpeedSavory', 'idle', true);
	scaleObject('RaveSpeedSavory', 2, 2);
	setProperty('RaveSpeedSavory.alpha', 0.0001);
	addLuaSprite('RaveSpeedSavory', false);
end

function onUpdate(elapsed)
		setProperty('cityscrollnight.alpha', getProperty('cityscrollnight.alpha') - ((crochet / 2000) * elapsed * 2));
end