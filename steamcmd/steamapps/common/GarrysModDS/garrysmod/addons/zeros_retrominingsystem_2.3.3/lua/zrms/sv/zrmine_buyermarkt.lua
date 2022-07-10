if not SERVER then return end
zrmine = zrmine or {}
zrmine.f = zrmine.f or {}

function zrmine.f.BuyerMarkt_TimerExist()
    zrmine.f.Timer_Remove("zrmine_buyermarkt_id")
    zrmine.f.Timer_Create("zrmine_buyermarkt_id", zrmine.config.MetalBuyer.RefreshRate, 0, zrmine.f.BuyerMarkt_Change)
end

function zrmine.f.BuyerMarkt_Change()

    local npcs = ents.FindByClass("zrms_buyer")
    for k, v in pairs(npcs) do
        if (IsValid(v)) then
            zrmine.f.BuyerNPC_RefreshBuyRate(v)
        end
    end
end

zrmine.f.BuyerMarkt_TimerExist()
