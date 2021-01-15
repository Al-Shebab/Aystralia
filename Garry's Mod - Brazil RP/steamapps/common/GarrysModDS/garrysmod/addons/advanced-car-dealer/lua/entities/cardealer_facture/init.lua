AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local sentences = AdvCarDealer.Language.Sentences[ AdvCarDealer.Language.Lang ]

function ENT:Initialize()
	sentences = sentences or AdvCarDealer.Language.Sentences[ AdvCarDealer.Language.Lang ]
	
	self:SetModel( "models/stim/venatuss/car_dealer/paper.mdl" )
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

	if not IsValid( self:GetCarDealer() ) or not AdvCarDealer:IsCarDealer( self:GetCarDealer() ) then self:Remove() return end

	if not IsValid( self:GetVehicle() ) then
		if not AdvCarDealer:IsCarDealer( pCaller ) then 
			DarkRP.notify( pCaller, AdvCarDealer.NOTIFY_ERROR, 10, sentences[ 38 ] )
		elseif self:GetCarDealer() ~= pCaller then
			DarkRP.notify( pCaller, AdvCarDealer.NOTIFY_ERROR, 10, sentences[ 39 ] )
			return 
		end
	end

	net.Start( "AdvCarDealer.OpenFacture" )
		net.WriteEntity( self )
	net.Send( pCaller )
end