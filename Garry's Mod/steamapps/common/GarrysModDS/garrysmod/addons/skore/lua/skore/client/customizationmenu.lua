
function sKore.openThemesTab()
	if !sKore.config["allowThemeSelection"] then return end
	sKore.openCustomizationMenu()
	sKore.customizationMenu:MoveToCanvas(sKore.customizationMenu.themesTab, true)
end

function sKore.openScalingTab()
	if !sKore.config["allowScaleAjustment"] then return end
	sKore.openCustomizationMenu()
	sKore.customizationMenu:MoveToCanvas(sKore.customizationMenu.scaleTab, true)
end

function sKore.openLanguageTab()
	if !sKore.config["allowLanguageSelection"] then return end
	sKore.openCustomizationMenu()
	sKore.customizationMenu:MoveToCanvas(sKore.customizationMenu.languageTab, true)
end

hook.Add("OnPlayerChat", "sKoreCustomizationChatCommands", function(ply, text)
	text = text:lower()
	if sKore.config["allowThemeSelection"] and sKore.config["themeSelectionMenuChat"][text] then
		if ply == LocalPlayer() then sKore.openThemesTab() end
		return true
	elseif sKore.config["allowScaleAjustment"] and sKore.config["minimumScale"] < sKore.config["maximumScale"] and sKore.config["scaleAjustmentMenuChat"][text] then
		if ply == LocalPlayer() then sKore.openScalingTab() end
		return true
	elseif sKore.config["allowLanguageSelection"] and sKore.config["languageSelectionMenuChat"][text] then
		if ply == LocalPlayer() then sKore.openLanguageTab() end
		return true
	end
end)

for _, commandName in ipairs(sKore.config["themeSelectionMenuConsole"]) do
	concommand.Add(commandName, sKore.openThemesTab)
end

for _, commandName in ipairs(sKore.config["scaleAjustmentMenuConsole"]) do
	concommand.Add(commandName, sKore.openScalingTab)
end

for _, commandName in ipairs(sKore.config["languageSelectionMenuConsole"]) do
	concommand.Add(commandName, sKore.openLanguageTab)
end

function sKore.openCustomizationMenu()
	if IsValid(sKore.customizationMenu) then
		sKore.customizationMenu:Open()
		sKore.customizationMenu:Center()
		return
	end

	sKore.customizationMenu = vgui.Create("MFrame")
	sKore.customizationMenu:SetScaledSize(950, 650)
	sKore.customizationMenu:SetTitle("#customization_title")
	sKore.customizationMenu:ShowNavigationDrawer(true)
	sKore.customizationMenu:SetNavigationDrawerWidth(sKore.scale, 200)
	sKore.customizationMenu:SetDraggable(true)
	sKore.customizationMenu:SetDeleteOnClose(false)
	sKore.customizationMenu:Center()
	sKore.customizationMenu:MakePopup()

	local appBar = sKore.customizationMenu:GetAppBar()
	local navigationDrawer = sKore.customizationMenu:GetNavigationDrawer()

	local optionsMenu = vgui.Create("MMenu", sKore.customizationMenu)
	optionsMenu:SetDeleteOnClose(false)

	local defaultThemeButton = optionsMenu:AddOption("#customization_restoreDefaultTheme")
	defaultThemeButton.DoClick = function()
		local defaultThemeID = sKore.getDefaultThemeID()
		if sKore.getActiveThemeID() != defaultThemeID then
			sKore.themeConvar:SetString(defaultThemeID)
			sKore.customizationMenu:CreateSnackbar("#customization_defaultThemeRestored", 1.5)
		else
			sKore.customizationMenu:CreateSnackbar("#customization_alreadyDefaultTheme", 1.5)
		end
	end
	defaultThemeButton:SetEnabled(sKore.config["allowThemeSelection"])

	local defaultScalingButton = optionsMenu:AddOption("#customization_restoreDefaultScaling")
	defaultScalingButton.DoClick = function()
		if sKore.scalingConvar:GetFloat() != 1 then
			sKore.scalingConvar:SetFloat(sKore.scalingConvar:GetDefault())
			sKore.customizationMenu:Center()
			sKore.customizationMenu:CreateSnackbar("#customization_defaultScalingRestored", 1.5)
		else
			sKore.customizationMenu:CreateSnackbar("#customization_alreadyDefaultScaling", 1.5)
		end
	end
	defaultScalingButton:SetEnabled(sKore.config["allowScaleAjustment"])

	local defaultLanguageButton = optionsMenu:AddOption("#customization_restoreDefaultLanguage")
	defaultLanguageButton.DoClick = function()
		local defaultLanguage = sKore.getDefaultLanguageName()
		if sKore.getActiveLanguageName() != defaultLanguage then
			sKore.languageConvar:SetString(defaultLanguage)
			sKore.customizationMenu:CreateSnackbar("#customization_defaultLanguageRestored", 1.5)
		else
			sKore.customizationMenu:CreateSnackbar("#customization_alreadyDefaultLanguage", 1.5)
		end
	end
	defaultLanguageButton:SetEnabled(sKore.config["allowLanguageSelection"])

	local optionsButton = appBar:AddButton()
	optionsButton.DoClick = function() optionsMenu:Open(sKore.TOP_RIGHT) end

	if sKore.config["allowThemeSelection"] then
		local themesCanvas, canvasPosition = sKore.customizationMenu:AddCanvas()
		sKore.customizationMenu.themesTab = canvasPosition

		local themesTabButton = navigationDrawer:AddButton("#customization_themesTabName", "palette")
		themesTabButton.DoClick = function(self)
			self.frame:MoveToCanvas(canvasPosition)
		end

		if #sKore.config["lightThemeWheel"] != 0 then
			local lightPaletteBase = vgui.Create("MPanel", themesCanvas)
			lightPaletteBase:Dock(TOP)
			lightPaletteBase.Paint = function(self, width, height)
				draw.RoundedBox(sKore.scale(6), 0, 0, width, height, self:GetBackgroundColour())
			end
			lightPaletteBase.PaintOver = function(self) sKore.drawShadows(self) end

			local lightPaletteTitle = vgui.Create("DLabel", lightPaletteBase)
			lightPaletteTitle:SetFont("sKoreCardTitleText")
			lightPaletteTitle:Dock(TOP)
			lightPaletteTitle.PerformLayout = function(self, width, height)
				self:DockMargin(sKore.scale(16), sKore.scale(16), sKore.scale(8), 0)
				self:SetText(sKore.getPhrase("#customization_lightBackgroundPaletteTitle"))
				self:SetTextColor(sKore.getBackgroundTextColour(sKore.HIGH_EMPHASIS))
				self:SizeToContentsY()
			end

			local lightPaletteDescription = vgui.Create("DLabel", lightPaletteBase)
			lightPaletteDescription:SetFont("sKoreCardText")
			lightPaletteDescription:SetWrap(true)
			lightPaletteDescription:Dock(TOP)
			lightPaletteDescription.PerformLayout = function(self)
				self:DockMargin(sKore.scale(16), sKore.scale(8), sKore.scale(8), 0)
				self:SetText(sKore.getPhrase("#customization_lightBackgroundPaletteDescription"))
				self:SetTextColor(sKore.getBackgroundTextColour(sKore.HIGH_EMPHASIS))
				self:SizeToContentsY()
			end

			local lightPaletteWheel = vgui.Create("MCircularPalette", lightPaletteBase)
			lightPaletteWheel:Dock(TOP)
			lightPaletteWheel.PerformLayout = function(self, width, height)
				self:DockMargin(sKore.scale(16), sKore.scale(16), sKore.scale(16), 0)
				self:SetTall(sKore.scale(325))
				self:InvalidateParent(true)
				self:SetPalette(sKore.config["lightThemeWheel"])
			end

			lightPaletteBase.PerformLayout = function(self)
				local margin = sKore.scale(16)
				self:DockMargin(margin, margin, margin, 0)
				themesCanvas:SetPadding(0, 0, 0, margin)
				self:SetTall(lightPaletteWheel.y + lightPaletteWheel:GetTall() + sKore.scale(16))
			end
		end

		if #sKore.config["darkThemeWheel"] != 0 then
			local darkPaletteBase = vgui.Create("MPanel", themesCanvas)
			darkPaletteBase:Dock(TOP)
			darkPaletteBase.Paint = function(self, width, height)
				draw.RoundedBox(sKore.scale(6), 0, 0, width, height, self:GetBackgroundColour())
			end
			darkPaletteBase.PaintOver = function(self) sKore.drawShadows(self) end

			local darkPaletteTitle = vgui.Create("DLabel", darkPaletteBase)
			darkPaletteTitle:SetFont("sKoreCardTitleText")
			darkPaletteTitle:Dock(TOP)
			darkPaletteTitle.PerformLayout = function(self, width, height)
				self:DockMargin(sKore.scale(16), sKore.scale(16), sKore.scale(8), 0)
				self:SetText(sKore.getPhrase("#customization_darkBackgroundPaletteTitle"))
				self:SetTextColor(sKore.getBackgroundTextColour(sKore.HIGH_EMPHASIS))
				self:SizeToContentsY()
			end

			local darkPaletteDescription = vgui.Create("DLabel", darkPaletteBase)
			darkPaletteDescription:SetFont("sKoreCardText")
			darkPaletteDescription:SetWrap(true)
			darkPaletteDescription:Dock(TOP)
			darkPaletteDescription.PerformLayout = function(self)
				self:DockMargin(sKore.scale(16), sKore.scale(8), sKore.scale(8), 0)
				self:SetText(sKore.getPhrase("#customization_darkBackgroundPaletteDescription"))
				self:SetTextColor(sKore.getBackgroundTextColour(sKore.HIGH_EMPHASIS))
				self:SizeToContentsY()
			end

			local darkPaletteWheel = vgui.Create("MCircularPalette", darkPaletteBase)
			darkPaletteWheel:Dock(TOP)
			darkPaletteWheel.PerformLayout = function(self, width, height)
				self:DockMargin(sKore.scale(16), sKore.scale(16), sKore.scale(16), 0)
				self:SetTall(sKore.scale(325))
				self:InvalidateParent(true)
				self:SetPalette(sKore.config["darkThemeWheel"])
			end

			darkPaletteBase.PerformLayout = function(self)
				local margin = sKore.scale(16)
				self:DockMargin(margin, margin, margin, 0)
				themesCanvas:SetPadding(0, 0, 0, margin)
				self:SetTall(darkPaletteWheel.y + darkPaletteWheel:GetTall() + sKore.scale(16))
			end
		end

		local otherThemesBase = vgui.Create("MPanel", themesCanvas)
		otherThemesBase:Dock(TOP)

		local otherThemesTitle = vgui.Create("DLabel", otherThemesBase)
		otherThemesTitle:SetFont("sKoreCardTitleText")
		otherThemesTitle:Dock(TOP)
		otherThemesTitle.PerformLayout = function(self, width, height)
			self:DockMargin(sKore.scale(16), sKore.scale(16), sKore.scale(8), 0)
			self:SetText(sKore.getPhrase("#customization_otherThemesTitle"))
			self:SetTextColor(sKore.getBackgroundTextColour(sKore.HIGH_EMPHASIS))
			self:SizeToContentsY()
		end

		local otherThemesDescription = vgui.Create("DLabel", otherThemesBase)
		otherThemesDescription:SetFont("sKoreCardText")
		otherThemesDescription:SetWrap(true)
		otherThemesDescription:Dock(TOP)
		otherThemesDescription.PerformLayout = function(self, width, height)
			self:DockMargin(sKore.scale(16), sKore.scale(8), sKore.scale(8), 0)
			self:SetText(sKore.getPhrase("#customization_otherThemesDescription"))
			self:SetTextColor(sKore.getBackgroundTextColour(sKore.HIGH_EMPHASIS))
			self:SizeToContentsY()
		end

		local defaultButton = vgui.Create("MRaisedButton", otherThemesBase)
		defaultButton:SetText("#customization_defaultThemeButton")
		defaultButton.DoClick = function()
			local defaultTheme = sKore.getDefaultTheme()
			if sKore.getActiveThemeID() == defaultTheme:GetID() then
				sKore.customizationMenu:CreateSnackbar(sKore.getPhrase("#customization_alreadyDefaultTheme", defaultTheme:GetName()), 1.5)
			else
				sKore.themeConvar:SetString(defaultTheme:GetID())
				sKore.customizationMenu:CreateSnackbar(sKore.getPhrase("#customization_defaultThemeRestored", defaultTheme:GetName()), 1.5)
			end
		end

		local nightButton
		if sKore.isValidThemeID("night") then
			nightButton = vgui.Create("MRaisedButton", otherThemesBase)
			nightButton:SetText("#customization_nightThemeButton")
			nightButton.DoClick = function()
				local nightTheme = sKore.getThemeByID("night")
				if sKore.getActiveThemeID() == "night" then
					sKore.customizationMenu:CreateSnackbar(sKore.getPhrase("#customization_themeAlreadyInUse", nightTheme:GetName()), 1.5)
				else
					sKore.themeConvar:SetString("night")
					sKore.customizationMenu:CreateSnackbar(sKore.getPhrase("#customization_themeChangedSuccessfully", nightTheme:GetName()), 1.5)
				end
			end
		end

		otherThemesBase.PerformLayout = function(self, width, height)
			self:DockMargin(sKore.scale(16), sKore.scale(16), sKore.scale(16), 0)
			themesCanvas:SetPadding(0, 0, 0, sKore.scale(16))
			defaultButton:SizeToContents()
			defaultButton:SetPos(sKore.scale(16), otherThemesDescription.y + otherThemesDescription:GetTall() + sKore.scale(16))
			if nightButton then
				nightButton:SizeToContents()
				nightButton:SetPos(defaultButton.x + defaultButton:GetWide() + sKore.scale(16), defaultButton.y)
			end
			self:SetTall(defaultButton.y + defaultButton:GetTall() + sKore.scale(16))
		end
	else
		local themesTabButton = navigationDrawer:AddButton("#customization_themesTabName", "palette-disabled")
		themesTabButton:SetDisabled(true)
	end

	if sKore.config["allowScaleAjustment"] and sKore.config["minimumScale"] < sKore.config["maximumScale"] then
		local scaleCanvas, canvasPosition = sKore.customizationMenu:AddCanvas()
		sKore.customizationMenu.scaleTab = canvasPosition

		local scaleTabButton = navigationDrawer:AddButton("#customization_scalingTabName", "resize")
		scaleTabButton.DoClick = function(self)
			self.frame:MoveToCanvas(canvasPosition)
		end

		local scaleBase = vgui.Create("MPanel", scaleCanvas)
		scaleBase:Dock(TOP)
		scaleBase.Paint = function(self, width, height)
			draw.RoundedBox(sKore.scale(6), 0, 0, width, height, self:GetBackgroundColour())
		end
		scaleBase.PaintOver = function(self) sKore.drawShadows(self) end

		local scaleBaseTitle = vgui.Create("DLabel", scaleBase)
		scaleBaseTitle:SetFont("sKoreCardTitleText")
		scaleBaseTitle:Dock(TOP)
		scaleBaseTitle.PerformLayout = function(self)
			self:DockMargin(sKore.scale(16), sKore.scale(16), sKore.scale(8), 0)
			self:SetText(sKore.getPhrase("#customization_scalingTabTitle"))
			self:SetTextColor(sKore.getBackgroundTextColour(sKore.HIGH_EMPHASIS))
			self:SizeToContentsY()
		end

		local scaleBaseDescription = vgui.Create("DLabel", scaleBase)
		scaleBaseDescription:SetFont("sKoreCardText")
		scaleBaseDescription:SetWrap(true)
		scaleBaseDescription:Dock(TOP)
		scaleBaseDescription.PerformLayout = function(self)
			self:DockMargin(sKore.scale(16), sKore.scale(8), sKore.scale(8), 0)
			self:SetText(sKore.getPhrase("#customization_scalingTabDescription"))
			self:SetTextColor(sKore.getBackgroundTextColour(sKore.HIGH_EMPHASIS))
			self:SizeToContentsY()
		end

		local scaleSlider = vgui.Create("MSlider", scaleBase)
		scaleSlider:Dock(TOP)
		scaleSlider.PerformLayout = function(self)
			self:DockMargin(sKore.scale(16), sKore.scale(8), sKore.scale(16), 0)
		end
		scaleSlider:SetMinimumValue(sKore.config["minimumScale"])
		scaleSlider:SetMaximumValue(sKore.config["maximumScale"])
		scaleSlider.OnReleased = function(self)
			sKore.scalingConvar:SetFloat(scaleSlider:GetValue())
			self.frame:Center()
		end

		local resetButton = vgui.Create("MFlatButton", scaleBase)
		resetButton:SetText("#customization_scalingDefaultButton")
		resetButton.DoClick = function(self)
			if sKore.scalingConvar:GetFloat() == 1 then
				self.frame:CreateSnackbar("#customization_alreadyDefaultScaling", 1.5)
			else
				sKore.scalingConvar:SetFloat(sKore.scalingConvar:GetDefault())
				scaleSlider:SetValue(sKore.scalingConvar:GetFloat())
				self.frame:Center()
				self.frame:CreateSnackbar("#customization_defaultScalingRestored", 1.5)
			end
		end

		scaleBase.PerformLayout = function(self, width, height)
			self:DockMargin(sKore.scale(16), sKore.scale(16), sKore.scale(16), 0)
			scaleCanvas:SetPadding(0, 0, 0, sKore.scale(16))
			scaleSlider:SetValue(sKore.scalingConvar:GetFloat())
			resetButton:SizeToContents()
			resetButton:SetPos(width - sKore.scale(16) - resetButton:GetWide(), scaleSlider.y + scaleSlider:GetTall() + sKore.scale(4))
			self:SetTall(resetButton.y + resetButton:GetTall() + sKore.scale(16))
		end
	else
		local scaleTabButton = navigationDrawer:AddButton("#customization_scalingTabName", "resize-disabled")
		scaleTabButton:SetDisabled(true)
	end

	if sKore.config["allowLanguageSelection"] then
		local languageCanvas, canvasPosition = sKore.customizationMenu:AddCanvas()
		sKore.customizationMenu.languageTab = canvasPosition

		local langTabButton = navigationDrawer:AddButton("#customization_languageTabName", "earth")
		langTabButton.DoClick = function(self)
			self.frame:MoveToCanvas(canvasPosition)
		end

		local languageBase = vgui.Create("MPanel", languageCanvas)
		languageBase:Dock(TOP)
		languageBase.Paint = function(self, width, height)
			draw.RoundedBox(sKore.scale(6), 0, 0, width, height, self:GetBackgroundColour())
		end
		languageBase.PaintOver = function(self) sKore.drawShadows(self) end

		local languageBaseTitle = vgui.Create("DLabel", languageBase)
		languageBaseTitle:SetFont("sKoreCardTitleText")
		languageBaseTitle:Dock(TOP)
		languageBaseTitle.PerformLayout = function(self, width, height)
			self:DockMargin(sKore.scale(16), sKore.scale(16), sKore.scale(8), 0)
			self:SetText(sKore.getPhrase("#customization_languageTabTitle"))
			self:SetTextColor(sKore.getBackgroundTextColour(sKore.HIGH_EMPHASIS))
			self:SizeToContentsY()
		end

		local languageBaseDescription = vgui.Create("DLabel", languageBase)
		languageBaseDescription:SetFont("sKoreCardText")
		languageBaseDescription:SetWrap(true)
		languageBaseDescription:Dock(TOP)
		languageBaseDescription.PerformLayout = function(self, width, height)
			self:DockMargin(sKore.scale(16), sKore.scale(8), sKore.scale(8), sKore.scale(16))
			self:SetText(sKore.getPhrase("#customization_languageTabDescription"))
			self:SetTextColor(sKore.getBackgroundTextColour(sKore.HIGH_EMPHASIS))
			self:SizeToContentsY()
		end

		local lastButton
		for languageID, languageTable in SortedPairs(sKore.languages) do
			local languageButton = vgui.Create("MFlatButton", languageBase)
			languageButton:Dock(TOP)
			local oldPerformLayout = languageButton.PerformLayout
			local english = languageTable["language_english"]
			local native = languageTable["language_native"]
			local fancy
			if english != native then
				fancy = Format("%s (%s)", native, english)
			else
				fancy = english
			end
			languageButton:SetText(fancy)
			languageButton.PerformLayout = function(self, width, height)
				oldPerformLayout(self, width, height)
				self:DockMargin(sKore.scale(16), 0, sKore.scale(16), 0)
			end
			languageButton.DoClick = function()
				if sKore.getActiveLanguageName() != languageID then
					sKore.languageConvar:SetString(languageID)
					sKore.customizationMenu:CreateSnackbar(sKore.getPhrase("#customization_languageSuccessfullyChanged", fancy), 1.5)
				else
					sKore.customizationMenu:CreateSnackbar(sKore.getPhrase("#customization_languageAlreadyInUse", fancy), 1.5)
				end
			end
			lastButton = languageButton
		end

		languageBase.PerformLayout = function(self, width, height)
			self:DockMargin(sKore.scale(16), sKore.scale(16), sKore.scale(16), 0)
			languageCanvas:SetPadding(0, 0, 0, sKore.scale(16))
			self:SetTall(lastButton.y + lastButton:GetTall() + sKore.scale(16))
		end
	else
		local langTabButton = navigationDrawer:AddButton("#customization_languageTabName", "earth-disabled")
		langTabButton:SetDisabled(true)
	end
end

if sKore.config["promptLanguageSelection"] and !sKore.fileTable["promptedLanguageSelection"] then
	sKore.fileTable["promptedLanguageSelection"] = true
	file.Write(sKore.filePath, util.TableToJSON(sKore.fileTable))
	timer.Simple(0, sKore.openLanguageTab)
end
