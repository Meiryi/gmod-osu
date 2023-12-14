--[[
	Gmod osu! - An unofficial port of osu! to Garry's mod.
	None of these codes should be modified or changed without original author's permission, anykind of modification is not allowed.

	You can use it on whatever you like, but you should not claim you're the original author,
	If you're a server owner, do not put this addon behind paywall, or some vip shit

	For translators, if you want to translate this addon, please contact me directly instead of modify the code
	REUPLOAD / REPACK IS NOT ALLOWED

	Copyright (C) 2023 Meika. All rights reserved
]]

function OSU:GetAvgPeak()
	if(#OSU.Peaks > 1) then
		local sum = 0
		for k,v in next, OSU.Peaks do
			sum = sum + v
		end
		return sum / #OSU.Peaks
	else
		return 0
	end
end

function OSU:GetHighOffs()
	return math.abs(OSU.FreqAvg - OSU.HighestSample)
end

--[[
	1 / 43

	Kick : 60 -> 130 [2, 3, 4]
	Drum : 301 -> 750 [7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 ,18]
]]

local Interval = 0
local amp = 30

hook.Add("Think", "OSU_FFTProcessing", function()
	OSU.CurTime = SysTime()
	--[[
	if(IsValid(OSU.SoundChannel) && OSU.SoundChannel:GetState() == GMOD_CHANNEL_PLAYING) then
		local fft = {}
		OSU.SoundChannel:FFT(fft, 2048)
		if(OSU.NextRecord < OSU.CurTime) then
			local avg = 0
			for i = 1, #fft do
				avg = avg + fft[i]
			end
			local beat = false
			local avg = avg * amp
			local prev = OSU.Samples[#OSU.Samples]
			if(OSU.TimeSinceLastBeat < OSU.CurTime) then
				if(#OSU.Peaks > 0) then
					table.remove(OSU.Peaks, #OSU.Peaks)
				end 
			end
			if(OSU.HighestSample == 0) then
				OSU.HighestSample = avg
			else
				if(avg > OSU.HighestSample) then
					OSU.HighestSample = avg
				end
			end
			if(prev != nil) then
				if(!prev[3]) then
					local _fi = prev[1]
					for i = #OSU.Samples, #OSU.Samples - 4, -1 do -- Use multiple samples instead of 1
						local sample = OSU.Samples[i]
						local prevsample = OSU.Samples[i - 1]
						if(prevsample == nil) then continue end
						if(sample[1] < prevsample[1]) then _fi = sample[1] continue end
						_fi = sample[1]
					end
					if(_fi > prev[1]) then
						_fi = prev[1]
					end
					if(math.abs(avg - _fi) > OSU.FreqAvg / 2 && avg >= OSU.FreqAvg) then
						if(math.abs(avg - _fi) > math.abs(OSU:GetAvgPeak() - OSU.FreqAvg) * 0.9) then
							hook.Run("Osu_Beat")
							beat = true
							table.insert(OSU.Peaks, avg)
							OSU.TimeSinceLastBeat = OSU.CurTime + 1
						end
					end
				end
			end
			table.insert(OSU.Samples, {avg, OSU.CurTime + 1, beat, false})
			OSU.NextRecord = OSU.CurTime + OSU.SampleInterval -- 64 samples per seconds
		end
	end
	OSU.FreqAvg = 0
	for i = #OSU.Samples, 1, -1 do
		OSU.FreqAvg = OSU.FreqAvg + OSU.Samples[i][1]
		if(OSU.Samples[i][2] < OSU.CurTime) then
			table.remove(OSU.Samples, i)
		continue
		end
	end
	OSU.FreqAvg = (OSU.FreqAvg / #OSU.Samples)
	]]
end)
