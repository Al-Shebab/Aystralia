--[[
    MGangs 2 - (SH) Init
    Developed by Zephruz
]]

-- Load config(s)
AddCSLuaFile("sh_config.lua")
include("sh_config.lua")
if (SERVER) then include("sv_config.lua") end

-- Load language
AddCSLuaFile("sh_language.lua")
include("sh_language.lua")

-- Load admin
AddCSLuaFile("sh_admin.lua")
include("sh_admin.lua")

-- Load vgui
AddCSLuaFile("vgui/sh_vgui.lua")
include("vgui/sh_vgui.lua")

-- Load gangs
AddCSLuaFile("gang/sh_gang.lua")
include("gang/sh_gang.lua")

-- Load init(s)
AddCSLuaFile("cl_init.lua")
include((SERVER && "sv" || "cl") .. "_init.lua")

-- Load modules
AddCSLuaFile("sh_modules.lua")
include("sh_modules.lua")

--[[
    MGangs 2 Load
]]
if (SERVER) then
    local cfg = mg2.config
    local mysqlInfo = (cfg && cfg.mysqlInfo)

    local dtype = zlib.data:CreateConnection("mg2.Main", mysqlInfo.dbModule, { mysqlInfo = mysqlInfo })
    dtype:Connect(function()
        hook.Run("mg2.data.Initialized", mg2, dtype)
    end,
    function(err) 
        mg2:ConsoleMessage("Failed to connect to DB: ", err)
    end)
end

/* OBSOLETE - USE :Init() METHOD */
function mg2:Load()
    if (SERVER) then
        local cfg = mg2.config
        local mysqlInfo = (cfg && cfg.mysqlInfo)

        local dtype = zlib.data:CreateConnection("mg2.Main", mysqlInfo.dbModule, { mysqlInfo = mysqlInfo })
        dtype:Connect(function()
            hook.Run("mg2.data.Initialized", mg2, dtype)
        end,
        function(err) 
            mg2:ConsoleMessage("Failed to connect to DB: ", err)
        end)
    end
end

--[[
    Commands
]]

--[[
    mg2_reload

    - Completely reloads the addon (core, modules, libraries, etc)
        * If you're an admin, this reloads both locally (yourself) and the server
    - Useful for quickly fixing odd bugs/errors
]]
concommand.Add("mg2_reload", 
function(ply, cmd, args)
    if (SERVER && IsValid(ply) && !table.HasValue(mg2.config.adminGroups, ply:GetUserGroup())) then return end

    mg2:Init()
end)