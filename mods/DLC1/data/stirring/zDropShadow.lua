--Throw this file anywhere it needs to be called.
--I don't know if it'll lag when being immediately applied to something midsong but it does work and is my friend :)

function onCreate()
	addHaxeLibrary('DropShadowShader', 'shaders');
end

function onCreatePost()
end

function thingie(num)
	num = tonumber(num)
	if num == 1604 then
		applyRim("dad");
		applyRim("bf");
		
		runHaxeCode([[
		getVar('bfrim').distance = 0;
		getVar('bfrim').baseBrightness = 0;
		getVar('bfrim').baseContrast = 0;
		getVar('bfrim').baseSaturation = 0;
		getVar('dadrim').distance = 0;
		getVar('dadrim').baseBrightness = 0;
		getVar('dadrim').baseContrast = 0;
		getVar('dadrim').baseSaturation = 0;
		
		
		var thingie:String = 'bfrimtween';
		game.modchartTweens.set(thingie, FlxTween.tween(getVar('bfrim'), {distance: 20, baseBrightness: -45, baseContrast: -40, baseSaturation: 20}, 5, {
		onComplete: function(twn:FlxTween) {
			PlayState.instance.callOnLuas('onTweenCompleted', [thingie]);
			PlayState.instance.modchartTweens.remove(thingie);
		}}));
		
		var thingie2:String = 'dadrimtween';
		game.modchartTweens.set(thingie2, FlxTween.tween(getVar('dadrim'), {distance: 20, baseBrightness: -45, baseContrast: -40, baseSaturation: 20}, 5, {
		onComplete: function(twn:FlxTween) {
			PlayState.instance.callOnLuas('onTweenCompleted', [thingie2]);
			PlayState.instance.modchartTweens.remove(thingie2);
		}}));
		]]);
	end
	if num == 1743 then --I think it's here it gets applied????
		removeRim("dad");
		removeRim("bf");
	end
	if num == 1744 then --I think it's here it gets applied????
		applyRim("dad");
		applyRim("bf");
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
		rim.setAdjustColor(-45, 0, -40, 20); //brightness, hue, contrast, saturation
		rim.distance = 20;
		rim.color = 0xFF7F0000;
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