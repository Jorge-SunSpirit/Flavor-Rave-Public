stagecameratype = 0;
local saffrun = false;
local floralbop = true;

function onCreate()
	makeLuaSprite('black', '', -100, -100);
    makeGraphic('black', 1280*2, 720*2, '000000');
    setScrollFactor('black', 0, 0);
    screenCenter('black');
	setObjectCamera('black', 'effect')
	addLuaSprite('black', true);

	makeLuaSprite('thisismyplaceholderravebackground', 'closeup/AllBG', 0, 0);
	setScrollFactor('thisismyplaceholderravebackground', 0, 0);
	addLuaSprite('thisismyplaceholderravebackground', false);
	setProperty('thisismyplaceholderravebackground.alpha', 0.0001);

	runHaxeCode([[
		var saffbg1:FlxBackdrop = new FlxBackdrop(Paths.image('stages/greenhouse/saffbg1'), 0x11);
		saffbg1.antialiasing = ClientPrefs.globalAntialiasing;
		game.insert(game.members.indexOf(game.getLuaObject('thisismyplaceholderravebackground')) + 1, saffbg1);
		setVar('saffbg1', saffbg1);
		
		var saffbg2:FlxBackdrop = new FlxBackdrop(Paths.image('stages/greenhouse/saffbg2'), 0x11);
		saffbg2.antialiasing = ClientPrefs.globalAntialiasing;
		game.insert(game.members.indexOf(game.getLuaObject('thisismyplaceholderravebackground')) + 1, saffbg2);
		setVar('saffbg2', saffbg2);
	]]);

	setScrollFactor('saffbg1', 0.1, 0.1);
	scaleObject('saffbg1', 1.1, 1.1);
	setProperty('saffbg1.velocity.x', -60);
	setProperty('saffbg1.velocity.y', -60);
	setProperty('saffbg1.alpha', 0.0001);
	setScrollFactor('saffbg2', 0.1, 0.1);
	scaleObject('saffbg2', 1.1, 1.1);
	setProperty('saffbg2.velocity.x', -60);
	setProperty('saffbg2.velocity.y', -60);
	setProperty('saffbg2.alpha', 0.0001);

	makeAnimatedLuaSprite('DramaIntro', 'stages/greenhouse/intro/SaffIntro', 0, 0);
	addAnimationByPrefix('DramaIntro', 'SaffPresents', 'SaffPresents', 26, false);
	addAnimationByPrefix('DramaIntro', 'SaffSong', 'SaffSong', 26, false);
	addAnimationByPrefix('DramaIntro', 'BySaff', 'BySaff', 26, false);
	addAnimationByPrefix('DramaIntro', 'Feacher', 'Feacher', 26, false);
	addAnimationByPrefix('DramaIntro', 'Sweet', 'Sweet', 26, false);
	addAnimationByPrefix('DramaIntro', 'Dad', 'Dad', 26, false);
	addAnimationByPrefix('DramaIntro', 'ThatGuy', 'ThatGuy', 26, false);
	addAnimationByPrefix('DramaIntro', 'Important', 'Important', 26, false);
    screenCenter('DramaIntro');
	setProperty('DramaIntro.alpha', 0.0001);
	setObjectCamera('DramaIntro', 'effect')
	addLuaSprite('DramaIntro', true);

	makeLuaSprite('runtransition', 'stages/greenhouse/runtransition', -2100, 0);
	setScrollFactor('runtransition', 0, 0);
	scaleObject('runtransition', 1, 1);
	addLuaSprite('runtransition', true);
	setObjectCamera('runtransition', 'effect');

	makeLuaSprite('sweetdash', 'stages/greenhouse/sweetrun', -762, -0);
	setScrollFactor('sweetdash', 1, 1);
	scaleObject('sweetdash', 1, 1);
	addLuaSprite('sweetdash', true);
	setObjectCamera('sweetdash', 'effect');
	setProperty('sweetdash.alpha', 0.0001);

	makeLuaSprite('sourdash', 'stages/greenhouse/sourrun', -762, -28);
	setScrollFactor('sourdash', 1, 1);
	scaleObject('sourdash', 1, 1);
	addLuaSprite('sourdash', true);
	setObjectCamera('sourdash', 'effect');
	setProperty('sourdash.alpha', 0.0001);
	
	makeLuaSprite('saffdash', 'stages/greenhouse/saffrun', -762, -74);
	setScrollFactor('saffdash', 1, 1);
	scaleObject('saffdash', 1, 1);
	addLuaSprite('saffdash', true);
	setObjectCamera('saffdash', 'effect');
	setProperty('saffdash.alpha', 0.0001);

	makeLuaSprite('whitehueh', 'dreamcast/art_BG/whitehueh', 0, 0);
	setScrollFactor('whitehueh', 0, 0);
	addLuaSprite('whitehueh', true);
	setObjectCamera('whitehueh', 'effect');
	setProperty('whitehueh.alpha', 0.0001);

	playAnim('extraChar', 'idle-sad', true)
	playAnim('boyfriend', 'idle-sad', true)
	triggerEvent('Alt Idle Animation', 'Extra', '-sad');
	triggerEvent('Alt Idle Animation', 'BF', '-sad');
	setProperty('noteSkinChangeCharNote', false);
end

function onCreatePost()
	addCharacterToList('sour-run', 'boyfriend');
	addCharacterToList('sour-seasick-sing', 'boyfriend');--Might be funny to have this used
	addCharacterToList('sweet-run', 'extra'); --Replace with running Sweet
	addCharacterToList('saff-scooter', 'dad'); --Replace with scooting Saff
end

function onStepHit()
	if curStep == 21 then
		setProperty('DramaIntro.alpha', 1);
		playAnim('DramaIntro', 'SaffPresents');
	end
	if curStep == 37 then
		playAnim('DramaIntro', 'SaffSong');
	end
	if curStep == 53 then
		playAnim('DramaIntro', 'BySaff');
	end
	if curStep == 71 then
		playAnim('DramaIntro', 'Feacher');
	end
	if curStep == 79 then
		playAnim('DramaIntro', 'Sweet');
	end
	if curStep == 87 then
		playAnim('DramaIntro', 'Dad');
	end
	if curStep == 95 then
		playAnim('DramaIntro', 'ThatGuy');
	end
	if curStep == 103 then
		playAnim('DramaIntro', 'Important');
	end
	if curStep == 111 then
		setProperty('DramaIntro.alpha', 0.0001);
	end
	if curStep == 150 then
		doTweenAlpha('whitehueh', 'whitehueh', 1, 0.6);
	end
	if curStep == 160 then
		setProperty('whitehueh.alpha', 0.0001);
		setProperty('black.alpha', 0.0001);
	end
	if curStep == 576 then
		floralbop = false
	end	
	if curStep == 592 then
		playAnim('floral', 'shock');
	end	
	if curStep == 604 then
		doTweenX('runtransition', 'runtransition', 2400, 0.9);
	end	
	--Remove all of this and use the actual callonLuas event later
	if curStep == 608 then --Carrera Loca
		callOnLuas('bgSwap', {1})
		bgSwap(1);
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.x', 531);
		setProperty('camFollow.y', -72);
		setProperty('camera.target.x', 531);
		setProperty('camera.target.y', -72);
	end

	if curStep == 612 then
		doTweenX('dadGroup', 'dadGroup', -300, 2, "quadinout");
	end
	
	if curStep == 642 then
		setProperty('runtransition.alpha', 0.0001);
		doTweenX('boyfriendGroup', 'boyfriendGroup', 700, 1.3, "quadinout");
	end	
	
	if curStep == 702 then
		doTweenX('extraGroup', 'extraGroup', 200, 1.3, "quadinout");
		doTweenX('runtransition', 'runtransition', -2100, 0.2);
	end	

	if curStep == 838 then
		doTweenX('dadGroup', 'dadGroup', -1400, 1.2, "quadinout");
	end
	
	if curStep == 844 then
		doTweenX('extraGroup', 'extraGroup', -1400, 0.7, "quadinout");
		doTweenX('boyfriendGroup', 'boyfriendGroup', -1200, 0.85, "quadinout");
	end

	if curStep == 860 then
		setProperty('runtransition.alpha', 1);
		doTweenX('runtransition', 'runtransition', 2400, 0.9);
	end	
	
	if curStep == 864 then --Lodestar Shanty
		callOnLuas('bgSwap', {2})
		bgSwap(2);
	end
	
	if curStep == 1098 then
		doTweenAlpha('whitehueh', 'whitehueh', 1, 1.7, "quadinout");
	end
	
	if curStep == 1120 then --Applewood
		callOnLuas('bgSwap', {3})
		bgSwap(3);
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.x', 450);
		setProperty('camFollow.y', -430);
		setProperty('camera.target.x', 450)
		setProperty('camera.target.y', -430)
		doTweenAlpha('whitehueh', 'whitehueh', 0.001, 1);
	end

	if curStep == 1138 then 
		doTweenY('moveCam', 'camFollow', 350, 2.5, "easeincirc");
	end
	
	if curStep == 1180 then 
		setProperty('isCameraOnForcedPos', false);
	end
	
	if curStep == 1632 then --Caramelize
		callOnLuas('bgSwap', {4})
	end

	if curStep == 1888 then
		doTweenAlpha('black', 'black', 1, 1, "quadinout");
	end

	if curStep == 1904 then --CranberryPop
		callOnLuas('bgSwap', {5})
		doTweenAlpha('black', 'black', 0.0001, 1.6, "quadinout");
	end

	if curStep == 2160 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.x', 845);
		doTweenY('moveCam', 'camFollow', -710, 1.5, "easeincirc");
		doTweenAlpha('whitehueh', 'whitehueh', 1, 1.5, "quadinout");
	end

	if curStep == 2192 then 
		setProperty('whitehueh.alpha', 0.0001);
	end
	if curStep == 2207 then
		saffrun = true
	end	
	if curStep == 2208 then
		callOnLuas('bgSwap', {11})
		bgSwap(11);
	end
	
	if curStep == 2212 then --Saff runs by from Right to Left
		doTweenX('dadGroup', 'dadGroup', -1400, 1, "linear");
	end
	
	if curStep == 2228 then -- sour runs by fro mRight to Left
		doTweenX('boyfriendGroup', 'boyfriendGroup', -1400, 1, "linear");
	end
	
	if curStep == 2244 then --Saff runs by from Left to Right
		flipCharacter('saff', 'left');
		doTweenX('dadGroup', 'dadGroup', 1800, 1, "linear");
	end
	
	if curStep == 2260 then --Sweet runs by from Left to Right
		flipCharacter('sweet', 'right');
		doTweenX('extraGroup', 'extraGroup', 1800, 1, "linear");
	end
	
	if curStep == 2270 then --Saff runs by from Right to Left
		flipCharacter('saff', 'right');
		setProperty('dadGroup.x', 1280);
		doTweenX('dadGroup', 'dadGroup', -1400, 1, "linear");
	end
	
	if curStep == 2288 then -- sour runs by fro mRight to Left
		setProperty('boyfriendGroup.x', 1280);
		doTweenX('boyfriendGroup', 'boyfriendGroup', -1400, 1, "linear");
	end	

	if curStep == 2300 then --Sweet runs by from Right to Left
		flipCharacter('sweet', 'left');
		setProperty('extraGroup.x', 1280);
		doTweenX('extraGroup', 'extraGroup', -1500, 1, "linear");
	end
	if curStep == 2320 then
		setProperty('sweetdash.alpha', 1);
		setProperty('sourdash.alpha', 1);
		setProperty('saffdash.alpha', 1);
		doTweenX('sweetdash', 'sweetdash', -72, 0.1, "quadinout");
	end			
	if curStep == 2324 then --Prob have a transition thignie here.
		doTweenX('sourdash', 'sourdash', 173, 0.1, "quadinout");
		flipCharacter('sweet', 'apple');
		flipCharacter('sour', 'apple');
		flipCharacter('saff', 'apple');
	end
	if curStep == 2328 then
		doTweenX('saffdash', 'saffdash', 530, 0.1, "quadinout");
	end		
	if curStep == 2335 then
		saffrun = false
	end	
	if curStep == 2336 then --Timeshock
		setProperty('sweetdash.alpha', 0.0001);
		setProperty('sourdash.alpha', 0.0001);
		setProperty('saffdash.alpha', 0.0001);
		setProperty('saffbg1.alpha', 0.0001);
		setProperty('saffbg2.alpha', 0.0001);
		callOnLuas('bgSwap', {6})
		bgSwap(6);
	end
	
	if curStep == 2592 then --Rainbow Sorbet
		callOnLuas('bgSwap', {7})
	end
	
	if curStep == 2624 then --Wasabi
		callOnLuas('bgSwap', {8})
	end
	
	if curStep == 2656 then -- SynSun
		callOnLuas('bgSwap', {9})
		flipCharacter('sour', 'right');
		flipCharacter('saff', 'left');
	end
	
	if curStep == 2688 then -- Stirring
		callOnLuas('bgSwap', {10})
		flipCharacter('sour', 'apple');
		flipCharacter('saff', 'apple');
	end
	
	if curStep == 2720 then --GreenHouse
		callOnLuas('bgSwap', {0})
		playAnim('floral', 'sleep');
	end
	
end

function funnycam(num)
	if num == '1' then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.x', 150);
		setProperty('camFollow.y', 680);
		setProperty('camera.target.x', 150)
		setProperty('camera.target.y', 680)
	end
	if num == '2' then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.x', 780);
		setProperty('camFollow.y', 570);
		setProperty('camera.target.x', 780)
		setProperty('camera.target.y', 570)
	end
	if num == '3' then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.x', 1120);
		setProperty('camFollow.y', 535);
		setProperty('camera.target.x', 1120)
		setProperty('camera.target.y', 535)
	end
	if num == '4' then
		setProperty('isCameraOnForcedPos', false);
	end
	if num == '5' then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.x', 650);
		setProperty('camFollow.y', 420);
		setProperty('camera.target.x', 650)
		setProperty('camera.target.y', 420)
	end
end

function onUpdateadsafdsfadsafds() --Rename function to onUpdate for debug
	if not keyboardPressed('CONTROL')then
		if keyboardJustPressed('K') then
			triggerEvent('Change Character','bf','sour');
			flipCharacter('saff', 'left');
		end
		if keyboardJustPressed('L') then
			triggerEvent('Change Character','bf','sour');
			flipCharacter('saff', 'right');
		end
		if keyboardJustPressed('Q') then
			callOnLuas('bgSwap', {0});
			bgSwap(0);
		end
		if keyboardJustPressed('W') then
			callOnLuas('bgSwap', {1});
			bgSwap(1);
		end
		if keyboardJustPressed('E') then
			callOnLuas('bgSwap', {2});
			bgSwap(2);
		end
		if keyboardJustPressed('R') then
			callOnLuas('bgSwap', {3});
			bgSwap(4);
		end
		if keyboardJustPressed('T') then
			callOnLuas('bgSwap', {4});
		end
		if keyboardJustPressed('Y') then
			callOnLuas('bgSwap', {5});
		end
		if keyboardJustPressed('U') then
			callOnLuas('bgSwap', {6});
		end
		if keyboardJustPressed('I') then
			callOnLuas('bgSwap', {7});
		end
		if keyboardJustPressed('O') then
			callOnLuas('bgSwap', {8});
		end
		if keyboardJustPressed('P') then
			callOnLuas('bgSwap', {9});
		end
		if keyboardJustPressed('A') then
			callOnLuas('bgSwap', {10});
		end
		if keyboardJustPressed('S') then
			callOnLuas('bgSwap', {11});
			bgSwap(11);
		end
	end
end

function flipCharacter(who, dir)
	if who == 'sweet' then
		if dir == 'right' then
			runHaxeCode([[
				game.extraChar.setFacingFlip(true);
				game.extraChar.facing = 0x0010;
				game.extraChar.dance(true);	
			]]);
		else
			runHaxeCode([[
				game.extraChar.setFacingFlip(false);
				game.extraChar.facing = 0x0001;
				game.extraChar.dance(true);
			]]);
		end
	end
	if who == 'sour' then
		if dir == 'right' then
			runHaxeCode([[
				game.boyfriend.setFacingFlip(0x0010, false);
				game.boyfriend.facing = 0x0010;
				game.boyfriend.dance(true);	
			]]);
		else
			runHaxeCode([[
				game.boyfriend.setFacingFlip(0x0001, true);
				game.boyfriend.facing = 0x0001;
				game.boyfriend.dance(true);
			]]);
		end
	end
	if who == 'saff' then
		if dir == 'left' then
			runHaxeCode([[
				game.dad.setFacingFlip(0x0001,true);
				game.dad.facing = 0x0001;
				game.dad.dance(true);
			]]);
		else
			runHaxeCode([[
				game.dad.setFacingFlip(0x0010, false);
				game.dad.facing = 0x0010;
				game.dad.dance(true);
			]]);
		end
	end
end

function bgSwap(num)
	stagecameratype = num;
	setScrollFactor('dad', 1, 1);
	scaleObject('dad', 1, 1);
	setProperty('isCameraOnForcedPos', false);
	setProperty('thisismyplaceholderravebackground.alpha', 0.001);
	if num == 1 then
		triggerEvent('Change Character','bf','sour-run');
		triggerEvent('Change Character','extra','sweet-run');
		triggerEvent('Change Character','dad','saff-scooter');
		triggerEvent('Alt Idle Animation', 'Extra', '');
		triggerEvent('Alt Idle Animation', 'BF', '-alt');
		
		setScrollFactor('dad', 0.9, 0.7);
		setProperty('boyfriend.danceEveryNumBeats', 4);
		setProperty('extraChar.danceEveryNumBeats', 4);
		setObjectOrder('wall', getObjectOrder('dadGroup')+1);
		setObjectOrder('extraGroup', getObjectOrder('wall')+1);
		setObjectOrder('boyfriendGroup', getObjectOrder('extraGroup')+1);
	end
	
	if num == 2 then
		triggerEvent('Change Character','bf','sour-seasick-sing');
		triggerEvent('Change Character','extra','sweet');
		triggerEvent('Change Character','dad','saff');
		triggerEvent('Alt Idle Animation', 'BF', '');
	end
	
	if num == 11 then
		triggerEvent('Change Character','bf','sour-run');
		triggerEvent('Change Character','extra','sweet-run');
		triggerEvent('Change Character','dad','saff-scooter');
		triggerEvent('Alt Idle Animation', 'Extra', '');
		triggerEvent('Alt Idle Animation', 'BF', '-alt');
		setProperty('isCameraOnForcedPos', true);
		scaleObject('dad', 2, 2);
		characterDance('dad');
		setProperty('thisismyplaceholderravebackground.alpha', 1);
		runHaxeCode([[
			game.cameraBoundaries = null;
			game.defaultCamZoom = 1;
			game.camGame.zoom = 1;
			game.cameraSpeed = 1;
			
			game.camFollow.x = 320;
			game.camFollow.y = 550;
			game.camera.target.x = 320;
			game.camera.target.y = 550;
			
			game.boyfriendGroup.setPosition(1280, 270);			
			game.dadGroup.setPosition(1280, 700);	
			if (game.allowExtra)
			{
				game.extraGroup.setPosition(-1400, 235);
			}
		]]);
	end
	if num ~= 1 and num ~= 2 and num ~= 11 then
		triggerEvent('Change Character','bf','sour');
		triggerEvent('Change Character','extra','sweet');
		triggerEvent('Change Character','dad','saff');
		triggerEvent('Alt Idle Animation', 'Extra', '-sad');
		triggerEvent('Alt Idle Animation', 'BF', '-sad');
	end
end

function onMoveCamera(focus)
	if stagecameratype == 1 then --Car locar
		if focus == 'boyfriend' or focus == 'extra' then
			setProperty('defaultCamZoom', 0.7);
			setProperty('camFollow.x', 641);
			setProperty('camFollow.y', 140);
		elseif focus == 'dad' then
			setProperty('defaultCamZoom', 0.9);
			setProperty('camFollow.x', 270);
			setProperty('camFollow.y', -72);
		end
	end
	
	
end

function onBeatHit()
	if curBeat % 2 == 0 and saffrun then
		if danced then
			danced = false;
				setProperty('saffbg1.alpha', 1);
				setProperty('saffbg2.alpha', 0.0001);
		else
			danced = true;
				setProperty('saffbg1.alpha', 0.0001);
				setProperty('saffbg2.alpha', 1);
		end
	end
	if curBeat % 4 == 0 and floralbop then
			playAnim('floral', 'idle');
	end
end