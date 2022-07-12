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
-- Bitcoin Miner --

DarkRP.createEntity("Bitminer S1", {
	ent = "bm2_bitminer_1",
	model = "models/bitminers2/bitminer_1.mdl",
	price = 5000,
	max = 4,
	cmd = "buybitminers1",
    allowed = BITCOIN_MINER,
	category = "Bitcoin Mining"
}) 

DarkRP.createEntity("Bitminer S2", {
	ent = "bm2_bitminer_2",
	model = "models/bitminers2/bitminer_3.mdl",
	price = 25000,
	max = 4,
	cmd = "buybitminers2",
    allowed = BITCOIN_MINER,
	category = "Bitcoin Mining"
})

DarkRP.createEntity("Bitminer Server", {
	ent = "bm2_bitminer_server",
	model = "models/bitminers2/bitminer_2.mdl",
	price = 50000,
	max = 16,
	cmd = "buybitminerserver",
    allowed = BITCOIN_MINER,
	category = "Bitcoin Mining"
})

DarkRP.createEntity("Bitminer Rack", {
	ent = "bm2_bitminer_rack",
	model = "models/bitminers2/bitminer_rack.mdl",
	price = 100000,
	max = 2,
	cmd = "buybitminerrack",
    allowed = BITCOIN_MINER,
	category = "Bitcoin Mining"
})

DarkRP.createEntity("Extension Lead", {
	ent = "bm2_extention_lead",
	model = "models/bitminers2/bitminer_plug_3.mdl",
	price = 500,
	max = 8,
	cmd = "buybitminerextension",
    allowed = BITCOIN_MINER,
	category = "Bitcoin Mining"
})

DarkRP.createEntity("Power Lead", {
	ent = "bm2_power_lead",
	model = "models/bitminers2/bitminer_plug_2.mdl",
	price = 500,
	max = 10,
	cmd = "buybitminerpowerlead",
    allowed = BITCOIN_MINER,
	category = "Bitcoin Mining"
})

DarkRP.createEntity("Generator", {
	ent = "bm2_generator",
	model = "models/bitminers2/generator.mdl",
	price = 6000,
	max = 3,
	cmd = "buybitminergenerator",
    allowed = BITCOIN_MINER,
	category = "Bitcoin Mining"
})

DarkRP.createEntity("Fuel", {
	ent = "bm2_fuel",
	model = "models/props_junk/gascan001a.mdl",
	price = 1000,
	max = 4,
	cmd = "buybitminerfuel",
    allowed = BITCOIN_MINER,
	category = "Bitcoin Mining"
})

DarkRP.createEntity("Fuel Line", {
	ent = "bm2_extra_fuel_line",
	model = "models/bitminers2/bm2_extra_fuel_plug.mdl",
	price = 1500,
	max = 2,
	cmd = "buyfuelline",
    allowed = BITCOIN_MINER,
	category = "Bitcoin Mining"
}) 

DarkRP.createEntity("Large Fuel", {
	ent = "bm2_large_fuel",
	model = "models/props/de_train/barrel.mdl",
	price = 4000,
	max = 4,
	cmd = "buylargefuel",
    allowed = BITCOIN_MINER,
	category = "Bitcoin Mining"
})

DarkRP.createEntity("Fuel Tank", {
	ent = "bm2_extra_fuel_tank",
	model = "models/bitminers2/bm2_extra_fueltank.mdl",
	price = 10000,
	max = 2,
	cmd = "buyfueltank",
    allowed = BITCOIN_MINER,
	category = "Bitcoin Mining"
})

DarkRP.createEntity("Solar Cable", {
	ent = "bm2_solar_cable",
	model = "models/bitminers2/bm2_solar_plug.mdl",
	price = 500,
	max = 10,
	cmd = "buysolarcable",
    allowed = BITCOIN_MINER,
	category = "Bitcoin Mining"
})

DarkRP.createEntity("Solar Converter", {
	ent = "bm2_solarconverter",
	model = "models/bitminers2/bm2_solar_converter.mdl",
	price = 20000,
	max = 1,
	cmd = "buysolarconverter",
    allowed = BITCOIN_MINER,
	category = "Bitcoin Mining"
})

DarkRP.createEntity("Solar Panel", {
	ent = "bm2_solar_panel",
	model = "models/bitminers2/bm2_solar_panel.mdl",
	price = 15000,
	max = 10,
	cmd = "buysolarpanel",
    allowed = BITCOIN_MINER,
	category = "Bitcoin Mining"
})

-- Money Printer Job --

DarkRP.createEntity( "OP Printer", {
    ent = "oneprint",
    model = "models/ogl/ogl_oneprint.mdl",
    price = 55000,
    max = 3,
	allowed = MONEY_PRINTER,
    cmd = "oneprint",
	category = "Money Printer"
})
-- Oil Refiner Job --

DarkRP.createEntity("Build Kit", {
    ent = "zrush_machinecrate",
    model = "models/zerochain/props_oilrush/zor_machinecrate.mdl",
    price = 250,
    max = 8,
    cmd = "buyzrushmachinecrate",
    allowed = OIL_REFINER,
    category = "Oil Refiner"
})

DarkRP.createEntity("Barrel", {
    ent = "zrush_barrel",
    model = "models/zerochain/props_oilrush/zor_barrel.mdl",
    price = 100,
    max = 10,
    cmd = "buyzrushbarrel",
    allowed = OIL_REFINER,
    category = "Oil Refiner"
})

DarkRP.createEntity("10x Pipes", {
    ent = "zrush_drillpipe_holder",
    model = "models/zerochain/props_oilrush/zor_drillpipe_holder.mdl",
    price = 100,
    max = 10,
    cmd = "buyzrushdrillpipeholder",
    allowed = OIL_REFINER,
    category = "Oil Refiner"
})

DarkRP.createEntity("Palette", {
    ent = "zrush_palette",
    model = "models/props_junk/wood_pallet001a.mdl",
    price = 100,
    max = 2,
    cmd = "buyzrush_palette",
    allowed = OIL_REFINER,
    category = "Oil Refiner"
})

-- Mining Job --

DarkRP.createEntity("Gravel - Crate", {
	ent = "zrms_gravelcrate",
	model = "models/zerochain/props_mining/zrms_refiner_basket.mdl",
	price = 250,
	max = 6,
	cmd = "buyzrms_gravelcrate",
	allowed = MINER,
	category = "Mining Gear"
})

DarkRP.createEntity("Refiner - Crate", {
	ent = "zrms_basket",
	model = "models/zerochain/props_mining/zrms_refiner_basket.mdl",
	price = 250,
	max = 12,
	cmd = "buyzrms_basket",
	allowed = MINER,
	category = "Mining Gear"
})

DarkRP.createEntity("Storage Crate", {
	ent = "zrms_storagecrate",
	model = "models/zerochain/props_mining/zrms_storagecrate.mdl",
	price = 25,
	max = 6,
	cmd = "buyzrms_storagecrate",
	allowed = MINER,
	category = "Mining Gear"
})

DarkRP.createEntity("Mine Entrance", {
	ent = "zrms_mineentrance_base",
	model = "models/zerochain/props_mining/mining_entrance.mdl",
	price = 150000,
	max = 3,
	cmd = "buyzrms_mineentrance_base",
	allowed = MINER,
	category = "Mining Gear"
})

DarkRP.createEntity("Melter", {
	ent = "zrms_melter",
	model = "models/zerochain/props_mining/zrms_melter.mdl",
	price = 7500,
	max = 2,
	cmd = "buyzrms_melter",
	allowed = MINER,
	category = "Mining Gear"
})

-- Meth Job --

DarkRP.createEntity("Combiner", {
	ent = "zmlab_combiner",
	model = "models/zerochain/zmlab/zmlab_combiner.mdl",
	price = 6000,
	max = 1,
	cmd = "buycombiner_zmlab",
	allowed = METH_COOK,
	category = "Meth Manufacturing"
})

DarkRP.createEntity("Gas Filter", {
	ent = "zmlab_filter",
	model = "models/zerochain/zmlab/zmlab_filter.mdl",
	price = 1000,
	max = 2,
	cmd = "buyfilter_zmlab",
	allowed = METH_COOK,
	category = "Meth Manufacturing"
})

DarkRP.createEntity("Frezzer", {
	ent = "zmlab_frezzer",
	model = "models/zerochain/zmlab/zmlab_frezzer.mdl",
	price = 2000,
	max = 2,
	cmd = "buyfrezzer_zmlab",
	allowed = METH_COOK,
	category = "Meth Manufacturing"
})

DarkRP.createEntity("Transport Crate", {
	ent = "zmlab_collectcrate",
	model = "models/zerochain/zmlab/zmlab_transportcrate.mdl",
	price = 250,
	max = 5,
	cmd = "buycollectcrate_zmlab",
	allowed = METH_COOK,
	category = "Meth Manufacturing"
})

DarkRP.createEntity("Methylamin", {
	ent = "zmlab_methylamin",
	model = "models/zerochain/zmlab/zmlab_methylamin.mdl",
	price = 1000,
	max = 6,
	cmd = "buymethylamin_zmlab",
	allowed = METH_COOK,
	category = "Meth Manufacturing"
})

DarkRP.createEntity("Aluminium", {
	ent = "zmlab_aluminium",
	model = "models/zerochain/zmlab/zmlab_aluminiumbox.mdl",
	price = 100,
	max = 6,
	cmd = "buyaluminium_zmlab",
	allowed = METH_COOK,
	category = "Meth Manufacturing"
})

DarkRP.createEntity("Transport Palette", {
	ent = "zmlab_palette",
	model = "models/props_junk/wood_pallet001a.mdl",
	price = 100,
	max = 3,
	cmd = "buypalette_zmlab",
	allowed = METH_COOK,
	category = "Meth Manufacturing"
})
