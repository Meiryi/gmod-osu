--[[
	Gmod osu! - An unofficial port of osu! to Garry's mod.
	None of these codes should be modified or changed without original author's permission, anykind of modification is not allowed.

	You can use it on whatever you like, but you should not claim you're the original author,
	If you're a server owner, do not put this addon behind paywall, or some vip shit

	For translators, if you want to translate this addon, please contact me directly instead of modify the code
	REUPLOAD / REPACK IS NOT ALLOWED

	Copyright (C) 2023 Meika. All rights reserved
]]

function osu_vec2t(x, y)
	return {x = x, y = y}
end

function OSU:GetPlayFieldSize()
	local h = ScrH() * 0.8 
	local w = ((4 / 3) * h)
	return w, h
end

function OSU:GetPlayFieldSize_Vec2t()
	local h = ScrH() * 0.8 
	local w = ((4 / 3) * h)
	return {x = w, y = h}
end

function OSU:GetPlayFieldVec()
	local w, h = OSU:GetPlayFieldSize()
	return (ScrW() / 2) - (w / 2), (ScrH() / 2) - (h / 2)
end

function OSU:OsuPixelToScreenPixel(px)
	local _x, _y = OSU:GetPlayFieldSize()
	local osuPX = px * (_x / 512)
	return osuPX
end

function OSU:PixelToOsuPixel(px)
	local _x, _y = OSU:GetPlayFieldSize()
	local osuPX = px / (_x / 512)
	return osuPX
end

function OSU:OsuPixelToPixel(x, y)
	local _x, _y = OSU:GetPlayFieldSize()
	local osuX = x * (_x / 512)
	local osuY = y * (_y / 384)
	return osuX, osuY
end

function OSU:OsuPixelToScreen(pX, pY)
	local x, y = OSU:GetPlayFieldVec()
	return x + pX, y + pY
end

function OSU:NewCombo(int)
	local bit = math.IntToBin(int)
	local rbit = string.reverse(bit)
	if(rbit[3] == "1") then
		return true
	else
		return false
	end
end

function OSU:GetHitsoundTable(int)
	local t = {
		[0] = false,
		[1] = false,
		[2] = false,
		[3] = false,
	}
	if(int <= 0) then
		t[0] = true
		return t
	end
	local bit = math.IntToBin(int)
	local rbit = string.reverse(bit)
	local ret = ""
	for i = 1, 4, 1 do
		if(rbit[i] == "" || rbit[i] == "0") then
			t[i - 1] = false
		else
			t[i - 1] = true
		end
	end
	return t
end

function OSU:GetHitsoundType(bitindex)
	if(bit.band(bitindex, OSU.HITSOUND_NORMAL) > 0) then
		return 0
	elseif(bit.band(bitindex, OSU.HITSOUND_WHISTLE) > 0) then
		return 1
	elseif(bit.band(bitindex, OSU.HITSOUND_FINISH) > 0) then
		return 2
	elseif(bit.band(bitindex, OSU.HITSOUND_CLAP) > 0) then
		return 3
	else
		return 0
	end
end

function OSU:GetObjectType(bitindex)
	if(bit.band(bitindex, OSU.HITOBJECT_CIRCLE) > 0) then
		return 1
	elseif(bit.band(bitindex, OSU.HITOBJECT_SLIDER) > 0) then
		return 2
	else
		return 3
	end
end

function OSU:GetManiaObjectType(bitindex)
	local bit = math.IntToBin(bitindex)
	local bitfield = string.reverse(bit)
	if(bitfield[8] == "1") then
		return 2
	else
		return 1
	end
end

function OSU:PickSampleSet(sample)
	if(sample == "Normal") then
		return "normal"
	elseif(sample == "Soft") then
		return "soft"
	elseif(sample == "Drum") then
		return "drum"
	else
		return "normal"
	end
end

function OSU:GetColumn(ctx, k)
	local xAxis = tonumber(ctx)
	return math.floor((xAxis * k) / 512) + 1
end

function OSU:ConstrustPlayField(field)
	OSU.ManiaNoteTextures = {
		["note1"] = Material(OSU.CurrentSkin["mania-note1"]),
		["note1h"] = Material(OSU.CurrentSkin["mania-note1L-0"]),
	}
	local lw, lh = OSU:GetMaterialSize(OSU.CurrentSkin["mania-stage-left"])
	local rw, rh = OSU:GetMaterialSize(OSU.CurrentSkin["mania-stage-right"])
	OSU:CreateImage(field, 0, 0, lw, ScrH(), OSU.CurrentSkin["mania-stage-left"], false)
	local next = lw
	local pad = ScreenScale(1)
	local w, h = OSU:GetMaterialSize(OSU.CurrentSkin["mania-key1"])
	for i = 1, OSU.CS, 1 do
		OSU:CreateGrid(field, next)
		next = next + pad
		field.Keys[i] = OSU:CreateKey(field, next, w, i)
		next = next + w
		if(i == OSU.CS) then
			OSU:CreateGrid(field, next)
			next = next + pad
		end
	end
	local hw, hh = OSU:GetMaterialSize(OSU.CurrentSkin["mania-stage-hint"])
	next = next - lw
	field:SetWide(field:GetWide() + lw + rw + next)
	OSU:CreateImage(field, lw, ScrH() - (h + hh), field:GetWide() - (lw + rw), hh, OSU.CurrentSkin["mania-stage-hint"], false)
	OSU:CreateImage(field, field:GetWide() - rw, 0, rw, ScrH(), OSU.CurrentSkin["mania-stage-right"], false)
	field:SetX((OSU.PlayFieldLayer:GetWide() / 2) - (field:GetWide() / 2))
end

local _stop = false
function OSU:StartBeatmap(beatmap, details, id, replay)
	if(OSU.CurrentMode != 0) then
		return
	end
	if(IsValid(OSU.HealthBar)) then OSU.HealthBar:Remove() end
	if(IsValid(OSU.FailPanel)) then OSU.FailPanel:Remove() end
	if(replay == nil) then replay = false end
	OSU.ReplayMode = replay
	OSU.ShouldDrawFakeCursor = replay
	OSU:ResetReplayData()
	OSU.ReplayData.Details.t = math.floor(OSU.CurTime)
	OSU.ReplayData.Details.mul = OSU.ScoreMul
	
	if(!_stop) then
		OSU.GameEnded = false
		OSU.BeatmapDetails = details
		OSU.PlayMenuAnimStarted = true
		OSU.MusicStarted = false
		OSU.SoundChannel:Pause()
		OSU.SoundChannel:SetTime(0)
		OSU.CurrentZPos = 32767
		OSU.PlayFieldLayer = OSU:CreateFrame(OSU.MainGameFrame, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 0), false)
		if(details["Video"]) then
			local path = details["Path"]..details["VideoFN"]
			if(file.Exists(path, "DATA")) then

				
			end
		end
		OSU.PlayFieldLayer.UpperLayer = OSU.PlayFieldLayer:Add("DImage")
		OSU.PlayFieldLayer.UpperLayer:SetSize(ScrW(), ScrH())
		OSU.PlayFieldLayer.UpperLayer:SetDrawOnTop(true)
		OSU.PlayFieldLayer.FollowPoints = {}
		OSU.HealthBar = vgui.Create("DPanel", OSU.PlayFieldLayer.UpperLayer)
		OSU.HealthBar.Paint = function() return end
		OSU.HealthBar.Bar = vgui.Create("DImage", OSU.HealthBar)
		OSU.HealthBar:SetVisible(false)
		OSU.BaseSliderMultiplier = 1
		OSU.SliderMultiplier = 1
		OSU.CurrentTableIndex = 1
		OSU.CurrentTableIndex_Read = 1
	end	

	OSU.OriginalSize = ScreenScale(54.4)

	OSU.BeatmapEndTime = 0
	OSU.BeatmapStartTime = 0
	OSU.TotalObjectsRecorded = 0
	OSU.TotalAccuracyRecorded = 0
	OSU.Accuracy = 0
	OSU.HIT300 = 0
	OSU.HIT100 = 0
	OSU.HIT50 = 0
	OSU.MISS = 0
	OSU.Score = 0
	OSU.DisplayScore = 0
	OSU.Combo = 0
	OSU.HighestCombo = 0
	OSU.PlayFieldYOffs = 0
	OSU.CurrentColourIndex = 1
	OSU.CurrentComboIndex = 1
	OSU.Health = 100
	OSU.LastInaccuracyTime = 0



	for i = 0, 9, 1 do
		OSU.DefaultMaterialTable[tostring(i)] = Material(OSU.CurrentSkin["default-"..i])
	end
	for i = 0, 9, 1 do
		OSU.ScoreMaterialTable[tostring(i)] = Material(OSU.CurrentSkin["score-"..i])
	end
	OSU.ScoreMaterialTable["x"] = Material(OSU.CurrentSkin["score-x"])
	OSU.ScoreMaterialTable["p"] = Material(OSU.CurrentSkin["score-percent"])
	OSU.ScoreMaterialTable["."] = Material(OSU.CurrentSkin["score-dot"])

	local w, h = OSU:GetMaterialSize(OSU.CurrentSkin["followpoint"])
	OSU.FollowPointTx = {
		["t"] = Material(OSU.CurrentSkin["followpoint"], "smooth"),
		["w"] = w,
		["h"] = h,
	}
	OSU.FollowPointsGap = math.Round(math.Distance(0, 0, w, h))
	OSU.FollowPointsTable = {}
	OSU.SliderFollow = Material(OSU.CurrentSkin["sliderfollowcircle"])
	local w, h = OSU:GetMaterialSize(OSU.CurrentSkin["play-unranked@2x"])
	OSU.UnrankedTx = {
		["t"] = Material(OSU.CurrentSkin["play-unranked@2x"]),
		["w"] = w,
		["h"] = h,
	}

	local w1, h1 = OSU:GetMaterialSize(OSU.CurrentSkin["scorebar-bg"])
	local w2, h2 = OSU:GetMaterialSize(OSU.CurrentSkin["scorebar-colour"])
	local w3, h3 = OSU:GetMaterialSize(OSU.CurrentSkin["scorebar-ki"])
	local w4, h4 = OSU:GetMaterialSize(OSU.CurrentSkin["scorebar-kidanger"])
	local w5, h5 = OSU:GetMaterialSize(OSU.CurrentSkin["scorebar-kidanger2"])

	OSU.ScoreBarData = {
		["bg"] = Material(OSU.CurrentSkin["scorebar-bg"]),
		["bc"] = OSU.CurrentSkin["scorebar-colour"],
		["ki1"] = Material(OSU.CurrentSkin["scorebar-ki"]),
		["ki2"] = Material(OSU.CurrentSkin["scorebar-kidanger"]),
		["ki3"] = Material(OSU.CurrentSkin["scorebar-kidanger2"]),
		["gw"] = w1,
		["gh"] = h1,
		["cw"] = w2,
		["ch"] = h2,
		["kw1"] = w3,
		["kh1"] = h3,
		["kw2"] = w4,
		["kh2"] = h4,
		["kw3"] = w5,
		["kh3"] = h5,
	}
	OSU.TempData = {
		["b"] = "",
		["i"] = "",
	}
	OSU.CircleBG = OSU.CurrentSkin["hitcircle"]
	OSU.BeatmapTime = OSU.CurTime + 32767
	OSU.Objects = {}
	OSU.TimingPoints = {}
	OSU.Breaks = {}
	OSU.ComboColours = details["Colours"]
	OSU.CurrentObjectColor = OSU.ComboColours[1]
	OSU.BreakTime = 0
	OSU.AppearTime = 0
	OSU.ObjectIndex = 0
	OSU.SliderBackground = Material("osu/internal/hitcircle.png", "smooth")
	OSU.rHitCircleOverlay = Material(OSU.CurrentSkin["hitcircleoverlay"], "smooth")
	OSU.HitCircleOverlay = Material(OSU.CurrentSkin["sliderb0"], "smooth")
	OSU.RevArrow = Material(OSU.CurrentSkin["reversearrow"], "smooth")
	OSU.PlayFieldSize = OSU:GetPlayFieldSize_Vec2t()
	OSU.CS = tonumber(details["CS"])
	OSU.AR = tonumber(details["AR"])
	OSU.HP = tonumber(details["HP"])
	OSU.OD = tonumber(details["OD"])
	if(OSU.EZ) then
		OSU.AR = math.Clamp(OSU.AR * 0.8, 1, 10)
		OSU.CS = math.Clamp(OSU.CS * 0.45, 0.1, 10)
		OSU.HP = OSU.HP * 0.6
		OSU.OD = OSU.OD * 0.6
	end
	if(OSU.HR) then
		OSU.AR = math.Clamp(OSU.AR * 1.35, 1, 10)
		OSU.CS = math.Clamp(OSU.CS * 1.25, 0.1, 10)
		OSU.HP = OSU.HP * 1.4
		OSU.OD = math.Clamp(OSU.OD * 1.3, 0.1, 10)
	end
	OSU.CurrentHitSound = "soft"
	local apprTime = OSU:GetApprTime()
	OSU.AppearTime = apprTime
	local cached = file.Exists(OSU.HitObjectsCachePath..id..".dat", "DATA")
	local obj_start, obj_end = details["Object Range"][1], details["Object Range"][2]
	local tps_start, tps_end = details["Timepoint Range"][1], details["Timepoint Range"][2]

		if(cached) then
			local _sTime = SysTime()
			local ctx = file.Read(OSU.HitObjectsCachePath..id..".dat", "DATA")
			local data = util.JSONToTable(ctx)
			OSU.Objects = data["objects"]
			OSU.TimingPoints = data["timing"]
			local _eTime = SysTime()
			local _processTime = _eTime - _sTime
			OSU:CenteredMessage("Loading beatmap temp ("..id..".dat, "..math.Round(_processTime, 3).."s)")
			OSU.BeatmapTime = OSU.CurTime + 2 + _processTime
			for k,v in next, OSU.TimingPoints do
				local mul = 1
				if(OSU.HT) then
					mul = 1.5
				end
				if(OSU.DT) then
					mul = 0.5
				end
				v[1] = (v[1] * mul) + OSU.BeatmapTime
			end
			for k,v in next, OSU.Objects do
				v["time"] = OSU.BeatmapTime + v["time"] - apprTime
				if(v["type"] == 3) then
					v["killttime"] = OSU.BeatmapTime + v["killttime"]
				end
				if(k == 1) then
					OSU.BeatmapStartTime = v["time"]
				end
				if(k == #OSU.Objects) then
					OSU.BeatmapEndTime = v["time"] + 2.5
				end
				if(OSU.HR) then
					if(v["type"] == 2) then
						v["vec_2"].x = ScrW() - v["vec_2"].x
						v["vec_2"].y = ScrH() - v["vec_2"].y
						for x,y in next, v["followpoint"] do
							y.x = ScrW() - y.x
							y.y = ScrH() - y.y
						end
						for x,y in next, v["realfollowpoint"] do
							y.x = ScrW() - y.x
							y.y = ScrH() - y.y
						end
					end
					if(v["type"] == 1) then
						v["vec_2"].x = ScrW() - v["vec_2"].x
						v["vec_2"].y = ScrH() - v["vec_2"].y
					end
				end
			end
			local ctx_ = string.Explode("\n", beatmap)
			for i = tps_start, tps_end, 1 do
				local _ctx = ctx_[i]
				local ret = string.Explode(",", _ctx)
				if(i == tps_start) then
					OSU.BeatLength = tonumber(ret[2])
					if(OSU.HT) then
						OSU.BeatLength = OSU.BeatLength * 1.5
					end
					if(OSU.DT) then
						OSU.BeatLength = OSU.BeatLength * 0.5
					end
				end
				if(tonumber(ret[2]) == nil || tonumber(ret[2]) > 0) then continue end
				if(tonumber(ret[1]) == nil || tonumber(ret[2]) == nil || tonumber(ret[3]) == nil || tonumber(ret[4]) == nil || tonumber(ret[8]) == nil) then continue end
				table.insert(OSU.TimingPoints, {(tonumber(ret[1]) / 1000), tonumber(ret[2]), false, tonumber(ret[4]), tonumber(ret[8])})
			end
			local breakStart = 0
			local breakEnd = 0
			for k,v in pairs(ctx_) do
				if(string.find(v, "SliderMultiplier:")) then
					local num = string.Replace(v, "SliderMultiplier:", "")
					OSU.SliderMultiplier = tonumber(num)
					OSU.SliderVelocity = OSU.SliderMultiplier
				end
				if(string.find(v, "SampleSet:")) then
					OSU.CurrentHitSound = OSU:PickSampleSet(string.Replace(v, "SampleSet: ", ""))
					OSU.BeatmapDefaultSet = OSU:PickSampleSet(string.Replace(v, "SampleSet: ", ""))
				end
				if(breakStart == 0) then
					if(string.find(v, "//Break")) then
						breakStart = k + 1
					end
				else
					if(breakEnd == 0) then
						if(string.find(v, "//Storyboard Layer 0")) then
							breakEnd = k - 1
						end
					end
				end
			end
			if(breakStart != 0 && breakEnd != 0) then
				for i = breakStart, breakEnd, 1 do
					local _bd = string.Explode(",", ctx_[i])
					table.insert(OSU.Breaks, {OSU.BeatmapTime + (tonumber(_bd[2]) / 1000), OSU.BeatmapTime + (tonumber(_bd[3]) / 1000)})
				end
			end
		else
			local nextTime = OSU.BeatmapTime
			local ctx = string.Explode("\n", beatmap)
			--[[
				Object types
					1 - Circle
					2 - Slider
					3 - Spinner
			]]
			local _sTime = SysTime()
			for i = obj_start, obj_end, 1 do
				local _ctx = ctx[i]
				local ret = string.Explode(",", _ctx)
				-- x, y, time, type, hitSound, objectParams, hitSample
				local gX, gY = tonumber(ret[1]), tonumber(ret[2])
				local scX, scY = OSU:OsuPixelToPixel(gX, gY)
				local _x, _y = OSU:OsuPixelToScreen(scX, scY)
				local time = (tonumber(ret[3]) / 1000)
				local hitsound = OSU:GetHitsoundTable(tonumber(ret[5]))
				local newcombo = OSU:NewCombo(tonumber(ret[4]))
				if(OSU:GetObjectType(ret[4]) == 1) then -- Circle
					table.insert(OSU.Objects, {
						["otime"] = time,
						["type"] = 1,
						["time"] = time,
						["sound"] = hitsound,
						["vec_2"] = osu_vec2t(_x, _y),
						["spawned"] = false,
						["newcombo"] = newcombo,
					})
				elseif(OSU:GetObjectType(ret[4]) == 2) then -- Slider
					local points = {}
					local _repeat = 1
					local length = 1
					local type = string.Left(ret[6], 1)
					local curveStart = 0
					local _len = string.len(_ctx)
					local sliderDataString = ""
					local edgesound = OSU:GetHitsoundTable(tonumber(ret[5]))
					for _ = 1, _len, 1 do
						if(string.sub(_ctx, _, _) == "|") then
								curveStart = _ + 1
							break
						end
					end
					local curveData = string.Explode("|", string.sub(_ctx, curveStart, _len))
					local _max = #curveData
					for _ = 1, #curveData, 1 do -- Make sure it ends on corrent position
						local inx = string.Explode(":", curveData[_])
						local ex = string.Explode(",", inx[2])
						if(#ex >= 3) then
							_max = _
							break
						end
					end
					table.insert(points, Vector(_x, _y))
					for x, y in pairs(curveData) do
						if(x > _max) then continue end -- Unused datas
						
						if(x < _max) then -- Vec datas
							local _v = string.Explode(":", y)
							local scX, scY = OSU:OsuPixelToPixel(tonumber(_v[1]), tonumber(_v[2]))
							local _x, _y = OSU:OsuPixelToScreen(scX, scY)
							table.insert(points, Vector(_x, _y))
						else -- Slider datas
							sliderDataString = y
							local dataStart = 1
							local dataLen = string.len(y)
							for _ = 1, dataLen, 1 do
								if(string.sub(y, _, _) == ",") then
										dataStart = _ + 1
									break
								end
							end
							local sliderDatas = string.Explode(",", string.sub(y, dataStart, dataLen))
							_repeat = sliderDatas[1]
							length = sliderDatas[2]
							if(sliderDatas[3] != nil) then
								edgesound = OSU:GetHitsoundTable(tonumber(sliderDatas[3]))
							end
							local _v = string.Explode(":", string.sub(y, 1, dataStart - 2))
							local scX, scY = OSU:OsuPixelToPixel(tonumber(_v[1]), tonumber(_v[2]))
							local _x, _y = OSU:OsuPixelToScreen(scX, scY)
							table.insert(points, Vector(_x, _y))
							--[[
								local scX, scY = OSU:OsuPixelToPixel(_v[1], _v[2])
								local _x, _y = OSU:OsuPixelToScreen(scX, scY)
							]]
						end 
					end
					_repeat = tonumber(_repeat)
					length = tonumber(length)
					local ret_curves, realFollowPoint = OSU:GetCurves(type, points, length)
					table.insert(OSU.Objects, {
						["otime"] = time,
						["type"] = 2,
						["time"] = time,
						["sound"] = hitsound,
						["vec_2"] = osu_vec2t(_x, _y),
						["followpoint"] = ret_curves,
						["realfollowpoint"] = realFollowPoint,
						["connectpoints"] = points,
						["stype"] = type,
						["length"] = length,
						["repeat"] = _repeat,
						["edgesd"] = edgesound,
						["spawned"] = false,
						["newcombo"] = newcombo,
					})
				else -- Spinner
					table.insert(OSU.Objects, {
						["otime"] = time,
						["type"] = 3,
						["time"] = time,
						["sound"] = hitsound,
						["vec_2"] = osu_vec2t(_x, _y),
						["killttime"] = (tonumber(ret[6]) / 1000) - apprTime,
						["okilltime"] = (tonumber(ret[6]) / 1000) - apprTime,
						["spawned"] = false,
					})
				end
				nextTime = OSU.CurTime + 2
			end
			local _eTime = SysTime()
			local _processTime = (_eTime - _sTime)
			OSU.BeatmapTime = nextTime + _processTime
			for i = tps_start, tps_end, 1 do
				local _ctx = ctx[i]
				local ret = string.Explode(",", _ctx)
				if(i == tps_start) then
					OSU.BeatLength = tonumber(ret[2])
					if(OSU.HT) then
						OSU.BeatLength = OSU.BeatLength * 1.5
					end
					if(OSU.DT) then
						OSU.BeatLength = OSU.BeatLength * 0.5
					end
				end
				if(tonumber(ret[2]) == nil || tonumber(ret[2]) > 0) then continue end
				if(tonumber(ret[1]) == nil || tonumber(ret[2]) == nil || tonumber(ret[3]) == nil || tonumber(ret[4]) == nil || tonumber(ret[8]) == nil) then continue end
				table.insert(OSU.TimingPoints, {(tonumber(ret[1]) / 1000), tonumber(ret[2]), false, tonumber(ret[4]), tonumber(ret[8])})
			end
			local temp = {
				["objects"] = OSU.Objects,
				["timing"] = OSU.TimingPoints,
			}
			if(OSU.WriteObjectFile) then
				file.Write(OSU.HitObjectsCachePath..id..".dat", util.TableToJSON(temp))
				OSU:CenteredMessage("Writing beatmap temp ("..id..".dat), this lag will only happen once per beatmap!  ("..math.Round(_processTime, 3).."s)", _processTime)
			else
				--OSU:CenteredMessage("Map loaded ("..math.Round(_processTime, 3).."s)", _processTime)
			end
			for k,v in next, OSU.TimingPoints do
				local mul = 1
				if(OSU.HT) then
					mul = 1.5
				end
				if(OSU.DT) then
					mul = 0.5
				end
				v[1] = (v[1] * mul) + OSU.BeatmapTime
			end
			for k,v in next, OSU.Objects do
				v["time"] = OSU.BeatmapTime + v["time"] - apprTime
				if(v["type"] == 3) then
					v["killttime"] = OSU.BeatmapTime + v["killttime"]
				end
				if(k == 1) then
					OSU.BeatmapStartTime = v["time"]
				end
				if(k == #OSU.Objects) then
					OSU.BeatmapEndTime = v["time"] + 2.5
				end
				if(OSU.HR) then
					if(v["type"] == 2) then
						v["vec_2"].x = ScrW() - v["vec_2"].x
						v["vec_2"].y = ScrH() - v["vec_2"].y
						for x,y in next, v["followpoint"] do
							if(x == 1) then
								table.remove(v["followpoint"], k)
								continue
							end
							y.x = ScrW() - y.x
							y.y = ScrH() - y.y
						end
						for x,y in next, v["realfollowpoint"] do
							y.x = ScrW() - y.x
							y.y = ScrH() - y.y
						end
					end
					if(v["type"] == 1) then
						v["vec_2"].x = ScrW() - v["vec_2"].x
						v["vec_2"].y = ScrH() - v["vec_2"].y
					end
				end
			end
			local breakStart = 0
			local breakEnd = 0
			for k,v in pairs(ctx) do
				if(string.find(v, "SliderMultiplier:")) then
					local num = string.Replace(v, "SliderMultiplier:", "")
					OSU.SliderMultiplier = tonumber(num)
					OSU.SliderVelocity = OSU.SliderMultiplier
				end
				if(string.find(v, "SampleSet:")) then
					OSU.CurrentHitSound = OSU:PickSampleSet(string.Replace(v, "SampleSet: ", ""))
					OSU.BeatmapDefaultSet = OSU:PickSampleSet(string.Replace(v, "SampleSet: ", ""))
				end
				if(breakStart == 0) then
					if(string.find(v, "//Break")) then
						breakStart = k + 1
					end
				else
					if(breakEnd == 0) then
						if(string.find(v, "//Storyboard Layer 0")) then
							breakEnd = k - 1
						end
					end
				end
			end
			if(breakStart != 0 && breakEnd != 0) then
				for i = breakStart, breakEnd, 1 do
					if(ctx[i] == nil) then continue end
					local _bd = string.Explode(",", ctx[i])
					table.insert(OSU.Breaks, {OSU.BeatmapTime + (tonumber(_bd[2]) / 1000),OSU.BeatmapTime + (tonumber(_bd[3]) / 1000), false})
				end
			end
		end
	local mul = 1
	if(OSU.HT) then
		mul = 1.5
	end
	if(OSU.DT) then
		mul = 0.5
	end
	for k,v in next, OSU.Objects do
		v["time"] = OSU.BeatmapTime + (v["otime"] * mul) - apprTime
		if(v["type"] == 3) then
			v["killttime"] = OSU.BeatmapTime + (v["okilltime"] * mul)
		end
		if(k == 1) then
			OSU.BeatmapStartTime = v["time"]
		end
		if(k == #OSU.Objects) then
			OSU.BeatmapEndTime = v["time"] + 2.5
		end
	end
	OSU.OffsList = {}
	OSU.TotalHitOffs = 0
	OSU.AvgHitOffs = 0
	OSU.TotalHitObjects = 0
	OSU.ArrowTargetPos = 0
	OSU.CurrentArrowPos = 0
	OSU.ArrowAlpha = 0
	OSU:UpdateOD()
	OSU.Hit300Tx = Material(OSU.CurrentSkin["hit300"])
	OSU.Hit100Tx = Material(OSU.CurrentSkin["hit100"])
	OSU.Hit50Tx = Material(OSU.CurrentSkin["hit50"])
	OSU.Hit0Tx = Material(OSU.CurrentSkin["hit0"])
	OSU.TempData = {
		["b"] = beatmap,
		["i"] = id,
	}
	local gap = ScreenScale(3)
	local m, w, h = OSU:PickMaterial("1")
	local _x, _y = ScreenScale(4), ScreenScale(4)
	local nextExecute = 0.1
	local ExecuteTime = 0
	local srate = ScrW() * 0.5
	local smin = ScrW() * 6
	local smax = ScrW() * 24
	local sx = smax
	local falpha = 255
	if(OSU.ReplayMode) then
		falpha = 200
	end
	if(!IsValid(OSU.PlayFieldLayer)) then return end
	OSU.PlayFieldLayer.Paint = function()
		surface.SetMaterial(OSU.FollowPointTx["t"])
		for _, t in next, OSU.FollowPointsTable do
			for k,v in next, t do
			-- pos, alpha, alpha++, end time, angle, st time
			if(v[4] > OSU.CurTime) then
				if(v[6] <= OSU.CurTime) then
					v[2] = math.Clamp(v[2] + OSU:GetFixedValue(v[3]), 0, 255)
				end
			else
				if(v[7] <= OSU.CurTime) then
					v[2] = math.Clamp(v[2] - OSU:GetFixedValue(v[3]), 0, 255)
				end
				if(v[2] <= 0) then
					table.remove(OSU.FollowPointsTable[_], k)
				end
			end

			surface.SetDrawColor(255, 255, 255, v[2])
			surface.DrawTexturedRectRotated(v[1].x, v[1].y, OSU.FollowPointTx["w"], OSU.FollowPointTx["h"], v[5])
			end
		end
	end
	OSU.PlayFieldLayer.UpperLayer.Paint = function()
			if(OSU.FL) then
				local x, y = input.GetCursorPos()
				if(OSU.ReplayMode) then
					x, y = OSU.FakeCursorPos.x, OSU.FakeCursorPos.y
				end
				if(OSU.BreakTime > OSU.CurTime || OSU.BeatmapStartTime > OSU.CurTime) then
					sx = math.Clamp(sx + OSU:GetFixedValue((smax - smin) * 0.1), smin, smax)
				else
					sx = math.Clamp(sx - OSU:GetFixedValue((sx - smin) * 0.1), smin, smax)
				end
				surface.SetDrawColor(0, 0, 0, falpha)
				surface.SetMaterial(OSU.FlashLight)
				surface.DrawTexturedRectRotated(x, y, sx, sx, 0)
			end
			if(OSU.GlobalMatShadowSize > OSU.GlobalMatSize) then
				OSU.GlobalMatShadowSize = math.Clamp(OSU.GlobalMatShadowSize - OSU:GetFixedValue(0.03), OSU.GlobalMatSize, 2)
				OSU:DrawStringAsMaterial(OSU.Combo.."x", 0 + gap, ScrH() - gap, OSU.GlobalMatShadowSize, 2, 100, false, false)
			end
			OSU.GlobalMatSize = math.Clamp(OSU.GlobalMatSize - OSU:GetFixedValue(0.02), 1, 1.15)
			OSU:DrawStringAsMaterial(OSU.Combo.."x", 0 + gap, ScrH() - gap, OSU.GlobalMatSize, 2, 255, false, false)
			OSU:DrawStringAsMaterial(OSU.DisplayScore, ScrW() - gap, 0 + gap, 1, -gap, 255, true, true)
			OSU:DrawStringAsMaterial(string.format("%3.2fp", OSU.Accuracy), ScrW() - gap, 0 + gap + h, 0.75, 0, 255, true, false)

			surface.SetDrawColor(255, 255, 255, 255 * OSU.GlobalAlphaMult)
			surface.SetMaterial(OSU.ScoreBarData["bg"])
			surface.DrawTexturedRect(0, 0, OSU.ScoreBarData["gw"], OSU.ScoreBarData["gh"])
			if(IsValid(OSU.HealthBar)) then
				OSU.HealthBar:SetVisible(true)
				OSU.HealthBar:SetPos(_x, _y)
				OSU.HealthBar.Bar:SetImage(OSU.ScoreBarData["bc"])
				OSU.HealthBar.Bar:SetSize(OSU.ScoreBarData["cw"], OSU.ScoreBarData["ch"])
				OSU.HealthBar.Bar:SetImageColor(Color(255, 255, 255, 255 * OSU.GlobalAlphaMult))
				local len = OSU.ScoreBarData["cw"] * (OSU.Health / 100)
				local cWide = OSU.HealthBar:GetWide()
				local scl = OSU:GetFixedValue((len - cWide) * 0.1)
				if(scl > 0 && scl < 1) then
					scl = 1
				end
				if(scl < 0 && scl > -0.1) then
					scl = -0.1
				end
				OSU.HealthBar:SetSize(math.Clamp(cWide + scl, 0, OSU.ScoreBarData["cw"]), OSU.ScoreBarData["ch"])
			end
			if(OSU.AutoNotes) then
				local alp = 255
				surface.SetMaterial(OSU.UnrankedTx["t"])
				surface.SetDrawColor(255, 255, 255, alp)
				surface.DrawTexturedRect((ScrW() / 2) - OSU.UnrankedTx["w"] / 2, (ScrH() * 0.125) - OSU.UnrankedTx["h"] / 2, OSU.UnrankedTx["w"], OSU.UnrankedTx["h"])
				local t = "Watching osu! playing   "..OSU.BeatmapDetails["Title"]
				local xh = OSU:GetTextSize("OSUBeatmapResultMapper", t)
				if(OSU.AutoplayTextOffs <= 0) then
					OSU.AutoplayTextOffs = ScrW() + (xh * 1.25)
				end
				draw.DrawText(t, "OSUBeatmapResultMapper", OSU.AutoplayTextOffs, ScrH() * 0.175, Color(255, 255, 255, alp), TEXT_ALIGN_RIGHT)
				OSU.AutoplayTextOffs = OSU.AutoplayTextOffs - OSU:GetFixedValue(2)
			end
			if(OSU.ReplayMode) then
				local t = "REPLAY MODE - Watching "..OSU.ReplayModeUserNick.." play "..OSU.BeatmapDetails["Title"]
				local xh = OSU:GetTextSize("OSUBeatmapResultMapper", t)
				if(OSU.AutoplayTextOffs <= 0) then
					OSU.AutoplayTextOffs = ScrW() + (xh * 1.25)
				end
				draw.DrawText(t, "OSUBeatmapResultMapper", OSU.AutoplayTextOffs, ScrH() * 0.175, Color(255, 255, 255, alp), TEXT_ALIGN_RIGHT)
				OSU.AutoplayTextOffs = OSU.AutoplayTextOffs - OSU:GetFixedValue(2)
			end
			if(OSU.HitErrorBar) then
				local alp = 255 * OSU.GlobalAlphaMult
				local xAxis, yAxis = ScrW() / 2, ScrH() * 0.98
				local h = ScreenScale(3)
				local fTime = OSU.HIT50Time
				local fullLen = ScreenScale(400) * OSU.HIT50Time
				local len1 = fullLen * (OSU.HIT300Time / fTime)
				local len2 = fullLen * (OSU.HIT100Time / fTime)
				surface.SetDrawColor(206, 178, 78, alp)
				surface.DrawRect(xAxis - (fullLen / 2), yAxis - h / 2, fullLen, h)
				surface.SetDrawColor(137, 225, 45, alp)
				surface.DrawRect(xAxis - (len2 / 2), yAxis - h / 2, len2, h)
				surface.SetDrawColor(112, 183, 230, alp)
				surface.DrawRect(xAxis - (len1 / 2), yAxis - h / 2, len1, h)
				surface.SetDrawColor(255, 255, 255, alp)
				local w = ScreenScale(1)
				h = ScreenScale(9)
				surface.DrawRect(xAxis - (w / 2), yAxis - h / 2, w, h)
				if(OSU.ArrowTargetPos != 0) then
					OSU.ArrowAlpha = math.Clamp(OSU.ArrowAlpha + OSU:GetFixedValue(15), 0, 255)
					local sx = ScreenScale(5)
					surface.SetDrawColor(255, 255, 255, OSU.ArrowAlpha * OSU.GlobalAlphaMult)
					surface.SetMaterial(OSU.HitArrowTx)
					local hLen = fullLen / 2
					OSU.CurrentArrowPos = math.Clamp(OSU.CurrentArrowPos + OSU:GetFixedValue((OSU.ArrowTargetPos - OSU.CurrentArrowPos) * 0.05), -hLen, hLen)
					surface.DrawTexturedRect((xAxis + OSU.CurrentArrowPos) - sx / 2, yAxis - (sx * 1.2), sx, sx)
					h = ScreenScale(7)
					for k,v in next, OSU.OffsList do
						if(v[3] < OSU.CurTime) then
							v[2] = math.Clamp(v[2] - OSU:GetFixedValue(15), 0, 255)
							if(v[2] <= 0) then
								table.remove(OSU.OffsList, k)
							end
						end
						surface.SetDrawColor(255, 255, 255, v[2])
						surface.DrawRect((xAxis + v[1]) - w / 2, yAxis - (h / 2), w, h)
					end
					if(OSU.NextResetTime < OSU.CurTime) then
						OSU.TotalHitObjects = 0
						OSU.TotalHitOffs = 0
						OSU.NextResetTime = OSU.CurTime + 1.5
					end
				end
			end
			OSU.KiExt = math.Clamp(OSU.KiExt - OSU:GetFixedValue(5), 0, 1024)
	end
end