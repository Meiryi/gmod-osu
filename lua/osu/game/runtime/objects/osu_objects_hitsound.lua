--[[
	Gmod osu! - An unofficial port of osu! to Garry's mod.
	None of these codes should be modified or changed without original author's permission, anykind of modification is not allowed.

	You can use it on whatever you like, but you should not claim you're the original author,
	If you're a server owner, do not put this addon behind paywall, or some vip shit

	For translators, if you want to translate this addon, please contact me directly instead of modify the code
	REUPLOAD / REPACK IS NOT ALLOWED

	Copyright (C) 2023 Meika. All rights reserved
]]

function OSU:HitsoundChooser(_int)
	local ret = "normal"
	local sdList = {
		[0] = "normal",
		[1] = "whistle",
		[2] = "finish",
		[3] = "clap",
	}
	if(sdList[_int] != nil) then ret = sdList[_int] end
	if(OSU.FinishToWhistle) then
		if(ret == "finish") then
			ret = "whistle"
		end
	end
	return ret
end