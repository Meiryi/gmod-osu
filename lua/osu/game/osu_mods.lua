function OSU:CalcScoreMul()
	local mul = 1
	if(OSU.EZ) then
		if(mul < 1) then
			mul = mul / 2
		else
			mul = mul - 0.5
		end
	end
	if(OSU.NF) then
		if(mul < 1) then
			mul = mul / 2
		else
			mul = mul - 0.5
		end
	end
	if(OSU.HT) then
		if(mul < 1) then
			mul = mul / 2
		else
			mul = mul - 0.5
		end
	end
	if(OSU.HR) then
		mul = mul + 0.06
	end
	if(OSU.SD) then
		mul = mul + 0.06
	end
	if(OSU.HD) then
		mul = mul + 0.08
	end
	if(OSU.DT) then
		mul = mul + 0.12
	end
	if(OSU.FL) then
		mul = mul + 0.12
	end
	OSU.ScoreMul = mul
end

function OSU:SetupModsPanel()
	if(IsValid(OSU.ModePanel)) then
		OSU.ModePanel:Remove()
	end

	local textpadding = ScreenScale(20)
	local gap = ScreenScale(2)
	local gap2x = ScreenScale(4)
	OSU.ModePanel = OSU:CreateFrame(OSU.PlayMenuLayer, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 255), true)
	OSU.ModePanel.iAlpha = 0
	OSU.ModePanel.Paint = function()
		OSU.ModePanel.iAlpha = math.Clamp(OSU.ModePanel.iAlpha + OSU:GetFixedValue(30), 0, 250)
		draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, OSU.ModePanel.iAlpha))
		draw.DrawText("Mods provide different ways to enjoy gameplay. Some have an effect on the score you can\nachieve during ranked play. Others are just for fun", "OSUBeatmapTitle", ScrW() / 2, gap2x, Color(220, 220, 220, 255), TEXT_ALIGN_CENTER)
		local clr = Color(255, 255, 255, 255)
		if(OSU.ScoreMul > 1) then
			clr = Color(100, 255, 100, 255)
		end
		if(OSU.ScoreMul < 1) then
			clr = Color(255, 100 ,100, 255)
		end
		draw.DrawText("Score Multiplier: "..OSU.ScoreMul.."X", "OSUBeatmapTitle", ScrW() / 2, ScrH() * 0.15, clr, TEXT_ALIGN_CENTER)
		draw.DrawText("Difficulty Reduction", "OSUBeatmapTitle", textpadding, ScrH() * 0.3, Color(70, 255, 70, 255), TEXT_ALIGN_LEFT)
		draw.DrawText("Difficulty Increase", "OSUBeatmapTitle", textpadding, ScrH() * 0.425, Color(255, 70, 70, 255), TEXT_ALIGN_LEFT)
		draw.DrawText("Special", "OSUBeatmapTitle", textpadding, ScrH() * 0.55, Color(220, 220, 220, 255), TEXT_ALIGN_LEFT)
	end

	local w = ScreenScale(30)
	local h = w
	local nextX = w + ScreenScale(20)
	local _h = h * 0.5
	local decX, decY = ScrW() * 0.33, (ScrH() * 0.3) + _h / 2
	local diffX, diffY = ScrW() * 0.33, (ScrH() * 0.425) + _h / 2
	local speX, speY = ScrW() * 0.33, (ScrH() * 0.55) + _h / 2
	local cX1 = 0
	local cX2 = 0
	local cX3 = 0
	local texture = Material(OSU.CurrentSkin["selection-mod-easy"], "noclamp smooth")
	local parent = OSU.ModePanel
	OSU:CreateModsButton(parent, texture, decX + cX1, decY, w, h, "EZ", {"HR"}, nil)
	cX1 = cX1 + nextX
	local texture = Material(OSU.CurrentSkin["selection-mod-nofail"], "noclamp smooth")
	OSU:CreateModsButton(parent, texture, decX + cX1, decY, w, h, "NF", {"SD"}, nil)
	cX1 = cX1 + nextX
	local texture = Material(OSU.CurrentSkin["selection-mod-halftime"], "noclamp smooth")
	OSU:CreateModsButton(parent, texture, decX + cX1, decY, w, h, "HT", {"DT"}, function()
		OSU:PlaySoundEffect(OSU.CurrentSkin["check-off"])
		OSU:CenteredMessage("This mod is still WIP!")
	end)

	local texture = Material(OSU.CurrentSkin["selection-mod-hardrock"], "noclamp smooth")
	OSU:CreateModsButton(parent, texture, diffX + cX2, diffY, w, h, "HR", {"EZ"}, nil)
	cX2 = cX2 + nextX
	local texture = Material(OSU.CurrentSkin["selection-mod-suddendeath"], "noclamp smooth")
	OSU:CreateModsButton(parent, texture, diffX + cX2, diffY, w, h, "SD", {"NF"}, nil)
	cX2 = cX2 + nextX
	local texture = Material(OSU.CurrentSkin["selection-mod-doubletime"], "noclamp smooth")
	OSU:CreateModsButton(parent, texture, diffX + cX2, diffY, w, h, "DT", {"HT"}, function()
		OSU:PlaySoundEffect(OSU.CurrentSkin["check-off"])
		OSU:CenteredMessage("This mod is still WIP!")
	end)
	cX2 = cX2 + nextX
	local texture = Material(OSU.CurrentSkin["selection-mod-hidden"], "noclamp smooth")
	OSU:CreateModsButton(parent, texture, diffX + cX2, diffY, w, h, "HD", {}, nil)
	cX2 = cX2 + nextX
	local texture = Material(OSU.CurrentSkin["selection-mod-flashlight"], "noclamp smooth")
	OSU:CreateModsButton(parent, texture, diffX + cX2, diffY, w, h, "FL", {}, nil)

	local texture = Material(OSU.CurrentSkin["selection-mod-autoplay"], "noclamp smooth")
	OSU:CreateModsButton(parent, texture, speX + cX3, speY, w, h, "AutoNotes", {}, nil)

	OSU:CreateBackButton(OSU.ModePanel, OSU_MENU_STATE_MAIN, true, function()
		if(IsValid(OSU.PlayMenuLayer)) then
			OSU:CreateBackButton(OSU.PlayMenuLayer, OSU_MENU_STATE_MAIN)
		end
		OSU.ModePanel:Remove()
	end, 0)
end
