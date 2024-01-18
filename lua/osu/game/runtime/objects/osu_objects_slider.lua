--[[
	Gmod osu! - An unofficial port of osu! to Garry's mod.
	None of these codes should be modified or changed without original author's permission, anykind of modification is not allowed.

	You can use it on whatever you like, but you should not claim you're the original author,
	If you're a server owner, do not put this addon behind paywall, or some vip shit

	For translators, if you want to translate this addon, please contact me directly instead of modify the code
	REUPLOAD / REPACK IS NOT ALLOWED

	Copyright (C) 2023 Meika. All rights reserved
]]

local math_atan2 = math.atan2
local math_deg = math.deg
local math_sin = math.sin
local math_cos = math.cos
local math_Clamp = math.Clamp
local math_mod = math.mod
local math_Distance = math.Distance
local math_floor = math.floor
local math_abs = math.abs
local math_rad = math.rad
local math_max = math.max
local table_remove = table.remove
local table_insert = table.insert
local surface_SetMaterial = surface.SetMaterial
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawPoly = surface.DrawPoly
local surface_DrawTexturedRect = surface.DrawTexturedRect
local surface_DrawTexturedRectRotated = surface.DrawTexturedRectRotated
__BlurTexture = Material("pp/blurscreen")
draw_NoTexture = draw.NoTexture
render_ClearStencil = render.ClearStencil
render_SetStencilEnable = render.SetStencilEnable
render_SetStencilTestMask = render.SetStencilTestMask
render_SetStencilWriteMask = render.SetStencilWriteMask
render_SetStencilReferenceValue = render.SetStencilReferenceValue
render_SetStencilCompareFunction = render.SetStencilCompareFunction
render_SetStencilFailOperation = render.SetStencilFailOperation
render_SetStencilZFailOperation = render.SetStencilZFailOperation
render_SetStencilEnable = render.SetStencilEnable
surface_DrawRect = surface.DrawRect

osu_circle_seg = 16
function OSU:BuildInnerCircle(vec_2t, radius)
	local c = {}
	table_insert(c, {x = vec_2t.x, y = vec_2t.y})
	for i = 0, osu_circle_seg do
		local a = math_rad((i / osu_circle_seg) * -360)
		table_insert(c, {x = vec_2t.x + math_sin(a) * radius, y = vec_2t.y + math_cos(a) * radius})
	end
	local a = math_rad(0)
	table_insert(c, {x = vec_2t.x + math_sin(a) * radius, y = vec_2t.y + math_cos(a) * radius})
	return c
end

function OSU:CreateSlider(vec_2t, followpoint, realfollowpoint, connectpoints, len, _amount, sound, zp, stype, ___index, edgesd, comboidx)
	-- https://osu.ppy.sh/wiki/en/Beatmap/Circle_size
	local radius = OSU.CircleRadius
	local radius2 = radius * 0.915
	local ___offs = radius - radius2
	local holerad = (radius2 / 2) - ___offs
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
	local pressed = false
	local timeSet = false
	local _missoffs = OSU:GetMissTime()
	local _prevAngle = math_atan2(
		followpoint[#followpoint].x - followpoint[#followpoint - 1].y,
		followpoint[#followpoint - 1].y - followpoint[#followpoint].x
	)
	local deg = math_deg(_prevAngle)
	local rw, rh = OSU:GetMaterialSize(OSU.CurrentSkin["reversearrow"])
	local alptime = OSU.CurTime + OSU.AppearTime / 2
	local alprate = 255 / (60 * (OSU.AppearTime / 2))
	local alprate2 = alprate * 2
	local _roffset = -64
	local basetime = OSU.CurTime
	local ctime = OSU.CurTime
	local _clr = OSU.CurrentObjectColor
	local clapped = false
	local traced = false
	local traceTime = OSU.CurTime + (ms / 5)
	local target = OSU.Objects[2]
	local innerCircle = {}
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
	if(!OSU.AutoNotes && !OSU.AP) then
		area.Removed = true
	end
	if(OSU.SnakingSliders) then
		area.MaxDrawIndex = 1
	else
		area.MaxDrawIndex = #followpoint
	end
	local apprTime = OSU:GetApprTime()
	local snakingRate = #followpoint / (22 * apprTime)
	area.Paint = function()
	if(OSU.SnakingSliders) then
		area.MaxDrawIndex = math_Clamp(area.MaxDrawIndex + OSU:GetFixedValue(snakingRate), 1, #followpoint)
	end
	local beat = OSU.SliderBeat * 1.5
	local completeTime = len / (OSU.SliderMultiplier * 100 * OSU.SliderVelocity) * OSU.BeatLength -- ms
	completeTime = (completeTime / 1000)
	if(OSU.HT) then
		completeTime = completeTime / 0.75
	end
	if(OSU.DT) then
		completeTime = completeTime / 1.5
	end
	ctime = basetime + completeTime
	if(_amount > 1) then
		traceTime = OSU.CurTime + completeTime * 0.75
	end
	if(traceTime < OSU.CurTime && !traced) then
		if(target != nil) then
			if(!target["newcombo"]) then
				local time = target["time"]
				local pos = target["vec_2"]
				local idx = #followpoint
				if(math_mod(_amount, 2) == 0) then
					idx = 2
				end
				local ang = math_deg(math_atan2(followpoint[idx].y - pos.y, pos.x - followpoint[idx].x))
				local dst = math_Distance(followpoint[idx].x, followpoint[idx].y, pos.x, pos.y)
				if(dst > radius * 1.5) then
					--from, to, angle, time, dst, _end
					OSU:TraceFollowPoint(followpoint[idx], pos, ang, OSU.CurTime, target["time"] + ms / 1.4, dst, true)
				end
			end
		end
		traced = true
	end
	local incrate = #realfollowpoint / (60 * completeTime)
		--surface_SetDrawColor(math_Clamp((_clr.r) + beat, 0, 255), math_Clamp((_clr.g ) + beat, 0, 255), math_Clamp((_clr.b) + beat, 0, 255), area.iAlpha)
		surface_SetDrawColor(255, 255, 255, area.iAlpha * 0.8)

		render_ClearStencil()
		render_SetStencilEnable(true)
			render_SetStencilTestMask(0xFF)
			render_SetStencilWriteMask(0xFF)
			render_SetStencilReferenceValue(0x01)

			render_SetStencilCompareFunction(STENCIL_NEVER)
			render_SetStencilFailOperation(STENCIL_REPLACE)
			render_SetStencilZFailOperation(STENCIL_REPLACE)
			draw_NoTexture()
			for k,v in next, innerCircle do
				surface_DrawPoly(v)
			end
			render_SetStencilCompareFunction(STENCIL_EQUAL)
			render_SetStencilFailOperation(STENCIL_KEEP)
			render_SetStencilZFailOperation(STENCIL_KEEP)

			surface_SetDrawColor(math_Clamp((_clr.r) + beat, 0, 255), math_Clamp((_clr.g ) + beat, 0, 255), math_Clamp((_clr.b) + beat, 0, 255), area.iAlpha * 0.1)
			surface_DrawRect(0, 0, ScrW(), ScrH())
			
			render_SetStencilCompareFunction(STENCIL_GREATER)
			render_SetStencilFailOperation(STENCIL_KEEP)
			render_SetStencilZFailOperation(STENCIL_KEEP)
			surface_SetDrawColor(255, 255, 255, area.iAlpha * 0.8)
			surface_SetMaterial(OSU.SliderInnerTexture)
			for i = 1, area.MaxDrawIndex, 1 do
				local v = followpoint[i]
				if(v == nil) then continue end
				if(innerCircle[i] == nil) then
					innerCircle[i] = OSU:BuildInnerCircle(Vector(v.x, v.y), holerad)
				end
				surface_DrawTexturedRect(v.x - offs, v.y - offs, radius, radius)
			end
			render_SetStencilEnable(false)

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
					area.iAlpha = math_Clamp(area.iAlpha - OSU:GetFixedValue(math_max((area.iAlpha) * 0.1, 0.5)), 0, 255)
				else
					area.iAlpha = math_Clamp(area.iAlpha + OSU:GetFixedValue(alprate2), 0, 255)
				end
			else
				area.iAlpha = math_Clamp(area.iAlpha + OSU:GetFixedValue(alprate2), 0, 255)
			end
		else
			if(!area.Removed) then
				OSU:RemoveScreenObject(area)
				area.Removed = true
			end
			area.iAlpha = math_Clamp(area.iAlpha - OSU:GetFixedValue(25), 0, 255)
			if(area.iAlpha <= 0) then
				area:Remove()
			end
			return
		end
		surface_SetDrawColor(Color(100 ,100 ,100 , area.iAlpha))
		if(OSU.CurTime > ptime) then
			if(!timeSet) then
				area.lastHoldTime = OSU.CurTime
				timeSet = true
			end
			if(OSU.AutoNotes) then
				area.lastHoldTime = OSU.CurTime
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
			local index = math_floor(CurFollow)
			__index = index
			local x, y = realfollowpoint[index].x, realfollowpoint[index].y
			local dis = math_Distance(OSU.CursorPos.x, OSU.CursorPos.y, x, y)
			if(OSU.ReplayMode) then
				dis = math_Distance(OSU.FakeCursorPos.x, OSU.FakeCursorPos.y, x, y)
			end
			local __amo = math_abs(amount - _amount)
			if(!dir) then
				CurFollow = math_Clamp(CurFollow + OSU:GetFixedValue(incrate), 1, MaxFollow)
				if(CurFollow >= MaxFollow) then
					if(OSU.CurTime - area.lastHoldTime < _missoffs) then
						if(__amo > 1) then
							OSU:PlayHitSound_t(sound)
							OSU:AddCombo()
							OSU:AddHealth(2)
						end
					else
						if(OSU.AutoNotes) then
							if(__amo > 1) then
								OSU:PlayHitSound_t(sound)
								OSU:AddCombo()
								OSU:AddHealth(2)
							end
						end
					end
					amount = amount + 1
					dir = true
				end
			else
				CurFollow = math_Clamp(CurFollow - OSU:GetFixedValue(incrate), 1, MaxFollow)
				if(CurFollow <= 1) then
					if(OSU.CurTime - area.lastHoldTime < _missoffs) then
						if(__amo > 1) then
							OSU:PlayHitSound_t(sound)
						end
						OSU:AddHealth(2)
						OSU:AddCombo()
					else
						if(OSU.AutoNotes) then
							if(__amo > 1) then
								OSU:PlayHitSound_t(sound)
							end
							OSU:AddHealth(2)
							OSU:AddCombo()
						end
					end
					amount = amount + 1
					dir = false
				end
			end
			surface_SetMaterial(OSU.HitCircleOverlay)
			surface_SetDrawColor(Color(255, 255 ,255 , area.iAlpha))
			surface_DrawTexturedRect(x - offs, y - offs, radius, radius)
			surface_SetMaterial(OSU.SliderFollow)
			surface_SetDrawColor(Color(255, 255 ,255, area.iFollowAlpha))
			local sx = area.iFollowSize + (OSU.SliderBeat * 1.15)
			surface_DrawTexturedRect(x - sx / 2, y - sx / 2, sx, sx)
			local lMiss = math_abs(area.lastHoldTime - OSU.CurTime)
			if(OSU.KeyDown && dis <= radius) then
				pressed = true
				area.lastHoldTime = OSU.CurTime
			end
			if(lMiss > _missoffs) then
				if(!missed) then
					OSU:ComboBreak()
					missed = true
				end
				area.iFollowAlpha = math_Clamp(area.iFollowAlpha - OSU:GetFixedValue(20), 0, 255)
				area.iFollowSize = math_Clamp(area.iFollowSize - OSU:GetFixedValue(5), radius, 1024)
			else
				OSU.Health = math_Clamp(OSU.Health + OSU:GetFixedValue(0.05 + (OSU.HP * 0.01)), 0, 100)
				area.iFollowAlpha = math_Clamp(area.iFollowAlpha + OSU:GetFixedValue(20), 0, 255)
				area.iFollowSize = math_Clamp(area.iFollowSize + OSU:GetFixedValue(5), radius, radius * 1.5)
			end
			if(OSU.AutoNotes || OSU.AP) then
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
				if(!OSU.AllowAllSounds) then
					edgesd[3] = false
					edgesd[0] = true
				else
					edgesd[3] = false
					edgesd[2] = false
					edgesd[1] = false
					edgesd[0] = true
				end
				area.DoCheckAcc(osu_vec2t(realfollowpoint[__index].x, realfollowpoint[__index].y), OSU.CurTime)
				area.Finished = true
			end
			if(_amount - amount >= 2) then
				local x, y = followpoint[fMaxFollow].x, followpoint[fMaxFollow].y
				local _x, _y = followpoint[1].x, followpoint[1].y
				_prevAngle = math_atan2(
					followpoint[fMaxFollow].y - followpoint[fMaxFollow - 1].y,
					followpoint[fMaxFollow - 1].x - followpoint[fMaxFollow].x
				)
				if(dir) then
					x, y = followpoint[1].x, followpoint[1].y
					_prevAngle = math_atan2(
						followpoint[1].y - followpoint[2].y,
						followpoint[2].x - followpoint[1].x
					)
				end
				deg = math_deg(_prevAngle)
				surface_SetDrawColor(255, 255, 255, 255)
				surface_SetMaterial(OSU.RevArrow)
				local mul = (OSU.SliderBeat / 20) * (radius * 0.5)
				if(area.MaxDrawIndex == #followpoint) then
					surface_DrawTexturedRectRotated(x, y, rw + mul, rh + (mul * area.SizeScale), deg)
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
		local hitoffs = math_abs(checkTime - area.lastHoldTime)
		if(!pressed && !OSU.AutoNotes) then
			hitoffs = OSU.HITMISSTIME + 0.2
		end
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