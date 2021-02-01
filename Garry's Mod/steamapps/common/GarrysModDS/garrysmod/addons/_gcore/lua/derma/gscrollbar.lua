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

local PANEL = {}

function PANEL:Init()
    self.Offset = 0
    self.Scroll = 0
    self.CanvasSize = 1
    self.BarSize = 1

    self.btnGrip = vgui.Create("DScrollBarGrip", self)
    self.btnGrip:SetCursor("hand")
    self.btnGrip.Paint = function(self, w, h)
        surface.SetDrawColor(25, 25, 25, 255)
        surface.DrawRect(4, 0, 7, h)
    end

    self:SetSize(15, 15)
end

function PANEL:SetEnabled(b)
    if (!b) then
        self.Offset = 0
        self:SetScroll( 0 )
        self.HasChanged = true
    end

    self:SetMouseInputEnabled(b)
    self:SetVisible(b)

    if (self.Enabled != b) then
        self:GetParent():InvalidateLayout()

        if (self:GetParent().OnScrollbarAppear) then self:GetParent():OnScrollbarAppear() end
    end

    self.Enabled = b
end

function PANEL:BarScale()
    if (self.BarSize == 0) then return 1 end
    return (self.BarSize / (self.CanvasSize + self.BarSize))
end

function PANEL:SetUp(_barsize_, _canvassize_)
    self.BarSize = _barsize_
    self.CanvasSize = math.max(_canvassize_ - _barsize_, 1)

    self:SetEnabled(_canvassize_ > _barsize_)
    self:InvalidateLayout()
end

function PANEL:AddScroll(scrollDelta)
    local OldScroll = self:GetScroll()
    scrollDelta = scrollDelta * 25

    self:SetScroll(self:GetScroll() + scrollDelta)
    return (OldScroll != self:GetScroll())
end

function PANEL:SetScroll(newScroll)
    if (!self.Enabled) then self.Scroll = 0 return end

    self.Scroll = math.Clamp(newScroll, 0, self.CanvasSize)

    self:InvalidateLayout()

    local func = self:GetParent().OnVScroll
    if (func) then func(self:GetParent(), self:GetOffset()) else self:GetParent():InvalidateLayout() end
end

function PANEL:AnimateTo(newScroll, length, delay, ease)
    local anim = self:NewAnimation(length, delay, ease)
    anim.StartPos = self.Scroll
    anim.TargetPos = newScroll
    anim.Think = function(anim, pnl, fraction) pnl:SetScroll(Lerp(fraction, anim.StartPos, anim.TargetPos)) end
end

function PANEL:Think() end
function PANEL:GetScroll() return ((self.Enabled and self.Scroll) or 0) end
function PANEL:GetOffset() return ((self.Enabled and self.Scroll * -1) or 0) end
function PANEL:OnMouseWheeled(scrollDelta) return ((self:IsVisible() and self:AddScroll(scrollDelta * -2)) or false) end
function PANEL:Value() return self.Pos end

function PANEL:Paint(w, h)
    surface.SetDrawColor(50, 50, 50, 255)
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(25, 25, 25, 255)
    surface.DrawOutlinedRect(0, 0, w, h)
end

function PANEL:OnMousePressed()
    local x, y = self:CursorPos()
    local PageSize = self.BarSize

    if (y > self.btnGrip.y) then self:SetScroll(self:GetScroll() + PageSize) else self:SetScroll(self:GetScroll() - PageSize) end
end

function PANEL:OnMouseReleased()
    self.Dragging = false
    self.DraggingCanvas = nil
    self:MouseCapture(false)

    self.btnGrip.Depressed = false
end

function PANEL:OnCursorMoved(x, y)
    if (!self.Enabled or !self.Dragging) then return end

    local x = 0
    local y = gui.MouseY()
    local x, y = self:ScreenToLocal(x, y)

    y = y - self.HoldPos

    local TrackSize = (self:GetTall() - self:GetWide() * 2 - self.btnGrip:GetTall())

    y = y / TrackSize
    self:SetScroll(y * self.CanvasSize)
end

function PANEL:Grip()
    if (!self.Enabled or self.BarSize == 0) then return end

    self:MouseCapture(true)
    self.Dragging = true

    local x, y = 0, gui.MouseY()
    local x, y = self.btnGrip:ScreenToLocal(x, y)

    self.HoldPos = y
    self.btnGrip.Depressed = true
end

function PANEL:PerformLayout()
    local Wide = self:GetWide()
    local Scroll = (self:GetScroll() / self.CanvasSize)
    local BarSize = math.max(self:BarScale() * (self:GetTall() - 8), 10)
    local Track = (self:GetTall() - 8 - BarSize)

    Track = Track + 1
    Scroll = Scroll * Track

    self.btnGrip:SetPos(0, 4 + Scroll)
    self.btnGrip:SetSize(Wide, BarSize)
end

vgui.Register("GScrollBar", PANEL, "Panel")