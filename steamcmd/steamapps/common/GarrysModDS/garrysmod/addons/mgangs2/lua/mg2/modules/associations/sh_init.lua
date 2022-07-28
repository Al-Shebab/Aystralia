--[[
    MGangs 2 - ASSOCIATIONS - (SH) Init
    Developed by Zephruz
]]

MG2_ASSOCIATIONS = mg2.modules:Register("associations")
MG2_ASSOCIATIONS:SetName("Associations")
MG2_ASSOCIATIONS:SetDescription("Implements associations.")
MG2_ASSOCIATIONS:SetVersion("V1")
MG2_ASSOCIATIONS:setData("AssociationTypes", {}, { -- DON'T EDIT THIS
    onGet = function(s,val,assocType)
        if !(assocType) then return end

        return (val && val[assocType] || false)
    end,
})

--[[
    Includes
]]
AddCSLuaFile("sh_config.lua")
include("sh_config.lua")

AddCSLuaFile("sh_associations.lua")
include("sh_associations.lua")

AddCSLuaFile("vgui/menu_associations.lua")
include("vgui/menu_associations.lua")

if (SERVER) then include("sv_init.lua") end