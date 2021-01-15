ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.PrintName = "Refinery"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros OilRush"
ENT.Model = "models/zerochain/props_oilrush/zor_refinery.mdl"
ENT.AutomaticFrameAdvance = true
ENT.DisableDuplicator = false
ENT.MachineID = "Refinery"

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "InputBarrel")
	self:NetworkVar("Entity", 1, "OutputBarrel")
	self:NetworkVar("String", 0, "State")
	self:NetworkVar("Float", 0, "SpeedBoost")
	self:NetworkVar("Float", 1, "ProductionBoost")
	self:NetworkVar("Float", 3, "CoolingBoost")
	self:NetworkVar("Float", 4, "RefineBoost")
	self:NetworkVar("Int", 0, "FuelTypeID")
	self:NetworkVar("Bool", 1, "OverHeat")
	self:NetworkVar("Bool", 2, "IsRunning")

	if (SERVER) then
		self:SetState("IDLE")
		self:SetInputBarrel(NULL)
		self:SetOutputBarrel(NULL)
		self:SetSpeedBoost(0)
		self:SetProductionBoost(0)
		self:SetCoolingBoost(0)
		self:SetRefineBoost(0)
		self:SetFuelTypeID(1)
		self:SetOverHeat(false)
		self:SetIsRunning(false)
	end
end
