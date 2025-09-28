function onCreate()
	addHaxeLibrary('FlxBackdrop', 'flixel.addons.display');

	posX = -1200;
	posY = -580;
	scale = 1.75;

	makeLuaSprite('sky', 'stages/greenhouse/sky', posX, posY);
	setScrollFactor('sky', 0.2, 0.2);
	scaleObject('sky', scale, scale);
	addLuaSprite('sky', false);

	makeLuaSprite('trees', 'stages/greenhouse/bg', posX, posY);
	setScrollFactor('trees', 0.4, 0.8);
	scaleObject('trees', scale, scale);
	addLuaSprite('trees', false);
	
	makeLuaSprite('greenhouse', 'stages/greenhouse/greenhouse_Tablemerged', posX, posY);
	setScrollFactor('greenhouse', 1, 1);
	scaleObject('greenhouse', scale, scale);
	addLuaSprite('greenhouse', false);

	makeLuaSprite('fgFlora', 'stages/greenhouse/fgFlora', posX, posY);
	setScrollFactor('fgFlora', 1.2, 1.2);
	scaleObject('fgFlora', scale, scale);
	addLuaSprite('fgFlora', true);

	makeAnimatedLuaSprite('floral', 'stages/greenhouse/Floral', 300, 160);
	addAnimationByPrefix('floral', 'idle', 'FloralIdle', 24, false);
	addAnimationByPrefix('floral', 'shock', 'FloralShock', 24, false);
	addAnimationByPrefix('floral', 'sleep', 'FloralSleep', 24, true);
	setScrollFactor('floral', 1, 1);
	scaleObject('floral', 1.3, 1.3);
	addLuaSprite('floral', false);

	makeLuaSprite('overlayAdd', 'stages/greenhouse/addOverlay', posX, posY);
	setScrollFactor('overlayAdd', 0, 0);
	scaleObject('overlayAdd', scale, scale);
	setBlendMode('overlayAdd', 'overlay');
	screenCenter('overlayAdd');
	addLuaSprite('overlayAdd', true);
	
	-- SPACER 608

	makeLuaSprite('skyCL', 'stages/corianda-run/sky', -400, -400);
	setScrollFactor('skyCL', 0.1, 0.12);
	scaleObject('skyCL', 1.2, 1.2);
	addLuaSprite('skyCL', false);
	setProperty('skyCL.alpha', 0.0001);
	
	runHaxeCode([[
		var cityscroll:FlxBackdrop = new FlxBackdrop(Paths.image('stages/corianda-run/cityscroll'), 0x01);
		cityscroll.antialiasing = ClientPrefs.globalAntialiasing;
		game.insert(game.members.indexOf(game.getLuaObject('skyCL')) + 1, cityscroll);
		setVar('cityscroll', cityscroll);
		
		var clouds:FlxBackdrop = new FlxBackdrop(Paths.image('stages/corianda-run/clouds'), 0x01);
		clouds.antialiasing = ClientPrefs.globalAntialiasing;
		game.insert(game.members.indexOf(game.getLuaObject('cityscroll')) + 1, clouds);
		setVar('clouds', clouds);
	
		var wall:FlxBackdrop = new FlxBackdrop(Paths.image('stages/corianda-run/wall'), 0x01);
		wall.antialiasing = ClientPrefs.globalAntialiasing;
		game.insert(game.members.indexOf(game.getLuaObject('clouds')) + 1, wall);
		setVar('wall', wall);
	]]);
	
	setScrollFactor('wall', 0.9, 0.7);
	setProperty('wall.velocity.x', 3500);	
	setProperty('wall.alpha', 0.0001);--
	
	setScrollFactor('clouds', 0.9, 0.7);
	setProperty('clouds.velocity.x', 800);
	setProperty('clouds.y', -150);
	setProperty('clouds.alpha', 0.0001);--
	
	setScrollFactor('cityscroll', 0.2, 0.24);
	setProperty('cityscroll.velocity.x', 150);	
	setProperty('cityscroll.alpha', 0.0001);--
	
	-- SPACER 864
	
	posX = -1400;
	posY = -900;
	scale = 2;
	
	makeLuaSprite('skyLS', 'stages/lady-morton/Sky', -1250, -1000);
	setScrollFactor('skyLS', 0.1, 0.1);
	scaleObject('skyLS', scale, scale);
	setProperty('skyLS.alpha', 0.0001);
	addLuaSprite('skyLS', false);
	
	makeLuaSprite('boat', 'stages/greenhouse/extra/lodestar', posX, posY);
	setScrollFactor('boat', 1, 1);
	scaleObject('boat', scale, scale);
	setProperty('boat.alpha', 0.0001);
	addLuaSprite('boat', false);
	
	-- SPACER 1120
	
	posX = -900;
	posY = -500;
	scale = 1.1;
	
	makeLuaSprite('SkyAW', 'enzync/sky', posX, posY);
	setScrollFactor('SkyAW', 0.3, 0.3);
	scaleObject('SkyAW', scale, scale);
	setProperty('SkyAW.alpha', 0.0001);
	addLuaSprite('SkyAW', false);

	makeLuaSprite('backcityAW', 'enzync/back', posX, posY);
	setScrollFactor('backcityAW', 0.7, 0.7);
	scaleObject('backcityAW', scale, scale);
	setProperty('backcityAW.alpha', 0.0001);
	addLuaSprite('backcityAW', false);

	makeLuaSprite('buildingAW', 'enzync/buildings', posX, posY);
	setScrollFactor('buildingAW', 0.92, 0.92);
	scaleObject('buildingAW', scale, scale);
	setProperty('buildingAW.alpha', 0.0001);
	addLuaSprite('buildingAW', false);

	makeLuaSprite('frontAW', 'enzync/foreground', posX, posY);
	setScrollFactor('frontAW', 1, 1);
	scaleObject('frontAW', scale, scale);
	setProperty('frontAW.alpha', 0.0001);
	addLuaSprite('frontAW', false);
	
	--SPACER 1632
	
	posX = -1200;
	posY = -700;
	scale = 1.5;
	
	makeLuaSprite('SkyCARA', 'togarashi/sky', posX, posY);
	setScrollFactor('SkyCARA', 0.2, 0.2);
	scaleObject('SkyCARA', scale, scale);
	setProperty('SkyCARA.alpha', 0.0001);
	addLuaSprite('SkyCARA', false);

	makeLuaSprite('backcity', 'togarashi/back', posX, posY);
	setScrollFactor('backcity', 0.5, 0.5);
	scaleObject('backcity', scale, scale);
	setProperty('backcity.alpha', 0.0001);
	addLuaSprite('backcity', false);

	makeLuaSprite('middle', 'togarashi/middle', posX, posY);
	setScrollFactor('middle', 0.8, 0.8);
	scaleObject('middle', scale, scale);
	setProperty('middle.alpha', 0.0001);
	addLuaSprite('middle', false);

	makeLuaSprite('front', 'togarashi/main', posX, posY);
	setScrollFactor('front', 1, 1);
	scaleObject('front', scale, scale);
	setProperty('front.alpha', 0.0001);
	addLuaSprite('front', false);
	
	makeAnimatedLuaSprite('gate', 'togarashi/gate', posX, posY);
	addAnimationByPrefix('gate', 'idle', 'GateBump', 24, false);
	playAnim('gate', 'idle');
	finishAnim('gate');
	setProperty('gate.alpha', 1);
	setScrollFactor('gate', 1, 1);
	scaleObject('gate', scale, scale);
	setProperty('gate.alpha', 0.0001);
	addLuaSprite('gate', false);
	
	-- SPACER 1904
	
	posX = -1000;
	posY = -700;
	scale = 1.5;
	
	makeLuaSprite('skyCP', 'bg1/sky', posX, posY);
	setScrollFactor('skyCP', 0, 0);
	scaleObject('skyCP', scale, scale);
	setProperty('skyCP.alpha', 0.001);
	addLuaSprite('skyCP', false);

	makeLuaSprite('cloudsCP', 'bg1/clouds', posX, posY);
	setScrollFactor('cloudsCP', 0.15, 0.2);
	scaleObject('cloudsCP', scale, scale);
	setProperty('cloudsCP.alpha', 0.001);
	addLuaSprite('cloudsCP', false);
	
	makeLuaSprite('hill', 'stages/greenhouse/extra/cranberrypop_hills', posX, posY);
	setScrollFactor('hill', 0.3, 1);
	scaleObject('hill', scale, scale);
	setProperty('hill.alpha', 0.001);
	addLuaSprite('hill', false);
	
	makeLuaSprite('streetlights', 'stages/greenhouse/extra/cranberrypop_lamppost', posX, posY);
	setScrollFactor('streetlights', 0.6, 1);
	scaleObject('streetlights', scale, scale);
	setProperty('streetlights.alpha', 0.001);
	addLuaSprite('streetlights', false);
	
	makeLuaSprite('parking', 'bg1/parking', posX, posY);
	setScrollFactor('parking', 1, 1);
	scaleObject('parking', scale, scale);
	setProperty('parking.alpha', 0.001);
	addLuaSprite('parking', false);
	
	makeLuaSprite('venue', 'bg1/venue', posX, posY);
	setScrollFactor('venue', 0.5, 1);
	scaleObject('venue', scale, scale);
	setProperty('venue.alpha', 0.001);
	addLuaSprite('venue', false);
	
	makeLuaSprite('sweetsourbus', 'stages/greenhouse/extra/cranberrypop_busvan', posX, posY);
	setScrollFactor('sweetsourbus', 0.8, 1);
	scaleObject('sweetsourbus', scale, scale);
	setProperty('sweetsourbus.alpha', 0.001);
	addLuaSprite('sweetsourbus', false);
	
	makeLuaSprite('equipment', 'bg1/equipment', posX, posY);
	setScrollFactor('equipment', 0.95, 1);
	scaleObject('equipment', scale, scale);
	setProperty('equipment.alpha', 0.001);
	addLuaSprite('equipment', false);
	
	-- SPACER 2336
	
	posX = -1400;
	posY = -950;
	scale = 1.7;
	
	makeLuaSprite('skyTS', 'bg2/SourSweet_bg2_1', posX, posY);
	setScrollFactor('skyTS', 0.1, 1);
	scaleObject('skyTS', scale, scale);
	setProperty('skyTS.alpha', 0.001);
	addLuaSprite('skyTS', false);

	makeLuaSprite('bgTS', 'bg2/SourSweet_bg2_2', posX, posY);
	setScrollFactor('bgTS', 0.8, 1);
	scaleObject('bgTS', scale, scale);
	setProperty('bgTS.alpha', 0.001);
	addLuaSprite('bgTS', false);
	
	makeLuaSprite('foregroundTS', 'bg2/SourSweet_bg2_3', posX, posY);
	setScrollFactor('foregroundTS', 1.1, 1);
	scaleObject('foregroundTS', scale, scale);
	setProperty('foregroundTS.alpha', 0.001);
	addLuaSprite('foregroundTS', true);
	
	-- SPACER 2592
	
	posX = -450;
	posY = -940;
	scale = 1;

	makeLuaSprite('SkyRS', 'stages/greenhouse/extra/rs_sky', posX, posY);
	setScrollFactor('SkyRS', 0.05, 0.05);
	scaleObject('SkyRS', scale, scale);
	setProperty('SkyRS.alpha', 0.001);
	addLuaSprite('SkyRS', false);
	
	makeLuaSprite('FrontMountains', 'stages/greenhouse/extra/rs_mountains', posX, posY);
	setScrollFactor('FrontMountains', 0.52, 0.52);
	scaleObject('FrontMountains', scale, scale);
	setProperty('FrontMountains.alpha', 0.001);
	addLuaSprite('FrontMountains', false);
	
	makeLuaSprite('Main', 'stages/greenhouse/extra/rs_main', posX, posY);
	setScrollFactor('Main', 1, 1);
	scaleObject('Main', scale, scale);
	setProperty('Main.alpha', 0.001);
	addLuaSprite('Main', false);
	
	-- SPACER 2624
	
	posX = -500;
	posY = -700;
	scale = 1.2;
	
	makeLuaSprite('SkyWAS', 'backstreet/Sky', posX, posY);
	setScrollFactor('SkyWAS', 0, 0);
	scaleObject('SkyWAS', scale, scale);
	setProperty('SkyWAS.alpha', 0.001);
	addLuaSprite('SkyWAS', false);
	
	makeLuaSprite('BGCity', 'backstreet/BGCity', posX, posY);
	setScrollFactor('BGCity', 0.2, 0.9);
	scaleObject('BGCity', scale, scale);
	setProperty('BGCity.alpha', 0.001);
	addLuaSprite('BGCity', false);
	
	makeLuaSprite('Road', 'stages/greenhouse/extra/wasabi_main', posX, posY);
	setScrollFactor('Road', 1, 1);
	scaleObject('Road', scale, scale);
	setProperty('Road.alpha', 0.001);
	addLuaSprite('Road', false);
	
	makeAnimatedLuaSprite('MovingPieces', 'backstreet/MovingPieces', posX, posY + 445);
	addAnimationByPrefix('MovingPieces', 'idle', 'TogaAnim', 24, true);
	playAnim('MovingPieces', 'idle');
	scaleObject('MovingPieces', scale, scale);
	addLuaSprite('MovingPieces', false);
	setScrollFactor('MovingPieces', 1, 1);
	setProperty('MovingPieces.alpha', 0.001);
	
	-- SPACER 2656
	
	makeLuaSprite('synsunbg', 'stages/greenhouse/extra/synsunbg', 0, 0);
	setScrollFactor('synsunbg', 1, 1);
	setProperty('synsunbg.alpha', 0.001);
	addLuaSprite('synsunbg', false);
	
	makeLuaSprite('scan', 'mainmenu/scanlines', 0, 0);
	setScrollFactor('scan', 1, 1);
	setProperty('scan.alpha', 0.001);
	addLuaSprite('scan', false);

	makeLuaSprite('bg', 'mainmenu/BG', 0, 0);
	setScrollFactor('bg', 1, 1);
	setProperty('bg.alpha', 0.001);
	addLuaSprite('bg', false);
	
	makeLuaSprite('deskbg', 'mainmenu/desk', 0, 0);
	setScrollFactor('deskbg', 1, 1);
	setProperty('deskbg.alpha', 0.001);
	addLuaSprite('deskbg', true);
	
	-- SPACER 2688
	
	posX = -1350;
	posY = -940;
	scale = 2.5;
	
	makeLuaSprite('SkySTIR', 'stages/chicory/sky', posX, posY);
	setScrollFactor('SkySTIR', 0.6, 0.6);
	scaleObject('SkySTIR', scale, scale);
	setProperty('SkySTIR.alpha', 0.001);
	addLuaSprite('SkySTIR', false);
	
	makeLuaSprite('Restaurant', 'stages/chicory/main', posX, posY);
	setScrollFactor('Restaurant', 1, 1);
	scaleObject('Restaurant', scale, scale);
	setProperty('Restaurant.alpha', 0.001);
	addLuaSprite('Restaurant', false);
	
	makeLuaSprite('Light', 'stages/greenhouse/extra/stirring_lights', posX, posY);
	setScrollFactor('Light', 1, 1);
	scaleObject('Light', scale, scale);
	setProperty('Light.alpha', 0.001);
	addLuaSprite('Light', true);
	
	makeLuaSprite('Tables', 'stages/chicory/tables', posX, posY);
	setScrollFactor('Tables', 1.1, 1.1);
	scaleObject('Tables', scale, scale);
	setProperty('Tables.alpha', 0.001);
	addLuaSprite('Tables', true);
	
end

function onCreatePost()
end

function onBeatHit()
	if curBeat % 2 == 0 then
		playAnim('gate', 'idle');
	end
end

function bgSwap(num)
	setProperty('isCameraOnForcedPos', false);
		
	setProperty('sky.alpha', 0.0001);
	setProperty('trees.alpha', 0.0001);
	setProperty('greenhouse.alpha', 0.0001);
	setProperty('fgFlora.alpha', 0.0001);
	setProperty('floral.alpha', 0.0001);
	setProperty('overlayAdd.alpha', 0.0001);
	
	setProperty('skyCL.alpha', 0.0001);
	setProperty('cityscroll.alpha', 0.0001);
	setProperty('clouds.alpha', 0.0001);
	setProperty('wall.alpha', 0.0001);
	
	setProperty('skyLS.alpha', 0.0001);
	setProperty('boat.alpha', 0.0001);
	
	setProperty('SkyAW.alpha', 0.0001);
	setProperty('backcityAW.alpha', 0.0001);
	setProperty('buildingAW.alpha', 0.0001);
	setProperty('frontAW.alpha', 0.0001);
	
	setProperty('SkyCARA.alpha', 0.0001);
	setProperty('backcity.alpha', 0.0001);
	setProperty('middle.alpha', 0.0001);
	setProperty('front.alpha', 0.0001);
	setProperty('gate.alpha', 0.0001);
	
	setProperty('skyCP.alpha', 0.0001);
	setProperty('cloudsCP.alpha', 0.0001);
	setProperty('hill.alpha', 0.0001);
	setProperty('streetlights.alpha', 0.0001);
	setProperty('parking.alpha', 0.0001);
	setProperty('venue.alpha', 0.0001);
	setProperty('sweetsourbus.alpha', 0.0001);
	setProperty('equipment.alpha', 0.0001);
	
	setProperty('skyTS.alpha', 0.0001);
	setProperty('bgTS.alpha', 0.0001);
	setProperty('foregroundTS.alpha', 0.0001);
	
	setProperty('SkyRS.alpha', 0.0001);
	setProperty('FrontMountains.alpha', 0.0001);
	setProperty('Main.alpha', 0.0001);
	
	setProperty('SkyWAS.alpha', 0.0001);
	setProperty('BGCity.alpha', 0.0001);
	setProperty('Road.alpha', 0.0001);
	setProperty('MovingPieces.alpha', 0.0001);
	
	setProperty('synsunbg.alpha', 0.0001);
	setProperty('scan.alpha', 0.0001);
	setProperty('bg.alpha', 0.0001);
	setProperty('deskbg.alpha', 0.0001);
	
	setProperty('SkySTIR.alpha', 0.0001);
	setProperty('Restaurant.alpha', 0.0001);
	setProperty('Light.alpha', 0.0001);
	setProperty('Tables.alpha', 0.0001);
	
	if num == 0 then
		setProperty('sky.alpha', 1);
		setProperty('trees.alpha', 1);
		setProperty('greenhouse.alpha', 1);
		setProperty('fgFlora.alpha', 1);
		setProperty('floral.alpha', 1);
		setProperty('overlayAdd.alpha', 1);
		
		-- json properties
		runHaxeCode([[
			//game.cameraBoundaries = [-1110, -590, 1942, 864];
			game.cameraBoundaries = null;
			game.defaultCamZoom = 0.6;
			game.camGame.zoom = 0.6;
			game.cameraSpeed = 1;
			
			game.boyfriendGroup.setPosition(580, 270);
			game.boyfriendCameraOffset = [0, 10];
			
			game.dadGroup.setPosition(-100, 280);
			game.opponentCameraOffset = [70, -40];
			
			game.gfGroup.setPosition(1000, 160);
			game.girlfriendCameraOffset = [0, 0];
			
			if (game.allowExtra)
			{
				game.extraGroup.setPosition(820, 235);
				game.extraCameraOffset = [0, 0];
			}
		]]);
	end
	if num == 1 then
		setProperty('skyCL.alpha', 1);
		setProperty('cityscroll.alpha', 1);
		setProperty('clouds.alpha', 1);
		setProperty('wall.alpha', 1);
		
		-- json properties
		runHaxeCode([[
			//game.cameraBoundaries = [-1110, -590, 1942, 864];
			game.cameraBoundaries = null;
			game.defaultCamZoom = 0.7;
			game.camGame.zoom = 0.7;
			game.cameraSpeed = 2.4;
			
			game.boyfriendGroup.setPosition(1700, 0);
			game.boyfriendCameraOffset = [0, -100];
			
			game.dadGroup.setPosition(1700, -410);
			game.opponentCameraOffset = [0, 0];
			
			game.gfGroup.setPosition(622, -340);
			game.girlfriendCameraOffset = [0, 0];
			
			if (game.allowExtra)
			{
				game.extraGroup.setPosition(1700, 0);
				game.extraCameraOffset = [-900, -200];
			}
		]]);	
	end
	if num == 2 then
		setProperty('skyLS.alpha', 1);
		setProperty('boat.alpha', 1);
		
		runHaxeCode([[
			game.cameraBoundaries = [-71, -195, 1098, 800];
			//game.cameraBoundaries = null;
			game.defaultCamZoom = 0.7;
			game.camGame.zoom = 0.7;
			game.cameraSpeed = 1;
			
			game.boyfriendGroup.setPosition(580, 270);
			game.boyfriendCameraOffset = [0, 0];
			
			game.dadGroup.setPosition(-100, 280);
			game.opponentCameraOffset = [0, 0];
			
			game.gfGroup.setPosition(1000, 160);
			game.girlfriendCameraOffset = [0, 0];
			
			if (game.allowExtra)
			{
				game.extraGroup.setPosition(820, 235);
				game.extraCameraOffset = [0, 0];
			}
		]]);
	end
	if num == 3 then
		setProperty('SkyAW.alpha', 1);
		setProperty('backcityAW.alpha', 1);
		setProperty('buildingAW.alpha', 1);
		setProperty('frontAW.alpha', 1);
		
		runHaxeCode([[
			game.cameraBoundaries = [-258, -1310, 1648, 640];
			//game.cameraBoundaries = null;
			game.defaultCamZoom = 0.82;
			game.camGame.zoom = 0.82;
			game.cameraSpeed = 1;
			
			game.boyfriendGroup.setPosition(1050, 90);
			game.boyfriendCameraOffset = [0, 10];
			
			game.dadGroup.setPosition(120, 150);
			game.opponentCameraOffset = [70, 10];
			
			game.gfGroup.setPosition(400, 110);
			game.girlfriendCameraOffset = [0, 0];
			
			if (game.allowExtra)
			{
				game.extraGroup.setPosition(1350, 40);
				game.extraCameraOffset = [0, 10];
			}
		]]);
	end
	if num == 4 then
		setProperty('SkyCARA.alpha', 1);
		setProperty('backcity.alpha', 1);
		setProperty('middle.alpha', 1);
		setProperty('front.alpha', 1);
		setProperty('gate.alpha', 1);
		
		runHaxeCode([[
			game.cameraBoundaries = [-558, -3144, 2058, 560];
			//game.cameraBoundaries = null;
			game.defaultCamZoom = 0.76;
			game.camGame.zoom = 0.76;
			game.cameraSpeed = 1;
			
			game.boyfriendGroup.setPosition(920, 130);
			game.gfGroup.setPosition(-50, 100);
			game.dadGroup.setPosition(50, 115);
			
			game.boyfriendCameraOffset = [0, 10];
			game.opponentCameraOffset = [0, 0];
			game.girlfriendCameraOffset = [0, 0];
			
			if (game.allowExtra)
			{
				game.extraGroup.setPosition(1170, 100);
				game.extraCameraOffset = [0, 0];
			}
		]]);
	end
	if num == 5 then
		setProperty('skyCP.alpha', 1);
		setProperty('cloudsCP.alpha', 1);
		setProperty('hill.alpha', 1);
		setProperty('streetlights.alpha', 1);
		setProperty('parking.alpha', 1);
		setProperty('venue.alpha', 1);
		setProperty('sweetsourbus.alpha', 1);
		setProperty('equipment.alpha', 1);
		
		runHaxeCode([[
			game.cameraBoundaries = [-358, -3142, 2352, 890];
			//game.cameraBoundaries = null;
			game.defaultCamZoom = 0.9;
			game.camGame.zoom = 0.9;
			game.cameraSpeed = 1;
			
			game.boyfriendGroup.setPosition(1050, 90);
			game.boyfriendCameraOffset = [0, 0];
			
			game.dadGroup.setPosition(-50, 90);
			game.opponentCameraOffset = [0, 0];
			
			game.gfGroup.setPosition(50, 75);
			game.girlfriendCameraOffset = [0, 0];
			
			if (game.allowExtra)
			{
				game.extraGroup.setPosition(750, 75);
				game.extraCameraOffset = [0, 0];
			}
		]]);
	end
	if num == 6 then
		setProperty('skyTS.alpha', 1);
		setProperty('bgTS.alpha', 1);
		setProperty('foregroundTS.alpha', 1);
		
		runHaxeCode([[
			game.cameraBoundaries = [-1110, -590, 1942, 864];
			//game.cameraBoundaries = null;
			game.defaultCamZoom = 0.65;
			game.camGame.zoom = 0.65;
			game.cameraSpeed = 1;
			
			game.boyfriendGroup.setPosition(770, 150);
			game.boyfriendCameraOffset = [0, -60];
			
			game.dadGroup.setPosition(0, 100);
			game.opponentCameraOffset = [0, -60];
			
			game.gfGroup.setPosition(400, 130);
			game.girlfriendCameraOffset = [0, 0];
			
			if (game.allowExtra)
			{
				game.extraGroup.setPosition(1150, 170);
				game.extraCameraOffset = [0, 0];
			}
		]]);
	end
	if num == 7 then
		setProperty('SkyRS.alpha', 1);
		setProperty('FrontMountains.alpha', 1);
		setProperty('Main.alpha', 1);
		
		runHaxeCode([[
			game.cameraBoundaries = [192, -8904, 1506, 700];
			//game.cameraBoundaries = null;
			game.defaultCamZoom = 0.67;
			game.camGame.zoom = 0.67;
			game.cameraSpeed = 1;
			
			game.boyfriendGroup.setPosition(930, 120);
			game.boyfriendCameraOffset = [0, 10];
			
			game.dadGroup.setPosition(90, 90);
			game.opponentCameraOffset = [70, 10];
			
			game.gfGroup.setPosition(400, 110);
			game.girlfriendCameraOffset = [0, 0];
			
			if (game.allowExtra)
			{
				game.extraGroup.setPosition(1200, 90);
				game.extraCameraOffset = [0, 0];
			}
		]]);
		
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.x', 818);
		setProperty('camFollow.y', 423);
		setProperty('camera.target.x', 818);
		setProperty('camera.target.y', 423);
	end
	if num == 8 then
		setProperty('SkyWAS.alpha', 1);
		setProperty('BGCity.alpha', 1);
		setProperty('Road.alpha', 1);
		setProperty('MovingPieces.alpha', 1);
		
		runHaxeCode([[
			game.cameraBoundaries = [600, -480, 1740, 500];
			game.defaultCamZoom = 0.7;
			game.camGame.zoom = 0.7;
			game.cameraSpeed = 1;
			
			game.boyfriendGroup.setPosition(1100, 95);
			game.boyfriendCameraOffset = [0, 30];
			
			game.dadGroup.setPosition(-120, 70);
			game.opponentCameraOffset = [70, 30];
			
			game.gfGroup.setPosition(400, 110);
			game.girlfriendCameraOffset = [0, 0];
			
			if (game.allowExtra)
			{
				game.extraGroup.setPosition(800, 55);
				game.extraCameraOffset = [0, 0];
			}
		]]);
		
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.x', 700);
		setProperty('camFollow.y', 350);
		setProperty('camera.target.x', 700);
		setProperty('camera.target.y', 350);
	end
	if num == 9 then
		setProperty('synsunbg.alpha', 1);
		setProperty('scan.alpha', 1);
		setProperty('bg.alpha', 1);
		setProperty('deskbg.alpha', 1);
		
		runHaxeCode([[
			game.cameraBoundaries = null;
			game.defaultCamZoom = 1;
			game.camGame.zoom = 1;
			game.cameraSpeed = 1;
			
			game.boyfriendGroup.setPosition(200, -80);
			game.boyfriendCameraOffset = [0, 10];
			
			game.dadGroup.setPosition(850, 0);
			game.opponentCameraOffset = [70, -40];
			
			if (game.allowExtra)
			{
				game.extraGroup.setPosition(600, 0);
				game.extraCameraOffset = [0, 0];
			}
		]]);
		
		setObjectOrder('dadGroup', getObjectOrder('bg')+1);
		setObjectOrder('boyfriendGroup', getObjectOrder('synsunbg')+1);
		setObjectOrder('extraGroup', getObjectOrder('synsunbg')+1);
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.x', 639);
		setProperty('camFollow.y', 359);
		setProperty('camera.target.x', 639);
		setProperty('camera.target.y', 359);
	end
	if num == 10 then
		setProperty('SkySTIR.alpha', 1);
		setProperty('Restaurant.alpha', 1);
		setProperty('Light.alpha', 1);
		setProperty('Tables.alpha', 1);
		
		runHaxeCode([[
			//game.cameraBoundaries = [-1110, -590, 1942, 864];
			game.cameraBoundaries = null;
			game.defaultCamZoom = 0.5;
			game.camGame.zoom = 0.5;
			game.cameraSpeed = 1;
			
			game.boyfriendGroup.setPosition(800, 80);
			game.boyfriendCameraOffset = [0, 10];
			
			game.dadGroup.setPosition(240, 110);
			game.opponentCameraOffset = [70, -40];
			
			game.gfGroup.setPosition(500, 110);
			game.girlfriendCameraOffset = [0, 0];
			
			if (game.allowExtra)
			{
				game.extraGroup.setPosition(1000, 80);
				game.extraCameraOffset = [0, 10];
			}
		]]);
		setObjectOrder('dadGroup', getObjectOrder('Restaurant')+1);
		setObjectOrder('boyfriendGroup', getObjectOrder('Restaurant')+1);
		setObjectOrder('extraGroup', getObjectOrder('Restaurant')+1);
		
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.x', 828);
		setProperty('camFollow.y', 381);
		setProperty('camera.target.x', 828);
		setProperty('camera.target.y', 381);
	end
end