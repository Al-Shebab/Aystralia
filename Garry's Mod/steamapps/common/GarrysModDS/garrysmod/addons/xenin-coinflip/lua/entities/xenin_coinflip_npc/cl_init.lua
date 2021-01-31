include("shared.lua")

function ENT:Initialize()
  hook.Add("PreDrawEffects", self, function(self)
    local ply = LocalPlayer()
    local pos = self:GetPos()
    local eyePos = ply:GetPos()
    local dist = pos:Distance(eyePos)
    local alpha = math.Clamp(2500 - dist * 2.7, 0, 255)

    if (alpha <= 0) then return end

    local angle = self:GetAngles()
    local eyeAngle = ply:EyeAngles()

    angle:RotateAroundAxis(angle:Forward(), 90)
    angle:RotateAroundAxis(angle:Right(), - 90)

    cam.Start3D2D(pos + self:GetUp() * 95, Angle(0, eyeAngle.y - 90, 90), 0.04)
      XeninUI:DrawNPCOverhead(self, {
        alpha = alpha,
        text = Coinflip.Config.NPCTitle,
        icon = Coinflip.Config.NPCIcon,
        sin = true,
        xOffset = 0,
        textOffset = 0,
        iconMargin = 0,
        color = Coinflip.Config.NPCOutlineColor
      })
    cam.End3D2D()
  end)
end

function ENT:Draw()
  self:DrawModel()
end