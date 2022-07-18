local PMETA = FindMetaTable( "Player" )

function PMETA:CRATE_RankCanRob()
	local can_rob = false

	for k, v in pairs( CH_SupplyCrate.Config.RankRestrictions ) do
		if serverguard then
			if v.UserGroup == serverguard.player:GetRank( self ) then
				return v.CanRob
			end
		elseif sam then
			if v.UserGroup == sam.player.get_rank( self:SteamID() ) then
				return v.CanRob
			end
		else
			if v.UserGroup == self:GetUserGroup() then
				return v.CanRob
			end
		end
	end

	return can_rob
end

--[[
	XP SUPPORT
--]]
function CH_SupplyCrate.LevelSupport( ply, amount )
	-- Give XP (Vronkadis DarkRP Level System)
	if CH_SupplyCrate.Config.DarkRPLevelSystemEnabled then
		ply:addXP( amount, true )
	end

	-- Give XP (Sublime Levels)
	if CH_SupplyCrate.Config.SublimeLevelSystemEnabled then
		ply:SL_AddExperience( amount, CH_SupplyCrate.Config.Lang["XP rewarded."][CH_SupplyCrate.Config.Language] )
	end

	-- Give XP (Elite XP system)
	if CH_SupplyCrate.Config.EXP2SystemEnabled then
		EliteXP.CheckXP( ply, amount )
	end

	-- Give XP (DarkRP essentials & Brick's Essentials)
	if CH_SupplyCrate.Config.EssentialsXPSystemEnabled then
		ply:AddExperience( amount, CH_SupplyCrate.Config.Lang["XP rewarded."][CH_SupplyCrate.Config.Language] )
	end

	-- Give XP (GlorifiedLeveling)
	if CH_SupplyCrate.Config.GlorifiedLevelingXPSystemEnabled then
		GlorifiedLeveling.AddPlayerXP( ply, amount )
	end
end