--[[------------------------------
  AWarn 2
----------------------------------]]

include( 'includes/sh_awarn2.lua' )

include( 'includes/awarn2_convarcreate.lua' )
include( 'includes/awarn2_mysql_abstraction.lua' )
include( 'includes/awarn2_logging.lua' )
include( 'includes/awarn2_utilnetwork.lua' )
include( 'includes/awarn2_stats.lua' )
include( 'includes/awarn2_localization.lua' )

AddCSLuaFile( "includes/cl_awarn2.lua" )
AddCSLuaFile( "includes/sh_awarn2.lua" )
AddCSLuaFile( "includes/awarn2_convarcreate.lua" )
AddCSLuaFile( "includes/awarn2_localization.lua" )
AddCSLuaFile( "includes/awarn2_menu.lua" )
AddCSLuaFile( "includes/awarn2_skin.lua" )

function awarn_loadscript()
	awarn_tbl_exist()
end
hook.Add( "Initialize", "Awarn_Initialize", awarn_loadscript )

local loc = AWarn.localizations.localLang

function awarn_kick( ply, message )
	if ulx then
		ULib.kick( ply, message )
	else
		ply:Kick( message )
	end
end

function awarn_ban( ply, time, message )
	if ulx then
		ULib.kickban( ply, time, message )
	else
		ply:Ban( time, true, message )
	end
end

function awarn_playerdisconnected( ply )
	timer.Remove( ply:SteamID64() .. "_awarn_decay" )
end
hook.Add( "PlayerDisconnected", "awarn_playerdisconnected", awarn_playerdisconnected )

net.Receive( "awarn_fetchwarnings", function( l, ply )
	if not awarn_checkadmin_view( ply ) then
		AWSendMessage( ply, "AWarn: " .. AWarn.localizations[loc].sv1)
		return
	end
	local player_type = net.ReadString()
	local player_target = net.ReadString()
	if player_type == "playername" then
		local target_ply = awarn_getUser( player_target )
		
		if target_ply then
			awarn_sendwarnings( ply, target_ply )
		else
			AWSendMessage( ply, "AWarn: " .. AWarn.localizations[loc].cl37)
		end
	elseif player_type == "playerid" then
		awarn_sendwarnings_id( ply, player_target )
	end
end )

net.Receive( "awarn_fetchownwarnings", function( l, ply )
	awarn_sendownwarnings( ply )
end )

net.Receive( "awarn_fetchofflineplayers", function( l, ply )
	if not awarn_checkadmin_view( ply ) then
		AWSendMessage( ply, "AWarn: " .. AWarn.localizations[loc].sv1)
		return
	end
    local fetchAll = net.ReadBool()
	awarn_sendofflineplayers( ply )
end )

net.Receive( "awarn_changeconvarbool", function( l, ply )
	local allowed = { "awarn_kick", "awarn_ban", "awarn_decay", "awarn_reasonrequired", "awarn_reset_warnings_after_ban", "awarn_logging" }
	local convar = net.ReadString()
	local val = net.ReadString()
	if not awarn_checkadmin_options( ply ) then
		AWSendMessage( ply, "AWarn: " .. AWarn.localizations[loc].sv1)
		return
	end
	if not table.HasValue( allowed, convar ) then
		AWSendMessage( ply, "AWarn: " .. AWarn.localizations[loc].sv2)
		return
	end
	if val == "true" then
		GetConVar( convar ):SetBool( false )
		return
	end
	GetConVar( convar ):SetBool( true )
end )

net.Receive( "awarn_changeconvar", function( l, ply )
	local allowed = { "awarn_kick_threshold", "awarn_ban_threshold", "awarn_ban_time", "awarn_decay_rate" }
	local convar = net.ReadString()
	local val = net.ReadInt(32)
	if not awarn_checkadmin_options( ply ) then
		AWSendMessage( ply, "AWarn: " .. AWarn.localizations[loc].sv1)
		return
	end
	if not table.HasValue( allowed, convar ) then
		AWSendMessage( ply, "AWarn: " .. AWarn.localizations[loc].sv2)
		return
	end
	if val < 0 then
		AWSendMessage( ply, "AWarn: " .. AWarn.localizations[loc].sv3)
		return
	end
	GetConVar( convar ):SetInt( val )
end )

function AWSendMessage( ply, message )
    if IsValid(ply) then
        ply:PrintMessage( HUD_PRINTTALK, message )
    else
        print( message )
    end
end

function AWarn_ChatWarn( ply, text, public )
    if (string.sub(string.lower(text), 1, 5) == "!warn") then
		local args = string.Explode( " ", text )
		if #args == 1 then
			ply:ConCommand( "awarn_menu" )
		else
			table.remove( args, 1 )
			awarn_con_warn( ply, _, args )
		end
		return false
    end
end
hook.Add( "PlayerSay", "AWarn_ChatWarn", AWarn_ChatWarn )

function awarn_con_warn( ply, _, args )
	if not ( #args >= 1 ) then return end
	local tar = awarn_getUser( args[1] )
	local reason = table.concat( args, " ", 2 )
	if (string.sub(string.lower(args[1]), 1, 5) == "steam") then
		if string.len(args[1]) == 7 then
			AWSendMessage( ply, "AWarn: " .. AWarn.localizations[loc].cl36)
			return
		end
		tid = AWarn_ConvertSteamID( args[1] )
		awarn_warnplayerid( ply, tid, reason )
		return
	end
	if not (IsValid(tar)) then return end
	awarn_warnplayer( ply, tar, reason )
end
concommand.Add( "awarn_warn", awarn_con_warn )


net.Receive( "awarn_warn", function( l, ply )
	awarn_warnplayer( ply, net.ReadEntity(), net.ReadString() )
end )

net.Receive( "awarn_warnid", function( l, ply )
	awarn_warnplayerid( ply, net.ReadString(), net.ReadString() )
end )


function awarn_warnplayer( ply, tar, reason )
	if not awarn_checkadmin_warn( ply ) then
		AWSendMessage( ply, "AWarn: " .. AWarn.localizations[loc].sv1)
		return
	end
	if table.HasValue( AWarn.Config.userBlacklist, tar:SteamID() ) then
		AWSendMessage( ply, "AWarn: " .. AWarn.localizations[loc].sv9)
		return
	end
	if table.HasValue( AWarn.Config.groupBlacklist, tar:GetUserGroup() ) then
		AWSendMessage( ply, "AWarn: " .. AWarn.localizations[loc].sv10)
		return
	end
	if awarn_checkadmin_warn( tar ) and not GetConVar("awarn_allow_warnadmin"):GetBool() then
		AWSendMessage( ply, "AWarn: " .. AWarn.localizations[loc].sv4)
		return
	end
	target_ply = tar
	if reason == nil then reason = "" end
	if not IsValid(target_ply) then return end
	if not target_ply:IsPlayer() then return end
	--if tobool(GetGlobalInt( "awarn_reasonrequired", 1 )) then
	if GetConVar("awarn_reasonrequired"):GetBool() then
		if not reason then
			AWSendMessage( ply, "AWarn: " .. AWarn.localizations[loc].sv5)
			return
		end
		if reason == "" then
			AWSendMessage( ply, "AWarn: " .. AWarn.localizations[loc].sv5)
			return
		end
	end
	if not reason then reason = "NONE GIVEN" end
	if reason == "" then reason = "NONE GIVEN" end
	if target_ply then
		for k, v in pairs(player.GetAll()) do
			if v ~= target_ply then
				net.Start("AWarnNotification")
					net.WriteEntity( ply )
					net.WriteEntity( target_ply )
					net.WriteString( reason )
				net.Send( v )
			end
		end
		if IsValid(ply) then
            awarn_addwarning( target_ply:SteamID64(), reason, ply:GetName() )
            ServerLog( "[AWarn] " .. ply:GetName() .. " warned " .. target_ply:GetName() .. " for reason: " .. reason.. "\n" )
			if GetConVar("awarn_logging"):GetBool() then
				awarn_log( ply:GetName() .. " warned " .. target_ply:GetName() .. " for reason: " .. reason )
			end
        else
            awarn_addwarning( target_ply:SteamID64(), reason, "[CONSOLE]" )
            ServerLog( "[AWarn] [CONSOLE] warned " .. target_ply:GetName() .. " for reason: " .. reason.. "\n" )
			if GetConVar("awarn_logging"):GetBool() then
				awarn_log( "[CONSOLE] warned " .. target_ply:GetName() .. " for reason: " .. reason )
			end
        end
		awarn_incwarnings( target_ply )
		local t1 = {}
        if IsValid( ply ) then
            t1 = { Color(60,60,60), "[", Color(30,90,150), "AWarn", Color(60,60,60), "] ", Color(255,255,255), AWarn.localizations[loc].sv6 .. " ", ply, ": ", Color(150,40,40), reason }
        else
            t1 = { Color(60,60,60), "[", Color(30,90,150), "AWarn", Color(60,60,60), "] ", Color(255,255,255), AWarn.localizations[loc].sv6 .. " ", Color(100,100,100), "[CONSOLE]", Color(255,255,255), ": ", Color(150,40,40), reason }
        end
		net.Start("AWarnChatMessage") net.WriteTable(t1) net.Send( target_ply )
		local t5 = { Color(60,60,60), "[", Color(30,90,150), "AWarn", Color(60,60,60), "] ", Color(255,255,255), AWarn.localizations[loc].sv7 }
		net.Start("AWarnChatMessage") net.WriteTable(t5) net.Send( target_ply )
		if IsValid( ply ) then
            awarn_sendwarnings( ply, target_ply )
        end
		local AWarnPlayerWarned = hook.Call( "AWarnPlayerWarned", GAMEMODE, target_ply, ply, reason )
	else
		AWSendMessage( ply, "AWarn: " .. AWarn.localizations[loc].cl37)
	end
end

function awarn_warnplayerid( ply, tarid, reason )
	if not awarn_checkadmin_warn( ply ) then
		AWSendMessage( ply, "AWarn: " .. AWarn.localizations[loc].sv1)
		return
	end
	if table.HasValue( AWarn.Config.userBlacklist, util.SteamIDFrom64( tarid ) ) then
		AWSendMessage( ply, "AWarn: " .. AWarn.localizations[loc].sv9)
		return
	end
	if GetConVar("awarn_reasonrequired"):GetBool() then
		if not reason then
			AWSendMessage( ply, "AWarn: " .. AWarn.localizations[loc].sv5)
			return
		end
		if reason == "" then
			AWSendMessage( ply, "AWarn: " .. AWarn.localizations[loc].sv5)
			return
		end
	end
	if not reason then reason = "NONE GIVEN" end
	if reason == "" then reason = "NONE GIVEN" end
	local tar_name = tarid
	local tar_ply = nil
	for k, v in pairs( player.GetAll() ) do
		if v:SteamID64() == tostring(tarid) then
			tar_name = v:GetName()
			tar_ply = v
			awarn_warnplayer( ply, tar_ply, reason )
			return
		end
	end
	if not tar_ply then tar_ply = game.GetWorld() end
	for k, v in pairs(player.GetAll()) do
		if v ~= tar_ply then
			net.Start("AWarnNotification")
				net.WriteEntity( ply )
				net.WriteEntity( tar_ply )
				net.WriteString( reason )
				net.WriteString( tostring(tarid) )
			net.Send( v )
		end
	end
	if IsValid(ply) then
		awarn_addwarning( tarid, reason, ply:GetName() )
		ServerLog( "[AWarn] " .. ply:GetName() .. " warned " .. tostring(tar_name) .. " for reason: " .. reason.. "\n" )
		if GetConVar("awarn_logging"):GetBool() then
			awarn_log( ply:GetName() .. " warned " .. tostring(tar_name) .. " for reason: " .. reason )
		end
	else
		awarn_addwarning( tarid, reason, "[CONSOLE]" )
		ServerLog( "[AWarn] [CONSOLE] warned " .. tostring(tar_name) .. " for reason: " .. reason.. "\n" )
		if GetConVar("awarn_logging"):GetBool() then
			awarn_log( "[CONSOLE] warned " .. tostring(tar_name) .. " for reason: " .. reason )
		end
	end
	awarn_incwarningsid( tarid )
		
	if IsValid( ply ) then
		awarn_sendwarnings_id( ply, util.SteamIDFrom64( tarid ) )
	end
	local AWarnPlayerIDWarned = hook.Call( "AWarnPlayerIDWarned", GAMEMODE, tarid, ply, reason )
end

-- This function is for removing warnings
-- 76561198166995699
-- ( ply, tar )
function awarn_remwarn( ply, tar )
	if not awarn_checkadmin_remove( ply ) then
		AWSendMessage( ply, "AWarn: " .. AWarn.localizations[loc].sv1)
		return
	end
	local target_ply = awarn_getUser( tar )
	if target_ply then
		awarn_decwarnings( target_ply, ply )
        if IsValid( ply ) then
            awarn_sendwarnings( ply, target_ply )
        end
	else
		AWSendMessage( ply, "AWarn: Player not found!")
	end
end

net.Receive( "awarn_removewarnid", function( l, ply )
	if not awarn_checkadmin_remove( ply ) then
		AWSendMessage( ply, "AWarn: " .. AWarn.localizations[loc].sv1)
		return
	end
	local uid = net.ReadString()
	awarn_decwarningsid( uid, ply )
end )

net.Receive( "awarn_removewarn", function( l, ply )
    if not IsValid( ply ) then return end
	local p_id = net.ReadString()
    if (string.sub(string.lower( p_id ), 1, 5) == "steam") then
		if string.len(args[1]) == 7 then
		AWSendMessage( ply, "AWarn: " .. AWarn.localizations[loc].cl36)
			return
		end
        id = AWarn_ConvertSteamID( p_id )
		awarn_decwarningsid( id, ply )
        return
    end
	awarn_remwarn( ply, p_id )
end )

net.Receive( "awarn_deletewarnings", function( l, ply )
	if not awarn_checkadmin_delete( ply ) then
		AWSendMessage( ply, "AWarn: " .. AWarn.localizations[loc].sv1)
		return
	end
	local target_ply = awarn_getUser( net.ReadString() )
	if target_ply then
		awarn_delwarnings( target_ply, ply )
	else
		AWSendMessage( ply, "AWarn: " .. AWarn.localizations[loc].cl37)
	end
end )

concommand.Add( "awarn_deletewarnings", function( ply, _, args )
	if IsValid(ply) then return end
	if #args ~= 1 then return end
	local target_ply = awarn_getUser( args[1] )
	if target_ply then
		awarn_delwarnings( target_ply, ply )
	else
		AWSendMessage( ply, "AWarn: " .. AWarn.localizations[loc].cl37)
	end
end )

net.Receive( "awarn_deletewarningsid", function( l, ply )
	if not awarn_checkadmin_delete( ply ) then
		AWSendMessage( ply, "AWarn: " .. AWarn.localizations[loc].sv1)
		return
	end
	local uid = net.ReadString()
	awarn_delwarningsid( uid, ply )
end )

concommand.Add( "awarn_deletewarningsid", function( ply, _, args )
	if IsValid(ply) then return end
	if #args ~= 1 then return end
	
	local uid = args[1]
	awarn_delwarningsid( uid, ply )
end )

net.Receive( "awarn_openmenu", function( l, ply )
    if not IsValid( ply ) then
		AWSendMessage( ply, "AWarn: " .. AWarn.localizations[loc].sv8)
        return
    end
	if not awarn_checkadmin_view( ply ) then
		net.Start("AWarnClientMenu")
		net.Send( ply )
		return
	end
	net.Start("AWarnMenu")
	net.Send( ply )
end )

net.Receive( "awarn_openoptions", function( l, ply )
    if not IsValid( ply ) then
		AWSendMessage( ply, "AWarn: " .. AWarn.localizations[loc].sv8)
        return
    end
	if not awarn_checkadmin_options( ply ) then
		AWSendMessage( ply, "AWarn: " .. AWarn.localizations[loc].sv1)
		return
	end
	net.Start("AWarnOptionsMenu")
	net.Send( ply )
end )

net.Receive( "awarn_deletesinglewarn", function( l, ply )
	if not awarn_checkadmin_delete( ply ) then
		AWSendMessage( ply, "AWarn: " .. AWarn.localizations[loc].sv1)
		return
	end
	local warningid = net.ReadInt(32)
	awarn_delsinglewarning( ply, warningid )
end )

hook.Add( "PlayerInitialSpawn", "AWarn2_InitialSpawn_AddToMenu", function( ply )
	timer.Simple( 1, function()
		if not IsValid( ply ) then return end
		net.Start("awarn_playerjoin")
		net.WriteEntity( ply )
		net.Broadcast()
	end )
end )

net.Receive( "awarn_openpunishconfigure", function( l, ply )
	net.Start("awarn_openpunishconfigure")
	net.WriteTable(AWarn.Config)
	net.Send( ply )
end )

net.Receive( "awarn_savepunishconfiguration", function( l, ply )
	if not awarn_checkadmin_options( ply ) then return end
	local punishmentTable = net.ReadTable()
	AWarn.Config.PunishmentSequence = punishmentTable
	AWarn2_SaveConfig()
end )



net.Receive( "awarn_openblacklistsconfigure", function( l, ply )
	net.Start("awarn_openblacklistsconfigure")
	net.WriteTable(AWarn.Config)
	net.Send( ply )
end )


net.Receive( "awarn_saveblacklistsconfiguration", function( l, ply )
	if not awarn_checkadmin_options( ply ) then return end
	AWarn.Config.groupBlacklist = net.ReadTable()
	AWarn.Config.userBlacklist = net.ReadTable()	
	AWarn2_SaveConfig()
end )


if !file.Exists( "awarn2/settings", "DATA" ) then
	file.CreateDir( "awarn2/settings" )
end

include( 'config/awarn2_settings.lua' )

function AWarn2_LoadSQLConfig()
	if !file.Exists( "awarn2/settings/mysql_settings.txt", "DATA" ) then
		file.Write( "awarn2/settings/mysql_settings.txt", util.TableToJSON( AWarn.MySQLConfig, true ) )
	else
		AWarn.MySQLConfig = util.JSONToTable( file.Read( "awarn2/settings/mysql_settings.txt", "DATA" ) )
	end
end
AWarn2_LoadSQLConfig()

function AWarn2_LoadConfig()
	if !file.Exists( "awarn2/settings/settings.txt", "DATA" ) then
		file.Write( "awarn2/settings/settings.txt", util.TableToJSON( AWarn.Config, true ) )
	else
		AWarn.Config = util.JSONToTable( file.Read( "awarn2/settings/settings.txt", "DATA" ) )
	end
end
AWarn2_LoadConfig()

function AWarn2_SaveConfig()
	if file.Exists( "awarn2/settings/settings.txt", "DATA" ) then
		file.Write( "awarn2/settings/settings.txt", util.TableToJSON( AWarn.Config, true ) )
	end
end

include( 'config/awarn2_sql.lua' )