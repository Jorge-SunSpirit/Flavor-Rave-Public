local camAwesome = 0;
local songStarted = false;

local likesVer = '';

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
	
	makeAnimatedLuaSprite('SynSunEnd', 'mainmenu/SynSun/npt/synsun', 550, 60);
	addAnimationByPrefix('SynSunEnd', 'idle', '0', 24, false);
	setScrollFactor('SynSunEnd', 0, 0);
	playAnim('SynSunEnd', 'idle');
	scaleObject('SynSunEnd', 2, 2);
	setProperty('SynSunEnd.alpha', 0.0001);
	addLuaSprite('SynSunEnd', true);
	screenCenter('SynSunEnd');
	setObjectCamera('SynSunEnd', 'effect');
	
	makeLuaSprite('SynSunEndDrawn', 'mainmenu/SynSun/npt/Endscreen', 0, 0);
	setScrollFactor('SynSunEndDrawn', 0, 0);
	scaleObject('SynSunEndDrawn', 1, 1);
	addLuaSprite('SynSunEndDrawn', true);
	setProperty('SynSunEndDrawn.alpha', 0.0001);
	setObjectCamera('SynSunEndDrawn', 'effect');
	
	makeLuaSprite('white', '', -100, -100);
    makeGraphic('white', 2560, 1440, '00FFFF');
    setScrollFactor('white', 0, 0);
    screenCenter('white');
    addLuaSprite('white', true);
	setProperty('white.alpha', 0.0001);
	setObjectCamera('white', 'effect');

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
	
	liveYPos = 640;
	if downscroll then	liveYPos = 40;	end

	makeLuaSprite('liveIcon', 'mainmenu/SynSun/live', 30, liveYPos);
	setScrollFactor('liveIcon', 1, 1);
	scaleObject('liveIcon', 0.9, 0.9);
	setObjectCamera('liveIcon', 'effect');
	addLuaSprite('liveIcon', true);
	
	likesYPos = 572;
	if downscroll then	likesYPos = -34.9;	end

	makeAnimatedLuaSprite('likes', 'mainmenu/SynSun/npt/npt-likes', 1020, likesYPos);
	addAnimationByPrefix('likes', 'none', 'None', 24, false);
	addAnimationByPrefix('likes', 'low', 'Low', 24, false);
	addAnimationByPrefix('likes', 'lowmed', 'ALowMed', 24, false);
	addAnimationByPrefix('likes', 'med', 'Med', 24, false);
	addAnimationByPrefix('likes', 'medhigh', 'AMedHigh', 24, false);
	addAnimationByPrefix('likes', 'high', 'High', 24, false);
	addAnimationByPrefix('likes', 'highmax', 'AHighMax', 24, false);
	addAnimationByPrefix('likes', 'maxlikes', 'Max', 24, false);
	setScrollFactor('likes', 0, 0);
	playAnim('likes', 'none');
	addLuaSprite('likes', true);
	setObjectCamera('likes', 'effect');

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

function thingie(num)
	num = tonumber(num)
	if num == 1 then
		songStarted = true
	end
	if num == 48 then
		setProperty('camZooming', true);
		setProperty('defaultCamZoom', 1.3);
		setProperty('camFollow.x', 687);
		setProperty('camFollow.y', 420);
	end
	if num == 52 then
		setProperty('synI.x', 427);
		setProperty('synI.y', 63);
		playAnim('synI', 'jump');
	end
	if num == 64 then
		setProperty('camFollow.x', 687);
		setProperty('camFollow.y', 278);
		setProperty('dad.alpha', 1);
	end
	if num == 128 then
		camAwesome = 1; -- Set this to any other number to disable the move camera
	end
	if num == 384 then
		playAnim('likes', 'low');
	end
	if num == 512 then
		playAnim('likes', 'lowmed');
	end
	if num == 639 then
		likesVer = 'med';
	end
	if num == 767 then
		likesVer = 'likesmedhigh';
	end
	if num == 897 then
		doTweenAlpha('dramablack', 'dramablack', 0.6, 4);
		doTweenAlpha('drama', 'drama', 1, 4);
		likesVer = 'high';
	end
	if num == 1151 then
		likesVer = 'highmax';
	end
	if num == 1344 then
		camAwesome = 0;
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.x', 639);
		setProperty('camFollow.y', 360);
	end
	if num == 1378 then
		setProperty('camFollow.x', 687);
		setProperty('camFollow.y', 278);
	end
	if num == 1390 then
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
	if num == 1407 then
		likesVer = 'maxlikes';
	end
	if num == 1408 then
		doTweenAlpha('syn3D', 'syn3D', 1, 1);
		doTweenAlpha('sun3D', 'sun3D', 1, 1);
		setProperty('defaultCamZoom', 1);
	end
	if num == 1664 then
		doTweenY('barTop', 'barTop', -102, 1, "circinout");
		doTweenY('barBottom', 'barBottom', 822, 1, "circinout");
		setProperty('bg3d.alpha', 0);
		setProperty('3dbgfloor.alpha', 0);
		setProperty('3dmark.alpha', 0);
		setProperty('synsuntext.alpha', 0);
		setProperty('synsuntext2.alpha', 0);
		setProperty('syn3D.alpha', 0);
		setProperty('sun3D.alpha', 0);
		
		playAnim('SynSunEnd', 'idle', true);
		setProperty('SynSunEnd.alpha', 1);
		doTweenAlpha('camHUD', 'camHUD', 0, 2, 'circout')
	end
	if num == 1728 then 
		setProperty('liveIcon.alpha', 0);
		setProperty('likes.alpha', 0);
		setProperty('SynSunEndDrawn.alpha', 1);
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
function onBeatHit()
	if curBeat % 4 == 0 and likesVer == 'med' then
		playAnim('likes', 'med');
	end
	if curBeat % 4 == 0 and likesVer == 'medhigh' then
		playAnim('likes', 'medhigh');
	end
	if curBeat % 2 == 0 and likesVer == 'high' then
		playAnim('likes', 'high');
	end
	if curBeat % 2 == 0 and likesVer == 'highmax' then
		playAnim('likes', 'highmax');
	end
	if curBeat % 2 == 0 and likesVer == 'maxlikes' then
		playAnim('likes', 'maxlikes');
	end

end

