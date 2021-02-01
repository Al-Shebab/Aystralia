--        ____        _ _
--       |  _ \      (_) |   Package Information
--   __ _| |_) | __ _ _| |   @package      gBail
--  / _` |  _ < / _` | | |   @author       Guurgle
-- | (_| | |_) | (_| | | |   @build        1.0.2
--  \__, |____/ \__,_|_|_|   @release      06/26/2016
--   __/ |    _              _____                       _
--  |___/    | |            / ____|                     | |
--           | |__  _   _  | |  __ _   _ _   _ _ __ __ _| | ___
--           | '_ \| | | | | | |_ | | | | | | | '__/ _` | |/ _ \
--           | |_) | |_| | | |__| | |_| | |_| | | | (_| | |  __/
--           |_.__/ \__, |  \_____|\__,_|\__,_|_|  \__, |_|\___|
--                   __/ |                          __/ |
--                  |___/                          |___/ 

AddCSLuaFile()

ENT.Base            = "guurgle_basenpc"
ENT.Type            = "ai"
ENT.PrintName       = "gBail NPC"
ENT.Author          = "Guurgle (STEAM_0:1:66459838)"
ENT.Contact         = "N/A"
ENT.Purpose         = "N/A"
ENT.Category        = "Roleplay"

ENT.DefaultModel    = "models/police.mdl"
ENT.NameText        = bailNPC.npcName
ENT.NameColor       = bailNPC.npcNameColor

ENT.Spawnable = true
ENT.AdminOnly = true

function ENT:InitializeNPC() end
function ENT:OnUseCheck(client) return bailNPC.canUseMenu(client, true) end
function ENT:OnUseNPC(client) if (CLIENT) then bailNPC.openMenu() end end