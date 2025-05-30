local isTweened = false;
local speed = 2;

function onCreatePost()
	addHaxeLibrary('FlxBar', 'flixel.ui');
	
	
	makeAnimatedLuaSprite('laneBG', 'GuitarStrum', 0, 0);
	addAnimationByPrefix('laneBG', 'idle', 'idle', 30, false);
	setProperty('laneBG.alpha', 0.001);
	playAnim('laneBG', 'idle');
	addLuaSprite('laneBG', false);
	setObjectCamera('laneBG', 'hud');
	screenCenter('laneBG');
	
	runHaxeCode([[
		var eviporate:FlxBar;
		eviporate = new FlxBar(1066, 720 + 69, 0x11, 167, 51, game, 'health', 0, 2);
		eviporate.antialiasing = ClientPrefs.globalAntialiasing;
		eviporate.numDivisions = 167;
		game.insert(game.members.indexOf(game.getLuaObject('laneBG')) + 1, eviporate);
		setVar('eviporate', eviporate);
		eviporate.createImageBar(Paths.image('StrumHeroHealthEmpty'),Paths.image('StrumHeroHealthFull'));
		eviporate.updateBar();
		
		var timy:FlxBar;
		timy = new FlxBar(47, 720 + 69, 0x11, 167, 51, game, 'songPercent', 0, 1);
		timy.antialiasing = ClientPrefs.globalAntialiasing;
		timy.numDivisions = 167;
		game.insert(game.members.indexOf(game.getLuaObject('laneBG')) + 1, timy);
		setVar('timy', timy);
		timy.flipX = true;
		timy.createImageBar(Paths.image('StrumHeroHealthEmpty'),Paths.image('StrumHeroTimeFull'));
		timy.updateBar();
	]]);
	setObjectCamera('eviporate', 'hud');
	setObjectCamera('timy', 'hud');
	
	makeLuaSprite('vapir', 'FlavorHudStrumHero', 0, 720);
	addLuaSprite('vapir', false);
	setObjectCamera('vapir', 'hud');
	screenCenter('vapir', 'x');
end

function onEvent(name, value1, value2) 
	if name == 'Strum Hero' then
		val1 = string.lower(value1);
		speed = tonumber(value2);
		
		if val1 == 'true' and isTweened == false then
			isTweened = true;
			bringIn(true)
		else
			if isTweened == true then
				bringIn(false)
			end
			isTweened = false;
		end
	end
end

function bringIn(what)
	if what == true then
		runTimer('thingie', speed);
		
		barY = 1280;
		if downscroll then	barY = -200;	end
		doTweenY("flavorBar", "flavorHUD", barY, speed, "circinout")
		doTweenY("vapir", "vapir", 589, speed, "circinout")
		doTweenY("eviporate", "eviporate", 658, speed, "circinout")
		doTweenY("timy", "timy", 658, speed, "circinout")
		if not middlescroll then
			noteTweenX("NoteMove1", 0, 417, speed, "circinout")
			noteTweenX("NoteMove2", 1, 529, speed, "circinout")
			noteTweenX("NoteMove3", 2, 641, speed, "circinout")
			noteTweenX("NoteMove4", 3, 753, speed, "circinout")
			noteTweenX("NoteMove5", 4, 417, speed, "circinout")
			noteTweenX("NoteMove6", 5, 529, speed, "circinout")
			noteTweenX("NoteMove7", 6, 641, speed, "circinout")
			noteTweenX("NoteMove8", 7, 753, speed, "circinout")
			
			
			if opponentstrums then
				if opponentPlay then 
					noteTweenAlpha("NoteFade1", 4, 0.07, speed, "circinout")
					noteTweenAlpha("NoteFade2", 5, 0.07, speed, "circinout")
					noteTweenAlpha("NoteFade3", 6, 0.07, speed, "circinout")
					noteTweenAlpha("NoteFade4",	7, 0.07, speed, "circinout")
				else
					noteTweenAlpha("NoteFade1", 0, 0.07, speed, "circinout")
					noteTweenAlpha("NoteFade2", 1, 0.07, speed, "circinout")
					noteTweenAlpha("NoteFade3", 2, 0.07, speed, "circinout")
					noteTweenAlpha("NoteFade4", 3, 0.07, speed, "circinout")
				end
			end
			
		end
	else
		playAnim('laneBG', 'idle', true, true);
		
		barY = 626.4;
		if downscroll then	barY = 38.4;	end
		doTweenY("flavorBar", "flavorHUD", barY, speed, "circinout")
		doTweenY("vapir", "vapir", 720, speed, "circinout")
		doTweenY("eviporate", "eviporate", 720 + 69, speed, "circinout")
		doTweenY("timy", "timy", 720 + 69, speed, "circinout")
		if not middlescroll then
			noteTweenX('bf', 4, defaultPlayerStrumX0, speed, "circinout")
			noteTweenX('bf1', 5, defaultPlayerStrumX1, speed, "circinout")
			noteTweenX('bf2', 6, defaultPlayerStrumX2, speed, "circinout")
			noteTweenX('bf3', 7, defaultPlayerStrumX3, speed, "circinout")
			noteTweenX('dad4', 0, defaultOpponentStrumX0, speed, "circinout")
			noteTweenX('dad5', 1, defaultOpponentStrumX1, speed, "circinout")
			noteTweenX('dad6', 2, defaultOpponentStrumX2, speed, "circinout")
			noteTweenX('dad7', 3, defaultOpponentStrumX3, speed, "circinout")
			
			if opponentstrums then
				noteTweenAlpha("NoteFade1", 0, 1, speed, "circinout")
				noteTweenAlpha("NoteFade2", 1, 1, speed, "circinout")
				noteTweenAlpha("NoteFade3", 2, 1, speed, "circinout")
				noteTweenAlpha("NoteFade4", 3, 1, speed, "circinout")
				noteTweenAlpha("NoteFade5", 4, 1, speed, "circinout")
				noteTweenAlpha("NoteFade6", 5, 1, speed, "circinout")
				noteTweenAlpha("NoteFade7", 6, 1, speed, "circinout")
				noteTweenAlpha("NoteFade8", 7, 1, speed, "circinout")
			end
		end
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'thingie' then
		setProperty('laneBG.alpha', 1);
		playAnim('laneBG', 'idle', true, false, 11);
	end
end