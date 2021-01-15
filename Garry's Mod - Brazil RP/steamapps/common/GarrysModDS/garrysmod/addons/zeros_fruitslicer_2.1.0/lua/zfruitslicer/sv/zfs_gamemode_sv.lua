if not SERVER then return end

local entTable = {
    ["zfs_fruit"] = true,
    ["zfs_fruitcup_base"] = true,
    ["zfs_shop"] = true
}

hook.Add("BaseWars_PlayerBuyEntity", "a_zfs_basewars_SetOwnerOnEntBuy", function(ply, ent)
    if entTable[ent:GetClass()] then
        zfs.f.SetOwner(ent, ply)
    end
end)

hook.Add("playerBoughtCustomEntity", "a_zfs_darkrp_SetOwnerOnEntBuy", function(ply, enttbl, ent, price)
    //Check table of entities
    if entTable[ent:GetClass()] then
        zfs.f.SetOwnerID(ent, ply)
    end
end)
