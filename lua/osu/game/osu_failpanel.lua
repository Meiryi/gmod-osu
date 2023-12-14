function OSU:SetupFailPanel()
	OSU.ShouldDrawFakeCursor = false
	OSU:PlaySoundEffect(OSU.CurrentSkin["failsound"])
	OSU.Objects = {}
	if(IsValid(OSU.FailPanel)) then
		OSU.FailPanel:Remove()
	end
	local vAlpha = 0
	OSU.FailPanel = OSU:CreateFrame(OSU.MainGameFrame, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 0), false)
	OSU.FailPanel.PlayRate = 1
	OSU.FailPanel.ButtonInited = false
	OSU.FailPanel.Think = function()
	vAlpha = math.Clamp(vAlpha + OSU:GetFixedValue(8), 0, 255)
		if(IsValid(OSU.PlayFieldLayer)) then
			OSU.PlayFieldYOffs = OSU.PlayFieldYOffs + OSU:GetFixedValue(3.25)
			OSU.PlayFieldLayer:SetY(OSU.PlayFieldYOffs)
			OSU.FailPanel.PlayRate = OSU.FailPanel.PlayRate - OSU:GetFixedValue(0.01)
			OSU.SoundChannel:SetPlaybackRate(OSU.FailPanel.PlayRate)
			if(OSU.PlayFieldYOffs >= ScrH() * 0.2) then
				OSU.SoundChannel:Pause()
				OSU.PlayFieldLayer:Remove()
			end
		else
			OSU.FailPanel.iAlpha = math.Clamp(OSU.FailPanel.iAlpha + OSU:GetFixedValue(10), OSU.BackgroundDim, 250)
			if(!OSU.FailPanel.ButtonInited) then
				OSU.FailPanel.InitButtons()
				OSU.FailPanel.ButtonInited = true
			end
		end
	end
	OSU.FailPanel.InitButtons = function()
		local hoveradd = 5
		local rw, rh = OSU:GetMaterialSize(OSU.CurrentSkin["pause-retry"])
		local rscl = rh / rw
		local retry = vgui.Create("DImageButton", OSU.FailPanel)
			retry:SetSize(rw, rh)
			retry:SetPos((ScrW() / 2) - rw / 2, (ScrH() / 2) - rh / 2)
			retry:SetImage(OSU.CurrentSkin["pause-retry"])
			retry.Ext = 0
			retry.Think = function()
				retry:SetColor(Color(255, 255, 255, vAlpha))
				if(retry:IsHovered()) then
					retry.Ext = math.Clamp(retry.Ext + OSU:GetFixedValue(hoveradd), 0, ScreenScale(15))
				else
					retry.Ext = math.Clamp(retry.Ext - OSU:GetFixedValue(hoveradd), 0, ScreenScale(15))
				end
				retry:SetSize(rw + retry.Ext, rh + (retry.Ext * rscl))
				retry:SetPos((ScrW() / 2) - (retry:GetWide() / 2), (ScrH() / 2) - (retry:GetTall() / 2))
			end
			function retry:OnCursorEntered()
				OSU:PlaySoundEffect(OSU.CurrentSkin["pause-hover"])
			end
			retry.DoClick = function()
				OSU.SoundChannel:SetPlaybackRate(1)
				OSU:PlaySoundEffect(OSU.CurrentSkin["pause-retry-click"])
				OSU:StartBeatmap(OSU.TempData["b"], OSU.BeatmapDetails, OSU.TempData["i"])
				OSU.FailPanel:Remove()
			end
		local bg = vgui.Create("DImage", OSU.FailPanel)
		bg:SetSize(ScrW(), ScrH())
		bg:SetImage(OSU.CurrentSkin["fail-background"])
		bg.Think = function()
			bg:SetImageColor(Color(255, 255, 255, vAlpha))
		end
		local ew, eh = OSU:GetMaterialSize(OSU.CurrentSkin["pause-back"])
		local escl = eh / ew
		local exit = vgui.Create("DImageButton", OSU.FailPanel)
			exit:SetSize(rw, rh)
			exit:SetPos((ScrW() / 2) - rw / 2, (ScrH() / 2) - rh / 2)
			exit:SetImage(OSU.CurrentSkin["pause-back"])
			exit.Ext = 0
			exit.Think = function()
				exit:SetColor(Color(255, 255, 255, vAlpha))
				if(exit:IsHovered()) then
					exit.Ext = math.Clamp(exit.Ext + OSU:GetFixedValue(hoveradd), 0, ScreenScale(15))
				else
					exit.Ext = math.Clamp(exit.Ext - OSU:GetFixedValue(hoveradd), 0, ScreenScale(15))
				end
				exit:SetSize(ew + exit.Ext, eh + (exit.Ext * escl))
				exit:SetPos((ScrW() / 2) - (exit:GetWide() / 2), ((ScrH() / 2) + (eh * 1.5)) - (exit:GetTall() / 2))
			end
			function exit:OnCursorEntered()
				OSU:PlaySoundEffect(OSU.CurrentSkin["pause-hover"])
			end
			exit.DoClick = function()
				OSU:PlaySoundEffect(OSU.CurrentSkin["pause-back-click"])
				OSU:ChangeScene(OSU_MENU_STATE_MAIN)
				OSU.FailPanel:Remove()
			end
	end
end