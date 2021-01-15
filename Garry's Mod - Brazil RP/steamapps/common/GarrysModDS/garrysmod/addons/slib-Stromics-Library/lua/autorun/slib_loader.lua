local function slibInit()
    print("[slib] Loading")

    if SERVER then
        AddCSLuaFile("slib/sh_util.lua")
        include("slib/sh_util.lua")
        include("slib/sv_storage.lua")
    else
        include("slib/sh_util.lua")
    end
    
    slib.loadFolder("slib/vgui/", false, {{"slib/vgui/", "cl_sframe.lua"}})
end

slibInit()