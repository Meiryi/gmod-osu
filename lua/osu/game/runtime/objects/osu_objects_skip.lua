--[[
	Gmod osu! - An unofficial port of osu! to Garry's mod.
	None of these codes should be modified or changed without original author's permission, anykind of modification is not allowed.

	You can use it on whatever you like, but you should not claim you're the original author,
	If you're a server owner, do not put this addon behind paywall, or some vip shit

	For translators, if you want to translate this addon, please contact me directly instead of modify the code
	REUPLOAD / REPACK IS NOT ALLOWED

	Copyright (C) 2023 Meika. All rights reserved
]]

function OSU:CreateSkipButton()
	local w, h = ScreenScale(64), ScreenScale(49)
	local x, y = ScrW(), ScrH()
	local skip = vgui.Create("DImageButton", OSU.PlayFieldLayer)
		skip:SetSize(w, h)
		skip:SetPos(x - w, y - h)
		skip:SetImage(OSU.CurrentSkin["play-skip"])
		skip:SetColor(Color(255, 255, 255, 255))
		local sTime = OSU.BeatmapStartTime - 1
		local fade = false
		skip.iAlpha = 0
		skip.Think = function()
			local timediff = sTime - OSU.CurTime
			if(timediff <= 0) then
				fade = true
			end
			if(fade) then
				skip.iAlpha = math.Clamp(skip.iAlpha - OSU:GetFixedValue(20), 0, 255)
				if(skip.iAlpha <= 0) then
					skip:Remove()
				end
			else
				skip.iAlpha = math.Clamp(skip.iAlpha + OSU:GetFixedValue(20), 0, 255)
			end
			if(OSU.ReplayMode) then
				if(OSU.CurrentReplayData.Specs.skip != -1) then
					if(OSU.CurrentReplayData.Specs.skip + OSU.BeatmapTime < OSU.CurTime) then
						skip:aSkip()
						OSU.CurrentReplayData.Specs.skip = -1
					end
				end
			end
			skip:SetColor(Color(255, 255, 255, skip.iAlpha))
		end
		skip.DoClick = function()
			if(fade) then return end
			if(!OSU.ReplayMode) then
				OSU:InsertSkipTime(OSU.CurTime - OSU.BeatmapTime)
			else
				return
			end
			OSU:PlaySoundEffect(OSU.CurrentSkin["menu-direct-click"])
			fade = true
			local musicoffs = sTime - OSU.BeatmapTime
			OSU.SoundChannel:SetTime(musicoffs, false)
			local offs = sTime - OSU.CurTime
			for k,v in next, OSU.Objects do
				v["time"] = v["time"] - offs
				if(v["type"] == 3) then
					v["killttime"] = v["killttime"] - offs
				end
				if(OSU.CurrentMode == 3) then
					if(v["type"] != 1) then
						v["endtime"] = v["endtime"] - offs
					end
				end
			end
			for k,v in next, OSU.Breaks do
				v[1] = v[1] - offs
				v[2] = v[2] - offs
			end
			for k,v in next, OSU.TimingPoints do
				v[1] = v[1] - offs
			end
			OSU.BeatmapStartTime = OSU.CurTime
			OSU.BeatmapEndTime = OSU.BeatmapEndTime - offs
		end
		function skip:aSkip()
			if(fade) then return end
			OSU:PlaySoundEffect(OSU.CurrentSkin["menu-direct-click"])
			fade = true
			local musicoffs = sTime - OSU.BeatmapTime
			OSU.SoundChannel:SetTime(musicoffs, false)
			local offs = sTime - OSU.CurTime
			for k,v in next, OSU.Objects do
				v["time"] = v["time"] - offs
				if(v["type"] == 3) then
					v["killttime"] = v["killttime"] - offs
				end
				if(OSU.CurrentMode == 3) then
					if(v["type"] != 1) then
						v["endtime"] = v["endtime"] - offs
					end
				end
			end
			for k,v in next, OSU.Breaks do
				v[1] = v[1] - offs
				v[2] = v[2] - offs
			end
			for k,v in next, OSU.TimingPoints do
				v[1] = v[1] - offs
			end
			OSU.BeatmapStartTime = OSU.CurTime
			OSU.BeatmapEndTime = OSU.BeatmapEndTime - offs
		end
	return skip
end