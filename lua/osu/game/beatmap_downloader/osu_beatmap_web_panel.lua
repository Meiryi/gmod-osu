OSU.WebFetchTime = 0
OSU.WebFetchedTable = {}
OSU.WebDownloadingTable = {}
OSU.WebCardQuery = {}
OSU.WebFailed = false
OSU.WebFetching = false
OSU.CurrentPage = 0
OSU.PreviewChannel = nil
OSU.PreviewSetID = "?"
OSU.PreviewLoading = false
OSU.NextEnterSearchTime = 0
OSU.WebCardTemp = {}
OSU.NothingFound = false

function OSU:IsBeatmapInstalled(_SetID)
	if(file.Exists("osu!/download/".._SetID..".dat", "DATA")) then
		return true
	else
		local f, d = file.Find("osu!/beatmaps/".._SetID.."*", "DATA")
		if(#d > 0) then
			return true
		end
	end
	return false
end

function OSU:DownloadBeatmapSet(_SetID)
	HTTP({
		failed = function(reason)
			OSU.WebDownloadingTable[_SetID] = nil
		end,
		success = function(code, body, headers)
			OSU.WebDownloadingTable[_SetID] = nil
			if(string.find(body, "server_error")) then

			else
				file.Write("osu!/download/".._SetID..".dat", body)
				OSU:SideNotify("Beatmap set ".._SetID.."\nDownload finished!", 2)
				OSU:InsertUnpackQuery(_SetID) -- Don't unpack everything at once, game'll crash
			end
		end,
		method = "GET",
		url = "api.chimu.moe/v1/download/".._SetID
	})
end

function OSU:FetchBeatmapCard(_SetID)
	http.Fetch("https://assets.ppy.sh/beatmaps/".._SetID.."/covers/card.jpg",
		function(body, length, headers, code)
			if(code == 404) then
				OSU:AppendCardsTemp(_SetID)
			else
				file.Write("osu!/cards/".._SetID..".jpg", body)
			end
		end,
		function(message)
			-- osu's server shouldn't fail, so do nothing
		end
	)
end

function OSU:FetchPreviewMusic(_SetID)
	if(OSU.WebFetchTime > OSU.CurTime) then
		OSU:CenteredMessage("Don't spam the button!")
		return
	end
	if(OSU.PreviewLoading) then return end
	OSU.WebFetchTime = OSU.CurTime + 0.2
	if(IsValid(OSU.PreviewChannel)) then
		if(OSU.PreviewSetID == _SetID && OSU.PreviewChannel:GetState() == GMOD_CHANNEL_PLAYING) then
			return
		end
		OSU.PreviewChannel:Pause()
	end
	OSU.PreviewSetID = _SetID
	OSU.PreviewLoading = true
	sound.PlayURL("https://b.ppy.sh/preview/".._SetID..".mp3", "noblock", function(station)
		if(IsValid(station)) then
			if(IsValid(OSU.PreviewChannel)) then
				OSU.PreviewChannel:Pause()
			end
			if(OSU.PreviewSetID == _SetID) then
				station:Play()
				OSU.PreviewChannel = station
				OSU.PreviewLoading = false
				OSU.SoundChannel:Pause()
			end
		else
			OSU:CenteredMessage("Error fetching url", 0.2)
			OSU.PreviewLoading = false
		end
	end)
end

function OSU:GetStarColor(stars)
	if(stars >= 10) then
		return Color(0, 0, 0, 255)
	end
	if(stars >= 9) then
		return Color(15, 5, 60, 255)
	end
	if(stars >= 8) then
		return Color(25, 5, 110, 255)
	end
	if(stars >= 7) then
		return Color(85, 70, 195, 255)
	end
	if(stars >= 6) then
		return Color(160, 80, 190, 255)
	end
	if(stars >= 5) then
		return Color(220, 90, 120, 255)
	end
	if(stars >= 4) then
		return Color(230, 160, 105, 255)
	end
	if(stars >= 3) then
		return Color(210, 250, 100, 255)
	end
	if(stars >= 2) then
		return Color(150, 250, 210, 255)
	end
	if(stars >= 1) then
		return Color(120, 180, 250, 255)
	end
	if(stars >= 0) then
		return Color(100, 140, 250, 255)
	end
	return Color(100, 140, 250, 255)
end

function OSU:RequestBeatmapList(keyword, page)
	OSU.NothingFound = false
	if(keyword == nil) then
		keyword = ""
	end
	if(page == nil) then
		OSU.CurrentPage = 0
	end
	local pg = OSU.CurrentPage
	local offset = tostring(50 * OSU.CurrentPage)
	keyword = string.Replace(keyword, " ", "%20")
	OSU.WebFetching = true
	OSU.WebFailed = false
	OSU.WebDownloadPanel.FetchList:Clear()
	HTTP({
		failed = function(reason)
			OSU.WebFailed = true
			OSU.WebFetching = false
		end,
		success = function(code, body, headers)
			if(!IsValid(OSU.WebDownloadPanel.FetchList)) then return end
			OSU.WebDownloadPanel.FetchList:GetVBar():SetScroll(0)
			local ret = util.JSONToTable(body)
			if(ret == nil) then
				OSU.WebFailed = true
			else
				OSU.WebFailed = false
				if(pg != OSU.CurrentPage) then return end
				if(#ret <= 0) then
					OSU.WebFetching = false
					OSU.NothingFound = true
					return
				end
				--[[
					Keys :
						Title
						SetID
						Creator
						LastUpdate
						Artist
				]]
				local width = OSU.WebDownloadPanel.FetchList:GetWide()
				local height = ScreenScale(30)
				local pheight = ScreenScale(16)
				local padding = ScreenScale(4)
				local padding2x = padding * 2
				local padding1_5x = ScreenScale(6)
				local topPadding = ScreenScale(12)
				local textPadding = ScreenScale(26)
				local dockpad = ScreenScale(2)
				local w = ScreenScale(85)
				for k,v in next, ret do
					if(v["HasVideo"]) then continue end
					if(string.len(v["Title"]) > 24) then
						v["Title"] = string.Left(v["Title"], 24)..".."
					end
					local title = v["Artist"].." - "..v["Title"]
					local DetailsText = "Mapped by "..v["Creator"].." on "..string.Replace(v["LastUpdate"], "Z", "")
					local base = OSU.WebDownloadPanel.FetchList:Add("DFrame")
						base:SetWide(width)
						base:SetTall(height)
						base:Dock(TOP)
						base:DockMargin(0, 0, 0, dockpad)
						base:SetTitle("")
						base:SetDraggable(false)
						base:ShowCloseButton(false)
						base.Paint = function()
							if(OSU.PreviewSetID == v["SetID"]) then
								if(IsValid(OSU.PreviewChannel)) then
									if(OSU.PreviewChannel:GetState() == GMOD_CHANNEL_PLAYING) then
										draw.RoundedBox(0, 0, 0, width, height, Color(50, 150, 50, 200))
									else
										draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))
									end
								else
									draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))
								end
							else
								draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))
							end
							draw.DrawText(title, "OSUWebTitle", w + textPadding, dockpad, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
							draw.DrawText(DetailsText, "OSUWebDetails", w + textPadding, padding + topPadding, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
						end
						local preview = base:Add("DImageButton")
							preview:SetSize(pheight, pheight)
							preview:SetPos(w + padding, padding2x)
							preview:SetImage("osu/internal/musicplay.png")
							preview.DoClick = function()
								OSU:PlaySoundEffect(OSU.CurrentSkin["click-short-confirm"])
								OSU:FetchPreviewMusic(v["SetID"])
							end
							local rotate = 0
							preview.oPaint = preview.Paint
							preview.Paint = function()
								if(OSU.PreviewSetID == v["SetID"]) then
									if(OSU.PreviewLoading) then
										rotate = math.Clamp(rotate + OSU:GetFixedValue(1), 0, 360)
										if(rotate >= 360) then
											rotate = 0
										end
										surface.SetDrawColor(255, 255, 255, 255)
										surface.SetMaterial(OSU.LoadingTx)
										surface.DrawTexturedRectRotated(pheight / 2, pheight / 2, pheight, pheight, rotate)
										preview:SetColor(Color(255, 255, 255, 0))
									else
										preview:SetColor(Color(255, 255, 255, 255))
									end
								else
									preview:SetColor(Color(255, 255, 255, 255))
								end
							end
							local fpath = "osu!/cards/"..v["SetID"]..".jpg"
							local fetch = false
							local loaded = false
							local checkinterval = 0
							local card = base:Add("DImage")
								card:SetSize(w, height)
								card.Think = function()
									if(checkinterval < OSU.CurTime) then
										if(OSU.WebCardTemp[v["SetID"]]) then
											card:SetImage("osu/internal/nopre.jpg")
											card.Think = nil
											return
										end
										if(file.Exists(fpath, "DATA")) then
											card:SetImage("data/osu!/cards/"..v["SetID"]..".jpg")
											card.Think = nil
										else
											if(!fetch && OSU.WebCardTemp[v["SetID"]] == nil) then
												OSU:FetchBeatmapCard(v["SetID"])
												fetch = true
											end
										end
										checkinterval = OSU.CurTime + 1
									end
								end
								local sx = ScreenScale(16)
								local download = base:Add("DImageButton")
								local installed = false
								local nextthink = 0
									download:SetPos(width - sx - padding1_5x, padding1_5x)
									download:SetSize(sx, sx)
									download:SetImage("osu/internal/webdownload.png")
									download.DoClick = function()
										if(OSU.WebDownloadingTable[v["SetID"]] || installed) then return end
										if(OSU:IsBeatmapInstalled(v["SetID"])) then
											return
										end
										OSU:DownloadBeatmapSet(v["SetID"])
										OSU.WebDownloadingTable[v["SetID"]] = true
										OSU:PlaySoundEffect(OSU.CurrentSkin["click-short-confirm"])
									end
									download.Think = function()
										if(nextthink > OSU.CurTime) then return end
										if(OSU:IsBeatmapInstalled(v["SetID"])) then
											download:SetImage("osu/internal/check.png")
											download.Think = nil
										end
										nextthink = OSU.CurTime + 1
									end
									download.Paint = function()
										if(OSU.WebDownloadingTable[v["SetID"]]) then
											rotate = math.Clamp(rotate + OSU:GetFixedValue(1), 0, 360)
											if(rotate >= 360) then
												rotate = 0
											end
											surface.SetDrawColor(255, 255, 255, 255)
											surface.SetMaterial(OSU.LoadingTx)
											surface.DrawTexturedRectRotated(pheight / 2, pheight / 2, pheight, pheight, rotate)
											download:SetColor(Color(255, 255, 255, 0))
										else
											download:SetColor(Color(255, 255, 255, 255))
										end
									end
									function download:OnCursorEntered()
										OSU:PlaySoundEffect(OSU.CurrentSkin["click-short"])
									end
									local icons = {
										[0] = false,
										[1] = false,
										[2] = false,
										[3] = false,
									}
									local stars = {}
									for x,y in next, v["ChildrenBeatmaps"] do
										icons[tonumber(y["Mode"])] = true
										table.insert(stars, tonumber(y["DifficultyRating"]))
									end
									table.sort(stars, function(a, b) return b > a end)
									local nextX = 0
									local hasData = false
									local sx = ScreenScale(12)
									local baseX = download:GetX() - padding2x - sx
									local baseY = height - sx - padding
									for x,y in next, icons do
										if(!y) then continue end
										local ico = base:Add("DImage")
											ico:SetPos(baseX - nextX, baseY)
											ico:SetSize(sx, sx)
											ico:SetImage(OSU:PickModeIcon(x))
											nextX = sx + dockpad
										hasData = true
									end
									local nX = 0
									local w, h = ScreenScale(8), ScreenScale(8)
									local gap = ScreenScale(1)
									local hpad = ScreenScale(5)
									local npad = ScreenScale(7)
									for x,y in next, stars do
										local clr = OSU:GetStarColor(y)
										local rect = base:Add("DImage")
											rect:SetPos(baseX - (nX + nextX + gap + sx), height - (h + hpad))
											rect:SetSize(w, h)
											rect.Paint = function()
												draw.RoundedBox(ScreenScale(3), 0, 0, rect:GetWide() / 2, rect:GetTall(), clr)
											end
											nX = nX + npad
									end
									if(!hasData) then
										local ico = base:Add("DImageButton")
											ico:SetPos(baseX, baseY)
											ico:SetSize(sx, sx)
											ico:SetImage("osu/internal/unk.png")
									end

				end
			end
			OSU.WebFetching = false
		end,
		method = "GET",
		url = "https://api.chimu.moe/cheesegull/search?query="..keyword.."&offset="..offset
	})
end

function OSU:AppendCardsTemp(_SetID)
	OSU.WebCardTemp[_SetID] = true
	file.Write("osu!/cache/cards.dat", util.TableToJSON(OSU.WebCardTemp))
end

function OSU:WriteCardsTemp()
	local tbl = {}
	file.Write("osu!/cache/cards.dat", util.TableToJSON(tbl))
end

function OSU:GetCardsTemp()
	if(file.Exists("osu!/cache/cards.dat", "DATA")) then
		local ret = file.Read("osu!/cache/cards.dat", "DATA")
		if(ret == nil) then
			OSU:WriteCardsTemp()
		else
			local tbl = util.JSONToTable(ret)
			if(tbl == nil) then
				OSU:WriteCardsTemp()
			else
				OSU.WebCardTemp = tbl
			end
		end
	else
		OSU:WriteCardsTemp()
	end
end

function OSU:SetupBeatmapDownloadPanel()
	if(IsValid(OSU.WebDownloadPanel)) then
		OSU.WebDownloadPanel:Remove()
	end
	OSU.CurrentPage = 0
	OSU:GetCardsTemp()
	OSU.WebFetchTime = 0
	OSU.WebFailed = false
	OSU.WebFetching = false
	OSU.NothingFound = false
	OSU.WebDownloadPanel = OSU:CreateFrame(OSU.MainGameFrame, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 0), true)
	OSU.WebDownloadPanel.Think = function()
		OSU.WebDownloadPanel.iAlpha = math.Clamp(OSU.WebDownloadPanel.iAlpha + OSU:GetFixedValue(50), 0, 210)
	end
	local upperGap = ScreenScale(32)
	local sideGap = ScreenScale(48)
	local searchHeight = ScreenScale(18)
	local elementsgap = ScreenScale(4)
	local breathgap = ScreenScale(8)
	local dlheight = ScreenScale(15)
	local dockpad = ScreenScale(2)
	local tgap = ScreenScale(1)
	local labelpadding = ScreenScale(10)
	local breathingAlpha = 0
	local breathingAlphaSwitch = false
	local mul = 0.05
	local textcent = ((ScrW() * 0.8) - upperGap) / 2

	local searchtext = OSU:CreateTextEntryPanel(OSU.WebDownloadPanel, upperGap, upperGap, ScrW() * 0.4, searchHeight, false)
	searchtext:SetPlaceholderText("Search beatmap name | mapper")
	function searchtext:OnKeyCodeTyped(keyCode)
		if(keyCode == 66) then
			OSU:PlaySoundEffect(OSU.CurrentSkin["key-delete"])
		else
			if(keyCode != 64) then
				OSU:PlaySoundEffect(OSU.CurrentSkin["key-press-"..math.random(1, 4)])
			else
				OSU:PlaySoundEffect(OSU.CurrentSkin["key-confirm"])
				if(OSU.NextEnterSearchTime > OSU.CurTime) then return end -- prevent people holding enter to spam requests, otherwise they'll got rate limited
				OSU:RequestBeatmapList(searchtext:GetValue())
				OSU.NextEnterSearchTime = OSU.CurTime + 0.33
			end
		end
	end
	local searchbtn = OSU:CreateClickableButton(OSU.WebDownloadPanel, upperGap + searchtext:GetWide() + elementsgap, upperGap, ScreenScale(40), searchHeight, false, "Search", function()
		OSU:PlaySoundEffect(OSU.CurrentSkin["click-short-confirm"])
		local key = searchtext:GetValue()
		if(string.len(key) <= 0) then
			key = ""
		end
		OSU:RequestBeatmapList(key)
	end, Color(232, 159, 106, 255), Color(0, 0, 0, 255), "OSUBeatmapDetails", Color(200, 200, 200, 255))

	local stopsd = OSU:CreateClickableButton(OSU.WebDownloadPanel, upperGap + searchtext:GetWide() + (elementsgap * 2) + searchbtn:GetWide(), upperGap, ScreenScale(60), searchHeight, false, "Stop sounds", function()
		OSU:PlaySoundEffect(OSU.CurrentSkin["click-short-confirm"])
		OSU:StopSound()
	end, Color(232, 106, 106, 255), Color(0, 0, 0, 255), "OSUBeatmapDetails", Color(200, 200, 200, 255))
	local resetbtn = OSU:CreateClickableButton(OSU.WebDownloadPanel, upperGap + searchtext:GetWide() + (elementsgap * 3) + searchbtn:GetWide() + stopsd:GetWide(), upperGap, ScreenScale(30), searchHeight, false, "Reset", function()
		OSU:PlaySoundEffect(OSU.CurrentSkin["click-short-confirm"])
		searchtext:SetValue("")
		OSU:RequestBeatmapList()
	end, Color(106, 255, 106, 255), Color(0, 0, 0, 255), "OSUBeatmapDetails", Color(200, 200, 200, 255))
	local btnsx = ScreenScale(14)
	OSU.WebDownloadPanel.FetchList = OSU:CreateScrollPanel(OSU.WebDownloadPanel, upperGap, upperGap + elementsgap + searchHeight + btnsx, (ScrW() * 0.8) - upperGap * 2, ScrH() * 0.75, Color(0, 0, 0, 150))
	local sx = ScreenScale(32)
	local rotate = 0
	OSU.WebDownloadPanel.FetchList.Paint = function()
		if(OSU.NothingFound) then
			draw.DrawText("No Result", "OSUBeatmapTitle", OSU.WebDownloadPanel.FetchList:GetWide() / 2, OSU.WebDownloadPanel.FetchList:GetTall() / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		end
		if(OSU.WebFetching) then
			rotate = math.Clamp(rotate + OSU:GetFixedValue(1.5), 0, 360)
			if(rotate >= 360) then
				rotate = 0
			end
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(OSU.LoadingTx)
			surface.DrawTexturedRectRotated(OSU.WebDownloadPanel.FetchList:GetWide() / 2, OSU.WebDownloadPanel.FetchList:GetTall() / 2, sx, sx, rotate)
		end
	end

	local nextclicktime = 0
	local bsx = ScreenScale(10)
	local bsx01 = ScreenScale(9)
	local bx, by = OSU.WebDownloadPanel.FetchList:GetX(), OSU.WebDownloadPanel.FetchList:GetY() - (btnsx)
	local prevpg = OSU:CreateImageButton(OSU.WebDownloadPanel, bx, by, bsx, bsx, "osu/internal/musicprev.png", false, function()
		if(OSU.CurrentPage <= 0 || nextclicktime > OSU.CurTime) then return end
		OSU.CurrentPage = OSU.CurrentPage - 1
		local key = searchtext:GetValue()
		if(string.len(key) <= 0) then
			key = ""
		end
		OSU:PlaySoundEffect(OSU.CurrentSkin["click-short-confirm"])
		OSU:RequestBeatmapList(key, true)
		nextclicktime = OSU.CurTime + 0.33
	end)
	local bx, by = OSU.WebDownloadPanel.FetchList:GetWide() - bsx + upperGap, OSU.WebDownloadPanel.FetchList:GetY() - (btnsx)
	local nextpg = OSU:CreateImageButton(OSU.WebDownloadPanel, bx, by, bsx, bsx, "osu/internal/musicnext.png", false, function()
		if(nextclicktime > OSU.CurTime) then return end
		OSU.CurrentPage = OSU.CurrentPage + 1
		local key = searchtext:GetValue()
		if(string.len(key) <= 0) then
			key = ""
		end
		OSU:PlaySoundEffect(OSU.CurrentSkin["click-short-confirm"])
		OSU:RequestBeatmapList(key, true)
		nextclicktime = OSU.CurTime + 0.33
	end)

	local currentscroll = 0
	local vbar = OSU.WebDownloadPanel.FetchList:GetVBar()
	vbar:SetWide(ScreenScale(2))
	function vbar:Paint(w, h) return
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
	end
	function vbar.btnUp:Paint(w, h) return end
	function vbar.btnDown:Paint(w, h) return end
	function vbar.btnGrip:Paint(w, h) return
		draw.RoundedBox(ScreenScale(2), 0, 0, w, h, Color(255, 255, 255, 200))
	end

	function OSU.WebDownloadPanel.FetchList:OnMouseWheeled(scrollDelta)
		currentscroll = math.Clamp(currentscroll - (ScreenScale(40) * scrollDelta), 0, vbar.CanvasSize)
	end

	OSU.WebDownloadPanel.FetchList.Think = function()
		if(vbar.CanvasSize <= 0) then
			currentscroll = 0
		end
		if(vbar:GetScroll() != currentscroll) then
			local smooth = math.abs(currentscroll - vbar:GetScroll())
			if(vbar:GetScroll() < currentscroll) then
				vbar:SetScroll(math.Clamp(vbar:GetScroll() + OSU:GetFixedValue(smooth * 0.15), 0, vbar.CanvasSize))
			else
				vbar:SetScroll(math.Clamp(vbar:GetScroll() - OSU:GetFixedValue(smooth * 0.15), 0, vbar.CanvasSize))
			end
		end
	end

	local w = ScreenScale(120)
	local textpad = ScreenScale(4)
	local scrollpad = ScreenScale(16)
	OSU.WebDownloadPanel.ImportList = OSU:CreateFrame(OSU.WebDownloadPanel, ScrW() - w, OSU.WebDownloadPanel.FetchList:GetY(), w, ScrH() * 0.65, Color(0, 0, 0, 200))
	OSU.WebDownloadPanel.ImportList.Paint = function()
		draw.RoundedBox(0, 0, 0, OSU.WebDownloadPanel.ImportList:GetWide(), OSU.WebDownloadPanel.ImportList:GetTall(), Color(0, 0, 0, 200))
		draw.DrawText("Downloads", "OSUBeatmapDetails", OSU.WebDownloadPanel.ImportList:GetWide() / 2, textpad, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	end
	OSU.WebDownloadPanel.ImportList.Scroll = OSU:CreateScrollPanel(OSU.WebDownloadPanel.ImportList, 0, scrollpad, OSU.WebDownloadPanel.ImportList:GetWide(), OSU.WebDownloadPanel.ImportList:GetTall() * 0.8, Color(0, 0, 0, 0))
	local interval = 0
	local pList = {}
	local height = ScreenScale(16)
	OSU.WebDownloadPanel.ImportList.Scroll.Think = function()
		if(interval > OSU.CurTime) then return end
		OSU.WebDownloadPanel.ImportList.Scroll:Clear()
		local f = file.Find("osu!/download/*.dat", "DATA")
		for k,v in next, f do
			local str = "Set ID : "..string.Replace(v, ".dat", "")
			local size = "Size : "..math.Round((file.Size("osu!/download/"..v, "DATA") / (1024 ^ 2)), 2).." MB"
			local base = OSU.WebDownloadPanel.ImportList.Scroll:Add("DFrame")
				base:Dock(TOP)
				base:DockMargin(0, 0, 0, tgap)
				base:SetTall(height)
				base:SetWide(OSU.WebDownloadPanel.ImportList.Scroll:GetWide())
				base:ShowCloseButton(false)
				base:SetDraggable(false)
				base:SetTitle("")
				base.Paint = function()
					draw.RoundedBox(0, 0, 0, base:GetWide(), base:GetTall(), Color(30, 30, 30, 200))
					draw.DrawText(str, "OSUWebDetails", tgap, tgap, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
					draw.DrawText(size, "OSUDetails", tgap, bsx01, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
				end
		end
		interval = OSU.CurTime + 1
	end

	OSU.WebDownloadPanel.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, OSU.WebDownloadPanel.iAlpha))
		draw.DrawText("Type to search!", "OSUBeatmapTitle", upperGap, labelpadding, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
		draw.DrawText("Current page : "..(OSU.CurrentPage + 1), "OSUBeatmapDetails", textcent, sideGap + labelpadding, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		draw.DrawText("Importing maps will cause\ntemporary lag", "OSUBeatmapDetails", OSU.WebDownloadPanel.ImportList:GetX() + OSU.WebDownloadPanel.ImportList:GetWide() / 2, OSU.WebDownloadPanel.ImportList:GetY() + OSU.WebDownloadPanel.ImportList:GetTall() + textpad, Color(200, 255, 200, 255), TEXT_ALIGN_CENTER)
	end

	local w, h = ScreenScale(110), ScreenScale(10)
	local importall = OSU:CreateClickableButton(OSU.WebDownloadPanel.ImportList, OSU.WebDownloadPanel.ImportList:GetWide() / 2, OSU.WebDownloadPanel.ImportList:GetTall() - (h + textpad / 2), w, h, true, "Import All", function()
		if(table.Count(OSU.UnpackingQuery) <= 0) then return end
		OSU.Unpacking = true
	end, Color(20, 20, 20, 255), OSU.OptBlue, "OSUBeatmapDetails", Color(20, 20, 20, 255))



	OSU:RequestBeatmapList()
	OSU:CreateBackButton(OSU.WebDownloadPanel, OSU_MENU_STATE_MAIN)
end