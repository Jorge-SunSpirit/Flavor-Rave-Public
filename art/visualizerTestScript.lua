-- Example script on how to use the visualizer bars. Recreates the visualizer bars from Will in Cerulean Symphony

function onCreate()
	addHaxeLibrary("VisualizerBar");
	runHaxeCode([[
		var visualizer:VisualizerBar = new VisualizerBar(0, 0, "horizontal", 25, 0xFFFFCCCB);
		visualizer.cameras = [game.camEffect];
		game.add(visualizer);
		setVar("visualizer", visualizer);
		visualizer.visible = false;
	]]);
end

function onSongStart()
	setProperty("visualizer.visible", true);
	setProperty("visualizer.gapSize", 5);
	setProperty("visualizer.alpha", 0.5);
end