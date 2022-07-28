--[[
    MGangs 2 - ASSOCIATIONS - (SH) Associations
    Developed by Zephruz
]]

--[[
    MG2_ASSOCIATIONS:SetupTemporary(data [table])
]]
function MG2_ASSOCIATIONS:SetupTemporary(data)
    local assoc = {}

    zlib.object:SetMetatable("mg2.Association", assoc)

    if (data) then
        for k,v in pairs(data) do
            assoc:setRawData(k,v)
        end
    end

    return assoc
end

--[[
    MG2_ASSOCIATIONS:Setup(id [int], data [table])

    - Sets an assocation up with the specified data
]]
function MG2_ASSOCIATIONS:Setup(id, data)
    if !(id) then return end

    local assoc = self:SetupTemporary(data)
    assoc:SetID(id)

    local cache = zlib.cache:Get("mg2.Associations")

    if (cache) then 
        local id, entry = cache:addEntry(assoc, id)

        if (SERVER && entry) then
            mg2.gang:SendCacheToPlayer("mg2.Associations", player.GetAll(),
            function(entries)
                return {[id] = entry:getDataTable()}
            end)
        end
        
        return entry
    end

    return assoc
end

--[[
    MG2_ASSOCIATIONS:Get(id [int])

    - Returns a cached association
]]
function MG2_ASSOCIATIONS:Get(id)
    if !(id) then return end

    local cache = zlib.cache:Get("mg2.Associations")

    if !(cache) then return end

    return cache:getEntry(id)
end

--[[
    MG2_ASSOCIATIONS:GetAll()

    - Returns all cached associations
]]
function MG2_ASSOCIATIONS:GetAll()
    local cache = zlib.cache:Get("mg2.Associations")

    if !(cache) then return {} end

    return cache:GetEntries()
end

--[[
    MG2_ASSOCIATIONS:GetGangs(gangid [int])

    - Returns a gangs cached associations
]]
function MG2_ASSOCIATIONS:GetGangs(gangid)
    local assocTbl = {}
    local assoc = self:GetAll()

    for k,v in pairs(assoc) do
        if (v:GetGangs(gangid)) then
            table.insert(assocTbl, v)
        end
    end

    return assocTbl
end

--[[
    Association Cache(s)
]]
local assocCache = zlib.cache:Register("mg2.Associations")
assocCache.onPlayerReceive = function(s,data)
    for k,v in pairs(data) do
        local assoc = MG2_ASSOCIATIONS:Get(k)

        if (!v && assoc) then
            // remove assoc
            assoc:remove()
        elseif (assoc) then
            // update assoc data
            for i,d in pairs(v) do
                assoc:setRawData(i, d)
            end
        else 
            // setup assoc
            MG2_ASSOCIATIONS:Setup(k, v)
        end
    end
end

--[[
    Association Metastructure
]]
local assocMtbl = zlib.object:Create("mg2.Association")

assocMtbl:setData("ID", false, {shouldSave = false})
assocMtbl:setData("Name", "Name", {})
assocMtbl:setData("Association", "Neutral", {})
assocMtbl:setData("WarStatus", false, {})

assocMtbl:setData("Gangs", {}, {
    shouldSave = false,
    onSet = function(s,val,oVal)
        if !(val) then return oVal end

        oVal = (oVal or {})
        oVal[val] = true

        return oVal
    end,
    onGet = function(s,val,gangid)
        if !(gangid) then return end

        return (gangid && val[gangid] || false)
    end,
})

function assocMtbl:remove()
    local id = self:GetID()

    if !(id) then return end

    local cache = zlib.cache:Get("mg2.Associations")
    cache:removeEntry(id)

    if (SERVER) then
        mg2.gang:SendCacheToPlayer("mg2.Associations", player.GetAll(),
        function(entries)
            return {[id] = false}
        end)
    end
end

function assocMtbl:onSave(data, cb)
    if (!SERVER or !data) then return end

    local id = self:GetID()
    local dtype = zlib.data:GetConnection("mg2.Main")

    if (!id or !dtype) then return end

    dtype:Query("UPDATE `mg2_associations` SET `data`=" .. data .. " WHERE `id`=" .. id,
    function()
        mg2.gang:SendCacheToPlayer("mg2.Associations", player.GetAll(), 
        function(entries)
            return {[id] = self:getDataTable()}
        end)

        if (cb) then cb(self) end
    end)
end

--[[
    Permissions
]]

--[[RESPOND ASSOCIATION]]
local PERM_RESPREQASSOC = mg2.gang:RegisterPermission("associations.RequestRespond")
PERM_RESPREQASSOC:SetName(mg2.lang:GetTranslation("associations.RequestRespond"))
PERM_RESPREQASSOC:SetCategory(mg2.lang:GetTranslation("associations"))
PERM_RESPREQASSOC:SetDescription(mg2.lang:GetTranslation("associations.RequestRespondDesc"))

function PERM_RESPREQASSOC:onCall(ply, cb, reqid, response)
    local gang = ply:GetGang()

    if (!gang or !reqid) then return false end

    local canRespond = hook.Run("mg2.associations.Respond", ply, gang)

    if (canRespond == false) then cb(false) return false end

    local gangid = gang:GetID()

    MG2_ASSOCIATIONS:GetRequest(reqid,
    function(data)
        if (!data or data.rec_gangid != gangid) then cb(false) return end
        
        MG2_ASSOCIATIONS:RespondToRequest(reqid, (response or false),
        function()
            cb(true)
        end)
    end)
end

--[[REQUEST ASSOCIATION]]
local PERM_REQASSOC = mg2.gang:RegisterPermission("associations.RequestAssociation")
PERM_REQASSOC:SetName(mg2.lang:GetTranslation("associations.Request"))
PERM_REQASSOC:SetCategory(mg2.lang:GetTranslation("associations"))
PERM_REQASSOC:SetDescription(mg2.lang:GetTranslation("associations.RequestDesc"))

function PERM_REQASSOC:onCall(ply, cb, gid, assocType)
    local gang = ply:GetGang()
    local aType = MG2_ASSOCIATIONS:GetAssociationTypes(assocType)

    if (!gang or !gid or !aType) then return false end

    local canRequest = hook.Run("mg2.associations.Request", ply, gang)

    if (canRequest == false) then cb(false) return false end

    local gid1, gid2 = gang:GetID(), gid

    MG2_ASSOCIATIONS:RequestAssociation(gid1, gid2, assocType, 
    function(res)
        cb(res or false)
    end)
end

--[[SET ASSOCIATION]]
local PERM_SETASSOC = mg2.gang:RegisterPermission("associations.SetAssociation")
PERM_SETASSOC:SetName(mg2.lang:GetTranslation("associations.SetAssociation"))
PERM_SETASSOC:SetCategory(mg2.lang:GetTranslation("associations"))
PERM_SETASSOC:SetDescription(mg2.lang:GetTranslation("associations.SetAssociationDesc"))
PERM_SETASSOC:SetPermissionType("association")

PERM_SETASSOC.oldUserCall = (PERM_SETASSOC.oldUserCall or PERM_SETASSOC.onUserCall)

function PERM_SETASSOC:onCall(ply, cb, associd, val)
    local gang = ply:GetGang()

    if (!gang or !associd or !val) then return false end

    local gangid = gang:GetID()
    local assocType, assoc = MG2_ASSOCIATIONS:GetAssociationTypes(val), MG2_ASSOCIATIONS:Get(associd)
    local hasAssoc = (assoc && assoc:GetGangs(gangid))

    if (!assocType or !hasAssoc) then return false end

    assoc:SetAssociation(val)

    cb(val)
end

function PERM_SETASSOC:onUserCall(data, cb)
    local id = (data && data[1])
    local assoc = MG2_ASSOCIATIONS:Get(id)

    if !(assoc) then return end

    local frame = vgui.Create("mg2.Frame")
    frame:SetSize(300,85)
    frame:SetTitle(mg2.lang:GetTranslation("associations.SetAssociation"))
    frame:Center()
    frame:MakePopup()
    frame:SetBackgroundBlur(true)

    local dropDown = vgui.Create("mg2.Dropdown", frame)
    dropDown:Dock(TOP)
    dropDown:DockMargin(3,3,3,3)
    dropDown:SetTall(30)
    dropDown:SetText(mg2.lang:GetTranslation("selectassociation"))

    local btn = vgui.Create("mg2.Button", frame)
    btn:Dock(FILL)
    btn:DockMargin(3,0,3,3)
    btn:SetText(mg2.lang:GetTranslation("set"))
    btn.DoClick = function(s)
        local val = dropDown:GetSelected()

        if !(val) then return end

        self:oldUserCall({id, val}, 
        function(res)
            if (res) then assoc:SetAssociation(res) end

            cb(res)

            if !(IsValid(frame)) then return end
            
            frame:Remove()
        end)
    end

    -- Association types
    local assocTypes = MG2_ASSOCIATIONS:GetAssociationTypes()

    for k,v in pairs(assocTypes) do
        dropDown:AddChoice(k)
    end
end

--[[SET ASSOCIATION NAME]]
local PERM_SETNAME = mg2.gang:RegisterPermission("associations.SetName")
PERM_SETNAME:SetName(mg2.lang:GetTranslation("setname"))
PERM_SETNAME:SetCategory(mg2.lang:GetTranslation("associations"))
PERM_SETNAME:SetDescription(mg2.lang:GetTranslation("associations.SetNameDesc"))
PERM_SETNAME:SetPermissionType("association")

PERM_SETNAME.oldUserCall = (PERM_SETNAME.oldUserCall or PERM_SETNAME.onUserCall)

function PERM_SETNAME:onCall(ply, cb, associd, val)
    if (!associd or !val) then return false end

    local assoc = MG2_ASSOCIATIONS:Get(associd)
    
    if !(assoc) then return end

    assoc:SetName(val)

    cb(val)
end

function PERM_SETNAME:onUserCall(data, cb)
    local id = (data && data[1])
    local assoc = MG2_ASSOCIATIONS:Get(id)

    if !(assoc) then return end

    local frame = vgui.Create("mg2.Frame")
    frame:SetSize(300,85)
    frame:SetTitle(mg2.lang:GetTranslation("setassociationname"))
    frame:Center()
    frame:MakePopup()
    frame:SetBackgroundBlur(true)

    local textEntry = vgui.Create("mg2.TextEntry", frame)
    textEntry:Dock(TOP)
    textEntry:DockMargin(3,3,3,3)
    textEntry:SetTall(30)
    textEntry:SetText(assoc:GetName())
    textEntry:SetPlaceholder(mg2.lang:GetTranslation("enterassociationname"))

    local btn = vgui.Create("mg2.Button", frame)
    btn:Dock(FILL)
    btn:DockMargin(3,0,3,3)
    btn:SetText(mg2.lang:GetTranslation("set"))
    btn.DoClick = function(s)
        local val = textEntry:GetText()
        
        if !(val) then return end

        self:oldUserCall({id, val}, 
        function(res)
            if (res) then assoc:SetName(res) end

            cb(res)

            if !(IsValid(frame)) then return end
            
            frame:Remove()
        end)
    end
end

--[[VOID ASSOCIATION]]
local PERM_VOIDASSOCIATION = mg2.gang:RegisterPermission("associations.VoidAssociation")
PERM_VOIDASSOCIATION:SetName(mg2.lang:GetTranslation("associations.VoidAssociation"))
PERM_VOIDASSOCIATION:SetCategory(mg2.lang:GetTranslation("associations"))
PERM_VOIDASSOCIATION:SetDescription(mg2.lang:GetTranslation("associations.VoidAssociationDesc"))
PERM_VOIDASSOCIATION:SetPermissionType("association")

function PERM_VOIDASSOCIATION:onCall(ply, cb, val)
    local gang = ply:GetGang()

    if !(val) then return false end

    local assoc = MG2_ASSOCIATIONS:Get(val)

    if !(assoc) then return end

    local isGAssoc = assoc:GetGangs(gang:GetID())

    if (isGAssoc) then
        MG2_ASSOCIATIONS:DeleteAssociation(val, 
        function()
            cb(true)
        end)

        return
    end

    cb(false)
end

--[[GO TO WAR]]
--[[local PERM_GOTOWAR = mg2.gang:RegisterPermission("associations.GoToWar")
PERM_GOTOWAR:SetName("Go To War")
PERM_GOTOWAR:SetCategory("Associations")
PERM_GOTOWAR:SetDescription("Able to go to war with another gang.")
PERM_GOTOWAR:SetPermissionType("association")

function PERM_GOTOWAR:onCall(ply, cb, val)
    local gang = ply:GetGang()

    if (!gang or !val) then return false end

    -- @TODO;
end]]

--[[
    Networking
]]
local userReqs = {}
userReqs["getRequests"] = function(ply, data, cb)
    local gang = ply:GetGang()

    if !(gang) then return end

    MG2_ASSOCIATIONS:GetRequests(gang:GetID(),
    function(reqs)
        cb(reqs)
    end)
end

zlib.network:RegisterAction("mg2.achievements.userRequest", {
    onReceive = function(ply, val, cb)
        if !(istable(val)) then return end

        local reqName, data = val.reqName, (val.data or {})
        local req = userReqs[reqName]
        
        if (req) then
            req(ply, val, cb)
        end
    end,
})