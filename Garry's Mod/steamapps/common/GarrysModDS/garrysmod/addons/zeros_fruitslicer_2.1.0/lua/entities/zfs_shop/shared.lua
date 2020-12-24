ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.PrintName = "Smoothie Stand"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros FruitSlicer"

ENT.DisableDuplicator = false

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "CurrentState")
	self:NetworkVar("Int", 1, "TSelectedItem")
	self:NetworkVar("Int", 2, "TSelectedTopping")
	self:NetworkVar("Float", 0, "PPrice")
	self:NetworkVar("Bool", 0, "IsBusy")
	self:NetworkVar("Bool", 1, "PublicEntity")
	self:NetworkVar("Entity", 1, "OccupiedPlayer")

	if SERVER then
		self:SetOccupiedPlayer(NULL)
	end
end
