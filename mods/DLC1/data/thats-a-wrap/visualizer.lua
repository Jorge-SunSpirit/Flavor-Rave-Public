function onCreate()
	addHaxeLibrary("VisualizerBar");
	runHaxeCode([[
		var visualizer:VisualizerBar = new VisualizerBar(0, 0, "horizontal", 20, 0xFFFFCCCB);
		visualizer.cameras = [game.camEffect];
		game.insert(game.members.indexOf(game.getLuaObject('phillystreet')) + 1, visualizer);
		setVar("visualizer", visualizer);
		visualizer.visible = false;
		
		var visualizer2:VisualizerBar = new VisualizerBar(0, 0, "raise", 15, 0xFFFFCCCB);
		visualizer2.cameras = [game.camEffect];
		game.insert(game.members.indexOf(game.getLuaObject('barBottom')) - 1, visualizer2);
		setVar("visualizer2", visualizer2);
		visualizer2.visible = false;
		
		var visualizer3:VisualizerBar = new VisualizerBar(0, 0, "lower", 15, 0xFFFFCCCB);
		visualizer3.cameras = [game.camEffect];
		game.insert(game.members.indexOf(game.getLuaObject('barBottom')) - 1, visualizer3);
		setVar("visualizer3", visualizer3);
		visualizer3.visible = false;
	]]);
end

function thingie(num)
	num = tonumber(num)
	if num == 512 then
		setBlendMode('visualizer', 'add')
		setBlendMode('visualizer2', 'add')
		setBlendMode('visualizer3', 'add')
		setProperty("visualizer2.visible", true);
		setProperty("visualizer2.gapSize", 5);
		setProperty("visualizer2.alpha", 0.7);
		setProperty("visualizer3.visible", true);
		setProperty("visualizer3.gapSize", 5);
		setProperty("visualizer3.alpha", 0.7);
	end
	if num == 576 then
		setProperty("visualizer2.visible", false);
		setProperty("visualizer3.visible", false);
	end
	if num == 724 then
		setProperty("visualizer.visible", true);
		setProperty("visualizer.gapSize", 5);
		setProperty("visualizer.alpha", 0.7);
	end
	if num == 864 then
		setProperty("visualizer.visible", false);
	end
	if num == 1312 then
		setProperty("visualizer2.visible", true);
		setProperty("visualizer3.visible", true);
	end
end