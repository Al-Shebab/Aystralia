--[[
    MGangs 2 - HISCORES - (SH)
    Developed by Zephruz
]]

--[[
    MG2_HISCORES:SetupTemporary(data [table])
]]
function MG2_HISCORES:SetupTemporary(data)
    local hiscore = {}

    zlib.object:SetMetatable("mg2.HiscoreType", hiscore)

    if (data) then
        for k,v in pairs(data) do
            hiscore:setRawData(k,v)
        end
    end

    return hiscore
end

--[[
    MG2_HISCORES:RegisterType(uName [string], data [table])

    - Registers a hiscore type with the specified data
]]
function MG2_HISCORES:RegisterType(uName, data)
    if !(uName) then return end

    local hisType = self:SetupTemporary(data)
    hisType:SetUniqueName(uName)

    local types = self:GetTypes()

    types[uName] = hisType

    self:SetTypes(types)

    return hisType
end

--[[
    Hiscore Metastructure
]]
local hisMtbl = zlib.object:Create("mg2.HiscoreType")

hisMtbl:setData("UniqueName", "UNIQUE.NAME", {shouldSave = false})
hisMtbl:setData("Name", "Name", {shouldSave = false})
hisMtbl:setData("Category", "General", {shouldSave = false})
hisMtbl:setData("Icon", "icon16/exclamation.png", {shouldSave = false})
hisMtbl:setData("Enabled", true, {
    shouldSave = false,
    onGet = function(s,val)
        return (s:hasRequirement() && val)
    end,
})

function hisMtbl:Request(cb)
    if (SERVER || !cb) then return false end

    zlib.network:CallAction("mg2.hiscores.requestValue", {hisName = self:GetUniqueName()},
    function(res)
        cb(res)
    end)

    return true
end

function hisMtbl:onUserRequest(ply, cb) cb(false) end

function hisMtbl:hasRequirement() return true end -- Use to determine if the server/client has a requirement (like a required module or addon)

--[[
    Hiscore Requests
]]
zlib.network:RegisterAction("mg2.hiscores.requestValue", {
    onReceive = function(ply, val, cb)
        if !(istable(val)) then return end

        local hisName = val.hisName
        local hisType = MG2_HISCORES:GetTypes(hisName)
        
        if (hisType) then
            hisType:onUserRequest(ply, cb)
        end
    end,
})
