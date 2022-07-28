--[[
    MGangs 2 - (SH) VGUI ELEMENT - Scrollpanel
    Developed by Zephruz
]]

local PANEL = {}

function PANEL:Init()
    self.theme = mg2.vgui:GetCurrentTheme()

    local function paintVB(s,w,h)
        local sbCol = self.theme:GetColor("scrollPanel.Scrollbar.Grip")
        
        draw.RoundedBoxEx(0,0,0,w,h,sbCol)
    end

    self:PaintScrollbar(nil, paintVB, paintVB, paintVB)
end

function PANEL:PaintScrollbar(paint, btnUp, btnDown, btnGrip)
	local vBar = self:GetVBar()
    
	if !(IsValid(vBar)) then return false end
	
    vBar:SetWide(5)

	vBar.Paint = function(...) if (isfunction(paint)) then paint(...) end return end
	vBar.btnUp.Paint = function(...) if (isfunction(btnUp)) then btnUp(...) end return end
	vBar.btnDown.Paint = function(...) if (isfunction(btnDown)) then btnDown(...) end return end
	vBar.btnGrip.Paint = function(...) if (isfunction(btnGrip)) then btnGrip(...) end return end
end

vgui.Register("mg2.Scrollpanel", PANEL, "DScrollPanel")