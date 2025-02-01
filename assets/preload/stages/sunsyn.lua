function onCreate()

	makeLuaSprite('dramablack', '', -100, -100);
	makeGraphic('dramablack', 1280*2, 720*2, '000000');
	setScrollFactor('dramablack', 0, 0);
	screenCenter('dramablack');
	addLuaSprite('dramablack', false);
	setProperty('dramablack.alpha', 0.0001);
	
	makeLuaSprite('scan', 'mainmenu/scanlines', 0, 0);
	setScrollFactor('scan', 1, 1);
	addLuaSprite('scan', false);

	makeLuaSprite('bg', 'mainmenu/BG', 0, 0);
	setScrollFactor('bg', 1, 1);
	addLuaSprite('bg', false);
	
	makeLuaSprite('drama', 'mainmenu/SynSun/npt/BGDrama', 0, 0);
	setScrollFactor('drama', 1, 1);
	addLuaSprite('drama', false);	
	setProperty('drama.alpha', 0.0001);
	
	makeLuaSprite('deskbg', 'mainmenu/desk', 0, 0);
	setScrollFactor('deskbg', 1, 1);
	addLuaSprite('deskbg', false);
	
	makeLuaSprite('liveIcon', 'mainmenu/SynSun/live', 10, 10);
	setScrollFactor('liveIcon', 1, 1);
	setObjectCamera('liveIcon', 'effect');
	addLuaSprite('liveIcon', true);
end

function onCreatePost()
	setProperty('isCameraOnForcedPos', true);
    setProperty('camFollow.x', 639);
    setProperty('camFollow.y', 360);
    setProperty('camera.target.x', 639);
    setProperty('camera.target.y', 360);
	setObjectOrder('dadGroup', getObjectOrder('scan')+1);
	
	--This is temp
	setObjectOrder('boyfriendGroup', getObjectOrder('drama')+1);
end