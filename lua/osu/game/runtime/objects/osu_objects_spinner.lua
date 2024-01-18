--[[
	Gmod osu! - An unofficial port of osu! to Garry's mod.
	None of these codes should be modified or changed without original author's permission, anykind of modification is not allowed.

	You can use it on whatever you like, but you should not claim you're the original author,
	If you're a server owner, do not put this addon behind paywall, or some vip shit

	For translators, if you want to translate this addon, please contact me directly instead of modify the code
	REUPLOAD / REPACK IS NOT ALLOWED

	Copyright (C) 2023 Meika. All rights reserved
]]

local NaN = 0 / 0
function OSU:CreateSpinner(vec_2t, sound, zp, killtime)
	OSU.RPM = 0
	OSU.LastDegree = 0
	OSU.AllDegree = 0
	OSU.Diff = 0
	OSU.Deg = 0
	OSU.DegAdd = 0
	OSU.LastTime = OSU.CurTime
	local absTime = math.abs(OSU.LastTime - killtime)
	local minScore = (absTime * 0.5) * 360
	local nextScore = 0
	local cleared = false
	local base = vgui.Create("DPanel", OSU.PlayFieldLayer.UpperLayer)
	local scoreMul = 0
	local clearmat = Material(OSU.CurrentSkin["spinner-clear"])
	local spinmat = Material(OSU.CurrentSkin["spinner-spin"])
	local sw, sh = ScreenScale(114), ScreenScale(40)
	local cw, ch = ScreenScale(106), ScreenScale(41)
	local sAlpha = 0
	local FadeTime = OSU.CurTime + 1
		base:SetSize(ScrW(), ScrH())
		base:SetZPos(zp)
		base.iAlpha = 0
		base.Paint = function()
			base.iAlpha = math.Clamp(base.iAlpha + OSU:GetFixedValue(20), 0, 255)
			return
		end
		local size_ = (ScrH() * 0.9) + ScreenScale(10)
		local size = ScrH() * 0.9
		local topmat = Material(OSU.CurrentSkin["spinner-top"])
		local botmat = Material(OSU.CurrentSkin["spinner-bottom"])
		base.SpinnerBottom = vgui.Create("DImage", base)
		base.SpinnerBottom:SetSize(size, size)
		base.SpinnerBottom:SetPos((ScrW() / 2) - size / 2, (ScrH() / 2) - size / 2)
		base.SpinnerBottom.Paint = function()
			surface.SetDrawColor(255, 255, 255, base.iAlpha)
			surface.SetMaterial(botmat)
			surface.DrawTexturedRectRotated(size / 2, size / 2, size, size, OSU.DegAdd / 2)
		end
		base.SpinnerTop = vgui.Create("DImage", base)
		base.SpinnerTop:SetSize(size, size)
		base.SpinnerTop:SetPos((ScrW() / 2) - size / 2, (ScrH() / 2) - size / 2)
		base.SpinnerTop.Paint = function()
			surface.SetDrawColor(255, 255, 255, base.iAlpha)
			surface.SetMaterial(topmat)
			surface.DrawTexturedRectRotated(size / 2, size / 2, size, size, OSU.DegAdd)
		end
		base.Middle = vgui.Create("DImage", base)
		base.Middle:SetSize(size_, size_)
		base.Middle:SetPos((ScrW() / 2) - (size_ / 2), (ScrH() / 2) - (size_ / 2))
		base.Middle:SetImage(OSU.CurrentSkin["spinner-middle"])
		base.Middle.Think = function()
			base.Middle:SetImageColor(Color(255, 255, 255, base.iAlpha))
		end
		base.SpinArea = vgui.Create("DPanel", OSU.PlayFieldLayer)
		base.SpinArea.Paint = function() return end
		base.SpinArea.CenterPoint = {x = ScrW() / 2, y = ScrH() / 2}
		base.SpinArea.Reset = true
		local nextExecute = 0
		base.SpinArea.Think = function()
		if(!IsValid(base)) then return end
		if(nextExecute > OSU.CurTime) then return end
			local moving = true
			local mouseX, mouseY = input.GetCursorPos()
			if(OSU.ReplayMode) then
				mouseX = OSU.FakeCursorPos.x
				mouseY = OSU.FakeCursorPos.y
			end
			local angle = math.atan2(
				base.SpinArea.CenterPoint.y - mouseY,
				mouseX - base.SpinArea.CenterPoint.x
			)
			local deg = math.deg(angle)
			if(deg < 0) then
				deg = 180 + (180 - math.abs(deg))
			end
			local Diff = math.abs(OSU.LastDegree - deg)
			if(Diff >= 359) then
				Diff = 0
			end
			if(math.abs(OSU.LastDegree - deg) < 0.3) then
				moving = false
			end
			OSU.AllDegree = OSU.AllDegree - Diff
			OSU.LastDegree = deg
			local _t = (((OSU.CurTime - OSU.LastTime) / 60) * 480)
			local _add = (OSU.RPM * 0.01)
			if(!moving) then
				OSU.RPM = math.Clamp(OSU.RPM - OSU:GetFixedValue(5), 0, 477)
				_t = 0.1
				_add = 0.1
			else
				OSU.RPM = math.Clamp(math.abs(OSU.AllDegree / _t), 0, 477)
				OSU.Health = math.Clamp(OSU.Health + 0.225, 0, 100)
			end
			if(_add == math.huge) then
				_add = 0
			end
			if(OSU.SO) then
				OSU.RPM = 239
				_add = 2.39
				OSU.Health = math.Clamp(OSU.Health + 0.125, 0, 100)
			end
			if(OSU.AutoNotes) then
				OSU.RPM = 477
				_add = 4.77
				OSU.Health = math.Clamp(OSU.Health + 0.225, 0, 100)
			end
			OSU.DegAdd = OSU.DegAdd + _add * 3
			nextExecute = OSU.CurTime + 0.0166
	end
	base.Think = function()
	if(OSU.DegAdd > minScore) then
		if(!cleared) then
			cleared = true
			OSU:PlayHitSound(OSU.CurrentSkin["spinnerbonus"])
			scoreMul = 1000 * OSU.ScoreMul
			OSU.Score = math.Clamp(OSU.Score + (1000 * OSU.ScoreMul), 0, 2147000000)
			nextScore = OSU.DegAdd + 180
			OSU.ReplayData.Details.ssc = OSU.ReplayData.Details.ssc + (1000 * OSU.ScoreMul)
		else
			if(OSU.DegAdd > nextScore) then
				OSU:PlayHitSound(OSU.CurrentSkin["spinnerbonus"])
				scoreMul = scoreMul + (1000 * OSU.ScoreMul)
				OSU.Score = math.Clamp(OSU.Score + (1000 * OSU.ScoreMul), 0, 2147000000)
				nextScore = OSU.DegAdd + 180
				OSU.ReplayData.Details.ssc = OSU.ReplayData.Details.ssc + (1000 * OSU.ScoreMul)
			end
		end
	end
		if(OSU.CurTime >= killtime) then
			base:Remove()
		end
	end
	local w, h = ScreenScale(94), ScreenScale(19)
	local _h = 0
	base.RPMIndicator = OSU:CreateFrame(base, (base:GetWide() / 2) - w / 2, base:GetTall() - h, w, h, Color(0, 0, 0, 0), false)
	local rpmbg = Material(OSU.CurrentSkin["spinner-rpm"])
	base.RPMIndicator.Paint = function()
		_h = math.Clamp(_h + OSU:GetFixedValue(10), 0, h)
		surface.SetDrawColor(255, 255, 255, base.iAlpha)
		surface.SetMaterial(rpmbg)
		surface.DrawTexturedRect(0, 0, w, _h)
		draw.DrawText(math.floor(OSU.RPM), "OSUBeatmapTitle", w / 2, ScreenScale(3), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	end
	local drawLayer = vgui.Create("DPanel", base)
	local cAlpha = 0
		drawLayer:SetSize(ScrW(), ScrH())
		drawLayer.Paint = function()
			if(FadeTime > OSU.CurTime) then
				sAlpha = math.Clamp(sAlpha + OSU:GetFixedValue(40), 0, 255)
			else
				sAlpha = math.Clamp(sAlpha - OSU:GetFixedValue(20), 0, 255)
			end
			surface.SetDrawColor(255, 255, 255, sAlpha)
			surface.SetMaterial(spinmat)
			surface.DrawTexturedRect((ScrW() / 2) - sw / 2, (ScrH() * 0.8) - sh / 2, sw, sh)

			if(cleared) then
				cAlpha = math.Clamp(cAlpha + OSU:GetFixedValue(30), 0, 255)
				surface.SetDrawColor(255, 255, 255, cAlpha)
				surface.SetMaterial(clearmat)
				surface.DrawTexturedRect((ScrW() / 2) - sw / 2, (ScrH() * 0.3) - sh / 2, sw, sh)
				if(scoreMul >= 0) then
					draw.DrawText(scoreMul, "OSURunTimeSpinnerClear", ScrW() / 2, ScrH() * 0.7, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
				end
			end
		end
end