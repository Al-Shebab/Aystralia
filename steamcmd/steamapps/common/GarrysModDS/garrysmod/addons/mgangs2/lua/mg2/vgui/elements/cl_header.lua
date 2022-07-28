--[[
    MGangs 2 - (SH) VGUI ELEMENT - Header
    Developed by Zephruz
]]

if (CLIENT) then

surface.CreateFont("mg2.HEADER.MEDIUM", {
    font = "Abel",
    size = 22,
})

surface.CreateFont("mg2.HEADER.SMALL", {
    font = "Abel",
    size = 18,
})

end

local PANEL = {}

function PANEL:Init()
    self.theme = mg2.vgui:GetCurrentTheme()

    self.isRounded = true

    self._text = ""
end

function PANEL:SetText(val)
    self._text = val
end

function PANEL:GetText()
    return self._text
end

function PANEL:SetRounded(bool)
    self.isRounded = bool
end

function PANEL:GetRounded()
    return self.isRounded
end

function PANEL:Paint(w,h)
    local bgCol, textCol = self.theme:GetColor("header.Background"), self.theme:GetColor("header.Text")
    local rounded = self:GetRounded()
  
    draw.RoundedBoxEx(4,0,0,w,h,bgCol,rounded,rounded,rounded,rounded)
    draw.SimpleText(self:GetText(), "mg2.HEADER.SMALL", 5, h/2, textCol, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

vgui.Register("mg2.Header", PANEL, "DPanel")