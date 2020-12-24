LSD.Config = {}
LSD.Config.Health = 100 //Entities health

LSD.Config.PhonePrice = 500

LSD.Config.DurationMultiplier = 1

LSD.Config.AllowPurchase = true //Allows to people buy lsd without making them
LSD.Config.Price = 2000 //How much does costs to buy 4 lsd things
LSD.Config.Selling = 0.75 //How much does cost to sell one lsd stick, correct forumla is = LSD.Config.Price/4 * LSD.Config.Selling
LSD.Config.SellingSuper = 5 //How much does it cost to sell a super, formula LSD.Config.Price/4 * LSD.Config.Selling * LSD.Config.SellingSuper

LSD.Cooking = {}
LSD.Cooking.GasDuration = 1 //The bigger, the faster gas will drain
LSD.Cooking.GasConsuption = 1 //The bigger, it will require less time to cook

LSD.Cooking.CoolTime = 1 //The smaller is (until 0), the more it takes to cool a flask

LSD.Cooking.ShakeStrenght = 1 //How much does it takes to shake the flask, this also increases the shake damage
LSD.Cooking.MaxShakeDamage = 20 //Max damage caused by shaking it too fast
