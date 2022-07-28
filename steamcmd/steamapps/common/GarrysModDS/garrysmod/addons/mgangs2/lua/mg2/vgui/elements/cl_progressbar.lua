--[[
    MGangs 2 - (SH) VGUI ELEMENT - Progress bar
    Developed by Zephruz
]]

local PANEL = {}

function PANEL:Init()
    self.theme = mg2.vgui:GetCurrentTheme()
end

function PANEL:Paint(w,h)
    local pgFrac = self:GetFraction()
    local bgCol = self.theme:GetColor("progressBar.Background")
    local barCol, barUlCol = self.theme:GetColor("progressBar.Bar"), self.theme:GetColor("progressBar.Bar.Underline")

    draw.RoundedBoxEx(4, 0, 0, w, h, bgCol, true, true, true, true)
    draw.RoundedBoxEx(4, 2, h - 10, (w * pgFrac) - 4, 8, barCol, false, false, true, true)
    draw.RoundedBoxEx(4, 2, 2, (w * pgFrac) - 4, h - 7, barUlCol, true, true, true, true)
end

vgui.Register("mg2.ProgressBar", PANEL, "DProgress")