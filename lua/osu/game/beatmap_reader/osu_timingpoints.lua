function OSU:GetTimingPoints(ctx, details)
	local tps_start, tps_end = details["Timepoint Range"][1], details["Timepoint Range"][2]
	OSU.MenuTimingPoints = {}
	OSU.MenuTimingPoints_Temp = {}
	if(tps_start == nil || tps_end == nil) then
		return
	end
	local v = string.Explode("\n", ctx)
	for i = tps_start, tps_end, 1 do
		local line = v[i]
		local ret = string.Explode(",", line)
		if(tonumber(ret[1]) == nil || tonumber(ret[2]) == nil || tonumber(ret[3]) == nil || tonumber(ret[4]) == nil || tonumber(ret[8]) == nil) then continue end
		local bpm = false
		local _bpm = 0
		if(tonumber(ret[2]) > 0) then
			bpm = true
			_bpm = 1 / tonumber(ret[2]) * 1000 * 60
		end
		table.insert(OSU.MenuTimingPoints, {tonumber(ret[1]) / 1000, tonumber(ret[8]), false, _bpm, bpm})
	end
end