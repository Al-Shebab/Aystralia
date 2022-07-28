-- This file will contain code to Import from other ATM's

--[[
	Import from Blue's ATM
--]]
net.Receive( "CH_ATM_Net_ConvertAccountsFromBlueATM", function( len, ply )
	if ( ply.CH_ATM_NetDelay or CurTime() ) > CurTime() then
		ply:ChatPrint( "You're running the command too fast. Slow down champ!" )
		return
	end
	ply.CH_ATM_NetDelay = CurTime() + 1
	
	if not ply:CH_ATM_IsAdmin() then
		DarkRP.notify( ply, 1, CH_ATM.Config.NotificationTime, CH_ATM.LangString( "Only administrators can perform this action!" ) )
		return
	end
	
	if not BATM then
		DarkRP.notify( ply, 1, CH_ATM.Config.NotificationTime, CH_ATM.LangString( "Failed to detect Blue's ATM on the server!" ) )
		return
	end
	
	if player.GetCount() > 1 then
		DarkRP.notify( ply, 1, CH_ATM.Config.NotificationTime, CH_ATM.LangString( "You have to be alone on the server to do this!" ) )
		return
	end
	
	if not CH_ATM.Config.EnableSQL then
		CH_ATM.NotifyPlayer( ply, CH_ATM.LangString( "SQL must be enabled to do this in-game." ) )
		return
	end
	
	print( "[CH ATM - Import Data] - Transfer initialized." )
	print( "[CH ATM - Import Data] - Transfering from Blue's ATM." )
	
	-- Delete all records
	local queryObj = mysql:Delete( "ch_atm_accounts" )
	queryObj:Execute()
	
	-- Write accounts from batm to ch atm
	local queryObj = mysql:Select( "batm_personal_accounts" )
	queryObj:Callback( function( results, status, lastid )
		for key, value in ipairs( results ) do
			if results[1] then -- PLAYER HAS NO ACCOUNT SO WE CREATE ONE
				local AccountInfo = util.JSONToTable( value.accountinfo )
				
				if not AccountInfo.isGroup then
					local insertObj = mysql:Insert( "ch_atm_accounts" )
						insertObj:Insert( "amount", AccountInfo.balance )
						insertObj:Insert( "level", 1 )
						insertObj:Insert( "steamid", AccountInfo.ownerID )
					insertObj:Execute()
					
					print( "[CH ATM - Import Data] - Creating new account for ".. AccountInfo.ownerID .." with a balance of ".. AccountInfo.balance )
				end
			end
		end
		
		print( "[CH ATM - Import Data] - Transfering from Blue's ATM has finished successfully." )
		print( "[CH ATM - Import Data] - Please delete Blue's ATM from your server and restart it now." )
		
		ply:ChatPrint( CH_ATM.LangString( "Please check your server console for transfer output!" ) )
	end )
	queryObj:Execute()
end )

--[[
	Import from Slown ATM
--]]
net.Receive( "CH_ATM_Net_ConvertAccountsFromSlownLS", function( len, ply )
	if ( ply.CH_ATM_NetDelay or CurTime() ) > CurTime() then
		ply:ChatPrint( "You're running the command too fast. Slow down champ!" )
		return
	end
	ply.CH_ATM_NetDelay = CurTime() + 1
	
	if not ply:CH_ATM_IsAdmin() then
		DarkRP.notify( ply, 1, CH_ATM.Config.NotificationTime, CH_ATM.LangString( "Only administrators can perform this action!" ) )
		return
	end
	
	if not SlownLS then
		DarkRP.notify( ply, 1, CH_ATM.Config.NotificationTime, CH_ATM.LangString( "Failed to detect SlownLS ATM on the server!" ) )
		return
	end
	
	if player.GetCount() > 1 then
		DarkRP.notify( ply, 1, CH_ATM.Config.NotificationTime, CH_ATM.LangString( "You have to be alone on the server to do this!" ) )
		return
	end
	
	if not CH_ATM.Config.EnableSQL then
		CH_ATM.NotifyPlayer( ply, CH_ATM.LangString( "SQL must be enabled to do this in-game." ) )
		return
	end
	
	print( "[CH ATM - Import Data] - Transfer initialized." )
	print( "[CH ATM - Import Data] - Transfering from SlownLS ATM." )
	
	-- Delete all records
	local queryObj = mysql:Delete( "ch_atm_accounts" )
	queryObj:Execute()
	
	-- Write accounts from slownls to ch atm
	local queryObj = mysql:Select( "slownls_atm_accounts" )
	queryObj:Callback( function( results, status, lastid )
		for key, value in ipairs( results ) do
			if results[1] then -- PLAYER HAS NO ACCOUNT SO WE CREATE ONE
				local insertObj = mysql:Insert( "ch_atm_accounts" )
					insertObj:Insert( "amount", value.balance )
					insertObj:Insert( "level", 1 )
					insertObj:Insert( "steamid", value.steamid )
				insertObj:Execute()
				
				print( "[CH ATM - Import Data] - Creating new account for ".. value.steamid .." with a balance of ".. value.balance )
			end
		end
		
		print( "[CH ATM - Import Data] - Transfering from SlownLS ATM has finished successfully." )
		print( "[CH ATM - Import Data] - Please delete SlownLS ATM from your server and restart it now." )
		
		ply:ChatPrint( CH_ATM.LangString( "Please check your server console for transfer output!" ) )
	end )
	queryObj:Execute()
end )

--[[
	Import from Better Banking
--]]