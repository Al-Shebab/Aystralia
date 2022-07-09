
RayUI.Configuration.AddConfig( "OffsetX", {
	Title = "offset_x",
	TypeEnum = RAYUI_CONFIG_NUMBER,
	Default = 12,
	minNum = 0,
	maxNum = 200,
	SettingsOf = 1,
} )

RayUI.Configuration.AddConfig( "OffsetY", {
	Title = "offset_y",
	TypeEnum = RAYUI_CONFIG_NUMBER,
	Default = 12,
	minNum = 0,
	maxNum = 200,
	SettingsOf = 1,

} )

RayUI.Configuration.AddConfig( "MiniMode", {
	Title = "mini_mode",
	TypeEnum = RAYUI_CONFIG_BOOL,
	Default = false,
	SettingsOf = 1,
} )

RayUI.Configuration.AddConfig( "VehicleHUD", {
	Title = "vehicle_hud",
	TypeEnum = RAYUI_CONFIG_BOOL,
	Default = true,
	SettingsOf = 1,
} )

RayUI.Configuration.AddConfig( "VehicleInfo", {
	Title = "vehicle_info",
	TypeEnum = RAYUI_CONFIG_BOOL,
	Default = true,
	SettingsOf = 1,
} )

RayUI.Configuration.AddConfig( "DoorHUD", {
	Title = "door_hud",
	TypeEnum = RAYUI_CONFIG_BOOL,
	Default = true,
	SettingsOf = 1,
} )

RayUI.Configuration.AddConfig( "DoorMenu", {
	Title = "door_menu",
	TypeEnum = RAYUI_CONFIG_BOOL,
	Default = true,
	SettingsOf = 1,
} )

RayUI.Configuration.AddConfig( "CrashScreen", {
	Title = "crash_menu",
	TypeEnum = RAYUI_CONFIG_BOOL,
	Default = true,
	SettingsOf = 1,
} )

RayUI.Configuration.AddConfig( "HideOnSpawnMenu", {
	Title = "hide_menu",
	TypeEnum = RAYUI_CONFIG_BOOL,
	Default = true,
	SettingsOf = 1,
} )

RayUI.Configuration.AddConfig( "DisableKillfeed", {
	Title = "disable_killfeed",
	TypeEnum = RAYUI_CONFIG_BOOL,
	Default = false,
	SettingsOf = 1,
} )

RayUI.Configuration.AddConfig( "EnableBatteryAlert", {
	Title = "battery_alert",
	TypeEnum = RAYUI_CONFIG_BOOL,
	Default = false,
	SettingsOf = 1,
} )

RayUI.Configuration.AddConfig( "OverheadHUDNum", {
	Title = "overhead_ui_numbers",
	TypeEnum = RAYUI_CONFIG_BOOL,
	Default = true,
	SettingsOf = 1,
} )

RayUI.Configuration.AddConfig( "OverheadHUD", {
	Title = "overhead_ui",
	TypeEnum = RAYUI_CONFIG_TABLE,
	Default = "Show everything",
	Values = {"Show everything", "Show name only", "Hide HP and Armor", "Hide RP Name", "Hide everything"},
	SettingsOf = 1,
} )

RayUI.Configuration.AddConfig( "LawsPanel", {
	Title = "laws_panel",
	TypeEnum = RAYUI_CONFIG_TABLE,
	Default = "Show when opening scoreboard",
	Values = {"Always Show", "Show when opening scoreboard", "Hide"},
	SettingsOf = 1,
} )

RayUI.Configuration.AddConfig( "WantedList", {
	Title = "wanted_list",
	TypeEnum = RAYUI_CONFIG_TABLE,
	Default = "Show when opening scoreboard",
	Values = {"Always Show", "Show when opening scoreboard", "Hide"},
	SettingsOf = 1,
} )

RayUI.Configuration.AddConfig( "LevelPanel", {
	Title = "level_panel",
	TypeEnum = RAYUI_CONFIG_TABLE,
	Default = "Show when getting XP",
	Values = {"Always Show", "Show when opening scoreboard", "Show when getting XP", "Hide"},
	SettingsOf = 1,
} )

RayUI.Configuration.AddConfig( "LevelSystem", {
	Title = "level_system",
	TypeEnum = RAYUI_CONFIG_TABLE,
	Default = "None",
	Values = {"None", "Vrondakis Level System", "Sublime Levels", "GlorifiedLeveling"},
	SettingsOf = 1,
} )

if SERVER then
	RayUI.Configuration.LoadConfig()
end