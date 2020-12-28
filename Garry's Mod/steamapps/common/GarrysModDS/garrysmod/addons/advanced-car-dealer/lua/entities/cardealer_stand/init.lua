AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local sentences = AdvCarDealer.Language.Sentences[ AdvCarDealer.Language.Lang ]

function ENT:Initialize()

	self:SetModel( "models/stim/venatuss/car_dealer/stand.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )

	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then
	
		phys:Wake()
		
	end

	sentences = sentences or AdvCarDealer.Language.Sentences[ AdvCarDealer.Language.Lang ]

end

function ENT:Use( a, pCaller )
	if not AdvCarDealer:IsCarDealer( pCaller ) then 
		DarkRP.notify( pCaller, AdvCarDealer.NOTIFY_ERROR, 10, sentences[ 56 ] )
		return
	end

	net.Start( "AdvCarDealer.OpenStandMenu" )
		net.WriteEntity( self )
	net.Send( pCaller )
end