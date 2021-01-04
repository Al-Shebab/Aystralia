TierPrinters.Config = {} 
 
 
TierPrinters.Config.ChatPrefixColor = Color(200,0,200) 
TierPrinters.Config.ChatPrefix = "[Tier Printer]" 
 
/* 
=========== 
Core system 
=========== 
This is for the basic config, setting amounts, times, ect.. 
*/ 
 
-- The time to wait between each print (In seconds) 
TierPrinters.Config.PrintTime = 30 
 
-- How much health does the printer have? The higher it is, the longer it takes to destroy. 
TierPrinters.Config.Health = 100 

-- Should the UI show the health left?
TierPrinters.Config.ShowHealth = false 
 
-- Can the entity be picked up with the Phys gun?
TierPrinters.Config.PickUpAble = true 
 
-- Can the entity be picked up with the Grav gun? HIGHLY recommended
TierPrinters.Config.PickUpAbleGrav = true
 
 
/* 
============== 
Battery system 
============== 
There is a built in battery system. There are a few options to allow you to do 
multiple things with it. 
 
1.) You can disable the battery system and have a basic tier printer, I don't 
suggest this because players can AFK print and it can crash eco. 
- If this is the case, set the next option to false and skip the battery config. 
 
2.) There is an option in the derma (UI) that allows you to recharge the battery 
and it's as simple as pressing a button. Great for a basic level battery system. 
- If this is the case, configure all of the battery config. 
 
3.) There is an entity based battery system. This involves the player spawning a 
battery and pressing it against the printer. This forces more actions/movement. 
- If this is the case, configure all of the battery config but disable BatteryUI 
*/ 
 
-- Setting this to false will disable the battery system and allow it to print forever 
TierPrinters.Config.BatterySystem = true 
 
-- Setting this to true will add a "Recharge" button in the UI, allowing for players to 
-- recharge the battery through a simple button.  
TierPrinters.Config.BatteryUI = false 
 
-- If the above is true, how much should it cost to recharge the battery. 
TierPrinters.Config.BatteryPrice = 5000
 
-- The time between the battery losing 1% (In seconds) 
TierPrinters.Config.BatteryTime = 7


/* 
============
Sound System 
============
This is the settings for sound
*/ 

-- Should the printer produce sound
TierPrinters.Config.SoundSystem = true

-- The sound to be played
TierPrinters.Config.SoundDir = "ambient/levels/labs/equipment_printer_loop1.wav"


/* 
============ 
Tier System 
============ 
This is the editing for anything to do with the tier 
*/ 
 
-- Should the player be forced to buy 1 tier at a time? (Not recommended, pointless in reality)
TierPrinters.Config.ForceNextTier = false 

-- Can someone who doesn't own the printer upgrade tiers? 
TierPrinters.Config.AnyoneUpgrade = true 

/* 
Adding tier is fairly straight forwards. 
[NUMBER] = {color = COLOR, price = PRICE, amount = AMOUNT, customCheck = CUSTOM} 
 
NUMBER - This is the tier number, so if it was 4, itd be the fourth tier, 
make sure to not miss any numbers else you may encounter issues, 
 
COLOR - This is the color of the tier, it is represented on the left hand 
side of the UI. I suggest keeping it a dark color. 
 
PRICE - This is the price the player will be charged to upgrade to this tier.

AMOUNT - The amount that the printer will print each print period.
 
**Optional** 
CUSTOM - This is an option to run a custom function. Use this to restrict 
tiers to specific things. The example is user groups, however if you have 
the Lua knowledge, you can check it against anything. 

LIMIT - The max amount the printer can hold.
*/ 
 
TierPrinters.Config.Tiers = { 
 
        [1] = { 
                color = Color(100,0,0), 
                price = 0, -- The price doesn't matter for the first tier, just keep it 0 
                amount = 500
        }, 
        [2] = { 
                color = Color(200,0,0), 
                price = 5000,
                amount = 1000
        }, 
        [3] = { 
                color = Color(200,100,0), 
                price = 7000,
                amount = 1500
        }, 
        [4] = { 
                color = Color(200,200,0), 
                price = 10000,
                amount = 2000
        }, 
        [5] = { 
                color = Color(100,200,0), 
                price = 20000,
                amount = 2500,
                limit = 40000
        }, 
        [6] = { 
                color = Color(0,200,0), 
                price = 50000,
                amount = 3000,
                limit = 50000
        }, 
        [7] = { 
                color = Color(0,200,100), 
                price = 80000,
                amount = 3500,
                limit = 55000
        }, 
        [8] = { 
                color = Color(0,200,200), 
                price = 100000,
                amount = 4000,
                limit = 65000
        }, 
        [9] = { 
                color = Color(0,100,200), 
                price = 150000,
                amount = 4500,
                limit = 120000
        }, 
        [10] = { 
                color = Color(0,0,200), 
                price = 200000,
                amount = 5000,
                limit = 500000
        }, 
 
} 
 
 
/* 
When adding the entities to F4, you can use these: 
DarkRP.createEntity("Printer", { 
    ent = "tierp_printer", 
    model = "models/freeman/money_printer.mdl", 
    price = 10000, 
    max = 2, 
    cmd = "buytierprinter" 
}) 
 
-- !!ONLY ADD THIS IF YOU WANT PLAYERS TO BE ABLE TO RECHARGE THE BATTERY WITH THE ENTITY!!  
DarkRP.createEntity("Printer Battery", { 
    ent = "tierp_battery", 
    model = "models/freeman/giant_battery.mdl", 
    price = 500, 
    max = 2, 
    cmd = "buytierbattery" 
}) 
 
 
*/
 


/* 
================
Language Options
================
There isn't much text, so there's not much to config. But this just saves you having to go
into core files. Much safer this way.
*/ 

TierPrinters.Config.Language = {}
-- %i and %s are none static things. This could be anything from money to the printer owners name.

-- These are the lines for the identity of the printer in both the UI and on the external panel.
TierPrinters.Config.Language.Identity1 = "%s's" -- The top line
TierPrinters.Config.Language.Identity2 = "Money Printer" -- The 2nd line

-- These are the lines for the its current holding in both the UI and on the external panel.
TierPrinters.Config.Language.CurrentHold1 = "Currently Holding" -- The top line
TierPrinters.Config.Language.CurrentHold2 = "$%s" -- The 2nd line

-- This is the big access button on the front of the external panel
TierPrinters.Config.Language.Access = "ACCESS"

-- These are the list of tiers on the right side of the UI
TierPrinters.Config.Language.Tiers1 = "Tier %i" -- The top line
TierPrinters.Config.Language.Tiers2 = "$%s" -- The 2nd line's unpurchased state
TierPrinters.Config.Language.Tiers3 = "Purchased" -- The 2nd line's purchased state

-- This is the panel for health
TierPrinters.Config.Language.Health1 = "Health" -- The top line
TierPrinters.Config.Language.Health2 = "%i%%" -- The 2nd line. %% = %

-- This is the panel for battery
TierPrinters.Config.Language.Battery1 = "Battery" -- The top line
TierPrinters.Config.Language.Battery2 = "%i%%" -- The 2nd line. %% = %

-- This is the panel for recharge
TierPrinters.Config.Language.Recharge1 = "Recharge" -- The top line
TierPrinters.Config.Language.Recharge2 = "$%s" -- The 2nd line.

TierPrinters.Config.Language.Withdraw = "Withdraw" -- The top line

-- These are the chat noficiations 
TierPrinters.Config.Language.Destroyed = "Your printer has been destroyed!" -- For when the printer gets destroyed
TierPrinters.Config.Language.ConfRecharge = "You have recharged the battery for $%i" -- For when you recharge the battery
TierPrinters.Config.Language.ErrorOtherUpgrade = "You cannot upgrade other peoples printers!" -- Informing that you cannot upgrade other peoples printers 
TierPrinters.Config.Language.ErrorStageUpgrade = "You may only upgrade 1 tier at a time" -- Informing of only being allowed to upgrade each tier one at a time
TierPrinters.Config.Language.ErrorNoRequrirements = "You do not reach the requirements for this tier!" -- Informing of not reaching requirements for that tier
TierPrinters.Config.Language.SuccessfulUpgrade = "You have upgraded to tier %s for $%i" -- Informing of upgrading to a new tier
TierPrinters.Config.Language.FailureUpgrade = "You cannot afford to upgrade to this tier!" -- Informing of unable to upgrading to a new tier
TierPrinters.Config.Language.TakingMoney = "You have taken $%i" -- Informing of taking money
