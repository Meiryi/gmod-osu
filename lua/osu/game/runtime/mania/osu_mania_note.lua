function OSU:CreateManiaNote(col, sd)
	local w, h = OSU:PickMaterialSize(OSU.ManiaNoteTextures["note1"])
	local ptime = OSU.CurTime
	local note = OSU.PlayFieldLayer.ColumnField.Keys[col]:Add("DImage")
		note:SetImage(OSU.CurrentSkin["mania-note1"])
		note:SetSize(OSU.PlayFieldLayer.ColumnField.Keys[col]:GetWide(), ScreenScale(8))
		note.Think = function()
			note:SetY(note:GetY() + OSU:GetFixedValue(OSU.ManiaFallSpeed))
		end
end