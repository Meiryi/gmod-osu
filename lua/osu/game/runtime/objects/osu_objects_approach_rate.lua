--[[
	Gmod osu! - An unofficial port of osu! to Garry's mod.
	None of these codes should be modified or changed without original author's permission, anykind of modification is not allowed.

	You can use it on whatever you like, but you should not claim you're the original author,
	If you're a server owner, do not put this addon behind paywall, or some vip shit

	For translators, if you want to translate this addon, please contact me directly instead of modify the code
	REUPLOAD / REPACK IS NOT ALLOWED

	Copyright (C) 2023 Meika. All rights reserved
]]

function OSU:GetApprTime()
	local ms = 1800
	local _mul = 1
	if(OSU.AR <= 5) then
		ms = 1800 - (OSU.AR * (120 * _mul))
	else
		ms = (1950) - (OSU.AR * (150 * _mul))
	end
	ms = ms / 1000
	return ms
end

function OSU:GetApproachRate(size)
	local _to = size * 2
	local ms = 1800
	local fade = 800
	local _mul = 1
	if(OSU.AR <= 5) then
		ms = 1800 - (OSU.AR * (120 * _mul))
		fade = 800 + 400 * (5 - OSU.AR) / 5
	else
		ms = (1950) - (OSU.AR * (150 * _mul))
		fade = 800 - 500 * (OSU.AR - 5) / 5
	end
	ms = ms / 1000
	local _ms = ms
	fade = fade / 1000
	local appr = _to / (60 * ms)
	local fade = 255 / (60 * fade)
	return appr, fade, _ms
end