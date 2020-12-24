if not SERVER then return end
zrmine = zrmine or {}
zrmine.f = zrmine.f or {}

function zrmine.f.BuyerMarkt_TimerExist()
	zrmine.f.Timer_Remove("zrmine_buyermarkt_id")
	zrmine.f.Timer_Create("zrmine_buyermarkt_id", zrmine.config.MetalBuyer.RefreshRate, 0, zrmine.f.BuyerMarkt_Change)
end
hook.Add("InitPostEntity", "a_zrmine_SpawnBuyermarkt", zrmine.f.BuyerMarkt_TimerExist)

function zrmine.f.BuyerMarkt_Change()
	for k, v in pairs(ents.FindByClass("zrms_buyer")) do
		if (IsValid(v)) then
			zrmine.f.BuyerNPC_RefreshBuyRate(v)
		end
	end
end
