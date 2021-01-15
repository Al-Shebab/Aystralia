AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(true)
	end

	zfs.f.Fruitbox_Initialize(self)
end
