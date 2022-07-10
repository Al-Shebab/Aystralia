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
-- Money Printer Job --

DarkRP.createEntity( "OP Printer", {
    ent = "oneprint",
    model = "models/ogl/ogl_oneprint.mdl",
    price = 10000,
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
