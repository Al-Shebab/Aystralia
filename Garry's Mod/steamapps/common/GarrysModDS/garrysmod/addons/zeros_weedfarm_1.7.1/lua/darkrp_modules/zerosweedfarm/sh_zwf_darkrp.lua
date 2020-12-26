TEAM_ZWF_WEEDGROWER = DarkRP.createJob("Weed Grower", {
    color = Color(225, 75, 75, 255),
    model = {"models/player/group03/male_04.mdl"},
    description = [[You grow and sell dank weed.]],
    weapons = {"zwf_shoptablet", "zwf_cable", "zwf_wateringcan"},
    command = "zwf_weedgrower",
    max = 2,
    salary = 0,
    admin = 0,
    vote = false,
    category = "Gangsters",
    hasLicense = false,
})

DarkRP.createCategory{
    name = "Weed Grower",
    categorises = "entities",
    startExpanded = true,
    color = Color(255, 107, 0, 255),
    canSee = function(ply) return true end,
    sortOrder = 104
}

DarkRP.createEntity("DoobyTable", {
    ent = "zwf_doobytable",
    model = "models/zerochain/props_weedfarm/zwf_doobytable.mdl",
    price = 5000,
    max = 1,
    cmd = "buyzwf_doobytable",
    allowed = {TEAM_ZWF_WEEDGROWER},
    category = "Weed Grower"
})

DarkRP.createEntity("Mixer", {
    ent = "zwf_mixer",
    model = "models/zerochain/props_weedfarm/zwf_mixer.mdl",
    price = 5000,
    max = 1,
    cmd = "buyzwf_mixer",
    allowed = {TEAM_ZWF_WEEDGROWER},
    category = "Weed Grower"
})

DarkRP.createEntity("Oven", {
    ent = "zwf_oven",
    model = "models/zerochain/props_weedfarm/zwf_oven.mdl",
    price = 5000,
    max = 1,
    cmd = "buyzwf_oven",
    allowed = {TEAM_ZWF_WEEDGROWER},
    category = "Weed Grower"
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
    allowed = {TEAM_ZWF_WEEDGROWER},
    category = "Weed Grower",
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
    allowed = {TEAM_ZWF_WEEDGROWER},
    category = "Weed Grower",
    spawn = function(ply, tr, tblEnt)
        return  Spawn_BackMix(2,ply,tr)
    end
})

// If you dont want to use the tablet swep then you can enable this instead and remove the swep from the player.
/*
// Equipment
DarkRP.createEntity("Autopacker", {
    ent = "zwf_autopacker",
    model = "models/zerochain/props_weedfarm/zwf_autopacker.mdl",
    price = 10000,
    max = 1,
    cmd = "buyzwf_autopacker",
    allowed = {TEAM_ZWF_WEEDGROWER},
    category = "Weed Grower"
})
DarkRP.createEntity("Fan", {
    ent = "zwf_ventilator",
    model = "models/zerochain/props_weedfarm/zwf_ventilator01.mdl",
    price = 3000,
    max = 3,
    cmd = "buyzwf_ventilator",
    allowed = {TEAM_ZWF_WEEDGROWER},
    category = "Weed Grower"
})
DarkRP.createEntity("Powerstrip", {
    ent = "zwf_outlet",
    model = "models/zerochain/props_weedfarm/zwf_outlets.mdl",
    price = 300,
    max = 2,
    cmd = "buyzwf_outlet",
    allowed = {TEAM_ZWF_WEEDGROWER},
    category = "Weed Grower"
})
DarkRP.createEntity("Flowerpot", {
    ent = "zwf_pot",
    model = "models/zerochain/props_weedfarm/zwf_pot01.mdl",
    price = 300,
    max = 10,
    cmd = "buyzwf_pot",
    allowed = {TEAM_ZWF_WEEDGROWER},
    category = "Weed Grower"
})
DarkRP.createEntity("Hydro Flowerpot", {
    ent = "zwf_pot_hydro",
    model = "models/zerochain/props_weedfarm/zwf_pot02.mdl",
    price = 500,
    max = 10,
    cmd = "buyzwf_pot_hydro",
    allowed = {TEAM_ZWF_WEEDGROWER},
    category = "Weed Grower"
})
DarkRP.createEntity("Soil", {
    ent = "zwf_soil",
    model = "models/zerochain/props_weedfarm/zwf_soil.mdl",
    price = 300,
    max = 10,
    cmd = "buyzwf_soil",
    allowed = {TEAM_ZWF_WEEDGROWER},
    category = "Weed Grower"
})
DarkRP.createEntity("Watertank", {
    ent = "zwf_watertank",
    model = "models/zerochain/props_weedfarm/zwf_watertank.mdl",
    price = 3000,
    max = 1,
    cmd = "buyzwf_watertank",
    allowed = {TEAM_ZWF_WEEDGROWER},
    category = "Weed Grower"
})
DarkRP.createEntity("Dry Station", {
    ent = "zwf_drystation",
    model = "models/zerochain/props_weedfarm/zwf_drystation.mdl",
    price = 3000,
    max = 1,
    cmd = "buyzwf_drystation",
    allowed = {TEAM_ZWF_WEEDGROWER},
    category = "Weed Grower"
})
DarkRP.createEntity("Fuel", {
    ent = "zwf_fuel",
    model = "models/zerochain/props_weedfarm/zwf_fuel.mdl",
    price = 1000,
    max = 3,
    cmd = "buyzwf_fuel",
    allowed = {TEAM_ZWF_WEEDGROWER},
    category = "Weed Grower"
})
DarkRP.createEntity("Generator", {
    ent = "zwf_generator",
    model = "models/zerochain/props_weedfarm/zwf_generator.mdl",
    price = 5000,
    max = 1,
    cmd = "buyzwf_generator",
    allowed = {TEAM_ZWF_WEEDGROWER},
    category = "Weed Grower"
})
DarkRP.createEntity("Packing Table", {
    ent = "zwf_packingstation",
    model = "models/zerochain/props_weedfarm/zwf_packingstation.mdl",
    price = 3000,
    max = 1,
    cmd = "buyzwf_packingstation",
    allowed = {TEAM_ZWF_WEEDGROWER},
    category = "Weed Grower"
})
DarkRP.createEntity("Seed Lab", {
    ent = "zwf_splice_lab",
    model = "models/zerochain/props_weedfarm/zwf_seedlab.mdl",
    price = 5000,
    max = 1,
    cmd = "buyzwf_splice_lab",
    allowed = {TEAM_ZWF_WEEDGROWER},
    category = "Weed Grower"
})
DarkRP.createEntity("Seed Bank", {
    ent = "zwf_seed_bank",
    model = "models/zerochain/props_weedfarm/zwf_seedbank.mdl",
    price = 1000,
    max = 1,
    cmd = "buyzwf_seed_bank",
    allowed = {TEAM_ZWF_WEEDGROWER},
    category = "Weed Grower"
})
DarkRP.createEntity("Palette", {
    ent = "zwf_palette",
    model = "models/props_junk/wood_pallet001a.mdl",
    price = 250,
    max = 2,
    cmd = "buyzwf_palette",
    allowed = {TEAM_ZWF_WEEDGROWER},
    category = "Weed Grower"
})


// Lamps
local function Spawn_Lamp(id,ply,tr)
    local lamp = ents.Create("zwf_lamp")
    lamp:SetPos(tr.HitPos)
    lamp:Spawn()
    lamp:Activate()
    zwf.f.SetOwner(lamp, ply)
    lamp:SetLampID(id)
    lamp:SetModel(zwf.config.Lamps[id].model)
    return lamp
end
DarkRP.createEntity("Sodium Lamp", {
    ent = "zwf_lamp",
    model = "models/zerochain/props_weedfarm/zwf_lamp01.mdl",
    price = 3000,
    max = 6,
    cmd = "buyzwf_lamp01",
    allowed = {TEAM_ZWF_WEEDGROWER},
    category = "Weed Grower",
    spawn = function(ply, tr, tblEnt)
        return Spawn_Lamp(1,ply,tr)
    end
})
DarkRP.createEntity("LED Lamp", {
    ent = "zwf_lamp",
    model = "models/zerochain/props_weedfarm/zwf_lamp02.mdl",
    price = 5000,
    max = 6,
    cmd = "buyzwf_lamp02",
    allowed = {TEAM_ZWF_WEEDGROWER},
    category = "Weed Grower",
    spawn = function(ply, tr, tblEnt)
        return Spawn_Lamp(2,ply,tr)
    end
})

// Fertilizer
local function Spawn_Nutrition(id,ply,tr)
    local nut = ents.Create("zwf_nutrition")
    nut:SetPos(tr.HitPos)
    nut:Spawn()
    nut:Activate()
    zwf.f.SetOwner(nut, ply)
    nut:SetNutritionID(id)
    nut:SetSkin(zwf.config.Nutrition[id].skin)
    return nut
end
DarkRP.createEntity("Hyper Viper", {
    ent = "zwf_nutrition",
    model = "models/zerochain/props_weedfarm/zwf_nutritionbottle.mdl",
    price = 15000,
    max = 1,
    cmd = "buyzwf_nutrition01",
    allowed = {TEAM_ZWF_WEEDGROWER},
    category = "Weed Grower",
    spawn = function(ply, tr, tblEnt)
        return Spawn_Nutrition(1,ply,tr)
    end
})
DarkRP.createEntity("Haze of Light", {
    ent = "zwf_nutrition",
    model = "models/zerochain/props_weedfarm/zwf_nutritionbottle.mdl",
    price = 30000,
    max = 1,
    cmd = "buyzwf_nutrition02",
    allowed = {TEAM_ZWF_WEEDGROWER},
    category = "Weed Grower",
    spawn = function(ply, tr, tblEnt)
        return Spawn_Nutrition(2,ply,tr)
    end
})
DarkRP.createEntity("Fat Harvest", {
    ent = "zwf_nutrition",
    model = "models/zerochain/props_weedfarm/zwf_nutritionbottle.mdl",
    price = 15000,
    max = 1,
    cmd = "buyzwf_nutrition03",
    allowed = {TEAM_ZWF_WEEDGROWER},
    category = "Weed Grower",
    spawn = function(ply, tr, tblEnt)
        return Spawn_Nutrition(3,ply,tr)
    end
})
DarkRP.createEntity("MEGA Harvest", {
    ent = "zwf_nutrition",
    model = "models/zerochain/props_weedfarm/zwf_nutritionbottle.mdl",
    price = 30000,
    max = 1,
    cmd = "buyzwf_nutrition04",
    allowed = {TEAM_ZWF_WEEDGROWER},
    category = "Weed Grower",
    spawn = function(ply, tr, tblEnt)
        return Spawn_Nutrition(4,ply,tr)
    end
})
DarkRP.createEntity("Rapid Rabbit Mix", {
    ent = "zwf_nutrition",
    model = "models/zerochain/props_weedfarm/zwf_nutritionbottle.mdl",
    price = 30000,
    max = 1,
    cmd = "buyzwf_nutrition05",
    allowed = {TEAM_ZWF_WEEDGROWER},
    category = "Weed Grower",
    spawn = function(ply, tr, tblEnt)
        return Spawn_Nutrition(5,ply,tr)
    end
})
DarkRP.createEntity("Get Schwifty Mix", {
    ent = "zwf_nutrition",
    model = "models/zerochain/props_weedfarm/zwf_nutritionbottle.mdl",
    price = 60000,
    max = 1,
    cmd = "buyzwf_nutrition06",
    allowed = {TEAM_ZWF_WEEDGROWER},
    category = "Weed Grower",
    spawn = function(ply, tr, tblEnt)
        return Spawn_Nutrition(6,ply,tr)
    end
})






// Seeds
local function Spawn_Seed(id,ply,tr)
    local seed = ents.Create("zwf_seed")
    seed:SetPos(tr.HitPos)
    seed:Spawn()
    seed:Activate()

    zwf.f.SetOwner(seed, ply)

    seed:SetSeedID(id)

    seed:SetPerf_Time(100)
    seed:SetPerf_Amount(100)
    seed:SetPerf_THC(100)

    seed:SetSeedCount(zwf.config.Seeds.Count)

    local plantData = zwf.config.Plants[id]
    if plantData then
        seed:SetSeedName(plantData.name)
        seed:SetSkin(plantData.skin)
    end

    return seed
end
DarkRP.createEntity("OG Kush", {
    ent = "zwf_seed",
    model = "models/zerochain/props_weedfarm/zwf_weedseed.mdl",
    price = 2000,
    max = 1,
    cmd = "buyzwf_seed01",
    allowed = {TEAM_ZWF_WEEDGROWER},
    category = "Weed Grower",
    spawn = function(ply, tr, tblEnt)
        return  Spawn_Seed(1,ply,tr)
    end
})
DarkRP.createEntity("Bubba Kush", {
    ent = "zwf_seed",
    model = "models/zerochain/props_weedfarm/zwf_weedseed.mdl",
    price = 3000,
    max = 1,
    cmd = "buyzwf_seed02",
    allowed = {TEAM_ZWF_WEEDGROWER},
    category = "Weed Grower",
    spawn = function(ply, tr, tblEnt)
        return  Spawn_Seed(2,ply,tr)
    end
})
DarkRP.createEntity("Sour Diesel", {
    ent = "zwf_seed",
    model = "models/zerochain/props_weedfarm/zwf_weedseed.mdl",
    price = 5000,
    max = 1,
    cmd = "buyzwf_seed03",
    allowed = {TEAM_ZWF_WEEDGROWER},
    category = "Weed Grower",
    spawn = function(ply, tr, tblEnt)
        return  Spawn_Seed(3,ply,tr)
    end
})
DarkRP.createEntity("AK-47", {
    ent = "zwf_seed",
    model = "models/zerochain/props_weedfarm/zwf_weedseed.mdl",
    price = 6000,
    max = 1,
    cmd = "buyzwf_seed04",
    allowed = {TEAM_ZWF_WEEDGROWER},
    category = "Weed Grower",
    spawn = function(ply, tr, tblEnt)
        return  Spawn_Seed(4,ply,tr)
    end
})
DarkRP.createEntity("Super Lemon Haze", {
    ent = "zwf_seed",
    model = "models/zerochain/props_weedfarm/zwf_weedseed.mdl",
    price = 7500,
    max = 1,
    cmd = "buyzwf_seed05",
    allowed = {TEAM_ZWF_WEEDGROWER},
    category = "Weed Grower",
    spawn = function(ply, tr, tblEnt)
        return  Spawn_Seed(5,ply,tr)
    end
})
DarkRP.createEntity("Strawberry Cough", {
    ent = "zwf_seed",
    model = "models/zerochain/props_weedfarm/zwf_weedseed.mdl",
    price = 9000,
    max = 1,
    cmd = "buyzwf_seed06",
    allowed = {TEAM_ZWF_WEEDGROWER},
    category = "Weed Grower",
    spawn = function(ply, tr, tblEnt)
        return  Spawn_Seed(6,ply,tr)
    end
})
DarkRP.createEntity("Dark Devil", {
    ent = "zwf_seed",
    model = "models/zerochain/props_weedfarm/zwf_weedseed.mdl",
    price = 12000,
    max = 1,
    cmd = "buyzwf_seed07",
    allowed = {TEAM_ZWF_WEEDGROWER},
    category = "Weed Grower",
    spawn = function(ply, tr, tblEnt)
        return  Spawn_Seed(7,ply,tr)
    end
})
*/
