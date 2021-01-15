AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()

	self:SetModel( "models/stim/venatuss/car_dealer/tablet/tablet.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )

	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then
	
		phys:Wake()
		
	end

end

function ENT:Use( a, pCaller )
	net.Start( "AdvCarDealer.OpenTablet" )
		net.WriteEntity( self )
	net.Send( pCaller )
end