--[[
	Gmod osu! - An unofficial port of osu! to Garry's mod.
	None of these codes should be modified or changed without original author's permission, anykind of modification is not allowed.

	You can use it on whatever you like, but you should not claim you're the original author,
	If you're a server owner, do not put this addon behind paywall, or some vip shit

	For translators, if you want to translate this addon, please contact me directly instead of modify the code
	REUPLOAD / REPACK IS NOT ALLOWED

	Copyright (C) 2023 Meika. All rights reserved
]]

OSU.OptPink = Color(236, 117, 140, 255)
OSU.OptPinkOff = Color(165, 82, 98, 255)
OSU.OptBlue = Color(88, 218, 254, 255)
OSU.OptGlod = Color(255, 239, 63, 255)

OSU.SliderBarScroll = 0
OSU.SliderBarMaxScroll = 0

OSU.FadeMaterial = Material("osu/internal/fade.png")
OSU.ShouldWrite = false
OSU.WriteDelay = 0

OSU.ConfigTable = {
	"BeatmapNameType",
	"BeatmapArtistType",
	"FPSCounterEnabled",
	"WorldRender",
	"WriteObjectFile",
	"InterfaceVoice",
	"ThemeMusic",
	"SongThumbnails",
	"MultiThumbnail",
	"SnakingSliders",
	"SingleColorSlider",
	"BackgroundDim",
	"ForceDefaultBG",
	"DisableFlash",
	"DisableBeatFlash",
	"HitErrorBar",
	"PerfectHit",
	"FinishToWhistle",
	"CursorSize",
	"CursorTrail",
	"FillCursorGap",
	"CursorTrailLife",
	"MusicVolume",
	"HitSoundVolume",
	"EffectVolume",
	"SteamName",
	"UserName",
	"NoAvatars",
	"LoadFrame",
	"NoBreakSound",
	"BlurShader",
	"EdgeFlash",
	"MainBGDim",
	"SmoothBG",
	"MenuShow",
	"NoEdgeSound",
	"CircleFollowPoint",
	"SmoothHitCircle",
	"AllowAllSounds",
	"LoadCards",
	"DisableMouse",
}

OSU.Vec1 = Vector(0, 0, 0)
OSU.Vec2 = Vector(0, 0, 0)

OSU.UserName = "My Custom Name"
OSU.NoAvatar = false
OSU.SteamName = true
OSU.FPSCounterEnabled = true
OSU.WorldRender = true
OSU.WriteObjectFile = true
OSU.InterfaceVoice = true
OSU.ThemeMusic = true
OSU.SongThumbnails = true
OSU.DisableFlash = false
OSU.DisableBeatFlash = false
OSU.MusicVolume = 1
OSU.EffectVolume = 1
OSU.HitSoundVolume = 1
OSU.SingleColorSlider = false
OSU.SnakingSliders = true
OSU.CursorSize = 16
OSU.Key1Code = 36
OSU.Key2Code = 34
OSU.MultiThumbnail = false
OSU.CursorTrail = false
OSU.FillCursorGap = true
OSU.CursorTrailLife = 0.08
OSU.FinishToWhistle = false
OSU.HitErrorBar = true
OSU.PerfectHit = true
OSU.ForceDefaultBG = false
OSU.LoadFrame = true
OSU.FlashLoginArea = false
OSU.NoBreakSound = false
OSU.BlurShader = false
OSU.EdgeFlash = false
OSU.MainBGDim = 255
OSU.SmoothBG = true
OSU.MenuSnow = true
OSU.NoEdgeSound = false
OSU.CircleFollowPoint = true
OSU.SmoothHitCircle = true
OSU.AllowAllSounds = true
OSU.LoadCards = true
OSU.DisableMouse = false

OSU.MainVersion = "1.1.0"
OSU.AvatarVersion = "1.0.1"
OSU.BeatmapCacheVersion = "1.1.0"

function OSU:ClearAvatars()
	local a = file.Find("osu!/avatars/*", "DATA")
	local f = file.Find("osu!/avatars/frames/*", "DATA")
	for k,v in next, a do
		file.Delete("osu!/avatars/"..v)
	end
	for k,v in next, f do
		file.Delete("osu!/avatars/frames/"..v)
	end
end

function OSU:ClearCaches()
	local a = file.Find("osu!/cache/hitobjects/*", "DATA")
	for k,v in next, a do
		file.Delete("osu!/cache/hitobjects/"..v)
	end
end

function OSU:WriteVersionFile()
	local tmp = {
		["main"] = OSU.MainVersion,
		["avt"] = OSU.AvatarVersion,
		["bmp"] = OSU.BeatmapCacheVersion,
	}
	file.Write("osu!/version.dat", util.TableToJSON(tmp))
end

function OSU.CheckVersion()
	if(file.Exists("osu!/version.dat", "DATA")) then
		local dat = util.JSONToTable(file.Read("osu!/version.dat", "DATA"))
		if(dat == nil) then
			OSU:WriteLog("Version file is not valid! rewriting it..")
			OSU:WriteVersionFile()
		else
			local ShouldUpdate = false
			if(dat["main"] != OSU.MainVersion) then
				-- do something
				ShouldUpdate = true
			end
			if(dat["avt"] != OSU.AvatarVersion) then
				OSU:ClearAvatars()
				ShouldUpdate = true
			end
			if(dat["bmp"] != OSU.BeatmapCacheVersion) then
				OSU:ClearCaches()
				ShouldUpdate = true
			end
			if(ShouldUpdate) then
				OSU:WriteVersionFile()
			end
		end
	else
		OSU:WriteLog("Version file not found, creating..")
		OSU:WriteVersionFile()
		OSU:ClearAvatars()
		OSU:ClearCaches()
	end
end

function OSU:DrawCircle( x, y, radius, seg )
	local cir = {}
	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end
	local a = math.rad( 0 ) -- This is needed for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	draw.NoTexture()
	surface.SetDrawColor(236, 117, 140, 255)
	surface.DrawPoly(cir)
end

function OSU:Opt_InsertGap(gap)
	local t = OSU.SettingsScrollPanel:Add("DPanel")
		t:Dock(TOP)
		t.Paint = function() return end
		t:DockMargin(0, gap, 0, gap)
end

function OSU:Opt_CreateTopTitle(str, t, d, font, color)
	local text = OSU.SettingsScrollPanel:Add("DLabel")
		text:Dock(TOP)
		text:SetFont(font)
		text:SetText(str)
		local w, h = OSU:GetTextSize(font, str)
		text:SetSize(OSU.SettingsScrollPanel:GetWide(), h)
		text:DockMargin((OSU.SettingsScrollPanel:GetWide() / 2) - w / 2, t, 0, d)
		text:SetColor(color)
end

function OSU:CreateSectionTitle(str)
	local base = OSU.SettingsScrollPanel:Add("DPanel")
	base.Switch = false
	local w, h = OSU:GetTextSize("OSUOptionSectionTitle", str)
	base:SetTall(h)
	base:Dock(TOP)
	base:DockMargin(0, ScreenScale(10), 0, ScreenScale(7))
	base.Paint = function() return end
	local nextpos = ScreenScale(20)
	local text = base:Add("DLabel")
		text:SetFont("OSUOptionSectionTitle")
		text:SetText(str)
		text:SetColor(OSU.OptBlue)
		text:SetSize(w, h)
		text:SetX(OSU.SettingsScrollPanel:GetWide() - (w + ScreenScale(10)))
end

function OSU:CreateSubTitle(str)
	local base = OSU.SettingsScrollPanel:Add("DPanel")
	base.Switch = false
	base:SetTall(ScreenScale(12))
	base:Dock(TOP)
	base.Paint = function()
		if(base.Switch) then
			draw.RoundedBox(8, ScreenScale(14), 0, 4, base:GetTall(), OSU.OptGlod)
		else
			draw.RoundedBox(8, ScreenScale(14), 0, 4, base:GetTall(), Color(90, 90, 90, 255))
		end
	end
	local nextpos = ScreenScale(20)
	local text = base:Add("DLabel")
		text:SetFont("OSUOptionSubTitle")
		local w, h = OSU:GetTextSize("OSUOptionSubTitle", str)
		text:SetText(str)
		text:SetSize(w, h)
		text:SetX(nextpos)
end

function OSU:CreateString(str, clr)
	if(clr == nil) then clr = Color(255, 255, 255, 255) end
	local base = OSU.SettingsScrollPanel:Add("DPanel")
	base.Switch = false
	base:SetTall(ScreenScale(12))
	base:Dock(TOP)
	base.Paint = function()
		if(base.Switch) then
			draw.RoundedBox(8, ScreenScale(14), 0, 4, base:GetTall(), OSU.OptGlod)
		else
			draw.RoundedBox(8, ScreenScale(14), 0, 4, base:GetTall(), Color(90, 90, 90, 255))
		end
	end
	local nextpos = ScreenScale(20)
	local text = base:Add("DLabel")
		text:SetFont("OSUOptionDesc")
		local w, h = OSU:GetTextSize("OSUOptionDesc", str)
		text:SetText(str)
		text:SetSize(w, h)
		text:SetPos(nextpos, (base:GetTall() - h) / 2)
		text:SetTextColor(clr)
end

function OSU:CreateStatusString()
	local base = OSU.SettingsScrollPanel:Add("DPanel")
	base.Switch = false
	base:SetTall(ScreenScale(12))
	base:Dock(TOP)
	base.Paint = function()
		if(base.Switch) then
			draw.RoundedBox(8, ScreenScale(14), 0, 4, base:GetTall(), OSU.OptGlod)
		else
			draw.RoundedBox(8, ScreenScale(14), 0, 4, base:GetTall(), Color(90, 90, 90, 255))
		end
	end
	local nextpos = ScreenScale(20)
	local text = base:Add("DLabel")
		text:SetFont("OSUOptionDesc")
		local w, h = OSU:GetTextSize("OSUOptionDesc", "DummyText")
		text:SetSize(OSU.SettingsScrollPanel:GetWide(), h)
		text:SetPos(nextpos, (base:GetTall() - h) / 2)
		base.Think = function()
			if(OSU.LoggedIn) then
				text:SetText("Status : Logged in")
			else
				text:SetText("Status : Not logged in")
			end
		end
end

function OSU:CreateCustomString(str, func)
	local base = OSU.SettingsScrollPanel:Add("DPanel")
	base.Switch = false
	base:SetTall(ScreenScale(12))
	base:Dock(TOP)
	base.Paint = function()
		if(base.Switch) then
			draw.RoundedBox(8, ScreenScale(14), 0, 4, base:GetTall(), OSU.OptGlod)
		else
			draw.RoundedBox(8, ScreenScale(14), 0, 4, base:GetTall(), Color(90, 90, 90, 255))
		end
	end
	local nextpos = ScreenScale(20)
		base.text = base:Add("DLabel")
		base.text:SetFont("OSUOptionDesc")
		local w, h = OSU:GetTextSize("OSUOptionDesc", str)
		base.text:SetSize(OSU.SettingsScrollPanel:GetWide(), h)
		base.text:SetPos(nextpos, (base:GetTall() - h) / 2)
		base.text:SetText(str)
		base.Think = func
end

function OSU:Opt_CreateClickButton(str, func, func2)
	local base = OSU.SettingsScrollPanel:Add("DPanel")
	base.Switch = false
	base:SetTall(ScreenScale(14))
	base:Dock(TOP)
	base.Paint = function()
		if(base.Switch) then
			draw.RoundedBox(8, ScreenScale(14), 0, 4, base:GetTall(), OSU.OptGlod)
		else
			draw.RoundedBox(8, ScreenScale(14), 0, 4, base:GetTall(), Color(90, 90, 90, 255))
		end
	end
	local nextpos = ScreenScale(20)
	local btn = vgui.Create("DButton", base)
		btn:SetFont("OSUOptionDesc")
		btn:SetText(str)
		btn:SetColor(Color(100, 100, 100, 255))
		btn:SetSize(ScreenScale(200), ScreenScale(12))
		btn:SetX(nextpos)
		local gap = 2
		local gap2x = gap * 2
		btn.Paint = function()
			draw.RoundedBox(0, 0, 0, btn:GetWide(), btn:GetTall(), Color(0, 0, 0, 255))
			draw.RoundedBox(0, gap, gap, btn:GetWide() - gap2x, btn:GetTall() - gap2x, OSU.OptBlue)
		end
		function btn:OnCursorEntered()
			OSU:PlaySoundEffect(OSU.CurrentSkin["click-short"])
		end
		btn.DoClick = func
		btn.Think = func2
end

function OSU:CreatePreviewImage(opt)
	local imgTall = ScreenScale(108)
	local textTall = ScreenScale(12)
	local base = OSU.SettingsScrollPanel:Add("DPanel")
	base.Switch = false
	base:SetTall(imgTall + textTall)
	base:Dock(TOP)
	base.Paint = function()
		if(base.Switch) then
			draw.RoundedBox(8, ScreenScale(14), 0, 4, base:GetTall(), OSU.OptGlod)
		else
			draw.RoundedBox(8, ScreenScale(14), 0, 4, base:GetTall(), Color(90, 90, 90, 255))
		end
	end
	local nextpos = ScreenScale(20)
	local text = vgui.Create("DLabel", base)
		text:SetPos(nextpos, imgTall + ScreenScale(1))
		text:SetSize(OSU.SettingsScrollPanel:GetWide(), ScreenScale(9))
		text:SetFont("OSUOptionSubTitle")
	local pImg = vgui.Create("DImage", base)
		pImg:SetSize(ScreenScale(192), imgTall)
		pImg:SetX(nextpos)
		pImg:SetImage(OSU.CurrentSkin["menu-background"])
		pImg.Think = function()
			local cv = math.Round(OSU[opt], 1)
			pImg:SetImageColor(Color(cv, cv, cv, 255))
			local perc = math.Round(cv / 255, 2) * 100
			text:SetText("Color("..cv..", "..cv..", "..cv..", 255) ["..perc.."%]")
		end
end

function OSU:Opt_CreateBNameButton(str)
	local base = OSU.SettingsScrollPanel:Add("DPanel")
	base.Switch = false
	base:SetTall(ScreenScale(12))
	base.CircleSize = base:GetTall() / 4
	base:Dock(TOP)
	base.fade = 0
	local max = ScreenScale(7)
	local nextpos = ScreenScale(30)
	local text = base:Add("DLabel")
		text:SetFont("OSUOptionDesc")
		local w, h = OSU:GetTextSize("OSUOptionDesc", str)
		text:SetText(str)
		text:SetSize(w, h)
		text:SetPos(nextpos, ((base:GetTall() - h) / 2))
		local btn = base:Add("DButton")
		btn:SetSize(OSU.SettingsScrollPanel:GetWide(), base:GetTall())
		btn:SetText("")
		btn.Paint = function() return end
		btn.DoClick = function()
			if(base.Switch) then
				OSU.BeatmapNameType = "Title"
				OSU:PlaySoundEffect(OSU.CurrentSkin["check-off"])
			else
				OSU.BeatmapNameType = "TitleUnicode"
				OSU:PlaySoundEffect(OSU.CurrentSkin["check-on"])
			end
			OSU:WriteConfigFile()
		end
	base.Paint = function()
		surface.SetDrawColor(177, 132, 14, 255)
		surface.SetMaterial(OSU.FadeMaterial)
		surface.DrawTexturedRect(ScreenScale(14), 0, base.fade, base:GetTall())
		if(base.Switch) then
			draw.RoundedBox(8, ScreenScale(14), 0, 4, base:GetTall(), OSU.OptGlod)
			OSU:DrawCircle(ScreenScale(25) - (base.CircleSize / 2), (base:GetTall() / 2) - (base.CircleSize / 2) + ((base:GetTall() - h) / 2), base.CircleSize, 20)
			base.fade = math.Clamp(base.fade + OSU:GetFixedValue((max - base.fade) * 0.25), 0, max)
		else
			draw.RoundedBox(8, ScreenScale(14), 0, 4, base:GetTall(), Color(90, 90, 90, 255))
			surface.DrawCircle(ScreenScale(25) - (base.CircleSize / 2), (base:GetTall() / 2) - (base.CircleSize / 2) + ((base:GetTall() - h) / 2), base.CircleSize, OSU.OptPink)
			base.fade = math.Clamp(base.fade - OSU:GetFixedValue((base.fade) * 0.25), 0, max)
		end
		if(OSU.BeatmapNameType == "Title") then
			base.Switch = false
		else
			base.Switch = true
		end
	end
end

function OSU:Opt_CreateANameButton(str)
	local base = OSU.SettingsScrollPanel:Add("DPanel")
	base.Switch = false
	base:SetTall(ScreenScale(12))
	base.CircleSize = base:GetTall() / 4
	base.fade = 0
	local max = ScreenScale(7)
	base:Dock(TOP)
	local nextpos = ScreenScale(30)
	local text = base:Add("DLabel")
		text:SetFont("OSUOptionDesc")
		local w, h = OSU:GetTextSize("OSUOptionDesc", str)
		text:SetText(str)
		text:SetSize(w, h)
		text:SetPos(nextpos, (base:GetTall() - h) / 2)
		local btn = base:Add("DButton")
		btn:SetSize(OSU.SettingsScrollPanel:GetWide(), base:GetTall())
		btn:SetText("")
		btn.Paint = function() return end
		btn.DoClick = function()
			if(base.Switch) then
				OSU.BeatmapArtistType = "Artist"
				OSU:PlaySoundEffect(OSU.CurrentSkin["check-off"])
			else
				OSU.BeatmapArtistType = "ArtistUnicode"
				OSU:PlaySoundEffect(OSU.CurrentSkin["check-on"])
			end
			OSU:WriteConfigFile()
		end
	base.Paint = function()
		surface.SetDrawColor(177, 132, 14, 255)
		surface.SetMaterial(OSU.FadeMaterial)
		surface.DrawTexturedRect(ScreenScale(14), 0, base.fade, base:GetTall())
		if(base.Switch) then
			draw.RoundedBox(8, ScreenScale(14), 0, 4, base:GetTall(), OSU.OptGlod)
			OSU:DrawCircle(ScreenScale(25) - (base.CircleSize / 2), (base:GetTall() / 2) - (base.CircleSize / 2) + ((base:GetTall() - h) / 2), base.CircleSize, 20)
			base.fade = math.Clamp(base.fade + OSU:GetFixedValue((max - base.fade) * 0.25), 0, max)
		else
			draw.RoundedBox(8, ScreenScale(14), 0, 4, base:GetTall(), Color(90, 90, 90, 255))
			surface.DrawCircle(ScreenScale(25) - (base.CircleSize / 2), (base:GetTall() / 2) - (base.CircleSize / 2) + ((base:GetTall() - h) / 2), base.CircleSize, OSU.OptPink)
			base.fade = math.Clamp(base.fade - OSU:GetFixedValue((base.fade) * 0.25), 0, max)
		end
		if(OSU.BeatmapArtistType == "Artist") then
			base.Switch = false
		else
			base.Switch = true
		end
	end
end

function OSU:Opt_CreateButton(str, opt, func)
	local base = OSU.SettingsScrollPanel:Add("DPanel")
	base.Switch = false
	base:SetTall(ScreenScale(12))
	base.CircleSize = base:GetTall() / 4
	base.fade = 0
	local max = ScreenScale(7)
	base:Dock(TOP)
	local nextpos = ScreenScale(30)
	local text = base:Add("DLabel")
		text:SetFont("OSUOptionDesc")
		local w, h = OSU:GetTextSize("OSUOptionDesc", str)
		text:SetText(str)
		text:SetSize(w, h)
		text:SetPos(nextpos, (base:GetTall() - h) / 2)
		local btn = base:Add("DButton")
		btn:SetSize(OSU.SettingsScrollPanel:GetWide(), base:GetTall())
		btn:SetText("")
		btn.Paint = function() return end
		btn.DoClick = function()
			if(base.Switch) then
				OSU[opt] = false
				OSU:PlaySoundEffect(OSU.CurrentSkin["check-off"])
			else
				OSU[opt] = true
				OSU:PlaySoundEffect(OSU.CurrentSkin["check-on"])
			end
			OSU:WriteConfigFile()
			if(func != nil) then
				func()
			end
		end
	base.Paint = function()
		surface.SetDrawColor(177, 132, 14, 255)
		surface.SetMaterial(OSU.FadeMaterial)
		surface.DrawTexturedRect(ScreenScale(14), 0, base.fade, base:GetTall())
		if(base.Switch) then
			draw.RoundedBox(8, ScreenScale(14), 0, 4, base:GetTall(), OSU.OptGlod)
			OSU:DrawCircle(ScreenScale(25) - (base.CircleSize / 2), (base:GetTall() / 2) - (base.CircleSize / 2) + ((base:GetTall() - h) / 2), base.CircleSize, 20)
			base.fade = math.Clamp(base.fade + OSU:GetFixedValue((max - base.fade) * 0.25), 0, max)
		else
			draw.RoundedBox(8, ScreenScale(14), 0, 4, base:GetTall(), Color(90, 90, 90, 255))
			surface.DrawCircle(ScreenScale(25) - (base.CircleSize / 2), (base:GetTall() / 2) - (base.CircleSize / 2) + ((base:GetTall() - h) / 2), base.CircleSize, OSU.OptPink)
			base.fade = math.Clamp(base.fade - OSU:GetFixedValue((base.fade) * 0.25), 0, max)
		end
		if(!OSU[opt]) then
			base.Switch = false
		else
			base.Switch = true
		end
	end
end

function OSU:Opt_CreateDropDown(str)
	local base = OSU.SettingsScrollPanel:Add("DPanel")
	base.Switch = false
	base:SetTall(ScreenScale(12))
	base:Dock(TOP)
	base.Paint = function()
		if(base.Switch) then
			draw.RoundedBox(8, ScreenScale(14), 0, 4, base:GetTall(), OSU.OptGlod)
		else
			draw.RoundedBox(8, ScreenScale(14), 0, 4, base:GetTall(), Color(90, 90, 90, 255))
		end
	end
	local nextpos = ScreenScale(20)
	local text = base:Add("DLabel")
		text:SetFont("OSUOptionDesc")
		local w, h = OSU:GetTextSize("OSUOptionDesc", str)
		text:SetText(str)
		text:SetSize(w, h)
		text:SetPos(nextpos, ((base:GetTall() - h) / 2))
	--[[
		local cbo = base:Add("OSUComboBox")
		cbo.Paint = function()
			draw.RoundedBox(8, 0, 0, cbo:GetWide(), cbo:GetTall(), Color(0, 0, 0, 200))
		end
		]]
end

function OSU:Opt_CreateSlider(str, opt, min, _max)
	local base = OSU.SettingsScrollPanel:Add("DPanel")
	base.Switch = false
	base:SetTall(ScreenScale(12))
	base.vSize = base:GetTall() / 2
	base.fade = 0
	local max = ScreenScale(7)
	base:Dock(TOP)
	local nextpos = ScreenScale(20)
	local text = base:Add("DLabel")
		text:SetFont("OSUOptionDesc")
		local w, h = OSU:GetTextSize("OSUOptionDesc", str)
		text:SetText(str)
		text:SetSize(w, h)
		text:SetPos(nextpos, (base:GetTall() - h) / 2)
	base.Paint = function()
		surface.SetDrawColor(177, 132, 14, 255)
		surface.SetMaterial(OSU.FadeMaterial)
		surface.DrawTexturedRect(ScreenScale(14), 0, base.fade, base:GetTall())
		draw.RoundedBox(8, ScreenScale(14), 0, 4, base:GetTall(), Color(90, 90, 90, 255))
	end
	local cSize = base.vSize / 2
	local vbase = base:Add("DPanel")
		vbase:SetPos(nextpos + w + ScreenScale(4))
		vbase:SetSize(OSU.SettingsScrollPanel:GetWide() - (nextpos + w + ScreenScale(15)), ScreenScale(12))
		vbase.CurPos = (OSU[opt] / (_max)) * vbase:GetWide()
		vbase.oldvalue = 0
		vbase.soundinterval = 0
		vbase.ShouldWrite = false
		vbase.WriteDelay = 0
		vbase.Paint = function()
			draw.RoundedBox(0, 0, vbase:GetTall() / 2, vbase.CurPos - cSize, ScreenScale(1), OSU.OptPink)
			draw.RoundedBox(0, vbase.CurPos + cSize, vbase:GetTall() / 2, vbase:GetWide(), ScreenScale(1), OSU.OptPinkOff)
			surface.DrawCircle(vbase.CurPos, vbase:GetTall() / 2, cSize, OSU.OptPink)
			if(input.IsMouseDown(MOUSE_LEFT) && vbase:IsHovered()) then
				local mx, my = vbase:CursorPos()
				local RelativePosToValue = math.Clamp(_max * (mx / vbase:GetWide()), min, _max)
				vbase.CurPos = math.Clamp(mx, 0, vbase:GetWide())
				if(vbase.oldvalue != RelativePosToValue && vbase.soundinterval < OSU.CurTime) then
					OSU:PlaySoundEffect("sound/osu/internal/sidebarhover.wav")
					vbase.soundinterval = OSU.CurTime + 0.06
					vbase.ShouldWrite = true
					vbase.WriteDelay = OSU.CurTime + 0.1
				end
				OSU[opt] = RelativePosToValue
				if(opt == "MusicVolume") then
					OSU.SoundChannel:SetVolume(OSU[opt])
				end
				vbase.oldvalue = RelativePosToValue
			end
		end
		vbase.Think = function()
			if(vbase.ShouldWrite) then
				if(vbase.WriteDelay < OSU.CurTime) then
					OSU:WriteConfigFile()
					vbase.ShouldWrite = false
				end
			end
		end
end

function OSU:CreateFlashObject()

end

function OSU:Opt_PositioningObject(opt, opposite)
	local base = OSU.SettingsScrollPanel:Add("DPanel")
	base:SetSize(OSU.SettingsScrollPanel:GetWide(), 1)
	base:Dock(TOP)
	base.Paint = function() return end
	base.Think = function()
		local x, y = OSU.SettingsScrollPanel:GetChildPosition(base)
		if(opposite) then
			OSU[opt] = Vector(base:GetWide(), y, 0)
		else
			OSU[opt] = Vector(x, y, 0)
		end
	end
	return base
end

function OSU:Opt_CreateImage(path, w, h)
	local base = OSU.SettingsScrollPanel:Add("DPanel")
		base.Paint = function() end
		base:Dock(TOP)
		base:SetTall(h)
		local img = base:Add("DImage")
			img:SetImage(path)
			img:SetSize(w, h)
			img:SetX((OSU.SettingsScrollPanel:GetWide() / 2) - (w / 2))
end

function OSU:CreateTextEntry(str, opt, cond)
	local base = OSU.SettingsScrollPanel:Add("DPanel")
	local _h = ScreenScale(25)
		base.Switch = false
		base.Focused = false
		base.Paint = function() end
		base:Dock(TOP)
		base:SetTall(_h)
		base.ShouldWrite = false
		base.WriteDelay = 0
		base.condAlp = 0
		local gap = ScreenScale(2)
		local bgGap = ScreenScale(5)
		local nextpos = ScreenScale(20)
		local innerGap = ScreenScale(1)
		base.Paint = function()
			if(base.Switch) then
				draw.RoundedBox(8, ScreenScale(14), 0, 4, base:GetTall(), OSU.OptGlod)
			else
				draw.RoundedBox(8, ScreenScale(14), 0, 4, base:GetTall(), Color(90, 90, 90, 255))
			end
			if(OSU[cond]) then
				base.condAlp = math.Clamp(base.condAlp + OSU:GetFixedValue(25), 0, 200)
			else
				base.condAlp = math.Clamp(base.condAlp - OSU:GetFixedValue(25), 0, 200)
			end
			draw.RoundedBox(0, nextpos - bgGap, 0, base:GetWide(), base:GetTall(), Color(0, 0, 0, base.condAlp))
		end
		local w, h = OSU:GetTextSize("OSUOptionDesc", str)
		local label = base:Add("DLabel")
			label:SetFont("OSUOptionDesc")
			label:SetText(str)
			label:SetSize(w, h)
			label:SetX(nextpos)
			local teBG = base:Add("DImage")
				teBG:SetSize(OSU.SettingsScrollPanel:GetWide() - (nextpos * 1.5), _h - (h + bgGap))
				teBG:SetPos(nextpos, h + gap)
				teBG.Clr = 0
				teBG.Paint = function()
				if(base.Focused) then
					teBG.Clr = math.Clamp(teBG.Clr + OSU:GetFixedValue(30), 0, 125)
				else
					teBG.Clr = math.Clamp(teBG.Clr - OSU:GetFixedValue(30), 0, 125)
				end
					local clr = 100 + teBG.Clr
					draw.RoundedBox(0, 0, 0, teBG:GetWide(), teBG:GetTall(), Color(0, 0, 0, 100))
					surface.SetDrawColor(clr, clr, clr, 255)
					surface.DrawOutlinedRect(0, 0, teBG:GetWide(), teBG:GetTall(), ScreenScale(1))
				end
				local text = OSU[opt]
				local innerBG = base:Add("DTextEntry")
					innerBG:SetSize(teBG:GetWide() - innerGap * 2, teBG:GetTall() - innerGap * 2)
					innerBG:SetPos(teBG:GetX() + innerGap, teBG:GetY() + innerGap)
					innerBG:SetPaintBackground(false)
					innerBG:SetTextColor(Color(255, 255, 255, 255))
					innerBG:SetFont("OSUOptionSubTitle")
					base.NextClick = 0
					function base:OnMousePressed(keyCode)
						if(keyCode != 107 || OSU[cond]) then return end
						base.Focused = !base.Focused
						if(base.Focused) then
							innerBG:RequestFocus()
							OSU:PlaySoundEffect(OSU.CurrentSkin["click-short"])
						else
							OSU:PlaySoundEffect(OSU.CurrentSkin["click-close"])
						end
					end
					function innerBG:OnMousePressed(keyCode)
						if(keyCode != 107 || OSU[cond]) then return end
						if(!base.Focused) then
							innerBG:RequestFocus()
							OSU:PlaySoundEffect(OSU.CurrentSkin["click-short"])
						end
						base.Focused = true
					end
					function innerBG:OnKeyCodeTyped(keyCode)
						if(keyCode == 66) then
							OSU:PlaySoundEffect(OSU.CurrentSkin["key-delete"])
						else
							if(keyCode != 64) then
								OSU:PlaySoundEffect(OSU.CurrentSkin["key-press-"..math.random(1, 4)])
							end
						end
						base.ShouldWrite = true
						base.WriteDelay = OSU.CurTime + 0.15
					end
					function innerBG:OnEnter(value)
						base.Focused = false
						OSU:PlaySoundEffect(OSU.CurrentSkin["key-confirm"])
					end
					innerBG.Think = function()
						innerBG:SetEditable(base.Focused)
						if(!base.Focused) then innerBG:KillFocus() end
					end
					base.Think = function()
						if(base.Focused) then
							if(input.IsMouseDown(107) && !base:IsHovered() && !innerBG:IsHovered()) then
								OSU:PlaySoundEffect(OSU.CurrentSkin["click-close"])
								base.Focused = false
							end
						end
						if(base.ShouldWrite) then
							if(base.WriteDelay < OSU.CurTime) then 
								OSU[opt] = innerBG:GetValue()
								OSU:WriteConfigFile()
								base.ShouldWrite = false
							end
						end
					end
					innerBG:SetValue(text)
end

function OSU:OpenOptionsMenu()
	OSU.SettingsLayer = OSU:CreateFrame(OSU.ObjectLayer, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 0), true)
	OSU.SettingsLayer.Closing = false
	OSU.SettingsLayer.PaneliAlpha = 0
	OSU.SettingsLayer.PaneliWide = 0
	OSU.SettingsPanel = OSU:CreateFrame(OSU.SettingsLayer, 0, 0, ScrW() * 0.4, ScrH(), Color(0, 0, 0, 0), true)
	local side = OSU.SettingsPanel:GetWide() * 0.1
	OSU.SettingsPanel.SidePanel = OSU:CreateFrame(OSU.SettingsPanel, 0, 0, side, ScrH(), Color(0, 0, 0, 255), true)
	OSU.SettingsScrollPanel = OSU:CreateScrollPanel(OSU.SettingsPanel, side, 0, (ScrW() * 0.4) - side, ScrH(), Color(0, 0, 0, 175))
	OSU.SettingsLayer.MaxWide = OSU.SettingsPanel:GetWide() * 0.9
	OSU.SettingsLayer.Think = function()
		OSU.SliderBarMaxScroll = OSU.SettingsScrollPanel:GetVBar().CanvasSize
		if(OSU.SettingsLayer.Closing) then
			OSU.SettingsLayer.PaneliAlpha = math.Clamp(OSU.SettingsLayer.PaneliAlpha - OSU:GetFixedValue(15), 0, 255)
			OSU.SettingsLayer.PaneliWide = math.Clamp(OSU.SettingsLayer.PaneliWide - OSU:GetFixedValue(OSU.SettingsScrollPanel:GetWide() * 0.1), 0, OSU.SettingsLayer.MaxWide)
			if(OSU.SettingsLayer.PaneliAlpha <= 10) then
				OSU.SettingsLayer:Remove()
			end
		else
			OSU.SettingsLayer.PaneliAlpha = math.Clamp(OSU.SettingsLayer.PaneliAlpha + OSU:GetFixedValue(15), 0, 255)
			OSU.SettingsLayer.PaneliWide = math.Clamp(OSU.SettingsLayer.PaneliWide + OSU:GetFixedValue((OSU.SettingsLayer.MaxWide - OSU.SettingsScrollPanel:GetWide()) * 0.1), 0, OSU.SettingsLayer.MaxWide)
		end
		OSU.SettingsScrollPanel:SetWide(OSU.SettingsLayer.PaneliWide)
		OSU.SettingsPanel.SidePanel.iAlpha = OSU.SettingsLayer.PaneliAlpha
		OSU.SettingsScrollPanel.iAlpha = OSU.SettingsLayer.PaneliAlpha / 1.25
		OSU.SettingsScrollPanel:SetAlpha(OSU.SettingsLayer.PaneliAlpha)
	end
	function OSU.SettingsLayer:OnMousePressed(keyCode)
		if(keyCode == 107) then
			OSU.SettingsLayer.Closing = true
		end
	end

	local sbar = OSU.SettingsScrollPanel:GetVBar()
	function sbar:Paint(w, h) return end
	function sbar.btnUp:Paint(w, h) return end
	function sbar.btnDown:Paint(w, h) return end
	function sbar.btnGrip:Paint(w, h) return end

	function OSU.SettingsScrollPanel:OnMouseWheeled(scrollDelta)
		if(OSU.SliderBarMaxScroll == 0) then return end
		OSU.SliderBarScroll = math.Clamp(OSU.SliderBarScroll - (scrollDelta * (ScreenScale(45))), 0, OSU.SliderBarMaxScroll)
	end

	OSU.SettingsScrollPanel.Think = function()
		if(OSU.SliderBarMaxScroll == 0) then return end
		local scroll = OSU.SettingsScrollPanel:GetVBar()
		if(scroll:GetScroll() != OSU.SliderBarScroll) then
			local smooth = math.abs(OSU.SliderBarScroll - scroll:GetScroll())
			if(scroll:GetScroll() < OSU.SliderBarScroll) then
				scroll:SetScroll(math.Clamp(scroll:GetScroll() + OSU:GetFixedValue(smooth * 0.15), 0, OSU.SliderBarMaxScroll))
			else
				scroll:SetScroll(math.Clamp(scroll:GetScroll() - OSU:GetFixedValue(smooth * 0.15), 0, OSU.SliderBarMaxScroll))
			end
		end
	end
	OSU.SettingsScrollPanel.FlashAlp = 0
	OSU.SettingsScrollPanel.Paint = function()
		draw.RoundedBox(0, 0, 0, OSU.SettingsScrollPanel:GetWide(), OSU.SettingsScrollPanel:GetTall(), Color(0, 0, 0, OSU.SettingsScrollPanel.iAlpha))
	end
	OSU:Opt_CreateTopTitle("Options", ScreenScale(30), ScreenScale(3), "OSUOptionTitle", Color(255, 255, 255, 255))
	OSU:Opt_CreateTopTitle("Change the way osu! beheaves", 0, ScreenScale(3), "OSUOptionDesc", OSU.OptPink)
	OSU:Opt_CreateTopTitle("Gmod osu! v"..OSU.MainVersion.." build", 0, ScreenScale(20), "OSUBeatmapDetails", Color(255, 255, 255, 255))
	OSU:CreateSectionTitle("Identify")
	OSU:CreateSubTitle("Sign in")
	OSU:CreateStatusString()
	OSU:CreateFlashObject()
	OSU:Opt_CreateClickButton("Login with steam", function()
		OSU:AuthorizeToken()
	end, function(self)
		if(OSU.LoggedIn) then
			self:Remove()
			local base = self:GetParent()
			if(IsValid(base)) then
				base:Remove()
			end
		else
			if(OSU.FlashLoginArea) then
				local x, y = input.GetCursorPos()
				local relX, relY = OSU.SettingsScrollPanel:GetChildPosition(self)
				local tarX, tarY = relX + self:GetWide() / 2, relY + self:GetTall() / 2
				local sthX, sthY = tarX - x, tarY - y
				input.SetCursorPos(x + OSU:GetFixedValue(sthX * 0.1), y + OSU:GetFixedValue(sthY * 0.1))
			end
		end
	end)
	OSU:CreateCustomString("We needs you to login is only for Identifying", function(self)
		if(OSU.LoggedIn || OSU.UserBanned) then
			self:Remove()
		end
	end)
	OSU:CreateCustomString("None of your information will be collected.", function(self)
		if(OSU.LoggedIn || OSU.UserBanned) then
			self:Remove()
		end
	end)
	OSU:CreateCustomString("Current User : ", function(self)
		if(!IsValid(self.text)) then return end
		if(OSU.LoggedIn) then
			if(OSU.UserBanned) then
				self.text:SetText("Cheating fuck")
				self.text:SetTextColor(Color(255, 50, 50))
			else
				self.text:SetText("Welcome, "..LocalPlayer():Nick())
				self.text:SetTextColor(Color(200, 255, 200))
			end
		else
			self.text:SetText("Playing as : Guest")
			self.text:SetTextColor(Color(255, 200, 200))
		end
	end)
	OSU:CreateSectionTitle("Leaderboard")
	OSU:CreateSubTitle("Name & Leaderboard")
	OSU:Opt_CreateButton("Use steam name for leaderboard", "SteamName")
	OSU:CreateTextEntry("Name for leaderboard", "UserName", "SteamName")
	OSU:Opt_CreateButton("Disable avatars on leaderboard", "NoAvatar")
	OSU:Opt_CreateButton("Load avatar frames", "LoadFrame")
	OSU:CreateString("*Leaderboard is not available unless you logged in!*", Color(255, 150, 150, 255))
	OSU:CreateSectionTitle("GENERAL")
	OSU:CreateSubTitle("Language")
	OSU:Opt_CreateBNameButton("Prefer metadata in original language (Map Name)")
	OSU:Opt_CreateANameButton("Prefer metadata in original language (Artist Name)")
	OSU:CreateSectionTitle("GRAPHICS")
	OSU:CreateSubTitle("Renderer")
	OSU:Opt_CreateButton("Show FPS counter", "FPSCounterEnabled")
	OSU:Opt_CreateButton("Blur shader", "BlurShader")
	OSU:Opt_InsertGap(ScreenScale(5))
	OSU:CreateSubTitle("Performance")
	OSU:Opt_CreateButton("Stop world rendering (Highly recommended)", "WorldRender")
	OSU:Opt_CreateButton("Write beatmap cache (Faster load time)", "WriteObjectFile")
	OSU:Opt_InsertGap(ScreenScale(5))
	OSU:CreateSubTitle("Main Menu")
	OSU:Opt_CreateSlider("Menu background dim", "MainBGDim", 0, 255)
	OSU:CreatePreviewImage("MainBGDim")
	OSU:Opt_CreateButton("Smooth background", "SmoothBG", function()
		if(OSU.SmoothBG) then
			OSU.Background.Tx = Material(OSU.Background:GetImage(), "smooth")
		else
			OSU.Background.Tx = Material(OSU.Background:GetImage())
		end
	end)
	OSU:Opt_CreateButton("Interface voices", "InterfaceVoice")
	OSU:Opt_CreateButton("osu! music theme", "ThemeMusic")
	OSU:Opt_CreateButton("Edge flashing (Unstable)", "EdgeFlash")
	OSU:Opt_CreateButton("Menu snow", "MenuSnow")
	OSU:Opt_InsertGap(ScreenScale(5))
	OSU:CreateSubTitle("Song Select")
	OSU:Opt_CreateButton("Show thumbnails", "SongThumbnails")
	OSU:Opt_CreateButton("Check if map has more than one thumbnails", "MultiThumbnail")
	OSU:Opt_InsertGap(ScreenScale(5))
	OSU:CreateSubTitle("Detail Settings")
	OSU:Opt_CreateButton("Snaking sliders", "SnakingSliders")
	OSU:Opt_CreateButton("Don't draw slider's outlines", "SingleColorSlider")
	OSU:Opt_InsertGap(ScreenScale(5))
	OSU:CreateSubTitle("Downloader")
	OSU:Opt_CreateButton("Load beatmap cards", "LoadCards")
	OSU:CreateSectionTitle("GAMEPLAY")
	OSU:CreateSubTitle("General")
	OSU:Opt_CreateSlider("Background dim", "BackgroundDim", 0, 255)
	OSU:CreateSubTitle("Preview Image")
	OSU:CreatePreviewImage("BackgroundDim")
	OSU:Opt_CreateButton("Force default background", "ForceDefaultBG")
	OSU:Opt_CreateButton("Disable background flashing effect", "DisableFlash")
	OSU:Opt_CreateButton("Disable beat flashing on hitobjects", "DisableBeatFlash")
	OSU:Opt_CreateButton("Hit-error bar", "HitErrorBar")
	OSU:Opt_CreateButton("Show perfect hits", "PerfectHit")
	OSU:Opt_CreateButton("Followpoints", "CircleFollowPoint")
	OSU:Opt_InsertGap(ScreenScale(5))
	OSU:CreateSubTitle("Hit Objects")
	OSU:Opt_CreateButton("Smoother hitcircles", "SmoothHitCircle", function()
		if(OSU.SmoothHitCircle) then
			OSU:CenteredMessage("Turn it off if it's causing lag", 0.33)
		end
	end)
	OSU:Opt_InsertGap(ScreenScale(5))
	OSU:CreateSubTitle("Sounds")
	OSU:Opt_CreateButton("Replace hitfinish to hitwhistle", "FinishToWhistle")
	OSU:Opt_CreateButton("Disable combobreak sound", "NoBreakSound")
	OSU:Opt_CreateButton("Disable slider edge sound", "NoEdgeSound")
	OSU:Opt_CreateButton("Allow all edge sounds (WIP)", "AllowAllSounds")
	OSU:CreateString("*Enable this will make sliders play all possible sounds", Color(255, 255, 255, 255))
	OSU:CreateString("Some sounds might be desynced, since my brain is", Color(255, 255, 255, 255))
	OSU:CreateString("too small to figure out osu's sound system*", Color(255, 255, 255, 255))
	OSU:CreateSectionTitle("AUDIO")
	OSU:CreateSubTitle("Volume")
	OSU:Opt_CreateSlider("Music volume", "MusicVolume", 0, 2)
	OSU:Opt_CreateSlider("Hitsound volume", "HitSoundVolume", 0, 2)
	OSU:Opt_CreateSlider("Sound effect volume", "EffectVolume", 0, 2)
	OSU:CreateSectionTitle("SKIN")
	OSU:CreateSubTitle("Skins (Full skin support coming soon)")
	OSU:Opt_CreateSlider("Cursor size", "CursorSize", 1, 48)
	OSU:Opt_CreateButton("Cursor trail (Low performance)", "CursorTrail")
	OSU:Opt_CreateButton("Fill gap between cursor position", "FillCursorGap")
	OSU:Opt_CreateSlider("Trail lifetime", "CursorTrailLife", 0.02, 0.3)
	OSU:CreateSectionTitle("INPUT")
	OSU:CreateSubTitle("Mouse")
	OSU:Opt_CreateButton("Disable mouse buttons", "DisableMouse")
	OSU:CreateSectionTitle("CACHE")
	OSU:CreateSubTitle("Cached Datas")
	OSU:Opt_CreateClickButton("Clear all cached datas", function()
		OSU:ClearCaches()
	end)
	OSU:CreateString("Deleting cached data will cause longer load time!")
	local files = file.Find("osu!/cache/hitobjects/*.dat", "DATA")
	local mb = 0
	for k,v in next, files do
		mb = mb + file.Size("osu!/cache/hitobjects/"..v, "DATA")
	end
	mb = math.Round(mb / (1024 ^ 2), 2)
	OSU:CreateString("-- "..#files.." Beatmaps cached, Total of "..mb.." MB")
	OSU:CreateSectionTitle("DEBUG")
	OSU:CreateSubTitle("Sliders")
	OSU:Opt_CreateButton("Display connectpoints and curve type", "DevDisplaySliderConnectPoints")
	OSU:Opt_CreateClickButton("Output skin table", function()
		OSU:WriteSkinTable()
	end)
	OSU:Opt_CreateClickButton("Reload all fonts", function()
		OSU:InitFonts()
	end)
	OSU:Opt_InsertGap(ScreenScale(15))
	OSU:Opt_CreateTopTitle("Gmod osu! by Meika", 0, ScreenScale(3), "OSUOptionDesc", OSU.OptPink)
	OSU:Opt_CreateTopTitle("! Do not modify or reupload !", 0, ScreenScale(3), "OSUOptionDesc", Color(255, 55, 55, 255))
	OSU:Opt_InsertGap(ScreenScale(2))
	OSU:Opt_CreateTopTitle("Original game by peppy and osu! team", 0, ScreenScale(3), "OSUOptionDesc", Color(255, 255, 255, 255))
	OSU:Opt_CreateTopTitle("Download it at osu.ppy.sh", 0, ScreenScale(3), "OSUOptionDesc", Color(255, 255, 255, 255))
	OSU:Opt_InsertGap(ScreenScale(20))
	OSU:Opt_CreateImage("osu/internal/cardigan.png", ScreenScale(150), ScreenScale(224))
	OSU:Opt_CreateTopTitle("What are you looking for? :D", 0, ScreenScale(3), "OSUOptionTitle", Color(255, 255, 255, 255))
	OSU:Opt_CreateTopTitle("Cardigan <3", 0, ScreenScale(3), "OSUOptionDesc", Color(255, 255, 255, 255))
	OSU:Opt_InsertGap(ScreenScale(10))
	OSU.SliderBarScroll = 0
	OSU.SettingsScrollPanel:GetVBar():SetScroll(0)
end

function OSU:WriteConfigFile()
	local temp = {}
	for k,v in next, OSU.ConfigTable do
		temp[v] = OSU[v]
	end
	file.Write("osu!/config.txt", util.TableToJSON(temp))
end

function OSU:GetUserConfig()
	if(!file.Exists("osu!/config.txt", "DATA")) then
		OSU:WriteLog("Config not found!, writing..")
		OSU:WriteConfigFile()
	else
		local ctx = file.Read("osu!/config.txt", "DATA")
		local dat = util.JSONToTable(ctx)
		if(dat == nil) then
			OSU:WriteLog("Failed to read config file, rewrite a new one..")
			OSU:WriteConfigFile()
		else
			for k,v in next, dat do
				OSU[k] = v
			end
		end
	end
end