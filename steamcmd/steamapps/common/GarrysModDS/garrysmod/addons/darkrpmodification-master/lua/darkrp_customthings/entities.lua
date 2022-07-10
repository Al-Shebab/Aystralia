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

-- Meth --

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
