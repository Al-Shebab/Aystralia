AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )

ENT.Base = "sent_base_lsd"

ENT.Size = Vector(5,20,20)
ENT.PrintName		= "LSD Paper"
ENT.Author		= "Gonzo"
ENT.Category		= "LSD Drugs"
ENT.Spawnable 		= true
ENT.AdminOnly 		= true

function ENT:Initialize()

 	if SERVER then
		self:SetModel( "models/props/cs_office/Paper_towels.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
		self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
		self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	 	self:SetModelScale(1.5,0.01)
    self:SetUseType(SIMPLE_USE)
    local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end
	end
end
