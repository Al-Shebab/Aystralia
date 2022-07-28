--[[
	Called on PlayerInitialSpawn to check if the player has a bank account or not and call the appropriate function
--]]
function CH_ATM.ControlPlayerBankAccount( ply )
	local ply_steamid64 = ply:SteamID64()

	if CH_ATM.Config.EnableSQL then
		local queryObj = mysql:Select( "ch_atm_accounts" )
		queryObj:Where( "steamid", ply_steamid64 )
		queryObj:Callback( function( results, status, lastid )
			if results[1] then
				-- BANK ACCOUNT EXISTS - Load players bank account
				CH_ATM.LoadAccountSQL( ply )
			else
				-- NO BANK ACCOUNT - Initialize a new bank account for the player
				CH_ATM.InitializeBankAccount( ply )
			end
		end )
		queryObj:Execute()
	elseif file.Exists( "craphead_scripts/ch_atm/accounts/".. ply_steamid64 .."/bank_account.txt", "DATA" ) then
		-- BANK ACCOUNT EXISTS - Load players bank account
		CH_ATM.LoadBankAccountFile( ply )
	else
		-- NO BANK ACCOUNT - Initialize a new bank account for the player
		if not file.IsDir( "craphead_scripts/ch_atm/accounts/".. ply_steamid64, "DATA" ) then
			file.CreateDir( "craphead_scripts/ch_atm/accounts/".. ply_steamid64, "DATA" )
		end
		
		CH_ATM.InitializeBankAccount( ply )
	end
end

--[[
	Create a bank account for the player
--]]
function CH_ATM.InitializeBankAccount( ply )
	-- Initialize variable
	ply.CH_ATM_BankAccount = CH_ATM.Config.AccountStartMoney
	ply.CH_ATM_BankAccountLevel = 1
	
	-- Save players bank account
	CH_ATM.SavePlayerBankAccount( ply )
	
	timer.Simple( 2, function()
		if IsValid( ply ) then
			-- Set player default interest based on config and account level
			CH_ATM.SetInterestRate( ply, CH_ATM.Config.AccountLevels[ CH_ATM.GetAccountLevel( ply ) ].InterestRate )
			
			-- Network bank account
			CH_ATM.NetworkBankAccountToPlayer( ply )
		end
	end )
end

--[[
	Load bank account file if the player already has an account
--]]
function CH_ATM.LoadBankAccountFile( ply )
	local ply_steamid64 = ply:SteamID64()

	CH_ATM.DebugPrint( "LOADING BANK ACCOUNT FILE FOR ".. ply:Nick() )
	
	-- Load bank account from file if no SQL
	local bank_account = file.Read( "craphead_scripts/ch_atm/accounts/".. ply_steamid64 .."/bank_account.txt", "DATA" )
	local bank_account_level = file.Read( "craphead_scripts/ch_atm/accounts/".. ply_steamid64 .."/bank_account_level.txt", "DATA" )
	
	-- Create bank account variable based on file
	ply.CH_ATM_BankAccount = tonumber( bank_account )
	ply.CH_ATM_BankAccountLevel = tonumber( bank_account_level )

	timer.Simple( 2, function()
		if IsValid( ply ) then
			-- Set player default interest based on config and account level
			CH_ATM.SetInterestRate( ply, CH_ATM.Config.AccountLevels[ CH_ATM.GetAccountLevel( ply ) ].InterestRate )
			
			-- Network bank account
			CH_ATM.NetworkBankAccountToPlayer( ply )
		end
	end )
end

--[[
	Network bank account to the player
--]]
function CH_ATM.NetworkBankAccountToPlayer( ply )
	local bank_account_amt = CH_ATM.GetMoneyBankAccount( ply )
	local bank_account_level = CH_ATM.GetAccountLevel( ply )
	
	-- Network it
	net.Start( "CH_ATM_Net_NetworkBankAccount" )
		net.WriteUInt( bank_account_amt, 32 )
		net.WriteUInt( bank_account_level, 8 )
	net.Send( ply )
end

--[[
	Function to save the players bank account
--]]
function CH_ATM.SavePlayerBankAccount( ply )
	local ply_steamid64 = ply:SteamID64()
	
	if CH_ATM.Config.EnableSQL then
		-- Save the players wallet using SQL
		CH_ATM.SavePlayerBankAccountSQL( ply )
	else
		local bank_account_amt = CH_ATM.GetMoneyBankAccount( ply )
		local bank_account_level = CH_ATM.GetAccountLevel( ply )
	
		file.Write( "craphead_scripts/ch_atm/accounts/".. ply_steamid64 .."/bank_account.txt", bank_account_amt, "DATA" )
		
		file.Write( "craphead_scripts/ch_atm/accounts/".. ply_steamid64 .."/bank_account_level.txt", bank_account_level, "DATA" )
	end
end