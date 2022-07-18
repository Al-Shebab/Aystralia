resource.AddWorkshop( "1911629257")

util.AddNetworkString( "CRATE_RestartCooldown" )
util.AddNetworkString( "CRATE_StopCooldown" )
util.AddNetworkString( "CRATE_RestartTimer" )
util.AddNetworkString( "CRATE_StopTimer" )

util.AddNetworkString( "CRATE_UpdateContent" )

local map = string.lower( game.GetMap() )

function CH_SupplyCrate.InitializeAddon()
	print( "[Supply Crate Robbery] - Script initializing..." )
	
	-- Create dirs
	if not file.IsDir( "craphead_scripts", "DATA" ) then
		file.CreateDir( "craphead_scripts", "DATA" )
	end
	
	if not file.IsDir( "craphead_scripts/police_supply_crate/".. map .."", "DATA" ) then
		file.CreateDir( "craphead_scripts/police_supply_crate/".. map .."", "DATA" )
	end
	
	if not file.Exists( "craphead_scripts/police_supply_crate/".. map .."/supplycrate_location.txt", "DATA" ) then
		file.Write( "craphead_scripts/police_supply_crate/".. map .."/supplycrate_location.txt", "0;-0;-0;0;0;0", "DATA" )
	end
	
	-- Spawn supply crate entity
	CH_SupplyCrate.InitCrateEnt()
	
	timer.Simple( 5, function()
		CH_SupplyCrate.UpdateLoot()
		
		CH_SupplyCrate.Content.Money = 0
		CH_SupplyCrate.Content.Shipments = 0
		CH_SupplyCrate.Content.Ammo = 0
		
		-- Network the loot
		timer.Simple( 1, function()
			print( "[Supply Crate Robbery] - Networking armory information." )
			net.Start( "CRATE_UpdateContent" )
				net.WriteEntity( CH_SupplyCrate.CrateEntity )
				net.WriteDouble( CH_SupplyCrate.Content.Money )
				net.WriteDouble( CH_SupplyCrate.Content.Shipments )
				net.WriteDouble( CH_SupplyCrate.Content.Ammo )
			net.Broadcast()
		end )
	
		CH_SupplyCrate.IsBeingRobbed = false
		
		timer.Create( "CRATE_DistRobberyCheck", 2, 0, function()
			CH_SupplyCrate.RobberyDistanceCheck()
		end )
		print( "[Supply Crate Robbery] - Script initialized!" )
	end )
end
hook.Add( "Initialize", "CH_SupplyCrate.InitializeAddon", CH_SupplyCrate.InitializeAddon )