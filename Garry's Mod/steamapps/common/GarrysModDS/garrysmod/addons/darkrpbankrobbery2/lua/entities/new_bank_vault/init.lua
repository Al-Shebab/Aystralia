AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

CH_BankVault.Banks = CH_BankVault.Banks or {}

function CH_BankRobbery2_VaultInitialize()	
	if not file.Exists( "craphead_scripts/bank_robbery2/".. string.lower( game.GetMap() ) .."/bankvault2_location.txt", "DATA" ) then
		file.Write( "craphead_scripts/bank_robbery2/".. string.lower( game.GetMap() ) .."/bankvault2_location.txt", "0;-0;-0;0;0;0", "DATA" )
	end
	
	local PositionFile = file.Read("craphead_scripts/bank_robbery2/".. string.lower( game.GetMap() ) .."/bankvault2_location.txt", "DATA")
	
	local ThePosition = string.Explode( ";", PositionFile )
	
	local TheVector = Vector( ThePosition[1], ThePosition[2], ThePosition[3] )
	local TheAngle = Angle( tonumber(ThePosition[4]), ThePosition[5], ThePosition[6] )
	
	local NewBankVault = ents.Create( "new_bank_vault" )
	NewBankVault:SetModel( "models/props/cs_assault/moneypallet.mdl" )
	NewBankVault:SetPos( TheVector )
	NewBankVault:SetAngles( TheAngle )
	NewBankVault:Spawn()
	NewBankVault:SetMoveType( MOVETYPE_NONE )
	NewBankVault:SetSolid( SOLID_BBOX )
	NewBankVault:SetCollisionGroup( COLLISION_GROUP_PLAYER )
	
	CH_BankVault.BankEntity = NewBankVault
	CH_BankVault.Banks[ NewBankVault ] = true
end
hook.Add( "Initialize", "CH_BankRobbery2_VaultInitialize", CH_BankRobbery2_VaultInitialize )

function CH_BankRobbery2_VaultSetPos( ply )
	if ply:IsAdmin() then
		local TheVector = string.Explode( " ", tostring( ply:GetPos() ) )
		local TheAngle = string.Explode( " ", tostring( ply:GetAngles() ) )
		
		file.Write( "craphead_scripts/bank_robbery2/".. string.lower( game.GetMap() ) .."/bankvault2_location.txt", ""..(TheVector[1])..";"..(TheVector[2])..";"..(TheVector[3])..";"..(TheAngle[1])..";"..(TheAngle[2])..";"..(TheAngle[3]).."", "DATA" )
		ply:ChatPrint( "New position for the bank vault has been succesfully set." )
		ply:ChatPrint( "The bank vault will respawn in 5 seconds. Move out the way." )
		
		-- Respawn the NPC
		for ent, v in pairs( CH_BankVault.Banks ) do
			if ent:GetClass() == "new_bank_vault" and IsValid( ent ) then
				ent:Remove()
			end
		end
		
		timer.Simple( 5, function()
			if IsValid( ply ) then
				CH_BankRobbery2_VaultInitialize()
				ply:ChatPrint( "The bank vault has been respawned." )
			end
		end )
	else
		ply:ChatPrint( "Only administrators can perform this action" )
	end
end
concommand.Add( "newbankvault_setpos", CH_BankRobbery2_VaultSetPos )

function ENT:AcceptInput( ply, caller )
	if caller:IsPlayer() and IsValid( caller ) then
		if ( self.lastUsed or CurTime() ) <= CurTime() then
			self.lastUsed = CurTime() + 2

			CH_BankRobbery2_StartRobbery( caller )
		end
	end
end

function ENT:OnRemove()
  	CH_BankVault.Banks[ self ] = nil
end

-- 76561198166995690