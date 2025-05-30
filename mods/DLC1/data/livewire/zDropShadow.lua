--Throw this file anywhere it needs to be called.
--I don't know if it'll lag when being immediately applied to something midsong but it does work and is my friend :)

function onCreate()
	addHaxeLibrary('DropShadowShader', 'shaders');
end

function onCreatePost()
	applyRim("dad");
	
	
	--This stuff down here is me messin with it. Feel free to remove it. 
	applyRim("bf");
	applyRim("gf");
	runHaxeCode([[
		getVar('gfrim').angle = 45;
		getVar('gfrim').distance = 40;
		getVar('bfrim').distance = 50;
	]]);
end

function thingie(num)
	num = tonumber(num)
	if num == 394 then
		removeRim("dad");
		
		--Same applies here remove if unwanted
		removeRim("bf");
		removeRim("gf");
	end
end

function applyRim(name)
	runHaxeCode([[
		var who:String = "]]..name..[[";
		var char:Character = game.dad;

		//Fun fact, HScript doesn't like 'thing' | 'thing'. It gotta be 'thing' , 'thing'
		switch(who)
		{
			default:
				who = 'dad';
			case 'gf' , 'girlfriend':
				char = game.gf;
				who = 'gf';
			case 'extra' , 'extraChar':
				char = game.extraChar;
				who = 'extra';
			case 'boyfriend' , 'bf':
				char = game.boyfriend;
				who = 'bf';
		}
	
		var rim = new DropShadowShader();
		rim.setAdjustColor(-10, 0, -35, 10); //brightness, hue, contrast, saturation
		rim.color = 0xFF707070;
		char.shader = rim;
		rim.attachedSprite = char;
		rim.angle = 90;
		setVar(who + 'rim', rim);
		trace(who + 'rim ' + getVar(who+'rim'));
		
		char.animation.callback = function() 
		{
			if (char != null)
				rim.updateFrameInfo(char.frame);
		};
	]]);
end

function removeRim(name)
	runHaxeCode([[
		var who:String = "]]..name..[[";
		var char:Character = game.dad;

		switch(who) {
			default:
				who = 'dad';
			case 'gf' , 'girlfriend':
				char = game.gf;
				who = 'gf';
			case 'extra' , 'extraChar':
				char = game.extraChar;
				who = 'extra';
			case 'boyfriend' , 'bf':
				char = game.boyfriend;
				who = 'bf';
		}
		char.shader = null;
		removeVar(who + 'rim');
		
		char.animation.callback = function() {};
	]]);
end