local PANEL = {}

local buttonColors = {
	{
		Background = Color(253, 100, 95),
		Outline = Color(227, 73, 71)
	},
	{
		Background = Color(254, 193, 66),
		Outline = Color(221, 163, 56)
	},
	{
		Background = Color(53, 208, 75),
		Outline = Color(46, 174, 55)
	}
}

function PANEL:Init()
	self.F4Down = true

	self:SetSize(ScrW() > 1185 and 1185 or 850, ScrH() > 825 and 825 or 650)
	self:Center()
	self:MakePopup()
	self:DockPadding(1, 1, 1, 1)

	self.Bar = vgui.Create('Panel', self)
	self.Bar:Dock(TOP)
	self.Bar:SetTall(65)
	self.Bar:DockPadding(0, 9, 20, 9)
	self.Bar.OnMouseReleased = function()
		self:Close()
	end

	self.Bar.Paint = function(panel, w, h)
		draw.RoundedBoxEx(F4Menu.Colors.BorderRadius, 0, 0, w, h, F4Menu.Colors.TitleBar, true, true, false, false)
		draw.RoundedBox(0, 0, h - 2, w, 2, F4Menu.Colors.TitleBorder)

		local padding = 27
		for index, button in pairs(buttonColors) do
			local y = h / 2
			draw.FilledCircle(padding, y - 2, 10, 27, button.Outline)
			draw.FilledCircle(padding, y - 2, 9, 27, button.Background)
			padding = padding + 27
		end

		local activeTab = self:GetActiveTab()

		if not ValidPanel(activeTab) then return end

		local title = activeTab:GetText()
		draw.SimpleText(title, 'OSXTitle', w / 2, h / 2, F4Menu.Colors.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	self.Arrow = vgui.Create('OSXArrow', self.Bar)
	self.Arrow:Dock(RIGHT)
	self.Arrow:SetOrigin(BOTTOM)
	self.Arrow:SetWide(15)
	self.Arrow:SetCursor('hand')
	self.Arrow.OnMouseReleased = function()
		self:CommandMenu()
	end

	self.Avatar = vgui.Create('OSXAvatar', self.Bar)
	self.Avatar:Dock(RIGHT)
	self.Avatar:DockMargin(0, 0, 12, 0)
	self.Avatar:SetWide(46)
	self.Avatar:SetFullSize(46, 46)
	self.Avatar:SetPlayer(LocalPlayer(), 46)

	self.Nick = vgui.Create('DLabel', self.Bar)
	self.Nick:Dock(RIGHT)
	self.Nick:DockMargin(0, 0, 12, 0)
	self.Nick:SetFont('OSXTitle')
	self.Nick:SetColor(F4Menu.Colors.Text)
	self.Nick:SetText(LocalPlayer():Nick())
	self.Nick:SizeToContentsX()

	if ValidPanel(self.tabScroller) then
		self.tabScroller:Remove()
	end

	self.tabScroller = vgui.Create('OSXPanelList', self)
	self.tabScroller:Dock(LEFT)
	self.tabScroller:SetWide(253)
	self.tabScroller:SetPadding(21)
	self.tabScroller:SetSpacing(7)
	self.tabScroller.Paint = function(self, w, h)
		draw.RoundedBoxEx(F4Menu.Colors.BorderRadius, 0, 0, w, h, F4Menu.Colors.Background, false, false, true, false)
		draw.RoundedBox(0, w - 1, 0, 1, h, F4Menu.Colors.Border)
	end

	self:Refresh()
	self:Show()
end

function PANEL:CommandMenu()
	hook.Run('F4MenuCommands', self)
end

function PANEL:Paint(w, h)
	draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 0, 95))
	draw.RoundedBox(8, 1, 1, w - 2, h - 2, F4Menu.Colors.Background)
end

function PANEL:AddSheet(label, panel, Tooltip)
	if not IsValid(panel) then return end

	local w, h = self:GetSize()
	local sheet = {}

	sheet.Name = label

	sheet.Tab = vgui.Create('OSXTab', self)
	sheet.Tab:SetText(label)
	sheet.Tab:SetPropertySheet(self)
	sheet.Tab:SetPanel(panel)
	sheet.Tab:SetTooltip(Tooltip)

	sheet.Panel = panel
	sheet.Panel.tab = sheet.Tab
	sheet.Panel:SetPos(self.tabScroller:GetWide() + 1, self.Bar:GetTall() + 1)
	sheet.Panel:SetSize(w - self.tabScroller:GetWide() - 2, h - self.Bar:GetTall() - 2)
	sheet.Panel:SetVisible(false)

	if sheet.Panel.shouldHide and sheet.Panel:shouldHide() then sheet.Tab:SetDisabled(true) end

	panel:SetParent(self)

	table.insert(self.Items, sheet)
	local index = #self.Items

	if not self:GetActiveTab() then
		self:SetActiveTab(sheet.Tab)
		sheet.Panel:SetVisible(true)
	end

	self.tabScroller:AddItem(sheet.Tab)

	if panel.Refresh then panel:Refresh() end

	return sheet, index
end

function PANEL:Refresh()
	for k,v in pairs(self.Items) do
		if v.Panel.shouldHide and v.Panel:shouldHide() then v.Tab:SetDisabled(true)
		else v.Tab:SetDisabled(false) end
		if v.Panel.Refresh then v.Panel:Refresh() end
	end
end

function PANEL:Think()
	self.Nick:SetText(LocalPlayer():Nick())
	self.Nick:SizeToContentsX()

	local closeButton = input.KeyNameToNumber(input.LookupBinding('gm_showspare2'))

	if self.F4Down and not input.IsKeyDown(closeButton) then
		self.F4Down = false
		return
	elseif not self.F4Down and input.IsKeyDown(closeButton) then
		self.F4Down = true
		self:Close()
	end
end

function PANEL:Show()
	self:Refresh()
	if #self.Items > 0 and self:GetActiveTab() and self:GetActiveTab():GetDisabled() then
		self:SetActiveTab(self.Items[1].Tab)
	end
	self.F4Down = true
	self:SetVisible(true)
	RememberCursorPosition()
end

function PANEL:Hide()
	RestoreCursorPosition()
	self:SetVisible(false)
end

function PANEL:Close()
	self:Hide()
end

function PANEL:PerformLayout()
	local ActiveTab = self:GetActiveTab()
	local Padding = self:GetPadding()

	if not IsValid(ActiveTab) then return end

	ActiveTab:InvalidateLayout(true)
	self.tabScroller:SetTall(ActiveTab:GetTall())

	local ActivePanel = ActiveTab:GetPanel()

	for k, v in pairs(self.Items) do
		if v.Tab:GetPanel() == ActivePanel then
			v.Tab:GetPanel():SetVisible(true)
			v.Tab:SetZPos(100)
		else
			v.Tab:GetPanel():SetVisible(false)
			v.Tab:SetZPos(1)
		end
		v.Tab:ApplySchemeSettings()
	end

	ActivePanel:InvalidateLayout()
	self.animFade:Run()
end

function PANEL:StringRequest(requestPlaceholder, requestTitle, requestCallback, numeric)
	if ValidPanel(self.RequestOverlay) then
		self.RequestOverlay:Remove()
	end

	self.RequestOverlay = vgui.Create('OSXRequest', self)
	self.RequestOverlay:SetSize(self:GetSize())
	self.RequestOverlay:Setup(requestPlaceholder, requestTitle, requestCallback, numeric)
end

function PANEL:CreateTab(name, panel)
	local sheet, index = self:AddSheet(name, panel)
	return index, sheet
end

function PANEL:AddSpacer()
	local spacer = vgui.Create('OSXSpacer')
	self.tabScroller:AddItem(spacer)
end

function PANEL:AddButton(buttonPanel)
	self.tabScroller:AddItem(buttonPanel)
end

function PANEL:RemoveTab(name)
	for k, v in pairs(self.Items) do
		if v.Tab:GetText() ~= name then continue end
		return self:CloseTab(v.Tab, true)
	end
end

vgui.Register('OSXEditablePropertySheet', vgui.GetControlTable('DPropertySheet'), 'EditablePanel')
vgui.Register('OSXFrame', PANEL, 'OSXEditablePropertySheet')

local PANEL = {}

function PANEL:EnableVerticalScrollbar()
	if self.VBar then return end

	self.VBar = vgui.Create('SlideBar', self)
	self.VBar.Paint = function(self)
		if not self.Enabled or self.BarScale <= 0 then return end

		draw.RoundedBoxEx(0, 0, 0, 1, self:GetTall(), F4Menu.Colors.Border)

		local Pos = (self:GetTall() - self:ScrollbarSize()) * self.Pos
		draw.RoundedBox(4, 5, Pos + 2, self:GetWide() - 7, self:ScrollbarSize() - 4, F4Menu.Colors.ScrollBar)
	end
	self:InvalidateLayout()
end

vgui.Register('OSXPanelList', PANEL, 'PanelList')
