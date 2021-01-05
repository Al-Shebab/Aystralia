-- fastdl
resource.AddWorkshop("2002491440")

resource.AddFile(Slawer.Mayor.CFG.IconDir)

if not Slawer.Mayor.CFG.DisabledModules["funds"] then
	function Slawer.Mayor:GetMoneyBG()
		if Slawer.Mayor:GetFunds() == 0 then
			return 0
		end

		return math.Round(Slawer.Mayor:GetFunds() / Slawer.Mayor:GetMaxFunds() * 2) + 1
	end

	function Slawer.Mayor:UpdateSafesBodygroup()
		for k, v in pairs(Slawer.Mayor.SafeList) do
			if not IsValid(k) then continue end
			k:UpdateMoneyLevel()
		end
	end

	Slawer.Mayor:NetReceive("CloseSafe", function(pPlayer, tbl)
		if not tbl.ent || not IsValid(tbl.ent) || tbl.ent:GetClass() != "slawer_mayor_safe" || tbl.ent:GetPos():DistToSqr(pPlayer:GetPos()) > 90000 then
			DarkRP.notify(pPlayer, 1, 5, Slawer.Mayor:L("AnErrorHasOccured"))
			return
		end

		if not tbl.ent.IsOpen then
			DarkRP.notify(pPlayer, 1, 5, Slawer.Mayor:L("SafeMustBeOpen"))
			return
		end
		
		tbl.ent:OnToggle(false)
	end)

	local intNext = 0

	Slawer.Mayor:NetReceive("WithdrawSafe", function(pPlayer, tbl)
		if not tbl.ent || not IsValid(tbl.ent) || tbl.ent:GetClass() != "slawer_mayor_safe" || tbl.ent:GetPos():DistToSqr(pPlayer:GetPos()) > 90000 || not tbl.amount || not isnumber(tbl.amount) || tbl.amount <= 0 || tbl.amount >= 2147483647 || tbl.amount != math.Round(tbl.amount) then
			DarkRP.notify(pPlayer, 1, 5, Slawer.Mayor:L("AnErrorHasOccured"))
			return
		end

		if intNext > CurTime() then
			DarkRP.notify(pPlayer, 1, 5, Slawer.Mayor:L("WaitUntilNextWithdraw"):format(math.Round(intNext - CurTime())))
			return
		end
		
		if not tbl.ent.IsOpen then
			DarkRP.notify(pPlayer, 1, 5, Slawer.Mayor:L("SafeMustBeOpen"))
			return
		end
		

		if tbl.deposit then
			if not pPlayer:canAfford(tbl.amount) then
				DarkRP.notify(pPlayer, 1, 5, Slawer.Mayor:L("NotEnoughFunds"))
				return
			end

			if Slawer.Mayor:GetMaxFunds() < tbl.amount + Slawer.Mayor:GetFunds() then
				DarkRP.notify(pPlayer, 1, 5, Slawer.Mayor:L("CantDepositThatMuch"))
				return
			end

			Slawer.Mayor:AddFunds(math.Clamp(tbl.amount, 0, 2147483646))
			pPlayer:addMoney(-math.Clamp(tbl.amount, 0, 2147483646))

			DarkRP.notify(pPlayer, 0, 5, Slawer.Mayor:L("SuccessfullyDeposited"))
		else
			if (not Slawer.Mayor.CFG.CanMayorWithdrawFromSafe && pPlayer:isMayor()) then
				DarkRP.notify(pPlayer, 1, 5, Slawer.Mayor:L("NoAccess"))
				return
			end

			if Slawer.Mayor:GetFunds() < tbl.amount then
				DarkRP.notify(pPlayer, 1, 5, Slawer.Mayor:L("NotEnoughFunds"))
				return
			end

			Slawer.Mayor:AddFunds(-math.Clamp(tbl.amount, 0, 2147483646))
			pPlayer:addMoney(math.Clamp(tbl.amount, 0, 2147483646))

			DarkRP.notify(pPlayer, 0, 5, Slawer.Mayor:L("SuccessfullyWithdrew"))
		end

		intNext = CurTime() + 3
	end)
end