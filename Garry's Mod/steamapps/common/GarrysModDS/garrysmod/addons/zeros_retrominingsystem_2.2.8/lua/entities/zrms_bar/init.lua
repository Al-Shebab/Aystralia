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
	self:SetCustomCollisionCheck(true)
	local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(true)
	end

	self:UpdateVisuals()
	self.zrms_added = false
end

function ENT:AcceptInput(key, ply)

	if ((self.lastUsed or CurTime()) <= CurTime()) and (key == "Use" and IsValid(ply) and ply:IsPlayer() and ply:Alive()) then
		self.lastUsed = CurTime() + 0.25

		if (zrmine.f.Player_IsMiner(ply) and zrmine.f.CanSteal(ply,self)) then
			local barType = self:GetMetalType()

			if (barType == "Iron") then
				ply:zrms_AddMetalBar("Iron", 1)
			elseif (barType == "Bronze") then
				ply:zrms_AddMetalBar("Bronze", 1)
			elseif (barType == "Silver") then
				ply:zrms_AddMetalBar("Silver", 1)
			elseif (barType == "Gold") then
				ply:zrms_AddMetalBar("Gold", 1)
			end

			zrmine.f.Notify(ply, "+" .. barType .. " Bar", 0)
			self:Remove()
		else
			zrmine.f.Notify(ply, zrmine.language.WrongJob, 1)
		end
	end
end

function ENT:UpdateVisuals()
	local btype = self:GetMetalType()

	if (btype == "Iron") then
		self:SetSkin(0)
	elseif (btype == "Bronze") then
		self:SetSkin(1)
	elseif (btype == "Silver") then
		self:SetSkin(2)
	elseif (btype == "Gold") then
		self:SetSkin(3)
	end
end
