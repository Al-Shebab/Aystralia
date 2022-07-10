AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:SpawnFunction(ply, tr)
	if (not tr.Hit) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 1
	local ent = ents.Create(self.ClassName)
	local angle = ply:GetAimVector():Angle()
	angle = Angle(0, angle.yaw, 0)
	angle:RotateAroundAxis(angle:Up(), 180)
	ent:SetAngles(angle)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	zrmine.f.SetOwner(ent, ply)

	return ent
end

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:UseClientSideAnimation()
	local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(true)
	end

	zrmine.f.StorageCrate_Initialize(self)
end

function ENT:AcceptInput(key, activator)

	if ((self.lastUsed or CurTime()) <= CurTime()) and (key == "Use" and IsValid(activator) and activator:IsPlayer() and activator:Alive()) then
		self.lastUsed = CurTime() + 0.25
		zrmine.f.StorageCrate_Use(self,activator)
	end
end


function ENT:StartTouch(ent)
	if not IsValid(ent) then return end
	if zrmine.f.CollisionCooldown(ent) then return end

	if string.sub(ent:GetClass(),1,8) == "zrms_bar" and self.BarCount < 12 and ent.zrms_added == false then
		zrmine.f.StorageCrate_AddBar(self,ent)
	end
end

function ENT:SpawnFromInventory()
	timer.Simple(0.1, function()
		if (IsValid(self)) then
			self:SetIsClosed(true)
			self.BarCount = self:GetbIron() + self:GetbBronze() + self:GetbSilver() + self:GetbGold()
		end
	end)
end
