local PANEL = {}

AccessorFunc(PANEL, 'm_pMenu', 'Menu')
AccessorFunc(PANEL, 'm_bChecked', 'Checked')
AccessorFunc(PANEL, 'm_bCheckable', 'IsCheckable')

function PANEL:Init()
	self:SetContentAlignment(4)
	self:SetTextInset(13, 0)
	self:SetFont('OSXContextMenu')
end

function PANEL:Paint(w, h)
	if self.Hovered or self.Highlight then
		draw.RoundedBox(0, 0, 0, w, h, F4Menu.Colors.ContextMenuSelected)
	end
end

function PANEL:OnMousePressed(mousecode)
	self.m_MenuClicking = true
	DButton.OnMousePressed( self, mousecode )
end

function PANEL:OnMouseReleased( mousecode )
	DButton.OnMouseReleased( self, mousecode )

	if self.m_MenuClicking and mousecode == MOUSE_LEFT then
		self.m_MenuClicking = false
		CloseDermaMenus()	
	end
end

function PANEL:UpdateColours()
	local selected = self.Hovered or self.Highlight

	local textColor = selected and F4Menu.Colors.Background or F4Menu.Colors.Text
	
	self:SetTextStyleColor(textColor)
end

function PANEL:PerformLayout()
	self:SizeToContents()
	self:SetWide(self:GetWide() + 30)
	
	local w = math.max(self:GetParent():GetWide(), self:GetWide())

	self:SetSize(w, 22)
	
	if self.SubMenuArrow then
		self.SubMenuArrow:SetSize(15, 15)
		self.SubMenuArrow:CenterVertical()
		self.SubMenuArrow:AlignRight(4)
	end

	DButton.PerformLayout(self)	
end

vgui.Register('OSXMenuOption', PANEL, 'DButton')

local PANEL = {}

function PANEL:Init()
	self:SetIsMenu(true)
	self:SetMinimumWidth(100)
	self:SetDrawOnTop(true)
	self:SetMaxHeight(ScrH() * 0.9)
	self:SetDeleteSelf(true)
		
	self:SetPadding(0)

	RegisterDermaMenuForClose(self)
end

function PANEL:AddOption(strText, funcFunction)
	local pnl = vgui.Create('OSXMenuOption', self)
	pnl:SetMenu(self)
	pnl:SetText(strText)
	pnl:SetTall(18)
	if funcFunction then pnl.DoClick = funcFunction end
	
	self:AddPanel(pnl)
	
	return pnl
end

function PANEL:AddSpacer()
	local panel = vgui.Create('OSXSpacer')
	panel:SetTall(3)
	return self:AddPanel(panel)
end

function PANEL:Paint(w, h)
	draw.RoundedBox(6, 0, 0, w, h, F4Menu.Colors.Border)
	draw.RoundedBox(6, 1, 1, w - 2, h - 2, F4Menu.Colors.Background)
end

function PANEL:PerformLayout()
	local w = self:GetMinimumWidth()

	for k, pnl in pairs(self:GetCanvas():GetChildren()) do
		pnl:PerformLayout()
		w = math.max(w, pnl:GetWide())
	end

	self:SetWide(w)
	
	local y = 4
	
	for k, pnl in pairs(self:GetCanvas():GetChildren()) do
		pnl:SetWide(w)
		pnl:SetPos(0, y)
		pnl:InvalidateLayout(true)
		
		y = y + pnl:GetTall() + 4
	end

	y = y + 4

	y = math.min(y, self:GetMaxHeight())
	
	self:SetTall(y)
	
	DScrollPanel.PerformLayout(self)
end

vgui.Register('OSXMenu', PANEL, 'DMenu')

function OSXMenu()
	return vgui.Create('OSXMenu')
end
--[[
CloseDermaMenus()

local m = OSXMenu()
m:AddOption('Change RP Name',function() end)
m:AddSpacer()
m:AddOption('Get Free Cake',function() end)
m:AddOption('Drop Money',function() end)
m:AddOption('Take Money',function() end)
m:AddOption('Dark Mode',function() end)
m:Open()]]