local function getPeopleNear( targ ) 
	local tab = {}
	
	for k,v in pairs( player.GetAll() ) do
		if ( v:GetPos():Distance( targ:GetPos() ) > 300 ) then 
			continue
		end
		
		local tr = util.TraceLine({
			start = targ:GetShootPos(),
			endpos = v:GetShootPos(),
			filter = { v, targ }
		})
		
		if ( tr.HitWorld ) then
			continue
		end
		
		tab[ #tab + 1 ] = v
	end
	
	return tab
end

util.AddNetworkString("rayStreamChatMessage")
util.AddNetworkString("rayCollectRealChat")

net.Receive("rayCollectRealChat", function( length, ply )
	local str = net.ReadString()
	if #str > 60 then return end

	local start = string.Left( ply.real_chat, 1 )

	if start == "!" or start == "/advert" or start == "@" or start == "/pm" then return end

	net.Start( "rayStreamChatMessage" )
		net.WriteString( str )
		net.WriteEntity( ply )
	net.Send( getPeopleNear( ply ) )
end )