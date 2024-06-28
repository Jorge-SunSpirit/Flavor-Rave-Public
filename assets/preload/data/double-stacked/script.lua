function onCreate()
	-- makes ratings change per character
	setProperty('healthCharNote', true);
	setProperty('ratingCharNote', true);
	setProperty('noteSkinCharNote', true);
end

function onStepHit()
	if curStep == 896 then
	setProperty('burgertime.alpha', 1);
	setProperty('umami.alpha', 1);
	setProperty('dramablack.alpha', 0.6);
	end
	if curStep == 1408 then
	doTweenAlpha('burgertime', 'burgertime', 0.0001, 4);
	doTweenAlpha('dramablack', 'dramablack', 0.0001, 2);
	end
end