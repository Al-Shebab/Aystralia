--[[
     MGangs 2 - ACHIEVEMENTS - (SH) Init
    Developed by Zephruz
]]

MG2_GANGACHIEVEMENTS = mg2.modules:Register("gang.Achievements")
MG2_GANGACHIEVEMENTS:SetName("Gang Achievements")
MG2_GANGACHIEVEMENTS:SetDescription("Implements gang achievements.")
MG2_GANGACHIEVEMENTS:SetVersion("V1")

--[[Gang meta registration]]
local gangMeta = zlib.object:Get("mg2.Gang")

gangMeta:setData("Achievements", {}, {
    onSet = function(s,val,oVal,tier,has)
        if !(tier) then return (val or oVal) end

        oVal = (oVal or {})
        oVal[val] = (oVal[val] or {})
        oVal[val][tier] = (has or false)

        return oVal
    end,
    onGet = function(s,val,aName,tier)
        if !(aName) then return val end

        local ach = val[aName]

        if (ach && tier) then
            return (ach[tier] or false)
        end

        return false
    end,
})

--[[
    Includes
]]
AddCSLuaFile("sh_achievements.lua")
include("sh_achievements.lua")

AddCSLuaFile("vgui/menu_achievement.lua")
include("vgui/menu_achievement.lua")

--[[Load Achievements]]
local files, dirs = file.Find("mg2/modules/achievements/achievements/ach_*", "LUA")

for k,v in pairs(files) do
    zlib.util:IncludeByPath(v, "achievements/")
end