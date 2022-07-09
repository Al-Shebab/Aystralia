RayUI.Lang.polish = {

	RayUI = {
		--[[------------------------------
			Setings Panel
		--------------------------------]]

		// Main, RayUI
		rayui_settings = "Ustawienia RayUI",

		config_access = "Grupy z dostępem do ustawień",
		ui_scale = "Skala interfejsu",
		ui_rounding = "Zaokrąglenie interfejsu",
		ui_opacity = "Przeźroczystość interfejsu",
		blur_mode = "Włącz Blur",
		job_color = "Użyj koloru pracy dla nagłówków",
		custom_color = "Własny kolor nagłówków",
		language = "Język",

		save_settings = "Zapisz ustawienia",
		reset_default = "Zresetuj wszystkie ustawienia",

		// RayHUD Settings
		offset_x = "Odstęp X",
		offset_y = "Odstęp Y",
		mini_mode = "Tryb Mini",
		vehicle_hud = "Włącz HUD pojazdów (VCMod / Simfphys)",
		vehicle_info = "Włącz info o pojeździe, gdy na niego patrzysz",
		door_hud = "Pokaż HUD na drzwiach",
		door_menu = "Nadpisz domyślne menu drzwi",
		crash_menu = "Włącz crash screen",
		hide_menu = "Ukrywaj HUD, gdy otwierasz spawn menu",
		disable_killfeed = "Wyłącz killfeed",
		battery_alert = "Włącz ostrzeżenia baterii (laptopy)",
		overhead_ui_numbers = "Pokaż dokładne liczby nad głowami graczy",
		overhead_ui = "Interfejs nad głowami graczy",
		laws_panel = "Panel praw",
		wanted_list = "Lista poszukiwanych",
		level_panel = "Panel poziomu",
		level_system = "System poziomów",

		// RayBoard Settings
		rayboard_width = "Szerokość tabeli",
		rayboard_height = "Wysokość tabeli",
		rayboard_hide_hud = "Ukryj HUD przy otwartej tabeli",
		rayboard_title = "Tytuł nagłówka (zostaw puste by użyć nazwy serwera)",
		rayboard_mode = "Tryb tabeli",
		rayboard_can_hide = "Grupy, które mogą ukrywać się na tabeli",
		rayboard_can_use_incognito = "Grupy, które mogą używać trybu Incognito",
		rayboard_can_see_incognito = "Grupy, które widzą kto korzysta z Incognito",

		// RayHUDTTT Settings
		drowning_indicator = "Panel tlenu",
		credits_wepswitch = "Pokazuj kredyty na zmianie broni",
		custom_icon = "Pokazuj ikonę niestandardowych itemów",
		shop_columns = "Liczba kolumn sklepu",
		shop_rows = "Liczba rzędów sklepu",
	},



	HUD = {

		--[[------------------------------
			Main Panel
		--------------------------------]]

		health = "Życie",
		armor = "Pancerz",
		hunger = "Głód",


		--[[------------------------------
			Lower Right
		--------------------------------]]

		props = "Propy",
		ammo = "Ammo",

		// VCMod / Simfphys
		engine = "Silnik",
		fuel = "Paliwo",
		your_car = "Twoje auto",


		--[[------------------------------
			Events
		--------------------------------]]

		lockdown = "Lockdown",
		lockdown_init = "Burmistrz rozpoczął lockdown. Wróć do swojego domu.",

		wanted = "Poszukiwany",
		wanted_cop = "Rozpocząłeś poszukiwania %C za %R.",
		wanted_criminal = "Jesteś poszukiwany przez %C za: %R!",
		wanted_all = "%CR jest poszukiwany przez %C za: %R!",

		unwanted = "Nie poszukiwany",
		unwanted_cop = "Wycofałeś poszukiwania %C.",
		unwanted_criminal = "Nie jesteś już poszukiwany.",
		unwanted_all = "%C nie jest już poszukiwany.",

		warranted = "Warranted",
		warranted_cop = "Masz pozwolenie na przeszukanie mieszkania %C.",
		warranted_criminal = "Dostałeś warrant przez %C za %R.",

		unwarranted = "Unwarranted",
		unwarranted_cop = "Usunąłeś warrant %C.",
		unwarranted_criminal = "Twój warrant został przeterminowany.",
		unwarranted_all = "%C usunął warrant %S.",

		arrested = "Aresztowany",
		arrested_cop = "Aresztowałeś %C na %T.",
		arrested_criminal = "Zostałeś aresztowany %C na %T.",

		unarrested = "Nie aresztowany",
		unarrested_cop = "Wyciągnąłeś z więzienia %C.",
		unarrested_criminal = "Nie jesteś już aresztowany przez %C.",

		// Battery Alerts
		charger_connected = "Ładowarka podłączona",
		charging_started = "Twój komputer ładuje się.",

		charger_disconnected = "Ładowarka odłączona",
		charging_aborted = "Twój komputer już się nie ładuje.",

		battery_status = "Stan baterii",
		battery_info = "Zostało Ci %B% baterii. Podłącz ładowarkę, by móc grać dalej.",


		--[[------------------------------
			Doors
		--------------------------------]]

		for_sale = "Na sprzedaż",
		purchase_door = "Wciśnij F2 aby kupić drzwi",

		sell_door = "Sprzedaj drzwi",
		buy_door = "Kup drzwi",

		sell_vehicle = "Sprzedaj pojazd",
		buy_vehicle = "Kup pojazd",
		add_owner = "Dodaj właściciela",
		remove_owner = "Usuń właściciela",

		allow_ownership = "Nadaj dostęp",
		disallow_ownership = "Zabierz dostęp",

		set_door_title = "Ustaw tytuł drzwi",
		set_vehicle_title = "Ustaw tytuł pojazdu",

		edit_groups = "Edytuj dostęp grup",

		group_door = "Drzwi grupowe",
		group_door_access = "Dostęp: %G",

		team_door = "Drzwi prac",
		team_door_access = "Dostep: %J prac",

		owner_unknown = "Właściciel: Nieznany",

		door_coowners = "Współwłaściciele: ",
		allowed_coowners = "Dopuszczeni współwłaściciele: ",

		// DoorSkin and LockPeek support
		upgrade_lock = "Ulepsz zamek",
		edit_door_appearance = "Edytuj wygląd drzwi",


		--[[------------------------------
			Vehicle Info
		--------------------------------]]

		vehicle = "Pojazd",

		owner = "Właściciel",
		co_owners = "Współwłasciciele: ",
		allowed_co_owners = "Dopuszczeni współwłaściciele: ",
		owner_unknown = "Nieznany",

		vehicle_unowned = "Nieposiadany",
		vehicle_not_ownable = "Nie może być zakupiony",
		vehicle_access_group = "Dostep: %G",
		vehicle_access_jobs = "Dostep: %J prac",


		--[[------------------------------
			Gestures
		--------------------------------]]

		gesture_bow = "Klęknij",
		gesture_sexydance = "Seksowny taniec",
		gesture_follow_me = "Chodź za mną",
		gesture_laugh = "Śmiech",
		gesture_lion_pose = "Poza lwa",
		gesture_nonverbal_no = "Niewerbalne nie",
		gesture_thumbs_up = "Kciuk w góre",
		gesture_wave = "Machanie",
		gesture_dance = "Taniec",
	

		--[[------------------------------
			Other
		--------------------------------]]

		laws = "Prawa",

		--[[------------------------------
			Crash Screen
		--------------------------------]]

		connection_lost = "Utracono połączenie",
		lost_connection = "Wygląda na to, że straciłeś połączenie z serwerem.",
		reconnected = "Jeśli połączenie nie wróci, wciśnij przycisk 'połącz ponownie' aby wrócić na serwer.",
	},



	RayBoard = {

		--[[------------------------------
			Main
		--------------------------------]]

		score = "Punkty",
		deaths = "Śmierci",
		karma = "Karma",

		sort = "Sortuj",

		id_changer = "Zmiana tożsamości",

		incognito_mode = "Tryb Incognito",
		change_id = "Zmień tożsamość",
		hide_yourself = "Ukryj się",
		unhide_yourself = "Odkryj się",
		
		fake_nickname = "Ustaw fałszywy nick",
		fake_usergroup = "Ustaw fałszywą grupę",
		fake_avatar = "Zmień swój avatar - wklej URL do jpg lub png (lub zostaw puste by użyć twojego avataru)",
		save_fakeid = "Zapisz FakeID",
		reset_fakeid = "Zresetuj swoje ID",
	},



	RayHUDTTT = {

		air_level = "Poziom tlenu",
		dmglogs_settings = "Ustawienia DmgLogs",

		binds = "Bindy",
		quickcommands_list = "Lista szybkich komend.",
		shortcut_to_all = "Skrót do wszystkich szybkich komend.",
		open_dmglogs = "Otwórz ustawienia DmgLogs.",
		recently_weapon = "Ostatnio trzymana broń",
		enable_disguiser = "Włącz/Wyłącz Disguiser",
		disguiser_tooltip = "Musisz posiadać disguiser by tego użyć.",

		enable_fps = "Włącz licznik FPS",
		enable_multicore = "Włącz renderowanie wielordzeniowe",
		enable_hardware_acc = "Włącz akcelerację sprzętową",
		disable_shadows = "Wyłacz cienie",
		disable_skybox = "Wyłacz skybox",
		disable_sprays = "Wyłącz spraye",	
		disable_gibs = "Wyłącz 'gibs'",
		disable_gibs_help = "są to cząstki i przedmioty, które mogą odlatywać ze zwłok i ragdolli.",

		you_died = "Zginąłeś!",

	}
}