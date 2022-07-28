--[[
    MGangs 2 - ASSOCIATIONS - (SV) Init
    Developed by Zephruz
]]

--[[
    MG2_ASSOCIATIONS:CreateAssociation(gangid1 [int], gangid2 [int], callback [function])

    - Creates an association between two gangs
]]
function MG2_ASSOCIATIONS:CreateAssociation(gangid1, gangid2, callback)
    if (!gangid1 or !gangid2) then return end

    local dtype = zlib.data:GetConnection("mg2.Main")

    if !(dtype) then return end

    local escGid1, escGid2 = dtype:EscapeString(gangid1), dtype:EscapeString(gangid2)

    dtype:Query("SELECT id, gang_id1, gang_id2, data FROM `mg2_associations` WHERE (`gang_id1`=" .. escGid1 .. " AND `gang_id2`=" .. escGid2 .. ") OR (`gang_id1`=" .. escGid2 .. " AND `gang_id2`=" .. escGid1 .. ")",
    function(data)
        local assocData = (data && data[1])
        
        if (assocData) then
            self:Load(assocData.id,
            function(assoc)
                if (callback) then callback(assoc or false) end
            end)

            return
        end

        local escGid1, escGid2, data = dtype:EscapeString(gangid1), dtype:EscapeString(gangid2), zlib.util:Serialize({})

        dtype:Query("INSERT INTO `mg2_associations` (`gang_id1`, `gang_id2`, `data`) VALUES (" .. escGid1 .. ", " .. escGid2 .. ", '" .. data .. "')",
        function(data, id)
            self:Load(id,
            function(assoc)
                if (callback) then callback(assoc or false) end
            end)
        end)
    end)
end

--[[
    MG2_ASSOCIATIONS:DeleteAssociation(id [int], callback [function])

    - Deletes an association
]]
function MG2_ASSOCIATIONS:DeleteAssociation(id, callback)
    if !(id) then return end

    local dtype = zlib.data:GetConnection("mg2.Main")

    if !(dtype) then return end

    dtype:Query("DELETE FROM `mg2_associations` WHERE `id`=" .. dtype:EscapeString(id),
    function()
        local assoc = self:Get(id)

        if (assoc) then
            assoc:remove()
        end

        if (callback) then callback(true) end
    end)
end

--[[
    MG2_ASSOCIATIONS:GetRequests(gangid [id], callback [function])

    - Returns a gangs association requests
]]
function MG2_ASSOCIATIONS:GetRequests(gangid, callback)
    if !(gangid) then return end

    local dtype = zlib.data:GetConnection("mg2.Main")

    if !(dtype) then return end

    dtype:Query("SELECT id, req_gangid, rec_gangid, association_type, data FROM `mg2_associationrequests` WHERE `rec_gangid`=" .. dtype:EscapeString(gangid),
    function(data)
        if (callback) then callback(data) end
    end)
end

--[[
    MG2_ASSOCIATIONS:Load(id [int], callback [function])

    - Loads an association
]]
function MG2_ASSOCIATIONS:Load(id, callback)
    if !(id) then return end

    local dtype = zlib.data:GetConnection("mg2.Main")

    if !(dtype) then return end

    dtype:Query("SELECT id, gang_id1, gang_id2, data FROM `mg2_associations` WHERE `id`=" .. dtype:EscapeString(id),
    function(data)
        local assocData = (data && data[1])
        local assoc = false

        if (assocData) then
            assocData.data = zlib.util:Deserialize(assocData.data)
            assocData.data.Gangs = (assocData.data.Gangs or {})
            assocData.data.Gangs[assocData.gang_id1] = true
            assocData.data.Gangs[assocData.gang_id2] = true

            assoc = self:Setup(id, assocData.data)
        end

        if (callback) then callback(assoc) end
    end)
end

--[[
    MG2_ASSOCIATIONS:LoadGangs(gangid [int], callback [function])

    - Loads all of a gangs associations
]]
function MG2_ASSOCIATIONS:LoadGangs(gangid, callback, noNetwork)
    if !(gangid) then return end

    local dtype = zlib.data:GetConnection("mg2.Main")
    local gang = mg2.gang:Get(gangid)

    if (!dtype or !gang) then return end

    local escGangid = dtype:EscapeString(gangid)

    dtype:Query("SELECT id, gang_id1, gang_id2, data FROM `mg2_associations` WHERE `gang_id1`=" .. escGangid .. " OR `gang_id2`=" .. escGangid,
    function(data)
        local assocTbl = {}
        
        for k,v in pairs(data) do
            v.data = (zlib.util:Deserialize(v.data) || {})
            v.data.Gangs = (v.data.Gangs or {})
            v.data.Gangs[v.gang_id1] = true
            v.data.Gangs[v.gang_id2] = true

            local assoc = (noNetwork && self:SetupTemporary(v.data) || self:Setup(v.id, v.data))

            table.insert(assocTbl, assoc)
        end

        if (callback) then callback(assocTbl) end
    end)
end

--[[-----------
    REQUESTING
-------------]]

--[[
    MG2_ASSOCIATIONS:RequestAssociation(req_gangid [int], rec_gangid [int], assocType [string], callback [function])

    - Requests an association between the specified gang id's
]]
function MG2_ASSOCIATIONS:RequestAssociation(req_gangid, rec_gangid, assocType, callback)
    if (!req_gangid or !rec_gangid or !self:GetAssociationTypes(assocType)) then return end

    local dtype = zlib.data:GetConnection("mg2.Main")

    if !(dtype) then return end

    self:GetRequests(rec_gangid,
    function(data)
        for k,v in pairs(data) do
            if (v.req_gangid == req_gangid) then
                if (callback) then callback(false) end

                return
            end
        end

        MG2_ASSOCIATIONS:LoadGangs(req_gangid, 
        function(assoc)
            for k,v in pairs(assoc) do
                if (v:GetGangs(rec_gangid)) then
                    if (callback) then callback(false) end

                    return 
                end
            end

            local reqGang = mg2.gang:Get(req_gangid)
            local data = zlib.util:Serialize({date = os.time(), name = (reqGang && reqGang:GetName() || "Unknown")})

            dtype:Query("INSERT INTO `mg2_associationrequests` (`req_gangid`, `rec_gangid`, `association_type`, `data`) VALUES (" .. dtype:EscapeString(req_gangid) .. ", " .. dtype:EscapeString(rec_gangid) .. ", " .. dtype:EscapeString(assocType) .. ", " .. data .. ")",
            function()
                if (callback) then callback(true) end
            end)
        end, true)
    end)
end

--[[
    MG2_ASSOCIATIONS:RemoveRequest(id [int], callback [function])

    - Removes an association request
]]
function MG2_ASSOCIATIONS:RemoveRequest(id, callback)
    if !(id) then return end

    local dtype = zlib.data:GetConnection("mg2.Main")

    if !(dtype) then return end

    dtype:Query("DELETE FROM `mg2_associationrequests` WHERE `id`=" .. dtype:EscapeString(id),
    function()
        if (callback) then callback(true) end
    end)
end

--[[
    MG2_ASSOCIATIONS:GetRequest(id [int], callback [function])

    - Removes an association request
]]
function MG2_ASSOCIATIONS:GetRequest(id, callback)
    if !(id) then return end

    local dtype = zlib.data:GetConnection("mg2.Main")

    if !(dtype) then return end

    dtype:Query("SELECT id, req_gangid, rec_gangid, association_type, data FROM `mg2_associationrequests` WHERE `id`=" .. dtype:EscapeString(id),
    function(data)
        data = (data && data[1])

        if (callback) then callback(data or false) end
    end)
end

--[[
    MG2_ASSOCIATIONS:RespondToRequest(id [int], response [bool], callback [function])

    - Responds to the request
]]
function MG2_ASSOCIATIONS:RespondToRequest(id, response, callback)
    if !(id) then return end

    self:GetRequest(id,
    function(data)
        if !(data) then return end

        self:RemoveRequest(id,
        function()
            local req_gid, rec_gid, assocType = data.req_gangid, data.rec_gangid, data.association_type

            if !(self:GetAssociationTypes(assocType)) then if (callback) then callback(false) end return end

            if (response) then
                MG2_ASSOCIATIONS:CreateAssociation(req_gid, rec_gid, 
                function(assoc)
                    assoc:SetAssociation(assocType)

                    if (callback) then callback(true) end
                end)

                return
            end

            if (callback) then callback(true) end
        end)
    end)
end

--[[
    MG2_ASSOCIATIONS:GetRequests(gangid [int], callback [function]

    - Returns all of a gangs requests (sent and received)
]]
function MG2_ASSOCIATIONS:GetRequests(gangid, callback)
    if !(gangid) then return end

    local dtype = zlib.data:GetConnection("mg2.Main")

    if !(dtype) then return end

    dtype:Query("SELECT id, req_gangid, rec_gangid, association_type, data FROM `mg2_associationrequests` WHERE `req_gangid`=" .. dtype:EscapeString(gangid) .. " OR `rec_gangid`=" .. dtype:EscapeString(gangid),
    function(data)
        for k,v in pairs(data) do
            data[k].data = (v.data && zlib.util:Deserialize(v.data) || {})
        end

        if (callback) then callback(data) end
    end)
end

--[[
    Data
]]
local function loadData(dtype)
    if !(dtype) then return end

    -- Associations
    dtype:Query([[CREATE TABLE IF NOT EXISTS `mg2_associations` (
        `id` INTEGER PRIMARY KEY AUTO_INCREMENT,
        `gang_id1` INTEGER NOT NULL,
        `gang_id2` INTEGER NOT NULL,
        `data` LONGTEXT NOT NULL
    )]], nil, function(err, sSql) mg2:ConsoleMessage((err || "Unknown error") .. " - " .. (sSql || "")) end)

    -- Association requests
    dtype:Query([[CREATE TABLE IF NOT EXISTS `mg2_associationrequests` (
        `id` INTEGER PRIMARY KEY AUTO_INCREMENT,
        `req_gangid` INTEGER NOT NULL,
        `rec_gangid` INTEGER NOT NULL,
        `association_type` VARCHAR(60) NOT NULL,
        `data` LONGTEXT NOT NULL
    )]], nil, function(err, sSql) mg2:ConsoleMessage((err || "Unknown error") .. " - " .. (sSql || "")) end)
end

hook.Add("mg2.data.Initialized", "mg2.associations.LoadData",
function(mg2, dtype)
    loadData(dtype)
end)

loadData(zlib.data:GetConnection("mg2.Main"))

--[[
    Hooks
]]
hook.Add("mg2.gang.Loaded", "mg2.gang.Associations[gang.Loaded]",
function(gang)
    if !(gang) then return end

    local gangid = gang:GetID()

    MG2_ASSOCIATIONS:LoadGangs(gangid)
end)

hook.Add("mg2.player.Loaded", "mg2.gang.Associations[player.Loaded]",
function(ply, gang)
    if (!ply or !gang) then return end

    local gangid = gang:GetID()

    if !(gangid) then return end

    mg2.gang:SendCacheToPlayer("mg2.Associations", ply, 
    function(entries)
        local toSend = {}

        for k,v in pairs(entries) do
            local isGangs = (v && v.Gangs && v.Gangs[gangid])
            
            if (isGangs) then
                toSend[k] = v
            end
        end

        return toSend
    end)
end)