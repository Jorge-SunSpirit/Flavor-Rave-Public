function onCreate()
	addHaxeLibrary('FlxBackdrop', 'flixel.addons.display');

	--First secton
	posX = -1000;
	posY = -3000;
	scale = 2;
	
	makeLuaSprite('sky', 'stages/lady-morton/Sky', -1250, -1000);
	setScrollFactor('sky', 0.1, 0.1);
	scaleObject('sky', scale, scale);
	addLuaSprite('sky', false);
	
	makeLuaSprite('skyafter', 'stages/lady-morton/SkyAfter', -1250, -1000);
	setScrollFactor('skyafter', 0.1, 0.1);
	scaleObject('skyafter', scale, scale);
	setProperty('skyafter.alpha', 0.0001);
	addLuaSprite('skyafter', false);

	makeAnimatedLuaSprite('waves', 'stages/lady-morton/waves', posX, posY + 2800);
	addAnimationByPrefix('waves', 'idle', 'Waves', 24, false);
	setScrollFactor('waves', 0, 0);
	addLuaSprite('waves', false);
	scaleObject('waves', scale, scale);
    screenCenter('waves');
	setProperty('waves.alpha', 0.0001);
	
	makeLuaSprite('mast', 'stages/lady-morton/Mast', posX, posY);
	setScrollFactor('mast', 1, 0.95);
	scaleObject('mast', scale, scale);
	addLuaSprite('mast', false);
	
	makeAnimatedLuaSprite('flag', 'stages/lady-morton/Jolly Roger', posX + 1850, posY + 450);
	addAnimationByPrefix('flag', 'opens', 'Jolly Roger', 12, true);
	setScrollFactor('flag', 1, 0.95);
	playAnim('flag', 'idle');
	addLuaSprite('flag', false);
	
	makeLuaSprite('deck', 'stages/lady-morton/Deck', posX, posY + 2800);
	setScrollFactor('deck', 1, 1);
	scaleObject('deck', scale, scale);
	addLuaSprite('deck', false);
	
	makeLuaSprite('poop', 'stages/lady-morton/PoopdeckHahaLOL', posX, posY + 2800);
	setScrollFactor('poop', 1, 0.9);
	scaleObject('poop', scale, scale);
	addLuaSprite('poop', false);

	makeAnimatedLuaSprite('sharp', 'stages/lady-morton/Sharp_BG', posX + 2200, posY + 2852);
	addAnimationByPrefix('sharp', 'idle', 'Sharp_Idle', 24, false);
	addAnimationByPrefix('sharp', 'hey', 'Sharp_Hey', 24, false);
	addAnimationByPrefix('sharp', 'wayho', 'Sharp_WayHo', 24, false);
	setScrollFactor('sharp', 1, 1);
	scaleObject('sharp', 0.54, 0.54);
	addLuaSprite('sharp', false);

	makeLuaSprite('quater', 'stages/lady-morton/Quarterdeck', posX, posY + 3200);
	setScrollFactor('quater', 1, 1);
	scaleObject('quater', scale, scale);
	addLuaSprite('quater', false);

	makeLuaSprite('sail', 'stages/lady-morton/Sail', posX, posY + 1350);
	setScrollFactor('sail', 1, 1.008);
	scaleObject('sail', scale, scale);
	addLuaSprite('sail', true);

	makeAnimatedLuaSprite('adobo', 'stages/lady-morton/Adobo_BG', posX + 1170, posY + 2972);
	addAnimationByPrefix('adobo', 'left', 'Adobo_LeftBop', 24, false);
	addAnimationByPrefix('adobo', 'right', 'Adobo_RightBop', 24, false);
	addAnimationByPrefix('adobo', 'hey', 'Adobo_Hey', 24, false);
	addAnimationByPrefix('adobo', 'wayho', 'Adobo_WayHo', 24, false);
	setScrollFactor('adobo', 1, 1);
	scaleObject('adobo', 0.45, 0.45);
	addLuaSprite('adobo', false);

	makeAnimatedLuaSprite('door', 'stages/lady-morton/door', posX, posY);
	addAnimationByPrefix('door', 'idle', 'door door', 12, false);
	addAnimationByPrefix('door', 'opens', 'open', 12, false);
	setScrollFactor('door', 1, 1);
	playAnim('door', 'idle');
	addLuaSprite('door', false);

	makeAnimatedLuaSprite('saff', 'stages/lady-morton/SAFF', posX + 144, posY + 3600);
	addAnimationByPrefix('saff', 'hide', 'Hide', 24, true);
	addAnimationByPrefix('saff', 'emerge', 'Emerge', 24, false);
	addAnimationByPrefix('saff', 'idle', 'Idle', 24, false);
	setScrollFactor('saff', 1, 1);
	playAnim('saff', 'hide');
	scaleObject('saff', 1.35, 1.35);
	addLuaSprite('saff', false);
	
	makeAnimatedLuaSprite('midpir8', 'stages/lady-morton/MidPirates', posX + 1440, posY + 3650);
	addAnimationByPrefix('midpir8', 'appear', 'Appear', 24, false);
	addAnimationByPrefix('midpir8', 'idle', 'MidPirate', 24, false);
	setScrollFactor('midpir8', 1, 1);
	scaleObject('midpir8', 1.3, 1.3);
	setProperty('midpir8.alpha', 0.0001);
	addLuaSprite('midpir8', false);

	makeAnimatedLuaSprite('leftpir8', 'stages/lady-morton/LeftPirates', posX + 320, posY + 3905);
	addAnimationByPrefix('leftpir8', 'appear', 'Appear', 24, false);
	addAnimationByPrefix('leftpir8', 'idle', 'LeftPirate', 24, false);
	setScrollFactor('leftpir8', 1, 1);
	scaleObject('leftpir8', 1.35, 1.35);
	setProperty('leftpir8.alpha', 0.0001);
	addLuaSprite('leftpir8', false);

	makeAnimatedLuaSprite('rightpir8', 'stages/lady-morton/RightPirates', posX + 2286, posY + 4000);
	addAnimationByPrefix('rightpir8', 'appear', 'Appear', 24, false);
	addAnimationByPrefix('rightpir8', 'idle', 'RightPirate', 24, false);
	setScrollFactor('rightpir8', 1, 1);
	scaleObject('rightpir8', 1.35, 1.35);
	setProperty('rightpir8.alpha', 0.0001);
	addLuaSprite('rightpir8', true);

	makeLuaSprite('trapdoor1', 'stages/lady-morton/GrateL', posX + 253, posY + 4364);
	setScrollFactor('trapdoor1', 1, 1);
	scaleObject('trapdoor1', scale, scale);
	addLuaSprite('trapdoor1', false);
	
	makeLuaSprite('trapdoor2', 'stages/lady-morton/GrateR', posX + 253, posY + 4364);
	setScrollFactor('trapdoor2', 1, 1);
	scaleObject('trapdoor2', scale, scale);
	addLuaSprite('trapdoor2', false);

	makeLuaSprite('ropes', 'stages/lady-morton/Ropes', posX, posY);
	setScrollFactor('ropes', 1, 1);
	scaleObject('ropes', scale, scale);
	addLuaSprite('ropes', true);

	makeAnimatedLuaSprite('sharpstart', 'stages/lady-morton/SharpIntro', 384, -2850);
	addAnimationByPrefix('sharpstart', 'idle', 'SharpIntro', 24, false);
	setScrollFactor('sharpstart', 1, 1);
	addLuaSprite('sharpstart', true);

	setObjectOrder('boyfriendGroup', getObjectOrder('sharp')+1);
end