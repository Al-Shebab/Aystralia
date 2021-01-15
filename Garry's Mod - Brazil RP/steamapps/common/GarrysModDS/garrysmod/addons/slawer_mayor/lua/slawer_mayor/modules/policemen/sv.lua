local lastMoneyGift = 0
local lastKick = 0

function Slawer.Mayor:SyncPolicemen(pPlayer)
	if pPlayer then
		Slawer.Mayor:NetStart("SyncPolicemen", {}, pPlayer)
	else
		Slawer.Mayor:NetStart("SyncPolicemen", {})
	end
end

Slawer.Mayor:NetReceive("MoneyGift", function(pPlayer, tbl)
	if not Slawer.Mayor:HasAccess(pPlayer) then
		DarkRP.notify(pPlayer, 1, 5, Slawer.Mayor:L("NoAccess"))
		return
	end

	if lastMoneyGift > CurTime() then
		DarkRP.notify(pPlayer, 1, 5, Slawer.Mayor:L("WaitUntilNextBonus"):format(math.Round(lastMoneyGift - CurTime())))
		return
	end

	if not tbl.receiver || not IsValid(tbl.receiver) || not tbl.receiver:IsPlayer() || not tbl.receiver:isCP() then
		DarkRP.notify(pPlayer, 1, 5, Slawer.Mayor:L("AnErrorHasOccured"))
		return
	end

	if not tbl.amount || not isnumber(tbl.amount) then
		DarkRP.notify(pPlayer, 1, 5, Slawer.Mayor:L("AnErrorHasOccured"))
		return
	end

	local intAmount = tonumber(tbl.amount)

	if intAmount < Slawer.Mayor.CFG.MinMaxBonus[1] || intAmount > tonumber(Slawer.Mayor.CFG.MinMaxBonus[2]) then
		DarkRP.notify(pPlayer, 1, 5, Slawer.Mayor:L("NotAllowedBonus"):format(DarkRP.formatMoney(Slawer.Mayor.CFG.MinMaxBonus[1]), DarkRP.formatMoney(Slawer.Mayor.CFG.MinMaxBonus[2])))
		return
	end

	intAmount = math.Clamp(intAmount, Slawer.Mayor.CFG.MinMaxBonus[1], Slawer.Mayor.CFG.MinMaxBonus[2])

	if Slawer.Mayor:GetFunds() < tonumber(tbl.amount) then
		DarkRP.notify(pPlayer, 1, 5, Slawer.Mayor:L("NotEnoughFunds"))
		return
	end

	Slawer.Mayor:AddFunds(-intAmount)
	tbl.receiver:addMoney(intAmount)

	lastMoneyGift = CurTime() + Slawer.Mayor.CFG.BonusDelay
	
	DarkRP.notify(pPlayer, 0, 5, Slawer.Mayor:L("BonusSuccessfullyGiven"))
end)

Slawer.Mayor:NetReceive("KickCP", function(pPlayer, tbl)
	if not Slawer.Mayor:HasAccess(pPlayer) then
		DarkRP.notify(pPlayer, 1, 5, Slawer.Mayor:L("NoAccess"))
		return
	end

	if lastKick > CurTime() then
		DarkRP.notify(pPlayer, 1, 5, Slawer.Mayor:L("WaitUntilNextKick"):format(math.Round(lastKick - CurTime())))
		return
	end

	if not tbl.cp || not IsValid(tbl.cp) || not tbl.cp:IsPlayer() || not tbl.cp:isCP() || tbl.cp:isMayor() || not Slawer.Mayor.CFG.MayorCanKickCP then
		DarkRP.notify(pPlayer, 1, 5, Slawer.Mayor:L("AnErrorHasOccured"))
		return
	end

	tbl.cp:changeTeam((GAMEMODE or GM).DefaultTeam, true, true)

	Slawer.Mayor:SyncPolicemen()

	lastKick = CurTime() + Slawer.Mayor.CFG.KickDelay
	
	DarkRP.notify(tbl.cp, 0, 5, Slawer.Mayor:L("YouveBeenFired"))
	DarkRP.notify(pPlayer, 0, 5, Slawer.Mayor:L("CPSuccessfullyFired"))
end)