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

OSU.Translators = {
	["ja"] = "Daypark",
	["ru"] = "Berry",
	["tr"] = "Matt",
	["zh-CN"] = "Kliment",
}

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
	"UploadToLeaderboard",
	"Trans",
	"RGBTrail",
	"CursorTrailSize",
	"RGBRate",
	"Key1Code",
	"Key2Code",
	"CurrentSkinPath",
	"LoadSkinImage",
	"Load2x",
	"BetaSliders",
	"RevSnakingSliders",
	"DisplayPP",
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
OSU.EdgeFlash = true
OSU.MainBGDim = 200
OSU.SmoothBG = true
OSU.MenuSnow = true
OSU.NoEdgeSound = false
OSU.CircleFollowPoint = true
OSU.SmoothHitCircle = true
OSU.AllowAllSounds = true
OSU.LoadCards = true
OSU.DisableMouse = false
OSU.UploadToLeaderboard = true
OSU.RGBTrail = false
OSU.LoadSkinImage = false
OSU.CursorTrailSize = 8
OSU.RGBRate = 22.5
OSU.Load2x = false
OSU.BetaSliders = false
OSU.RevSnakingSliders = true
OSU.DisplayPP = false
OSU.ManiaKeys = {
	[1] = 29,	
	[2] = 14,	
	[3] = 16,	
	[4] = 17,	
	[5] = 18,	
	[6] = 20,	
	[7] = 20,	
	[8] = 20,	
	[9] = 20,	
	[10] = 20,	
}

OSU.MainVersion = "1.2.2"
OSU.AvatarVersion = "1.0.1"
OSU.BeatmapCacheVersion = "1.3.5"

function OSU:RestartGame()
	local fade = OSU:CreateFrame(nil, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 0), true)
	fade.iAlpha = 0
	fade.Switch = false
	fade.Think = function()
	if(!fade.Switch) then
		fade.iAlpha = math.Clamp(fade.iAlpha + OSU:GetFixedValue(20), 0, 255)
			if(fade.iAlpha >= 255) then
				OSU.MainGameFrame:Remove()
				OSU:Startup(true)
				OSU:OpenOptionsMenu()
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
		text:SetTextColor(Color(255, 255, 255, 255))
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
		text:SetTextColor(Color(220, 220, 220, 255))
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
	local logy = OSU:LookupTranslate("#STStatus").." : "..OSU:LookupTranslate("#STLoggedIn-Yes")
	local logn = OSU:LookupTranslate("#STStatus").." : "..OSU:LookupTranslate("#STLoggedIn-No")
		text:SetFont("OSUOptionDesc")
		local w, h = OSU:GetTextSize("OSUOptionDesc", "DummyText")
		text:SetSize(OSU.SettingsScrollPanel:GetWide(), h)
		text:SetPos(nextpos, (base:GetTall() - h) / 2)
		text:SetText(logy)
		text:SetTextColor(Color(220, 220, 220, 255))
		--[[
		base.Think = function()
			if(OSU.LoggedIn) then
				text:SetText(logy)
			else
				text:SetText(logn)
			end
		end
		]]
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
		base.text:SetTextColor(Color(220, 220, 220, 255))
		base.Think = func
end

function OSU:Opt_KeyRecorder()
	local base = OSU.SettingsScrollPanel:Add("DPanel")
	base.Switch = false
	base:SetWide(OSU.SettingsScrollPanel:GetWide())
	base:SetTall(ScreenScale(12))
	base:Dock(TOP)
	base.Paint = function()
		if(base.Switch) then
			draw.RoundedBox(8, ScreenScale(14), 0, 4, base:GetTall(), OSU.OptGlod)
		else
			draw.RoundedBox(8, ScreenScale(14), 0, 4, base:GetTall(), Color(90, 90, 90, 255))
		end
	end
	local str = OSU:LookupTranslate("#STCustomKeyboard")
	local nextpos = ScreenScale(20)
		base.text = base:Add("DLabel")
		base.text:SetFont("OSUOptionDesc")
		local w, h = OSU:GetTextSize("OSUOptionDesc", str)
		base.text:SetSize(OSU.SettingsScrollPanel:GetWide(), h)
		base.text:SetPos(nextpos, (base:GetTall() - h) / 2)
		base.text:SetText(str)
		base.text:SetTextColor(Color(220, 220, 220, 255))
		local gap = ScreenScale(1)
		local gap2x = gap * 2
		local x = base:GetWide() - ScreenScale(8)
		local w, h = ScreenScale(24), base:GetTall()
		local key1 = base:Add("DPanel")
			key1.Code = OSU.Key2Code
			key1.col = 0
			key1:SetKeyboardInputEnabled(true)
			key1.focused = false
			key1:SetSize(w, h)
			key1:SetX(x - w)
			key1.Think = function()
				if(key1:IsHovered()) then return end
				if(input.IsMouseDown(107)) then
					key1.focused = false
				end
			end
			key1.Paint = function()
				local col = 130 + key1.col
				if(key1.focused) then
					key1.col = math.Clamp(key1.col + OSU:GetFixedValue(30), 0, 120)
				else
					key1.col = math.Clamp(key1.col - OSU:GetFixedValue(30), 0, 120)
				end
				col = 130 + key1.col
				surface.SetDrawColor(0, 0, 0, 225)
				surface.DrawRect(0, 0, w, h)
				surface.SetDrawColor(col, col, col, 200)
				surface.DrawOutlinedRect(0, 0, w, h, gap)
				draw.DrawText(input.GetKeyName(key1.Code), "OSUOptionDesc", w / 2, 0, Color(255, 255, 255, 200), TEXT_ALIGN_CENTER)
			end
			function key1:OnKeyCodePressed(keyCode)
				if(!key1.focused) then return end
				OSU.Key2Code = keyCode
				key1.Code = OSU.Key2Code
				OSU:WriteConfigFile()
				key1.focused = false
			end 
			function key1:OnMousePressed()
				key1:RequestFocus()
				key1.focused = true
			end
		local key2 = base:Add("DPanel")
			key2.Code = OSU.Key1Code
			key2.col = 0
			key2:SetKeyboardInputEnabled(true)
			key2.focused = false
			key2:SetSize(w, h)
			key2:SetX(x - ((w * 2) + gap2x))
			key2.Think = function()
				if(key2:IsHovered()) then return end
				if(input.IsMouseDown(107)) then
					key2.focused = false
				end
			end
			key2.Paint = function()
				local col = 130 + key2.col
				if(key2.focused) then
					key2.col = math.Clamp(key2.col + OSU:GetFixedValue(30), 0, 120)
				else
					key2.col = math.Clamp(key2.col - OSU:GetFixedValue(30), 0, 120)
				end
				col = 130 + key2.col
				surface.SetDrawColor(0, 0, 0, 225)
				surface.DrawRect(0, 0, w, h)
				surface.SetDrawColor(col, col, col, 200)
				surface.DrawOutlinedRect(0, 0, w, h, gap)
				draw.DrawText(input.GetKeyName(key2.Code), "OSUOptionDesc", w / 2, 0, Color(255, 255, 255, 200), TEXT_ALIGN_CENTER)
			end
			function key2:OnKeyCodePressed(keyCode)
				if(!key2.focused) then return end
				OSU.Key1Code = keyCode
				key2.Code = OSU.Key1Code
				OSU:WriteConfigFile()
				key2.focused = false
			end 
			function key2:OnMousePressed()
				key2:RequestFocus()
				key2.focused = true
			end
end

function OSU:Opt_CreateDropDown(str, opt, options)
	local base = OSU.SettingsScrollPanel:Add("DPanel")
	local gap = ScreenScale(2)
	local gap2x = gap * 2
	base.Switch = false
	base:SetTall(ScreenScale(14))
	base:SetWide(OSU.SettingsScrollPanel:GetWide())
	base:Dock(TOP)
	base.Paint = function()
		if(base.Switch) then
			draw.RoundedBox(8, ScreenScale(14), 0, 4, base:GetTall(), OSU.OptGlod)
		else
			draw.RoundedBox(8, ScreenScale(14), 0, 4, base:GetTall(), Color(90, 90, 90, 255))
		end
	end
	function base:OnCursorEntered()
		OSU:PlaySoundEffect(OSU.CurrentSkin["click-short"])
	end
	local nextpos = ScreenScale(20)
	local dstr = str.." : "
	local text = base:Add("DLabel")
		text:SetFont("OSUOptionDesc")
		local w, h = OSU:GetTextSize("OSUOptionDesc", dstr)
		text:SetText(dstr)
		text:SetSize(w, h)
		text:SetPos(nextpos, ((base:GetTall() - h) / 2))
		text:SetTextColor(Color(220, 220, 220, 255))
		nextpos = nextpos + w + gap
		local value = "Undefined"
		for k,v in next, options do
			if(OSU[opt] == v) then
				value = k
			end
		end
		local dcombo = base:Add("OSUComboBox")
			dcombo:SetSize(base:GetWide() - (nextpos + ScreenScale(8)), base:GetTall() - gap)
			dcombo:SetPos(nextpos, gap / 2)
			dcombo:SetValue(value)
			dcombo:SetFont("OSUOptionDesc")
			dcombo:SetTextColor(Color(255, 255, 255, 255))
			for k,v in next, options do
				dcombo:AddChoice(k)
			end
			function dcombo:OnSelect(index, text, data)
				OSU[opt] = options[text]
				OSU:WriteConfigFile()
				OSU:RestartGame()
				OSU:PlaySoundEffect(OSU.CurrentSkin["menu-direct-click"])
			end
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
		text:SetTextColor(Color(220, 220, 220, 255))
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
		text:SetTextColor(Color(220, 220, 220, 255))
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
			OSU:CacheAudios()
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
		text:SetTextColor(Color(220, 220, 220, 255))
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
			OSU:CacheAudios()
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
		text:SetTextColor(Color(220, 220, 220, 255))
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
		text:SetTextColor(Color(220, 220, 220, 255))
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
			label:SetTextColor(Color(220, 220, 220, 255))
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
	OSU:Opt_CreateTopTitle(OSU:LookupTranslate("#STOptions"), ScreenScale(30), ScreenScale(3), "OSUOptionTitle", Color(255, 255, 255, 255))
	OSU:Opt_CreateTopTitle(OSU:LookupTranslate("#STBeheaves"), 0, ScreenScale(3), "OSUOptionDesc", OSU.OptPink)
	OSU:Opt_CreateTopTitle("Gmod osu! v"..OSU.MainVersion.." build", 0, ScreenScale(20), "OSUBeatmapDetails", Color(255, 255, 255, 255))
	OSU:CreateSectionTitle(OSU:LookupTranslate("#STIdentify"))
	OSU:CreateSubTitle(OSU:LookupTranslate("#STSignIn"))
	OSU:CreateStatusString()
	OSU:CreateFlashObject()
	--[[
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
	]]
	OSU:CreateCustomString("Current User : ", function(self)
		if(!IsValid(self.text)) then return end
		self.text:SetText(OSU:LookupTranslate("#STWelcome").." "..LocalPlayer():Nick())
		self.text:SetTextColor(Color(200, 255, 200))
	end)
	OSU:CreateSectionTitle(OSU:LookupTranslate("#STLeaderboard"))
	OSU:CreateSubTitle(OSU:LookupTranslate("#STLName"))
	OSU:Opt_CreateButton(OSU:LookupTranslate("#STSteamName"), "SteamName")
	OSU:CreateTextEntry(OSU:LookupTranslate("#STCustomName"), "UserName", "SteamName")
	OSU:Opt_CreateButton(OSU:LookupTranslate("#STNoAvatar"), "NoAvatar")
	OSU:Opt_CreateButton(OSU:LookupTranslate("#STAvatarFrame"), "LoadFrame")
	OSU:Opt_CreateButton(OSU:LookupTranslate("#STSentScore"), "UploadToLeaderboard")
	--OSU:CreateString("*Leaderboard is not available unless you logged in!*", Color(255, 150, 150, 255))
	OSU:CreateSectionTitle(OSU:LookupTranslate("#STGeneral"))
	OSU:CreateSubTitle(OSU:LookupTranslate("#STLanguage"))
	local langTable = {
		["English"] = "en",
		["繁體中文"] = "zh-TW",
		["简体中文"] = "zh-CN",
		["日本語"] = "ja",
		["Русский"] = "ru",
		["Türkçe"] = "tr",
	}
	OSU:Opt_CreateDropDown(OSU:LookupTranslate("#STDisplayLanguage"), "Trans", langTable)
	if(OSU.Trans != "en" && OSU.Trans != "zh-TW") then
		local name = OSU.Translators[OSU.Trans]
		if(name != nil) then
			OSU:CreateString("*Special thanks to "..name.." for the translate*", OSU.OptPink)
		end
	end
	OSU:CreateString("*Add Meiryi on steam if you want to translate it", Color(255, 255, 255, 255)) 
	OSU:CreateString("to other language*", Color(255, 255, 255, 255))
	OSU:Opt_CreateBNameButton(OSU:LookupTranslate("#STMetaString").." (Map Name)")
	OSU:Opt_CreateANameButton(OSU:LookupTranslate("#STMetaString").." (Artist Name)")
	OSU:CreateSectionTitle(OSU:LookupTranslate("#STGraphics"))
	OSU:CreateSubTitle(OSU:LookupTranslate("#STRenderer"))
	OSU:Opt_CreateButton(OSU:LookupTranslate("#STFPS"), "FPSCounterEnabled")
	OSU:Opt_CreateButton(OSU:LookupTranslate("#STBlur"), "BlurShader")
	OSU:Opt_InsertGap(ScreenScale(5))
	OSU:CreateSubTitle(OSU:LookupTranslate("#STPerformance"))
	OSU:Opt_CreateButton(OSU:LookupTranslate("#STNoRender"), "WorldRender")
	OSU:Opt_CreateButton(OSU:LookupTranslate("#STWriteCache"), "WriteObjectFile")
	OSU:Opt_InsertGap(ScreenScale(5))
	OSU:CreateSubTitle(OSU:LookupTranslate("#STMainMenu"))
	OSU:Opt_CreateSlider(OSU:LookupTranslate("#STMenuDim"), "MainBGDim", 0, 255)
	OSU:CreatePreviewImage("MainBGDim")
	OSU:Opt_CreateButton(OSU:LookupTranslate("#STSmoothBG"), "SmoothBG", function()
		if(OSU.SmoothBG) then
			OSU.Background.Tx = Material(OSU.Background:GetImage(), "smooth")
		else
			OSU.Background.Tx = Material(OSU.Background:GetImage())
		end
	end)
	OSU:Opt_CreateButton(OSU:LookupTranslate("#STInterfaceSound"), "InterfaceVoice")
	OSU:Opt_CreateButton(OSU:LookupTranslate("#STTheme"), "ThemeMusic")
	OSU:Opt_CreateButton(OSU:LookupTranslate("#STEdgeFlash"), "EdgeFlash")
	OSU:Opt_CreateButton(OSU:LookupTranslate("#STMenuSnow"), "MenuSnow")
	OSU:Opt_InsertGap(ScreenScale(5))
	OSU:CreateSubTitle(OSU:LookupTranslate("#STSelectSong"))
	OSU:Opt_CreateButton(OSU:LookupTranslate("#STShowThumbnails"), "SongThumbnails")
	OSU:Opt_CreateButton(OSU:LookupTranslate("#STCheckThumbnails"), "MultiThumbnail")
	OSU:Opt_InsertGap(ScreenScale(5))
	OSU:CreateSubTitle(OSU:LookupTranslate("#STDetails"))
	OSU:Opt_CreateButton(OSU:LookupTranslate("#STSnaking"), "SnakingSliders")
	OSU:Opt_CreateButton(OSU:LookupTranslate("#STNoOutline"), "SingleColorSlider")
	OSU:Opt_InsertGap(ScreenScale(5))
	OSU:CreateSubTitle(OSU:LookupTranslate("#STDownloader"))
	OSU:Opt_CreateButton(OSU:LookupTranslate("#STCards"), "LoadCards")
	OSU:CreateSectionTitle(OSU:LookupTranslate("#STGameplay"))
	OSU:CreateSubTitle(OSU:LookupTranslate("#STGeneral"))
	OSU:Opt_CreateSlider(OSU:LookupTranslate("#STBGDim"), "BackgroundDim", 0, 255)
	OSU:CreatePreviewImage("BackgroundDim")
	OSU:Opt_CreateButton(OSU:LookupTranslate("#STForceBG"), "ForceDefaultBG")
	OSU:Opt_CreateButton(OSU:LookupTranslate("#STNoBGFlash"), "DisableFlash")
	OSU:Opt_CreateButton(OSU:LookupTranslate("#STNoOBJFlash"), "DisableBeatFlash")
	OSU:Opt_CreateButton(OSU:LookupTranslate("#STHitError"), "HitErrorBar")
	OSU:Opt_CreateButton(OSU:LookupTranslate("#STPerfectHit"), "PerfectHit")
	OSU:Opt_CreateButton(OSU:LookupTranslate("#STFPoint"), "CircleFollowPoint")
	OSU:Opt_InsertGap(ScreenScale(5))
	OSU:CreateSubTitle(OSU:LookupTranslate("#STHObject"))
	OSU:Opt_CreateButton(OSU:LookupTranslate("#STSmoothObj"), "SmoothHitCircle", function()
		if(OSU.SmoothHitCircle) then
			OSU:CenteredMessage("Turn it off if it's causing lag", 0.33)
		end
	end)
	OSU:Opt_InsertGap(ScreenScale(5))
	OSU:CreateSubTitle(OSU:LookupTranslate("#STSounds"))
	--OSU:Opt_CreateButton("Replace hitfinish to hitwhistle", "FinishToWhistle")
	OSU:Opt_CreateButton(OSU:LookupTranslate("#STNoComboBreak"), "NoBreakSound")
	OSU:Opt_CreateButton(OSU:LookupTranslate("#STNoEdgeSound"), "NoEdgeSound")
	OSU:Opt_CreateButton(OSU:LookupTranslate("#STAllEdgeSound"), "AllowAllSounds")
	--OSU:CreateString("*Enable this will make sliders play all possible sounds", Color(255, 255, 255, 255))
	--OSU:CreateString("Some sounds might be desynced, since my brain is", Color(255, 255, 255, 255))
	--OSU:CreateString("too small to figure out osu's sound system*", Color(255, 255, 255, 255))
	OSU:CreateSectionTitle(OSU:LookupTranslate("#STAudio"))
	OSU:CreateSubTitle(OSU:LookupTranslate("#STVolume"))
	OSU:Opt_CreateSlider(OSU:LookupTranslate("#STMVol"), "MusicVolume", 0, 2)
	OSU:Opt_CreateSlider(OSU:LookupTranslate("#STHVol"), "HitSoundVolume", 0, 2)
	OSU:Opt_CreateSlider(OSU:LookupTranslate("#STEVol"), "EffectVolume", 0, 2)
	OSU:CreateSectionTitle(OSU:LookupTranslate("#STSkin"))
	OSU:CreateSubTitle(OSU:LookupTranslate("#STSkins"))
	local skinTable = {}
	local f, d = file.Find("osu!/skins/*", "DATA")
	for k,v in next, d do
		skinTable[v] = v
	end
	OSU:Opt_CreateDropDown("Skin > ", "CurrentSkinPath", skinTable)
	--OSU:Opt_CreateButton(OSU:LookupTranslate("#STTestSlider"), "BetaSliders")
	OSU:Opt_CreateButton(OSU:LookupTranslate("#STLoadSkinImage"), "LoadSkinImage")
	OSU:Opt_CreateButton(OSU:LookupTranslate("#STCursorTrail"), "CursorTrail")
	OSU:Opt_CreateButton(OSU:LookupTranslate("#STCursorTrailGap"), "FillCursorGap")
	OSU:Opt_CreateButton(OSU:LookupTranslate("#STCursorTrailRGB"), "RGBTrail", function()
		if(OSU.RGBTrail) then
			OSU.CurTrailMat = Material("osu/internal/rbgtrail.png", "smooth")
		else
			OSU.CurTrailMat = Material(OSU.CurrentSkin["cursortrail"], "smooth")
		end
	end)
	OSU:Opt_CreateSlider(OSU:LookupTranslate("#STCursorSize"), "CursorSize", 1, 48)
	OSU:Opt_CreateSlider(OSU:LookupTranslate("#STCursorTrailSize"), "CursorTrailSize", 1, 48)
	OSU:Opt_CreateSlider(OSU:LookupTranslate("#STRGBRate"), "RGBRate", 1, 360)
	OSU:Opt_CreateSlider(OSU:LookupTranslate("#STCursorTrailLife"), "CursorTrailLife", 0.02, 0.3)
	OSU:CreateSectionTitle(OSU:LookupTranslate("#STInput"))
	OSU:CreateSubTitle(OSU:LookupTranslate("#STMouse"))
	OSU:Opt_CreateButton(OSU:LookupTranslate("#STDisableMouse"), "DisableMouse")
	OSU:Opt_InsertGap(ScreenScale(5))
	OSU:CreateSubTitle(OSU:LookupTranslate("#STKeyboard"))
	OSU:Opt_KeyRecorder()
	OSU:CreateSectionTitle(OSU:LookupTranslate("#STCache"))
	OSU:CreateSubTitle(OSU:LookupTranslate("#STCached"))
	OSU:Opt_CreateClickButton(OSU:LookupTranslate("#STClearCache"), function()
		OSU:ClearCaches()
	end)
	OSU:CreateString(OSU:LookupTranslate("#STCacheWarning"))
	local files = file.Find("osu!/cache/hitobjects/*.dat", "DATA")
	local mb = 0
	for k,v in next, files do
		mb = mb + file.Size("osu!/cache/hitobjects/"..v, "DATA")
	end
	mb = math.Round(mb / (1024 ^ 2), 2)
	OSU:CreateString("-- "..#files.." Cached, ~"..mb.." MB")
	OSU:CreateSectionTitle(OSU:LookupTranslate("#STDebug"))
	OSU:CreateSubTitle(OSU:LookupTranslate("#STDSlider"))
	OSU:Opt_CreateButton(OSU:LookupTranslate("#STDConnect"), "DevDisplaySliderConnectPoints")
	OSU:Opt_CreateClickButton("Output skin table", function()
		OSU:WriteSkinTable()
	end)
	OSU:Opt_CreateClickButton("Reload all fonts", function()
		OSU:InitFonts()
	end)
	OSU:Opt_InsertGap(ScreenScale(5))
	OSU:CreateSubTitle("Peformance Points")
	OSU:Opt_CreateButton("Display PP details", "DisplayPP")
	OSU:Opt_InsertGap(ScreenScale(15))
	OSU:Opt_CreateTopTitle("Gmod osu! by Meiryi", 0, ScreenScale(3), "OSUOptionDesc", OSU.OptPink)
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