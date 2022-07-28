AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/breen.mdl")
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()

	self:SetSolid(SOLID_BBOX)

	self:CapabilitiesAdd(bit.bor(CAP_USE, CAP_ANIMATEDFACE, CAP_TURN_HEAD)) //CAP_MOVE_CLIMB, CAP_MOVE_GROUND, CAP_OPEN_DOORS, CAP_USE_SHOT_REGULATOR, CAP_AIM_GUN, CAP_DUCK,
	self:SetUseType(SIMPLE_USE)
end

function ENT:AcceptInput(name, activator, caller, data)
	if (name == "Use") then 
		self:Used(activator, caller, 1, 1)
	end
end

function ENT:Used(ply, caller)
	if !(ply:IsPlayer()) then return end

	mg2.vgui:OpenMenu(ply, "npcmanager.Selection", {NPCID = self:GetNPCID()})
end