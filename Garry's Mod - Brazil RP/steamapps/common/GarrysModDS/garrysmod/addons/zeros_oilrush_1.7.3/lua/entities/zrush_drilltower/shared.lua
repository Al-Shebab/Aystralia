ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.PrintName = "DrillTower"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros OilRush"
ENT.Model = "models/zerochain/props_oilrush/zor_drilltower.mdl"
ENT.AutomaticFrameAdvance = true
ENT.DisableDuplicator = false
ENT.MachineID = "Drill"

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "Pipes")
	self:NetworkVar("Entity", 0, "Hole")
	self:NetworkVar("Bool", 2, "Jammed")
	self:NetworkVar("String", 1, "State")
	self:NetworkVar("Float", 1, "SpeedBoost")
	self:NetworkVar("Float", 2, "ProductionBoost")
	self:NetworkVar("Float", 3, "AntiJamBoost")
	self:NetworkVar("Float", 4, "ExtraPipes")
	self:NetworkVar("Bool", 3, "IsRunning")

	if (SERVER) then
		self:SetSpeedBoost(0)
		self:SetProductionBoost(0)
		self:SetAntiJamBoost(0)
		self:SetExtraPipes(0)
		self:SetState("IDLE")
		self:SetJammed(false)
		self:SetIsRunning(false)
	end
end
