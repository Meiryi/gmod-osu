OSU.Unpacking = false
OSU.UnpackingQuery = {}

function OSU:PickFileExtension(ext)
	local l = {
		[".osu"] = ".dem",
		[".osb"] = ".vcd",
	}
	local ret = l[ext]
	if(ret == nil) then
		return ext
	end
	return ret
end

function OSU:GetDirCount(str)
	local count = 0
	for i = 1, #str, 1 do
		if(str[i] == "/") then count = count + 1 end
	end
	return count
end

function OSU:UnpackBeatmap(osz)
	if(!file.Exists("osu!/download/"..osz..".dat", "DATA")) then
		return
	end
	local zip = file.Read("osu!/download/"..osz..".dat", "DATA")
	file.CreateDir("osu!/beatmaps/"..osz.."/")
	for _,name,offset,size,packed,crc in zzlib.files(zip) do
		if(OSU:GetDirCount(name) > 0) then continue end -- Don't unpack storyboard
	    local ctx = zzlib.unzip(zip, name)
	    local ext = "."..string.GetExtensionFromFilename(name)
	    local n_ext = string.Replace(name, ext, "")
	    local _ext = OSU:PickFileExtension(ext)
	    n_ext = string.Replace(n_ext, ".", "")
	    file.Write("osu!/beatmaps/"..osz.."/"..n_ext.._ext, ctx)
	end
	OSU:SideNotify("Beatmap set "..osz.."\nUnpacked successfully!", 2)

	file.Delete("osu!/download/"..osz..".dat")
end

function OSU:InsertUnpackQuery(_SetID)
	OSU.UnpackingQuery[_SetID] = true
end

local runinterval = 0
hook.Add("Think", "OSU_UnpackQuery", function()
	if(runinterval > OSU.CurTime) then return end
	if(!OSU.Unpacking) then return end
	for k,v in next, OSU.UnpackingQuery do
		OSU:UnpackBeatmap(k)
		OSU.UnpackingQuery[k] = nil
		break
	end
	if(OSU.Unpacking) then
		if(table.Count(OSU.UnpackingQuery) <= 0) then
			OSU.Unpacking = false
		end
	end
	runinterval = OSU.CurTime + 0.5
end)