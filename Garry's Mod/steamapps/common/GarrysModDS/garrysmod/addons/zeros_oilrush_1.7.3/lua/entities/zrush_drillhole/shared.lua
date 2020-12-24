ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.PrintName = "DrillHole"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros OilRush"
ENT.Model = "models/zerochain/props_oilrush/zor_drillhole.mdl"
ENT.AutomaticFrameAdvance = true
ENT.DisableDuplicator = false

function ENT:SetupDataTables()
	self:NetworkVar("String", 1, "State")
	self:NetworkVar("Float", 0, "Pipes")
	self:NetworkVar("Float", 1, "Gas")
	self:NetworkVar("Float", 2, "HoleType")
	self:NetworkVar("Float", 3, "OilAmount")
	self:NetworkVar("Float", 4, "NeededPipes")
	self:NetworkVar("Float", 5, "ChaosEventBoost")
	self:NetworkVar("Bool", 0, "HasDrill")
	self:NetworkVar("Bool", 1, "HasBurner")
	self:NetworkVar("Bool", 2, "HasPump")
end
