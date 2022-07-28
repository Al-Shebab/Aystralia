--[[
     MGangs 2 - HISCORES - (SH) Init
    Developed by Zephruz
]]

MG2_HISCORES = mg2.modules:Register("gang.HiScores")
MG2_HISCORES:SetName("Gang HiScores")
MG2_HISCORES:SetDescription("Implements gang hiscores.")
MG2_HISCORES:SetVersion("V1")
MG2_HISCORES:setData("Types", {}, { -- DON'T EDIT THIS
    shouldSave = false,
    onGet = function(s,val,hisType)
        if !(hisType) then return val end

        return (val && val[hisType] || false)
    end,
})

--[[
    Includes
]]
AddCSLuaFile("sh_hiscores.lua")
include("sh_hiscores.lua")

AddCSLuaFile("vgui/menu_hiscores.lua")
include("vgui/menu_hiscores.lua")

--[[Load Hiscore types]]
local files, dirs = file.Find("mg2/modules/hiscores/types/hiscores_*", "LUA")

for k,v in pairs(files) do
    zlib.util:IncludeByPath(v, "types/")
end