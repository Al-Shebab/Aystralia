AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:SpawnFunction(ply, tr)
	local SpawnPos = tr.HitPos + tr.HitNormal * 55
	local ent = ents.Create(self.ClassName)
	local angle = ply:GetAimVector():Angle()
	angle = Angle(0, angle.yaw, 0)
	angle:RotateAroundAxis(angle:Up(), 90)
	ent:SetAngles(angle)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	zwf.f.SetOwner(ent, ply)
	return ent
end

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self:UseClientSideAnimation()

	local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(true)
	end

	zwf.f.EntList_Add(self)
	zwf.f.PowerEntList_Add(self)
end


function ENT:AcceptInput(input, activator, caller, data)
	if string.lower(input) == "use" and IsValid(activator) and activator:IsPlayer() and activator:Alive() then
		if self:EnableButton(activator) == false then return end
		if zwf.config.Sharing.Lamps == false and zwf.f.IsOwner(activator, self) == false then return end

		self:SetIsRunning(not self:GetIsRunning())
	end
end

function ENT:OnTakeDamage(dmg)
	zwf.f.Entity_OnTakeDamage(self,dmg)
end
