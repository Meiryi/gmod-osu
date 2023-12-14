OSU.RankingList = {}
OSU.PlayerNameList = {}
OSU.PendingNameRequests = {}

function OSU:InsertNameRequest(steamid64)
	table.insert(OSU.PendingNameRequests, steamid64)
end

function OSU:SetupRankingPanel(toState, parent)
	OSU.RankingPanel = OSU:CreateFrame(parent, 0, 0, ScrW(), ScrH(), Color(27, 23, 25, 255), false)
	local topPadding = ScrH() * 0.25
	local sidePadding = ScrW() * 0.15
	local titleHeight = ScreenScale(24)
	local detailPos = titleHeight - ScreenScale(10)
	local scrollX = sidePadding
	local scrollWideX = sidePadding + (ScrW() - sidePadding * 2)
	local rankpad = scrollWideX - ScreenScale(2)
	local namepad = scrollX + ScreenScale(30)
	local scorepad = scrollX + ScreenScale(270)
	local accuracypad = scrollX + ScreenScale(330)
	local playspad = scrollX + ScreenScale(380)
	local topbg = OSU.RankingPanel:Add("DImage")
		topbg:SetSize(ScrW(), ScrH())
		topbg:SetImage(OSU.CurrentSkin["menu-background"])
		topbg:SetImageColor(Color(125, 125, 125, 255))
		topbg:SetY((-ScrH() / 2) + topPadding / 2)
	local topbgDraw = OSU.RankingPanel:Add("DImage")
		topbgDraw:SetSize(ScrW(), topPadding)
		topbgDraw.Paint = function()
			if(OSU.UserBanned || OSU.LoggedIn) then return end
			draw.DrawText("Want your name on leaderboard?", "OSULeaderboardRankingTitle", topbgDraw:GetWide() / 2, topbgDraw:GetTall() / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		end
		local gap = ScreenScale(1)
		local gap2x = gap * 2
		local LoginBtn  = OSU.RankingPanel:Add("DButton")
			LoginBtn:SetSize(ScrW() * 0.4, ScreenScale(16))
			LoginBtn:SetPos((ScrW() / 2) - LoginBtn:GetWide() / 2, (topPadding / 1.3) - LoginBtn:GetTall() / 2)
			LoginBtn:SetFont("OSUBeatmapTitle")
			LoginBtn:SetText("Login with steam")
		local _w, _h = LoginBtn:GetSize()
		LoginBtn.Paint = function()
			draw.RoundedBox(0, 0, 0, _w, _h, Color(0, 0, 0, 255))
			draw.RoundedBox(0, gap, gap, _w - gap2x, _h - gap2x, OSU.OptBlue)
			if(OSU.UserBanned || OSU.LoggedIn) then
				LoginBtn:Remove()
			end
		end
		LoginBtn.DoClick = function()
			OSU:AuthorizeToken(-1)
		end
	local topfade = OSU.RankingPanel:Add("DImage")
		topfade:SetSize(ScrW(), ScreenScale(30))
		topfade:SetImage("osu/internal/fade_down.png")
		topfade:SetImageColor(Color(199, 60, 92, 100))
	local bottomblock = OSU:CreateFrame(OSU.RankingPanel, 0, topPadding, ScrW(), ScrH() - (topPadding), Color(27, 23, 25, 255), false)
	OSU.RankingPanelScroll = OSU:CreateScrollPanel(OSU.RankingPanel, sidePadding, topPadding + titleHeight, ScrW() - sidePadding * 2, ScrH() - (topPadding + titleHeight), Color(57, 42, 50, 255))
	local titleBlock = OSU:CreateFrame(OSU.RankingPanel, 0, topPadding, ScrW(), titleHeight, Color(41, 31, 37, 255), false)
		titleBlock.Paint = function()
			draw.RoundedBox(0, 0, 0, titleBlock:GetWide(), titleBlock:GetTall(), Color(41, 31, 37, 255))
			draw.DrawText("Ranking Leaderboard", "OSULeaderboardRankingTitle", titleBlock:GetWide() / 2, ScreenScale(2), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			draw.DrawText("Player name", "OSULeaderboardRankingDetails", namepad, detailPos, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
			draw.DrawText("Ranking", "OSULeaderboardRankingDetails", rankpad, detailPos, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)
			draw.DrawText("Ranking Score", "OSULeaderboardRankingDetails", scorepad, detailPos, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			draw.DrawText("Accuracy", "OSULeaderboardRankingDetails", accuracypad, detailPos, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			draw.DrawText("Total Plays", "OSULeaderboardRankingDetails", playspad, detailPos, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		end
	OSU:CreateBackButton(OSU.RankingPanel, OSU_MENU_STATE_MAIN, true, function()
		if(toState == OSU_MENU_STATE_BEATMAP) then
			if(IsValid(OSU.PlayMenuLayer)) then
				OSU:CreateBackButton(OSU.PlayMenuLayer, OSU_MENU_STATE_MAIN)
			end
		end
		OSU.RankingPanel:Remove()
	end, 0)
	local rotate = 0
	local fetching = true
	local error = false
	local sx = ScreenScale(40)
	local currentscroll = 0
	local maxscroll = 0
	OSU.RankingPanelScroll.Paint = function()
		maxscroll = OSU.RankingPanelScroll:GetVBar().CanvasSize
		draw.RoundedBox(0, 0, 0, OSU.RankingPanelScroll:GetWide(), OSU.RankingPanelScroll:GetWide(), Color(57, 42, 50, 255))
		if(fetching) then
			rotate = math.Clamp(rotate + OSU:GetFixedValue(2), 0, 360)
			if(rotate >= 360) then rotate = 0 end
			surface.SetDrawColor(255, 255, 255, 100)
			surface.SetMaterial(OSU.LoadingTx)
			surface.DrawTexturedRectRotated(OSU.RankingPanelScroll:GetWide() / 2, OSU.RankingPanelScroll:GetTall() / 2, sx, sx, rotate)
		else
			if(error) then
				draw.DrawText("Something went wrong!", "OSULeaderboardRankingTitle", OSU.RankingPanelScroll:GetWide() / 2, OSU.RankingPanelScroll:GetTall() / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			end
		end
	end
	function OSU.RankingPanelScroll:OnMouseWheeled(scrollDelta)
		currentscroll = math.Clamp(currentscroll - (ScreenScale(80 * scrollDelta)), 0, maxscroll)
	end
	OSU.RankingPanelScroll.Think = function()
		if(scroll == 0) then return end
		local scroll = OSU.RankingPanelScroll:GetVBar()
		if(scroll:GetScroll() != currentscroll) then
			local smooth = math.abs(currentscroll - scroll:GetScroll())
			if(scroll:GetScroll() < currentscroll) then
				scroll:SetScroll(math.Clamp(scroll:GetScroll() + OSU:GetFixedValue(smooth * 0.15), 0, maxscroll))
			else
				scroll:SetScroll(math.Clamp(scroll:GetScroll() - OSU:GetFixedValue(smooth * 0.15), 0, maxscroll))
			end
		end
	end
	local sbar = OSU.RankingPanelScroll:GetVBar()
	sbar:SetWide(ScreenScale(2))
	function sbar.btnUp:Paint(w, h) return end
	function sbar.btnDown:Paint(w, h) return end
	function sbar:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
	end
	function sbar.btnGrip:Paint(w, h)
		draw.RoundedBox(5, 0, 0, w, h, Color(255, 255, 255, 150))
	end

	local names = file.Read(OSU.CachePath.."names.txt", "DATA")
	if(names == nil) then
		OSU:WriteLog("Failed to read name cache file")
	else
		local dat = util.JSONToTable(names)
		if(dat != nil) then
			OSU.PlayerNameList = dat
		else
			OSU:WriteLog("Cached name file returned nil")
		end
	end

	local h = ScreenScale(25)
	local _h = h * 0.8
	local gap = ScreenScale(1)
	local gap2 = ScreenScale(6)
	local gap3 = ScreenScale(3)
	local textpad = ScreenScale(6.5)
	local scorepad = ScreenScale(270)
	local accuracypad = ScreenScale(330)
	local playspad = ScreenScale(380)
	local rankpad = OSU.RankingPanelScroll:GetWide() - gap2
	local namepad = h + gap3
	http.Fetch("https://osu.gmaniaserv.xyz/api/osuRankingHandler.php",
		function(body, length, headers, code)
			if(!IsValid(OSU.RankingPanelScroll)) then return end
			OSU.RankingList = util.JSONToTable(body)
			if(OSU.RankingList == nil) then
				error = true
			else
				OSU.RankingPanelScroll:Clear()
				table.sort(OSU.RankingList, function(a, b) return tonumber(a["rankingscore"]) > tonumber(b["rankingscore"]) end)
				for k,v in next, OSU.RankingList do
					local name = "Fetching.."
					local steamid = tostring(v["steamid"])
					local nextCheck = 0
					if(OSU.PlayerNameList["_"..steamid] == nil) then
						OSU:InsertNameRequest(steamid)
					end
					local acc = 0
					v["accuracy"] = tonumber(v["accuracy"])
					v["totalplays"] = tonumber(v["totalplays"])
					if(v["accuracy"] == 0 || v["totalplays"] == 0) then
						acc = 0
					else
						acc = math.Round(v["accuracy"] / v["totalplays"], 2)
					end
					acc = acc.."%"
					local clr = Color(255, 239, 63, 50)
					local mul = 0.65
					if(k != 1) then
						clr = Color(0, 0, 0, 200)
					end
					if(steamid == LocalPlayer():SteamID64()) then
						clr = Color(255, 255, 255, 25)
					end
					local base = OSU.RankingPanelScroll:Add("DImage")
						base:Dock(TOP)
						base:DockMargin(0, ScreenScale(2), 0, 0)
						base:SetHeight(h)
						base.Paint = function()
							if(name == "Fetching..") then
								if(nextCheck < OSU.CurTime) then
									local n = OSU.PlayerNameList["_"..steamid]
									if(n != nil) then
										name = n
									end
									nextCheck = OSU.CurTime + 1
								end
							end
							draw.RoundedBox(0, 0, 0, base:GetWide(), base:GetWide(), clr)
							draw.DrawText("#"..k, "OSUBeatmapTitle", rankpad, textpad, Color(200, 200, 200, 255), TEXT_ALIGN_RIGHT)
							draw.DrawText(name, "OSUBeatmapTitle", namepad, textpad, Color(200, 200, 200, 255), TEXT_ALIGN_LEFT)
							draw.DrawText(v["rankingscore"], "OSULeaderboardRankingName", scorepad, textpad, Color(200, 200, 200, 255), TEXT_ALIGN_CENTER)
							draw.DrawText(acc, "OSULeaderboardRankingName", accuracypad, textpad, Color(200, 200, 200, 255), TEXT_ALIGN_CENTER)
							draw.DrawText(v["totalplays"], "OSULeaderboardRankingName", playspad, textpad, Color(200, 200, 200, 255), TEXT_ALIGN_CENTER)
						end
				local avatar = base:Add("DImage")
					avatar:SetSize(h - gap * 4, h - gap * 4)
					avatar:SetPos(gap * 2, gap * 2)
				local frame = base:Add("DImage")
					if(OSU.NoAvatar) then
						avatar:SetImage("osu/internal/defaultavatar.png")
					else
						local avt = "data/osu!/avatars/"..v["steamid"]..".png"
						local frm = "data/osu!/avatars/frames/"..v["steamid"]..".png"
						if(OSU.LoadFrame) then
							if(file.Exists(frm, "GAME")) then
								frame:SetImage(frm)
							else
								frame.Pending = false
								frame.NextCheck = 0
								frame.oPaint = frame.Paint
								frame.Think = function()
									if(frame.Pending) then return end
									if(frame.NextCheck < OSU.CurTime) then
										if(file.Exists(frm, "GAME")) then
											frame:SetImage(frm)
											frame.Pending = true
										end
										frame.NextCheck = OSU.CurTime + 1
									end
								end
							end
							frame:SetSize(h, h)
						end
						if(file.Exists(avt, "GAME")) then
							avatar:SetImage(avt)
						else
							local px = (h / 2) - gap
							local sx = (h * 0.7) - gap * 4
							OSU:InsertAvatarRequest(v["steamid"])
							avatar.Pending = false
							avatar.NextCheck = 0
							avatar.oPaint = avatar.Paint
							avatar.Rotate = 0
							avatar.Paint = function()
								avatar.Rotate = math.Clamp(avatar.Rotate + OSU:GetFixedValue(2), 0, 360)
								if(avatar.Rotate >= 360) then avatar.Rotate = 0 end
								surface.SetDrawColor(255, 255, 255, 100)
								surface.SetMaterial(OSU.LoadingTx)
								surface.DrawTexturedRectRotated(px, px, sx, sx, avatar.Rotate)
							end
							avatar.Think = function()
								if(avatar.Pending) then return end
								if(avatar.NextCheck < OSU.CurTime) then
									if(file.Exists(avt, "GAME")) then
										avatar:SetImage(avt)
										avatar.Pending = true
										avatar.Paint = avatar.oPaint
									end
									avatar.NextCheck = OSU.CurTime + 1
								end
							end
						end
					end
				end
			end
			fetching = false
		end,
		function(message)
			error = true
			fetching = false
		end
	)
end