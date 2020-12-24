if (not SERVER) then return end
zfs = zfs or {}
zfs.f = zfs.f or {}

function zfs.f.PublicEnts_Save(ply)
    if not file.Exists("zfs", "DATA") then
        file.CreateDir("zfs")
    end

    local data = {}

    for k, v in pairs(zfs.EntList) do
        if IsValid(v) and v:GetClass() == "zfs_shop" and zfs.f.IsOwner(ply, v) then
            table.insert(data, {
                class = v:GetClass(),
                pos = v:GetPos(),
                ang = v:GetAngles()
            })
        end
    end

    if data and table.Count(data) > 0 then
        file.Write("zfs/" .. game.GetMap() .. "_FruitSlicers" .. ".txt", util.TableToJSON(data))
        zfs.f.Notify(ply, "The FruitSlicer Entities have been saved for the map " .. game.GetMap() .. "!", 0)

        zfs.f.PublicEnts_LoadAfterSave()
    end
end

function zfs.f.PublicEnts_LoadAfterSave()
    for k, v in pairs(zfs.EntList) do
        if IsValid(v) and v:GetClass() == "zfs_shop" then
            v:Remove()
        end
    end

    zfs.f.PublicEnts_Load()
end

function zfs.f.PublicEnts_Load()
    local path = "zfs/" .. game.GetMap() .. "_fruitslicers" .. ".txt"

    if file.Exists(path, "DATA") then
        local data = file.Read(path, "DATA")
        data = util.JSONToTable(data)

        if data and table.Count(data) > 0 then

            for k, v in pairs(data) do

                local ent = ents.Create(v.class)
                ent:SetPos(v.pos)
                ent:SetAngles(v.ang)
                ent:Spawn()
                ent:SetPublicEntity(true)

                local phys = ent:GetPhysicsObject()
                if IsValid(phys) then
                    phys:Wake()
                    phys:EnableMotion(false)
                end

                timer.Simple(1.3, function()
                    if IsValid(ent) then
                        zfs.f.Shop_action_Enable(ent)
                    end
                end)
            end

            print("[Zeros FruitSlicer] Finished loading FruitSlicer entities.")
        else
            print("[Zeros FruitSlicer] No map data found for FruitSlicer entities.")
        end
    else
        print("[Zeros FruitSlicer] No map data found for FruitSlicer entities.")
    end
end

hook.Add("InitPostEntity", "a_zfs_PublicEnts_OnMapLoad", zfs.f.PublicEnts_Load)
hook.Add("PostCleanupMap", "a_zfs_PublicEnts_PostCleanUp", zfs.f.PublicEnts_Load)

concommand.Add("zfs_saveents", function(ply, cmd, args)
    if zfs.f.IsAdmin(ply) then
        zfs.f.PublicEnts_Save(ply)
    else
        zfs.f.Notify(ply, "You do not have permission to perform this action, please contact an admin.", 1)
    end
end)

hook.Add("PlayerSay", "a_zfs_PlayerSay_Save", function(ply, text)
    if string.sub(string.lower(text), 1, 8) == "!savezfs" then
        if zfs.f.IsAdmin(ply) then
            zfs.f.PublicEnts_Save(ply)
        else
            zfs.f.Notify(ply, "You do not have permission to perform this action, please contact an admin.", 1)
        end
    end
end)
