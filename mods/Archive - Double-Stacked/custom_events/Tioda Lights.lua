local bump = false;
local frequency = 2;

function onCreatePost()
	makeLuaSprite('tiodalights', 'uncle-hearty/ENCOREBORDER', 0, 0);
	setScrollFactor('tiodalights', 0, 0);
	setObjectCamera('tiodalights', 'effect');
	setProperty("tiodalights.alpha", 0.00001);
	addLuaSprite('tiodalights', false);
end

function onEvent(name, value1, value2) 
	if name == 'Tioda Lights' then
		value1num = string.lower(value1);
		if value1num == 'true' then
			bump = true;
		else
			bump = false;
		end
		value2num = math.tointeger(value2);
		if value2num > 0 and value2num < 17 then
			frequency = value2num;
		end
	end
end

function onBeatHit()
	if bump and curBeat % frequency == 0 then
		runHaxeCode([[
			var colors:Array<Dynamic> = [0xff31a2fd, 0xff31fd8c, 0xfff794f7, 0xfff96d63, 0xfffba633, 0xff95E0FA, 0xff8CD465, 0xffFC95D3, 0xff9E72D2];
			var sprite:ModchartSprite = game.getLuaObject('tiodalights');
			sprite.color = colors[FlxG.random.int(0, colors.length - 1)];
		]])
		setProperty("tiodalights.alpha", 1);
		doTweenAlpha('tiodalights', 'tiodalights', 0.0001, 1.2);
	end
end
