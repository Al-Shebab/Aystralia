--[[
    MGangs 2 - STASH - (SH) Init
    Developed by Zephruz
]]

MG2_STASH = mg2.modules:Register("stash")
MG2_STASH:SetName("Stash")
MG2_STASH:SetDescription("Implements gang stashes.")
MG2_STASH:SetVersion("V1")

-- DON'T EDIT THESE
MG2_STASH:setData("ClassName", {}, {
    shouldSave = false,
    onSet = function(s,cName,oVal,name)
        if !(name) then return (oVal or {}) end

        oVal = (oVal or {})
        oVal[cName] = name

        return oVal
    end,
    onGet = function(s,val,name) return (val && val[name] || name) end,
})

MG2_STASH:setData("InventoryType", false, {
    shouldSave = false,
    onGet = function(s,val)
        local cache = zlib.cache:Get("mg2.StashInvTypes")

        if !(cache) then return val end

        return cache:getEntry(val)
    end,
})

MG2_STASH:setData("ItemBlacklist", {}, {shouldSave = false})

--[[
    Includes
]]
AddCSLuaFile("sh_config.lua")
include("sh_config.lua")

AddCSLuaFile("sh_types.lua")
include("sh_types.lua")

AddCSLuaFile("sh_stash.lua")
include("sh_stash.lua")

AddCSLuaFile("cl_init.lua")
include((SERVER && "sv" || "cl") .. "_init.lua")

AddCSLuaFile("vgui/menu_stash.lua")
include("vgui/menu_stash.lua")