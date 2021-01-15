if not SERVER then return end
zrmine = zrmine or {}
zrmine.f = zrmine.f or {}

// Here are some Hooks you can use for Custom Code

// Overrides the entity limit of the builder swep, entity_class tells you what entitiy the player is trying to build
// This piece of code should be called on both server and client so make sure you move it out of here and somewhere else
hook.Add("zrmine_OverrideEntityLimit", "zrmine_OverrideEntityLimit_test", function(ply,entity_class)

    if ply:IsSuperAdmin() then
        return 10
    end
end)


// Called when the player hits a ore entity
hook.Add("zrmine_OnPickaxeHit", "zrmine_OnPickaxeHit_Vrondakis", function(ply, HitPos, OreEntity)
    if IsValid(ply) and (LevelSystemConfiguration or manolis) then
        ply:addXP(zrmine.config.Vrondakis["Mining_pickaxe"].XP, " ", true)
    end
end)

// Gets called when the player receives xp points for his pickaxe
// This is usefull if you want to modify the XP amount for individual players
hook.Add("zrmine_XPModify", "zrmine_zrmine_OnXPGain_Modifier", function(ply, xp)

    local Final_XP = xp

    // Double points if the players steam id matches with this one
    if IsValid(ply) and ply:SteamID64() == "76561198013322242" then
        Final_XP = xp * 2
    end

    return Final_XP
end)


// Call when a Mine Entrance produces ore entities
// *Note* The player variable can be nil if the MineEntrance is public
hook.Add("zrmine_OnOreMined", "zrmine_OnOreMined_Vrondakis", function(ply, MineEntity)
    if IsValid(ply) and (LevelSystemConfiguration or manolis) then
        ply:addXP(zrmine.config.Vrondakis["Mining_mine"].XP, " ", true)
    end
end)

// Called when Ore gets Crushed
hook.Add("zrmine_OnOreCrushing", "zrmine_OnOreCrushing_Vrondakis", function(ply, Crusher, OreType, OreAmount)
    if IsValid(ply) and (LevelSystemConfiguration or manolis) then
        ply:addXP(zrmine.config.Vrondakis["Crushing"].XP, " ", true)
    end
end)

// Called when a refinery refines ore
hook.Add("zrmine_OnOreRefined", "zrmine_OnOreRefined_Vrondakis", function(ply, Refinery, OreType, OreAmount)
    if IsValid(ply) and (LevelSystemConfiguration or manolis) then
        ply:addXP(zrmine.config.Vrondakis["Refining"].XP, " ", true)
    end
end)

// Called when the player produces metal bars
hook.Add("zrmine_OnMelting", "zrmine_OnMelting_Vrondakis", function(ply, Melter, BarType)
    if IsValid(ply) and (LevelSystemConfiguration or manolis) then
        ply:addXP(zrmine.config.Vrondakis["Melting"].XP, " ", true)
    end
end)

// Called when the player produces metal bars
hook.Add("zrmine_OnSelling", "zrmine_OnMelting_Vrondakis", function(ply, BuyerNPC, SellProfit, MetalBarsTable, Earnings)
    if IsValid(ply) and (LevelSystemConfiguration or manolis) then
        ply:addXP(zrmine.config.Vrondakis["Selling"].XP, " ", true)
    end
end)
