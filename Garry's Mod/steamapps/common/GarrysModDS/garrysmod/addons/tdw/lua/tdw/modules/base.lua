local MODULE = TDW.CreateModule()

MODULE.Name = "Base"
MODULE.Description = "Support for base gamemode hooks."


/*---------------------------------------------------------------------------
	Players dying
---------------------------------------------------------------------------*/
MODULE:AddHook("PlayerDeath", function(victim, inflictor, attacker)
	TDW.Steam:GetPlayerInfo(victim, function(info)
		local embed = TDW.RichEmbed()

		if(victim == attacker) then
			embed:SetAuthor("Suicide", info.avatar, info.profileurl)
			embed:SetDescription(victim:DNick().." has killed themselves.")
		elseif(IsValid(attacker) && attacker:IsPlayer()) then
			embed:SetAuthor("Player Killed", info.avatar, info.profileurl)
			embed:SetDescription(victim:DNick().." has been killed by "..attacker:DNick()..".")
		else
			embed:SetAuthor("Player Killed", info.avatar, info.profileurl)
			embed:SetDescription(victim:DNick().." has died.")
		end

		embed:SetThumbnail(info.avatarfull)
		embed:SetColor("PlayerDeath")
		embed:SetTimestamp()

		TDW.SendEmbed(embed)
	end)
end)

TDW.RegisterModule(MODULE)