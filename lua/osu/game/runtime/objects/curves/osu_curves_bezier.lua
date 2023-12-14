--[[
	Gmod osu! - An unofficial port of osu! to Garry's mod.
	None of these codes should be modified or changed without original author's permission, anykind of modification is not allowed.

	You can use it on whatever you like, but you should not claim you're the original author,
	If you're a server owner, do not put this addon behind paywall, or some vip shit

	For translators, if you want to translate this addon, please contact me directly instead of modify the code
	REUPLOAD / REPACK IS NOT ALLOWED

	Copyright (C) 2023 Meika. All rights reserved
]]

function OSU:BezierCurve(T, points)
	local ValuesTable = points
	local NumberOfControlPoints = #ValuesTable - 2
	if NumberOfControlPoints < 0 then end
	local Value = nil
	for i = 1, #ValuesTable do
		local Multiplier = NumberOfControlPoints + 1
		if (i == 1) or (i == #ValuesTable) then
			Multiplier = 1
		end
		local FirstValue = (1 - T)^(NumberOfControlPoints + 1 - (i - 1))
		local FinalValue = T^(NumberOfControlPoints - (-i + NumberOfControlPoints + 1))
		local CurrentValue = (FirstValue * FinalValue) * Multiplier * ValuesTable[i]
		if not Value then
			Value = CurrentValue
		else
			Value = Value + CurrentValue
		end
	end
	return Value
end
