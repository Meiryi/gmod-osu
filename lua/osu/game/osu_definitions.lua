--[[
	Gmod osu! - An unofficial port of osu! to Garry's mod.
	None of these codes should be modified or changed without original author's permission, anykind of modification is not allowed.

	You can use it on whatever you like, but you should not claim you're the original author,
	If you're a server owner, do not put this addon behind paywall, or some vip shit

	For translators, if you want to translate this addon, please contact me directly instead of modify the code
	REUPLOAD / REPACK IS NOT ALLOWED

	Copyright (C) 2023 Meika. All rights reserved
]]

OSU.MENU_STATE = 0

OSU_MENU_STATE_MAIN = 0
OSU_MENU_STATE_BEATMAP = 1
OSU_MENU_STATE_PLAYING = 2
OSU_MENU_STATE_RESULT = 3
OSU_MENU_STATE_REPLAY = 4
OSU_MENU_STATE_PAUSE = 5
OSU_MENU_STATE_FAILED = 6

OSU.MenuBackgroundColor = Color(0, 0, 0, 255)
OSU.MenuOutlineColor = Color(75, 87, 235, 255)
OSU.StarRatingTx = Material(OSU.CurrentSkin["star"])
OSU.ConnectTx = Material("osu/internal/connected.png")
OSU.DisconnectTx = Material("osu/internal/disconnected.png")
OSU.TutorialTx = Material("osu/internal/tokentutorial.png")
OSU.TotalBeatmapSets = 0
OSU.TotalRequests = 0

OSU.MainGameFrame = nil
OSU.WebDownloadPanel = nil
OSU.WebDownloadButton = nil
OSU.FakeCursor = nil
OSU.AuthPanel = nil
OSU.LoginPanel = nil
OSU.ModePanel = nil
OSU.RankingButton = nil
OSU.SearchBox = nil
OSU.RankingPanel = nil
OSU.RankingPanelScroll = nil
OSU.StartupAnim = nil
OSU.LoginButton = nil
OSU.Background = nil
OSU.BackButton = nil
OSU.ObjectLayer = nil
OSU.PlayMenuLayer = nil
OSU.PlayFieldLayer = nil
OSU.BeatmapDetailsTab = nil
OSU.ResultLayer = nil
OSU.BeatmapScrollPanel = nil
OSU.BeatmapDetails = nil
OSU.BeatmapDiffDetails = nil
OSU.LeaderboardScrollPanel = nil
OSU.UserAvatar = nil
OSU.MusicControlPanel = nil
OSU.MusicDetails = nil
OSU.MusicControlTab = nil
OSU.GameUIOverlay = nil
OSU.FPSCounter = nil
OSU.Logo = nil
OSU.Button_Play = nil
OSU.Button_Exit = nil
OSU.Button_Settings = nil
OSU.SettingsLayer = nil
OSU.SettingsPanel = nil
OSU.SettingsScrollPanel = nil
OSU.LeaderboardScrollPanel = nil
OSU.ColorInc = false
OSU.CurColor = 0

function OSU:LerpValue(val, time)
	return Lerp(time * RealFrameTime(), val, 0)
end

function OSU:StopSound()
	LocalPlayer():ConCommand("stopsound")
end

function OSUVector(x, y)
	return {x, y}
end