
local PANEL = {}

sKore.AccessorFunc(PANEL, "scrollbarWidth", "ScrollbarWidth", sKore.FORCE_NUMBER, sKore.invalidateLayout)

function PANEL:Init()
	self.vBar = vgui.Create("MVScrollBar", self)
	self.vBar:Dock(RIGHT)

	self.canvasPanel = vgui.Create("Panel", self)
	self.canvasPanel:Dock(TOP)
	self.canvasPanel.PerformLayout = function() self:InvalidateLayout(true) end
	self.canvasPanel.GetElevation = function() return self:GetElevation() end
	self.canvasPanel.AddShadow = function(_, panel) return self:AddShadow(panel) end
	self.canvasPanel.RemoveShadow = function(_, panel) return self:RemoveShadow(panel) end

	self:SetPaintShadow(false)
	self:SetDrawGlobalShadows(false)
	self:SetElevation(0)
	self:SetScrollbarWidth(sKore.scaleR, 7.5)
end

function PANEL:InnerHeight()
	return self.canvasPanel:GetTall()
end

function PANEL:GetCanvas()
	return self.canvasPanel
end

function PANEL:GetPadding()
	return self.canvasPanel:GetDockPadding()
end

function PANEL:SetPadding(...)
	return self.canvasPanel:DockPadding(...)
end

function PANEL:GetVBar()
	return self.vBar
end

function PANEL:InnerWidth()
	return self.canvasPanel:GetWide()
end

function PANEL:OnChildAdded(child)
	child:SetParent(self.canvasPanel)
end
PANEL.AddItem = PANEL.OnChildAdded

function PANEL:Paint()
	sKore.drawShadows(self)
end

function PANEL:OnMouseWheeled(dlta)
	self.vBar:AddScroll(math.Clamp(dlta, -3, 3) * (self:GetTall() / -5))
end

function PANEL:OnVScroll(offset)
	self.canvasPanel:SetPos(0, offset)
end

function PANEL:Clear()
	self.canvasPanel:Clear()
end

function PANEL:PerformLayout()
	self.vBar:SetWidth(self.vBar:IsEnabled() and self:GetScrollbarWidth() or 0)

	self.canvasPanel:SizeToChildren(false, true)
	self.vBar:SetUp(self.canvasPanel:GetTall())

	self.canvasPanel:DockMargin(0, self.vBar:GetOffset(), 0, 0)
end

derma.DefineControl("MVScrollPanel", "", PANEL, "MPanel")
