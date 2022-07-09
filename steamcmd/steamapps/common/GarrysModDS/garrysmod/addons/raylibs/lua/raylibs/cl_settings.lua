-- RayUI Owner: 76561198166995690
-- RayUI Version: 1.4

function RayUI:ShowSettings()

	local dataModifiers = {}

	local Settings = {
		Panel = {},
	}

	local function CreateSettings(parent, type)
		for k,v in SortedPairsByMemberValue(RayUI.Configuration.ConfigOptions, "Order", false) do
			if v.SettingsOf != type then continue end

			local dataModifier = vgui.Create("RayUI:DataPanel", parent)
			dataModifier:Dock(TOP)
			dataModifier:SetTall(60 * RayUI.Scale)
			dataModifier:SetID(k)
			table.insert(dataModifiers, dataModifier)
		end
	end

	local SettingsPanels = {
		{text = "RayUI Settings", icon = RayUI.Icons.Summary,
			callback = function(parent)
				CreateSettings(parent, 0)
			end
		},

		{text = "RayHUD Settings", icon = RayUI.Icons.Interface,
			ShouldShow = function()
				if RayHUD then return true end
			end,
			callback = function(parent)
				CreateSettings(parent, 1)
			end
		},

		{text = "RayBoard Settings", icon = RayUI.Icons.Score,
			ShouldShow = function()
				if RayBoard then return true end
			end,
			callback = function(parent)
				CreateSettings(parent, 2)
			end
		},

		{text = "RayHUD Settings", icon = RayUI.Icons.Interface,
			ShouldShow = function()
				if RayHUDTTT then return true end
			end,
			callback = function(parent)
				CreateSettings(parent, 3)
			end
		},
	}

	local SettingsPanel = vgui.Create("RayUI:MainPanel")
	SettingsPanel:SetSize(650 * RayUI.Scale, 800 * RayUI.Scale)
	SettingsPanel:CreateSidebar(SettingsPanels)
	SettingsPanel:SetTitle("RayUI Settings")
	SettingsPanel:Center()
	SettingsPanel:MakePopup()

	local DefaultButton = vgui.Create("DButton", SettingsPanel)
	DefaultButton:FormatRayButton(RayUI.GetPhrase("rayui", "reset_default"), RayUI.Colors.DarkGray3, RayUI.Colors.Red)
	DefaultButton:Dock(BOTTOM)
	DefaultButton:DockMargin(10 * RayUI.Scale, 0 * RayUI.Scale, 10 * RayUI.Scale, 10 * RayUI.Scale)
	DefaultButton:SetTall(40 * RayUI.Scale)
	DefaultButton:SetFont("RayUI:Large2")
	DefaultButton.DoClick = function()
		net.Start("RayUI:ResetConfiguration")
		net.SendToServer()

		timer.Simple(2, function()
			SettingsPanel:Remove()
			RunConsoleCommand("rayui")
		end)
	end

	local SaveBut = vgui.Create("DButton", SettingsPanel)
	SaveBut:FormatRayButton(RayUI.GetPhrase("rayui", "save_settings"), RayUI.Colors.DarkGray3, RayUI.Colors.Green)
	SaveBut:Dock(BOTTOM)
	SaveBut:DockMargin(10 * RayUI.Scale, 0 * RayUI.Scale, 10 * RayUI.Scale, 10 * RayUI.Scale)
	SaveBut:SetTall(40 * RayUI.Scale)
	SaveBut:SetFont("RayUI:Large2")
	SaveBut.DoClick = function()
		local config = {}

		for k,v in pairs(dataModifiers) do
			if v.interactElement.IsColor then
				config[v.interactElement.ID] = v.interactElement:GetColor()
			else
				config[v.interactElement.ID] = v.interactElement:GetValue()
			end
		end

		net.Start("RayUI:SaveConfiguration")
			net.WriteTable(config)
		net.SendToServer()
	end
end

concommand.Add("rayui", function(ply)

	local configTxt = RayUI.Configuration.GetConfig( "ConfigAccess" )

	if string.Right(configTxt, 1) == "," then
		configTxt = string.Left(configTxt, #configTxt - 1)
	end

	local groupsAccess = string.Explode(",", configTxt)

	if !table.HasValue(groupsAccess, ply:GetUserGroup()) then
		notification.AddLegacy( "[RayUI] Only users with the following ranks can open the config menu: " .. table.concat(groupsAccess, ", "), NOTIFY_ERROR, 10)
		return
	end

	if RayHUDTTT then include("rayhud_ttt/shared/sh_setup.lua") end
	if RayHUD then include("rayhud/shared/sh_setup.lua") end
	if RayBoard then include("rayboard/shared/sh_setup.lua") end

	RayUI:ShowSettings()

end)