include("shared.lua")

function ENT:Initialize()
    zrush.f.EntList_Add(self)
end

function ENT:OnRemove()
    zrush.f.EntList_Remove(self)
end

function ENT:Draw()
	self:DrawModel()

	if zrush.f.DrawUI() and zrush.f.InDistance(self:GetPos(), LocalPlayer():GetPos(), 500) then
		local oil = self:GetOil()
		local Fuel = self:GetFuel()

		if oil > 0 then
			self:Draw_MainInfo(1, oil)
		elseif Fuel > 0 then
			self:Draw_MainInfo(2, Fuel)
		else
			self:Draw_MainInfo(0, 0)
		end
	end
end

local l_pos01 = Vector(3.2, -17.15, 6.5)
local l_ang01 = Angle(-180, 0, 90)

local l_pos02 = Vector(-3.2, 17.15, 6.5)
local l_ang02 = Angle(0, 0, -90)


function ENT:Draw_MainInfo(ltype, lamount)
	local aBar = math.Clamp((435 / zrush.config.Machine["Barrel"].Storage) * lamount, 0, 435)

	cam.Start3D2D(self:LocalToWorld(l_pos01), self:LocalToWorldAngles(l_ang01), 0.1)
		draw.RoundedBox(0, 0, -30, 60, 435, zrush.default_colors["grey01"])

		if ltype == 1 then
			draw.RoundedBox(0, 0, -30, 60, aBar, zrush.default_colors["black01"])
		elseif ltype == 2 then
			draw.RoundedBox(0, 0, -30, 60, aBar, zrush.darken_fuelcolors[self:GetFuelTypeID()])
		else
			draw.RoundedBox(0, 0, -30, 60, aBar, zrush.default_colors["white01"])
		end

		surface.SetDrawColor(zrush.default_colors["white02"])
		surface.SetMaterial(zrush.default_materials["barrel_scalar"])
		surface.DrawTexturedRect(0, -30, 64, 435)
	cam.End3D2D()

    cam.Start3D2D(self:LocalToWorld(l_pos02), self:LocalToWorldAngles(l_ang02), 0.1)
        draw.RoundedBox(0, 0, -30, 60, 435, zrush.default_colors["grey01"])

        if ltype == 1 then
            draw.RoundedBox(0, 0, -30, 60, aBar, zrush.default_colors["black01"])
        elseif ltype == 2 then
            draw.RoundedBox(0, 0, -30, 60, aBar, zrush.darken_fuelcolors[self:GetFuelTypeID()])
        else
            draw.RoundedBox(0, 0, -30, 60, aBar, zrush.default_colors["white01"])
        end

        surface.SetDrawColor(zrush.default_colors["white02"])
        surface.SetMaterial(zrush.default_materials["barrel_scalar"])
        surface.DrawTexturedRect(0, -30, 64, 435)
    cam.End3D2D()
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Think()
	self:SetNextClientThink(CurTime())

	return true
end
