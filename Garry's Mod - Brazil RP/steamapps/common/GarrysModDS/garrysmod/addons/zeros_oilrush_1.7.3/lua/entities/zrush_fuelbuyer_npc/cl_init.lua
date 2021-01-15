include("shared.lua")

local offsetX, offsetY = -140, 125

function ENT:Initialize()
	// Lets sort the fuel table only once so we dont need do redo it all the time in update
	self.FuelTableSorted = {}
	table.CopyFromTo(zrush.Fuel, self.FuelTableSorted)
	table.sort(self.FuelTableSorted, function(a, b) return a.price > b.price end)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()

	if zrush.f.DrawUI() and zrush.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 500) then
		self:DrawInfo()
	end
end

function ENT:DrawInfo()

	self.PriceMul = self:GetPrice_Mul()

	cam.Start3D2D(self:LocalToWorld(Vector(0,0,85 + 1 * math.abs(math.sin(CurTime()) * 1))), Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 0.1)

		// Title
		draw.SimpleTextOutlined(zrush.language.NPC["FuelBuyer"], "zrush_npc_font01", 0, -10, zrush.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, zrush.default_colors["black03"])

		// Profit
		draw.RoundedBox(25, -200, 50, 400, 50, zrush.default_colors["black02"])
		local progress = (1 / zrush.config.FuelBuyer.MaxBuyRate) * self.PriceMul
		local pColor = zrush.f.LerpColor(progress, zrush.default_colors["red04"], zrush.default_colors["green04"])

		local sellProfit = self:GetPrice_Mul() - 100
		if sellProfit > 0 then
			sellProfit = "+ " .. sellProfit
		end
		draw.DrawText(zrush.language.NPC["Profit"], "zrush_npc_font02", -175, 60, zrush.default_colors["white01"], TEXT_ALIGN_LEFT)
		draw.DrawText(sellProfit .. "%", "zrush_npc_font02", 190, 62, pColor, TEXT_ALIGN_RIGHT)

		// Fuel Info
		draw.RoundedBox(25, -200, 110, 120, 45 + (30 * table.Count(zrush.Fuel)), zrush.default_colors["black02"])
		draw.DrawText(zrush.config.Currency .. " / " .. zrush.config.UoM, "zrush_npc_font02", -140, 120, zrush.default_colors["white01"], TEXT_ALIGN_CENTER)

		if self.FuelTableSorted then
			for k, v in pairs(self.FuelTableSorted) do
				self:DrawResourceItem(v, -50, 30 * k, 20)
			end
		end

	cam.End3D2D()
end

function ENT:DrawResourceItem(fuelData, xpos, ypos, size)

	local price = math.Round(fuelData.price * (self.PriceMul / 100))

	surface.SetDrawColor(fuelData.color)
	surface.SetMaterial(zrush.default_materials["barrel_icon"])
	surface.DrawTexturedRect(xpos + offsetX, ypos + offsetY, size, size)

	draw.DrawText(zrush.config.Currency .. price, "zrush_npc_font03", xpos + offsetX + 25, ypos + offsetY + size * 0.1, zrush.default_colors["white01"], TEXT_ALIGN_LEFT)
end
