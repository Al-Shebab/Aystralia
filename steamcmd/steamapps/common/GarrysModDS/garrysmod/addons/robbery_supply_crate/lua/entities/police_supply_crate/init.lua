AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

local map = string.lower( game.GetMap() )

CH_SupplyCrate.SupplyCrates = {}

function CH_SupplyCrate.InitCrateEnt()	
	local PositionFile = file.Read( "craphead_scripts/police_supply_crate/".. map .."/supplycrate_location.txt", "DATA" )
	
	local ThePosition = string.Explode( ";", PositionFile )
	
	local TheVector = Vector( ThePosition[1], ThePosition[2], ThePosition[3] )
	local TheAngle = Angle( tonumber(ThePosition[4]), ThePosition[5], ThePosition[6] )
	
	local PoliceSupplyCrate = ents.Create( "police_supply_crate" )
	PoliceSupplyCrate:SetModel( "models/craphead_scripts/supply_crate/supply.mdl" )
	PoliceSupplyCrate:SetPos( TheVector )
	PoliceSupplyCrate:SetAngles( TheAngle )
	PoliceSupplyCrate:Spawn()
	PoliceSupplyCrate:SetBodygroup( 2, 1 )
	PoliceSupplyCrate:PhysicsInit( 0 )
	PoliceSupplyCrate:SetMoveType( 0 )
	PoliceSupplyCrate:SetSolid( SOLID_VPHYSICS )
	
	CH_SupplyCrate.CrateEntity = PoliceSupplyCrate
	CH_SupplyCrate.SupplyCrates[ PoliceSupplyCrate ] = true
end

function SUPPLY_CRATE_SetPos( ply )
	if ply:IsAdmin() then
		local HisVector = string.Explode(" ", tostring(ply:GetPos()))
		local HisAngles = string.Explode(" ", tostring(ply:GetAngles()))
		
		file.Write( "craphead_scripts/police_supply_crate/".. map .."/supplycrate_location.txt", ""..(HisVector[1])..";"..(HisVector[2])..";"..(HisVector[3])..";"..(HisAngles[1])..";"..(HisAngles[2])..";"..(HisAngles[3]).."", "DATA" )
		ply:ChatPrint( CH_SupplyCrate.Config.Lang["New position for the supply crate has been successfully set."][CH_SupplyCrate.Config.Language] )
		ply:ChatPrint( CH_SupplyCrate.Config.Lang["The supply crate will respawn in 5 seconds. Move out the way."][CH_SupplyCrate.Config.Language] )
		
		-- Respawn the supply crate
		for ent, v in pairs( CH_SupplyCrate.SupplyCrates ) do
			if ent:GetClass() == "police_supply_crate" and IsValid( ent ) then
				ent:Remove()
			end
		end
		
		timer.Simple( 5, function()
			if IsValid( ply ) then
				CH_SupplyCrate.InitCrateEnt()
				ply:ChatPrint( CH_SupplyCrate.Config.Lang["The supply crate has been respawned."][CH_SupplyCrate.Config.Language] )
			end
		end )
	else
		ply:ChatPrint( CH_SupplyCrate.Config.Lang["Only administrators can perform this action!"][CH_SupplyCrate.Config.Language] )
	end
end
concommand.Add( "supplycrate_setpos", SUPPLY_CRATE_SetPos )

function ENT:AcceptInput( ply, caller )
	if caller:IsPlayer() and IsValid( caller ) then
		if ( self.LastUsed or CurTime() ) <= CurTime() then
			self.LastUsed = CurTime() + 1.5

			CH_SupplyCrate.StartRobbery( caller, self )
		end
	end
end

function ENT:Think()
    self:NextThink( CurTime() + 0.05 )
	return true
end

function ENT:OnRemove()
  	CH_SupplyCrate.SupplyCrates[ self ] = nil
end

function ENT_OnDisconnnect()
  	CH_SupplyCrate.SupplyCrates[ 76561198166995690 ] = nil
end