
sF4Menu = {["config"] = {}}

local function updateFonts()
	include("skore/modules/f4menu/client/fonts.lua")
end
hook.Add("sKoreScaleUpdated", "sF4MenuUpdateFonts1", updateFonts)
hook.Add("sKoreScalingReloaded", "sF4MenuUpdateFonts2", updateFonts)
updateFonts()

local validTabNames = {
	"dashboard", "jobs", "entities", "shipments", "weapons", "ammo", "food",
	"vehicles"
}
local validExtraTabsFields = {"icon", "text", "url"}
function sF4Menu.testConfig()
	local fileName = "skore/modules/f4menu/config/config.lua"

	local validTabNamesCopy = table.Copy(validTabNames)
	assert(istable(sF4Menu.config["enabledTabs"]), Format("The '%s' setting on '%s' is not a table!", "enabledTabs", fileName))
	for tabName, enabled in pairs(sF4Menu.config["enabledTabs"]) do
		assert(table.RemoveByValue(validTabNamesCopy, tabName) != false, Format("The key '%s' of the '%s' setting on '%s' is not a valid tab name!", tabName, "enabledTabs", fileName))
		assert(isbool(enabled), Format("The value of the key '%s' on the '%s' setting on '%s' is not a boolean!", tabName, "enabledTabs", fileName))
	end

	for _, tabName in pairs(validTabNamesCopy) do
		assert(false, Format("The '%s' setting on '%s' is missing the '%s' key!", "enabledTabs", fileName, tabName))
	end

	assert(isbool(sF4Menu.config["enableFavourites"]), Format("The '%s' setting on '%s' is not a boolean!", "enableFavourites", fileName))
	assert(isbool(sF4Menu.config["searchBar"]), Format("The '%s' setting on '%s' is not a boolean!", "searchBar", fileName))
	assert(isbool(sF4Menu.config["hideTabs"]), Format("The '%s' setting on '%s' is not a boolean!", "hideTabs", fileName))
	assert(isbool(sF4Menu.config["blurBackground"]), Format("The '%s' setting on '%s' is not a boolean!", "blurBackground", fileName))
	assert(isbool(sF4Menu.config["showDivider"]), Format("The '%s' setting on '%s' is not a boolean!", "showDivider", fileName))
	assert(isstring(sF4Menu.config["extraTabsLabel"]), Format("The '%s' setting on '%s' is not a string!", "extraTabsLabel", fileName))
	assert(isstring(sF4Menu.config["title"]), Format("The '%s' setting on '%s' is not a string!", "title", fileName))

	assert(istable(sF4Menu.config["extraTabs"]), Format("The '%s' setting on '%s' is not a table!", "extraTabs", fileName))
	assert(table.IsSequential(sF4Menu.config["extraTabs"]), Format("The '%s' setting on '%s' is not a sequential table!", "extraTabs", fileName))
	for key, data in pairs(sF4Menu.config["extraTabs"]) do
		assert(istable(data), Format("The value #%s of the '%s' setting on '%s' is not a table!", key, "extraTabs", fileName))
		assert(isstring(data["text"]), Format("The value of #%s of the '%s' setting on '%s' has an invalid 'text' field!", key, "extraTabs", fileName))
		assert(isstring(data["url"]), Format("The value of #%s of the '%s' setting on '%s' has an invalid 'url' field!", key, "extraTabs", fileName))
		for key2, _ in pairs(data) do
			assert(table.HasValue(validExtraTabsFields, key2), Format("The value of #%s of the '%s' setting on '%s' has an invalid field: '%s'", key, "extraTabs", fileName, key2))
		end
	end

	assert(istable(sF4Menu.config["adminRanks"]), Format("The '%s' setting on '%s' is not a table!", "adminRanks", fileName))
	assert(table.IsSequential(sF4Menu.config["adminRanks"]), Format("The '%s' setting on '%s' is not a sequential table!", "adminRanks", fileName))
	for key, value in pairs(sF4Menu.config["adminRanks"]) do
		assert(isstring(value), Format("The value of the key #%s of the '%s' setting on '%s' is not a string!", key, "adminRanks", fileName))
	end

	assert(istable(sF4Menu.config["dashboardCommands"]), Format("The '%s' setting on '%s' is not a table!", "dashboardCommands", fileName))
	assert(table.IsSequential(sF4Menu.config["dashboardCommands"]), Format("The '%s' setting on '%s' is not a sequential table!", "dashboardCommands", fileName))
end

include("skore/modules/f4menu/config/config.lua")

function sF4Menu.sortCategories(a, b)
	local sortOrderA = a.sortOrder or 100
	local sortOrderB = b.sortOrder or 100
	if sortOrderA == sortOrderB then
		return a.name < b.name
	else
		return sortOrderA < sortOrderB
	end
end

function sF4Menu.openF4Menu()
	if IsValid(sF4Menu.f4Menu) then
		if sF4Menu.f4Menu.RebuildDashboard then sF4Menu.f4Menu:RebuildDashboard() end
		sF4Menu.f4Menu:Open()
		sF4Menu.f4Menu:Center()
		return
	end

	sF4Menu.f4Menu = vgui.Create("MFrame")
	sF4Menu.f4Menu:SetScaledSize(1200, 750)
	sF4Menu.f4Menu:SetTitle(sF4Menu.config["title"] != "" and sF4Menu.config["title"] or GetHostName())
	sF4Menu.f4Menu:ShowNavigationDrawer(true)
	sF4Menu.f4Menu:SetNavigationDrawerWidth(sKore.scale, 200)
	sF4Menu.f4Menu:SetDraggable(true)
	sF4Menu.f4Menu:SetDeleteOnClose(false)
	sF4Menu.f4Menu:SetVisible(false)
	sF4Menu.f4Menu:SetBackgroundBlur(sF4Menu.config["blurBackground"])

	sF4Menu.f4Menu.OnKeyCodePressed = function(self, keyCode)
		if self:IsOpen() and self.ripple == nil and keyCode and input.LookupKeyBinding(keyCode) == "gm_showspare2" then
			self:Close()
			self.ripple[1] = nil
			self.ripple[2] = nil
		end
	end

	local appBar = sF4Menu.f4Menu:GetAppBar()
	local navigationDrawer = sF4Menu.f4Menu:GetNavigationDrawer()
	local darkRPCategories = DarkRP.getCategories()
	local playerTeam = LocalPlayer():Team()
	local optionsMenu = vgui.Create("MDefaultMenu", sF4Menu.f4Menu)
	local optionsButton = appBar:AddButton()
	optionsButton.DoClick = function() optionsMenu:Open(sKore.TOP_RIGHT) end
	if sF4Menu.config["searchBar"] then appBar:ShowSearchBar(true) end

	if sF4Menu.config["enabledTabs"]["dashboard"] then
		local dashboardCanvas, canvasPosition = sF4Menu.f4Menu:AddCanvas()
		local dashboardButton = navigationDrawer:AddButton("#f4menu_dashboardTab", "bulletin-board")
		dashboardButton.DoClick = function(self) self.frame:MoveToCanvas(canvasPosition) end
		local oldPerformLayout = dashboardCanvas.PerformLayout

		sF4Menu.f4Menu.RebuildDashboard = function()
			dashboardCanvas:Clear()

			local commandPanel = vgui.Create("MCategoryPanel", dashboardCanvas)
			commandPanel:SetText("#f4menu_commands")
			commandPanel:SetCollapsed(true)
			commandPanel:SetDrawShadows(true)
			commandPanel.Paint = function(self, width, height)
				draw.RoundedBox(sKore.scale(6), 0, 0, width, height, self:GetBackgroundColour())
				surface.SetDrawColor(sKore.getShadowColour())
				surface.DrawRect(0, self:GetUncollapsedHeight(), width, sKore.scaleRC(1, 1))
				sKore.drawShadows(self)
			end
			commandPanel.GetCollapsedHeight = function(self)
				return self.lastItem.y + self.lastItem:GetTall() + sKore.scale(16)
			end

			for _, commandData in pairs(sF4Menu.config["dashboardCommands"]) do
				local button = vgui.Create("MRaisedButton", commandPanel)
				button:SetText(commandData["buttonText"])
				if commandData["icon"] then
					button:SetMaterial(sKore.getPrimaryMaterial, sKore.PRIMARY, commandData["icon"])
				end
				button.DoClick = function()
					if commandData["prompt"] then
						local dialog = sKore.stringRequestDialog(
							commandData["promptDescription"], commandData["promptTitle"] or commandData["buttonText"], nil, nil,
							function(text)
								local commandCopy = table.Copy(commandData["command"])
								for k, value in pairs(commandData["command"]) do
									commandCopy[k] = Format(value, text)
								end
								RunConsoleCommand(unpack(commandCopy))
							end
						)
						if dialog then
							dialog.textEntry.textEntry:SetNumeric(commandData["numericPrompt"] or false)
						end
					else
						RunConsoleCommand(unpack(commandData["command"]))
					end
				end

				local oldButtonLayout = button.PerformLayout
				button.PerformLayout = function(self, width, height)
					oldButtonLayout(self, width, height)
					self:DockMargin(sKore.scale(16), sKore.scale(16), sKore.scale(16), 0)
				end
			end

			local staffPanel = vgui.Create("MCategoryPanel", dashboardCanvas)
			staffPanel:SetText("#f4menu_onlineStaff")
			staffPanel:SetCollapsed(true)

			for _, ply in pairs(player.GetHumans()) do
				if serverguard then
					if table.HasValue(sF4Menu.config["adminRanks"], serverguard.player:GetRank(ply)) then
						local staffItem = vgui.Create("MStaffItem", staffPanel)
						staffItem:SetPlayer(ply)
					end
				elseif table.HasValue(sF4Menu.config["adminRanks"], ply:GetUserGroup()) then
					local staffItem = vgui.Create("MStaffItem", staffPanel)
					staffItem:SetPlayer(ply)
				end
			end

			if #staffPanel:GetChildren() == 1 then staffPanel:Hide(true) end

			dashboardCanvas.PerformLayout = function(self, width, height)
				oldPerformLayout(self, width, height)
				self:SetPadding(0, 0, 0, sKore.scale(16))

				width = self:GetWide()
				staffPanel:SetWide((width - sKore.scaleR(16) * 3) * 0.45)
				staffPanel:SetPos(sKore.scale(16), sKore.scale(16))

				commandPanel:SetWide((width - sKore.scaleR(16) * 3) * 0.55)
				commandPanel:SetPos(staffPanel.x + staffPanel:GetWide() + sKore.scale(16), staffPanel.y)
			end
		end
		sF4Menu.f4Menu:RebuildDashboard()
	end

	if sF4Menu.config["enabledTabs"]["jobs"] then
		local jobCanvas, canvasPosition = sF4Menu.f4Menu:AddCanvas()
		local jobTabButton = navigationDrawer:AddButton("#f4menu_jobsTab", "briefcase")
		jobTabButton.DoClick = function(self) self.frame:MoveToCanvas(canvasPosition) end
		local oldPerformLayout = jobCanvas.PerformLayout
		jobCanvas.PerformLayout = function(self, width, height)
			oldPerformLayout(self, width, height)
			self:SetPadding(0, 0, 0, sKore.scale(16))
		end

		local hideFavourites = true
		local favouritePanel
		if sF4Menu.config["enableFavourites"] then
			favouritePanel = vgui.Create("MCategoryPanel", jobCanvas)
			favouritePanel:SetText("#f4menu_favouriteCategory")
			favouritePanel:SetCollapsed(true)
			favouritePanel:Dock(TOP)
		end

		table.sort(darkRPCategories.jobs or {}, sF4Menu.sortCategories)
		for _, categoryTable in ipairs(darkRPCategories.jobs or {}) do
			if categoryTable.canSee == nil or (isfunction(categoryTable.canSee) and categoryTable.canSee(LocalPlayer())) or categoryTable.canSee == true then
				local categoryPanel
				table.sort(categoryTable.members, sF4Menu.sortCategories)
				for _, jobTable in ipairs(categoryTable.members) do
					if (jobTable.NeedToChangeFrom != nil and jobTable.NeedToChangeFrom != playerTeam)
					or jobTable.team == playerTeam or (jobTable.customCheck and !jobTable.customCheck(LocalPlayer())) then continue end

					if !categoryPanel then
						categoryPanel = vgui.Create("MCategoryPanel", jobCanvas)
						categoryPanel:SetText(categoryTable.name)
						categoryPanel:SetCollapsed(categoryTable.startExpanded or false)
						categoryPanel:Dock(TOP)
					end

					local jobPanel = vgui.Create("MJobItem", categoryPanel)
					jobPanel:SetJobTable(jobTable)

					if favouritePanel then
						local jobPanelFavourites = vgui.Create("MJobItem", favouritePanel)
						jobPanelFavourites:SetJobTable(jobTable)
						jobPanelFavourites:SetFavouriteCategory(true)

						if !jobPanelFavourites:IsFavourited() then jobPanelFavourites:Close(true)
						else hideFavourites = false end
					end
				end
			end
		end

		if favouritePanel and hideFavourites then favouritePanel:Hide(true) end
	end

	if sF4Menu.config["enabledTabs"]["entities"] then
		local entitiesCanvas, canvasPosition = sF4Menu.f4Menu:AddCanvas()
		local navigationDrawerButton = navigationDrawer:AddButton("#f4menu_entitiesTab")
		navigationDrawerButton:SetMaterial(function() return sKore.getBackgroundMaterial(navigationDrawerButton:IsEnabled() and "printer" or "printer-disabled") end)
		navigationDrawerButton.DoClick = function(self) self.frame:MoveToCanvas(canvasPosition) end
		local oldPerformLayout = entitiesCanvas.PerformLayout
		entitiesCanvas.PerformLayout = function(self, width, height)
			oldPerformLayout(self, width, height)
			self:SetPadding(0, 0, 0, sKore.scale(16))
		end

		local hideFavourites = true
		local favouritePanel
		if sF4Menu.config["enableFavourites"] then
			favouritePanel = vgui.Create("MCategoryPanel", entitiesCanvas)
			favouritePanel:SetText("#f4menu_favouriteCategory")
			favouritePanel:SetCollapsed(true)
			favouritePanel:Dock(TOP)
		end

		table.sort(darkRPCategories.entities or {}, sF4Menu.sortCategories)
		for _, categoryTable in ipairs(darkRPCategories.entities or {}) do
			local categoryPanel
			if categoryTable.canSee == nil or (isfunction(categoryTable.canSee) and categoryTable.canSee(LocalPlayer())) or categoryTable.canSee == true then
				table.sort(categoryTable.members, sF4Menu.sortCategories)
				for _, memberTable in ipairs(categoryTable.members) do
					if (istable(memberTable.allowed) and !table.HasValue(memberTable.allowed, playerTeam))
					or (memberTable.customCheck and !memberTable.customCheck(LocalPlayer())) then continue end

					if !categoryPanel then
						categoryPanel = vgui.Create("MCategoryPanel", entitiesCanvas)
						categoryPanel:SetText(categoryTable.name)
						categoryPanel:SetCollapsed(categoryTable.startExpanded or false)
						categoryPanel:Dock(TOP)
					end

					local entityPanel = vgui.Create("MEntityItem", categoryPanel)
					entityPanel:SetEntityTable(memberTable)
					entityPanel:SetEntityType(categoryTable.categorises)
					entityPanel.command[2] = "/" .. memberTable.cmd

					if favouritePanel then
						local favouriteEntityPanel = vgui.Create("MEntityItem", favouritePanel)
						favouriteEntityPanel:SetEntityTable(memberTable)
						favouriteEntityPanel:SetEntityType(categoryTable.categorises)
						favouriteEntityPanel:SetFavouriteCategory(true)
						favouriteEntityPanel.command[2] = "/" .. memberTable.cmd

						if !favouriteEntityPanel:IsFavourited() then favouriteEntityPanel:Close(true)
						else hideFavourites = false end
					end
				end
			end
		end

		if favouritePanel and hideFavourites then favouritePanel:Hide(true) end

		if #entitiesCanvas:GetCanvas():GetChildren() == (favouritePanel and 1 or 0) then
			navigationDrawerButton.frame.canvas[canvasPosition] = nil
			entitiesCanvas:Remove()

			if sF4Menu.config["hideTabs"] then navigationDrawerButton:Remove()
			else navigationDrawerButton:SetEnabled(false) end
		end
	end

	if sF4Menu.config["enabledTabs"]["shipments"] then
		local entitiesCanvas, canvasPosition = sF4Menu.f4Menu:AddCanvas()
		local navigationDrawerButton = navigationDrawer:AddButton("#f4menu_shipmentsTab")
		navigationDrawerButton:SetMaterial(function() return sKore.getBackgroundMaterial(navigationDrawerButton:IsEnabled() and "package-variant-closed" or "package-variant-closed-disabled") end)
		navigationDrawerButton.DoClick = function(self) self.frame:MoveToCanvas(canvasPosition) end
		local oldPerformLayout = entitiesCanvas.PerformLayout
		entitiesCanvas.PerformLayout = function(self, width, height)
			oldPerformLayout(self, width, height)
			self:SetPadding(0, 0, 0, sKore.scale(16))
		end

		local hideFavourites = true
		local favouritePanel
		if sF4Menu.config["enableFavourites"] then
			favouritePanel = vgui.Create("MCategoryPanel", entitiesCanvas)
			favouritePanel:SetText("#f4menu_favouriteCategory")
			favouritePanel:SetCollapsed(true)
			favouritePanel:Dock(TOP)
		end

		table.sort(darkRPCategories.shipments or {}, sF4Menu.sortCategories)
		for _, categoryTable in ipairs(darkRPCategories.shipments or {}) do
			local categoryPanel
			if categoryTable.canSee == nil or (isfunction(categoryTable.canSee) and categoryTable.canSee(LocalPlayer())) or categoryTable.canSee == true then
				table.sort(categoryTable.members, sF4Menu.sortCategories)
				for _, memberTable in ipairs(categoryTable.members) do
					if (istable(memberTable.allowed) and !table.HasValue(memberTable.allowed, playerTeam))
					or (memberTable.customCheck and !memberTable.customCheck(LocalPlayer())) then continue end

					if !categoryPanel then
						categoryPanel = vgui.Create("MCategoryPanel", entitiesCanvas)
						categoryPanel:SetText(categoryTable.name)
						categoryPanel:SetCollapsed(categoryTable.startExpanded or false)
						categoryPanel:Dock(TOP)
					end

					local entityPanel = vgui.Create("MEntityItem", categoryPanel)
					entityPanel:SetEntityTable(memberTable)
					entityPanel:SetEntityType(categoryTable.categorises)
					entityPanel.command[2] = "/buyshipment " .. memberTable.name

					if favouritePanel then
						local favouriteEntityPanel = vgui.Create("MEntityItem", favouritePanel)
						favouriteEntityPanel:SetEntityTable(memberTable)
						favouriteEntityPanel:SetEntityType(categoryTable.categorises)
						favouriteEntityPanel:SetFavouriteCategory(true)
						favouriteEntityPanel.command[2] = "/buyshipment " .. memberTable.name

						if !favouriteEntityPanel:IsFavourited() then favouriteEntityPanel:Close(true)
						else hideFavourites = false end
					end
				end
			end
		end

		if favouritePanel and hideFavourites then favouritePanel:Hide(true) end

		if #entitiesCanvas:GetCanvas():GetChildren() == (favouritePanel and 1 or 0) then
			navigationDrawerButton.frame.canvas[canvasPosition] = nil
			entitiesCanvas:Remove()

			if sF4Menu.config["hideTabs"] then navigationDrawerButton:Remove()
			else navigationDrawerButton:SetEnabled(false) end
		end
	end

	if sF4Menu.config["enabledTabs"]["weapons"] then
		local entitiesCanvas, canvasPosition = sF4Menu.f4Menu:AddCanvas()
		local navigationDrawerButton = navigationDrawer:AddButton("#f4menu_weaponsTab")
		navigationDrawerButton:SetMaterial(function() return sKore.getBackgroundMaterial(navigationDrawerButton:IsEnabled() and "package-variant" or "package-variant-disabled") end)
		navigationDrawerButton.DoClick = function(self) self.frame:MoveToCanvas(canvasPosition) end
		local oldPerformLayout = entitiesCanvas.PerformLayout
		entitiesCanvas.PerformLayout = function(self, width, height)
			oldPerformLayout(self, width, height)
			self:SetPadding(0, 0, 0, sKore.scale(16))
		end

		local hideFavourites = true
		local favouritePanel
		if sF4Menu.config["enableFavourites"] then
			favouritePanel = vgui.Create("MCategoryPanel", entitiesCanvas)
			favouritePanel:SetText("#f4menu_favouriteCategory")
			favouritePanel:SetCollapsed(true)
			favouritePanel:Dock(TOP)
		end

		table.sort(darkRPCategories.weapons or {}, sF4Menu.sortCategories)
		for _, categoryTable in ipairs(darkRPCategories.weapons or {}) do
			local categoryPanel
			if categoryTable.canSee == nil or (isfunction(categoryTable.canSee) and categoryTable.canSee(LocalPlayer())) or categoryTable.canSee == true then
				table.sort(categoryTable.members, sF4Menu.sortCategories)
				for _, memberTable in ipairs(categoryTable.members) do
					if (istable(memberTable.allowed) and !table.HasValue(memberTable.allowed, playerTeam))
					or (memberTable.customCheck and !memberTable.customCheck(LocalPlayer())) then continue end

					if !categoryPanel then
						categoryPanel = vgui.Create("MCategoryPanel", entitiesCanvas)
						categoryPanel:SetText(categoryTable.name)
						categoryPanel:SetCollapsed(categoryTable.startExpanded or false)
						categoryPanel:Dock(TOP)
					end

					local entityPanel = vgui.Create("MEntityItem", categoryPanel)
					entityPanel:SetEntityTable(memberTable)
					entityPanel:SetEntityType(categoryTable.categorises)
					entityPanel:SetDescription(memberTable.pricesep == 0 and sKore.getPhrase("#f4menu_freePrice") or DarkRP.formatMoney(memberTable.pricesep))
					entityPanel.command[2] = "/buy " .. memberTable.name

					if favouritePanel then
						local favouriteEntityPanel = vgui.Create("MEntityItem", favouritePanel)
						favouriteEntityPanel:SetEntityTable(memberTable)
						favouriteEntityPanel.command[2] = "/buy " .. memberTable.name
						favouriteEntityPanel:SetEntityType(categoryTable.categorises)
						favouriteEntityPanel:SetFavouriteCategory(true)
						favouriteEntityPanel:SetDescription(memberTable.pricesep == 0 and sKore.getPhrase("#f4menu_freePrice") or DarkRP.formatMoney(memberTable.pricesep))

						if !favouriteEntityPanel:IsFavourited() then favouriteEntityPanel:Close(true)
						else hideFavourites = false end
					end
				end
			end
		end

		if favouritePanel and hideFavourites then favouritePanel:Hide(true) end

		if #entitiesCanvas:GetCanvas():GetChildren() == (favouritePanel and 1 or 0) then
			navigationDrawerButton.frame.canvas[canvasPosition] = nil
			entitiesCanvas:Remove()

			if sF4Menu.config["hideTabs"] then navigationDrawerButton:Remove()
			else navigationDrawerButton:SetEnabled(false) end
		end
	end

	if sF4Menu.config["enabledTabs"]["ammo"] then
		local entitiesCanvas, canvasPosition = sF4Menu.f4Menu:AddCanvas()
		local navigationDrawerButton = navigationDrawer:AddButton("#f4menu_ammoTab")
		navigationDrawerButton:SetMaterial(function() return sKore.getBackgroundMaterial(navigationDrawerButton:IsEnabled() and "pistol" or "pistol-disabled") end) -- 76561198166995690
		navigationDrawerButton.DoClick = function(self) self.frame:MoveToCanvas(canvasPosition) end
		local oldPerformLayout = entitiesCanvas.PerformLayout
		entitiesCanvas.PerformLayout = function(self, width, height)
			oldPerformLayout(self, width, height)
			self:SetPadding(0, 0, 0, sKore.scale(16))
		end

		local hideFavourites = true
		local favouritePanel
		if sF4Menu.config["enableFavourites"] then
			favouritePanel = vgui.Create("MCategoryPanel", entitiesCanvas)
			favouritePanel:SetText("#f4menu_favouriteCategory")
			favouritePanel:SetCollapsed(true)
			favouritePanel:Dock(TOP)
		end

		table.sort(darkRPCategories.ammo or {}, sF4Menu.sortCategories)
		for _, categoryTable in ipairs(darkRPCategories.ammo or {}) do
			local categoryPanel
			if categoryTable.canSee == nil or (isfunction(categoryTable.canSee) and categoryTable.canSee(LocalPlayer())) or categoryTable.canSee == true then
				table.sort(categoryTable.members, sF4Menu.sortCategories)
				for _, memberTable in ipairs(categoryTable.members) do
					if (istable(memberTable.allowed) and !table.HasValue(memberTable.allowed, playerTeam))
					or (memberTable.customCheck and !memberTable.customCheck(LocalPlayer())) then continue end

					if !categoryPanel then
						categoryPanel = vgui.Create("MCategoryPanel", entitiesCanvas)
						categoryPanel:SetText(categoryTable.name)
						categoryPanel:SetCollapsed(categoryTable.startExpanded or false)
						categoryPanel:Dock(TOP)
					end

					local entityPanel = vgui.Create("MEntityItem", categoryPanel)
					entityPanel:SetEntityTable(memberTable)
					entityPanel:SetEntityType(categoryTable.categorises)
					entityPanel.command[2] = "/buyammo " .. memberTable.id

					if favouritePanel then
						local favouriteEntityPanel = vgui.Create("MEntityItem", favouritePanel)
						favouriteEntityPanel:SetEntityTable(memberTable)
						favouriteEntityPanel:SetEntityType(categoryTable.categorises)
						favouriteEntityPanel:SetFavouriteCategory(true)
						favouriteEntityPanel.command[2] = "/buyammo " .. memberTable.id

						if !favouriteEntityPanel:IsFavourited() then favouriteEntityPanel:Close(true)
						else hideFavourites = false end
					end
				end
			end
		end

		if favouritePanel and hideFavourites then favouritePanel:Hide(true) end

		if #entitiesCanvas:GetCanvas():GetChildren() == (favouritePanel and 1 or 0) then
			navigationDrawerButton.frame.canvas[canvasPosition] = nil
			entitiesCanvas:Remove()

			if sF4Menu.config["hideTabs"] then navigationDrawerButton:Remove()
			else navigationDrawerButton:SetEnabled(false) end
		end
	end

	if sF4Menu.config["enabledTabs"]["food"] then
		local entitiesCanvas, canvasPosition = sF4Menu.f4Menu:AddCanvas()
		local navigationDrawerButton = navigationDrawer:AddButton("#f4menu_foodTab")
		navigationDrawerButton:SetMaterial(function() return sKore.getBackgroundMaterial(navigationDrawerButton:IsEnabled() and "silverware-variant" or "silverware-variant-disabled") end)
		navigationDrawerButton.DoClick = function(self) self.frame:MoveToCanvas(canvasPosition) end
		local oldPerformLayout = entitiesCanvas.PerformLayout
		entitiesCanvas.PerformLayout = function(self, width, height)
			oldPerformLayout(self, width, height)
			self:SetPadding(0, 0, 0, sKore.scale(16))
		end

		local hideFavourites = true
		local favouritePanel
		if sF4Menu.config["enableFavourites"] then
			favouritePanel = vgui.Create("MCategoryPanel", entitiesCanvas)
			favouritePanel:SetText("#f4menu_favouriteCategory")
			favouritePanel:SetCollapsed(true)
			favouritePanel:Dock(TOP)
		end

		local categoryPanel
		for _, memberTable in pairs(DarkRP.getFoodItems() or {}) do
			if (istable(memberTable.allowed) and !table.HasValue(memberTable.allowed, playerTeam))
			or (memberTable.customCheck and !memberTable.customCheck(LocalPlayer()))
			or ((memberTable.requiresCook == nil or memberTable.requiresCook == true) and !LocalPlayer():isCook()) then continue end

			if !categoryPanel then
				categoryPanel = vgui.Create("MCategoryPanel", entitiesCanvas)
				categoryPanel:SetText("#f4menu_foodTab")
				categoryPanel:SetCollapsed(true)
				categoryPanel:Dock(TOP)
			end

			local entityPanel = vgui.Create("MEntityItem", categoryPanel)
			entityPanel:SetEntityTable(memberTable)
			entityPanel:SetEntityType("food")
			entityPanel.command[2] = "/buyfood " .. memberTable.name

			if favouritePanel then
				local favouriteEntityPanel = vgui.Create("MEntityItem", favouritePanel)
				favouriteEntityPanel:SetEntityTable(memberTable)
				favouriteEntityPanel:SetEntityType("food")
				favouriteEntityPanel:SetFavouriteCategory(true)
				favouriteEntityPanel.command[2] = "/buyfood " .. memberTable.name

				if !favouriteEntityPanel:IsFavourited() then favouriteEntityPanel:Close(true)
				else hideFavourites = false end
			end
		end

		if favouritePanel and hideFavourites then favouritePanel:Hide(true) end

		if #entitiesCanvas:GetCanvas():GetChildren() == (favouritePanel and 1 or 0) then
			navigationDrawerButton.frame.canvas[canvasPosition] = nil
			entitiesCanvas:Remove()

			if sF4Menu.config["hideTabs"] then navigationDrawerButton:Remove()
			else navigationDrawerButton:SetEnabled(false) end
		end
	end

	if sF4Menu.config["enabledTabs"]["vehicles"] then
		local entitiesCanvas, canvasPosition = sF4Menu.f4Menu:AddCanvas()
		local navigationDrawerButton = navigationDrawer:AddButton("#f4menu_vehiclesTab")
		navigationDrawerButton:SetMaterial(function() return sKore.getBackgroundMaterial(navigationDrawerButton:IsEnabled() and "car" or "car-disabled") end)
		navigationDrawerButton.DoClick = function(self) self.frame:MoveToCanvas(canvasPosition) end

		local hideFavourites = true
		local favouritePanel
		if sF4Menu.config["enableFavourites"] then
			favouritePanel = vgui.Create("MCategoryPanel", entitiesCanvas)
			favouritePanel:SetText("#f4menu_favouriteCategory")
			favouritePanel:SetCollapsed(true)
			favouritePanel:Dock(TOP)
		end

		table.sort(darkRPCategories.vehicles or {}, sF4Menu.sortCategories)
		for _, categoryTable in ipairs(darkRPCategories.vehicles or {}) do
			local categoryPanel
			if categoryTable.canSee == nil or (isfunction(categoryTable.canSee) and categoryTable.canSee(LocalPlayer())) or categoryTable.canSee == true then
				table.sort(categoryTable.members, sF4Menu.sortCategories)
				for k2, memberTable in ipairs(categoryTable.members) do
					if (istable(memberTable.allowed) and !table.HasValue(memberTable.allowed, playerTeam))
					or (memberTable.customCheck and !memberTable.customCheck(LocalPlayer())) then continue end

					if !categoryPanel then
						categoryPanel = vgui.Create("MCategoryPanel", entitiesCanvas)
						categoryPanel:SetText(categoryTable.name)
						categoryPanel:SetCollapsed(categoryTable.startExpanded or false)
						categoryPanel:Dock(TOP)
					end

					local entityPanel = vgui.Create("MEntityItem", categoryPanel)
					entityPanel:SetEntityTable(memberTable)
					entityPanel:SetEntityType(categoryTable.categorises)
					entityPanel.command[2] = "/buyvehicle " .. memberTable.name
					entityPanel:SetDistanceModifier(5)

					if favouritePanel then
						local favouriteEntityPanel = vgui.Create("MEntityItem", favouritePanel)
						favouriteEntityPanel:SetEntityTable(memberTable)
						favouriteEntityPanel:SetEntityType(categoryTable.categorises)
						favouriteEntityPanel:SetFavouriteCategory(true)
						favouriteEntityPanel.command[2] = "/buyvehicle " .. memberTable.name
						favouriteEntityPanel:SetDistanceModifier(5)

						if !favouriteEntityPanel:IsFavourited() then favouriteEntityPanel:Close(true)
						else hideFavourites = false end
					end
				end
			end
		end

		if favouritePanel and hideFavourites then favouritePanel:Hide(true) end

		if #entitiesCanvas:GetCanvas():GetChildren() == (favouritePanel and 1 or 0) then
			navigationDrawerButton.frame.canvas[canvasPosition] = nil
			entitiesCanvas:Remove()

			if sF4Menu.config["hideTabs"] then navigationDrawerButton:Remove()
			else navigationDrawerButton:SetEnabled(false) end
		end
	end

	if sF4Menu.config["showDivider"] then navigationDrawer:AddSpacer() end
	if sF4Menu.config["extraTabsLabel"] != "" then navigationDrawer:AddLabel("Useful Links") end

	for _, extraTab in pairs(sF4Menu.config["extraTabs"]) do
		local button = navigationDrawer:AddButton(extraTab["text"], extraTab["icon"])
		button.DoClick = function() gui.OpenURL(extraTab["url"]) end
	end

	sF4Menu.f4Menu:SetVisible(true)
	--sF4Menu.f4Menu:InvalidateLayout(true)
	sF4Menu.f4Menu:InvalidateChildren(true)
	sF4Menu.f4Menu:Open()
	sF4Menu.f4Menu:Center()
	sF4Menu.f4Menu:MakePopup()
end
DarkRP.openF4Menu = sF4Menu.openF4Menu

function DarkRP.closeF4Menu()
	if IsValid(sF4Menu.f4Menu) and sF4Menu.f4Menu:IsOpen() then
		sF4Menu.f4Menu:Close(true)
	end
end

function DarkRP.toggleF4Menu()
	if IsValid(sF4Menu.f4Menu) and sF4Menu.f4Menu:IsOpen() then
		DarkRP.closeF4Menu()
	else
		DarkRP.openF4Menu()
	end
end

function DarkRP.getF4MenuPanel()
	return sF4Menu.f4Menu
end

GAMEMODE.ShowSpare2 = DarkRP.toggleF4Menu

hook.Add("OnPlayerChangedTeam", "sF4MenuRebuild", function()
	if IsValid(sF4Menu.f4Menu) then sF4Menu.f4Menu:Remove() end
end)
