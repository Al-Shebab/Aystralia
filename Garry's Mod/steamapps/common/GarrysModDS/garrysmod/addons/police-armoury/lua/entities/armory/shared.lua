ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName		= "Police Armory"
ENT.Author			= "2155X"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""
ENT.Spawnable		= true
ENT.AdminSpawnable	= true
ENT.Category		= "2155X's Ents"

function ENT:SetupDataTables()
	self:NetworkVar("Int", 1, "Money")
	self:NetworkVar("Int", 2, "Shipments")
	self:NetworkVar("Int", 3, "Weps")
	self:NetworkVar("Float", 4, "Progress")
	
	self:NetworkVar("Bool", 1, "IsBeingRobbed")
	self:NetworkVar("Bool", 3, "IsBroken")
	
	self:NetworkVar("Entity", 1, "Robber")
	
	self:NetworkVar("Int", 4, "MaxMoney")
	self:NetworkVar("Int", 5, "MaxShipments")
	self:NetworkVar("Int", 6, "MaxWeapons")
end