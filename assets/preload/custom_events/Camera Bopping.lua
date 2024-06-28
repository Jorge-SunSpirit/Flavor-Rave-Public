local camAngle = 1.5;
local danceNum = 1;
local danceBeat = 2;
local cameraBopping = false;

function onEvent(name, value1, value2)
	if name == 'Camera Bopping' then
		value1num = string.lower(value1);
		if tonumber(value1) == 1 or value1num == 'true' then
			cameraBopping = true;
		else
			cameraBopping = false;
		end

		value2num = math.tointeger(value2);
		if value2num > 0 and value2num < 17 then
			danceBeat = value2num;
		end
	end
end

function onBeatHit()
	if cameraBopping and curBeat % danceBeat == 0 then
		camBop();
	end
end

function camBop()
	if danceNum == 1 then
		danceNum = -1;
	else
		danceNum = 1;
	end
	doTweenAngle('camGame', 'camGame', camAngle * danceNum, 0.1, 'linear');
end

function onTweenCompleted(tag)
	if tag == 'camGame' then
		doTweenAngle('again', 'camGame', 0, 0.7, 'cubeout');
	end
end