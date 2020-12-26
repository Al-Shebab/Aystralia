
local PANEL = {}

function PANEL:Init()
	self:SetDeleteOnClose(false)

	local openThemesButton = self:AddOption("#defaultMenu_openThemes")
	openThemesButton.DoClick = function()
		self.frame:Close()
		timer.Simple(0.33, function()
			sKore.openThemesTab()
		end)
	end
	openThemesButton:SetEnabled(sKore.config["allowThemeSelection"])

	local openScalingButton = self:AddOption("#defaultMenu_openScaling")
	openScalingButton.DoClick = function()
		self.frame:Close()
		timer.Simple(0.33, function()
			sKore.openScalingTab()
		end)
	end
	openScalingButton:SetEnabled(sKore.config["allowScaleAjustment"])

	local openLanguageButton = self:AddOption("#defaultMenu_openLanguage")
	openLanguageButton.DoClick = function()
		self.frame:Close()
		timer.Simple(0.33, function()
			sKore.openLanguageTab()
		end)
	end
	openLanguageButton:SetEnabled(sKore.config["allowLanguageSelection"])
end

derma.DefineControl("MDefaultMenu", "", PANEL, "MMenu")
