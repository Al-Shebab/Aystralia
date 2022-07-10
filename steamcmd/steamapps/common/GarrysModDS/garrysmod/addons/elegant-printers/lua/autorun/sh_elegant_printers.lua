hook.Add("Initialize", "elegant_printers", function()
    if not DarkRP then return end

    elegant_printers = elegant_printers or {}

    if SERVER then
        AddCSLuaFile("elegant_printers/cl_main.lua")
        AddCSLuaFile("elegant_printers/sh_config.lua")
        AddCSLuaFile("elegant_printers/sh_upgrades.lua")
        AddCSLuaFile("elegant_printers/sh_main.lua")
        AddCSLuaFile("elegant_printers/sh_addtof4.lua")
    end

    include("elegant_printers/sh_config.lua")
    include("elegant_printers/sh_upgrades.lua")
    include("elegant_printers/sh_main.lua")
    include("elegant_printers/sh_addtof4.lua")

    if SERVER then
        include("elegant_printers/sv_main.lua")
    end

    if CLIENT then
        include("elegant_printers/cl_main.lua")
    end
end)
