if CLIENT then return end
zrush = zrush or {}
zrush.f = zrush.f or {}

// Called when the Burner entity burned one Gas Unit
hook.Add("zrush_OnGasBurned", "zrush_OnGasBurned_Test", function(Burner, BurnAmount)
    //Vrondakis
    if (zrush.config.VrondakisLevelSystem) then
        local ply = zrush.f.GetOwner(Burner)

        if IsValid(ply) then
            ply:addXP(zrush.config.Vrondakis["BurningGas"].XP * BurnAmount, " ", true)
        end
    end
end)

// Called when the Burner entity finished burning all the Gas
hook.Add("zrush_OnGasBurnedFinished", "zrush_OnGasBurnedFinished_Test", function(Burner)
    //Vrondakis
    if zrush.config.VrondakisLevelSystem then
        local ply = zrush.f.GetOwner(Burner)

        if IsValid(ply) then
            ply:addXP(zrush.config.Vrondakis["ReachingOil"].XP, " ", true)
        end
    end
end)

// Called when the Drilltower finished one Pipe
hook.Add("zrush_OnPipeDrilled", "zrush_OnPipeDrilled_Test", function(DrillHole)
    //Vrondakis
    if zrush.config.VrondakisLevelSystem then
        local ply = zrush.f.GetOwner(DrillHole)

        if IsValid(ply) then
            ply:addXP(zrush.config.Vrondakis["DrillingPipe"].XP, " ", true)
        end
    end
end)

// Called when the Pump pumps oil
hook.Add("zrush_OnOilPumped", "zrush_OnOilPumped_Test", function(Pump, Amount)
    //Vrondakis
    if zrush.config.VrondakisLevelSystem then
        local ply = zrush.f.GetOwner(Pump)

        if IsValid(ply) then
            ply:addXP(zrush.config.Vrondakis["PumpingOil"].XP * Amount, " ", true)
        end
    end
end)

// Called when the Refinery refines fuel
hook.Add("zrush_OnFuelRefined", "zrush_OnFuelRefined_Test", function(Refinery, FuelAmount,FuelID)
    //Vrondakis
    if zrush.config.VrondakisLevelSystem then
        local ply = zrush.f.GetOwner(Refinery)

        if IsValid(ply) then
            ply:addXP(zrush.config.Vrondakis["RefiningOil"].XP * FuelAmount, " ", true)
        end
    end
end)

// Called when the Player sells fuel
hook.Add("zrush_OnFuelSold", "zrush_OnFuelSold_Test", function(ply, FuelAmount, FuelID, Earning, FuelBuyer)
    //Vrondakis
    if zrush.config.VrondakisLevelSystem then
        ply:addXP(zrush.config.Vrondakis["Selling"].XP * FuelAmount, " ", true)
    end
end)
