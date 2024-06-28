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

function onStepHit()

	if curStep == 10 then
		doTweenAlpha('dramablack', 'dramablack', 0, 3);
	end
	if curStep == 35 then
		doTweenAlpha('text1', 'text1', 1, 2);
	end
	if curStep == 60 then
		runTimer('inkstart', 0.2);
	end
	if curStep == 64 then
		doTweenY('barTop', 'barTop', -102, 2, "circinout");
		doTweenY('barBottom', 'barBottom', 822, 2, "circinout");
		doTweenAlpha('ink', 'ink', 1, 0.3);
	end
	if curStep == 94 then
		doTweenAlpha('text2', 'text2', 1, 2);
	end
	if curStep == 124 then
		runTimer('papergone', 0.2);
	end
	if curStep == 131 then
		doTweenAlpha('paper', 'paper', 0, 0.2);
		doTweenAlpha('ink', 'ink', 0, 0.2);
		doTweenAlpha('text1', 'text1', 0, 0.5);
		doTweenAlpha('text2', 'text2', 0, 0.5);
	end
	if curStep == 145 then
		removeLuaSprite('text1');
		doTweenAlpha('paperburn', 'paperburn', 0, 0.4);
	end
	if curStep == 180 then
		doTweenY('moveCam', 'camFollow', 350, 5);
	end
	if curStep == 255 then
		setProperty('isCameraOnForcedPos', false);
	end
	if curStep == 800 then
		doTweenY('barTop', 'barTop', 0, 0.5, "circinout");
		doTweenY('barBottom', 'barBottom', 628, 0.5, "circinout");
	end
	if curStep == 1056 then
		setProperty('borderfire.alpha', 1);
		setProperty('vin.alpha', 1);
		doTweenY('barTop', 'barTop', -102, 0.25, "circinout");
		doTweenY('barBottom', 'barBottom', 822, 0.25, "circinout");
	end
	if curStep == 1568 then
		doTweenAlpha('dramablack', 'dramablack', 1, 2);
		doTweenAlpha('borderfire', 'borderfire', 0, 2);
		doTweenAlpha('vin', 'vin', 0, 1.5);
	end
	if curStep == 1619 then
		setProperty('dramashadow.alpha', 1);
		doTweenAlpha('dramablack', 'dramablack', 0, 1);
	end
	if curStep == 1823 then
		doTweenAlpha('vin', 'vin', 0.3, 3);
	end
	if curStep == 2080 then
		setProperty('borderfire.alpha', 1);
		setProperty('vin.alpha', 1);
		setProperty('dramashadow.alpha', 0);
	end
	if curStep == 2592 then
		doTweenAlpha('borderfire', 'borderfire', 0, 3);
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
end