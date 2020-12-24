local MODULE = TDW.CreateModule()

MODULE.Name = "DarkRP"
MODULE.Description = "Support for DarkRP hooks."


/*---------------------------------------------------------------------------
	Laws
---------------------------------------------------------------------------*/
MODULE:AddHook("addLaw", function(index, law)
	local embed = TDW.RichEmbed()
	embed:SetTitle("Law Added")
	embed:SetDescription(index..". "..law)
	embed:SetColor("addLaw")
	embed:SetTimestamp()

	TDW.SendEmbed(embed)
end)

MODULE:AddHook("removeLaw", function(index, law)
	local embed = TDW.RichEmbed()
	embed:SetTitle("Law Removed")
	embed:SetDescription(index..". "..law)
	embed:SetColor("removeLaw")
	embed:SetTimestamp()

	TDW.SendEmbed(embed)
end)

MODULE:AddHook("resetLaws", function(ply)
	TDW.Steam:GetPlayerInfo(ply, function(info)
		local embed = TDW.RichEmbed()

		embed:SetAuthor("Laws Reset", info.avatar, info.profileurl)
		embed:SetDescription("The laws have been reset by "..ply:DNick()..".")
		embed:SetThumbnail(info.avatarfull)
		embed:SetColor("resetLaws")
		embed:SetTimestamp()

		TDW.SendEmbed(embed)
	end)
end)


/*---------------------------------------------------------------------------
	Arresting
---------------------------------------------------------------------------*/
MODULE:AddHook("playerArrested", function(ply, time, actor)
	TDW.Steam:GetPlayerInfo(ply, function(info)
		local embed = TDW.RichEmbed()

		embed:SetAuthor("Player Arrested", info.avatar, info.profileurl)

		if(IsValid(actor) && actor:IsPlayer()) then
			embed:SetDescription(ply:DNick().." has been arrested by "..actor:DNick()..".")
		else
			embed:SetDescription(ply:DNick().." has been arrested.")
		end

		embed:SetThumbnail(info.avatarfull)

		embed:AddField("Time", time)

		embed:SetColor("playerArrested")
		embed:SetTimestamp()

		TDW.SendEmbed(embed)
	end)
end)

MODULE:AddHook("playerUnArrested", function(ply, actor)
	TDW.Steam:GetPlayerInfo(ply, function(info)
		local embed = TDW.RichEmbed()

		embed:SetAuthor("Player Unarrested", info.avatar, info.profileurl)
		
		if(IsValid(actor) && actor:IsPlayer()) then
			embed:SetDescription(ply:DNick().." has been unarrested by "..actor:DNick()..".")
		else
			embed:SetDescription(ply:DNick().." has been let out of jail.")
		end

		embed:SetThumbnail(info.avatarfull)

		embed:SetColor("playerUnArrested")
		embed:SetTimestamp()

		TDW.SendEmbed(embed)
	end)
end)


/*---------------------------------------------------------------------------
	Warranting
---------------------------------------------------------------------------*/
MODULE:AddHook("playerWarranted", function(ply, actor, reason)
	TDW.Steam:GetPlayerInfo(ply, function(info)
		local embed = TDW.RichEmbed()

		embed:SetAuthor("Player Warranted", info.avatar, info.profileurl)

		if(IsValid(actor) && actor:IsPlayer()) then
			embed:SetDescription(actor:DNick().." has issued "..ply:DNick().." a search warrant.")
		else
			embed:SetDescription(ply:DNick().." has been issued a search warrant.")
		end

		embed:SetThumbnail(info.avatarfull)

		embed:AddField("Reason", reason)

		embed:SetColor("playerWarranted")
		embed:SetTimestamp()

		TDW.SendEmbed(embed)
	end)
end)

MODULE:AddHook("playerUnWarranted", function(ply, actor)
	TDW.Steam:GetPlayerInfo(ply, function(info)
		local embed = TDW.RichEmbed()

		embed:SetAuthor("Player Unwarranted", info.avatar, info.profileurl)
		
		if(IsValid(actor) && actor:IsPlayer()) then
			embed:SetDescription(ply:DNick().."'s warrant has been terminated by "..actor:DNick()..".")
		else
			embed:SetDescription(ply:DNick().."'s warrant has expired.")
		end

		embed:SetThumbnail(info.avatarfull)

		embed:SetColor("playerUnWarranted")
		embed:SetTimestamp()

		TDW.SendEmbed(embed)
	end)
end)


/*---------------------------------------------------------------------------
	Wanting
---------------------------------------------------------------------------*/
MODULE:AddHook("playerWanted", function(ply, actor, reason)
	TDW.Steam:GetPlayerInfo(ply, function(info)
		local embed = TDW.RichEmbed()

		embed:SetAuthor("Player Wanted", info.avatar, info.profileurl)
		embed:SetDescription(ply:DNick().." has been made wanted by "..actor:DNick()..".")

		embed:SetThumbnail(info.avatarfull)

		embed:AddField("Reason", reason)

		embed:SetColor("playerWanted")
		embed:SetTimestamp()

		TDW.SendEmbed(embed)
	end)
end)

MODULE:AddHook("playerUnWanted", function(ply, actor)
	TDW.Steam:GetPlayerInfo(ply, function(info)
		local embed = TDW.RichEmbed()

		embed:SetAuthor("Player Unwanted", info.avatar, info.profileurl)
		
		if(IsValid(actor) && actor:IsPlayer()) then
			embed:SetDescription(ply:DNick().." has been made unwanted by "..actor:DNick()..".")
		else
			embed:SetDescription(ply:DNick().."'s wanted status has expired.")
		end

		embed:SetThumbnail(info.avatarfull)

		embed:SetColor("playerUnWanted")
		embed:SetTimestamp()

		TDW.SendEmbed(embed)
	end)
end)


/*---------------------------------------------------------------------------
	Demoting
---------------------------------------------------------------------------*/
MODULE:AddHook("onPlayerDemoted", function(actor, target, reason)
	TDW.Steam:GetPlayerInfo(actor, function(info)
		local embed = TDW.RichEmbed()

		embed:SetAuthor("Player Demoted", info.avatar, info.profileurl)
		
		if(IsValid(actor) && actor:IsPlayer()) then
			embed:SetDescription(target:DNick().." has been demoted by "..actor:DNick()..".")
		else
			embed:SetDescription(target:DNick().."has been demoted.")
		end

		embed:AddField("Reason", reason)

		embed:SetThumbnail(info.avatarfull)

		embed:SetColor("onPlayerDemoted")
		embed:SetTimestamp()

		TDW.SendEmbed(embed)
	end)
end)


/*---------------------------------------------------------------------------
	Name change
---------------------------------------------------------------------------*/
MODULE:AddHook("onPlayerChangedName", function(ply, oldName, newName)
	TDW.Steam:GetPlayerInfo(ply, function(info)
		local embed = TDW.RichEmbed()

		embed:SetAuthor("Name Change", info.avatar, info.profileurl)
		
		embed:SetDescription(ply:DNick().." has changed their roleplay name.")

		embed:AddField("Old Name", oldName, true)
		embed:AddField("New Name", newName, true)

		embed:SetThumbnail(info.avatarfull)

		embed:SetColor("onPlayerChangedName")
		embed:SetTimestamp()

		TDW.SendEmbed(embed)
	end)
end)


/*---------------------------------------------------------------------------
	Hits
---------------------------------------------------------------------------*/
MODULE:AddHook("onHitCompleted", function(ply, target, customer)
	TDW.Steam:GetPlayerInfo(ply, function(info)
		local embed = TDW.RichEmbed()

		embed:SetAuthor("Hit Completed", info.avatar, info.profileurl)
		embed:SetDescription(ply:DNick().." has completed a hit on "..target:DNick()..".")
		embed:AddField("Customer", customer:DNick())
		embed:SetThumbnail(info.avatarfull)

		embed:SetColor("onHitCompleted")
		embed:SetTimestamp()

		TDW.SendEmbed(embed)
	end)
end)

MODULE:AddHook("onHitFailed", function(ply, target, reason)
	TDW.Steam:GetPlayerInfo(ply, function(info)
		local embed = TDW.RichEmbed()

		embed:SetAuthor("Hit Failed", info.avatar, info.profileurl)
		embed:SetDescription(ply:DNick().." has failed a hit on "..target:DNick()..".")
		embed:AddField("Reason", reason)
		embed:SetThumbnail(info.avatarfull)

		embed:SetColor("onHitFailed")
		embed:SetTimestamp()

		TDW.SendEmbed(embed)
	end)
end)


/*---------------------------------------------------------------------------
	Purchases
---------------------------------------------------------------------------*/
MODULE:AddHook("playerBoughtCustomEntity", function(ply, tbl, ent, price)
	TDW.Steam:GetPlayerInfo(ply, function(info)
		local embed = TDW.RichEmbed()

		embed:SetAuthor("Entity Purchased", info.avatar, info.profileurl)
		embed:SetDescription(ply:DNick().." has purchased a `"..tbl.name.."`.")
		embed:AddField("Price", DarkRP.formatMoney(price))
		embed:SetThumbnail(info.avatarfull)

		embed:SetColor("playerBoughtCustomEntity")
		embed:SetTimestamp()

		TDW.SendEmbed(embed)
	end)
end)

MODULE:AddHook("playerBoughtAmmo", function(ply, tbl, ent, price)
	TDW.Steam:GetPlayerInfo(ply, function(info)
		local embed = TDW.RichEmbed()

		embed:SetAuthor("Ammo Purchased", info.avatar, info.profileurl)
		embed:SetDescription(ply:DNick().." has purchased `"..tbl.name.."`.")
		embed:AddField("Price", DarkRP.formatMoney(price), true)
		embed:AddField("Amount", tbl.amountGiven, true)
		embed:SetThumbnail(info.avatarfull)

		embed:SetColor("playerBoughtAmmo")
		embed:SetTimestamp()

		TDW.SendEmbed(embed)
	end)
end)

MODULE:AddHook("playerBoughtPistol", function(ply, tbl, ent, price)
	TDW.Steam:GetPlayerInfo(ply, function(info)
		local embed = TDW.RichEmbed()

		embed:SetAuthor("Weapon Purchased", info.avatar, info.profileurl)
		embed:SetDescription(ply:DNick().." has purchased a `"..tbl.name.."`.")
		embed:AddField("Price", DarkRP.formatMoney(price))
		embed:SetThumbnail(info.avatarfull)

		embed:SetColor("playerBoughtPistol")
		embed:SetTimestamp()

		TDW.SendEmbed(embed)
	end)
end)

MODULE:AddHook("playerBoughtShipment", function(ply, tbl, ent, price)
	TDW.Steam:GetPlayerInfo(ply, function(info)
		local embed = TDW.RichEmbed()

		embed:SetAuthor("Shipment Purchased", info.avatar, info.profileurl)
		embed:SetDescription(ply:DNick().." has purchased `"..tbl.name.."`.")
		embed:AddField("Price", DarkRP.formatMoney(price), true)
		embed:AddField("Amount", tbl.amount, true)
		embed:SetThumbnail(info.avatarfull)

		embed:SetColor("playerBoughtShipment")
		embed:SetTimestamp()

		TDW.SendEmbed(embed)
	end)
end)

TDW.RegisterModule(MODULE)