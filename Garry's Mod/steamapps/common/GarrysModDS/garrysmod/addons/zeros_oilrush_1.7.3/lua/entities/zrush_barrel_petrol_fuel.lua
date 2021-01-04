AddCSLuaFile()
DEFINE_BASECLASS("zrush_barrel")
ENT.Type = "anim"
ENT.Base = "zrush_barrel"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.PrintName = "Petrol Barrel"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros OilRush"
ENT.Model = "models/zerochain/props_oilrush/zor_barrel.mdl"
ENT.AutomaticFrameAdvance = true
ENT.DisableDuplicator = false

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "Oil")
	self:NetworkVar("Float", 1, "Fuel")
	self:NetworkVar("Int", 0, "FuelTypeID")

	if (SERVER) then
		self:SetFuelTypeID(1)
		self:SetOil(0)
		self:SetFuel(zrush.config.Machine["Barrel"].Storage)
	end
end
