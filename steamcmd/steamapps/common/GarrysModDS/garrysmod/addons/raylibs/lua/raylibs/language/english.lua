RayUI.Lang.english = {

	RayUI = {
		--[[------------------------------
			Setings Panel
		--------------------------------]]

		// Main, RayUI
		rayui_settings = "RayUI Settings",

		config_access = "Groups with access to config panel",
		ui_scale = "UI Scale",
		ui_rounding = "UI Rounding",
		ui_opacity = "UI Opacity",
		blur_mode = "Enable Blur Mode",
		job_color = "Use job color for UI header",
		custom_color = "Custom header color",
		language = "Language",

		save_settings = "Save Settings",
		reset_default = "Reset all settings",

		// RayHUD Settings
		offset_x = "Offset X",
		offset_y = "Offset Y",
		mini_mode = "Mini Mode",
		vehicle_hud = "Enable vehicle HUD (VCMod / Simfphys)",
		vehicle_info = "Enable vehicle info when looking on it",
		door_hud = "Show HUD on doors",
		door_menu = "Override default doors menu",
		crash_menu = "Enable crash screen",
		hide_menu = "Hide HUD with spawn menu open",
		disable_killfeed = "Disable killfeed",
		battery_alert = "Enable battery alert",
		overhead_ui_numbers = "Show numbers with Overhead UI",
		overhead_ui = "Overhead UI",
		overhead_ui = "Overhead UI",
		laws_panel = "Laws Panel",
		wanted_list = "Wanted List",
		level_panel = "Level Panel",
		level_system = "Level System",

		// RayBoard Settings
		rayboard_width = "Width of the scoreboard",
		rayboard_height = "Height of the scoreboard",
		rayboard_hide_hud = "Hide HUD when opening scoreboard",
		rayboard_title = "Header title (leave blank to use server name)",
		rayboard_mode = "Scoreboard mode",
		rayboard_can_hide = "Groups that can hide on the scoreboard",
		rayboard_can_use_incognito = "Groups that can use Incognito Mode",
		rayboard_can_see_incognito = "Groups that can see, who is using Incognito",

		// RayHUDTTT Settings
		drowning_indicator = "Drowning Indicator",
		credits_wepswitch = "Show credits on Weapon Switch",
		custom_icon = "Show custom items icon",
		shop_columns = "Shop Columns",
		shop_rows = "Shop Rows",
	},



	HUD = {

		--[[------------------------------
			Main Panel
		--------------------------------]]

		health = "HP",
		armor = "Armor",
		hunger = "Hunger",


		--[[------------------------------
			Lower Right
		--------------------------------]]

		props = "Props",
		ammo = "Ammo",

		// VCMod / Simfphys
		engine = "Engine",
		fuel = "Fuel",
		your_car = "Your car",


		--[[------------------------------
			Events
		--------------------------------]]

		lockdown = "Lockdown",
		lockdown_init = "The mayor has initiated lockdown. Return to your home.",

		wanted = "Wanted",
		wanted_cop = "You made %C wanted for %R.",
		wanted_criminal = "You are wanted by %C for: %R!",
		wanted_all = "%CR is wanted by %C for: %R!",

		unwanted = "Unwanted",
		unwanted_cop = "You have taken away %C's wanted status.",
		unwanted_criminal = "You are no longer wanted by the police.",
		unwanted_all = "%C is no longer wanted by the police.",

		warranted = "Warranted",
		warranted_cop = "You are now allowed to search %C's buildings.",
		warranted_criminal = "You have received a warrant by %C for %R.",

		unwarranted = "Unwarranted",
		unwarranted_cop = "You have removed %C's warrant.",
		unwarranted_criminal = "Your warrant have expired.",
		unwarranted_all = "%C have removed %S's warrant.",

		arrested = "Arrested",
		arrested_cop = "You have arrested %C for %T.",
		arrested_criminal = "You have been arrested by %C for %T.",

		unarrested = "Unarrested",
		unarrested_cop = "You have unarrested %C.",
		unarrested_criminal = "You have been unarrested by %C.",

		// Battery Alerts
		charger_connected = "Charger Connected",
		charging_started = "Your computer is now charging.",

		charger_disconnected = "Charger Disconnected",
		charging_aborted = "Your computer is no longer charging.",

		battery_status = "Battery Status",
		battery_info = "You currently have %B% of battery left. Connect charger to continue playing.",


		--[[------------------------------
			Doors
		--------------------------------]]

		for_sale = "For Sale",
		purchase_door = "Press F2 to purchase door",

		sell_door = "Sell door",
		buy_door = "Buy door",

		sell_vehicle = "Sell vehicle",
		buy_vehicle = "Buy vehicle",
		add_owner = "Add owner",
		remove_owner = "Remove owner",

		allow_ownership = "Allow ownership",
		disallow_ownership = "Disallow ownership",

		set_door_title = "Set door title",
		set_vehicle_title = "Set vehicle title",

		edit_groups = "Edit group access",

		group_door = "Group Door",
		group_door_access = "Access: %G",

		team_door = "Team Door",
		team_door_access = "Access: %J job(s)",

		owner_unknown = "Owner: Unknown",

		door_coowners = "Co-Owners:",
		allowed_coowners = "Allowed Co-Owners:",

		// DoorSkin and LockPeek support
		upgrade_lock = "Upgrade Lock",
		edit_door_appearance = "Edit Door Appearance",


		--[[------------------------------
			Vehicle Info
		--------------------------------]]

		vehicle = "Vehicle",

		owner = "Owner",
		co_owners = "Co-Owners: ",
		allowed_co_owners = "Allowed Co-Owners: ",
		owner_unknown = "Unknown",

		vehicle_unowned = "Unowned",
		vehicle_not_ownable = "Not Ownable",
		vehicle_access_group = "Access: %G",
		vehicle_access_jobs = "Access: %J job(s)",


		--[[------------------------------
			Gestures
		--------------------------------]]

		gesture_bow = "Bow",
		gesture_sexydance = "Sexy dance",
		gesture_follow_me = "Follow Me",
		gesture_laugh = "Laugh",
		gesture_lion_pose = "Lion Pose",
		gesture_nonverbal_no = "Non-verbal no",
		gesture_thumbs_up = "Thumbs up",
		gesture_wave = "Wave",
		gesture_dance = "Dance",
		

		--[[------------------------------
			Other
		--------------------------------]]

		laws = "Laws",

		--[[------------------------------
			Crash Screen
		--------------------------------]]

		connection_lost = "Connection Lost",
		lost_connection = "It looks like you've lost connection to the server.",
		reconnected = "If the server doesn’t recover, just press the 'reconnect' button to reconnect to the server.",
	},



	RayBoard = {

		score = "Score",
		deaths = "Deaths",
		karma = "Karma",

		sort = "Sort",

		id_changer = "Identity Changer",

		incognito_mode = "Incognito Mode",
		change_id = "Change identity",
		hide_yourself = "Hide yourself",
		unhide_yourself = "Unhide yourself",
		
		fake_nickname = "Set your fake nickname",
		fake_usergroup = "Set your fake usergroup",
		fake_avatar = "Change your avatar - Paste URL to jpg or png (leave blank to use your avatar)",
		save_fakeid = "Save FakeID",
		reset_fakeid = "Reset ID",
	},



	RayHUDTTT = {

		air_level = "Air Level",
		dmglogs_settings = "DmgLogs Settings",

		binds = "Binds",
		quickcommands_list = "List of quick commands.",
		shortcut_to_all = "Shortcut to all quick commands.",
		open_dmglogs = "Open DmgLogs Settings.",
		recently_weapon = "Recently held weapon",
		enable_disguiser = "Enable/Disable Disguiser",
		disguiser_tooltip = "You must have a disguiser to use it.",

		enable_fps = "Enable FPS info",
		enable_multicore = "Enable multicore rendering",
		enable_hardware_acc = "Enable hardware acceleration",
		disable_shadows = "Disable shadows",
		disable_skybox = "Disable skybox",
		disable_sprays = "Disable sprays",
		disable_gibs = "Disable 'gibs'",
		disable_gibs_help = "these are particles and objects that can fly away from corpses and ragdolls.",

		you_died = "You died!",

	}
}