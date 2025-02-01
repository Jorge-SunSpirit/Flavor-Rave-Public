local camAwesome = 0;
local songStarted = false;

function onCreate()
	addHaxeLibrary('FlxBackdrop', 'flixel.addons.display');
	
	makeAnimatedLuaSprite('synI', 'mainmenu/SynSun/npt/SynIntro', 725, 203);
	addAnimationByPrefix('synI', 'idle', 'SynInit', 24, false);
	addAnimationByPrefix('synI', 'jump', 'SynJump', 24, false);
	setScrollFactor('synI', 1, 1);
	playAnim('synI', 'idle');
	addLuaSprite('synI', true);

	makeLuaSprite('3dmark', 'mainmenu/SynSun/npt/bgmark', 0, 0);
	setScrollFactor('3dmark', 0.9, 0.9);
	addLuaSprite('3dmark', false);	
	setProperty('3dmark.alpha', 0.0001);

	makeLuaSprite('3dbgfloor', 'mainmenu/SynSun/npt/bgfloor', 0, 0);
	setScrollFactor('3dbgfloor', 1, 1);
	addLuaSprite('3dbgfloor', false);	
	setProperty('3dbgfloor.alpha', 0.0001);
	
	setProperty('synsuntext.velocity.x', 70);
	setProperty('synsuntext.y', 220);
	setProperty('synsuntext.alpha', 0.0001);
	
	setProperty('synsuntext2.velocity.x', -70);
	setProperty('synsuntext2.y', 420);
	setProperty('synsuntext2.alpha', 0.0001);
	
	makeAnimatedLuaSprite('syn3D', 'mainmenu/SynSun/npt/dance_syn', 130, 210);
	addAnimationByPrefix('syn3D', 'idle', 'synAnim', 24, true);
	setScrollFactor('syn3D', 1, 1);
	playAnim('syn3D', 'idle');
	scaleObject('syn3D', 0.8, 0.8);
	setProperty('syn3D.alpha', 0.0001);
	addLuaSprite('syn3D', true);
	
	makeAnimatedLuaSprite('sun3D', 'mainmenu/SynSun/npt/dance_sun', 550, 60);
	addAnimationByPrefix('sun3D', 'idle', 'sunAnim', 24, true);
	setScrollFactor('sun3D', 1, 1);
	playAnim('sun3D', 'idle');
	scaleObject('sun3D', 0.8, 0.8);
	setProperty('sun3D.alpha', 0.0001);
	addLuaSprite('sun3D', true);

	makeLuaSprite('barTop', 'closeup/TightBars', 0, -102);
	setScrollFactor('barTop', 0, 0);
	scaleObject('barTop', 1.1, 1);
	addLuaSprite('barTop', false);
	setObjectCamera('barTop', 'effect');

	makeLuaSprite('barBottom', 'closeup/TightBars', 0, 822);
	setScrollFactor('barBottom', 0, 0);
	scaleObject('barBottom', 1.1, 1);
	addLuaSprite('barBottom', false);
	setObjectCamera('barBottom', 'effect');

end

function onCreatePost()
	runHaxeCode([[
		trace('started');
		var bg3d:FlxBackdrop = new FlxBackdrop(Paths.image('mainmenu/SynSun/npt/farbg'), 0x01);
		bg3d.antialiasing = ClientPrefs.globalAntialiasing;
		game.insert(game.members.indexOf(game.getLuaObject('deskbg')) + 1, bg3d);
		setVar('bg3d', bg3d);
	
		var synsuntext:FlxBackdrop = new FlxBackdrop(Paths.image('mainmenu/SynSun/npt/bgscroll'), 0x01);
		synsuntext.antialiasing = ClientPrefs.globalAntialiasing;
		synsuntext.y = 190;
		game.insert(game.members.indexOf(game.getLuaObject('3dbgfloor')) + 1, synsuntext);
		setVar('synsuntext', synsuntext);

		var synsuntext2:FlxBackdrop = new FlxBackdrop(Paths.image('mainmenu/SynSun/npt/bgscroll2'), 0x01);
		synsuntext2.antialiasing = ClientPrefs.globalAntialiasing;
		synsuntext2.y = 490;
		game.insert(game.members.indexOf(game.getLuaObject('3dbgfloor')) + 1, synsuntext2);
		setVar('synsuntext2', synsuntext2);
		trace('finished');
	]]);

	setProperty('bg3d.velocity.x', -20);
	setProperty('bg3d.alpha', 0.0001);
	setProperty('synsuntext.velocity.x', -20);
	setProperty('synsuntext.alpha', 0.0001);
	setProperty('synsuntext2.velocity.x', 20);
	setProperty('synsuntext2.alpha', 0.0001);


	setProperty('dad.alpha', 0.001);
	scaleObject('dad', 0.9, 0.9);
end

function onStepHit()
	if curStep == 1 then
		songStarted = true
	end
	if curStep == 48 then
		setProperty('camZooming', true);
		setProperty('defaultCamZoom', 1.3);
		setProperty('camFollow.x', 687);
		setProperty('camFollow.y', 420);
	end
	if curStep == 52 then
		setProperty('synI.x', 427);
		setProperty('synI.y', 63);
		playAnim('synI', 'jump');
	end
	if curStep == 64 then
		setProperty('camFollow.x', 687);
		setProperty('camFollow.y', 278);
		setProperty('dad.alpha', 1);
	end
	if curStep == 128 then
		camAwesome = 1; -- Set this to any other number to disable the move camera
	end
	if curStep == 898 then
		doTweenAlpha('dramablack', 'dramablack', 0.6, 4);
		doTweenAlpha('drama', 'drama', 1, 4);
	end
	if curStep == 1344 then
		camAwesome = 0;
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.x', 639);
		setProperty('camFollow.y', 360);
	end
	if curStep == 1378 then
		setProperty('camFollow.x', 687);
		setProperty('camFollow.y', 278);
	end
	if curStep == 1390 then
		setProperty('camFollow.x', 639);
		setProperty('camFollow.y', 360);
		doTweenY('barTop', 'barTop', 0, 2, "circinout");
		doTweenY('barBottom', 'barBottom', 628, 2, "circinout");
		doTweenAlpha('scan', 'scan', 0.0001, 2);
		doTweenAlpha('drama', 'drama', 0.0001, 2);
		doTweenAlpha('dramablack', 'dramablack', 0.0001, 2);
		doTweenAlpha('bg3d', 'bg3d', 1, 2);
		doTweenAlpha('3dmark', '3dmark', 1, 2);
		doTweenAlpha('3dbgfloor', '3dbgfloor', 1, 2);
		doTweenAlpha('synsuntext', 'synsuntext', 1, 2);
		doTweenAlpha('synsuntext2', 'synsuntext2', 1, 2);
		doTweenAlpha('dad', 'dad', 0.0001, 1);
		doTweenAlpha('boyfriend', 'boyfriend', 0.0001, 1);
	end
	if curStep == 1408 then
		doTweenAlpha('syn3D', 'syn3D', 1, 1);
		doTweenAlpha('sun3D', 'sun3D', 1, 1);
		setProperty('defaultCamZoom', 1);
	end
	if curStep == 1664 then
		doTweenY('barTop', 'barTop', -102, 1, "circinout");
		doTweenY('barBottom', 'barBottom', 822, 1, "circinout");
		setProperty('scan.alpha', 1);
		setProperty('bg3d.alpha', 0);
		setProperty('3dbgfloor.alpha', 0);
		setProperty('3dmark.alpha', 0);
		setProperty('synsuntext.alpha', 0);
		setProperty('synsuntext2.alpha', 0);
		setProperty('syn3D.alpha', 0);
		setProperty('sun3D.alpha', 0);
		setProperty('dad.alpha', 1);
		setProperty('boyfriend.alpha', 1);
	end
end

function onMoveCamera(focus)
	if camAwesome == 1 and songStarted then
		if focus == 'dad' then
			setProperty('defaultCamZoom', 1.3);
			setProperty('camFollow.x', 687);
			setProperty('camFollow.y', 278);
		elseif focus == 'boyfriend' then
			setProperty('defaultCamZoom', 1.2);
			setProperty('camFollow.x', 742);
			setProperty('camFollow.y', 319);
		end
	end
end

