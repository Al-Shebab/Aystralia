AddCSLuaFile()

LSD.Config.Health = 20 //Entities health

LSD.Config.PhonePrice = 2500

LSD.Config.DurationMultiplier = 8

LSD.Config.AllowPurchase = false //Allows to people buy lsd without making them
LSD.Config.Price = 5000 //How much does costs to buy 4 lsd things
LSD.Config.Selling = 0.75 //How much does cost to sell one lsd stick, correct forumla is = LSD.Config.Price/4 * LSD.Config.Selling
LSD.Config.SellingSuper = 4 //How much does it cost to sell a super, formula LSD.Config.Price/4 * LSD.Config.Selling * LSD.Config.SellingSuper

LSD.Cooking = {}
LSD.Cooking.GasDuration = 0.4 //The bigger, the faster gas will drain
LSD.Cooking.GasConsuption = 0.25 //The bigger, it will require less time to cook

LSD.Cooking.CoolTime = 0.1 //The smaller is (until 0), the more it takes to cool a flask

LSD.Cooking.ShakeStrenght = 0.5 //How much does it takes to shake the flask, this also increases the shake damage
LSD.Cooking.MaxShakeDamage = 85 //Max damage caused by shaking it too fast
