if (not SERVER) then return end
zrush = zrush or {}
zrush.f = zrush.f or {}

function zrush.f.PublicEnts_Save(ply)
    if not file.Exists("zrush", "DATA") then
        file.CreateDir("zrush")
    end

    if (zrush.config.Drill_Mode == 1) then
        local data = {}

        for u, j in pairs(ents.FindByClass("zrush_oilspot")) do
            table.insert(data, {
                class = j:GetClass(),
                pos = j:GetPos(),
                ang = j:GetAngles()
            })
        end

        file.Write("zrush/" .. string.lower( game.GetMap() ) .. "_oilspots" .. ".txt", util.TableToJSON(data))
        zrush.f.Notify(ply, "The OilSpots have been saved for the map " .. string.lower( game.GetMap() ) .. "!", 0)
    elseif (zrush.config.Drill_Mode == 2) then
        local data = {}

        for u, j in pairs(ents.FindByClass("zrush_oilspot_generator")) do
            table.insert(data, {
                class = j:GetClass(),
                pos = j:GetPos(),
                ang = j:GetAngles(),
                radius = j:GetSpawnRadius()
            })
        end

        file.Write("zrush/" .. string.lower( game.GetMap() ) .. "_oilspotgenerators" .. ".txt", util.TableToJSON(data))
        zrush.f.Notify(ply, "The OilSpot Generators have been saved for the map " .. string.lower( game.GetMap() ) .. "!", 0)
    end

    local data = {}

    for u, j in pairs(ents.FindByClass("zrush_fuelbuyer_npc")) do
        table.insert(data, {
            class = j:GetClass(),
            pos = j:GetPos(),
            ang = j:GetAngles()
        })
    end

    file.Write("zrush/" .. string.lower( game.GetMap() ) .. "_fuelbuyernpc" .. ".txt", util.TableToJSON(data))
    zrush.f.Notify(ply, "The NPC entities have been saved for the map " .. string.lower( game.GetMap() ) .. "!", 0)
end


function zrush.f.PublicEnts_Load()
    if (zrush.config.Drill_Mode == 1) then
        local path = "zrush/" .. string.lower( game.GetMap() ) .. "_oilspots" .. ".txt"

        if file.Exists(path, "DATA") then
            local data = file.Read(path, "DATA")
            data = util.JSONToTable(data)

            for k, v in pairs(data) do
                local ent = ents.Create(v.class)
                ent:SetPos(v.pos)
                ent:SetAngles(v.ang)
                ent:Spawn()
                local phys = ent:GetPhysicsObject()

                if (phys:IsValid()) then
                    phys:Wake()
                    phys:EnableMotion(false)
                end
            end

            print("[Zeros OilRush] Finished loading OilSpots entities.")
        else
            print("[Zeros OilRush] No map data found for OilSpots entities.")
        end
    elseif (zrush.config.Drill_Mode == 2) then
        local path = "zrush/" .. string.lower( game.GetMap() ) .. "_oilspotgenerators" .. ".txt"

        if file.Exists(path, "DATA") then
            local data = file.Read(path, "DATA")
            data = util.JSONToTable(data)

            for k, v in pairs(data) do
                local ent = ents.Create(v.class)
                ent:SetPos(v.pos)
                ent:SetAngles(v.ang)
                ent:Spawn()
                ent:SetSpawnRadius(v.radius)
                local phys = ent:GetPhysicsObject()
                // 164285642
                if (phys:IsValid()) then
                    phys:Wake()
                    phys:EnableMotion(false)
                end
            end

            print("[Zeros OilRush] Finished loading OilSpot Generator entities.")
        else
            print("[Zeros OilRush] No map data found for OilSpot Generator entities.")
        end
    end

    local path = "zrush/" .. string.lower( game.GetMap() ) .. "_fuelbuyernpc" .. ".txt"

    if file.Exists(path, "DATA") then
        local data = file.Read(path, "DATA")
        data = util.JSONToTable(data)

        for k, v in pairs(data) do
            local ent = ents.Create(v.class)
            ent:SetPos(v.pos)
            ent:SetAngles(v.ang)
            ent:Spawn()
        end

        print("[Zeros OilRush] Finished loading FuelBuyer entities.")
    else
        print("[Zeros OilRush] No map data found for FuelBuyer entities.")
    end
end
timer.Simple(0,function()
    zrush.f.PublicEnts_Load()
end)
hook.Add("PostCleanupMap", "a.zrush.PostCleanupMap.PublicEnts_PostCleanUp", zrush.f.PublicEnts_Load)


function zrush.f.PublicEnts_Remove(ply)
    for k, v in pairs(ents.FindByClass("zrush_oilspot")) do
        if IsValid(v) then
            SafeRemoveEntity(v)
        end
    end

    if file.Exists("zrush/" .. string.lower(game.GetMap()) .. "_oilspots" .. ".txt", "DATA") then
        file.Delete("zrush/" .. string.lower(game.GetMap()) .. "_oilspots" .. ".txt")
    end

    for k, v in pairs(ents.FindByClass("zrush_oilspot_generator")) do
        if IsValid(v) then
            SafeRemoveEntity(v)
        end
    end

    if file.Exists("zrush/" .. string.lower(game.GetMap()) .. "_oilspotgenerators" .. ".txt", "DATA") then
        file.Delete("zrush/" .. string.lower(game.GetMap()) .. "_oilspotgenerators" .. ".txt")
    end

    for k, v in pairs(ents.FindByClass("zrush_fuelbuyer_npc")) do
        if IsValid(v) then
            SafeRemoveEntity(v)
        end
    end

    if file.Exists("zrush/" .. string.lower(game.GetMap()) .. "_fuelbuyernpc" .. ".txt", "DATA") then
        file.Delete("zrush/" .. string.lower(game.GetMap()) .. "_fuelbuyernpc" .. ".txt")
    end

    zrush.f.Notify(ply, "The NPC & OilsSpots / Generators have been removed for the map " .. string.lower(game.GetMap()) .. "!", 0)
end


concommand.Add("zrush_publicents_save", function(ply, cmd, args)
    if zrush.f.IsAdmin(ply) then
        zrush.f.PublicEnts_Save(ply)
    else
        zrush.f.Notify(ply, "You do not have permission to perform this action, please contact an admin.", 1)
    end
end)

concommand.Add("zrush_publicents_remove", function(ply, cmd, args)
    if zrush.f.IsAdmin(ply) then
        zrush.f.PublicEnts_Remove(ply)
    else
        zrush.f.Notify(ply, "You do not have permission to perform this action, please contact an admin.", 1)
    end
end)

hook.Add("PlayerSay", "a.zrush.PlayerSay.savezrush", function(ply, text)
    if string.sub(string.lower(text), 1, 10) == "!savezrush" then
        if zrush.f.IsAdmin(ply) then
            zrush.f.PublicEnts_Save(ply)
        else
            zrush.f.Notify(ply, "You do not have permission to perform this action, please contact an admin.", 1)
        end
    end
end)
