resource.AddWorkshop( "1911629257")

util.AddNetworkString( "CRATE_RestartCooldown" )
util.AddNetworkString( "CRATE_StopCooldown" )
util.AddNetworkString( "CRATE_RestartTimer" )
util.AddNetworkString( "CRATE_StopTimer" )

util.AddNetworkString( "CRATE_UpdateContent" )
util.AddNetworkString( "CRATE_UpdateMoneyBagAmt" )

function SUPPLY_CRATE_ServerInitilize()
	print( "[Supply Crate Robbery] - Script initialized..." )
	CRATE_UpdateLoot()
		
	CH_SupplyCrate.Content.Money = 0
	CH_SupplyCrate.Content.Shipments = 0
	CH_SupplyCrate.Content.Ammo = 0
		
	timer.Simple( 1, function()
		print( "[Supply Crate Robbery] - Updating armory content clientside..." )
		net.Start( "CRATE_UpdateContent" )
			net.WriteEntity( CH_SupplyCrate.CrateEntity )
			net.WriteDouble( CH_SupplyCrate.Content.Money )
			net.WriteDouble( CH_SupplyCrate.Content.Shipments )
			net.WriteDouble( CH_SupplyCrate.Content.Ammo )
		net.Broadcast()
	end )
		
	CH_SupplyCrate.IsBeingRobbed = false
		
	timer.Create( "CRATE_DistRobberyCheck", 2, 0, function()
		CRATE_RobberyDistanceCheck()
	end )
end
timer.Simple( 5, function()
	SUPPLY_CRATE_ServerInitilize()
end )

function SUPPLY_CRATE_RespawnEntsCleanup()
   print( "[Supply Crate Robbery] - Map cleaned up. Respawning supply create..." )

   timer.Simple( 1, function()
	  SUPPLY_CRATE_InitCrateEnt()
   end )
end
hook.Add( "PostCleanupMap", "SUPPLY_CRATE_RespawnEntsCleanup", SUPPLY_CRATE_RespawnEntsCleanup )