--[[
	Gmod osu! - An unofficial port of osu! to Garry's mod.
	None of these codes should be modified or changed without original author's permission, anykind of modification is not allowed.

	You can use it on whatever you like, but you should not claim you're the original author,
	If you're a server owner, do not put this addon behind paywall, or some vip shit

	For translators, if you want to translate this addon, please contact me directly instead of modify the code
	REUPLOAD / REPACK IS NOT ALLOWED

	Copyright (C) 2023 Meika. All rights reserved
]]

OSU = {}

if(OSU_RenderTarget == nil) then
	OSU_RenderTarget = GetRenderTarget("osu_rt", ScrW(), ScrH()) 
	OSU_RTMaterial = CreateMaterial("osu_rt_mat", "UnlitGeneric", {
		['$basetexture'] = OSU_RenderTarget:GetName(),
		["$translucent"] = "1" 
	});
end

OSU.BeatmapPath = "osu!/beatmaps/"
OSU.SkinsPath = "osu!/skins/"
OSU.DevPath = "osu!/dev/"
OSU.DefaultSkinPath = "osu!/skins/default/"
OSU.CachePath = "osu!/cache/"
OSU.HitObjectsCachePath = "osu!/cache/hitobjects/"
OSU.RetPath = "osu!/ret/"

OSU.NotifyIndex = 0
OSU.NotifyTable = {}
OSU.Samples = {}
OSU.KickAvg = 0 
OSU.DrumAvg = 0
OSU.NextRecord = 0
OSU.HighestKick = 0
OSU.Kicks = {}
OSU.FreqAvg = 0
OSU.Peaks = {}
OSU.PreviewTime = 0
OSU.AlphaIncrease = 0

OSU.CurTime = 0
OSU.TempFrameTime = 0
OSU.BPM = 184
OSU.NextBPM = 0
OSU.SoundChannel = nil
OSU.Background = ""
OSU.StartupTimer = 0
OSU.NextBeat = 0
OSU.Rotate = 1
OSU.HaveInvalidBeatmap = false
OSU.MaxScroll = 0
OSU.iMaxScroll = 0
OSU.CurrentScroll = 0
OSU.PanelAmount = 0
OSU.CurrentBeatmapSet = ""
OSU.CurrentBeatmapID = 00000000
OSU.MusicLeadIn = 0
OSU.CurrentTimtingPoints = {}
OSU.BeatmapNameType = "Title"
OSU.BeatmapArtistType = "Artist"
OSU.GetVBarMaxScrollTime = 0
OSU.ReloadMaxScroll = false
OSU.CursorTexture = Material("data/"..OSU.DefaultSkinPath.."cursor.png")
OSU.CursorMiddleTexture = Material("data/"..OSU.DefaultSkinPath.."cursormiddle.png")
OSU.SliderBackground = Material("data/"..OSU.DefaultSkinPath.."hitcircle.png")
OSU.HitCircleOverlay = Material("data/"..OSU.DefaultSkinPath.."sliderb0.png")
OSU.RevArrow = Material("data/"..OSU.DefaultSkinPath.."reversearrow.png")
OSU.CurTrailMat = Material("data/"..OSU.DefaultSkinPath.."cursortrail.png")
OSU.LoadingTx = Material("osu/internal/loading.png")
OSU.UnloggedTx = Material("osu/internal/unlogged.png")
OSU.CheaterTx = Material("osu/internal/cheater_trans.png")
OSU.NoRecordTx = Material("osu/internal/norecord.png", "noclamp smooth")
OSU.RightFade = Material("osu/internal/fade_rev.png", "noclamp smooth")
OSU.LeftFade = Material("osu/internal/fade.png", "noclamp smooth")
OSU.WarningFooter = Material("osu/internal/warning-footer.png", "noclamp smooth")
OSU.PlayMenuAnimStarted = false
OSU.PlayMenuObjectOffset = 0
OSU.BackgroundDim = 70
OSU.SliderBeat = 0
OSU.CurrentMessageIndex = 0
OSU.NextClickTime = 0
OSU.CurrentTarget = nil
OSU.UserBanned = false
OSU.FetchTime = 0
OSU.Fetched = false
OSU.ShouldFetch = false
OSU.ResultFetched = false
OSU.NoRecords = false

OSU.MusicLengthLists = {}
OSU.MusicLists = {}
OSU.BeatmapPanels = {}
OSU.CurrentMusicName = "Nekodex - Circles"
OSU.CurrentMusicLength = 136
OSU.NextDetectionTime = 0
OSU.SampleInterval = 0.015625
OSU.HighestSample = 0
OSU.NextSampleTime = 0
OSU.TimeSinceLastBeat = 0
OSU.MusicTemp = {}
OSU.FFT = {}
OSU.Visualizer = {}
for i = 1, 1024, 1 do
	OSU.Visualizer[i] = 0
end

OSU.UserAccuracy = 100.00
OSU.UserMapsPlayed = 32767
OSU.UserRanking = -1
OSU.UserRankingScore = 0
OSU.UserScoreFetching = false
OSU.UserDataInvalid = false
OSU.ServerOffline = false
OSU.InvalidToken = false

OSU.MouseInactiveTime = 0
OSU.GlobalAlphaMult = 1
OSU.MenuAlphaMul = 1
OSU.MouseVecTemp = Vector(0, 0, 0)

OSU.PP_Points = 0
OSU.PP_AvgDst = 60
OSU.PP_AimChunk = 0
OSU.PP_SpeedChunk = 0
OSU.PP_AimAvg = 0
OSU.PP_SpeedAvg = 0
OSU.PP_AimAvgSum = 0
OSU.PP_SpeedAvgSum = 0
OSU.PP_DiffSampleCount = 0
OSU.PP_DiffDstAvg = 0
OSU.PP_DiffSpeedAvg = 0
OSU.PP_DiffDstAvgSum = 0
OSU.PP_DiffSpeedAvgSum = 0
OSU.PP_AimVal = 0
OSU.PP_SpeedVal = 0
OSU.PP_AimSampledCount = 0
OSU.PP_SpeedSampledCount = 0
OSU.PP_BaseScore = 0
OSU.PP_BaseSpeed = 0.155 -- Avg tapping speed
OSU.PP_RecordInterval = 0
OSU.PP_StartedDiff = 0
OSU.PP_TotalDiff = 0
OSU.PP_DiffSwitch = false

OSU.PP_LastHitTime = 0
OSU.PP_LastHitVector = Vector(0, 0, 0)

function OSU:ChatPrint(_string)
	LocalPlayer():ChatPrint("[osu!] ".._string)
end

function OSU:GetTextSize(font, text)
	surface.SetFont(font)
	return surface.GetTextSize(text)
end