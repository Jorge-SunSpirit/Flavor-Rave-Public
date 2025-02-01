function onCreate()
	makeLuaSprite('waltzbg', 'stages/other/waltzbg', -0, -0);
	setScrollFactor('waltzbg', 0, 0);
	scaleObject('waltzbg', 1.1, 1.1);
	addLuaSprite('waltzbg', false);
	setProperty('waltzbg.alpha', 0.0001);
	setObjectCamera('waltzbg', 'effect');
    screenCenter('waltzbg');
	
	makeLuaSprite('waltz', 'stages/other/waltz2', -0, -0);
	setScrollFactor('waltz', 0, 0);
	scaleObject('waltz', 1.1, 1.1);
	addLuaSprite('waltz', false);
	setProperty('waltz.alpha', 0.0001);
	setObjectCamera('waltz', 'effect');
    screenCenter('waltz');
	
	makeLuaSprite('whitehueh', 'dreamcast/art_BG/whitehueh', 0, 0);
	setScrollFactor('whitehueh', 0, 0);
	addLuaSprite('whitehueh', false);
	setObjectCamera('whitehueh', 'effect');
	setProperty('whitehueh.alpha', 0.0001);

end

function onStepHit()
	if curStep == 638 then
		doTweenAlpha('whitehueh', 'whitehueh', 1, 1);
	end
	if curStep == 662 then
		doTweenAlpha('whitehueh', 'whitehueh', 0.0001, 1.5);
	setProperty('waltz.alpha', 1);
	setProperty('waltzbg.alpha', 1);
	end
	if curStep == 1040 then
	setProperty('waltz.alpha', 0.0001);
	setProperty('waltzbg.alpha', 0.0001);
	end
	if curStep == 1968 then
		doTweenAlpha('whitehueh', 'whitehueh', 1, 2);
	end
	if curStep == 2001 then
		doTweenAlpha('whitehueh', 'whitehueh', 0.0001, 1);
	end
end
function onBeatHit()
end