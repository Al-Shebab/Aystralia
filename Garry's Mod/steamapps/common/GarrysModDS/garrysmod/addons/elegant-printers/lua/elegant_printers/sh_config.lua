elegant_printers.config = {
--[[
    These are the default values that will be used for each printer.
]]

--[[
    DarkRP custom entity values

    You can also use the other values! https://wiki.darkrp.com/index.php/DarkRP:CustomEntityFields
    as well as whatever custom fields your addons make use of.
]]
--  example:
--  customCheck = function(ply) end,
--  This will get run just like if you added the "spawn" field in DarkRP.createEntity!

    PrintName = "General Money Printer",
--  The name of the money printer that will be displayed in messages and the F4 menu

    price = 1000,
--  The price of a default printer.

    max = 1,
--  By default, you can have any number of printers you want at once. (math.huge = BASICALLY INFINITE)
--  If you set this to a number, you will be limited in the amount of printers you can simultaneously own!

    GlobalMax = 2,
--  Maximum amounts of printers you can have at once, regardless of their tier.

    SeizeReward = 1000,
--  The amount of money a cop will receive upon seizing a printer. (When attacked with a Stun Stick)

--[[
    The printer entity's values
]]
    PrintAmount = 200,
--  The amount of money printed per "ink usage".

    PrintTime = 60 * 1,
--  The amount of time in seconds it takes to print money. ((60 * 1) seconds = 1 minutes)

    HeatupTime = 10,
--  The amount of time in seconds it takes the printer to heat up.
--  Everytime the printer heats up, it will take one damage to durability. Once it reaches 0, it will explode!
--  You can prevent this using High Quality Cooling.

    MaxMoney = 10000,
--  The maximum amount of money the money printer can store until it stops printing.
--  TIP: You can pass math.huge as a value to make it infinite.

    InkSystem = true,
--  If set to false, the printers will work without ink.

    CoolingSystem = true,
--  If set to false, the simple cooling system will be disabled.

    MaxInk = 5,
--  The default amount of times a printer can print money before you have to refill it.

    InkRefill = 5,
--  The amount of ink that will be refilled on usage of an ink cartridge.
--  TIP: This value is also used to determine how many slots will be added on usage of an ink cartridge slot upgrade!

    UpgradedMaxInk = 15,
--  The maximum amount of ink a printer can store, with all slot upgrades.

    LogoURL = "https://i.imgur.com/LXf6L2R.png",
--  An URL linking to the image that will get displayed on your printer's interface.
--  Must be a direct link to the image, ending with .jpg or .png

    GradientDirection = "right",
--  The direction of the background gradient used on the printer.
--  Possible values: "up", "down", "left", "right", "none"

    Gradient1 = Color(0, 99, 115),
--  Start color of the gradient (Pick RGB values using https://www.w3schools.com/colors/colors_picker.asp)
--  If GradientDirection is set to "none", this will be the background of the printer's interface.

    Gradient2 = Color(0, 151, 176),
--  End color of the gradient
--  Unused if GradientDirection is set to "none".

    PrinterColor = Color(255, 255, 255),
--  The printer's model's color on spawn.

    InvertColors = true,
--  For the printer's interface, do you want to switch white text for black text?
--  Could improve readability depending on the gradient colors you chose.

    MaxRenderDistance = 128 ^ 2,
--  How far you have to be for the printer screen to stop rendering. Hammer units. Lowering this helps with performance.
--  Do not forget the "^ 2" after the number, it is required for this config option to work properly.

    AllowedVIPs = {
        "user",
        "trusted",
        "perth",
        "brisbane",
        "melbourne",
        "sydney",
        "ayssie",
        "member",
        "trial-moderator",
        "moderator",
        "senior-moderator",
        "admin",
        "donator-trial-moderator",
        "donator-moderator",
        "donator-senior-moderator",
        "donator-admin",
        "senior-admin",
        "staff-manager",
        "superadmin",
    },
--  If this table exists and is not empty, players that do not have one of the specified usergroups will not be able to buy a printer.

--[[
    If ItemStore is installed...

    https://www.gmodstore.com/scripts/view/15/itemstore-inventory-for-darkrp
]]
    ItemStore = false,
--  If set to true, this will let you pick up the printers and its upgrades with it.

--[[
    If Vrondrakis's Level System is installed...

    https://github.com/vrondakis/Leveling-System
]]
    VrondakisLevelSystem = false,
--  If set to true, printers will give XP on money retrieval.
    VrondakisLevelSystem_Multiplier = 0.25,
--  The XP being given is the amount of money being retrieved multiplied by the above number.
    VrondakisLevelSystem_MinLevel = 0,
--  The minimum level required to spawn a printer.

--[[
    Using the same variable names as the ones above with different values, you can create customized printer tiers.
    The values you pick for them will override the ones of the default printer, set above this comment.
    You can add any number of tiers you want.
    Tier names will show up in some places, make sure to capitalize them properly!

    Keep in mind, ALL of the values above have an effect! Don't be afraid to try and mix every config option with another!
]]
    Tiers = {
        Generic = {
            PrintName = "Generic Grade Printer",
            price = 1000,
            cmd = "buyprinter_generic",

            PrintAmount = 1200,
            MaxMoney = 15000,
            Gradient1 = Color(0, 99, 115),
            Gradient2 = Color(0, 151, 176),
            AllowedVIPs = {
                "user",
                "trusted",
                "perth",
                "brisbane",
                "melbourne",
                "sydney",
                "ayssie",
                "member",
                "trial-moderator",
                "moderator",
                "senior-moderator",
                "admin",
                "donator-trial-moderator",
                "donator-moderator",
                "donator-senior-moderator",
                "donator-admin",
                "senior-admin",
                "staff-manager",
                "superadmin",
            },
-- Example: PrintTime = 10 (This tier would print $1,000 every 10 seconds)
        },
        Perth = {
            PrintName = "Perth Grade Printer",
            price = 2500,
            cmd = "buyprinter_perth",

            PrintAmount = 2400,
            MaxMoney = 25000,
            Gradient1 = Color(0, 183, 212),
            Gradient2 = Color(36, 225, 255),
            AllowedVIPs = {
                "perth",
                "staff-manager",
                "superadmin",
            },
-- Example: PrintTime = 10 (This tier would print $1,000 every 10 seconds)
        },
        Brisbane = {
            PrintName = "Brisbane Grade Printer",
            price = 5000,
            cmd = "buyprinter_brisbane",

            PrintAmount = 3600,
            MaxMoney = 40000,
            Gradient1 = Color(61, 229, 255),
            Gradient2 = Color(130, 238, 255),
            AllowedVIPs = {
                "brisbane",
                "staff-manager",
                "superadmin",
            },
        },
        Melbourne = {
            PrintName = "Melbourne Grade Printer",
            price = 7500,
            cmd = "buyprinter_melbourne",

            PrintAmount = 4800,
            MaxMoney = 50000,
            Gradient1 = Color(61, 255, 213),
            Gradient2 = Color(130, 255, 228),
            AllowedVIPs = {
                "melbourne",
                "staff-manager",
                "superadmin",
            },
        },
        Sydney = {
            PrintName = "Sydney Grade Printer",
            price = 10000,
            cmd = "buyprinter_sydney",

            PrintAmount = 6000,
            MaxMoney = 75000,
            Gradient1 = Color(61, 255, 154),
            Gradient2 = Color(130, 255, 190),
            AllowedVIPs = {
                "sydney",
                "staff-manager",
                "superadmin",
            },
        },
        Ayssie = {
            PrintName = "Ayssie Grade Printer",
            price = 26000,
            cmd = "buyprinter_ayssie",

            PrintAmount = 18000,
            MaxMoney = 200000,
            Gradient1 = Color(61, 255, 154),
            Gradient2 = Color(130, 255, 190),
            AllowedVIPs = {
                "ayssie",
                "donator-trial-moderator",
                "donator-moderator",
                "donator-senior-moderator",
                "donator-admin",
                "senior-admin",
                "staff-manager",
                "superadmin",
            },
        },
    },

--[[
    These tables allow you to customize each upgrade's price and model.
    You shouldn't have to modify the latter at any point, but it's up to you if you want to.
]]
    InkCartridge = {
        PrintName = "Xenon Printer Ink Cartridge",
        price = 100,
        model = "models/freeman/compact_printer_ink.mdl",
        cmd = "buyprinterink",

        Disabled = false, -- If set to true, the item won't show up in the F4 menu.
    },
    InkSlot = {
        PrintName = "Xenon Ink Cartridge Upgrade",
        price = 1000,
        model = "models/Items/car_battery01.mdl",
        cmd = "buyprinterslot",

        Disabled = false, -- If set to true, the item won't show up in the F4 menu.
    },
    RepairPart = {
        PrintName = "Xenon Repair Part",
        price = 1000,
        model = "models/props_lab/reciever01d.mdl",
        cmd = "buyprinterrepair",

        Disabled = false, -- If set to true, the item won't show up in the F4 menu.
    },
    HQCooling = {
        PrintName = "Xenon Quality Cooling",
        price = 2500,
        model = "models/props_phx/gears/spur12.mdl",
        cmd = "buyprintercooling",

        Disabled = false, -- If set to true, the item won't show up in the F4 menu.
    },

--[[
    Printing bonus event, triggered with the `elegant_printers_triggerevent` command.
    You can let superadmins run that command whenever they want, or make it part of a package of your favorite donation system!
]]
    EventDuration = 60 * 60 * 3,
--  Duration in seconds ((60 * 60 * 3) seconds = 3 hours)

    EventPrintMultiplier = 1.5,
--  1.5 equals to +50% print bonus!

--[[
    Usergroup overrides and bonuses
]]
    PrintMultiplierVIPs = { -- You can make it so certain usergroups benefit from a permanent print percentage bonus, the same way as the event print multiplier.
        -- superadmin = 1.5,
    },
    UpgradedMaxInkVIPs = { -- Same goes with maximum ink cartridge slot upgrade limits!
        superadmin = 20,
    },
    GlobalMaxVIPs = {
        superadmin = math.huge,
    },

--[[
    Miscellaneous values, used for printing in the chat as well as the console, and the F4 menu category.
]]
    CommunityName = "Money Printers",
    CommunityColor = Color(0, 251, 255),
}

--[[
    Past this point, I strongly advise you not to modify or remove anything else in the addon; unless you know what you are doing.
    I have made it so the addition of the printers and their upgrades to the F4 menu are completely automated, entirely through
    the use of the above config table. If you ended up breaking this file, just start over and try again!

    Make sure to restart everytime you make a change to be sure everything has been applied properly.
    ALSO, DON'T FORGET ANY COMMAS.

    If you have encountered any bug, and are absolutely certain that it is not your fault, please create a support ticket.
]]
