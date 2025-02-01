local timers1={
		[1]={'sceneLength', 20},
		[2]={'zoomin', 0.001},
		[3]={'fadeOut', 2.5},
		[4]={'fadeIn', 5},
		[5]={'cutin', 10},
		[6]={'swaptoStage', 14}
	}
local timers2={
		[1]={'sceneLength', 20},
		[2]={'glows', 0.001},
		[3]={'lighting', 2},
		[4]={'whiteflash', 2.5}
	}
local cutsceneCallbacks={
		['sceneLength']=function()
		end,
		['zoomin']=function()
			setProperty('defaultCamZoom', 1.5);
			doTweenZoom('zoomCam', 'camGame', 1.5, 5, "circout")
			doTweenY('camy', 'camera.target', 324, 5, "circout")
		end,
		['fadeOut']=function()
			doTweenAlpha('black', 'black', 1, 2.5);
		end,
		['fadeIn']=function()
			setProperty('roomBG.alpha', 0.001);
			doTweenAlpha('black', 'black', 0, 0.1);
			setProperty('CGBLACK.alpha', 1);
			setProperty('dorksSil.alpha', 1);
			setProperty('dorksSil.y', -10);
			doTweenY('dorksSil', 'dorksSil', 1280, 30, "linear")
		end,
		['cutin']=function()
			doTweenY('cutinskyBG', 'cutinskyBG', -140, 3, "circout");
			setProperty('cutinskyBG.alpha', 1);
			setProperty('sourDork.alpha', 1);
			setProperty('sweetDork.alpha', 1);
			doTweenY('sourDork', 'sourDork', 0, 4.1, "circout");
			doTweenY('sweetDork', 'sweetDork', 0, 4, "circout");
		end,
		['swaptoStage']=function()
			setProperty('extraChar.alpha', 1);
			setProperty('boyfriend.alpha', 1);
			setProperty('gf.alpha', 1);
			setProperty('dad.alpha', 1);
			callOnLuas('swapBG', {'1'})
			callOnLuas('swapBG', {'1'})
			setProperty('CGBLACK.alpha', 0.001);
			setProperty('dorksSil.alpha', 0.001);
			doTweenAlpha('sourDork', 'sourDork', 0, 1, "circout");
			doTweenAlpha('sweetDork', 'sweetDork', 0, 1, "circout");
			doTweenAlpha('cutinskyBG', 'cutinskyBG', 0, 1, "circout");
			
			setProperty('camera.target.x', 370);
			setProperty('camera.target.y', 6);
			setProperty('camFollow.x', 370);
			setProperty('camFollow.y', 6);
		end,
		['glows']=function()
		end,
		['lighting']=function()
			setProperty('warper.alpha', 1);
			playAnim('warper', 'idle');
			setProperty('extraChar.alpha', 0.001);
			setProperty('boyfriend.alpha', 0.001);
			triggerEvent('Screen Flash', "1", "white");
			setProperty('gf.alpha', 0.001);
			setProperty('dad.alpha', 0.001);
		end,
		['whiteflash']=function()
			setProperty('warper.alpha', 0.0001);
		end
	}



function onCreate()
	posX = -0;
	posY = -0;
	scale = 1;
	
	makeAnimatedLuaSprite('warper', 'sweetroom/GetWarped', -300, 0);
	addAnimationByPrefix('warper', 'idle', 'CoolLaser', 24, false);
	playAnim('warper', 'idle');
	finishAnim('warper', 'idle');
	addLuaSprite('warper', true);
	setProperty('warper.alpha', 0.0001);
	
	makeLuaSprite('CGBLACK', '', -100, -100);
    makeGraphic('CGBLACK', 1280*2, 720*2, '000000');
    setScrollFactor('CGBLACK', 0, 0);
    screenCenter('CGBLACK');
	setProperty('CGBLACK.alpha', 0.0001);
    addLuaSprite('CGBLACK', false);
	
	makeLuaSprite('dorksSil', 'funktrix/fallin', 0, 0);
	setScrollFactor('dorksSil', 0, 0);
	addLuaSprite('dorksSil', false);
	screenCenter('dorksSil');
	setProperty('dorksSil.alpha', 0.0001);
	scaleObject('dorksSil', 0.8, 0.8);
	
	makeLuaSprite('cutinBG', 'funktrix/CutinBG', 1280, 0);
	setScrollFactor('cutinBG', 0, 0);
	addLuaSprite('cutinBG', false);
	setObjectCamera('cutinBG', 'effect');
	setProperty('cutinBG.alpha', 0.0001);
	
	makeLuaSprite('cutinBG2', 'funktrix/CutinBG', 0, -1280);
	setScrollFactor('cutinBG2', 0, 0);
	addLuaSprite('cutinBG2', false);
	setObjectCamera('cutinBG2', 'effect');
	setProperty('cutinBG2.alpha', 0.0001);
	
	makeLuaSprite('cutinskyBG', 'funktrix/CutinBGSKY', 0, -1280);
	setScrollFactor('cutinskyBG', 0, 0);
	addLuaSprite('cutinskyBG', false);
	setObjectCamera('cutinskyBG', 'effect');
	setProperty('cutinskyBG.alpha', 0.0001);
	
	makeLuaSprite('sourDork', 'funktrix/Gamejamed_sour', 148, 689);
	setScrollFactor('sourDork', 0, 0);
	addLuaSprite('sourDork', false);
	setObjectCamera('sourDork', 'effect');
	setProperty('sourDork.alpha', 0.0001);
	
	makeLuaSprite('sweetDork', 'funktrix/Gamejamed_sweet', 646, 608);
	setScrollFactor('sweetDork', 0, 0);
	addLuaSprite('sweetDork', false);
	setObjectCamera('sweetDork', 'effect');
	setProperty('sweetDork.alpha', 0.0001);
	
	makeAnimatedLuaSprite('torrentCutIn', 'funktrix/GJCutin', 0, 720);
	addAnimationByPrefix('torrentCutIn', 'idle', 'GJCutIn', 24, false);
	playAnim('torrentCutIn', 'idle');
	finishAnim('torrentCutIn', 'idle');
	addLuaSprite('torrentCutIn', false);
	setObjectCamera('torrentCutIn', 'effect');
	setProperty('torrentCutIn.alpha', 0.0001);
	
	makeLuaSprite('black', '', -100, -100);
    makeGraphic('black', 1280*2, 720*2, '000000');
    setScrollFactor('black', 0, 0);
    screenCenter('black');
    addLuaSprite('black', true);
	--doTweenAlpha('black', 'black', 0, 0.001);
	
	--Cannot screenflash have to use this
	makeLuaSprite('white', '', -100, -100);
	makeGraphic('white', 1280*2, 720*2, 'FFFFFF');
	setScrollFactor('white', 0, 0);
	screenCenter('white');
	setObjectCamera('white', 'effect');
	setProperty('white.alpha', 0.001);
	addLuaSprite('white', true);
	
	setProperty('healthCharNote', true);
	setProperty('ratingCharNote', true);
	setProperty('noteSkinCharNote', true);
end

function onCreatePost()
	initLuaShader('glitch');
	setProperty('dad.color', 0x00000000);
	setProperty('gf.color', 0x00000000);
end

function onStepHit()
	if not getProperty('endingSong') then
		if curStep == 4 then
			doTweenAlpha('black', 'black', 0, 4);
		end
		if curStep == 64 then
		setProperty('introstatic.alpha', 0.0001);
		setProperty('dad.color', 0xFFFFFF);
		setProperty('gf.color', 0xFFFFFF);
		end
		if curStep == 752 then
			for aaa=1,table.maxn(timers2) do
				runTimer(timers2[aaa][1], timers2[aaa][2], 1)
			end
		end
		if curStep == 768 then
			callOnLuas('swapBG', {'2'})
			
		end
		if curStep == 774 then
			for aaa=1,table.maxn(timers1) do
				runTimer(timers1[aaa][1], timers1[aaa][2], 1)
			end
		end
		if curStep == 1040 then
			--Center Camera
			setProperty('isCameraOnForcedPos', true);
			setProperty('camFollow.x', 350);
			setProperty('camFollow.y', 400);
			setProperty('white.alpha', 0.5);
			doTweenAlpha('white', 'white', 0, 0.7);
			if shadersEnabled then setSpriteShader('cutinBG', 'glitch'); end
			setProperty('cutinBG.alpha', 1);
			setProperty('cutinBG.x', 0);
			setProperty('cutinBG2.y', 0);
			doTweenAlpha('cutinBG2', 'cutinBG2', 1, 1.5, "circout");
		end
		if curStep == 1044 then
			setProperty('torrentCutIn.alpha', 1);
			doTweenY('torrentCutIn', 'torrentCutIn', 0, 0.5, "circout");
			playAnim('torrentCutIn', 'idle', true);
		end
		if curStep == 1054 then -- You can remove this. Thought it looked cool
			--In hindsight, this is kinda stupid.
			doTweenY('torrentCutInScaleY', 'torrentCutIn.scale', 3, 0.3, "circout");
			doTweenX('torrentCutInScaleX', 'torrentCutIn.scale', 3, 0.3, "circout");
			doTweenX('torrentCutInX', 'torrentCutIn', 500, 0.3, "circout");
		end
		if curStep == 1056 then
			if shadersEnabled then removeSpriteShader('cutinBG'); end
			setProperty('cutinBG.alpha', 0.0001);
			doTweenX('cutinBG', 'cutinBG2', -1280, 0.3, "circout");
			setProperty('torrentCutIn.alpha', 0.0001);
			setProperty('white.alpha', 1);
			doTweenAlpha('white', 'white', 0, 0.7);
		end
		if curStep == 1064 then
			callOnLuas('getJammed', {})
		end
		if curStep == 1168 then
			setProperty('isCameraOnForcedPos', false);
			setProperty('defaultCamZoom', 0.75);
		end
		if curStep == 1184 then
			setProperty('isCameraOnForcedPos', true);
			setProperty('camFollow.x', 350);
			setProperty('camFollow.y', 400);
			setProperty('defaultCamZoom', 0.5);
		end
		if curStep == 1312 then
			setProperty('isCameraOnForcedPos', false);
			setProperty('defaultCamZoom', 0.6);
		end
		if curStep == 1424 then
			setProperty('isCameraOnForcedPos', true);
			setProperty('camFollow.x', 350);
			setProperty('camFollow.y', 400);
			setProperty('defaultCamZoom', 0.5);
		end
		if curStep == 1440 then
			setProperty('isCameraOnForcedPos', false);
			setProperty('defaultCamZoom', 0.6);
		end
		if curStep == 1583 then
			setProperty('isCameraOnForcedPos', true);
			setProperty('camFollow.x', 350);
			setProperty('camFollow.y', 400);
			setProperty('defaultCamZoom', 0.5);
		end
	end
end

function onBeatHit()
	if curBeat % 2 == 0 then
		--BG folk
	end
end

function onTimerCompleted(tag,loops,left)
	if cutsceneCallbacks[tag] then cutsceneCallbacks[tag]() end
end