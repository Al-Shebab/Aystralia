-- Add all categories and DarkRP entities here automatically.

function SH_COCAINE_DarkRPAdds()
	-- Categories
	DarkRP.createCategory{
		name = "Cocaine Factory",
		categorises = "entities",
		startExpanded = true,
		color = Color(0, 107, 0, 255),
        canSee = function(ply) return table.HasValue({TEAM_COCAINE_DEALER}, ply:Team()) end,
		sortOrder = 13,
	}
	
	DarkRP.createCategory{
		name = "Cocaine Factory",
		categorises = "weapons",
		startExpanded = true,
		color = Color(0, 107, 0, 255),
        canSee = function(ply) return table.HasValue({TEAM_COCAINE_DEALER}, ply:Team()) end,
		sortOrder = 80,
	}
	-- Entities
	DarkRP.createEntity("Water Bottle", {
        ent = "cocaine_water",
        model = "models/craphead_scripts/the_cocaine_factory/utility/water.mdl",
        price = 75,
        max = 5,
		category = "Cocaine Factory",
        cmd = "buywater",
        allowed = {TEAM_COCAINE_DEALER},
    })

    DarkRP.createEntity("Stove", {
        ent = "cocaine_stove",
        model = "models/craphead_scripts/the_cocaine_factory/stove/gas_stove.mdl",
        price = 1500,
        max = 2,
		category = "Cocaine Factory",
        cmd = "buystove",
        allowed = {TEAM_COCAINE_DEALER},
    })

    DarkRP.createEntity("Cooking Pot", {
        ent = "cocaine_cooking_pot",
        model = "models/craphead_scripts/the_cocaine_factory/utility/pot.mdl",
        price = 50,
        max = 10,
		category = "Cocaine Factory",
        cmd = "buypot",
        allowed = {TEAM_COCAINE_DEALER},
    })
	
	DarkRP.createEntity("Bucket", {
        ent = "cocaine_bucket",
        model = "models/craphead_scripts/the_cocaine_factory/utility/bucket.mdl",
        price = 75,
        max = 10,
		category = "Cocaine Factory",
        cmd = "buybucket",
        allowed = {TEAM_COCAINE_DEALER},
    })

    DarkRP.createEntity("Leaves", {
        ent = "cocaine_leaves",
        model = "models/craphead_scripts/the_cocaine_factory/utility/leaves.mdl",
        price = 50,
        max = 10,
		category = "Cocaine Factory",
        cmd = "buyleaves",
        allowed = {TEAM_COCAINE_DEALER},
    })
	
	DarkRP.createEntity("Battery", {
        ent = "cocaine_battery",
        model = "models/craphead_scripts/the_cocaine_factory/utility/battery.mdl",
        price = 150,
        max = 10,
		category = "Cocaine Factory",
        cmd = "buybattery",
        allowed = {TEAM_COCAINE_DEALER},
    })

    DarkRP.createEntity("Gas Canister", {
        ent = "cocaine_gas",
        model = "models/craphead_scripts/the_cocaine_factory/utility/gas_tank.mdl",
        price = 350,
        max = 8,
		category = "Cocaine Factory",
        cmd = "buygas",
        allowed = {TEAM_COCAINE_DEALER},
    })

    DarkRP.createEntity("Drying Rack", {
        ent = "cocaine_drying_rack",
        model = "models/craphead_scripts/the_cocaine_factory/drying_rack/drying_rack.mdl",
        price = 1500,
        max = 2,
		category = "Cocaine Factory",
        cmd = "buydryingrack",
        allowed = {TEAM_COCAINE_DEALER},
    })

    DarkRP.createEntity("Cocaine Box", {
        ent = "cocaine_box",
        model = "models/craphead_scripts/the_cocaine_factory/utility/cocaine_box.mdl",
        price = 100,
        max = 4,
		category = "Cocaine Factory",
		cmd = "buycocainebox",
        allowed = {TEAM_COCAINE_DEALER},
	})
	
	if not TCF.Config.InstallPlatesDefault then
		DarkRP.createEntity("Cooking Plate", {
			ent = "cocaine_cooking_plate",
			model = "models/craphead_scripts/the_cocaine_factory/utility/stove_upgrade.mdl",
			price = 250,
			max = 4,
			category = "Cocaine Factory",
			cmd = "buyplateupgrade",
            allowed = {TEAM_COCAINE_DEALER},
		})
	end
	
    DarkRP.createEntity("Cocaine Extractor", {
        ent = "cocaine_extractor",
        model = "models/craphead_scripts/the_cocaine_factory/extractor/extractor.mdl",
        price = 1750,
        max = 2,
		category = "Cocaine Factory",
        cmd = "buyextractor",
        allowed = {TEAM_COCAINE_DEALER},
    })

    DarkRP.createEntity("Baking Soda", {
        ent = "cocaine_baking_soda",
        model = "models/craphead_scripts/the_cocaine_factory/utility/soda.mdl",
        price = 50,
        max = 5,
		category = "Cocaine Factory",
        cmd = "buybakingsoda",
        allowed = {TEAM_COCAINE_DEALER},
    })

end
hook.Add( "loadCustomDarkRPItems", "SH_COCAINE_DarkRPAdds", SH_COCAINE_DarkRPAdds )