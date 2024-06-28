posX = 0;
posYcut = -10;
posY = 0;

function onCreate()
	addHaxeLibrary('FlxBackdrop', 'flixel.addons.display');	
	makeLuaSprite('sweetBGFar', 'closeup/SC_Sky', posX, posY);
	setScrollFactor('sweetBGFar', 0, 0);
	addLuaSprite('sweetBGFar', false);
	setProperty('sweetBGFar.alpha', 0.0001);
	
	runHaxeCode([[
		var farMountain:FlxBackdrop = new FlxBackdrop(Paths.image('closeup/SC_BackMount'), 0x01);
		farMountain.antialiasing = ClientPrefs.globalAntialiasing;
		farMountain.y = 0;
		game.addBehindGF(farMountain);
		setVar('farMountain', farMountain);
		
		var mountain:FlxBackdrop = new FlxBackdrop(Paths.image('closeup/SC_FrontMount'), 0x01);
		mountain.antialiasing = ClientPrefs.globalAntialiasing;
		mountain.y = 0;
		game.addBehindGF(mountain);
		setVar('mountain', mountain);
	]]);
	setScrollFactor('farMountain', 0, 0);
	setProperty('farMountain.velocity.x', 20 * playbackRate);
	setProperty('farMountain.alpha', 0.0001);
	setScrollFactor('mountain', 0, 0);
	setProperty('mountain.velocity.x', 50 * playbackRate);
	setProperty('mountain.alpha', 0.0001);

	makeLuaSprite('sweetBG', 'closeup/sugarcoatBG', posX, posY);
	setScrollFactor('sweetBG', 0, 0);
	addLuaSprite('sweetBG', false);
	setProperty('sweetBG.alpha', 0.0001);
	setProperty('gf.alpha', 0.0001);
	
	makeAnimatedLuaSprite('speedline', 'closeup/speedline', 540, 0);
	addAnimationByPrefix('speedline', 'idle', 'vert', 24, true);
	playAnim('speedline', 'idle');
	setScrollFactor('speedline', 0, 0);
	setProperty('speedline.alpha', 0.001);
	addLuaSprite('speedline', false);

	makeAnimatedLuaSprite('crowd0', 'bg1/Background_Cameo_Assets2', -522, 35);
	addAnimationByPrefix('crowd0', 'idle', 'All', 24, false);
	playAnim('crowd0', 'idle');
	finishAnim('crowd0');
	setScrollFactor('crowd0', 0.9, 1);
	setProperty('crowd0.alpha', 0.001);

	setProperty('stans.alpha', 0.001);
	setProperty('kyle.alpha', 0.001);

	runHaxeCode([[
		game.insert(game.members.indexOf(game.getLuaObject('sweetbuslight')) + 1, game.getLuaObject('crowd0'));
	]]);

	makeAnimatedLuaSprite('SourCutinSC', 'closeup/SourCutinSugarcoat', -1280, 91);
	addAnimationByPrefix('SourCutinSC', 'idle', 'SourCutinSugarcoat', 24, false);
	playAnim('SourCutinSC', 'idle');
	setScrollFactor('SourCutinSC', 0, 0);
	addLuaSprite('SourCutinSC', false);
	setObjectCamera('SourCutinSC', 'hud');

	makeAnimatedLuaSprite('SweetCutInSC', 'closeup/SweetCutInsSugarcoat', 1280, 359);
	addAnimationByPrefix('SweetCutInSC', 'idle', 'SugarCutinSugarcoat', 24, false);
	playAnim('SweetCutInSC', 'idle');
	setScrollFactor('SweetCutInSC', 0, 0);
	addLuaSprite('SweetCutInSC', false);
	setObjectCamera('SweetCutInSC', 'hud');
end

function onCreatePost()

	makeLuaSprite('black', '', -100, -100);
    makeGraphic('black', 1280*2, 720*2, '000000');
    setScrollFactor('black', 0, 0);
    screenCenter('black');
    addLuaSprite('black', true);

	makeLuaSprite('whitehueh', 'dreamcast/art_BG/whitehueh', 0, 0);
	setScrollFactor('whitehueh', 0, 0);
	addLuaSprite('whitehueh', true);
	setObjectCamera('whitehueh', 'hud');
	setProperty('whitehueh.alpha', 0.0001);


	makeLuaSprite('21', 'dreamcast/art_BG/21', 0, 0);
	setScrollFactor('21', 0, 0);
	addLuaSprite('21', true);
	setObjectCamera('21', 'hud');
	setProperty('21.alpha', 0.0001);
	
	makeLuaSprite('22', 'dreamcast/art_BG/22', 0, 0);
	setScrollFactor('22', 0, 0);
	addLuaSprite('22', true);
	setObjectCamera('22', 'hud');
	setProperty('22.alpha', 0.0001);
	
	makeLuaSprite('23', 'dreamcast/art_BG/23', 0, 0);
	setScrollFactor('23', 0, 0);
	addLuaSprite('23', true);
	setObjectCamera('23', 'hud');
	setProperty('23.alpha', 0.0001);
	
	setProperty('equipment.alpha', 0.0001);
	setProperty('crowd0.alpha', 1);
	cutIn(11);
	setProperty('isCameraOnForcedPos', true);
	setProperty('camFollow.y', 525);
	setProperty('camFollow.x', 900);
	setProperty('camera.target.x', 900);
	setProperty('camera.target.y', 525);
end

function thingie(num)
	num = tonumber(num)
	if num == 43 then
		doTweenAlpha('whitehueh', 'whitehueh', 1, 2, 'circInOut');
	end 
	if num == 70 then
		setProperty('black.alpha', 0.0001);
	end 
	if num == 74 then
		doTweenAlpha('whitehueh', 'whitehueh', 0.0001, 5, 'cubeinout');
	end 
	if num == 894 then
		cutIn(0);
	end 
	if num == 902 then
		cutIn(9);
	end 
	if num == 910 then
		cutIn(1);
		cutIn(9);
	end 
	
	if num == 1670 then -- fade to white
		doTweenAlpha('whitehueh', 'whitehueh', 1, 2.5);
	end 
	
	if num == 1712 then -- fade to 21
		doTweenAlpha('21', '21', 1, 3);
	end 
	
	if num == 1759 then -- fade to 22
		doTweenAlpha('22', '22', 1, 3);
	end 
	
	if num == 1837 then -- fade to colored image
		doTweenAlpha('23', '23', 1, 3);
	end
end

function onStepHit()
	-- Center camera stuff
	if curStep >= 986 and curStep <= 1150 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 360);
		setProperty('camFollow.x', 737);
	elseif curStep >= 1200 and curStep <= 1216 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 360);
		setProperty('camFollow.x', 737);
	elseif curStep >= 1244 and curStep <= 1280 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 360);
		setProperty('camFollow.x', 737);
	elseif curStep >= 1326 and curStep <= 1408 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 360);
		setProperty('camFollow.x', 737);
	elseif curStep >= 1610 and curStep <= 1648 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 360);
		setProperty('camFollow.x', 737);
	elseif curStep >= 986 and curStep <= 1648 then
		setProperty('isCameraOnForcedPos', false);
	end
end

function cutIn(num)
	if num == 0 then -- adds the cutins
		doTweenY('barTop', 'barTop', 0, 0.5, "circinout");
		doTweenY('barBottom', 'barBottom', 628, 0.5, "circinout");
		doTweenX('SourCutinSC', 'SourCutinSC', 0, 1, "cubeinout");
		doTweenX('SweetCutInSC', 'SweetCutInSC', 0, 1, "cubeinout");
		playAnim('SourCutinSC', 'idle');
		playAnim('SweetCutInSC', 'idle');
	end
	if num == 1 then -- tween away cutins
		doTweenX('SourCutinSC', 'SourCutinSC', 1280, 0.5, "circinout");
		doTweenX('SweetCutInSC', 'SweetCutInSC', -1280, 0.5, "circinout");
	end
	
	--Moving tweens
	if num == 2 then -- tween in sourBack and BF
		doTweenX('boyfriendGroup', 'boyfriendGroup', 1000, 0.7, "cubeinout");
	end
	if num == 3 then -- tween away BF and sourBack
		doTweenX('boyfriendGroup', 'boyfriendGroup', 1800, 0.7, "cubeinout");
	end
	
	if num == 4 then -- tween in sweetback and dad
		doTweenX('dadGroup', 'dadGroup', 300, 0.7, "cubeinout");
	end
	if num == 5 then -- tween away sweetback and dad
		doTweenX('dadGroup', 'dadGroup', -500, 0.7, "cubeinout");
	end
	
	if num == 6 then -- tween in bf and dad
		doTweenX('dadGroup', 'dadGroup', 300, 0.7, "cubeinout");
		doTweenX('boyfriendGroup', 'boyfriendGroup', 1000, 0.7, "cubeinout");
	end
	
	if num == 7 then -- tween out bf and dad
		doTweenX('dadGroup', 'dadGroup', -500, 0.7, "cubeinout");
		doTweenX('boyfriendGroup', 'boyfriendGroup', 1800, 0.7, "cubeinout");
	end
	
	
	
	--Reset
	if num == 9 then -- reset
		setProperty('cameraSpeed', 1);
		runTimer('slowblackbar', 0.4);
		doTweenX('transition', 'transition', 1280, 0.8);
		runTimer('hueh', 0.4);
	end
	
	--Initialize
	if num == 10 then -- initialize while the cutins are active
		doTweenX('dadGroup', 'dadGroup', -500, 0.1);
		setProperty('defaultCamZoom', 1);
		doTweenZoom('zoomcamera', 'camGame', 1, 0.01);
		setProperty('camZooming', true);
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 525);
		setProperty('camFollow.x', 900);
		setProperty('sweetBG.alpha', 1);
		setProperty('sweetBGFar.alpha', 1);
		setProperty('speedline.alpha', 1);
	end
	
	if num == 11 then -- insta setup
		setProperty('barTop.y', 0);
		setProperty('barBottom.y', 628);
		doTweenX('dadGroup', 'dadGroup', 300, 0.001);
		setProperty('camZooming', true);
		setProperty('defaultCamZoom', 1);
		doTweenZoom('zoomcamera', 'camGame', 1, 0.1);
		setProperty('sweetBG.alpha', 1);
		setProperty('speedline.alpha', 1);
		setProperty('sweetBGFar.alpha', 1);
		setProperty('farMountain.alpha', 1);
		setProperty('mountain.alpha', 1);
		-- doTweenX('boyfriend', 'boyfriend', getProperty('boyfriend.x') - 125, 0.1, "cubeinout");
	end
end

function onBeatHit()
	if curBeat % 2 == 0 then
		playAnim('crowd0', 'idle', true);
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'slowblackbar' then
		doTweenY('barTop', 'barTop', -102, 0.25, "circinout");
		doTweenY('barBottom', 'barBottom', 822, 0.25, "circinout");
	end
	if tag == 'hueh' then
		setProperty('isCameraOnForcedPos', false);
		setProperty('camFollow.y', 400);
		setProperty('camFollow.x', 850);
		doTweenX('boyfriendGroup', 'boyfriendGroup', 1000, 0.01);
		doTweenX('dadGroup', 'dadGroup', -50, 0.01);
		setProperty('sweetBG.alpha', 0.001);
		setProperty('speedline.alpha', 0.001);
		setProperty('sweetBGFar.alpha', 0.0001);
		setProperty('defaultCamZoom', 0.5);
		setProperty('farMountain.alpha', 0.001);
		setProperty('mountain.alpha', 0.001);
	end
end