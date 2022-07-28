--[[
    MGangs 2 - (SH) VGUI ELEMENT - Check box
    Developed by Zephruz
]]

if (CLIENT) then

surface.CreateFont("mg2.CHECKBOX.SMALL", {
    font = "Abel",
    size = 17,
})

end

local PANEL = {}

function PANEL:Init() 
    self.theme = mg2.vgui:GetCurrentTheme()
end

function PANEL:Paint(w,h)
    local bgCol, bgCheckCol = self.theme:GetColor("checkBox.Background"), self.theme:GetColor("checkBox.Background.Active")

    draw.RoundedBoxEx(4,0,0,w,h,(self:GetChecked() && bgCheckCol || bgCol), true, true, true, true)
end

vgui.Register("mg2.CheckBox", PANEL, "DCheckBox")