for k, v in pairs( CH_AdminPopups.Config.OnDutyJobs ) do
	CH_AdminPopups.Config.OnDutyJobs[k] = v:lower()
end

function CH_AdminPopups.PlayerHasAccess( ply )
	if ulx then
		return ply:query( "ulx seeasay" )	
	end
	
	if sam then
		return ply:HasPermission( "see_admin_chat" )
	end
	
	if serverguard then
		return serverguard.player:HasPermission( ply, "Manage Reports" )
	end
	
	if sAdmin then
		return sAdmin.hasPermission( ply, "is_staff" )
	end
	
	return ply:IsAdmin()
end