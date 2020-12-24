function fcd.adminAccess( ply )
	if not ply then return end

	return table.HasValue( fcd.cfg.adminRanks, ply:GetUserGroup() )
end