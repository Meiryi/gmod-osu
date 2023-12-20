--[[
	Gmod osu! - An unofficial port of osu! to Garry's mod.
	None of these codes should be modified or changed without original author's permission, anykind of modification is not allowed.

	You can use it on whatever you like, but you should not claim you're the original author,
	If you're a server owner, do not put this addon behind paywall, or some vip shit

	For translators, if you want to translate this addon, please contact me directly instead of modify the code
	REUPLOAD / REPACK IS NOT ALLOWED

	Copyright (C) 2023 Meika. All rights reserved
]]

function OSU:HideAllScenes()
	if(IsValid(OSU.ObjectLayer)) then
		OSU.ObjectLayer:SetVisible(false)
	end
	if(IsValid(OSU.PlayMenuLayer)) then
		OSU.PlayMenuLayer:SetVisible(false)
	end
	if(IsValid(OSU.PlayFieldLayer)) then
		OSU.Objects = {}
		OSU.PlayFieldLayer:Remove()
	end
	if(IsValid(OSU.ResultLayer)) then
		OSU.ResultLayer:SetVisible(false)
	end
end

--[[
	OSU_MENU_STATE_MAIN = 0
	OSU_MENU_STATE_BEATMAP = 1
	OSU_MENU_STATE_PLAYING = 2
	OSU_MENU_STATE_RESULT = 3
	OSU_MENU_STATE_REPLAY = 4
	OSU_MENU_STATE_PAUSE = 5
	OSU_MENU_STATE_FAILED = 6
]]

function OSU:FakeChangeScene(func)
	local blackScreen = OSU:CreateFrame(nil, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 0), true)
	blackScreen.iAlpha = 0
	blackScreen.Switch = false
	blackScreen.Think = function()
		if(blackScreen.Switch) then
			blackScreen.iAlpha = math.Clamp(blackScreen.iAlpha - OSU:GetFixedValue(20), 0, 255)
			if(blackScreen.iAlpha <= 0) then
				blackScreen:Remove()
			end
		else
			blackScreen.iAlpha = math.Clamp(blackScreen.iAlpha + OSU:GetFixedValue(20), 0, 255)
			if(blackScreen.iAlpha >= 255) then
				func()
				blackScreen.Switch = true
			end
		end
	end
end

function OSU:ChangeScene(state)
	local blackScreen = OSU:CreateFrame(OSU.MainGameFrame, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 0), true)
	local zPos = blackScreen:GetZPos()
	local exec = false
	local inc = false
	local blur = false
	local killtime = 0
	local fadedelay = 0
	local fixedvalue = 20
	local fixedvalue2 = 8
	local blurtime = SysTime()
	local blurtime_b = SysTime() - 1
	local res = false
	blackScreen:MakePopup()
	if(OSU.BlurShader) then
		blur = true
		fixedvalue = 15
	end
	blackScreen.Paint = function()
	blackScreen:SetZPos(32767)
		if(blur) then
			local s = SysTime()
			if(inc) then
				if(fadedelay < OSU.CurTime) then
					blurtime = math.Clamp(blurtime + OSU:GetFixedValue((s - blurtime) * 0.1), 0, SysTime())
				end
			else
				blurtime = math.Clamp(blurtime - OSU:GetFixedValue(0.1), blurtime_b, s)
			end
			if(!res) then
				Derma_DrawBackgroundBlur(blackScreen, blurtime)
			else
				res = false -- reset blurred background
			end
		end
		draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, blackScreen.iAlpha))
	end
	blackScreen.Think = function()
		if(blackScreen.iAlpha >= 255 && !exec) then
			OSU:HideAllScenes()
			if(state == OSU_MENU_STATE_BEATMAP) then
				OSU:SetupBeatmapPanel()
			elseif(state == OSU_MENU_STATE_MAIN) then
				OSU.ObjectLayer:SetVisible(true)
				OSU.ObjectLayer:MakePopup()
				OSU:ChangeBackground(OSU:PickMenuBackground())
				if(OSU.SoundChannel:GetState() != GMOD_CHANNEL_PLAYING) then
					OSU.SoundChannel:SetPlaybackRate(1)
					OSU.SoundChannel:Play()
				end
			elseif(state == OSU_MENU_STATE_RESULT) then
				local name = LocalPlayer():Nick()
				local rID = math.random(1, 16777216)
				if(OSU.AutoNotes) then
					name = "osu!"
				else
					OSU:OutputReplayFile(OSU.BeatmapDetails["ID"], rID)
				end
				OSU.HasReplay = false
				OSU:SetupResultPanel(name)
				local id = -1
				id = OSU.BeatmapDetails["ID"]
				local tmp = {
					["score"] = OSU.Score,
					["combo"] = OSU.HighestCombo,
					["accuracy"] = OSU.Accuracy,
					["ID"] = id,
					["3"] = OSU.HIT300,
					["1"] = OSU.HIT100,
					["5"] = OSU.HIT50,
					["m"] = OSU.MISS,
					["rID"] = rID,
				}
				local baseScore = (tmp["3"] * 300) + (tmp["1"] * 100) + (tmp["5"] * 50)
				if(tmp["score"] < baseScore) then tmp["score"] = baseScore + 1 end
				if(tmp["combo"] < 0) then tmp["combo"] = 1 end
				if(tmp["score"] < 0) then tmp["score"] = 1 end
				OSU:SubmitScore(tmp)
			elseif(state == 16) then
				OSU:SetupBeatmapDownloadPanel()
			end
			exec = true
			OSU.MENU_STATE = state
		end
		if(!inc) then
			blackScreen.iAlpha = math.Clamp(blackScreen.iAlpha + OSU:GetFixedValue(fixedvalue), 0, 255)
			if(blackScreen.iAlpha >= 255) then
				inc = true
				if(OSU.BlurShader) then
					fixedvalue = fixedvalue2
					killtime = SysTime() + 0.33
					fadedelay = SysTime() + 0.15
					res = true
				end
			end
		else
			blackScreen.iAlpha = math.Clamp(blackScreen.iAlpha - OSU:GetFixedValue(fixedvalue), 0, 255)
			if(blackScreen.iAlpha <= 0) then
				blackScreen:Remove()
				OSU.MainGameFrame.Bluring = false
			end
		end
	end
end