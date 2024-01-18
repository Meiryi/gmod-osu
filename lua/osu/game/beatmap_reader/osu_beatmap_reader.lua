OSU.HITOBJECT_CIRCLE = 1
OSU.HITOBJECT_SLIDER = 2
OSU.HITOBJECT_NEWCOMBO = 4
OSU.HITOBJECT_SPINNER = 8
OSU.HITOBJECT_HOLD_MANIA = 7

OSU.HITSOUND_NORMAL = 0
OSU.HITSOUND_WHISTLE = 1
OSU.HITSOUND_FINISH = 2
OSU.HITSOUND_CLAP = 3

function OSU:GetBeatmapDetails(ctx)
	local details = {
		["BPM"] = 60,
		["TimeGap"] = 0,
		["Objects"] = -1,
		["Circles"] = -1,
		["Sliders"] = -1,
		["Spinners"] = -1,
		["CS"] = -1,
		["AR"] = -1,
		["OD"] = -1,
		["HP"] = -1,
		["Stars"] = -1,
		["Length"] = 1,
		["Video"] = false,
		["VideoFN"] = "NULL",
		["VideoOffset"] = "0",
		["BPMs"] = {},
		["Audiopath"] = "",
	}
	local ctx = string.Explode("\n", ctx)
	local bpm_processing = ""
	local obj_start = 0
	local obj_end = 0
	local obj_count = 0
	local obj_circle = 0
	local obj_slider = 0
	local obj_spinner = 0
	local tps_start = 0
	local tps_end = 0
	local clr_start = 0
	local colors = nil
	local tmp = {}
	for k,v in pairs(ctx) do
		if(string.find(v, "TimingPoints")) then
			bpm_processing = ctx[k + 1]
		end
		if(string.find(v, "CircleSize:")) then
			details["CS"] = string.Replace(v, "CircleSize:")
		end
		if(string.find(v, "ApproachRate:")) then
			details["AR"] = string.Replace(v, "ApproachRate:")
		end
		if(string.find(v, "OverallDifficulty:")) then
			details["OD"] = string.Replace(v, "OverallDifficulty:")
		end
		if(string.find(v, "HPDrainRate:")) then
			details["HP"] = string.Replace(v, "HPDrainRate:")
		end
		if(string.find(v, "TimingPoints")) then
			tps_start = k + 1
		end
		if(string.find(v, "Colours")) then
			clr_start = k + 1
		end
		if(string.find(v, "HitObjects")) then
			obj_start = k + 1
		end
		if(string.find(v, "Video,")) then
			details["Video"] = true
			local _v = string.Explode(",", v)
			local f = string.Replace(_v[3], '"', "")
			f = string.Replace(f, "\r", "")
			details["VideoFN"] = f
			details["VideoOffset"] = _v[2]
		end
	end
	if(tps_start != 0) then
		for i = tps_start, #ctx, 1 do
			if(string.len(ctx[i]) <= 1 || string.find(ctx[i], "HitObjects")) then
				tps_end = i - 1
				break
			end
		end
	end
	if(obj_start != 0) then
		for i = obj_start, #ctx, 1 do
			if(string.len(ctx[i]) <= 0 || i == #ctx) then
				obj_end = i - 1
				break
			end
		end
		for i = obj_start, obj_end, 1 do
			--[[
				Syntax:	x, y, time, type, hitSound, objectParams, hitSample

				type :
					0	Marks the object as a hit circle
					1	Marks the object as a slider
					2	Marks the start of a new combo
					3	Marks the object as a spinner
					4, 5, 6	A 3-bit integer specifying how many combo colours to skip, a practice referred to as "colour hax". Only relevant if the object starts a new combo.
					7	Marks the object as an osu!mania hold note.
			]]
			local lines = string.Explode(",", ctx[i])
			for x,y in pairs(lines) do
				if(x == 3 && i == obj_end) then
					details["Length"] = (tonumber(y) / 1000)
				end
				if(x == 4) then
					local _type = tonumber(y)
					-- https://github.com/itdelatrisu/opsu/blob/28003bfbe5195a97c1d7135d6060d09727768aab/src/itdelatrisu/opsu/beatmap/BeatmapParser.java#L618
					if(bit.band(_type, OSU.HITOBJECT_CIRCLE) > 0) then
						obj_circle = obj_circle + 1
					elseif(bit.band(_type, OSU.HITOBJECT_SLIDER) > 0) then
						obj_slider = obj_slider + 1
					else
						obj_spinner = obj_spinner + 1
					end
				end
			end
		end
		details["Objects"] = obj_end - (obj_start - 1)
	end
	if(clr_start != 0) then
		for i = clr_start, #ctx, 1 do
			local line = ctx[i]
			if(!string.find(line, "Combo")) then
				break
			end
			local st, ed, str = string.find(line, " : ")
			if(ed == nil) then break end
			ed = ed + 1
			local processStr = string.sub(line, ed)
			local ex = string.Explode(",", processStr)
			table.insert(tmp, Color(tonumber(ex[1]), tonumber(ex[2]), tonumber(ex[3]), 255))
		end
	end
	if(bpm_processing != "") then
		for i = tps_start, tps_end, 1 do
			local line = ctx[i]
			local str = string.Explode(",", line)
			if(str[2] == nil) then continue end
			if(tonumber(str[2]) > 0) then
				table.insert(details["BPMs"], 1 / tonumber(str[2]) * 1000 * 60)
			end
		end
		local ret = string.Explode(",", bpm_processing)
		local output = tonumber(ret[2])
		local timegap = tonumber(ret[1])
		details["BPM"] = 1 / output * 1000 * 60
		details["TimeGap"] = timegap / 1000
	end
	details["Circles"] = obj_circle
	details["Sliders"] = obj_slider
	details["Spinners"] = obj_spinner
	details["Object Range"] = {obj_start, obj_end}
	details["Timepoint Range"] = {tps_start, tps_end}
	if(#tmp > 0) then
		details["Colours"] = tmp
	else
		details["Colours"] = {Color(255, 255, 255, 255)}
	end
	return details
end