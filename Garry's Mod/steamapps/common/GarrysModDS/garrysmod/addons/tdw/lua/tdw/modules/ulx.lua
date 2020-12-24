local MODULE = TDW.CreateModule()

/*---------------------------------------------------------------------------
	Basic module info
---------------------------------------------------------------------------*/
MODULE.Name = "ULX"
MODULE.Description = "Support for ULX Admin Mod."


/*---------------------------------------------------------------------------
	Helper functions
---------------------------------------------------------------------------*/
local function formatName(ply)
	return (IsValid(ply) && ply:IsPlayer()) && ply:Nick().." `("..ply:SteamID()..")`" || "Console"
end


/*---------------------------------------------------------------------------
	Fires when a player is kicked from the server
---------------------------------------------------------------------------*/
MODULE:AddHook("ULibPlayerKicked", function(steamId, reason, caller)
	if(reason:lower():find("banned")) then return end

	TDW.Steam:GetPlayerInfo(steamId, function(ply)
		if(!ply) then return end
		if(ply.Banned) then ply.Banned = nil return end

		local embed = TDW.RichEmbed()
		embed:SetAuthor("Player Kicked", ply.avatar, ply.profileurl)
		embed:SetDescription(ply.personaname.." has been kicked from the server.")
		embed:SetThumbnail(ply.avatarfull)

		embed:AddField("Kicker", formatName(caller))
		embed:AddField("Reason", reason || "Not Provided")

		embed:SetTimestamp()
		embed:SetColor("ULibPlayerKicked")

		TDW.SendEmbed(embed)
	end)
end)


/*---------------------------------------------------------------------------
	Fires when a player is banned from the server
---------------------------------------------------------------------------*/
MODULE:AddHook("ULibPlayerBanned", function(steamId, banData)
	TDW.Steam:GetPlayerInfo(steamId, function(ply)
		if(!ply) then return end
		ply.Banned = true

		local embed = TDW.RichEmbed()
		embed:SetAuthor("Player Banned", ply.avatar, ply.profileurl)
		embed:SetDescription(ply.personaname.." has been banned from the server.")
		embed:SetThumbnail(ply.avatarfull)

		embed:AddField("Banner", banData.admin)
		embed:AddField("Reason", banData.reason || "Not Provided")

		if(banData.unban == 0) then
			embed:AddField("Ban Duration", "Permanent")
		else
			local time = string.FormattedTime(banData.unban - banData.time)
			embed:AddField("Ban Duration", (time.h > 0 && time.h.."h " || "")..time.m.."m")
		end

		embed:SetTimestamp()
		embed:SetColor("ULibPlayerBanned")

		TDW.SendEmbed(embed)
	end)
end)


/*---------------------------------------------------------------------------
	Fires when a player is unbanned from the server
---------------------------------------------------------------------------*/
MODULE:AddHook("ULibPlayerUnBanned", function(steamId, caller)
	TDW.Steam:GetPlayerInfo(steamId, function(ply)
		if(!ply) then return end

		local embed = TDW.RichEmbed()
		embed:SetAuthor("Player Unbanned", ply.avatar, ply.profileurl)
		embed:SetDescription(ply.personaname.." has been unbanned from the server.")
		embed:SetThumbnail(ply.avatarfull)

		embed:AddField("Unbanner", formatName(caller))

		embed:SetTimestamp()
		embed:SetColor("ULibPlayerUnBanned")

		TDW.SendEmbed(embed)
	end)
end)

TDW.RegisterModule(MODULE)