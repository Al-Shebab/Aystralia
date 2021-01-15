AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	zrush.f.FuelBuyer_Initialize(self)
end

function ENT:AcceptInput(key, ply)
	if ((self.lastUsed or CurTime()) <= CurTime()) and (key == "Use" and IsValid(ply) and ply:IsPlayer() and ply:Alive()) then
		self.lastUsed = CurTime() + 0.25
		zrush.f.FuelBuyer_OnUse(self, ply)
	end
end
