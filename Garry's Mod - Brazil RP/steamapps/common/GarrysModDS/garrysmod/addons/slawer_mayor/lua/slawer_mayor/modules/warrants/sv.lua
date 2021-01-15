function Slawer.Mayor:SyncWarrants(pPlayer)
	if pPlayer then
		Slawer.Mayor:NetStart("SyncWarrants", Slawer.Mayor.WarrantsList, pPlayer)
	else
		Slawer.Mayor:NetStart("SyncWarrants", Slawer.Mayor.WarrantsList)
	end
end

hook.Add("playerWarranted", "Slawer.Mayor:playerWarranted", function(pWarranted)
	Slawer.Mayor.WarrantsList[pWarranted] = {
		endDate = CurTime() + (GM or GAMEMODE).Config.searchtime or -1
	}
	Slawer.Mayor:SyncWarrants()
end)

hook.Add("playerUnWarranted", "Slawer.Mayor:playerUnWarranted", function(pUnWarranted)
	Slawer.Mayor.WarrantsList[pUnWarranted] = nil
	Slawer.Mayor:SyncWarrants()
end)

hook.Add("PlayerSpawn", "Slawer.Mayor:Warrants:PlayerSpawn", function(pPlayer)
	Slawer.Mayor:SyncWarrants(pPlayer)
end)