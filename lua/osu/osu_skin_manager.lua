--[[
	Gmod osu! - An unofficial port of osu! to Garry's mod.
	None of these codes should be modified or changed without original author's permission, anykind of modification is not allowed.

	You can use it on whatever you like, but you should not claim you're the original author,
	If you're a server owner, do not put this addon behind paywall, or some vip shit

	For translators, if you want to translate this addon, please contact me directly instead of modify the code
	REUPLOAD / REPACK IS NOT ALLOWED

	Copyright (C) 2023 Meika. All rights reserved
]]

function OSU:SetupSkins()
	for k,v in next, OSU.SkinList do
		OSU.CurrentSkin[k] = "data/"..OSU.CurrentSkinPath..v
	end
	OSU.CursorTexture = Material(OSU.CurrentSkin["cursor"])
	OSU.CursorMiddleTexture = Material(OSU.CurrentSkin["cursormiddle"])
end

function OSU:LoadSkin(path)
	
end