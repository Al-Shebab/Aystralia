
local MFRAMES = {}

function invalidateLayoutMFrames()
	for panel, _ in pairs(MFRAMES) do
		if !IsValid(panel) then MFRAMES[panel] = nil continue end
		panel:InvalidateLayout(true)
		panel:InvalidateChildren(true)
	end
end

hook.Add("sKoreScaleUpdated", "sKoreMFrameScalingUpdated", invalidateLayoutMFrames)
hook.Add("sKoreScalingReloaded", "sKoreMFrameScalingReloaded", invalidateLayoutMFrames)
hook.Add("sKoreThemeUpdated", "sKoreMFrameThemeUpdated", invalidateLayoutMFrames)
hook.Add("sKoreThemeReloaded", "sKoreMFrameThemeReloaded", invalidateLayoutMFrames)
hook.Add("sKoreLanguageUpdated", "sKoreMFrameLanguageUpdated", invalidateLayoutMFrames)
hook.Add("sKoreLanguageReloaded", "sKoreMFrameLanguageReloaded", invalidateLayoutMFrames)

local PANEL = {}

table.Merge(PANEL, sKore.elevationGAS)
table.Merge(PANEL, sKore.shadowGAS)
sKore.AccessorFunc(PANEL, "backgroundBlur", "BackgroundBlur", sKore.FORCE_BOOL)
sKore.AccessorFunc(PANEL, "deleteOnClose", "DeleteOnClose", sKore.FORCE_BOOL)
sKore.AccessorFunc(PANEL, "screenLock", "ScreenLock", sKore.FORCE_BOOL)
sKore.AccessorFunc(PANEL, "draggable", "Draggable", sKore.FORCE_BOOL)
sKore.AccessorFunc(PANEL, "showCloseButton", "ShowCloseButton", sKore.FORCE_BOOL, sKore.invalidateLayout)
sKore.AccessorFunc(PANEL, "enableCloseButton", "EnableCloseButton", sKore.FORCE_BOOL, sKore.invalidateLayout)
sKore.AccessorFunc(PANEL, "showMaximizeButton", "ShowMaximizeButton", sKore.FORCE_BOOL, sKore.invalidateLayout)
sKore.AccessorFunc(PANEL, "enableMaximizeButton", "EnableMaximizeButton", sKore.FORCE_BOOL, sKore.invalidateLayout)
sKore.AccessorFunc(PANEL, "showMinimizeButton", "ShowMinimizeButton", sKore.FORCE_BOOL, sKore.invalidateLayout)
sKore.AccessorFunc(PANEL, "enableMinimizeButton", "EnableMinimizeButton", sKore.FORCE_BOOL, sKore.invalidateLayout)
sKore.AccessorFunc(PANEL, "title", "Title", sKore.FORCE_STRING, sKore.invalidateLayout)
sKore.AccessorFunc(PANEL, "snackbarLimit", "SnackbarLimit", sKore.FORCE_NUMBER)

sKore.AccessorFunc(PANEL, "scrollCanvasVertically", "CanvasScrollVertically", sKore.FORCE_BOOL, function(self, newValue)
	self.scrollCanvasHorizontally = !newValue
	self:InvalidateLayout(true)
end)
sKore.AccessorFunc(PANEL, "scrollCanvasHorizontally", "CanvasScrollHorizontally", sKore.FORCE_BOOL, function(self, newValue)
	self.scrollCanvasVertically = !newValue
	self:InvalidateLayout(true)
end)

function PANEL:Init()
	self:SetFocusTopLevel(true)
	self:SetZPos(0)

	MFRAMES[self] = true
	local parent = self:GetParent()
	if parent.AddShadow then parent:AddShadow(self) end
	self.frame = sKore.getFrame(self)
	self.snackbars = {}
	self.globalShadows = self.globalShadows or {}
	self.canvas = {}
	self.canvasPosition = 0
	self.updateOnSearch = {}

	self.canvasPlaceholder = vgui.Create("Panel", self)
	self.canvasPlaceholder.Paint = function() end
	self.canvasPlaceholder:SetMouseInputEnabled(false)
	self.canvasPlaceholder:SetKeyboardInputEnabled(false)
	self.canvasPlaceholder:Dock(FILL)

	self:SetElevation(2)
	self:SetShadowOffsetX(1)
	self:SetShadowOffsetY(1)
	self:SetPaintShadow(true)
	self:SetDrawShadows(true)
	self:SetDrawGlobalShadows(true)
	self:SetBackgroundBlur(true)
	self:SetDeleteOnClose(true)
	self:SetScreenLock(false)
	self:SetDraggable(true)
	self:SetSnackbarLimit(2)
	self:SetCanvasScrollVertically(true)
	self:SetupCanvas(0)

	self:ShowWindowBar(true)
	self:SetShowCloseButton(true)
	self:SetEnableCloseButton(true)
	self:SetShowMaximizeButton(true)
	self:SetEnableMaximizeButton(true)
	self:SetShowMinimizeButton(false)
	self:SetEnableMinimizeButton(false)

	self:ShowAppBar(true)
	self:SetTitle("Title")

	self:Open()
end

function PANEL:MoveToCanvas(position, instantly)
	if !isnumber(position) then error("'position' argument is not a number!", 2) end
	if self.canvas[position] == nil then error("'position' argument is not a valid position number!", 2) end
	instantly = instantly or false
	if !isbool(instantly) then error("'instantly' argument is not a boolean!", 2) end
	for _, canvas in pairs(self.canvas) do
		canvas:SetVisible(true)
	end
	local target = 1 - position
	if instantly then
		self.canvasAnimation = nil
		self.canvasPosition = target
		for p, canvas in pairs(self.canvas) do
			if p == math.abs(self.canvasPosition) + 1 then continue end
			canvas:SetVisible(false)
		end
		self:InvalidateLayout(true)
		return true
	else
		if self.canvasAnimation then return false end
		local start = self.canvasPosition
		local offset = target - start
		self.canvasAnimation = self:NewAnimation(math.min(0.2 * math.abs(offset), 0.4), 0, -1, function()
			self.canvasAnimation = nil
			for p, canvas in pairs(self.canvas) do
				if p == math.abs(self.canvasPosition) + 1 then continue end
				canvas:SetVisible(false)
			end
		end)
		self.canvasAnimation.Think = function(anim, panel, faction)
			if self.canvasAnimation != anim then return end
			self.canvasPosition = start + offset * faction
			self:InvalidateLayout(true)
		end
		return true
	end
end

function PANEL:GetCanvas(position)
	if position == nil then return self.canvas end
	position = position or 1
	if !isnumber(position) then error("'position' argument is not a number!", 2) end
	return self.canvas[position] or nil
end

function PANEL:AddCanvas(position)
	position = position or #self.canvas + 1
	if !isnumber(position) then error("'position' argument is not a number!", 2) end

	local newCanvas = vgui.Create("MVScrollPanel", self)
	local index = table.insert(self.canvas, position, newCanvas)
	if index != math.abs(self.canvasPosition) + 1 then newCanvas:SetVisible(false) end

	return newCanvas, index
end

function PANEL:SetupCanvas(amount)
	if !isnumber(amount) then error("'amount' argument is not a number!", 2) end
	for _, canvas in pairs(self.canvas) do canvas:Remove() end
	self.canvas = {}
	self.canvasPosition = 0

	for i = 1, amount do self:AddCanvas() end
	return self.canvas
end

function PANEL:SetScaledSize(width, height)
	if !isnumber(width) and width != nil then error("'width' argument is neither a number nor nil!", 2) end
	if !isnumber(height) and height != nil then error("'height' argument is neither a number nor nil!", 2) end
	self.scaledWidth = width
	self.scaledHeight = height
	self:InvalidateLayout(true)
end

function PANEL:SnackbarQueueWork()
	if #self.snackbars == 0 or self.snackbar then return end
	local snackbarInfo = self.snackbars[1]
	self.snackbar = vgui.Create("MSnackbar", self)
	self.snackbar:SetText(snackbarInfo["text"])
	self.snackbar:SetPos(0, self:GetTall())

	local fadeInAnimation = self.snackbar:NewAnimation(0.15, 0.1, -1, function()
		local restingAnimation = self.snackbar:NewAnimation(snackbarInfo["time"], 0, -1, function()
			local fadeOutAnimation = self.snackbar:NewAnimation(0.15, 0, -1, function()
				table.remove(self.snackbars, 1)
				self.snackbar:Remove()
				self.snackbar = nil
				self:SnackbarQueueWork()
			end)
			fadeOutAnimation.Think = function(anim, panel, fraction)
				panel:SetPos((self:GetWide() - panel:GetWide()) / 2, self:GetTall() - (sKore.scaleR(24) + panel:GetTall()) * (1 - fraction))
			end
		end)
		restingAnimation.Think = function(anim, panel, fraction)
			panel:SetPos((self:GetWide() - panel:GetWide()) / 2, self:GetTall() - (sKore.scaleR(24) + panel:GetTall()))
		end
	end)
	fadeInAnimation.Think = function(anim, panel, fraction)
		panel:SetPos((self:GetWide() - panel:GetWide()) / 2, self:GetTall() - (sKore.scaleR(24) + panel:GetTall()) * fraction)
	end
end

function PANEL:CreateSnackbar(text, time)
	if !isstring(text) then error("'text' argument is not a string!", 2) end
	if !isnumber(time) then error("'time' argument is not a number!", 2) end
	if #self.snackbars >= self:GetSnackbarLimit() then return end
	table.insert(self.snackbars, {
		["text"] = text,
		["time"] = time
	})
	self:SnackbarQueueWork()
end

function PANEL:OnChildAdded(child)
	child:SetPaintedManually(true)
end

function PANEL:ShowNavigationDrawer(show)
	if !isbool(show) then error("'show' argument is not a boolean!", 2) end
	if show and !self:HasNavigationDrawer() then
		self.nagigationDrawer = vgui.Create("MNavigationDrawer", self)
		self.nagigationDrawer:Dock(LEFT)
	elseif !show and self:HasNavigationDrawer() then
		self.nagigationDrawer:Remove()
		self.nagigationDrawer = nil
	end
end

function PANEL:HasNavigationDrawer()
	return IsValid(self.nagigationDrawer)
end

function PANEL:GetNavigationDrawer()
	return self.nagigationDrawer
end

function PANEL:ShowAppBar(show)
	if !isbool(show) then error("'show' argument is not a boolean!", 2) end
	if show and !self:HasAppBar() then
		self.appBar = vgui.Create("MAppBar", self)
		self.appBar:Dock(TOP)
	elseif !show and self:HasAppBar() then
		self.appBar:Remove()
		self.appBar = nil
	end
end

function PANEL:HasAppBar()
	return IsValid(self.appBar)
end

function PANEL:GetAppBar()
	return self.appBar
end

function PANEL:ShowWindowBar(show)
	if !isbool(show) then error("'show' argument is not a boolean!", 2) end
	if show and !self:HasWindowBar() then
		self.windowBar = vgui.Create("MWindowBar", self)
		self.windowBar:Dock(TOP)
	elseif !show and self:HasWindowBar() then
		self.windowBar:Remove()
		self.windowBar = nil
	end
end

function PANEL:HasWindowBar()
	return IsValid(self.windowBar)
end

function PANEL:GetWindowBar()
	return self.windowBar
end

function PANEL:IsActive()
	return self:HasFocus() or vgui.FocusedHasParent(self)
end

function PANEL:Open()
	if self.closed == false then return end
	self.closed = false
	self.startTime = SysTime()
	local startTime = self.startTime
	self.ripple = {nil, nil, nil, 0}
	self.rippleAnimation = self:NewAnimation(0.33, 0, -1, function(animation)
		if animation != self.rippleAnimation then return end
		self.ripple = nil
	end)
	self.rippleAnimation.Think = function(animation, panel, fraction)
		if animation != self.rippleAnimation then return end
		self.ripple[4] = fraction
		self.startTime = SysTime() - (SysTime() - startTime) * 3
	end
	self:SetVisible(true)
end

function PANEL:Close(instantly)
	if self.closed == true then return end
	if !isbool(instantly) and instantly != nil then error("'instantly' argument is neither a boolean nor nil!", 2) end
	self.closed = true
	if instantly == true then
		self:SetVisible(false)
		if self:GetDeleteOnClose() then self:Remove() end
		self:OnClose()
	end
	local mousex, mousey = self:ScreenToLocal(gui.MouseX(), gui.MouseY())
	self.ripple = {mousex, mousey, nil, 1}
	local width, height = self:GetSize()
	if mousex > width / 2 then
		if mousey > height / 2 then
			self.ripple[3] = math.sqrt(math.pow(mousex, 2) + math.pow(mousey, 2))
		else
			self.ripple[3] = math.sqrt(math.pow(mousex, 2) + math.pow(height - mousey, 2))
		end
	else
		if mousey > height / 2 then
			self.ripple[3] = math.sqrt(math.pow(width - mousex, 2) + math.pow(mousey, 2))
		else
			self.ripple[3] = math.sqrt(math.pow(width - mousex, 2) + math.pow(width - mousey, 2))
		end
	end
	self.rippleAnimation = self:NewAnimation(0.33, 0, -1, function(animation)
		if animation != self.rippleAnimation then return end
		self.ripple = nil
		self:SetVisible(false)
		if self:GetDeleteOnClose() then self:Remove() end
		self:OnClose()
	end)
	self.rippleAnimation.Think = function(animation, panel, fraction)
		if animation != self.rippleAnimation then return end
		self.ripple[4] = 1 - fraction
		self.startTime = SysTime() - 3 * self.ripple[4]
	end
end

function PANEL:IsClosed()
	return self.closed
end

function PANEL:IsOpen()
	return !self.closed
end

function PANEL:OnClose() end

function PANEL:OnRemove()
	MFRAMES[self] = nil
end

function PANEL:Paint(width, height)
	if !self:IsVisible() then return end

	if self:GetBackgroundBlur() then
		Derma_DrawBackgroundBlur(self, self.startTime)
	end

	render.ClearStencil()
	render.SetStencilEnable(true)
	render.SetStencilWriteMask(255)
	render.SetStencilTestMask(255)

	render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
	render.SetStencilPassOperation(STENCILOPERATION_ZERO)
	render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
	render.SetStencilReferenceValue(1)

	draw.NoTexture()
	surface.SetDrawColor(Color(0, 0, 0))
	if self.ripple then
		self.ripple[3] = self.ripple[3] or math.sqrt(math.pow(width / 2, 2) + math.pow(height / 2, 2))
		sKore.drawCircle(self.ripple[1] or width / 2, self.ripple[2] or height / 2, self.ripple[3] * self.ripple[4])
	else
		surface.DrawRect(0, 0, width, height)
	end

	render.SetStencilFailOperation(STENCILOPERATION_KEEP)
	render.SetStencilPassOperation(STENCILOPERATION_KEEP)
	render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)

	if self:HasWindowBar() then
		draw.RoundedBox(sKore.scale(8), 0, self.windowBar.x + self.windowBar:GetTall(), width, height - self.windowBar.x - self.windowBar:GetTall(), sKore.getBackgroundColour(2))
	elseif self:HasAppBar() then
		draw.RoundedBox(sKore.scale(8), 0, self.appBar.x + self.appBar:GetTall(), width, height - self.appBar.x - self.appBar:GetTall(), sKore.getBackgroundColour(2))
	else
		draw.RoundedBox(sKore.scale(8), 0, 0, width, height, sKore.getBackgroundColour(2)) -- 76561198166995690
	end

	sKore.drawShadows(self)

	for _, child in pairs(self:GetChildren()) do
		child:PaintManual()
	end

	render.SetStencilEnable(false)
	render.ClearStencil()
end

function PANEL:PaintShadow(x, y)
	draw.RoundedBox(sKore.scale(8), x, y, self:GetWide(), self:GetTall(), sKore.getShadowColour())
end

function PANEL:PerformLayout()
	local width, height = self:GetSize()

	if !self.maximized and !self.resizing then
		if self.scaledWidth and sKore.scaleR(self.scaledWidth) != width then
			width = sKore.scaleRC(self.scaledWidth, nil, ScrW() - 30 * sKore.scalingFactorRaw)
			self:SetWidth(width)
			if !self:IsDraggable() then self:CenterHorizontal() end
		end
		if self.scaledHeight and sKore.scaleR(self.scaledHeight) != height then
			height = sKore.scaleRC(self.scaledHeight, nil, ScrH() - 30 * sKore.scalingFactorRaw)
			self:SetHeight(height)
			if !self:IsDraggable() then self:CenterVertical() end
		end
	end

	local canvasWidth, canvasHeight = self.canvasPlaceholder:GetSize()
	local canvasXOrigin, canvasYOrigin = self.canvasPlaceholder:GetPos()
	local scrollVertically = self:GetCanvasScrollVertically()
	for position, canvas in pairs(self:GetCanvas() or {}) do
		canvas:SetSize(canvasWidth, canvasHeight)
		if scrollVertically then
			canvas:SetPos(
				canvasXOrigin,
				canvasYOrigin + (canvasHeight + sKore.scaleR(20)) * (self.canvasPosition + position - 1)
			)
		else
			canvas:SetPos(
				canvasXOrigin + (canvasWidth + sKore.scaleR(20)) * (self.canvasPosition + position - 1),
				canvasYOrigin
			)
		end
	end
end

function PANEL:Think()
	if self.dragging then
		if !input.IsMouseDown(MOUSE_LEFT) or !self:HasWindowBar() or self.ripple then
			self.dragging = nil
		else
			local x = math.Clamp(gui.MouseX(), 1, ScrW() - 1) - self.dragging[1]
			local y = math.Clamp(gui.MouseY(), 1, ScrH() - 1) - self.dragging[2]

			if self:GetScreenLock() then
				x = math.Clamp(x, 0, ScrW() - self:GetWide())
				y = math.Clamp(y, 0, ScrH() - self:GetTall())
			elseif ispanel(self.windowBar) then
				x = math.Clamp(
					x, self.windowBar:GetTall() - self.windowBar:GetWide(),
					ScrW() - self.windowBar:GetTall()
				)
				y = math.Clamp(y, 0, ScrH() - self.windowBar:GetTall())
			end

			self:SetPos(x, y)
		end
	end
end

function PANEL:SetMinimumNavigationDrawerWidth(...)
	return self:GetNavigationDrawer():SetMinimumWidth(...)
end

function PANEL:GetMinimumNavigationDrawerWidth(...)
	return self:GetNavigationDrawer():GetMinimumWidth(...)
end

function PANEL:SetMaximumNavigationDrawerWidth(...)
	return self:GetNavigationDrawer():SetMaximumWidth(...)
end

function PANEL:GetMaximumNavigationDrawerWidth(...)
	return self:GetNavigationDrawer():GetMaximumWidth(...)
end

function PANEL:SetNavigationDrawerWidth(...)
	return self:GetNavigationDrawer():SetDrawerWidth(...)
end

function PANEL:GetNavigationDrawerWidth(...)
	return self:GetNavigationDrawer():GetNavigationDrawerWidth(...)
end

derma.DefineControl("MFrame", "", PANEL, "EditablePanel")
