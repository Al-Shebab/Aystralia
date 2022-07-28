--[[
    MGangs 2 - (SH) VGUI
    Developed by Zephruz
]]

mg2.vgui = (mg2.vgui or {})

function mg2.vgui:Load()
    local defTheme = mg2.config.defaultTheme
    defTheme = (defTheme || "Default")

    self:SetCurrentTheme(defTheme)
end

function mg2.vgui:GetMetatableOptions(mtName, vguiOpt)
    local mtbl = zlib.object:Get(mtName)

    if (!mtbl or !vguiOpt) then return {} end

    local opts = {}

    for k,v in pairs(mtbl:getParameterTable()) do
        local vguiOpt = (v.vgui && v.vgui[vguiOpt])

        if (vguiOpt) then
            opts[k] = vguiOpt
        end
    end

    return opts
end

--[[
    Includes
]]

-- Menus
AddCSLuaFile("sh_menus.lua")
include("sh_menus.lua")

-- Themes
AddCSLuaFile("sh_themes.lua")
include("sh_themes.lua")

-- [[Elements]]
local files, dirs = file.Find("mg2/vgui/elements/cl_*", "LUA")

for k,v in pairs(files) do
    zlib.util:IncludeByPath(v, "elements/")
end

mg2.vgui:Load()