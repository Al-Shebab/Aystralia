AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local CFG = AdvCarDealer.GetConfig

function ENT:Initialize()

	self:SetModel( "models/barney.mdl" )
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
	local sentences = AdvCarDealer.Language.Sentences[ AdvCarDealer.Language.Lang ]
	
	if( event == "Use" && pCaller:IsPlayer() && self.nextClick < CurTime() )  then

		self.nextClick = CurTime() + 2
		local iID = self:GetID()

		if not iID or not CFG().JobGarage or not CFG().JobGarage[ game.GetMap() ] or not  CFG().JobGarage[ game.GetMap() ][ iID ] then return end
		if not table.HasValue( CFG().JobGarage[ game.GetMap() ][ iID ].Jobs or {}, team.GetName( pCaller:Team() ) ) then DarkRP.notify( pCaller, AdvCarDealer.NOTIFY_ERROR, 10, sentences[ 64 ] ) return end

		net.Start( "AdvCarDealer.OpenGarage" )
			net.WriteEntity( self )
			net.WriteTable(  CFG().JobGarage[ game.GetMap() ][ iID ].Vehicles or {} )
			net.WriteBool( true )
		net.Send( pCaller )
		
	end
	
end