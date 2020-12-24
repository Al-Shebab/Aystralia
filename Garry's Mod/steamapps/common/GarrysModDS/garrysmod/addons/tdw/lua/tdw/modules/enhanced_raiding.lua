local MODULE = TDW.CreateModule()

MODULE.Name = "Enhanced Raiding"
MODULE.Description = "Support for Enhanced Raiding."

MODULE:AddHook("onPlayerStartedRaid", function(raider, target)
	TDW.Steam:GetPlayerInfo(raider, function(info)
		local embed = TDW.RichEmbed()

		embed:SetAuthor("Raid Started", info.avatar, info.profileurl)
		embed:SetDescription(raider:DNick().." has started raiding "..target:Nick()..".")

		embed:SetThumbnail(info.avatarfull)
		embed:SetColor("onPlayerStartedRaid")
		embed:SetTimestamp()

		TDW.SendEmbed(embed)
	end)
end)

MODULE:AddHook("onRaidStopped", function(ply)
	TDW.Steam:GetPlayerInfo(ply, function(info)
		local embed = TDW.RichEmbed()

		embed:SetAuthor("Raid Stopped", info.avatar, info.profileurl)
		embed:SetDescription(ply:DNick().."'s raid has stopped.")

		embed:SetThumbnail(info.avatarfull)
		embed:SetColor("onRaidStopped")
		embed:SetTimestamp()

		TDW.SendEmbed(embed)
	end)
end)

TDW.RegisterModule(MODULE)