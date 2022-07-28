--[[
    MGangs 2 - TERRITORIES - (SV) Init
    Developed by Zephruz
]]

--[[
    MG2_NPCMANAGER:Create(data [table], callback [function])

    - Creates an NPC
]]
function MG2_NPCMANAGER:Create(data, callback)
    data = (data or {})

    local dtype = zlib.data:GetConnection("mg2.Main")

    if !(dtype) then return end

    local npc = self:SetupTemporary(data)
    local tData = npc:getValidatedData()
    local tsData = zlib.util:Serialize(istable(tData) && tData || {})
    local mapName = (npc:GetMapName() || game.GetMap())

    dtype:Query("INSERT INTO `mg2_npcs` (`data`, `map_name`) VALUES ('" .. tsData .. "', " .. dtype:EscapeString(mapName) .. ")",
    function(data, id)
        if (!data or !id) then return end

        local npc = self:Setup(id, tData)

        if (callback) then callback(npc) end
    end)
end

--[[
    MG2_NPCMANAGER:Delete(id [int], callback [function])

    - Deletes a NPC
]]
function MG2_NPCMANAGER:Delete(id, callback)
    if !(id) then if (callback) then callback(false) end return end

    local dtype = zlib.data:GetConnection("mg2.Main")

    if !(dtype) then if (callback) then callback(false) end return end

    dtype:Query("DELETE FROM `mg2_npcs` WHERE `id`=" .. dtype:EscapeString(id),
    function()
        local npc = self:Get(id)

        if (npc) then
            npc:remove()
        end

        if (callback) then 
            callback(true) 
        end
    end)
end

--[[
    MG2_NPCMANAGER:Load(id [int], callback [function])

    - Loads the NPC with the specified ID
    - You can optionally pass "*" as the ID to load all NPCs
]]
function MG2_NPCMANAGER:Load(id, callback)
    if !(id) then return end

    local dtype = zlib.data:GetConnection("mg2.Main")

    if !(dtype) then return end

    local idStr = (id == "*" && "" || " WHERE `id`=" .. dtype:EscapeString(id))
    local mapName = dtype:EscapeString(game.GetMap())

    dtype:Query("SELECT id, map_name, data FROM `mg2_npcs`" .. idStr .. " WHERE `map_name`=" .. mapName,
    function(data)
        -- Load single NPC
        if (id != "*" && callback) then 
            local tData = data[1]

            if !(tData) then return false end

            tData.data = zlib.util:Deserialize(tData.data)

            callback(tData && self:Setup(tData.id,tData.data) || false)

            return 
        end

        -- Load NPCs
        local npcs = {}

        for k,v in pairs(data) do
            v.data = zlib.util:Deserialize(v.data)

            local tempNpc = self:Setup(v.id,v.data)
            tempNpc:SetMapName(v.map_name)

            npcs[v.id] = tempNpc
        end

        if (callback) then callback(npcs) end
    end)
end

--[[
    MG2_NPCMANAGER:SetupNPCEntity(npc [NPC])

    - Sets a NPC flag up
]]
function MG2_NPCMANAGER:SetupNPCEntity(npc)
    if !(npc) then return end

    local id, pos, col, name, desc = npc:GetID(), npc:GetPosition(), npc:GetColor(), npc:GetTitle(), npc:GetDescription()
    local npcEnt = ents.Create("mg_npc")

    if !(IsValid(npcEnt)) then mg2:ConsoleMessage("Error loading NPC entity, entity is NULL. (NPC ID: " .. (id or "NIL") .. ")") return end

    npcEnt:SetPos(pos)
    npcEnt:Spawn()

    local phys = npcEnt:GetPhysicsObject()
    
    if (IsValid(phys)) then
        phys:EnableMotion(false)
    end

    -- Setup data
    npcEnt:SetTitle(name)
    npcEnt:SetDescription(desc)
    npcEnt:SetNPCID(id)
    npcEnt:SetColor(col or Color(255,255,255))

    -- Set entity on NPC
    npc:SetEntity(npcEnt)
end


--[[
    MG2_NPCMANAGER:VerifyLoaded()

    - Verifies if NPC entities are loaded
        * If they aren't, it loads them
]]
function MG2_NPCMANAGER:VerifyLoaded()
    for k,v in pairs(self:GetAll()) do
        local ent = v:GetEntity()
        
        if (IsEntity(ent) && !IsValid(ent) || !ent) then
            self:SetupNPCEntity(v)
        end
    end
end

--[[
    Data
]]
local function loadData(mg2, dtype)
    if !(dtype) then return end

    dtype:Query([[CREATE TABLE IF NOT EXISTS `mg2_npcs` (
		`id` INTEGER PRIMARY KEY AUTO_INCREMENT,
        `map_name` VARCHAR(120) NOT NULL,
		`data` LONGTEXT NOT NULL
    )]], nil, function(err, sSql) mg2:ConsoleMessage((err || "Unknown error") .. " - " .. (sSql || "")) end)

    MG2_NPCMANAGER:Load("*")
end

hook.Add("mg2.data.Initialized", "mg2.npcmanager.LoadData", loadData)

loadData((mg2 or {}), zlib.data:GetConnection("mg2.Main"))

--[[
    Hooks
]]
hook.Add("PlayerInitialSpawn", "mg2.npcmanager[PlayerInitialSpawn]",
function(ply)
    if !(IsValid(ply)) then return end

    mg2.gang:SendCacheToPlayer("mg2.NPCManager", ply)

    MG2_NPCMANAGER:VerifyLoaded()
end)

hook.Add("PostCleanupMap", "mg2.npcmanager[PostCleanupMap]",
function()
	MG2_NPCMANAGER:VerifyLoaded()
end)