--[[
	Gmod osu! - An unofficial port of osu! to Garry's mod.
	None of these codes should be modified or changed without original author's permission, anykind of modification is not allowed.

	You can use it on whatever you like, but you should not claim you're the original author,
	If you're a server owner, do not put this addon behind paywall, or some vip shit

	For translators, if you want to translate this addon, please contact me directly instead of modify the code
	REUPLOAD / REPACK IS NOT ALLOWED

	Copyright (C) 2023 Meika. All rights reserved
]]

function OSU:Get300Time()
	local ms = 80
	ms = 90 - (6 * OSU.OD)
	return ms / 1000
end

function OSU:Get100Time()
	local ms = 140
	ms = 180 - (8 * OSU.OD)
	return ms / 1000
end

function OSU:Get50Time()
	local ms = 200
	ms = 270 - (10 * OSU.OD)
	return ms / 1000
end

function OSU:GetMissTime()
	local ms = 200
	ms = 270 - (10 * OSU.OD)
	return ms / 1000
end

function OSU:UpdateOD()
	OSU.HIT300Time = OSU:Get300Time()
	OSU.HIT100Time = OSU:Get100Time()
	OSU.HIT50Time = OSU:Get50Time()
end