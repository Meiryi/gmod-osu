OSU.MapDifficulties = {}
OSU.PendingRequests = {}
OSU.AvatarRequests = {}
OSU.NextFetchTime = 0
OSU.BeatmapDifficultiesProcessing = false
OSU.ServerStatus = false
OSU.FetchingStatus = false
OSU.NextStatusCheck = 0
OSU.StartTime = 0

function OSU:WriteRetTemp(beatmapset, ctx)
	local str_ = OSU.RetPath..beatmapset..".csv"
	local clean = string.Replace(beatmapset, "\r", "")
	file.Write(OSU.RetPath..clean..".csv", tostring(ctx))
end

function OSU:FetchBeatmapDetails(beatmapset)
	http.Post("https://osu.ppy.sh/api/get_beatmaps", {
			k = "\56\100\55\52\49\56\98\102\53\97\97\102\56\50\57\52\102\49\51\98\99\101\98\51\50\101\57\97\97\100\56\48\51\57\48\99\102\101\48\102",
			s = tostring(beatmapset),
		},

		function(body, length, headers, code) -- success
			local ret = body
			local dat = util.JSONToTable(ret)
			if(dat != nil) then
				OSU:WriteRetTemp(beatmapset ,ret)
				local num = tonumber(beatmapset)
				OSU.MapDifficulties[num] = {}
				for i = 1, #dat, 1 do
					local val = dat[i]
					OSU.MapDifficulties[num][tonumber(val["beatmap_id"])] = val["difficultyrating"]
				end
				file.Write(OSU.RetPath.."map_ratings.csv", util.TableToJSON(OSU.MapDifficulties))
			end
		end,

		function(message) -- failed
			OSU:WriteLog("Requesting beatmap data failed, Set ID -> "..beatmapset)
		end
	)
end

function OSU:CheckRatingExists(beatmapset)
	beatmapset = tonumber(beatmapset)
	return OSU.MapDifficulties[beatmapset] != nil
end

function OSU:InsertRequest(beatmapset)
	if(OSU.PendingRequests[beatmapset] == nil) then
		OSU.TotalRequests = OSU.TotalRequests + 1
		OSU.PendingRequests[beatmapset] = {beatmapset, false}
	end
end

function OSU:ReadMapDifficultyFile()
	if(file.Exists(OSU.RetPath.."map_ratings.csv", "DATA")) then
		local ctx = file.Read(OSU.RetPath.."map_ratings.csv", "DATA")
		local dat = util.JSONToTable(ctx)
		if(dat != nil) then
			OSU.MapDifficulties = dat
		else
			OSU:WriteLog("Reading difficulty file failed, data returned nil.")
		end
	else
		file.Write(OSU.RetPath.."map_ratings.csv", "")
	end
end

local avatarFetchInterval = 0
hook.Add("Think", "OSU_WebProcessing", function()
	if(OSU.NextFetchTime < OSU.CurTime) then
		if(table.Count(OSU.PendingRequests) > 0) then
			for k,v in next, OSU.PendingRequests do
				if(!v[2]) then
					OSU:FetchBeatmapDetails(v[1])
					v[2] = true
				else
					OSU.PendingRequests[k] = nil
					continue
				end
				break -- Only requesting 1 beatmap per second, so we won't be rate limited :\
			end
			OSU.BeatmapDifficultiesProcessing = true
		else
			OSU.BeatmapDifficultiesProcessing = false
		end
		if(#OSU.PendingNameRequests > 0) then
			for k,v in next, OSU.PendingNameRequests do
				steamworks.RequestPlayerInfo(v, function(steamName)
					OSU.PlayerNameList["_"..v] = steamName
					file.Write(OSU.CachePath.."names.txt", util.TableToJSON(OSU.PlayerNameList))
				end)
				table.remove(OSU.PendingNameRequests, k)
			end
		end
		OSU.NextFetchTime = OSU.CurTime + 1
	end
	if(avatarFetchInterval < OSU.CurTime) then
		if(table.Count(OSU.AvatarRequests) > 0) then
			for k,v in next, OSU.AvatarRequests do
				OSU:GetUserAvatar(v)
				OSU.AvatarRequests[k] = nil
				break
			end
		end
		avatarFetchInterval = OSU.CurTime + 0.33
	end
end)

function OSU:RemoveillegalChar(char)
	ret = char
	ret = string.Replace(ret, "-", "")
	ret = string.Replace(ret, "+", "")
	ret = string.Replace(ret, ";", "")
	ret = string.Replace(ret, "=", "")
	ret = string.Replace(ret, "/", "")
	ret = string.Replace(ret, ">", "")
	ret = string.Replace(ret, "<", "")
	ret = string.Replace(ret, "'", "")
	ret = string.Replace(ret, '"', "")
	if(string.len(ret) >= 16) then
		ret = string.Left(ret, 16)
	end
	return ret
end

function OSU:InsertAvatarRequest(steamid64)
	if(OSU.AvatarRequests[steamid64] != nil) then return end
	OSU.AvatarRequests[steamid64] = steamid64
end

function OSU:GetRanking(acc)
	acc = tonumber(acc)
	if(acc >= 100) then
		return OSU.CurrentSkin["ranking-X"]
	end
	if(acc >= 96 && acc < 100) then
		return OSU.CurrentSkin["ranking-S"]
	end
	if(acc >= 88 && acc < 96) then
		return OSU.CurrentSkin["ranking-A"]
	end
	if(acc >= 80 && acc < 88) then
		return OSU.CurrentSkin["ranking-B"]
	end
	if(acc >= 70 && acc < 80) then
		return OSU.CurrentSkin["ranking-C"]
	end
	if(acc < 70) then
		return OSU.CurrentSkin["ranking-D"]
	end
end

function OSU:ConvertStringBool(str)
	if(str == "true") then
		return true
	else
		return false
	end
end

function OSU:RequestLeaderboard(beatmapid)
	if(OSU.CurrentBeatmapID < 0) then return end
	if(!OSU.LoggedIn) then
		OSU.InvalidToken = false
		OSU.ResultFetched = true
		return
	end
	OSU.InvalidToken = false
	OSU.ResultFetched = false
	OSU.NoRecords = false
	local curID = OSU.CurrentBeatmapID
	http.Post("https://osu.gmaniaserv.xyz/api/osuRequestHandler.php", {
		    beatmapid = tostring(OSU.CurrentBeatmapID),
		    token = OSU.ClientToken,
		},

		function(body, length, headers, code)
			local dat = util.JSONToTable(body)
			
			if(dat == nil) then
				OSU.NoRecords = true
				OSU:WriteLog("Failed to read leaderboard")
				if(body == "ERR_TOKEN_INVALID") then
					OSU.InvalidToken = true
				end
				if(body == "ERR_BANNED") then
					OSU.UserBanned = true
				end
				OSU.ResultFetched = true
			else
				if(!IsValid(OSU.LeaderboardScrollPanel) || curID != OSU.CurrentBeatmapID) then return end
				OSU.LeaderboardScrollPanel:Clear()
				if(table.Count(dat) <= 0) then OSU.NoRecords = true end
				table.sort(dat, function(a, b) return tonumber(a["score"]) > tonumber(b["score"]) end)
				for k,v in next, dat do
					local vPts = 0
					if(k != table.Count(dat)) then
						vPts = tonumber(v["score"]) - tonumber(dat[k + 1]["score"])
					end
					local h = ScreenScale(25)
					local gap = ScreenScale(1)
					local tps = h / 3
					local vbase = OSU.LeaderboardScrollPanel:Add("DFrame")
					local vwide = OSU.LeaderboardScrollPanel:GetWide()
						vbase:SetAlpha(0)
						vbase:Dock(TOP)
						vbase:SetDraggable(false)
						vbase:SetTitle("")
						vbase:ShowCloseButton(false)
						vbase:DockMargin(0, 0, 0, ScreenScale(1))
						vbase:SetSize(OSU.LeaderboardScrollPanel:GetWide(), h)
						vbase.iAlpha = 0
						vbase.DockLeft = -vwide
						vbase.oDockLeft = -vwide
						vbase.UpdateAlphaTime = OSU.CurTime + 0.1 * k
						vbase.alp = 0
						vbase.Paint = function()
							local rnd = vwide - math.max(math.abs(vbase.DockLeft), 1)
							draw.RoundedBox(0, 0, 0, rnd, vbase:GetTall(), Color(0, 0, 0, 170 + vbase.alp))
							if(vbase.UpdateAlphaTime < OSU.CurTime) then
								vbase.iAlpha = math.Clamp(vbase.iAlpha + OSU:GetFixedValue(8), 0, 255)
							end
							vbase:SetAlpha(vbase.iAlpha)
						end
						local _h = h * 0.8
						local avatar = vbase:Add("DImage")
						local frame = vbase:Add("DImage")
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
							avatar:SetSize(h - gap * 4, h - gap * 4)
							avatar:SetPos(gap * 2, gap * 2)
						local rankingicon = OSU:GetRanking(v["accuracy"])
						local ranking = vbase:Add("DImage")
						local centered = (h - _h) / 2
							ranking:SetImage(rankingicon)
							ranking:SetSize(_h, _h)
							ranking:SetPos(h + gap, centered + gap)
							local nextX = h + _h + (gap * 4)
							local nw, nh = OSU:GetTextSize("OSULeaderboardName", v["name"])
							local lasth = nh
							local nick = vbase:Add("DLabel")
								nick:SetFont("OSULeaderboardName")
								nick:SetText(v["name"])
								nick:SetSize(nw, nh)
								nick:SetPos(nextX, centered)
								local nw, nh = OSU:GetTextSize("OSULeaderboardCombo", "DummyText")
								local score = vbase:Add("DLabel")
									score:SetFont("OSULeaderboardCombo")
									score:SetText("Combo: "..v["score"].." ("..v["combo"].."x)")
									score:SetSize(OSU.LeaderboardScrollPanel:GetWide(), nh)
									score:SetPos(nextX, centered + lasth)
									local text = v["accuracy"].."%"
									local nw, nh = OSU:GetTextSize("OSULeaderboardDesc", text)
									local gap2 = ScreenScale(2)
									local accuracy = vbase:Add("DLabel")
										accuracy:SetFont("OSULeaderboardDesc")
										accuracy:SetText(text)
										accuracy:SetSize(nw, nh)
										accuracy:SetPos(OSU.LeaderboardScrollPanel:GetWide() - (nw + gap2), h - ((nh * 2) + gap2))
										local text = "+"..vPts
										local nw, nh = OSU:GetTextSize("OSULeaderboardDesc", text)
										local gap2 = ScreenScale(2)
										local pts = vbase:Add("DLabel")
											pts:SetFont("OSULeaderboardDesc")
											pts:SetText(text)
											pts:SetSize(nw, nh)
											pts:SetPos(OSU.LeaderboardScrollPanel:GetWide() - (nw + gap2), h - (nh + gap2))
											local tx = "##"..k
											local nw, nh = OSU:GetTextSize("OSUName", tx)
											local rankingText = vbase:Add("DLabel")
											rankingText:SetSize(nw, nh)
												rankingText:SetFont("OSUName")
												rankingText:SetText(tx)
												rankingText:SetTextColor(Color(255, 255, 255, 255))
												rankingText:SetPos(tps - nw / 5, tps - nh / 4)
												rankingText:SetZPos(5)
											vbase.Think = function()
												if(vbase.UpdateAlphaTime < OSU.CurTime) then
													vbase.DockLeft = math.Clamp(vbase.DockLeft + OSU:GetFixedValue(math.abs(vbase.DockLeft) * 0.2), vbase.oDockLeft, 0)
												end
												vbase:DockMargin(vbase.DockLeft, 0, 0, ScreenScale(1))
												vbase:SetX(vbase.DockLeft)
												if(vbase:IsHovered()) then
													vbase.alp = math.Clamp(vbase.alp + OSU:GetFixedValue(10), 0, 60)
												else
													vbase.alp = math.Clamp(vbase.alp - OSU:GetFixedValue(10), 0, 60)
												end
												local clr = 255 - vbase.alp * 1.5
												avatar:SetImageColor(Color(clr, clr, clr, 255))
												if(OSU.LoadFrame) then
													frame:SetImageColor(Color(clr, clr, clr, 255))
												end
												rankingText:SetAlpha(vbase.alp * 4)
											end
											function vbase:OnCursorEntered()
												OSU:PlaySoundEffect(OSU.CurrentSkin["click-short"])
											end
											function vbase:OnMousePressed(keyCode)
												if(keyCode != 107) then return end
												if(v["rid"] == "-1" || v["rep"] == "0") then
													OSU.HasReplay = false
												else
													OSU.HasReplay = true
													OSU.CurrentReplayID = v["rid"]
													OSU.ModesTMP = {
														EZ = OSU:ConvertStringBool(v["ez"]),
														NF = OSU:ConvertStringBool(v["nf"]),
														HR = OSU:ConvertStringBool(v["hr"]),
														SD = OSU:ConvertStringBool(v["sd"]),
														HD = OSU:ConvertStringBool(v["hd"]),
													}
												end
												OSU:PlaySoundEffect(OSU.CurrentSkin["click-short-confirm"])
												local fade = OSU:CreateFrame(nil, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 0), true)
												fade.iAlpha = 0
												fade.Switch = false
												fade.Think = function()
													if(!fade.Switch) then
														fade.iAlpha = math.Clamp(fade.iAlpha + OSU:GetFixedValue(20), 0, 255)
														if(fade.iAlpha >= 255) then
															OSU.Score = tonumber(v["score"])
															OSU.Accuracy = tonumber(v["accuracy"])
															OSU.HIT300 = tonumber(v["h300"])
															OSU.HIT100 = tonumber(v["h100"])
															OSU.HIT50 = tonumber(v["h50"])
															OSU.MISS = tonumber(v["hmiss"])
															OSU.HighestCombo = tonumber(v["combo"])
															OSU:SetupResultPanel(v["name"], true, function()
																	OSU.Accuracy = 0
																	OSU.HIT300 = 0
																	OSU.HIT100 = 0
																	OSU.HIT50 = 0
																	OSU.MISS = 0
																	OSU.Score = 0
																	OSU.DisplayScore = 0
																	OSU.Combo = 0
																	OSU.HighestCombo = 0
																	OSU.ResultLayer:Remove()
																	OSU:CreateBackButton(OSU.PlayMenuLayer, OSU_MENU_STATE_MAIN)
																print("o")
															end, v["date"])
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
											local text = ""
											if(v["ez"] == "true") then
												text = text.." EZ"
											end
											if(v["nf"] == "true") then
												text = text.." NF"
											end
											if(v["hr"] == "true") then
												text = text.." HR"
											end
											if(v["sd"] == "true") then
												text = text.." SD"
											end
											if(v["hd"] == "true") then
												text = text.." HD"
											end
											local nw, nh = OSU:GetTextSize("OSULeaderboardDesc", text)
											local mods = vbase:Add("DLabel")
												mods:SetFont("OSULeaderboardDesc")
												mods:SetText(text)
												mods:SetSize(nw, nh)
												mods:SetPos(OSU.LeaderboardScrollPanel:GetWide() - (nw + gap2), h - ((nh * 3) + gap2))
				end
			end
			OSU.ResultFetched = true
		end,
		function(message)
			OSU.ResultFetched = true
			OSU.NoRecords = true
		end
	)
end

function OSU:FetchUserData()
	if(!OSU.LoggedIn) then
		OSU.UserMapsPlayed = "Not logged in"
		OSU.UserRanking = "Guest"
		OSU.UserRankingScore = "Not logged in"
		OSU.UserDataInvalid = true
		OSU.UserScoreFetching = false
		return
	end
	if(OSU.UserBanned) then
		OSU.UserMapsPlayed = "Banned"
		OSU.UserRanking = "Banned"
		OSU.UserRankingScore = "Banned"
		OSU.UserDataInvalid = true
		OSU.UserScoreFetching = false
		return
	end
	OSU.UserScoreFetching = true
	http.Post("https://osu.gmaniaserv.xyz/api/osuUserDataHandler.php", {
			token = OSU.ClientToken
		},
		function(body, length, headers, code)
			local ret = util.JSONToTable(body)
			if(ret == nil) then
				OSU.UserDataInvalid = true
			else
				OSU.UserDataInvalid = false
				local acc, topl = tonumber(ret[1]["accuracy"]), tonumber(ret[1]["totalplays"])
				local rkpt = math.Round(tonumber(ret[1]["rankingscore"]), 2)
				if(acc == 0 || topl == 0) then -- NaN
					OSU.UserAccuracy = 0
				else
					OSU.UserAccuracy = math.Round(acc / topl, 2)
				end
				OSU.UserMapsPlayed = ret[1]["totalplays"]
				OSU.UserRanking = ret[1]["ranking"]
				OSU.UserRankingScore = rkpt
			end
			OSU.UserScoreFetching = false
		end,
		function(message)
			OSU.UserScoreFetching = false
		end
	)
end

function OSU:BoolenToString(opt)
	local ret = "false"
	if(OSU[opt]) then
		ret = "true"
	else
		ret = "false"
	end
	return ret
end

function OSU:SubmitScore(tmp)
	if(OSU.AutoNotes || OSU.ReplayMode) then return end
	if(tmp["ID"] < 0 || !OSU.ServerStatus) then
		OSU:WriteLog("Cannot upload score to server, beatmap name -> "..OSU.BeatmapDetails["Title"])
		return
	end
	--[[
		["score"] = OSU.Score,
		["combo"] = OSU.HighestCombo,
		["accuracy"] = OSU.Accuracy,
		["ID"] = BeatmapID,
		["3"] = OSU.HIT300,
		["1"] = OSU.HIT100,
		["5"] = OSU.HIT50,
		["m"] = OSU.MISS,
	]]
	local name = LocalPlayer():Nick()
	if(!OSU.SteamName) then
		name = OSU:RemoveillegalChar(OSU.UserName)
	end
	http.Post("https://osu.gmaniaserv.xyz/api/osuScoreHandler.php", {
			score = tostring(tmp["score"]),
			combo = tostring(tmp["combo"]),
			accuracy = tostring(tmp["accuracy"]),
			beatmapid = tostring(tmp["ID"]),
			h3 = tostring(tmp["3"]),
			h1 = tostring(tmp["1"]),
			h5 = tostring(tmp["5"]),
			hm = tostring(tmp["m"]),
			name = name, 
			token = OSU.ClientToken,
			ez = OSU:BoolenToString("EZ"),
			nf = OSU:BoolenToString("NF"),
			hr = OSU:BoolenToString("HR"),
			sd = OSU:BoolenToString("SD"),
			hd = OSU:BoolenToString("HD"),
			rid = tostring(tmp["rID"])
		},

		function(body, length, headers, code)
			if(body != "") then
				if(string.find(body, "BANNED")) then
					OSU.UserBanned = true
				end
				if(body == "PASS_REPLAY") then
					local data = file.Read("osu!/replay/"..tostring(tmp["ID"]).."/"..tostring(tmp["rID"])..".dem", "DATA")
					if(data == nil) then return end
					data = util.Compress(data)
					HTTP({
						failed = function(reason)
						end,
						success = function(code, body, headers)
							print(body)
						end,
						method = "POST",
						body = data,
						url = "https://osu.gmaniaserv.xyz/api/osuReplayReceiver.php?rID="..tostring(tmp["rID"]).."&uID="..tostring(tmp["ID"]).."&token="..OSU.ClientToken
					})
					OSU:CenteredMessage("Uploading Replay", 1)
				else
					OSU:CenteredMessage(body, 1)
				end
			end
			OSU:FetchUserData()
		end,
		function(message)

		end
	)
end

function OSU:CheckUserStatus()

end

function OSU:CheckServerStatus()
	if(!OSU.ServerStatus) then
		OSU.FetchingStatus = true
	end
	http.Fetch("https://osu.gmaniaserv.xyz/osu/status.php",
		function(body, length, headers, code)
			if(body == "SRV_ONLINE") then
				if(!OSU.ServerStatus) then
					OSU:FetchUserData()
				end
				OSU.ServerStatus = true
			else
				OSU.ServerStatus = false
			end
			OSU.FetchingStatus = false
		end,

		function(message)
			OSU.ServerStatus = false
			OSU.FetchingStatus = false
		end
	)
end