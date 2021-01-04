if not SERVER then return end

local entTable = {
    ["zrush_barrel"] = true,
    ["zrush_drillpipe_holder"] = true,
    ["zrush_machinecrate"] = true,
    ["zrush_palette"] = true
}

hook.Add("BaseWars_PlayerBuyEntity", "a.zrush.basewars.PlayerBuyEntity", function(ply, ent)
    if entTable[ent:GetClass()] then
        zrush.f.SetOwner(ent, ply)
    end
end)

hook.Add("playerBoughtCustomEntity", "a.zrush.darkrp.PlayerBuyEntity", function(ply, enttbl, ent, price)
    if entTable[ent:GetClass()] then
        zrush.f.SetOwner(ent, ply)
    end
end)
