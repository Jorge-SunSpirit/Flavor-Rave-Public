function onCreate()
	charBacklight = false;
	curLightName = 'off';
	beatNum = 1;
end

function onEvent(name, value1, value2, strumTime)
	if name == 'Stage Lights' then
		curLightName = value1;

		if curLightName == 'off' then
			loadGraphic('backlight', 'bg2/backlightoff');
			charBacklight = false;
		end

		if curLightName == 'sour' then
			loadGraphic('backlight', 'bg2/backlightsour'..beatNum);
			charBacklight = true;
		end

		if curLightName == 'sweet' then
			loadGraphic('backlight', 'bg2/backlightsweet'..beatNum);
			charBacklight = true;
		end

		if curLightName == 'all' then
			loadGraphic('backlight', 'bg2/backlightall');
			charBacklight = false;
		end
	end
end

function onBeatHit()
	if (curBeat % 2) == 0 then
		if (beatNum == 2) then
			beatNum = 1
		else
			beatNum = 2
		end

		if (charBacklight == true) then
			if curLightName == 'sour' then
				loadGraphic('backlight', 'bg2/backlightsour'..beatNum);
			end
			if curLightName == 'sweet' then
				loadGraphic('backlight', 'bg2/backlightsweet'..beatNum);
			end
		end
	end
end