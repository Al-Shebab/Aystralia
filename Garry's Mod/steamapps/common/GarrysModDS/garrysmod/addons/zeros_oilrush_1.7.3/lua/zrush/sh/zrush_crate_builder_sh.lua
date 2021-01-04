zrush = zrush or {}
zrush.f = zrush.f or {}
zrush.f.MachineCrateBuilder = zrush.f.MachineCrateBuilder or {}

// Is the drillhole ready for the machine?
function zrush.f.MachineCrateBuilder.Drillhole_ReadyForMachine(drillhole, MachineID, ply)
    local ready = false

    if (drillhole:GetState() == "NEED_PIPES" and not drillhole:GetHasDrill()) then
        if (MachineID ~= "Drill") then
            if (SERVER) then
                zrush.f.Notify(ply, zrush.language.VGUI.MachineBuilder["Needsdrilledfirst"], 1)
            end
        else
            ready = true
        end
    elseif (drillhole:GetState() == "NEED_BURNER" and not drillhole:GetHasBurner()) then
        if (MachineID ~= "Burner") then
            if (SERVER) then
                zrush.f.Notify(ply, zrush.language.VGUI.MachineBuilder["NeedsBurnerquick"], 1)
            end
        else
            ready = true
        end
    elseif (drillhole:GetState() == "PUMP_READY" and not drillhole:GetHasPump()) then
        if (MachineID ~= "Pump") then
            if (SERVER) then
                zrush.f.Notify(ply, zrush.language.VGUI.MachineBuilder["NeedsPump"], 1)
            end
        else
            ready = true
        end
    else
        if (SERVER) then
            zrush.f.Notify(ply, zrush.language.VGUI.MachineBuilder["NotValidSpace"], 1)
        end
    end

    return ready
end

// Are there any DrillHoles in the way?
function zrush.f.MachineCrateBuilder.ValidDrillSpace(pos)
    local ValidSpace = true

    for k, v in pairs(ents.FindInSphere(pos, zrush.config.Machine["Drill"].NewDrillRadius)) do
        if (IsValid(v) and v:GetClass() == "zrush_drillhole") then
            ValidSpace = false
            break
        end
    end

    return ValidSpace
end

// Are there any objects in the way?
function zrush.f.MachineCrateBuilder.EnoughSpace(pos, distance)
    local FreeSpace = true

    for k, v in pairs(ents.FindInSphere(pos, distance)) do
        if (IsValid(v) and v:EntIndex() ~= -1 and v:GetClass() == "prop_physics" or v:GetClass() == "prop_dynamics" or v:GetClass() == "player" or string.sub(v:GetClass(), 1, 5) == "zrush") then
            FreeSpace = false
            break
        end
    end

    return FreeSpace
end

//Is the trace pos on the player height range?
function zrush.f.MachineCrateBuilder.ValidHeight(tr, ply)
    local validHeight = true
    local plyPos = ply:GetPos().z
    local range = 25

    if (tr.HitPos.z < (plyPos - range)) then
        validHeight = false
    elseif (tr.HitPos.z > (plyPos + range)) then
        validHeight = false
    end

    return validHeight
end

//Is the trace ang not too crazy?
function zrush.f.MachineCrateBuilder.ValidAngle(tr)
    local validAngle = true
    local HN = tr.HitNormal:Angle()
    HN:Normalize()
    local range = 45

    if (HN.p < (-0 - range) or HN.p > (0 + range)) then
        validAngle = false
    elseif (HN.y < (-90 + range) or HN.y > (90 - range)) then
        validAngle = false
    elseif (HN.r < (-0 - range) or HN.r > (0 + range)) then
        validAngle = false
    end

    return validAngle
end

// This checks if we are lookinga t a valid space for building a entity
function zrush.f.MachineCrateBuilder.ValidPos(tr, MachineID, ply, ent)
    local trEnt = tr.Entity
    local validpos = false


    if (IsValid(ent) and zrush.f.InDistance(tr.HitPos,ply:GetPos(),290) and zrush.f.InDistance(tr.HitPos,ent:GetPos(),290)) then

        //What are we trying do build?
        if (MachineID == "Drill") then
            
            // Did we hit a oilspot?
            if (IsValid(trEnt) and not tr.HitWorld and trEnt:GetClass() == "zrush_oilspot" and (zrush.config.Drill_Mode == 2 or zrush.config.Drill_Mode == 1)) then
                // Is the OilSpot not used yet?
                if (not trEnt:GetHasDrillHole()) then
                    validpos = true
                else
                    if (SERVER) then
                        zrush.f.Notify(ply, zrush.language.General["AllreadyInUse"], 1)
                    end
                end
            elseif (IsValid(trEnt) and trEnt:GetClass() == "zrush_drillhole") then
                if (not zrush.f.IsOwner(ply, trEnt)) then
                    if (SERVER) then
                        zrush.f.Notify(ply, zrush.language.General["YouDontOwnThis"], 1)
                    end

                    return
                end

                if (zrush.f.MachineCrateBuilder.Drillhole_ReadyForMachine(trEnt, "Drill", ply)) then
                    validpos = trEnt:GetPos()
                end
            elseif (tr.HitWorld and zrush.config.Drill_Mode == 0 and zrush.f.MachineCrateBuilder.ValidHeight(tr, ply)) then
                // Do we have enoguh space do build a drilltwoer here?
                if (zrush.f.MachineCrateBuilder.ValidDrillSpace(tr.HitPos) and zrush.f.MachineCrateBuilder.EnoughSpace(tr.HitPos, 30)) then
                    validpos = tr.HitPos
                else
                    if (SERVER) then
                        zrush.f.Notify(ply, zrush.language.VGUI.MachineBuilder["ToocloseDrillHole"], 1)
                    end
                end
            else
                if (SERVER) then
                    if (zrush.config.Drill_Mode == 0) then
                        zrush.f.Notify(ply, zrush.language.VGUI.MachineBuilder["CanonlybuildGround"], 1)
                    else
                        zrush.f.Notify(ply, zrush.language.VGUI.MachineBuilder["CanonlybuildOilSpots"], 1)
                    end
                end
            end
        elseif (MachineID == "Burner") then
            // Did we hit a drillhole?
            if (not tr.HitWorld and IsValid(trEnt) and trEnt:GetClass() == "zrush_drillhole") then
                // Is the Drillhole not used yet?
                if (zrush.f.MachineCrateBuilder.Drillhole_ReadyForMachine(trEnt, "Burner", ply)) then
                    validpos = true
                end
            else
                if (SERVER) then
                    zrush.f.Notify(ply, zrush.language.VGUI.MachineBuilder["CanonlybuildDrillhole"], 1)
                end
            end
        elseif (MachineID == "Pump") then
            // Did we hit a drillhole?
            if (not tr.HitWorld and IsValid(trEnt) and trEnt:GetClass() == "zrush_drillhole") then
                // Is the drillhole ready do get pumped
                if (zrush.f.MachineCrateBuilder.Drillhole_ReadyForMachine(trEnt, "Pump", ply)) then
                    validpos = true
                end
            else
                if (SERVER) then
                    zrush.f.Notify(ply, zrush.language.VGUI.MachineBuilder["CanonlybuildDrillhole"], 1)
                end
            end
        elseif (MachineID == "Refinery") then
            // Did we hit the world
            //[[zrush.f.MachineCrateBuilder.ValidAngle(tr) &&]]
            if (tr.HitWorld and zrush.f.MachineCrateBuilder.ValidHeight(tr, ply)) then
                // Add Function do make sure we have enough space
                if (zrush.f.MachineCrateBuilder.EnoughSpace(tr.HitPos, 60)) then
                    validpos = tr.HitPos
                else
                    if (SERVER) then
                        zrush.f.Notify(ply, zrush.language.VGUI.MachineBuilder["NotenoughSpace"], 1)
                    end
                end
            else
                if (SERVER) then
                    zrush.f.Notify(ply, zrush.language.VGUI.MachineBuilder["CanonlybuildGround"], 1)
                end
            end
        end
    else
        if (SERVER) then
            zrush.f.Notify(ply, zrush.language.VGUI.MachineBuilder["ConnectionLost"], 2)
        end

        validpos = false
    end

    return validpos, trEnt
end
