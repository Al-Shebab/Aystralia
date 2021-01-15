local PANEL = {}

local maincolor, maincolor_5, accentcolor = slib.getTheme("maincolor"), slib.getTheme("maincolor", 5), slib.getTheme("accentcolor")

function PANEL:Init()
    local scr = self:GetVBar()
    scr:SetHideButtons(true)

    scr.Paint = function(_, w, h)
        surface.SetDrawColor(maincolor_5)
        surface.DrawRect(0, 0, 1, h)
    end
    scr.btnUp.Paint = function(_, w, h)
        draw.RoundedBoxEx(0, 0, 0, w, h, maincolor, true, true, true, true)
    end
    scr.btnDown.Paint = function(_, w, h)
        draw.RoundedBoxEx(0, 0, 0, w, h, maincolor, true, true, true, true)
    end

    scr.btnGrip.Paint = function(me, w, h)
        draw.RoundedBoxEx(5, w * 0.5 - (w * 0.45 / 2), h * 0.03, w * 0.45, h - h * 0.06, accentcolor, true, true, true, true)
    end

    slib.wrapFunction(self, "SetSize", nil, function() return self end, true)
	slib.wrapFunction(self, "Center", nil, function() return self end, true)
	slib.wrapFunction(self, "SetPos", nil, function() return self end, true)
    slib.wrapFunction(self, "Dock", nil, function() return self end, true)
end

vgui.Register("SScrollPanel", PANEL, "DScrollPanel")