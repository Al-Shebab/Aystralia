--[[
    MGangs 2 - (SH) Admin
    Developed by Zephruz
]]

mg2.admin = (mg2.admin or {})

--[[
    mg2.admin:RegisterOption(name [string], data [table])

    - Registers an admin option
]]
function mg2.admin:RegisterOption(name, data)
    local opt = {}

    zlib.object:SetMetatable("mg2.AdminOption", opt)

    opt:SetUniqueName(name)

    if (data) then
        for k,v in pairs(data) do
            opt:setRawData(k,v)
        end
    end

    local cache = zlib.cache:Get("mg2.AdminOptions")

    if (cache) then 
        local id, entry = cache:addEntry(opt, name)

        return entry
    end

    return opt
end

--[[
    mg2.admin:GetOption(name [string])

    - Retreives an admin option
]]
function mg2.admin:GetOption(name)
    local cache = zlib.cache:Get("mg2.AdminOptions")

    if !(cache) then return end

    return cache:getEntry(name)
end

--[[
    mg2.admin:GetAllOptions()

    - Returns all admin options
]]
function mg2.admin:GetAllOptions()
    local cache = zlib.cache:Get("mg2.AdminOptions")

    if !(cache) then return {} end

    return cache:GetEntries()
end

--[[
    mg2.admin:GetOptionsFor(forName [string])

    - Retreives admin options with the For value set as forName
]]
function mg2.admin:GetOptionsFor(forName)
    local retOpts = {}

    for k,v in pairs(self:GetAllOptions()) do
        if (v:GetFor() == forName) then
            table.insert(retOpts, v)
        end
    end

    return retOpts
end

--[[
    Admin Cache(s)
]]
zlib.cache:Register("mg2.AdminOptions")

--[[
    Admin Option Metastructure
]]
local adminOptMtbl = zlib.object:Create("mg2.AdminOption")

adminOptMtbl:setData("UniqueName", false, {shouldSave = false})
adminOptMtbl:setData("Name", "OPT.NAME", {shouldSave = false})
adminOptMtbl:setData("Description", "OPT.DESC", {shouldSave = false})
adminOptMtbl:setData("For", false, {shouldSave = false})

//function adminOptMtbl:loadVgui(...) end
function adminOptMtbl:onCall(...) end
function adminOptMtbl:onUserCall(data, cb)
    if (SERVER) then return end

    zlib.network:CallAction("mg2.admin.request", {
        reqName = "callOption",
        optName = self:GetUniqueName(),
        optData = data,
    },
    function(res)
        if (cb) then 
            cb(istable(res) && unpack(res) || res) 
        end
    end)
end

--[[
    Networking
]]
local adminReqs = {}
adminReqs["callOption"] = function(admin, val, cb)
    local optName, optData = val.optName, val.optData
    
    if (!optName or !optData) then return end

    local opt = mg2.admin:GetOption(optName)

    if (opt) then
        opt:onCall(admin, optData, cb)
    end
end

zlib.network:RegisterAction("mg2.admin.request", {
    adminGroups = mg2.config.adminGroups,
    onReceive = function(admin, val, cb)
        if !(istable(val)) then return end

        local reqName, data = val.reqName, (val.data or {})
        local req = adminReqs[reqName]
        
        if (req) then
            req(admin, val, cb)
        end
    end,
})