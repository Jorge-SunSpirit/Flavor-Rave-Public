function onCreate()
	addHaxeLibrary('FlxBackdrop', 'flixel.addons.display');
	
	makeLuaSprite('waltzbg', 'stages/chicory/intromoon', -0, -0);
	setScrollFactor('waltzbg', 0, 0);
	scaleObject('waltzbg', 1.2, 1.2);
	addLuaSprite('waltzbg', false);
	setProperty('waltzbg.alpha', 0.0001);
	setObjectCamera('waltzbg', 'effect');
    screenCenter('waltzbg');
	
	makeLuaSprite('closeupbg', 'stages/chicory/closeupbg', -0, -0);
	setScrollFactor('closeupbg', 0, 0);
	scaleObject('closeupbg', 1.1, 1.1);
	addLuaSprite('closeupbg', false);
	setProperty('closeupbg.alpha', 0.0001);
	setObjectCamera('closeupbg', 'effect');
    screenCenter('closeupbg');
	
	makeLuaSprite('intromoon', 'stages/chicory/intromoon', -0, -0);
	setScrollFactor('intromoon', 0, 0);
	scaleObject('intromoon', 1.15, 1.15);
	addLuaSprite('intromoon', false);
	setObjectCamera('intromoon', 'effect');
    screenCenter('intromoon');
	
	makeLuaSprite('end1', 'stages/chicory/ending/stirring_end_1', -0, -0);
	setScrollFactor('end1', 0, 0);
	scaleObject('end1', 1.15, 1.15);
	addLuaSprite('end1', false);
	setProperty('end1.alpha', 0.0001);
	setObjectCamera('end1', 'effect');
    screenCenter('end1');
	
	makeLuaSprite('end2', 'stages/chicory/ending/stirring_end_2', -0, -0);
	setScrollFactor('end2', 0, 0);
	scaleObject('end2', 1.15, 1.15);
	addLuaSprite('end2', false);
	setProperty('end2.alpha', 0.0001);
	setObjectCamera('end2', 'effect');
    screenCenter('end2');

	makeLuaSprite('end6', 'stages/chicory/ending/stirring_end_6', -0, -0);
	setScrollFactor('end6', 0, 0);
	scaleObject('end6', 2, 2);
	setProperty('end6.x', 0);
	setProperty('end6.y', 0);
	addLuaSprite('end6', false);
	setProperty('end6.alpha', 0.0001);
	setObjectCamera('end6', 'effect');

	makeLuaSprite('end4', 'stages/chicory/ending/stirring_end_4', -0, -0);
	setScrollFactor('end4', 0, 0);
	scaleObject('end4', 1.15, 1.15);
	addLuaSprite('end4', false);
	setProperty('end4.alpha', 0.0001);
	setObjectCamera('end4', 'effect');
    screenCenter('end4');
	
	makeLuaSprite('end5', 'stages/chicory/ending/stirring_end_5', -0, -0);
	setScrollFactor('end5', 0, 0);
	scaleObject('end5', 1.15, 1.15);
	addLuaSprite('end5', false);
	setProperty('end5.alpha', 0.0001);
	setObjectCamera('end5', 'effect');
    screenCenter('end5');

	makeLuaSprite('swirl', 'stages/chicory/swirl', -0, -0);
	setScrollFactor('swirl', 0, 0);
	scaleObject('swirl', 1.7, 1.7);
	addLuaSprite('swirl', false);
	setProperty('swirl.alpha', 0.0001);
	setObjectCamera('swirl', 'effect');
	setBlendMode('swirl', 'add');
    screenCenter('swirl');

	makeLuaSprite('lace1', 'stages/chicory/lacesmall', -0, -0);
	setScrollFactor('lace1', 0, 0);
	scaleObject('lace1', 3, 3);
	addLuaSprite('lace1', false);
	--setProperty('lace1.alpha', 0.0001);
	setObjectCamera('lace1', 'effect');
    screenCenter('lace1');
	
	makeLuaSprite('lace2', 'stages/chicory/lacemid', -0, -0);
	setScrollFactor('lace2', 0, 0);
	scaleObject('lace2', 3, 3);
	addLuaSprite('lace2', false);
	--setProperty('lace2.alpha', 0.0001);
	setObjectCamera('lace2', 'effect');
    screenCenter('lace2');

	makeAnimatedLuaSprite('waltzanim', 'stages/chicory/waltz', posX, posY);
	addAnimationByPrefix('waltzanim', 'dance', 'WaltzAll', 30, true);
	setScrollFactor('waltzanim', 0, 0);
    screenCenter('waltzanim');
	addLuaSprite('waltzanim', false);
	setObjectCamera('waltzanim', 'effect');
	setProperty('waltzanim.alpha', 0.0001);

	makeLuaSprite('lace3', 'stages/chicory/lacebig', -0, -0);
	setScrollFactor('lace3', 0, 0);
	scaleObject('lace3', 3, 3);
	addLuaSprite('lace3', false);
	--setProperty('lace3.alpha', 0.0001);
	setObjectCamera('lace3', 'effect');
    screenCenter('lace3');

	makeLuaSprite('momcloser', 'stages/chicory/her/closer', -0, -0);
	setScrollFactor('momcloser', 0, 0);
	scaleObject('momcloser', 1, 1);
	addLuaSprite('momcloser', false);
	setProperty('momcloser.alpha', 0.0001);
	setObjectCamera('momcloser', 'effect');
    screenCenter('momcloser');

	makeLuaSprite('momscare', 'stages/chicory/her/stare', -0, -0);
	setScrollFactor('momscare', 0, 0);
	scaleObject('momscare', 2.5, 2.5);
	addLuaSprite('momscare', false);
	setProperty('momscare.alpha', 0.0001);
	setObjectCamera('momscare', 'effect');
    screenCenter('momscare');
	
	makeLuaSprite('momeyes', 'stages/chicory/her/stareeyes', -0, -0);
	setScrollFactor('momeyes', 0, 0);
	scaleObject('momeyes', 2.5, 2.5);
	addLuaSprite('momeyes', false);
	setProperty('momeyes.alpha', 0.0001);
	setObjectCamera('momeyes', 'effect');
    screenCenter('momeyes');

	makeLuaSprite('lacememory', 'stages/chicory/lacememory', -0, -0);
	setScrollFactor('lacememory', 0, 0);
	scaleObject('lacememory', 1.1, 1.1);
	addLuaSprite('lacememory', false);
	setProperty('lacememory.alpha', 0.0001);
	setObjectCamera('lacememory', 'effect');
    screenCenter('lacememory');

	makeAnimatedLuaSprite('memory', 'stages/chicory/memory', 0, 0);
	addAnimationByPrefix('memory', 'recall', 'Memory', 30, false);
	setScrollFactor('memory', 0, 0);
	scaleObject('memory', 1, 1);
    screenCenter('memory');
	addLuaSprite('memory', false);
	setObjectCamera('memory', 'effect');
	setProperty('memory.alpha', 0.0001);
	
	makeAnimatedLuaSprite('badmemory', 'stages/chicory/badmemory', 0, 0);
	addAnimationByPrefix('badmemory', 'recall', 'badmemory', 30, true);
	setScrollFactor('badmemory', 0, 0);
	scaleObject('badmemory', 1, 1);
    screenCenter('badmemory');
	addLuaSprite('badmemory', false);
	setObjectCamera('badmemory', 'effect');
	setProperty('badmemory.alpha', 0.0001);
	
	makeAnimatedLuaSprite('letsdance', 'stages/chicory/LetsDance', posX, posY);
	addAnimationByPrefix('letsdance', 'gesture', 'MidSongGesture', 24, false);
	setScrollFactor('letsdance', 0, 0);
	scaleObject('letsdance', 1.1, 1.1);
    screenCenter('letsdance');
	addLuaSprite('letsdance', false);
	setObjectCamera('letsdance', 'effect');
	setProperty('letsdance.alpha', 0.0001);
	
	makeAnimatedLuaSprite('memoryfog', 'stages/chicory/memoryfog', 0, 0);
	addAnimationByPrefix('memoryfog', 'idle', 'badborder', 24, false);
	setScrollFactor('memoryfog', 0, 0);
	scaleObject('memoryfog', 1, 1);
    screenCenter('memoryfog');
	addLuaSprite('memoryfog', true);
	setObjectCamera('memoryfog', 'effect');
	setProperty('memoryfog.alpha', 0.0001);
	
	makeLuaSprite('whitehueh', 'dreamcast/art_BG/whitehueh', 0, 0);
	setScrollFactor('whitehueh', 0, 0);
	addLuaSprite('whitehueh', true);
	setObjectCamera('whitehueh', 'effect');
	setProperty('whitehueh.alpha', 0.0001);

	makeLuaSprite('end3', 'stages/chicory/ending/stirring_end_3', -0, -0);
	setScrollFactor('end3', 0, 0);
	scaleObject('end3', 1, 1);
	addLuaSprite('end3', true);
	setProperty('end3.alpha', 0.0001);
	setObjectCamera('end3', 'effect');
    screenCenter('end3');

	makeLuaSprite('AngryBorder', 'stages/chicory/angryborder', -0, -0);
	setScrollFactor('AngryBorder', 0, 0);
	scaleObject('AngryBorder', 1, 1);
	addLuaSprite('AngryBorder', false);
	setProperty('AngryBorder.alpha', 0.0001);
	setObjectCamera('AngryBorder', 'effect');
    screenCenter('AngryBorder');

	makeLuaSprite('black', '', -100, -100);
    makeGraphic('black', 1280*2, 720*2, '000000');
    setScrollFactor('black', 0, 0);
    screenCenter('black');
	setObjectCamera('black', 'effect');
    addLuaSprite('black', true);

	runHaxeCode([[
		var stars:FlxBackdrop = new FlxBackdrop(Paths.image('stages/chicory/stars'), 0x10);
		stars.antialiasing = ClientPrefs.globalAntialiasing;
		game.insert(game.members.indexOf(game.getLuaObject('waltzanim')) + 1, stars);
		setVar('stars', stars);
	
		var introclouds:FlxBackdrop = new FlxBackdrop(Paths.image('stages/chicory/introclouds'), 0x01);
		introclouds.antialiasing = ClientPrefs.globalAntialiasing;
		game.insert(game.members.indexOf(game.getLuaObject('stars')) + 1, introclouds);
		setVar('introclouds', introclouds);
		
		var closeuplace:FlxBackdrop = new FlxBackdrop(Paths.image('stages/chicory/laceborder1'), 0x01);
		closeuplace.antialiasing = ClientPrefs.globalAntialiasing;
		game.insert(game.members.indexOf(game.getLuaObject('whitehueh')) - 1, closeuplace);
		setVar('closeuplace', closeuplace);

		var closeuplacetwo:FlxBackdrop = new FlxBackdrop(Paths.image('stages/chicory/laceborder2'), 0x01);
		closeuplacetwo.antialiasing = ClientPrefs.globalAntialiasing;
		game.insert(game.members.indexOf(game.getLuaObject('closeuplace')) - 1, closeuplacetwo);
		setVar('closeuplacetwo', closeuplacetwo);
	]]);
	setProperty('closeuplace.alpha', 0.0001);
	setProperty('closeuplacetwo.alpha', 0.0001);
	setObjectCamera('closeuplace', 'effect');
	setObjectCamera('closeuplacetwo', 'effect');
	setObjectCamera('introclouds', 'effect');
	setProperty('introclouds.velocity.x', 20);
	setProperty('closeuplace.velocity.x', 30);
	setProperty('closeuplacetwo.velocity.x', -30);
	setObjectCamera('stars', 'effect');
	setProperty('stars.velocity.y', -20);
	setProperty('stars.alpha', 0.0001);
	setBlendMode('stars', 'add');
	setProperty('happyEnding', true)
end

function onCreatePost()
	if isStoryMode then
		setProperty('resultType', 'mute')
	end
end

function mother(num)
	if num == '1' then
		setProperty('SkyDark.alpha', 0.8);
		doTweenAlpha('SkyDark', 'SkyDark', 1, 1);
		setProperty('AngryBorder.alpha', 1);
		doTweenAlpha('AngryBorder', 'AngryBorder', 0.0001, 0.5);
		setProperty('RestaurantDark.alpha', 0.5);
		doTweenAlpha('RestaurantDark', 'RestaurantDark', 1, 1);
		setProperty('TablesDark.alpha', 0.5);
		doTweenAlpha('TablesDark', 'TablesDark', 1, 1);
		setProperty('LightDark.alpha', 0.0001);
		doTweenAlpha('LightDark', 'LightDark', 1, 1);
		setProperty('Glow.alpha', 1);
		doTweenAlpha('Glow', 'Glow', 0.00001, 1.2);
	end
end

function onCreatePost()
	setProperty('camZoomingFreq', 12);
	setProperty('boyfriend.danceEveryNumBeats', 3);
	setProperty('dad.danceEveryNumBeats', 3);
	setProperty('flavorHUD.beatFrequency', 6);
	
	addCharacterToList('bitter-close-stirring', 'dad');
	addCharacterToList('sweet-close-stirring', 'boyfriend');
end

function thingie(num)
	num = tonumber(num)
	if num == 1 then
		setProperty('introclouds.y', 40);
		setProperty('intromoon.y', -10);
		setProperty('end1.x', -65);
		setProperty('end2.x', -65);
		setProperty('end4.x', -65);
		setProperty('end5.x', -65);
	end
	if num == 16 then
		doTweenAlpha('black', 'black', 0.0001, 3);
		doTweenY('introclouds', 'introclouds', 0, 7, "quadinout");
		doTweenY('intromoon', 'intromoon', -65, 7, "quadinout");
	end
	if num == 96 then
		doTweenAlpha('introclouds', 'introclouds', 0.0001, 1.6, "quadinout");
		doTweenAlpha('intromoon', 'intromoon', 0.0001, 2.3, "quadinout");
	end
	if num == 448 then
		setProperty('camFollow.x', 822);
		setProperty('camFollow.y', 250);
		setProperty('isCameraOnForcedPos', true);
	end
	if num == 476 then
		setProperty('isCameraOnForcedPos', false);
	end
	if num == 504 then
		setProperty('camFollow.x', 822);
		setProperty('camFollow.y', 250);
		setProperty('isCameraOnForcedPos', true);
	end
	if num == 532 then
		doTweenAlpha('whitehueh', 'whitehueh', 1, 2);
		doTweenX('moveCamX', 'camFollow', 808, 5, "quadinout");
		doTweenY('moveCamY', 'camFollow', -581, 5, "quadinout");
	end
	if num == 560 then
		doTweenAlpha('whitehueh', 'whitehueh', 0.001, 1);
		setProperty('closeupbg.alpha', 1);
		setProperty('closeuplace.alpha', 1);
		setProperty('closeuplacetwo.alpha', 1);
		triggerEvent('Change Character','bf','sweet-close-stirring');
		triggerEvent('Change Character','dad','bitter-close-stirring');
		setProperty('boyfriend.x', 820);
		setProperty('boyfriend.y', 100);
		setProperty('dad.x', -30);
		setProperty('dad.y', -100);
		setObjectCamera('boyfriend', 'effect');
		setObjectCamera('dad', 'effect');
	end
	if num == 624 then
		doTweenX('boyfriend', 'boyfriend', 1600, 0.9, "quadinout");
		doTweenX('dad', 'dad', -800, 0.9, "quadinout");
	end
	if num == 632 then
		setProperty('letsdance.alpha', 1);
		playAnim('letsdance', 'gesture');
	end
	if num == 656 then
		setProperty('whitehueh.alpha', 1);
		setProperty('closeupbg.alpha', 0.0001);
		setProperty('closeuplace.alpha', 0.0001);
		setProperty('closeuplacetwo.alpha', 0.0001);
		setProperty('letsdance.alpha', 0.001);
		doTweenAlpha('whitehueh', 'whitehueh', 0.0001, 0.7);
		setProperty('boyfriend.alpha', 0.001);
		setProperty('dad.alpha', 0.001);
		playAnim('waltzanim', 'dance');
		setProperty('stars.alpha', 1);
		setProperty('waltzanim.alpha', 1);
		setProperty('waltzbg.alpha', 1);
	end
	if num == 844 then
		setProperty('dad.x', -30);
		setProperty('boyfriend.x', 820);
		setProperty('isCameraOnForcedPos', false);
		doTweenX('lace1X', 'lace1.scale', 1.4, 5, "quadOut", 1.5);
		doTweenY('lace1Y', 'lace1.scale', 1.4, 5, "quadOut", 1.5);
		
		doTweenX('lace2X', 'lace2.scale', 1.4, 5, "quadOut", 0.7);
		doTweenY('lace2Y', 'lace2.scale', 1.4, 5, "quadOut", 0.7);
		
		doTweenX('lace3X', 'lace3.scale', 1.4, 5, "quadOut");
		doTweenY('lace3Y', 'lace3.scale', 1.4, 5, "quadOut");
		
		setProperty('lace1.angularVelocity', 15);
		setProperty('lace2.angularVelocity', -10);
		setProperty('lace3.angularVelocity', 5);
	end
	if num == 870 then
		doTweenColor('waltzbg', 'waltzbg', 'f9ff40', '3', 'linear')
		doTweenAlpha('swirl', 'swirl', 1, 2);
		setProperty('swirl.angularVelocity', -20);
	end
	if num == 1040 then
		setProperty('lace1.alpha', 0.0001);
		setProperty('lace2.alpha', 0.0001);
		setProperty('lace3.alpha', 0.0001);
		setProperty('swirl.alpha', 0.0001);
		setProperty('stars.alpha', 0.0001);
		setProperty('waltz.alpha', 0.0001);
		setProperty('waltzbg.alpha', 0.0001);
		setProperty('whitehueh.alpha', 1);
		doTweenAlpha('whitehueh', 'whitehueh', 0.0001, 0.7);
		setProperty('boyfriend.alpha', 1);
		setProperty('dad.alpha', 1);
		setProperty('closeuplace.alpha', 0.001);
		setProperty('waltzanim.alpha', 0.001);
		setProperty('waltzbg.alpha', 0.001);
		setProperty('closeupbg.alpha', 0.001);
		triggerEvent('Change Character','bf','sweet');
		triggerEvent('Change Character','dad','bitter');
	end
	if num == 1400 then
		setProperty('memory.x', 130);
		doTweenAlpha('whitehueh', 'whitehueh', 1, 2.5);
	end
	if num == 1424 then
		doTweenAngle('lacememory', 'lacememory', 720, 45)
		setProperty('lacememory.alpha', 1);
		playAnim('memory', 'recall');
		setProperty('memory.alpha', 1);
		doTweenAlpha('whitehueh', 'whitehueh', 0.001, 1);
		triggerEvent('Change Character','bf','sweet-close-stirring');
		triggerEvent('Change Character','dad','bitter-close-stirring');
		setProperty('boyfriend.x', 882);
		setProperty('boyfriend.y', 100);
		setProperty('dad.x', -107);
		setProperty('dad.y', -100);
		setObjectCamera('boyfriend', 'effect');
		setObjectCamera('dad', 'effect');
		setObjectOrder('memoryfog', getObjectOrder('boyfriendGroup')+1);
		setProperty('closeuplace.alpha', 1);
		setProperty('closeuplacetwo.alpha', 1);
		setProperty('closeupbg.alpha', 1);
	end
	if num == 1584 then
		doTweenColor('lacememory', 'lacememory', '170404', '0.001', 'linear')
		setProperty('flavorHUD.forceP1Frame', "angry");
		setProperty('flavorHUD.forceP2Frame', "angry");
	end
	if num == 1604 then
		doTweenColor('closeupbg', 'closeupbg', 'b50404', '6', 'linear')
	end
	if num == 1704 then
		setProperty('memory.alpha', 0.0001);
		setProperty('badmemory.alpha', 1);
	end
	if num == 1724 then
		setProperty('memoryfog.alpha', 1);
		playAnim('memoryfog', 'idle');
	end
	if num == 1744 then
		setProperty('memoryfog.alpha', 0.0001);
		setProperty('lacememory.alpha', 0.0001);
		setProperty('badmemory.alpha', 0.0001);
		setProperty('whitehueh.alpha', 1);
		doTweenAlpha('whitehueh', 'whitehueh', 0.0001, 0.5);
		triggerEvent('Change Character','bf','sweet');
		triggerEvent('Change Character','dad','bitter');
		setProperty('closeupbg.alpha', 0.001);
		setProperty('closeuplace.alpha', 0.001);
		setProperty('closeuplacetwo.alpha', 0.001);
		setProperty('isCameraOnForcedPos', false);
		triggerEvent('Change Camera Zoom', '0.4', '1');
	end
	if num == 1756 then
		setProperty('mombitter.alpha', 1);
		doTweenAlpha('mombitter', 'mombitter', 0.00001, 1);
	end
	if num == 1768 then
		setProperty('momtable.alpha', 1);
		doTweenAlpha('momtable', 'momtable', 0.00001, 1);
	end
	if num == 1800 then
		triggerEvent('Change Camera Zoom', '0.4', '1');
	end
	if num == 1812 then
		setProperty('momsweet.alpha', 1);
		doTweenAlpha('momsweet', 'momsweet', 0.00001, 1);
	end
	if num == 1824 then
		setProperty('momfront.alpha', 1);
		doTweenAlpha('momfront', 'momfront', 0.00001, 1);
	end
	if num == 1856 then
		setProperty('mommiddle.alpha', 1);
		doTweenAlpha('mommiddle', 'mommiddle', 0.00001, 1);
		setProperty('camFollow.x', 822);
		setProperty('camFollow.y', 250);
		setProperty('isCameraOnForcedPos', true);
	end
	if num == 1868 then
		setProperty('momcloser.alpha', 1);
		doTweenAlpha('momcloser', 'momcloser', 0.00001, 1);
	end
	if num == 1880 then
		setProperty('momscare.alpha', 1);
		doTweenAlpha('momscare', 'momscare', 0.00001, 1.5);
		setProperty('momeyes.alpha', 1);
		doTweenAlpha('momeyes', 'momeyes', 0.00001, 3);
		setProperty('isCameraOnForcedPos', false);
	end
	if num == 1912 then
		setProperty('camFollow.x', 822);
		setProperty('camFollow.y', 250);
		setProperty('isCameraOnForcedPos', true);
	end
	if num == 1924 then
		setProperty('mommiddle.alpha', 1);
		doTweenAlpha('mommiddle', 'mommiddle', 0.00001, 1);
		setProperty('momtable.alpha', 1);
		doTweenAlpha('momtable', 'momtable', 0.00001, 1);
		setProperty('momsweet.alpha', 1);
		doTweenAlpha('momsweet', 'momsweet', 0.00001, 1);
		setProperty('momfront.alpha', 1);
		doTweenAlpha('momfront', 'momfront', 0.00001, 1);
		setProperty('mombitter.alpha', 1);
		doTweenAlpha('mombitter', 'mombitter', 0.00001, 1);
	end
	if num == 1936 then
		setProperty('isCameraOnForcedPos', false);
	end
	if num == 1968 then
		triggerEvent('Change Camera Zoom', '0.4', '1');
		doTweenAlpha('whitehueh', 'whitehueh', 1, 2);
	end
	if num == 2001 then
		doTweenAlpha('whitehueh', 'whitehueh', 0.0001, 1.5);
		setProperty('end1.alpha', 1);
		doTweenX('end1', 'end1', 6, 7);
		setProperty('happyEnding', true)
		setProperty('flavorHUD.forceP1Frame', "");
		setProperty('flavorHUD.forceP2Frame', "");
	end
	if num == 2052 then
		doTweenAlpha('alphaend2', 'end2', 1, 0.8);
		doTweenX('xend2', 'end2', 6, 7);
	end
	if num == 2086 then
		doTweenAlpha('whitehueh', 'whitehueh', 1, 1);
		setProperty('end1.alpha', 0.0001);
	end
	if num == 2104 then
		setProperty('swirl.angularVelocity', -10);
		doTweenColor('waltzbg', 'waltzbg', 'db39af', '0.5', 'linear')
		doTweenAlpha('end3', 'end3', 1, 1.5);
	end
	if num == 2118 then
		setProperty('end2.alpha', 0.0001);
		doTweenAlpha('swirl', 'swirl', 1, 0.7);
		doTweenAlpha('stars', 'stars', 1, 1);
		setProperty('waltzbg.alpha', 1);
	end
	if num == 2126 then
		doTweenAlpha('whitehueh', 'whitehueh', 0.0001, 2);
	end
	if num == 2248 then
		doTweenAlpha('whitehueh', 'whitehueh', 1, 0.7, "circinout");
	end
	if num == 2260 then
		setProperty('end4.alpha', 1);
		doTweenAlpha('swirl', 'swirl', 0.0001, 0.3);
		doTweenAlpha('stars', 'stars', 0.0001, 0.3);
		doTweenAlpha('end3', 'end3', 0.0001, 0.5);
		setProperty('waltzbg.alpha', 0.0001);
		doTweenX('end4', 'end4', 6, 7);
		doTweenAlpha('whitehueh', 'whitehueh', 0.0001, 1);
		doTweenAlpha('camHUD', 'camHUD', 0, 2, 'circout')
		setProperty("camZooming", false)
	end
	if num == 2282 then
		doTweenX('alphaend5', 'end5', 6, 7);
		doTweenAlpha('onetwooatmealkirbyisapinkguyend5', 'end5', 1, 0.8);
	end
	if num == 2308 then
		setProperty('end4.alpha', 0.0001);
		doTweenAlpha('end5', 'end5', 0.0001, 0.5);
		setProperty('end6.alpha', 1);
	end
	if num == 2320 then
		doTweenX('end6ScaleX', 'end6.scale', 1, 3, 'quadinout');
		doTweenY('end6ScaleY', 'end6.scale', 1, 3, 'quadinout');
		doTweenX('end6X', 'end6', -640, 3, 'quadinout');
		doTweenY('end6Y', 'end6', -360, 3, 'quadinout');
	end
	if num == 2368 then
		doTweenAlpha('black', 'black', 1, 2);
	end
end
function onBeatHit()
end