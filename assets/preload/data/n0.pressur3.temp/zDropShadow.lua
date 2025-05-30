--Throw this file anywhere it needs to be called.
--I don't know if it'll lag when being immediately applied to something midsong but it does work and is my friend :)

function onCreate()
	addHaxeLibrary('DropShadowShader', 'shaders');
end

function onCreatePost()
	applyRim("bf");
end

function thingie(num)
	num = tonumber(num)
	if num == 897 then
		runHaxeCode([[
			var thingie:String = 'test';
			game.modchartTweens.set(thingie, FlxTween.tween(getVar('bfrim'), {distance: 20, baseBrightness: -25, baseContrast: -15}, 4, {ease: FlxEase.quadOut,
			onComplete: function(twn:FlxTween) {
				PlayState.instance.callOnLuas('onTweenCompleted', [thingie]);
				PlayState.instance.modchartTweens.remove(thingie);
			}}));
		]]);
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
		rim.setAdjustColor(0, 0, 0, 0); //brightness, hue, contrast, saturation
		rim.distance = 0;
		rim.color = 0xFF51CDFF;
		char.shader = rim;
		rim.attachedSprite = char;
		rim.angle = 125;
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