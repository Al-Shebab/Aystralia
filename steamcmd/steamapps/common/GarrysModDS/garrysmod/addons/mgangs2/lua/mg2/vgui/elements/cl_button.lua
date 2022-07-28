--[[
    MGangs 2 - (SH) VGUI ELEMENT - Button
    Developed by Zephruz
]]

if (CLIENT) then

surface.CreateFont("mg2.BUTTON.MEDIUM", {
    font = "Abel",
    size = 25,
})

surface.CreateFont("mg2.BUTTON.SMALL", {
    font = "Abel",
    size = 18,
})

end

local PANEL = {}

function PANEL:Init()
    self.theme = mg2.vgui:GetCurrentTheme()
    self.realText = ""
    self.isRounded = true
    self._icon = false
    self.isDoubleClickConfirm = false

    self:SetText("")
end

function PANEL:SetDoubleClickConfirm(bool)
    self._totalClicks = 0
    self.isDoubleClickConfirm = bool

    if (bool) then
        self.DoClick = function()
            self._totalClicks = self._totalClicks + 1

            if (self._totalClicks >= 2 && self.OnConfirm) then
                self:OnConfirm(self)

                self._totalClicks = 0
            end
        end
    end
end

function PANEL:GetDoubleClickConfirm()
    return self.isDoubleClickConfirm
end

function PANEL:SetIcon(icon)
    self._icon = Material(icon)
end

function PANEL:GetIcon()
    return self._icon
end

function PANEL:SetRounded(bool)
    self.isRounded = bool
end

function PANEL:GetRounded()
    return self.isRounded
end

function PANEL:SetText(text)
    DButton.SetText(self, "")

    self.realText = text
end

function PANEL:GetText()
    return self.realText
end

function PANEL:Paint(w,h)
    local bgCol, bgHovCol, bgDisCol = self.theme:GetColor("button.Background"), self.theme:GetColor("button.Background.Hover"), self.theme:GetColor("button.Background.Disabled")
    local textCol = self.theme:GetColor("button.Text")
    local rounded, icon, dblClick = self:GetRounded(), self:GetIcon(), self:GetDoubleClickConfirm()
    local txt = self:GetText()

    draw.RoundedBoxEx(4,0,0,w,h,((self:GetDisabled() &&  bgDisCol) || (self:IsHovered() && bgHovCol) || bgCol), rounded, rounded, rounded, rounded)

    if (icon) then
        local iH, iW = 16, 16

        surface.SetDrawColor(0, 0, 0, 125)
        surface.SetMaterial(icon)
        surface.DrawTexturedRect(5, (h/2 - iH/2), iH, iW)
    end

    -- Check double click
    if (dblClick && self._totalClicks == 1) then
        txt = "Confirm"
    end

    -- Text
    draw.SimpleText(txt,"mg2.BUTTON.SMALL",w/2,h/2,textCol,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end

vgui.Register("mg2.Button", PANEL, "DButton")