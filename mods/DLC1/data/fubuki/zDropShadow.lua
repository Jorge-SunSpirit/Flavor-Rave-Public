--Throw this file anywhere it needs to be called.
--I don't know if it'll lag when being immediately applied to something midsong but it does work and is my friend :)

function onCreate()
	addHaxeLibrary('DropShadowShader', 'shaders');
end

function onCreatePost()
		applyRim("dad");
		applyRim("bf");
		applyRim("extraChar");
		removeRim("bf");
		removeRim("dad");
		removeRim("extraChar");
end

function thingie(num)
	num = tonumber(num)
	if num == 1056 then
		applyRim("dad");
		applyRim("bf");
		applyRim("extraChar");
		runHaxeCode([[
		getVar('bfrim').color = 0xFF00FFFF;
		getVar('extrarim').color = 0xFF00FFFF;
		getVar('dadrim').color = 0xFF00FFFF;
		getVar('bfrim').setAdjustColor(-255, 0, 0, 0); //brightness, hue, contrast, saturation
		getVar('extrarim').setAdjustColor(-255, 0, 0, 0); //brightness, hue, contrast, saturation
		getVar('dadrim').setAdjustColor(-255, 0, 0, 0); //brightness, hue, contrast, saturation
		]]);
	end
	if num == 1440 then
		applyRim("dad");
		applyRim("bf");
		applyRim("extraChar");
		runHaxeCode([[
		getVar('bfrim').color = 0xFFFF6100;
		getVar('extrarim').color = 0xFFFF6100;
		getVar('dadrim').color = 0xFFFF6100;
		getVar('bfrim').setAdjustColor(-255, 0, 0, 0); //brightness, hue, contrast, saturation
		getVar('extrarim').setAdjustColor(-255, 0, 0, 0); //brightness, hue, contrast, saturation
		getVar('dadrim').setAdjustColor(-255, 0, 0, 0); //brightness, hue, contrast, saturation
		]]);
	end
	if num == 1312 or num == 1696 then
		removeRim("bf");
		removeRim("dad");
		removeRim("extraChar");
	end
	if num == 1952 then
		applyRim("dad");
		applyRim("bf");
		applyRim("extraChar");
	end
end

function applyRim(name)
	runHaxeCode([[
		trace('Start Rim');
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
		rim.setAdjustColor(-10, 0, -30, 20); //brightness, hue, contrast, saturation
		rim.distance = 14;
		rim.color = 0xFF2BFAB2;
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
		trace('End Rim');
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