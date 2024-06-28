function toggleLights(num)
	if num == 0 then -- Sweet
		setProperty('leftLights.alpha', 0.0001);
		setProperty('rightLights.alpha', 1);
	end
	if num == 1 then -- Sour
		setProperty('leftLights.alpha', 1);
		setProperty('rightLights.alpha', 0.0001);
	end
	if num == 2 then -- Both
		setProperty('leftLights.alpha', 1);
		setProperty('rightLights.alpha', 1);
	end
	if num == 3 then -- None
		setProperty('leftLights.alpha', 0.0001);
		setProperty('rightLights.alpha', 0.0001);
	end
end

function onCreate()
	triggerEvent('Alt Idle Animation', 'Dad', '-sad');
	triggerEvent('Alt Idle Animation', 'BF', '-sad');
	playAnim('dad', 'idle-sad', true)
	playAnim('boyfriend', 'idle-sad', true)

	makeAnimatedLuaSprite('bordersour', 'closeup/SourBorder', 0, 0);
	addAnimationByPrefix('bordersour', 'idle', 'SourBorder', 30, true);
	playAnim('bordersour', 'idle');
	setScrollFactor('bordersour', 0, 0);
    screenCenter('bordersour');
	addLuaSprite('bordersour', false);
	setObjectCamera('bordersour', 'hud');
	setProperty('bordersour.alpha', 0.0001);
	
	makeAnimatedLuaSprite('bordersweet', 'closeup/sweetborder', 0, 0);
	addAnimationByPrefix('bordersweet', 'idle', 'SweetBorder', 30, true);
	playAnim('bordersweet', 'idle');
	setScrollFactor('bordersweet', 0, 0);
    screenCenter('bordersweet');
	addLuaSprite('bordersweet', false);
	setObjectCamera('bordersweet', 'hud');
	setProperty('bordersweet.alpha', 0.0001);
end

function onCreatePost()
	setProperty('bglights.alpha', 0.0001);
	toggleLights(3);
	setProperty('isCameraOnForcedPos', true);
    setProperty('camFollow.y', 410);
    setProperty('camFollow.x', 727);
    setProperty('camera.target.x', 727);
    setProperty('camera.target.y', 410);
end

function thingie(num)
	if num == "80" then
		setProperty('isCameraOnForcedPos', false);
	end
	if num == "272" then
		setProperty('bglights.alpha', 1);
		toggleLights(1);
	end
	if num == "332" then
		toggleLights(3);
	end
	if num == "336" then
		toggleLights(0);
	end
	if num == "400" then
		toggleLights(1);
	end
	if num == "460" then
		toggleLights(3);
	end
	if num == "464" then
		toggleLights(0);
	end
	if num == "524" then
		toggleLights(3);
	end
	if num == "528" then
		toggleLights(2);
	end
	if num == "652" then
		toggleLights(3);
	end
	if num == "656" then
		toggleLights(2);
	end
	if num == "1168" then
		toggleLights(1);
		setProperty('bordersour.alpha', 1);
	end
	if num == "1296" then
		toggleLights(0);
		doTweenAlpha('bordersour', 'bordersour', 0.0001, 2);
		doTweenAlpha('bordersweet', 'bordersweet', 1, 2);
	end
	if num == "1424" then
		toggleLights(2);
		doTweenAlpha('bordersweet', 'bordersweet', 0.0001, 1);
	end
	if num == "1676" then
		toggleLights(3);
	end
	if num == "1680" then
		toggleLights(2);
		setProperty('bordersour.alpha', 1);
		setProperty('bordersweet.alpha', 1);
	end
	if num == "1936" then
		toggleLights(0);
	end
	if num == "1944" then
		toggleLights(1);
	end
	if num == "1952" then
		toggleLights(2);
	end
	if num == "1972" then
		doTweenAlpha('bordersour', 'bordersour', 0.0001, 3.4);
		doTweenAlpha('bordersweet', 'bordersweet', 0.0001, 3.4);
	end
end

function onStepHit()
	--Center Camera
	if curStep >= 208 and curStep <= 239 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 410);
		setProperty('camFollow.x', 727);
	elseif curStep >= 528 and curStep <= 655 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 410);
		setProperty('camFollow.x', 727);
	elseif curStep >= 944 and curStep <= 974 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 410);
		setProperty('camFollow.x', 727);
	elseif curStep >= 1010 and curStep <= 1040 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 410);
		setProperty('camFollow.x', 727);
	elseif curStep >= 1080 and curStep <= 1104 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 410);
		setProperty('camFollow.x', 727);
	elseif curStep >= 1136 and curStep <= 1167 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 410);
		setProperty('camFollow.x', 727);
	elseif curStep >= 1295 and curStep <= 1424 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 410);
		setProperty('camFollow.x', 727);
	elseif curStep >= 1616 and curStep <= 1679 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 410);
		setProperty('camFollow.x', 727);
	elseif curStep >= 1808 and curStep <= 2018 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 410);
		setProperty('camFollow.x', 727);
	elseif curStep >= 208 and curStep <= 2018 then
		setProperty('isCameraOnForcedPos', false);
	end
end