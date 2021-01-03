-- Net messages
util.AddNetworkString( "CH_Armory_WeaponMenu" )

util.AddNetworkString( "ARMORY_RestartCooldown" )
util.AddNetworkString( "ARMORY_KillCooldown" )
util.AddNetworkString( "ARMORY_RestartCountdown" )
util.AddNetworkString( "ARMORY_KillCountdown" )

-- Create dirs
if not file.IsDir("craphead_scripts", "DATA") then
	file.CreateDir("craphead_scripts", "DATA")
end

if not file.IsDir("craphead_scripts/armory_robbery/".. string.lower(game.GetMap()) .."", "DATA") then
	file.CreateDir("craphead_scripts/armory_robbery/".. string.lower(game.GetMap()) .."", "DATA")
end

if not file.Exists( "craphead_scripts/armory_robbery/".. string.lower(game.GetMap()) .."/policearmory_location.txt", "DATA" ) then
	file.Write("craphead_scripts/armory_robbery/".. string.lower(game.GetMap()) .."/policearmory_location.txt", "0;-0;-0;0;0;0", "DATA")
end

-- Initialize
function CH_ARMORY_ServerInitilize()
	timer.Simple( 5, function()
		ARMORY_UpdateArmory()
		
		SetGlobalInt( "ARMORY_MoneyAmount", 0 )
		SetGlobalInt( "ARMORY_AmmoAmount", 0 )
		SetGlobalInt( "ARMORY_ShipmentsAmount", 0 )
		
		CH_ArmoryRobbery.IsBeingRobbed = false
	end )
end
hook.Add( "Initialize", "CH_ARMORY_ServerInitilize", CH_ARMORY_ServerInitilize )

-- Respawn armory if cleanup
function CH_ARMORY_RespawnEntCleanup()
	print( "[CH ARMORY] - Map cleaned up. Respawning the armory entity..." )

	timer.Simple( 1, function()
		CH_ARMORY_SpawnPoliceArmory()
	end )
end
hook.Add( "PostCleanupMap", "CH_ARMORY_RespawnEntCleanup", CH_ARMORY_RespawnEntCleanup )

-- 76561198166995690