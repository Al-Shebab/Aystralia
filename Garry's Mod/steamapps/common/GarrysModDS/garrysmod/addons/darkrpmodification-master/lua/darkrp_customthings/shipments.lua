--[[---------------------------------------------------------------------------
DarkRP custom shipments and guns
---------------------------------------------------------------------------

This file contains your custom shipments and guns.
This file should also contain shipments and guns from DarkRP that you edited.

Note: If you want to edit a default DarkRP shipment, first disable it in darkrp_config/disabled_defaults.lua
    Once you've done that, copy and paste the shipment to this file and edit it.

The default shipments and guns can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/addentities.lua

For examples and explanation please visit this wiki page:
https://darkrp.miraheze.org/wiki/DarkRP:CustomShipmentFields


Add shipments and guns under the following line:
---------------------------------------------------------------------------]]

-- Pistols --

DarkRP.createShipment("Colt 1911", {
    model = "models/weapons/s_dmgf_co1911.mdl",
    entity = "m9k_colt1911",
    amount = 10,
    price = 40000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Pistols",
    allowed = {TEAM_GUN_DEALER}
})
DarkRP.createShipment("M92 Beretta", {
    model = "models/weapons/w_beretta_m92.mdl",
    entity = "m9k_m92beretta",
    amount = 10,
    price = 45000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Pistols",
    allowed = {TEAM_GUN_DEALER}
})
DarkRP.createShipment("HK USP", {
    model = "models/weapons/w_pist_fokkususp.mdl",
    entity = "m9k_usp",
    amount = 10,
    price = 50000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Pistols",
    allowed = {TEAM_GUN_DEALER}
})
DarkRP.createShipment("Glock 18", {
    model = "models/weapons/w_dmg_glock.mdl",
    entity = "m9k_glock",
    amount = 10,
    price = 65000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Pistols",
    allowed = {TEAM_GUN_DEALER}
})

-- Heavy Pistols --

DarkRP.createShipment("Colt Python", {
    model = "models/weapons/w_colt_python.mdl",
    entity = "m9k_coltpython",
    amount = 10,
    price = 65000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Heavy Pistols",
    allowed = {TEAM_GUN_DEALER}
})
DarkRP.createShipment("S&W Model 500", {
    model = "models/weapons/w_sw_model_500.mdl",
    entity = "m9k_model500",
    amount = 10,
    price = 75000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Heavy Pistols",
    allowed = {TEAM_GUN_DEALER}
})
DarkRP.createShipment("Desert Eagle", {
    model = "models/weapons/w_tcom_deagle.mdl",
    entity = "m9k_deagle",
    amount = 10,
    price = 80000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Heavy Pistols",
    allowed = {TEAM_GUN_DEALER}
})
DarkRP.createShipment("Raging Bull - Scoped", {
    model = "models/weapons/w_raging_bull_scoped.mdl",
    entity = "m9k_scoped_taurus",
    amount = 10,
    price = 85000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Heavy Pistols",
    allowed = {TEAM_GUN_DEALER}
})

-- SMGs --

DarkRP.createShipment("HK USC", {
    model = "models/weapons/w_hk_usc.mdl",
    entity = "m9k_usc",
    amount = 10,
    price = 90000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "SMGs",
    allowed = {TEAM_GUN_DEALER}
})
DarkRP.createShipment("UZI", {
    model = "models/weapons/w_uzi_imi.mdl",
    entity = "m9k_uzi",
    amount = 10,
    price = 100000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "SMGs",
    allowed = {TEAM_GUN_DEALER}
})
DarkRP.createShipment("Tommy Gun", {
    model = "models/weapons/w_tommy_gun.mdl",
    entity = "m9k_thompson",
    amount = 10,
    price = 110000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "SMGs",
    allowed = {TEAM_GUN_DEALER}
})
DarkRP.createShipment("MP9", {
    model = "models/weapons/w_brugger_thomet_mp9.mdl",
    entity = "m9k_mp9",
    amount = 10,
    price = 130000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "SMGs",
    allowed = {TEAM_GUN_DEALER}
})

-- Shotguns --

DarkRP.createShipment("Winchester 1897", {
    model = "models/weapons/w_winchester_1897_trench.mdl",
    entity = "m9k_1897winchester",
    amount = 10,
    price = 100000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Shotguns",
    allowed = {TEAM_STAFF_ON_DUTY}
})
DarkRP.createShipment("Benelli M3", {
    model = "models/weapons/w_benelli_m3.mdl",
    entity = "m9k_m3",
    amount = 10,
    price = 110000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Shotguns",
    allowed = {TEAM_GUN_DEALER}
})
DarkRP.createShipment("Mossberg 590", {
    model = "models/weapons/w_mossberg_590.mdl",
    entity = "m9k_mossberg590",
    amount = 10,
    price = 120000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Shotguns",
    allowed = {TEAM_GUN_DEALER}
})
DarkRP.createShipment("Browning Auto 5", {
    model = "models/weapons/w_browning_auto.mdl",
    entity = "m9k_browningauto5",
    amount = 10,
    price = 240000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Shotguns",
    allowed = {TEAM_GUN_DEALER}
})

-- Rifles --

DarkRP.createShipment("73 Winchester Carbine", {
    model = "models/weapons/w_winchester_1873.mdl",
    entity = "m9k_winchester73",
    amount = 10,
    price = 250000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Rifles",
    allowed = {TEAM_GUN_DEALER}
})
DarkRP.createShipment("M4A1", {
    model = "models/weapons/w_m4a1_iron.mdl",
    entity = "m9k_m4a1",
    amount = 10,
    price = 310000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Rifles",
    allowed = {TEAM_GUN_DEALER}
})
DarkRP.createShipment("AK-47", {
    model = "models/weapons/w_ak47_m9k.mdl",
    entity = "m9k_ak47",
    amount = 10,
    price = 350000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Rifles",
    allowed = {TEAM_GUN_DEALER}
})
DarkRP.createShipment("M16A4 ACOG", {
    model = "models/weapons/w_dmg_m16ag.mdl",
    entity = "m9k_m16a4_acog",
    amount = 10,
    price = 400000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Rifles",
    allowed = {TEAM_GUN_DEALER}
})

-- Black Market Dealer --

DarkRP.createShipment("M416", {
    model = "models/weapons/w_hk_416.mdl",
    entity = "m9k_m416",
    amount = 10,
    price = 200000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Rifles",
    allowed = {TEAM_BLACK_MARKET_DEALER}
})
DarkRP.createShipment("G36C", {
    model = "models/weapons/w_hk_g36c.mdl",
    entity = "m9k_g36",
    amount = 10,
    price = 210000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Rifles",
    allowed = {TEAM_BLACK_MARKET_DEALER}
})
DarkRP.createShipment("SCAR", {
    model = "models/weapons/w_fn_scar_h.mdl",
    entity = "m9k_scar",
    amount = 10,
    price = 210000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Rifles",
    allowed = {TEAM_BLACK_MARKET_DEALER}
})
DarkRP.createShipment("F2000", {
    model = "models/weapons/w_fn_f2000.mdl",
    entity = "m9k_f2000",
    amount = 10,
    price = 240000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Rifles",
    allowed = {TEAM_BLACK_MARKET_DEALER}
})

-- Machine Guns --

DarkRP.createShipment("FG42", {
    model = "models/weapons/w_fg42.mdl",
    entity = "m9k_fg42",
    amount = 5,
    price = 300000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Machine Guns",
    allowed = {TEAM_BLACK_MARKET_DEALER}
})
DarkRP.createShipment("M60", {
    model = "models/weapons/w_m60_machine_gun.mdl",
    entity = "m9k_m60",
    amount = 5,
    price = 450000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Machine Guns",
    allowed = {TEAM_BLACK_MARKET_DEALER}
})
DarkRP.createShipment("M249", {
    model = "models/weapons/w_m249_machine_gun.mdl",
    entity = "m9k_m249lmg",
    amount = 5,
    price = 500000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Machine Guns",
    allowed = {TEAM_BLACK_MARKET_DEALER}
})

-- Snipers --

DarkRP.createShipment("M24", {
    model = "models/weapons/w_snip_m24_6.mdl",
    entity = "m9k_m24",
    amount = 5,
    price = 500000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Snipers",
    allowed = {TEAM_BLACK_MARKET_DEALER}
})
DarkRP.createShipment("Barrett M98B", {
    model = "models/weapons/w_barrett_m98b.mdl",
    entity = "m9k_m98b",
    amount = 5,
    price = 700000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Snipers",
    allowed = {TEAM_BLACK_MARKET_DEALER}
})
DarkRP.createShipment("Remington 7615P", {
    model = "models/weapons/w_remington_7615p.mdl",
    entity = "m9k_remington7615p",
    amount = 5,
    price = 750000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Snipers",
    allowed = {TEAM_BLACK_MARKET_DEALER}
})
DarkRP.createShipment("AW50", {
    model = "models/weapons/w_acc_int_aw50.mdl",
    entity = "m9k_aw50",
    amount = 5,
    price = 800000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Snipers",
    allowed = {TEAM_BLACK_MARKET_DEALER}
})

-- Explosives --

DarkRP.createShipment("Frag Grenade", {
    model = "models/weapons/w_grenade.mdl",
    entity = "m9k_m61_frag",
    amount = 1,
    price = 900000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Explosives",
    allowed = {TEAM_BLACK_MARKET_DEALER}
})
DarkRP.createShipment("Sticky Grenade", {
    model = "models/weapons/w_sticky_grenade.mdl",
    entity = "m9k_sticky_grenade",
    amount = 1,
    price = 1200000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Explosives",
    allowed = {TEAM_BLACK_MARKET_DEALER}
})
DarkRP.createShipment("Timed C4", {
    model = "models/weapons/w_sb.mdl",
    entity = "m9k_suicide_bomb",
    amount = 1,
    price = 1500000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Explosives",
    allowed = {TEAM_BLACK_MARKET_DEALER}
})
DarkRP.createShipment("M79 Grenade Launcher.", {
    model = "models/weapons/w_m79_grenadelauncher.mdl",
    entity = "m9k_m79gl",
    amount = 1,
    price = 1200000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Explosives",
    allowed = {TEAM_BLACK_MARKET_DEALER}
})
DarkRP.createShipment("Matador", {
    model = "models/weapons/w_GDCW_MATADOR_RL.mdl",
    entity = "m9k_matador",
    amount = 1,
    price = 2000000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Explosives",
    allowed = {TEAM_BLACK_MARKET_DEALER}
})
DarkRP.createShipment("RPG", {
    model = "models/weapons/w_rl7.mdl",
    entity = "m9k_rpg7",
    amount = 1,
    price = 2500000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Explosives",
    allowed = {TEAM_BLACK_MARKET_DEALER}
})

-- Drugs --

DarkRP.createShipment("Alcohol", {
    model = "models/drug_mod/alcohol_can.mdl",
    entity = "durgz_alcohol",
    amount = 10,
    price = 10000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Drugs",
    allowed = {TEAM_DRUG_DEALER},
    customCheck = function(ply) return
        table.HasValue({TEAM_DRUG_DEALER}, ply:Team())
    end,
    CustomCheckFailMsg = "",
})
DarkRP.createShipment("Aspirin", {
    model = "models/jaanus/aspbtl.mdl",
    entity = "durgz_aspirin",
    amount = 10,
    price = 25000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Drugs",
    allowed = {TEAM_DRUG_DEALER},
    customCheck = function(ply) return
        table.HasValue({TEAM_DRUG_DEALER}, ply:Team())
    end,
    CustomCheckFailMsg = "",
})
DarkRP.createShipment("Ciggies", {
    model = "models/boxopencigshib.mdl",
    entity = "durgz_cigarette",
    amount = 10,
    price = 10000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Drugs",
    allowed = {TEAM_DRUG_DEALER},
    customCheck = function(ply) return
        table.HasValue({TEAM_DRUG_DEALER}, ply:Team())
    end,
    CustomCheckFailMsg = "",
})
DarkRP.createShipment("Heroin", {
    model = "models/katharsmodels/syringe_out/syringe_out.mdl",
    entity = "durgz_heroine",
    amount = 10,
    price = 25000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Drugs",
    allowed = {TEAM_DRUG_DEALER},
    customCheck = function(ply) return
        table.HasValue({TEAM_DRUG_DEALER}, ply:Team())
    end,
    CustomCheckFailMsg = "",
})
DarkRP.createShipment("LSD Tabs", {
    model = "models/smile/smile.mdl",
    entity = "durgz_lsd",
    amount = 10,
    price = 15000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Drugs",
    allowed = {TEAM_DRUG_DEALER},
    customCheck = function(ply) return
        table.HasValue({TEAM_DRUG_DEALER}, ply:Team())
    end,
    CustomCheckFailMsg = "",
})
DarkRP.createShipment("Marijuana", {
    model = "models/katharsmodels/contraband/zak_wiet/zak_wiet.mdl",
    entity = "durgz_weed",
    amount = 10,
    price = 10000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Drugs",
    allowed = {TEAM_DRUG_DEALER},
    customCheck = function(ply) return
        table.HasValue({TEAM_DRUG_DEALER}, ply:Team())
    end,
    CustomCheckFailMsg = "",
})
DarkRP.createShipment("Methamphetamine", {
    model = "models/katharsmodels/contraband/metasync/blue_sky.mdl",
    entity = "durgz_meth",
    amount = 10,
    price = 10000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Drugs",
    allowed = {TEAM_DRUG_DEALER},
    customCheck = function(ply) return
        table.HasValue({TEAM_DRUG_DEALER}, ply:Team())
    end,
    CustomCheckFailMsg = "",
})
DarkRP.createShipment("Mushrooms", {
    model = "models/ipha/mushroom_small.mdl",
    entity = "durgz_mushroom",
    amount = 10,
    price = 10000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Drugs",
    allowed = {TEAM_DRUG_DEALER},
    customCheck = function(ply) return
        table.HasValue({TEAM_DRUG_DEALER}, ply:Team())
    end,
    CustomCheckFailMsg = "",
})
DarkRP.createShipment("PCP", {
    model = "models/marioragdoll/super mario galaxy/star/star.mdl",
    entity = "durgz_pcp",
    amount = 10,
    price = 10000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Drugs",
    allowed = {TEAM_DRUG_DEALER},
    customCheck = function(ply) return
        table.HasValue({TEAM_DRUG_DEALER}, ply:Team())
    end,
    CustomCheckFailMsg = "",
})
DarkRP.createShipment("Water", {
    model = "models/drug_mod/the_bottle_of_water.mdl",
    entity = "durgz_water",
    amount = 10,
    price = 5000,
    separate = false,
    pricesep = 0,
    noship = false,
    category = "Drugs",
    allowed = {TEAM_DRUG_DEALER},
    customCheck = function(ply) return
        table.HasValue({TEAM_DRUG_DEALER}, ply:Team())
    end,
    CustomCheckFailMsg = "",
})