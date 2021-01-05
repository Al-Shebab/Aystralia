local PANEL = {}

function PANEL:Init()
    self.VBar:SetHideButtons(true)
    self.VBar:SetWide(20)

    if not Slawer.Mayor.IsTooLowResolution then self:NoClipping(true) end

    function self.VBar:Paint(intW, intH)
    end

    function self.VBar.btnGrip:Paint(intW, intH)
        surface.SetDrawColor(Slawer.Mayor.Colors.Blue)
        surface.DrawRect(7, 0, 4, intH)
    end
end

function PANEL:SetLowResValue(iValue)
    function self.VBar.btnGrip:Paint()end
    function self:OnMouseWheeled(iScroll)
        self.VBar:AddScroll(iScroll < 0 and iValue or -iValue )
    end
end


vgui.Register("Slawer.Mayor:DScrollPanel",PANEL,"DScrollPanel")
