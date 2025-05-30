function onCreate()
	addHaxeLibrary("VisualizerBar");
	runHaxeCode([[
		var visualizer:VisualizerBar = new VisualizerBar(0, 0, "horizontal", 20, 0xFFFFFFFF);
		visualizer.cameras = [game.camEffect];
		game.insert(game.members.indexOf(game.getLuaObject('city2')) + 1, visualizer);
		setVar("visualizer", visualizer);
		visualizer.visible = false;
	]]);
end

function thingie(num)
	num = tonumber(num)
	if num == 384 then
		setProperty("visualizer.visible", true);
		setProperty("visualizer.gapSize", 4);
		setProperty("visualizer.alpha", 0.85);
	end
	if num == 640 then
		setProperty("visualizer.visible", false);
	end
	if num == 1808 then
		setProperty("visualizer.visible", true);
	end
	if num == 1936 then
		setProperty("visualizer.visible", false);
	end
end