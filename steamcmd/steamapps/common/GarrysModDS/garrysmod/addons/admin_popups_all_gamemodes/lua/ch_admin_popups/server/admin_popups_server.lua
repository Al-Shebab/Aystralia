util.AddNetworkString( "CH_AdminPopups_CasePopup" )
util.AddNetworkString( "CH_AdminPopups_ClaimCase" )
util.AddNetworkString( "CH_AdminPopups_CloseCase" )

--[[
	FILE CONTROL
--]]

if not file.Exists( "ch_admin_popups_caseclaims.txt","DATA" ) then
	file.Write( "ch_admin_popups_caseclaims.txt", "[]" )
end

local caseclaims = util.JSONToTable( file.Read( "ch_admin_popups_caseclaims.txt", "DATA" ) )

local function tabletofile()
	file.Write( "ch_admin_popups_caseclaims.txt", util.TableToJSON( caseclaims ) )
end

--[[
	NET MESSAGES
--]]

net.Receive( "CH_AdminPopups_ClaimCase", function( len, ply )
	-- Rate limit net message
	local cur_time = CurTime()
	if ( ply.CH_AdminPopups_NetRateLimit or 0 ) > cur_time then
		ply:ChatPrint( "You're running the command too fast. Slow down champ!" )
		return
	end
	ply.CH_AdminPopups_NetRateLimit = cur_time + 1.5
	
	local noob = net.ReadEntity()
	
	if CH_AdminPopups.PlayerHasAccess( ply ) and not noob.CH_AdminPopups_CaseClaimed then
		for k, v in ipairs( player.GetAll() ) do
			if CH_AdminPopups.PlayerHasAccess( v ) then
				net.Start("CH_AdminPopups_ClaimCase")
					net.WriteEntity( ply )
					net.WriteEntity( noob )
				net.Send( v )
			end
		end
		
		hook.Call( "CH_AdminPopups_Hook_ClaimCase", GAMEMODE, ply, noob ) -- for use of other addons (such as statistics) like this one steamcommunity.com/workshop/gmod/?id=76561198019733081
		
		noob.CH_AdminPopups_CaseClaimed = ply
	end
end )

net.Receive( "CH_AdminPopups_CloseCase", function( len, ply )
	-- Rate limit net message
	local cur_time = CurTime()
	if ( ply.CH_AdminPopups_NetRateLimit or 0 ) > cur_time then
		ply:ChatPrint( "You're running the command too fast. Slow down champ!" )
		return
	end
	ply.CH_AdminPopups_NetRateLimit = cur_time + 1.5
	
	local noob = net.ReadEntity()
	
	if not noob or not IsValid( noob ) then
		return
	end
	
	if not noob.CH_AdminPopups_CaseClaimed == ply then
		return
	end
	
	if timer.Exists( "CH_AdminPopup_Timer_".. noob:SteamID64() ) then
		timer.Destroy( "CH_AdminPopup_Timer_".. noob:SteamID64() )
	end
	
	for k, ply in ipairs( player.GetAll() ) do
		if CH_AdminPopups.PlayerHasAccess( ply ) then
			net.Start("CH_AdminPopups_CloseCase")
				net.WriteEntity( noob )
			net.Send( ply )
		end
	end
	
	noob.CH_AdminPopups_CaseClaimed = nil
end )

--[[
	Admin Popup function
--]]
function CH_AdminPopups.SendAdminPopup( noob, message )
	if CH_AdminPopups.Config.CaseUpdateOnly then
		if noob.CH_AdminPopups_CaseClaimed then
			if IsValid( noob.CH_AdminPopups_CaseClaimed ) and noob.CH_AdminPopups_CaseClaimed:IsPlayer() then
				net.Start( "CH_AdminPopups_CasePopup" )
					net.WriteEntity( noob )
					net.WriteString( message )
					net.WriteEntity( noob.CH_AdminPopups_CaseClaimed )
				net.Send( noob.CH_AdminPopups_CaseClaimed )
			end
		else
			for k, ply in ipairs( player.GetAll() ) do
				if CH_AdminPopups.PlayerHasAccess( ply ) then
					net.Start( "CH_AdminPopups_CasePopup" )
						net.WriteEntity( noob )
						net.WriteString( message )
						net.WriteEntity( noob.CH_AdminPopups_CaseClaimed )
					net.Send( ply )
				end
			end
		end
	else
		for k, ply in ipairs( player.GetAll() ) do
			if CH_AdminPopups.PlayerHasAccess( ply ) then
				net.Start("CH_AdminPopups_CasePopup")
					net.WriteEntity( noob )
					net.WriteString( message )
					net.WriteEntity( noob.CH_AdminPopups_CaseClaimed )
				net.Send( ply )
			end
		end
	end
	
	if IsValid( noob ) and noob:IsPlayer() then
		timer.Destroy( "CH_AdminPopup_Timer_".. noob:SteamID64() )
		
		if CH_AdminPopups.Config.AutoCloseTime > 0 then
			timer.Create( "CH_AdminPopup_Timer_".. noob:SteamID64(), CH_AdminPopups.Config.AutoCloseTime, 1, function()
				if IsValid( noob ) and noob:IsPlayer() then
					noob.CH_AdminPopups_CaseClaimed = nil
				end
			end )
		end
	end
end

--[[
	HOOKS
--]]

function CH_AdminPopups.PlayerSay( ply, text )
	if ( string.StartWith( string.lower( text ), CH_AdminPopups.Config.ReportCommand ) ) then
		text = string.Replace( text, CH_AdminPopups.Config.ReportCommand, "" )

		if CH_AdminPopups.PlayerHasAccess( ply ) then
			if CH_AdminPopups.Config.Debug then
				CH_AdminPopups.SendAdminPopup( ply, text )
			end
		else
			CH_AdminPopups.SendAdminPopup( ply, text )
		end
		
		ply:ChatPrint( CH_AdminPopups.Config.PrintReportText )
		
		return ""
	end
end
hook.Add( "PlayerSay", "CH_AdminPopups.PlayerSay", CH_AdminPopups.PlayerSay )

hook.Add( "PlayerDisconnected", "CH_AdminPopups_PopupsClose",function( noob )
	for k, ply in ipairs( player.GetAll() ) do
		if CH_AdminPopups.PlayerHasAccess( ply ) then
			net.Start( "CH_AdminPopups_CloseCase" )
				net.WriteEntity( noob )
			net.Send( ply )
		end
	end	
end )

hook.Add( "CH_AdminPopups_Hook_ClaimCase", "CH_AdminPopups_StoreClaims", function( admin, noob )
	-- Insert if it doesn't exist
	caseclaims[admin:SteamID()] = caseclaims[admin:SteamID()] or {
		name = admin:Nick(),
		claims = 0,
		lastclaim = os.time()
	}
	
	-- Update it
	caseclaims[admin:SteamID()] = {
		name = admin:Nick(),
		claims = caseclaims[admin:SteamID()].claims + 1,
		lastclaim = os.time()
	}
	
	tabletofile()
end )