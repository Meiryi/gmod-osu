--[[
	Gmod osu! - An unofficial port of osu! to Garry's mod.
	None of these codes should be modified or changed without original author's permission, anykind of modification is not allowed.

	You can use it on whatever you like, but you should not claim you're the original author,
	If you're a server owner, do not put this addon behind paywall, or some vip shit

	For translators, if you want to translate this addon, please contact me directly instead of modify the code
	REUPLOAD / REPACK IS NOT ALLOWED

	Copyright (C) 2023 Meika. All rights reserved
]]

function OSU:GetKeysAmount(ctx, datas)
	local ctx_ = string.Explode("\n", ctx)
	local k = {}
	for i = 1, 10, 1 do
		k[i] = false
	end
	for i = datas["Object Range"][1], datas["Object Range"][2], 1 do
		local line = string.Explode(",", ctx_[i])[1]
		if(line == "1344") then
			k[10] = true
		end
		if(line == "1216") then
			k[9] = true
		end
		if(line == "1088") then
			k[8] = true
		end
		if(line == "960") then
			k[7] = true
		end
		if(line == "832") then
			k[6] = true
		end
		if(line == "704") then
			k[5] = true
		end
		if(line == "448") then
			k[4] = true
		end
		if(line == "320") then
			k[3] = true
		end
		if(line == "192") then
			k[2] = true
		end
		if(line == "64") then
			k[1] = true
		end
	end
	for i = 10, 1, -1 do
		if(k[i]) then return i end
	end
	--[[
		if(string.find(ctx, "1344,")) then
			return 10
		end
		if(string.find(ctx, "1216,")) then
			return 9
		end
		if(string.find(ctx, "1088,")) then
			return 8
		end
		if(string.find(ctx, "960,")) then
			return 7
		end
		if(string.find(ctx, "832,")) then
			return 6
		end
		if(string.find(ctx, "704,")) then
			return 5
		end
		if(string.find(ctx, "448,")) then
			return 4
		end
		if(string.find(ctx, "320,")) then
			return 3
		end
		if(string.find(ctx, "192,")) then
			return 2
		end
		if(string.find(ctx, "64,")) then
			return 1
		end
	]]
end

function OSU:PickModeIconMat()
	local l = {
		[0] = OSU.STDTx,
		[1] = OSU.TKOTx,
		[2] = OSU.CTBTx,
		[3] = OSU.MNATx,
	}
	return l[OSU.CurrentMode]
end

function OSU:IsSupportedMode(mode)
	local l = {
		[0] = true,
		[1] = false,
		[2] = false,
		[3] = false,
	}
	return l[mode]
end

function OSU:PickModeIcon(mode)
	local l = {
		[0] = OSU.CurrentSkin["mode-osu"],
		[1] = OSU.CurrentSkin["mode-taiko"],
		[2] = OSU.CurrentSkin["mode-fruits"],
		[3] = OSU.CurrentSkin["mode-mania"],
	}
	return l[mode]
end

function OSU:ScrollToPanel(vPanel)

end

function OSU:ValidateBeatmapPath(maps, path)
	for k,v in next, maps do
		return file.Exists(path..v, "DATA")
	end
end

function OSU:GetBeatmapVersion(data, path)
	local version = "Unknown"
	local id = math.random(0, 99999999)
	local preview = 0
	local mode = -1
	local ctx = string.Explode("\n", data)
	for k,v in pairs(ctx) do
		if(string.find(v, "Version:")) then
			version = string.Replace(v, "Version:", "")
		end
		if(string.find(v, "BeatmapID:")) then
			id = string.Replace(v, "BeatmapID:", "")
		end
		if(string.find(v, "PreviewTime:")) then
			preview = string.Replace(v, "PreviewTime: ")
		end
		if(string.find(v, "Mode:")) then
			mode = string.Replace(v, "Mode: ", "")
		end
	end
	return version, tonumber(id), tonumber(preview), tonumber(mode)
end

function OSU:GetBeatmapName(maps, path)
	local name = {
		["Title"] = "Unknown",
		["TitleUnicode"] = "未知",
		["Creator:"] = "Unknown",
		["Artist"] = "Unknown",
		["ArtistUnicode"] = "未知",
		["BeatmapSetID"] = math.random(-9999999, -1),
		["AudioFilename"] = "Unknown",
	}
	for x,y in next, maps do
		local data = file.Read(path..y, "DATA")
		local ctx = string.Explode("\n", data)
		for k,v in pairs(ctx) do
			if(string.find(v, "Title:")) then
				name["Title"] = string.Replace(v, "Title:", "")
			end
			if(string.find(v, "TitleUnicode:")) then
				name["TitleUnicode"] = string.Replace(v, "TitleUnicode:", "")
			end
			if(string.find(v, "Creator:")) then
				name["Creator"] = string.Replace(v, "Creator:", "")
			end
			if(string.find(v, "Artist:")) then
				name["Artist"] = string.Replace(v, "Artist:", "")
			end
			if(string.find(v, "ArtistUnicode:")) then
				name["ArtistUnicode"] = string.Replace(v, "ArtistUnicode:", "")
			end
			if(string.find(v, "BeatmapSetID:")) then
				name["BeatmapSetID"] = string.Replace(v, "BeatmapSetID:", "")
			end
			if(string.find(v, "AudioFilename:")) then
				name["AudioFilename"] = path..string.Replace(v, "AudioFilename: ", "")
			end
			if(string.find(v, "BeatDivisor:")) then
				local num = string.Replace(v, "BeatDivisor: ", "")
				OSU.BeatDivisor = tonumber(num)
			end
		end
		break
	end
	return name
end

function OSU:GetBeatmapBackground(maps, path)
	if(OSU.ForceDefaultBG) then return OSU.CurrentSkin["menu-background"] end
	local ret = OSU.CurrentSkin["menu-background"]
	local processStr = ''
	for x,y in next, maps do
		local data = file.Read(path..y, "DATA")
		if(data == nil) then return OSU.CurrentSkin["menu-background"] end
		local ctx = string.Explode("\n", data)
		for k,v in pairs(ctx) do
			if(string.find(v, '0,0,"')) then
				if(string.find(v, ".jpg") || string.find(v, ".png")) then
					processStr = v
				end
			end
		end
		break
	end
	if(processStr == '') then return ret end
	local len = string.len(processStr)
	local _start = -1
	local _end = -1
	for i = 1, len, 1 do
		if(string.sub(processStr, i, i) == '"') then
			if(_start == -1) then
				_start = i
			else
				if(_end == -1) then
					_end = i
				end
			end
		end
	end
	ret = string.Replace(string.sub(processStr, _start, _end), '"', '')
	local fullP = "data/"..path..ret
	if(!file.Exists(fullP, "GAME")) then
		return OSU.CurrentSkin["menu-background"]
	end
	return fullP
end

local scrollOffset = 0
function OSU:RefreshBeatmapList(keyWord)
	OSU.BeatmapPanels = {}
	local hasinvalidmap = false
	local hasbeatmap = false
	OSU.PanelAmount = 0
	OSU.BeatmapScrollPanel:Clear()
	local iconsx = ScreenScale(14)
	local iconsx_ = ScreenScale(12)
	local gap = ScreenScale(3)
	local gap2 = ScreenScale(4)
	local gap2x_ = gap2 * 2
	local gap2x = gap * 2
	local f, dirs = file.Find(OSU.BeatmapPath.."*", "DATA")
	local _rand = math.random(1, #dirs)
	OSU.GetVBarMaxScrollTime = OSU.CurTime + 0.2
	for k,v in next, dirs do
		local _path = OSU.BeatmapPath..v.."/"
		local _fosu = file.Find(_path.."*.osu", "DATA")
		if(#_fosu <= 0) then
			_fosu = file.Find(_path.."*.dem", "DATA")
			if(#_fosu <= 0) then
				continue
			end
		end
		if(!OSU:ValidateBeatmapPath(_fosu, _path)) then
			OSU:WriteLog("Found invalid beatmap(s), folder -> "..v)
			hasinvalidmap = true
			continue
		end
		local _this = false
		if(_rand == k) then
			_this = true
		end
		OSU.GetVBarMaxScrollTime = OSU.CurTime + 0.2
		local name = OSU:GetBeatmapName(_fosu, _path)
		if(!OSU:CheckRatingExists(name["BeatmapSetID"]) && tonumber(name["BeatmapSetID"]) > 0) then
			OSU:InsertRequest(name["BeatmapSetID"])
		end
		local fullName = name[OSU.BeatmapArtistType].." - "..name[OSU.BeatmapNameType]
		local amounts = #_fosu
		local bg = OSU:GetBeatmapBackground(_fosu, _path)
		local timingpoints = {}
		local bpm = 60
		local bgmat = Material(bg)
		local bgmat_w = ScreenScale(70)
		if(!OSU.SongThumbnails) then bgmat_w = 0 end
		if(OSU.CurrentBeatmapSet == name["BeatmapSetID"]) then
			_this = true
		else
			if(OSU.CurrentBeatmapSet != "") then
				_this = false
			end
		end
		local pBase = OSU:CreateFrameScroll(OSU.BeatmapScrollPanel, OSU.BeatmapScrollPanel:GetWide(), ScreenScale(40), Color(0, 0, 0, 0))
		pBase.ShouldSort = false
		pBase.TargetMaps = 1
		pBase.StrTitle = name[OSU.BeatmapNameType]
		pBase.iAlpha = 0
		pBase.pID = v
		pBase.SubPanels = {}
		pBase.StarRatings = {}
		pBase.NextCheckTime = 0
		pBase.Clicked = false
		pBase.TargetHeight = pBase:GetTall()
		local wide, height = pBase:GetWide(), pBase:GetTall()
		pBase.Title = OSU:CreateFrame(pBase, 0, 0, wide, height, Color(200, 100, 149, 220), false)
		pBase.Title.iAlpha = 180
		pBase.Title.iAlphaInc = 0
		function pBase.Title:OnCursorEntered()
			pBase.Title.iAlpha = 255
			OSU:PlaySoundEffect(OSU.CurrentSkin["menuclick"])
		end
		function pBase.Title:OnMousePressed(keyCode)
			local targetIndex = 1
			if(keyCode == 107) then
				OSU.NextClickTime = OSU.CurTime + 0.15
				OSU:PlaySoundEffect(OSU.CurrentSkin["menu-freeplay-click"])
				pBase.ShouldSort = true
				pBase.TargetMaps = 1
				pBase.StarRatings = {}
				local _index = 0
				OSU.CurrentBeatmapSet = name["BeatmapSetID"]
				if(tonumber(name["BeatmapSetID"]) < 0) then
					OSU:CenteredMessage("Cannot process this map's difficulty, because BeatmapSetID is missing!")
				end
				for x,y in next, _fosu do
					local bg = bg
					local bgmat = bgmat
					if(OSU.MultiThumbnail) then
						bg = OSU:GetBeatmapBackground({y}, _path)
						bgmat = Material(bg)
					end
					local _data = file.Read(_path..y, "DATA")
					if(_data == nil) then
						OSU:WriteLog("Failed to read beatmap data -> "..y)
						OSU:CenteredMessage("Some maps cannot be loaded due to illegal characters in file name/path", 0.5)
						targetIndex = targetIndex + 1
						continue
					end
					local ver, id, preview, mode = OSU:GetBeatmapVersion(_data, _path)
					local datas = OSU:GetBeatmapDetails(_data)
					datas["Audiopath"] = "data/"..string.Left(name["AudioFilename"], string.len(name["AudioFilename"]) - 1)
					datas["Path"] = _path
					datas["ID"] = id
					datas["Title"] = name[OSU.BeatmapArtistType].." - "..name[OSU.BeatmapNameType].." ["..ver.."]"
					datas["Mapper"] = name["Creator"]
					local vBase = OSU:CreateFrame(pBase, 0, (_index * height), wide, height, Color(30, 101, 252,220), false)
					vBase.TargetYAxis = _index * height
					local StarSx = ScreenScale(8)
					local StarSxBG = ScreenScale(4)
					local supported = OSU:IsSupportedMode(tonumber(mode))
					vBase.iAlpha = 225
					vBase.iAlphaInc = 0
					vBase.iTextColor = 255
					vBase.Paint = function()
						if(supported) then
							if(OSU.CurrentBeatmapID == id) then
								local r = math.Clamp(vBase.qColor.r + (255 - vBase.iTextColor), 0, 255)
								local g = math.Clamp(vBase.qColor.g + (255 - vBase.iTextColor), 0, 255)
								local b = math.Clamp(vBase.qColor.b + (255 - vBase.iTextColor), 0, 255)
								draw.RoundedBox(0, 0, 0, vBase:GetWide(), vBase:GetTall(), Color(r, g, b, vBase.iAlpha + vBase.iAlphaInc))
							else
								local r = math.Clamp((255 - vBase.iTextColor), vBase.qColor.r, 255)
								local g = math.Clamp((255 - vBase.iTextColor), vBase.qColor.g, 255)
								local b = math.Clamp((255 - vBase.iTextColor), vBase.qColor.b, 255)
								draw.RoundedBox(0, 0, 0, vBase:GetWide(), vBase:GetTall(), Color(r, g, b, vBase.iAlpha + vBase.iAlphaInc))
							end
						else
							local r = math.Clamp((255 - vBase.iTextColor), vBase.qColor.r, 255)
							local g = math.Clamp((255 - vBase.iTextColor), vBase.qColor.g, 255)
							local b = math.Clamp((255 - vBase.iTextColor), vBase.qColor.b, 255)
							draw.RoundedBox(0, 0, 0, vBase:GetWide(), vBase:GetTall(), Color(r / 2, g / 2, b / 2, vBase.iAlpha + vBase.iAlphaInc))
						end
						if(OSU.SongThumbnails) then
							surface.SetMaterial(bgmat)
							surface.SetDrawColor(255, 255, 255, 255)
							surface.DrawTexturedRect(0, 0, bgmat_w, height)
						end
						local vPos = 0
						local floored = math.floor(datas["Stars"])
						local lastStar = datas["Stars"] - floored
						local count = floored
						if(datas["Stars"] > floored) then
							count = floored + 1
						end
						for i = 1, 10, 1 do
							surface.SetDrawColor(vBase.iTextColor, vBase.iTextColor, vBase.iTextColor, 100)
							surface.SetMaterial(OSU.StarRatingTx)
							local x, y = (bgmat_w + gap2x_ + iconsx) + vPos + (StarSx * (i - 1)), vBase:GetTall() - (StarSxBG + gap2)
							surface.DrawTexturedRect(x, y, StarSxBG, StarSxBG)
							x, y = x + (StarSxBG / 2), y + (StarSxBG / 2)
							surface.SetDrawColor(vBase.iTextColor, vBase.iTextColor, vBase.iTextColor, 255)
							if(i <= count) then
								if(i == count) then
									local _StarSx = StarSx * (lastStar / 1)
									surface.DrawTexturedRect(x - (_StarSx / 2), y - (_StarSx / 2), _StarSx, _StarSx)
								else
									surface.DrawTexturedRect(x - (StarSx / 2), y - (StarSx / 2), StarSx, StarSx)
								end
							end
							vPos = vPos + gap
						end
					end
					local icon = vgui.Create("DImage", vBase)
					icon:SetSize(iconsx_, iconsx_)
					icon:SetPos(gap2 + bgmat_w, (vBase:GetTall() / 2) - iconsx_ / 2)
					icon:SetImage(OSU:PickModeIcon(tonumber(mode)))
					local Title = vgui.Create("DLabel", vBase)
					Title:SetFont("OSUBeatmapTitle")
					Title:SetText(name[OSU.BeatmapNameType])
					Title:SetSize(wide, ScreenScale(14))
					Title:SetPos(bgmat_w + gap2x + iconsx, 0)
					Title:SetTextColor(Color(255, 255, 255, 255))
					local sx, sy = OSU:GetTextSize("OSUBeatmapTitle", "Dummy Text")
					local Detail = vgui.Create("DLabel", vBase)
					Detail:SetFont("OSUBeatmapDetails")
					Detail:SetText(name[OSU.BeatmapArtistType].." // "..name["Creator"])
					Detail:SetSize(wide, ScreenScale(8))
					Detail:SetPos(bgmat_w + gap2x + iconsx, sy)
					Detail:SetTextColor(Color(255, 255, 255, 255))
					local ext = ""
					datas["mode"] = mode
					if(mode == 3) then
						datas["Keys"] = tonumber(datas["CS"])
						ext = " ("..datas["Keys"].."K)"
					end
					local Version = vgui.Create("DLabel", vBase)
					Version:SetFont("OSUBeatmapVersion")
					Version:SetText(ver..ext)
					Version:SetSize(wide, ScreenScale(8))
					Version:SetTextColor(Color(255, 255, 255, 255))
					local _sx, _sy = OSU:GetTextSize("OSUBeatmapVersion", "Dummy Text")
					Version:SetPos(bgmat_w + gap2x + iconsx, sy + _sy)
					vBase.NextCheckTime = 0
					vBase.DoSortIndex = function(idx, midx)
						vBase.Sorted = true
						vBase.TargetYAxis = (idx * height)
						if(OSU.CurrentBeatmapID != id) then return end
						OSU.CurrentScroll = OSU.BeatmapScrollPanel:GetVBar():GetScroll() - ((OSU.BeatmapScrollPanel:GetTall() / 2) - ((pBase:GetY() + (vBase.TargetYAxis + vBase:GetTall() / 2)) + OSU.BeatmapScrollPanel:GetVBar():GetOffset()))
					end
					local animscl = 0.2
					vBase.Think = function()
						local _y = vBase:GetY()
						if(_y != vBase.TargetYAxis) then
							if(_y < vBase.TargetYAxis) then
								vBase:SetY(math.Clamp(_y + math.max(OSU:GetFixedValue((vBase.TargetYAxis - _y) * animscl), 1), _y, vBase.TargetYAxis))
							else
								vBase:SetY(math.Clamp(_y - math.max(OSU:GetFixedValue((_y - vBase.TargetYAxis) * animscl), 1), _y, vBase.TargetYAxis))
							end
						end
						local vDst = math.abs((OSU.BeatmapScrollPanel:GetTall() / 2) - ((pBase:GetY() + vBase:GetY()) + OSU.BeatmapScrollPanel:GetVBar():GetOffset())) * 0.1
						vBase:DockMargin(math.Clamp(vDst, 0, ScreenScale(60)), 0, 0, -1)
						vBase:SetX(math.Clamp(vDst, 0, ScreenScale(60)), 0)
						if(vBase.iAlphaInc > 0) then
							vBase.iAlphaInc = math.Clamp(vBase.iAlphaInc - OSU:GetFixedValue(2), 0, 255)
						end
						if(OSU.CurrentBeatmapID == id) then
							vBase.iTextColor = math.Clamp(vBase.iTextColor - OSU:GetFixedValue(25), 0, 255)
						else
							vBase.iTextColor = math.Clamp(vBase.iTextColor + OSU:GetFixedValue(25), 0, 255)
						end
						local clr = Color(vBase.iTextColor, vBase.iTextColor, vBase.iTextColor)
						Title:SetColor(clr)
						Detail:SetColor(clr)
						Version:SetColor(clr)
						icon:SetImageColor(clr)
						if(vBase.NextCheckTime < OSU.CurTime) then
							if(datas["Stars"] == -1) then
								local _base = OSU.MapDifficulties[tonumber(name["BeatmapSetID"])]
								if(_base != nil) then
									if(_base[id] != nil) then
										datas["Stars"] = math.Round(_base[id], 2) + 0.001
										if(OSU.CurrentBeatmapID == id && OSU.BeatmapDetailsTab.UpdateRating != nil) then
											OSU.BeatmapDetailsTab.UpdateRating(datas)
										end
										table.insert(pBase.StarRatings, {tonumber(datas["Stars"]), vBase})
									end
								end
							end
							vBase.NextCheckTime = vBase.NextCheckTime + 1
						end
					end
					function vBase:OnCursorEntered()
						OSU:PlaySoundEffect(OSU.CurrentSkin["menuclick"])
						vBase.iAlphaInc = 60
					end
					function vBase:OnMousePressed(keyCode, at)
						if(OSU.NextClickTime > OSU.CurTime && at == nil) then return end
						if(vBase.Sorted) then
							OSU.CurrentScroll = OSU.BeatmapScrollPanel:GetVBar():GetScroll() - ((OSU.BeatmapScrollPanel:GetTall() / 2) - ((pBase:GetY() + (vBase:GetY() + vBase:GetTall() / 2)) + OSU.BeatmapScrollPanel:GetVBar():GetOffset()))
						end
						local aStr = "data/"..string.Left(name["AudioFilename"], string.len(name["AudioFilename"]) - 1)
						if(keyCode != 107) then return end
						OSU.CurrentMode = tonumber(mode)
						if(!supported) then
							OSU:CenteredMessage("Due to limitations, this mode cannot be implemented.", 0.33)
							OSU:PlaySoundEffect(OSU.CurrentSkin["menu-multiplayer-click"])
							OSU:ChangeBackground(bg)
							OSU.BPM = datas["BPM"]
							OSU.BPMTimeGap = datas["TimeGap"]
							OSU.AlphaIncrease = 255 / (60 * (1 / (OSU.BPM / 60)))
							OSU:PrintBeatmapDetails(datas)
							if(OSU.CurrentMusicName != fullName) then
								OSU:PlayMusic(aStr, fullName, name["AudioFilename"], preview / 1000)
								OSU.PreviewTime = preview / 1000
								OSU:GetTimingPoints(_data, datas)
							end
							return
						end
						if(OSU.CurrentBeatmapID != id) then
							OSU.BeatmapDetails = datas
							OSU:PlaySoundEffect(OSU.CurrentSkin["menu-multiplayer-click"])
							OSU:ChangeBackground(bg)
							OSU.CurrentBeatmapID = id
							OSU.BeatmapCTX = _data
							OSU.BPM = datas["BPM"]
							OSU.BPMTimeGap = datas["TimeGap"]
							OSU.AlphaIncrease = 255 / (60 * (1 / (OSU.BPM / 60)))
							if(OSU.CurrentMusicName != fullName) then
								OSU:PlayMusic(aStr, fullName, name["AudioFilename"], preview / 1000)
								OSU.PreviewTime = preview / 1000
								OSU:GetTimingPoints(_data, datas)
							end
							OSU:PrintBeatmapDetails(datas)
							OSU.LeaderboardScrollPanel:Clear()
							OSU.FetchTime = OSU.CurTime + 0.33
							OSU.ShouldFetch = true
						else
							OSU:PlaySoundEffect(OSU.CurrentSkin["menu-direct-click"])
							if(at) then
								if(OSU.CurrentMusicName != fullName) then
									OSU:PlayMusic(aStr, fullName, name["AudioFilename"], preview / 1000)
									OSU.PreviewTime = preview / 1000
									OSU:GetTimingPoints(_data, datas)
								end
								OSU.BeatmapDetails = datas
								OSU:ChangeBackground(bg)
								OSU.CurrentBeatmapID = id
								OSU.BeatmapCTX = _data
								OSU.BPM = datas["BPM"]
								OSU.BPMTimeGap = datas["TimeGap"]
								OSU.AlphaIncrease = 255 / (60 * (1 / (OSU.BPM / 60)))
								OSU:PrintBeatmapDetails(datas)
							end
							if(OSU.SoundChannel:GetFileName() == aStr && !at) then
								OSU:StartBeatmap(_data, datas, OSU.CurrentBeatmapID)
							end
						end
					end
					if(x == targetIndex) then
						vBase:OnMousePressed(107, true)
					end
					_index = _index + 1
					table.insert(pBase.SubPanels, vBase)
				end
				OSU.MaxScroll = OSU.MaxScroll + ((_index - 1) * height)
				pBase.TargetHeight = (height + ((_index - 1) * height)) + ScreenScale(1)
			end
		end
		if(_this) then
			pBase.Title:OnMousePressed(107, true)
		end
		pBase.Title.Paint = function()
			draw.RoundedBox(0, 0, 0, pBase.Title:GetWide(), pBase.Title:GetTall(), Color(pBase.Title.qColor.r, pBase.Title.qColor.g, pBase.Title.qColor.b, pBase.Title.iAlpha))
			if(OSU.SongThumbnails) then
				surface.SetMaterial(bgmat)
				surface.SetDrawColor(255, 255, 255, pBase.Title.iAlpha / 2)
				surface.DrawTexturedRect(0, 0, bgmat_w, height)
			end
		end
		pBase.Title.Think = function()
			pBase.Title.iAlpha = math.Clamp(pBase.Title.iAlpha - OSU:GetFixedValue(10), 200 + pBase.Title.iAlphaInc, 255)
			if(pBase.Title:IsHovered()) then
				pBase.Title.iAlphaInc = 25
			else
				pBase.Title.iAlphaInc = 0
			end
			local vDst = math.abs((OSU.BeatmapScrollPanel:GetTall() / 2) - (pBase:GetY() + OSU.BeatmapScrollPanel:GetVBar():GetOffset())) * 0.1
			pBase.Title:DockMargin(math.Clamp(vDst, 0, ScreenScale(60)), 0, 0, -1)
			pBase.Title:SetX(math.Clamp(vDst, 0, ScreenScale(60)), 0)
		end
		pBase.Think = function()
			local _w, _h = pBase:GetWide(), pBase:GetTall()
			if(OSU.CurrentBeatmapSet == name["BeatmapSetID"]) then
				--print(#pBase.StarRatings, pBase.TargetMaps)
				pBase.Title:SetVisible(false)
				pBase.Clicked = true
				if(_h < pBase.TargetHeight) then
					local smooth = math.abs(pBase.TargetHeight - _h) * 0.3
					pBase:SetTall(math.Clamp(_h + math.max(OSU:GetFixedValue(smooth), 1), height, pBase.TargetHeight))
				end
				if(pBase.ShouldSort) then
					if(pBase.NextCheckTime < OSU.CurTime) then
						if(#pBase.StarRatings >= pBase.TargetMaps) then
							table.SortByMember(pBase.StarRatings, 1, true)
							for k,v in next, pBase.StarRatings do
								if(!IsValid(v[2])) then
									continue
								end
								v[2].DoSortIndex(k - 1, #pBase.StarRatings)
							end
							pBase.ShouldSort = false
						end
						pBase.NextCheckTime = OSU.CurTime + 0.1
					end
				end
			else
				pBase.Title:SetVisible(true)
				if(_h > height) then
					local smooth = math.abs(_h - height) * 0.3
					pBase:SetTall(math.Clamp(_h - OSU:GetFixedValue(smooth), height, pBase.TargetHeight))
				end
				if(pBase.Clicked) then
					OSU.MaxScroll = OSU.MaxScroll - ((#pBase.SubPanels - 1) * height)
					pBase.Clicked = false
				end
				if(#pBase.SubPanels > 0) then
					for k,v in next, pBase.SubPanels do
						if(IsValid(v)) then
							v:Remove()
						end
						table.remove(pBase.SubPanels, k)
					end
				end
			end
		end
		local Title = vgui.Create("DLabel", pBase.Title)
		Title:SetFont("OSUBeatmapTitle")
		Title:SetText(name[OSU.BeatmapNameType])
		Title:SetSize(wide, ScreenScale(14))
		Title:SetPos(bgmat_w + gap, gap)
		Title:SetTextColor(Color(200, 200, 200, 255))
		local sx, sy = OSU:GetTextSize("OSUBeatmapTitle", "Dummy Text")
		local Detail = vgui.Create("DLabel", pBase.Title)
		Detail:SetFont("OSUBeatmapDetails")
		Detail:SetText(name[OSU.BeatmapArtistType].." // "..name["Creator"])
		Detail:SetSize(wide, ScreenScale(8))
		Detail:SetPos(bgmat_w + gap, (gap * 2) + sy)
		Detail:SetTextColor(Color(200, 200, 200, 255))
		OSU.PanelAmount = OSU.PanelAmount + 1
		table.insert(OSU.BeatmapPanels, pBase)
		OSU.TotalBeatmapSets = OSU.TotalBeatmapSets + 1
		hasbeatmap = true
	end
	OSU.ReloadMaxScroll = true
	if(!hasbeatmap) then
		local h = ScreenScale(40)
		local base = OSU:CreateFrame(OSU.PlayMenuLayer, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 255), true)
		local pgTx = Material("osu/internal/pagearrow.png")
		local pgSx = ScreenScale(60)
		base.tutPage = 1
		local img = base:Add("DImage")
		local imgW = base:GetTall() * 1.77
			img:SetPos(0, 0)
			img:SetSize(base:GetWide(), base:GetTall())
			img:SetImage("osu/internal/tut1.png")
			local _w = ScreenScale(80)
			local btn_n = base:Add("DButton")
				btn_n:SetPos(ScrW() - _w, 0)
				btn_n:SetSize(_w, ScrH())
				btn_n:SetText("")
				btn_n.Paint = function()
					draw.RoundedBox(0, 0, 0, _w, ScrH(), Color(200, 200, 255, 100))
					surface.SetDrawColor(255, 255, 255, 255)
					surface.SetMaterial(pgTx)
					surface.DrawTexturedRectRotated(_w / 2, ScrH() / 2, pgSx, pgSx, 180)
				end
				function btn_n:OnCursorEntered()
					OSU:PlaySoundEffect(OSU.CurrentSkin["menuclick"])
				end
				--gui.OpenURL("https://mega.nz/file/daIwCTiA#Axoi9UOZddOZyMN5u98GkBkr1ocyAuYOCWoNhOj38-o")
				btn_n.DoClick = function()
					if(base.tutPage >= 4) then
						base:Remove()
						OSU:RefreshBeatmapList()
						return
					end
					base.tutPage = math.Clamp(base.tutPage + 1, 1, 4)
					OSU:PlaySoundEffect(OSU.CurrentSkin["menu-direct-click"])
					img:SetImage("osu/internal/tut"..base.tutPage..".png")
				end

			local btn_p = base:Add("DButton")
				btn_p:SetPos(0, 0)
				btn_p:SetSize(_w, ScrH())
				btn_p:SetText("")
				btn_p.Paint = function()
					draw.RoundedBox(0, 0, 0, _w, ScrH(), Color(200, 200, 255, 100))
					surface.SetDrawColor(255, 255, 255, 255)
					surface.SetMaterial(pgTx)
					surface.DrawTexturedRectRotated(_w / 2, ScrH() / 2, pgSx, pgSx, 0)
				end
				function btn_p:OnCursorEntered()
					OSU:PlaySoundEffect(OSU.CurrentSkin["menuclick"])
				end
				btn_p.DoClick = function()
					base.tutPage = math.Clamp(base.tutPage - 1, 1, 4)
					OSU:PlaySoundEffect(OSU.CurrentSkin["menu-direct-click"])
					img:SetImage("osu/internal/tut"..base.tutPage..".png")
				end

		OSU:CreateBackButton(base, OSU_MENU_STATE_MAIN)
		OSU.ResultFetched = true
		OSU:CenteredMessage("No beatmaps found!", 0.5)
	else
		OSU:CreateBackButton(OSU.PlayMenuLayer, OSU_MENU_STATE_MAIN)
	end
end

function OSU:SetupBeatmapPanel()
	OSU:ReadMapDifficultyFile()
	OSU.TotalBeatmapSets = 0
	OSU.TotalRequests = 0
	OSU.StarRatingTx = Material(OSU.CurrentSkin["star"])
	OSU.ShouldFetch = false
	OSU.PlayMenuAnimStarted = false
	OSU.PlayMenuObjectOffset = 0
	OSU.PlayMenuLayer = OSU:CreateFrame(OSU.MainGameFrame, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 0), true)
	local h = ScreenScale(40)
	local o = ScreenScale(1)
	local iSX = ScreenScale(100)
	OSU.PlayMenuLayer.UpperMaterial = Material("osu/internal/upperbar.png")
	OSU.PlayMenuLayer.IconMaterial = Material("osu/internal/standard.png")
	OSU.PlayMenuLayer.IconAlpha = 0
	OSU.PlayMenuLayer.BottomHeight = h
	OSU.PlayMenuLayer.Beat = false
	OSU.PlayMenuLayer.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 100))
		draw.RoundedBox(0, 0, ScrH() - (h - OSU.PlayMenuObjectOffset), ScrW(), h, OSU.MenuBackgroundColor)
		if(OSU.BeatmapDifficultiesProcessing) then
			draw.DrawText("Processing difficulties.. ("..OSU.TotalRequests.."/"..OSU.TotalRequests - table.Count(OSU.PendingRequests)..", Total : "..table.Count(OSU.MapDifficulties)..")", "OSUBeatmapTitle", ScrW() / 2, ScrH() - ((h / 2) + ScreenScale(7)), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		end
		draw.RoundedBox(0, 0, ScrH() - (h - OSU.PlayMenuObjectOffset), ScrW(), o, OSU.MenuOutlineColor)
		surface.SetMaterial(OSU.PlayMenuLayer.UpperMaterial)
		surface.SetDrawColor(OSU.MenuOutlineColor.r, OSU.MenuOutlineColor.g, OSU.MenuOutlineColor.b, 255)
		surface.DrawTexturedRect(0, -OSU.PlayMenuObjectOffset, ScrW(), h * 1.78)
		if(OSU.PlayMenuLayer.Beat) then
			OSU.PlayMenuLayer.IconAlpha = 60
			OSU.PlayMenuLayer.Beat = false
		end
		OSU.PlayMenuLayer.IconAlpha = math.Clamp(OSU.PlayMenuLayer.IconAlpha - OSU:GetFixedValue(2), 0, 255)
		if(!OSU.PlayMenuAnimStarted) then
			surface.SetMaterial(OSU:PickModeIconMat())
			surface.SetDrawColor(255 ,255, 255, OSU.PlayMenuLayer.IconAlpha)
			surface.DrawTexturedRect((ScrW() / 2) - (iSX / 2), (ScrH() / 2) - (iSX / 2), iSX, iSX)
			if(OSU.SoundChannel:GetState() == 0) then
				OSU.SoundChannel:SetTime(OSU.PreviewTime)
				OSU.SoundChannel:Play()
				OSU:SetNextBPM(OSU.BPM)
			end
		end

		if(OSU.PlayMenuAnimStarted) then
			OSU.PlayMenuObjectOffset = math.Clamp(OSU.PlayMenuObjectOffset + OSU:GetFixedValue(ScreenScale(5)), 0, ScrW() * 0.405)
			if(OSU.PlayMenuObjectOffset >= ScrW() * 0.4) then
				OSU.PlayMenuLayer:SetVisible(false)
			end
		end
	end
	OSU.PlayMenuLayer.Think = function()
		if(OSU.FetchTime < OSU.CurTime && OSU.ShouldFetch) then
			OSU:RequestLeaderboard()
			OSU.ShouldFetch = false
		end
	end
	OSU:CreateBackButton(OSU.PlayMenuLayer, OSU_MENU_STATE_MAIN)

	local Rotate = 0
	local sx = ScreenScale(50)
	local iAlpha = 0
	local iAlpha2 = 0
	OSU.BeatmapScrollPanel = OSU:CreateScrollPanel(OSU.PlayMenuLayer, ScrW() * 0.6, h, ScrW() * 0.4, ScrH() - (h * 2), Color(0, 0, 0, 0))
	OSU.LeaderboardScrollPanel = OSU:CreateScrollPanel(OSU.PlayMenuLayer, ScreenScale(2), h * 2, ScreenScale(170), ScrH() - (h * 4), Color(0, 0, 0, 0))
	local cSx = OSU.LeaderboardScrollPanel:GetWide() * 0.75
	local sh = OSU.LeaderboardScrollPanel:GetWide() * 0.504
	OSU.LeaderboardScrollPanel.Paint = function()
		Rotate = math.Clamp(Rotate + OSU:GetFixedValue(2), 0, 360)
		if(Rotate >= 360) then
			Rotate = 0
		end
		draw.RoundedBox(0, 0, 0, OSU.LeaderboardScrollPanel:GetWide(), OSU.LeaderboardScrollPanel:GetTall(), Color(0, 0, 0, 0))
				if(!OSU.ResultFetched) then
					iAlpha = math.Clamp(iAlpha + OSU:GetFixedValue(5), 0, 100)
					surface.SetDrawColor(255, 255, 255, iAlpha)
					surface.SetMaterial(OSU.LoadingTx)
					surface.DrawTexturedRectRotated(OSU.LeaderboardScrollPanel:GetWide() / 2, OSU.LeaderboardScrollPanel:GetTall() / 2, sx, sx, Rotate)
				end
				if(OSU.NoRecords) then
					iAlpha2 = math.Clamp(iAlpha2 + OSU:GetFixedValue(30), 0, 255)
				else
					iAlpha2 = math.Clamp(iAlpha2 - OSU:GetFixedValue(30), 0, 255)
				end
				surface.SetDrawColor(255, 255, 255, iAlpha2)
				surface.SetMaterial(OSU.NoRecordTx)
				local __h = OSU.LeaderboardScrollPanel:GetWide() * 0.747
				surface.DrawTexturedRect(0, (OSU.LeaderboardScrollPanel:GetTall() / 2) - (__h / 2), OSU.LeaderboardScrollPanel:GetWide(), __h)
		--[[
		if(!OSU.UserBanned) then
			if(OSU.LoggedIn) then
				if(!OSU.ResultFetched) then
					iAlpha = math.Clamp(iAlpha + OSU:GetFixedValue(5), 0, 100)
					surface.SetDrawColor(255, 255, 255, iAlpha)
					surface.SetMaterial(OSU.LoadingTx)
					surface.DrawTexturedRectRotated(OSU.LeaderboardScrollPanel:GetWide() / 2, OSU.LeaderboardScrollPanel:GetTall() / 2, sx, sx, Rotate)
				end
				if(OSU.NoRecords) then
					iAlpha2 = math.Clamp(iAlpha2 + OSU:GetFixedValue(30), 0, 255)
				else
					iAlpha2 = math.Clamp(iAlpha2 - OSU:GetFixedValue(30), 0, 255)
				end
				surface.SetDrawColor(255, 255, 255, iAlpha2)
				surface.SetMaterial(OSU.NoRecordTx)
				local __h = OSU.LeaderboardScrollPanel:GetWide() * 0.747
				surface.DrawTexturedRect(0, (OSU.LeaderboardScrollPanel:GetTall() / 2) - (__h / 2), OSU.LeaderboardScrollPanel:GetWide(), __h)
			else
				if(!OSU.ResultFetched) then
					iAlpha = math.Clamp(iAlpha + OSU:GetFixedValue(20), 0, 255)
				else
					iAlpha = math.Clamp(iAlpha - OSU:GetFixedValue(20), 0, 255)
				end
				surface.SetDrawColor(255, 255, 255, iAlpha)
				surface.SetMaterial(OSU.LoadingTx)
				surface.DrawTexturedRectRotated(OSU.LeaderboardScrollPanel:GetWide() / 2, OSU.LeaderboardScrollPanel:GetTall() / 2, sx, sx, Rotate)
				surface.SetDrawColor(255, 255, 255, 255 - iAlpha)
				surface.SetMaterial(OSU.UnloggedTx)
				surface.DrawTexturedRect(0, (OSU.LeaderboardScrollPanel:GetTall() / 2) - sh / 2, OSU.LeaderboardScrollPanel:GetWide(), sh)
			end
		else
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(OSU.CheaterTx)
			surface.DrawTexturedRect((OSU.LeaderboardScrollPanel:GetWide() / 2) - cSx / 2, (OSU.LeaderboardScrollPanel:GetTall() / 2) - cSx / 2, cSx, cSx)
		end
		]]
	end
	function OSU.BeatmapScrollPanel:OnMouseWheeled(scrollDelta)
		if(OSU.MaxScroll == 0) then return end
		OSU.CurrentScroll = math.Clamp(OSU.CurrentScroll - (scrollDelta * (ScreenScale(50))), 0, OSU.MaxScroll)
	end
	local sbar = OSU.LeaderboardScrollPanel:GetVBar()
	sbar:SetWide(ScreenScale(1))
	function sbar.btnUp:Paint(w, h) return end
	function sbar.btnDown:Paint(w, h) return end
	function sbar:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
	end
	function sbar.btnGrip:Paint(w, h)
		draw.RoundedBox(5, 0, 0, w, h, Color(255, 255, 255, 150))
	end
	OSU.LeaderboardScrollPanel.CurrentScroll = 0
	local maxscroll = OSU.LeaderboardScrollPanel:GetVBar().CanvasSize
	function OSU.LeaderboardScrollPanel:OnMouseWheeled(scrollDelta)
		OSU.LeaderboardScrollPanel.CurrentScroll = math.Clamp(OSU.LeaderboardScrollPanel.CurrentScroll - (ScreenScale(50) * scrollDelta), 0, maxscroll)
	end
	OSU.LeaderboardScrollPanel.Think = function()
		maxscroll = OSU.LeaderboardScrollPanel:GetVBar().CanvasSize
		if(maxscroll == 0) then return end
			local scroll = OSU.LeaderboardScrollPanel:GetVBar()
			if(scroll:GetScroll() != OSU.LeaderboardScrollPanel.CurrentScroll) then
				local smooth = math.abs(OSU.LeaderboardScrollPanel.CurrentScroll - scroll:GetScroll())
			if(scroll:GetScroll() < OSU.LeaderboardScrollPanel.CurrentScroll) then
				scroll:SetScroll(math.Clamp(scroll:GetScroll() + OSU:GetFixedValue(smooth * 0.15), 0, maxscroll))
			else
				scroll:SetScroll(math.Clamp(scroll:GetScroll() - OSU:GetFixedValue(smooth * 0.15), 0, maxscroll))
			end
		end
	end

	OSU.BeatmapScrollPanel.Think = function()
		if(OSU.MaxScroll == 0) then return end
		local scroll = OSU.BeatmapScrollPanel:GetVBar()
		if(scroll:GetScroll() != OSU.CurrentScroll) then
			local smooth = math.abs(OSU.CurrentScroll - scroll:GetScroll())
			if(scroll:GetScroll() < OSU.CurrentScroll) then
				scroll:SetScroll(math.Clamp(scroll:GetScroll() + OSU:GetFixedValue(smooth * 0.15), 0, OSU.MaxScroll))
			else
				scroll:SetScroll(math.Clamp(scroll:GetScroll() - OSU:GetFixedValue(smooth * 0.15), 0, OSU.MaxScroll))
			end
		end
		OSU.iMaxScroll = OSU.BeatmapScrollPanel:GetVBar().CanvasSize
		OSU.MaxScroll = OSU.BeatmapScrollPanel:GetVBar().CanvasSize
		OSU.BeatmapScrollPanel:SetX(OSU.BeatmapScrollPanel:GetX() + OSU.PlayMenuObjectOffset)
	end
	local vBar = OSU.BeatmapScrollPanel:GetVBar()
	vBar:SetHideButtons(true)
	vBar:SetWide(ScreenScale(3))
	function vBar:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 70))
	end
	function vBar.btnGrip:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 255))
	end
	local sx = ScreenScale(96)
	OSU.PlayMenuLayer.Logo = OSU:CreateImageBeat(OSU.PlayMenuLayer, ScrW() - (sx * 0.3), ScrH() - (sx * 0.3), sx, sx, OSU.CurrentSkin["logo"], true, true)
	--[[
	if(!OSU.UserBanned && !OSU.LoggedIn) then
		if(IsValid(OSU.LoginButton)) then OSU.LoginButton:Remove() end
		local w = OSU.LeaderboardScrollPanel:GetWide()
		local h = ScreenScale(18)
		local gap = ScreenScale(1)
		local gap2x = gap * 2
		local rgap = OSU.LeaderboardScrollPanel:GetWide() - w
		OSU.LoginButton = OSU.PlayMenuLayer:Add("DButton")
		OSU.LoginButton:SetSize(w, h)
		OSU.LoginButton:SetPos(OSU.LeaderboardScrollPanel:GetX(), OSU.LeaderboardScrollPanel:GetY() + OSU.LeaderboardScrollPanel:GetTall() - (h + gap))
		OSU.LoginButton:SetFont("OSUBeatmapTitle")
		OSU.LoginButton:SetText("Login with steam")
		local _w, _h = OSU.LoginButton:GetSize()
		OSU.LoginButton.Paint = function()
			draw.RoundedBox(0, 0, 0, _w, _h, Color(0, 0, 0, 255))
			draw.RoundedBox(0, gap, gap, _w - gap2x, _h - gap2x, OSU.OptBlue)
			if(OSU.UserBanned || OSU.LoggedIn) then
				OSU.LoginButton:Remove()
			end
		end
		OSU.LoginButton.DoClick = function()
			OSU:AuthorizeToken(OSU_MENU_STATE_BEATMAP)
		end
	end
	]]
	local _h = h
	local w, h = ScreenScale(150), ScreenScale(15)
	local gap, padding = ScreenScale(2), (h - ScreenScale(10)) / 2
	local searchstr = OSU:LookupTranslate("#DLSearch")..":"
	OSU.SearchBox = OSU:CreateFrame(OSU.PlayMenuLayer, ScrW() - w, _h, w, h, Color(0, 0, 0, 150), false)
	OSU.SearchBox.Paint = function()
		draw.RoundedBox(gap, 0, 0, OSU.SearchBox:GetWide(), OSU.SearchBox:GetTall(), Color(0, 0, 0, 150))
		draw.DrawText(searchstr, "OSUOptionDesc", gap, padding, Color(173, 221, 61, 255), Color(255, 255, 255, 255))
	end
	local tw, th = OSU:GetTextSize("OSUOptionDesc", searchstr)
	local entryTall = OSU.SearchBox:GetTall() * 0.8
	local entry = OSU.SearchBox:Add("DTextEntry")
		entry:SetPos(tw + (gap * 2), (OSU.SearchBox:GetTall() - entryTall) / 2)
		entry:SetSize(OSU.SearchBox:GetWide() - (tw + gap * 2), entryTall)
		entry:SetFont("OSUOptionDesc")
		entry:SetPaintBackground(false)
		entry:SetTextColor(Color(255, 255, 255, 255))
		entry.BeatmapsExists = true
		function entry:OnKeyCodeTyped(keyCode)
			if(keyCode == 66) then
				OSU:PlaySoundEffect(OSU.CurrentSkin["key-delete"])
			else
				if(keyCode != 64) then
					OSU:PlaySoundEffect(OSU.CurrentSkin["key-press-"..math.random(1, 4)])
				end
			end
		end
		function entry:OnChange()
			local value = entry:GetValue()
			for k,v in next, OSU.BeatmapPanels do
				local t = v.StrTitle
				if(t == nil) then continue end
				t = string.lower(t)
				value = string.lower(value)
				if(string.len(value) <= 0) then
					v:SetVisible(true)
				else
					if(string.find(t, value)) then
						v:SetVisible(true)
					else
						v:SetVisible(false)
					end
				end
				-- So layout will update
				v:SetTall(v:GetTall() + 1)
				v:SetTall(v:GetTall() - 1)
			end
			OSU.BeatmapScrollPanel:InvalidateLayout(true)
		end

	OSU:CreateRankingButton()
	OSU:CreateModeButton()
	OSU:CreateRandomButton()
	OSU:RefreshBeatmapList()
end