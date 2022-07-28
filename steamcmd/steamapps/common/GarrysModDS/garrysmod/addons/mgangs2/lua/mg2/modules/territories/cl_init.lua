--[[
    MGangs 2 - TERRITORIES - (CL) Init
    Developed by Zephruz
]]

CreateClientConVar("mg2_draw_territories", "0", true, false, "Enables territory wireframe visibility.")

surface.CreateFont("mg2.TERRITORYWIREFRAME.LARGE", {
    font = "Abel",
    size = 26,
})

surface.CreateFont("mg2.TERRITORYWIREFRAME.MEDIUM", {
    font = "Abel",
    size = 24,
})

surface.CreateFont("mg2.TERRITORYWIREFRAME.SMALL", {
    font = "Abel",
    size = 20,
})

--[[
    Hooks
]]

-- Draw the territories
hook.Add("PostDrawTranslucentRenderables", "mg2.territories[PostDrawTranslucentRenderables]",
function()
	local tr, eAng = LocalPlayer():GetEyeTrace(), LocalPlayer():EyeAngles()
	local tTbl = MG2_TERRITORIES:GetAll()

	local dTOpt = GetConVar("mg2_draw_territories")

	if (dTOpt && tobool(dTOpt:GetInt())) then
		for k,v in pairs(tTbl) do
			local name, col, bounds = v:GetName(), v:GetColor(), v:GetBounds()
			local bPos1, bPos2 = bounds[1], bounds[2]

			-- Draw wireframe
			render.DrawWireframeBox(bPos1, Angle(0,0,0), Vector(0,0,0), bPos2, col, false)
		end
	end
end)

-- Draw territory display
hook.Add("HUDPaint", "mg2.territores[HUDPaint]",
function()
	if (MG2_TERRITORIES.config.showHUD) then
		local tTbl = MG2_TERRITORIES:GetAll()

		for k,v in pairs(tTbl) do
			if !(v) then continue end

			local name, desc, col, bounds, claimed = v:GetName(), v:GetDescription(), v:GetColor(), v:GetBounds(), v:GetClaimed()
			local values = {
				{
					value = name,
					x = ScrW()/2, y = 30,
					font = "mg2.TERRITORYWIREFRAME.LARGE"
				},
				{
					value = desc,
					x = ScrW()/2, y = 55,
					font = "mg2.TERRITORYWIREFRAME.SMALL"
				},
				{
					value = (claimed && mg2.lang:GetTranslation("territory.ControlledBy", claimed.gangName) || mg2.lang:GetTranslation("unclaimed")),
					x = ScrW()/2, y = 75,
					font = "mg2.TERRITORYWIREFRAME.SMALL"
				},
			}

			local bPos1, bPos2 = bounds[1], bounds[2]
			bPos2 = LocalToWorld(bPos2, Angle(0,0,0), bPos1, Angle(0,0,0))

			local inBounds = LocalPlayer():EyePos():WithinAABox(bPos1, bPos2)
			
			if !(inBounds) then continue end

			local bW, bH = 0, 0

			-- Calculate box w/h
			for _,val in pairs(values) do
				local valW, valH = zlib.util:GetTextSize(val.value, val.font)

				if (valW > bW) then bW = valW end
				bH = bH + valH
			end

			bW = bW + 10

			local bX, bY = (ScrW()/2 - bW/2), 30

			-- Draw box & text
			draw.RoundedBoxEx(5, bX - 2, bY - 2, bW + 4, bH + 4, (col or Color(255,255,255)), true, true, true, true)
			draw.RoundedBoxEx(5, bX, bY, bW, bH, Color(55,55,55,255), true, true, true, true)
			draw.SimpleText(mg2.lang:GetTranslation("territory.YouAreIn"), "mg2.TERRITORYWIREFRAME.MEDIUM", ScrW()/2, 5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

			for _,val in pairs(values) do
				draw.SimpleText(val.value, val.font, val.x, val.y, (val.color or Color(255,255,255,255)), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			end
		end
	end
end)