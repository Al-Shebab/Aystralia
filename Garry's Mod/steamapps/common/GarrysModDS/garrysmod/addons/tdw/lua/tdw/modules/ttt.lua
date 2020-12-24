local MODULE = TDW.CreateModule()

/*---------------------------------------------------------------------------
	Basic module info
---------------------------------------------------------------------------*/
MODULE.Name = "TTT"
MODULE.Description = "Support for Trouble in Terrorist Town."

MODULE:AddHook("TTTPrepareRound", function()
	local embed = TDW.RichEmbed()
	embed:SetTitle("Round Preparing")
	embed:SetDescription("`"..game.GetMap().."`")
	embed:SetTimestamp()
	embed:SetColor("TTTPrepareRound")

	TDW.SendEmbed(embed)
end)

MODULE:AddHook("TTTBeginRound", function()
	local embed = TDW.RichEmbed()
	embed:SetTitle("Round Started")
	embed:SetTimestamp()
	embed:SetColor("TTTBeginRound")

	TDW.SendEmbed(embed)
end)

MODULE:AddHook("TTTEndRound", function(result)
	local embed = TDW.RichEmbed()
	embed:SetTitle("Round Ended")
	
	if(result == WIN_TRAITOR) then
		embed:AddField("Winner", "Traitors")
	elseif(result == WIN_INNOCENT) then
		embed:AddField("Winner", "Innocents")
	elseif(result == WIN_TIMELIMIT) then
		embed:AddField("Winner", "Innocents (Time Limit)")
	end

	embed:SetTimestamp()
	embed:SetColor("TTTEndRound")

	TDW.SendEmbed(embed)
end)

TDW.RegisterModule(MODULE)