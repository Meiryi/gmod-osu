--[[
	Gmod osu! - An unofficial port of osu! to Garry's mod.
	None of these codes should be modified or changed without original author's permission, anykind of modification is not allowed.

	You can use it on whatever you like, but you should not claim you're the original author,
	If you're a server owner, do not put this addon behind paywall, or some vip shit

	For translators, if you want to translate this addon, please contact me directly instead of modify the code
	REUPLOAD / REPACK IS NOT ALLOWED

	Copyright (C) 2023 Meika. All rights reserved
]]

function OSU:AddCombo(noins)
	OSU.Combo = OSU.Combo + 1
	OSU.GlobalMatSize = 1.07
	OSU.GlobalMatShadowSize = OSU.GlobalMatSize * 1.3
	if(noins == nil) then
		OSU:InsertHitDetails(6)
	end
end

function OSU:TraceFollowPoint(from, to, angle, time, etime, dst, notar)
	if(!OSU.CircleFollowPoint) then return end
	local _time = (etime - time) * 0.2
	local fade = 255 * _time
	local step = OSU.FollowPointsGap / dst
	local tmp = {}
	local vec_2t = {x = to.x - from.x, y = to.y - from.y}
	local rad = OSU.CircleRadius / 2
	for i = 0, 1, step do
		local target = Vector(from.x + vec_2t.x * i, from.y + vec_2t.y * i)
		if(math.Distance(target.x, target.y, to.x, to.y) < rad) then
			continue
		end
		if(notar && math.Distance(target.x, target.y, from.x, from.y) < rad) then
			continue
		end
		table.insert(tmp, {
			[1] = time + (_time * i) * 2,
			[2] = fade,
			[3] = target,
			[4] = 0,
			[5] = angle,
			[6] = etime - (_time * (1 - i))
		})
	end
	table.insert(OSU.FollowPointsTable, tmp)
end

function OSU:PlayHitSound_t(t)
	for k,v in next, t do
		--[[
		if(k != 0) then
			continue 
		else
			v = true
		end
		]]
		if(v) then
			OSU:PlayHitSound(OSU.CurrentSkin[OSU.CurrentHitSound.."-hit"..OSU:HitsoundChooser(k)])
		end
	end
end

function OSU:HitError(offs)
	OSU.TotalHitObjects = OSU.TotalHitObjects + 1
	OSU.TotalHitOffs = OSU.TotalHitOffs + offs
	if(!OSU.HitErrorBar) then return end
	local f = (ScreenScale(400) * OSU.HIT50Time) / 2
	if(OSU.TotalHitObjects > 0) then
		OSU.AvgHitOffs = OSU.TotalHitOffs / OSU.TotalHitObjects
		local sc = math.Clamp(OSU.AvgHitOffs / OSU.HIT50Time, -1, 1)
		OSU.ArrowTargetPos = f * sc
	end
	table.insert(OSU.OffsList, {f * math.Clamp(offs / OSU.HIT50Time, -1, 1), 255, OSU.CurTime + 0.35})
end

function OSU:RemoveScreenObject(obj)
	for k,v in next, OSU.ScreenObjects do
		if(!IsValid(v) || v == obj) then
			table.remove(OSU.ScreenObjects, k)
		end
	end
end

function OSU:InsertObjects(obj)
	for k,v in next, OSU.ScreenObjects do
		if(!IsValid(v)) then table.remove(OSU.ScreenObjects, k) end
	end
	table.insert(OSU.ScreenObjects, obj)
end

function OSU:GetValidObject()
	for k,v in next, OSU.ScreenObjects do
		if(IsValid(v)) then
			return v
		end
	end
	return nil
end

function OSU:GetHitType(offs)
	if(offs <= OSU.HIT300Time) then
		return 1
	elseif(offs <= OSU.HIT100Time) then
		return 2
	elseif(offs <= OSU.HIT50Time) then
		return 3
	else
		return 2
	end
end

function OSU:ComboBreak()
	if(OSU.Combo >= 10 && !OSU.NoBreakSound) then
		OSU:PlaySoundEffect(OSU.CurrentSkin["combobreak"])
	end
	OSU.Combo = 0
	OSU:InsertHitDetails(4)
end

function OSU:CalculatePerformancePoints(type, vec_2t)
	type = math.Clamp(type, 1, 4)
	--[[
	if(OSU.PP_LastHitVector == Vector(0, 0, 0)) then 
		OSU.PP_LastHitVector = vec_2t
		OSU.PP_LastHitTime = OSU.CurTime
		return
	end
	local avgGap = OSU.CircleRadius * 4
	local dst = math.Distance(vec_2t.x, vec_2t.y, OSU.PP_LastHitVector.x, OSU.PP_LastHitVector.y)
	if(dst > OSU.CircleRadius * 1.5) then
		dst = dst * 1.35
	end
	local blist = {
		[1] = 1,
		[2] = 0.66,
		[3] = -0.98,
		[4] = -0.92,
	}
	local vScl = OSU.PP_AvgNvS / math.max((OSU.CurTime - OSU.PP_LastHitTime), 0.01)
	local bScl = blist[type]
	local kScl = math.Clamp(1 - (OSU.PerformancePoints / OSU.PP_MaxiPP), 0, 1)
	if(bScl < 0) then bScl = 1 end
	if(vScl == math.huge) then return end
	local basePoints = 5 * (dst / avgGap) * vScl * bScl
	if(blist[type] < 0) then
		OSU.PerformancePoints = math.Round(OSU.PerformancePoints * math.abs(blist[type]), 2)
	else
		OSU.PerformancePoints = math.Round(OSU.PerformancePoints + basePoints * kScl, 2)
	end
	OSU.PP_LastHitVector = vec_2t
	OSU.PP_LastHitTime = OSU.CurTime
	]]
	
end

function OSU:RunHitObjectsCheck(type, slider, vec_2t)
	if(!slider) then
		OSU:CalcPerformance(type, vec_2t)
	end
	if(type != 4) then
		local mul = (10 + math.floor((OSU.Combo + 1) / 40))
		if(type == 1) then
			OSU.Score = math.Clamp(OSU.Score + ((300 + OSU.Combo * mul) * OSU.ScoreMul), 0, 2147000000)
			OSU.TotalAccuracyRecorded = OSU.TotalAccuracyRecorded + 1
			OSU.HealAccuracy = OSU.HealAccuracy + 1
			OSU.HIT300 = OSU.HIT300 + 1
		elseif(type == 2) then
			OSU.Score = math.Clamp(OSU.Score + ((100 + OSU.Combo * mul) * OSU.ScoreMul), 0, 2147000000)
			OSU.TotalAccuracyRecorded = OSU.TotalAccuracyRecorded + 0.2
			OSU.HealAccuracy = OSU.HealAccuracy + 0.33
			OSU.HIT100 = OSU.HIT100 + 1
		elseif(type == 3) then
			OSU.Score = math.Clamp(OSU.Score + ((50 + OSU.Combo * mul) * OSU.ScoreMul), 0, 2147000000)
			OSU.TotalAccuracyRecorded = OSU.TotalAccuracyRecorded + 0.16
			OSU.HealAccuracy = OSU.HealAccuracy + 0.08
			OSU.HealAccuracy = 0
			OSU.HealObjectsHit = 5 + math.floor(OSU.HP / 2)
			OSU.HIT50 = OSU.HIT50 + 1	
			if(OSU.LastInaccuracyTime < OSU.CurTime) then
				OSU.LastInaccuracyTime = OSU.CurTime + (OSU.HP * 0.3) + 3
			end
		end
		OSU.Score = math.Clamp(math.floor(OSU.Score), 0, 2147000000)
		OSU.Combo = OSU.Combo + 1
		OSU.TotalObjectsRecorded = OSU.TotalObjectsRecorded + 1
		OSU.GlobalMatSize = 1.07
		OSU.GlobalMatShadowSize = OSU.GlobalMatSize * 1.3
		if(OSU.Combo > OSU.HighestCombo) then
			OSU.HighestCombo = OSU.Combo
		end
		OSU:AddHealth(type)
		OSU:InsertHitDetails(type)
	else
		if(OSU.LastInaccuracyTime < OSU.CurTime) then
			OSU.LastInaccuracyTime = OSU.CurTime + (12 + OSU.HP)
			OSU.HealObjectsHit = 10 + math.floor(OSU.HP / 2)
		else
			OSU.LastInaccuracyTime = OSU.LastInaccuracyTime + (OSU.HP / 2) + 9
			OSU.HealObjectsHit = OSU.HealObjectsHit + math.floor(OSU.HP * 0.5) + 4
		end
		OSU.HealAccuracy = 1
		OSU.HealRating = 0
		if(OSU.SD) then -- insta death
			OSU.Health = -1
		end
		local drain = ((OSU.HP * 1.25) + 3.5)
		if(OSU.Health <= 45) then
			drain = drain * math.Clamp(OSU.Health / 100, 0.65, 1)
		end
		OSU.Health = math.Clamp(OSU.Health - drain, 0, 100)
		OSU.MISS = OSU.MISS + 1
		OSU:ComboBreak()
		OSU.TotalObjectsRecorded = OSU.TotalObjectsRecorded + 1
	end
	OSU.Accuracy = math.Round(math.Clamp((OSU.TotalAccuracyRecorded / OSU.TotalObjectsRecorded) * 100, 0, 100), 2)
	OSU.HealObjectsHit = OSU.HealObjectsHit + 1
	OSU.HealRating = math.Clamp((OSU.HealAccuracy / OSU.HealObjectsHit), 0, 1)
end

function OSU:GetMaterialSizeMul(str, mul)
	local temp = Material(str)
	local w = temp:GetInt("$realwidth")
	local h = temp:GetInt("$realheight")
	local scl = ScrW() / 1920
	return (w * mul) * scl, (h * mul) * scl
end

function OSU:GetMaterialSize(str)
	local temp = Material(str)
	local w = temp:GetInt("$realwidth")
	local h = temp:GetInt("$realheight")
	local scl = ScrW() / 1920
	return w * scl, h * scl
end

function OSU:PickDefaultMaterial(str)
	local ret = OSU.DefaultMaterialTable[str]
	if(ret == nil) then
		ret = OSU.DefaultMaterialTable["1"]
	end
	local w = ret:GetInt("$realwidth")
	local h = ret:GetInt("$realheight")
	local scl = ScrW() / 1920
	return ret, w * scl, h * scl
end

function OSU:PickMaterial(str)
	local ret = OSU.ScoreMaterialTable[str]
	if(ret == nil) then
		ret = OSU.ScoreMaterialTable["x"]
	end
	local w = ret:GetInt("$realwidth")
	local h = ret:GetInt("$realheight")
	local scl = ScrW() / 1920
	return ret, w * scl, h * scl
end

function OSU:PickMaterialSize(mat)
	local w = mat:GetInt("$realwidth")
	local h = mat:GetInt("$realheight")
	local scl = ScrW() / 1920
	return w * scl, h * scl
end

function OSU:DrawDefaultNumber(str, x, y, size, alp)
	str = tostring(str)
	local len = string.len(str)
	local w, h = 0, 0
	for i = 1, len, 1 do
		local _m, _w, _h = OSU:PickDefaultMaterial(string.sub(str, i, i))
		w = w + _w
		h = _h
	end
	surface.SetDrawColor(255, 255, 255, alp)
	local offs = 0
	for i = 1, len, 1 do
		local m, _w, _h = OSU:PickDefaultMaterial(string.sub(str, i, i))
		surface.SetMaterial(m)
		surface.DrawTexturedRect((x + offs) - (w / 2), y - (_h / 2), _w, _h)
		offs = offs + _w
	end
end

function OSU:DrawStringAsMaterial(str, x, y, size, gap, alpha, rev, score)
	if(!isstring(str)) then
		str = tostring(str)
	end
	local len = string.len(str)
	local startpos = 0
	local globalOffs = 0
	surface.SetDrawColor(255, 255, 255, alpha * OSU.GlobalAlphaMult)
	if(score) then
		if(len < 8) then
			local dummyText = "00000000"
			local offs = 8 - len
			str = string.Left(dummyText, offs)..str
			len = string.len(str)
		end
		globalOffs = OSU.ScoreOffs
		for i = 1, len, 1 do
			local _s = string.sub(str, i, i)
			local _m, _w, _h = OSU:PickMaterial(_s) 
			surface.SetMaterial(_m)
			_w = _w * size
			_h = _h * size
			surface.DrawTexturedRect((x + startpos) - OSU.ScoreOffs, y, _w, _h)
			startpos = startpos + _h + gap
		end
		OSU.ScoreOffs = startpos
	else
		if(rev) then
			for i = 1, len, 1 do
				local _s = string.sub(str, i, i)
				local _m, _w, _h = OSU:PickMaterial(_s) 
				surface.SetMaterial(_m)
				_w = _w * size
				_h = _h * size
				surface.DrawTexturedRect((x + startpos) - (OSU.AccOffs - gap), y - gap, _w, _h)
				startpos = startpos + _w + gap
			end
			OSU.AccOffs = startpos
		else
			for i = 1, len, 1 do
				local _s = string.sub(str, i, i)
				local _m, _w, _h = OSU:PickMaterial(_s) 
				surface.SetMaterial(_m)
				_w = _w * size
				_h = _h * size
				surface.DrawTexturedRect(x + startpos, y - _h, _w, _h)
				startpos = startpos + _w + gap
			end
		end
	end
end

function OSU:AddHealth(type)
	local amount = 15
	if(type == 1) then
		amount = 12
	elseif(type == 2) then
		amount = 4.95
	elseif(type == 3) then
		amount = 2.5
	else
		amount = 2.5
	end
	local offs = OSU.LastInaccuracyTime - OSU.CurTime
	if(offs > 0) then
		if(type == 1) then
			amount = (15 + OSU.HP) -- Make players survival much longer, least don't die instantly
			OSU.LastInaccuracyTime = OSU.LastInaccuracyTime - 0.45
		elseif(type == 2) then
			OSU.LastInaccuracyTime = OSU.LastInaccuracyTime - 0.2
			OSU.HealObjectsHit = OSU.HealObjectsHit + math.floor(OSU.HP * 0.11)
		elseif(type == 3) then
			OSU.LastInaccuracyTime = OSU.LastInaccuracyTime - 0.12
			OSU.HealObjectsHit = OSU.HealObjectsHit + math.floor(OSU.HP * 0.22)
		else
			OSU.LastInaccuracyTime = OSU.LastInaccuracyTime + 0.2
		end
		amount = amount * OSU.HealRating
	end
	OSU.Health = math.Clamp(OSU.Health + (amount - (OSU.HP * 0.1)), 0, 100)
	OSU.KiExt = ScreenScale(10)
end