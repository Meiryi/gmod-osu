--[[
	Gmod osu! - An unofficial port of osu! to Garry's mod.
	None of these codes should be modified or changed without original author's permission, anykind of modification is not allowed.

	You can use it on whatever you like, but you should not claim you're the original author,
	If you're a server owner, do not put this addon behind paywall, or some vip shit

	For translators, if you want to translate this addon, please contact me directly instead of modify the code
	REUPLOAD / REPACK IS NOT ALLOWED

	Copyright (C) 2023 Meika. All rights reserved
]]

function OSU:GetScoreWidth(gap, tsize)
	local str = tostring(OSU.Score)
	local len = string.len(str)
	local width = 0
	for i = 1, len, 1 do
		local _s = string.sub(str, i, i)
		local _m, _w, _h = OSU:PickMaterial(_s)
		width = width + (_w * tsize) + gap
	end
	return width
end

function OSU:PickRankingImage(acc)
	if(acc >= 100) then
		local m = Material(OSU.CurrentSkin["ranking-X"])
		local w = m:GetInt("$realwidth")
		local h = m:GetInt("$realheight")
		return m, w, h
	end
	if(acc >= 96 && acc < 100) then
		local m = Material(OSU.CurrentSkin["ranking-S"])
		local w = m:GetInt("$realwidth")
		local h = m:GetInt("$realheight")
		return m, w, h
	end
	if(acc >= 88 && acc < 96) then
		local m = Material(OSU.CurrentSkin["ranking-A"])
		local w = m:GetInt("$realwidth")
		local h = m:GetInt("$realheight")
		return m, w, h
	end
	if(acc >= 80 && acc < 88) then
		local m = Material(OSU.CurrentSkin["ranking-B"])
		local w = m:GetInt("$realwidth")
		local h = m:GetInt("$realheight")
		return m, w, h
	end
	if(acc >= 70 && acc < 80) then
		local m = Material(OSU.CurrentSkin["ranking-C"])
		local w = m:GetInt("$realwidth")
		local h = m:GetInt("$realheight")
		return m, w, h
	end
	if(acc < 70) then
		local m = Material(OSU.CurrentSkin["ranking-D"])
		local w = m:GetInt("$realwidth")
		local h = m:GetInt("$realheight")
		return m, w, h
	end
end

function OSU:SetupResultPanel(name, fBack, func, date)
	if(IsValid(OSU.ResultLayer)) then OSU.ResultLayer:Remove() end
	if(name == nil) then name = "Invalid" end
	local topH = ScreenScale(50)
	local gapX = ScreenScale(3)
	local gapY = ScreenScale(5)
	local tgap = ScreenScale(1)
	local tsize = 1.5
	local tw, th = OSU:GetMaterialSizeMul(OSU.CurrentSkin["score-0"], tsize)
	local iw, ih = OSU:GetMaterialSize(OSU.CurrentSkin["score-0"])
	local _w = OSU:GetScoreWidth(tgap, tsize)
	local mat, mat_w, mat_h = OSU:PickRankingImage(OSU.Accuracy)
	local topgap = ScreenScale(3)
	local Timestamp = os.time()
	local TimeString = os.date("%H:%M:%S - %d/%m/%Y" , Timestamp)
	if(date != nil) then TimeString = date end
	OSU.ResultLayer = OSU:CreateFrame(nil, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 0), true)
	OSU.ResultLayer.iAlpha = 0
	OSU.ResultLayer.Paint = function()
		OSU.ResultLayer.iAlpha = math.Clamp(OSU.ResultLayer.iAlpha + OSU:GetFixedValue(15), 0, 255)
		draw.RoundedBox(0, 0, 0, ScrW(), topH, Color(0, 0, 0, 200))
		draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 150))
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(mat)
		surface.DrawTexturedRect(ScrW() - (mat_w + ScreenScale(20)), topH + ScreenScale(12), mat_w, mat_h)
		if(OSU.BeatmapDetails["Title"] != nil && OSU.BeatmapDetails["Mapper"] != nil) then
			draw.DrawText(OSU.BeatmapDetails["Title"], "OSUBeatmapResultTitle", topgap, topgap, Color(255, 255, 255, OSU.ResultLayer.iAlpha), TEXT_ALIGN_LEFT)
			draw.DrawText("Beatmap by "..OSU.BeatmapDetails["Mapper"], "OSUBeatmapResultMapper", topgap, topgap + ScreenScale(18), Color(255, 255, 255, OSU.ResultLayer.iAlpha), TEXT_ALIGN_LEFT)
			draw.DrawText("Played by "..name.." on "..TimeString, "OSUBeatmapResultMapper", topgap, topgap + ScreenScale(30), Color(255, 255, 255, OSU.ResultLayer.iAlpha), TEXT_ALIGN_LEFT)
		end
	end
	OSU:CreateBackButton(OSU.ResultLayer, OSU_MENU_STATE_BEATMAP, fBack, func)
	local resultBG = OSU:CreateImage(OSU.ResultLayer, gapX, gapY + topH, ScreenScale(285), ScreenScale(237), OSU.CurrentSkin["ranking-panel"], false)
	local innerFrame = OSU:CreateImage(resultBG, 0, 0, ScreenScale(285), ScreenScale(237), OSU.CurrentSkin["ranking-panel"], false)
	local _3w, _3h = OSU:GetMaterialSize(OSU.CurrentSkin["hit300"])
	local _1w, _1h = OSU:GetMaterialSize(OSU.CurrentSkin["hit100"])
	local _5w, _5h = OSU:GetMaterialSize(OSU.CurrentSkin["hit50"])
	local _0w, _0h = OSU:GetMaterialSize(OSU.CurrentSkin["hit0"])
	local _aw, _ah = OSU:GetMaterialSize(OSU.CurrentSkin["ranking-accuracy"])
	local _cw, _ch = OSU:GetMaterialSize(OSU.CurrentSkin["ranking-maxcombo"])
	local _3m = Material(OSU.CurrentSkin["hit300"])
	local _1m = Material(OSU.CurrentSkin["hit100"])
	local _5m = Material(OSU.CurrentSkin["hit50"])
	local _mm = Material(OSU.CurrentSkin["hit0"])
	local _am = Material(OSU.CurrentSkin["ranking-accuracy"])
	local _cm = Material(OSU.CurrentSkin["ranking-maxcombo"])
	local _gap = ScreenScale(3)
	innerFrame.Paint = function()
		OSU:DrawStringAsMaterial(OSU.Score, innerFrame:GetWide() - (_w + (gapX * 2)), ih * 2.15, tsize, tgap, 255, false, false)
		surface.SetMaterial(_3m)
		local yPos = 60
		local diff = math.abs((ScreenScale(yPos) + _3h) - (ScreenScale(yPos) + th)) / 2
		surface.DrawTexturedRect(ScreenScale(16), ScreenScale(yPos), _3w, _3h)
		OSU:DrawStringAsMaterial(OSU.HIT300, ScreenScale(24) + _3w + _gap, (ScreenScale(yPos) + th) - diff, tsize, tgap, 255, false, false)
		surface.SetMaterial(_1m)
		local yPos = 100
		local diff = math.abs((ScreenScale(yPos) + _1h) - (ScreenScale(yPos) + th)) / 2
		surface.DrawTexturedRect(ScreenScale(16), ScreenScale(yPos), _1w, _1h)
		OSU:DrawStringAsMaterial(OSU.HIT100, ScreenScale(24) + _3w + _gap, (ScreenScale(yPos) + th) - diff, tsize, tgap, 255, false, false)
		local yPos = 140
		local diff = math.abs((ScreenScale(yPos) + _5h) - (ScreenScale(yPos) + th)) / 2
		surface.SetMaterial(_5m)
		surface.DrawTexturedRect(ScreenScale(16), ScreenScale(yPos), _5w, _5h)
		OSU:DrawStringAsMaterial(OSU.HIT50, ScreenScale(24) + _3w + _gap, (ScreenScale(yPos) + th) - diff, tsize, tgap, 255, false, false)
		local yPos = 140
		local diff = math.abs((ScreenScale(yPos) + _0h) - (ScreenScale(yPos) + th)) / 2
		surface.SetMaterial(_mm)
		surface.DrawTexturedRect(ScreenScale(150), ScreenScale(yPos), _0w, _0h)
		OSU:DrawStringAsMaterial(OSU.MISS, ScreenScale(150) + _3w + _gap, (ScreenScale(yPos) + th) - diff, tsize, tgap, 255, false, false)
		local yPos = 175
		local diff = math.abs((ScreenScale(yPos) + _ch) - (ScreenScale(yPos) + th)) / 2
		surface.SetMaterial(_cm)
		surface.DrawTexturedRect(ScreenScale(16), ScreenScale(yPos), _cw, _ch)
		OSU:DrawStringAsMaterial(OSU.HighestCombo, ScreenScale(16), (ScreenScale(yPos) + th + _ch + gapY) - diff, tsize, tgap, 255, false, false)
		local diff = math.abs((ScreenScale(yPos) + _ch) - (ScreenScale(yPos) + th)) / 2
		surface.SetMaterial(_am)
		surface.DrawTexturedRect(ScreenScale(150), ScreenScale(yPos), _aw, _ah)
		OSU:DrawStringAsMaterial(OSU.Accuracy.."p", ScreenScale(150), (ScreenScale(yPos) + th + _ah + gapY) - diff, tsize, tgap, 255, false, false)
	end
	local clr = 255
	if(!OSU.HasReplay) then
		clr = 125
	end
	local w, h = OSU:GetMaterialSize(OSU.CurrentSkin["pause-replay"])
	local replay = OSU.ResultLayer:Add("DImageButton")
	replay:SetPos(ScrW() - (w + _gap), topH + ScreenScale(24) + mat_h)
	replay:SetSize(w, h)
	replay:SetImage(OSU.CurrentSkin["pause-replay"])
	replay.iAlpha = 200
	replay.Think = function()
		if(replay:IsHovered()) then
			replay.iAlpha = math.Clamp(replay.iAlpha + OSU:GetFixedValue(5), 200, 255)
		else
			replay.iAlpha = math.Clamp(replay.iAlpha - OSU:GetFixedValue(5), 200, 255)
		end
		replay:SetColor(Color(clr, clr, clr, replay.iAlpha))
	end
	replay.DoClick = function()
		if(!OSU.HasReplay) then
			OSU:CenteredMessage("This result doesn't have replay yet!")
			return
		end
		if(OSU.FetchingReplay) then
			OSU:CenteredMessage("Already downloading replay file!")
			return
		end
		OSU:CenteredMessage("Downloading replay..")
		OSU.FetchingReplay = true
		local bid, rid = OSU.CurrentBeatmapID, OSU.CurrentReplayID
		OSU.CurrentReplayData = data
			http.Fetch("https://osu.gmaniaserv.xyz/apiv2/LD/Replay/"..bid.."/"..rid..".gosr",
				function(body, length, headers, code)
					if(IsValid(OSU.PlayFieldLayer)) then return end
					local data = util.JSONToTable(body)
					if(data == nil) then
						OSU:CenteredMessage("Replay file not found!")
					else
						if(bid == OSU.CurrentBeatmapID) then
							OSU.AutoNotes = false
							OSU.EZ = OSU.ModesTMP.EZ
							OSU.NF = OSU.ModesTMP.NF
							OSU.HR = OSU.ModesTMP.HR
							OSU.SD = OSU.ModesTMP.SD
							OSU.HD = OSU.ModesTMP.HD
							OSU.FL = OSU.ModesTMP.FL
							OSU.RL = OSU.ModesTMP.RL
							OSU.AP = OSU.ModesTMP.AP
							OSU.SO = OSU.ModesTMP.SO
							OSU.DT = OSU.ModesTMP.DT
							OSU.CurrentReplayData = data
							OSU:StartBeatmap(OSU.BeatmapCTX, OSU.BeatmapDetails, OSU.CurrentBeatmapID, true)
							OSU.ResultLayer:Remove()
						end
					end
					OSU.FetchingReplay = false
				end,

				function(message)
					OSU:CenteredMessage("Replay file not found!")
					OSU.FetchingReplay = false
				end
			)
	end
end