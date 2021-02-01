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

surface.CreateFont("OpenSans16", { font = "Open Sans", size = 18, weight = 400, antialias = true })

local PANEL = {}

AccessorFunc(PANEL, "m_bIsMenuComponent",   "IsMenu",           FORCE_BOOL)
AccessorFunc(PANEL, "m_bDraggable",         "Draggable",        FORCE_BOOL)
AccessorFunc(PANEL, "m_bSizable",           "Sizable",          FORCE_BOOL)
AccessorFunc(PANEL, "m_bScreenLock",        "ScreenLock",       FORCE_BOOL)
AccessorFunc(PANEL, "m_bDeleteOnClose",     "DeleteOnClose",    FORCE_BOOL)
AccessorFunc(PANEL, "m_bPaintShadow",       "PaintShadow",      FORCE_BOOL)
AccessorFunc(PANEL, "m_iMinWidth",          "MinWidth"                    )
AccessorFunc(PANEL, "m_iMinHeight",         "MinHeight"                   )
AccessorFunc(PANEL, "m_bBackgroundBlur",    "BackgroundBlur",   FORCE_BOOL)

function PANEL:Init()
    self:SetFocusTopLevel(true)
    self:SetPaintShadow(true)

    self.lblTitle = vgui.Create("DLabel", self)
    self.lblTitle:SetFont("OpenSans16")
    self.lblTitle.UpdateColours = function(panel) panel:SetTextStyleColor(Color(255, 255, 255, 255)) end

    self.btnClose = vgui.Create("DButton", self)
    self.btnClose:SetText("")
    self.btnClose.DoClick = function() self:Close() end
    self.btnClose.Paint = function(panel, w, h)
        surface.SetMaterial(Material("icon16/cross.png"))
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(0, 0, w, h)
    end
    
    self.btnDeveloper = vgui.Create("DButton", self)
    self.btnDeveloper:SetText("")
    self.btnDeveloper.DoClick = function() if (self.functionDeveloper) then self.functionDeveloper() end end
    self.btnDeveloper.Paint = function(panel, w, h)
        surface.SetMaterial(Material("icon16/user_suit.png"))
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(0, 0, w, h)
    end

    self:SetDraggable(true)
    self:SetSizable(false)
    self:SetScreenLock(true)
    self:SetDeleteOnClose(true)
    self:SetVisible(true)

    self:SetMinWidth(100)
    self:SetMinHeight(100)

    self:SetPaintBackgroundEnabled(false)
    self:SetPaintBorderEnabled(false)

    self.m_fCreateTime = SysTime()

    self:DockPadding(5, 24 + 5, 5, 5)

    self:MakePopup()
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(70, 70, 70, 255)
    surface.DrawRect(0, 0, w, h)

    surface.SetMaterial(Material("guurgle/header.png"))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(0, 0, w, 24)

    surface.SetDrawColor(0, 0, 0, 255)
    surface.DrawRect(0, 24, w, 1)
    surface.DrawOutlinedRect(0, 0, w, h)
end

function PANEL:PerformLayout()
    self.lblTitle:SetPos(8, 2)
    self.lblTitle:SetSize(self:GetWide() - 50, 20)

    self.btnClose:SetPos(self:GetWide() - 20, 4)
    self.btnClose:SetSize(16, 16)

    self.btnDeveloper:SetPos(self:GetWide() - 40, 4)
    self.btnDeveloper:SetSize(16, 16)
    self.btnDeveloper:SetVisible(type(self.functionDeveloper) == "function")
end

function PANEL:Think()
    local mousex = math.Clamp(gui.MouseX(), 1, ScrW() - 1)
    local mousey = math.Clamp(gui.MouseY(), 1, ScrH() - 1)

    if (self.Dragging) then
        local x = mousex - self.Dragging[1]
        local y = mousey - self.Dragging[2]

        if (self:GetScreenLock()) then
            x = math.Clamp(x, 0, ScrW() - self:GetWide())
            y = math.Clamp(y, 0, ScrH() - self:GetTall())
        end

        self:SetPos(x, y)
    end

    if (self.Sizing) then
        local x = mousex - self.Sizing[1]
        local y = mousey - self.Sizing[2]
        local px, py = self:GetPos()

        if (x < self.m_iMinWidth) then x = self.m_iMinWidth elseif (x > ScrW() - px and self:GetScreenLock()) then x = ScrW() - px end
        if (y < self.m_iMinHeight) then y = self.m_iMinHeight elseif (y > ScrH() - py and self:GetScreenLock()) then y = ScrH() - py end

        self:SetSize(x, y)
        self:SetCursor("sizenwse")
        return

    end

    if (self.Hovered && self.m_bSizable && mousex > (self.x + self:GetWide() - 20) && mousey > (self.y + self:GetTall() - 20)) then self:SetCursor("sizenwse") return end
    if (self.Hovered && self:GetDraggable() && mousey < (self.y + 24)) then self:SetCursor( "sizeall" ) return end

    self:SetCursor("arrow")

    if (self.y < 0) then self:SetPos(self.x, 0) end
end

function PANEL:SetTitle(strTitle) self.lblTitle:SetText(strTitle) end

function PANEL:Close()
    if (self:GetDeleteOnClose()) then self:Remove() else self:SetVisible(false) end
    self:OnClose()
end

function PANEL:OnClose() end

function PANEL:Center()
    self:InvalidateLayout(true)
    self:CenterVertical()
    self:CenterHorizontal()
end

function PANEL:IsActive()
    if (self:HasFocus()) then return true end
    if (vgui.FocusedHasParent(self)) then return true end

    return false
end

function PANEL:OnMousePressed()
    if (self.m_bSizable) then
        if (gui.MouseX() > (self.x + self:GetWide() - 20) && gui.MouseY() > (self.y + self:GetTall() - 20)) then
            self.Sizing = { gui.MouseX() - self:GetWide(), gui.MouseY() - self:GetTall() }
            self:MouseCapture(true)
            return
        end
    end

    if (self:GetDraggable() && gui.MouseY() < (self.y + 24)) then
        self.Dragging = { gui.MouseX() - self.x, gui.MouseY() - self.y }
        self:MouseCapture(true)
        return
    end
end

function PANEL:OnMouseReleased()
    self.Dragging = nil
    self.Sizing = nil
    self:MouseCapture(false)
end

vgui.Register("GFrame", PANEL, "EditablePanel")