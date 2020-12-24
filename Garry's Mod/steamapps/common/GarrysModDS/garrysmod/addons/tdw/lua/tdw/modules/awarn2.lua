local MODULE = TDW.CreateModule()

/*---------------------------------------------------------------------------
	Basic module info
---------------------------------------------------------------------------*/
MODULE.Name = "Awarn2"
MODULE.Description = "Support for Awarn2."


/*---------------------------------------------------------------------------
	Called when a player/steamid is warned
---------------------------------------------------------------------------*/
local function warned(ply, actor, reason)
	TDW.Steam:GetPlayerInfo(ply, function(info)
		local embed = TDW.RichEmbed()

		embed:SetAuthor("Player Warned", info.avatar, info.profileurl)
		embed:SetDescription(info.personaname.." has been warned by "..actor:DNick()..".")
		embed:SetThumbnail(info.avatarfull)
		embed:AddField("Reason", reason)
		embed:SetColor("AWarnPlayerWarned")
		embed:SetTimestamp()
		
		TDW.SendEmbed(embed)
	end)
end


/*---------------------------------------------------------------------------
	Hooks
---------------------------------------------------------------------------*/
MODULE:AddHook("AWarnPlayerWarned", warned)
MODULE:AddHook("AWarnPlayerIDWarned", warned)

MODULE:AddHook("AWarnLimitKick", function(ply)
	TDW.Steam:GetPlayerInfo(ply, function(info)
		local embed = TDW.RichEmbed()

		embed:SetAuthor("Player Autokicked", info.avatar, info.profileurl)
		embed:SetDescription(ply:DNick().." has been kicked for exceeding the warning limit.")
		embed:SetThumbnail(info.avatarfull)
		embed:SetColor("AWarnLimitKick")
		embed:SetTimestamp()
		
		TDW.SendEmbed(embed)
	end)
end)

MODULE:AddHook("AWarnLimitBan", function(ply)
	TDW.Steam:GetPlayerInfo(ply, function(info)
		local embed = TDW.RichEmbed()

		embed:SetAuthor("Player Autobanned", info.avatar, info.profileurl)
		embed:SetDescription(ply:DNick().." has been banned for exceeding the warning limit.")
		embed:SetThumbnail(info.avatarfull)
		embed:SetColor("AWarnLimitBan")
		embed:SetTimestamp()
		
		TDW.SendEmbed(embed)
	end)
end)

TDW.RegisterModule(MODULE)