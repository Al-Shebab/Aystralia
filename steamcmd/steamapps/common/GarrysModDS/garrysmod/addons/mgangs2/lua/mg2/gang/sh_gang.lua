--[[
    MGangs 2 - (SH) Gang
    Developed by Zephruz
]]

mg2.gang = (mg2.gang or {})

--[[
    mg2.gang:SetupTemporary(data [table])

    [INTERNAL FUNCTION]
    - Sets a gang object up with the specified information
]]
function mg2.gang:SetupTemporary(data)
    local gang = {}

    zlib.object:SetMetatable("mg2.Gang", gang)

    if (data) then
        for k,v in pairs(data) do
            gang:setRawData(k,v)
        end
    end

    return gang
end

--[[
    mg2.gang:Setup(id [integer], data [table])

    [INTERNAL FUNCTION]
    - Sets a gang object up with the specified information
]]
function mg2.gang:Setup(id, data)
    if !(id) then return end

    local gang = self:SetupTemporary(data)
    gang:SetID(id)

    local cache = zlib.cache:Get("mg2.Gangs")

    if (cache) then 
        local id, entry = cache:addEntry(gang, id)

        if (SERVER && entry) then
            self:SendCacheToPlayer("mg2.Gangs", player.GetAll(),
            function(entries)
                return {[id] = entry:getDataTable()}
            end)
        end
        
        return entry
    end

    return gang
end

--[[
    mg2.gang:GetAll()

    - Returns all cached gangs
]]
function mg2.gang:GetAll()
    local cache = zlib.cache:Get("mg2.Gangs")

    if !(cache) then return {} end

    return cache:GetEntries()
end

--[[
    mg2.gang:Get(id [integer])
    
    - Returns a cached gang (or none)
]]
function mg2.gang:Get(id)
    local cache = zlib.cache:Get("mg2.Gangs")

    if !(cache) then return end

    return cache:getEntry(id)
end

--[[
    mg2.gang:GetOnlineMembers(id [int])

    - Returns online gang members
]]
function mg2.gang:GetOnlineMembers(id)
    local gangMems = {}

    for k,v in pairs(player.GetAll()) do
        if (v:GetGangID() == id) then
            table.insert(gangMems, v)
        end
    end

    return gangMems
end

--[[
    mg2.gang:CalculateExpToLevel(level [int])

    - Returns the total amount of exp needed to level
]]
function mg2.gang:CalculateExpToLevel(level)
    local lvlCfg = mg2.config.gangLeveling
    local expToLvl = (lvlCfg && lvlCfg.expCalculation)
    expToLvl = (expToLvl && expToLvl(level))

    return (expToLvl or 1000)
end

--[[
    mg2.gang:GetMaxLevel()

    - Returns the max level (or false if there isn't one)
]]
function mg2.gang:GetMaxLevel()
    local lvlCfg = mg2.config.gangLeveling
    local maxLvl = (lvlCfg && lvlCfg.maxLevel)

    return (maxLvl or false)
end

--[[
    mg2.gang:GetCurrencyType()

    - Returns the currency type
]]
function mg2.gang:GetCurrencyType()
    local cType = mg2.config.currencyType

    if !(cType) then return end

    cType = mg2.config.currencyTypes[cType]

    return (cType && cType.typeValid() && cType || false)
end

--[[
    mg2.gang:FormatCurrency(val)

    - Formats a number value into a currency string
]]
function mg2.gang:FormatCurrency(val)
    if !(val) then val = 0 end

    val = math.Round(val, 2)

    return (mg2.config.balanceSymbol or "$") .. zlib.util:FormatNumber(val)
end

--[[
    mg2.gang:GetIconMatName(id)

    - Returns the material name for a gangs icon
]]
function mg2.gang:GetIconMatName(id)
    local gang = self:Get(id)

    if !(gang) then return "" end

    local gMatName = string.format("%s%s", gang:GetID(), gang:GetName())

    return "mg2_material_" .. string.gsub(gMatName, "[^0-9a-zA-Z]+", "")
end

--[[
    Player meta
]]
local pMeta = FindMetaTable("Player")

function pMeta:GetGang()
    return mg2.gang:Get(self:GetGangID())
end

function pMeta:GetGangID()
    return self:GetNWInt("mg2.GangID", -1)
end

function pMeta:SetGangID(id)
    id = tonumber(id)

    if (id) then
        self:SetNWInt("mg2.GangID", (id || -1))
    else
        mg2:ConsoleMessage(string.format("Unable to set gangID for player (%s)", self:SteamID()))
    end
end

function pMeta:IsInGang()
    return self:GetGangID() > 0
end

--[[
    Gang Cache(s)
]]
-- Gang cache
local gangCache = zlib.cache:Register("mg2.Gangs")
gangCache.onPlayerReceive = function(s,data)
    for k,v in pairs(data) do
        local gang = mg2.gang:Get(k)

        if (!v && gang) then
            // remove gang from cache
            gang:remove()
        elseif (gang) then
            // update gang data
            for i,d in pairs(v) do
                gang:setRawData(i, d)
            end
        else 
            // setup gang
            mg2.gang:Setup(k, v)
        end
    end
end

--[[
    Gang Metastructure
]]
local gangMtbl = zlib.object:Create("mg2.Gang")

gangMtbl:setData("ID", false, {shouldSave = false})

gangMtbl:setData("Name", "GANG.NAME", {
    vgui = {
        ["gang.Create"] = {
            index = 1,
            createEle = function(s,pnl,gang)
                local textEntry = vgui.Create("mg2.TextEntry")
                textEntry:SetTall(30)
                textEntry:SetPlaceholder(mg2.lang:GetTranslation("name"))
                textEntry:Dock(TOP)
                textEntry:DockMargin(3,3,3,3)
                textEntry.OnChange = function(s)
                    local val = s:GetText()

                    gang:SetName(val)
                end

                return textEntry
            end,
        },
        ["gang.Settings"] = {
            index = 1,
            createEle = function(s,pnl,gang)
                local gGrp = LocalPlayer():GetGangGroup()

                if !(gGrp:GetPermissions("setname")) then return end

                local perm = mg2.gang:GetPermission("setname")

                if !(perm) then return end

                local size = 55
                local name = gang:GetName()
                
                local cont = vgui.Create("DPanel")
                cont:Dock(TOP)
                cont:SetTall(size)
                cont.Paint = function() end

                local header = vgui.Create("mg2.Header", cont)
                header:Dock(TOP)
                header:DockMargin(3,3,3,0)
                header:SetText(mg2.lang:GetTranslation("name"))

                local textEntry = vgui.Create("mg2.TextEntry", cont)
                textEntry:SetPlaceholder(mg2.lang:GetTranslation("gangname"))
                textEntry:Dock(FILL)
                textEntry:DockMargin(3,3,3,3)
                textEntry:SetValue(name)
                textEntry.OnEnter = function(s)
                    local val = s:GetText()
                    
                    perm:onUserCall({ val },
                    function(res)
                        if !(res) then return end

                        gang:SetName(val)
                    end)
                end
                textEntry.OnLoseFocus = textEntry.OnEnter

                return cont
            end,
        },
    },
})

gangMtbl:setData("MOTD", "Welcome to the gang!", {
    onSet = function(s,val,oVal)
        local canSetMOTD = (hook.Run("mg2.gang.SetMOTD", s, val, oVal) != false)

        if !(canSetMOTD) then return oVal end

        return val
    end,
    vgui = {
        ["gang.Settings"] = {
            index = 2,
            createEle = function(s,pnl,gang)
                local gGrp = LocalPlayer():GetGangGroup()

                if !(gGrp:GetPermissions("setmotd")) then return end

                local perm = mg2.gang:GetPermission("setmotd")

                if !(perm) then return end

                local size = 100
                local motd = gang:GetMOTD()
                
                local cont = vgui.Create("DPanel")
                cont:Dock(TOP)
                cont:SetTall(size)
                cont.Paint = function() end

                local header = vgui.Create("mg2.Header", cont)
                header:Dock(TOP)
                header:DockMargin(3,3,3,0)
                header:SetText(mg2.lang:GetTranslation("motd"))

                local textEntry = vgui.Create("mg2.TextEntry", cont)
                textEntry:Dock(FILL)
                textEntry:DockMargin(3,3,3,0)
                textEntry:SetMultiline(true)
                textEntry:SetPlaceholder(mg2.lang:GetTranslation("gangmotd"))
                textEntry:SetEnterAllowed(false)
                textEntry:SetText(motd)
                textEntry.OnLoseFocus = function(s)
                    local val = s:GetText()
            
                    perm:onUserCall({ val },
                    function(res)
                        if !(res) then return end

                        gang:SetMOTD(val)
                    end)
                end

                return cont
            end,
        }
    }
})

gangMtbl:setData("Icon", "https://zephruz.net/img/mgangs2_logo.png", {
    vgui = {
        ["gang.Create"] = {
            index = 3,
            createEle = function(s,pnl,gang)
                local size = 70

                local cont = vgui.Create("DPanel", pnl)
                cont:Dock(TOP)
                cont:SetTall(size)
                cont.Paint = function() end

                local httpImg = vgui.Create("mg2.HTMLImage", cont)
                httpImg:Dock(LEFT)
                httpImg:DockMargin(3,3,3,3)
                httpImg:SetSize(size,size)
                httpImg:SetURL(gang:GetIcon())
                httpImg:SetMaterialPrefix(string.format("%s%s", gang:GetID(), gang:GetName()))
                
                local textEntry = vgui.Create("mg2.TextEntry", cont)
                textEntry:SetTall(size)
                textEntry:SetPlaceholder(mg2.lang:GetTranslation("iconmustbeurl"))
                textEntry:Dock(FILL)
                textEntry:DockMargin(3,3,3,3)
                textEntry.OnEnter = function(s)
                    local val = s:GetText()

                    gang:SetIcon(val)
                    httpImg:SetURL(val)
                end

                return cont
            end,
        },
        ["gang.Settings"] = {
            index = 2,
            createEle = function(s,pnl,gang)
                local gGrp = LocalPlayer():GetGangGroup()

                if !(gGrp:GetPermissions("seticon")) then return end

                local perm = mg2.gang:GetPermission("seticon")

                if !(perm) then return end

                local size = 75
                local icon = gang:GetIcon()
                
                -- Icon & header cont
                local cont = vgui.Create("DPanel")
                cont:Dock(TOP)
                cont:SetTall(size)
                cont.Paint = function() end

                local header = vgui.Create("mg2.Header", cont)
                header:Dock(TOP)
                header:DockMargin(3,0,3,0)
                header:SetText(mg2.lang:GetTranslation("icon"))

                -- Icon cont
                size = (size - header:GetTall())

                local iconCont = vgui.Create("DPanel", cont)
                iconCont:Dock(FILL)
                iconCont:DockMargin(3,3,3,0)
                iconCont.Paint = function() end

                local httpImg = vgui.Create("mg2.HTMLImage", iconCont)
                httpImg:Dock(LEFT)
                httpImg:SetWide(size)
                httpImg:SetURL(icon)
                httpImg:SetMaterialPrefix(string.format("%s%s", gang:GetID(), gang:GetName()))
                
                local textEntry = vgui.Create("mg2.TextEntry", iconCont)
                textEntry:SetPlaceholder(mg2.lang:GetTranslation("iconmustbeurl"))
                textEntry:Dock(FILL)
                textEntry:DockMargin(3,0,0,0)
                textEntry:SetValue(icon)
                textEntry.OnEnter = function(s)
                    local val = s:GetText()
                    
                    perm:onUserCall({ val },
                    function(res)
                        if !(res) then return end
                        
                        gang:SetIcon(val)
                        httpImg:SetURL(val)
                    end)
                end
                textEntry.OnLoseFocus = textEntry.OnEnter

                return cont
            end,
        },
    },
})

gangMtbl:setData("Color", Color(125,125,125), {
    vgui = {
        ["gang.Create"] = {
            index = 4,
            createEle = function(s,pnl,gang)
                local size = 70

                local header = vgui.Create("mg2.Header", pnl)
                header:Dock(TOP)
                header:DockMargin(0,3,0,0)
                header:SetText(mg2.lang:GetTranslation("selectcolor"))

                local colPicker = vgui.Create("mg2.ColorPicker")
                colPicker:Dock(TOP)
                colPicker:SetTall(35)
                colPicker:SetColor(Color(125,125,125))
                colPicker.OnColorChange = function(s,col)
                    gang:SetColor(Color(col.r or 125, col.g or 125, col.b or 125, col.a or 125))
                end

                return colPicker
            end,
        },
        ["gang.Settings"] = {
            index = 3,
            createEle = function(s,pnl,gang)
                local gGrp = LocalPlayer():GetGangGroup()

                if !(gGrp:GetPermissions("setcolor")) then return end

                local perm = mg2.gang:GetPermission("setcolor")

                if !(perm) then return end

                local size = 60
                local color = gang:GetColor()
                
                -- Color & header cont
                local cont = vgui.Create("DPanel")
                cont:Dock(TOP)
                cont:SetTall(size)
                cont.Paint = function() end

                local header = vgui.Create("mg2.Header", cont)
                header:Dock(TOP)
                header:DockMargin(3,3,3,0)
                header:SetText(mg2.lang:GetTranslation("color"))

                -- Color cont
                local colorCont = vgui.Create("DPanel", cont)
                colorCont:Dock(FILL)
                colorCont:DockMargin(3,0,3,0)
                colorCont.Paint = function() end

                local colPicker = vgui.Create("mg2.ColorPicker", colorCont)
                colPicker:Dock(FILL)
                colPicker:DockMargin(3,0,0,0)
                colPicker:SetColor(color || Color(125, 125, 125))
                
                local saveColBtn = vgui.Create("mg2.Button", colorCont)
                saveColBtn:SetText(mg2.lang:GetTranslation("save"))
                saveColBtn:Dock(RIGHT)
                saveColBtn:DockMargin(3,3,3,3)
                saveColBtn.DoClick = function(s)
                    local col = colPicker:GetColor()

                    perm:onUserCall({ col },
                    function(res)
                        if !(res) then return end
                        
                        gang:SetColor(Color(col.r or 125, col.g or 125, col.b or 125, col.a or 125))
                    end)
                end

                return cont
            end,
        },
    },
})

gangMtbl:setData("Level", 1, {
    onSet = function(s,val,oVal)
        val = (tonumber(val) or 1)

        local maxLvl = mg2.gang:GetMaxLevel()

        if (maxLvl && val > maxLvl) then
            if (s:GetEXP() != 0) then s:SetEXP(0) end

            val = maxLvl
        end

        hook.Run("mg2.gang.SetLevel", s, val, oVal)

        return val
    end,
})

gangMtbl:setData("EXP", 0, {
    onSet = function(s,val,oVal)
        val = (tonumber(val) or 1)

        local curLvl = (s:GetLevel() or 1)
        local maxLvl, expToLevel = mg2.gang:GetMaxLevel(), mg2.gang:CalculateExpToLevel(curLvl)
        local leftOverExp = false
        
        if (expToLevel && expToLevel <= val) then
            leftOverExp = (val - expToLevel)

            local nextLevel = (curLvl + 1)
            local nextExpToLevel = mg2.gang:CalculateExpToLevel(nextLevel)

            if (leftOverExp >= nextExpToLevel) then
                leftOverExp = leftOverExp - nextExpToLevel

                for i=(nextLevel+1),(nextLevel+(maxLvl or 100)) do -- Loop for max level or 100
                    nextLevel = i
                    nextExpToLevel = mg2.gang:CalculateExpToLevel(nextLevel)

                    if (leftOverExp >= nextExpToLevel) then
                        leftOverExp = (leftOverExp - nextExpToLevel)
                    else
                        break
                    end
                end
            end

            s:SetLevel(nextLevel)
        end

        hook.Run("mg2.gang.SetEXP", s, val, oVal)

        return (leftOverExp or val)
    end,
})

gangMtbl:setData("Balance", 0, {
    onSet = function(s,val,oVal)
        local canDeposit = (hook.Run("mg2.gang.SetBalance", s, val, oVal) != false)

        if !(canDeposit) then return oVal end

        return val
    end,
})

function gangMtbl:getLeaderGroup()
    local groups = mg2.gang:GetGroups(self:GetID())

    for k,v in pairs(groups) do
        if (v && v:GetIsLeader()) then
            return v
        end
    end
end

function gangMtbl:getRecruitGroup()
    local groups = mg2.gang:GetGroups(self:GetID())

    for k,v in pairs(groups) do
        if (v && v:GetIsRecruit()) then
            return v
        end
    end
end

function gangMtbl:getGroup(id)
    local group = mg2.gang:GetGroup(id)

    if !(group) then return end

    return (group:GetGangID() == self:GetID() && group)
end

function gangMtbl:getGroups()
    return mg2.gang:GetGroups(self:GetID())
end

function gangMtbl:remove()
    local id = self:GetID()

    if !(id) then return end

    local cache = zlib.cache:Get("mg2.Gangs")
    cache:removeEntry(id)

    if (SERVER) then
        mg2.gang:SendCacheToPlayer("mg2.Gangs", player.GetAll(),
        function(entries)
            return {[id] = false}
        end)
    end
end

function gangMtbl:onSave(data, cb)
    if (!SERVER or !data) then return end

    local id = self:GetID()
    local dtype = zlib.data:GetConnection("mg2.Main")

    if (!id or !dtype) then return end
    
    dtype:Query("UPDATE `mg2_gangs` SET `data`=" .. data .. " WHERE `id`=" .. id,
    function()
        mg2.gang:SendCacheToPlayer("mg2.Gangs", player.GetAll(), 
        function(entries)
            return {[id] = self:getDataTable()}
        end)

        if (cb) then cb(self) end
    end)
end

--[[
    Networking
]]
local userReqs = {}
userReqs["createGang"] = function(ply, data, cb)
    if (ply:GetGang()) then cb({res = false, msg = "gang.AlreadyInGang"}) return end

    local gData, grpsData = data.gang, data.groups

    if (!gData or !grpsData) then return end

    local profCheck = {}

    -- Setup temporary gang to validate data
    local tempGang = mg2.gang:SetupTemporary(gData)
    gData = tempGang:getValidatedData()

    -- Validate gang name
    local gangName = tempGang:GetName()

    if (string.len(gangName) > mg2.config.maxGangNameSize) then
        cb({res = false, msg = "gang.NameTooLong"})

        return
    end

    table.insert(profCheck, gangName)

    -- Setup temporary groups to validate data
    local groups = {}

    for k,v in pairs(grpsData) do
        local grp = mg2.gang:SetupTemporaryGroup(v)
        local grpName = grp:GetName()

        groups[grpName] = grp:getValidatedData()

        table.insert(profCheck, grpName)
    end

    -- Check gang name & group names for profanity
    zlib.util:ContainsProfanity(table.concat(profCheck, ", "),
    function(hasProf)
        if (hasProf) then
            cb({res = false, msg = "gang.name.Profane"})

            return
        end

        local curType, gangCost = mg2.gang:GetCurrencyType(), mg2.config.gangCost
        local chargeFor = (curType && gangCost)

        if (chargeFor) then 
            if !(curType.canAfford(ply, gangCost)) then
                cb({res = false, msg = "gang.CantAfford"})

                return
            end
        end

        -- Create gang
        mg2.gang:Create(gData, groups,
        function(gang)
            if !(gang) then
                cb({res = false, msg = "gang.FailedToCreate"})
                
                return 
            end

            -- Charge for gang
            if (chargeFor) then
                curType.takeMoney(ply, gangCost)
            end

            -- Send created results
            cb({res = true, msg = "gang.Created"})
        end,
        function(gang, group)
            if (group && group:GetIsLeader()) then
                mg2.gang:SetPlayerGang(ply, gang:GetID(), group:GetID())
            end
        end)
    end, mg2.config.profanityFilter, mg2.config.useProfanityFilterAPI)
end

userReqs["getGangMembers"] = function(ply, data, cb)
    if !(ply:GetGang()) then return end

    local pgVal, srchVal = data.page, data.searchVal
    local dtype = zlib.data:GetConnection("mg2.Main")

    if (!dtype or (!pgVal && !srchVal)) then return end
    
    local gangid = ply:GetGangID()

    dtype:Query("SELECT COUNT(*) FROM `mg2_users` WHERE `gang_id`=" .. dtype:EscapeString(gangid),
    function(data)
        data = (data && data[1])

        local count = (data && data["COUNT(*)"])
        
        if !(count) then return end

        local maxRes = 25
        local numPgs = math.ceil(count/maxRes)

        local function deserializeData(data)
            for k,v in pairs(data) do
                if (v.data) then
                    data[k].data = zlib.util:Deserialize(v.data)
                end
            end

            return data
        end
        
        -- Construct query
        local query = false

        if (pgVal) then
            local maxMems = (maxRes * pgVal)
            local minMems = (maxMems - maxRes)
            
            query = "SELECT steamid, gang_id, group_id, data FROM `mg2_users` WHERE `gang_id`=" .. dtype:EscapeString(gangid) .. " LIMIT " .. minMems .. ", " .. maxMems
        elseif (srchVal) then
            srchVal = dtype:EscapeString("%" .. srchVal .. "%")

            query = "SELECT steamid, gang_id, group_id, data FROM `mg2_users` WHERE `gang_id`=" .. dtype:EscapeString(gangid) .. " AND (`group_id` LIKE " .. srchVal .. " OR `steamid` LIKE " .. srchVal .. " OR `data` LIKE " .. srchVal .. ") LIMIT 0, " .. maxRes
        end

        -- Run query
        if (query) then
            dtype:Query(query,
            function(data)
                data = deserializeData(data)

                cb({members = data, totalPages = numPgs})
            end)
        end
    end)
end

userReqs["leaveGang"] = function(ply, data, cb)
    if !(ply:GetGang()) then return end

    mg2.gang:RemovePlayer(ply:SteamID(),
    function(res)
        cb(res)
    end)
end

userReqs["setPermission"] = function(ply, data, cb)
    local gang, gangGrp = ply:GetGang(), ply:GetGangGroup()

    if (!gang or !gangGrp) then return end
    
    local perm, permData = data.permName, data.permData
    local hasPerm = gangGrp:GetPermissions(perm)

    perm = mg2.gang:GetPermission(perm)

    if (!perm or !permData or !hasPerm) then return end

    perm:onCall(ply, 
    function(...)
        cb({...})
    end, unpack(permData))
end

userReqs["getInvites"] = function(ply, data, cb)
    if (ply:GetGang()) then return end

    mg2.gang:GetPlayerInvites(ply,
    function(invites)
        cb(invites)
    end)
end

userReqs["respondToInvite"] = function(ply, data, cb)
    local inviteid, respVal = data.inviteid, data.response

    if !(inviteid) then return end

    mg2.gang:RespondToInvite(ply, inviteid, respVal,
    function(res)
        cb(res)
    end)
end

zlib.network:RegisterAction("mg2.gang.userRequest", {
    onReceive = function(ply, val, cb)
        if !(istable(val)) then return end

        local reqName, data = val.reqName, (val.data or {})
        local req = userReqs[reqName]
        
        if (req) then
            req(ply, val, cb)
        end
    end,
})

--[[ADMIN REQUESTS]]
local adminReqs = {}
adminReqs["getUsers"] = function(ply, data, cb)
    local pgVal, srchVal = data.page, data.searchVal
    local dtype = zlib.data:GetConnection("mg2.Main")

    if (!dtype or (!pgVal && !srchVal)) then return end

    dtype:Query("SELECT COUNT(*) FROM `mg2_users`",
    function(data)
        data = (data && data[1])

        local count = (data && data["COUNT(*)"])
        
        if !(count) then return end

        local maxRes = 25
        local numPgs = math.ceil(count/maxRes)

        local function deserializeData(data)
            for k,v in pairs(data) do
                if (v.data) then
                    data[k].data = zlib.util:Deserialize(v.data)
                end
            end

            return data
        end

        local query = false

        if (pgVal) then
            local maxMems = (maxRes * pgVal)
            local minMems = (maxMems - maxRes)

            query = "SELECT steamid, gang_id, group_id, data FROM `mg2_users` LIMIT " .. minMems .. ", " .. maxMems
        elseif (srchVal) then
            srchVal = dtype:EscapeString("%" .. srchVal .. "%")

            query = "SELECT steamid, gang_id, group_id, data FROM `mg2_users` WHERE (`gang_id` LIKE " .. srchVal .. " OR `group_id` LIKE " .. srchVal .. " OR `steamid` LIKE " .. srchVal .. " OR `data` LIKE " .. srchVal .. ") LIMIT 0, " .. maxRes
        end

        if (query) then
            dtype:Query(query,
            function(data)
                data = deserializeData(data)

                cb({users = data, totalPages = numPgs})
            end)
        end
    end)
end

adminReqs["getGangs"] = function(ply, data, cb)
    local pgVal, srchVal = data.page, data.searchVal
    local dtype = zlib.data:GetConnection("mg2.Main")

    if (!dtype or (!pgVal && !srchVal)) then return end

    dtype:Query("SELECT COUNT(*) FROM `mg2_gangs`",
    function(data)
        data = (data && data[1])

        local count = (data && data["COUNT(*)"])
        
        if !(count) then return end

        local maxRes = 25
        local numPgs = math.ceil(count/maxRes)

        local function deserializeData(data)
            for k,v in pairs(data) do
                if (v.data) then
                    data[k].data = zlib.util:Deserialize(v.data)
                end
            end

            return data
        end

        local query = false

        if (pgVal) then
            local maxGangs = (maxRes * pgVal)
            local minGangs = (maxGangs - maxRes)

            query = "SELECT id, data FROM `mg2_gangs` LIMIT " .. minGangs .. ", " .. maxGangs
        elseif (srchVal) then
            srchVal = dtype:EscapeString("%" .. srchVal .. "%")

            query = "SELECT id, data FROM `mg2_gangs` WHERE (`id` LIKE " .. srchVal .. " OR `data` LIKE " .. srchVal .. ") LIMIT 0, " .. maxRes
        end

        if (query) then
            dtype:Query(query,
            function(data)
                data = deserializeData(data)

                cb({gangs = data, totalPages = numPgs})
            end)
        end
    end)
end

zlib.network:RegisterAction("mg2.gang.adminRequest", {
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

local function loadSimpleValVgui(self, pnl, valName, curVal, onUserCall)
    local cont = vgui.Create("mg2.Container", pnl)
    cont:Dock(TOP)
    cont:DockMargin(0,3,0,0)
    cont:SetTall(55)
    
    local header = vgui.Create("mg2.Header", cont)
    header:Dock(TOP)
    header:SetText(mg2.lang:GetTranslation("set") .. " " .. valName)
    header:SetRounded(false)

    local textEntry = vgui.Create("mg2.TextEntry", cont)
    textEntry:Dock(FILL)
    textEntry:DockMargin(3,3,3,3)
    textEntry:SetPlaceholder(valName)
    textEntry:SetText(curVal != null && curVal || "")
    textEntry.OnEnter = function(s)
        local val = s:GetValue()

        if (onUserCall) then
            onUserCall(val)
        end
    end
end

--[[GANG ADMIN OPTIONS]]
local function loadSimpleValVguiGang(self, pnl, gangid, gang, valName)
    gang = (gang or mg2.gang:Get(gangid))

    if !(gang) then return end

    local curVal = gang:getData(valName)

    loadSimpleValVgui(self, pnl, valName, curVal, 
    function(val)
        self:onUserCall({
            gangid = gangid,
            value = val,
        }, function(res)
            if (res) then gang:setData(valName, val) end
        end)
    end)
end

-- SET GANG NAME
local ADMIN_SETGANGNAME = mg2.admin:RegisterOption("gang.SetName")
ADMIN_SETGANGNAME:SetName(mg2.lang:GetTranslation("gang.SetName"))
ADMIN_SETGANGNAME:SetDescription(mg2.lang:GetTranslation("gang.SetNameDesc"))
ADMIN_SETGANGNAME:SetFor("gang")
ADMIN_SETGANGNAME.vguiIndex = 1

function ADMIN_SETGANGNAME:onCall(admin, data, cb)
    local gid, name = data.gangid, data.value

    if (!gid or !name) then return end

    local function setName(gang)
        gang:SetName(name)

        cb(true)
    end

    local gang = mg2.gang:Get(gid)
    
    if (gang) then setName(gang) return end

    mg2.gang:Load(gid,
    function(gang)
        if !(gang) then cb(false) return end

        setName(gang)
    end, true)
end

function ADMIN_SETGANGNAME:loadVgui(pnl, gangid, gang)
    loadSimpleValVguiGang(self, pnl, gangid, gang, mg2.lang:GetTranslation("name"))
end

-- SET GANG LEVEL
local ADMIN_SETGANGLEVEL = mg2.admin:RegisterOption("gang.SetLevel")
ADMIN_SETGANGLEVEL:SetName(mg2.lang:GetTranslation("gang.SetLevel"))
ADMIN_SETGANGLEVEL:SetDescription(mg2.lang:GetTranslation("gang.SetLevelDesc"))
ADMIN_SETGANGLEVEL:SetFor("gang")
ADMIN_SETGANGLEVEL.vguiIndex = 2

function ADMIN_SETGANGLEVEL:onCall(admin, data, cb)
    local gid, lvl = data.gangid, data.value

    if (!gid or !lvl) then return end

    local function setLevel(gang)
        gang:SetLevel(lvl)

        cb(true)
    end

    local gang = mg2.gang:Get(gid)

    if (gang) then setLevel(gang) return end

    mg2.gang:Load(gid,
    function(gang)
        if !(gang) then cb(false) return end

        setLevel(gang)
    end, true)
end

function ADMIN_SETGANGLEVEL:loadVgui(pnl, gangid, gang)
    loadSimpleValVguiGang(self, pnl, gangid, gang, mg2.lang:GetTranslation("level"))
end

-- SET GANG ICON
local ADMIN_SETGANGICON = mg2.admin:RegisterOption("gang.SetIcon")
ADMIN_SETGANGICON:SetName(mg2.lang:GetTranslation("gang.SetIcon"))
ADMIN_SETGANGICON:SetDescription(mg2.lang:GetTranslation("gang.SetIconDesc"))
ADMIN_SETGANGICON:SetFor("gang")
ADMIN_SETGANGICON.vguiIndex = 3

function ADMIN_SETGANGICON:onCall(admin, data, cb)
    local gid, icon = data.gangid, data.value

    if (!gid or !icon) then return end

    local function setIcon(gang)
        gang:SetIcon(icon)

        cb(true)
    end

    local gang = mg2.gang:Get(gid)
    
    if (gang) then setIcon(gang) return end

    mg2.gang:Load(gid,
    function(gang)
        if !(gang) then cb(false) return end

        setIcon(gang)
    end, true)
end

function ADMIN_SETGANGICON:loadVgui(pnl, gangid, gang)
    loadSimpleValVguiGang(self, pnl, gangid, gang, mg2.lang:GetTranslation("icon"))
end

-- DELETE GANG
local ADMIN_DELETEGANG = mg2.admin:RegisterOption("gang.Delete")
ADMIN_DELETEGANG:SetName(mg2.lang:GetTranslation("gang.Delete"))
ADMIN_DELETEGANG:SetDescription(mg2.lang:GetTranslation("gang.DeleteDesc"))
ADMIN_DELETEGANG:SetFor("gang")
ADMIN_DELETEGANG.vguiIndex = 100

function ADMIN_DELETEGANG:onCall(admin, data, cb)
    local gangid = data.gangid

    if !(gangid) then return end

    mg2.gang:Delete(gangid, 
    function(res)
        if !(res) then cb(false) return end

        cb(true)
    end)
end

--[[USER ADMIN OPTIONS]]
local function loadSimpleValVguiUser(self, pnl, steamid, valName, getCurVal, onResult)
    local ply = zlib.util:GetPlayerBySteamID(steamid)

    if !(ply) then return end

    local curVal = (getCurVal && getCurVal(ply) || "")

    loadSimpleValVgui(self, pnl, valName, curVal, 
    function(val)
        self:onUserCall({
            steamid = steamid,
            value = val,
        }, function(res)
            if (onResult) then onResult(res) end
        end)
    end)
end

-- SET GANG
local ADMIN_SETUSERGANG = mg2.admin:RegisterOption("user.SetGang")
ADMIN_SETUSERGANG:SetName(mg2.lang:GetTranslation("user.SetGang"))
ADMIN_SETUSERGANG:SetDescription(mg2.lang:GetTranslation("user.SetGangDesc"))
ADMIN_SETUSERGANG:SetFor("user")
ADMIN_SETUSERGANG.vguiIndex = 1

function ADMIN_SETUSERGANG:onCall(admin, data, cb)
    local ply, gangid = zlib.util:GetPlayerBySteamID(data.steamid), data.value

    gangid = (gangid && tonumber(gangid))

    if (!ply || !gangid) then return end

    mg2.gang:SetPlayerGang(ply, gangid, nil,
    function(gang)
        cb(gang != false)
    end)
end

function ADMIN_SETUSERGANG:loadVgui(pnl, steamid)
    loadSimpleValVguiUser(self, pnl, steamid, mg2.lang:GetTranslation("gang"),
    function(ply)
        return ply:GetGangID()
    end)
end

-- SET GANG GROUP
local ADMIN_SETUSERGANGGROUP = mg2.admin:RegisterOption("user.SetGangGroup")
ADMIN_SETUSERGANGGROUP:SetName(mg2.lang:GetTranslation("user.SetGangGroup"))
ADMIN_SETUSERGANGGROUP:SetDescription(mg2.lang:GetTranslation("user.SetGangGroupDesc"))
ADMIN_SETUSERGANGGROUP:SetFor("user")
ADMIN_SETUSERGANGGROUP.vguiIndex = 2

function ADMIN_SETUSERGANGGROUP:onCall(admin, data, cb)
    local ply, groupid = zlib.util:GetPlayerBySteamID(data.steamid), data.value
    local gang = (IsValid(ply) && ply:GetGang())

    groupid = (groupid && tonumber(groupid))

    if (!gang || !groupid) then cb(false) return end

    local gangGrp = gang:getGroup(groupid)

    if !(gangGrp) then cb(false) return end

    mg2.gang:SetPlayerGroup(data.steamid, groupid,
    function(group)
        cb(group != nil && group != false)
    end)
end

function ADMIN_SETUSERGANGGROUP:loadVgui(pnl, steamid)
    local ply = zlib.util:GetPlayerBySteamID(steamid)
    local gang = (IsValid(ply) && ply:GetGang())

    if !(gang) then return end

    local cont = vgui.Create("mg2.Container", pnl)
    cont:Dock(TOP)
    cont:DockMargin(0,3,0,0)
    cont:SetTall(55)
    
    local header = vgui.Create("mg2.Header", cont)
    header:Dock(TOP)
    header:SetText("Set Gang Group")
    header:SetRounded(false)

    local dropDown = vgui.Create("mg2.Dropdown", cont)
    dropDown:SetText("Select Gang Group")
    dropDown:Dock(FILL)
    dropDown:DockMargin(3,3,3,3)
    dropDown.OnSelect = function(s, i, val)
        local groupid = s:GetOptionData(i)

        self:onUserCall({
            steamid = steamid,
            value = groupid,
        }, function(res)
            if (onResult) then onResult(res) end
        end)
    end

    -- Load groups
    local curGroupID = ply:GetGangGroupID()
    local groups = gang:getGroups()

    for k,v in pairs(groups) do
        local name = (v && v:GetName())

        if !(name) then continue end

        dropDown:AddChoice(name, k, (k == curGroupID))
    end
end

-- KICK FROM GANG
local ADMIN_KICKFROMGANG = mg2.admin:RegisterOption("user.KickFromGang")
ADMIN_KICKFROMGANG:SetName(mg2.lang:GetTranslation("user.KickFromGang"))
ADMIN_KICKFROMGANG:SetDescription(mg2.lang:GetTranslation("user.KickFromGangDesc"))
ADMIN_KICKFROMGANG:SetFor("user")
ADMIN_KICKFROMGANG.vguiIndex = 100

function ADMIN_KICKFROMGANG:onCall(admin, data, cb)
    local steamid = data.steamid

    if !(steamid) then cb(false) return end

    mg2.gang:RemovePlayer(steamid,
    function(result)
        cb(result)
    end)
end

--[[
    Includes
]]
if (SERVER) then
    include("sv_gang.lua")
end

AddCSLuaFile("sh_groups.lua")
include("sh_groups.lua")
