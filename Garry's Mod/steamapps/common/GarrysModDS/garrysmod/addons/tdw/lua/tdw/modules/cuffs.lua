local MODULE = TDW.CreateModule()

MODULE.Name = "Cuffs"
MODULE.Description = "Support for Cuffs - Handcuffs and Restraints."

MODULE:AddHook("OnHandcuffed", function(actor, ply)
	TDW.Steam:GetPlayerInfo(ply, function(info)
		local embed = TDW.RichEmbed()

		embed:SetAuthor("Player Handcuffed", info.avatar, info.profileurl)
		embed:SetDescription(ply:DNick().." has been handcuffed by "..actor:Nick()..".")

		embed:SetThumbnail(info.avatarfull)
		embed:SetColor("OnHandcuffed")
		embed:SetTimestamp()

		TDW.SendEmbed(embed)
	end)
end)

MODULE:AddHook("OnHandcuffBreak", function(ply, cuffs, friend)
	TDW.Steam:GetPlayerInfo(ply, function(info)
		local embed = TDW.RichEmbed()

		if(IsValid(friend) && friend:IsPlayer()) then
			embed:SetAuthor("Player Unhandcuffed", info.avatar, info.profileurl)
			embed:SetDescription(ply:DNick().." has been unhandcuffed by "..friend:Nick()..".")
		else
			embed:SetAuthor("Player Broke Handcuffs", info.avatar, info.profileurl)
			embed:SetDescription(ply:DNick().." has broken out of their handcuffs.")
		end

		embed:SetThumbnail(info.avatarfull)
		embed:SetColor("OnHandcuffBreak")
		embed:SetTimestamp()

		TDW.SendEmbed(embed)
	end)
end)

TDW.RegisterModule(MODULE)