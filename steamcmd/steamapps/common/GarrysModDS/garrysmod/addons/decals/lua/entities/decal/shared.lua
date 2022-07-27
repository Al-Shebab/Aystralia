ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Decal"
ENT.Category = "Decals"
ENT.Author = "Beast"
ENT.Spawnable = true
ENT.AdminSpawnable = true

function ENT:SetupDataTables()
    self:NetworkVar( "String", 0, "URL" )
    self:NetworkVar( "Int", 0, "Opacity" )
    self:NetworkVar( "Vector", 0, "DecalColor" )
    self:NetworkVar( "Vector", 1, "Scale" )
end
