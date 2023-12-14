OSU.ReplayData = {}
OSU.ReplayData.HitData = {}
OSU.ReplayData.MouseData = {
	["bnk_1"] = {}
}
OSU.ReplayData.KeyData = {}
OSU.ReplayData.Specs = {
	w = ScrW(),
	h = ScrH(),
	skip = -1,
}
function OSU:ResetReplayData()
	OSU.ReplayData = {}
	OSU.ReplayData.HitData = {}
	OSU.ReplayData.MouseData = {
		["bnk_1"] = {}
	}
	OSU.ReplayData.KeyData = {}
	OSU.ReplayData.Specs = {
		w = ScrW(),
		h = ScrH(),
		skip = -1,
	}
end

function OSU:InsertSkipTime(time)
	OSU.ReplayData.Specs.skip = time
end

function OSU:RecordFrame(data)
	if(OSU.AutoNotes) then return end
	if(#OSU.ReplayData.MouseData["bnk_"..OSU.CurrentTableIndex] < 4096) then
		table.insert(OSU.ReplayData.MouseData["bnk_"..OSU.CurrentTableIndex], data)
	else
		OSU.CurrentTableIndex = OSU.CurrentTableIndex + 1
		if(OSU.ReplayData.MouseData["bnk_"..OSU.CurrentTableIndex] == nil) then
			OSU.ReplayData.MouseData["bnk_"..OSU.CurrentTableIndex] = {}
			table.insert(OSU.ReplayData.MouseData["bnk_"..OSU.CurrentTableIndex], data)
		end
	end
end

function OSU:OutputReplayFile(bID, rID)
	if(!file.Exists("osu!/replay/"..bID.."/", "DATA")) then
		file.CreateDir("osu!/replay/"..bID)
	end
	local _file = file.Write("osu!/replay/"..bID.."/"..rID..".dem", util.TableToJSON(OSU.ReplayData))
end

function OSU:RecordInputs()

end