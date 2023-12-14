util.AddNetworkString("osu.RunGame")

function OpenOSUGame(ply)
	net.Start("OSU.RunGame")
	net.Send(ply)
end

hook.Add("PlayerSay", "OSU_ChatHook", function(ply, text)
	if(!IsValid(ply)) then return end
	if(text == "/osu") then
		OpenOSUGame(ply)
	end
end)