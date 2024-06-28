stageType = '0';
local pulsespeed = 2;
local pulseAlpha = 1;
local pulseDelay = 0.3;
local pulseEnabled = false;
local pulsed = false;
local stagePulse = false;
local songStarted = false;

function onCreate()
	addHaxeLibrary('FlxBackdrop', 'flixel.addons.display');

	--First secton
	posX = -500;
	posY = 0;
	scale = 0.8;
	
	makeLuaSprite('pcBG', 'sweetroom/computerbg', posX, posY);
	setScrollFactor('pcBG', 0.9, 0.9);
	scaleObject('pcBG', scale, scale);
	setProperty('pcBG.alpha', 0.001);

	makeAnimatedLuaSprite('introstatic', 'sweetroom/static', 0, posY);
	addAnimationByPrefix('introstatic', 'idle', 'static', 30, true);
	setScrollFactor('introstatic', 0.9, 0.9);
	playAnim('introstatic', 'idle');
	scaleObject('introstatic', 0.5, 0.5);

	makeLuaSprite('roomBG', 'sweetroom/MainBG', posX, posY);
	setScrollFactor('roomBG', 1, 1);
	scaleObject('roomBG', scale, scale);
	setProperty('roomBG.alpha', 0.001);
	setObjectOrder('roomBG', getObjectOrder('dadGroup')+1);
	
	setObjectOrder('extraGroup', getObjectOrder('dadGroup')+1);
	
	addLuaSprite('pcBG', false);
	addLuaSprite('introstatic', false);
	addLuaSprite('roomBG', false);
	
	--Second Section
	posX = -900;
	posY = -100;
	scale = 1.2;
	
	makeLuaSprite('bg', 'funktrix/nitro-sun1', posX, -500);
	setScrollFactor('bg', 0, 0);
	scaleObject('bg', scale, scale);
	
	makeLuaSprite('city', 'funktrix/nitro-city1', posX, posY);
	setScrollFactor('city', 0.1, 0.1);
	scaleObject('city', scale, scale);
	
	scale = 1.4;
	makeLuaSprite('platformNitro', 'funktrix/NitroPlat', 0, 0);
	scaleObject('platformNitro', scale, scale);
	setScrollFactor('platformNitro', 0.85, 0.85);
	
	makeLuaSprite('platformSweet', 'funktrix/SweetPlat', 0, 0);
	scaleObject('platformSweet', scale, scale);
	setScrollFactor('platformSweet', 0.85, 0.85);
	
	makeLuaSprite('platformTorrent', 'funktrix/TorrentPlat', 0, 0);
	scaleObject('platformTorrent', scale, scale);
	
	makeLuaSprite('platformSour', 'funktrix/SourPlat', 0, 0);
	scaleObject('platformSour', scale, scale);
	
	
	makeLuaSprite('platformglowNitro', 'funktrix/NitroPlatGlow', 0, 0);
	scaleObject('platformglowNitro', scale, scale);
	setScrollFactor('platformglowNitro', 0.85, 0.85);
	setProperty('platformglowNitro.alpha', 0.001);
	
	makeLuaSprite('platformglowSweet', 'funktrix/SweetPlatGlow', 0, 0);
	scaleObject('platformglowSweet', scale, scale);
	setScrollFactor('platformglowSweet', 0.85, 0.85);
	setProperty('platformglowSweet.alpha', 0.001);
	
	makeLuaSprite('platformglowTorrent', 'funktrix/TorrentPlatGlow', 0, 0);
	scaleObject('platformglowTorrent', scale, scale);
	setProperty('platformglowTorrent.alpha', 0.001);
	
	makeLuaSprite('platformglowSour', 'funktrix/SourPlatGlow', 0, 0);
	scaleObject('platformglowSour', scale, scale);
	setProperty('platformglowSour.alpha', 0.001);
	
	addLuaSprite('bg', false);
	addLuaSprite('city', false);
	addLuaSprite('platformNitro', false);
	addLuaSprite('platformSweet', false);
	addLuaSprite('platformTorrent', false);
	addLuaSprite('platformSour', false);
	
	addLuaSprite('platformglowNitro', true);
	addLuaSprite('platformglowSweet', true);
	setObjectOrder('platformglowNitro', getObjectOrder('gfGroup')+1);
	setObjectOrder('platformglowSweet', getObjectOrder('extraGroup')+1);
	
	addLuaSprite('platformglowTorrent', true);
	addLuaSprite('platformglowSour', true);
	
	runHaxeCode([[
		var topCameos:FlxBackdrop = new FlxBackdrop(Paths.image('funktrix/GJ-TopCameos'), 0x01);
		topCameos.frames = Paths.getSparrowAtlas('funktrix/GJ-TopCameos');
		topCameos.antialiasing = ClientPrefs.globalAntialiasing;
		topCameos.animation.addByPrefix('idle', 'TopScrollChars instance 1', 24, false);
		topCameos.animation.play('idle');
		topCameos.animation.finish();
		game.insert(game.members.indexOf(game.getLuaObject('city')) + 1, topCameos);
		setVar('topCameos', topCameos);
		
		var bottomCameos:FlxBackdrop = new FlxBackdrop(Paths.image('funktrix/GJ-BottomCameos'), 0x01);
		bottomCameos.frames = Paths.getSparrowAtlas('funktrix/GJ-BottomCameos');
		bottomCameos.antialiasing = ClientPrefs.globalAntialiasing;
		bottomCameos.animation.addByPrefix('idle', 'BottomScrollChars instance 1', 24, false);
		bottomCameos.animation.play('idle');
		bottomCameos.animation.finish();
		game.insert(game.members.indexOf(game.getLuaObject('city')) + 1, bottomCameos);
		setVar('bottomCameos', bottomCameos);
		
		var jamwarning:FlxBackdrop = new FlxBackdrop(Paths.image('funktrix/jamwarning'), 0x01);
		jamwarning.antialiasing = ClientPrefs.globalAntialiasing;
		game.insert(game.members.indexOf(game.getLuaObject('city')) + 1, jamwarning);
		setVar('jamwarning', jamwarning);
	]]);

	setScrollFactor('topCameos', 0.7, 0.7);
	setProperty('topCameos.velocity.x', 100);
	setProperty('topCameos.y', -1000);
	
	setScrollFactor('bottomCameos', 0.7, 0.7);
	setProperty('bottomCameos.velocity.x', -100);
	setProperty('bottomCameos.y', 1500);
	
	setScrollFactor('jamwarning', 0.75, 0.75);
	setProperty('jamwarning.velocity.x', 50);
	setProperty('jamwarning.y', 350);
	setProperty('jamwarning.alpha', 0.001);
	doPulse();
	
	addCharacterToList('sour-back', 'bf');
	addCharacterToList('nitro-puter', 'gf');
	addCharacterToList('torrent-puter', 'dad');
	addCharacterToList('sweet-back-gamejammed', 'extra');
	
	makeLuaSprite('barTop', 'closeup/TightBars', 0, -102);
	setScrollFactor('barTop', 0, 0);
	scaleObject('barTop', 1.1, 1);
	addLuaSprite('barTop', true);
	setObjectCamera('barTop', 'hud');

	makeLuaSprite('barBottom', 'closeup/TightBars', 0, 822);
	setScrollFactor('barBottom', 0, 0);
	scaleObject('barBottom', 1.1, 1);
	addLuaSprite('barBottom', true);
	setObjectCamera('barBottom', 'hud');
end

function onCreatePost()
	--swapBG('1');
	triggerEvent('Call on Luas','swapBG','0');
	setProperty('camZooming', true)
end

function swapBG(thingie)
	stageType = thingie
	cancelTween('extraChar');
	cancelTween('boyfriend');
	setProperty('extraChar.alpha', 1);
	setProperty('boyfriend.alpha', 1);
	
	if stageType == '1' then
		doTweenY('barTop', 'barTop', -102, 0.01, "circinout");
		doTweenY('barBottom', 'barBottom', 822, 0.01, "circinout");
		
		setProperty('roomBG.alpha', 0.001);
		setProperty('pcBG.alpha', 0.001);
		setProperty('monitor.alpha', 0.001);
		
		setProperty('bg.alpha', 1);
		setProperty('city.alpha', 1);
		setProperty('platformNitro.alpha', 1);
		setProperty('platformSweet.alpha', 1);
		setProperty('platformTorrent.alpha', 1);
		setProperty('platformSour.alpha', 1);
		
		setProperty('topCameos.alpha', 1);
		setProperty('bottomCameos.alpha', 1);
		setProperty('jamwarning.alpha', 0.001);
		
		setProperty('defaultCamZoom', 0.6);
		setProperty('isCameraOnForcedPos', false);
		scaleObject('boyfriend', 1, 1);
		scaleObject('extraChar', 1, 1);
		scaleObject('gf', 1, 1);
		scaleObject('dad', 1, 1);
		setScrollFactor('gf', 0.85, 0.85);
		setScrollFactor('dad', 1, 1);
		setScrollFactor('extraChar', 0.85, 0.85);
		
		setProperty('extraGroup.x', getProperty('EXTRA_X')+350)
		setProperty('extraGroup.y', getProperty('EXTRA_Y')-150)
		setProperty('boyfriendGroup.x', getProperty('BF_X')+350)
		setProperty('boyfriendGroup.y', getProperty('BF_Y'))
		
		setProperty('dadGroup.x', getProperty('DAD_X')-350)
		setProperty('dadGroup.y', getProperty('DAD_Y'))
		setProperty('gfGroup.x', getProperty('GF_X')-350)
		setProperty('gfGroup.y', getProperty('GF_Y')-150)
		
		setProperty('platformNitro.x', getProperty('gfGroup.x') - 275)
		setProperty('platformNitro.y', getProperty('gfGroup.y') + 375)
		setProperty('platformSweet.x', getProperty('extraGroup.x') - 200)
		setProperty('platformSweet.y', getProperty('extraGroup.y') + 375)
		setProperty('platformTorrent.x', getProperty('dadGroup.x') - 125)
		setProperty('platformTorrent.y', getProperty('dadGroup.y') + 375)
		setProperty('platformSour.x', getProperty('boyfriendGroup.x') - 175)
		setProperty('platformSour.y', getProperty('boyfriendGroup.y') + 375)
		
		setProperty('platformglowNitro.x', getProperty('platformNitro.x'))
		setProperty('platformglowNitro.y', getProperty('platformNitro.y'))
		setProperty('platformglowSweet.x', getProperty('platformSweet.x'))
		setProperty('platformglowSweet.y', getProperty('platformSweet.y'))
		setProperty('platformglowTorrent.x', getProperty('platformTorrent.x'))
		setProperty('platformglowTorrent.y', getProperty('platformTorrent.y'))
		setProperty('platformglowSour.x', getProperty('platformSour.x'))
		setProperty('platformglowSour.y', getProperty('platformSour.y'))
		
		runHaxeCode([[
			game.boyfriendCameraOffset = [-200, 0];
			//game.opponentCameraOffset = [0, 0];
			game.gf.dance();
			game.dad.dance();
			game.boyfriend.dance();
			game.extraChar.dance();
		]])

	end
	if stageType == '0' then
		doTweenY('barTop', 'barTop', -25, 0.01, "circinout");
		doTweenY('barBottom', 'barBottom', 653, 0.01, "circinout");
		
		setProperty('roomBG.alpha', 1);
		setProperty('pcBG.alpha', 1);
		setProperty('monitor.alpha', 1);
		
		setProperty('bg.alpha', 0.001);
		setProperty('city.alpha', 0.001);
		setProperty('platformNitro.alpha', 0.001);
		setProperty('platformSweet.alpha', 0.001);
		setProperty('platformTorrent.alpha', 0.001);
		setProperty('platformSour.alpha', 0.001);
		
		setProperty('topCameos.alpha', 0.001);
		setProperty('bottomCameos.alpha', 0.001);
		setProperty('jamwarning.alpha', 0.001);
		
		triggerEvent('Change Character','bf','sour-back');
		triggerEvent('Change Character','gf','nitro-puter');
		triggerEvent('Change Character','dad','torrent-puter');
		triggerEvent('Change Character','extra','sweet-back-gamejammed');
		
		scaleObject('boyfriend', 1.25, 1.25);
		scaleObject('extraChar', 1.25, 1.25);
		scaleObject('gf', 1.2, 1.2);
		scaleObject('dad', 1, 1);
		setScrollFactor('gf', 0.9, 0.9);
		setScrollFactor('dad', 0.9, 0.9);
		setScrollFactor('extraChar', 1, 1);
		setProperty('extraGroup.x', getProperty('EXTRA_X') - 900)
		setProperty('extraGroup.y', getProperty('EXTRA_Y') - 130)
		setProperty('boyfriendGroup.x', getProperty('BF_X') - 100)
		setProperty('boyfriendGroup.y', getProperty('BF_Y') - 70)
		setProperty('dadGroup.x', getProperty('DAD_X') + 750)
		setProperty('dadGroup.y', getProperty('DAD_Y') - 130)
		setProperty('gfGroup.x', getProperty('GF_X') + 480)
		setProperty('gfGroup.y', getProperty('GF_Y') - 50)
		
		runHaxeCode([[
			game.boyfriendCameraOffset = [0, 0];
			//game.opponentCameraOffset = [0, 0];
			game.gf.dance();
			game.dad.dance();
			game.boyfriend.dance();
			game.extraChar.dance();
		]])
		
		setProperty('defaultCamZoom', 0.9);
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.x', 374);
		setProperty('camFollow.y', 368);
	end
end

function getJammed()
	pulseEnabled = true;
	doPulse()
	doTweenY('bottomCameos', 'bottomCameos', 500, 1.5, 'circout')
	doTweenY('topCameos', 'topCameos', -300, 1.5, 'circout')
	stagePulse = true;
end

function onBeatHit()
	if curBeat % 2 == 0 then
		--BG folk
		playAnim('topCameos', 'idle', true);
		playAnim('bottomCameos', 'idle', true);
	end
end

function onStepHit()
	if curStep == 1 then
		songStarted = true
	end
end

function onMoveCamera(focus)
	if stageType == '0' and songStarted then
		if focus == 'gf' or focus == 'dad' then
			setProperty('defaultCamZoom', 1.2);
			doTweenAlpha('boyfriend', 'boyfriend', 0.7, 0.5, 'circout')
			doTweenAlpha('extraChar', 'extraChar', 0.7, 0.5, 'circout')
			setProperty('camFollow.x', 374);
			setProperty('camFollow.y', 338);
		elseif focus == 'extra' or focus == 'boyfriend' then
			setProperty('defaultCamZoom', 0.9);
			doTweenAlpha('boyfriend', 'boyfriend', 1, 0.5, 'circout')
			doTweenAlpha('extraChar', 'extraChar', 1, 0.5, 'circout')
			setProperty('camFollow.x', 374);
			setProperty('camFollow.y', 368);
		end
	end
end

function doPulse()
	if pulseEnabled then
		--Ima be real, the math.Sin thing didn't work the way I liked it so yeah lazy
		doTweenAlpha('bgPulse', 'jamwarning', pulseAlpha, pulsespeed, 'linear')
	end
end

function onTweenCompleted(tag)
	if tag == 'bgPulse' then
		if pulsed then
			pulsed = false;
			pulseAlpha = 0;
		else
			pulsed = true;
			pulseAlpha = 1;
		end
		runTimer('delay', pulseDelay)
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'delay' then
		doPulse();
	end
end

function goodNoteHit(membersIndex, noteData, noteType, isSustainNote)
	if not isSustainNote and stagePulse then
		if noteType == 'Extra Character Sing' then
			setProperty('platformglowSweet.alpha', 1);
			doTweenAlpha('platformglowSweet', 'platformglowSweet', 0.001, 1.5, 'circout')
		end
		
		if noteType == 'GF Sing' then
			setProperty('platformglowNitro.alpha', 1);
			doTweenAlpha('platformglowNitro', 'platformglowNitro', 0.001, 1.5, 'circout')
		end
		
		if opponentPlay and noteType == 'Duo Character Sing' then
			setProperty('platformglowNitro.alpha', 1);
			doTweenAlpha('platformglowNitro', 'platformglowNitro', 0.001, 1.5, 'circout')
			setProperty('platformglowTorrent.alpha', 1);
			doTweenAlpha('platformglowTorrent', 'platformglowTorrent', 0.001, 1.5, 'circout')
		end
		
		if not opponentPlay and noteType == 'Duo Character Sing' then
			setProperty('platformglowSweet.alpha', 1);
			doTweenAlpha('platformglowSweet', 'platformglowSweet', 0.001, 1.5, 'circout')
			setProperty('platformglowSour.alpha', 1);
			doTweenAlpha('platformglowSour', 'platformglowSour', 0.001, 1.5, 'circout')
		end
		
		if opponentPlay and noteType ~= 'GF Sing' and not noteType ~= 'Extra Character Sing' and noteType ~= 'Duo Character Sing' then
			setProperty('platformglowTorrent.alpha', 1);
			doTweenAlpha('platformglowTorrent', 'platformglowTorrent', 0.001, 1.5, 'circout')
		end
		
		if not opponentPlay and noteType ~= 'GF Sing' and noteType ~= 'Extra Character Sing' and noteType ~= 'Duo Character Sing' then
			setProperty('platformglowSour.alpha', 1);
			doTweenAlpha('platformglowSour', 'platformglowSour', 0.001, 1.5, 'circout')
		end
	end
end

function opponentNoteHit(membersIndex, noteData, noteType, isSustainNote)
	if not isSustainNote and stagePulse then
		if noteType == 'Extra Character Sing' then
			setProperty('platformglowSweet.alpha', 1);
			doTweenAlpha('platformglowSweet', 'platformglowSweet', 0.001, 1.5, 'circout')
		end
		
		if noteType == 'GF Sing' then
			setProperty('platformglowNitro.alpha', 1);
			doTweenAlpha('platformglowNitro', 'platformglowNitro', 0.001, 1.5, 'circout')
		end
		
		if not opponentPlay and noteType == 'Duo Character Sing' then
			setProperty('platformglowNitro.alpha', 1);
			doTweenAlpha('platformglowNitro', 'platformglowNitro', 0.001, 1.5, 'circout')
			setProperty('platformglowTorrent.alpha', 1);
			doTweenAlpha('platformglowTorrent', 'platformglowTorrent', 0.001, 1.5, 'circout')
		end
		
		if opponentPlay and noteType == 'Duo Character Sing' then
			setProperty('platformglowSweet.alpha', 1);
			doTweenAlpha('platformglowSweet', 'platformglowSweet', 0.001, 1.5, 'circout')
			setProperty('platformglowSour.alpha', 1);
			doTweenAlpha('platformglowSour', 'platformglowSour', 0.001, 1.5, 'circout')
		end
		
		if not opponentPlay and noteType ~= 'GF Sing' and not noteType ~= 'Extra Character Sing' and noteType ~= 'Duo Character Sing' then
			setProperty('platformglowTorrent.alpha', 1);
			doTweenAlpha('platformglowTorrent', 'platformglowTorrent', 0.001, 1.5, 'circout')
		end
		
		if opponentPlay and noteType ~= 'GF Sing' and noteType ~= 'Extra Character Sing' and noteType ~= 'Duo Character Sing' then
			setProperty('platformglowSour.alpha', 1);
			doTweenAlpha('platformglowSour', 'platformglowSour', 0.001, 1.5, 'circout')
		end
	end
end

function speakerNoteHit(membersIndex, noteData, noteType, isSustainNote, mustPress)
	if not isSustainNote and stagePulse then
		if noteType == 'Extra Character Sing' then
			setProperty('platformglowSweet.alpha', 1);
			doTweenAlpha('platformglowSweet', 'platformglowSweet', 0.001, 1.5, 'circout')
		end
		
		if noteType == 'GF Sing' then
			setProperty('platformglowNitro.alpha', 1);
			doTweenAlpha('platformglowNitro', 'platformglowNitro', 0.001, 1.5, 'circout')
		end
		
		if not mustPress and noteType ~= 'GF Sing' and noteType ~= 'Extra Character Sing' then
			setProperty('platformglowTorrent.alpha', 1);
			doTweenAlpha('platformglowTorrent', 'platformglowTorrent', 0.001, 1.5, 'circout')
		end
		
		if mustPress and noteType ~= 'GF Sing' and noteType ~= 'Extra Character Sing' then
			setProperty('platformglowSour.alpha', 1);
			doTweenAlpha('platformglowSour', 'platformglowSour', 0.001, 1.5, 'circout')
		end
	end
end