--[[
	Gmod osu! - An unofficial port of osu! to Garry's mod.
	None of these codes should be modified or changed without original author's permission, anykind of modification is not allowed.

	You can use it on whatever you like, but you should not claim you're the original author,
	If you're a server owner, do not put this addon behind paywall, or some vip shit

	For translators, if you want to translate this addon, please contact me directly instead of modify the code
	REUPLOAD / REPACK IS NOT ALLOWED

	Copyright (C) 2023 Meika. All rights reserved
]]

function OSU:CreateCircle(vec_2t, sound, zp, noscore, __index, comboidx)
	-- https://osu.ppy.sh/wiki/en/Beatmap/Circle_size
	local radius = OSU.CircleRadius
	local offs = radius / 2
	local dec, fadein, ms = OSU:GetApproachRate(radius)
	local base = vgui.Create("DPanel", OSU.PlayFieldLayer)
	base.Paint = function()return end
	local hcircle = vgui.Create("DImage", base)
		hcircle:SetImage(OSU.CurrentSkin["hitcircle"])
		hcircle:SetSize(radius, radius)
		hcircle:SetZPos(-1)
	local circle = vgui.Create("DImage", base)
	local ptime = OSU.CurTime + ms
	local misstime = OSU.CurTime + (OSU:GetMissTime() + ms)
	local alptime = OSU.CurTime + OSU.AppearTime / 2
	local alprate = 255 / (60 * (OSU.AppearTime / 3))
	local alprate2 = alprate * 2
	local _roffset = -64
	local traced = false
	local traceTime = OSU.CurTime + (ms / 5)
	local target = OSU.Objects[2]
	local aimscl = ScrH() / ScrW()
	if(noscore) then
		target = nil
	end
	if(OSU.ReplayMode) then
		if(OSU.CurrentReplayData.HitData[__index] != nil) then
			_roffset = OSU.CurrentReplayData.HitData[__index]
		end
	end
	local clr = 255
	local _clr = OSU.CurrentObjectColor
	local hittime = ptime + _roffset
		base:SetZPos(zp)
		base:SetSize(radius, radius)
		base:SetPos(vec_2t.x - offs, vec_2t.y - offs)
		base.IsHitObject = true
		base.ptime = ptime
		circle.Appr = OSU:CreateApproachCircle(vec_2t, fadein, dec, radius)
		circle.iAlpha = 0
		circle:SetSize(radius, radius)
		circle:SetImage(OSU.CurrentSkin["hitcircleoverlay"])
		circle.oPaint = circle.Paint
		local tx, ty = circle:GetWide() / 2, circle:GetTall() / 2
		circle.Paint = function()
			OSU:DrawDefaultNumber(comboidx, tx, ty, radius, circle.iAlpha)
			if(!OSU.SmoothHitCircle) then
				circle.oPaint(circle)
			else
				surface.SetDrawColor(clr, clr, clr, circle.iAlpha)
				surface.SetMaterial(OSU.rHitCircleOverlay)
				surface.DrawTexturedRect(0, 0, radius, radius)
			end
		end
		base.Think = function()
			if(traceTime < OSU.CurTime && !traced && !noscore) then
				if(target != nil) then
					if(!target["newcombo"]) then
						local time = target["time"]
						local pos = target["vec_2"]
						local ang = math.deg(math.atan2(vec_2t.y - pos.y, pos.x - vec_2t.x))
						local dst = math.Distance(vec_2t.x, vec_2t.y, pos.x, pos.y)
						if(dst > radius * 1.5) then
							OSU:TraceFollowPoint(vec_2t, pos, ang, OSU.CurTime, target["time"] + ms / 1.4, dst)
						end
					end
				end
				traced = true
			end
			if(OSU.HD) then
				clr = 255
				if(OSU.CurTime > alptime) then
					circle.iAlpha = math.Clamp(circle.iAlpha - OSU:GetFixedValue(alprate), 0, 200)
				else
					circle.iAlpha = math.Clamp(circle.iAlpha + OSU:GetFixedValue(alprate2), 0, 200)
				end
			else
				circle.iAlpha = math.Clamp(circle.iAlpha + OSU:GetFixedValue(alprate), 0, 255)
			end
			circle:SetImageColor(Color(clr, clr, clr, circle.iAlpha))
			hcircle:SetImageColor(Color(_clr.r, _clr.g, _clr.b, circle.iAlpha))
			if(_roffset != -64) then
				if(OSU.CurTime >= hittime) then
					base.Click()
				end
			end
			if(OSU.CurTime >= misstime) then
				if(noscore) then
					if(OSU.LastInaccuracyTime < OSU.CurTime) then
						OSU.LastInaccuracyTime = OSU.CurTime + (12 + OSU.HP)
						OSU.HealObjectsHit = 8 + math.floor(OSU.HP / 2)
					else
						OSU.LastInaccuracyTime = OSU.LastInaccuracyTime + (OSU.HP / 2) + 6
						OSU.HealObjectsHit = OSU.HealObjectsHit + math.floor(OSU.HP * 0.33)
					end
					base:Remove()
					OSU:ComboBreak()
					OSU:CalcPerformance(4, vec_2t)
				else
					base:Remove()
					OSU:CreateHitScore(vec_2t, 4)
				end
			end
			if(OSU.AutoNotes || OSU.AP) then
				if(OSU.CurTime >= ptime) then
					if(!OSU.AP) then
						base.Click()
					end
				else
					if(OSU:GetValidObject() == base) then
						OSU.CurrentTarget = base
						if(OSU.CurrentTarget == base) then
							local x, y = input.GetCursorPos()
							local dstX = x - vec_2t.x
							local dstY = y - vec_2t.y
							local time = ptime - OSU.CurTime
							dstX = dstX / (60 * time)
							dstY = dstY / (60 * time)
							local incX = OSU:GetFixedValue(dstX)
							local incY = OSU:GetFixedValue(dstY)
							local nposX = 0
							local nposY = 0
							if(vec_2t.x > x) then
								nposX = math.Clamp(x - incX, x, vec_2t.x)
							else
								nposX = math.Clamp(x - incX, vec_2t.x, x)
							end
							if(vec_2t.y > y) then
								nposY = math.Clamp(y - incY, y, vec_2t.y)
							else
								nposY = math.Clamp(y - incY, vec_2t.y, y)
							end
							input.SetCursorPos(nposX, nposY)
						end
					end
				end
			end
		end
		base.Click = function()
			if(!OSU.ReplayMode) then
				local rHitoffs = OSU.CurTime - ptime
				OSU.ReplayData.HitData[__index] = rHitoffs
			else
				OSU:RecordFrame({OSU.CurTime - OSU.BeatmapTime, OSU.CursorPos.x, OSU.CursorPos.y})
			end
			local hitoffs = math.abs(OSU.CurTime - ptime)
			if(OSU.AutoNotes) then
				hitoffs = 0
			end
			if(_roffset != -64) then
				hitoffs = _roffset
			end
			OSU:PlayHitSound_t(sound)
			if(noscore) then
				OSU:CreateClickEffect(radius, vec_2t, zp, _clr)
				OSU:AddHealth(OSU:GetHitType(hitoffs))
				OSU.Score = math.Clamp(OSU.Score + 50, 0, 2147000000)
				OSU:AddCombo(true)
				OSU:InsertHitDetails(5)
				OSU:CalcPerformance(OSU:GetHitType(hitoffs), vec_2t)
			else
				if(hitoffs <= OSU:GetMissTime()) then
					OSU:CreateHitScore(vec_2t, OSU:GetHitType(hitoffs))
					OSU:CreateClickEffect(radius, vec_2t, zp, _clr)
				else
					OSU:CreateHitScore(vec_2t, 4)
				end
			end
			if(IsValid(circle.Appr)) then
				circle.Appr:Remove()
			end
			OSU:HitError(OSU.CurTime - ptime)
			base:Remove()
		end
	OSU:InsertObjects(base)
end