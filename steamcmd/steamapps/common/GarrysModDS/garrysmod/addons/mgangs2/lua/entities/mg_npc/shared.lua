ENT.Type = "ai"
ENT.Base = "base_entity"

ENT.PrintName		= "MG2 NPC"
ENT.Author			= "Zephruz"
ENT.Contact			= "https://zephruz.net/"
ENT.Purpose			= "MG2 NPC"
ENT.Instructions	= "The MG2 NPC."
ENT.Category       		= "MGangs 2"
ENT.PrintName		   	= "MGangs 2 - Gang NPC"
ENT.RenderGroup     = RENDERGROUP_BOTH
ENT.AutomaticFrameAdvance = true
ENT.Spawnable		    =  true
ENT.AdminSpawnable		=  false

function ENT:SetupDataTables() 
	self:NetworkVar("Int", 0, "NPCID")
	self:NetworkVar("String", 0, "Title")
	self:NetworkVar("String", 1, "Description")
end

function ENT:SetAutomaticFrameAdvance(anim)
	self.AutomaticFrameAdvance = anim
end

function ENT:GetNPC()
	return MG2_NPCMANAGER:Get(self:GetNPCID())
end