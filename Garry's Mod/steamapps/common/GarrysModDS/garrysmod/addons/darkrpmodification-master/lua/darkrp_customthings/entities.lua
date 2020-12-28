--[[---------------------------------------------------------------------------
DarkRP custom entities
---------------------------------------------------------------------------

This file contains your custom entities.
This file should also contain entities from DarkRP that you edited.

Note: If you want to edit a default DarkRP entity, first disable it in darkrp_config/disabled_defaults.lua
    Once you've done that, copy and paste the entity to this file and edit it.

The default entities can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/addentities.lua

For examples and explanation please visit this wiki page:
https://darkrp.miraheze.org/wiki/DarkRP:CustomEntityFields

Add entities under the following line:
---------------------------------------------------------------------------]]
--[[
    Generated using: DarkRP | Entity Generator
    https://csite.io/tools/gmod-darkrp-entity
--]]
DarkRP.createEntity("Piano", {
    ent = "gmt_instrument_piano",
    model = "models/fishy/furniture/piano.mdl",
    price = 1000,
    max = 1,
    cmd = "gmt_instrument_piano",
    category = "Piano",
    allowed = {TEAM_PIANIST},
    customCheck = function(ply) return
        table.HasValue({TEAM_PIANIST}, ply:Team())
    end,
    CustomCheckFailMsg = "",
})

DarkRP.createEntity("Bitminer S1", {
    ent = "bm2_bitminer_1",
    model = "models/bitminers2/bitminer_1.mdl",
    price = 5000,
    max = 2,
    cmd = "buybitminers1",
    category = "Bitcoin",
    allowed = {TEAM_BITCOIN_MINER},
    customCheck = function(ply) return
        table.HasValue({TEAM_BITCOIN_MINER}, ply:Team())
    end,
    CustomCheckFailMsg = "",
}) 

DarkRP.createEntity("Bitminer S2", {
    ent = "bm2_bitminer_2",
    model = "models/bitminers2/bitminer_3.mdl",
    price = 25000,
    max = 2,
    cmd = "buybitminers2",
    category = "Bitcoin",
    allowed = {TEAM_BITCOIN_MINER},
    customCheck = function(ply) return
        table.HasValue({TEAM_BITCOIN_MINER}, ply:Team())
    end,
    CustomCheckFailMsg = "",
})

DarkRP.createEntity("Bitminer Server", {
    ent = "bm2_bitminer_server",
    model = "models/bitminers2/bitminer_2.mdl",
    price = 50000,
    max = 8,
    cmd = "buybitminerserver",
    category = "Bitcoin",
    allowed = {TEAM_BITCOIN_MINER},
    customCheck = function(ply) return
        table.HasValue({TEAM_BITCOIN_MINER}, ply:Team())
    end,
    CustomCheckFailMsg = "",
})

DarkRP.createEntity("Bitminer Rack", {
    ent = "bm2_bitminer_rack",
    model = "models/bitminers2/bitminer_rack.mdl",
    price = 100000,
    max = 1,
    cmd = "buybitminerrack",
    category = "Bitcoin",
    allowed = {TEAM_BITCOIN_MINER},
    customCheck = function(ply) return
        table.HasValue({TEAM_BITCOIN_MINER}, ply:Team())
    end,
    CustomCheckFailMsg = "",
})

DarkRP.createEntity("Extension Lead", {
    ent = "bm2_extention_lead",
    model = "models/bitminers2/bitminer_plug_3.mdl",
    price = 500,
    max = 4,
    cmd = "buybitminerextension",
    category = "Bitcoin",
    allowed = {TEAM_BITCOIN_MINER},
    customCheck = function(ply) return
        table.HasValue({TEAM_BITCOIN_MINER}, ply:Team())
    end,
    CustomCheckFailMsg = "",
})

DarkRP.createEntity("Power Lead", {
    ent = "bm2_power_lead",
    model = "models/bitminers2/bitminer_plug_2.mdl",
    price = 500,
    max = 5,
    cmd = "buybitminerpowerlead",
    category = "Bitcoin",
    allowed = {TEAM_BITCOIN_MINER},
    customCheck = function(ply) return
        table.HasValue({TEAM_BITCOIN_MINER}, ply:Team())
    end,
    CustomCheckFailMsg = "",
})

DarkRP.createEntity("Generator", {
    ent = "bm2_generator",
    model = "models/bitminers2/generator.mdl",
    price = 6000,
    max = 1,
    cmd = "buybitminergenerator",
    category = "Bitcoin",
    allowed = {TEAM_BITCOIN_MINER},
    customCheck = function(ply) return
        table.HasValue({TEAM_BITCOIN_MINER}, ply:Team())
    end,
    CustomCheckFailMsg = "",
})

DarkRP.createEntity("Fuel", {
    ent = "bm2_fuel",
    model = "models/props_junk/gascan001a.mdl",
    price = 1000,
    max = 2,
    cmd = "buybitminerfuel",
    category = "Bitcoin",
    allowed = {TEAM_BITCOIN_MINER},
    customCheck = function(ply) return
        table.HasValue({TEAM_BITCOIN_MINER}, ply:Team())
    end,
    CustomCheckFailMsg = "",
})

DarkRP.createEntity("Fuel Line", {
    ent = "bm2_extra_fuel_line",
    model = "models/bitminers2/bm2_extra_fuel_plug.mdl",
    price = 1500,
    max = 1,
    cmd = "buyfuelline",
    category = "Bitcoin",
    allowed = {TEAM_BITCOIN_MINER},
    customCheck = function(ply) return
        table.HasValue({TEAM_BITCOIN_MINER}, ply:Team())
    end,
    CustomCheckFailMsg = "",
}) 

DarkRP.createEntity("Large Fuel", {
    ent = "bm2_large_fuel",
    model = "models/props/de_train/barrel.mdl",
    price = 4000,
    max = 2,
    cmd = "buylargefuel",
    category = "Bitcoin",
    allowed = {TEAM_BITCOIN_MINER},
    customCheck = function(ply) return
        table.HasValue({TEAM_BITCOIN_MINER}, ply:Team())
    end,
    CustomCheckFailMsg = "",
})

DarkRP.createEntity("Fuel Tank", {
    ent = "bm2_extra_fuel_tank",
    model = "models/bitminers2/bm2_extra_fueltank.mdl",
    price = 10000,
    max = 1,
    cmd = "buyfueltank",
    category = "Bitcoin",
    allowed = {TEAM_BITCOIN_MINER},
    customCheck = function(ply) return
        table.HasValue({TEAM_BITCOIN_MINER}, ply:Team())
    end,
    CustomCheckFailMsg = "",
})

DarkRP.createEntity("Solar Cable", {
    ent = "bm2_solar_cable",
    model = "models/bitminers2/bm2_solar_plug.mdl",
    price = 500,
    max = 5,
    cmd = "buysolarcable",
    category = "Bitcoin",
    allowed = {TEAM_BITCOIN_MINER},
    customCheck = function(ply) return
        table.HasValue({TEAM_BITCOIN_MINER}, ply:Team())
    end,
    CustomCheckFailMsg = "",
})

DarkRP.createEntity("Solar Converter", {
    ent = "bm2_solarconverter",
    model = "models/bitminers2/bm2_solar_converter.mdl",
    price = 20000,
    max = 5,
    cmd = "buysolarconverter",
    category = "Bitcoin",
    allowed = {TEAM_BITCOIN_MINER},
    customCheck = function(ply) return
        table.HasValue({TEAM_BITCOIN_MINER}, ply:Team())
    end,
    CustomCheckFailMsg = "",
})

DarkRP.createEntity("Solar Panel", {
    ent = "bm2_solar_panel",
    model = "models/bitminers2/bm2_solar_panel.mdl",
    price = 15000,
    max = 10,
    cmd = "buysolarpanel",
    category = "Bitcoin",
    allowed = {TEAM_BITCOIN_MINER},
    customCheck = function(ply) return
        table.HasValue({TEAM_BITCOIN_MINER}, ply:Team())
    end,
    CustomCheckFailMsg = "",
})

DarkRP.createEntity("Ink Money Printer", {
    ent = "tierp_printer",
    model = "models/freeman/money_printer.mdl",
    price = 10000,
    max = 2,
    cmd = "tierp_printer",
    category = "Advanced Money Printers",
    customCheck = function(ply) return
        table.HasValue({TEAM_MONEY_PRINTER}, ply:Team())
    end,
    CustomCheckFailMsg = "",
})
DarkRP.createEntity("Ink Money Printer Battery", {
    ent = "tierp_battery",
    model = "models/freeman/giant_battery.mdl",
    price = 500,
    max = 4,
    cmd = "tierp_battery",
    category = "Advanced Money Printers",
    customCheck = function(ply) return
        table.HasValue({TEAM_MONEY_PRINTER}, ply:Team())
    end,
    CustomCheckFailMsg = "",
})--[[
    Generated using: DarkRP | Entity Generator
    https://csite.io/tools/gmod-darkrp-entity
--]]
DarkRP.createEntity("Lean Barrel", {
    ent = "lean_barrel",
    model = "models/freeman/codeine_barrel.mdl",
    price = 1500,
    max = 2,
    cmd = "lean_barrel",
    category = "Lean Materials",
    allowed = {TEAM_LEAN_MANUFACTURER}
})--[[
    Generated using: DarkRP | Entity Generator
    https://csite.io/tools/gmod-darkrp-entity
--]]
DarkRP.createEntity("Lean Crate", {
    ent = "lean_crate",
    model = "models/freeman/codeine_crate.mdl",
    price = 5000,
    max = 1,
    cmd = "lean_crate",
    category = "Lean Materials",
    allowed = {TEAM_LEAN_MANUFACTURER}
})--[[
    Generated using: DarkRP | Entity Generator
    https://csite.io/tools/gmod-darkrp-entity
--]]
DarkRP.createEntity("Lean Cup", {
    ent = "lean_cup",
    model = "models/freeman/codeine_cup.mdl",
    price = 20,
    max = 8,
    cmd = "lean_cup",
    category = "Lean Materials",
    allowed = {TEAM_LEAN_MANUFACTURER}
})--[[
    Generated using: DarkRP | Entity Generator
    https://csite.io/tools/gmod-darkrp-entity
--]]
DarkRP.createEntity("Lean Small Crate", {
    ent = "lean_smallcrate",
    model = "models/props_junk/cardboard_box001a.mdl",
    price = 500,
    max = 2,
    cmd = "lean_smallcrate",
    category = "Lean Materials",
    allowed = {TEAM_LEAN_MANUFACTURER}
})