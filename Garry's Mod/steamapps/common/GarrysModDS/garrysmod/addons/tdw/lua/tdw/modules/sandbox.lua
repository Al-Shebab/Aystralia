local MODULE = TDW.CreateModule()

MODULE.Name = "Sandbox"
MODULE.Description = "Support for sandbox and derivatives."


/*---------------------------------------------------------------------------
	Props
---------------------------------------------------------------------------*/
MODULE:AddHook("PlayerSpawnedProp", function(ply, model)
	TDW.Steam:GetPlayerInfo(ply, function(info)
		local embed = TDW.RichEmbed()

		embed:SetAuthor("Prop Spawned", info.avatar, info.profileurl)
		embed:SetDescription(ply:DNick().." has spawned `"..model.."`.")

		embed:SetThumbnail(info.avatarfull)
		embed:SetColor("PlayerSpawnedProp")
		embed:SetTimestamp()

		TDW.SendEmbed(embed)
	end)
end)


/*---------------------------------------------------------------------------
	SENTs
---------------------------------------------------------------------------*/
MODULE:AddHook("PlayerSpawnedSENT", function(ply, ent)
	TDW.Steam:GetPlayerInfo(ply, function(info)
		local embed = TDW.RichEmbed()

		embed:SetAuthor("SENT Spawned", info.avatar, info.profileurl)
		embed:SetDescription(ply:DNick().." has spawned a `"..ent:GetClass().."`.")
		
		embed:SetThumbnail(info.avatarfull)
		embed:SetColor("PlayerSpawnedSENT")
		embed:SetTimestamp()

		TDW.SendEmbed(embed)
	end)
end)

TDW.RegisterModule(MODULE)