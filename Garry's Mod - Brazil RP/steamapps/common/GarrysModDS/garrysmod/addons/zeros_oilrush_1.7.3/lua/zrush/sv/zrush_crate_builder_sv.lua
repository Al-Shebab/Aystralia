if (not SERVER) then return end

// This function disambles the machine into a crate
function zrush.f.MachineCrateBuilder.DeConstruct(machine)
    local tMachine = machine
    local tPlayer = zrush.f.GetOwner(tMachine)
    tMachine.Wait = true

    timer.Simple(0.1, function()
        if (IsValid(tMachine)) then
            local ent = ents.Create("zrush_machinecrate")
            local pos = tMachine:GetPos()

            if (tMachine.MachineID ~= "Refinery") then
                local hole = tMachine:GetHole()

                if (IsValid(hole)) then
                    pos = hole:GetPos()
                end
            end

            ent:SetAngles(tMachine:GetAngles())
            ent:SetPos(pos + Vector(0, 0, 50))
            ent:Spawn()
            ent:Activate()
            zrush.f.SetOwner(ent, tPlayer)

            local installedModules = zrush.f.Machine_ReturnInstalledModules(tMachine)

            // Here we add all the module info too the  crate
            zrush.f.Machinecrate_AddModules(ent, installedModules)
            ent:SetMachineID(tMachine.MachineID)
            SafeRemoveEntity(tMachine)
        end
    end)
end

util.AddNetworkString("zrush_MachineCrateOB_Place_net")

// This gets called from then machinecrate options box
net.Receive("zrush_MachineCrateOB_Place_net", function(len, ply)
    if zrush.f.NW_Player_Timeout(ply) then return end
    local ent = net.ReadEntity()

    if (IsValid(ent) and zrush.f.IsOwner(ply, ent) and ent:GetClass() == "zrush_machinecrate" and zrush.f.InDistance(ent:GetPos(), ply:GetPos(), 2000)) then
        zrush.f.MachineCrateBuilder.SelectEntity(ent, ply)
    end
end)

util.AddNetworkString("zrush_MachineCrateBuilder_SelectEntity_net")
util.AddNetworkString("zrush_MachineCrateBuilder_DeselectEntity_net")
util.AddNetworkString("zrush_MachineCrateBuilder_BuildEntity_net")

// The Selection action
function zrush.f.MachineCrateBuilder.SelectEntity(ent, ply)
    if IsValid(ent) then

        DropEntityIfHeld(ent)

        zrush.f.Machinecrate_SetCrateOccupied(ent,ply)

        zrush.f.CreateNetEffect("drill_loadpipe",ent)

        net.Start("zrush_MachineCrateBuilder_SelectEntity_net")
        net.WriteEntity(ent)
        net.Send(ply)
    end
end

// The Cancel action
net.Receive("zrush_MachineCrateBuilder_DeselectEntity_net", function(len, ply)
    if zrush.f.NW_Player_Timeout(ply) then return end
    local ent = net.ReadEntity()

    if (IsValid(ent) and zrush.f.IsOwner(ply, ent) and ent:GetClass() == "zrush_machinecrate" and zrush.f.InDistance(ent:GetPos(), ply:GetPos(), 2000)) then
        zrush.f.MachineCrateBuilder.DeselectEntity(ent, ply, zrush.language.VGUI.MachineBuilder["ConnectionLost"])
    end
end)

function zrush.f.MachineCrateBuilder.DeselectEntity(ent, ply, msg)
    if IsValid(ent) then
        zrush.f.Machinecrate_SetCrateFree(ent)
        zrush.f.Notify(ply, msg, 2)
    end
end

// The Building action
net.Receive("zrush_MachineCrateBuilder_BuildEntity_net", function(len, ply)
    if zrush.f.NW_Player_Timeout(ply) then return end
    local ent = net.ReadEntity()

    if (IsValid(ent) and zrush.f.IsOwner(ply, ent) and ent:GetClass() == "zrush_machinecrate" and zrush.f.InDistance(ent:GetPos(), ply:GetPos(), 2000)) then
        zrush.f.MachineCrateBuilder.BuildEntity(ent, ply)
    end
end)

function zrush.f.MachineCrateBuilder.BuildEntity(buildkit, ply)
    local tr = ply:GetEyeTrace()
    local machineID = buildkit:GetMachineID()
    local machineData = zrush.f.FindMachineDataByID(machineID)
    local validPos, validEnt = zrush.f.MachineCrateBuilder.ValidPos(tr, machineID, ply, buildkit)

    // Check if the player can build more from this entity!
    local entCount = 0
    for k,v in pairs(zrush.EntList) do
        if IsValid(v) and zrush.f.IsOwner(ply, v) and v:GetClass() == machineData.class then
            entCount = entCount + 1
        end
    end
    if entCount >= machineData.limit then
        zrush.f.Notify(ply, zrush.language.VGUI.MachineBuilder["MachineLimitReached"], NOTIFY_ERROR)
        return
    end


    if (validPos) then
        if (machineID == "Drill" and ply:zrush_ReturnActiveDrillHoleCount() >= zrush.config.Player.MaxActiveDrillHoles) then
            if (IsValid(validEnt)) then
                if (validEnt:GetClass() == "zrush_oilspot") then
                    zrush.f.MachineCrateBuilder.DeselectEntity(buildkit, ply, zrush.language.VGUI.MachineBuilder["ReachedMaxDrillhole"])

                    return
                end
            else
                zrush.f.MachineCrateBuilder.DeselectEntity(buildkit, ply, zrush.language.VGUI.MachineBuilder["ReachedMaxDrillhole"])

                return
            end
        end

        local ent = ents.Create(machineData.class)

        if (machineID == "Drill" and zrush.config.Drill_Mode == 0) then
            if (IsValid(validEnt)) then
                ang = validEnt:GetAngles()
                ent:SetAngles(ang)
                ent:SetPos(ent:GetPos())
            else
                ang = tr.HitNormal:Angle()
                ang:RotateAroundAxis(ang:Right(), -90)
                ang:RotateAroundAxis(ang:Up(), 90)
                ent:SetAngles(ang)
                ent:SetPos(validPos)
            end
        elseif (machineID == "Refinery") then
            ang = Angle(0, ply:EyeAngles().y + -90, 0)
            ent:SetAngles(ang)
            ent:SetPos(validPos)
        else
            ang = validEnt:GetAngles()
            ent:SetAngles(ang)
            ent:SetPos(validEnt:GetPos())
        end

        ent:Spawn()
        ent:Activate()

        zrush.f.CreateNetEffect("action_building",buildkit)
        zrush.f.CreateNetEffect("drill_loadpipe",buildkit)

        zrush.f.SetOwner(ent, ply)

        //Add function that adds modules too the machine
        if (buildkit.InstalledModules) then
            for k, v in pairs(buildkit.InstalledModules) do
                local freeSocket = zrush.f.Machine_SearchFreeSocket(ent)

                if (freeSocket) then
                    zrush.f.Machine_AddModule(v, ent, freeSocket)
                end
            end
        end

        SafeRemoveEntity(buildkit)

        if (machineID == "Drill") then
            timer.Simple(0.1, function()
                if IsValid(ent) then
                    if (IsValid(validEnt) and validEnt:GetClass() == "zrush_oilspot") then
                        zrush.f.DrillTower_DrillHole_SnapSetup(ent,validEnt,ply)
                    elseif (IsValid(validEnt) and validEnt:GetClass() == "zrush_drillhole") then
                        zrush.f.DrillTower_SnapTower(ent,ply, validEnt)
                    elseif (zrush.config.Drill_Mode == 0) then
                        zrush.f.DrillTower_DrillHole_TraceSetup(ent,ply)
                    end
                end
            end)
        elseif (machineID == "Burner") then
            timer.Simple(0.1, function()
                if IsValid(ent) and IsValid(validEnt) then
                    zrush.f.Burner_AttachBurner(ent,validEnt)
                end
            end)
        elseif (machineID == "Pump") then
            timer.Simple(0.1, function()
                if IsValid(ent) and IsValid(validEnt) then
                    zrush.f.Pump_PlacePump(ent,validEnt)
                end
            end)
        elseif (machineID == "Refinery") then
            timer.Simple(0.1, function()
                if IsValid(ent) then
                    zrush.f.Refinery_Place(ent)
                end
            end)
        end
    else
        zrush.f.Machinecrate_SetCrateFree(buildkit)
    end
end
