--[[
	Gmod osu! - An unofficial port of osu! to Garry's mod.
	None of these codes should be modified or changed without original author's permission, anykind of modification is not allowed.

	You can use it on whatever you like, but you should not claim you're the original author,
	If you're a server owner, do not put this addon behind paywall, or some vip shit

	For translators, if you want to translate this addon, please contact me directly instead of modify the code
	REUPLOAD / REPACK IS NOT ALLOWED

	Copyright (C) 2023 Meika. All rights reserved
]]

function OSU:GetCurves(type, curvePoints, length)
	--[[
		Bézier (B)
		Centripetal catmull-rom (C)
		Linear (L)
		Perfect circle (P)
	]]
	local followPoint = {}
	local realFollowPoint = {}
	local step = 1 / length

	if(type == "B" || type == "C") then
		for i = 0, 1, step do
			if(#curvePoints < 3) then
				table.insert(followPoint, OSU:BezierCurve(i, curvePoints))
			else
				if(#curvePoints == 3) then
					table.insert(followPoint, math.QuadraticBezier(i, curvePoints[1], curvePoints[2], curvePoints[3]))
				else
					table.insert(followPoint, math.BSplinePoint(i, curvePoints, 1))
				end
			end
		end
		if(#curvePoints >= 3) then
			local connect = {}
			local diff = 1 / OSU:PixelToOsuPixel(math.abs((curvePoints[1].x + curvePoints[1].y) - (followPoint[1].x + followPoint[1].y)))
			for _ = 0, 1, diff do
				table.insert(connect, OSU:BezierCurve(_, {curvePoints[1], followPoint[1]}))
			end
			for k,v in next, followPoint do
				table.insert(connect, v)
			end
			followPoint = connect
		end
	elseif(type == "L") then
		followPoint = OSU:LinearCurves(curvePoints)
	elseif(type == "P") then
		if(#curvePoints == 3) then
			local connect = {}
			local _dst = 0
			for x,y in next, curvePoints do
				if(x == #curvePoints) then continue end
				local n = curvePoints[x + 1]
				_dst = _dst + math.Distance(y.x, y.y, n.x, n.y)
			end
			local _step = 1 / _dst
			for _ = 0, 1, _step do
				table.insert(connect, math.QuadraticBezier(_, curvePoints[1], curvePoints[2], curvePoints[3]))
			end
			followPoint = connect
		else
			followPoint = OSU:LinearCurves(curvePoints)
		end
	end

	local start = followPoint[1]
	local curdis = 0
	table.insert(realFollowPoint, followPoint[1])
	for k,v in next, followPoint do
		v.z = 0
		local dis = math.Round(math.Distance(start.x, start.y, v.x, v.y), 2)
		curdis = curdis + dis
		if(math.floor(curdis) >= 0.5) then
			if(math.floor(curdis) >= 1) then
				for i = 0, 1, 1 / curdis do
					table.insert(realFollowPoint, OSU:BezierCurve(i, {start, v}))
				end
			else
				table.insert(realFollowPoint, v)
			end
			curdis = 0
		end
		start = v
	end

	return followPoint, realFollowPoint
end