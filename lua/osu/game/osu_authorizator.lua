OSU.ClientToken = ""
OSU.LoggedIn = false
OSU.CheckingToken = false

function OSU:IsFirstLogin()
	return !file.Exists("osu!/cache/login.dat", "DATA")
end

function OSU:GetTokenFile()
	local token = file.Read("osu!/cache/token.dat", "DATA")
	if(token == nil) then
		return false
	else
		return true
	end
end

function OSU:SetupLoginPage()
	if(IsValid(OSU.LoginPanel)) then
		OSU.LoginPanel:Remove()
	end
	OSU.LoginPanel = OSU:CreateFrame(OSU.MainGameFrame, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 0), true)
	local uppLayer = OSU:CreateFrame(OSU.LoginPanel, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 0), true)
	local h = ScreenScale(40)
	uppLayer.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrW(), h, Color(0, 0, 0, 200))
		draw.RoundedBox(0, 0, ScrH() - h, ScrW(), h, Color(0, 0, 0, 200))
	end
	local gap = ScreenScale(1)
	local gap2x = gap * 2
	local gap4x = gap * 4
	local textpadding = ScreenScale(15)
	local bg = OSU.LoginPanel:Add("DImage")
		bg:SetImage(OSU.CurrentSkin["menu-background"])
		bg:SetSize(ScrW(), ScrH())
		bg:SetImageColor(Color(180, 180, 180, 255))
		local pw, ph = ScreenScale(200), ScreenScale(200)
		local panel = OSU:CreateFrame(uppLayer, (ScrW() / 2) - (pw / 2), (ScrH() / 2) - (ph / 2), pw, ph, Color(0, 0, 0, 200), true)
		local sw = panel:GetWide() * 0.65
		local sh = sw * 0.504
		panel.Paint = function()
			draw.RoundedBox(ScreenScale(10), 0, 0, pw, ph, Color(20, 20, 20, 200))
			draw.DrawText("Login?", "OSUBeatmapTitle", pw / 2, gap2x, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			draw.DrawText("After logged in, you can upload your score to\nleaderboard for others to see\nyou only need to login once!\n*Login for non-x64 users has been fixed*", "OSUBeatmapDetails", pw / 2, textpadding, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			draw.DrawText("You can login at anytime on settings panel", "OSUBeatmapDetails", pw / 2, ph - textpadding, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(OSU.UnloggedTx)
			surface.DrawTexturedRect((pw / 2) - sw / 2, (ph / 2) - sh / 2, sw, sh)
		end
		local bw, bh = ScreenScale(140), ScreenScale(20) 
		OSU:CreateClickableButton(panel, pw / 2, ph - (textpadding + (bh * 2) + gap2x), bw, bh, true, "Login with Steam",
			function() 
				OSU:AuthorizeToken(-2)
				OSU.LoginPanel:Remove()
			end)
		OSU:CreateClickableButton(panel, pw / 2, ph - (textpadding + bh), bw, bh, true, "No Thanks",
			function() 
				local fade = OSU:CreateFrame(nil, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 0), true)
				fade.iAlpha = 0
				fade.Switch = false
				fade.Think = function()
					if(!fade.Switch) then
						fade.iAlpha = math.Clamp(fade.iAlpha + OSU:GetFixedValue(20), 0, 255)
						if(fade.iAlpha >= 255) then
							OSU.LoginPanel:Remove()
							fade.Switch = true
						end
					else
						fade.iAlpha = math.Clamp(fade.iAlpha - OSU:GetFixedValue(20), 0, 255)
						if(fade.iAlpha <= 0) then
							fade:Remove()
						end
					end
				end
			end)
end

function OSU:WriteToken()
	file.Write("osu!/cache/token.dat", OSU.ClientToken)
	if(IsValid(OSU.AuthPanel)) then OSU.AuthPanel:Remove() end
	if(IsValid(OSU.MainGameFrame)) then
		if(OSU.UserBanned) then
			OSU:CenteredMessage("You are banned, appeal your ban in discord server!", 1)
		else
			OSU:CenteredMessage("Logged in as "..LocalPlayer():Nick(), 1)
			OSU:FetchUserData()
		end
		if(OSU.MENU_STATE == OSU_MENU_STATE_BEATMAP) then
			if(IsValid(OSU.PlayMenuLayer)) then
				OSU:CreateBackButton(OSU.PlayMenuLayer, OSU_MENU_STATE_MAIN)
			end
		end
	end
end

function OSU:AuthorizeToken(toState) 
	if(IsValid(OSU.AuthPanel)) then
		OSU.AuthPanel:Remove()
	end
	local sx = ScreenScale(80)
	OSU.AuthPanel = OSU:CreateFrame(OSU.MainGameFrame, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 255), true)
	OSU.AuthPanel.iAlpha = 0
	OSU.AuthPanel.Rotate = 0
	OSU.AuthPanel.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 255))
		OSU.AuthPanel.iAlpha = math.Clamp(OSU.AuthPanel.iAlpha + OSU:GetFixedValue(40), 0, 255)
		OSU.AuthPanel.Rotate = math.Clamp(OSU.AuthPanel.Rotate + OSU:GetFixedValue(3), 0, 360)
		if(OSU.AuthPanel.Rotate >= 360) then
			OSU.AuthPanel.Rotate = 0
		end
		if(BRANCH == "x86-64") then
			draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, OSU.AuthPanel.iAlpha))
			surface.SetDrawColor(255, 255, 255, OSU.AuthPanel.iAlpha / 2)
			surface.SetMaterial(OSU.LoadingTx)
			surface.DrawTexturedRectRotated(ScrW() / 2, ScrH() / 2, sx, sx, OSU.AuthPanel.Rotate)
		else
			surface.SetDrawColor(255, 255, 255, OSU.AuthPanel.iAlpha / 2)
			surface.SetMaterial(OSU.TutorialTx)
			surface.DrawTexturedRect(0, ScrH() / 2, ScrW(), ScrH() / 2)
			draw.DrawText("Put your token here to login!", "OSUBeatmapTitle", ScrW() / 2, ScrH() * 0.175, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			draw.DrawText("Auto token verify doesn't work on x32, so you have to do it manually!\nsee the tutorial below.", "OSUBeatmapDetails", ScrW() / 2, ScreenScale(3), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		end
	end
	if(BRANCH == "x86-64") then
	local ctx = vgui.Create("DHTML", OSU.AuthPanel)
		ctx:Dock(FILL)
		ctx:OpenURL("https://osu.gmaniaserv.xyz/token/TokenAuth.php")
		ctx:SetAllowLua(true)
		OSU:CreateBackButton(ctx, OSU_MENU_STATE_MAIN, true, function()
			if(toState == OSU_MENU_STATE_BEATMAP) then
				if(IsValid(OSU.PlayMenuLayer)) then
					OSU:CreateBackButton(OSU.PlayMenuLayer, OSU_MENU_STATE_MAIN)
				end
			end
			if(toState == -1) then
				OSU:CreateBackButton(OSU.RankingPanel, OSU_MENU_STATE_MAIN, true, function()
					if(IsValid(OSU.PlayMenuLayer)) then
						OSU:CreateBackButton(OSU.PlayMenuLayer, OSU_MENU_STATE_MAIN)
					end
					OSU.RankingPanel:Remove()
				end, 0)
			end
			OSU.AuthPanel:Remove()
		end, ScreenScale(15))
	else
		local bw, bh = ScreenScale(200), ScreenScale(20) 
		OSU:CreateClickableButton(OSU.AuthPanel, ScrW() / 2, ScrH() * 0.45, bw, bh, true, "Click here if it url didn't open",
		function() 
			gui.OpenURL("https://osu.gmaniaserv.xyz/token/TokenAuth.php")
		end)
		local textentry = OSU:CreateTextEntryPanel(OSU.AuthPanel, ScrW() / 2, ScrH() * 0.25, bw, bh, true)
		textentry:SetPlaceholderText("Put token here")
		textentry:SetPlaceholderColor(Color(100, 100, 100, 100))
		local btn = OSU:CreateClickableButton(OSU.AuthPanel, ScrW() / 2, ScrH() * 0.325, bw, bh, true, "Submit token",
		function() 
			if(string.len(textentry:GetValue()) <= 24 || OSU.CheckingToken) then return end
			OSU:CheckTokenManual(textentry:GetValue())
		end)
		btn.Think = function()
			if(OSU.CheckingToken) then
				btn:SetText("Verifying token..")
			else
				btn:SetText("Submit token")
			end
		end
		gui.OpenURL("https://osu.gmaniaserv.xyz/token/TokenAuth.php")
		OSU:CreateBackButton(OSU.AuthPanel, OSU_MENU_STATE_MAIN, true, function()
			if(toState == OSU_MENU_STATE_BEATMAP) then
				if(IsValid(OSU.PlayMenuLayer)) then
					OSU:CreateBackButton(OSU.PlayMenuLayer, OSU_MENU_STATE_MAIN)
				end
			end
			if(toState == -1) then
				OSU:CreateBackButton(OSU.RankingPanel, OSU_MENU_STATE_MAIN, true, function()
					if(IsValid(OSU.PlayMenuLayer)) then
						OSU:CreateBackButton(OSU.PlayMenuLayer, OSU_MENU_STATE_MAIN)
					end
					OSU.RankingPanel:Remove()
				end, 0)
			end
			OSU.AuthPanel:Remove()
		end, 0)
	end
end

function OSU:CheckTokenManual(token)
	OSU.LoggedIn = false
	OSU.CheckingToken = true
	if(token == nil) then OSU.UserBanned = false return end
		http.Post("https://osu.gmaniaserv.xyz/token/VerifyToken.php", {token = token},
			function(body, length, headers, code)
				if(string.find(body, "BANNED")) then
					OSU.UserBanned = true
					OSU.LoggedIn = true
					if(IsValid(OSU.AuthPanel)) then
						OSU.AuthPanel:Remove()
					end
					OSU.ClientToken = token
					OSU:WriteToken()
				else
					if(body == "PASS") then
						OSU.UserBanned = false
						OSU.ClientToken = token
						OSU.LoggedIn = true
						OSU:FetchUserData()
						if(IsValid(OSU.AuthPanel)) then
							OSU.AuthPanel:Remove()
						end
						OSU.ClientToken = token
						OSU:WriteToken()
					end
					if(body == "NON-EXIST") then
						OSU:CenteredMessage("Invalid token (Error code : "..body..")")
					end
				end
				OSU.CheckingToken = false
			end,

			function(message)
				OSU.CheckingToken = false
			end
		)
end

function OSU:CheckToken()
	OSU.LoggedIn = false
	OSU.CheckingToken = true
	local token = file.Read("osu!/cache/token.dat", "DATA")
	if(token == nil) then OSU.UserBanned = false return end
		http.Post("https://osu.gmaniaserv.xyz/token/VerifyToken.php", {token = token},
			function(body, length, headers, code)
				if(string.find(body, "BANNED")) then
					OSU.UserBanned = true
					OSU.LoggedIn = true
				else
					if(body == "PASS") then
						OSU.UserBanned = false
						OSU.ClientToken = token
						OSU.LoggedIn = true
						OSU:FetchUserData()
					end
					if(body == "NON-EXIST") then
						OSU:CenteredMessage("Invalid token (Error code : "..body..")")
					end
				end
				OSU.CheckingToken = false
			end,

			function(message)
				OSU.CheckingToken = false
			end
		)
end