ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Facture"
ENT.Category = "Car Dealer"
ENT.Author = "Venatuss"
ENT.Spawnable = true

function ENT:SetupDataTables()

	self:NetworkVar( "Entity", 0, "CarDealer" )
	self:NetworkVar( "Entity", 1, "Vehicle" )
	self:NetworkVar( "Float", 0, "Percentage" )

end