function onCreate()
	posX = -0;
	posY = -0;
	scale = 1;

	makeLuaSprite('swing', 'enzync/swingbg', -900, -500);
	setScrollFactor('swing', 0.3, 0.3);
	scaleObject('swing', 1.1, 1.1);
	addLuaSprite('swing', false);
	setProperty('swing.alpha', 0.0001);
	
	makeLuaSprite('swing2', 'enzync/buildingsswing', -900, -500);
	setScrollFactor('swing2', 0.7, 0.7);
	scaleObject('swing2', 1.1, 1.1);
	addLuaSprite('swing2', false);
	setProperty('swing2.alpha', 0.0001);
	
	makeLuaSprite('swing3', 'enzync/foregroundswing', -900, -500);
	setScrollFactor('swing3', 1, 1);
	scaleObject('swing3', 1.1, 1.1);
	addLuaSprite('swing3', false);
	setProperty('swing3.alpha', 0.0001);

	makeAnimatedLuaSprite('leftcrowd', 'enzync/leftcrowd', -430, 275);
	addAnimationByPrefix('leftcrowd', 'idle', 'LeftCrowd', 24, false);
	playAnim('leftcrowd', 'idle');
	finishAnim('leftcrowd');
	addLuaSprite('leftcrowd', false);
	scaleObject('leftcrowd', 0.8, 0.8);
	setProperty('leftcrowd.alpha', 0.0001);
	
	makeAnimatedLuaSprite('rightcrowd', 'enzync/rightcrowd', 910, 110);
	addAnimationByPrefix('rightcrowd', 'idle', 'RightCrowd', 24, false);
	playAnim('rightcrowd', 'idle');
	finishAnim('rightcrowd');
	addLuaSprite('rightcrowd', false);
	scaleObject('rightcrowd', 0.8, 0.8);
	setProperty('rightcrowd.alpha', 0.0001);

	makeLuaSprite('cutbg', 'enzync/cutscenebg', 0, 0);
	setScrollFactor('cutbg', 0, 0);
	scaleObject('cutbg', scale, scale);
	addLuaSprite('cutbg', false);
	setObjectCamera('cutbg', 'effect')
	setProperty('cutbg.alpha', 0.0001);

	makeAnimatedLuaSprite('cutscenecool', 'enzync/cutscene', posX, posY);
	addAnimationByPrefix('cutscenecool', 'idle', 'Cutscene', 24, false);
	setScrollFactor('cutscenecool', 0, 0);
	addLuaSprite('cutscenecool', false);
    screenCenter('cutscenecool');
	setObjectCamera('cutscenecool', 'effect')
	setProperty('cutscenecool.alpha', 0.0001);

	makeLuaSprite('fade', 'enzync/bgfade', 0, 1060);
	setScrollFactor('fade', 0, 0);
	scaleObject('fade', scale, scale);
	addLuaSprite('fade', false);
	setObjectCamera('fade', 'effect')

end

function onCreatePost()
	makeLuaSprite('whitehueh', 'dreamcast/art_BG/whitehueh', 0, 0);
	setScrollFactor('whitehueh', 0, 0);
	addLuaSprite('whitehueh', true);
	setObjectCamera('whitehueh', 'effect');
	setProperty('whitehueh.alpha', 0.0001);

	makeLuaSprite('46', 'dreamcast/art_BG/46', 0, 0);
	setScrollFactor('46', 0, 0);
	addLuaSprite('46', true);
	setObjectCamera('46', 'effect');
	setProperty('46.alpha', 0.0001);
	
	makeLuaSprite('47', 'dreamcast/art_BG/47', 0, 0);
	setScrollFactor('47', 0, 0);
	addLuaSprite('47', true);
	setObjectCamera('47', 'effect');
	setProperty('47.alpha', 0.0001);
	

end

function onStepHit()

	if curStep >= 490 and curStep <= 511 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 310);
		setProperty('camFollow.x', 390);
	end
	if curStep == 512 then
		setProperty('isCameraOnForcedPos', false);
	end
	
	if curStep >= 1024 and curStep <= 1154 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 350);
		setProperty('camFollow.x', 710);
	end
	if curStep == 870 then
		doTweenY('fade', 'fade', -1060, 1);
	end
	if curStep == 874 then
		setProperty('cutbg.alpha', 1);
		setProperty('swing.alpha', 1);
		setProperty('swing2.alpha', 1);
		setProperty('swing3.alpha', 1);
	end	
	if curStep == 878 then
		runTimer('cutscenetime', 0.2);
	end
	if curStep == 880 then
		setProperty('cutscenecool.alpha', 1);
	end
	if curStep == 912 then
		setProperty('cutbg.alpha', 0.0001);
		setProperty('cutscenecool.alpha', 0.0001);
		setProperty('leftcrowd.alpha', 1);
		setProperty('rightcrowd.alpha', 1);
		setProperty('backbops.alpha', 0.0001);
		setProperty('backbops2.alpha', 0.0001);
		setProperty('saff.alpha', 0.0001);
	end
	if curStep == 1155 then -- fade to white
		setProperty('isCameraOnForcedPos', false);
		doTweenAlpha('camHUD', 'camHUD', 0, 1);
		doTweenAlpha('whitehueh', 'whitehueh', 1, 1);
	end 
	if curStep == 1165 then -- fade to colored image
		doTweenAlpha('46', '46', 1, 1);
	end
	if curStep == 1185 then -- fade to colored image
		doTweenAlpha('47', '47', 1, 1);
	end
end

function onBeatHit()
	if curBeat % 2 == 0 then
		playAnim('leftcrowd', 'idle');
		playAnim('rightcrowd', 'idle');
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'cutscenetime' then
		playAnim('cutscenecool', 'idle');
	end
end