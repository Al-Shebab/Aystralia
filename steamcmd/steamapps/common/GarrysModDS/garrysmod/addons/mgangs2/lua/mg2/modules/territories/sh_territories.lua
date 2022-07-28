--[[
    MGangs 2 - TERRITORIES - (SH)
    Developed by Zephruz
]]

--[[
    MG2_TERRITORIES:SetupTemporary(data [table])

    - Sets a temporary territory up
]]
function MG2_TERRITORIES:SetupTemporary(data)
    local terr = {}

    zlib.object:SetMetatable("mg2.Territory", terr)

    if (data) then
        for k,v in pairs(data) do
            terr:setRawData(k,v)
        end
    end

    return terr
end

--[[
    MG2_TERRITORIES:Setup(id [int], data [table])

    - Sets a territory up with the specified data
]]
function MG2_TERRITORIES:Setup(id, data)
    if !(id) then return end

    -- Remove previous territory flag/entity
    local prevTerr = self:Get(id)
    local tEnt = (prevTerr && prevTerr:GetEntity())

    if (SERVER && IsValid(tEnt)) then
        tEnt:Remove()
    end

    -- Load territory
    local terr = self:SetupTemporary(data)
    terr:SetID(id)

    /*-- Verify gang claim
    local claimData = terr:GetClaimed()
    claimData =  (istable(claimData) && claimData)

    if (SERVER && claimData) then
        local gangid = claimData.gangid
        local gang = mg2.gang:Get(gangid)

        if !(gang) then
            mg2.gang:Load(gangid,
            function(gang)
                if !(gang) then terr:SetClaimed(false) end
            end)
        end
    end*/

    -- Add it to the cache
    local cache = zlib.cache:Get("mg2.Territories")

    if (cache) then 
        local id, entry = cache:addEntry(terr, id)

        if (SERVER && entry) then
            self:SetupTerritoryFlag(entry)

            mg2.gang:SendCacheToPlayer("mg2.Territories", player.GetAll(),
            function(entries)
                return {[id] = entry:getDataTable()}
            end)
        end
        
        return entry
    end

    return terr
end

--[[
    MG2_TERRITORIES:Get(id [int])

    - Returns a cached territory
]]
function MG2_TERRITORIES:Get(id)
    if !(id) then return end

    local cache = zlib.cache:Get("mg2.Territories")

    if !(cache) then return end

    return cache:getEntry(id)
end

--[[
    MG2_TERRITORIES:GetAll()

    - Returns all cached territories
]]
function MG2_TERRITORIES:GetAll()
    local cache = zlib.cache:Get("mg2.Territories")

    if !(cache) then return {} end

    return cache:GetEntries()
end

--[[
    MG2_TERRITORIES:GetClaimed(gangid [int])

    - Returns a gangs claimed territories
]]
function MG2_TERRITORIES:GetClaimed(gangid)
    local territories = self:GetAll()
    local claimedTerrs = {}

    for k,v in pairs(territories) do
        if !(v) then continue end

        local claimed = v:GetClaimed()

        if (!claimed || claimed.gangid != gangid) then continue end
 
        claimedTerrs[k] = v
    end

    return claimedTerrs
end

--[[
    Territory Cache(s)
]]
local terrCache = zlib.cache:Register("mg2.Territories")
terrCache.onPlayerReceive = function(s,data)
    for k,v in pairs(data) do
        local terr = MG2_TERRITORIES:Get(k)

        if (!v && terr) then
            // remove territory
            terr:remove()
        elseif (terr) then
            // update territory data
            for i,d in pairs(v) do
                terr:setRawData(i, d)
            end
        else 
            // setup territory
            MG2_TERRITORIES:Setup(k, v)
        end
    end
end

--[[
    Territory Metastructure
]]
local terrMtbl = zlib.object:Create("mg2.Territory")

terrMtbl:setData("ID", false, {shouldSave = false})

terrMtbl:setData("Claimed", false, {
    onSet = function(s,val,oVal,gangid)
        if (!gangid or val == false) then return false end

        local gang = mg2.gang:Get(gangid)

        if !(gang) then return false end

        local cTbl = {}
        cTbl.gangName = gang:GetName()
        cTbl.gangid = gang:GetID()
        cTbl.claimtime = os.time()

        return cTbl
    end,
})

terrMtbl:setData("Name", "Territory", {
    vgui = {
        ["terr.Create"] = {
            index = 1,
            createEle = function(s,pnl,terr)
                local textEntry = vgui.Create("mg2.TextEntry")
                textEntry:SetTall(30)
                textEntry:SetPlaceholder(mg2.lang:GetTranslation("name"))
                textEntry:Dock(TOP)
                textEntry:DockMargin(0,3,0,0)

                local function setFunc(s)
                    local val = s:GetText()

                    terr:SetName(val)
                end

                textEntry.OnEnter = setFunc
                textEntry.OnLoseFocus = setFunc

                return textEntry
            end,
        },
    },
})

terrMtbl:setData("Description", "Territory Description", {
    vgui = {
        ["terr.Create"] = {
            index = 2,
            createEle = function(s,pnl,terr)
                local textEntry = vgui.Create("mg2.TextEntry")
                textEntry:SetTall(30)
                textEntry:SetPlaceholder(mg2.lang:GetTranslation("description"))
                textEntry:Dock(TOP)
                textEntry:DockMargin(0,3,0,0)
                
                local function setFunc(s)
                    local val = s:GetText()

                    terr:SetDescription(val)
                end

                textEntry.OnEnter = setFunc
                textEntry.OnLoseFocus = setFunc

                return textEntry
            end,
        },
    },
})

terrMtbl:setData("Color", Color(255,255,255), {
    vgui = {
        ["terr.Create"] = {
            index = 3,
            createEle = function(s,pnl,terr)
                local header = vgui.Create("mg2.Header", pnl)
                header:Dock(TOP)
                header:DockMargin(0,3,0,0)
                header:SetText(mg2.lang:GetTranslation("selectcolor"))

                local colPicker = vgui.Create("mg2.ColorPicker")
                colPicker:SetTall(50)
                colPicker:Dock(TOP)
                colPicker:SetColor(Color(25,25,25))
                colPicker.OnColorChange = function(s,col)
                    terr:SetColor(Color(col.r or 255, col.g or 255, col.b or 255, col.a or 255))
                end
                
                return colPicker
            end,
        },
    },
})

-- Entity data
terrMtbl:setData("Position", Vector(0,0,0), {})
terrMtbl:setData("Bounds", {Vector(0,0,0), Vector(0,0,0)}, {})
terrMtbl:setData("Entity", false, {
    shouldSave = false,
    onSet = function(s,val,oVal)
        if (IsValid(oVal)) then oVal:Remove() end

        val:SetPos(s:GetPosition())
    end,
})

function terrMtbl:remove()
    local id = self:GetID()

    if !(id) then return end

    local cache = zlib.cache:Get("mg2.Territories")
    cache:removeEntry(id)

    if (SERVER) then
        local ent = self:GetEntity()

        if (IsValid(ent)) then ent:Remove() end

        mg2.gang:SendCacheToPlayer("mg2.Territories", player.GetAll(),
        function(entries)
            return {[id] = false}
        end)
    end
end

function terrMtbl:onSave(data, cb)
    if (!SERVER or !data) then return end

    local id = self:GetID()
    local dtype = zlib.data:GetConnection("mg2.Main")

    if (!id or !dtype) then return end

    dtype:Query("UPDATE `mg2_territories` SET `data`=" .. data .. " WHERE `id`=" .. id,
    function()
        mg2.gang:SendCacheToPlayer("mg2.Territories", player.GetAll(), 
        function(entries)
            return {[id] = self:getDataTable()}
        end)

        if (cb) then cb(self) end
    end)
end

--[[
    Networking
]]
local adminReqs = {}

adminReqs["createTerritory"] = function(ply, val, cb)
    local tData = val.data

    if !(tData) then return end
    
    MG2_TERRITORIES:Create(tData, 
    function(terr)
        local tid = (terr && terr:GetID())

        cb(tid or false)
    end)
end

adminReqs["deleteTerritory"] = function(ply, val, cb)
    local tid = val.id

    if !(tid) then return end

    MG2_TERRITORIES:Delete(tid, 
    function(res)
        cb(res)
    end)
end

adminReqs["reloadAllTerritories"] = function(ply, val, cb)
    MG2_TERRITORIES:Load("*",
    function()
        cb(true)
    end)
end

zlib.network:RegisterAction("mg2.territories.adminRequest", {
    adminOnly = mg2.config.adminGroups,
    onReceive = function(ply, val, cb)
        if !(istable(val)) then return end

        local reqName, data = val.reqName, (val.data or {})
        local req = adminReqs[reqName]
        
        if (req) then
            req(ply, val, cb)
        end
    end,
})

--[[
    Admin Options
]]
local function loadSimpleValVgui(self, pnl, terrid, terr, valName)
    terr = (terr or MG2_TERRITORIES:Get(terrid))

    if !(terr) then return end

    local tVal = terr:getData(valName)

    local cont = vgui.Create("mg2.Container", pnl)
    cont:Dock(TOP)
    cont:DockMargin(0,3,0,0)
    cont:SetTall(55)
    
    local header = vgui.Create("mg2.Header", cont)
    header:Dock(TOP)
    header:SetText(mg2.lang:GetTranslation("territory.SetTerritory", valName:lower()))
    header:SetRounded(false)

    local textEntry = vgui.Create("mg2.TextEntry", cont)
    textEntry:Dock(FILL)
    textEntry:DockMargin(3,3,3,3)
    textEntry:SetPlaceholder(mg2.lang:GetTranslation("territory.TerritoryName", valName))
    textEntry:SetText(tVal)
    textEntry.OnEnter = function(s)
        local val = s:GetValue()

        self:onUserCall({
            terrid = terrid,
            value = val,
        }, function(res)
            if (res) then terr:setData(valName, val) end
        end)
    end
end

--[[SET TERRITORY NAME]]
local ADMIN_SETTERRITORYNAME = mg2.admin:RegisterOption("territory.SetName")
ADMIN_SETTERRITORYNAME:SetName(mg2.lang:GetTranslation("territory.SetName"))
ADMIN_SETTERRITORYNAME:SetDescription(mg2.lang:GetTranslation("territory.SetNameDesc"))
ADMIN_SETTERRITORYNAME:SetFor("territory")
ADMIN_SETTERRITORYNAME.vguiIndex = 1

function ADMIN_SETTERRITORYNAME:onCall(admin, data, cb)
    local tid, name = data.terrid, data.value

    if (!tid or !name) then return end

    local terr = MG2_TERRITORIES:Get(tid)
    
    if !(terr) then return end

    terr:SetName(name)

    cb(true)
end

function ADMIN_SETTERRITORYNAME:loadVgui(pnl, terrid, terr)
    loadSimpleValVgui(self, pnl, terrid, terr, "Name")
end

--[[SET TERRITORY DESCRIPTION]]
local ADMIN_SETTERRITORYDESC = mg2.admin:RegisterOption("territory.SetDescription")
ADMIN_SETTERRITORYDESC:SetName(mg2.lang:GetTranslation("territory.SetDescription"))
ADMIN_SETTERRITORYDESC:SetDescription(mg2.lang:GetTranslation("territory.SetDescriptionDesc"))
ADMIN_SETTERRITORYDESC:SetFor("territory")
ADMIN_SETTERRITORYDESC.vguiIndex = 2

function ADMIN_SETTERRITORYDESC:onCall(admin, data, cb)
    local tid, desc = data.terrid, data.value

    if (!tid or !desc) then return end

    local terr = MG2_TERRITORIES:Get(tid)

    if !(terr) then return end

    terr:SetDescription(desc)

    cb(true)
end

function ADMIN_SETTERRITORYDESC:loadVgui(pnl, terrid, terr)
    loadSimpleValVgui(self, pnl, terrid, terr, "Description")
end

--[[DELETE TERRITORY]]
local ADMIN_DELETETERRITORY = mg2.admin:RegisterOption("territory.Delete")
ADMIN_DELETETERRITORY:SetName(mg2.lang:GetTranslation("territory.Delete"))
ADMIN_DELETETERRITORY:SetDescription(mg2.lang:GetTranslation("territory.DeleteDesc"))
ADMIN_DELETETERRITORY:SetFor("territory")
ADMIN_DELETETERRITORY.vguiIndex = 100

function ADMIN_DELETETERRITORY:onCall(admin, data, cb)
    local terrid = data.terrid

    if !(terrid) then return end

    MG2_TERRITORIES:Delete(terrid, 
    function(res)
        if !(res) then cb(false) return end

        cb(true)
    end)
end