include("shared.lua")

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()

	if zrush.f.DrawUI() and zrush.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 500) then
		self:Draw_MainInfo(-90, 9)
		self:Draw_MainInfo(90, -9)
	end
end

local l_pos = Vector(-9,0,5)
local l_ang = Angle(0,-90,90)

function ENT:Draw_MainInfo(angoffset, posoffset)

	cam.Start3D2D(self:LocalToWorld(l_pos), self:LocalToWorldAngles(l_ang), 0.1)
		local mId = self:GetMachineID()
		local text = "nil"

		if (mId ~= "nil") then
			surface.SetDrawColor(zrush.default_colors["white03"])
			surface.SetMaterial(zrush.default_materials[mId])
			surface.DrawTexturedRect(-120, -73, 240, 240)
		end

		if (mId == "nil") then
			text = zrush.language.MachineCrate["BuyMachine"]
		else
			text = zrush.language.MachineCrate[mId]
		end

		draw.RoundedBox(25, -200, -60, 400, 100, zrush.default_colors["black02"])
		draw.DrawText(text, "zrush_machinecrate_font01", 0, -60, zrush.default_colors["white01"], TEXT_ALIGN_CENTER)

		if (self.InstalledModules and table.Count(self.InstalledModules) > 0) then
			draw.RoundedBox(25, -200, 45, 400, 100, zrush.default_colors["black02"])

			for k, v in pairs(self.InstalledModules) do
				local mData = zrush.AbilityModules[v + 1]

				if (mData) then
					local mType = mData.type
					local mAmount = mData.amount
					local mIcon = zrush.default_materials["circle"]

					if (mType == "speed") then
						mIcon = zrush.default_materials["module_speed"]
					elseif (mType == "production") then
						mIcon = zrush.default_materials["module_production"]
					elseif (mType == "antijam") then
						mIcon = zrush.default_materials["module_antijam"]
					elseif (mType == "cooling") then
						mIcon = zrush.default_materials["module_cooling"]
					elseif (mType == "pipes") then
						mIcon = zrush.default_materials["module_morepipes"]
					elseif (mType == "refining") then
						mIcon = zrush.default_materials["module_refining"]
					end

					local atext = "nil"

					if (mType == "pipes") then
						atext = "+" .. tostring(mAmount)
					else
						atext = "+" .. tostring(100 * mAmount) .. "%"
					end

					surface.SetDrawColor(zrush.default_colors["grey03"])
					surface.SetMaterial(zrush.default_materials["circle"])
					surface.DrawTexturedRect(-300 + (100 * k), 45, 100, 100)

					surface.SetDrawColor(mData.color)
					surface.SetMaterial(mIcon)
					surface.DrawTexturedRect(-286 + (100 * k), 60, 70, 70)

					draw.DrawText(atext, "zrush_machinecrate_font02", -250 + (100 * k), 80, zrush.default_colors["white01"], TEXT_ALIGN_CENTER)
				end
			end
		end

	cam.End3D2D()
end
