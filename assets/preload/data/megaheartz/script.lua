function onCreate()
	posX = -135;
	posY = -100;
	scale = 0.35;

	setProperty('extraChar.alpha', 0.0001);
	setProperty('dad.alpha', 0.0001);
	setProperty('boyfriend.alpha', 0.0001);

	makeLuaSprite('CamLeft', 'enZ-TV/BGCloseLeft', posX, posY);
	setScrollFactor('CamLeft', 1, 1);
	scaleObject('CamLeft', scale, scale);
	setProperty('CamLeft.alpha', 0.0001);
	addLuaSprite('CamLeft', false);

	makeLuaSprite('CamRight', 'enZ-TV/BGCloseRight', posX, posY);
	setScrollFactor('CamRight', 1, 1);
	scaleObject('CamRight', scale, scale);
	setProperty('CamRight.alpha', 0.0001);
	addLuaSprite('CamRight', false);

	makeLuaSprite('white', '', -100, -100);
	makeGraphic('white', 1280*2, 720*2, 'FFFFFF');
	setScrollFactor('white', 0, 0);
	screenCenter('white');
	setProperty('white.alpha', 0.001);
	addLuaSprite('white', true);
end

function onCreatePost()
	callOnLuas('swapBG', {'2'})
	callOnLuas('swapBG', {'1'})
end

function eventStep(step)
		if step == '1' then
			setProperty('introstatic.alpha', 1);
		end
		if step == '12' then
			doTweenY('moveCam', 'camFollow', 268, 4);
		end
		if step == '66' then
			setProperty('dad.alpha', 1);
			setProperty('CamLeft.alpha', 1);
		end
		if step == '130' then
			setProperty('dad.alpha', 0.0001);
			setProperty('CamLeft.alpha', 0.0001);
			setProperty('boyfriend.alpha', 1);
			setProperty('CamRight.alpha', 1);
		end
		if step == '192' then
			setProperty('sour_chibi.alpha', 1);
			setProperty('SourDanceBG.alpha', 1);
		end
		if step == '224' then
			setProperty('dad.alpha', 1);
			setProperty('CamLeft.alpha', 1);
			setProperty('sour_chibi.alpha', 0.0001);
			setProperty('SourDanceBG.alpha', 0.0001);
		end
		if step == '320' then
			setProperty('CamRight.alpha', 0.0001);
			setProperty('boyfriend.alpha', 0.0001);
			setProperty('rika_chibi.alpha', 1);
			setProperty('RikaDanceBG.alpha', 1);
		end
		if step == '384' then
			setProperty('dad.alpha', 0.0001);
			setProperty('CamLeft.alpha', 0.0001);
			setProperty('CamRight.alpha', 1);
			setProperty('extraChar.alpha', 1);
			setProperty('rika_chibi.alpha', 0.0001);
			setProperty('RikaDanceBG.alpha', 0.0001);
			setProperty('sweet_chibi.alpha', 1);
			setProperty('SweetDanceBG.alpha', 1);
		end
		if step == '466' then
			setProperty('dad.alpha', 1);
			setProperty('CamLeft.alpha', 1);
			setProperty('sweet_chibi.alpha', 0.0001);
			setProperty('SweetDanceBG.alpha', 0.0001);
			setProperty('boyfriend.alpha', 0.0001);
		end
		if step == '510' then
			setProperty('extraChar.alpha', 0.0001);
			setProperty('CamRight.alpha', 0.0001);
		end
		if step == '512' then
			setProperty('boyfriend.alpha', 1);
			setProperty('CamRight.alpha', 1);
		end
		if step == '576' then
			setProperty('boyfriend.alpha', 0.0001);
			setProperty('CamRight.alpha', 0.0001);
			setProperty('RikaTV.alpha', 1);
		end
		if step == '608' then
			setProperty('dad.alpha', 0.0001);
			setProperty('extraChar.alpha', 1);
			setProperty('CamLeft.alpha', 0.0001);
			setProperty('CamRight.alpha', 1);
			setProperty('SweetTV.alpha', 1);
		end
		if step == '642' then
			setProperty('dad.alpha', 1);
			setProperty('CamLeft.alpha', 1);
			setProperty('extraChar.alpha', 0.0001);
			setProperty('CamRight.alpha', 0.0001);
		end
		if step == '658' then
			setProperty('dad.alpha', 0.0001);
			setProperty('boyfriend.alpha', 1);
			setProperty('CamLeft.alpha', 0.0001);
			setProperty('CamRight.alpha', 1);
			setProperty('SourTV.alpha', 1);
		end
		if step == '672' then
			doTweenZoom('zoomcamera', 'camGame', 1.3, 4, "quadOut");
			setProperty('defaultCamZoom', 1.3);
			doTweenAlpha('white', 'white', 1, 2, "quadOut");
		end
		if step == '688' then
			setProperty('dad.alpha', 1);
			setProperty('CamLeft.alpha', 1);
			setProperty('SweetTV.alpha', 0.0001);
			setProperty('RikaTV.alpha', 0.0001);
			setProperty('SourTV.alpha', 0.0001);
			doTweenX('borderXScale', 'border.scale', 1, 2, "quadOut");
			doTweenY('borderYScale', 'border.scale', 1, 2, "quadOut");
			doTweenX('borderX', 'border', -640, 2, "quadOut");
			doTweenY('borderY', 'border', -360, 2, "quadOut");
			if not middlescroll then
				noteTweenX('bf', 4, defaultPlayerStrumX0 - 75, 1, "quadOut")
				noteTweenX('bf1', 5, defaultPlayerStrumX1 - 75, 1, "quadOut")
				noteTweenX('bf2', 6, defaultPlayerStrumX2 - 75, 1, "quadOut")
				noteTweenX('bf3', 7, defaultPlayerStrumX3 - 75, 1, "quadOut")
				noteTweenX('dad4', 0, defaultOpponentStrumX0 + 75, 1, "quadOut")
				noteTweenX('dad5', 1, defaultOpponentStrumX1 + 75, 1, "quadOut")
				noteTweenX('dad6', 2, defaultOpponentStrumX2 + 75, 1, "quadOut")
				noteTweenX('dad7', 3, defaultOpponentStrumX3 + 75, 1, "quadOut")
			else
				if opponentPlay then
					noteTweenX('dad4', 0, defaultPlayerStrumX0 + 75, 1, linear);
					noteTweenX('dad5', 1, defaultPlayerStrumX1 + 75, 1, linear);
					noteTweenX('dad6', 2, defaultPlayerStrumX2 - 75, 1, linear);
					noteTweenX('dad7', 3, defaultPlayerStrumX3 - 75, 1, linear);
				else
					noteTweenX('dad4', 0, defaultOpponentStrumX0 + 75, 1, linear);
					noteTweenX('dad5', 1, defaultOpponentStrumX1 + 75, 1, linear);
					noteTweenX('dad6', 2, defaultOpponentStrumX2 - 75, 1, linear);
					noteTweenX('dad7', 3, defaultOpponentStrumX3 - 75, 1, linear);
				end
			end
		end
		if step == '704' then
			setProperty('extraChar.alpha', 1);
			setProperty('CamLeft.alpha', 0.0001);
			setProperty('CamRight.alpha', 0.0001);
			callOnLuas('swapBG', {'2'})
			doTweenAlpha('white', 'white', 0, 1, "quadOut");
		end
		if step == '1510' then
			doTweenAlpha('outrostatic', 'outrostatic', 1, 2);
		end
		if step == '1537' then
		setProperty('tvScreenOutro.alpha', 1);
		end
end