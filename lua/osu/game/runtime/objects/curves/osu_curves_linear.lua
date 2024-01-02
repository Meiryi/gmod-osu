--[[
	Gmod osu! - An unofficial port of osu! to Garry's mod.
	None of these codes should be modified or changed without original author's permission, anykind of modification is not allowed.

	You can use it on whatever you like, but you should not claim you're the original author,
	If you're a server owner, do not put this addon behind paywall, or some vip shit

	For translators, if you want to translate this addon, please contact me directly instead of modify the code
	REUPLOAD / REPACK IS NOT ALLOWED

	Copyright (C) 2023 Meika. All rights reserved
]]

function OSU:LinearCurves(points)
	-- Split it into a 2 point bezier
	local temp = {}
	for k,v in next, points do
		local _next = points[k + 1]
		if(_next == nil) then continue end
		local step = 1 / math.Distance(v.x, v.y, _next.x, _next.y)
		for i = 0, 1, step do
			table.insert(temp, OSU:BezierCurve(i, {v, _next}))
		end
	end
	return temp
end