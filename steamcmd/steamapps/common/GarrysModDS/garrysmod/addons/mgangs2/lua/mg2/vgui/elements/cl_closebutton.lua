--[[
    MGangs 2 - (SH) VGUI ELEMENT - Close Button
    Developed by Zephruz
]]

if (CLIENT) then

surface.CreateFont("mg2.CLOSEBUTTON.MEDIUM", {
    font = "Abel",
    size = 25,
})

surface.CreateFont("mg2.CLOSEBUTTON.SMALL", {
    font = "Abel",
    size = 20,
})

end

local PANEL = {}

function PANEL:Init() 
    self.theme = mg2.vgui:GetCurrentTheme()

    self.closeParent = nil
    self.realText = ""

    self:SetText("×")
end

function PANEL:SetText(text)
    DButton.SetText(self, "")

    self.realText = text
end

function PANEL:GetText()
    return self.realText
end

function PANEL:SetCloseParent(parent)
    self.closeParent = parent
end

function PANEL:GetCloseParent()
    return self.closeParent
end

function PANEL:DoClick()
    local cParent = self:GetCloseParent()

    if (IsValid(cParent)) then
        cParent:Remove()
    end
    
    self:OnClose()
end

function PANEL:Paint(w,h)
    local bgCol, bgHovCol = self.theme:GetColor("closeButton.Background"), self.theme:GetColor("closeButton.Background.Hover")
    local textCol = self.theme:GetColor("closeButton.Text")

    draw.RoundedBoxEx(4,0,0,w,h,(self:IsHovered() && bgHovCol || bgCol), true, true, true, true)
    draw.SimpleText(self:GetText(),"mg2.CLOSEBUTTON.SMALL",w/2,h/2,textCol,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end

function PANEL:OnClose() end

vgui.Register("mg2.CloseButton", PANEL, "DButton")