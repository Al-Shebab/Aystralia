AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	if not KVS then 
		self:Remove()
		return 
	end 

	self:SetModel( "models/gman_high.mdl" )
	self:SetHullType( HULL_HUMAN )
	self:SetHullSizeNormal()
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:SetSolid(  SOLID_BBOX )
	self:CapabilitiesAdd( CAP_ANIMATEDFACE || CAP_TURN_HEAD )
	self:SetUseType( SIMPLE_USE )
	self:DropToFloor()
	self.nextClick = CurTime() + 1
	self:SetMaxYawSpeed( 90 )
end

function ENT:AcceptInput( event, a, pCaller )

	if( event == "Use" && pCaller:IsPlayer() && self.nextClick < CurTime() )  then
	
		self.nextClick = CurTime() + 2

		AdvCarDealer:GetPlayerCars( pCaller, function( tCars ) 

			tCars = tCars or {}

			for k, v in pairs( tCars ) do
				if AdvCarDealer.VehiclesOut[ tonumber( v.id ) ] then
					tCars[ k ] = nil
				end
			end

			net.Start( "AdvCarDealer.OpenGarage" )
				net.WriteEntity( self )
				net.WriteTable( tCars )
			net.Send( pCaller )
		end )
	end
	
end