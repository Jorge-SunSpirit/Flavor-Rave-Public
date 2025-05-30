local tbdcheer = false;
local portalwarning = false;

function onCreatePost()
	setProperty('ratingCharNote', true);
	setProperty('healthCharNote', true);
	setProperty('noteSkinCharNote', true);
end

function onCreate()
	addHaxeLibrary('FlxBackdrop', 'flixel.addons.display');
	
	makeAnimatedLuaSprite('showsmans', 'characters/showman', 850, -100);
	addAnimationByPrefix('showsmans', 'idle', 'ShowmanIdle ', 24, false);
	setScrollFactor('showsmans', 1, 1);
	scaleObject('showsmans', 1, 1);
	addLuaSprite('showsmans', false);
	
	makeAnimatedLuaSprite('endartsa', 'stages/taw-extras/EndArt', 0, 0);
	addAnimationByPrefix('endartsa', 'sour', 'EndAnim0000', 24, false);
	addAnimationByPrefix('endartsa', 'sweeb', 'EndAnim0001', 24, false);
	addAnimationByPrefix('endartsa', 'bf', 'EndAnim0002', 24, false);
	addAnimationByPrefix('endartsa', 'gf', 'EndAnim0003', 24, false);
	setScrollFactor('endartsa', 0, 0);
	scaleObject('endartsa', 1, 1);
	addLuaSprite('endartsa', false);
	setProperty('endartsa.alpha', 0.0001);
	setBlendMode('endartsa', 'add');
	screenCenter('endartsa');

	makeLuaSprite('coolpattern', 'stages/taw-extras/sampler/overlay', 0, 0);
	setScrollFactor('coolpattern', 0, 0);
	addLuaSprite('coolpattern', false);
	setObjectCamera('coolpattern', 'effect');
	setBlendMode('coolpattern', 'add')
	setProperty('coolpattern.alpha', 0.0001);

	makeLuaSprite('WeekendBG', 'stages/taw-extras/sampler/weekend', -250, -0);
	setScrollFactor('WeekendBG', 0, 0);
	scaleObject('WeekendBG', 1.5, 1.5);
	addLuaSprite('WeekendBG', false);
	setProperty('WeekendBG.alpha', 0.0001);
	setObjectCamera('WeekendBG', 'effect');
	
	makeLuaSprite('StageBG', 'stages/taw-extras/sampler/stage', 0, 45);
	setScrollFactor('StageBG', 0, 0);
	scaleObject('StageBG', 1.1, 1.1);
	addLuaSprite('StageBG', false);
	setProperty('StageBG.alpha', 0.0001);
	setObjectCamera('StageBG', 'effect');

	makeAnimatedLuaSprite('ShowmanBow', 'stages/taw-extras/ShowmanBow', -100, -50);
	addAnimationByPrefix('ShowmanBow', 'idle', 'ShowmanBow', 24, false);
	setScrollFactor('ShowmanBow', 0, 0);
	scaleObject('ShowmanBow', 1.1, 1.1);
	addLuaSprite('ShowmanBow', false);
	setObjectCamera('ShowmanBow', 'effect')
	setProperty('ShowmanBow.alpha', 0.0001);

	makeLuaSprite('intrograffiti', 'dreamcast/art_BG/z4', -0, -0);
	setScrollFactor('intrograffiti', 0, 0);
	scaleObject('intrograffiti', 1, 1);
	addLuaSprite('intrograffiti', false);
	setObjectCamera('intrograffiti', 'effect');

	makeAnimatedLuaSprite('Portal', 'stages/taw-extras/Portal', 0, 0);
	addAnimationByPrefix('Portal', 'idle', 'PortalIdle', 24, true);
	playAnim('Portal', 'idle');
	setScrollFactor('Portal', 0, 0);
	scaleObject('Portal', 1.3, 1.3);
	addLuaSprite('Portal', false);
    screenCenter('Portal');
	setObjectCamera('Portal', 'effect')

	makeLuaSprite('SampleBGZoom', 'stages/taw-extras/sampler/sky-cool', -0, -0);
	setScrollFactor('SampleBGZoom', 0.2, 0.2);
	scaleObject('SampleBGZoom', 1.3, 1.3);
	addLuaSprite('SampleBGZoom', false);
    screenCenter('SampleBGZoom');
	setProperty('SampleBGZoom.alpha', 0.0001);

	makeLuaSprite('SampleBG', 'stages/taw-extras/sampler/sky-cool', -0, -0);
	setScrollFactor('SampleBG', 0, 0);
	scaleObject('SampleBG', 1.1, 1.1);
	addLuaSprite('SampleBG', false);
	setProperty('SampleBG.alpha', 0.0001);
	setObjectCamera('SampleBG', 'effect');

	makeLuaSprite('disk', 'stages/taw-extras/sampler/disk', -0, 1000);
	setScrollFactor('disk', 0, 0);
	addLuaSprite('disk', false);
	setProperty('disk.alpha', 0.0001);
	setBlendMode('disk', 'add')
	setObjectCamera('disk', 'effect');
    screenCenter('disk');
	
	makeLuaSprite('CrowdBack', 'stages/taw-extras/sampler/CrowdBack', -0, 750);
	setScrollFactor('CrowdBack', 0, 0);
	scaleObject('CrowdBack', 1, 1);
	addLuaSprite('CrowdBack', false);
	setProperty('CrowdBack.alpha', 0.0001);
	setObjectCamera('CrowdBack', 'effect');
	
	makeLuaSprite('CrowdMiddle', 'stages/taw-extras/sampler/CrowdMiddle', -0, 750);
	setScrollFactor('CrowdMiddle', 0, 0);
	scaleObject('CrowdMiddle', 1, 1);
	addLuaSprite('CrowdMiddle', false);
	setProperty('CrowdMiddle.alpha', 0.0001);
	setObjectCamera('CrowdMiddle', 'effect');

	makeLuaSprite('PortalBorderBottom', 'stages/taw-extras/sampler/bottomborder', 0, 822);
	setScrollFactor('PortalBorderBottom', 0, 0);
	scaleObject('PortalBorderBottom', 1, 1);
	addLuaSprite('PortalBorderBottom', false);
	setObjectCamera('PortalBorderBottom', 'effect');
	setProperty('PortalBorderBottom.alpha', 0.0001);

	makeAnimatedLuaSprite('PhillyPortal', 'stages/taw-extras/sampler/PortalTime', 0, 0);
	addAnimationByPrefix('PhillyPortal', 'idle', 'PortalTime', 24, false);
	setScrollFactor('PhillyPortal', 0, 0);
	addLuaSprite('PhillyPortal', false);
    screenCenter('PhillyPortal');
	setObjectCamera('PhillyPortal', 'effect')
	setProperty('PhillyPortal.alpha', 0.0001);

	makeAnimatedLuaSprite('TBDtan', 'stages/taw-extras/sampler/TBDtan', 0, 750);
	addAnimationByPrefix('TBDtan', 'Cheer', 'Cheer', 24, false);
	addAnimationByPrefix('TBDtan', 'Shock', 'Shock', 24, false);
	setScrollFactor('TBDtan', 0, 0);
	addLuaSprite('TBDtan', false);
    screenCenter('TBDtan');
	setObjectCamera('TBDtan', 'effect')
	setProperty('TBDtan.alpha', 0.0001);
	
	makeLuaSprite('CrowdFront', 'stages/taw-extras/sampler/CrowdFront', -0, 750);
	setScrollFactor('CrowdFront', 0, 0);
	scaleObject('CrowdFront', 1, 1);
	addLuaSprite('CrowdFront', false);
	setProperty('CrowdFront.alpha', 0.0001);
	setObjectCamera('CrowdFront', 'effect');

	makeLuaSprite('phillygirder', 'stages/taw-extras/sampler/girders', -0, -0);
	setScrollFactor('phillygirder', 0, 0);
	scaleObject('phillygirder', 1, 1);
	addLuaSprite('phillygirder', false);
	setProperty('phillygirder.alpha', 0.0001);
	setObjectCamera('phillygirder', 'effect');
	
	makeLuaSprite('phillystreet', 'stages/taw-extras/sampler/street', -0, -0);
	setScrollFactor('phillystreet', 0, 0);
	scaleObject('phillystreet', 1, 1);
	addLuaSprite('phillystreet', false);
	setProperty('phillystreet.alpha', 0.0001);
	setObjectCamera('phillystreet', 'effect');

	runHaxeCode([[
		var city1:FlxBackdrop = new FlxBackdrop(Paths.image('stages/taw-extras/sampler/SpitBuilds1'), 0x11);
		city1.antialiasing = ClientPrefs.globalAntialiasing;
		game.insert(game.members.indexOf(game.getLuaObject('SampleBG')) + 1, city1);
		setVar('city1', city1);
		
		var phillytrain:FlxBackdrop = new FlxBackdrop(Paths.image('stages/taw-extras/sampler/train'), 0x11);
		phillytrain.antialiasing = ClientPrefs.globalAntialiasing;
		game.insert(game.members.indexOf(game.getLuaObject('phillygirder')) + 1, phillytrain);
		setVar('phillytrain', phillytrain);
	]]);

	setObjectCamera('city1', 'effect');
	setProperty('city1.velocity.x', -70);
	setProperty('city1.alpha', 0.0001);

	setObjectCamera('phillytrain', 'effect');
	setProperty('phillytrain.velocity.x', 170);
	setProperty('phillytrain.alpha', 0.0001);

	makeLuaSprite('Border', 'stages/taw-extras/sampler/border', -0, -0);
	setScrollFactor('Border', 0, 0);
	scaleObject('Border', 1, 1);
	addLuaSprite('Border', false);
    screenCenter('Border');
	setProperty('Border.alpha', 0.0001);
	setObjectCamera('Border', 'effect');
	
	makeAnimatedLuaSprite('SourFunky', 'stages/taw-extras/sampler/SourFunky', 0, 0);
	addAnimationByPrefix('SourFunky', 'idle', 'SourFunky', 24, false);
	setScrollFactor('SourFunky', 0, 0);
	addLuaSprite('SourFunky', false);
    screenCenter('SourFunky');
	setObjectCamera('SourFunky', 'effect')
	setProperty('SourFunky.alpha', 0.0001);
	
	makeAnimatedLuaSprite('PhillyGang', 'stages/taw-extras/sampler/PhillyGang', 0, 0);
	addAnimationByPrefix('PhillyGang', 'idle', 'PhillyGang', 24, false);
	setScrollFactor('PhillyGang', 0, 0);
	scaleObject('PhillyGang', 0.92, 0.92);
	addLuaSprite('PhillyGang', false);
    screenCenter('PhillyGang');
	setObjectCamera('PhillyGang', 'effect')
	setProperty('PhillyGang.alpha', 0.0001);
	
	makeAnimatedLuaSprite('SweetSampler', 'stages/taw-extras/sampler/Sweet', 0, 0);
	addAnimationByPrefix('SweetSampler', 'idle', 'sweet dance', 24, true);
	setScrollFactor('SweetSampler', 0, 0);
	addLuaSprite('SweetSampler', false);
    screenCenter('SweetSampler');
	setObjectCamera('SweetSampler', 'effect')
	setProperty('SweetSampler.alpha', 0.0001);
	
	makeAnimatedLuaSprite('SaucySampler', 'stages/taw-extras/sampler/Saucy', 0, 0);
	addAnimationByPrefix('SaucySampler', 'idle', 'gf', 24, true);
	setScrollFactor('SaucySampler', 0, 0);
	addLuaSprite('SaucySampler', false);
    screenCenter('SaucySampler');
	setObjectCamera('SaucySampler', 'effect')
	setProperty('SaucySampler.alpha', 0.0001);

	makeLuaSprite('whitehueh', 'dreamcast/art_BG/whitehueh', 0, 0);
	setScrollFactor('whitehueh', 0, 0);
	addLuaSprite('whitehueh', true);
	setObjectCamera('whitehueh', 'effect');
	setProperty('whitehueh.alpha', 0.0001);

	makeLuaSprite('PortalBorderTop', 'stages/taw-extras/sampler/topborder', 0, -302);
	setScrollFactor('PortalBorderTop', 0, 0);
	scaleObject('PortalBorderTop', 1, 1);
	addLuaSprite('PortalBorderTop', true);
	setObjectCamera('PortalBorderTop', 'effect');
	setProperty('PortalBorderTop.alpha', 0.0001);

	makeLuaSprite('warn', 'stages/taw-extras/warning', -0, -0);
	setScrollFactor('warn', 0, 0);
	scaleObject('warn', 1, 1);
	addLuaSprite('warn', true);
    screenCenter('warn');
	setProperty('warn.alpha', 0.0001);
	setObjectCamera('warn', 'effect');
	
	makeLuaSprite('portalwarn', 'stages/taw-extras/portalwarning', -0, -0);
	setScrollFactor('portalwarn', 0, 0);
	scaleObject('portalwarn', 1, 1);
	addLuaSprite('portalwarn', true);
    screenCenter('portalwarn');
	setProperty('portalwarn.alpha', 0.0001);
	setObjectCamera('portalwarn', 'effect');

	makeLuaSprite('barTop', 'closeup/TightBars', 0, -132);
	setScrollFactor('barTop', 0, 0);
	scaleObject('barTop', 1.1, 1.1);
	addLuaSprite('barTop', true);
	setObjectCamera('barTop', 'effect');

	makeLuaSprite('barBottom', 'closeup/TightBars', 0, 852);
	setScrollFactor('barBottom', 0, 0);
	scaleObject('barBottom', 1.1, 1.1);
	addLuaSprite('barBottom', true);
	setObjectCamera('barBottom', 'effect');

	makeLuaSprite('TAWtitle', 'stages/taw-extras/sampler/text/title', -580, 13);
	setScrollFactor('TAWtitle', 0, 0);
	scaleObject('TAWtitle', 1, 1);
	addLuaSprite('TAWtitle', true);
	setProperty('TAWtitle.alpha', 0.0001);
	setObjectCamera('TAWtitle', 'effect');
	
	makeLuaSprite('TBDTitle', 'stages/taw-extras/sampler/text/tbd', 1282, 626);
	setScrollFactor('TBDTitle', 0, 0);
	scaleObject('TBDTitle', 1, 1);
	addLuaSprite('TBDTitle', true);
	setProperty('TBDTitle.alpha', 0.0001);
	setObjectCamera('TBDTitle', 'effect');
	
	makeLuaSprite('2hot1', 'stages/taw-extras/sampler/text/philly-2hot', 666, 18);
	setScrollFactor('2hot1', 0, 0);
	scaleObject('2hot1', 1, 1);
	addLuaSprite('2hot1', true);
	setProperty('2hot1.alpha', 0.0001);
	setObjectCamera('2hot1', 'effect');
	
	makeLuaSprite('2hot2', 'stages/taw-extras/sampler/text/enzync-2hot', 666, 18);
	setScrollFactor('2hot2', 0, 0);
	scaleObject('2hot2', 1, 1);
	addLuaSprite('2hot2', true);
	setProperty('2hot2.alpha', 0.0001);
	setObjectCamera('2hot2', 'effect');
	
	makeLuaSprite('meanwhile', 'stages/taw-extras/sampler/text/meanwhile', 1282, 628);
	setScrollFactor('meanwhile', 0, 0);
	scaleObject('meanwhile', 1, 1);
	addLuaSprite('meanwhile', true);
	setProperty('meanwhile.alpha', 0.0001);
	setObjectCamera('meanwhile', 'effect');

	makeLuaSprite('black', '', -100, -100);
    makeGraphic('black', 1280*2, 720*2, '000000');
    setScrollFactor('black', 0, 0);
    screenCenter('black');
	setObjectCamera('black', 'effect')
	addLuaSprite('black', true);
	
	makeLuaSprite('endart', 'gallery/images/taw', -0, 0);
	setScrollFactor('endart', 0, 0);
	addLuaSprite('endart', true);
	scaleObject('endart', 3, 3);
	setProperty('endart.alpha', 0.0001);
	setObjectCamera('endart', 'effect');
    screenCenter('endart');
end

function sampler(num)
	if num == '1' then
		playAnim('SourFunky', 'idle');
		doTweenX('diskX', 'disk', 32, 1, "circinout");
		doTweenAlpha('city1', 'city1', 1, 0.2, "circinout");
		doTweenAlpha('phillygirder', 'phillygirder', 0.0001, 0.2, "circinout");
		doTweenAlpha('phillystreet', 'phillystreet', 0.0001, 0.2, "circinout");
		doTweenAlpha('phillytrain', 'phillytrain', 0.0001, 0.2, "circinout");
		doTweenColor('SampleBG', 'SampleBG', '6363FD', '0.2', 'linear');
		doTweenX('BorderX', 'Border', 1030, 0.1, "circinout");
		doTweenX('SourFunkyX', 'SourFunky', 750, 0.2, "circinout");
		doTweenX('SweetSamplerX', 'SweetSampler', 250, 0.2, "circinout");
		doTweenX('SaucySampler', 'SaucySampler', 1550, 0.2, "circinout");
	end
	if num == '2' then
		playAnim('SourFunky', 'idle');
		doTweenX('diskX', 'disk', -548, 1, "circinout");
		doTweenAlpha('city1', 'city1', 0.0001, 0.2, "circinout");
		doTweenAlpha('phillygirder', 'phillygirder', 1, 0.2, "circinout");
		doTweenAlpha('phillystreet', 'phillystreet', 1, 0.2, "circinout");
		doTweenAlpha('phillytrain', 'phillytrain', 1, 0.2, "circinout");
		doTweenColor('SampleBG', 'SampleBG', 'FF91D3', '0.2', 'linear');
		doTweenX('BorderX', 'Border', -0, 0.1, "circinout");
		doTweenX('SourFunkyX', 'SourFunky', -950, 0.2, "circinout");
		doTweenX('SweetSamplerX', 'SweetSampler', -950, 0.2, "circinout");
		doTweenX('SaucySampler', 'SaucySampler', 750, 0.2, "circinout");
	end
end

function thingie(num)
	num = tonumber(num)
	if num == 2 then
		doTweenY('diskY', 'disk', 1000, 1, "quadInOut");
		doTweenY('PortalY', 'Portal', 100, 0.001);
		setProperty('camFollow.x', 1462);
		setProperty('camFollow.y', -350);
		setProperty('isCameraOnForcedPos', true);
		doTweenAlpha('black', 'black', 0.0001, 1);
	end
	if num == 20 then
		doTweenX('intrograffitiScaleX', 'intrograffiti.scale', 4.7, 1.7, 'quadinout');
		doTweenY('intrograffitiScaleY', 'intrograffiti.scale', 4.7, 1.7, 'quadinout');
		doTweenX('PortalScaleX', 'Portal.scale', 5.2, 1.6, 'quadinout');
		doTweenY('PortalScaleY', 'Portal.scale', 5.2, 1.6, 'quadinout');
	end
	if num == 30 then
		doTweenAlpha('Portal', 'Portal', 0.0001, 1.2);
		doTweenAlpha('intrograffiti', 'intrograffiti', 0.0001, 0.3);
		doTweenY('moveCam', 'camFollow', 450, 1.7);
	end
	if num == 48 then
		setProperty('isCameraOnForcedPos', false);
	end
	if num == 512 then
		doTweenX('SampleBGZoomX', 'SampleBGZoom', -20, 14);
		doTweenY('ShowmanBowY', 'ShowmanBow', 0, 0.2, "quadinout");
		doTweenY('StageBGY', 'StageBG', 100, 0.2, "quadinout");
		setProperty('extraChar.alpha', 0.0001);
		setProperty('dramablack.alpha', 0.7);
		scaleObject('intrograffiti', 1, 1);
		scaleObject('Portal', 1.3, 1.3);
		setProperty('SampleBGZoom.alpha', 1);
	end
	if num == 560 then
		doTweenAlpha('whitehueh', 'whitehueh', 1, 2, "quadinout");
	end
	if num == 576 then
		doTweenY('barTop', 'barTop', 0, 0.5, "quadinout");
		doTweenY('barBottom', 'barBottom', 608, 0.5, "quadinout");
		doTweenY('ShowmanBowY', 'ShowmanBow', -50, 1.8, "quadinout");
		doTweenY('StageBGY', 'StageBG', 75, 1.8, "quadinout");
		setProperty('dramablack.alpha', 0.0001);
		setProperty('SampleBGZoom.alpha', 0.0001);
		playAnim('ShowmanBow', 'idle');
		doTweenAlpha('whitehueh', 'whitehueh', 0.0001, 1, "quadinout");
		setProperty('ShowmanBow.alpha', 1);
		setProperty('StageBG.alpha', 1);
	end
	if num == 592 then
		setProperty('extraChar.alpha', 1);
		setProperty('ShowmanBow.alpha', 0.0001);
		setProperty('StageBG.alpha', 0.0001);
		doTweenY('barTop', 'barTop', -132, 0.3, "quadinout");
		doTweenY('barBottom', 'barBottom', 822, 0.3, "quadinout");	
		setProperty('showsmans.alpha', 0.0001);
		callOnLuas('changeStage', {'1'})
	end
	if num == 720 then
		barY = 1280;
        if downscroll then    barY = -200;    end
		doTweenY("flavorBar", "flavorHUD", barY, 0.8, "circinout")
		doTweenY('SweetSamplerY', 'SweetSampler', 150, 0.2);
		doTweenY('SaucySamplerY', 'SaucySampler', 150, 0.2);
		doTweenX('SweetSamplerX', 'SweetSampler', -950, 0.2);
		doTweenX('SaucySamplerX', 'SaucySampler', 1550, 0.2);
		doTweenX('SourFunkyX', 'SourFunky', -150, 0.2);
		setProperty('SourFunky.color', 0x00000000);
		doTweenY('barTop', 'barTop', 0, 0.2, "quadinout");
		doTweenY('barBottom', 'barBottom', 608, 0.2, "quadinout");
		setProperty('black.alpha', 1);
	end
	if num == 724 then
		setProperty('black.alpha', 0.0001);
		setProperty('disk.alpha', 1);
		doTweenY('diskY', 'disk', 100, 1, "quadInOut");
		doTweenAngle('disk', 'disk', 1080, 30)
		setProperty('SampleBG.alpha', 1);
	end
	if num == 732 then
		setProperty('Border.alpha', 1);
		setProperty('SourFunky.alpha', 1);
		setProperty('SweetSampler.alpha', 1);
		setProperty('SaucySampler.alpha', 1);
	end
	if num == 736 then
		setProperty('SourFunky.color', 0xFFFFFF);
		setProperty('TAWtitle.alpha', 1);
		setProperty('TBDTitle.alpha', 1);
		doTweenX('TAWtitleX', 'TAWtitle', 35, 2, "quadinout");
		doTweenX('TBDTitleX', 'TBDTitle', 585, 2, "quadinout");
	end
	if num == 854 then
		doTweenX('TAWtitleX', 'TAWtitle', -580, 1.2, "quadinout");
		doTweenX('TBDTitleX', 'TBDTitle', 1282, 1.2, "quadinout");
	end
	if num == 864 then
		setProperty('TAWtitle.alpha', 0.0001);
		setProperty('TBDTitle.alpha', 0.0001);
		setProperty('meanwhile.alpha', 1);
		doTweenAlpha('2hot1', '2hot1', 1, 1.3);
		setProperty('disk.alpha', 0.0001);
		setProperty('Border.alpha', 0.0001);
		setProperty('SourFunky.alpha', 0.0001);
		setProperty('SweetSampler.alpha', 0.0001);
		setProperty('SaucySampler.alpha', 0.0001);
		setProperty('SampleBG.alpha', 0.0001);
		setProperty('phillygirder.alpha', 0.0001);
		setProperty('phillytrain.alpha', 0.0001);
		setProperty('phillystreet.alpha', 0.0001);
		setProperty('black.alpha', 1);
	end
	if num == 866 then
		doTweenX('meanwhileX', 'meanwhile', 26, 1, "quadinout");
		setProperty('camFollow.x', 690);
		setProperty('camFollow.y', 400);
		setProperty('isCameraOnForcedPos', true);
		setProperty('WeekendBG.alpha', 1);
		doTweenAlpha('black', 'black', 0.0001, 1.3);
		doTweenX('WeekendBGX', 'WeekendBG', 250, 10);
	end
	if num == 884 then
		doTweenAlpha('intrograffiti', 'intrograffiti', 1, 0.7);
		doTweenAlpha('Portal', 'Portal', 1, 0.65);
	end
	if num == 896 then
		setProperty('PhillyGang.alpha', 1);
		playAnim('PhillyGang', 'idle');
	end
	if num == 918 then
		setProperty('samplegradient.alpha', 0.0001);
		doTweenX('intrograffitiScaleX', 'intrograffiti.scale', 1.1, 0.5, 'quadinout');
		doTweenY('intrograffitiScaleY', 'intrograffiti.scale', 1.1, 0.5, 'quadinout');
		doTweenX('PortalScaleX', 'Portal.scale', 1.3, 0.5, 'quadinout');
		doTweenY('PortalScaleY', 'Portal.scale', 1.3, 0.5, 'quadinout');
		doTweenX('PhillyGangX', 'PhillyGang.scale', 1.2, 0.5, 'quadinout');
		doTweenY('PhillyGangY', 'PhillyGang.scale', 1.2, 0.5, 'quadinout');
	end
	if num == 928 then
		doTweenAlpha('2hot2', '2hot2', 1, 0.6);
		doTweenAlpha('2hot1', '2hot1', 0.0001, 0.6);
		doTweenY('TBDtanY', 'TBDtan', 750, 0.2, "circinout");
		doTweenX('StageBGX', 'StageBG', -100, 10);
		setProperty('StageBG.alpha', 1);
		setProperty('WeekendBG.alpha', 0.0001);
		setProperty('PhillyGang.alpha', 0.0001);
		setProperty('Portal.alpha', 0.0001);
		setProperty('intrograffiti.alpha', 0.0001);
	end
	if num == 950 then
		doTweenX('meanwhileX', 'meanwhile', -650, 1, "quadinout");
		doTweenAlpha('2hot2', '2hot2', 0.0001, 1);
		doTweenAlpha('samplegradient', 'samplegradient', 0.0001, 1);
		doTweenX('StageBGScaleX', 'StageBG.scale', 2.5, 1.5, 'quadinout');
		doTweenY('StageBGScaleY', 'StageBG.scale', 2.5, 1.5, 'quadinout');	
	end
	if num == 955 then
		tbdcheer = true;
		setProperty('CrowdFront.alpha', 1);
		setProperty('CrowdMiddle.alpha', 1);
		setProperty('CrowdBack.alpha', 1);
		setProperty('TBDtan.alpha', 1);
		doTweenY('CrowdBackY', 'CrowdBack', 0, 1, "quadinout");
		doTweenY('CrowdMiddleY', 'CrowdMiddle', 0, 2, "quadinout");
		doTweenY('TBDtanY', 'TBDtan', 0, 2, "quadinout");
		doTweenY('CrowdFrontY', 'CrowdFront', 0, 2.5, "quadinout");
		doTweenAlpha('SampleBG', 'SampleBG', 1, 0.7);
	end
	if num == 984 then
		setProperty('StageBG.alpha', 0.0001);
		doTweenY('CrowdBackY', 'CrowdBack', 720, 1, "quadinout");
		doTweenY('CrowdMiddleY', 'CrowdMiddle', 720, 0.6, "quadinout");
		doTweenY('TBDtanY', 'TBDtan', 720, 0.6, "quadinout");
		doTweenY('CrowdFrontY', 'CrowdFront', 720, 0.3, "quadinout");
	end
	if num == 992 then
		tbdcheer = false;
		setProperty('coolpattern.alpha', 0.65);
		doTweenAlpha('SampleBG', 'SampleBG', 0.0001, 0.5);
		setProperty('CrowdFront.alpha', 0.0001);
		setProperty('CrowdMiddle.alpha', 0.0001);
		setProperty('CrowdBack.alpha', 0.0001);
		setProperty('TBDtan.alpha', 0.0001);
		doTweenY('moveCam', 'camFollow', -550, 4, "quadinout");
		setProperty('WeekendBG.alpha', 0.0001);
		setProperty('black.alpha', 0.0001);
		doTweenY('barTop', 'barTop', -132, 0.6, "quadinout");
		doTweenY('barBottom', 'barBottom', 822, 0.6, "quadinout");
	end
	if num == 1023 then
		portalwarning = true;
	end
	if num == 1024 then
		doTweenY('PortalBorderTopY', 'PortalBorderTop', 0, 0.4, "quadinout");
		doTweenY('PortalBorderBottomY', 'PortalBorderBottom', 0, 0.4, "quadinout");
		setProperty('PhillyPortal.alpha', 1);
		setProperty('PortalBorderBottom.alpha', 1);
		setProperty('PortalBorderTop.alpha', 1);
		playAnim('PhillyPortal', 'idle');
	end
	if num == 1052 then
		portalwarning = false;
		setProperty('TBDtan.alpha', 1);
		playAnim('TBDtan', 'Shock');
		doTweenY('TBDtanY', 'TBDtan', 220, 0.25, "quadinout");
	end
	if num == 1060 then
		barYeee = 626.4;
		if downscroll then	barYeee = 38.4;	end
		doTweenY("flavorBar", "flavorHUD", barYeee, 0.8, "circinout")
		setProperty('camFollow.x', -300);
		setProperty('camFollow.y', 400);
		doTweenX('moveCam', 'camFollow', 1500, 15, "quadinout");
		setProperty('coolpattern.alpha', 0.0001);
		setProperty('PhillyPortal.alpha', 0.0001);
		setProperty('PortalBorderTop.alpha', 0.0001);
		setProperty('PortalBorderBottom.alpha', 0.0001);
		setProperty('TBDtan.alpha', 0.0001);
		setProperty('flambe.alpha', 1);
		setProperty('picante.alpha', 1);
		setProperty('neo.alpha', 1);
		doTweenAngle('endartangle', 'endart', 10, 0.7, "quadinout")
	end
	if num == 1184 then
		setProperty('isCameraOnForcedPos', false);
	end
	if num == 1312 then
		doTweenX('SampleBGZoomX', 'SampleBGZoom', 20, 20);
		setObjectOrder('gfGroup', getObjectOrder('SampleBGZoom')+1);
		setObjectOrder('extraGroup', getObjectOrder('SampleBGZoom')+1);
		setProperty('flambe.alpha', 0.0001);
		setProperty('picante.alpha', 0.0001);
		setProperty('neo.alpha', 0.0001);
		doTweenX('SampleBGZoomX', 'SampleBGZoom', -40, 14);
		setProperty('SampleBGZoom.alpha', 1);
		
		setProperty('isCameraOnForcedPos', true);
		cameraSetTarget('dad');
		setProperty('boyfriend.alpha', 0.0001);
		setProperty('extraChar.alpha', 0.0001);
		setProperty('gf.alpha', 0.0001);
		setObjectOrder('endartsa', getObjectOrder('dadGroup')-1);
		playAnim('endartsa', 'sour');
		doTweenAlpha('endartsa', 'endartsa', 1, 0.25, "circinout");
	end
	if num == 1348 then
		cameraSetTarget('gf');
		setProperty('gf.alpha', 1);
		setProperty('dad.alpha', 0.0001);
		setObjectOrder('endartsa', getObjectOrder('gfGroup')-1);
		playAnim('endartsa', 'sweeb');
	end
	if num == 1376 then
		cameraSetTarget('bf');
		setProperty('gf.alpha', 0.0001);
		setProperty('boyfriend.alpha', 1);
		setObjectOrder('endartsa', getObjectOrder('boyfriendGroup')-1);
		playAnim('endartsa', 'bf');
	end
	if num == 1408 then
		cameraSetTarget('extra');
		setProperty('boyfriend.alpha', 0.0001);
		setProperty('extraChar.alpha', 1);
		setObjectOrder('endartsa', getObjectOrder('extraGroup')-1);
		playAnim('endartsa', 'gf');
	end
	if num == 1424 then
		setProperty('gf.alpha', 1);
		setProperty('bf.alpha', 1);
		setProperty('extraChar.alpha', 1);
		setProperty('dad.alpha', 1);
		setObjectOrder('gfGroup', getObjectOrder('extraplat')-1);
		setObjectOrder('extraGroup', getObjectOrder('extraplat')-1);
		setProperty('SampleBGZoom.alpha', 0.0001);
		setProperty('camFollow.x', 690);
		setProperty('camFollow.y', 400);
		setProperty('boyfriend.alpha', 1);
		setProperty('endartsa.alpha', 0.001);
		setProperty('flambe.alpha', 1);
		setProperty('picante.alpha', 1);
		setProperty('neo.alpha', 1);
	end
	if num == 1440 then
		setProperty('camHUD.alpha', 0.0001);
		setProperty('endart.alpha', 1);
		doTweenAngle('endartangle', 'endart', -5, 0.7, "quadinout")
		doTweenX('endartX', 'endart.scale', 0.6, 0.3, 'quadinout');
		doTweenY('endartY', 'endart.scale', 0.6, 0.3, 'quadinout');	
		setProperty('black.alpha', 1);
	end
end

function onBeatHit()
	if curBeat % 1 == 0 and tbdcheer then
		playAnim('TBDtan', 'Cheer');
	end
	if curBeat % 2 == 0 then
		if portalwarning then
			setProperty('warn.alpha', 1);
			setProperty('portalwarn.alpha', 1);
			doTweenAlpha('warn', 'warn', 0.0001, 0.7);
			doTweenAlpha('portalwarn', 'portalwarn', 0.0001, 1.2);
		end
		playAnim('showsmans', 'idle');
	end
end