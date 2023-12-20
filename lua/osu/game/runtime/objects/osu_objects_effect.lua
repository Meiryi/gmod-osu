--[[
	Gmod osu! - An unofficial port of osu! to Garry's mod.
	None of these codes should be modified or changed without original author's permission, anykind of modification is not allowed.

	You can use it on whatever you like, but you should not claim you're the original author,
	If you're a server owner, do not put this addon behind paywall, or some vip shit

	For translators, if you want to translate this addon, please contact me directly instead of modify the code
	REUPLOAD / REPACK IS NOT ALLOWED

	Copyright (C) 2023 Meika. All rights reserved
]]

function OSU:CreateClickEffect(radius, vec_2t, zp, clr)
	if(OSU.HD) then return end
	if(zp >= 32767) then -- Maximum Z pos for panels is -32767 to 32767
		zp = 32766
	end
	local offs = radius / 2
	local ext = radius * 0.45
	local cext = 0
	local circle = vgui.Create("DImage", OSU.PlayFieldLayer.UpperLayer)
		circle.iAlpha = 255
		circle:SetZPos(zp + 1)
		circle:SetImage(OSU.CurrentSkin["hitcircleoverlay"])
		circle:SetSize(radius, radius)
		circle:SetPos(vec_2t.x - offs, vec_2t.y - offs)
		circle:SetImageColor(clr)
		circle.Think = function()
			circle.iAlpha = math.Clamp(circle.iAlpha - OSU:GetFixedValue(25), 0, 255)
			cext = math.Clamp(cext + OSU:GetFixedValue(math.abs(ext - cext) * 0.1), 0, ext)
			circle:SetSize(radius + cext, radius + cext)
			offs = (radius / 2) + cext / 2
			circle:SetPos(vec_2t.x - offs, vec_2t.y - offs)
			circle:SetAlpha(circle.iAlpha)
			if(circle.iAlpha <= 0) then
				circle:Remove()
			end
		end
end