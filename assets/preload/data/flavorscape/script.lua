goku = false

function onCreate()

	setProperty('dadGroup.x', getProperty('DAD_X')-250)
	setProperty('dadGroup.y', getProperty('DAD_Y')+35)
	setProperty('boyfriendGroup.x', getProperty('BF_X')+180)
	setProperty('boyfriendGroup.y', getProperty('BF_Y')+35)

	makeLuaSprite('dramablack', '', -100, -100);
    makeGraphic('dramablack', 1280*2, 720*2, '000000');
    setScrollFactor('dramablack', 0, 0);
    screenCenter('dramablack');
    addLuaSprite('dramablack', false);
	setProperty('dramablack.alpha', 0.0001);
	
	makeAnimatedLuaSprite('Rave', 'closeup/RAVE-BG', -0, -60);
	addAnimationByPrefix('Rave', 'idle', 'RaveBG', 42, true);
	setScrollFactor('Rave', 0, 0);
	addLuaSprite('Rave', false);
	scaleObject('Rave', 1.5, 1.5);
    screenCenter('Rave');
	setProperty('Rave.alpha', 0.0001);

	makeLuaSprite('fsbg', 'flavorscape/RaveBG', 0, 0);
	setScrollFactor('fsbg', 0, 0);
	scaleObject('fsbg',1.5, 1.5);
	addLuaSprite('fsbg', false);
	screenCenter('fsbg');
	setProperty('fsbg.alpha', 0.0001);
	
	
	runHaxeCode([[
		var stars:FlxBackdrop = new FlxBackdrop(Paths.image('flavorscape/stars'), 0x11);
		stars.antialiasing = ClientPrefs.globalAntialiasing;
		game.insert(game.members.indexOf(game.getLuaObject('fsbg')) + 1, stars);
		setVar('stars', stars);
	]]);
	setScrollFactor('stars', 0.2, 0.2);
	setBlendMode('stars', 'add');
	setProperty('stars.velocity.x', -20);
	setProperty('stars.velocity.y', -20);
	setProperty('stars.alpha', 0.0001);

	makeAnimatedLuaSprite('rift', 'flavorscape/rift', -500, -300);
	addAnimationByPrefix('rift', 'idle', 'Rift', 30, true);
	setScrollFactor('rift', 0.9, 0.9);
	addLuaSprite('rift', false);
	scaleObject('rift', 2, 2);
	setBlendMode('rift', 'add');
	setProperty('rift.alpha', 0.0001);

	makeAnimatedLuaSprite('firebg', 'closeup/FireBG', -200, -40);
	addAnimationByPrefix('firebg', 'idle', 'FireBG', 30, true);
	setScrollFactor('firebg', 0.5, 0.5);
	addLuaSprite('firebg', false);
	scaleObject('firebg', 1.4, 1.4);
	setBlendMode('firebg', 'add');
	setProperty('firebg.alpha', 0.0001);
	
	makeAnimatedLuaSprite('spicyIntro', 'characters/Spicy-RAVE-intro', 250, 150);
	addAnimationByIndices('spicyIntro', 'froze', 'SpicyRaveIntro', "0", 24);
	addAnimationByPrefix('spicyIntro', 'idle', 'SpicyRaveIntro', 24, false);
	setScrollFactor('spicyIntro', 1, 1);
	addLuaSprite('spicyIntro', false);
	scaleObject('spicyIntro', 0.9, 0.9);
	setProperty('spicyIntro.alpha', 0.0001);

	makeLuaSprite('ravevin', 'closeup/raveglow', 0, 0);
	setScrollFactor('ravevin', 0, 0);
	addLuaSprite('ravevin', false);
	setObjectCamera('ravevin', 'effect');
	setProperty('ravevin.alpha', 0.0001);

    makeLuaSprite('white', '', -100, -100);
    makeGraphic('white', 2560, 1440, 'FFFFFF');
    setScrollFactor('white', 0, 0);
    screenCenter('white');
    addLuaSprite('white', true);
	setProperty('white.alpha', 0.0001);

	makeAnimatedLuaSprite('trans', 'backstreet/transition', posX, posY);
	addAnimationByPrefix('trans', 'idle', 'SmokeTrans', 24, false);
	playAnim('trans', 'idle');
	finishAnim('trans');
	setScrollFactor('trans', 0, 0);
	scaleObject('trans', 1.2, 1.2);
	addLuaSprite('trans', false);
    screenCenter('trans');
	setObjectCamera('trans', 'effect');
	setProperty('trans.alpha', 0.0001);
	
	makeLuaSprite('allBG', 'closeup/AllBG', 0, 0);
	setScrollFactor('allBG', 0, 0);
	--setObjectCamera('allBG', 'effect');
	addLuaSprite('allBG', true);
	screenCenter('allBG');
	setProperty('allBG.alpha', 0.0001);
	
	makeLuaSprite('spicy', 'closeup/finale/spicy', 152, 1280);
	setScrollFactor('spicy', 0, 0);
	--setObjectCamera('spicy', 'effect');
	addLuaSprite('spicy', true);
	setProperty('spicy.alpha', 0.0001);
	setProperty('spicy.color', 0x00000000);
	
	makeLuaSprite('smoky', 'closeup/finale/smoky', 92, 1280);
	setScrollFactor('smoky', 0, 0);
	--setObjectCamera('smoky', 'effect');
	addLuaSprite('smoky', true);
	setProperty('smoky.alpha', 0.0001);
	setProperty('smoky.color', 0x00000000);
	
	makeLuaSprite('sweet', 'closeup/finale/sweet', 240, 1280);
	setScrollFactor('sweet', 0, 0);
	--setObjectCamera('sweet', 'effect');
	addLuaSprite('sweet', true);
	setProperty('sweet.alpha', 0.0001);
	setProperty('sweet.color', 0x00000000);
	
	makeLuaSprite('sour', 'closeup/finale/sour', -20, 1280);
	setScrollFactor('sour', 0, 0);
	-- setObjectCamera('sour', 'effect');
	addLuaSprite('sour', true);
	setProperty('sour.alpha', 0.0001);
	setProperty('sour.color', 0x00000000);
	
	
end

function onCreatePost()
	initLuaShader('glitch');
	addCharacterToList('sour-back-RAVE', 'extra');
	addCharacterToList('sweet-back-RAVE', 'bf');
	addCharacterToList('sour-RAVE', 'extra');
	addCharacterToList('sweet-RAVE', 'bf');
	
	setProperty('ratingCharNote', true);
	setProperty('healthCharNote', true);
	setProperty('noteSkinCharNote', true);
end

function funnyStep(thingie)
	if thingie == "962" then
		doTweenAlpha('ravevin', 'ravevin', 1, 2.4);
	end
	if thingie == "1024" then
		doTweenAlpha('ravevin', 'ravevin', 0.001, 0.001);
		setProperty('gf.alpha', 0);
		setProperty('dad.alpha', 0);
		setProperty('Rave.alpha', 1);
	end
	if thingie == "1202" then
		runTimer('smokintime', 0.2);
		doTweenAlpha('trans', 'trans', 1, 0.2);
	end
	if thingie == "1212" then
		setProperty('spicyIntro.alpha', 1);
		playAnim('spicyIntro', 'froze');
		setProperty('dramablack.alpha', 0.6);
		setProperty('dadGroup.x', 330)
		setProperty('dadGroup.y', 105)
		setProperty('gfGroup.x', 450)
		setProperty('gfGroup.y', -70)
		setProperty('Rave.alpha', 0.0001);
		
		--Janky :D
		triggerEvent('Change Character','extra','sour-back-RAVE');
		triggerEvent('Change Character','bf','sweet-back-RAVE');
		setProperty('boyfriendGroup.x', -175)
		setProperty('boyfriendGroup.y', 230)
		setProperty('extraGroup.x', 1225)
		setProperty('extraGroup.y', 170)
		setObjectOrder('extraGroup', getObjectOrder('dadGroup')+1);
		setScrollFactor('boyfriendGroup', 1.1, 1.1);
		setScrollFactor('extraGroup', 1.1, 1.1);
		scaleObject('boyfriend', 1.5, 1.5);
		scaleObject('extraChar', 1.5, 1.5);
		setProperty('isCameraOnForcedPos', true);
		goku = true
	end
	if thingie == "1240" then
		goku = false
		doTweenY('barTop', 'barTop', 0, 1, "circinout");
		doTweenY('barBottom', 'barBottom', 628, 1, "circinout");
		setProperty('camFollow.x', 763);
		setProperty('camFollow.y', 458);
		setProperty('defaultCamZoom', 1);
		doTweenAlpha('boyfriend', 'boyfriend', 0.7, 0.5, 'circout')
		doTweenAlpha('extraChar', 'extraChar', 0.7, 0.5, 'circout')
	end
	if thingie == "1248" then
		playAnim('spicyIntro', 'idle', true);
	end
	if thingie == "1272" then
		doTweenAlpha('white', 'white', 1, 0.3)
	end
	if thingie == "1280" then
		setProperty('gays.color', 0x00000000);
		setProperty('gays2.color', 0x00000000);
		setProperty('firebg.alpha', 0.8);
		doTweenAlpha('white', 'white', 0.0001, 0.001)
		setProperty('dad.alpha', 1);
		setProperty('spicyIntro.alpha', 0.0001);
		goku = true
	end
	if thingie == "1344" then
		doTweenAlpha('gf', 'gf', 1, 2);
	end
	if thingie == "2048" then
		setProperty('fsbg.alpha', 1);
		setProperty('stars.alpha', 1);
		setProperty('rift.alpha', 1);
		setProperty('firebg.alpha', 0);
		doTweenY('barTop', 'barTop', -102, 0.4, "circinout");
		doTweenY('barBottom', 'barBottom', 822, 0.4, "circinout");
	end
	if thingie == "2271" then
		goku = false
		setProperty('camFollow.x', 781);
		setProperty('camFollow.y', 394);
		doTweenAlpha('boyfriend', 'boyfriend', 1, 0.1, 'circout')
		doTweenAlpha('extraChar', 'extraChar', 1, 0.1, 'circout')
	end
	if thingie == "2304" then
		setProperty('white.alpha', 1);
		doTweenAlpha('white', 'white', 0.001, 0.3)
		setProperty('boyfriendGroup.x', 1050)
		setProperty('boyfriendGroup.y', 0)
		setProperty('extraGroup.x', 1125)
		setObjectOrder('extraGroup', getObjectOrder('boyfriendGroup')+1);
		
		setProperty('dadGroup.x', -175)
		setProperty('dadGroup.y', 175)
		setProperty('gfGroup.x', -50)
		setProperty('gfGroup.y', -0)
	end
	if thingie == "2816" then
		setProperty('dadGroup.x', 330)
		setProperty('dadGroup.y', 105)
		setProperty('gfGroup.x', 450)
		setProperty('gfGroup.y', -70)
		setProperty('boyfriendGroup.x', -175)
		setProperty('boyfriendGroup.y', 230)
		setProperty('extraGroup.x', 1225)
		setProperty('extraGroup.y', 170)
		
		triggerEvent('Change Character','extra','sour-back-RAVE');
		triggerEvent('Change Character','bf','sweet-back-RAVE');
		setScrollFactor('boyfriendGroup', 1.1, 1.1);
		setScrollFactor('extraGroup', 1.1, 1.1);
		scaleObject('boyfriend', 1.5, 1.5);
		scaleObject('extraChar', 1.5, 1.5);
		goku = true
		setProperty('fsbg.alpha', 0);
		setProperty('stars.alpha', 0);
		setProperty('rift.alpha', 0);
	end
	
	if thingie == "3206" then
		goku = false
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.x', 763);
		setProperty('defaultCamZoom', 1);
		doTweenY('moveCam', 'camFollow', -1110, 4, "circin");
	end
	if thingie == "3232" then
		doTweenAlpha('white', 'white', 1, 1)
	end
	if thingie == "3264" then
		doTweenY('spicy', 'spicy', 0, 0.2, 'circout')
		setProperty('spicy.alpha', 1);
	end
	if thingie == "3266" then
		doTweenY('smoky', 'smoky', 0, 0.2, 'circout')
		setProperty('smoky.alpha', 1);
	end
	if thingie == "3268" then
		doTweenY('sweet', 'sweet', 0, 0.2, 'circout')
		setProperty('sweet.alpha', 1);
	end
	if thingie == "3270" then
		doTweenY('sour', 'sour', 0, 0.2, 'circout')
		setProperty('sour.alpha', 1);
	end
	if thingie == "3272" then
		setProperty('allBG.alpha', 1);
		setProperty('spicy.color', 0xFFFFFF);
		setProperty('smoky.color', 0xFFFFFF);
		setProperty('sweet.color', 0xFFFFFF);
		setProperty('sour.color', 0xFFFFFF);
		doTweenAlpha('camHUD', 'camHUD', 0, 0.3, 'circout')
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'smokintime' then
		playAnim('trans', 'idle');
	end
end

function onMoveCamera(focus)
	if goku then
		if focus == 'gf' or focus == 'dad' then
			if focus == 'dad' then
				setProperty('camFollow.x', 763);
				setProperty('camFollow.y', 458);
			else
				setProperty('camFollow.x', 763);
				setProperty('camFollow.y', 146);
			end
			setProperty('defaultCamZoom', 1);
			doTweenAlpha('boyfriend', 'boyfriend', 0.7, 0.5, 'circout')
			doTweenAlpha('extraChar', 'extraChar', 0.7, 0.5, 'circout')
		elseif focus == 'extra' or focus == 'boyfriend' then
			if focus == 'boyfriend' then
				setProperty('camFollow.x', 612);
				setProperty('camFollow.y', 394);
			else
				setProperty('camFollow.x', 931);
				setProperty('camFollow.y', 394);
			end
			setProperty('defaultCamZoom', 0.8);
			doTweenAlpha('boyfriend', 'boyfriend', 1, 0.5, 'circout')
			doTweenAlpha('extraChar', 'extraChar', 1, 0.5, 'circout')
		end
	end
end