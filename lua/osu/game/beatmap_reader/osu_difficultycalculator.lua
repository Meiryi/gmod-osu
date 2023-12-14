function OSU:CalculateDifficulty(ctx) -- unused, since gmod lua is single threaded, calculate it might cause game lag or freezes
	local DIFFICULTY_SPEED, DIFFICULTY_AIM = 0, 1
	local STAR_SCALING_FACTO = 0.0675
	local EXTREME_SCALING_FACTOR = 0.5
	local PLAYFIELD_WIDTH = 512
	local STRAIN_STEP = 400
	local DECAY_WEIGHT = 0.9
	local beatmap = ctx
	local tpHitObjects = OSU:GetHitObjects(ctx)
	local starRating = -1
end