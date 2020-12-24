AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props/cs_office/computer_caseb_p5b.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:GetPhysicsObject():Wake()
	self:SetPoint(100)
	timer.Simple(550, function() if self:IsValid() then self:Remove() end end )
end

function ENT:OnTakeDamage( dmg )
    if ( self.burningup ) then return end
	self:SetPoint( ( self:GetPoint() or 100 ) - dmg:GetDamage() )       
    if ( self:GetPoint() <= 0 ) then      
        self:Remove() 
    end    
end

function ENT:OnRemove()
end

