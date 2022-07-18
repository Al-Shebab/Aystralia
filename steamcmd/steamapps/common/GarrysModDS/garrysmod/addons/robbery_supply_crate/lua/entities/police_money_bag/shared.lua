ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Police Money Bag"
ENT.Author = "Crap-Head"

ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.AutomaticFrameAdvance = true

function ENT:SetupDataTables()	
	self:NetworkVar( "Int", 0, "BagMoney" )
end