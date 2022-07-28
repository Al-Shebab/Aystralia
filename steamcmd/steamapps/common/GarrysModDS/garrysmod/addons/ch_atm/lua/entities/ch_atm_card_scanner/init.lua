AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:SpawnFunction( ply, tr )
	if not tr.Hit then
		return
	end
	
	local SpawnPos = tr.HitPos + tr.HitNormal
	
	local ent = ents.Create( "ch_atm_card_scanner" )
	ent:SetPos( SpawnPos )
	ent:SetAngles( Angle( 0, 0, 0 ) )
	ent:Spawn()
	ent:Activate()
	
	return ent
end

function ENT:Initialize()
	self:SetModel( "models/craphead_scripts/ch_atm/terminal.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_NONE  )
	
	self:PhysWake()
	
	self:SetColor( CH_ATM.Config.TerminalDefaultColor )
	
	self.IsInUse = false
	self.InUseBy = nil
	
	self:SetIsReadyToScan( false )
	self:SetTerminalPrice( "" )
	
	-- Set DarkRP owner
	self:CPPISetOwner( self:Getowning_ent() )
end

--[[
	Update the status of the terminal
--]]
net.Receive( "CH_ATM_Net_CardScanner_IsReadyToScan", function( length, ply )
	local ent = net.ReadEntity()
	local status = net.ReadBool()
	
	ent:SetIsReadyToScan( status )
end )

--[[
	Update the terminal price
--]]
net.Receive( "CH_ATM_Net_CardScanner_UpdatePrice", function( length, ply )
	local ent = net.ReadEntity()
	local input = net.ReadString()
	local clear = net.ReadBool()
	
	if clear then
		ent:SetTerminalPrice( "" )
	else
		ent:SetTerminalPrice( ent:GetTerminalPrice() .. input )
	end
end )

--[[
	Function to trigger the green/red lights on scanner
--]]
function ENT:ChangeLights( accepted, on )
	if accepted and on then
		self:SetBodygroup( 1, 1 )
		
		self:SetSkin( 0 )
	elseif not accepted and on then
		self:SetBodygroup( 1, 1 )
		
		self:SetSkin( 1 )
	elseif not on then
		self:SetBodygroup( 1, 0 )
	end
end

--[[
	Disable damage for entity
--]]
function ENT:OnTakeDamage( dmg )
	return 0
end