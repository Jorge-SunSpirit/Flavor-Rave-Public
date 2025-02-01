local piratetime = false;
local safftime = false;
local crewbop = true;

function onCreate()
	posX = -0;
	posY = -0;
	scale = 1;

	makeLuaSprite('cutBG', 'stages/lady-morton/CutsceneBG', -250, 1250);
	setScrollFactor('cutBG', 0, 0);
	scaleObject('cutBG', 1.1, 1.1);
	addLuaSprite('cutBG', false);
	setProperty('cutBG.alpha', 0.0001);
	setObjectCamera('cutBG', 'effect');
	
	makeAnimatedLuaSprite('cutArt', 'stages/lady-morton/LSCutscene', posX, posY);
	addAnimationByPrefix('cutArt', 'idle', 'LSCutscene', 24, false);
	setScrollFactor('cutArt', 0, 0);
	addLuaSprite('cutArt', false);
    screenCenter('cutArt');
	setObjectCamera('cutArt', 'effect')
	setProperty('cutArt.alpha', 0.0001);
	
	makeAnimatedLuaSprite('cutText', 'stages/lady-morton/LSCutsceneText', posX, posY);
	addAnimationByPrefix('cutText', 'idle', 'LSCutsceneText', 24, false);
	setScrollFactor('cutText', 0, 0);
	addLuaSprite('cutText', false);
    screenCenter('cutText');
	setObjectCamera('cutText', 'effect')
	setProperty('cutText.alpha', 0.0001);
	
end


function onCreatePost()
	setProperty('countdownSuffix', '_LS');
	setProperty('camZoomingFreq', 24);

	setProperty('boyfriend.danceEveryNumBeats', 3);
	setProperty('dad.danceEveryNumBeats', 3);
	setProperty('gf.danceEveryNumBeats', 3);
	setProperty('extraChar.danceEveryNumBeats', 3);

	setProperty('flavorHUD.beatFrequency', 6);
	
	setProperty('isCameraOnForcedPos', true);
	setProperty('camFollow.x', 990);
	setProperty('camFollow.y', -2150);
	setProperty('camera.target.x', 990)
	setProperty('camera.target.y', -2150)
	
	makeLuaSprite('dramablack', '', -100, -100);
    makeGraphic('dramablack', 1280*2, 720*2, '000000');
    setScrollFactor('dramablack', 0, 0);
    screenCenter('dramablack');
    addLuaSprite('dramablack', true);
	
	if not middlescroll then
		noteTweenX('dad4', 0, -500, 0.01, "circinout")
		noteTweenX('dad5', 1, -500, 0.01, "circinout")
		noteTweenX('dad6', 2, -500, 0.01, "circinout")
		noteTweenX('dad7', 3, -500, 0.01, "circinout")
	end
end

function chants(num)
	if num == '1' then
		playAnim('adobo', 'hey');
		playAnim('sharp', 'hey');
	end
	if num == '2' then
		playAnim('adobo', 'wayho');
		playAnim('sharp', 'wayho');
	end
end

function onStepHit()
	--This is temporary. Do not keep this. We will be using callonLua event.
	--UTAH
	if curStep == 1 then
		playAnim('sharpstart', 'idle', true);
	end
	if curStep == 10 then
		doTweenAlpha('dramablack', 'dramablack', 0, 4);
	end
	if curStep == 97 then
		setProperty('sharpstart.alpha', 0.0001);
		doTweenY('moveCam', 'camFollow', 347, 6);
	end
	if curStep == 192 then
		setProperty('isCameraOnForcedPos', false);
		setProperty('defaultCamZoom', 1);
	end
	if curStep == 1312 then
		setProperty('cutBG.alpha', 1);
		doTweenY('cutBG', 'cutBG', -150, 2, "circinout");
	end
	if curStep == 1353 then
		doTweenX('cutBG', 'cutBG', -80, 20);
		doTweenAlpha('camHUD', 'camHUD', 0.0001, 0.5);
		playAnim('cutArt', 'idle');
		playAnim('cutText', 'idle');
		doTweenAlpha('cutArt', 'cutArt', 1, 1);
	end
	if curStep == 1356 then
		doTweenAlpha('cutText', 'cutText', 1, 1);
	end
	if curStep == 1390 then
		doTweenAlpha('cutArt', 'cutArt', 0.0001, 0.4);
		doTweenAlpha('cutText', 'cutText', 0.0001, 0.4);
	end
	if curStep == 1397 then
		doTweenAlpha('cutArt', 'cutArt', 1, 1.1);
	end
	if curStep == 1400 then
		doTweenAlpha('cutText', 'cutText', 1, 1.1);
	end
	if curStep == 1438 then
		doTweenAlpha('cutArt', 'cutArt', 0.0001, 0.4);
		doTweenAlpha('cutText', 'cutText', 0.0001, 0.4);
	end
	if curStep == 1447 then
		doTweenAlpha('cutArt', 'cutArt', 1, 1.1);
	end
	if curStep == 1450 then
		doTweenAlpha('cutText', 'cutText', 1, 1.1);
	end
	if curStep == 1496 then
		doTweenAlpha('cutArt', 'cutArt', 0.0001, 0.4);
		doTweenAlpha('cutText', 'cutText', 0.0001, 0.4);
	end
	if curStep == 1504 then
		doTweenAlpha('cutArt', 'cutArt', 1, 1.1);
	end
	if curStep == 1506 then
		doTweenAlpha('cutText', 'cutText', 1, 1.1);
	end
	if curStep == 1558 then
		doTweenAlpha('cutArt', 'cutArt', 0.0001, 0.4);
		doTweenAlpha('cutText', 'cutText', 0.0001, 0.4);
	end
	if curStep == 1566 then
		doTweenAlpha('cutArt', 'cutArt', 1, 1.1);
	end
	if curStep == 1569 then
		doTweenAlpha('cutText', 'cutText', 1, 1.1);
	end
	if curStep == 1607 then
		doTweenAlpha('camHUD', 'camHUD', 1, 2);
		doTweenAlpha('cutArt', 'cutArt', 0.0001, 1);
		doTweenAlpha('cutText', 'cutText', 0.0001, 1);
	end
	if curStep == 1624 then
		doTweenY('cutBG', 'cutBG', 1200, 1, "circinout");
	end
	if curStep == 2592 then
		crewbop = false
	end
	if curStep == 2800 then
		crewbop = true
		doTweenColor('sky', 'sky', 'f2bc79', '14', 'linear')
	end
	if curStep == 2817 then
		crewbop = false
		doTweenAlpha('skyafter', 'skyafter', 1, 8);
	end
	if curStep == 2973 then
	setProperty('isCameraOnForcedPos', true);
	setProperty('camFollow.x', 990);
	setProperty('camFollow.y', 850);
	setProperty('defaultCamZoom', 0.38);
	barY = 1280;
        if downscroll then    barY = -200;    end
		doTweenY("flavorBar", "flavorHUD", barY, 0.8, "circinout")
	end
	if curStep == 3000 then
		setProperty('flavorHUD.beatFrequency', 3);
		setProperty('camZoomingFreq', 12);
		doTweenY('trapdoor1', 'trapdoor1', -3200, 0.3);
		doTweenY('trapdoor2', 'trapdoor2', -3200, 0.3);
		playAnim('leftpir8', 'appear');
		playAnim('rightpir8', 'appear');
		playAnim('door', 'opens');
		setProperty('leftpir8.alpha', 1);
		setProperty('rightpir8.alpha', 1);
	end
	if curStep == 3012 then
		playAnim('midpir8', 'appear');
		setProperty('midpir8.alpha', 1);
	end
	if curStep == 3023 then
		piratetime = true
	end
	if curStep == 3045 then
		playAnim('saff', 'emerge');
	end
	if curStep == 3095 then
		safftime = true
	end
	if curStep == 3192 then
	setProperty('waves.alpha', 1);
	end
	if curStep == 3334 then
		setProperty('waves.alpha', 0.0001);
		setProperty('camZoomingFreq', 24);
		setProperty('flavorHUD.beatFrequency', 6);
		setProperty('isCameraOnForcedPos', false);
		crewbop = true
		
		barYeee = 626.4;
		if downscroll then	barYeee = 38.4;	end
		doTweenY("flavorBar", "flavorHUD", barYeee, 0.8, "circinout")
	end
	if curStep == 3528 then	
		doTweenAlpha('dramablack', 'dramablack', 1, 0.001);
	end
end

function onBeatHit()
	if curBeat % 3 == 0 and piratetime then
		playAnim('leftpir8', 'idle', true);
		playAnim('rightpir8', 'idle', true);
		playAnim('midpir8', 'idle', true);
		playAnim('waves', 'idle', true);
	end
	if curBeat % 3 == 0 and safftime then
		playAnim('saff', 'idle', true);
	end
	if curBeat % 3 == 0 and crewbop then
			playAnim('sharp', 'idle');
		if danced then
			danced = false;
			playAnim('adobo', 'left');
		else
			danced = true;
			playAnim('adobo', 'right');
		end
	end
end