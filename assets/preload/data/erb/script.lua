function onCreatePost()
	setProperty('gfGroup.x', -100);
	setProperty('gfGroup.y', 100);
	setProperty('girlfriendCameraOffset[0]', 200);
	setProperty('boyfriendGroup.x', getProperty('boyfriendGroup.x') + 40);
	setProperty('boyfriendGroup.y', getProperty('boyfriendGroup.y') + 20);
end