--[[
    MGangs 2 - TERRITORIES - (SV) Init
    Developed by Zephruz
]]

--[[
    MG2_TERRITORIES:Create(data [table], callback [function])

    - Creates a territory
]]
function MG2_TERRITORIES:Create(data, callback)
    data = (data or {})

    local dtype = zlib.data:GetConnection("mg2.Main")

    if !(dtype) then return end

    local terr = self:SetupTemporary(data)
    local tData = terr:getValidatedData()
    local tsData = zlib.util:Serialize(istable(tData) && tData || {})
    local mapName = dtype:EscapeString(game.GetMap())

    dtype:Query("INSERT INTO `mg2_territories` (`data`, `map_name`) VALUES ('" .. tsData .. "', " .. mapName .. ")",
    function(data, id)
        if (!data or !id) then return end

        local terr = self:Setup(id, tData)

        if (callback) then callback(terr) end
    end)
end

--[[
    MG2_TERRITORIES:Delete(id [int], callback [function])

    - Deletes a territory
]]
function MG2_TERRITORIES:Delete(id, callback)
    if !(id) then return end

    local dtype = zlib.data:GetConnection("mg2.Main")

    if !(dtype) then return end

    dtype:Query("DELETE FROM `mg2_territories` WHERE `id`=" .. dtype:EscapeString(id),
    function()
        local terr = self:Get(id)

        if (terr) then
            terr:remove()
        end

        if (callback) then callback(true) end
    end)
end

--[[
    MG2_TERRITORIES:Load(id [int], callback [function])

    - Loads the territory with the specified ID
    - You can optionally pass "*" as the ID to load all territories
]]
function MG2_TERRITORIES:Load(id, callback)
    if !(id) then return end

    local dtype = zlib.data:GetConnection("mg2.Main")

    if !(dtype) then return end

    local idStr = (id == "*" && "" || " WHERE `id`=" .. dtype:EscapeString(id))
    local mapName = dtype:EscapeString(game.GetMap())

    dtype:Query("SELECT id, map_name, data FROM `mg2_territories`" .. idStr .. " WHERE `map_name`=" .. mapName,
    function(data)
        -- Load single territory
        if (id != "*" && callback) then 
            local tData = data[1]

            if !(tData) then return false end

            tData.data = zlib.util:Deserialize(tData.data)

            callback(tData && self:Setup(tData.id,tData.data) || false)

            return 
        end

        -- Load territories
        local terrs = {}

        for k,v in pairs(data) do
            v.data = zlib.util:Deserialize(v.data)

            terrs[v.id] = self:Setup(v.id,v.data)
        end

        if (callback) then callback(terrs) end
    end)
end

--[[
    MG2_TERRITORIES:SetupTerritoryFlag(terr [territory])

    - Sets a territory flag up
]]
function MG2_TERRITORIES:SetupTerritoryFlag(terr)
    if !(terr) then return end

    local id, pos, col = terr:GetID(), terr:GetPosition(), terr:GetColor()

    local flagEnt = ents.Create("mg_flag")

    if !(IsValid(flagEnt)) then mg2:ConsoleMessage("Error loading territory flag, flag entity is NULL. (Territory ID: " .. (id or "NIL") .. ")") return end

    flagEnt:SetPos(pos)
    flagEnt:Spawn()

    local phys = flagEnt:GetPhysicsObject()
    
    if (IsValid(phys)) then
        phys:EnableMotion(false)
    end

    -- Setup data
    flagEnt:SetColor(col or Color(255,255,255))
    flagEnt:SetTerritoryID(id)

    -- Set gang
    local tcData = terr:GetClaimed()
    local gid = (tcData && tcData.gangid)

    if (gid) then
        flagEnt:ClearClaim()
    end

    terr:SetEntity(flagEnt)
end

--[[
    MG2_TERRITORIES:RewardGang(gang [gang], rewardType [string])

    - Rewards a gang
]]
local rewTypes = {
    ["EXP"] = function(gang, amt)
        local curExp = gang:GetEXP()

        return gang:SetEXP(curExp + amt)
    end,
    ["Balance"] = function(gang, amt)
        local curBal = gang:GetBalance()

        return gang:SetBalance(curBal + amt)
    end,
}

function MG2_TERRITORIES:RewardGang(gang, rewardType)
    if (!gang or !rewardType) then return end

    local rewConfig = self.config.rewards
	local tRewCfg = rewConfig[rewardType]

    if !(tRewCfg) then return end
    
    for k,v in pairs(tRewCfg) do
        local rType = rewTypes[k]

        if (rType) then
            rType(gang, v)
        end
    end
end

--[[
    MG2_TERRITORIES:VerifyLoaded()

    - Verifies if territories flag entities are loaded
        * If they aren't, it loads them
]]
function MG2_TERRITORIES:VerifyLoaded()
    for k,v in pairs(self:GetAll()) do
        local ent = v:GetEntity()
        
        if (IsEntity(ent) && !IsValid(ent) || !ent) then
            self:SetupTerritoryFlag(v)
        end
    end
end

--[[
    Data
]]
local function loadData(mg2, dtype)
    if !(dtype) then return end

    dtype:Query([[CREATE TABLE IF NOT EXISTS `mg2_territories` (
		`id` INTEGER PRIMARY KEY AUTO_INCREMENT,
        `map_name` VARCHAR(120) NOT NULL,
		`data` LONGTEXT NOT NULL
    )]], nil, function(err, sSql) mg2:ConsoleMessage((err || "Unknown error") .. " - " .. (sSql || "")) end)
	
	MG2_TERRITORIES:Load("*")
end

hook.Add("mg2.data.Initialized", "mg2.territories.LoadData", loadData)

loadData((mg2 or {}), zlib.data:GetConnection("mg2.Main"))

--[[
    Hooks
]]
hook.Add("PlayerInitialSpawn", "mg2.territories[PlayerInitialSpawn]",
function(ply)
    if !(IsValid(ply)) then return end

    mg2.gang:SendCacheToPlayer("mg2.Territories", ply)

    MG2_TERRITORIES:VerifyLoaded()
end)

hook.Add("PlayerDisconnected", "mg2.territories[PlayerDisconnected]",
function(ply)
    local gang = (ply && ply:GetGang())

    if (!gang or !MG2_TERRITORIES.config.unclaimNoPlayers) then return end

    local onlineMems = mg2.gang:GetOnlineMembers(gang:GetID())

    if (table.Count(onlineMems) - 1 > 0) then return end

    for k,v in pairs(MG2_TERRITORIES:GetAll()) do
        local claimData = v:GetClaimed()

        if !(claimData) then continue end

        if (claimData.gangid == gang:GetID()) then
            v:SetClaimed(false) -- Unclaim
            
            break
        end
    end
end)

hook.Add("PostCleanupMap", "mg2.territories[PostCleanupMap]",
function()
	MG2_TERRITORIES:VerifyLoaded()
end)