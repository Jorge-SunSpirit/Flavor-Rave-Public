function onCreatePost()
end

local isLooking = true;
local isFocusOn = 0;
local bopL = '-left';
local bopR = '-right';
local panL = 'righttoleft';
local panR = 'lefttoright';

function onStepHit()
	if curStep == 1168 then
		isLooking = false;
	end
end

function onMoveCamera(focus)
	-- This will stop GF from looking left and right every time the camera moves
	if isLooking == false then 
		return Function_Stop;
	end

	--This will handle GF looking left and right.
	if isFocusOn ~= 0 and focus == 'gf' or isFocusOn ~= 0 and focus == 'dad' then
		isFocusOn = 0;
		triggerEvent('Play Animation', panL, 'gf');
		triggerEvent('Alt Idle Animation', 'gf', bopL)
	elseif isFocusOn ~= 1 and focus == 'boyfriend' then
		isFocusOn = 1;
		triggerEvent('Play Animation', panR, 'gf');
		triggerEvent('Alt Idle Animation', 'gf', bopR)
	end
end 