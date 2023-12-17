--[[
	Gmod osu! - An unofficial port of osu! to Garry's mod.
	None of these codes should be modified or changed without original author's permission, anykind of modification is not allowed.

	You can use it on whatever you like, but you should not claim you're the original author,
	If you're a server owner, do not put this addon behind paywall, or some vip shit

	For translators, if you want to translate this addon, please contact me directly instead of modify the code
	REUPLOAD / REPACK IS NOT ALLOWED

	Copyright (C) 2023 Meika. All rights reserved
]]

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
end

function OSU:RunHitObjectsCheck(type)
	if(type != 4) then
		local mul = (10 + math.floor((OSU.Combo + 1) / 40))
		if(type == 1) then
			OSU.Score = math.Clamp(OSU.Score + ((300 + OSU.Combo * mul) * OSU.ScoreMul), 0, 2147000000)
			OSU.TotalAccuracyRecorded = OSU.TotalAccuracyRecorded + 1
			OSU.HIT300 = OSU.HIT300 + 1
		elseif(type == 2) then
			OSU.Score = math.Clamp(OSU.Score + ((100 + OSU.Combo * mul) * OSU.ScoreMul), 0, 2147000000)
			OSU.TotalAccuracyRecorded = OSU.TotalAccuracyRecorded + 0.33
			OSU.HIT100 = OSU.HIT100 + 1
		elseif(type == 3) then
			OSU.Score = math.Clamp(OSU.Score + ((50 + OSU.Combo * mul) * OSU.ScoreMul), 0, 2147000000)
			OSU.TotalAccuracyRecorded = OSU.TotalAccuracyRecorded + 0.16
			OSU.HIT50 = OSU.HIT50 + 1	
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
	else
		if(OSU.SD) then -- insta death
			OSU.Health = -1
		end
		OSU.Health = math.Clamp(OSU.Health - (OSU.HP + 15), 0, 100)
		OSU.MISS = OSU.MISS + 1
		OSU:ComboBreak()
		OSU.TotalObjectsRecorded = OSU.TotalObjectsRecorded + 1
	end
	OSU.Accuracy = math.Round(math.Clamp((OSU.TotalAccuracyRecorded / OSU.TotalObjectsRecorded) * 100, 0, 100), 2)
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
		amount = 15
	elseif(type == 2) then
		amount = 10
	elseif(type == 3) then
		amount = 5
	else
		amount = 5
	end
	OSU.Health = math.Clamp(OSU.Health + (amount - (OSU.HP * 0.5)), 0, 100)
	OSU.KiExt = ScreenScale(10)
end