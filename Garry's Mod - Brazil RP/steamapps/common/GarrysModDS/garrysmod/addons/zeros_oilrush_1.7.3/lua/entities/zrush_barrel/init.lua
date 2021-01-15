AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:SpawnFunction(ply, tr)
	if (not tr.Hit) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 30
	local ent = ents.Create(self.ClassName)
	local angle = ply:GetAimVector():Angle()
	angle = Angle(0, angle.yaw, 0)
	angle:RotateAroundAxis(angle:Up(), 180)
	ent:SetAngles(angle)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	zrush.f.SetOwner(ent, ply)

	return ent
end

function ENT:Initialize()
	zrush.f.Barrel_Initialize(self)
end

function ENT:AcceptInput(key, ply)
	if ((self.lastUsed or CurTime()) <= CurTime()) and (key == "Use" and IsValid(ply) and ply:IsPlayer() and ply:Alive()) and zrush.f.InDistance(ply:GetPos(), self:GetPos(), 100) then
		self.lastUsed = CurTime() + 1
		zrush.f.Barrel_OnUse(self, ply)
	end
end

function ENT:StartTouch(ent)
	zrush.f.Barrel_OnTouch(self, ent)
end

function ENT:OnRemove()
	zrush.f.Barrel_OnRemove(self)
end

function ENT:OnTakeDamage(dmg)
	zrush.f.Barrel_OnTakeDamage(self, dmg)
end
