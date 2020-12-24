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
	local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(true)
	end

	zrmine.f.EntList_Add(self)

	self.IsMergingResoures = false
	self.LastTouch = -1
end


function ENT:AcceptInput(key, activator)

	if ((self.lastUsed or CurTime()) <= CurTime()) and (key == "Use" and IsValid(activator) and activator:IsPlayer() and activator:Alive()) then
		self.lastUsed = CurTime() + 0.25

		local refinery = self:GetParent()

		if IsValid(refinery) and string.sub(refinery:GetClass(), 1, 12) == "zrms_refiner" then

			if zrmine.config.ResourceCrates_Sharing == false and not zrmine.f.IsOwner(activator, self) then
				zrmine.f.Notify(activator, zrmine.language.Module_DontOwn, 1)

				return
			end

			zrmine.f.Refinery_DetachBasket(refinery, self)
		end
	end
end




function ENT:OnRemove()
	if (IsValid(self:GetParent())) then
		zrmine.f.Refinery_DetachBasket(self:GetParent(), self)
	end
end

function ENT:StartTouch(ent)
	if self.LastTouch < CurTime() then
		zrmine.f.Basket_StartTouch(self, ent)
		self.LastTouch = CurTime() + 1
	end
end
