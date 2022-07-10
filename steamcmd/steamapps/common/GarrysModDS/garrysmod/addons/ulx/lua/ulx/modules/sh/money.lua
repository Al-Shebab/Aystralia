CATEGORY_NAME = "Money"
-- Coded by syst3M4TiK; Director of RVNsoftware & Head of ProUnpro
-- http://steamcommunity.com/id/Officialsyst3M4TiK
-- Visit us at http://unpro.rvnsoftware.cf !
-- WARNING: This will ONLY work on DarkRP. Any damage done to your server for not following this warning is your own doing. 

-- The 'Give Money' function. Use the format below (without <>) to give (x) money to the target player.
//!givemoney <name> <amount>
function ulx.givemoney( calling_ply, target_ply, money )

	target_ply:addMoney(money)
	ulx.fancyLogAdmin( calling_ply, "#A gave $#i to #T", money, target_ply) -- Change "$" to whatever currency you want to use.

end

local givemoney = ulx.command( CATEGORY_NAME, "ulx givemoney", ulx.givemoney, "!givemoney" )
givemoney:defaultAccess( ULib.ACCESS_SUPERADMIN )
givemoney:addParam{ type=ULib.cmds.PlayerArg }
givemoney:addParam{ type=ULib.cmds.NumArg, min=0, default=1000, hint="give how much?", ULib.cmds.optional, ULib.cmds.round }
givemoney:help( "Give players the chosen amount of cash" )


-- The 'Take Money' function. Use the format below (without <>) to take away (x) money from the target player.
//!takemoney <name> <amount>
function ulx.takemoney( calling_ply, target_ply, money )

	target_ply:addMoney(-money)
	ulx.fancyLogAdmin( calling_ply, "#A took $#i from #T", money, target_ply) -- Change "$" to whatever currency you want to use.

end

local takemoney = ulx.command( CATEGORY_NAME, "ulx takemoney", ulx.takemoney, "!takemoney" )
takemoney:defaultAccess( ULib.ACCESS_SUPERADMIN )
takemoney:addParam{ type=ULib.cmds.PlayerArg }
takemoney:addParam{ type=ULib.cmds.NumArg, min=0, default=1000, hint="take how much?", ULib.cmds.optional, ULib.cmds.round }
takemoney:help( "Take away the chosen amount of cash from players" )

-- The 'Set Money' function. Use the format below (without <>) to set the target player's money to (x).
//!setmoney <name> <amount>

function ulx.setmoney( calling_ply, target_ply, amount )

	target_ply:setDarkRPVar("money", amount)
	ulx.fancyLogAdmin( calling_ply, "#A set #T's money to $#i", money, target_ply) -- Change "$" to whatever currency you want to use.
	
end
local setmoney = ulx.command( CATEGORY_NAME, "ulx setmoney", ulx.setmoney, "!setmoney" )
setmoney:defaultAccess( ULib.ACCESS_SUPERADMIN )
setmoney:addParam{ type=ULib.cmds.PlayerArg }
setmoney:addParam{ type=ULib.cmds.NumArg, min=0, default=1000, hint="set to what?", ULib.cmds.optional, ULib.cmds.round }
setmoney:help( "Set the money of the target" )

-- The 'Get Money' function. Use the format below (without <>) to get the player's current wallet amount.
-- Submitted by XxLMM13xXgaming; edited by syst3M4TiK
//!getmoney <player>
function ulx.getmoney( calling_ply, target_ply )
 
-- This function will make it so 10000 will be 10,000
local function formatNumber(n)
        if not n then return "" end
        
		if n >= 1e14 then return tostring(n) end
		
		n = tostring(n)
		local sep = sep or ","
		local dp = string.find(n, "%.") or #n+1
		for i=dp-4, 1, -3 do
			n = n:sub(1, i) .. sep .. n:sub(i+1)
		end
        return n
		
end
 
	local plymoney = formatNumber(target_ply:getDarkRPVar("money") or 0)
	ULib.tsayError( calling_ply, "This player currently has $"..plymoney, true )
 
end
local getmoney = ulx.command( CATEGORY_NAME, "ulx getmoney", ulx.getmoney, "!getmoney", true )
getmoney:addParam{ type=ULib.cmds.PlayerArg }
getmoney:defaultAccess( ULib.ACCESS_ADMIN )
getmoney:help( "Prints the players money in chat." )