--[[
	Gmod osu! - An unofficial port of osu! to Garry's mod.
	None of these codes should be modified or changed without original author's permission, anykind of modification is not allowed.

	You can use it on whatever you like, but you should not claim you're the original author,
	If you're a server owner, do not put this addon behind paywall, or some vip shit

	For translators, if you want to translate this addon, please contact me directly instead of modify the code
	REUPLOAD / REPACK IS NOT ALLOWED

	Copyright (C) 2023 Meika. All rights reserved
]]

if(CLIENT) then
	include("osu/osu_globalvars.lua")
	include("osu/osu_localization.lua")
	include("osu/osu_skin_precache.lua")
	include("osu/osu_skin_manager.lua")
	include("osu/osu_dev_functions.lua")
	include("osu/osu_beats.lua")

	include("osu/audio/osu_audio.lua")
	include("osu/audio/osu_soundduration.lua")

	include("osu/game/osu_definitions.lua")
	include("osu/game/osu_panel.lua")
	include("osu/game/osu_panel_func.lua")
	include("osu/game/osu_options.lua")
	include("osu/game/osu_scenes.lua")
	include("osu/game/osu_resultpanel.lua")
	include("osu/game/osu_failpanel.lua")
	include("osu/game/osu_webapi.lua")
	include("osu/game/osu_htmlparser.lua")
	include("osu/game/osu_authorizator.lua")
	include("osu/game/osu_rankingpanel.lua")
	include("osu/game/osu_mods.lua")
	include("osu/game/osu_performance.lua")

	include("osu/game/replay/osu_replay_recorder.lua")
	include("osu/game/replay/osu_replay_importer.lua")

	include("osu/game/zzlib/inflate-bit32.lua")
	include("osu/game/zzlib/zzlib.lua")

	include("osu/game/beatmap_downloader/osu_beatmap_web_panel.lua")
	include("osu/game/beatmap_downloader/osu_unpacker.lua")

	include("osu/game/beatmap_panel/osu_beatmap_panel.lua")

	include("osu/game/beatmap_reader/osu_beatmap_reader.lua")
	include("osu/game/beatmap_reader/osu_timingpoints.lua")
	include("osu/game/beatmap_reader/osu_difficultycalculator.lua")

	include("osu/game/runtime/osu_runtime.lua")
	include("osu/game/runtime/osu_runtime_vars.lua")
	include("osu/game/runtime/osu_runtime_setup.lua")

	include("osu/game/runtime/mania/osu_mania_ui.lua")
	include("osu/game/runtime/mania/osu_mania_note.lua")
	include("osu/game/runtime/mania/osu_mania_holdnote.lua")
	include("osu/game/runtime/mania/osu_mania_shared.lua")

	include("osu/game/runtime/objects/osu_objects_approach_rate.lua")
	include("osu/game/runtime/objects/osu_objects_approach_circle.lua")
	include("osu/game/runtime/objects/osu_objects_skip.lua")
	include("osu/game/runtime/objects/osu_objects_circle.lua")
	include("osu/game/runtime/objects/osu_objects_slider.lua")
	include("osu/game/runtime/objects/osu_objects_spinner.lua")
	include("osu/game/runtime/objects/osu_objects_effect.lua")
	include("osu/game/runtime/objects/osu_objects_hitscore.lua")
	include("osu/game/runtime/objects/osu_objects_overall_difficulty.lua")
	include("osu/game/runtime/objects/osu_objects_hitsound.lua")
	include("osu/game/runtime/objects/osu_objects_shared.lua")
	include("osu/game/runtime/objects/curves/osu_curves_bezier.lua")
	include("osu/game/runtime/objects/curves/osu_curves_linear.lua")
	include("osu/game/runtime/objects/curves/osu_curves_catmullrom.lua")
	include("osu/game/runtime/objects/curves/osu_curves_type.lua")
	concommand.Add("osu", function(ply, cmd, args)
		OSU:Startup()
	end)
end

if(SERVER) then
	include("osu/osu_serverhook.lua")

	AddCSLuaFile("osu/osu_globalvars.lua")
	AddCSLuaFile("osu/osu_localization.lua")
	AddCSLuaFile("osu/osu_skin_precache.lua")
	AddCSLuaFile("osu/osu_skin_manager.lua")
	AddCSLuaFile("osu/osu_dev_functions.lua")
	AddCSLuaFile("osu/osu_beats.lua")

	AddCSLuaFile("osu/audio/osu_audio.lua")
	AddCSLuaFile("osu/audio/osu_soundduration.lua")

	AddCSLuaFile("osu/game/osu_definitions.lua")
	AddCSLuaFile("osu/game/osu_panel.lua")
	AddCSLuaFile("osu/game/osu_panel_func.lua")
	AddCSLuaFile("osu/game/osu_options.lua")
	AddCSLuaFile("osu/game/osu_scenes.lua")
	AddCSLuaFile("osu/game/osu_resultpanel.lua")
	AddCSLuaFile("osu/game/osu_failpanel.lua")
	AddCSLuaFile("osu/game/osu_webapi.lua")
	AddCSLuaFile("osu/game/osu_htmlparser.lua")
	AddCSLuaFile("osu/game/osu_authorizator.lua")
	AddCSLuaFile("osu/game/osu_rankingpanel.lua")
	AddCSLuaFile("osu/game/osu_mods.lua")
	AddCSLuaFile("osu/game/osu_performance.lua")

	AddCSLuaFile("osu/game/replay/osu_replay_recorder.lua")
	AddCSLuaFile("osu/game/replay/osu_replay_importer.lua")

	AddCSLuaFile("osu/game/zzlib/inflate-bit32.lua")
	AddCSLuaFile("osu/game/zzlib/zzlib.lua")

	AddCSLuaFile("osu/game/beatmap_downloader/osu_beatmap_web_panel.lua")
	AddCSLuaFile("osu/game/beatmap_downloader/osu_unpacker.lua")

	AddCSLuaFile("osu/game/beatmap_panel/osu_beatmap_panel.lua")

	AddCSLuaFile("osu/game/beatmap_reader/osu_beatmap_reader.lua")
	AddCSLuaFile("osu/game/beatmap_reader/osu_timingpoints.lua")
	AddCSLuaFile("osu/game/beatmap_reader/osu_difficultycalculator.lua")

	AddCSLuaFile("osu/game/runtime/osu_runtime.lua")
	AddCSLuaFile("osu/game/runtime/osu_runtime_vars.lua")
	AddCSLuaFile("osu/game/runtime/osu_runtime_setup.lua")

	AddCSLuaFile("osu/game/runtime/mania/osu_mania_ui.lua")
	AddCSLuaFile("osu/game/runtime/mania/osu_mania_note.lua")
	AddCSLuaFile("osu/game/runtime/mania/osu_mania_holdnote.lua")
	AddCSLuaFile("osu/game/runtime/mania/osu_mania_shared.lua")

	AddCSLuaFile("osu/game/runtime/objects/osu_objects_approach_rate.lua")
	AddCSLuaFile("osu/game/runtime/objects/osu_objects_approach_circle.lua")
	AddCSLuaFile("osu/game/runtime/objects/osu_objects_skip.lua")
	AddCSLuaFile("osu/game/runtime/objects/osu_objects_circle.lua")
	AddCSLuaFile("osu/game/runtime/objects/osu_objects_slider.lua")
	AddCSLuaFile("osu/game/runtime/objects/osu_objects_spinner.lua")
	AddCSLuaFile("osu/game/runtime/objects/osu_objects_effect.lua")
	AddCSLuaFile("osu/game/runtime/objects/osu_objects_hitscore.lua")
	AddCSLuaFile("osu/game/runtime/objects/osu_objects_overall_difficulty.lua")
	AddCSLuaFile("osu/game/runtime/objects/osu_objects_hitsound.lua")
	AddCSLuaFile("osu/game/runtime/objects/osu_objects_shared.lua")
	AddCSLuaFile("osu/game/runtime/objects/curves/osu_curves_bezier.lua")
	AddCSLuaFile("osu/game/runtime/objects/curves/osu_curves_linear.lua")
	AddCSLuaFile("osu/game/runtime/objects/curves/osu_curves_catmullrom.lua")
	AddCSLuaFile("osu/game/runtime/objects/curves/osu_curves_type.lua")
end

file.CreateDir("osu!")
file.CreateDir("osu!/skins")
file.CreateDir("osu!/skins/default/")
file.CreateDir("osu!/beatmaps")
file.CreateDir("osu!/dev")
file.CreateDir("osu!/logs")
file.CreateDir("osu!/replay")
file.CreateDir("osu!/cache")
file.CreateDir("osu!/cache/hitobjects")
file.CreateDir("osu!/ret")
file.CreateDir("osu!/avatars")
file.CreateDir("osu!/avatars/frames")
file.CreateDir("osu!/download")
file.CreateDir("osu!/cards")
file.Write("osu!/skins/do not edit default skin.txt", "Although you can, but don't modify default skins, it'll cause unexpected result.")