--[[
    MGangs 2 - UPGRADES - (SH) Init
    Developed by Zephruz
]]

MG2_UPGRADES = mg2.modules:Register("upgrades")
MG2_UPGRADES:SetName("Upgrades")
MG2_UPGRADES:SetDescription("Implements gang upgrades.")
MG2_UPGRADES:SetVersion("V1")

--[[Gang meta registration]]
local gangMeta = zlib.object:Get("mg2.Gang")

gangMeta:setData("Upgrades", {}, {
    onSet = function(s,uName,oVal,tier)
        oVal = (oVal or {})

        if !(tier) then return (uName or oVal) end

        local upg = MG2_UPGRADES:Get(uName)

        if !(upg) then return oVal end -- Invalid upgrade

        oVal[uName] = tier

        return oVal
    end,
    onGet = function(s,val,uName)
        if !(uName) then return val end
        
        local upg = MG2_UPGRADES:Get(uName)

        if !(upg) then return false end -- Invalid upgrade

        return upg:GetTiers(val[uName] || 0)
    end,
})

--[[
    Includes
]]
AddCSLuaFile("sh_config.lua")
include("sh_config.lua")

AddCSLuaFile("sh_upgrades.lua")
include("sh_upgrades.lua")

AddCSLuaFile("vgui/menu_upgrade.lua")
include("vgui/menu_upgrade.lua")

--[[Load Upgrades]]
local files, dirs = file.Find("mg2/modules/upgrades/upgrades/upg_*", "LUA")

for k,v in pairs(files) do
    zlib.util:IncludeByPath(v, "upgrades/")
end