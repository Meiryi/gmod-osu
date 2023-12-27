function OSU:CreateGrid(parent, x)
	local grid = parent:Add("DImage")
	 grid:SetSize(ScreenScale(1), ScrH())
	 grid:SetX(x)
	 grid.Paint = function()
	 	draw.RoundedBox(0, 0, 0, grid:GetWide(), grid:GetTall(), Color(255, 255, 255, 255))
	end
end

function OSU:CreateKey(field, x, w, idx)
	local key = OSU:CreateFrame(field, x, 0, w, ScrH(), Color(255, 255, 255, 0), false)
		local fw, fh = OSU:GetMaterialSize(OSU.CurrentSkin["mania-stage-light"])
		local img = OSU.CurrentSkin["mania-key1"]
		local _w, _h = OSU:GetMaterialSize(img)
		local light = OSU:CreateImage(key, 0, ScrH() - (_h + fh), _w, fh, OSU.CurrentSkin["mania-stage-light"], false)
		local keyinput = OSU:CreateImage(key, 0, ScrH() - _h, _w, _h, img, false)
		local alp = 20
		local falp = 0
			keyinput.clr = 0
			keyinput.Think = function()
				if(input.IsKeyDown(OSU.ManiaKeys[idx])) then
					keyinput.clr = math.Clamp(keyinput.clr + OSU:GetFixedValue(alp), 0, 75)
					falp = math.Clamp(falp + OSU:GetFixedValue(alp), 0, 150)
				else
					keyinput.clr = math.Clamp(keyinput.clr - OSU:GetFixedValue(alp), 0, 75)
					falp = math.Clamp(falp - OSU:GetFixedValue(alp), 0, 150)
				end
				local clr = 180 + keyinput.clr
				keyinput:SetImageColor(Color(clr, clr, clr, 255))
				light:SetAlpha(falp)
			end
	return key
end