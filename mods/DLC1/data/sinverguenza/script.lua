function onCreatePost()
	triggerEvent('Note Camera Movement', 10,'')
	
	if not middlescroll then
		noteTweenX('dad4', 0, -500, 0.01, "circinout")
		noteTweenX('dad5', 1, -500, 0.01, "circinout")
		noteTweenX('dad6', 2, -500, 0.01, "circinout")
		noteTweenX('dad7', 3, -500, 0.01, "circinout")
	end
end

function onStepHit()
end

function onBeatHit()
end