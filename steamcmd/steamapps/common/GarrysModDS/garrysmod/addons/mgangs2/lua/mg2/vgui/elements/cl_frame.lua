--[[
    MGangs 2 - (SH) VGUI ELEMENT - Frame
    Developed by Zephruz
]]

if (CLIENT) then

surface.CreateFont("mg2.FRAME.SMALL", {
    font = "Abel",
    size = 18,
})

end

local PANEL = {}

function PANEL:Init()
    self.theme = mg2.vgui:GetCurrentTheme()
    self.realTitle = ""

	self:DockPadding(0, 0, 0, 0)
    self:SetTitle("")
    self:ShowCloseButton(false)

    self:SetupTopNavigation()
end

function PANEL:SetFrameBlur(bool)
    self.frameBlur = bool
end

function PANEL:GetFrameBlur()
    return self.frameBlur
end

function PANEL:SetTitle(text)
    DFrame.SetTitle(self, "")
    
    self.realTitle = text
end

function PANEL:GetTitle()
    return self.realTitle
end

function PANEL:SetupTopNavigation()
    if (IsValid(self.topNav)) then self.topNav:Remove() end

    local tnH = 25

    self.topNav = vgui.Create("DPanel", self)
    self.topNav:Dock(TOP)
    self.topNav:DockMargin(0,0,0,0)
    self.topNav:SetTall(tnH)
    self.topNav.Paint = function(s,w,h)
        local bgCol, titleCol = self.theme:GetColor("frame.NavBar"), self.theme:GetColor("frame.Title")
        
        draw.RoundedBoxEx(4,0,0,w,h,bgCol,true,true)
        draw.SimpleText(self:GetTitle(),"mg2.FRAME.SMALL",5,h/2,titleCol,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    end

    local cButton = vgui.Create("mg2.CloseButton", self.topNav)
    cButton:Dock(RIGHT)
    cButton:DockMargin(3,3,3,3)
    cButton:SetWide(tnH - 6)
    cButton:SetCloseParent(self)
    cButton.OnClose = function()
        if (self.OnClose) then self:OnClose() end
    end
end

function PANEL:AddTopNavigationButton(text)
    if !(IsValid(self.topNav)) then self:SetupTopNav() end

    local tnH = self.topNav:GetTall()

    local nButton = vgui.Create("mg2.Button", self.topNav)
    nButton:Dock(RIGHT)
    nButton:DockMargin(3,3,0,3)
    nButton:SetWide(tnH - 6)
    nButton:SetText(text or "NOTEXT")

    return nButton
end

function PANEL:GetSideNavigationPanel()
    if !(IsValid(self.sideNav)) then self:EnableSideNavigation(true) end

    return self.sideNav
end

function PANEL:EnableSideNavigation(bool)
    if (IsValid(self.sideNav)) then self.sideNav:Remove() end
    if !(bool) then return end

    self._snButtons = {}

    self.sideNav = vgui.Create("DPanel", self)
    self.sideNav:Dock(LEFT)
    self.sideNav:SetWide(150)
    self.sideNav.Paint = function(s,w,h)
        local bgCol = self.theme:GetColor("frame.SideNav.Background")

        draw.RoundedBoxEx(0, 0, 0, w, h, bgCol)
    end
    
    -- Scroll Panel
    self.sideNav.sp = vgui.Create("mg2.Scrollpanel", self.sideNav)
    self.sideNav.sp:Dock(FILL)
    //self.sideNav.sp:DockMargin(0,5,0,5)
end

function PANEL:AddSideNavigationButton(text, data)
    if !(IsValid(self.sideNav)) then self:EnableSideNavigation(true) end

    data = (data or {})

    local snButton = vgui.Create("mg2.Button", self.sideNav.sp)
    snButton:Dock(TOP)
    snButton:DockMargin(0,3,0,0)
    snButton:SetTall(35)
    snButton:SetText(text or "NOTEXT")
    snButton:SetRounded(false)
    snButton.PaintOver = function(s,w,h)
        s.lineW = (s.lineW or 0)

        local bgCol, bgColHov = self.theme:GetColor("navButton.Background"), self.theme:GetColor("navButton.Background.Hover")
        local activeCol, activeLineCol = self.theme:GetColor("navButton.Active"), self.theme:GetColor("navButton.Active.Line")

        draw.RoundedBoxEx(0, 0, 0, w, h, (s:GetDisabled() && activeCol || s:IsHovered() && bgColHov || bgCol))

        if (s:IsHovered() or s:GetDisabled()) then
            s.lineW = math.Clamp(s.lineW+0.5, 0, 5)
        else
            s.lineW = 0
        end

        draw.RoundedBoxEx(0, 0, 0, s.lineW, h, activeLineCol)

        draw.SimpleText(s:GetText(), "mg2.FRAME.SMALL", w/2, h/2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    snButton.DoClick = function(s)
        local id = s._id

        s:SetDisabled(true)

        for k,v in pairs(self._snButtons) do
            if (k != id) then
                if (v.button && IsValid(v.button)) then
                    v.button:SetDisabled(false)
                end

                if (v.pnl && IsValid(v.pnl)) then
                    v.pnl:Remove()
                end
            end
        end

        if (data.doClick) then
            local pnl = vgui.Create("DPanel", self)
            pnl:Dock(FILL)
            pnl.Paint = function(s,w,h) end

            -- Add Menu Hints
            if (!mg2.config.disableMenuHints && data.menuHints != nil && table.Count(data.menuHints) > 0) then
                local displayTime = 2500
                local hPnlH = 25
                local totalHints = table.Count(data.menuHints)

                local hintPnl = vgui.Create("mg2.Container", pnl)
                hintPnl:Dock(TOP)
                hintPnl:SetTall(hPnlH)
                hintPnl:SetRounded(false)
                hintPnl.curTick = 0 // current paint tick
                hintPnl.curHint = 1 // current hint
                hintPnl.PaintOver = function(s,w,h)
                    local curHint = s.curHint
                    local hintText = data.menuHints[curHint]

                    if (totalHints > 1) then
                        if (s.curTick >= displayTime) then
                            local nextHint = (s.curHint + 1)

                            s.curHint = (nextHint <= totalHints && nextHint || 1)
                            s.curTick = 0
                        else
                            s.curTick = s.curTick + 1
                            draw.RoundedBoxEx(0, 0, 0, Lerp(s.curTick/displayTime, 0, w), h, self.theme:GetColor("hintPanel.Background.TimeSlider"))
                        end

                        hintText = "(Hint " .. curHint .. "/" .. totalHints .. ") " .. hintText
                    end

                    draw.SimpleText(hintText, "mg2.FRAME.SMALL", 5, h/2, Color(255,255,255,225), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                end

                local cHintBtn = vgui.Create("mg2.CloseButton", hintPnl)
                cHintBtn:Dock(RIGHT)
                cHintBtn:SetWide(hPnlH - 6)
                cHintBtn:DockMargin(3,3,3,3)
                cHintBtn:SetCloseParent(hintPnl)
            end

            data.doClick(s, pnl)

            self._snButtons[id].pnl = pnl
        end
    end

    local id = table.insert(self._snButtons, { button = snButton, data = data })
    snButton._id = id

    if (data.defaultTab) then
        snButton:DoClick()
    end

    self._snButtons[id].button = snButton

    return self._snButtons[id]
end

function PANEL:Paint(w,h)
    if (self:GetBackgroundBlur()) then
		Derma_DrawBackgroundBlur(self, CurTime())
	end

    if (self:GetFrameBlur()) then
        zlib.util:DrawBlur(self,w,h)
    end

    local bgCol = self.theme:GetColor("frame.Background")

    draw.RoundedBoxEx(6, 0, 0, w, h, bgCol, true, true, false, false) -- Background
end

function PANEL:OnClose() end

vgui.Register("mg2.Frame", PANEL, "DFrame")