local particles = false;
local particleSprite = '';
local ypos = '';

function onEvent(name, value1, value2) 
	if name == 'Spawn Spinning Particles' then
		particles = not particles;
		particleSprite = value1;
		ypos = tonumber(value2);
	end
end

function onBeatHit()
	if particles then
		runHaxeCode([[
			var funniSprite:String = "]]..particleSprite..[[";
			var ypos:Int = ]]..ypos..[[;
			var spriteArray:Array<String> = funniSprite.split(',');
			var scale:Float = FlxG.random.float(0.6, 1);
			
			var parti:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image(spriteArray[FlxG.random.int(0, spriteArray.length - 1)]));
			parti.antialiasing = ClientPrefs.globalAntialiasing;
			parti.x = FlxG.random.int(-500, 2000);
			parti.y = game.boyfriend.y + ypos;
			parti.angularVelocity = FlxG.random.float(-90, 90);
			parti.scale.set(scale, scale);
			game.particleGroup.add(parti);

			FlxTween.tween(parti, {y: parti.y - 600, alpha: 0}, FlxG.random.float(1, 7), {
			onComplete: function(tween:FlxTween){
				parti.destroy();
				game.particleGroup.remove(parti);
				parti = null;
			}});
		]])
	end
end
