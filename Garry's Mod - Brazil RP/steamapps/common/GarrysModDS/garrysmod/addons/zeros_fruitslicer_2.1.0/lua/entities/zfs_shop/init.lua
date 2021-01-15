AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:SpawnFunction(ply, tr)
	if (not tr.Hit) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 1
	local ent = ents.Create(self.ClassName)
	local angle = ply:GetAimVector():Angle()
	angle:RotateAroundAxis(Vector(0,0,1),90)
	angle = Angle(0, angle.yaw, 0)
	ent:SetAngles(angle)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	zfs.f.SetOwnerID(ent, ply)

	return ent
end

function ENT:Initialize()

	if (zfs.config.Theme == 1) then
		self:SetModel("models/zerochain/fruitslicerjob/fs_shop.mdl")
	elseif (zfs.config.Theme == 2) then
		self:SetModel("models/zerochain/fruitslicerjob/fs_shop_india.mdl")
	end

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:Wake()
		phys:EnableMotion(true)
	end

	zfs.f.Shop_Initialize(self)
end

function ENT:AcceptInput(input, activator, caller, data)
	if string.lower(input) == "use" and IsValid(activator) and activator:IsPlayer() and activator:Alive() then
		zfs.f.Shop_Use(activator, self)
	end
end

function ENT:StartTouch(other)
	zfs.f.Shop_OnTouch(self, other)
end
