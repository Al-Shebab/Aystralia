
function sKore.getCircleVertices(x, y, radius)
	local circle = {}
	local segments = math.Clamp(math.ceil(math.pi * radius / 30), 25, 1024)
	for segment = 0, segments - 1 do
		local angle = -2 * math.pi * segment / segments
		table.insert(circle, {
			["x"] = x + math.cos(angle) * radius,
			["y"] = y - math.sin(angle) * radius
		})
	end
	return circle
end

function sKore.drawCircle(x, y, radius)
	surface.DrawPoly(sKore.getCircleVertices(x, y, radius))
end

function sKore.updateShadowFactor()
	sKore.shadowFactor = (11 / 12) * sKore.getScalingFactor() * 1.3
end
hook.Add("sKoreScaleUpdated", "sKoreUpdateShadowFactor1", sKore.updateShadowFactor)
hook.Add("sKoreScalingReloaded", "sKoreUpdateShadowFactor2", sKore.updateShadowFactor)
sKore.updateShadowFactor()

function sKore.drawShadow(on, of)
	local ofElevation = of.GetElevation and of:GetElevation() or 0
	local onElevation = on.GetElevation and on:GetElevation() or 0

	local elevationDiff = ofElevation - onElevation
	if elevationDiff <= 0 then return end
	local offset = elevationDiff * sKore.shadowFactor

	local x, y = on:ScreenToLocal(of:LocalToScreen(0, 0))
	x, y = x + math.ceil(offset * (of.shadowOffsetX or 1)), y + math.ceil(offset * (of.shadowOffsetY or 1))
	local onWidth, onHeight = on:GetSize()
	local ofWidth, ofHeight = of:GetSize()
	if x > onWidth or y > onHeight or x < -ofWidth or y < -ofHeight then return end

	if of.PaintShadow then
		of:PaintShadow(x, y)
	else
		draw.RoundedBox(sKore.scale(6), x, y, ofWidth, ofHeight, sKore.getShadowColour())
	end
end

function sKore.drawShadows(panel)
	if panel.GetDrawShadows and !panel:GetDrawShadows() then return end

	if panel.AddShadow then
		for key, drawShadow in pairs(panel.shadows or {}) do
			if drawShadow:IsValid() then
				if !drawShadow:IsVisible() or !drawShadow:GetPaintShadow() or drawShadow:IsGlobalShadow() then continue end
				sKore.drawShadow(panel, drawShadow)
			else
				panel.shadows[key] = nil
			end
		end

		if !panel:GetDrawGlobalShadows() then return end

		local frame = panel.globalShadows != nil and panel or panel.frame

		if frame != nil and frame.globalShadows != nil then
			for drawShadow, _ in pairs(frame.globalShadows) do
				if IsValid(drawShadow) then
					if !drawShadow:IsVisible() then continue end
					sKore.drawShadow(panel, drawShadow)
				else
					frame.globalShadows[drawShadow] = nil
				end
			end
		end
	end
end
