local cameraType = 0;

function onCreate()
	posX = -0;
	posY = -0;
	scale = 1;

	setProperty('barTop.y', 0)
	setProperty('barBottom.y', 628)

	makeLuaSprite('dramablack', '', -100, -100);
    makeGraphic('dramablack', 1280*2, 720*2, '000000');
    setScrollFactor('dramablack', 0, 0);
    screenCenter('dramablack');
    addLuaSprite('dramablack', true);

	makeAnimatedLuaSprite('paperburn', 'togarashi/intropaperburn', posX, posY);
	addAnimationByPrefix('paperburn', 'idle', 'PaperBurn', 24, false);
	playAnim('paperburn', 'idle');
	finishAnim('paperburn');
	setScrollFactor('paperburn', 0, 0);
	scaleObject('paperburn', 1.4, 1.4);
	addLuaSprite('paperburn', false);
    screenCenter('paperburn');

	makeLuaSprite('paper', 'togarashi/intropaper', posX, posY);
	setScrollFactor('paper', 0, 0);
	scaleObject('paper', 1.62, 1.62);
	addLuaSprite('paper', false);
    screenCenter('paper');
	
	makeAnimatedLuaSprite('ink', 'togarashi/inkreveal', posX, posY);
	addAnimationByPrefix('ink', 'idle', 'InkReveal', 24, false);
	playAnim('ink', 'idle');
	finishAnim('ink');
	setScrollFactor('ink', 0, 0);
	scaleObject('ink', 1.62, 1.62);
	addLuaSprite('ink', false);
    screenCenter('ink');
	setProperty('ink.alpha', 0.0001);
	
	makeLuaSprite('dramashadow', 'togarashi/backshadow', -1200, -700);
	setScrollFactor('dramashadow', 1, 1);
	scaleObject('dramashadow', 1.5, 1.5);
	addLuaSprite('dramashadow', false);
	setProperty('dramashadow.alpha', 0.0001);
	
	makeLuaSprite('text1', 'togarashi/introtext1', 195, 300);
	setScrollFactor('text1', 0, 0);
	addLuaSprite('text1', false);
	setProperty('text1.alpha', 0.0001);
	
	makeLuaSprite('text2', 'togarashi/introtext2', 322, 370);
	setScrollFactor('text2', 0, 0);
	addLuaSprite('text2', false);
	setProperty('text2.alpha', 0.0001);

	makeAnimatedLuaSprite('strum', 'closeup/CoolStrum', posX, posY);
	addAnimationByPrefix('strum', 'idle', 'CoolStrum', 30, false);
	setScrollFactor('strum', 0, 0);
    screenCenter('strum');
	addLuaSprite('strum', false);
	setProperty('strum.alpha', 0.0001);
	
	makeLuaSprite('dramawhite', '', -100, -100);
    makeGraphic('dramawhite', 1280*2, 720*2, 'FFFFFF');
    setScrollFactor('dramawhite', 0, 0);
    screenCenter('dramawhite');
	setProperty('dramawhite.alpha', 0.0001);
    addLuaSprite('dramawhite', true);
	
	makeLuaSprite('vin', 'togarashi/burnvin', posX, posY);
	setScrollFactor('vin', 0, 0);
	scaleObject('vin', 1.35, 1.35);
	addLuaSprite('vin', false);
    screenCenter('vin');
	setProperty('vin.alpha', 0.0001);
	
	setProperty('isCameraOnForcedPos', true);
	setProperty('camFollow.x', 700);
	setProperty('camFollow.y', -650);
	setProperty('camera.target.y', 0)
	doTweenY('moveCam', 'camFollow', -1110, 0.1);
end

function onCreatePost()
	setObjectCamera('extraGroup', 'effect');
	setObjectCamera('gfGroup', 'effect');
	setProperty('gfGroup.x', -1000)
	setProperty('gfGroup.y', 0)
	setProperty('extraGroup.x', 1280)
	setProperty('extraGroup.y', 0)
	setProperty('gf.missRecolor', false)
	setProperty('extraChar.missRecolor', false)
	setScrollFactor('extraGroup', 0, 0);
	setObjectOrder('extraGroup', getObjectOrder('strum')+1);
	setScrollFactor('gfGroup', 0, 0);
	setObjectOrder('gfGroup', getObjectOrder('strum')+1);
	
	setObjectCamera('fireback', 'effect');

end

function thingie(num)
	num = tonumber(num)
	if num == 10 then
		doTweenAlpha('dramablack', 'dramablack', 0, 3);
	end
	if num == 35 then
		doTweenAlpha('text1', 'text1', 1, 2);
	end
	if num == 60 then
		runTimer('inkstart', 0.2);
	end
	if num == 64 then
		doTweenY('barTop', 'barTop', -102, 2, "circinout");
		doTweenY('barBottom', 'barBottom', 822, 2, "circinout");
		doTweenAlpha('ink', 'ink', 1, 0.3);
	end
	if num == 94 then
		doTweenAlpha('text2', 'text2', 1, 2);
	end
	if num == 124 then
		runTimer('papergone', 0.2);
	end
	if num == 131 then
		doTweenAlpha('paper', 'paper', 0, 0.2);
		doTweenAlpha('ink', 'ink', 0, 0.2);
		doTweenAlpha('text1', 'text1', 0, 0.5);
		doTweenAlpha('text2', 'text2', 0, 0.5);
	end
	if num == 145 then
		removeLuaSprite('text1');
		doTweenAlpha('paperburn', 'paperburn', 0, 0.4);
	end
	if num == 180 then
		doTweenY('moveCam', 'camFollow', 350, 5);
	end
	if num == 255 then
		setProperty('isCameraOnForcedPos', false);
	end
	if num == 800 then
		doTweenAlpha('dramashadow', 'dramashadow', 0.7, 3);
		doTweenY('barTop', 'barTop', 0, 0.5, "circinout");
		doTweenY('barBottom', 'barBottom', 628, 0.5, "circinout");
	end
	if num == 1018 then
		runTimer('strumstart', 0.2);
	end
	if num == 1024 then
		doTweenAlpha('strum', 'strum', 1, 0.2, "circinout");
	end
	if num == 1050 then
		doTweenAlpha('dramawhite', 'dramawhite', 1, 0.25);
	end
	if num == 1056 then
		cameraType = 1
		setProperty('dramawhite.alpha', 0.0001);
		setProperty('strum.alpha', 0.0001);
		setProperty('fireback.alpha', 1);
		setProperty('vin.alpha', 1);
		doTweenY('barTop', 'barTop', -102, 0.25, "circinout");
		doTweenY('barBottom', 'barBottom', 822, 0.25, "circinout");
	end
	if num == 1568 then
		cameraType = 3
		setProperty('dramablack.alpha', 1);
		doTweenAlpha('fireback', 'fireback', 0.00001, 2);
		doTweenAlpha('vin', 'vin', 0, 1.5);
	end
	if num == 1619 then
		setProperty('dramashadow.alpha', 1);
		doTweenAlpha('dramablack', 'dramablack', 0, 1);
	end
	if num == 1823 then
		doTweenAlpha('vin', 'vin', 0.3, 3);
	end
	if num == 2080 then
		cameraType = 1
		setProperty('fireback.alpha', 1);
		setProperty('vin.alpha', 1);
		setProperty('dramashadow.alpha', 0);
	end
	if num == 2528 then
		cameraType = 2
	end
	if num == 2592 then
		cameraType = 3
		doTweenAlpha('fireback', 'fireback', 0, 2);
		doTweenAlpha('vin', 'vin', 0, 2);
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'papergone' then
		playAnim('paperburn', 'idle');
	end
	if tag == 'inkstart' then
		playAnim('ink', 'idle');
	end
	if tag == 'strumstart' then
		playAnim('strum', 'idle');
	end
end

local charFocus = -1

function onMoveCamera(focus)
	if cameraType == 1 then
		if focus == 'extra' or focus == 'boyfriend' then
			if charFocus ~= 1 then
				charFocus = 1
				doTweenColor('gfC', 'gf', '808080', 0.5, 'quadout');
				doTweenX('gfX', 'gfGroup', -325, 0.5, 'quadout');
				doTweenY('gfY', 'gfGroup', 20, 0.5, 'quadout');
				doTweenColor('extraC', 'extraChar', 'ffffff', 0.5, 'quadout');
				doTweenX('extraX', 'extraGroup', 750, 0.5, 'quadout');
				doTweenY('extraY', 'extraGroup', 0, 0.5, 'quadout');
			end
		elseif focus == 'gf' or focus == 'dad' then
			if charFocus ~= 0 then
				charFocus = 0
				doTweenColor('gfC', 'gf', 'ffffff', 0.5, 'quadout');
				doTweenX('gfX', 'gfGroup', -275, 0.5, 'quadout');
				doTweenY('gfY', 'gfGroup', 0, 0.5, 'quadout');
				doTweenColor('extraC', 'extraChar', '808080', 0.5, 'quadout');
				doTweenX('extraX', 'extraGroup', 800, 0.5, 'quadout');
				doTweenY('extraY', 'extraGroup', 20, 0.5, 'quadout');
			end
		end
	end
	if cameraType == 2 then --Them together
		if charFocus ~= 2 then
			charFocus = 2
			doTweenColor('gfC', 'gf', 'ffffff', 0.5, 'quadout');
			doTweenX('gfX', 'gfGroup', -275, 0.5, 'quadout');
			doTweenY('gfY', 'gfGroup', 0, 0.5, 'quadout');
			doTweenColor('extraC', 'extraChar', 'ffffff', 0.5, 'quadout');
			doTweenX('extraX', 'extraGroup', 750, 0.5, 'quadout');
			doTweenY('extraY', 'extraGroup', 0, 0.5, 'quadout');
		end
	end
	if cameraType == 3 then --This is just hiding them just incase
		if charFocus ~= 3 then
			charFocus = 3
			doTweenColor('gfC', 'gf', 'ffffff', 0.5, 'quadout');
			doTweenX('gfX', 'gfGroup', -1000, 0.5, 'quadout');
			doTweenY('gfY', 'gfGroup', 0, 0.5, 'quadout');
			doTweenColor('extraC', 'extraChar', 'ffffff', 0.5, 'quadout');
			doTweenX('extraX', 'extraGroup', 1380, 0.5, 'quadout');
			doTweenY('extraY', 'extraGroup', 0, 0.5, 'quadout');
		end
	end
end