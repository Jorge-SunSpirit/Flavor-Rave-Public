function onCreate()
	posX = -0;
	posY = -0;
	scale = 1;

	makeLuaSprite('black', '', -100, -100);
	makeGraphic('black', 1280*2, 720*2, '000000');
	setScrollFactor('black', 0, 0);
	screenCenter('black');
	setProperty('black.alpha', 0.0001);
	addLuaSprite('black', false);

	setProperty('contest1.alpha', 1);
	setProperty('contest2.alpha', 1);
	setProperty('contest3.alpha', 1);

	setProperty('barTop.y', 0)
	setProperty('barBottom.y', 628)

	makeLuaSprite('dramablack', '', -100, -100);
    makeGraphic('dramablack', 1280*2, 720*2, '000000');
    setScrollFactor('dramablack', 0, 0);
    screenCenter('dramablack');
    addLuaSprite('dramablack', true);

	makeLuaSprite('paper', 'togarashi/intropaper', posX, posY);
	setScrollFactor('paper', 0, 0);
	scaleObject('paper', 1.62, 1.62);
	addLuaSprite('paper', false);
    screenCenter('paper');

	makeLuaSprite('dramashadow', 'togarashi/backshadow', -1200, -700);
	setScrollFactor('dramashadow', 1, 1);
	scaleObject('dramashadow', 1.5, 1.5);
	addLuaSprite('dramashadow', false);
	setProperty('dramashadow.alpha', 0.0001);

	makeAnimatedLuaSprite('smokeTop', 'backstreet/smokebordertop', -75, -302);
	addAnimationByPrefix('smokeTop', 'idle', 'BorderSmokyBottom', 24, true);
	setScrollFactor('smokeTop', 0, 0);
	scaleObject('smokeTop', 1, 1);
	addLuaSprite('smokeTop', false);
	setObjectCamera('smokeTop', 'effect');

	makeAnimatedLuaSprite('smokeBottom', 'backstreet/smokeborderbottom', -75, 722);
	addAnimationByPrefix('smokeBottom', 'idle', 'BorderSmokyBottom', 24, true);
	setScrollFactor('smokeBottom', 0, 0);
	scaleObject('smokeBottom', 1, 1);
	addLuaSprite('smokeBottom', false);
	setObjectCamera('smokeBottom', 'effect');
	
	makeLuaSprite('text1', 'togarashi/introtext3', 195, 300);
	setScrollFactor('text1', 0, 0);
	addLuaSprite('text1', true);
	setProperty('text1.alpha', 0.0001);
	
	makeLuaSprite('text2', 'togarashi/introtext4', 200, 370);
	setScrollFactor('text2', 0, 0);
	addLuaSprite('text2', true);
	setProperty('text2.alpha', 0.0001);
	
	makeLuaSprite('vin', 'togarashi/burnvin', posX, posY);
	setScrollFactor('vin', 0, 0);
	scaleObject('vin', 1.5, 1.5);
	addLuaSprite('vin', false);
    screenCenter('vin');
	setProperty('vin.alpha', 0.0001);
	
	setProperty('isCameraOnForcedPos', true);
	setProperty('camFollow.x', 750);
	setProperty('camFollow.y', 370);
	setProperty('camera.target.y', 0);
	
	setProperty('dad.color', 0x00000000);
	setProperty('boyfriend.color', 0x00000000);
	
	setProperty('boyfriend.alpha', 0);
	setProperty('dad.alpha', 0);
	
    makeLuaSprite('white', '', -100, -100);
    makeGraphic('white', 2560, 1440, 'FFFFFF');
    setScrollFactor('white', 0, 0);
    screenCenter('white');
    addLuaSprite('white', true);
	setProperty('white.alpha', 0.0001);
	
end

function thingie(num)
	num = tonumber(num)
	if num == 10 then
		doTweenAlpha('dramablack', 'dramablack', 0, 3);
	end
	if num == 24 then
		doTweenAlpha('text1', 'text1', 1, 2);
	end
	if num == 52 then
		doTweenAlpha('text2', 'text2', 1, 2);
		doTweenY('barTop', 'barTop', -102, 2, "circinout");
		doTweenY('barBottom', 'barBottom', 822, 2, "circinout");
	end
	if num == 58 then
		doTweenAlpha('boyfriend', 'boyfriend', 1, 1.4);
		doTweenAlpha('dad', 'dad', 1, 1.4);
	end
	if num == 80 then
		setProperty('boyfriend.color', 0xFFFFFF);
		setProperty('dad.color', 0xFFFFFF);
		setProperty('text1.alpha', 0.0001);
		setProperty('text2.alpha', 0.0001);
		setProperty('paper.alpha', 0.0001);
	end
	if num == 112 then
		setProperty('isCameraOnForcedPos', false);
		removeLuaSprite('text1');
		removeLuaSprite('text2');
	end
	if num == 1168 then
		doTweenAlpha('dramablack', 'dramablack', 1, 0.4);
	end
	if num == 1174 then
		setProperty('black.alpha', 1);
		runHaxeCode('game.boyfriend.setColorTransform(1, 1, 1, 1, 255, 255, 255, 0);')
		runHaxeCode('game.dad.setColorTransform(1, 1, 1, 1, 255, 255, 255, 0);')
		setProperty('dad.alpha', 0);
	end
	if num == 1176 then
		doTweenAlpha('dramablack', 'dramablack', 0.0001, 3);
	end
	if num == 1236 then
		doTweenAlpha('dad', 'dad', 1, 2);
	end
	if num == 1296 then
		setProperty('black.alpha', 0.0001);
		runHaxeCode('game.boyfriend.setColorTransform(1, 1, 1, 1, 0, 0, 0, 0);')
		runHaxeCode('game.dad.setColorTransform(1, 1, 1, 1, 0, 0, 0, 0);')
		setProperty('dramashadow.alpha', 1);
		doTweenY('smokeTop', 'smokeTop', -100, 1, "circinout");
		doTweenY('smokeBottom', 'smokeBottom', 528, 1, "circinout");
	end
	if num == 1424 then
		doTweenY('smokeTop', 'smokeTop', -302, 1.6, "circinout");
		doTweenY('smokeBottom', 'smokeBottom', 722, 1.6, "circinout");
		doTweenAlpha('vin', 'vin', 0.4, 3);
	end
	if num == 1520 then
		doTweenAlpha('white', 'white', 1, 2);
	end
	if num == 1552 then
		setProperty('white.alpha', 0.0001);
		setProperty('borderfire.alpha', 1);
		setProperty('fireback.alpha', 1);
		setProperty('boyfriendGroup.x', 1000)
		setProperty('boyfriendGroup.y', 200)
		setProperty('dadGroup.x', -100)
		setObjectOrder('dadGroup', getObjectOrder('boyfriendGroup')+1);
		setProperty('dramashadow.alpha', 0.0001);
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.x', 781);
		setProperty('camFollow.y', 394);
		setProperty('camera.target.x', 781);
		setProperty('camera.target.y', 394);
		setProperty('defaultCamZoom', 1);
	end
	if num == 1808 then
		goku = true
		setProperty('white.alpha', 1);
		setProperty('fireback.alpha', 0.001);
		doTweenAlpha('white', 'white', 0.001, 0.5);
		setProperty('black.alpha', 0.5);
		setProperty('boyfriendGroup.x', 550)
		setProperty('boyfriendGroup.y', -70)
		setProperty('dadGroup.x', 330)
		setProperty('dadGroup.y', 105)
	end
	if num == 1936 then
		doTweenAlpha('borderfire', 'borderfire', 0, 3);
	end
end

function onBeatHit()
	if curBeat % 2 == 0 then
		playAnim('contest1', 'idle');
		playAnim('contest2', 'idle');
		playAnim('contest3', 'idle');
	end
end

function onMoveCamera(focus)
	if goku then
		if focus == 'dad' then
			setProperty('camFollow.x', 763);
			setProperty('camFollow.y', 458);
		else
			setProperty('camFollow.x', 763);
			setProperty('camFollow.y', 146);
		end
	end
end