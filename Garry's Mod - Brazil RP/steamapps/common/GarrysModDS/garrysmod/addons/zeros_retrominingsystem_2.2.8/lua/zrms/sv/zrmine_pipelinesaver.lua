if not SERVER then return end
zrmine = zrmine or {}
zrmine.f = zrmine.f or {}

local PipeLineEnts = {"zrms_crusher", "zrms_conveyorbelt_n", "zrms_conveyorbelt_s", "zrms_conveyorbelt_c_left", "zrms_conveyorbelt_c_right",
     "zrms_refiner_iron", "zrms_refiner_bronze", "zrms_refiner_coal", "zrms_refiner_silver", "zrms_refiner_gold"
 }

 zrms_Pipeline_Data = {}


// Used do find the connected Entity for most modules
local function FindConnectedEntByID(id, table)
    local foundEnt = nil

    for k, v in pairs(table) do
        if (v.PipeLine_ID == id) then
            foundEnt = v
            break
        end
    end

    return foundEnt
end

local function SaveMultiConnect(ply, ent)
    local dataTable = {}

    local connectedEnt01 = ent:GetModuleChild01()
    local connectedEnt02 = ent:GetModuleChild02()
    local connectedID01 = -1
    local connectedID02 = -1

    if (IsValid(connectedEnt01)) then
        connectedID01 = connectedEnt01:EntIndex()
    end

    if (IsValid(connectedEnt02)) then
        connectedID02 = connectedEnt02:EntIndex()
    end

    ent.IsPipeLineEntity = true
    ent:SetNWString("zrmine_Owner", "world")

    dataTable = {
        class = ent:GetClass(),
        pos = ent:GetPos(),
        ang = ent:GetAngles(),
        id = ent:EntIndex(),
        coID01 = connectedID01,
        coID02 = connectedID02
    }

    return dataTable
end

local function SaveAllMultiConnect(ply,class)
    for k, v in pairs(zrmine.EntList) do
        if (IsValid(v) and v:GetClass() == class and (v.IsPipeLineEntity or zrmine.f.IsOwner(ply, v))) then

            local aTable = SaveMultiConnect(ply, v)

            if table.Count(aTable) > 0 then
                table.insert(zrms_Pipeline_Data, aTable)
            end
        end
    end
end

// Here we build our PipeLine Table
function zrmine.f.PipeLine_Build(ply)

    zrms_Pipeline_Data = {}

    for k, v in pairs(zrmine.EntList) do
        if (IsValid(v) and table.HasValue(PipeLineEnts, v:GetClass())
        and (v.IsPipeLineEntity or zrmine.f.IsOwner(ply, v))
        and (IsValid(v:GetModuleChild()) or IsValid(v:GetModuleParent()))) then

            local connectedEnt = v:GetModuleChild()
            local connectedID = -1

            if (IsValid(connectedEnt)) then
                connectedID = connectedEnt:EntIndex()
            end

            v.IsPipeLineEntity = true

            v:SetNWString("zrmine_Owner", "world")

            table.insert(zrms_Pipeline_Data, {
                class = v:GetClass(),
                pos = v:GetPos(),
                ang = v:GetAngles(),
                id = v:EntIndex(),
                coID = connectedID
            })
        end
    end

    // This Saves all insertes
    for k, v in pairs(zrmine.EntList) do
        if (IsValid(v) and v:GetClass() == "zrms_inserter" and (v.IsPipeLineEntity or zrmine.f.IsOwner(ply, v))) then
            local connectedEnt = v:GetModuleChild()
            local connectedID = -1

            if (IsValid(connectedEnt)) then
                connectedID = connectedEnt:EntIndex()
            end

            v.IsPipeLineEntity = true
            v:SetNWString("zrmine_Owner", "world")

            table.insert(zrms_Pipeline_Data, {
                class = v:GetClass(),
                pos = v:GetPos(),
                ang = v:GetAngles(),
                id = v:EntIndex(),
                coID = connectedID
            })
        end
    end

    // This Saves all splitter
    SaveAllMultiConnect(ply,"zrms_splitter")


    // This Saves all sorter
    SaveAllMultiConnect(ply,"zrms_sorter_coal")
    SaveAllMultiConnect(ply,"zrms_sorter_iron")
    SaveAllMultiConnect(ply,"zrms_sorter_bronze")
    SaveAllMultiConnect(ply,"zrms_sorter_silver")
    SaveAllMultiConnect(ply,"zrms_sorter_gold")

    return zrms_Pipeline_Data
end

// Here we rebuild our Pipeline
function zrmine.f.PipeLine_Rebuild(data)
    local createdEnts = {}

    // Create the entites at the exact ang and pos
    // Also we tell them what their childs EntIndex are
    for k, v in pairs(data) do
        if (v.class) then
            local ent = ents.Create(v.class)
            ent:SetPos(v.pos)
            ent:SetAngles(v.ang)
            ent:Spawn()
            local phys = ent:GetPhysicsObject()

            if (phys:IsValid()) then
                phys:Wake()
                phys:EnableMotion(false)
            end

            ent.PipeLine_ID = v.id
            ent.IsPipeLineEntity = true
            ent:SetNWString("zrmine_Owner", "world")

            if (v.class == "zrms_splitter" or string.sub(v.class, 1, 11) == "zrms_sorter") then
                ent.PipeLine_CoID01 = v.coID01
                ent.PipeLine_CoID02 = v.coID02
            else
                ent.PipeLine_CoID = v.coID
            end

            if (string.sub(v.class, 1, 12) == "zrms_refiner") and zrmine.config.Refiner_AutoSpawnCrate then
                timer.Simple(0.1, function()
                    if (IsValid(ent)) then
                        ent.PublicEntity = true
                        zrmine.f.Refinery_SpawnBasket(ent)
                    end
                end)
            end

            table.insert(createdEnts, ent)
        end
    end

    local connectdID
    local foundEnt

    // Connect Normal PipeLine Ents
    for k, v in pairs(createdEnts) do
        if (v:GetClass() ~= "zrms_inserter" or v:GetClass() ~= "zrms_splitter" or string.sub(v:GetClass(), 1, 11) ~= "zrms_sorter") then
            connectdID = v.PipeLine_CoID

            if (connectdID ~= -1) then
                foundEnt = FindConnectedEntByID(connectdID, createdEnts)

                if (IsValid(foundEnt)) then

                    v:SetModuleChild(foundEnt)
                    v:GetModuleChild():SetModuleParent(v)

                    v.PhysgunDisabled = true
                    v:GetModuleChild().PhysgunDisabled = true
                end
            end
        end
    end

    // Connect Inserter PipeLine Ents
    for k, v in pairs(createdEnts) do

        if (v:GetClass() == "zrms_inserter") then

            connectdID = v.PipeLine_CoID

            if (connectdID ~= -1) then
                foundEnt = FindConnectedEntByID(connectdID, createdEnts)

                if (IsValid(foundEnt)) then
                    v:SetModuleChild(foundEnt)
                    v.PhysgunDisabled = true
                    //print("Inserter got connected too "..foundEnt:GetClass())
                end
            end
        end
    end

    // Connect Splitter PipeLine Ents
    for k, v in pairs(createdEnts) do
        if (v:GetClass() == "zrms_splitter") then
            local connectdID01 = v.PipeLine_CoID01
            local connectdID02 = v.PipeLine_CoID02

            if (connectdID01 ~= -1) then
                foundEnt = FindConnectedEntByID(connectdID01, createdEnts)

                if (IsValid(foundEnt)) then
                    v:SetModuleChild01(foundEnt)
                    //print("Splitter01 got connected too "..foundEnt:GetClass())
                end
            end

            if (connectdID02 ~= -1) then
                foundEnt = FindConnectedEntByID(connectdID02, createdEnts)

                if (IsValid(foundEnt)) then
                    v:SetModuleChild02(foundEnt)
                    //print("Splitter02 got connected too "..foundEnt:GetClass())
                end
            end
        end
    end

    // Connect Sorter ents
    for k, v in pairs(createdEnts) do
        if (string.sub(v:GetClass(), 1, 11) == "zrms_sorter") then
            local connectdID01 = v.PipeLine_CoID01
            local connectdID02 = v.PipeLine_CoID02

            if (connectdID01 ~= -1) then
                foundEnt = FindConnectedEntByID(connectdID01, createdEnts)

                if (IsValid(foundEnt)) then
                    v:SetModuleChild01(foundEnt)
                end
            end

            if (connectdID02 ~= -1) then
                foundEnt = FindConnectedEntByID(connectdID02, createdEnts)

                if (IsValid(foundEnt)) then
                    v:SetModuleChild02(foundEnt)
                end
            end
        end
    end
end

// Finds all the PipeLine entitys and removes them
function zrmine.f.PipeLine_Remove()
    for k, v in pairs(zrmine.EntList) do
        if (IsValid(v) and v.IsPipeLineEntity) then
            v:Remove()
        end
    end
end

// Save Load Delete
function zrmine.f.PipeLine_Save(ply)
    local data = zrmine.f.PipeLine_Build(ply)

    if not file.Exists("zrms", "DATA") then
        file.CreateDir("zrms")
    end

    file.Write("zrms/" .. string.lower(game.GetMap()) .. "_PipeLine" .. ".txt", util.TableToJSON(data,true))
    zrmine.f.Notify(ply, "The PipeLine has been saved for the map " .. string.lower(game.GetMap()) .. "!", 0)
end

function zrmine.f.PipeLine_Load()
    if file.Exists("zrms/" .. string.lower(game.GetMap()) .. "_PipeLine" .. ".txt", "DATA") then
        local data = file.Read("zrms/" .. string.lower(game.GetMap()) .. "_PipeLine" .. ".txt", "DATA")
        data = util.JSONToTable(data)

        if data and data ~= nil then
            zrmine.f.PipeLine_Rebuild(data)
            print("[Zeros Retro MiningSystem] Finished loading PipeLine entities.")
        end
    else
        print("[Zeros Retro MiningSystem] No map data found for PipeLine entities. Please build a PipeLine first and do !zrms_savepipeline to create the data.")
    end
end

function zrmine.f.PipeLine_Delete(ply)
    if file.Exists("zrms/" .. string.lower(game.GetMap()) .. "_PipeLine" .. ".txt", "DATA") then
        file.Delete("zrms/" .. string.lower(game.GetMap()) .. "_PipeLine" .. ".txt")
        zrmine.f.PipeLine_Remove()
        zrmine.f.Notify(ply, "[Zeros Retro MiningSystem] Removed PipeLine entities.", 1)
    end
end

hook.Add("InitPostEntity", "a_zrmine_PipeLine_Rebuild_OnMapLoad", zrmine.f.PipeLine_Load)
hook.Add("PostCleanupMap", "a_zrmine_PipeLine_Rebuild_PostCleanUp", zrmine.f.PipeLine_Load)


function zrmine.f.PublicEnts_Save(ply)
    local data = {}

    for u, j in pairs(ents.FindByClass("zrms_mineentrance_base")) do
        table.insert(data, {
            class = j:GetClass(),
            pos = j:GetPos(),
            ang = j:GetAngles()
        })
    end

    for u, j in pairs(ents.FindByClass("zrms_melter")) do
        table.insert(data, {
            class = j:GetClass(),
            pos = j:GetPos(),
            ang = j:GetAngles()
        })
    end

    if not file.Exists("zrms", "DATA") then
        file.CreateDir("zrms")
    end

    file.Write("zrms/" .. string.lower(game.GetMap()) .. "_PublicEnts" .. ".txt", util.TableToJSON(data))
    zrmine.f.Notify(ply, "The Public Entities have been saved for the map " .. string.lower(game.GetMap()) .. "!", 0)
end

function zrmine.f.PublicEnts_Remove(ply)
    for u, j in pairs(ents.FindByClass("zrms_mineentrance_base")) do
        if IsValid(j) and j.PublicEntity then
            j:Remove()
        end
    end

    for u, j in pairs(ents.FindByClass("zrms_melter")) do
        if IsValid(j) and j.PublicEntity then
            j:Remove()
        end
    end

    if file.Exists("zrms/" .. string.lower(game.GetMap()) .. "_PublicEnts" .. ".txt", "DATA") then
        file.Delete("zrms/" .. string.lower(game.GetMap()) .. "_PublicEnts" .. ".txt")
    end

    zrmine.f.Notify(ply, "The Public Entities have been removed for the map " .. string.lower(game.GetMap()) .. "!", 0)
end

function zrmine.f.PublicEnts_Load()
    if file.Exists("zrms/" .. string.lower(game.GetMap()) .. "_PublicEnts" .. ".txt", "DATA") then
        local data = file.Read("zrms/" .. string.lower(game.GetMap()) .. "_PublicEnts" .. ".txt", "DATA")
        data = util.JSONToTable(data)

        if data then
            for k, v in pairs(data) do
                local ent = ents.Create(v.class)
                ent:SetPos(v.pos)
                ent:SetAngles(v.ang)
                ent:Spawn()
                ent.PublicEntity = true

                if (v.class == "zrms_mineentrance_base") then
                    timer.Simple(0.1, function()
                        if IsValid(ent) then

                            zrmine.f.Minebase_OpenMine(ent,nil)
                        end
                    end)
                end
            end
        end

        print("[Zeros Retro MiningSystem] Finished loading Public entities.")
    else
        print("[Zeros Retro MiningSystem] No map data found for Public entities.")
    end
end

hook.Add("InitPostEntity", "a_zrmine_PublicEnts_OnMapLoad", zrmine.f.PublicEnts_Load)
hook.Add("PostCleanupMap", "a_zrmine_PublicEnts_PostCleanUp", zrmine.f.PublicEnts_Load)
