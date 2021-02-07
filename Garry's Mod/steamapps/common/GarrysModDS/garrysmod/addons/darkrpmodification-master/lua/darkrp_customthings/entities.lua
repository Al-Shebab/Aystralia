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

DarkRP.createEntity("Bitminer S1", {
    ent = "bm2_bitminer_1",
    model = "models/bitminers2/bitminer_1.mdl",
    price = 10000,
    max = 1,
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
    max = 1,
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
    price = 40000,
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
    price = 20000,
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
    max = 1,
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
    price = 1000,
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
    price = 2500,
    max = 2,
    cmd = "buybitminerfuel",
    category = "Bitcoin",
    allowed = {TEAM_BITCOIN_MINER},
    customCheck = function(ply) return
        table.HasValue({TEAM_BITCOIN_MINER}, ply:Team())
    end,
    CustomCheckFailMsg = "",
})
DarkRP.createEntity( "Advanced Printer", {
    ent = "oneprint",
    model = "models/ogl/ogl_oneprint.mdl",
    price = 15000,
    max = 1,
    cmd = "oneprinter",
    category = "Advanced Money Printers",
    allowed = {TEAM_MONEY_PRINTER,TEAM_SONIC},
    customCheck = function(ply) return
        table.HasValue({TEAM_MONEY_PRINTER,TEAM_SONIC}, ply:Team())
    end,
    CustomCheckFailMsg = "",
})
DarkRP.createEntity("Combiner", {
	ent = "zmlab_combiner",
	model = "models/zerochain/zmlab/zmlab_combiner.mdl",
	price = 6000,
	max = 1,
	cmd = "buycombiner_zmlab",
	allowed = TEAM_METH_DEALER,
	category = "Meth Materials"
})

DarkRP.createEntity("Gas Filter", {
	ent = "zmlab_filter",
	model = "models/zerochain/zmlab/zmlab_filter.mdl",
	price = 5000,
	max = 1,
	cmd = "buyfilter_zmlab",
	allowed = TEAM_METH_DEALER,
	category = "Meth Materials"
})

DarkRP.createEntity("Freezer", {
	ent = "zmlab_frezzer",
	model = "models/zerochain/zmlab/zmlab_frezzer.mdl",
	price = 2500,
	max = 1,
	cmd = "buyfrezzer_zmlab",
	allowed = TEAM_METH_DEALER,
	category = "Meth Materials"
})

DarkRP.createEntity("Transport Crate", {
	ent = "zmlab_collectcrate",
	model = "models/zerochain/zmlab/zmlab_transportcrate.mdl",
	price = 1000,
	max = 4,
	cmd = "buycollectcrate_zmlab",
	allowed = TEAM_METH_DEALER,
	category = "Meth Materials"
})

DarkRP.createEntity("Methylamin", {
	ent = "zmlab_methylamin",
	model = "models/zerochain/zmlab/zmlab_methylamin.mdl",
	price = 2000,
	max = 3,
	cmd = "buymethylamin_zmlab",
	allowed = TEAM_METH_DEALER,
	category = "Meth Materials"
})

DarkRP.createEntity("Aluminium", {
	ent = "zmlab_aluminium",
	model = "models/zerochain/zmlab/zmlab_aluminiumbox.mdl",
	price = 500,
	max = 3,
	cmd = "buyaluminium_zmlab",
	allowed = TEAM_METH_DEALER,
	category = "Meth Materials"
})

-- Weed?? --

DarkRP.createEntity("DoobyTable", {
    ent = "zwf_doobytable",
    model = "models/zerochain/props_weedfarm/zwf_doobytable.mdl",
    price = 5000,
    max = 1,
    cmd = "buyzwf_doobytable",
    allowed = {TEAM_WEED_DEALER},
    category = "Weed Materials"
})

DarkRP.createEntity("Mixer", {
    ent = "zwf_mixer",
    model = "models/zerochain/props_weedfarm/zwf_mixer.mdl",
    price = 5000,
    max = 1,
    cmd = "buyzwf_mixer",
    allowed = {TEAM_WEED_DEALER},
    category = "Weed Materials"
})

DarkRP.createEntity("Oven", {
    ent = "zwf_oven",
    model = "models/zerochain/props_weedfarm/zwf_oven.mdl",
    price = 5000,
    max = 1,
    cmd = "buyzwf_oven",
    allowed = {TEAM_WEED_DEALER},
    category = "Weed Materials"
})

local function Spawn_BackMix(id,ply,tr)
    local backmix = ents.Create("zwf_backmix")
    backmix:SetPos(tr.HitPos)
    backmix:Spawn()
    backmix:SetModel(zwf.config.Cooking.edibles[id].backmix_model)
    backmix:Activate()
    backmix.EdibleID = id
    return backmix
end

DarkRP.createEntity("Muffin Mix", {
    ent = "zwf_backmix",
    model = "models/zerochain/props_weedfarm/zwf_backmix_muffin.mdl",
    price = 500,
    max = 3,
    cmd = "buyzwf_backmix_muffin",
    allowed = {TEAM_WEED_DEALER},
    category = "Weed Materials",
    spawn = function(ply, tr, tblEnt)
        return  Spawn_BackMix(1,ply,tr)
    end
})

DarkRP.createEntity("Brownie Mix", {
    ent = "zwf_backmix",
    model = "models/zerochain/props_weedfarm/zwf_backmix_brownie.mdl",
    price = 500,
    max = 3,
    cmd = "buyzwf_backmix_brownie",
    allowed = {TEAM_WEED_DEALER},
    category = "Weed Materials",
    spawn = function(ply, tr, tblEnt)
        return  Spawn_BackMix(2,ply,tr)
    end
})

DarkRP.createEntity("Fuel Line", {
    ent = "bm2_extra_fuel_line",
    model = "models/bitminers2/bm2_extra_fuel_plug.mdl",
    price = 1500,
    max = 1,
    cmd = "buyfuelline",
    allowed = {TEAM_BITCOIN_MINER},
    category = "Bitcoin"
}) 

DarkRP.createEntity("Large Fuel", {
    ent = "bm2_large_fuel",
    model = "models/props/de_train/barrel.mdl",
    price = 4000,
    max = 2,
    cmd = "buylargefuel",
    allowed = {TEAM_BITCOIN_MINER},
    category = "Bitcoin"
})

DarkRP.createEntity("Fuel Tank", {
    ent = "bm2_extra_fuel_tank",
    model = "models/bitminers2/bm2_extra_fueltank.mdl",
    price = 10000,
    max = 1,
    cmd = "buyfueltank",
    allowed = {TEAM_BITCOIN_MINER},
    category = "Bitcoin"
})

DarkRP.createEntity("Solar Cable", {
    ent = "bm2_solar_cable",
    model = "models/bitminers2/bm2_solar_plug.mdl",
    price = 500,
    max = 5,
    cmd = "buysolarcable",
    allowed = {TEAM_BITCOIN_MINER},
    category = "Bitcoin"
})

DarkRP.createEntity("Solar Converter", {
    ent = "bm2_solarconverter",
    model = "models/bitminers2/bm2_solar_converter.mdl",
    price = 30000,
    max = 1,
    cmd = "buysolarconverter",
    allowed = {TEAM_BITCOIN_MINER},
    category = "Bitcoin"
})

DarkRP.createEntity("Solar Panel", {
    ent = "bm2_solar_panel",
    model = "models/bitminers2/bm2_solar_panel.mdl",
    price = 15000,
    max = 5,
    cmd = "buysolarpanel",
    allowed = {TEAM_BITCOIN_MINER},
    category = "Bitcoin"
})
    
DarkRP.createEntity("Armour Station", {
    ent = "armour_station",
    model = "models/props_c17/consolebox01a.mdl",
    price = 100000,
    max = 1,
    cmd = "armour_station",
    category = "Supplies"
})    

DarkRP.createEntity("BuildKit", {
    ent = "zrush_machinecrate",
    model = "models/zerochain/props_oilrush/zor_machinecrate.mdl",
    price = 1000,
    max = 4,
    cmd = "buyzrushmachinecrate",
    allowed = {TEAM_OIL_REFINER},
    category = "Oil Refiner"
})

DarkRP.createEntity("Barrel", {
    ent = "zrush_barrel",
    model = "models/zerochain/props_oilrush/zor_barrel.mdl",
    price = 500,
    max = 8,
    cmd = "buyzrushbarrel",
    allowed = {TEAM_OIL_REFINER},
    category = "Oil Refiner"
})

DarkRP.createEntity("10x Pipes", {
    ent = "zrush_drillpipe_holder",
    model = "models/zerochain/props_oilrush/zor_drillpipe_holder.mdl",
    price = 500,
    max = 1,
    cmd = "buyzrushdrillpipeholder",
    allowed = {TEAM_OIL_REFINER},
    category = "Oil Refiner"
})

DarkRP.createEntity("Palette", {
    ent = "zrush_palette",
    model = "models/props_junk/wood_pallet001a.mdl",
    price = 1000,
    max = 2,
    cmd = "buyzrush_palette",
    allowed = {TEAM_OIL_REFINER},
    category = "Oil Refiner"
})

DarkRP.createEntity("FruitSlicer Shop", {
	ent = "zfs_shop",
	model = "models/zerochain/fruitslicerjob/fs_shop.mdl",
	price = 5000,
	max = 1,
	cmd = "buyzfs_shop",
	allowed = {TEAM_FRUIT_SLICER},
	category = "Fruit Slicer",
})

DarkRP.createEntity("Melons", {
	ent = "zfs_fruitbox_melon",
	model = "models/zerochain/fruitslicerjob/fs_cardboardbox.mdl",
	price = 1000,
	max = 1,
	cmd = "zfs_fruitbox_melon",
	allowed = {TEAM_FRUIT_SLICER},
	category = "Fruit Slicer"
})
DarkRP.createEntity("Bananas", {
	ent = "zfs_fruitbox_banana",
	model = "models/zerochain/fruitslicerjob/fs_cardboardbox.mdl",
	price = 1000,
	max = 1,
	cmd = "zfs_fruitbox_banana",
	allowed = {TEAM_FRUIT_SLICER},
	category = "Fruit Slicer"
})
DarkRP.createEntity("Coconuts", {
	ent = "zfs_fruitbox_coconut",
	model = "models/zerochain/fruitslicerjob/fs_cardboardbox.mdl",
	price = 1000,
	max = 1,
	cmd = "zfs_fruitbox_coconut",
	allowed = {TEAM_FRUIT_SLICER},
	category = "Fruit Slicer"
})
DarkRP.createEntity("Pomegranates", {
	ent = "zfs_fruitbox_pomegranate",
	model = "models/zerochain/fruitslicerjob/fs_cardboardbox.mdl",
	price = 1000,
	max = 1,
	cmd = "zfs_fruitbox_pomegranate",
	allowed = {TEAM_FRUIT_SLICER},
	category = "Fruit Slicer"
})
DarkRP.createEntity("Strawberrys", {
	ent = "zfs_fruitbox_strawberry",
	model = "models/zerochain/fruitslicerjob/fs_cardboardbox.mdl",
	price = 1000,
	max = 1,
	cmd = "zfs_fruitbox_strawberry",
	allowed = {TEAM_FRUIT_SLICER},
	category = "Fruit Slicer"
})
DarkRP.createEntity("Kiwis", {
	ent = "zfs_fruitbox_kiwi",
	model = "models/zerochain/fruitslicerjob/fs_cardboardbox.mdl",
	price = 1000,
	max = 1,
	cmd = "zfs_fruitbox_kiwi",
	allowed = {TEAM_FRUIT_SLICER},
	category = "Fruit Slicer"
})
DarkRP.createEntity("Lemons", {
	ent = "zfs_fruitbox_lemon",
	model = "models/zerochain/fruitslicerjob/fs_cardboardbox.mdl",
	price = 1000,
	max = 1,
	cmd = "zfs_fruitbox_lemon",
	allowed = {TEAM_FRUIT_SLICER},
	category = "Fruit Slicer"
})
DarkRP.createEntity("Oranges", {
	ent = "zfs_fruitbox_orange",
	model = "models/zerochain/fruitslicerjob/fs_cardboardbox.mdl",
	price = 1000,
	max = 1,
	cmd = "zfs_fruitbox_orange",
	allowed = {TEAM_FRUIT_SLICER},
	category = "Fruit Slicer"
})
DarkRP.createEntity("Apples", {
	ent = "zfs_fruitbox_apple",
	model = "models/zerochain/fruitslicerjob/fs_cardboardbox.mdl",
	price = 1000,
	max = 1,
	cmd = "zfs_fruitbox_apple",
	allowed = {TEAM_FRUIT_SLICER},
	category = "Fruit Slicer"
})

DarkRP.createEntity("Gravel - Crate", {
	ent = "zrms_gravelcrate",
	model = "models/zerochain/props_mining/zrms_refiner_basket.mdl",
	price = 250,
	max = 5,
	cmd = "buyzrms_gravelcrate",
	allowed = {TEAM_MINER,TEAM_FELIX_ARGYLE},
	category = "Mining"
})

DarkRP.createEntity("Refiner - Crate", {
	ent = "zrms_basket",
	model = "models/zerochain/props_mining/zrms_refiner_basket.mdl",
	price = 250,
	max = 2,
	cmd = "buyzrms_basket",
	allowed = {TEAM_MINER,TEAM_FELIX_ARGYLE},
	category = "Mining"
})

DarkRP.createEntity("Storage Crate", {
	ent = "zrms_storagecrate",
	model = "models/zerochain/props_mining/zrms_storagecrate.mdl",
	price = 25,
	max = 5,
	cmd = "buyzrms_storagecrate",
	allowed = {TEAM_MINER,TEAM_FELIX_ARGYLE},
	category = "Mining"
})

DarkRP.createEntity("Mine", {
	ent = "zrms_mineentrance_base",
	model = "models/zerochain/props_mining/mining_entrance.mdl",
	price = 150000,
	max = 3,
	cmd = "buyzrms_mineentrance_base",
	allowed = {TEAM_MINER,TEAM_FELIX_ARGYLE},
	category = "Mining"
})

DarkRP.createEntity("Melter", {
	ent = "zrms_melter",
	model = "models/zerochain/props_mining/zrms_melter.mdl",
	price = 7500,
	max = 1,
	cmd = "buyzrms_melter",
	allowed = {TEAM_MINER,TEAM_FELIX_ARGYLE},
	category = "Mining"
})
