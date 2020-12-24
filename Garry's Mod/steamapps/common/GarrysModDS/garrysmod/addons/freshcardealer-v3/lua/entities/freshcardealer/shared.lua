ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.AutomaticFrameAdvance = true
ENT.PrintName = "Fresh Car Dealer"
ENT.Category = "Tupac's Items"
ENT.Author = "Tupac Shakur"
ENT.Spawnable = true
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "dealerName")
	self:NetworkVar("String", 1, "dealerID")
	self:NetworkVar( 'Bool', 0, 'isSpecific' )
end

function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end
