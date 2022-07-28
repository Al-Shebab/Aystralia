--[[
	Function to save the players account using SQL
--]]
function CH_ATM.SavePlayerBankAccountSQL( ply )
	local ply_steamid64 = ply:SteamID64()

	-- Save the players account using SQL
	local queryObj = mysql:Select( "ch_atm_accounts" )
	queryObj:Where( "steamid", ply_steamid64 )
	queryObj:Callback( function( results, status, lastid )
		if not results[1] then -- PLAYER HAS NO ACCOUNT SO WE CREATE ONE
			local insertObj = mysql:Insert( "ch_atm_accounts" )
				insertObj:Insert( "amount", ply.CH_ATM_BankAccount )
				insertObj:Insert( "level", ply.CH_ATM_BankAccountLevel )
				insertObj:Insert( "steamid", ply_steamid64 )
			insertObj:Execute()
		else -- PLAYER HAS ACCOUNT SO WE UPDATE THE CURRENT ONE
			local updateObj = mysql:Update( "ch_atm_accounts" )
				updateObj:Update( "amount", ply.CH_ATM_BankAccount )
				updateObj:Update( "level", ply.CH_ATM_BankAccountLevel )
				updateObj:Where( "steamid", ply_steamid64 )
			updateObj:Execute()
		end
	end )
	queryObj:Execute()
end

--[[
	Load the wallet from the SQL database
--]]
function CH_ATM.LoadAccountSQL( ply )
	local ply_steamid64 = ply:SteamID64()
	
	CH_ATM.DebugPrint( "LOADING ACCOUNT SQL FOR ".. ply:Nick() )
	
	-- Get data from SQL and insert it into players wallet table.
	local queryObj = mysql:Select( "ch_atm_accounts" )
	queryObj:Where( "steamid", ply_steamid64 )
	queryObj:Callback( function( results, status, lastid )
		-- Initialize variables
		ply.CH_ATM_BankAccount = tonumber( results[1][ "amount" ] )
		ply.CH_ATM_BankAccountLevel = tonumber( results[1][ "level" ] )

		timer.Simple( 2, function()
			if IsValid( ply ) then
				-- Set player default interest based on config and account level
				CH_ATM.SetInterestRate( ply, CH_ATM.Config.AccountLevels[ CH_ATM.GetAccountLevel( ply ) ].InterestRate )
				
				-- Network bank account
				CH_ATM.NetworkBankAccountToPlayer( ply )
			end
		end )
	end )
	queryObj:Execute()
end