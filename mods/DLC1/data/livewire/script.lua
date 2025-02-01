local newstime = false;

function onCreate()
	posX = -0;
	posY = -0;
	scale = 1;

	addHaxeLibrary('FlxBackdrop', 'flixel.addons.display');
	
	makeLuaSprite('SourBG', 'closeup/SourBG', -50, -0);
	setScrollFactor('SourBG', 0, 0);
	scaleObject('SourBG', 1.2, 1.2);
	addLuaSprite('SourBG', false);
	setProperty('SourBG.alpha', 0.0001);
	setObjectCamera('SourBG', 'effect');
	
	makeLuaSprite('SweetBG', 'closeup/SweetBG', -50, -0);
	setScrollFactor('SweetBG', 0, 0);
	scaleObject('SweetBG', 1.2, 1.2);
	addLuaSprite('SweetBG', false);
	setProperty('SweetBG.alpha', 0.0001);
	setObjectCamera('SweetBG', 'effect');
	
	makeLuaSprite('TangyBG', 'stages/livewire-extras/tangyBG', -0, -50);
	setScrollFactor('TangyBG', 0, 0);
	scaleObject('TangyBG', 1.2, 1.2);
	addLuaSprite('TangyBG', false);
	setProperty('TangyBG.alpha', 0.0001);
	setObjectCamera('TangyBG', 'effect');
    screenCenter('TangyBG');

	makeLuaSprite('TangyBGAngryEnd', 'stages/livewire-extras/TangyAngryBG', -400, -250);
	setScrollFactor('TangyBGAngryEnd', 0.3, 0.3);
	scaleObject('TangyBGAngryEnd', 1.5, 1.5);
	addLuaSprite('TangyBGAngryEnd', false);
	setProperty('TangyBGAngryEnd.alpha', 0.0001);
    screenCenter('TangyBGAngryEnd');
	
	makeLuaSprite('TangyBGAngry', 'stages/livewire-extras/TangyAngryBG', -0, -0);
	setScrollFactor('TangyBGAngry', 0, 0);
	scaleObject('TangyBGAngry', 1.2, 1.2);
	addLuaSprite('TangyBGAngry', false);
	setProperty('TangyBGAngry.alpha', 0.0001);
	setObjectCamera('TangyBGAngry', 'effect');
    screenCenter('TangyBGAngry');

	makeAnimatedLuaSprite('intro1', 'stages/livewire-extras/SourIntro', posX - 100, posY);
	addAnimationByPrefix('intro1', 'idle', 'SourIntro', 24, false);
	setScrollFactor('intro1', 0, 0);
	addLuaSprite('intro1', false);
    screenCenter('intro1');
	setObjectCamera('intro1', 'effect')
	setProperty('intro1.alpha', 0.0001);
	
	makeAnimatedLuaSprite('intro2', 'stages/livewire-extras/SweetIntro', posX + 600, posY);
	addAnimationByPrefix('intro2', 'idle', 'SweetIntro', 24, false);
	setScrollFactor('intro2', 0, 0);
	addLuaSprite('intro2', false);
    screenCenter('intro2');
	setObjectCamera('intro2', 'effect')
	setProperty('intro2.alpha', 0.0001);
	
	makeAnimatedLuaSprite('intro3', 'stages/livewire-extras/TangyIntro1', posX + 300, -600);
	addAnimationByPrefix('intro3', 'idle', 'TangyIntro1', 24, false);
	setScrollFactor('intro3', 0, 0);
	addLuaSprite('intro3', false);
	setObjectCamera('intro3', 'effect')
	setProperty('intro3.alpha', 0.0001);
	
	makeAnimatedLuaSprite('intro4', 'stages/livewire-extras/TangyIntro2', -176.05, -154.8);
	addAnimationByPrefix('intro4', 'idle', 'TangyIntro2', 24, false);
	setScrollFactor('intro4', 0, 0);
	addLuaSprite('intro4', false);
	setObjectCamera('intro4', 'effect')
	setProperty('intro4.alpha', 0.0001);

	makeLuaSprite('CutinBG', 'stages/livewire-extras/cutinBG', -0, -0);
	setScrollFactor('CutinBG', 0, 0);
	addLuaSprite('CutinBG', false);
	setProperty('CutinBG.alpha', 0.0001);
	setObjectCamera('CutinBG', 'effect');
    screenCenter('CutinBG');

	makeLuaSprite('disk', 'stages/livewire-extras/disk', -0, 1000);
	setScrollFactor('disk', 0, 0);
	addLuaSprite('disk', false);
	setProperty('disk.alpha', 0.0001);
	setObjectCamera('disk', 'effect');
    screenCenter('disk');

	runHaxeCode([[
		var city1:FlxBackdrop = new FlxBackdrop(Paths.image('stages/livewire-extras/SpitBuilds1'), 0x11);
		city1.antialiasing = ClientPrefs.globalAntialiasing;
		game.insert(game.members.indexOf(game.getLuaObject('CutinBG')) + 1, city1);
		setVar('city1', city1);
		
		var city2:FlxBackdrop = new FlxBackdrop(Paths.image('stages/livewire-extras/SpitBuilds2'), 0x11);
		city2.antialiasing = ClientPrefs.globalAntialiasing;
		game.insert(game.members.indexOf(game.getLuaObject('city1')) + 1, city2);
		setVar('city2', city2);
	]]);

	setObjectCamera('city1', 'effect');
	setObjectCamera('city2', 'effect');
	setProperty('city1.velocity.x', 50);
	setProperty('city2.velocity.x', -50);
	setProperty('city1.alpha', 0.0001);
	setProperty('city2.alpha', 0.0001);
	setProperty('city1.y', 200);
	setProperty('city2.y', -200);

	makeLuaSprite('TangyDrama', 'stages/livewire-extras/tangydrama', 820, -0);
	setScrollFactor('TangyDrama', 0, 0);
	scaleObject('TangyDrama', 1, 1);
	addLuaSprite('TangyDrama', false);
	setProperty('TangyDrama.alpha', 0.0001);
	setObjectCamera('TangyDrama', 'effect');
	
	makeLuaSprite('SourDrama', 'stages/livewire-extras/sourdrama', -350, -0);
	setScrollFactor('SourDrama', 0, 0);
	scaleObject('SourDrama', 1, 1);
	addLuaSprite('SourDrama', false);
	setProperty('SourDrama.alpha', 0.0001);
	setObjectCamera('SourDrama', 'effect');

	makeLuaSprite('barTop', 'closeup/TightBars', 0, -40);
	setScrollFactor('barTop', 0, 0);
	scaleObject('barTop', 1.1, 1);
	addLuaSprite('barTop', false);
	setObjectCamera('barTop', 'effect');

	makeLuaSprite('barBottom', 'closeup/TightBars', 0, 668);
	setScrollFactor('barBottom', 0, 0);
	scaleObject('barBottom', 1.1, 1);
	addLuaSprite('barBottom', false);
	setObjectCamera('barBottom', 'effect');

	makeAnimatedLuaSprite('SourCutin', 'stages/livewire-extras/SourCutin', 931, 131);
	addAnimationByPrefix('SourCutin', 'idle', 'SourCutin1', 24, true);
	playAnim('SourCutin', 'idle');
	setScrollFactor('SourCutin', 0, 0);
	addLuaSprite('SourCutin', false);
	setObjectCamera('SourCutin', 'effect')
	setProperty('SourCutin.alpha', 0.0001);

	makeAnimatedLuaSprite('TangyCutin', 'stages/livewire-extras/TangyCutin', -300, 402);
	addAnimationByPrefix('TangyCutin', 'idle', 'TangyCutin1', 24, true);
	playAnim('TangyCutin', 'idle');
	setScrollFactor('TangyCutin', 0, 0);
	addLuaSprite('TangyCutin', false);
	setObjectCamera('TangyCutin', 'effect')
	setProperty('TangyCutin.alpha', 0.0001);

	makeAnimatedLuaSprite('CoolEffects', 'stages/livewire-extras/BGIntroEffects', 0, 0);
	addAnimationByPrefix('CoolEffects', 'idle', 'BGEffects', 24, false);
	playAnim('CoolEffects', 'idle');
	scaleObject('CoolEffects', 1.2, 1.2);
	setScrollFactor('CoolEffects', 0, 0);
	addLuaSprite('CoolEffects', false);
	setObjectCamera('CoolEffects', 'effect')
	setProperty('CoolEffects.alpha', 0.0001);
    screenCenter('CutinBG');

	makeAnimatedLuaSprite('Cut1', 'stages/livewire-extras/Cutscene/HatThrow', 256, 0);
	addAnimationByPrefix('Cut1', 'idle', 'HatThrow', 24, false);
	playAnim('Cut1', 'idle');
	setScrollFactor('Cut1', 0, 0);
	addLuaSprite('Cut1', false);
	setObjectCamera('Cut1', 'effect')
	setProperty('Cut1.alpha', 0.0001);
	
	makeAnimatedLuaSprite('Cut2', 'stages/livewire-extras/Cutscene/FistTime', -160, -200);
	addAnimationByPrefix('Cut2', 'idle', 'FistTime', 24, false);
	playAnim('Cut2', 'idle');
	setScrollFactor('Cut2', 0, 0);
	addLuaSprite('Cut2', false);
	setObjectCamera('Cut2', 'effect')
	setProperty('Cut2.alpha', 0.0001);

	makeAnimatedLuaSprite('Cut3', 'stages/livewire-extras/Cutscene/LeftyTime', 120, -550);
	addAnimationByPrefix('Cut3', 'idle', 'LeftyTime', 24, false);
	playAnim('Cut3', 'idle');
	setScrollFactor('Cut3', 0, 0);
	addLuaSprite('Cut3', false);
	setObjectCamera('Cut3', 'effect')
	setProperty('Cut3.alpha', 0.0001);

	makeAnimatedLuaSprite('Cut4', 'stages/livewire-extras/Cutscene/UhhDie', 0, 0);
	addAnimationByPrefix('Cut4', 'idle', 'UhhDie', 24, false);
	playAnim('Cut4', 'idle');
	setScrollFactor('Cut4', 0, 0);
    screenCenter('Cut4');
	addLuaSprite('Cut4', false);
	setObjectCamera('Cut4', 'effect')
	setProperty('Cut4.alpha', 0.0001);

	makeLuaSprite('End1', 'stages/livewire-extras/End1', 0, -0);
	setScrollFactor('End1', 0, 0);
	scaleObject('End1', 1.1, 1.1);
	addLuaSprite('End1', false);
	setProperty('End1.alpha', 0.0001);
    screenCenter('End1');
	setObjectCamera('End1', 'effect');
	
	makeLuaSprite('End2', 'stages/livewire-extras/End2', 0, -0);
	setScrollFactor('End2', 0, 0);
	scaleObject('End2', 1.1, 1.1);
	addLuaSprite('End2', false);
	setProperty('End2.alpha', 0.0001);
    screenCenter('End2');
	setObjectCamera('End2', 'effect');
	
	makeLuaSprite('End3', 'stages/livewire-extras/End3', 0, -0);
	setScrollFactor('End3', 0, 0);
	scaleObject('End3', 1.1, 1.1);
	addLuaSprite('End3', false);
	setProperty('End3.alpha', 0.0001);
    screenCenter('End3');
	setObjectCamera('End3', 'effect');

	makeAnimatedLuaSprite('leftygrabbed', 'stages/livewire-extras/lefty_grab', 500, -300);
	addAnimationByPrefix('leftygrabbed', 'idle', 'LeftyPlace', 24, true);
	addLuaSprite('leftygrabbed', false);
	setProperty('leftygrabbed.alpha', 0.0001);

	makeLuaSprite('coolborder', 'stages/livewire-extras/coolborder', -0, -0);
	setScrollFactor('coolborder', 0, 0);
	addLuaSprite('coolborder', false);
	setProperty('coolborder.alpha', 0.0001);
	setObjectCamera('coolborder', 'effect');
    screenCenter('coolborder');

	makeLuaSprite('dramablack', '', -100, -100);
    makeGraphic('dramablack', 1280*2, 720*2, '000000');
    setScrollFactor('dramablack', 0, 0);
    screenCenter('dramablack');
	setProperty('dramablack.alpha', 0.0001);
	addLuaSprite('dramablack', false);

	makeLuaSprite('black', '', -100, -100);
    makeGraphic('black', 1280*2, 720*2, '000000');
    setScrollFactor('black', 0, 0);
    screenCenter('black');
	setObjectCamera('black', 'effect')
	addLuaSprite('black', true);
end

function onCreatePost()
	setProperty('extraChar.alpha', 0.0001);
	addCharacterToList('tangy-rave', 'dad');
	addCharacterToList('tangy-rave-ending', 'dad');
	addCharacterToList('sour-ending-LW', 'boyfriend');
	stageType(1);
	
	if not opponentPlay and isStoryMode then
		setProperty('isFakeout', true)
	end
end

function onStepHit()
	if curStep == 1 then
		doTweenY('diskY', 'disk', 1000, 1, "quadInOut");
		doTweenAlpha('black', 'black', 0.0001, 0.5);
		setProperty('intro1.alpha', 1);
		doTweenX('intro1X', 'intro1', 150, 6);
		doTweenX('SourBGX', 'SourBG', -100, 6);
		setProperty('SourBG.alpha', 1);
		runTimer('cutscene1', 0.01);
	end
	if curStep == 24 then
		doTweenAlpha('black', 'black', 1, 0.7);
	end
	if curStep == 32 then
		setProperty('intro1.alpha', 0.0001);
		doTweenAlpha('black', 'black', 0.0001, 0.5);
		setProperty('SourBG.alpha', 0.0001);
		setProperty('SweetBG.alpha', 1);
		setProperty('intro2.alpha', 1);
		doTweenX('intro2X', 'intro2', 100, 6);
		doTweenX('SweetBGX', 'SweetBG', 25, 6);
		runTimer('cutscene2', 0.01);
	end
	if curStep == 56 then
		doTweenAlpha('black', 'black', 1, 0.7);
	end
	if curStep == 64 then
		setProperty('intro2.alpha', 0.0001);
		doTweenAlpha('black', 'black', 0.0001, 0.5);
		setProperty('SweetBG.alpha', 0.0001);
		setProperty('TangyBG.alpha', 1);
		setProperty('intro3.alpha', 1);
		doTweenY('intro3Y', 'intro3', 100, 9);
		doTweenY('TangyBGY', 'TangyBG', 50, 3);
		runTimer('cutscene3', 0.01);
	end
	if curStep == 88 then
		doTweenAlpha('black', 'black', 1, 0.7);
	end
	if curStep == 96 then
		setProperty('intro3.alpha', 0.0001);
		doTweenAlpha('black', 'black', 0.0001, 0.5);
		setProperty('intro4.alpha', 1);
		runTimer('cutscene4', 0.01);
	end
	if curStep == 116 then
		setProperty('TangyBG.alpha', 0.0001);
		setProperty('intro4.alpha', 0.0001);
		setProperty('black.alpha', 1);
	end
	if curStep == 120 then
		setProperty('black.alpha', 0.0001);
	end
	if curStep == 384 then
		setProperty('black.alpha', 1);
		setProperty('leftlight.alpha', 0.0001);
		setProperty('rightlight.alpha', 0.0001);
		setProperty('spotlight.alpha', 0.0001);
		setProperty('dramablack.alpha', 1);
		doTweenY('city1Y', 'city1', 0, 3, "quadInOut");
		doTweenY('city2Y', 'city2', 0, 3, "quadInOut");
	end
	if curStep == 394 then
		setProperty('CutinBG.alpha', 1);
		setProperty('city1.alpha', 1);
		setProperty('city2.alpha', 1);
		setProperty('disk.alpha', 1);
		doTweenAngle('disk', 'disk', 1080, 30)
		setProperty('boyfriend.alpha', 0.0001);
		setProperty('dad.alpha', 0.0001);
		doTweenAlpha('black', 'black', 0.0001, 4);
	end
	if curStep == 402 then
		doTweenAlpha('TangyCutin', 'TangyCutin', 1, 2, "quadInOut");
		doTweenX('TangyCutinX', 'TangyCutin', -12, 3, "quadInOut");
	end
	if curStep == 448 then
		doTweenAlpha('SourCutin', 'SourCutin', 1, 2, "quadInOut");
		doTweenX('SourCutinX', 'SourCutin', 631, 3, "quadInOut");
	end
	if curStep == 504 then
		doTweenX('SourCutinX', 'SourCutin', 1431, 1, "quadInOut");
		doTweenX('TangyCutinX', 'TangyCutin', -800, 1, "quadInOut");
	end
	if curStep == 512 then
		setProperty('TangyCutin.alpha', 0.0001);
		setProperty('SourCutin.alpha', 0.0001);
		doTweenAlpha('TangyDrama', 'TangyDrama', 1, 2, "quadInOut");
		doTweenX('TangyDramaX', 'TangyDrama', -180, 4.5, "quadInOut");
		doTweenAlpha('SourDrama', 'SourDrama', 1, 2, "quadInOut");
		doTweenX('SourDramaX', 'SourDrama', 720, 4.5, "quadInOut");
	end
	if curStep == 554 then
		doTweenY('diskY', 'disk', 100, 2, "quadInOut");
	end
	if curStep == 640 then
		newstime = true
		setProperty('CutinBG.alpha', 0.0001);
		setProperty('city1.alpha', 0.0001);
		setProperty('city2.alpha', 0.0001);
		setProperty('disk.alpha', 0.0001);
		setProperty('TangyDrama.alpha', 0.0001);
		setProperty('SourDrama.alpha', 0.0001);
		setProperty('boyfriend.alpha', 1);
		setProperty('dad.alpha', 1);
		setProperty('dramablack.alpha', 0.0001);
		setProperty('coolborder.alpha', 1);
		setProperty('news.alpha', 1);
		setProperty('backcitylights.alpha', 1);
		setProperty('buildinglights.alpha', 1);
		setProperty('Sky-cool.alpha', 1);
		setProperty('backcity-cool.alpha', 1);
		setProperty('front-cool.alpha', 1);
		setProperty('building-cool.alpha', 1);
		setProperty('barTop.alpha', 0.0001);
		setProperty('barBottom.alpha', 0.0001);
	end
	if curStep == 1168 then
		setProperty('black.alpha', 1);
		setProperty('coolborder.alpha', 0.0001);
	end
	if curStep == 1180 then
		doTweenAlpha('camHUD', 'camHUD', 0.0001, 0.5);
		setProperty('TangyBGAngry.y', -50);
		setProperty('TangyBGAngry.alpha', 1);
		doTweenAlpha('black', 'black', 0.0001, 0.5);
		playAnim('Cut1', 'idle');
		setProperty('Cut1.alpha', 1);
	end
	if curStep == 1200 then
		playAnim('Cut2', 'idle');
		setProperty('Cut1.alpha', 0.0001);
		setProperty('Cut2.alpha', 1);
	end
	if curStep == 1232 then
		playAnim('Cut3', 'idle');
		setProperty('Cut2.alpha', 0.0001);
		setProperty('Cut3.alpha', 1);
	end
	if curStep == 1264 then
		playAnim('Cut4', 'idle');
		setProperty('Cut3.alpha', 0.0001);
		setProperty('Cut4.alpha', 1);
	end
	if curStep == 1280 then
		newstime = false
		doTweenAlpha('camHUD', 'camHUD', 1, 1);
	end
	if curStep == 1296 then
		doTweenColor('building-cool', 'building-cool', '00f5be', '0.8', 'linear')
		doTweenColor('backcity-cool', 'backcity-cool', '09d2ff', '0.4', 'linear')
		doTweenColor('Sky-cool', 'Sky-cool', '1c29cc ', '0.2', 'linear')
		doTweenColor('front-cool', 'front-cool', 'e3fe37', '1', 'linear')
		setProperty('Cut4.alpha', 0.0001);
		setProperty('TangyBGAngry.alpha', 0.0001);
		setProperty('barTop.alpha', 1);
		setProperty('barBottom.alpha', 1);
		stageType(2);
	end
	if curStep == 1552 then
		newsBeatSpeed = 4;
	end
	if curStep == 1792 then
		doTweenY('barTop', 'barTop', -102, 0.25, "circinout");
		doTweenY('barBottom', 'barBottom', 822, 0.25, "circinout");
	end
	if curStep == 1808 then
		doTweenY('barTop', 'barTop', -40, 0.25, "circinout");
		doTweenY('barBottom', 'barBottom', 668, 0.25, "circinout");
		setProperty('coolborder.alpha', 1);
		setProperty('black.alpha', 1);
		setProperty('CutinBG.alpha', 1);
		setProperty('city1.alpha', 1);
		setProperty('city2.alpha', 1);
	end
	if curStep == 1824 then
		doTweenAlpha('black', 'black', 0.0001, 4);
	end
	if curStep == 1842 then
		doTweenAlpha('End1A', 'End1', 1, 1);
		doTweenX('End1X', 'End1', 80, 20);
	end
	if curStep == 1872 then
		doTweenAlpha('End1A', 'End1', 0.0001, 1);
		doTweenAlpha('End2A', 'End2', 1, 1);
		doTweenX('End2X', 'End2', 80, 20);
	end
	if curStep == 1912 then
		doTweenAlpha('End2A', 'End2', 0.0001, 1);
		doTweenAlpha('End3A', 'End3', 1, 1);
		doTweenX('End3X', 'End3', 80, 20);
	end
	if curStep == 1936 then
		doTweenY('barTop', 'barTop', -102, 0.25, "circinout");
		doTweenY('barBottom', 'barBottom', 822, 0.25, "circinout");
		setProperty('End3.alpha', 0.0001);
		setProperty('CutinBG.alpha', 0.0001);
		setProperty('city1.alpha', 0.0001);
		setProperty('city2.alpha', 0.0001);
		setProperty('TangyBGAngryEnd.alpha', 1);
		stageType(3);
	end
	if curStep == 2128 then
		setProperty('black.alpha', 1);
		setProperty('camHUD.alpha', 0.0001);
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'cutscene1' then
		playAnim('intro1', 'idle');
	end
	if tag == 'cutscene2' then
		playAnim('intro2', 'idle');
	end
	if tag == 'cutscene3' then
		playAnim('intro3', 'idle');
	end
	if tag == 'cutscene4' then
		playAnim('intro4', 'idle');
	end
end

local staty = 1

function stageType(part)
	if part == 0 then
		statey = 0
		--Reverting all of this stuff because it might be jank later hueh
		scaleObject('boyfriend', 1, 1)
		characterDance('boyfriend');
		setScrollFactor('boyfriend', 1, 1);
		scaleObject('dad', 1, 1)
		characterDance('dad');
		scaleObject('gf', 1, 1)
		characterDance('gf');
	end
	if part == 1 then
		statey = 1
		triggerEvent('Note Camera Movement', 5,'')
		scaleObject('boyfriend', 2, 2)
		characterDance('boyfriend');
		setScrollFactor('boyfriend', 1.3, 1.1);
		scaleObject('dad', 0.9, 0.9)
		characterDance('dad');
		scaleObject('gf', 0.85, 0.85)
		characterDance('gf');
	end
	if part == 2 then
		statey = 2
		setProperty('extraChar.alpha', 1);
		scaleObject('boyfriend', 1, 1)
		characterDance('boyfriend');
		setScrollFactor('boyfriend', 1, 1);
		scaleObject('dad', 1, 1)
		characterDance('dad');
		scaleObject('gf', 1, 1)
		characterDance('gf');
		setProperty('gf.alpha', 0.001);
		setProperty('boyfriend.alpha', 0.001);
		setProperty('defaultCamZoom', 0.9);
		triggerEvent('Change Character','dad','tangy-rave');
		setProperty('dad.x', -400);
		setProperty('camZooming', true)
		setProperty('dad.danceEveryNumBeats', 1)
		triggerEvent('Note Camera Movement', 12,'')
		runHaxeCode([[
			game.cameraBoundaries = null;
			game.opponentCameraOffset = [0, 0];
		]]);
	end
	if part == 3 then
		statey = 3
		triggerEvent('Change Character','dad','tangy-rave-ending');
		triggerEvent('Change Character','boyfriend','sour-ending-LW');
		triggerEvent('Note Camera Movement', 5,'')
		setProperty('defaultCamZoom', 0.9);
		scaleObject('boyfriend', 1, 1)
		characterDance('boyfriend');
		setScrollFactor('boyfriend', 1, 1);
		setProperty('boyfriend.alpha', 1);
		scaleObject('dad', 1, 1)
		setScrollFactor('dad', 1, 1);
		characterDance('dad');
		scaleObject('gf', 1, 1)
		characterDance('gf');
		setProperty('gf.alpha', 0.001);
		setProperty('leftygrabbed.alpha', 1);
		setProperty('extraChar.alpha', 0.001);
		runHaxeCode([[
			game.cameraBoundaries = null;
			game.boyfriendCameraOffset = [-100, 100];
			game.opponentCameraOffset = [0, -100];
		]]);
	end
end

function onMoveCamera(focus)
	if statey == 1 then
		if focus == 'gf' or focus == 'dad' then
			setProperty('defaultCamZoom', 1.45);
		elseif focus == 'extra' or focus == 'boyfriend' then
			setProperty('defaultCamZoom', 0.6);
		end
	end
	if statey == 1 and newstime then
		if focus == 'gf' or focus == 'dad' then
			doTweenColor('building-cool', 'building-cool', 'ffa118', '0.4', 'linear')
			doTweenColor('backcity-cool', 'backcity-cool', '9d05d1', '0.8', 'linear')
			doTweenColor('Sky-cool', 'Sky-cool', '9d05d1', '1', 'linear')
			doTweenColor('front-cool', 'front-cool', '4df916', '0.2', 'linear')
		elseif focus == 'extra' or focus == 'boyfriend' then
			doTweenColor('building-cool', 'building-cool', '00f5be', '0.8', 'linear')
			doTweenColor('backcity-cool', 'backcity-cool', '09d2ff', '0.4', 'linear')
			doTweenColor('Sky-cool', 'Sky-cool', '1c29cc ', '0.2', 'linear')
			doTweenColor('front-cool', 'front-cool', 'e3fe37', '1', 'linear')
		end
	end
	if statey == 2 and not getProperty('isCameraOnForcedPos') then
		cameraSetTarget('dad');
	end
end

local newsBeatSpeed = 2

function onBeatHit()
	if curBeat % newsBeatSpeed == 0 then
		playAnim('backcitylights', 'idle');
		playAnim('buildinglights', 'idle');
		if danced then
			danced = false;
			playAnim('news', 'paper1');
		else
			danced = true;
			playAnim('news', 'paper2');
		end
	end
end