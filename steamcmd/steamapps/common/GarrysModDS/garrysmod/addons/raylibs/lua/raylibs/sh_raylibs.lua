-- RayUI Owner: 76561198166995690
-- RayUI Version: 1.4

function RayUI.GetPhrase(type, phrase)
	local lang = RayUI.Configuration.GetConfig( "Language" )

	if !RayUI.Lang[lang] then
		lang = "english"
	end
	 
	if type == "hud" then 
		return RayUI.Lang[lang].HUD[phrase] or "Missing: " .. (phrase)
	elseif type == "rayui" then
		return RayUI.Lang[lang].RayUI[phrase] or "Missing: " .. (phrase)
	elseif type == "rayboard" then
		return RayUI.Lang[lang].RayBoard[phrase] or "Missing: " .. (phrase)
	elseif type == "rayhudttt" then
		return RayUI.Lang[lang].RayHUDTTT[phrase] or "Missing: " .. (phrase)
	else
		return "Missing: " .. (phrase)
	end
end












RayUI.Configuration = {
	Config = {},
	ConfigOptions = {},
}














if SERVER then
	util.AddNetworkString("RayUI:UpdatePlayerConfig")
	util.AddNetworkString("RayUI:SaveConfiguration")
	util.AddNetworkString("RayUI:ResetConfiguration")
	util.AddNetworkString("RayUI:ConfigurationSaved")
	util.AddNetworkString("RayUI:GetConfig")

	function RayUI.Configuration.SaveConfiguration(configTbl)
		local JSON = util.TableToJSON(configTbl, true)

		file.Write("RayUI/config.txt", JSON)
	end

	function RayUI.Configuration.LoadConfig()
		local configFile = util.JSONToTable(file.Read("RayUI/config.txt","DATA"))

		local changesMade = false

		local function resetToDefault( id )
			configFile[id] = RayUI.Configuration.ConfigOptions[id].Default

			changesMade = true
		end

		for k,v in pairs(RayUI.Configuration.ConfigOptions) do

			if configFile[k] == nil then
				resetToDefault(k)
			end
		end

		if changesMade == true then
			RayUI.Configuration.SaveConfiguration(configFile)
		end

		RayUI.Configuration.Config = configFile
	end

	function RayUI.Configuration.UpdatePlayers( recipientFilter )

		net.Start("RayUI:UpdatePlayerConfig")
			net.WriteTable(RayUI.Configuration.Config)
		net.Send(recipientFilter)

	end

end











function RayUI.Configuration.AddConfig( ID, tbl )
	tbl.Order = table.Count(RayUI.Configuration.ConfigOptions) + 1

	RayUI.Configuration.ConfigOptions[ID] = tbl
end











function RayUI.Configuration.GetConfig( ID )
	return RayUI.Configuration.Config[ID]
end












RAYUI_CONFIG_BOOL = 1
RAYUI_CONFIG_STRING = 2
RAYUI_CONFIG_NUMBER = 3
RAYUI_CONFIG_TABLE = 4
RAYUI_CONFIG_COLOR = 5

RayUI.Configuration.AddConfig( "ConfigAccess", {
	Title = "config_access",
	TypeEnum = RAYUI_CONFIG_STRING,
	Default = "superadmin,admin",
	SettingsOf = 0,
} )

RayUI.Configuration.AddConfig( "Scale", {
	Title = "ui_scale",
	TypeEnum = RAYUI_CONFIG_NUMBER,
	Default = 20,
	minNum = 15,
	maxNum = 30,
	SettingsOf = 0,
} )

RayUI.Configuration.AddConfig( "Rounding", {
	Title = "ui_rounding",
	TypeEnum = RAYUI_CONFIG_NUMBER,
	Default = 16,
	minNum = 0,
	maxNum = 20,
	SettingsOf = 0,
} )

RayUI.Configuration.AddConfig( "Opacity", {
	Title = "ui_opacity",
	TypeEnum = RAYUI_CONFIG_NUMBER,
	Default = 255,
	minNum = 0,
	maxNum = 255,
	SettingsOf = 0,
} )

RayUI.Configuration.AddConfig( "BlurMode", {
	Title = "blur_mode",
	TypeEnum = RAYUI_CONFIG_BOOL,
	Default = false,
	SettingsOf = 0,
} )

RayUI.Configuration.AddConfig( "JobColor", {
	Title = "job_color",
	TypeEnum = RAYUI_CONFIG_BOOL,
	Default = false,
	SettingsOf = 0,
} )

RayUI.Configuration.AddConfig( "HeaderColor", {
	Title = "custom_color",
	TypeEnum = RAYUI_CONFIG_COLOR,
	Default = Color(86, 86, 86),
	SettingsOf = 0,
} )

RayUI.Configuration.AddConfig( "Language", {
	Title = "language",
	TypeEnum = RAYUI_CONFIG_TABLE,
	Default = "english",
	Values = RayUI.Lang,
	SortItems = true,
	SettingsOf = 0,
} )


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --





















if SERVER then
	if !file.Exists("RayUI","DATA") then
		file.CreateDir("RayUI")
	end

	if !file.Exists("RayUI/config.txt","DATA") then

		local toWriteTbl = {}

		for k,v in pairs(RayUI.Configuration.ConfigOptions) do
			toWriteTbl[k] = v.Default
		end

		RayUI.Configuration.SaveConfiguration( toWriteTbl )
	end

	RayUI.Configuration.LoadConfig()

	timer.Simple(1, function()
		local rf = RecipientFilter()

		rf:AddAllPlayers()

		RayUI.Configuration.UpdatePlayers( rf )
	end)

	net.Receive("RayUI:GetConfig", function( _, ply )

		if ply.RayHUDConfig != nil then return end

		local rf2 = RecipientFilter()

		rf2:AddPlayer(ply)

		RayUI.Configuration.UpdatePlayers( rf2 )
		ply.RayHUDConfig = true

	end)

	net.Receive("RayUI:SaveConfiguration", function( _, ply )

		local configTxt = RayUI.Configuration.GetConfig( "ConfigAccess" )

		if string.Right(configTxt, 1) == "," then
			configTxt = string.Left(configTxt, #configTxt - 1)
		end

		local groupsAccess = string.Explode(",", configTxt)

		if !table.HasValue(groupsAccess, ply:GetUserGroup()) then return end

		RayUI.Configuration.SaveConfiguration( net.ReadTable() )

		net.Start("RayUI:ConfigurationSaved")
		net.Send(ply)

		if RayHUD then include("autorun/rayhud_autorun.lua") end
		if RayBoard then include("autorun/rayboard_autorun.lua") end
		if RayHUDTTT then include("autorun/rayhud_ttt_autorun.lua") end

		include("autorun/raylibs_autorun.lua")

	end)
	-- 76561198166995699
	net.Receive("RayUI:ResetConfiguration", function( _, ply )

		local configTxt = RayUI.Configuration.GetConfig( "ConfigAccess" )

		if string.Right(configTxt, 1) == "," then
			configTxt = string.Left(configTxt, #configTxt - 1)
		end

		local groupsAccess = string.Explode(",", configTxt)
		if !table.HasValue(groupsAccess, ply:GetUserGroup()) then return end

		file.Delete("RayUI/config.txt")

		local toWriteTbl = {}

		for k,v in pairs(RayUI.Configuration.ConfigOptions) do
			toWriteTbl[k] = v.Default
		end

		RayUI.Configuration.SaveConfiguration( toWriteTbl )

		net.Start("RayUI:ConfigurationSaved")
		net.Send(ply)

		if RayHUD then include("autorun/rayhud_autorun.lua") end
		if RayBoard then include("autorun/rayboard_autorun.lua") end
		if RayHUDTTT then include("autorun/rayhud_ttt_autorun.lua") end

		include("autorun/raylibs_autorun.lua")
	end)

	hook.Add("PlayerSay", "RayUI:ConfigCommand", function( ply, text )
		if string.lower(text) == "!rayui" or string.lower(text) == "!rayhud" or string.lower(text) == "!rayboard" then
			ply:ConCommand("rayui")
		end
	end)























else
	RayUI.Configuration.Config = hook.Run("RayUI:Internal_GetConfig") or {}

	local config = {}

	if table.Count(RayUI.Configuration.Config) > 0 then
		config = RayUI.Configuration.Config
	else
		net.Start("RayUI:GetConfig")
		net.SendToServer()
	end

	hook.Add("RayUI:Internal_GetConfig", "RayUI:Config", function()
		return config
	end)

	net.Receive("RayUI:UpdatePlayerConfig", function()

		config = net.ReadTable()

		if RayBoard then include("autorun/rayboard_autorun.lua") end
		if RayHUDTTT then include("autorun/rayhud_ttt_autorun.lua") end
		
		if RayHUD then
			for k, v in ipairs(RayHUD.FlatPanels) do
				v:Remove()
			end

			include("autorun/rayhud_autorun.lua")
		end

		include("autorun/raylibs_autorun.lua")
	end)

	net.Receive("RayUI:ConfigurationSaved",function()
		chat.AddText(Color(50,50,50,255),"[RayUI] ", Color(255,255,255,255), "Configuration was saved successfully.")
	end)
end


hook.Run("RayUILoaded")