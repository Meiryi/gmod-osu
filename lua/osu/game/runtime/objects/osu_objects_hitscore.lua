--[[
	Gmod osu! - An unofficial port of osu! to Garry's mod.
	None of these codes should be modified or changed without original author's permission, anykind of modification is not allowed.

	You can use it on whatever you like, but you should not claim you're the original author,
	If you're a server owner, do not put this addon behind paywall, or some vip shit

	For translators, if you want to translate this addon, please contact me directly instead of modify the code
	REUPLOAD / REPACK IS NOT ALLOWED

	Copyright (C) 2023 Meika. All rights reserved
]]

function OSU:GetHitImage(type)
	local tList = {
		[1] = "hit300",
		[2] = "hit100",
		[3] = "hit50",
		[4] = "hit0",
	}
	return OSU.CurrentSkin[tList[type]]
end

function OSU:GetHitImageSize(type)
	local w = OSU.Hit300Tx:GetInt("$realwidth")
	local h = OSU.Hit300Tx:GetInt("$realheight")
	local scl = ScrW() / 1920
	if(type == 1) then
		w = OSU.Hit300Tx:GetInt("$realwidth")
		h = OSU.Hit300Tx:GetInt("$realheight")
	elseif(type == 2) then
		w = OSU.Hit100Tx:GetInt("$realwidth")
		h = OSU.Hit100Tx:GetInt("$realheight")
	elseif(type == 3) then
		w = OSU.Hit50Tx:GetInt("$realwidth")
		h = OSU.Hit50Tx:GetInt("$realheight")
	elseif(type == 4) then
		w = OSU.Hit0Tx:GetInt("$realwidth")
		h = OSU.Hit0Tx:GetInt("$realheight")
	end
	return osu_vec2t(w * scl, h * scl)
end

function OSU:CreateHitScore(vec_2t, type)
	if(type == 1 && !OSU.PerfectHit) then return end
	local vFadeOut = 0
	local vTime = OSU.CurTime + 0.07
	local vSwitch = false
	local yOffs = 0
	local cext = 0
	local size_2t = OSU:GetHitImageSize(type)
	local offsx, offsy = size_2t.x / 2, size_2t.y / 2
	local circle = vgui.Create("DImage", OSU.PlayFieldLayer)
	local alpinc = 100
		circle.iAlpha = 0
		if(type == 4) then
			alpinc = alpinc * 2
		end
		circle.dec = 0
		circle:SetZPos(32767)
		circle:SetImage(OSU:GetHitImage(type))
		circle:SetSize(size_2t.x, size_2t.y)
		circle:SetPos(vec_2t.x - offsx, vec_2t.y - offsy)
		circle.Think = function()
			if(!vSwitch) then
				circle.iAlpha = math.Clamp(circle.iAlpha + OSU:GetFixedValue(alpinc), 0, 255)
				if(circle.iAlpha >= 255) then
					vSwitch = true
					vFadeOut = OSU.CurTime + 0.15
				end
			else
				if(vFadeOut < OSU.CurTime) then
					if(type == 4) then
						yOffs = yOffs + OSU:GetFixedValue(0.5)
					end
					circle.iAlpha = math.Clamp(circle.iAlpha - OSU:GetFixedValue(math.max(circle.iAlpha * 0.2, 1)), 0, 255)
					if(circle.iAlpha <= 1) then
						circle:Remove()
					end
				end
			end
			circle:SetImageColor(Color(255, 255, 255, circle.iAlpha))
			circle:SetY(vec_2t.y + yOffs - size_2t.y / 2)
		end

	OSU:RunHitObjectsCheck(type)
end