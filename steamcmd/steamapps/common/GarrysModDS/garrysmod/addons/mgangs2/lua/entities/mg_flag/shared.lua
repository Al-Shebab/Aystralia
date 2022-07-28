ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.Category       		= "MGangs 2"
ENT.PrintName		   	= "MGangs 2 - Territory Flag"
ENT.Author			   	= "Zephruz & ZeroChain"
ENT.Contact			   	= "https://zephruz.net/"
ENT.Purpose			   	= "Identifies a Territory"
ENT.Instructions	 	= "Used to mark a territory that can be captured."
ENT.Spawnable		    =  true
ENT.AdminSpawnable		=  false
ENT.RenderGroup 		= RENDERGROUP_BOTH

function ENT:SetupDataTables()
	-- Ents
	self:NetworkVar("Entity", 0, "ClaimingPly")

	-- Ints
	self:NetworkVar("Int", 0, "TerritoryID")
	self:NetworkVar("Int", 1, "ClaimStart")
	self:NetworkVar("Int", 2, "LastHoldReward")
end
