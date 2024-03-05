--[[
	Gmod osu! - An unofficial port of osu! to Garry's mod.
	None of these codes should be modified or changed without original author's permission, anykind of modification is not allowed.

	You can use it on whatever you like, but you should not claim you're the original author,
	If you're a server owner, do not put this addon behind paywall, or some vip shit

	For translators, if you want to translate this addon, please contact me directly instead of modify the code
	REUPLOAD / REPACK IS NOT ALLOWED

	Copyright (C) 2023 Meika. All rights reserved
]]
OSU.ImageExtensions = {".png", ".jpg", "jpeg"}
OSU.AudioExtensions = {".wav", ".ogg", ".mp3"}
OSU.CurrentLoadedSkin = "?"
OSU.KeyOverlayBG = Material("osu/inputoverlay-background.png", "smooth")
OSU.KeyOverlay = Material("osu/inputoverlay-key.png", "smooth")

function OSU:IsWhitelistedImage(fn)
	local str = string.Replace(fn, "@2x", "")
	local bList = {
		["approachcircle"] = true,
		["hitcircle"] = true,
		["hitcircleoverlay"] = true,
		["cursor"] = true,
		["cursormiddle"] = true,
		["cursortrail"] = true,
		["lighting"] = true,
		["reversearrow"] = true,
		["default-0"] = true,
		["default-1"] = true,
		["default-2"] = true,
		["default-3"] = true,
		["default-4"] = true,
		["default-5"] = true,
		["default-6"] = true,
		["default-7"] = true,
		["default-8"] = true,
		["default-9"] = true,
		["selection-mod-easy"] = true,
		["selection-mod-nofail"] = true,
		["selection-mod-halftime"] = true,
		["selection-mod-hardrock"] = true,
		["selection-mod-suddendeath"] = true,
		["selection-mod-doubletime"] = true,
		["selection-mod-hidden"] = true,
		["selection-mod-flashlight"] = true,
		["selection-mod-relax"] = true,
		["selection-mod-relax2"] = true,
		["selection-mod-spunout"] = true,
		["selection-mod-autoplay"] = true,
		--[[
		["score-0"] = true,
		["score-1"] = true,
		["score-2"] = true,
		["score-3"] = true,
		["score-4"] = true,
		["score-5"] = true,
		["score-6"] = true,
		["score-7"] = true,
		["score-8"] = true,
		["score-9"] = true,
		["score-percent"] = true,
		["score-x"] = true,
		["score-comma"] = true,
		["score-dot"] = true,
		]]
		["welcome_text"] = true,
	}
	return bList[str] != true
end

function OSU:GetFileNameNoExtension(input)
	return string.Explode(".", input)[1]
end

function OSU:FileExtensionType(input)
	if(input == "mp3" || input == "wav") then
		return 1
	else
		return 2
	end
end

function OSU:SetupSkins()
	if(OSU.CurrentLoadedSkin == OSU.CurrentSkinPath) then return end
	OSU.CurrentLoadedSkin = OSU.CurrentSkinPath
	local path = "data/osu!/skins/"..OSU.CurrentSkinPath.."/"
	local dpath = "data/osu!/skins/default/"
	local type = {}
	for k,v in next, OSU.SkinList do
		local t = string.GetExtensionFromFilename(v)
		local fn = OSU:GetFileNameNoExtension(v)
		local found = false
		if(OSU:FileExtensionType(t) == 1) then -- Audio
			for x,y in next, OSU.AudioExtensions do
				local _fn = fn..y
				if(file.Exists(path.._fn, "GAME")) then
					OSU.CurrentSkin[k] = path.._fn
					found = true
					break
				end
			end
		else -- Image
			if(!OSU.LoadSkinImage && OSU:IsWhitelistedImage(fn)) then OSU.CurrentSkin[k] = dpath..v continue end
			for x,y in next, OSU.ImageExtensions do
				local _fn = fn..y
				if(file.Exists(path.._fn, "GAME")) then
					OSU.CurrentSkin[k] = path.._fn
					found = true
					break
				end
			end
		end
		if(!found) then
			OSU.CurrentSkin[k] = dpath..v
		end
	end
	OSU.CursorTexture = Material(OSU.CurrentSkin["cursor"])
	OSU.CursorMiddleTexture = Material(OSU.CurrentSkin["cursormiddle"])
	OSU.CurTrailMat = Material(OSU.CurrentSkin["cursortrail"])
	--[[
		OSU.KeyOverlayBG = Material("osu/inputoverlay-background.png")
		OSU.KeyOverlay = Material("osu/inputoverlay-key.png")
	]]
	for i = 0, 9, 1 do
		OSU.ScoreMaterialTable[tostring(i)] = Material(OSU.CurrentSkin["score-"..i])
	end
end