ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "MachineCrate"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros OilRush"
ENT.Model = "models/zerochain/props_oilrush/zor_machinecrate.mdl"
ENT.AutomaticFrameAdvance = true
ENT.DisableDuplicator = false

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "MachineID")

	if (SERVER) then
		self:SetMachineID("nil")
	end
end
