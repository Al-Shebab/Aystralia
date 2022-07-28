--[[
	Net msg to view a player
	Sends data about the player back to the admin that requests it
--]]
net.Receive( "CH_ATM_Net_AdminViewPlayer", function( len, ply )
	if ( ply.CH_ATM_NetDelay or CurTime() ) > CurTime() then
		ply:ChatPrint( "You're running the command too fast. Slow down champ!" )
		return
	end
	ply.CH_ATM_NetDelay = CurTime() + 1
	
	if not ply:CH_ATM_IsAdmin() then
		DarkRP.notify( ply, 1, CH_ATM.Config.NotificationTime, CH_ATM.LangString( "Only administrators can perform this action!" ) )
		return
	end
	
	local target_ply = net.ReadEntity()
	
	-- Send the net message back (opens a menu)
	net.Start( "CH_ATM_Net_AdminViewPlayerMenu" )
		net.WriteEntity( target_ply )
		net.WriteUInt( CH_ATM.GetMoneyBankAccount( target_ply ), 32 )
		net.WriteUInt( CH_ATM.GetAccountLevel( target_ply ), 8 )
	net.Send( ply )
end )

--[[
	Give money to player via admin menu
--]]
net.Receive( "CH_ATM_Net_AdminGiveMoney", function( len, ply )
	if ( ply.CH_ATM_NetDelay or CurTime() ) > CurTime() then
		ply:ChatPrint( "You're running the command too fast. Slow down champ!" )
		return
	end
	ply.CH_ATM_NetDelay = CurTime() + 1
	
	if not ply:CH_ATM_IsAdmin() then
		DarkRP.notify( ply, 1, CH_ATM.Config.NotificationTime, CH_ATM.LangString( "Only administrators can perform this action!" ) )
		return
	end
	
	local target_ply = net.ReadEntity()
	local amount = net.ReadUInt( 32 )
	
	-- Control check amount
	if amount <= 0 then
		DarkRP.notify( ply, 1, CH_ATM.Config.NotificationTime, CH_ATM.LangString( "Please enter a valid number" ) )
		return
	end
	
	-- Perform action
	-- Give them money
	CH_ATM.AddMoneyToBankAccount( target_ply, amount )
	
	-- bLogs support
	hook.Run( "CH_ATM_bLogs_ReceiveMoney", amount, target_ply, "Given by an admin." )
	
	-- Notify
	CH_ATM.NotifyPlayer( target_ply, CH_ATM.FormatMoney( amount ) .." ".. CH_ATM.LangString( "has been added to your bank account." ) )
	
	CH_ATM.NotifyPlayer( ply, CH_ATM.LangString( "Action Successful" ) )
end )

--[[
	Take money from player via admin menu
--]]
net.Receive( "CH_ATM_Net_AdminTakeMoney", function( len, ply )
	if ( ply.CH_ATM_NetDelay or CurTime() ) > CurTime() then
		ply:ChatPrint( "You're running the command too fast. Slow down champ!" )
		return
	end
	ply.CH_ATM_NetDelay = CurTime() + 1
	
	if not ply:CH_ATM_IsAdmin() then
		DarkRP.notify( ply, 1, CH_ATM.Config.NotificationTime, CH_ATM.LangString( "Only administrators can perform this action!" ) )
		return
	end
	
	local target_ply = net.ReadEntity()
	local amount = net.ReadUInt( 32 )
	
	-- Control check amount
	if amount <= 0 then
		DarkRP.notify( ply, 1, CH_ATM.Config.NotificationTime, CH_ATM.LangString( "Please enter a valid number" ) )
		return
	end
	
	-- Perform action
	-- Take money from their bank account (will also save)
	CH_ATM.TakeMoneyFromBankAccount( target_ply, amount )
	
	-- bLogs support
	hook.Run( "CH_ATM_bLogs_TakeMoney", amount, target_ply, "Taken by an admin." )
	
	-- Notify
	CH_ATM.NotifyPlayer( target_ply, CH_ATM.FormatMoney( amount ) .." ".. CH_ATM.LangString( "has been deducted from your bank account." ) )
	
	CH_ATM.NotifyPlayer( ply, CH_ATM.LangString( "Action Successful" ) )
end )

--[[
	Reset a players account level via admin menu
--]]
net.Receive( "CH_ATM_Net_AdminResetAccountLevel", function( len, ply )
	if ( ply.CH_ATM_NetDelay or CurTime() ) > CurTime() then
		ply:ChatPrint( "You're running the command too fast. Slow down champ!" )
		return
	end
	ply.CH_ATM_NetDelay = CurTime() + 1
	
	if not ply:CH_ATM_IsAdmin() then
		DarkRP.notify( ply, 1, CH_ATM.Config.NotificationTime, CH_ATM.LangString( "Only administrators can perform this action!" ) )
		return
	end
	
	local target_ply = net.ReadEntity()
	
	-- Perform action
	-- Reset level
	ply.CH_ATM_BankAccountLevel = 1
	
	-- Set new interest rate
	CH_ATM.SetInterestRate( ply, CH_ATM.Config.AccountLevels[ CH_ATM.GetAccountLevel( ply ) ].InterestRate )
	
	-- Save players bank account
	CH_ATM.SavePlayerBankAccount( target_ply )
	
	-- Network it
	CH_ATM.NetworkBankAccountToPlayer( target_ply )
	
	-- Notify
	CH_ATM.NotifyPlayer( target_ply, CH_ATM.LangString( "An admin has reset your bank account level!" ) )
	
	CH_ATM.NotifyPlayer( ply, CH_ATM.LangString( "Action Successful" ) )
end )

--[[
	Reset every players balance and account level
--]]
net.Receive( "CH_ATM_Net_AdminResetAllAccounts", function( len, ply )
	if ( ply.CH_ATM_NetDelay or CurTime() ) > CurTime() then
		ply:ChatPrint( "You're running the command too fast. Slow down champ!" )
		return
	end
	ply.CH_ATM_NetDelay = CurTime() + 1
	
	if not ply:IsSuperAdmin() then
		DarkRP.notify( ply, 1, CH_ATM.Config.NotificationTime, CH_ATM.LangString( "Only administrators can perform this action!" ) )
		return
	end

	if player.GetCount() > 1 then
		DarkRP.notify( ply, 1, CH_ATM.Config.NotificationTime, CH_ATM.LangString( "You have to be alone on the server to do this!" ) )
		return
	end
	
	-- Check if SQL is enabled
	if not CH_ATM.Config.EnableSQL then
		CH_ATM.NotifyPlayer( ply, CH_ATM.LangString( "SQL must be enabled to do this in-game." ) )
		CH_ATM.NotifyPlayer( ply, CH_ATM.LangString( "Wipe it manually in garrysmod/data/craphead_scripts/ch_atm/accounts/" ) )
		return
	end
	
	if not CH_ATM.Config.EnableResetAllAccounts then
		return
	end
	
	-- Wipe data
	local queryObj = mysql:Select( "ch_atm_accounts" )
	queryObj:Callback( function( results, status, lastid )
		local updateObj = mysql:Update( "ch_atm_accounts" )
			updateObj:Update( "amount", CH_ATM.Config.AccountStartMoney )
			updateObj:Update( "level", 1 )
		updateObj:Execute()
	end )
	queryObj:Execute()
	
	ply.CH_ATM_BankAccount = CH_ATM.Config.AccountStartMoney
	ply.CH_ATM_BankAccountLevel = 1
	
	timer.Simple( 2, function()
		if IsValid( ply ) then
			-- Set player default interest based on config and account level
			CH_ATM.SetInterestRate( ply, CH_ATM.Config.AccountLevels[ CH_ATM.GetAccountLevel( ply ) ].InterestRate )
			
			-- Network bank account
			CH_ATM.NetworkBankAccountToPlayer( ply )
		end
	end )
	
	-- Notify
	CH_ATM.NotifyPlayer( ply, CH_ATM.LangString( "Action Successful" ) )
end )

--[[
	Emergency lockdown all ATMs on the map
--]]
net.Receive( "CH_ATM_Net_AdminATMEmergencyLockdown", function( len, ply )
	if ( ply.CH_ATM_NetDelay or CurTime() ) > CurTime() then
		ply:ChatPrint( "You're running the command too fast. Slow down champ!" )
		return
	end
	ply.CH_ATM_NetDelay = CurTime() + 1
	
	if not ply:CH_ATM_IsAdmin() then
		DarkRP.notify( ply, 1, CH_ATM.Config.NotificationTime, CH_ATM.LangString( "Only administrators can perform this action!" ) )
		return
	end
	
	local is_lockdown = net.ReadBool()
	
	-- Set var on ATM ents
	for k, ent in ipairs( ents.FindByClass( "ch_atm" ) ) do
		if IsValid( ent ) then
			ent:SetIsEmergencyLockdown( is_lockdown )
		end
	end

	-- Notify all players
	for k, v in ipairs( player.GetAll() ) do
		if is_lockdown then
			DarkRP.notify( v, 1, CH_ATM.Config.NotificationTime, CH_ATM.LangString( "An administrator has initiated an emergency lockdown on all ATMs in the city!" ) )
		else
			DarkRP.notify( v, 1, CH_ATM.Config.NotificationTime, CH_ATM.LangString( "Emergency ATM lockdown has ended. They are available for use again!" ) )
		end
	end
end )

--[[
	Lookup offline account and open UI with data if found
--]]
net.Receive( "CH_ATM_Net_AdminCheckOfflineAccount", function( len, ply )
	if ( ply.CH_ATM_NetDelay or CurTime() ) > CurTime() then
		ply:ChatPrint( "You're running the command too fast. Slow down champ!" )
		return
	end
	ply.CH_ATM_NetDelay = CurTime() + 1
	
	if not ply:CH_ATM_IsAdmin() then
		DarkRP.notify( ply, 1, CH_ATM.Config.NotificationTime, CH_ATM.LangString( "Only administrators can perform this action!" ) )
		return
	end
	
	local ply_steamid64 = net.ReadString()

	-- If SQL is enabled then run a query with specified SteamID
	if CH_ATM.Config.EnableSQL then
		local queryObj = mysql:Select( "ch_atm_accounts" )
		queryObj:Where( "steamid", ply_steamid64 )
		queryObj:Callback( function( results, status, lastid )
			if results[1] then -- PLAYER HAS ACCOUNT
				local money = results[1][ "amount" ]
				local level = results[1][ "level" ]
				
				net.Start( "CH_ATM_Net_AdminShowOfflineAccount" )
					net.WriteString( ply_steamid64 )
					net.WriteUInt( money, 32 )
					net.WriteUInt( level, 8 )
				net.Send( ply )
			else
				DarkRP.notify( ply, 1, CH_ATM.Config.NotificationTime, CH_ATM.LangString( "No account found with this SteamID!" ) )
			end
		end )
		queryObj:Execute()
	else
		-- If no SQL then check if the data folder exists with the specified SteamID
		if file.IsDir( "craphead_scripts/ch_atm/accounts/".. ply_steamid64, "DATA" ) then
			local money = file.Read( "craphead_scripts/ch_atm/accounts/".. ply_steamid64 .."/bank_account.txt", "DATA" )
			local level = file.Read( "craphead_scripts/ch_atm/accounts/".. ply_steamid64 .."/bank_account_level.txt", "DATA" )
			
			net.Start( "CH_ATM_Net_AdminShowOfflineAccount" )
				net.WriteString( ply_steamid64 )
				net.WriteUInt( money, 32 )
				net.WriteUInt( level, 8 )
			net.Send( ply )
		else
			DarkRP.notify( ply, 1, CH_ATM.Config.NotificationTime, CH_ATM.LangString( "No account found with this SteamID!" ) )
		end
	end
end )

net.Receive( "CH_ATM_Net_AdminUpdateOfflineAccount", function( len, ply )
	if ( ply.CH_ATM_NetDelay or CurTime() ) > CurTime() then
		ply:ChatPrint( "You're running the command too fast. Slow down champ!" )
		return
	end
	ply.CH_ATM_NetDelay = CurTime() + 1
	
	if not ply:CH_ATM_IsAdmin() then
		DarkRP.notify( ply, 1, CH_ATM.Config.NotificationTime, CH_ATM.LangString( "Only administrators can perform this action!" ) )
		return
	end
	
	local ply_steamid64 = net.ReadString()
	local money = net.ReadUInt( 32 )
	local level = net.ReadUInt( 8 )
	
	local found_ply = player.GetBySteamID64( ply_steamid64 )
	
	if money < 0 then
		return
	end
	
	if level < 1 then
		return
	end
	
	-- If SQL is enabled then run a query with specified SteamID and update if anything is found
	if CH_ATM.Config.EnableSQL then
		-- Save the players account using SQL
		local queryObj = mysql:Select( "ch_atm_accounts" )
		queryObj:Where( "steamid", ply_steamid64 )
		queryObj:Callback( function( results, status, lastid )
			if results[1] then -- PLAYER HAS ACCOUNT
				local updateObj = mysql:Update( "ch_atm_accounts" )
					updateObj:Update( "amount", money )
					updateObj:Update( "level", level )
					updateObj:Where( "steamid", ply_steamid64 )
				updateObj:Execute()
			else
				DarkRP.notify( ply, 1, CH_ATM.Config.NotificationTime, CH_ATM.LangString( "No account found with this SteamID!" ) )
			end
		end )
		queryObj:Execute()
	else
		-- If no SQL then check if the data folder exists with the specified SteamID and update if anything is found
		if file.IsDir( "craphead_scripts/ch_atm/accounts/".. ply_steamid64, "DATA" ) then
			file.Write( "craphead_scripts/ch_atm/accounts/".. ply_steamid64 .."/bank_account.txt", money, "DATA" )
		
			file.Write( "craphead_scripts/ch_atm/accounts/".. ply_steamid64 .."/bank_account_level.txt", level, "DATA" )
		else
			DarkRP.notify( ply, 1, CH_ATM.Config.NotificationTime, CH_ATM.LangString( "No account found with this SteamID!" ) )
		end
	end

	-- Check if found_ply is valid on the server and in that case update variables live and network it.
	if IsValid( found_ply ) then
		found_ply.CH_ATM_BankAccount = money
		found_ply.CH_ATM_BankAccountLevel = level

		timer.Simple( 2, function()
			if IsValid( found_ply ) then
				-- Set player default interest based on config and account level
				CH_ATM.SetInterestRate( found_ply, CH_ATM.Config.AccountLevels[ CH_ATM.GetAccountLevel( found_ply ) ].InterestRate )
				
				-- Network bank account
				CH_ATM.NetworkBankAccountToPlayer( found_ply )
			end
		end )
	end
	
	-- Notify
	CH_ATM.NotifyPlayer( ply, CH_ATM.LangString( "Action Successful" ) )
end )