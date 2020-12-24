AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )

ENT.Base = "sent_base_lsd"

ENT.Size = Vector(5,20,20)
ENT.PrintName		= "LSD Bottle material"
ENT.Author		= "Gonzo"
ENT.Category		= "LSD Drugs"
ENT.Spawnable 		= true
ENT.AdminOnly 		= true

function ENT:Initialize()

 	if SERVER then
		self:SetModel( "models/gonzo/lsd/bottle.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
		self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
		self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	 	self:SetModelScale(1.2,0.01)
          self:SetUseType(SIMPLE_USE)
          self:SetMaterial("models/gonzo/lsd/frascos")
          local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end
	end
end

function ENT:Use(act)
  act:AddNotification("You drank a toxic liquid",3,1)
  self:Remove()
  act:Kill()
end
