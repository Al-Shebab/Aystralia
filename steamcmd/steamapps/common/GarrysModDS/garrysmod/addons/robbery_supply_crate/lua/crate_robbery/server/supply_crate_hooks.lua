local function SUPPLY_CRATE_RespawnEntsCleanup()
   print( "[Supply Crate Robbery] - Map cleaned up. Respawning supply create..." )

   timer.Simple( 1, function()
	  CH_SupplyCrate.InitCrateEnt()
   end )
end
hook.Add( "PostCleanupMap", "SUPPLY_CRATE_RespawnEntsCleanup", SUPPLY_CRATE_RespawnEntsCleanup )

-- Robbery failure check on PlayerDeath
function CH_SupplyCrate.PlayerDeath( ply, inflictor, attacker )
	if ply.IsRobbingCrate then
		DarkRP.notify( ply, 1, 5, CH_SupplyCrate.Config.Lang["You have failed to rob the loot from the supply crate!"][CH_SupplyCrate.Config.Language] )

		if IsValid( attacker ) then
			if ply != attacker then
				DarkRP.notify( attacker, 1, 5, "+".. DarkRP.formatMoney( CH_SupplyCrate.Config.KillReward ) .." "..CH_SupplyCrate.Config.Lang["rewarded for killing the robber."][CH_SupplyCrate.Config.Language] )
				attacker:addMoney( CH_SupplyCrate.Config.KillReward )
				
				-- XP System Support
				CH_SupplyCrate.LevelSupport( attacker, CH_SupplyCrate.Config.XPStoppingRobber )
			end
		end
		
		CH_SupplyCrate.RobberyFinished( false )

		ply.IsRobbingCrate = false
		
		-- bLogs support
		hook.Run( "SUPPLY_CRATE_RobberyFailed", ply )
	end
end
hook.Add( "PlayerDeath", "CH_SupplyCrate.PlayerDeath", CH_SupplyCrate.PlayerDeath )

-- Robbery failure check on PlayerDisconnected
function CH_SupplyCrate.PlayerDisconnected( ply )
	if ply.IsRobbingCrate then			
		CH_SupplyCrate.RobberyFinished( false )

		ply.IsRobbingCrate = false
	end
end
hook.Add( "PlayerDisconnected", "CH_SupplyCrate.PlayerDisconnected", CH_SupplyCrate.PlayerDisconnected )