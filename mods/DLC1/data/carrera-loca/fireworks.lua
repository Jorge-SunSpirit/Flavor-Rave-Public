local fireworks = false;
function onCreatePost()
	precacheImage('stages/corianda-run/firework');
	setObjectOrder('particleGroup', getObjectOrder('cityscroll')+1);
	if not lowQuality then
		spawnFireworks()
	end
end

function spawnFireworks()
	runHaxeCode([[
		var scale:Float = FlxG.random.float(0.6, 1.5);
		var firework:FlxSprite = new FlxSprite(0, -400);
		firework.frames = Paths.getSparrowAtlas('stages/corianda-run/firework');
		firework.animation.addByPrefix('idle', "Firework", 24);
		firework.animation.play('idle');
		firework.antialiasing = ClientPrefs.globalAntialiasing;
		firework.scrollFactor.set(0.25, 0.24);
		firework.x = FlxG.random.int(-1600, 1000);
		firework.scale.set(scale, scale);
		firework.velocity.x = -50;
		game.particleGroup.add(firework);
		
		var colors:Array<Dynamic> = [0xffA6D7FC, 0xff9CFCC6, 0xffF4C1F4, 0xffF7B0AD, 0xffF9CC90, 0xffBBEAF9, 0xffB3D3A0, 0xffF9D4EB, 0xffAF94D1];
		firework.color = colors[FlxG.random.int(0, colors.length - 1)];
		

		FlxTween.tween(firework, {y: firework.y}, 1, {
		onComplete: function(tween:FlxTween){
			firework.destroy();
			game.particleGroup.remove(firework);
			firework = null;
		}});
	]]);
end

function onUpdate()
end

function thingie(num)
	num = tonumber(num)
	if num == 1855 then
		fireworks = true;
	end
end

function onBeatHit()
	if curBeat % 2 == 0 and fireworks and not lowQuality then
		spawnFireworks();
	end
end