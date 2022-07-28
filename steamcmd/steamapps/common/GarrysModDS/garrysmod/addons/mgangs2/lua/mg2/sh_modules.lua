--[[
    MGangs 2 - (SH) Modules
    Developed by Zephruz
]]

mg2.modules =  (mg2.modules or {})

--[[
    mg2.modules:Register(uniqueName [string], data [table (OPTIONAL)])

    - Registers a module
]]
function mg2.modules:Register(uniqueName, data)
    local mod = self:SetupTemporary(data)
    mod:SetID(uniqueName)

    return mod
end

--[[
    mg2.modules:SetupTemporary(data [table])

    - Sets a module object up with the specified data
]]
function mg2.modules:SetupTemporary(data)
    local mod = {}

    zlib.object:SetMetatable("mg2.Module", mod)

    if (data) then
        for k,v in pairs(data) do
            mod:setData(k,v)
        end
    end

    return mod
end

--[[
    mg2.modules:Get(uniqueName [string])

    - Retrieves a module or nil
]]
function mg2.modules:Get(uniqueName)
    local cache = zlib.cache:Get("mg2.Modules")

    if !(cache) then return end

    return cache:getEntry(uniqueName)
end

--[[
    Module Cache
]]
zlib.cache:Register("mg2.Modules")

--[[
    Module Metastructure
]]
local modMtbl = zlib.object:Create("mg2.Module")

modMtbl:setData("ID", false, {})
modMtbl:setData("Name", "MODULE.NAME", {})
modMtbl:setData("Description", "MODULE.DESCRIPTION", {})
modMtbl:setData("Version", "MODULE.VERSION", {})

--[[
    Load modules
]]
local modFiles, modDirs = file.Find("mg2/modules/*", "LUA")

for k,v in pairs(modFiles) do
    zlib.util:IncludeByPath(v, "modules/")
end

for k,v in pairs(modDirs) do
    local modFiles, modDirs = file.Find("mg2/modules/" .. v .. "/*", "LUA")

    zlib.util:IncludeByPath("sh_init.lua", "modules/" .. v .. "/")
end
