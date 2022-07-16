util.AddNetworkString( "emenu.player_changed_job" )

hook.Add("PlayerChangedTeam", "emenu.server.playerchangedteam", function(ply,old,new)
	net.Start( "emenu.player_changed_job" )
	net.WriteUInt(old,12)
	net.WriteUInt(new,12)
	net.WriteEntity( ply )
	net.Broadcast()
end)