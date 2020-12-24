ENT.Base = 'base_ai'
ENT.Type = 'ai'
ENT.AutomaticFrameAdvance = true
ENT.PrintName = 'Chop Shop'
ENT.Category = "Tupac's Items"
ENT.Author = 'Tupac Shakur'
ENT.Spawnable = true
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:NetworkVar( 'String', 0, 'npcID' )
end