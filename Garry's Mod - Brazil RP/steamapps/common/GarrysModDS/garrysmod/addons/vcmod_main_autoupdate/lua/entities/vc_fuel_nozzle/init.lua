// Copyright © 2020 VCMod (freemmaann). All Rights Reserved. if you have any complaints or ideas contact me: steam - steamcommunity.com/id/freemmaann/ or email - freemmaann@gmail.com.

AddCSLuaFile("cl_init.lua") AddCSLuaFile("shared.lua") include('shared.lua')

local ID = "Fuel_nozzle"

function ENT:Initialize() self:SetModel("models/weapons/w_toolgun.mdl") self:PhysicsInit(SOLID_VPHYSICS) self:SetMoveType(MOVETYPE_VPHYSICS) self:SetSolid(SOLID_VPHYSICS) self:SetUseType(SIMPLE_USE) local phys = self:GetPhysicsObject() if phys:IsValid() then phys:SetMaterial("metal") phys:Wake() end
	self.VC_Model = ents.Create("prop_dynamic")
	self.VC_Model:SetModel("models/props_c17/TrapPropeller_Lever.mdl")
	self.VC_Model:SetPos(self:LocalToWorld(Vector(14,0.2,3)))
	self.VC_Model:SetAngles(self:LocalToWorldAngles(Angle(0,90,0)))
	self.VC_Model:SetParent(self)
	self.VC_Model:Spawn()
	self.VC_Model:DeleteOnRemove(self)

	self:SetCustomCollisionCheck(true)
end

function ENT:Use(...) if VC and VC.CodeEnt[ID] and VC.CodeEnt[ID].Use then return VC.CodeEnt[ID].Use(self, ...) end end
function ENT:Think(...) if VC and VC.CodeEnt[ID] and VC.CodeEnt[ID].Think then return VC.CodeEnt[ID].Think(self, ...) end end
function ENT:Touch(...) if VC and VC.CodeEnt[ID] and VC.CodeEnt[ID].Touch then return VC.CodeEnt[ID].Touch(self, ...) end end
function ENT:OnTakeDamage(...) if VC and VC.CodeEnt[ID] and VC.CodeEnt[ID].OnTakeDamage then return VC.CodeEnt[ID].OnTakeDamage(self, ...) end end
function ENT:VC_PickedUp(...) if VC and VC.CodeEnt[ID] and VC.CodeEnt[ID].VC_PickedUp then return VC.CodeEnt[ID].VC_PickedUp(self, ...) end end