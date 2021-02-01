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

AccessorFunc(PANEL, "Padding",      "Padding")
AccessorFunc(PANEL, "pnlCanvas",    "Canvas")

function PANEL:Init()
    self.pnlCanvas = vgui.Create("Panel", self)
    self.pnlCanvas:SetMouseInputEnabled(true)

    self.pnlCanvas.OnMousePressed = function(self, keyCode) self:GetParent():OnMousePressed(keyCode) end
    self.pnlCanvas.PerformLayout = function()
        self:PerformLayout()
        self:InvalidateParent()
    end

    self.VBar = vgui.Create("GScrollBar", self)
    self.VBar:Dock(RIGHT)

    self:SetPadding(0)
    self:SetMouseInputEnabled(true)

    self:SetPaintBackgroundEnabled(false)
    self:SetPaintBorderEnabled(false)
    self:SetPaintBackground(false)
end

function PANEL:PerformLayout()
    local Tall = self.pnlCanvas:GetTall()
    local Wide = self:GetWide()
    local YPos = 0

    self:Rebuild()

    self.VBar:SetUp(self:GetTall(), self.pnlCanvas:GetTall())
    YPos = self.VBar:GetOffset()

    if (self.VBar.Enabled) then Wide = (Wide - self.VBar:GetWide()) end

    self.pnlCanvas:SetPos(0, YPos)
    self.pnlCanvas:SetWide(Wide)

    self:Rebuild()

    if (Tall != self.pnlCanvas:GetTall()) then self.VBar:SetScroll(self.VBar:GetScroll()) end
end

function PANEL:ScrollToChild(panel)
    self:PerformLayout()

    local x, y = self.pnlCanvas:GetChildPosition(panel)
    local w, h = panel:GetSize()

    y = y + h * 0.5
    y = y - self:GetTall() * 0.5

    self.VBar:AnimateTo( y, 0.5, 0, 0.5 )
end

function PANEL:Rebuild()
    self:GetCanvas():SizeToChildren(false, true)

    if (self.m_bNoSizing && self:GetCanvas():GetTall() < self:GetTall()) then
        self:GetCanvas():SetPos(0, (self:GetTall()-self:GetCanvas():GetTall()) * 0.5)
    end
end

function PANEL:AddItem(panel) panel:SetParent(self:GetCanvas()) end
function PANEL:OnChildAdded(child) self:AddItem(child) end
function PANEL:SizeToContents() self:SetSize(self.pnlCanvas:GetSize()) end
function PANEL:GetVBar() return self.VBar end
function PANEL:GetCanvas() return self.pnlCanvas end
function PANEL:InnerWidth() return self:GetCanvas():GetWide() end
function PANEL:OnMouseWheeled(scrollDelta) return self.VBar:OnMouseWheeled(scrollDelta) end
function PANEL:OnVScroll(scrollOffset) self.pnlCanvas:SetPos(0, scrollOffset) end
function PANEL:Clear() return self.pnlCanvas:Clear() end

vgui.Register("GScrollPanel", PANEL, "DPanel")