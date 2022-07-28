--[[
     MGangs 2 - GANGCHAT - (SH) Init
    Developed by Zephruz
]]

MG2_GANGCHAT = mg2.modules:Register("gang.Chat")
MG2_GANGCHAT:SetName("Gang Chat")
MG2_GANGCHAT:SetDescription("Implements gang chatting.")
MG2_GANGCHAT:SetVersion("V1")

MG2_GANGCHAT:setData("ChatPrefix", "GC", {
    onGet = function(s,val)
        if !(CLIENT) then return val end

        local gang = LocalPlayer():GetGang()
        local gName = (gang && gang:GetName())

        if !(gName) then return val end

        return "[" .. val .. " - " .. gName .. "]"
    end,
})

--[[
    Includes
]]
AddCSLuaFile("cl_init.lua")
include((SERVER && "sv" || "cl") .. "_init.lua")