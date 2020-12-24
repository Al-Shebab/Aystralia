include 'shared.lua'

AddCSLuaFile 'shared.lua' 
AddCSLuaFile 'cl_init.lua'

function ENT:Initialize(  )
	fcd.setDealerID( self, #ents.FindByClass( 'freshcardealer' ) )
	fcd.setDealerName( self, 'Unnamed Car Dealer' )

	self:SetisSpecific( false )

	self:SetModel( 'models/humans/group01/female_01.mdl' )
	self:SetHullType( HULL_HUMAN )
	self:SetHullSizeNormal(  )
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:SetSolid( SOLID_BBOX )
	self:CapabilitiesAdd( CAP_ANIMATEDFACE || CAP_TURN_HEAD )
	self:SetUseType( SIMPLE_USE )
	self:DropToFloor(  )
	self:SetMaxYawSpeed( 90 )
end

function ENT:AcceptInput( name, act, cal )
	if cal:IsPlayer() then
		if name == 'Use' then
			fcd.openMenu( cal, self )
		end
	end
end
