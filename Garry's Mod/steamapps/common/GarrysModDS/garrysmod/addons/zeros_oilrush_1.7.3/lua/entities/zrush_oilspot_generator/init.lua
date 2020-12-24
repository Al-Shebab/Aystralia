AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	zrush.f.OilspotGenerator_Initialize(self)
end

function ENT:OnRemove()
	zrush.f.OilspotGenerator_OnRemove(self)
end
