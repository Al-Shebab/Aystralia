--[[
    MGangs 2 - (SH) VGUI ELEMENT - Drop down
    Developed by Zephruz
]]


if (CLIENT) then

surface.CreateFont("mg2.DROPDOWN.MEDIUM", {
    font = "Abel",
    size = 25,
})

surface.CreateFont("mg2.DROPDOWN.SMALL", {
    font = "Abel",
    size = 18,
})

end

local DROPDOWN = {}

function DROPDOWN:Init()
    self.theme = mg2.vgui:GetCurrentTheme()

    self:SetText("")
    self:SetRounded(true)
    self:SetScrollbarWidth(5)

    self:PaintElements()
end

function DROPDOWN:SetScrollbarWidth(val)
    self.ScrollbarWidth = val

    local vBar = (IsValid(self.Menu) && self.Menu:GetVBar())

    if (IsValid(vBar)) then
        vBar:SetWide(val)
    end
end

function DROPDOWN:GetScrollbarWidth()
    return self.ScrollbarWidth
end

function DROPDOWN:SetText(val)
    self.text = val

    if !(self.originalText) then
        self.originalText = val
    end
end

function DROPDOWN:GetText()
    return self.text
end

function DROPDOWN:SetRounded(bool)
    self.isRounded = bool
end

function DROPDOWN:GetRounded()
    return self.isRounded
end

function DROPDOWN:PaintScrollbar(paint, btnUp, btnDown, btnGrip)
    if !(IsValid(self.Menu)) then return false end

    local vBar = self.Menu:GetVBar()
    
    if !(IsValid(vBar)) then return false end
    
    vBar.Paint = function(...) if (isfunction(paint)) then paint(...) end return end
    vBar.btnUp.Paint = function(...) if (isfunction(btnUp)) then btnUp(...) end return end
    vBar.btnDown.Paint = function(...) if (isfunction(btnDown)) then btnDown(...) end return end
    vBar.btnGrip.Paint = function(...) if (isfunction(btnGrip)) then btnGrip(...) end return end
end

function DROPDOWN:GetChoices()
    return self.Choices
end

function DROPDOWN:RemoveChoice(i)
    self.Data[i] = nil
    self.Choices[i] = nil

    if (self.selected == i) then
        self.selected = nil
    end

    self:SetText(self.originalText)
end

function DROPDOWN:PaintElements()
    local ddArrowMat, ddoArrowMat = Material("mg2/004__arrow_down.png", "noclamp smooth"), Material("mg2/003__arrow_up.png", "noclamp smooth")

    self.DropButton.Paint = function(s,w,h)
        local arrowMat = (self:IsMenuOpen() && ddoArrowMat || ddArrowMat)

        surface.SetDrawColor(Color(35,35,35,75))
        surface.SetMaterial(arrowMat)
        surface.DrawTexturedRect(-13,-13,42,42)

        surface.SetDrawColor(Color(255,255,255,255))
        surface.DrawTexturedRect(-14,-14,42,42)
    end
end

function DROPDOWN:DoClick()
    if (self:IsMenuOpen()) then return self:CloseMenu() end
    
    self:OpenMenu()

    local dmenu = self.Menu

    if !(IsValid(dmenu)) then return false end

    local function paintVGrip(s,w,h)
        local gripCol = (self.theme:GetColor("dropDown.VBARGRIP") || Color(125,125,125,125))

        s.bW = (s.bW or w)
        s.bH = (s.bH or h)
        
        if (s:IsHovered() or self:IsHovered() or self:IsChildHovered()) then
            s.bW = s.bW+1
            s.bW = math.min(w, s.bW)
        else
            s.bW = s.bW-1
            s.bW = math.max(0, s.bW)
        end

        draw.RoundedBoxEx(0,1,1,(s.bW - 2),s.bH,gripCol,false,false,false,false)
    end
    
    self:PaintScrollbar(nil, paintVGrip, paintVGrip, paintVGrip)
    self:SetScrollbarWidth(7)
    
    dmenu.Paint = function(s,w,h) end

    local dmenuCanv = dmenu:GetCanvas()
    local dmenuChild = dmenuCanv:GetChildren()

    for i = 1, #dmenuChild do
        local dlabel = dmenuChild[i]
        local rounded = (i == #dmenuChild && self.isRounded)

        dlabel:SetTextColor(Color(0,0,0,0))
        dlabel.Paint = function(s, w, h)
            draw.RoundedBoxEx(5, 0, 0, w, h, Color(35,35,35,255), false, false, rounded, rounded)

            local col = (i % 2 == 0 && Color(80,80,80,100) || Color(85,85,85,100))

            draw.RoundedBoxEx(5, 0, 0, w, h, col, false, false, rounded, rounded)

            local tCol = (s:IsHovered() && Color(255,255,255,155) || Color(255,255,255))

            draw.SimpleText(s:GetText(), "mg2.DROPDOWN.SMALL", 5, h/2, tCol, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end
end

function DROPDOWN:Clear()
    DComboBox.Clear(self)

    self:SetText(self.originalText)
end

function DROPDOWN:Paint(w,h)
    local bgCol, textCol = self.theme:GetColor("dropdown.Background"), self.theme:GetColor("dropdown.Text")
    local rounded = self:GetRounded()
  
    draw.RoundedBoxEx(4,0,0,w,h,bgCol,rounded,rounded,rounded,rounded)

    draw.SimpleText(self:GetText(), "mg2.DROPDOWN.SMALL", 5, h/2, textCol, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

vgui.Register("mg2.Dropdown", DROPDOWN, "DComboBox")