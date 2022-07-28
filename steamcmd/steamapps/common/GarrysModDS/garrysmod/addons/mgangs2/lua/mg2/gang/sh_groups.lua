--[[
    MGangs 2 - (SH) Gang groups
    Developed by Zephruz
]]

--[[
    mg2.gang:SetupTemporaryGroup(data [table])

    [INTERNAL FUNCTION]
    - Sets a gang group object up with the specified information
]]
function mg2.gang:SetupTemporaryGroup(data)
    local gangGroup = {}
    
    zlib.object:SetMetatable("mg2.GangGroup", gangGroup)

    if (data) then
        for k,v in pairs(data) do
            gangGroup:setRawData(k,v)
        end
    end

    return gangGroup
end

--[[
    mg2.gang:SetupGroup(id [int], data [table])

    [INTERNAL FUNCTION]
    - Sets a gang group object up with the specified information
]]
function mg2.gang:SetupGroup(id, data)
    if !(id) then return end

    local gangGroup = self:SetupTemporaryGroup(data)
    gangGroup:SetID(id)

    local cache = zlib.cache:Get("mg2.GangGroups")

    if (cache) then 
        local id, entry = cache:addEntry(gangGroup, id)
        
        if (SERVER && entry) then
            self:SendCacheToPlayer("mg2.GangGroups", player.GetAll(),
            function(entries)
                return {[id] = entry:getDataTable()}
            end)
        end

        return entry
    end

    return gangGroup
end

--[[
    mg2.gang:GetAllGroups()

    - Returns all cached gang groups
]]
function mg2.gang:GetAllGroups()
    local cache = zlib.cache:Get("mg2.GangGroups")

    if !(cache) then return end

    return cache:GetEntries()
end

--[[
    mg2.gang:GetGroups(gangid [integer])

    - Returns a gangs groups
]]
function mg2.gang:GetGroups(gangid)
    local gangGroups = {}
    local allGroups = self:GetAllGroups()

    for k,v in pairs(allGroups) do
        if (v:GetGangID() == gangid) then
            gangGroups[k] = v
        end
    end

    return gangGroups
end

--[[
    mg2.gang:GetGroup(id [integer])
]]
function mg2.gang:GetGroup(id)
    local cache = zlib.cache:Get("mg2.GangGroups")

    if !(cache) then return end

    return (cache:getEntry(id) or false)
end

--[[
    Player meta
]]
local pMeta = FindMetaTable("Player")

function pMeta:GetGangGroup()
    return mg2.gang:GetGroup(self:GetGangGroupID())
end

function pMeta:GetGangGroupID()
    return self:GetNWInt("mg2.GangGroupID", -1)
end

function pMeta:SetGangGroupID(id)
    self:SetNWInt("mg2.GangGroupID", (id || -1))
end

--[[
    Group Cache(s)
]]
-- Gang group cache
local gangGrpCache = zlib.cache:Register("mg2.GangGroups")
gangGrpCache.onPlayerReceive = function(s,data)
    for k,v in pairs(data) do
        local group = mg2.gang:GetGroup(k)

        if (!v && group) then
            // remove group
            group:remove()
        elseif (group) then
            // update group data
            for i,d in pairs(v) do
                group:setRawData(i, d)
            end
        else 
            // setup group
            mg2.gang:SetupGroup(k, v)
        end
    end
end

--[[
    Gang Group Metastructure
]]
local gangGrpMtbl = zlib.object:Create("mg2.GangGroup")

gangGrpMtbl:setData("ID", false, {shouldSave = false})
gangGrpMtbl:setData("GangID", false, {shouldSave = false})
gangGrpMtbl:setData("IsLeader", false, {})
gangGrpMtbl:setData("IsRecruit", false, {})

gangGrpMtbl:setData("Name", "GROUP.NAME", {
    vgui = {
        ["gang.GroupEdit"] = {
            index = 1,
            createEle = function(s,pnl,group)
                local textEntry = vgui.Create("mg2.TextEntry")
                textEntry:SetTall(30)
                textEntry:SetPlaceholder(mg2.lang:GetTranslation("name"))
                textEntry:Dock(TOP)
                textEntry:DockMargin(3,3,3,3)
                textEntry:SetText(group && group:GetName() || "")
                textEntry.OnChange = function(s)
                    group:SetName(s:GetText())
                end

                return textEntry
            end,
        },
    },
})
gangGrpMtbl:setData("Icon", "icon16/user.png", {
    vgui = {
        ["gang.GroupEdit"] = {
            index = 2,
            createEle = function(s,pnl,group)
                local dropDown = vgui.Create("mg2.Dropdown")
                dropDown:Dock(TOP)
                dropDown:DockMargin(3,3,3,3)
                dropDown:SetText(mg2.lang:GetTranslation("selecticon"))
                dropDown.OnSelect = function(s, i, val)
                    group:SetIcon("materials/icon16/" .. val)
                end
                
                local files, dirs = file.Find("materials/icon16/*", "GAME")
                
                for k,v in pairs(files) do
                    if (v:StartWith("user") or v:StartWith("world") or v:StartWith("medal")) then
                        dropDown:AddChoice(v)
                    end
                end

                return dropDown
            end,
        },
    },
})

gangGrpMtbl:setData("Priority", 0, {
    vgui = {
        ["gang.GroupEdit"] = {
            index = 3,
            createEle = function(s,pnl,group)
                local slider = vgui.Create("mg2.NumSlider")
                slider:Dock(TOP)
                slider:DockMargin(3,3,3,3)
                slider:SetText(mg2.lang:GetTranslation("priority"))
                slider:SetMin(1)
                slider:SetMax(1000)
                slider:SetValue(group && group:GetPriority() || 1)
                slider.OnValueChanged = function(s, val)
                    group:SetPriority(val)
                end

                return slider
            end,
        },
    },
})

gangGrpMtbl:setData("Permissions", {}, {
    onSet = function(s,permName,oVal,permVal)
        if (permVal == nil) then return (istable(permName) && permName || oVal) end

        local val = (oVal or {})

        if (permName) then
            val[permName] = (isbool(permVal) && permVal || false)
        end

        return val
    end,
    onGet = function(s,val,permName)
        if !(permName) then return val end

        return (s:GetIsLeader() || mg2.gang:GetPermission(permName) && val[permName] || false)
    end,
    vgui = {
        ["gang.GroupEdit"] = {
            index = 6,
            createEle = function(s,pnl,group)
                local cont = vgui.Create("mg2.Container")
                cont:Dock(TOP)
                cont:DockMargin(5,0,5,5)
                cont:SetTall(230)

                local hdr = vgui.Create("mg2.Header", cont)
                hdr:Dock(TOP)
                hdr:SetText(mg2.lang:GetTranslation("permissions"))

                local permSPnl = vgui.Create("mg2.Scrollpanel", cont)
                permSPnl:Dock(FILL)
                permSPnl:DockMargin(0,0,0,5)
                permSPnl:SizeToContents()

                local perms = mg2.gang:GetAllPermissions()
                local permsCat = {}

                -- Categorize permissions
                for k,v in pairs(perms) do
                    local category = v:GetCategory()

                    if !(category) then
                        category = "Misc"
                    end

                    if !(permsCat[category]) then
                        permsCat[category] = {}
                    end

                    permsCat[category][k] = v
                end
                
                for catName,perms in pairs(permsCat) do
                    if (table.Count(perms) <= 0) then continue end

                    local hdr = vgui.Create("mg2.Header", permSPnl)
                    hdr:Dock(TOP)
                    hdr:DockMargin(5,5,5,0)
                    hdr:SetText(catName)

                    for k,v in pairs(perms) do
                        local permVal = group:GetPermissions(k)
                        permVal = (permVal && 1 || 0)
                        
                        local pnl = vgui.Create("DPanel", permSPnl)
                        pnl:Dock(TOP)
                        pnl:DockMargin(5,5,5,0)
                        pnl:SetTall(25)
                        pnl.Paint = function(s,w,h)
                            draw.RoundedBoxEx(4,0,0,w,h,Color(45,45,45),true,true,true,true)
    
                            draw.SimpleText(v:GetName(), "mg2.CREATIONMENU.SMALL", 5, h/2, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                        end
    
                        local cbox = vgui.Create("mg2.CheckBox", pnl)
                        cbox:Dock(RIGHT)
                        cbox:DockMargin(3,3,3,3)
                        cbox:SetValue(permVal)
                        cbox.OnChange = function(s,val)
                            group:SetPermissions(k,val)
                        end
                    end
                end

                return cont
            end,
        },
    },
})

function gangGrpMtbl:remove(gid)
    local id = (self:GetID() or gid)

    if !(id) then return end

    local cache = zlib.cache:Get("mg2.GangGroups")
    cache:removeEntry(id)

    if (SERVER) then
        mg2.gang:SendCacheToPlayer("mg2.GangGroups", player.GetAll(),
        function(entries)
            return {[id] = false}
        end)
    end
end

function gangGrpMtbl:onSave(data, cb)
    if (!SERVER or !data) then return end

    local id = self:GetID()
    local dtype = zlib.data:GetConnection("mg2.Main")

    if (!id or !dtype) then return end

    dtype:Query("UPDATE `mg2_groups` SET `data`=" .. data .. " WHERE `id`=" .. id,
    function()
        local cache = zlib.cache:Get("mg2.GangGroups")
        cache:sendToPlayer(player.GetAll(),
        function(entries)
            return {[id] = self:getDataTable()}
        end)

        if (cb) then cb(self) end
    end)
end

--[[
    Includes
]]
if (SERVER) then
    include("sv_groups.lua")
end

AddCSLuaFile("sh_permissions.lua")
include("sh_permissions.lua")