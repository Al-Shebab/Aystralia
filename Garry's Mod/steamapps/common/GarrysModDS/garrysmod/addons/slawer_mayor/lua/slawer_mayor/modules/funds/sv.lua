--
-- Money
--

function Slawer.Mayor:SetFunds(int)
	SetGlobalInt("Slawer.Mayor:Funds", math.Clamp(int, 0, Slawer.Mayor:GetMaxFunds()))
	Slawer.Mayor:UpdateSafesBodygroup()
end

function Slawer.Mayor:SetMaxFunds(int)
	SetGlobalInt("Slawer.Mayor:MaxFunds", int)
	Slawer.Mayor:UpdateSafesBodygroup()
end

function Slawer.Mayor:AddFunds(int)
	SetGlobalInt("Slawer.Mayor:Funds", math.Clamp(GetGlobalInt("Slawer.Mayor:Funds") + int, 0, Slawer.Mayor:GetMaxFunds()))
	Slawer.Mayor:UpdateSafesBodygroup()
end

--
-- Upgrades
--

function Slawer.Mayor:SyncUpgrades(pPlayer)
	if pPlayer then
		Slawer.Mayor:NetStart("SyncUpgrades", Slawer.Mayor.Upgrades, pPlayer)
	else
		Slawer.Mayor:NetStart("SyncUpgrades", Slawer.Mayor.Upgrades)
	end
end

function Slawer.Mayor:UpUpgrade(intID, intUp)
	local tblUpgrade = Slawer.Mayor:GetUpgradeTable(intID)

	Slawer.Mayor.Upgrades[intID] = (intUp != nil) && intUp || (Slawer.Mayor.Upgrades[intID] or 0) + 1

	if tblUpgrade.OnUpgrade then
		tblUpgrade.OnUpgrade(intID, Slawer.Mayor.Upgrades[intID])
	end

	Slawer.Mayor:SyncUpgrades()
end

hook.Add("PlayerSpawn", "Slawer.Mayor:Upgrades:PlayerSpawn", function(pPlayer)
	Slawer.Mayor:SyncUpgrades(pPlayer)
end)

hook.Add("PlayerLoadout", "Slawer.Mayor:Upgrades:PlayerLoadout", function(pPlayer)
	for intID, tbl in pairs(Slawer.Mayor.CFG.Upgrades) do
		if tbl.Condition && not tbl.Condition(pPlayer) then continue end

		local intLevel = Slawer.Mayor:GetUpgradeLevel(intID)

		if tbl.Levels[intLevel].Weapons then
			for _, strWep in pairs(tbl.Levels[intLevel].Weapons) do
				pPlayer:Give(strWep)
			end
		end

		if tbl.Levels[intLevel].DefaultArmor then
			pPlayer:SetArmor(tbl.Levels[intLevel].DefaultArmor)
		end

		if tbl.Levels[intLevel].DefaultHealth then
			pPlayer:SetHealth(tbl.Levels[intLevel].DefaultHealth)
		end
	end
end)

hook.Add("canDropWeapon", "Slawer.Mayor:UPgrades:canDropWeapon", function(pPlayer, wep)
	for intID, tbl in pairs(Slawer.Mayor.CFG.Upgrades) do
		if tbl.Condition && not tbl.Condition(pPlayer) then continue end
		
		local intLevel = Slawer.Mayor:GetUpgradeLevel(intID)

		if tbl.Levels[intLevel].Weapons then
			if table.HasValue(tbl.Levels[intLevel].Weapons, wep:GetClass()) then
				return false
			end
		end
	end
end)

hook.Add("Initialize", "Slawer.Mayor:Funds:Initialize", function()
	Slawer.Mayor:SetMaxFunds(Slawer.Mayor.CFG.DefaultMaxFunds)
	Slawer.Mayor:SetFunds(Slawer.Mayor.CFG.DefaultFunds)
end)

Slawer.Mayor:NetReceive("Upgrade", function(pPlayer, tbl)
	if not Slawer.Mayor:HasAccess(pPlayer) then
		DarkRP.notify(pPlayer, 1, 5, Slawer.Mayor:L("NoAccess"))
		return
	end

	if not tbl.id || not tonumber(tbl.id) || not Slawer.Mayor.CFG.Upgrades[tbl.id] then
		DarkRP.notify(pPlayer, 1, 5, Slawer.Mayor:L("AnErrorHasOccured"))
		return
	end

	if Slawer.Mayor:GetUpgradeLevel(tbl.id) >= Slawer.Mayor:GetUpgradeMaxLevel(tbl.id) then
		DarkRP.notify(pPlayer, 1, 5, Slawer.Mayor:L("UpgradesAlreadyMax"))
		return
	end
	
	local intNew = Slawer.Mayor:GetUpgradeLevel(tbl.id) + 1
	local tblUpgrade = Slawer.Mayor.CFG.Upgrades[tbl.id].Levels[intNew]

	if Slawer.Mayor:GetFunds() < tblUpgrade.Price then
		DarkRP.notify(pPlayer, 1, 5, Slawer.Mayor:L("NotEnoughFunds"))
		return
	end

	Slawer.Mayor:AddFunds(-tblUpgrade.Price)
	Slawer.Mayor:UpUpgrade(tbl.id)
	
	DarkRP.notify(pPlayer, 0, 5, Slawer.Mayor:L("UpgradeSuccessfullyBought"))
end)