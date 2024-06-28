local partOne = true;

function onCreate()
	addHaxeLibrary('FlxBackdrop', 'flixel.addons.display');

	posX = -520;
	posY = -480;
	scale = 0.7;
	--enZ-TV/
	
	makeLuaSprite('sky', 'enZ-TV/sky_day', posX, posY);
	setScrollFactor('sky', 0.35, 0.35);
	scaleObject('sky', scale, scale);
	addLuaSprite('sky', false);
	setProperty('sky.alpha', 0.001);
	
	makeLuaSprite('city', 'enZ-TV/city_day', posX, posY);
	setScrollFactor('city', 0.7, 0.85);
	scaleObject('city', scale, scale);
	addLuaSprite('city', false);
	setProperty('city.alpha', 0.001);
	
	makeLuaSprite('roof', 'enZ-TV/rooftop_day', posX, posY);
	setScrollFactor('roof', 1, 1);
	scaleObject('roof', scale, scale);
	addLuaSprite('roof', false);
	setProperty('roof.alpha', 0.001);
	
	makeLuaSprite('tvfront', 'enZ-TV/frontTV', posX, posY);
	setScrollFactor('tvfront', 1.2, 1.2);
	scaleObject('tvfront', scale, scale);
	addLuaSprite('tvfront', true);
	setProperty('tvfront.alpha', 0.001);
	
	posX = -135;
	posY = -100;
	scale = 0.35;

	makeLuaSprite('tvScreens', 'enZ-TV/tvScreen', posX, posY);
	setScrollFactor('tvScreens', 1, 1);
	scaleObject('tvScreens', scale, scale);
	addLuaSprite('tvScreens', false);
	
	makeAnimatedLuaSprite('introstatic', 'sweetroom/static', -100, -100);
	addAnimationByPrefix('introstatic', 'idle', 'static', 30, true);
	playAnim('introstatic', 'idle');
	setProperty('introstatic.alpha', 0.001);
	scaleObject('introstatic', 0.7, 0.7);
	addLuaSprite('introstatic', false);

	makeLuaSprite('RikaDanceBG', 'closeup/RikaBG', -100, -50);
	setScrollFactor('RikaDanceBG', 1, 1);
	scaleObject('RikaDanceBG', 1, 1);
	setProperty('RikaDanceBG.alpha', 0.0001);
	addLuaSprite('RikaDanceBG', false);

	makeLuaSprite('SweetDanceBG', 'closeup/SweetBG', -100, -50);
	setScrollFactor('SweetDanceBG', 1, 1);
	scaleObject('SweetDanceBG', 1, 1);
	setProperty('SweetDanceBG.alpha', 0.0001);
	addLuaSprite('SweetDanceBG', false);
	
	makeLuaSprite('SourDanceBG', 'closeup/SourBG', -100, -50);
	setScrollFactor('SourDanceBG', 1, 1);
	scaleObject('SourDanceBG', 1, 1);
	setProperty('SourDanceBG.alpha', 0.0001);
	addLuaSprite('SourDanceBG', false);

	makeAnimatedLuaSprite('sour_chibi', 'enZ-TV/sour_chibi', -41, -40);
	addAnimationByPrefix('sour_chibi', 'idle', 'sour dance', 24, true);
	playAnim('sour_chibi', 'idle');
	setProperty('sour_chibi.alpha', 0.0001);
	scaleObject('sour_chibi', 1.2, 1.2);
	addLuaSprite('sour_chibi', false);

	makeAnimatedLuaSprite('rika_chibi', 'enZ-TV/rika_chibi', 576, -70);
	addAnimationByPrefix('rika_chibi', 'idle', 'rika dance', 24, true);
	playAnim('rika_chibi', 'idle');
	setProperty('rika_chibi.alpha', 0.0001);
	scaleObject('rika_chibi', 1.2, 1.2);
	addLuaSprite('rika_chibi', false);

	makeAnimatedLuaSprite('sweet_chibi', 'enZ-TV/sweet_chibi', 33, -35);
	addAnimationByPrefix('sweet_chibi', 'idle', 'sweet dance', 24, true);
	playAnim('sweet_chibi', 'idle');
	setProperty('sweet_chibi.alpha', 0.0001);
	scaleObject('sweet_chibi', 1.2, 1.2);
	addLuaSprite('sweet_chibi', false);

	makeAnimatedLuaSprite('SourTV', 'enZ-TV/SourTV', -81, -30);
	addAnimationByPrefix('SourTV', 'idle', 'SourTV', 24, true);
	playAnim('SourTV', 'idle');
	setProperty('SourTV.alpha', 0.0001);
	addLuaSprite('SourTV', false);

	makeAnimatedLuaSprite('RikaTV', 'enZ-TV/RikaTV', 525, -30);
	addAnimationByPrefix('RikaTV', 'idle', 'RikaTV', 24, true);
	playAnim('RikaTV', 'idle');
	setProperty('RikaTV.alpha', 0.0001);
	addLuaSprite('RikaTV', false);

	makeAnimatedLuaSprite('SweetTV', 'enZ-TV/SweetTV', -82, -28);
	addAnimationByPrefix('SweetTV', 'idle', 'SweetTV', 24, true);
	playAnim('SweetTV', 'idle');
	setProperty('SweetTV.alpha', 0.0001);
	addLuaSprite('SweetTV', false);

	makeAnimatedLuaSprite('bottomscreens', 'enZ-TV/bottomscreens', -140, 555);
	addAnimationByPrefix('bottomscreens', 'idle', 'ConsoleScreens', 24, true);
	playAnim('bottomscreens', 'idle');
	setProperty('bottomscreens.alpha', 1);
	addLuaSprite('bottomscreens', true);
	
	makeLuaSprite('computerRoom', 'enZ-TV/Computer_Room', posX, posY);
	setScrollFactor('computerRoom', 1, 1);
	scaleObject('computerRoom', scale, scale);
	addLuaSprite('computerRoom', true);
	
	makeLuaSprite('buttonGlow', 'enZ-TV/ButtonGlow', posX, posY);
	setScrollFactor('buttonGlow', 1, 1);
	scaleObject('buttonGlow', scale, scale);
	addLuaSprite('buttonGlow', true);
	setProperty('buttonGlow.alpha', 0.001);
end

function onCreatePost()
	makeAnimatedLuaSprite('outrostatic', 'sweetroom/static', -260, -100);
	addAnimationByPrefix('outrostatic', 'idle', 'static', 30, true);
	playAnim('outrostatic', 'idle');
	setProperty('outrostatic.alpha', 0.0001);
	scaleObject('outrostatic', 1, 1);
	addLuaSprite('outrostatic', true);

	makeLuaSprite('tvScreenOutro', 'enZ-TV/tvScreen', -235, -200);
	setScrollFactor('tvScreenOutro', 1, 1);
	scaleObject('tvScreenOutro', 1, 1);
	setProperty('tvScreenOutro.alpha', 0.0001);
	addLuaSprite('tvScreenOutro', true);

	makeLuaSprite('vcr', 'enZ-TV/vcr', 0, 0);
	setScrollFactor('vcr', 0, 0);
	scaleObject('vcr', 1, 1);
	addLuaSprite('vcr', false);
	setProperty('vcr.alpha', 0.001);
	setObjectCamera('vcr', 'hud');
	
	makeLuaSprite('border', 'enZ-TV/tvborder', 0, 0);
	setScrollFactor('border', 0, 0);
	scaleObject('border', 1, 1);
	addLuaSprite('border', true);
	setProperty('border.alpha', 0.001);
	setObjectCamera('border', 'hud');
	addCharacterToList('sour-mh', 'bf');
	addCharacterToList('rika-day', 'dad');
	addCharacterToList('sweet-mh', 'extra');
	addCharacterToList('sour-close-sc', 'bf');
	addCharacterToList('rika-close', 'dad');
	addCharacterToList('sweet-close-mh', 'extra');
end

function onBeatHit()
	if curBeat % 2 == 0 and partOne then
		setProperty('buttonGlow.alpha', 1);
		doTweenAlpha('buttonGlow', 'buttonGlow', 0, 0.5)
	end
end

function swapBG(which)
	if which == '1' then
		partOne = true;
		setProperty('sky.alpha', 0.001);
		setProperty('city.alpha', 0.001);
		setProperty('roof.alpha', 0.001);
		setProperty('tvfront.alpha', 0.001);
		setProperty('vcr.alpha', 0.001);
		setProperty('border.alpha', 0.001);
		
		setProperty('tvScreens.alpha', 1);
		setProperty('computerRoom.alpha', 1);
		setProperty('screenGlow.alpha', 1);
		setProperty('buttonGlow.alpha', 1);
		setProperty('bottomscreens.alpha', 1);
		
		triggerEvent('Change Character','bf','sour-close-sc');
		triggerEvent('Change Character','dad','rika-close');
		triggerEvent('Change Character','extra','sweet-close-mh');
		setProperty('defaultCamZoom', 1);
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.x', 524);
		setProperty('camFollow.y', 400);
		setProperty('camera.target.x', 524);
		setProperty('camera.target.y', 400);
		
		setProperty('extraGroup.x', getProperty('EXTRA_X') + 150)
		setProperty('extraGroup.y', getProperty('EXTRA_Y') - 250)
		setProperty('boyfriendGroup.x', getProperty('BF_X') - 150)
		setProperty('boyfriendGroup.y', getProperty('BF_Y') - 275)
		setProperty('dadGroup.x', getProperty('DAD_X') - 150)
		setProperty('dadGroup.y', getProperty('DAD_Y') - 200)
		
		noteTweenX('bf', 4, defaultPlayerStrumX0, 0.01, linear)
		noteTweenX('bf1', 5, defaultPlayerStrumX1, 0.01, linear)
		noteTweenX('bf2', 6, defaultPlayerStrumX2, 0.01, linear)
		noteTweenX('bf3', 7, defaultPlayerStrumX3, 0.01, linear)
		noteTweenX('dad4', 0, defaultOpponentStrumX0, 0.01, linear)
		noteTweenX('dad5', 1, defaultOpponentStrumX1, 0.01, linear)
		noteTweenX('dad6', 2, defaultOpponentStrumX2, 0.01, linear)
		noteTweenX('dad7', 3, defaultOpponentStrumX3, 0.01, linear)
	end
	if which == '2' then
		partOne = false;
		setProperty('sky.alpha', 1);
		setProperty('city.alpha', 1);
		setProperty('roof.alpha', 1);
		setProperty('vcr.alpha', 1);
		setProperty('tvfront.alpha', 1);
		setProperty('border.alpha', 1);
		
		setProperty('tvScreens.alpha', 0.001);
		setProperty('bottomscreens.alpha', 0.001);
		setProperty('computerRoom.alpha', 0.001);
		setProperty('screenGlow.alpha', 0.001);
		setProperty('buttonGlow.alpha', 0.001);
		setProperty('introstatic.alpha', 0.001);
		
		setProperty('defaultCamZoom', 0.9);
		setProperty('isCameraOnForcedPos', false);
		
		setProperty('extraGroup.x', getProperty('EXTRA_X'))
		setProperty('extraGroup.y', getProperty('EXTRA_Y')-10)
		setProperty('boyfriendGroup.x', getProperty('BF_X'))
		setProperty('boyfriendGroup.y', getProperty('BF_Y')+25)
		setProperty('dadGroup.x', getProperty('DAD_X'))
		setProperty('dadGroup.y', getProperty('DAD_Y'))

		if not middlescroll then
			noteTweenX('bf', 4, defaultPlayerStrumX0 - 75, 0.01, linear);
			noteTweenX('bf1', 5, defaultPlayerStrumX1 - 75, 0.01, linear);
			noteTweenX('bf2', 6, defaultPlayerStrumX2 - 75, 0.01, linear);
			noteTweenX('bf3', 7, defaultPlayerStrumX3 - 75, 0.01, linear);
			noteTweenX('dad4', 0, defaultOpponentStrumX0 + 75, 0.01, linear);
			noteTweenX('dad5', 1, defaultOpponentStrumX1 + 75, 0.01, linear);
			noteTweenX('dad6', 2, defaultOpponentStrumX2 + 75, 0.01, linear);
			noteTweenX('dad7', 3, defaultOpponentStrumX3 + 75, 0.01, linear);
		else
			noteTweenX('dad4', 0, defaultOpponentStrumX0 + 75, 0.01, linear);
			noteTweenX('dad5', 1, defaultOpponentStrumX1 + 75, 0.01, linear);
			noteTweenX('dad6', 2, defaultOpponentStrumX2 - 75, 0.01, linear);
			noteTweenX('dad7', 3, defaultOpponentStrumX3 - 75, 0.01, linear);
		end
	end
end
