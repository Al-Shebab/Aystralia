AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:SpawnFunction(ply, tr)
	if (not tr.Hit) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 35
	local ent = ents.Create(self.ClassName)
	local angle = ply:GetAimVector():Angle()
	angle = Angle(0, angle.yaw, 0)
	angle:RotateAroundAxis(angle:Up(), 90)
	ent:SetAngles(angle)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	zrush.f.SetOwner(ent, ply)

	return ent
end

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:Wake()
		phys:EnableMotion(true)
	end

	zrush.f.Palette_Initialize(self)
end

function ENT:StartTouch(other)
	zrush.f.Palette_StartTouch(self, other)
end

function ENT:OnTakeDamage(dmg)
	ent:TakePhysicsDamage(dmg)
	local damage = dmg:GetDamage()
	local entHealth = 100

	if (entHealth > 0) then
		ent.CurrentHealth = (ent.CurrentHealth or entHealth) - damage

		if (ent.CurrentHealth <= 0) then
			local vPoint = ent:GetPos()
			local effectdata = EffectData()
			effectdata:SetStart(vPoint)
			effectdata:SetOrigin(vPoint)
			effectdata:SetScale(1)
			util.Effect("WheelDust", effectdata)
			SafeRemoveEntity(ent)
		end
	end
end
