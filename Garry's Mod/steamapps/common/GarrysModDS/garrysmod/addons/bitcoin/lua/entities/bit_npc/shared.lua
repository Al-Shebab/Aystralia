ENT.Base = "base_ai" 
ENT.Type = "ai"
ENT.PrintName = "Bitcoin Buyer"
ENT.Author = "Mikael"
ENT.Category = "bitmine"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.AutomaticFrameAdvance = true

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end

