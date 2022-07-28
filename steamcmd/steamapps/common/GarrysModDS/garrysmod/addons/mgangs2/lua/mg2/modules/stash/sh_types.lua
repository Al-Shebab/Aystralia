--[[
    MGangs 2 - STASH - (SH) Types
    Developed by Zephruz
]]

--[[
    MG2_STASH:RegisterInventoryType(name [string], data [table])

    - Registers an inventory type
]]
function MG2_STASH:RegisterInventoryType(name, data)
    if !(name) then return end

    local invType = {}

    zlib.object:SetMetatable("mg2.StashInvType", invType)

    invType:SetUniqueName(name)

    local cache = zlib.cache:Get("mg2.StashInvTypes")

    if (cache) then 
        local name, entry = cache:addEntry(invType, name)

        return entry
    end

    return invType
end

--[[
    Stash Cache(s)
]]
-- Stash type cache
zlib.cache:Register("mg2.StashInvTypes")

--[[
    Stash Type Metastructure
]]
local invTypeMtbl = zlib.object:Create("mg2.StashInvType")

invTypeMtbl:setData("UniqueName", false, {shouldSave = false})
invTypeMtbl:setData("Name", false, {shouldSave = false})

function invTypeMtbl:onDeposit(...) end
function invTypeMtbl:onWithdraw(...) end
function invTypeMtbl:getUserItems(...) end

--[[
    Includes
]]

--[[Types]]
local files, dirs = file.Find("mg2/modules/stash/invtypes/invtype_*", "LUA")

for k,v in pairs(files) do
    zlib.util:IncludeByPath(v, "invtypes/")
end
