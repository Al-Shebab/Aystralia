util.AddNetworkString( "BANK2_RestartCooldown" )
util.AddNetworkString( "BANK2_KillCooldown" )

util.AddNetworkString( "BANK2_RestartCountdown" )
util.AddNetworkString( "BANK2_KillCountdown" )

util.AddNetworkString( "BANK2_UpdateCurrentRobbers" )
util.AddNetworkString( "BANK2_RemoveCurrentRobbers" )

util.AddNetworkString( "BANK2_UpdateBankMoney" )

-- Create directories
if not file.IsDir( "craphead_scripts", "DATA" ) then
	file.CreateDir( "craphead_scripts", "DATA" )
end
	
if not file.IsDir( "craphead_scripts/bank_robbery2/".. string.lower( game.GetMap() ) .."", "DATA" ) then
	file.CreateDir( "craphead_scripts/bank_robbery2/".. string.lower( game.GetMap() ) .."", "DATA" )
end

if not file.IsDir( "craphead_scripts/bank_robbery2_copsnpcdlc/".. string.lower( game.GetMap() ) .."", "DATA" ) then
	file.CreateDir( "craphead_scripts/bank_robbery2_copsnpcdlc/".. string.lower( game.GetMap() ) .."", "DATA" )
end

-- Initialize script functions
function CH_BankRobbery2_Initialize()
	-- Call functions with timers
	CH_BankRobbery2_AddMoneyTimer()
	CH_BankRobbery2_RobberyFailCheck()
	
	-- Set default money and network it
	CH_BankVault.Content.Money = CH_BankVault.Config.StartMoney
	
	timer.Simple( 2, function()
		net.Start( "BANK2_UpdateBankMoney" )
			net.WriteEntity( CH_BankVault.BankEntity )
			net.WriteDouble( CH_BankVault.Content.Money )
		net.Broadcast()
	end )
	
	-- Set start values
	CH_BankVault.BankIsBeingRobbed = false
	CH_BankVault.RobbersCanJoin = false
end
hook.Add( "Initialize", "CH_BankRobbery2_Initialize", CH_BankRobbery2_Initialize )

function CH_BankRobbery2_RespawnEntCleanup()
	print( "[BANK2] - Map cleaned up. Respawning the bank vault entity..." )

	timer.Simple( 1, function()
		CH_BankRobbery2_VaultInitialize()
	end )
end
hook.Add( "PostCleanupMap", "CH_BankRobbery2_RespawnEntCleanup", CH_BankRobbery2_RespawnEntCleanup )

-- 76561198166995690