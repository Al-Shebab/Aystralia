ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.PrintName = "Burner"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros OilRush"
ENT.Model = "models/zerochain/props_oilrush/zor_drillburner.mdl"
ENT.AutomaticFrameAdvance = true
ENT.DisableDuplicator = false
ENT.MachineID = "Burner"

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Hole")
	self:NetworkVar("String", 0, "State")
	self:NetworkVar("Float", 1, "SpeedBoost")
	self:NetworkVar("Float", 2, "ProductionBoost")
	self:NetworkVar("Float", 3, "CoolingBoost")
	self:NetworkVar("Bool", 1, "OverHeat")
	self:NetworkVar("Bool", 2, "IsRunning")

	if (SERVER) then
		self:SetHole(NULL)
		self:SetState("IDLE")
		self:SetOverHeat(false)
		self:SetSpeedBoost(0)
		self:SetProductionBoost(0)
		self:SetCoolingBoost(0)
		self:SetIsRunning(false)
	end
end
