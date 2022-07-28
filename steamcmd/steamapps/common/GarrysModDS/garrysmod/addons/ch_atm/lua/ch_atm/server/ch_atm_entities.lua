local map = string.lower( game.GetMap() )

function CH_ATM.SpawnEntities()
	for k, v in ipairs( file.Find( "craphead_scripts/ch_atm/entities/".. map .."/atm/atm_*.json", "DATA" ) ) do
		local PositionFile = file.Read( "craphead_scripts/ch_atm/entities/".. map .."/atm/".. v, "DATA" )

		local Pos = util.JSONToTable( PositionFile )
		local TheVector = Vector( Pos.EntityVector.x, Pos.EntityVector.y, Pos.EntityVector.z )
		local TheAngle = Angle( Pos.EntityAngles.x, Pos.EntityAngles.y, Pos.EntityAngles.z )

		local ATM = ents.Create( "ch_atm" )
		ATM:SetPos( TheVector )
		ATM:SetAngles( TheAngle )
		ATM:Spawn()
		timer.Simple( 1, function()
			if IsValid( ATM ) then
				ATM:SetMoveType( MOVETYPE_NONE )
			end
		end )
	end
end

local function CH_ATM_SaveATMEntities( ply, cmd, args )
	if not ply:CH_ATM_IsAdmin() then
		DarkRP.notify( ply, 1, CH_ATM.Config.NotificationTime, CH_ATM.LangString( "Only administrators can perform this action!" ) )
		return
	end
	
	local AutoIncrementID = 0
	
	for k, v in ipairs( file.Find( "craphead_scripts/ch_atm/entities/".. map .."/atm/atm_*.json", "DATA" ) ) do
		file.Delete( "craphead_scripts/ch_atm/entities/".. map .."/atm/".. v )
	end
	
	for k, ent in ipairs( ents.FindByClass( "ch_atm" ) ) do
		local Entity_Position = {
			EntityVector = {
				x = ent:GetPos().x,
				y = ent:GetPos().y,
				z = ent:GetPos().z,
			},
			EntityAngles = {
				x = ent:GetAngles().x,
				y = ent:GetAngles().y,
				z = ent:GetAngles().z,
			},
		}
		
		AutoIncrementID = AutoIncrementID + 1
		
		file.Write( "craphead_scripts/ch_atm/entities/".. map .."/atm/atm_".. AutoIncrementID ..".json", util.TableToJSON( Entity_Position ), "DATA" )
	end

	DarkRP.notify( ply, 1, CH_ATM.Config.NotificationTime, CH_ATM.LangString( "All ATM's have been saved to the map!" ) )
end
concommand.Add( "ch_atm_saveall", CH_ATM_SaveATMEntities )