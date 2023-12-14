--[[
	Gmod osu! - An unofficial port of osu! to Garry's mod.
	None of these codes should be modified or changed without original author's permission, anykind of modification is not allowed.

	You can use it on whatever you like, but you should not claim you're the original author,
	If you're a server owner, do not put this addon behind paywall, or some vip shit

	For translators, if you want to translate this addon, please contact me directly instead of modify the code
	REUPLOAD / REPACK IS NOT ALLOWED

	Copyright (C) 2023 Meika. All rights reserved
]]

OSU.ReplayMode = false
OSU.HasReplay = false
OSU.FetchingReplay = false
OSU.ModesTMP = {
	EZ = false,
	NF = false,
	HR = false,
	SD = false,
	HD = false,
}
OSU.CurrentDefBGPath = "osu/internal/bg_ch/"
OSU.BeatmapCTX = ""
OSU.BeatmapTime = 0
OSU.RecordInterval = 0
OSU.ObjectIndex = 0
OSU.BeatDivisor = 4
OSU.CurrentBeatCount = 0
OSU.BPMTimeGap = 0
OSU.LogoLastClickTime = 0
OSU.MenuKiaiTime = false
OSU.MenuTimingPoints_Temp = {}
OSU.MenuTimingPoints = {}
OSU.TimingPoints = {}
OSU.Objects = {}
OSU.Breaks = {}
OSU.FakeCursorPos = {x = 0, y = 0}
OSU.ShouldDrawFakeCursor = false
OSU.CurrentReplayID = "15526206"
OSU.CurrentReplayData = {}
OSU.CurrentTableIndex = 1
OSU.CurrentTableIndex_Read = 1

OSU.TempData = {
	["b"] = "",
	["i"] = "",
}

OSU.FLMin = ScrW() * 5

OSU.BreakTime = 0
OSU.Duration = 1
OSU.CurrentZPos = 32767
OSU.PlayFieldSize = {x = 0, y = 0}

OSU.HP = 0
OSU.AR = 1
OSU.OD = 1
OSU.CS = 3

OSU.ScoreMul = 1
OSU.EZ = false
OSU.NF = false
OSU.HR = false
OSU.SD = false
OSU.HD = false
OSU.FL = false
OSU.RLAC = false
OSU.RLAM = false
OSU.SP = false
OSU.AT = false

OSU.BeatLength = 180
OSU.SliderMultiplier = 1
OSU.SliderVelocity = 1
OSU.SliderTickRate = 1
OSU.CurrentHitSound = "soft"
OSU.BeatmapDefaultSet = "soft"

OSU.AppearTime = 0
OSU.RPM = 0
OSU.LastDegree = 0
OSU.AllDegree = 0
OSU.Diff = 0
OSU.Deg = 0
OSU.DegAdd = 0
OSU.LastTime = OSU.CurTime
OSU.SkipButton = nil
OSU.HealthBar = nil
OSU.FailPanel = nil
OSU.KiaiTime = false
OSU.PlayFieldYOffs = 0
OSU.ScreenObjects = {}

OSU.HIT300Time = 0.074
OSU.HIT100Time = 0.132
OSU.HIT50Time = 0.19
OSU.HITMISSTIME = 0.19
OSU.FlashLight = Material("osu/internal/flashlight.png")
OSU.Hit300Tx = Material(OSU.CurrentSkin["hit300"])
OSU.Hit100Tx = Material(OSU.CurrentSkin["hit100"])
OSU.Hit50Tx = Material(OSU.CurrentSkin["hit50"])
OSU.Hit0Tx = Material(OSU.CurrentSkin["hit0"])
OSU.SnowTexture = Material("osu/internal/standard.png")
OSU.UnrankedTx = {
	["t"] = Material(OSU.CurrentSkin["play-unranked@2x"]),
	["w"] = 0,
	["h"] = 0,
}
OSU.HitArrowTx = Material("osu/internal/hiterrorArrow.png")
OSU.CurrentArrowPos = 0
OSU.ArrowTargetPos = 0
OSU.ArrowAlpha = 0
OSU.NextResetTime = 0
OSU.OffsList = {}
OSU.TotalHitObjects = 0
OSU.AutoplayTextOffs = 0
OSU.TotalHitOffs = 0
OSU.AvgHitOffs = 0
OSU.BeatmapEndTime = 0
OSU.BeatmapStartTime = 0
OSU.TotalObjectsRecorded = 0
OSU.TotalAccuracyRecorded = 0
OSU.Accuracy = 0
OSU.HIT300 = 0
OSU.HIT100 = 0
OSU.HIT50 = 0
OSU.MISS = 0
OSU.Score = 0
OSU.DisplayScore = 0
OSU.Combo = 0
OSU.HighestCombo = 0
OSU.PlayFieldAlphaMult = 0
OSU.GlobalMatSize = 1
OSU.GlobalMatShadowSize = 1
OSU.ScoreOffs = 0
OSU.BackgroundDimInc = 0
OSU.AccOffs = 0
OSU.CircleBG = Material("osu/internal/hitcircle.png")
OSU.SliderFollow = Material("osu/sliderfollowcircle.png")
OSU.BeatmapDetails = {}
OSU.ScoreBarData = {
	["bg"] = Material("data/osu!/skins/default/scorebar-bg.png"),
	["bc"] = "data/osu!/skins/default/scorebar-colour.png",
	["ki1"] = Material("data/osu!/skins/default/scorebar-ki.png"),
	["ki2"] = Material("data/osu!/skins/default/scorebar-kidanger.png"),
	["ki3"] = Material("data/osu!/skins/default/scorebar-kidanger2.png"),
	["gw"] = 695,
	["gh"] = 44,
	["cw"] = 645,
	["ch"] = 10,
	["kw1"] = 60,
	["kh1"] = 56,
	["kw2"] = 60,
	["kh2"] = 56,
	["kw3"] = 60,
	["kh3"] = 56,
}
OSU.Health = 100
OSU.KiExt = 0

OSU.ScoreMaterialTable = {
	["0"] = Material("data/osu!/skins/default/score-0.png"),
	["1"] = Material("data/osu!/skins/default/score-1.png"),
	["2"] = Material("data/osu!/skins/default/score-2.png"),
	["3"] = Material("data/osu!/skins/default/score-3.png"),
	["4"] = Material("data/osu!/skins/default/score-4.png"),
	["5"] = Material("data/osu!/skins/default/score-5.png"),
	["6"] = Material("data/osu!/skins/default/score-6.png"),
	["7"] = Material("data/osu!/skins/default/score-7.png"),
	["8"] = Material("data/osu!/skins/default/score-8.png"),
	["9"] = Material("data/osu!/skins/default/score-9.png"),
	["x"] = Material("data/osu!/skins/default/score-x.png"),
	["p"] = Material("data/osu!/skins/default/score-percent.png"),
	["."] = Material("data/osu!/skins/default/score-dot.png"),
}

OSU.GameEnded = false
OSU.CursorPos = {x = 0, y = 0}
OSU.KeyDown = false
OSU.AutoNotes = false
OSU.MusicStarted = false
