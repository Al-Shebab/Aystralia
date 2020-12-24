TEAM_ZRUSH_FUELPRODUCER = DarkRP.createJob("Fuel Refiner", {
    color = Color(225, 75, 75, 255),
    model = {"models/player/group03/male_04.mdl"},
    description = [[You are making Fuel!]],
    weapons = {},
    command = "zrush_fuelrefiner",
    max = 4,
    salary = 15,
    admin = 0,
    vote = false,
    category = "Citizens",
    hasLicense = false
})

DarkRP.createCategory{
    name = "FuelRefiner",
    categorises = "entities",
    startExpanded = true,
    color = Color(255, 107, 0, 255),
    canSee = function(ply) return true end,
    sortOrder = 104
}

DarkRP.createEntity("BuildKit", {
    ent = "zrush_machinecrate",
    model = "models/zerochain/props_oilrush/zor_machinecrate.mdl",
    price = 250,
    max = 8,
    cmd = "buyzrushmachinecrate",
    allowed = TEAM_ZRUSH_FUELPRODUCER,
    category = "FuelRefiner"
})

DarkRP.createEntity("Barrel", {
    ent = "zrush_barrel",
    model = "models/zerochain/props_oilrush/zor_barrel.mdl",
    price = 100,
    max = 10,
    cmd = "buyzrushbarrel",
    allowed = TEAM_ZRUSH_FUELPRODUCER,
    category = "FuelRefiner"
})

DarkRP.createEntity("10x Pipes", {
    ent = "zrush_drillpipe_holder",
    model = "models/zerochain/props_oilrush/zor_drillpipe_holder.mdl",
    price = 100,
    max = 10,
    cmd = "buyzrushdrillpipeholder",
    allowed = TEAM_ZRUSH_FUELPRODUCER,
    category = "FuelRefiner"
})

DarkRP.createEntity("Palette", {
    ent = "zrush_palette",
    model = "models/props_junk/wood_pallet001a.mdl",
    price = 100,
    max = 2,
    cmd = "buyzrush_palette",
    allowed = TEAM_ZRUSH_FUELPRODUCER,
    category = "FuelRefiner"
})
