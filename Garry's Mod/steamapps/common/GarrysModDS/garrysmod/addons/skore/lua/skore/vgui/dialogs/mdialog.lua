
local MDIALOGS = {}

function invalidateLayoutMDialogs()
	for panel, _ in pairs(MDIALOGS) do
		if !IsValid(panel) then MDIALOGS[panel] = nil continue end
		panel:InvalidateLayout(true)
		panel:InvalidateChildren(true)
	end
end

hook.Add("sKoreScaleUpdated", "sKoreMDialogScalingUpdated", invalidateLayoutMDialogs)
hook.Add("sKoreScalingReloaded", "sKoreMDialogScalingReloaded", invalidateLayoutMDialogs)
hook.Add("sKoreThemeUpdated", "sKoreMDialogThemeUpdated", invalidateLayoutMDialogs)
hook.Add("sKoreThemeReloaded", "sKoreMDialogThemeReloaded", invalidateLayoutMDialogs)
hook.Add("sKoreLanguageUpdated", "sKoreMDialogLanguageUpdated", invalidateLayoutMDialogs)
hook.Add("sKoreLanguageReloaded", "sKoreMDialogLanguageReloaded", invalidateLayoutMDialogs)

local PANEL = {}

table.Merge(PANEL, sKore.elevationGAS)
table.Merge(PANEL, sKore.shadowGAS)
sKore.AccessorFunc(PANEL, "backgroundBlur", "BackgroundBlur", sKore.FORCE_BOOL)
sKore.AccessorFunc(PANEL, "titleColour", "TitleColour", sKore.FORCE_COLOUR, sKore.invalidateLayout)
sKore.AccessorFunc(PANEL, "title", "Title", sKore.FORCE_STRING, sKore.invalidateLayoutNow)
sKore.AccessorFunc(PANEL, "descriptionColour", "DescriptionColour", sKore.FORCE_COLOUR, sKore.invalidateLayout)
sKore.AccessorFunc(PANEL, "description", "Description", sKore.FORCE_STRING, sKore.invalidateLayoutNow)
sKore.AccessorFunc(PANEL, "deleteOnClose", "DeleteOnClose", sKore.FORCE_BOOL)

function PANEL:Init()
	self:SetFocusTopLevel(true)
	self:SetZPos(2100)

	self.titleLabel = vgui.Create("DLabel", self)
	self.titleLabel:SetFont("sKoreCardTitleText")
	self.titleLabel:SetWrap(true)
	self.titleLabel:Dock(TOP)
	self.titleLabel:SetZPos(2101)

	self.descriptionLabel = vgui.Create("DLabel", self)
	self.descriptionLabel:SetFont("sKoreCardText")
	self.descriptionLabel:SetWrap(true)
	self.descriptionLabel:Dock(TOP)
	self.descriptionLabel:SetZPos(2102)

	self.actionBar = vgui.Create("Panel", self)
	self.actionBar:Dock(TOP)
	self.actionBar:SetZPos(2104)
	self.actionBar.Paint = function() end

	MDIALOGS[self] = true
	local parent = self:GetParent()
	if parent.AddShadow then parent:AddShadow(self) end
	self.frame = sKore.getFrame(self)
	self.globalShadows = self.globalShadows or {}
	self.items = {}
	self.updateOnSearch = {}

	self:SetElevation(2)
	self:SetShadowOffsetX(1)
	self:SetShadowOffsetY(1)
	self:SetPaintShadow(true)
	self:SetDrawShadows(true)
	self:SetDrawGlobalShadows(true)
	self:SetBackgroundBlur(true)
	self:SetDeleteOnClose(true)

	self:SetTitleColour(sKore.getBackgroundTextColour, sKore.HIGH_EMPHASIS)
	self:SetTitle("Title")
	self:SetDescriptionColour(sKore.getBackgroundTextColour, sKore.HIGH_EMPHASIS)
	self:SetDescription("Description.")

	self:InvalidateLayout(true)
	self:Open()
end

function PANEL:AddOption(text)
	local button = vgui.Create("MFlatButton", self.actionBar)
	button:SetText(text)
	button:Dock(RIGHT)

	table.insert(self.items, button)
	return button
end

function PANEL:OnChildAdded(child)
	child:SetPaintedManually(true)
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

function PANEL:Close()
	if self.closed == true then return end
	self.closed = true
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

function PANEL:OnClose() end

function PANEL:OnRemove()
	MDIALOGS[self] = nil
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

	draw.RoundedBox(sKore.scale(8), 0, 0, width, height, sKore.getBackgroundColour(3))
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
	if self.ripple then self.ripple[3] = nil end

	self:SetWide(sKore.scale(560))

	self.titleLabel:SetTextColor(self:GetTitleColour())
	self.titleLabel:SetText(sKore.getPhrase(self:GetTitle()))
	self.titleLabel:DockMargin(sKore.scale(24), sKore.scale(24), sKore.scale(24), 0)
	self.titleLabel:SizeToContentsY()

	self.descriptionLabel:SetTextColor(self:GetDescriptionColour())
	self.descriptionLabel:SetText(sKore.getPhrase(self:GetDescription()))
	self.descriptionLabel:DockMargin(sKore.scale(24), sKore.scale(16), sKore.scale(24), sKore.scale(28))
	self.descriptionLabel:SizeToContentsY()

	self.actionBar:DockMargin(sKore.scale(24), sKore.scale(16), sKore.scale(16), sKore.scale(16))
	for _, item in pairs(self.items) do
		item:SizeToContents()
		item:DockMargin(sKore.scale(16), 0, 0, 0)
	end
	self.actionBar:SizeToChildren(false, true)

	self:SetHeight(self.actionBar.y + self.actionBar:GetTall() + sKore.scale(16))
	self:Center()
end

derma.DefineControl("MDialog", "", PANEL, "EditablePanel")

function sKore.messageDialog(text, title, closeButtonText)
	if !isstring(text) and text != nil then error("'text' argument is neither a string nor nil!", 2) end
	if !isstring(title) and title != nil then error("'title' argument is neither a string nor nil!", 2) end
	if !isstring(closeButtonText) and closeButtonText != nil then error("'closeButtonText' argument is neither a string nor nil!", 2) end
	if table.Count(MDIALOGS) != 0 then return false end

	local dialog = vgui.Create("MDialog")
	dialog:SetTitle(title or "")
	dialog:SetDescription(text or "")

	local closeButton = dialog:AddOption(closeButtonText or "#dialog_ok")
	closeButton.DoClick = function()
		dialog:Close()
	end

	dialog:MakePopup()

	return dialog
end

function sKore.queryDialog(text, title, ...)
	if !isstring(text) and text != nil then error("'text' argument is neither a string nor nil!", 2) end
	if !isstring(title) and title != nil then error("'title' argument is neither a string nor nil!", 2) end
	if table.Count(MDIALOGS) != 0 then return false end

	local dialog = vgui.Create("MDialog")
	dialog:SetTitle(title or "")
	dialog:SetDescription(text or "")

	local buttons = {...}
	local skip = false
	if !isstring(buttons[1]) then error("Argument #3 is not a string!", 2) end
	for k, argument in ipairs(buttons) do
		if skip then skip = false continue end
		if !isstring(argument) then error("Argument #" .. (i + 2) .. " is not a string !", 2) end

		local button = dialog:AddOption(argument)

		if isfunction(buttons[k + 1]) then
			button.DoClick = function()
				dialog:Close()
				buttons[k + 1]()
			end
			skip = true
		else
			button.DoClick = function()
				dialog:Close()
			end
		end
	end

	dialog:MakePopup()

	return dialog
end

function sKore.stringRequestDialog(text, title, hintText, default, confirmFunc, cancelFunc, confirmText, cancelText)
	if !isstring(text) and text != nil then error("'text' argument is neither a string nor nil!", 2) end
	if !isstring(title) and title != nil then error("'title' argument is neither a string nor nil!", 2) end
	if !isstring(hintText) and hintText != nil then error("'hintText' argument is neither a string nor nil!", 2) end
	if !isstring(default) and default != nil then error("'default' argument is neither a string nor nil!", 2) end
	if !isfunction(confirmFunc) and confirmFunc != nil then error("'confirmFunc' argument is neither a function nor nil!", 2) end
	if !isfunction(cancelFunc) and cancelFunc != nil then error("'cancelFunc' argument is neither a function nor nil!", 2) end
	if !isstring(confirmText) and confirmText != nil then error("'confirmText' argument is neither a string nor nil!", 2) end
	if !isstring(cancelText) and cancelText != nil then error("'cancelText' argument is neither a string nor nil!", 2) end
	if table.Count(MDIALOGS) != 0 then return false end

	local dialog = vgui.Create("MTextEntryDialog")
	dialog:SetTitle(title or "")
	dialog:SetDescription(text or "")
	dialog:SetHintText(hintText or "")
	dialog:SetText(default or "")

	local confirmButton = dialog:AddOption(confirmText or "#dialog_confirm")
	confirmButton.DoClick = function()
		if confirmFunc then confirmFunc(dialog:GetText()) end
		dialog:Close()
	end

	if cancelText != "" then
		local cancelButton = dialog:AddOption(cancelText or "#dialog_cancel")
		cancelButton.DoClick = function()
			if cancelFunc then cancelFunc(dialog:GetText()) end
			dialog:Close()
		end
	end

	dialog:MakePopup()

	return dialog
end
