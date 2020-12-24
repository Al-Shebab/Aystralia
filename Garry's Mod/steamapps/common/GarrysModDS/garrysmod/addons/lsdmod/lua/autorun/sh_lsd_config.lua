
LSD = {}
LSD.__index = __index

LSD.Config = {}
LSD.Config.Health = 100 //Entities health

LSD.Config.PhonePrice = 500

LSD.Config.HolderRankMultiplier = {user=1,vip=2,supervip=3,admin=5,superadmin=10} //How many of x items can players spawn
LSD.Config.PriceRankMultiplier = {user=1,vip=0.9,supervip=0.8,admin=0.6,superadmin=0.5} //Price multiplied by ranks, example, superadmin will get their items at half price

LSD.Config.DurationMultiplier = 1

LSD.Config.AllowPurchase = false //Allows to people buy lsd without making them
LSD.Config.Price = 2000 //How much does costs to buy 4 lsd things
LSD.Config.Selling = 0.75 //How much does cost to sell one lsd stick, correct forumla is = LSD.Config.Price/4 * LSD.Config.Selling
LSD.Config.SellingSuper = 5 //How much does it cost to sell a super, formula LSD.Config.Price/4 * LSD.Config.Selling * LSD.Config.SellingSuper

LSD.Cooking = {}
LSD.Cooking.GasDuration = 1 //The bigger, the faster gas will drain
LSD.Cooking.GasConsuption = 1 //The bigger, it will require less time to cook

LSD.Cooking.CoolTime = 1 //The smaller is (until 0), the more it takes to cool a flask

LSD.Cooking.ShakeStrenght = 1 //How much does it takes to shake the flask, this also increases the shake damage
LSD.Cooking.MaxShakeDamage = 20 //Max damage caused by shaking it too fast

timer.Simple(0,function()

LSD.Config.TeamsAllowed = {TEAM_DEALER,TEAM_CITIZEN} //Leave blank for everyone
LSD.Config.TeamsDisallowed = {TEAM_POLICE}

end)

//Do you want some presets? Remove -- to the one you want to load, you can nonly use one
--include("lsd_config/easy.lua")
--include("lsd_config/medium.lua")
--include("lsd_config/hard.lua")

include("autorun/lsd_configs/veryhard.lua")

function LSD:CanPurchase(ply)
  return #self.Config.TeamsAllowed < 0 && (!table.HasValue(self.Config.TeamsDisallowed,ply:Team()) && true || false) || table.HasValue(self.Config.TeamsAllowed,ply:Team())
end
