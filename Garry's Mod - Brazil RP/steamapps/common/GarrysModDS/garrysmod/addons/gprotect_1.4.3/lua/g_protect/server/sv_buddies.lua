util.AddNetworkString("gP:Buddies")
local limiter = {}
local netlimiter = {}

local weapons = {
	[1] = "weapon_physcannon",
	[2] = "weapon_physgun",
	[3] = "gmod_tool",
	[4] = "canProperty"
}

gProtect.TouchPermission = gProtect.TouchPermission or {}

hook.Add( "PlayerSay", "gP:OpenBuddies", function( ply, text, public )
	if (( string.lower( text ) == "!buddies" )) then
		ply:ConCommand("buddies")

		return ""
	end
end )

hook.Add( "PlayerDisconnected", "gP:HandleDisconnectionBuddies", function(ply)
	limiter[ply:SteamID64()] = nil

	gProtect.TouchPermission[ply:SteamID()] = nil
end)

net.Receive("gP:Buddies", function(_, ply)
	if !limiter[ply:SteamID64()] then
		limiter[ply:SteamID64()] = true

		gProtect.networkTouchPermissions(ply)
	end

	local buddy = net.ReadInt(15)
	local weapon = net.ReadUInt(3)
	local todo = net.ReadBool()
	local sid = ply:SteamID()
	if !isnumber(buddy) or !isnumber(weapon) then return end

	if !todo then todo = nil end
	weapon = weapons[weapon]
	
	buddy = ents.GetByIndex(buddy)

	if weapon == nil or !IsValid(buddy) or !buddy:IsPlayer() then return end
	
	gProtect.TouchPermission[sid] = gProtect.TouchPermission[sid] or {}
	gProtect.TouchPermission[sid][weapon] = gProtect.TouchPermission[sid][weapon] or {}
	gProtect.TouchPermission[sid][weapon][buddy:SteamID()] = todo
	
	gProtect.networkTouchPermissions(buddy, sid)
end)