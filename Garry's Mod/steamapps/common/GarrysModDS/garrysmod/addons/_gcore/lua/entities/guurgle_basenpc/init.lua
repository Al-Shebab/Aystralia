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

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel(self.DefaultModel or "models/gman_high.mdl")
    self:SetHullType(HULL_HUMAN)
    self:SetHullSizeNormal()
    self:SetNPCState(NPC_STATE_SCRIPT)
    self:SetSolid(SOLID_BBOX)
    self:CapabilitiesAdd(bit.bor(CAP_ANIMATEDFACE, CAP_TURN_HEAD))
    self:SetUseType(SIMPLE_USE)
    self:DropToFloor()

    if (self.InitializeNPC) then self:InitializeNPC() end
end

function ENT:OnTakeDamage(dmginfo) return false end

function ENT:AcceptInput(inputName, activator, client, data)
    if (inputName == "Use") then 
        if (client:KeyDown(IN_WALK) and client:IsSuperAdmin()) then
            client:PrintMessage(HUD_PRINTCONSOLE, "-------------------------------------------------------")
            client:PrintMessage(HUD_PRINTCONSOLE, "NPC Data for '" .. self:GetClass() .. "'")
            client:PrintMessage(HUD_PRINTCONSOLE, "Position:  Vector(" .. string.Replace(tostring(self:GetPos()), " ", ", ") .. ")")
            client:PrintMessage(HUD_PRINTCONSOLE, "Angle:     Angle(" .. string.Replace(tostring(self:GetAngles()), " ", ", ") .. ")")
            client:PrintMessage(HUD_PRINTCONSOLE, "Map:       " .. game.GetMap())
            client:PrintMessage(HUD_PRINTCONSOLE, "-------------------------------------------------------")
        else 
            if (self:OnUseCheck(client) and self.OnUseNPC) then
                netstream.Start(client, "gCore_UseNPC", self)
                self:OnUseNPC(client)
            end 
        end
    end
end

function ENT:OnUseCheck(client) return true end