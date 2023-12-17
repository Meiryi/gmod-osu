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
	local radius = ScreenScale(54.4 - 1.5 * OSU.CS)
	local offs = radius / 2
	local dec, fadein, ms = OSU:GetApproachRate(radius)
	local base = vgui.Create("DPanel", OSU.PlayFieldLayer)
	base.Paint = function() return end
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
	if(OSU.ReplayMode) then
		if(OSU.CurrentReplayData.HitData[__index] != nil) then
			_roffset = OSU.CurrentReplayData.HitData[__index]
		end
	end
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
			circle.oPaint(circle)
			--[[
			surface.SetDrawColor(_clr.r, _clr.g, _clr.b, circle.iAlpha)
			surface.SetMaterial(OSU.rHitCircleOverlay)
			surface.DrawTexturedRect(0, 0, radius, radius)
			]]
		end
		base.Think = function()
			local clr = 255
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
					base:Remove()
					OSU:ComboBreak()
				else
					base:Remove()
					OSU:CreateHitScore(vec_2t, 4)
				end
			end
			if(OSU.AutoNotes) then
				if(OSU.CurTime >= ptime) then
					base.Click()
				else
					if(OSU:GetValidObject() == base) then
						OSU.CurrentTarget = base
						if(OSU.CurrentTarget == base) then
							local x, y = input.GetCursorPos()
							local scl = math.max((1 - ((ptime - OSU.CurTime) / ms)) * 0.55, 0.1)
							local incX = OSU:GetFixedValue((x - vec_2t.x) * scl)
							local incY = OSU:GetFixedValue((y - vec_2t.y) * scl)
							input.SetCursorPos(x - incX, y - incY)
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
				OSU.Score = OSU.Score + 50
				OSU.Combo = OSU.Combo + 1
				OSU.GlobalMatSize = 1.07
				OSU.GlobalMatShadowSize = OSU.GlobalMatSize * 1.3
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