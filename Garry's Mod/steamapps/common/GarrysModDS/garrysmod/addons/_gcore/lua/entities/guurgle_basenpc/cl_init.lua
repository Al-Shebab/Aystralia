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

surface.CreateFont("BebasNeue90", { font = "Bebas Neue", size = 90 })

include("shared.lua")

function ENT:Initialize()
    if (self.InitializeNPC) then self:InitializeNPC() end
end

function ENT:Draw()
    self.Entity:DrawModel()

    if (self.NameText and type(self.NameText) == "string" and string.len(self.NameText) > 0) then
        local textPosition  = self:GetPos() + (self.namePosition or Vector(0, 0, 77))
        local textAngle     = LocalPlayer():EyeAngles()

        textAngle:RotateAroundAxis(textAngle:Forward(), 90)
        textAngle:RotateAroundAxis(textAngle:Right(), 90)

        cam.Start3D2D(textPosition, Angle(0, textAngle.y, 90), 0.1)
            draw.DrawText(self.NameText, "BebasNeue90", 0, -50, (self.NameColor or Color(255, 255, 255, 255)), TEXT_ALIGN_CENTER)
        cam.End3D2D()
    end
end

netstream.Hook("gCore_UseNPC", function(npcEntity) if (IsValid(npcEntity) and npcEntity.OnUseNPC) then npcEntity:OnUseNPC(LocalPlayer()) end end)