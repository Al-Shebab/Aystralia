--[[
    MGangs 2 - (SH) VGUI ELEMENT - Text Entry
    Developed by Zephruz
]]

if (CLIENT) then

surface.CreateFont("mg2.TEXTENTRY.MEDIUM", {
    font = "Abel",
    size = 25,
})

surface.CreateFont("mg2.TEXTENTRY.SMALL", {
    font = "Abel",
    size = 18,
})

end

local PANEL = {}

function PANEL:Init()
    self.theme = mg2.vgui:GetCurrentTheme()

    self:SetTall(25)

    self.placeholderText = ""
end

function PANEL:SetPlaceholder(val)
    self.placeholderText = val
end

function PANEL:GetPlaceholder()
    return self.placeholderText
end

function PANEL:Paint(w,h)
    local bgCol, bgACol = self.theme:GetColor("textentry.Background"), self.theme:GetColor("textentry.Background.Active")
    local textCol = self.theme:GetColor("textentry.Text")

    draw.RoundedBoxEx(4,0,0,w,h,(self:HasFocus() && bgACol || bgCol),true,true,true,true)

    self:DrawTextEntryText(textCol, Color(55,55,55,155), Color(255,255,255))

    if (#self:GetText() <= 0) then
        draw.SimpleText(self:GetPlaceholder(),"mg2.TEXTENTRY.SMALL",5,h/2,Color(155,155,155,200),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    end
end

vgui.Register("mg2.TextEntry", PANEL, "DTextEntry")