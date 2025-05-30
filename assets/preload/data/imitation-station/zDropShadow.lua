--Throw this file anywhere it needs to be called.
--I don't know if it'll lag when being immediately applied to something midsong but it does work and is my friend :)

function onCreate()
	addHaxeLibrary('DropShadowShader', 'shaders');
end

function onCreatePost()
	applyRim("dad");
	applyRim("bf");
end

function thingie(num)
	num = tonumber(num)
	if num == 1 then
		runHaxeCode([[
		getVar('bfrim').color = 0xFF000000;
		getVar('dadrim').color = 0xFF000000;
		getVar('bfrim').setAdjustColor(-255, 0, 0, 0);
		getVar('dadrim').setAdjustColor(-255, 0, 0, 0);
		]]);
	end
	if num == 112 then
		runHaxeCode([[
		getVar('bfrim').color = 0xFF707070;
		getVar('dadrim').color = 0xFF707070;
		getVar('bfrim').setAdjustColor(-10, 0, -35, 10);
		getVar('dadrim').setAdjustColor(-10, 0, -35, 10);
		]]);
	end
	if num == 640 then
		runHaxeCode([[
		var thingie:String = 'bfrimtween';
		game.modchartTweens.set(thingie, FlxTween.tween(getVar('bfrim'), {distance: 0, baseBrightness: 0, baseContrast: 0}, 2, {
		onComplete: function(twn:FlxTween) {
			PlayState.instance.callOnLuas('onTweenCompleted', [thingie]);
			PlayState.instance.modchartTweens.remove(thingie);
		}}));
		
		var thingie2:String = 'dadrimtween';
		game.modchartTweens.set(thingie2, FlxTween.tween(getVar('dadrim'), {distance: 0, baseBrightness: 0, baseContrast: 0}, 2, {
		onComplete: function(twn:FlxTween) {
			PlayState.instance.callOnLuas('onTweenCompleted', [thingie2]);
			PlayState.instance.modchartTweens.remove(thingie2);
		}}));
		]]);
		doTweenColor('bfrimcolotween', 'bfrim', '00000', 2, 'linear')
		doTweenColor('dadrimcolotween', 'dadrim', '00000', 2, 'linear')
	end
	if num == 896 then
		runHaxeCode([[
		getVar('bfrim').color = 0xFF7F0000;
		getVar('dadrim').color = 0xFF7F0000;
		getVar('bfrim').distance = 20;
		getVar('dadrim').distance = 20;
		getVar('bfrim').setAdjustColor(-45, 0, -40, 20);
		getVar('dadrim').setAdjustColor(-45, 0, -40, 20);
		]]);
	end
	if num == 1155 then
		removeRim("dad");
		removeRim("bf");
	end
	if num == 1158 then
		applyRim("dad");
		applyRim("bf");
		runHaxeCode([[
		getVar('bfrim').distance = 40;
		getVar('dadrim').distance = 40;
		]]);
	end
	if num == 1434 then
		runHaxeCode([[
		var thingie:String = 'bfrimtween';
		game.modchartTweens.set(thingie, FlxTween.tween(getVar('bfrim'), {distance: 0, baseBrightness: 0, baseContrast: 0}, 14, {
		onComplete: function(twn:FlxTween) {
			PlayState.instance.callOnLuas('onTweenCompleted', [thingie]);
			PlayState.instance.modchartTweens.remove(thingie);
		}}));
		
		var thingie2:String = 'dadrimtween';
		game.modchartTweens.set(thingie2, FlxTween.tween(getVar('dadrim'), {distance: 0, baseBrightness: 0, baseContrast: 0}, 14, {
		onComplete: function(twn:FlxTween) {
			PlayState.instance.callOnLuas('onTweenCompleted', [thingie2]);
			PlayState.instance.modchartTweens.remove(thingie2);
		}}));
		]]);
		doTweenColor('bfrimcolotween', 'bfrim', '00000', 14, 'linear')
		doTweenColor('dadrimcolotween', 'dadrim', '00000', 14, 'linear')
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