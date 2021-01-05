Slawer.Mayor.Upgrades = Slawer.Mayor.Upgrades or {}

function Slawer.Mayor:GetFunds()
	return GetGlobalInt("Slawer.Mayor:Funds")
end

function Slawer.Mayor:GetMaxFunds()
	return GetGlobalInt("Slawer.Mayor:MaxFunds")
end

function Slawer.Mayor:GetUpgradeLevel(intID)
	return Slawer.Mayor.Upgrades[intID] or 0
end

function Slawer.Mayor:GetUpgradeTable(intID)
	return Slawer.Mayor.CFG.Upgrades[intID]
end

function Slawer.Mayor:GetUpgradeMaxLevel(intID)
	return #Slawer.Mayor.CFG.Upgrades[intID].Levels or 0
end

hook.Add("lockpickTime", "Slawer.Mayor:lockpickTime", function(p, e)
	if e:GetClass() == "slawer_mayor_safe" then
		return Slawer.Mayor.CFG.LockpickTime
	end
end)