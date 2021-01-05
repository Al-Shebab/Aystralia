function Slawer.Mayor:SetNews(strNews, intDuration)
	SetGlobalString("SMayor:News", strNews)

	if timer.Exists("SMAYOR:News") then
		timer.Remove("SMAYOR:NEWS")
	end

	timer.Create("SMAYOR:NEWS", intDuration, 1, function()
		SetGlobalString("SMayor:News", "")
	end)
end

local intNext = 0

Slawer.Mayor:NetReceive("UpdateNews", function(pPlayer, tbl)
	if not Slawer.Mayor:HasAccess(pPlayer) then
		DarkRP.notify(pPlayer, 1, 5, Slawer.Mayor:L("NoAccess"))
		return
	end

	if not tbl.message || not isstring(tbl.message) || string.len(tbl.message) > 150 || not tbl.duration || not tonumber(tbl.duration) || tbl.duration <= 0 || tbl.duration >= 2147483647 then
		DarkRP.notify(pPlayer, 1, 5, Slawer.Mayor:L("AnErrorHasOccured"))
		return
	end

	if intNext > CurTime() then
		DarkRP.notify(pPlayer, 1, 5, Slawer.Mayor:L("WaitUntilNextNews"):format(math.Round(intNext - CurTime())))
		return
	end

	intNext = CurTime() + 30

	Slawer.Mayor:SetNews(tbl.message, tbl.duration)

	DarkRP.notify(pPlayer, 0, 5, Slawer.Mayor:L("NewsSuccessfullyChanged"))
end)