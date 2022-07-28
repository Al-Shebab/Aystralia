--[[
	Logging transactions to the SQL database
--]]
function CH_ATM.LogSQLTransaction( ply, action, amount )
	if not CH_ATM.Config.EnableSQL then
		return
	end

	local ply_steamid64 = ply:SteamID64()
	local timestamp = os.date( "%Y/%m/%d %X", os.time() )
	
	local insertObj = mysql:Insert( "ch_atm_transactions" )
		insertObj:Insert( "action", action )
		insertObj:Insert( "amount", amount )
		insertObj:Insert( "timestamp", timestamp )
		insertObj:Insert( "steamid", ply_steamid64 )
	insertObj:Execute()
	
	-- Network it after 1 second
	timer.Simple( 1, function()
		if IsValid( ply ) then
			CH_ATM.NetworkTransactionsSQL( ply )
		end
	end )
end

--[[
	Network transaction to the client
--]]
function CH_ATM.NetworkTransactionsSQL( ply )
	if not CH_ATM.Config.EnableSQL then
		return
	end
	
	local ply_steamid64 = ply:SteamID64()
	
	CH_ATM.DebugPrint( "SERVERSIDE ATM TRANSACTIONS FOR: ".. ply:Nick() )
	
	-- Get data from SQL and network it to the client.
	local queryObj = mysql:Select( "ch_atm_transactions" )
	queryObj:Where( "steamid", ply_steamid64 )
	queryObj:OrderByDesc( "timestamp" )
	queryObj:Limit( CH_ATM.Config.MaximumTransactionsToShow )
	queryObj:Callback( function( results, status, lastid )
		
		CH_ATM.DebugPrint( results )
		
		local table_length = #results
		
		-- Network it to the client as efficient as possible
		net.Start( "CH_ATM_Net_NetworkTransactions" )
			net.WriteUInt( table_length, 6 )

			for key, value in ipairs( results ) do
				net.WriteString( value.action )
				net.WriteDouble( value.amount )
				net.WriteString( value.timestamp )
			end
		net.Send( ply )
	end )
	queryObj:Execute()
end