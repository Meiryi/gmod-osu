--[[
	Gmod osu! - An unofficial port of osu! to Garry's mod.
	None of these codes should be modified or changed without original author's permission, anykind of modification is not allowed.

	You can use it on whatever you like, but you should not claim you're the original author,
	If you're a server owner, do not put this addon behind paywall, or some vip shit

	For translators, if you want to translate this addon, please contact me directly instead of modify the code
	REUPLOAD / REPACK IS NOT ALLOWED

	Copyright (C) 2023 Meika. All rights reserved
]]

function OSU:CreateApproachCircle(vec_2t, fadein, dec, radius)
	if(OSU.HD && OSU.CurrentZPos < 32766) then return end
	local oradius = radius
	radius = radius * 3
	local offs = radius / 2
	local circle = vgui.Create("DImage", OSU.PlayFieldLayer)
		circle.iAlpha = 0
		circle:SetImage(OSU.CurrentSkin["approachcircle"])
		circle:SetSize(radius, radius)
		circle:SetZPos(32766)
		circle:SetPos(vec_2t.x - offs, vec_2t.y - offs)
		circle:SetImageColor(OSU.CurrentObjectColor)
		circle.Think = function()
			radius = math.Clamp(radius - OSU:GetFixedValue(dec), oradius, oradius * 3)
			circle.iAlpha = math.Clamp(circle.iAlpha + OSU:GetFixedValue(fadein), 0, 255)
			circle:SetAlpha(circle.iAlpha)
			offs = radius / 2
			circle:SetSize(radius, radius)
			circle:SetPos(vec_2t.x - offs, vec_2t.y - offs)
			if(radius <= oradius) then
				circle:Remove()
			end
		end
	return circle
end