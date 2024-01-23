function OSU:ResetPerformance(rad, score)
	OSU.PP_AvgDst = rad * 1.5
	OSU.PP_Points = 0
	OSU.PP_AimChunk = 0
	OSU.PP_SpeedChunk = 0
	OSU.PP_AimVal = 0
	OSU.PP_SpeedVal = 0
	OSU.PP_AimSampledCount = 1
	OSU.PP_SpeedSampledCount = 1
	OSU.PP_BaseScore = score
	OSU.PP_AimAvg = 0
	OSU.PP_SpeedAvg = 0
	OSU.PP_DiffSampleCount = 0
	OSU.PP_DiffDstAvg = 0
	OSU.PP_DiffSpeedAvg = 0
	OSU.PP_DiffDstAvgSum = 0
	OSU.PP_DiffSpeedAvgSum = 0
	OSU.PP_AimAvgSum = 0
	OSU.PP_SpeedAvgSum = 0
	OSU.PP_StartedDiff = 0
	OSU.PP_TotalDiff = 0
	OSU.PP_DiffSwitch = false

	OSU.PP_LastHitTime = 0
	OSU.PP_LastHitVector = Vector(0, 0, 0)
end

function OSU:ProcessStrain()
	if(OSU.BreakTime > OSU.CurTime || OSU.BeatmapStartTime > OSU.CurTime) then return end
	OSU.PP_AimVal = math.max(OSU.PP_AimVal - OSU:GetFixedValue(math.max(OSU.PP_AimVal * 0.0075, 0.05)), 0)
	OSU.PP_SpeedVal = math.max(OSU.PP_SpeedVal - OSU:GetFixedValue(OSU.PP_SpeedVal * 0.0055), 0)

	if(OSU.PP_RecordInterval < OSU.CurTime) then
		if(OSU.PP_AimVal > 0) then
			OSU.PP_AimAvgSum = OSU.PP_AimAvgSum + OSU.PP_AimVal
			OSU.PP_AimChunk = OSU.PP_AimAvgSum / OSU.PP_AimSampledCount
			OSU.PP_AimSampledCount = OSU.PP_AimSampledCount + 1
		end
		if(OSU.PP_SpeedVal > 0) then
			OSU.PP_SpeedAvgSum = OSU.PP_SpeedAvgSum + OSU.PP_SpeedVal
			OSU.PP_SpeedChunk = OSU.PP_SpeedAvgSum / OSU.PP_SpeedSampledCount
			OSU.PP_SpeedSampledCount = OSU.PP_SpeedSampledCount + 1
		end
		local mul = (OSU.Accuracy / 100)
		local basePP = (OSU.PP_BaseScore * (OSU.PP_AimChunk + OSU.PP_SpeedChunk)) * mul
		local targetPP = (OSU.PP_BaseScore * (OSU.PP_AimVal + OSU.PP_SpeedVal)) * mul
		if(targetPP > OSU.PP_Points) then
			if(OSU.PP_DiffSwitch) then
				OSU.PP_StartedDiff = OSU.CurTime
				OSU.PP_DiffSwitch = false
			end
			local p = (targetPP - OSU.PP_Points) * 0.05
			OSU.PP_Points = OSU.PP_Points + p * mul
		else
			if(!OSU.PP_DiffSwitch) then
				OSU.PP_TotalDiff = OSU.CurTime + math.abs(OSU.CurTime - OSU.PP_StartedDiff)
				OSU.PP_DiffSwitch = true
			end
			if(OSU.PP_TotalDiff < OSU.CurTime) then
				OSU.PP_Points = math.max(OSU.PP_Points - (OSU.PP_Points - targetPP) * 0.005, basePP)
			end
		end
		OSU.PP_RecordInterval = OSU.CurTime + 0.33
	end
end

local vBonus = {
	[1] = 1,
	[2] = 0.667,
	[3] = 0.166,
	[4] = -1,
}
function OSU:CalcPerformance(_t, vec_2t, slider)
	_t = math.Clamp(_t, 1, 4)
	if(OSU.PP_LastHitVector == Vector(0, 0, 0) || slider) then
		OSU.PP_LastHitVector = vec_2t
		OSU.PP_LastHitTime = OSU.CurTime
		return
	end
	local dst = math.Distance(vec_2t.x, vec_2t.y, OSU.PP_LastHitVector.x, OSU.PP_LastHitVector.y)
	local tim = OSU.CurTime - OSU.PP_LastHitTime
	OSU.PP_DiffDstAvgSum = OSU.PP_DiffDstAvgSum + dst
	OSU.PP_DiffSpeedAvgSum = OSU.PP_DiffSpeedAvgSum + tim
	if(OSU.PP_DiffDstAvgSum > 0) then
		OSU.PP_DiffDstAvg = OSU.PP_DiffDstAvgSum / OSU.PP_DiffSampleCount
		if(OSU.PP_DiffDstAvgSum == math.huge) then
			OSU.PP_DiffDstAvgSum = 0
		end
	end
	if(OSU.PP_DiffSpeedAvgSum > 0) then
		OSU.PP_DiffSpeedAvg = OSU.PP_DiffSpeedAvgSum / OSU.PP_DiffSampleCount
	end
	OSU.PP_DiffSampleCount = OSU.PP_DiffSampleCount + 1
	local mul = vBonus[_t]
	local t = OSU.PP_BaseSpeed / (tim)
	if(t == math.huge) then return end
	local d = (dst / OSU.PP_AvgDst) * math.max(t, 1)
	local bonus = 1
	local punishment = 1
	if(tim < OSU.PP_DiffSpeedAvg * 1.15 && dst > OSU.PP_AvgDst * 1.5 && tim < OSU.PP_BaseSpeed * 2) then
		bonus = math.max(dst / OSU.PP_AvgDst , 1)
	end
	if(tim > OSU.PP_BaseSpeed * 2.5) then
		punishment = (OSU.PP_BaseSpeed * 2.5) / tim
	end
	local ap, sp = (d * bonus * punishment) * mul, (t * mul)
	if(_t == 4) then
		ap, sp = math.max(ap, 0), math.max(sp, 0)
	end
	OSU.PP_AimVal = math.max(OSU.PP_AimVal + ap, 0)
	OSU.PP_SpeedVal = math.max(OSU.PP_SpeedVal + sp, 0)
	if(_t == 4) then
		OSU.PP_Points = OSU.PP_Points * 0.95
	end
	OSU.PP_LastHitVector = vec_2t
	OSU.PP_LastHitTime = OSU.CurTime
end