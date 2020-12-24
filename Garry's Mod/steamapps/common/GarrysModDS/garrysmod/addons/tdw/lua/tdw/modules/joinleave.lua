local MODULE = TDW.CreateModule()

MODULE.Name = "Join and Leave"
MODULE.Description = "Support for join and leave notifications."


/*---------------------------------------------------------------------------
	Listening for additional hooks
---------------------------------------------------------------------------*/
gameevent.Listen("player_connect")
gameevent.Listen("player_disconnect")


/*---------------------------------------------------------------------------
	Player joining
---------------------------------------------------------------------------*/
MODULE:AddHook("player_connect", function(data)
	if(data.bot == 1) then return end
	TDW.Steam:GetPlayerInfo(data.networkid, function(info)
		local embed = TDW.RichEmbed()

		embed:SetAuthor("Player Connected", info.avatar, info.profileurl)
		embed:SetDescription(info.personaname.." has connected to the server.")
		embed:SetColor("player_connect")
		embed:SetThumbnail(info.avatarfull)
		embed:SetTimestamp()

		TDW.SendEmbed(embed)
	end)
end)


/*---------------------------------------------------------------------------
	Player leaving
---------------------------------------------------------------------------*/
MODULE:AddHook("player_disconnect", function(data)
	if(data.bot == 1) then return end
	TDW.Steam:GetPlayerInfo(data.networkid, function(info)
		local embed = TDW.RichEmbed()

		embed:SetAuthor("Player Disconnected", info.avatar, info.profileurl)
		embed:SetDescription(info.personaname.." has disconnected from the server.")
		embed:SetColor("player_disconnect")
		embed:SetThumbnail(info.avatarfull)
		embed:SetTimestamp()

		TDW.SendEmbed(embed)
	end)
end)

TDW.RegisterModule(MODULE)