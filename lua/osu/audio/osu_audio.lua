--[[
	Gmod osu! - An unofficial port of osu! to Garry's mod.
	None of these codes should be modified or changed without original author's permission, anykind of modification is not allowed.

	You can use it on whatever you like, but you should not claim you're the original author,
	If you're a server owner, do not put this addon behind paywall, or some vip shit

	For translators, if you want to translate this addon, please contact me directly instead of modify the code
	REUPLOAD / REPACK IS NOT ALLOWED

	Copyright (C) 2023 Meika. All rights reserved
]]

function OSU:SetNextBPM(bpm)
	if(!IsValid(OSU.SoundChannel)) then return end
	local time = OSU.SoundChannel:GetTime() - OSU.BPMTimeGap
	local bpm_t = 1 / (bpm / 60)
	if(OSU.SoundChannel:GetState() != GMOD_CHANNEL_PLAYING) then
		OSU.NextBPM = OSU.CurTime + bpm_t
		return
	end
	local lef = math.floor(time / bpm_t) * bpm_t
	if(lef < time) then
		lef = lef + bpm_t
	end
	OSU.NextBPM = OSU.CurTime + (lef - time)
end

function OSU:GetAudioFromFile(ctx)
	if(ctx == nil) then return false end
	local data = string.Explode("\n", ctx)
	local Title = "Unknown"
	local TitleUnicode = "Unknown"
	local Artist = "Unknown"
	local ArtistUnicode = "Unknown"
	local fn = ""
	for k,v in pairs(data) do
		if(string.find(v, "AudioFilename")) then
			fn = string.Replace(v, "AudioFilename: ", "")
		end
		if(string.find(v, "Title:")) then
			Title = string.Replace(v, "Title:", "")
		end
		if(string.find(v, "TitleUnicode:")) then
			TitleUnicode = string.Replace(v, "TitleUnicode:", "")
		end
		if(string.find(v, "Artist:")) then
			Artist = string.Replace(v, "Artist:", "")
		end
		if(string.find(v, "ArtistUnicode:")) then
			ArtistUnicode = string.Replace(v, "ArtistUnicode:", "")
		end
	end
	local ret = ""
	if(OSU.ArtistUnicode) then
		if(ArtistUnicode != "Unknown") then
			Artist = ArtistUnicode
		end
	else
		ret = ret..Artist
	end
	if(OSU.TitleUnicode) then
		if(TitleUnicode != "Unknown") then
			Title = TitleUnicode
		end
	else
		ret = ret.." - "..TitleUnicode
	end
	return fn, ret
end

function OSU:GetAudioNameFromDir(ctx)
	local _index = 0
	for i = 1, string.len(ctx), 1 do
		_index = i
		if(string.sub(ctx, i, i) == " ") then break end
	end
	return string.sub(ctx, _index + 1)
end

function OSU:CacheAudios()
	OSU.MusicLists = {}
	local files, paths = file.Find(OSU.BeatmapPath.."*", "DATA")
	for k,v in next, paths do
		local _dir = OSU.BeatmapPath..v.."/"
		local _files =  file.Find(_dir.."*", "DATA")
		for x,y in next, _files do
			if(string.Right(y, 4) != ".osu" && string.Right(y, 4) != ".dem") then continue end
			local ctx = file.Read(_dir..y, "DATA")
			local audio, _name = OSU:GetAudioFromFile(ctx)
			if(!audio) then break 	end
			local timingPoints = {}
			table.insert(OSU.MusicLists, {_name, _dir..audio, timingPoints})
			break
		end
	end
end

function OSU:LoadMusicLengthCache() -- Since gmod cannot return correct length of mp3 formatted audio file, so we need to cache it since it lags when calculating it
	if(!file.Exists(OSU.CachePath.."musiclen_temp.dat", "DATA")) then
		OSU:WriteMusicLengthCache(true)
		return
	end
	local json = file.Read(OSU.CachePath.."musiclen_temp.dat", "DATA")
	local ctx = string.Replace(json, "\r", "")
	OSU.MusicLengthLists = util.JSONToTable(ctx)
end

function OSU:WriteMusicLengthCache(fWrite)
	if(fWrite) then
		local cacheList = {}
		for k,v in next, OSU.MusicLists do
			if(OSU.MusicLengthLists[v[2]] == nil) then
				table.insert(cacheList, v[2])
			end
		end
		local temps = {}
		for k,v in next, cacheList do
			table.insert(temps, {
				[v] = OSU:SoundDuration(v),
			})
		end
		OSU.MusicLengthLists = temps
		file.Write(OSU.CachePath.."musiclen_temp.dat", util.TableToJSON(temps, true))
	else
		local cacheList = {}
		for k,v in next, OSU.MusicLists do
			local found = false
			for x, y in next, OSU.MusicLengthLists do
				if(y[v[2]] != nil) then
					found = true
				end
			end
			if(!found) then
				table.insert(cacheList, v[2])
			end
		end
		for k,v in next, cacheList do
			table.insert(OSU.MusicLengthLists, {
				[v] = OSU:SoundDuration(v),
			})
		end
		file.Write(OSU.CachePath.."musiclen_temp.dat", util.TableToJSON(OSU.MusicLengthLists, true))
	end
end

function OSU:PickRandomMusic(readBPM)
	local rand = math.random(1, #OSU.MusicLists)
	if(table.Count(OSU.MusicLists) <= 0) then return end
	OSU.MenuTimingPoints = {}
	OSU.MenuTimingPoints_Temp = {}
	local tps_start = 0
	local tps_end = 0
	local musicPath = OSU.MusicLists[rand][2]
	local bpm = 183
	if(string.Right(musicPath, 1) == "\r") then
		musicPath = string.Left(OSU.MusicLists[rand][2], string.len(OSU.MusicLists[rand][2]) - 1)
	end
	if(readBPM == nil) then
		local _end = 0
		for i = string.len(musicPath), 1, -1 do
			if(string.sub(musicPath, i, i) == "/") then
				_end = i
				break
			end
		end
		local _path = string.sub(musicPath, 1, _end)
		local fosu = file.Find(_path.."*.osu", "DATA")
		if(#fosu <= 0) then
			fosu = file.Find(_path.."*.dem", "DATA")
		end
		for k,v in next, fosu do
			if(!file.Exists(_path..v, "DATA")) then
				continue
			end
			local ctx = string.Explode("\n", file.Read(_path..v, "DATA"))
			local bpm_processing = ""
			for x,y in pairs(ctx) do
				if(string.find(y, "TimingPoints")) then
					bpm_processing = ctx[x + 1]
					tps_start = x + 2
				end
			end
			if(bpm_processing != "") then
				local ret = string.Explode(",", bpm_processing)
				local output = tonumber(ret[2])
				local timegap = tonumber(ret[1])
				bpm = 1 / output * 1000 * 60
				OSU.BPMTimeGap = timegap / 1000
			end
			if(tps_start != 0) then
				for i = tps_start, #ctx, 1 do
					if(string.len(ctx[i]) <= 1 || string.find(ctx[i], "HitObjects")) then
						tps_end = i
						for _ = tps_start, tps_end do
							local ret = string.Explode(",", ctx[_])
							if(tonumber(ret[1]) == nil || tonumber(ret[2]) == nil || tonumber(ret[3]) == nil || tonumber(ret[4]) == nil || tonumber(ret[8]) == nil) then continue end
							if(tonumber(ret[2]) > 0) then continue end
							table.insert(OSU.MenuTimingPoints, {tonumber(ret[1]) / 1000, tonumber(ret[8]), false})
						end
						break
					end
				end
			end
			break
		end
	end
	OSU.BPM = bpm
	OSU.AlphaIncrease = 255 / (60 * (1 / (OSU.BPM / 60)))
	OSU:PlayMusic("data/"..musicPath, OSU.MusicLists[rand][1], OSU.MusicLists[rand][2])
	OSU:ChangeBackground(OSU:PickMenuBackground())
end

function OSU:PlayHitSound(sd)
	sound.PlayFile(sd, "noplay", function(station, errCode, errStr)
		if(IsValid(station)) then
			station:SetVolume(OSU.HitSoundVolume)
			station:Play()
		end
	end)
end

function OSU:PlaySoundEffect(sd)
	sound.PlayFile(sd, "noplay", function(station, errCode, errStr)
		if(IsValid(station)) then
			station:SetVolume(OSU.EffectVolume)
			station:Play()
		end
	end)
end

function OSU:PlayMusic(sd, sdn, ostr, time)
	sound.PlayFile(sd, "noplay", function(station, errCode, errStr)
		if(IsValid(station)) then
			OSU.MenuKiaiTime = false
			if(IsValid(OSU.SoundChannel)) then
				OSU.SoundChannel:Stop()
			end
			if(time != nil && time != 0) then
				station:SetTime(time, true)
			end
			station:SetVolume(OSU.MusicVolume)
			station:Play()
			OSU.SoundChannel = station
			OSU.Samples = {}
			OSU.HighestKick = 0
			OSU.Kicks = {}
			OSU.Peaks = {}
			OSU.CurrentMusicName = sdn
			OSU.HighestSample = 0
			OSU.NextDetectionTime = OSU.CurTime + 1
			if(IsValid(OSU.MusicControlTab)) then
				OSU.MusicControlTab:Remove()
			end
			OSU.MusicControlTab = OSU:CreateMusicTab()
			if(ostr != nil) then
				local found = false
				for k,v in next, OSU.MusicLengthLists do
					if(v[ostr] != nil) then
						OSU.CurrentMusicLength = v[ostr]
						found = true
					end
				end
				if(!found) then
					OSU:WriteMusicLengthCache(false)
				end
			end
			OSU.CurrentBeatCount = math.floor(OSU.SoundChannel:GetTime() / (1 / math.floor(OSU.BPM / 60))) % 4
		end
	end)
end
