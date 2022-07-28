--[[
    MGangs 2 - (SH) VGUI ELEMENT - Model Panel
    Developed by Zephruz
]]

local PANEL = {}

function PANEL:Init()
    function self:LayoutEntity() return end
end

function PANEL:SetModel(...)
    DModelPanel.SetModel(self, ...)

    local mdlPnlEnt = self.Entity
    
    if !(IsValid(mdlPnlEnt)) then return end

    local PrevMins, PrevMaxs = mdlPnlEnt:GetRenderBounds()
    local camMult = Vector(0.6, 0.6, 0.5)

    self:SetCamPos(PrevMins:Distance(PrevMaxs)*camMult)
    self:SetLookAt((PrevMaxs + PrevMins)*0.55)
end

vgui.Register("mg2.ModelPanel", PANEL, "DModelPanel")