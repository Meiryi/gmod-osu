--[[
	Gmod osu! - An unofficial port of osu! to Garry's mod.
	None of these codes should be modified or changed without original author's permission, anykind of modification is not allowed.

	You can use it on whatever you like, but you should not claim you're the original author,
	If you're a server owner, do not put this addon behind paywall, or some vip shit

	For translators, if you want to translate this addon, please contact me directly instead of modify the code
	REUPLOAD / REPACK IS NOT ALLOWED

	Copyright (C) 2023 Meika. All rights reserved
]]

function OSU:InitFonts()
	surface.CreateFont("OSUName", {
		font = "Aller",
		size = ScreenScale(12),
		antialias = true,
	})
	surface.CreateFont("OSUDetails", {
		font = "Aller",
		size = ScreenScale(6),
		antialias = true,
	})
	surface.CreateFont("OSUMusicTitle", {
		font = "Aller",
		size = ScreenScale(8),
		antialias = true,
	})
	surface.CreateFont("OSUFPS", {
		font = "Aller",
		size = ScreenScale(8),
		antialias = true,
		weight = 1000,
	})
	surface.CreateFont("OSUBeatmapTitle", {
		font = "Aller",
		size = ScreenScale(14),
		antialias = true,
	})
	surface.CreateFont("OSUBeatmapDetails", {
		font = "Aller",
		size = ScreenScale(8),
		antialias = true,
	})
	surface.CreateFont("OSUBeatmapVersion", {
		font = "Aller",
		size = ScreenScale(8),
		antialias = true,
		weight = 1000,
	})
	surface.CreateFont("OSUBeatmapTitle_TOP", {
		font = "Aller Light",
		size = ScreenScale(11),
		antialias = true,
	})
	surface.CreateFont("OSUBeatmapMapper_TOP", {
		font = "Aller Light",
		size = ScreenScale(8),
		antialias = true,
	})
	surface.CreateFont("OSUBeatmapDetails_TOP", {
		font = "Aller",
		size = ScreenScale(8),
		antialias = true,
	})
	surface.CreateFont("OSUBeatmapObjects_TOP", {
		font = "Aller Light",
		size = ScreenScale(8),
		antialias = true,
	})
	surface.CreateFont("OSUBeatmapDifficulty_TOP", {
		font = "Aller Light",
		size = ScreenScale(6),
		antialias = true,
	})
	surface.CreateFont("OSURunTimeSpinnerClear", {
		font = "Aller Light",
		size = ScreenScale(32),
		antialias = true,
	})
	surface.CreateFont("OSUCenteredText", {
		font = "Aller",
		size = ScreenScale(14),
		antialias = true,
	})
	surface.CreateFont("OSUBeatmapResultTitle", {
		font = "Aller",
		size = ScreenScale(18),
		antialias = true,
	})
	surface.CreateFont("OSUBeatmapResultMapper", {
		font = "Aller",
		size = ScreenScale(12),
		antialias = true,
	})
	surface.CreateFont("OSUOptionTitle", {
		font = "Aller Light",
		size = ScreenScale(18),
		antialias = true,
	})
	surface.CreateFont("OSUOptionDesc", {
		font = "Aller",
		size = ScreenScale(10),
		antialias = true,
	})
	surface.CreateFont("OSUOptionSubTitle", {
		font = "Aller",
		size = ScreenScale(9),
		antialias = true,
		weight = 1000,
	})
	surface.CreateFont("OSUOptionSectionTitle", {
		font = "Aller Light",
		size = ScreenScale(18),
		antialias = true,
		weight = 1000,
	})
	surface.CreateFont("OSULeaderboardName", {
		font = "Aller Light",
		size = ScreenScale(12),
		antialias = true,
		weight = 1000,
	})
	surface.CreateFont("OSULeaderboardCombo", {
		font = "Aller Light",
		size = ScreenScale(8),
		antialias = true,
		weight = 1000,
	})
	surface.CreateFont("OSULeaderboardDesc", {
		font = "Aller Light",
		size = ScreenScale(7),
		antialias = true,
		weight = 1000,
	})
	surface.CreateFont("OSULeaderboardRankingTitle", {
		font = "Aller",
		size = ScreenScale(12),
		antialias = true,
	})
	surface.CreateFont("OSULeaderboardRanking", {
		font = "Aller",
		size = ScreenScale(12),
		antialias = true,
	})
	surface.CreateFont("OSULeaderboardRankingName", {
		font = "Aller",
		size = ScreenScale(10),
		antialias = true,
	})
	surface.CreateFont("OSULeaderboardRankingDetails", {
		font = "Aller",
		size = ScreenScale(8),
		antialias = true,
	})
	surface.CreateFont("OSUWebTitle", {
		font = "Aller",
		size = ScreenScale(12),
		antialias = true,
	})
	surface.CreateFont("OSUWebDetails", {
		font = "Aller",
		size = ScreenScale(8),
		antialias = true,
	})
	surface.CreateFont("OSUWebDownload", {
		font = "Aller",
		size = ScreenScale(10),
		antialias = true,
	})
end

function OSU:CreateFrameScroll(parent, w, h, color)
	local dFrame = parent:Add("DFrame")
		dFrame:SetTitle("")
		dFrame:ShowCloseButton(false)
		dFrame:SetDraggable(false)
		dFrame:Dock(TOP)
		dFrame:SetSize(w, h)
		dFrame:DockMargin(0, 0, 0, -ScreenScale(1))
		dFrame.Paint = function()
			draw.RoundedBox(0, 0, 0, dFrame:GetWide(), dFrame:GetTall(), Color(color.r, color.g, color.b, dFrame.iAlpha))
		end
	return dFrame
end

function OSU:CreateFrame(parent, x, y, w, h, color, focus)
	local dFrame = vgui.Create("DFrame", parent)
		dFrame:SetTitle("")
		dFrame:ShowCloseButton(false)
		dFrame:SetDraggable(false)
		dFrame:SetPos(x, y)
		dFrame:SetSize(w, h)
		dFrame.qColor = color
		dFrame.iAlpha = color.a
		if(focus) then
			dFrame:SetKeyBoardInputEnabled(true)
			dFrame:MakePopup()
		end
		dFrame.Paint = function()
			draw.RoundedBox(0, 0, 0, dFrame:GetWide(), dFrame:GetTall(), Color(color.r, color.g, color.b, dFrame.iAlpha))
		end
	return dFrame
end

function OSU:CreateImage(parent, x, y, w, h, image, tile)
	local dImage = vgui.Create("DImage", parent)
		dImage:SetImage(image)
		dImage:SetSize(w, h)
		dImage:SetPos(x, y)
		if(tile) then
			dImage:SetPos(x - (dImage:GetWide() / 2), y - (dImage:GetTall() / 2))
		end
	return dImage
end

function OSU:CreateImageBeat(parent, x, y, w, h, image, tile, offs)
	local dImage = vgui.Create("DImage", parent)
		dImage:SetImage(image)
		dImage:SetSize(w, h)
		dImage:SetPos(x, y)
		if(tile) then
			dImage:SetPos(x - (dImage:GetWide() / 2), y - (dImage:GetTall() / 2))
		end
		dImage.NextBeat = 0
		dImage.oW = w
		dImage.oH = h
		dImage.eSX = 0
		dImage.Beat = false
		dImage.Think = function()
			local beat = 60 / OSU.BPM
			local max, min = math.floor(ScreenScale(16)), math.floor(ScreenScale(10))
			local amo = OSU:GetFixedValue((max - Lerp(beat, min, max)) / 5)
			if(dImage.Beat) then
				dImage.eSX = 0
				dImage.NextBeat = UnPredictedCurTime() + beat
				dImage.Beat = false
			else
				dImage.eSX = math.Clamp(dImage.eSX + amo, 0, ScreenScale(30))
			end
			dImage:SetSize(w + dImage.eSX, h + dImage.eSX)
			if(tile) then
				local off = 0
				if(offs) then
					off = OSU.PlayMenuObjectOffset
				end
				dImage:SetPos(x - (dImage:GetWide() / 2), (y + off) - (dImage:GetTall() / 2))
			end
		end
	return dImage
end

function OSU:CreateLogo(parent, x, y, w, h, image, tile)
	local dImage = vgui.Create("DImageButton", parent)
		dImage:SetImage(image)
		dImage:SetSize(w, h)
		dImage:SetPos(x, y)
		if(tile) then
			dImage:SetPos(x - (dImage:GetWide() / 2), y - (dImage:GetTall() / 2))
		end
		dImage.Clicked = false
		dImage.NextBeat = 0
		dImage.oW = w
		dImage.oH = h
		dImage.oX = x
		dImage.oY = y
		dImage.eSX = 0
		dImage:SetText("")
		dImage.Beat = false
		dImage.Think = function()
			local beat = 60 / OSU.BPM
			local max, min = math.floor(ScreenScale(16)), math.floor(ScreenScale(10))
			local amo = OSU:GetFixedValue((max - Lerp(beat, min, max)) / 5)
			if(dImage.Beat) then
				if(dImage:IsHovered()) then
					OSU:PlaySoundEffect(OSU.CurrentSkin["heartbeat"])
				end
				dImage.eSX = 0
				dImage.NextBeat = UnPredictedCurTime() + beat
				dImage.Beat = false
			else
				dImage.eSX = math.Clamp(dImage.eSX + amo, 0, ScreenScale(30))
			end
			dImage:SetSize(w + dImage.eSX, h + dImage.eSX)
			if(tile) then
				dImage:SetPos(dImage.oX - (dImage:GetWide() / 2), dImage.oY - (dImage:GetTall() / 2))
			end
		end
		dImage.DoClick = function()
			if(dImage.Clicked) then
				OSU.Button_Play.DoClick()
				OSU.Logo.Clicked = true
			end
			OSU.LogoLastClickTime = OSU.CurTime + 8
			dImage.Clicked = !dImage.Clicked
			OSU:PlaySoundEffect(OSU.CurrentSkin["menu-direct-click"])
		end
	return dImage
end

function OSU:CreateScrollPanel(parent, x, y, w, h, color)
	local dscroll = vgui.Create("DScrollPanel", parent)
		dscroll:SetPos(x, y)
		dscroll:SetSize(w, h)
		dscroll.iAlpha = color.a
		dscroll.Paint = function()
			draw.RoundedBox(0, 0, 0, dscroll:GetWide(), dscroll:GetTall(), Color(color.r, color.g, color.b, dscroll.iAlpha))
		end
	return dscroll
end

function OSU:CreateLogoButton(str)
	local btn = vgui.Create("DButton", OSU.ObjectLayer)
		btn:SetSize(OSU.Logo:GetWide(), OSU.Logo:GetTall() * 0.2)
		btn:SetText("")
		btn:SetZPos(OSU.Logo:GetZPos() - 1)
		btn.Paint = function()
			draw.RoundedBox(ScreenScale(8), 0, 0, btn:GetWide(), btn:GetTall(), Color(100, 75, 175, OSU.ObjectLayer.ButtoniAlpha))
		end
			local img = vgui.Create("DImage", btn)
			img:SetImage("osu/internal/"..str..".png")
			img:SetSize(btn:GetWide() * 0.6, btn:GetTall() * 0.6)
			img:SetPos(btn:GetWide() * 0.35, (btn:GetTall() * 0.2))
			img:SetImageColor(Color(255, 255, 255, 0))
			img.Think = function()
				img:SetImageColor(Color(255, 255, 255, OSU.ObjectLayer.ButtoniAlpha))
			end
			function btn:OnCursorEntered()
				OSU:PlaySoundEffect(OSU.CurrentSkin["menuclick"])
			end
		btn:SetVisible(false)
	return btn
end

function OSU:CreateMusicTab()
	local dFrame = vgui.Create("DFrame", OSU.ObjectLayer)
	local sx, sy = OSU:GetTextSize("OSUMusicTitle", OSU.CurrentMusicName)
	local sX, sY = sx, ScreenScale(12)
	local dImage = vgui.Create("DImage", dFrame)
		dImage:SetSize(ScreenScale(24), ScreenScale(12))
		dImage:SetImage("osu/internal/nowplaying.png")
	local dText = vgui.Create("DLabel", dFrame)
		dText:SetFont("OSUMusicTitle")
		dText:SetText(OSU.CurrentMusicName)
		dText:SetSize(sx, sy)
		dText:SetPos(ScreenScale(28), sy / 3)
		dFrame:SetTitle("")
		dFrame:ShowCloseButton(false)
		dFrame:SetDraggable(false)
		dFrame:SetPos(ScrW(), ScreenScale(3))
		dFrame.iAlpha = 0
		dFrame:SetSize(sX + ScreenScale(28), sY)
		dFrame.Paint = function()
			draw.RoundedBox(0, 0, 0, dFrame:GetWide(), dFrame:GetTall(), Color(0, 0, 0, 0))
			dFrame:SetAlpha(255 * OSU.MenuAlphaMul)
		end
		dFrame.TargetX = (ScrW() - ScreenScale(5))
		dFrame.Think = function()
			if(IsValid(OSU.StartupAnim)) then return end
			local fPos = dFrame:GetWide() + dFrame:GetX()
			local dst = math.abs(dFrame.TargetX - fPos)
			if(fPos > dFrame.TargetX) then
				dFrame:SetX(math.Clamp(dFrame:GetX() - OSU:GetFixedValue(dst * 0.1), dFrame.TargetX - dFrame:GetWide(), 32767))
			end
			dFrame.iAlpha = math.Clamp(dFrame.iAlpha + OSU:GetFixedValue(10), 0, 255)
			dText:SetColor(Color(255, 255, 255, dFrame.iAlpha))
			dImage:SetImageColor(Color(255, 255, 255, dFrame.iAlpha))
			if(OSU.NextDetectionTime < OSU.CurTime) then
				if(IsValid(OSU.SoundChannel)) then
					if(math.floor(OSU.SoundChannel:GetTime()) >= math.floor(OSU.CurrentMusicLength)) then
						OSU:PickRandomMusic()
					end
				end
			end
		end
	return dFrame
end

function OSU:CenteredMessage(str, time)
	local oTime = time
	if(time == nil) then
		oTime = 0
		time = 0
	else
		time = OSU.CurTime + time
	end
	OSU.CurrentMessageIndex = OSU.CurrentMessageIndex + 1
	local dFrame = OSU:CreateFrame(OSU.MainGameFrame, 0, 0, ScrW(), ScreenScale(18), Color(0 ,0, 0, 0), false)
		dFrame:SetPos(0, (ScrH() / 2) - dFrame:GetTall() / 2)
		dFrame.KillTime = OSU.CurTime + 1.5 + oTime
		dFrame.iAlpha = 0
		dFrame.iHeight = 0
		dFrame.iYoffs = 0
		dFrame.Index = OSU.CurrentMessageIndex
		dFrame:SetZPos(32767)
		dFrame:SetDrawOnTop(true)
		dFrame:MakePopup()
		dFrame.Think = function()
			if(OSU.CurrentMessageIndex != dFrame.Index) then
				dFrame.iYoffs = dFrame.iYoffs + OSU:GetFixedValue(1.5)
				dFrame:SetY(((ScrH() / 2) - (dFrame:GetTall() / 2)) + dFrame.iYoffs)
			end
			if(dFrame.KillTime > OSU.CurTime && OSU.CurrentMessageIndex == dFrame.Index) then
				dFrame.iAlpha = math.Clamp(dFrame.iAlpha + OSU:GetFixedValue(15), 0, 200)
			else
				if(time < OSU.CurTime) then
					dFrame.iAlpha = math.Clamp(dFrame.iAlpha - OSU:GetFixedValue(15), 0, 200)
				end
				if(dFrame.iAlpha <= 0) then
					dFrame:Remove()
				end
			end
		end
		local gap = ScreenScale(8)
		dFrame.Paint = function()
			dFrame.iHeight = math.Clamp(dFrame.iHeight + OSU:GetFixedValue(7), 0, ScreenScale(18))
			draw.RoundedBox(0 ,0, ScreenScale(9) - (dFrame.iHeight / 2), dFrame:GetWide(), dFrame.iHeight, Color(0, 0, 0, dFrame.iAlpha))
			draw.SimpleTextOutlined(str, "OSUCenteredText", dFrame:GetWide() / 2, gap, Color(255, 255, 255, 55 + dFrame.iAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1.5, Color(0, 0, 0, 55 + dFrame.iAlpha))
		end
end

function OSU:CreateMusicControlPanel()
	local dFrame = vgui.Create("DFrame", OSU.ObjectLayer)
	local btnSize = ScreenScale(10)
	local gapSize = ScreenScale(2)
	local _gapSize = ScreenScale(6)
	local btnspeed = 1
		dFrame:SetTitle("")
		dFrame:ShowCloseButton(false)
		dFrame:SetDraggable(false)
		dFrame:SetSize((btnSize * 5) + (_gapSize * 6), ScreenScale(8) + btnSize)
		dFrame:SetPos((ScrW() - ScreenScale(3)) - dFrame:GetWide(), ScreenScale(17))
		dFrame.iAlpha = 0
		dFrame.Think = function()
			if(IsValid(OSU.StartupAnim)) then return end
			dFrame.iAlpha = math.Clamp(dFrame.iAlpha + OSU:GetFixedValue(8), 0, 255 * OSU.MenuAlphaMul)
		end
		dFrame.Paint = function() end
	local dButton = vgui.Create("DImageButton", dFrame)
		dButton:SetImage("osu/internal/musicprev.png")
		dButton:SetSize(btnSize, btnSize)
		dButton.oPos = Vector(_gapSize, gapSize)
		dButton.ext = 0
		dButton:SetPos(dButton.oPos.x, dButton.oPos.y)
		dButton.Think = function()
			if(dButton:IsHovered()) then
				dButton.ext = math.Clamp(dButton.ext + OSU:GetFixedValue(btnspeed), 0, ScreenScale(2))
			else
				dButton.ext = math.Clamp(dButton.ext - OSU:GetFixedValue(btnspeed), 0, ScreenScale(2))
			end
			dButton:SetSize(btnSize + dButton.ext, btnSize + dButton.ext)
			dButton:SetPos(dButton.oPos.x - (dButton.ext / 2), dButton.oPos.y - (dButton.ext / 2))
			dButton:SetColor(Color(255, 255, 255, dFrame.iAlpha))
		end
		function dButton:OnCursorEntered()
			OSU:PlaySoundEffect(OSU.CurrentSkin["click-short"])
		end
		dButton.DoClick = function()
			OSU:PlaySoundEffect(OSU.CurrentSkin["click-short-confirm"])
			OSU:CenteredMessage("<< Prev")
		end
	local dButton = vgui.Create("DImageButton", dFrame)
		dButton:SetImage("osu/internal/musicplay.png")
		dButton:SetSize(btnSize, btnSize)
		dButton.oPos = Vector((_gapSize * 2) + btnSize, gapSize)
		dButton.ext = 0
		dButton:SetPos(dButton.oPos.x, dButton.oPos.y)
		dButton.Think = function()
			if(dButton:IsHovered()) then
				dButton.ext = math.Clamp(dButton.ext + OSU:GetFixedValue(btnspeed), 0, ScreenScale(2))
			else
				dButton.ext = math.Clamp(dButton.ext - OSU:GetFixedValue(btnspeed), 0, ScreenScale(2))
			end
			dButton:SetSize(btnSize + dButton.ext, btnSize + dButton.ext)
			dButton:SetPos(dButton.oPos.x - (dButton.ext / 2), dButton.oPos.y - (dButton.ext / 2))
			dButton:SetColor(Color(255, 255, 255, dFrame.iAlpha))
		end
		function dButton:OnCursorEntered()
			OSU:PlaySoundEffect(OSU.CurrentSkin["click-short"])
		end
		dButton.DoClick = function()
			OSU:PlaySoundEffect(OSU.CurrentSkin["click-short-confirm"])
			OSU.SoundChannel:Play()
			OSU:CenteredMessage("Play")
			OSU.CurrentBeatCount = math.floor(OSU.SoundChannel:GetTime() / (1 / math.floor(OSU.BPM / 60))) % 4
		end
	local dButton = vgui.Create("DImageButton", dFrame)
		dButton:SetImage("osu/internal/musicpause.png")
		dButton:SetSize(btnSize, btnSize)
		dButton.oPos = Vector((_gapSize * 3) + (btnSize * 2), gapSize)
		dButton.ext = 0
		dButton:SetPos(dButton.oPos.x, dButton.oPos.y)
		dButton.Think = function()
			if(dButton:IsHovered()) then
				dButton.ext = math.Clamp(dButton.ext + OSU:GetFixedValue(btnspeed), 0, ScreenScale(2))
			else
				dButton.ext = math.Clamp(dButton.ext - OSU:GetFixedValue(btnspeed), 0, ScreenScale(2))
			end
			dButton:SetSize(btnSize + dButton.ext, btnSize + dButton.ext)
			dButton:SetPos(dButton.oPos.x - (dButton.ext / 2), dButton.oPos.y - (dButton.ext / 2))
			dButton:SetColor(Color(255, 255, 255, dFrame.iAlpha))
		end
		function dButton:OnCursorEntered()
			OSU:PlaySoundEffect(OSU.CurrentSkin["click-short"])
		end
		dButton.DoClick = function()
			OSU:PlaySoundEffect(OSU.CurrentSkin["click-short-confirm"])
			if(OSU.SoundChannel:GetState() == GMOD_CHANNEL_PLAYING) then
				OSU.SoundChannel:Pause()
				OSU:CenteredMessage("Pause")
			else
				OSU.SoundChannel:Play()
				OSU:CenteredMessage("Unpause")
			end
		end
	local dButton = vgui.Create("DImageButton", dFrame)
		dButton:SetImage("osu/internal/musicstop.png")
		dButton:SetSize(btnSize, btnSize)
		dButton.oPos = Vector((_gapSize * 4) + (btnSize * 3), gapSize)
		dButton.ext = 0
		dButton:SetPos(dButton.oPos.x, dButton.oPos.y)
		dButton.Think = function()
			if(dButton:IsHovered()) then
				dButton.ext = math.Clamp(dButton.ext + OSU:GetFixedValue(btnspeed), 0, ScreenScale(2))
			else
				dButton.ext = math.Clamp(dButton.ext - OSU:GetFixedValue(btnspeed), 0, ScreenScale(2))
			end
			dButton:SetSize(btnSize + dButton.ext, btnSize + dButton.ext)
			dButton:SetPos(dButton.oPos.x - (dButton.ext / 2), dButton.oPos.y - (dButton.ext / 2))
			dButton:SetColor(Color(255, 255, 255, dFrame.iAlpha))
		end
		function dButton:OnCursorEntered()
			OSU:PlaySoundEffect(OSU.CurrentSkin["click-short"])
		end
		dButton.DoClick = function()
			OSU:PlaySoundEffect(OSU.CurrentSkin["click-short-confirm"])
			OSU.SoundChannel:SetTime(0, true)
			OSU.CurrentBeatCount = 0
			OSU.SoundChannel:Pause()
			OSU:CenteredMessage("Stop Playing")
			for k,v in next, OSU.MenuTimingPoints do
				v[3] = false
			end
		end
	local dButton = vgui.Create("DImageButton", dFrame)
		dButton:SetImage("osu/internal/musicnext.png")
		dButton:SetSize(btnSize, btnSize)
		dButton.oPos = Vector((_gapSize * 5) + (btnSize * 4), gapSize)
		dButton.ext = 0
		dButton:SetPos(dButton.oPos.x, dButton.oPos.y)
		dButton.Think = function()
			if(dButton:IsHovered()) then
				dButton.ext = math.Clamp(dButton.ext + OSU:GetFixedValue(btnspeed), 0, ScreenScale(2))
			else
				dButton.ext = math.Clamp(dButton.ext - OSU:GetFixedValue(btnspeed), 0, ScreenScale(2))
			end
			dButton:SetSize(btnSize + dButton.ext, btnSize + dButton.ext)
			dButton:SetPos(dButton.oPos.x - (dButton.ext / 2), dButton.oPos.y - (dButton.ext / 2))
			dButton:SetColor(Color(255, 255, 255, dFrame.iAlpha))
		end
		function dButton:OnCursorEntered()
			OSU:PlaySoundEffect(OSU.CurrentSkin["click-short"])
		end
		dButton.DoClick = function()
			OSU:PlaySoundEffect(OSU.CurrentSkin["click-short-confirm"])
			OSU:PickRandomMusic()
			OSU:CenteredMessage("Next >>")
		end
	local musicTimeLine = vgui.Create("DButton", dFrame)
		musicTimeLine:SetText("")
		musicTimeLine:SetSize(dFrame:GetWide(), ScreenScale(2))
		musicTimeLine:SetPos(0, dFrame:GetTall() - (ScreenScale(2)))
		musicTimeLine.Paint = function()
			if(IsValid(OSU.SoundChannel)) then
				draw.RoundedBox(ScreenScale(4), 0, 0, musicTimeLine:GetWide(), musicTimeLine:GetTall(), Color(80, 80, 80, dFrame.iAlpha * 0.2))
				local len = musicTimeLine:GetWide() * (OSU.SoundChannel:GetTime() / OSU.CurrentMusicLength)
				draw.RoundedBox(ScreenScale(4), 0, 0, len, musicTimeLine:GetTall(), Color(255, 255, 255, dFrame.iAlpha * 0.6))
			end
		end
		function musicTimeLine:OnCursorEntered()
			OSU:PlaySoundEffect(OSU.CurrentSkin["click-short"])
		end
		musicTimeLine.DoClick = function()
			OSU:PlaySoundEffect(OSU.CurrentSkin["click-short-confirm"])
			local mx, my = musicTimeLine:CursorPos()
			local RelativePosToTime = OSU.CurrentMusicLength * (mx / musicTimeLine:GetWide())
			if(IsValid(OSU.SoundChannel)) then
				OSU.SoundChannel:SetTime(RelativePosToTime, true)
				OSU.CurrentBeatCount = math.floor(OSU.SoundChannel:GetTime() / (1 / math.floor(OSU.BPM / 60))) % 4
				for k,v in next, OSU.MenuTimingPoints do
					v[3] = false
				end
				OSU:SetNextBPM(OSU.BPM)
			end
		end
end

function OSU:PickRandomBeatmap()
	if(#OSU.BeatmapPanels <= 0) then return end
	local vPanel = OSU.BeatmapPanels[math.random(1, #OSU.BeatmapPanels)]
	if(!IsValid(vPanel)) then return end
	vPanel.Title:OnMousePressed(107)
end

function OSU:CreateRankingButton()
	local base = vgui.Create("DImageButton", OSU.PlayMenuLayer)
		base:SetSize(ScreenScale(35), OSU.PlayMenuLayer.BottomHeight)
		base:SetPos((ScrW() * 0.25) - ScreenScale(37) * 2, ScrH() - base:GetTall())
		base:SetImage("osu/internal/selection-ranking.png")
		local hover = vgui.Create("DImage", base)
		hover:SetSize(base:GetWide(), base:GetTall())
		hover:SetImage("osu/internal/selection-ranking-over.png")
		hover:SetImageColor(Color(255, 255, 255, 0))
		hover.iAlpha = 0
		function base.OnCursorEntered()
			OSU:PlaySoundEffect(OSU.CurrentSkin["click-short"])
		end
		base.KeyDown = false
		base.Think = function()
			if(base:IsHovered()) then
				hover.iAlpha = math.Clamp(hover.iAlpha + OSU:GetFixedValue(25), 0, 255)
			else
				hover.iAlpha = math.Clamp(hover.iAlpha - OSU:GetFixedValue(25), 0, 255)
			end
			hover:SetImageColor(Color(255, 255, 255, hover.iAlpha))
		end
		base.DoClick = function()
			OSU:PlaySoundEffect(OSU.CurrentSkin["click-short-confirm"])
				local fade = OSU:CreateFrame(nil, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 0), true)
				fade.iAlpha = 0
				fade.Switch = false
				fade.Think = function()
					if(!fade.Switch) then
						fade.iAlpha = math.Clamp(fade.iAlpha + OSU:GetFixedValue(20), 0, 255)
						if(fade.iAlpha >= 255) then
							OSU:SetupRankingPanel(OSU_MENU_STATE_BEATMAP, OSU.PlayMenuLayer)
							fade.Switch = true
						end
				else
					fade.iAlpha = math.Clamp(fade.iAlpha - OSU:GetFixedValue(20), 0, 255)
					if(fade.iAlpha <= 0) then
						fade:Remove()
					end
				end
			end
		end
end

function OSU:CreateModeButton()
	local base = vgui.Create("DImageButton", OSU.PlayMenuLayer)
		base:SetSize(ScreenScale(35), OSU.PlayMenuLayer.BottomHeight)
		base:SetPos((ScrW() * 0.25) - ScreenScale(37), ScrH() - base:GetTall())
		base:SetImage(OSU.CurrentSkin["selection-mods@2x"])
		local hover = vgui.Create("DImage", base)
		hover:SetSize(base:GetWide(), base:GetTall())
		hover:SetImage(OSU.CurrentSkin["selection-mods-over@2x"])
		hover:SetImageColor(Color(255, 255, 255, 0))
		hover.iAlpha = 0
		function base.OnCursorEntered()
			OSU:PlaySoundEffect(OSU.CurrentSkin["click-short"])
		end
		base.KeyDown = false
		base.Think = function()
		if(input.IsKeyDown(92)) then
			if(!base.KeyDown && !OSU.PlayMenuAnimStarted) then
				OSU:SetupModsPanel()
				base.KeyDown = true
			end
		else
			base.KeyDown = false
		end
			if(base:IsHovered()) then
				hover.iAlpha = math.Clamp(hover.iAlpha + OSU:GetFixedValue(25), 0, 255)
			else
				hover.iAlpha = math.Clamp(hover.iAlpha - OSU:GetFixedValue(25), 0, 255)
			end
			hover:SetImageColor(Color(255, 255, 255, hover.iAlpha))
		end
		base.DoClick = function()
			OSU:SetupModsPanel()
			OSU:PlaySoundEffect(OSU.CurrentSkin["click-short-confirm"])
		end
end

function OSU:CreateRandomButton()
	local base = vgui.Create("DImageButton", OSU.PlayMenuLayer)
		base:SetSize(ScreenScale(35), OSU.PlayMenuLayer.BottomHeight)
		base:SetPos(ScrW() * 0.25, ScrH() - base:GetTall())
		base:SetImage(OSU.CurrentSkin["selection-random@2x"])
		local hover = vgui.Create("DImage", base)
		hover:SetSize(base:GetWide(), base:GetTall())
		hover:SetImage(OSU.CurrentSkin["selection-random-over@2x"])
		hover:SetImageColor(Color(255, 255, 255, 0))
		hover.iAlpha = 0
		function base.OnCursorEntered()
			OSU:PlaySoundEffect(OSU.CurrentSkin["click-short"])
		end
		base.KeyDown = false
		base.Think = function()
		if(input.IsKeyDown(93)) then
			if(!base.KeyDown && !OSU.PlayMenuAnimStarted) then
				OSU:PickRandomBeatmap()
				base.KeyDown = true
			end
		else
			base.KeyDown = false
		end
			if(base:IsHovered()) then
				hover.iAlpha = math.Clamp(hover.iAlpha + OSU:GetFixedValue(25), 0, 255)
			else
				hover.iAlpha = math.Clamp(hover.iAlpha - OSU:GetFixedValue(25), 0, 255)
			end
			hover:SetImageColor(Color(255, 255, 255, hover.iAlpha))
		end
		base.DoClick = function()
			OSU:PickRandomBeatmap()
			OSU:PlaySoundEffect(OSU.CurrentSkin["click-short-confirm"])
		end
end

function OSU:CreateBackButton(parent, toState, fBack, func, offs)
	if(IsValid(OSU.BackButton)) then
		OSU.BackButton:Remove()
	end
	if(offs == nil) then offs = 0 end
	OSU.BackButton = vgui.Create("DImageButton", parent)
	OSU.BackButton.iYoffs = offs
	OSU.BackButton:SetSize(ScreenScale(37), ScreenScale(30))
	OSU.BackButton:SetPos(0, ScrH() - (ScreenScale(20) + OSU.BackButton:GetTall() + OSU.BackButton.iYoffs))
	OSU.BackButton.oW = ScreenScale(37)
	OSU.BackButton.oH = ScreenScale(30)
	OSU.BackButton.ext = 0
	OSU.BackButton.iAlpha = 255
	OSU.BackButton.Clicked = false
	OSU.BackButton:SetImage(OSU.CurrentSkin["menu-back"])
	OSU.BackButton.DoClick = function()
		if(OSU.BackButton.Clicked) then return end
		if(IsValid(OSU.PlayFieldLayer)) then
			OSU.PlayFieldLayer:Remove()
		end
		OSU:PlaySoundEffect(OSU.CurrentSkin["menuback"])
		if(!fBack) then
			OSU:ChangeScene(toState)
		else
			OSU:FakeChangeScene(func)
		end
		OSU.BackButton.Clicked = true
		if(IsValid(OSU.PreviewChannel)) then
			OSU.PreviewChannel:Pause()
		end
	end
	OSU.BackButton.Think = function()
		if(OSU.BackButton:IsHovered()) then
			OSU.BackButton.ext = math.Clamp(OSU.BackButton.ext + OSU:GetFixedValue(3), 0, ScreenScale(8))
		else
			OSU.BackButton.ext = math.Clamp(OSU.BackButton.ext - OSU:GetFixedValue(OSU.BackButton.ext * 0.1), 0, ScreenScale(8))
		end
		OSU.BackButton:SetSize(OSU.BackButton.oW + OSU.BackButton.ext, OSU.BackButton.oH + (OSU.BackButton.ext / 1.2))
		OSU.BackButton:SetPos(0, ScrH() - (ScreenScale(20) + (OSU.BackButton:GetTall() / 2) + OSU.BackButton.iYoffs))
		OSU.BackButton:SetColor(Color(255, 255, 255, OSU.BackButton.iAlpha))
		if(OSU.BackButton.Clicked) then
			OSU.BackButton.iAlpha = math.Clamp(OSU.BackButton.iAlpha - OSU:GetFixedValue(40), 0, 255)
			if(OSU.BackButton.iAlpha <= 0) then
				parent:Remove()
				OSU.BackButton:Remove()
			end
		end
	end
	function OSU.BackButton:OnCursorEntered()
		OSU:PlaySoundEffect(OSU.CurrentSkin["click-short"])
	end
end

function OSU:PickMenuBackground()
	if(OSU.CurrentDefBGPath != "") then
		local f, d = file.Find("materials/"..OSU.CurrentDefBGPath.."*", "GAME")
		if(#f <= 0) then
			return OSU.CurrentSkin["menu-background"]
		else
			return "materials/"..OSU.CurrentDefBGPath..f[math.random(1, #f)]
		end
	else
		return OSU.CurrentSkin["menu-background"]
	end
end

function OSU:CreateBackground()
	local img = OSU:PickMenuBackground()
	OSU.Background = vgui.Create("DImage", OSU.MainGameFrame)
	OSU.Background:SetSize(ScrW(), ScrH())
	OSU.Background:SetImage(img)
	OSU.Background:SetImageColor(Color(OSU.MainBGDim, OSU.MainBGDim, OSU.MainBGDim, 255))
	OSU.Background.oPaint = OSU.Background.Paint
	if(OSU.SmoothBG) then
		OSU.Background.Tx = Material(img, "smooth")
	else
		OSU.Background.Tx = Material(img)
	end
	OSU.Background.Paint = function()
		local cv = OSU.MainBGDim
		if(IsValid(OSU.PlayFieldLayer)) then
			cv = OSU.Background:GetImageColor().r
		end
		surface.SetDrawColor(cv, cv, cv, 255)
		surface.SetMaterial(OSU.Background.Tx)
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
	end
end

function OSU:ChangeBackground(img)
	if(!IsValid(OSU.Background)) then return end
	local bg = OSU.CurrentSkin["menu-background"]
	if(file.Exists(img, "GAME") && img != nil) then
		bg = img
	end
	local dummy = vgui.Create("DImage", OSU.Background)
		dummy:SetSize(ScrW(), ScrH())
		dummy:SetImage(OSU.Background:GetImage())
		dummy.iAlpha = 255
		dummy.startTime = OSU.CurTime
		dummy.Think = function()
		local smooth = math.abs(dummy.iAlpha) * 0.08
		dummy.iAlpha = math.Clamp(dummy.iAlpha - math.Clamp(OSU:GetFixedValue(smooth), 1, 255), 0, 255)
		dummy:SetImageColor(Color(255, 255, 255, dummy.iAlpha))
			if(dummy.iAlpha <= 0) then
				dummy:Remove()
			end
		end
	OSU.Background:SetImage(bg)
	if(OSU.SmoothBG) then
		OSU.Background.Tx = Material(img, "smooth")
	else
		OSU.Background.Tx = Material(img)
	end
end

function OSU:SecondsToMin(input)
	local m = math.floor(input / 60)
	local s = math.floor(input - (m * 60))
	if(s < 10) then s = "0"..s end
	return m..":"..s
end

function OSU:FlashEffect(alpha, bright)
	local flash = vgui.Create("DImage", OSU.PlayMenuLayer)
		flash:SetSize(ScrW(), ScrH())
		flash.iAlpha = alpha
		flash.Paint = function()
			flash:SetZPos(32767)
			flash.iAlpha = math.Clamp(flash.iAlpha - OSU:GetFixedValue(1.5), 0, 255)
			draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(bright, bright, bright, flash.iAlpha))
			if(flash.iAlpha <= 0) then
				flash:Remove()
			end
		end
end

function OSU:PrintBeatmapDetails(details)
	if(IsValid(OSU.BeatmapDetailsTab)) then
		OSU.BeatmapDetailsTab:Remove()
	end
	local bpmstr = details["BPM"]
	if(#details["BPMs"] > 1) then
		local lowestbpm = details["BPM"]
		local highestbpm = details["BPM"]
		for k,v in next, details["BPMs"] do
			if(v < lowestbpm) then
				lowestbpm = v
			end
			if(v > highestbpm) then
				highestbpm = v
			end
		end
		if(lowestbpm != highestbpm) then
			bpmstr = math.Round(lowestbpm, 2).." - "..math.Round(highestbpm, 2)
		end
	end
	OSU:SetNextBPM(details["BPM"])
	OSU:FlashEffect(30, 100)
	OSU.BeatmapDetailsTab = OSU.PlayMenuLayer:Add("DImage")
	OSU.BeatmapDetailsTab.Paint = function() return end
	OSU.BeatmapDetailsTab:SetSize(ScrW(), ScreenScale(65))
	--[[
		["BPM"] = 60,
		["Objects"] = -1,
		["Circles"] = -1,
		["Sliders"] = -1,
		["Spinners"] = -1,
		["CS"] = -1,
		["AR"] = -1,
		["OD"] = -1,
		["HP"] = -1,
		["Stars"] = -1,
	]]
	local _left = ScreenScale(15)
	local gap, spacing = ScreenScale(3), ScreenScale(1)
	local _sx = ScreenScale(12)
	local mode = vgui.Create("DImage", OSU.BeatmapDetailsTab)
		mode:SetImage("osu/internal/standard.png")
		mode:SetPos(gap + spacing, (gap * 2) + spacing)
		mode:SetSize(_sx, _sx)
	local _tit, _map, _det, _obj, _dif = ScreenScale(11), ScreenScale(8), ScreenScale(8), ScreenScale(8), ScreenScale(6)
	local a, b, c, d, e = 20, 20 ,15, 10, 10
	local _a, _b, _c = false, false, false
	local fadein = 80
	local title = vgui.Create("DLabel", OSU.BeatmapDetailsTab)
		title:SetPos(_left + gap, gap)
		title:SetSize(OSU.BeatmapDetailsTab:GetWide(), _tit)
		title:SetColor(Color(255, 255, 255))
		title:SetFont("OSUBeatmapTitle_TOP")
		title:SetText(details["Title"])
		title.iAlpha = 0
		title.Think = function()
			title:SetColor(Color(255 ,255, 255, title.iAlpha))
			title.iAlpha = math.Clamp(title.iAlpha + OSU:GetFixedValue(a), 0, 255)
		end
	local mapper = vgui.Create("DLabel", OSU.BeatmapDetailsTab)
		mapper:SetPos(_left + gap, spacing + _tit)
		mapper:SetSize(OSU.BeatmapDetailsTab:GetWide(), _tit)
		mapper:SetColor(Color(255, 255, 255))
		mapper:SetFont("OSUBeatmapMapper_TOP")
		mapper:SetText("Mapped by "..details["Mapper"])
		mapper.iAlpha = 0
		mapper.Think = function()
			mapper:SetColor(Color(255 ,255, 255, mapper.iAlpha))
			mapper.iAlpha = math.Clamp(mapper.iAlpha + OSU:GetFixedValue(b), 0, 255)
			if(mapper.iAlpha >= fadein * 2) then
				_a = true
			end
		end
	local detail = vgui.Create("DLabel", OSU.BeatmapDetailsTab)
		detail:SetPos(gap, spacing + _tit + _map)
		detail:SetSize(OSU.BeatmapDetailsTab:GetWide(), _tit)
		detail:SetColor(Color(255, 255, 255))
		detail:SetFont("OSUBeatmapDetails_TOP")
		detail:SetText(OSU:LookupTranslate("#BMLength")..": "..OSU:SecondsToMin(details["Length"]).."  BPM: "..bpmstr.."  "..OSU:LookupTranslate("#BMObjects")..": "..details["Objects"])
		detail.iAlpha = 0
		detail.Think = function()
			detail:SetColor(Color(255 ,255, 255, detail.iAlpha))
			if(_a) then
				detail.iAlpha = math.Clamp(detail.iAlpha + OSU:GetFixedValue(c), 0, 255)
				if(detail.iAlpha >= fadein) then
					_b = true
				end
			end
		end
	local object = vgui.Create("DLabel", OSU.BeatmapDetailsTab)
		object:SetPos(gap, spacing + _tit + _map + _det)
		object:SetSize(OSU.BeatmapDetailsTab:GetWide(), _tit)
		object:SetColor(Color(255, 255, 255))
		object:SetFont("OSUBeatmapObjects_TOP")
		object:SetText(OSU:LookupTranslate("#BMCircles")..": "..details["Circles"].."  "..OSU:LookupTranslate("#BMSliders")..": "..details["Sliders"].."  "..OSU:LookupTranslate("#BMSpinners")..": "..details["Spinners"])
		object.iAlpha = 0
		object.Think = function()
			object:SetColor(Color(255 ,255, 255, object.iAlpha))
			if(_b) then
				object.iAlpha = math.Clamp(object.iAlpha + OSU:GetFixedValue(d), 0, 255)
				if(object.iAlpha >= fadein) then
					_c = true
				end
			end
		end
	local tx = "CS: "
	if(details["mode"] == 3) then
		tx = "Keys: "
	end
	local difficulty = vgui.Create("DLabel", OSU.BeatmapDetailsTab)
		difficulty:SetPos(gap, spacing + _tit + _map + _det + _obj)
		difficulty:SetSize(OSU.BeatmapDetailsTab:GetWide(), _tit)
		difficulty:SetColor(Color(255, 255, 255))
		difficulty:SetFont("OSUBeatmapDifficulty_TOP")
		difficulty:SetText(tx..details["CS"].."  AR: "..details["AR"].."  OD: "..details["OD"].."  HP: "..details["HP"].."  Star Rating: "..math.Round(details["Stars"], 2))
		difficulty.iAlpha = 0
		difficulty.Think = function()
			difficulty:SetColor(Color(255 ,255, 255, difficulty.iAlpha))
			if(_c) then
				difficulty.iAlpha = math.Clamp(difficulty.iAlpha + OSU:GetFixedValue(e), 0, 255)
			end
		end
		function OSU.BeatmapDetailsTab.UpdateRating(details)
			difficulty:SetText("CS: "..details["CS"].."  AR: "..details["AR"].."  OD: "..details["OD"].."  HP: "..details["HP"].."  Star Rating: "..math.Round(details["Stars"], 2))
		end
end

function OSU:CreateImageButton(parent, x, y, w, h, img, cent, func)
	local tx = Material(img, "smooth")
	local img = parent:Add("DImageButton")
		img:SetSize(w, h)
		if(cent) then
			img:SetPos(x - w / 2, y - h / 2)
		else
			img:SetPos(x, y)
		end
		img.Paint = function()
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(tx)
			surface.DrawTexturedRect(0, 0, w, h)
		end
		function img:OnCursorEntered()
			OSU:PlaySoundEffect(OSU.CurrentSkin["click-short"])
		end
		img.DoClick = func
		return img
end

function OSU:CreateModsButton(parent, texture, x, y, w, h, opt, opt_off, func)
	if(!IsValid(parent) || OSU[opt] == nil) then return end
	local _w, _h = w * 1.5, h * 1.5
	local rotate = 0
	local max = ScreenScale(5)
	local ext = 0
	local centX, centY = _w / 2, _h / 2
	local clr = 0
	local nofunc = false
	if(func != nil) then
		nofunc = true
	end
	local base = parent:Add("DPanel")
		base:SetSize(_w, _h)
		base:SetPos(x - _w / 2, y - _h / 2)
		base.Paint = function()
			if(OSU[opt]) then
				rotate = math.Clamp(rotate - OSU:GetFixedValue(4), -12, 0)
				ext = math.Clamp(ext + OSU:GetFixedValue(5), 0, max)
				clr = math.Clamp(clr + OSU:GetFixedValue(10), 230, 255)
			else
				rotate = math.Clamp(rotate + OSU:GetFixedValue(4), -12, 0)
				ext = math.Clamp(ext - OSU:GetFixedValue(5), 0, max)
				clr = math.Clamp(clr - OSU:GetFixedValue(10), 230, 255)
			end
			if(nofunc) then
				clr = 100
			end
			local __w, __h = w + ext, h + ext
			surface.SetDrawColor(clr, clr, clr, 255)
			surface.SetMaterial(texture)
			surface.DrawTexturedRectRotated(centX, centY, __w, __h, rotate)
		end
		if(func == nil) then
			function base:OnMousePressed(keyCode)
				if(keyCode != 107) then return end
				if(OSU[opt]) then
					OSU:PlaySoundEffect(OSU.CurrentSkin["check-off"])
					OSU[opt] = false
				else
					OSU:PlaySoundEffect(OSU.CurrentSkin["check-on"])
					OSU[opt] = true

					for k,v in next, opt_off do
						OSU[v] = false
					end
				end
				OSU:CalcScoreMul()
			end
		else
			base.OnMousePressed = func
		end
end

function OSU:CreateClickableButton(parent, x, y, w, h, cent, text, func, outcolor, innercolor, font, textcolor)
	if(!IsValid(parent)) then return end
	local btn = parent:Add("DButton")
	btn:SetSize(w, h)
	if(cent) then
		btn:SetPos(x - w / 2, y - h / 2)
	else
		btn:SetPos(x, y)
	end
	local gap = ScreenScale(1)
	local gap2x = gap * 2
	local _w, _h = w - gap2x, h - gap2x
	local inclr = OSU.OptBlue
	local ouclr = Color(0, 0, 0, 200)
	if(innercolor != nil) then
		inclr = innercolor
	end
	if(outcolor != nil) then
		ouclr = outcolor
	end
	local ft = "OSUBeatmapTitle"
	if(font != nil) then
		ft = font
	end
	local tclr = Color(100 ,100, 100, 255)
	if(textcolor != nil) then
		tclr = textcolor
	end
	btn:SetFont(ft)
	btn:SetText(text)
	btn:SetTextColor(tclr)
	btn.Paint = function()
		draw.RoundedBox(0, 0, 0, w, h, ouclr)
		draw.RoundedBox(0, gap, gap, _w, _h, inclr)
	end
	btn.DoClick = func
	function btn:OnCursorEntered()
		OSU:PlaySoundEffect(OSU.CurrentSkin["click-short"])
	end
	return btn
end

function OSU:CreateTextEntryPanel(parent, x, y, w, h, cent)
	if(!IsValid(parent)) then return end
	local base = parent:Add("DPanel")
	base:SetSize(w, h)
	if(cent) then
		base:SetPos(x - w / 2, y - h / 2)
	else
		base:SetPos(x, y)
	end
	local btn = base:Add("DTextEntry")
	local gap = ScreenScale(1)
	local gap2x = gap * 2
	btn:SetPos(gap, gap)
	btn:SetSize(w - gap, h - gap)
	btn:SetPaintBackground(false)
	btn:SetFont("OSUBeatmapTitle")
	btn:SetTextColor(Color(255, 255, 255, 255))
	base.Paint = function()
		draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 255))
		draw.RoundedBox(0, gap, gap, w - gap2x, h - gap2x, Color(50, 50, 50, 255))
	end
	function btn:OnKeyCodeTyped(keyCode)
		if(keyCode == 66) then
			OSU:PlaySoundEffect(OSU.CurrentSkin["key-delete"])
		else
			if(keyCode != 64) then
				OSU:PlaySoundEffect(OSU.CurrentSkin["key-press-"..math.random(1, 4)])
			end
		end
	end
	function btn:OnEnter(value)
		OSU:PlaySoundEffect(OSU.CurrentSkin["key-confirm"])
	end
	return btn
end

function OSU:GetNotifyLevelColor(level)
	local l = {
		[0] = Color(255, 255, 255, 255),
		[1] = Color(255, 101, 41, 255),
		[2] = Color(56, 255, 103, 255),
		[3] = Color(255, 33, 33, 255),
		[4] = Color(155, 33, 255, 255),
	}
	local ret = l[level]
	if(ret == nil) then ret = l[0] end
	return ret
end

function OSU:SideNotify(message, level)
	local clr = OSU:GetNotifyLevelColor(level)
	local gap = ScreenScale(1)
	local gap2x = gap * 2
	local gap3x = gap * 3
	local baseY = ScrH() * 0.8
	local height = ScreenScale(16)
	local heightgap = ScreenScale(18)
	local pindex = #OSU.NotifyTable + 1
	local panel = OSU.MainGameFrame:Add("DImage")
		panel.iAlpha = 0
		panel.iKillTime = OSU.CurTime + 5
		panel:SetSize(ScreenScale(76), height)
		panel:SetDrawOnTop(true)
		panel:SetPos(ScrW() + 32, baseY)
		panel.TargetX = ScrW() - (panel:GetWide() + ScreenScale(3))
		panel.Paint = function()
			draw.RoundedBox(0, 0, 0, panel:GetWide(), panel:GetTall(), Color(clr.r, clr.g, clr.b, panel.iAlpha))
			draw.RoundedBox(0, gap, gap, panel:GetWide() - gap2x, panel:GetTall() - gap2x, Color(0, 0, 0, panel.iAlpha))
			draw.DrawText(message, "OSUDetails", gap2x, gap2x, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
		end
		panel.Think = function()
			panel:SetZPos(32767)
			if(panel.iKillTime < OSU.CurTime) then
				panel.iAlpha = math.Clamp(panel.iAlpha - OSU:GetFixedValue(25), 0, 255)
				if(panel.iAlpha <= 0) then
					panel:Remove()
				end
			else
				panel.iAlpha = math.Clamp(panel.iAlpha + OSU:GetFixedValue(25), 0, 255)
			end
		end
		panel.TargetY = (baseY - ((pindex - 1) * heightgap))
	table.insert(OSU.NotifyTable, {panel, pindex, baseX, baseY, heightgap})
end

surface.CreateFont("OSUOverlayTitle", {
	font = "Aller",
	size = ScreenScale(16),
	antialias = true,
})
function OSU:CreateOverlay()
	local w, h = ScreenScale(16), ScrH()
	local maxw = ScrW() * 0.2
	local minw = ScreenScale(16)
	local gap = ScreenScale(2)
	local d_alp = 0
	local o_alp = 0
	local oLay = vgui.Create("DImage")
		oLay:SetPos(0, 0)
		oLay:SetSize(w, h)
		function oLay:MouseHovered()
			local x1, y1, x2, y2 = oLay:GetX(), oLay:GetY(), oLay:GetX() + oLay:GetWide(), oLay:GetY() + oLay:GetTall()
			local x, y = input.GetCursorPos()
			return (x >= x1 && y >= y1 && x <= x2 && y <= y2)
		end
		local sx = ScreenScale(13)
		local pad = ScreenScale(1)
		local osu = vgui.Create("DImage", oLay)
			osu:SetPos((w / 2) - (sx / 2), (h / 2) - (sx / 2))
			osu:SetSize(sx, sx)
			osu:SetImage("osu/internal/logo_outlineRBSM.png")
		local sx2 = ScreenScale(13)
		local minsx = ScreenScale(13)
		local maxsx = maxw * 0.75
		local bg = vgui.Create("DImage", oLay)
			bg:SetPos(0, 0)
			bg:SetSize(ScrW(), ScrH())
			bg:SetImage("osu/internal/shapedbackground.png")
			bg:SetAlpha(0)
		local osu2 = vgui.Create("DImage", oLay)
			osu2:SetPos((w / 2) - (sx / 2), (h / 2) - (sx / 2))
			osu2:SetSize(sx, sx)
			osu2:SetImage("osu/internal/logo_outline.png")
			osu2:SetAlpha(0)
			local height = h * 0.05
			local hovered = false
			local clicked = false
			oLay.Paint = function()
				draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
				draw.RoundedBox(0, w - pad, (h / 2) - height / 2, pad, height, Color(255, 255, 255, d_alp))
				if(oLay:MouseHovered()) then
					w = math.Clamp(w + OSU:GetFixedValue(math.max((maxw - w) * 0.2, 1)), minw, maxw)
					d_alp = math.Clamp(d_alp - OSU:GetFixedValue(20), 0, 255)
					o_alp = math.Clamp(o_alp + OSU:GetFixedValue(20), 0, 255)
					sx2 = math.Clamp(sx2 + OSU:GetFixedValue(math.max((maxsx - sx2) * 0.25, 1)), minsx, maxsx)
					if(input.IsMouseDown(107)) then
						if(!clicked) then
							if(!IsValid(OSU.MainGameFrame)) then
								OSU:Startup()
							end
							clicked = true
						end
					else
						clicked = false
					end
					if(!hovered) then
						OSU:PlaySoundEffect("sound/osu/click-short.wav")
						hovered = true
					end
				else
					w = math.Clamp(w - OSU:GetFixedValue(math.max((w - minw) * 0.2, 1)), minw, maxw)
					d_alp = math.Clamp(d_alp + OSU:GetFixedValue(5), 0, 255)
					o_alp = math.Clamp(o_alp - OSU:GetFixedValue(20), 0, 255)
					sx2 = math.Clamp(sx2 - OSU:GetFixedValue(math.max((sx2) * 0.25, 1)), minsx, maxsx)
					hovered = false
				end
				oLay:SetWide(w)
				osu:SetX(((w / 2) - pad) - (sx / 2))
				osu:SetAlpha(d_alp)
				osu2:SetAlpha(o_alp)
				bg:SetAlpha(o_alp * 0.1)
				osu2:SetSize(sx2, sx2)
				osu2:SetPos((w / 2) - ((sx2 / 2) + pad), (h / 2) - (sx2 / 1.25))
				draw.DrawText(OSU:LookupTranslate("#C2S"), "OSUOverlayTitle", w / 2, (h / 2) + (sx2 * 0.33), Color(255, 255, 255, o_alp), TEXT_ALIGN_CENTER)
			end
		--[[
		local vBase = oLay:Add("DFrame")
			vBase:SetTitle("")
			vBase:SetDraggable(false)
			vBase:ShowCloseButton(false)
			vBase:SetSize(w, h)
			vBase.Hovered = false
			function vBase:MouseHovered()
				local _x, _y = input.GetCursorPos()
				if(_x > x1 && _y > y1 && _x < x2 && _y < y2) then
					if(!vBase.Hovered) then
						OSU:PlaySoundEffect("sound/osu/click-short.wav")
						vBase.Hovered = true
					end
					return true
				else
					if(vBase.Hovered) then
						vBase.Hovered = false
					end
					return false
				end
			end
			vBase.Paint = function()
				if(vBase:MouseHovered()) then
					clr = math.Clamp(clr + OSU:GetFixedValue(20), 0, 100)
					alp = math.Clamp(alp + OSU:GetFixedValue(30), 0, 255)
				else
					clr = math.Clamp(clr - OSU:GetFixedValue(20), 0, 100)
					alp = math.Clamp(alp - OSU:GetFixedValue(30), 0, 255)
				end
				surface.SetDrawColor(255, 255, 255, 128)
				surface.DrawOutlinedRect(0, 0, w, h, vsx)
				draw.RoundedBox(0, vsx, vsx, w - vsx2x, h - vsx2x, Color(0, 0, 0, 100 + clr))
			end
			local sx = ScreenScale(16)
			local pad = ScreenScale(2)
			]]
		return oLay
end

function OSU:GetFixedValue(input)
	local target = 0.01666666666
	local cur = FrameTime()
	return input * (cur / target)
end

surface.CreateFont("OSUOverlayWarning", {
	font = "Aller",
	size = ScreenScale(12),
	antialias = true,
})
local inactive = false
local rotate_deg = 0
local gap = ScreenScale(3)
local samplefps = 15
local sampled = 0
local sampletime = 0
local CTempedFrameTime = 0
local CAlpha = 0
local cursorTrails = {}
local cursorLayer = {}
local lastCursorPos = {x = 0, y = 0}
local flSx = 10240
local min = ScrW() * 7
local snowTable = {}
local snowInterval = 0
local mouseoffs = 0
local elementsgap = ScreenScale(4)
local breathgap = ScreenScale(8)
local dlheight = ScreenScale(15)
local dockpad = ScreenScale(2)
local tgap = ScreenScale(1)
local labelpadding = ScreenScale(10)
local breathingAlpha = 0
local breathingAlphaSwitch = false
local mul = 0.05
local footerh = ScreenScale(16)
hook.Add("DrawOverlay", "OSU_DrawCursor", function()
	local cx, cy = input.GetCursorPos()
	OSU.CursorPos = osu_vec2t(cx, cy)
	OSU.TempFrameTime = FrameTime()

	if(gui.IsGameUIVisible() && game.SinglePlayer()) then
		surface.SetMaterial(OSU.WarningFooter)
		surface.SetDrawColor(255, 255, 255, 100)
		surface.DrawTexturedRect(0, 0, ScrW(), footerh)
		draw.DrawText(OSU:LookupTranslate("#SPWarning3"), "OSUOverlayTitle", ScrW() / 2, 0, Color(255, 255, 255, 205), TEXT_ALIGN_CENTER)
	end

	local inGame = IsValid(OSU.MainGameFrame)
	if(!inGame) then return end
	local ms = math.Round(OSU.TempFrameTime * 1000, 1)
	local fps = math.floor(1 / OSU.TempFrameTime)
	local w, h = ScreenScale(30), ScreenScale(10)
	local r, g, b = 152, 184, 30
	if(ms > 16) then
		local offs = ms - 16
		r = math.Clamp(r + (offs * 18), 152, 255)
		if(r >= 250) then
			g = math.Clamp(g - (offs * 18), 0, 184)
		end
	end
	if(IsValid(OSU.SkipButton)) then
		CAlpha = math.Clamp(CAlpha - OSU:GetFixedValue(15), 0, 255)
	else
		if(OSU.FPSCounterEnabled) then
			CAlpha = math.Clamp(CAlpha + OSU:GetFixedValue(15), 0, 255)
		else
			CAlpha = math.Clamp(CAlpha - OSU:GetFixedValue(15), 0, 255)
		end
	end

	draw.RoundedBox(8, ScrW() - (gap + w), ScrH() - (gap + h), w, h, Color(r, g, b, CAlpha))
	draw.DrawText(ms.."ms", "OSUFPS", ScrW() - (gap + (w / 2)), ScrH() - (gap + h) + ScreenScale(0.5), Color(0, 0, 0, CAlpha), TEXT_ALIGN_CENTER)
	draw.RoundedBox(8, ScrW() - (gap + w), ScrH() - ((gap * 2) + (h * 2)), w, h, Color(r, g, b, CAlpha))
	draw.DrawText(fps.."hz", "OSUFPS", ScrW() - (gap + (w / 2)), ScrH() - ((gap * 2) + (h * 2)) + ScreenScale(0.5), Color(0, 0, 0, CAlpha), TEXT_ALIGN_CENTER)
	surface.SetDrawColor(255 ,255, 255, 255)
	if(rotate_deg >= 360) then
		rotate_deg = 0
	else
		rotate_deg = math.Clamp(rotate_deg + OSU:GetFixedValue(1), 0, 360)
	end
	local cSize = ScreenScale(OSU.CursorSize)
	local tSize = OSU.CursorTrailSize
	local cmSize = cSize / 2
	local x, y = input.GetCursorPos()
	if(OSU.CursorTrail && math.Distance(OSU.CursorPos.x, OSU.CursorPos.y, lastCursorPos.x, lastCursorPos.y) > 0) then
		local minDistance = math.Distance(0, 0, tSize, tSize) / 5
		local dst = math.Distance(OSU.CursorPos.x, OSU.CursorPos.y, lastCursorPos.x, lastCursorPos.y)
		local col = Color(255, 255, 255, 255)
		local col2 = Color(255, 255, 255, 255)
		if(OSU.RGBTrail) then
			local val = (CurTime() * 240) % 360
			col = HSVToColor(val, 1, 1)
			val = val + OSU.RGBRate
			if(val >= 360) then
				val = val - 360
			end
			col2 = HSVToColor(val, 1, 1)
		end
		if(dst >= minDistance && OSU.FillCursorGap) then
			for i = 0, 1, (minDistance / dst) * 0.85 do
				table.insert(cursorTrails, {OSU:BezierCurve(i, {Vector(lastCursorPos.x, lastCursorPos.y, 0), Vector(OSU.CursorPos.x, OSU.CursorPos.y, 0)}), OSU.CurTime + OSU.CursorTrailLife, tSize, col, 255})
				table.insert(cursorLayer, {OSU:BezierCurve(i, {Vector(lastCursorPos.x, lastCursorPos.y, 0), Vector(OSU.CursorPos.x, OSU.CursorPos.y, 0)}), OSU.CurTime + OSU.CursorTrailLife, tSize * 0.6, col2, 255})
			end
		else
			table.insert(cursorTrails, {OSU.CursorPos, OSU.CurTime + OSU.CursorTrailLife, tSize, col, 255})
			table.insert(cursorLayer, {OSU.CursorPos, OSU.CurTime + OSU.CursorTrailLife, tSize * 0.6, col2, 255})
		end
	end
	surface.SetMaterial(OSU.CurTrailMat)
	for k,v in next, cursorTrails do
		if(v[2] <= OSU.CurTime) then
			v[5] = math.Clamp(v[5] - OSU:GetFixedValue(20), 0, 255)
			v[3] = math.Clamp(v[3] - OSU:GetFixedValue(1), 0, 32767)
			if(v[5] <= 10) then
				table.remove(cursorTrails, k)
			end
		end
		surface.SetDrawColor(v[4].r, v[4].g, v[4].b, v[5])
		surface.DrawTexturedRect(v[1].x - (v[3] / 2), v[1].y - (v[3] / 2), v[3], v[3])
	end
	for k,v in next, cursorLayer do
		if(v[2] <= OSU.CurTime) then
			v[5] = math.Clamp(v[5] - OSU:GetFixedValue(20), 0, 255)
			v[3] = math.Clamp(v[3] - OSU:GetFixedValue(2), 0, 32767)
			if(v[5] <= 10) then
				table.remove(cursorLayer, k)
			end
		end
		surface.SetDrawColor(v[4].r, v[4].g, v[4].b, v[5])
		surface.DrawTexturedRect(v[1].x - (v[3] / 2), v[1].y - (v[3] / 2), v[3], v[3])
	end
	if(OSU.ShouldDrawFakeCursor) then
		surface.SetDrawColor(55, 55, 255, 255)
		surface.SetMaterial(OSU.CursorTexture)
		surface.DrawTexturedRectRotated(OSU.FakeCursorPos.x, OSU.FakeCursorPos.y, cSize, cSize, rotate_deg)
		surface.SetMaterial(OSU.CursorMiddleTexture)
		surface.DrawTexturedRect(OSU.FakeCursorPos.x - (cmSize / 2), OSU.FakeCursorPos.y - (cmSize / 2), cmSize, cmSize)
	end
	if(OSU.MENU_STATE != 0) then OSU.MenuAlphaMul = 1 end
	surface.SetDrawColor(255, 255, 255, 255 * OSU.MenuAlphaMul)
	surface.SetMaterial(OSU.CursorTexture)
	surface.DrawTexturedRectRotated(x, y, cSize, cSize, rotate_deg)
	surface.SetMaterial(OSU.CursorMiddleTexture)
	surface.DrawTexturedRect(x - (cmSize / 2), y - (cmSize / 2), cmSize, cmSize)
	local pos = ScreenScale(40)
	local count = table.Count(OSU.AvatarRequests)
	if(count > 0) then
		draw.DrawText("Downloading avatar(s).. ("..count.."remaining)", "OSUBeatmapDetails", ScreenScale(10), pos, Color(255, 255, 255, 200), TEXT_ALIGN_LEFT)
	end
	if(math.Distance(lastCursorPos.x, lastCursorPos.y, OSU.CursorPos.x, OSU.CursorPos.y) > 0.1) then
		OSU.MouseInactiveTime = OSU.CurTime
	end
	if(OSU.MENU_STATE == OSU_MENU_STATE_MAIN && OSU.MenuSnow) then
		if(snowInterval < OSU.CurTime && !IsValid(OSU.StartupAnim)) then
			for i = 1, math.random(1, 2), 1 do
				table.insert(snowTable, {ScreenScale(math.random(4, 8)), math.random(0, ScrW()), 0, math.Rand(1, 12), math.random(50, 255), math.Rand(1, 3), math.Rand(-1.5, 1.5)})
			end
			snowInterval = OSU.CurTime + 0.35
		end
		surface.SetMaterial(OSU.SnowTexture)
		mouseoffs = (OSU.CursorPos.x - lastCursorPos.x) * 0.0025
		-- sx, x, y, rotate, alpha, y++, x++
		for k,v in next, snowTable do
			if(v[2] > (ScrW() + v[1]) || v[2] < -v[1]) then
				table.remove(snowTable, k)
			end
			if(v[3] < ScrH() - v[1]) then
				v[3] = v[3] + OSU:GetFixedValue(v[6])
				v[2] = v[2] + OSU:GetFixedValue(v[7])
				v[4] = v[4] + OSU:GetFixedValue(v[7] * 2)
				if(mouseoffs != 0) then
					v[7] = v[7] + mouseoffs
				end
			else
				v[5] = math.Clamp(v[5] - OSU:GetFixedValue(2), 0, 255)
				if(v[5] <= 1) then
					table.remove(snowTable, k)
				end
			end
			surface.SetDrawColor(255, 255, 255, v[5])
			surface.DrawTexturedRectRotated(v[2], v[3], v[1], v[1], v[4])
		end
	end
	local count = table.Count(OSU.WebDownloadingTable)
	if(count > 0) then
		draw.RoundedBox(0, ScrW() * 0.25, ScrH() - dlheight, ScrW() * 0.5, dlheight, Color(30, 30, 30, 150))
		draw.DrawText(OSU:LookupTranslate("#DLDownloading").." ("..count..")", "OSUBeatmapDetails", ScrW() / 2, ScrH() - (dlheight - dockpad), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		draw.RoundedBox(0, (ScrW() * 0.25) + (labelpadding / 2), ScrH() - elementsgap, (ScrW() * 0.5) - (labelpadding), dockpad, Color(255, 255, 255, breathingAlpha))
		if(breathingAlphaSwitch) then
			breathingAlpha = math.Clamp(breathingAlpha - OSU:GetFixedValue(math.max(breathingAlpha * 0.05, 0.05)), 0, 255)
			if(breathingAlpha <= 30) then
				breathingAlphaSwitch = false
			end
		else
			breathingAlpha = math.Clamp(breathingAlpha + OSU:GetFixedValue(math.max((255 - breathingAlpha) * 0.05, 0.2)), 0, 255)
			if(breathingAlpha >= 255) then
				breathingAlphaSwitch = true
			end
		end
	end
	lastCursorPos = OSU.CursorPos
end)

hook.Add("RenderScene", "OSU_RenderScene", function()
	local inGame = IsValid(OSU.MainGameFrame)
	if(inGame) then
		local vPanel = vgui.GetHoveredPanel()
		if(IsValid(vPanel)) then
			vPanel:SetCursor("blank")
		end
	end
	if(inGame && OSU.WorldRender) then
		return true 
	end
end)

local noticed = false
hook.Add("HUDPaint", "OSU_Notice", function()
	if(!IsValid(LocalPlayer())) then return end
	if(!noticed) then
		LocalPlayer():ChatPrint("[osu!] "..OSU:LookupTranslate("#STNotify"))
		if(game.SinglePlayer()) then
			chat.AddText(Color(255, 100, 100), "[osu!] "..OSU:LookupTranslate("#SPWarning1"))
			chat.AddText(Color(255, 100, 100), "[osu!] "..OSU:LookupTranslate("#SPWarning2"))
		end
		noticed = true
	end
end)