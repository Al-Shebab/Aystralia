
local PANEL = {}

sKore.AccessorFunc(PANEL, "textColor", "TextColour", sKore.FORCE_COLOR, sKore.invalidateLayout)

function PANEL:Init()
	self.navigationDrawerButton = vgui.Create("MAppBarButton", self)
	self.navigationDrawerButton:SetMaterial(sKore.getPrimaryMaterial, sKore.PRIMARY, "menu")
	self.navigationDrawerButton:Dock(LEFT)
	self.navigationDrawerButton.DoClick = function()
		if self.frame.HasNavigationDrawer and self.frame:HasNavigationDrawer() then
			self.frame:GetNavigationDrawer():Toggle()
		end
	end

	self.titleLabel = vgui.Create("DLabel", self)
	self.titleLabel:SetFont("sKoreAppBarTitle")
	self.titleLabel:Dock(FILL)

	self:SetZPos((self:GetParent() or self):GetZPos() + 1001)
	self:SetElevation(5)
	self:SetShadowOffsetX(0)
	self:SetBackgroundColour(sKore.getPrimaryColour, sKore.PRIMARY)
	self:SetTextColour(sKore.getPrimaryTextColour, sKore.PRIMARY, sKore.HIGH_EMPHASIS)
	self:SetGlobalShadow(true)
end

function PANEL:AddButton(icon)
	local button = vgui.Create("MAppBarButton", self)
	button:SetMaterial(sKore.getPrimaryMaterial, sKore.PRIMARY, icon or "dots-vertical")
	button:Dock(RIGHT)

	return button
end

function PANEL:ShowSearchBar(show)
	if !isbool(show) then error("'show' argument is not a boolean!", 2) end
	if show and !self:HasSearchBar() then
		self.searchBar = vgui.Create("MSearchBar", self)
		self.searchBar:Dock(RIGHT)
	elseif !show and self:HasSearchBar() then
		self.searchBar:Remove()
		self.searchBar = nil
	end
end

function PANEL:HasSearchBar()
	return IsValid(self.searchBar)
end

function PANEL:GetSearchBar()
	return self.searchBar
end

function PANEL:PerformLayout()
	self:SetHeight(sKore.scale(64))
	self:DockPadding(sKore.scale(12), sKore.scale(8), sKore.scale(8), sKore.scale(8))

	local title = self.frame.GetTitle and self.frame:GetTitle() or "Title"

	self.titleLabel:SetText(sKore.getPhrase(title))
	self.titleLabel:DockMargin(sKore.scale(20), 0, sKore.scale(20), 0)
	self.titleLabel:SetColor(self:GetTextColour())

	if self.frame.HasNavigationDrawer and self.frame:HasNavigationDrawer() then
		self.navigationDrawerButton:SetVisible(true)
	else
		self.navigationDrawerButton:SetVisible(false)
		self.navigationDrawerButton:SetWidth(0)
	end
end

function PANEL:Paint(width, height)
	local parent = self:GetParent()
	if parent.HasWindowBar and parent:HasWindowBar() then
		surface.SetDrawColor(self:GetBackgroundColour())
		surface.DrawRect(0, 0, width, height)
	else
		draw.RoundedBoxEx(sKore.scale(8), 0, 0, width, height, self:GetBackgroundColour(), true, true)
	end
	sKore.drawShadows(self)
end

function PANEL:PaintShadow(x, y)
	local parent = self:GetParent()
	if parent.HasWindowBar and parent:HasWindowBar() then
		surface.SetDrawColor(sKore.getShadowColour())
		surface.DrawRect(x, y, self:GetWide(), self:GetTall())
	else
		draw.RoundedBoxEx(sKore.scale(8), x, y, self:GetWide(), self:GetTall(), sKore.getShadowColour(), true, true)
	end
end

function PANEL:OnRemove()
	self:GetParent().appBar = nil
end

derma.DefineControl("MAppBar", "", PANEL, "MPanel")
