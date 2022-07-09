module('draw', package.seeall)

function FilledCircle(x, y, radius, seg, color)
	surface.SetDrawColor(color)
	surface.DrawPoly(GenerateCircle(x, y, radius, seg))
end

function GenerateCircle(x, y, radius, seg)
	local circlePolygon = {}

	surface.SetTexture(0)
	table.insert(circlePolygon, { x = x, y = y, u = 0.5, v = 0.5 })

	for i = 0, seg do
		local a = math.rad((i / seg) * -360)
		table.insert(circlePolygon, { x = x + math.sin(a) * radius, y = y + math.cos(a) * radius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5 } )
	end

	local a = math.rad(0)
	table.insert(circlePolygon, { x = x + math.sin(a) * radius, y = y + math.cos(a) * radius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5 })
	return circlePolygon
end