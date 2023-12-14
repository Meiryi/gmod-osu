--[[
	Gmod osu! - An unofficial port of osu! to Garry's mod.
	None of these codes should be modified or changed without original author's permission, anykind of modification is not allowed.

	You can use it on whatever you like, but you should not claim you're the original author,
	If you're a server owner, do not put this addon behind paywall, or some vip shit

	For translators, if you want to translate this addon, please contact me directly instead of modify the code
	REUPLOAD / REPACK IS NOT ALLOWED

	Copyright (C) 2023 Meika. All rights reserved
]]

function OSU:PickScoreKi()
	if(OSU.Health >= 67) then
		return OSU.ScoreBarData["ki1"], OSU.ScoreBarData["kw1"], OSU.ScoreBarData["kh1"]
	elseif(OSU.Health >= 33) then
		return OSU.ScoreBarData["ki2"], OSU.ScoreBarData["kw2"], OSU.ScoreBarData["kh2"]
	else
		return OSU.ScoreBarData["ki3"], OSU.ScoreBarData["kw3"], OSU.ScoreBarData["kh3"]
	end
end

function OSU:GetSampleSet(sample)
	if(sample == 0) then
		return OSU.BeatmapDefaultSet
	elseif(sample == 1) then
		return "normal"
	elseif(sample == 2) then
		return "soft"
	elseif(sample == 3) then
		return "drum"
	else
		return "normal"
	end
end

function OSU:RunTime()
	if(!IsValid(OSU.PlayFieldLayer)) then
		local color = OSU.Background:GetImageColor()
		local cv = math.Clamp((color.r) + OSU:GetFixedValue(10), OSU.BackgroundDim, 255)
		OSU.Background:SetImageColor(Color(cv, cv, cv, 255))
		return
	end
	local color = OSU.Background:GetImageColor()
	OSU.BackgroundDimInc = math.Clamp(OSU.BackgroundDimInc - OSU:GetFixedValue(2), 0, 255)
	local cv = math.Clamp((color.r) - OSU:GetFixedValue(10), OSU.BackgroundDim + OSU.BackgroundDimInc, 255)
	OSU.Background:SetImageColor(Color(cv, cv, cv, 255))
	if(OSU.BeatmapTime - OSU.AppearTime > OSU.CurTime) then return end
	if(!OSU.MusicStarted && OSU.BeatmapTime < OSU.CurTime) then
		OSU.SoundChannel:Play()
		if(OSU.BeatmapStartTime - OSU.BeatmapTime >= 3) then 
			OSU.SkipButton = OSU:CreateSkipButton()
		end
		OSU.MusicStarted = true
	end
	--[[
		["type"] = 1,
		["time"] = nextTime + time,
		["sound"] = hitsound,
		["vec_2"] = osu_vec2t(_x, _y),
		["spawned"] = false,
	]]
	for k, v in next, OSU.ScreenObjects do
		if(IsValid(v)) then
			continue
		else
			table.remove(OSU.ScreenObjects, k)
		end
	end
	for k,v in next, OSU.Breaks do
		if(!v[3] && v[1] < OSU.CurTime) then
			OSU.BreakTime = v[2]
			v[3] = true
		else
			if(v[3]) then
				table.remove(OSU.Breaks, k)
			end
		end
	end
	for k,v in next, OSU.TimingPoints do
		if(v[3]) then
			table.remove(OSU.TimingPoints, k)
		else
			if(v[1] <= OSU.CurTime && !v[3]) then
				OSU.CurrentHitSound = OSU:GetSampleSet(v[4])
				OSU.SliderVelocity = 1 / (math.abs(tonumber(v[2])) / 100)
				if(v[5] == 1 && !OSU.DisableFlash) then
					if(!OSU.KiaiTime) then
						OSU.BackgroundDimInc = 75
						OSU.KiaiTime = true
					end
				else
					OSU.KiaiTime = false
				end
				v[3] = true
			end
		end
	end
	for k,v in next, OSU.Objects do
		if(v["spawned"]) then
			table.remove(OSU.Objects, k)
		else
			if(v["time"] <= OSU.CurTime) then
				if(v["type"] == 1) then
					OSU:CreateCircle(v["vec_2"], v["sound"], OSU.CurrentZPos, nil, OSU.ObjectIndex)
				elseif(v["type"] == 2) then
					OSU:CreateSlider(v["vec_2"], v["followpoint"], v["realfollowpoint"], v["connectpoints"], v["length"], v["repeat"], v["sound"], OSU.CurrentZPos, v["stype"], OSU.ObjectIndex)
				else
					OSU:CreateSpinner(v["vec_2"], v["sound"], OSU.CurrentZPos, v["killttime"])
					if(k == #OSU.Objects) then
						OSU.BeatmapEndTime = v["killttime"] + 2
					end
				end
				OSU.ObjectIndex = OSU.ObjectIndex + 1
				OSU.CurrentZPos = OSU.CurrentZPos - 1
				v["spawned"] = true
			end
		end
	end

	if(OSU.BreakTime > OSU.CurTime) then
		OSU.Health = math.Clamp(OSU.Health + OSU:GetFixedValue(0.05), 0, 100)
		OSU.GlobalAlphaMult = math.Clamp(OSU.GlobalAlphaMult - OSU:GetFixedValue(0.035), 0, 1)
	else
		if(OSU.BeatmapStartTime < OSU.CurTime && #OSU.Objects > 0) then
			OSU.Health = math.Clamp(OSU.Health - OSU:GetFixedValue(OSU.HP * 0.035), 0, 100)
		end
		if(OSU.Health <= 0 && OSU.PlayFieldYOffs <= 0 && !OSU.NF && !OSU.ReplayMode) then
			OSU:SetupFailPanel()
		end
		OSU.GlobalAlphaMult = math.Clamp(OSU.GlobalAlphaMult + OSU:GetFixedValue(0.035), 0, 1)
	end

	OSU.DisplayScore = math.floor(math.Clamp(OSU.DisplayScore + math.max(OSU:GetFixedValue(math.abs(OSU.Score - OSU.DisplayScore) * 0.5), 1), 0, OSU.Score))

	if(OSU.BeatmapEndTime < OSU.CurTime && #OSU.ScreenObjects <= 0 && !OSU.GameEnded) then
		OSU.GlobalAlphaMult = 1
		OSU:ChangeScene(OSU_MENU_STATE_RESULT)
		OSU.GameEnded = true
		OSU.ShouldDrawFakeCursor = false
	else
		if(input.IsKeyDown(70) && !OSU.GameEnded) then
			OSU.GlobalAlphaMult = 1
			OSU:ChangeScene(OSU_MENU_STATE_MAIN)
			OSU.GameEnded = true
			OSU.ShouldDrawFakeCursor = false
		end
	end

	if(OSU.ReplayMode) then
		for k,v in next, OSU.CurrentReplayData.MouseData["bnk_"..OSU.CurrentTableIndex_Read] do
			local time = v[1] + OSU.BeatmapTime
			if(time > OSU.CurTime) then
				local offs = time - OSU.CurTime
				if(offs < 0.033 && offs > 0) then
					local scl = OSU.CurrentReplayData.Specs.w / ScrW()
					local oX, oY = OSU.FakeCursorPos.x, OSU.FakeCursorPos.y
					local nX, nY = v[2] * scl, v[3] * scl
					local offX, offY = oX - nX, oY - nY
					OSU.FakeCursorPos = {x = math.Clamp(oX - OSU:GetFixedValue(offX ), 0, ScrW()), y = math.Clamp(oY - OSU:GetFixedValue(offY), 0, ScrH())}
				end
				continue
			else
				local scl = OSU.CurrentReplayData.Specs.w / ScrW()
				OSU.FakeCursorPos = {x = v[2] * scl, y = v[3] * scl}
				table.remove(OSU.CurrentReplayData.MouseData["bnk_"..OSU.CurrentTableIndex_Read], k)
			end
		end
		if(#OSU.CurrentReplayData.MouseData["bnk_"..OSU.CurrentTableIndex_Read] <= 0) then
			if(OSU.CurrentReplayData.MouseData["bnk_"..(OSU.CurrentTableIndex_Read + 1)] != nil) then
				OSU.CurrentTableIndex_Read = OSU.CurrentTableIndex_Read + 1
			end
		end
		for k,v in next, OSU.CurrentReplayData.KeyData do
			if(v[1] + OSU.BeatmapTime > OSU.CurTime) then
				continue
			else
				if(v[2] == 1) then
					OSU.KeyDown = true
				else
					OSU.KeyDown = false
				end
				table.remove(OSU.CurrentReplayData.KeyData, k)
			end
		end
	end

	if(OSU.RecordInterval < OSU.CurTime && !OSU.ReplayMode && !OSU.AutoNotes) then
		local time = OSU.CurTime - OSU.BeatmapTime
		--table.insert(OSU.ReplayData.MouseData, {time, OSU.CursorPos.x, OSU.CursorPos.y})
		OSU:RecordFrame({time, OSU.CursorPos.x, OSU.CursorPos.y})
		OSU.RecordInterval = OSU.CurTime + 0.033333
	end
end

function OSU:IsKeyDown()
	return (input.IsMouseDown(MOUSE_LEFT) || input.IsMouseDown(MOUSE_RIGHT) || input.IsKeyDown(OSU.Key1Code) || input.IsKeyDown(OSU.Key2Code)) -- holy shit lmao
end

local LeftDown = false
local RightDown = false
local Key1Down = false
local Key2Down = false
local GlobalKeyDown = false
hook.Add("Think", "OSU_RunTime", function()
	if(IsValid(OSU.PlayFieldLayer) && OSU.CurTime > OSU.BeatmapStartTime && !OSU.ReplayMode) then
		local time = OSU.CurTime - OSU.BeatmapTime
		if(OSU:IsKeyDown()) then
			if(!GlobalKeyDown) then
				table.insert(OSU.ReplayData.KeyData, {time, 1})
				GlobalKeyDown = true
			end
		else
			if(GlobalKeyDown) then
				table.insert(OSU.ReplayData.KeyData, {time, 0})
				GlobalKeyDown = false
			end
		end
	end
	local vPanel = vgui.GetHoveredPanel()
	if(!IsValid(vPanel)) then return end
	if(!vPanel.IsHitObject) then return end
	if(OSU.ReplayMode) then return end
	if(input.IsMouseDown(MOUSE_LEFT)) then
		OSU.KeyDown = true
		if(!LeftDown) then
			if(vPanel.Click != nil) then
				vPanel.Click()
			end
			LeftDown = true
		end
	else
		LeftDown = false
	end
	if(input.IsMouseDown(MOUSE_RIGHT)) then
		OSU.KeyDown = true
		if(!RightDown) then
			if(vPanel.Click != nil) then
				vPanel.Click()
			end
			RightDown = true
		end
	else
		RightDown = false
	end
	if(input.IsKeyDown(OSU.Key1Code)) then
		OSU.KeyDown = true
		if(!Key1Down) then
			if(vPanel.Click != nil) then
				vPanel.Click()
			end
			Key1Down = true
		end
	else
		Key1Down = false
	end
	if(input.IsKeyDown(OSU.Key2Code)) then
		OSU.KeyDown = true
		if(!Key2Down) then
			if(vPanel.Click != nil) then
				vPanel.Click()
			end
			Key2Down = true
		end
	else
		Key2Down = false
	end
	if(!input.IsMouseDown(MOUSE_LEFT) && !input.IsMouseDown(MOUSE_RIGHT) && !input.IsKeyDown(OSU.Key1Code) && !input.IsKeyDown(OSU.Key2Code)) then
		OSU.KeyDown = false
	end
end)