--[[
	Gmod osu! - An unofficial port of osu! to Garry's mod.
	None of these codes should be modified or changed without original author's permission, anykind of modification is not allowed.

	You can use it on whatever you like, but you should not claim you're the original author,
	If you're a server owner, do not put this addon behind paywall, or some vip shit

	For translators, if you want to translate this addon, please contact me directly instead of modify the code
	REUPLOAD / REPACK IS NOT ALLOWED

	Copyright (C) 2023 Meika. All rights reserved
]]

OSU.DevDisplaySliderConnectPoints = false

function OSU:WriteSkinTable() -- Im not going to typing all files manually lol
	local items = {}
	for k,v in pairs(file.Find("materials/osu/*", "GAME")) do
		print(v)
		local sName = v
		sName = string.Replace(sName, ".png", "")
		sName = string.Replace(sName, ".jpg", "")
		table.insert(items, {v, sName})
	end
	for k,v in pairs(file.Find("sound/osu/*", "GAME")) do
		print(v)
		local sName = v
		sName = string.Replace(sName, ".mp3", "")
		sName = string.Replace(sName, ".wav", "")
		table.insert(items, {v, sName})
	end
	file.Write(OSU.DevPath.."skintable.txt", "")
	for k,v in next, items do
		file.Append(OSU.DevPath.."skintable.txt", "['"..v[2].."'] = '"..v[1].."',\n")
	end
end

function OSU:CheckDefaultSkins()
	for k,v in next, OSU.SkinList do
		local _file = OSU.DefaultSkinPath..v
		if(!file.Exists(_file, "DATA")) then
			OSU:CopyDefaultSkin()
			return false
		end
	end
	return true
end

function OSU:CopyDefaultSkin()
	OSU:ChatPrint("Copying skins.. game may lagging for a while..")
	local LoadingText = vgui.Create("DLabel")
	local tx, ty = OSU:GetTextSize("DermaLarge", "Copying skin")
	LoadingText:SetPos((ScrW() / 2) - (tx / 2), ScrH() / 2)
	LoadingText:SetText("Loading")
	for k,v in pairs(file.Find("materials/osu/*", "GAME")) do
		local ctx = file.Read("materials/osu/"..v, "GAME")
		file.Write(OSU.DefaultSkinPath..v, ctx)
		LoadingText:SetText("Copying skin : "..v)
	end
	for k,v in pairs(file.Find("sound/osu/*", "GAME")) do
		local ctx = file.Read("sound/osu/"..v, "GAME")
		file.Write(OSU.DefaultSkinPath..v, ctx)
		LoadingText:SetText("Copying skin : "..v)
	end
	LoadingText:Remove()
end

function OSU:DrawOSUPlayField()
	local h = ScrH() * 0.8 
	local w = ((4 / 3) * h)
	local x = (ScrW() / 2) - w / 2
	local y = (ScrH() / 2) - h / 2
	OSU_TestFrame = vgui.Create("DFrame")
	OSU_TestFrame:SetPos(x, y)
	OSU_TestFrame:SetSize(w, h)
	OSU_TestFrame:ShowCloseButton(false)
	OSU_TestFrame.Paint = function()
		draw.RoundedBox(0, 0, 0, w, h, Color(155, 255, 155))
	end
end

function OSU:WriteLog(str)
	local Timestamp = os.time()
	local TimeString = os.date("%H:%M:%S - %d/%m/%Y" , Timestamp)
	if(!file.Exists("osu!/logs/log.txt", "DATA")) then
		file.Write("osu!/logs/log.txt", "This file is used for debugging, if you find anything below please report to me :D, - Meika\n")
	end
	file.Append("osu!/logs/log.txt", TimeString.." : -> "..str.."\n")
end

function OSU:RestoreScore()
	local ssc = OSU.ReplayData.Details.ssc
	local mul = OSU.ReplayData.Details.mul
	local c = 0
	local s = ssc
	local hc = 0
	for k,v in next, OSU.ReplayData.HitDetails do
		local mul_ = (10 + math.floor((c + 1) / 40))
		if(v == 1) then
			s = math.Clamp(s + ((300 + c * mul_) * mul), 0, 2147000000)
			c = c + 1
		elseif(v == 2)  then
			s = math.Clamp(s + ((100 + c * mul_) * mul), 0, 2147000000)
			c = c + 1
		elseif(v == 3)  then
			s = math.Clamp(s + ((50 + c * mul_) * mul), 0, 2147000000)
			c = c + 1
		elseif(v == 4)  then
			c = 0
		elseif(v == 5) then
			s = math.Clamp(s + 50, 0, 2147000000)
			c = c + 1
		elseif(v == 6) then
			c = c + 1
		end
		if(c > hc) then
			hc = c
		end
		s = math.floor(s)
	end
	print(s)
end