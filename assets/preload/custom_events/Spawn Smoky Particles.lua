local particles = false;
local particleSprite = '';
local direction = '';

function onEvent(name, value1, value2) 
	if name == 'Spawn Smoky Particles' then
		particles = not particles;
		particleSprite = value1;
		direction = value2;
	end
end

function onStepHit()
	if particles then
		runHaxeCode([[
			var funniSprite:String = "]]..particleSprite..[[";
			var direction:String = "]]..direction..[[";
			var scale:Float = FlxG.random.float(0.9, 1.4);

			var parti:FlxSprite = new FlxSprite(0, 0);

			parti.frames = Paths.getSparrowAtlas(funniSprite);
			parti.animation.addByPrefix("smonk", "SmokySmokeBG", 24, true);
			parti.animation.play("smonk");
			parti.antialiasing = ClientPrefs.globalAntialiasing;
			parti.x = FlxG.random.int(-700, 1700);
			parti.y = game.boyfriend.y + 700;
			parti.angularVelocity = FlxG.random.float(22.5, 90);
			parti.scale.set(scale, scale);
			game.particleGroup.add(parti);

			FlxTween.tween(parti, {y: parti.y - 600, alpha: 0}, FlxG.random.float(2, 6), {
			onComplete: function(tween:FlxTween){
				parti.destroy();
				game.particleGroup.remove(parti);
				parti = null;
			}});
		]])
	end
end
