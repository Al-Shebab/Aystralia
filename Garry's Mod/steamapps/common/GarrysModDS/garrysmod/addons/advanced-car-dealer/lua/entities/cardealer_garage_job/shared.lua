ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.AutomaticFrameAdvance = true
ENT.Author = "Venatuss"
ENT.Spawnable = false
ENT.Category = "Car Dealer"
ENT.PrintName = "Job garage manager"

function ENT:SetupDataTables()

	self:NetworkVar( "String", 0, "GName" )
	self:NetworkVar( "Float", 0, "ID" )

	if SERVER then
		self:SetGName( "Job Garage" )
		self:SetID( 0 )
	end

end