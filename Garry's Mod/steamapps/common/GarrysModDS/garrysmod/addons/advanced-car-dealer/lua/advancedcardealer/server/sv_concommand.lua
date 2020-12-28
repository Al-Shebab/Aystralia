local CFG = AdvCarDealer.GetConfig

concommand.Add("acd_givevehicle", function( ply, cmd, args )
	if IsValid( ply ) and not CFG().AdminUserGroups[ ply:GetUserGroup() ] then return end

    args = args or {}
    if not args[ 1 ] then print( "You should add a steamid in arguments : acd_givevehicle steamid classname") return end 
    if not args[ 2 ] then print( "You should add a classname in arguments : acd_givevehicle steamid classname ") return end 
    if not AdvCarDealer.GetCarInformations( args[ 2 ] ) then print( "You should add a classname of a car available in the shop in arguments : acd_givevehicle steamid classname ") return end
    local model = args[ 2 ]

    local SteamID = args[ 1 ]
	local SteamID2 = util.SteamIDFrom64( SteamID )

	if SteamID2 ~= "STEAM_0:0:0" then
		SteamID = SteamID2
	end

	tInfos = {
		className = args[ 2 ],
		skin = 0,
		color = "255 255 255 255"
	}

	AdvCarDealer:AddPlayerCar( SteamID, tInfos, true, function()
		print( "[Advanced Car Dealer] A vehicle has been given to a player with command acd_givevehicle." )
	end )
end)

concommand.Add("acd_clearplayercars", function( ply, cmd, args )
	if IsValid( ply ) and not CFG().AdminUserGroups[ ply:GetUserGroup() ] then return end

    args = args or {}
    if not args[ 1 ] then print( "You should add a steamid in arguments : acd_clearplayercars steamid") return end 

    local SteamID = args[ 1 ]
	local SteamID2 = util.SteamIDFrom64( SteamID )

	if SteamID2 ~= "STEAM_0:0:0" then
		SteamID = SteamID2
	end

	AdvCarDealer:ClearPlayerCars( SteamID )
end)

concommand.Add("acd_despawncars", function( ply, cmd, args )
	if IsValid( ply ) and not CFG().AdminUserGroups[ ply:GetUserGroup() ] then return end

    args = args or {}
    if not args[ 1 ] then print( "You should add a steamid in arguments : acd_despawncars steamid") return end 

    local SteamID = args[ 1 ]
	local SteamID2 = util.SteamIDFrom64( SteamID )

	if SteamID2 ~= "STEAM_0:0:0" then
		SteamID = SteamID2
	end

	local pPlayer = player.GetBySteamID( SteamID )

	if not IsValid( pPlayer ) then return end
	
	AdvCarDealer:ClearCars( pPlayer )
end)