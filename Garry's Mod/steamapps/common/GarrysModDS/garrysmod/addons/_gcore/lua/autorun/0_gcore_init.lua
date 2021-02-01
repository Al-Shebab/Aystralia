--         _____
--        / ____|                 Package Information
--   __ _| |     ___  _ __ ___    @package      gCore
--  / _` | |    / _ \| '__/ _ \   @author       Guurgle
-- | (_| | |___| (_) | | |  __/   @build        1.0.2
--  \__, |\_____\___/|_|  \___|   @release      06/26/2016
--   __/ |  _              _____                       _
--  |___/  | |            / ____|                     | |
--         | |__  _   _  | |  __ _   _ _   _ _ __ __ _| | ___
--         | '_ \| | | | | | |_ | | | | | | | '__/ _` | |/ _ \
--         | |_) | |_| | | |__| | |_| | |_| | | | (_| | |  __/
--         |____/ \___ |  \_____|\____|\____|_|  \___ |_|\___|
--                 __/ |                          __/ |
--                |___/   (STEAM_0:1:66459838)   |___/

if (SERVER) then
    AddCSLuaFile("libs/pon.lua")
    AddCSLuaFile("libs/netstream2.lua")

    AddCSLuaFile("derma/gframe.lua")
    AddCSLuaFile("derma/gscrollbar.lua")
    AddCSLuaFile("derma/gscrollpanel.lua")

    AddCSLuaFile("sh_gcore.lua")

    resource.AddFile("materials/guurgle/header.png")
end

include("libs/pon.lua")
include("libs/netstream2.lua")
include("sh_gcore.lua")

if (CLIENT) then 
    include("derma/gframe.lua")
    include("derma/gscrollbar.lua")
    include("derma/gscrollpanel.lua")
end