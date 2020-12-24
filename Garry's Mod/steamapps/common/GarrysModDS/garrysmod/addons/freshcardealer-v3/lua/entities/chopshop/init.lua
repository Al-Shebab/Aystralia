include 'shared.lua'

AddCSLuaFile 'shared.lua' 
AddCSLuaFile 'cl_init.lua'

function ENT:Initialize()
	self:SetModel( fcd.cfg.chopShop[ 'npcModel' ] )
	self:SetHullType( HULL_HUMAN )
	self:SetHullSizeNormal(  )
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:SetSolid( SOLID_BBOX )
	self:CapabilitiesAdd( CAP_ANIMATEDFACE || CAP_TURN_HEAD )
	self:SetUseType( SIMPLE_USE )
	self:DropToFloor()
	self:SetMaxYawSpeed( 90 )

	self:SetnpcID( #ents.FindByClass( self:GetClass() ) )
end

function ENT:AcceptInput(name, act, cal)
	if name == "Use" then
		if (cal:IsPlayer()) then
			if fcd.cfg.chopShop[ 'restrictTeams' ] then
				if not table.HasValue( fcd.cfg.chopShop[ 'allowedTeams' ], team.GetName( cal:Team() ) ) then
					fcd.notifyPlayer( cal, fcd.cfg.chopShopTranslate[ 'wrongTeam' ] )
					return
				end
			end
			
			fcd.openChopShopMenu(cal, self:GetnpcID())
		end
	end
end
