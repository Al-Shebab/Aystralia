ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Graphic Card"
ENT.Author = "Mikael"
ENT.Category = "bitmine"
ENT.Spawnable = true
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "Point" )
end