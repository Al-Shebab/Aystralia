include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	if zrush.f.DrawUI() and zrush.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 200) then
		self:Draw_MainInfo()
	end
end

function ENT:Initialize()
	self.moduledata = zrush.AbilityModules[self:GetAbilityID()]
	local mType = self.moduledata.type

	if (mType == "speed") then
		self.Icon = zrush.default_materials["module_speed"]
	elseif (mType == "production") then
		self.Icon = zrush.default_materials["module_production"]
	elseif (mType == "antijam") then
		self.Icon = zrush.default_materials["module_antijam"]
	elseif (mType == "cooling") then
		self.Icon = zrush.default_materials["module_cooling"]
	elseif (mType == "pipes") then
		self.Icon = zrush.default_materials["module_morepipes"]
	elseif (mType == "refining") then
		self.Icon = zrush.default_materials["module_refining"]
	end

	if (self.moduledata.type == "pipes") then
		self.text = "+" .. tostring(self.moduledata.amount)
	else
		self.text = "+" .. tostring(100 * self.moduledata.amount) .. "%"
	end
end

local l_pos = Vector(-5, -5, -4.6)
local l_ang = Angle(0, 0, 180)


function ENT:Draw_MainInfo()
	if (self.moduledata ~= nil and IsValid(self)) then
		cam.Start3D2D(self:LocalToWorld(l_pos), self:LocalToWorldAngles(l_ang), 0.1)
			surface.SetDrawColor(zrush.default_colors["grey03"])
			surface.SetMaterial(zrush.default_materials["circle"])
			surface.DrawTexturedRect(0, 0, 100, 100)

			surface.SetDrawColor(self.moduledata.color)
			surface.SetMaterial(self.Icon)
			surface.DrawTexturedRect(15, 15, 70, 70)

			draw.DrawText(self.text, "zrush_module_font01", 55, 30, zrush.default_colors["white01"], TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Think()
	self:SetNextClientThink(CurTime())

	return true
end
