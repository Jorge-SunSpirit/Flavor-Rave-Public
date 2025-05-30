local doBumpThingie = true;
local ogYDad = 0;
local ogYDadlegs = 0;
local ogYBF = 0;

function onCreatePost()
	ogYDad = getProperty('dadGroup.y');
	ogYDadlegs = getProperty('SavoryLegs.y');
	ogYBF = getProperty('boyfriendGroup.y');
	

	setProperty('isCameraOnForcedPos', true);
end

function onStepHit()
end

function onBeatHit()
	if doBumpThingie == true then
		setProperty('dadGroup.y', getProperty('dadGroup.y') + 25);
		setProperty('boyfriendGroup.y', getProperty('boyfriendGroup.y') + 10);
		setProperty('SavoryLegs.y', getProperty('SavoryLegs.y') + 10);
		
		doTweenY('dadGroupy', 'dadGroup', ogYDad, 0.2, "quadInOut");
		doTweenY('boyfriendGroupy', 'boyfriendGroup', ogYBF, 0.15, "quadInOut");
		doTweenY('SavoryLegsy', 'SavoryLegs', ogYDadlegs, 0.15, "quadInOut");
	end
end