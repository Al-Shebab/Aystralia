--[[
    MGangs 2 - (SH) VGUI ELEMENT - Container
    Developed by Zephruz
]]

local PANEL = {}

function PANEL:Init()
    self.theme = mg2.vgui:GetCurrentTheme()

    self.isRounded = true
end

function PANEL:SetRounded(bool)
    self.isRounded = bool
end

function PANEL:GetRounded()
    return self.isRounded
end

function PANEL:Paint(w,h)
    local bgCol = self.theme:GetColor("container.Background")
    local rounded = self:GetRounded()
  
    draw.RoundedBoxEx(4,0,0,w,h,bgCol,rounded,rounded,rounded,rounded)
end

vgui.Register("mg2.Container", PANEL, "DPanel")