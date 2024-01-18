--[[
	Gmod osu! - An unofficial port of osu! to Garry's mod.
	None of these codes should be modified or changed without original author's permission, anykind of modification is not allowed.

	You can use it on whatever you like, but you should not claim you're the original author,
	If you're a server owner, do not put this addon behind paywall, or some vip shit

	For translators, if you want to translate this addon, please contact me directly instead of modify the code
	REUPLOAD / REPACK IS NOT ALLOWED

	Copyright (C) 2023 Meika. All rights reserved
]]
local QuadraticBezier = math.QuadraticBezier
local BSplinePoint = math.BSplinePoint
local math_abs = math.abs
local table_insert = table.insert
local math_round = math.Round
local math_floor = math.floor
local math_Distance = math.Distance
local math_deg = math.deg
local math_atan2 = math.atan2
local math_rad = math.rad
function OSU:GetCurves(type, curvePoints, length)
	--[[
		Bézier (B)
		Centripetal catmull-rom (C)
		Linear (L)
		Perfect circle (P)
	]]
	local sliderMul = 0.15
	local followPoint = {}
	local realFollowPoint = {}
	local step = 1 / (length * sliderMul)
	if(type == "B" || type == "C") then
		if(#curvePoints >= 8) then
			sliderMul = 0.45
		end
		step = 1 / (length * sliderMul)
		for i = 0, 1, step do
			if(#curvePoints < 3) then
				table_insert(followPoint, OSU:BezierCurve(i, curvePoints))
			else
				if(#curvePoints == 3) then
					table_insert(followPoint, QuadraticBezier(i, curvePoints[1], curvePoints[2], curvePoints[3]))
				else
					table_insert(followPoint, BSplinePoint(i, curvePoints, 1))
				end
			end
		end
		if(#curvePoints >= 3) then
			local connect = {}
			local diff = 1 / (math_Distance(curvePoints[1].x, curvePoints[1].y, followPoint[1].x, followPoint[1].y) * sliderMul)
			for _ = 0, 1, diff do
				table_insert(connect, OSU:BezierCurve(_, {curvePoints[1], followPoint[1]}))
			end
			for k,v in next, followPoint do
				table_insert(connect, v)
			end
			followPoint = connect
		end
	elseif(type == "L") then
		followPoint = OSU:LinearCurves(curvePoints, sliderMul)
	elseif(type == "P") then
		if(#curvePoints == 3) then
			local connect = {}
			local _dst = 0
			for x,y in next, curvePoints do
				if(x == #curvePoints) then continue end
				local n = curvePoints[x + 1]
				_dst = _dst + math_Distance(y.x, y.y, n.x, n.y)
			end
			local _step = 1 / (_dst * sliderMul)
			for _ = 0, 1, _step do
				table_insert(connect, QuadraticBezier(_, curvePoints[1], curvePoints[2], curvePoints[3]))
			end
			followPoint = connect
		else
			followPoint = OSU:LinearCurves(curvePoints, sliderMul)
		end
	end

	local start = followPoint[1]
	local curdis = 0
	table_insert(realFollowPoint, followPoint[1])
	for k,v in next, followPoint do
		v.z = 0
		local dis = math_round(math_Distance(start.x, start.y, v.x, v.y), 2)
		curdis = curdis + dis
		if(math_floor(curdis) >= 0.5) then
			if(math_floor(curdis) >= 1) then
				for i = 0, 1, 1 / (curdis * sliderMul) do
					table_insert(realFollowPoint, OSU:BezierCurve(i, {start, v}))
				end
			else
				table_insert(realFollowPoint, v)
			end
			curdis = 0
		end
		start = v
	end

	return followPoint, realFollowPoint
end