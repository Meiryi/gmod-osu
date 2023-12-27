--[[
	Gmod osu! - An unofficial port of osu! to Garry's mod.
	None of these codes should be modified or changed without original author's permission, anykind of modification is not allowed.

	You can use it on whatever you like, but you should not claim you're the original author,
	If you're a server owner, do not put this addon behind paywall, or some vip shit

	For translators, if you want to translate this addon, please contact me directly instead of modify the code
	REUPLOAD / REPACK IS NOT ALLOWED

	Copyright (C) 2023 Meika. All rights reserved
]]

net.Receive("OSU.RunGame", function()
	OSU:Startup()
end)

hook.Add("Osu_Beat", "Osu_RunBeat", function()
	if(IsValid(OSU.Logo)) then
		OSU.Logo.Beat = true
	end
	if(IsValid(OSU.PlayMenuLayer)) then
		if(IsValid(OSU.PlayMenuLayer.Logo)) then
			OSU.PlayMenuLayer.Beat = true 
			OSU.PlayMenuLayer.Logo.Beat = true
		end
	end
	if(!OSU.DisableBeatFlash) then
		OSU.SliderBeat = 20
	end
end)

function OSU:StartupAnimation()
	if(OSU.InterfaceVoice) then
		OSU:PlaySoundEffect(OSU.CurrentSkin["welcome"])
	else
		OSU:PlaySoundEffect("sound/osu/internal/piano.mp3")
	end
	OSU.StartupAnim = OSU:CreateFrame(OSU.MainGameFrame, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 255), false)
	OSU.StartupAnim.iAlpha = 255
	OSU.StartupAnim.Start = 0
	OSU.StartupAnim:MakePopup()
	OSU.StartupAnim.Paint = function()
		draw.RoundedBox(0, 0, 0, OSU.StartupAnim:GetWide(), OSU.StartupAnim:GetTall(), Color(0, 0, 0, OSU.StartupAnim.iAlpha))
		if(UnPredictedCurTime() > OSU.StartupTimer) then
			OSU.StartupAnim.iAlpha = math.Clamp(OSU.StartupAnim.iAlpha - OSU:GetFixedValue(OSU.StartupAnim.iAlpha * 0.07), 0, 255)
			if(OSU.StartupAnim.iAlpha <= 40) then
				OSU.StartupAnim:Close()
			end
		end
	end
	OSU.StartupAnim.Welcome = vgui.Create("DImage", OSU.StartupAnim)
	OSU.StartupAnim.Welcome:SetImage(OSU.CurrentSkin["welcome_text"])
	OSU.StartupAnim.Welcome.ExtW = 0
	OSU.StartupAnim.Welcome.ExtH = 0
	OSU.StartupAnim.Welcome.BaseH = 0
	OSU.StartupAnim.Welcome.MaxH = ScreenScale(24)
	OSU.StartupAnim.Welcome.iAlpha = 0
	OSU.StartupAnim.Welcome.Think = function()
		local extinc = ScreenScale(0.2)
		local basehinc = ScreenScale(1.2)
		if(OSU.StartupAnim.Welcome.BaseH < OSU.StartupAnim.Welcome.MaxH) then
			OSU.StartupAnim.Welcome.BaseH = math.Clamp(OSU.StartupAnim.Welcome.BaseH + OSU:GetFixedValue(basehinc), 0, OSU.StartupAnim.Welcome.MaxH)
		else
			OSU.StartupAnim.Welcome.ExtW = OSU.StartupAnim.Welcome.ExtW + OSU:GetFixedValue(extinc)
			OSU.StartupAnim.Welcome.ExtH = OSU.StartupAnim.Welcome.ExtH + OSU:GetFixedValue(extinc / 4)
		end
		OSU.StartupAnim.Welcome.iAlpha = math.Clamp(OSU.StartupAnim.Welcome.iAlpha + OSU:GetFixedValue(2), 0, 255)
		OSU.StartupAnim.Welcome:SetSize(ScreenScale(125) + OSU.StartupAnim.Welcome.ExtW, OSU.StartupAnim.Welcome.BaseH + OSU.StartupAnim.Welcome.ExtH)
		OSU.StartupAnim.Welcome:SetPos((OSU.StartupAnim:GetWide() / 2) - (OSU.StartupAnim.Welcome:GetWide() / 2), (OSU.StartupAnim:GetTall() / 2) - (OSU.StartupAnim.Welcome:GetTall() / 2))
		OSU.StartupAnim.Welcome:SetImageColor(Color(255, 255, 255, OSU.StartupAnim.Welcome.iAlpha))
		if(UnPredictedCurTime() > OSU.StartupTimer) then
			OSU.StartupAnim.Welcome:Remove()
		end
	end
end

local ppy = Material("osu/internal/ppy.png")
local mat = Material("osu/internal/visualizer.png")
function OSU:Startup()
	if(IsValid(OSU.MainGameFrame)) then return end

	OSU.ClientToken = "nil"
	OSU.MENU_STATE = OSU_MENU_STATE_MAIN
	OSU.StartTime = OSU.CurTime
	OSU.UserName = LocalPlayer():Nick()
	OSU.LoggedIn = false
	if(OSU:GetTokenFile()) then
		OSU:CheckToken()
	end
	OSU.CheckVersion()
	OSU:GetUserConfig()
	OSU:InitFonts()
	OSU:CacheAudios()
	OSU:LoadMusicLengthCache()
	OSU:CheckDefaultSkins()
	OSU:SetupSkins()
	local introTime = 2.5
	local maximumfade = 70
	local fademul = 0.6
	local oldtime = 0
	OSU.BPM = 184
	OSU.BPMTimeGap = 0.75
	OSU.AlphaIncrease = 255 / (60 * (1 / (OSU.BPM / 60)))
	OSU.BeatDivisor = 4
	OSU.CurrentZPos = 32767
	OSU.Objects = {}
	OSU.StartupTimer = UnPredictedCurTime() + introTime
	OSU.MainGameFrame = OSU:CreateFrame(nil, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 255), true)
	OSU.MainGameFrame.Bluring = false
	OSU.MainGameFrame.Direction = false
	OSU.MainGameFrame.iAlpha_L = 0
	OSU.MainGameFrame.iAlpha_R = 0
	OSU.MainGameFrame.iAlpha__L = 0
	OSU.MainGameFrame.iAlpha__R = 0
	OSU.MainGameFrame.BlurTime = SysTime()
	OSU.MainGameFrame.Think = function()
		OSU:ProcessNotify()
		OSU:RunTime()
		OSU.SliderBeat = math.Clamp(OSU.SliderBeat - OSU:GetFixedValue(1.5), 0, 255)
		for k,v in next, OSU.MenuTimingPoints do
			if(v[3]) then continue end
			if(v[1] < OSU.SoundChannel:GetTime()) then
				if(v[2] == 1) then
					OSU.MenuKiaiTime = true
				else
					OSU.MenuKiaiTime = false
				end
				if(v[5]) then
					OSU.BPM = v[4]
				end
				v[3] = true
			end
		end
		if(OSU.NextStatusCheck < OSU.CurTime) then
			OSU:CheckServerStatus()
			OSU:CheckUserStatus()
			OSU.NextStatusCheck = OSU.CurTime + 30
		end
		if(OSU.NextBPM < OSU.CurTime) then
			hook.Run("Osu_Beat")
			OSU:SetNextBPM(OSU.BPM)
			if((SysTime() - oldtime) < (1 / (OSU.BPM / 60)) * 0.8 || !OSU.EdgeFlash) then return end
			OSU.CurrentBeatCount = OSU.CurrentBeatCount + 1
			oldtime = SysTime()
			if(!OSU.MenuKiaiTime) then
				if(OSU.CurrentBeatCount >= 4) then
					OSU.MainGameFrame.iAlpha_L = true
					OSU.MainGameFrame.iAlpha_R = true
					OSU.CurrentBeatCount = 0
				end
			else
				if(!OSU.MainGameFrame.Direction) then
					OSU.MainGameFrame.iAlpha_L = true
					OSU.MainGameFrame.Direction = true
				else
					OSU.MainGameFrame.iAlpha_R = true
					OSU.MainGameFrame.Direction = false
				end
			end
		end
		if(OSU.MainGameFrame.iAlpha_L) then
			OSU.MainGameFrame.iAlpha__L = math.Clamp(OSU.MainGameFrame.iAlpha__L + OSU:GetFixedValue(OSU.AlphaIncrease * fademul), 0, maximumfade)
			if(OSU.MainGameFrame.iAlpha__L >= maximumfade) then
				OSU.MainGameFrame.iAlpha_L = false
			end
		else
			OSU.MainGameFrame.iAlpha__L = math.Clamp(OSU.MainGameFrame.iAlpha__L - OSU:GetFixedValue(OSU.AlphaIncrease * fademul), 0, maximumfade)
		end
		if(OSU.MainGameFrame.iAlpha_R) then
			OSU.MainGameFrame.iAlpha__R = math.Clamp(OSU.MainGameFrame.iAlpha__R + OSU:GetFixedValue(OSU.AlphaIncrease * fademul), 0, maximumfade)
			if(OSU.MainGameFrame.iAlpha__R >= maximumfade) then
				OSU.MainGameFrame.iAlpha_R = false
			end
		else
			OSU.MainGameFrame.iAlpha__R = math.Clamp(OSU.MainGameFrame.iAlpha__R - OSU:GetFixedValue(OSU.AlphaIncrease * fademul), 0, maximumfade)
		end
	end
	OSU:CreateBackground()
	timer.Simple(introTime, function()
		if(OSU.ThemeMusic) then
			OSU:PlayMusic(OSU.CurrentSkin["theme"], "Nekodex - Circles")
		else
			OSU:PickRandomMusic()
		end
		OSU.UserScoreFetching = true
		OSU.ServerStatus = false
		OSU:CheckServerStatus()
	end)
	OSU.ObjectLayer = OSU:CreateFrame(OSU.MainGameFrame, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 0), true)
	local _pos = ScreenScale(3)
	local _xs = ScreenScale(34)
	OSU.UserAvatar = vgui.Create("AvatarImage", OSU.ObjectLayer)
	OSU.UserAvatar:SetPos(_pos, _pos)
	OSU.UserAvatar:SetSize(_xs, _xs)
	OSU.UserAvatar:SetPlayer(LocalPlayer(), 128)
	OSU.UserAvatar.BannedOverlay = OSU.UserAvatar:Add("DImage")
	OSU.UserAvatar.BannedOverlay:SetSize(OSU.UserAvatar:GetWide(), OSU.UserAvatar:GetTall())
	OSU.UserAvatar.BannedOverlay:SetImage("osu/internal/icheated.png")
	OSU.UserAvatar.Think = function()
		OSU.UserAvatar.BannedOverlay:SetVisible(OSU.UserBanned)
		OSU.UserAvatar:SetAlpha(255 * OSU.MenuAlphaMul)
	end
	local w = ScreenScale(18)
	OSU.WebDownloadButton = OSU:CreateImageButton(OSU.ObjectLayer, ScrW() - w / 2, ScrH() / 2, w, ScreenScale(147), "osu/internal/downloads.png", true, function()
		OSU:PlaySoundEffect(OSU.CurrentSkin["menu-freeplay-click"])
		OSU:ChangeScene(16)
	end)
	OSU.WebDownloadButton.hAlpha = 0

	OSU.WebDownloadButton.Overlay = OSU.WebDownloadButton:Add("DImage")
	OSU.WebDownloadButton.Overlay:SetSize(OSU.WebDownloadButton:GetWide(), OSU.WebDownloadButton:GetTall())
	OSU.WebDownloadButton.Overlay:SetImage("osu/internal/downloads-hover.png")
	OSU.WebDownloadButton.Think = function()
		OSU.WebDownloadButton:SetAlpha(255 * OSU.MenuAlphaMul)
		if(OSU.WebDownloadButton:IsHovered()) then
			OSU.WebDownloadButton.hAlpha = math.Clamp(OSU.WebDownloadButton.hAlpha + OSU:GetFixedValue(30), 0, 255)
		else
			OSU.WebDownloadButton.hAlpha = math.Clamp(OSU.WebDownloadButton.hAlpha - OSU:GetFixedValue(30), 0, 255)
		end
		OSU.WebDownloadButton.Overlay:SetAlpha(OSU.WebDownloadButton.hAlpha)
	end
	OSU.WebDownloadButton.OnCursorEntered = function()
		OSU:PlaySoundEffect(OSU.CurrentSkin["click-short"])
	end
	local h = ScreenScale(40)
	local _th = ScreenScale(12)
	local _w = ScreenScale(100)
	local _npos = _pos + _xs + ScreenScale(3)
	local sx, sy = OSU:GetTextSize("OSUName", "Dummy Text")
	local _sx, _sy = OSU:GetTextSize("OSUDetails", "Dummy Text")
	local num = 32
	local nextRotate = 1
	local gap = ScreenScale(4)
	local kSx = ScreenScale(10)
	local lSx = h * 0.5
	local lRotate = 0
	local _h = ScreenScale(13)
	--[[
	local discord = OSU.ObjectLayer:Add("DImageButton")
		discord:SetPos(ScreenScale(4), ScrH() - (h - ScreenScale(2)))
		discord:SetSize(h / 2, h / 2)
		discord:SetImage("osu/internal/discord.png")
		function discord:OnCursorEntered()
			OSU:PlaySoundEffect(OSU.CurrentSkin["click-short"])
		end
		discord.DoClick = function()
			OSU:PlaySoundEffect(OSU.CurrentSkin["click-short-confirm"])
			gui.OpenURL("https://discord.gg/tN8K3TMFaR")
		end
	]]
	local width = ScrW() * 0.08
	local width2x = width * 2
	OSU.ObjectLayer.Paint = function()
	if(OSU.CurTime - OSU.MouseInactiveTime > 1.5) then
		OSU.MenuAlphaMul = math.Clamp(OSU.MenuAlphaMul - OSU:GetFixedValue(0.0015), 0, 1)
	else
		OSU.MenuAlphaMul = math.Clamp(OSU.MenuAlphaMul + OSU:GetFixedValue(0.1), 0, 1)
	end
	local a = 200 * OSU.MenuAlphaMul
	local fa = 255 * OSU.MenuAlphaMul
	local ha = 100 * OSU.MenuAlphaMul
		if(OSU.MENU_STATE == OSU_MENU_STATE_MAIN) then
			surface.SetDrawColor(255, 255, 255, OSU.MainGameFrame.iAlpha__L)
			surface.SetMaterial(OSU.LeftFade)
			surface.DrawTexturedRect(-width, 0, width2x, ScrH())
			surface.SetDrawColor(255, 255, 255, OSU.MainGameFrame.iAlpha__R)
			surface.SetMaterial(OSU.RightFade)
			surface.DrawTexturedRect(ScrW() - width, 0, width2x, ScrH())
			draw.RoundedBox(0, 0, 0, ScrW(), h, Color(0, 0, 0, a))
			draw.RoundedBox(0, 0, ScrH() - h, ScrW(), h, Color(0, 0, 0, a))
			if(OSU.FetchingStatus) then
				local tx, ty = OSU:GetTextSize("OSUBeatmapTitle", "Checking server status..")
				draw.DrawText("Checking server status..", "OSUBeatmapTitle", ScrW() / 2, ScrH() - ((h / 2) + ScreenScale(7)), Color(255, 255, 255, fa), TEXT_ALIGN_CENTER)
			else
				if(OSU.ServerStatus) then
					local tx, ty = OSU:GetTextSize("OSUBeatmapTitle", "Server is online!")
					draw.DrawText("Server is online!", "OSUBeatmapTitle", ScrW() / 2, ScrH() - ((h / 2) + ScreenScale(7)), Color(200, 255, 200, fa), TEXT_ALIGN_CENTER)
					surface.SetDrawColor(200, 255, 200, fa)
					surface.SetMaterial(OSU.ConnectTx)
					surface.DrawTexturedRect((ScrW() / 2) + (tx / 2) + gap, ScrH() - (h / 2) - kSx / 2, kSx, kSx)
				else
					local tx, ty = OSU:GetTextSize("OSUBeatmapTitle", "Server is offline...")
					draw.DrawText("Server is offline...", "OSUBeatmapTitle", ScrW() / 2, ScrH() - ((h / 2) + ScreenScale(7)), Color(255, 200, 200, fa), TEXT_ALIGN_CENTER)
					surface.SetDrawColor(255, 200, 200, fa)
					surface.SetMaterial(OSU.DisconnectTx)
					surface.DrawTexturedRect((ScrW() / 2) + (tx / 2) + gap, ScrH() - (h / 2) - kSx / 2, kSx, kSx)
				end
			end
			surface.SetMaterial(ppy)
			surface.SetDrawColor(255, 255, 255, fa)
			surface.DrawTexturedRect(ScreenScale(2), ScrH() - (_h + ScreenScale(2)), ScreenScale(86), _h)
			surface.SetTextPos(_npos, _pos)
			if(!OSU.UserScoreFetching) then
				local _a = "[Invalid]"
				local _s = "[Invalid]"
				local _p = "[Invalid]"
				if(OSU.ServerStatus) then
					if(!OSU.UserDataInvalid) then
						_a = OSU.UserAccuracy.."%"
						_s = OSU.UserRankingScore
						_p = OSU.UserMapsPlayed
					end
				else
					_a = "[Server Offline..]"
					_s = "[Server Offline..]"
					_p = "[Server Offline..]"
				end
				surface.SetTextColor(255, 255, 255, fa)
				surface.SetFont("OSUName")
				local t = LocalPlayer():Nick()
				--[[
				if(OSU.UserBanned) then
					t = t.." [BANNED]"
				end
				]]
				surface.DrawText(t)
				surface.SetTextPos(_npos, _pos + sy)
				surface.SetFont("OSUDetails")
				surface.DrawText("Accuracy: ".._a)
				surface.SetTextPos(_npos, _pos + sy + _sy)
				surface.DrawText("Ranking Score: ".._s)
				surface.SetTextPos(_npos, _pos + sy + (_sy * 2))
				surface.DrawText("Total Map Played: ".._p)
				draw.DrawText("#"..OSU.UserRanking, "OSUBeatmapTitle", _npos + _w, h - (_th + gap), Color(255, 255, 255, ha), TEXT_ALIGN_RIGHT)
			else
				lRotate = math.Clamp(lRotate + OSU:GetFixedValue(2), 0, 360)
				if(lRotate >= 360) then lRotate = 0 end
				surface.SetMaterial(OSU.LoadingTx)
				surface.DrawTexturedRectRotated(_npos + lSx, h / 2, lSx, lSx, lRotate)
			end
			if(IsValid(OSU.SoundChannel)) then
			local size = ScreenScale(400)
			OSU.SoundChannel:FFT(OSU.FFT, FFT_256)
			if(OSU.Rotate >= 32) then
				OSU.Rotate = 1
			else
				if(nextRotate < OSU.CurTime) then
					OSU.Rotate = math.Clamp(OSU.Rotate + 1, 1, 32)
					nextRotate = OSU.CurTime + 0.02
				end
			end
				for i = 1, num do
					local idx = math.floor(i * 4)
					if(#OSU.FFT > 1) then
						local fIdx = i + OSU.Rotate
						if(fIdx > 32) then
							fIdx = fIdx - 32
						end
						if(OSU.Visualizer[idx] < OSU.FFT[fIdx]) then
							OSU.Visualizer[idx] = OSU.FFT[fIdx]
						end
					end
					OSU.Visualizer[idx] = Lerp(1.5 * FrameTime(), OSU.Visualizer[idx], 0)
			        local deg = (math.pi / num * i)
			        local x = math.sin(deg)
			        local y = math.cos(deg)
			        local ang = i * ScreenScale(1)
			        local iAlpha = math.Clamp(255 * OSU.Visualizer[idx], 0, 255) * 0.45
			        surface.SetMaterial(mat)
			        surface.SetDrawColor(255, 255, 255, iAlpha)
			       	for _ = 0, 5, 1 do
			       		surface.DrawTexturedRectRotated((OSU.Logo:GetX() + (OSU.Logo:GetWide() / 2)) - x, (OSU.Logo:GetY() + (OSU.Logo:GetTall() / 2)) - y, ScreenScale(3), ScreenScale(200) + (ScreenScale(150) * OSU.Visualizer[idx]), (ang + (_ * 60)))
			       	end
				end
			end
		end
	end
	if(IsValid(OSU.MusicControlTab)) then
		OSU.MusicControlTab:Remove()
	end
	OSU.MusicControlTab = OSU:CreateMusicTab()
	OSU.MusicControlPanel = OSU:CreateMusicControlPanel()
	OSU.Logo = OSU:CreateLogo(OSU.ObjectLayer, ScrW() / 2, ScrH() / 2, ScreenScale(200), ScreenScale(200), OSU.CurrentSkin["logo"], true)
	OSU.ObjectLayer.ButtonXOffset = 0
	OSU.ObjectLayer.ButtoniAlpha = 0
	OSU.Button_Play = OSU:CreateLogoButton("play")
	OSU.Button_Settings = OSU:CreateLogoButton("options")
	OSU.Button_Exit = OSU:CreateLogoButton("exit")
	OSU.Button_Play.DoClick = function()
		OSU:PlaySoundEffect(OSU.CurrentSkin["menu-play-click"])
		OSU:ChangeScene(OSU_MENU_STATE_BEATMAP)
		OSU.Logo.Clicked = false
	end
	OSU.Button_Settings.DoClick = function()
		OSU:OpenOptionsMenu()
		OSU:PlaySoundEffect(OSU.CurrentSkin["menu-direct-click"])
	end
	OSU.Button_Exit.DoClick = function()
		OSU.MainGameFrame:Close()
		OSU:StopSound()
		OSU:PlaySoundEffect(OSU.CurrentSkin["menu-direct-click"])
	end
	OSU.ObjectLayer.Think = function()
		if(IsValid(OSU.Logo)) then
			OSU.Logo:SetVisible(OSU.MENU_STATE == OSU_MENU_STATE_MAIN)
			if(OSU.Logo.Clicked) then
				OSU.Logo.oX = math.Clamp(OSU.Logo.oX - OSU:GetFixedValue(15), (ScrW() / 2) - ScreenScale(180) / 2, ScrW() / 2)
				local cPos = (OSU.Logo.oX * 0.8) + OSU.ObjectLayer.ButtonXOffset
				local dst = (ScrW() / 2) - (ScreenScale(180) / 2)
				if(math.abs(OSU.Logo.oX - dst) <= (dst / 4)) then
					OSU.ObjectLayer.ButtonXOffset = math.Clamp(OSU.ObjectLayer.ButtonXOffset + OSU:GetFixedValue(25), 0, ScreenScale(90))
					OSU.ObjectLayer.ButtoniAlpha = math.Clamp(OSU.ObjectLayer.ButtoniAlpha + OSU:GetFixedValue(25), 0, 255)
				end
				OSU.Button_Play:SetPos(cPos, ((ScrH() / 2) - OSU.Button_Play:GetTall() / 2) - ScreenScale(50))
				OSU.Button_Settings:SetPos(cPos, (ScrH() / 2) - OSU.Button_Settings:GetTall() / 2)
				OSU.Button_Exit:SetPos(cPos, ((ScrH() / 2) - OSU.Button_Exit:GetTall() / 2) + ScreenScale(50))
				OSU.Button_Play:SetVisible(true)
				OSU.Button_Settings:SetVisible(true)
				OSU.Button_Exit:SetVisible(true)
				if(OSU.LogoLastClickTime < OSU.CurTime) then
					OSU.Logo.Clicked = false
				end
			else
				OSU.Logo.oX = math.Clamp(OSU.Logo.oX + OSU:GetFixedValue(15), (ScrW() / 2) - ScreenScale(180) / 2, ScrW() / 2)
				OSU.ObjectLayer.ButtoniAlpha = math.Clamp(OSU.ObjectLayer.ButtoniAlpha - OSU:GetFixedValue(25), 0, 255)
				OSU.ObjectLayer.ButtonXOffset = math.Clamp(OSU.ObjectLayer.ButtonXOffset - OSU:GetFixedValue(10), 0, ScreenScale(90))
				if(OSU.ObjectLayer.ButtoniAlpha <= 0) then
					OSU.Button_Play:SetVisible(false)
					OSU.Button_Settings:SetVisible(false)
					OSU.Button_Exit:SetVisible(false)
				end
			end
		end
	end
	OSU:StartupAnimation()
end