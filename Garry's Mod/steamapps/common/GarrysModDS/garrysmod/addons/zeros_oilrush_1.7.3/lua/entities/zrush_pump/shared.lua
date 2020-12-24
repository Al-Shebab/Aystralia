ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.PrintName = "Pump"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros OilRush"
ENT.Model = "models/zerochain/props_oilrush/zor_oilpump.mdl"
ENT.AutomaticFrameAdvance = true
ENT.DisableDuplicator = false
ENT.MachineID = "Pump"

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Hole")
	self:NetworkVar("Entity", 1, "Barrel")
	self:NetworkVar("Bool", 1, "Pumping")
	self:NetworkVar("Bool", 2, "Jammed")
	self:NetworkVar("Bool", 3, "IsRunning")
	self:NetworkVar("String", 0, "State")
	self:NetworkVar("Float", 1, "SpeedBoost")
	self:NetworkVar("Float", 2, "ProductionBoost")
	self:NetworkVar("Float", 3, "AntiJamBoost")

	if (SERVER) then
		self:SetHole(NULL)
		self:SetBarrel(NULL)
		self:SetPumping(false)
		self:SetState("IDLE")
		self:SetSpeedBoost(0)
		self:SetProductionBoost(0)
		self:SetAntiJamBoost(0)
		self:SetJammed(false)
		self:SetIsRunning(false)
	end
end
