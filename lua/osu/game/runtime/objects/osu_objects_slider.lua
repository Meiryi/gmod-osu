--[[
	Gmod osu! - An unofficial port of osu! to Garry's mod.
	None of these codes should be modified or changed without original author's permission, anykind of modification is not allowed.

	You can use it on whatever you like, but you should not claim you're the original author,
	If you're a server owner, do not put this addon behind paywall, or some vip shit

	For translators, if you want to translate this addon, please contact me directly instead of modify the code
	REUPLOAD / REPACK IS NOT ALLOWED

	Copyright (C) 2023 Meika. All rights reserved
]]

function OSU:CreateSlider(vec_2t, followpoint, realfollowpoint, connectpoints, len, _amount, sound, zp, stype, ___index, edgesd, comboidx)
	-- https://osu.ppy.sh/wiki/en/Beatmap/Circle_size
	local radius = ScreenScale(54.4 - 1.5 * OSU.CS)
	local radius2 = radius * 0.9
	local offs = radius / 2
	local offs2 = radius2 / 2
	local dec, fadein, ms = OSU:GetApproachRate(radius)
	local ptime = OSU.CurTime + ms
	local misstime = OSU.CurTime + (OSU:GetMissTime() + ms)
	local ptime = OSU.CurTime + ms
	local area = vgui.Create("DImage", OSU.PlayFieldLayer)
	local dir = false
	local amount = 0
	local CurFollow = 1
	local MaxFollow = #realfollowpoint
	local fMaxFollow = #followpoint
	local __index = 1
	local missed = false
	local timeSet = false
	local _missoffs = OSU:GetMissTime()
	local _prevAngle = math.atan2(
		followpoint[#followpoint].x - followpoint[#followpoint - 1].y,
		followpoint[#followpoint - 1].y - followpoint[#followpoint].x
	)
	local deg = math.deg(_prevAngle)
	local rw, rh = OSU:GetMaterialSize(OSU.CurrentSkin["reversearrow"])
	local alptime = OSU.CurTime + OSU.AppearTime / 2
	local alprate = 255 / (60 * (OSU.AppearTime / 4))
	local alprate2 = alprate * 2
	local _roffset = -64
	local basetime = OSU.CurTime
	local ctime = OSU.CurTime
	local _clr = OSU.CurrentObjectColor
	local clapped = false
	local traced = false
	local traceTime = OSU.CurTime + (ms / 4)
	local target = OSU.Objects[2]
	local sdtmp = edgesd
	if(OSU.ReplayMode) then
		if(OSU.CurrentReplayData.HitData[___index] != nil) then
			_roffset = OSU.CurrentReplayData.HitData[___index]
		end
	end
	if(OSU.NoEdgeSound) then
		edgesd  = sound
	end
	OSU:CreateCircle(vec_2t, sound, zp, true, -OSU.ObjectIndex, comboidx)
	area:SetSize(ScrW(), ScrH())
	area:SetZPos(zp)
	area.IsSlider = true
	area.lastHoldTime = 0
	area.iAlpha = 0
	area.iFollowAlpha = 0
	area.iFollowSize = radius
	area.Finished = false
	area.SizeScale = rh / rw
	area.Removed = false
	if(!OSU.AutoNotes) then
		area.Removed = true
	end
	if(OSU.SnakingSliders) then
		area.MaxDrawIndex = 1
	else
		area.MaxDrawIndex = #followpoint
	end
	local apprTime = OSU:GetApprTime()
	local snakingRate = #followpoint / (10 * apprTime)
	area.Paint = function()
	if(OSU.SnakingSliders) then
		area.MaxDrawIndex = math.Clamp(area.MaxDrawIndex + OSU:GetFixedValue(snakingRate), 1, #followpoint)
	end
	local beat = OSU.SliderBeat * 1.5
	local completeTime = len / (OSU.SliderMultiplier * 100 * OSU.SliderVelocity) * OSU.BeatLength -- ms
	completeTime = (completeTime / 1000)
	ctime = basetime + completeTime
	if(traceTime < OSU.CurTime && !traced) then
		if(target != nil) then
			if(!target["newcombo"]) then
				local time = target["time"]
				local pos = target["vec_2"]
				local ang = math.deg(math.atan2(followpoint[#followpoint].y - pos.y, pos.x - followpoint[#followpoint].x))
				local dst = math.Distance(followpoint[#followpoint].x, followpoint[#followpoint].y, pos.x, pos.y)
				local __end = time + (OSU.AppearTime / 4)
				if(dst > radius * 1.5) then
					OSU:TraceFollowPoint(followpoint[#followpoint], pos, ang, __end - OSU.CurTime, dst, __end)
				end
			end
		end
		traced = true
	end
	local incrate = #realfollowpoint / (60 * completeTime)
		surface.SetMaterial(OSU.SliderBackground)
		if(!OSU.SingleColorSlider) then
			surface.SetDrawColor(Color(255, 255, 255, area.iAlpha))
			for i = 1, area.MaxDrawIndex, 1 do
				local v = followpoint[i]
				surface.DrawTexturedRect(v.x - offs, v.y - offs, radius, radius)
				surface.SetDrawColor(255, 255, 255, area.iAlpha)
			end
			for i = 1, area.MaxDrawIndex, 1 do
				local v = followpoint[i]
				surface.DrawTexturedRect(v.x - offs2, v.y - offs2, radius2, radius2)
				surface.SetDrawColor(math.Clamp((_clr.r * 0.7) + beat, 0, 255), math.Clamp((_clr.g * 0.7) + beat, 0, 255), math.Clamp((_clr.b * 0.7) + beat, 0, 255), area.iAlpha)
			end
		else
			for i = 1, area.MaxDrawIndex, 1 do
				local v = followpoint[i]
				surface.DrawTexturedRect(v.x - offs, v.y - offs, radius, radius)
				surface.SetDrawColor(_clr.r, _clr.g, _clr.b, area.iAlpha)
			end
		end
		surface.SetDrawColor(Color(255, 0, 255, 255))
		if(OSU.DevDisplaySliderConnectPoints) then
			for k,v in next, connectpoints do
				if(k == #connectpoints) then continue end
				local n = connectpoints[k + 1]
				surface.DrawLine(v.x, v.y, n.x, n.y)
			end
			draw.DrawText("Type : "..stype.."  dPoints : "..#followpoint.."x2", "OSUBeatmapTitle", connectpoints[1].x, connectpoints[1].y + ScreenScale(32), Color(255, 0, 255, 255), TEXT_ALIGN_CENTER)
		end
		if(!area.Finished) then
			if(OSU.HD) then
				if(OSU.CurTime > alptime) then
					area.iAlpha = math.Clamp(area.iAlpha - OSU:GetFixedValue(alprate), 0, 255)
				else
					area.iAlpha = math.Clamp(area.iAlpha + OSU:GetFixedValue(alprate2), 0, 255)
				end
			else
				area.iAlpha = math.Clamp(area.iAlpha + OSU:GetFixedValue(alprate2), 0, 255)
			end
		else
			if(OSU.CurTime > alptime) then
				area.iAlpha = math.Clamp(area.iAlpha - OSU:GetFixedValue(alprate), 0, 255)
			end
			if(!area.Removed) then
				OSU:RemoveScreenObject(area)
				area.Removed = true
			end
			area.iAlpha = math.Clamp(area.iAlpha - OSU:GetFixedValue(30), 0, 255)
			if(area.iAlpha <= 0) then
				area:Remove()
			end
			return
		end
		surface.SetDrawColor(Color(100 ,100 ,100 , area.iAlpha))
		if(OSU.CurTime > ptime) then
			if(!timeSet) then
				area.lastHoldTime = OSU.CurTime
				timeSet = true
			end
			if(OSU.AutoNotes) then
				area.lastHoldTime = OSU.CurTime
				OSU.Health = math.Clamp(OSU.Health + OSU:GetFixedValue(0.12 + (OSU.HP * 0.02)), 0, 100)
			end
			if(!clapped && ctime <= OSU.CurTime) then
				if(area.lastHoldTime >= OSU.CurTime) then
					if(OSU.AllowAllSounds) then
						sdtmp[0] = false
						OSU:PlayHitSound_t(sdtmp)
						clapped = true
					else
						if(edgesd[3]) then
							OSU:PlayHitSound(OSU.CurrentSkin[OSU.CurrentHitSound.."-hit"..OSU:HitsoundChooser(3)])
						end
					end
					clapped = true
				end
			end
			local index = math.floor(CurFollow)
			__index = index
			local x, y = realfollowpoint[index].x, realfollowpoint[index].y
			local dis = math.Distance(OSU.CursorPos.x, OSU.CursorPos.y, x, y)
			if(OSU.ReplayMode) then
				dis = math.Distance(OSU.FakeCursorPos.x, OSU.FakeCursorPos.y, x, y)
			end
			local __amo = math.abs(amount - _amount)
			if(!dir) then
				CurFollow = math.Clamp(CurFollow + OSU:GetFixedValue(incrate), 1, MaxFollow)
				if(CurFollow >= MaxFollow) then
					if(OSU.CurTime - area.lastHoldTime < _missoffs) then
						if(__amo > 1) then
							OSU:PlayHitSound_t(sound)
						end
						OSU:AddHealth(1)
					else
						if(OSU.AutoNotes) then
							if(__amo > 1) then
								OSU:PlayHitSound_t(sound)
							end
							OSU:AddHealth(1)
						end
					end
					amount = amount + 1
					dir = true
				end
			else
				CurFollow = math.Clamp(CurFollow - OSU:GetFixedValue(incrate), 1, MaxFollow)
				if(CurFollow <= 1) then
					if(OSU.CurTime - area.lastHoldTime < _missoffs) then
						if(__amo > 1) then
							OSU:PlayHitSound_t(sound)
						end
						OSU:AddHealth(1)
					else
						if(OSU.AutoNotes) then
							if(__amo > 1) then
								OSU:PlayHitSound_t(sound)
							end
							OSU:AddHealth(1)
						end
					end
					amount = amount + 1
					dir = false
				end
			end
			surface.SetMaterial(OSU.HitCircleOverlay)
			surface.SetDrawColor(Color(255, 255 ,255 , area.iAlpha))
			surface.DrawTexturedRect(x - offs, y - offs, radius, radius)
			surface.SetMaterial(OSU.SliderFollow)
			surface.SetDrawColor(Color(255, 255 ,255, area.iFollowAlpha))
			local sx = area.iFollowSize + (OSU.SliderBeat * 1.25)
			surface.DrawTexturedRect(x - sx / 2, y - sx / 2, sx, sx)
			local lMiss = math.abs(area.lastHoldTime - OSU.CurTime)
			if(OSU.KeyDown && dis <= radius) then
				area.lastHoldTime = OSU.CurTime
				OSU.Health = math.Clamp(OSU.Health + OSU:GetFixedValue(0.085 + (OSU.HP * 0.01)), 0, 100)
			end
			if(lMiss > _missoffs) then
				if(!missed) then
					OSU:ComboBreak()
					missed = true
				end
				area.iFollowAlpha = math.Clamp(area.iFollowAlpha - OSU:GetFixedValue(20), 0, 255)
				area.iFollowSize = math.Clamp(area.iFollowSize - OSU:GetFixedValue(5), radius, 1024)
			else
				area.iFollowAlpha = math.Clamp(area.iFollowAlpha + OSU:GetFixedValue(20), 0, 255)
				area.iFollowSize = math.Clamp(area.iFollowSize + OSU:GetFixedValue(5), radius, radius * 1.5)
			end
			if(OSU.AutoNotes) then
				if(OSU.CurrentTarget == area) then
					input.SetCursorPos(x, y)
				else
					if(OSU:GetValidObject() == area && !area.Finished) then
						OSU.CurrentTarget = area
					end
				end
			end
		end
			if(amount >= _amount) then
				if(OSU.AllowAllSounds) then
					edgesd[3] = false
					edgesd[2] = false
					edgesd[1] = false
					edgesd[0] = true
				else
					edgesd[3] = false
					edgesd[0] = true
				end
				area.DoCheckAcc(osu_vec2t(realfollowpoint[__index].x, realfollowpoint[__index].y), OSU.CurTime)
				area.Finished = true
			end
			if(_amount - amount >= 2) then
				local x, y = followpoint[fMaxFollow].x, followpoint[fMaxFollow].y
				local _x, _y = followpoint[1].x, followpoint[1].y
				_prevAngle = math.atan2(
					followpoint[fMaxFollow].y - followpoint[fMaxFollow - 1].y,
					followpoint[fMaxFollow - 1].x - followpoint[fMaxFollow].x
				)
				if(dir) then
					x, y = followpoint[1].x, followpoint[1].y
					_prevAngle = math.atan2(
						followpoint[1].y - followpoint[2].y,
						followpoint[2].x - followpoint[1].x
					)
				end
				deg = math.deg(_prevAngle)
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(OSU.RevArrow)
				local mul = (OSU.SliderBeat / 20) * (radius * 0.5)
				if(area.MaxDrawIndex == #followpoint) then
					surface.DrawTexturedRectRotated(x, y, rw + mul, rh + (mul * area.SizeScale), deg)
				end
			end
	end
	area.DoCheckAcc = function(vec_2t, checkTime)
		if(!OSU.ReplayMode) then
			local rHitoffs = checkTime - area.lastHoldTime
			OSU.ReplayData.HitData[___index] = rHitoffs
		else
			table.insert(OSU.ReplayData.MouseData, {OSU.CurTime - OSU.BeatmapTime, OSU.CursorPos.x, OSU.CursorPos.y})
		end
		local hitoffs = math.abs(checkTime - area.lastHoldTime)
		if(_roffset != -64) then
			hitoffs = _roffset
		end
		if(hitoffs <= OSU:GetMissTime()) then
			local type = OSU:GetHitType(hitoffs)
			OSU:PlayHitSound(OSU.CurrentSkin[OSU.CurrentHitSound.."-hit"..OSU:HitsoundChooser(edgesd)])
			OSU:CreateClickEffect(radius, vec_2t, zp, _clr)
			if(missed && type == 1) then
				OSU:CreateHitScore(vec_2t, 2)
			else
				OSU:CreateHitScore(vec_2t, type)
			end
		else
			OSU:CreateHitScore(vec_2t, 4)
		end
	end
	OSU:InsertObjects(area)
end