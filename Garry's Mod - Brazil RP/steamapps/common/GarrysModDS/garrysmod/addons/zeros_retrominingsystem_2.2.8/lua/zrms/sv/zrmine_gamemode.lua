if not SERVER then return end

local zrms_UserEntities = {
    ["zrms_basket"] = true,
    ["zrms_conveyorbelt"] = true,
    ["zrms_conveyorbelt_n"] = true,
    ["zrms_conveyorbelt_s"] = true,
    ["zrms_conveyorbelt_c_left"] = true,
    ["zrms_conveyorbelt_c_right"] = true,
    ["zrms_crusher"] = true,
    ["zrms_gravelcrate"] = true,
    ["zrms_melter"] = true,
    ["zrms_mineentrance_base"] = true,
    ["zrms_inserter"] = true,
    ["zrms_refiner_iron"] = true,
    ["zrms_refiner_coal"] = true,
    ["zrms_refiner_bronze"] = true,
    ["zrms_refiner_silver"] = true,
    ["zrms_refiner_gold"] = true,
    ["zrms_splitter"] = true,
    ["zrms_storagecrate"] = true,
    ["zrms_sorter_silver"] = true,
    ["zrms_sorter_iron"] = true,
    ["zrms_sorter_gold"] = true,
    ["zrms_sorter_coal"] = true,
    ["zrms_sorter_bronze"] = true,
}


hook.Add("playerBoughtCustomEntity", "a_zrmine_SetOwnerOnEntBuy", function(ply, enttbl, ent, price)
    if (zrms_UserEntities[ent:GetClass()]) then
        zrmine.f.SetOwner(ent, ply)
    end
end)

hook.Add("BaseWars_PlayerBuyEntity", "a_zrmine_BaseWars_PlayerBuyEntity", function(ply, ent)
    if zrms_UserEntities[ent:GetClass()] then
        zrmine.f.SetOwner(ent, ply)
    end
end)
