
local PANEL = {}

function PANEL:Init()
	self:SetZPos((self:GetParent() or self):GetZPos() + 1000)
	self:SetElevation(5)
	self:SetShadowOffsetX(0)
	self:SetBackgroundColour(sKore.getPrimaryColour, sKore.PRIMARY_DARK)
	self:SetGlobalShadow(true)

	self.closeButton = vgui.Create("MWindowBarButton", self)
	self.closeButton:Dock(RIGHT)
	self.closeButton.DoClick = function(button)
		if self.frame.resizing or self.frame.ripple then return end
		self.frame:Close()
	end

	self.maximizeButton = vgui.Create("MWindowBarButton", self)
	self.maximizeButton:Dock(RIGHT)
	self.maximizeButton.DoClick = function(button)
		if !self.frame.resizing and !self.frame.ripple then
			if self.frame.maximized then
				self.frame.resizing = true
				self.frame:SizeTo(
					self.frame.maximized[3], self.frame.maximized[4], 0.25, 0, -1,
					function()
						self.frame.resizing = nil
						self:InvalidateLayout()
					end
				)
				self.frame:MoveTo(
					self.frame.maximized[1], self.frame.maximized[2], 0.25, 0, -1
				)
				self.frame.maximized = nil
			else
				self.frame.resizing = true
				self.frame.maximized = {
					self.frame.x, self.frame.y, self.frame:GetWide(), self.frame:GetTall()
				}
				self.frame:SizeTo(
					ScrW() - 30 * sKore.scalingFactorRaw, ScrH() - 30 * sKore.scalingFactorRaw, 0.25,
					0, -1, function()
						self.frame.resizing = nil
						self:InvalidateLayout()
					end
				)
				self.frame:MoveTo(15 * sKore.scalingFactorRaw, 15 * sKore.scalingFactorRaw, 0.25, 0, -1)
			end
		end
	end

	self.minimizeButton = vgui.Create("MWindowBarButton", self)
	self.minimizeButton:Dock(RIGHT)
end

function PANEL:PerformLayout()
	self:SetHeight(sKore.scale(32))

	local showCloseButton = self.frame:GetShowCloseButton()
	if showCloseButton then
		self.closeButton:SetWidth(self.closeButton:GetTall())
		self.closeButton:DockMargin(0, 0, sKore.scale(16), 0)
		local enableCloseButton = self.frame:GetEnableCloseButton()
		self.closeButton:SetMaterial(sKore.getPrimaryMaterial, sKore.PRIMARY_DARK, enableCloseButton and "close" or "close-disabled")
		self.closeButton:SetEnabled(enableCloseButton)
	else
		self.closeButton:SetWidth(0)
		self.closeButton:DockMargin(0, 0, sKore.scale(16), 0)
	end

	local showMaximizeButton = self.frame:GetShowMaximizeButton()
	if showMaximizeButton then
		self.maximizeButton:SetWidth(self.maximizeButton:GetTall())
		self.maximizeButton:DockMargin(0, 0, sKore.scaleC(1, 1), 0)
		local enableMaximizeButton = self.frame:GetEnableMaximizeButton()
		local maximized = self.frame.maximized
		if (maximized and !self.resizing) or (!maximized and self.resizing) then
			self.maximizeButton:SetMaterial(sKore.getPrimaryMaterial, 1, enableMaximizeButton and "window-restore" or "window-restore-disabled")
		else
			self.maximizeButton:SetMaterial(sKore.getPrimaryMaterial, 1, enableMaximizeButton and "window-maximize" or "window-maximize-disabled")
		end
		self.maximizeButton:SetEnabled(enableMaximizeButton)
	else
		self.maximizeButton:SetWidth(0)
		self.maximizeButton:DockMargin(0, 0, 0, 0)
	end

	local showMinimizeButton = self.frame:GetShowMinimizeButton()
	if showMinimizeButton then
		self.minimizeButton:SetWidth(self.minimizeButton:GetTall())
		self.minimizeButton:DockMargin(0, 0, sKore.scaleC(1, 1), 0)
		local enableMinimizeButton = self.frame:GetEnableMinimizeButton()
		self.minimizeButton:SetMaterial(sKore.getPrimaryMaterial, 1, enableMinimizeButton and "window-minimize" or "window-minimize-disabled")
		self.minimizeButton:SetEnabled(enableMinimizeButton)
	else
		self.minimizeButton:SetWidth(0)
		self.minimizeButton:DockMargin(0, 0, 0, 0)
	end
end

function PANEL:Paint(width, height)
	draw.RoundedBoxEx(sKore.scale(8), 0, 0, width, height, self:GetBackgroundColour(), true, true)
end

function PANEL:PaintOver()
	sKore.drawShadows(self)
end

function PANEL:PaintShadow(x, y)
	draw.RoundedBoxEx(sKore.scale(8), x, y, self:GetWide(), self:GetTall(), sKore.getShadowColour(), true, true)
end

function PANEL:OnMousePressed()
	local parent = self:GetParent()
	if !parent.ripple and parent.GetDraggable and parent:GetDraggable() and !parent.maximized then
		parent.dragging = {
			gui.MouseX() - parent.x,
			gui.MouseY() - parent.y
		}
	end
end

function PANEL:OnRemove()
	self:GetParent().windowBar = nil
end

derma.DefineControl("MWindowBar", "", PANEL, "MPanel")
