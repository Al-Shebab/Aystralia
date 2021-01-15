include("shared.lua")

function ENT:HasToolActive()
	if (not LocalPlayer():Alive()) then return false end
	if (LocalPlayer() == nil) then return false end
	if (not LocalPlayer():IsValid()) then return false end
	if (LocalPlayer():GetActiveWeapon() == nil) then return false end
	if (not LocalPlayer():GetActiveWeapon():IsValid()) then return false end
	if (LocalPlayer():GetActiveWeapon():GetClass() == nil) then return false end
	if (LocalPlayer():GetActiveWeapon():GetClass() == "gmod_tool" and LocalPlayer():GetTool() and LocalPlayer():GetTool().Name == "#OilSpot Spawner") then return true end

	return false
end

function ENT:Draw()
	if (not self:HasToolActive()) then return end
	self:DrawModel()
	self:DrawInfo01()
	if zrush.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 300) then
		self:DrawInfo02()
	end
end

function ENT:DrawTranslucent()
	self:Draw()
end


function ENT:DrawInfo01()
	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	local size = self:GetSpawnRadius() * 2.25
	cam.Start3D2D(Pos, Ang, 1)
		surface.SetDrawColor(zrush.default_colors["black04"])
		surface.SetMaterial(zrush.default_materials["circle"])
		surface.DrawTexturedRect(-size / 2, -size / 2, size, size)
	cam.End3D2D()
end

function ENT:DrawInfo02()
	local Pos = self:GetPos()
	local Ang = Angle(0, LocalPlayer():EyeAngles().y - 90, 90)
	Pos = Pos + Ang:Right() * -20
	local Text = zrush.language.General["OilSpotSpawner"]
	cam.Start3D2D(Pos, Ang, 0.3)
		draw.DrawText(Text, "zrush_oilspotgenerator_font01", 0, -75, zrush.default_colors["white01"], TEXT_ALIGN_CENTER)
	cam.End3D2D()
end
