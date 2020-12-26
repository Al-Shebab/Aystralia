
local MMENUS = {}

sKore.TOP_LEFT = 1
sKore.TOP_RIGHT = 2
sKore.BOTTOM_LEFT = 3
sKore.BOTTOM_RIGHT = 4

local function getMMenu(panel)
	return (panel:GetName() == "MMenu" or panel:GetName() == "MDefaultMenu") and panel
		   or (IsValid(panel:GetParent()) and getMMenu(panel:GetParent())) or nil
end

hook.Add("VGUIMousePressed", "sKoreCloseMMenus", function(panel, mouseCode)
	local frame = getMMenu(panel)
	if !frame then
		for mmenu, _ in pairs(MMENUS) do
			if !IsValid(mmenu) then MMENUS[mmenu] = nil continue end
			mmenu:Close()
		end
	end
end)

local PANEL = {}

sKore.AccessorFunc(PANEL, "minimumWidth", "MinimumWidth", sKore.FORCE_NUMBER, sKore.InvalidateLayout)
sKore.AccessorFunc(PANEL, "maximumWidth", "MaximumWidth", sKore.FORCE_NUMBER, sKore.InvalidateLayout)
sKore.AccessorFunc(PANEL, "deleteOnClose", "DeleteOnClose", sKore.FORCE_BOOL)

function PANEL:Init()
	self:SetZPos(self.frame:GetZPos() + 2000)

	self.canvasPanel = vgui.Create("MVScrollPanel", self)
	self.canvasPanel:Dock(FILL)

	MMENUS[self] = true
	self.items = {}
	self.scale = 0
	self:SetElevation(9)
	self:SetMinimumWidth(sKore.scale, 112)
	self:SetMaximumWidth(sKore.scale, 280)
	self:SetDeleteOnClose(true)
	self:SetDrawShadows(false)
	self:SetGlobalShadow(true)
	self:SetVisible(false)
end

function PANEL:Open(x, y)
	if self.frame:IsClosed() then return end
	self.scale = 0

	if isnumber(x) and isnumber(y) then
		self:SetPos(x, y)
	else
		self:InvalidateLayout(true)
		local mousex, mousey = self:GetParent():ScreenToLocal(gui.MouseX(), gui.MouseY())
		local tall = math.min(self.canvasPanel:InnerHeight(), self.frame:GetTall() - sKore.scaleR(32) * 2)
		if x == sKore.TOP_RIGHT then
			self:SetPos(mousex - self:GetWide(), mousey)
		elseif x == sKore.BOTTOM_LEFT then
			self:SetPos(mousex, mousey - tall)
		elseif x == sKore.BOTTOM_RIGHT then
			self:SetPos(mousex - self:GetWide(), mousey - tall)
		else
			self:SetPos(mousex, mousey)
		end
	end

	self.animation = self:NewAnimation(0.2, 0, -1, function(animation)
		if self.animation != animation then return end
		self.animation = nil
	end)
	self.animation.Think = function(animation, panel, fraction)
		if self.animation != animation then return end
		self.scale = fraction
		self:InvalidateLayout(true)
	end

	self:SetVisible(true)
end

function PANEL:Close()
	self:SetVisible(false)
	if self:GetDeleteOnClose() then self:Remove() end
	self:OnClose()
end

function PANEL:OnClose() end

function PANEL:OnChildAdded(child)
	child:SetParent(self.canvasPanel)
end

function PANEL:AddOption(text)
	local button = vgui.Create("MMenuButton", self)
	button:SetText(text)
	button:Dock(TOP)

	table.insert(self.items, button)

	self:InvalidateLayout()
	return button
end

function PANEL:AddSpacer()
	local spacer = vgui.Create("Panel", self)
	spacer.Paint = function(panel, width, height)
		surface.SetDrawColor(sKore.getShadowColour())
		surface.DrawRect(0, 0, width, height)
	end
	spacer.PerformLayout = function()
		spacer:SetHeight(math.max(sKore.scale(1), 1))
		spacer:DockMargin(0, sKore.scale(8), 0, sKore.scale(8))
	end
	spacer:Dock(TOP)

	table.insert(self.items, spacer)

	self:InvalidateLayout()
	return spacer
end

function PANEL:ChildrenMinimumWidth()
	local minimumWidths = {}
	for _, child in pairs(self.items) do
		table.insert(minimumWidths, child.GetMinimumWidth and child:GetMinimumWidth() or 0)
	end
	return math.max(unpack(minimumWidths))
end

function PANEL:PerformLayout()
	self.canvasPanel:SetPadding(0, sKore.scale(8), 0, sKore.scale(8))
	self:SetWidth(math.Clamp(self:ChildrenMinimumWidth() + sKore.scale(8), self:GetMinimumWidth(), self:GetMaximumWidth()))
	self:SetHeight(math.min(self.canvasPanel:InnerHeight(), self.frame:GetTall() - sKore.scaleR(32) * 2) * self.scale)
	self:SetPos(
		math.Clamp(self.x, sKore.scaleR(32), self.frame:GetWide() - self:GetWide() - sKore.scaleR(30)),
		math.Clamp(self.y, sKore.scaleR(32), self.frame:GetTall() - self:GetTall() - sKore.scaleR(30))
	)
end

function PANEL:OnRemove()
	MMENUS[self] = nil
end

derma.DefineControl("MMenu", "", PANEL, "MPanel")
