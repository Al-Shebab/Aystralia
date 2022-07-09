RayUI.Lang.russian = {

	RayUI = {
		--[[------------------------------
			Setings Panel
		--------------------------------]]

		// Main, RayUI
		rayui_settings = "RayUI настройки",

		config_access = "Группы с доступом к панели конфигурации",
		ui_scale = "UI масштаб",
		ui_rounding = "UI округление",
		ui_opacity = "UI непрозрачность",
		blur_mode = "Включить размытие",
		job_color = "Используйте цвет работы для шапки интерфейса",
		custom_color = "Пользовательский цвет заголовка",
		language = "Язык",

		save_settings = "Сохранить настройки",
		reset_default = "Сбросить все настройки",

		// RayHUD Settings
		offset_x = "Смещение X",
		offset_y = "Смещение Y",
		mini_mode = "Мини-режим",
		vehicle_hud = "Включить HUD авто (VCMod / Simfphys)",
		vehicle_info = "Включить информацию о Т/С, когда смотрите на него",
		door_hud = "Показать HUD на дверях",
		door_menu = "Переопределение меню дверей по умолчанию",
		crash_menu = "Включить аварийный экран",
		hide_menu = "Скрыть HUD с открытым меню spawn",
		disable_killfeed = "Отключить killfeed",
		battery_alert = "Включить оповещение о батарее",
		overhead_ui = "UI над игроком",
		laws_panel = "Панель законов",
		wanted_list = "Список разыскиваемых",
		level_panel = "Панель уровня",
		level_system = "Система уровней",

		// RayBoard Settings
		rayboard_width = "Ширина табло",
		rayboard_height = "Высота табло",
		rayboard_hide_hud = "Hide HUD when opening scoreboard",
		rayboard_title = "Заголовок шапки (оставьте пустым, чтобы использовать имя сервера)",
		rayboard_mode = "Режим табло",
		rayboard_can_hide = "Группы, которые могут скрываться на табло",
		rayboard_can_use_incognito = "Группы, которые могут использовать режим инкогнито",
		rayboard_can_see_incognito = "Группы, которые могут видеть, кто использует инкогнито",

	},



	HUD = {

		--[[------------------------------
			Main Panel
		--------------------------------]]

		health = "HP",
		armor = "Броня",
		hunger = "Голод",


		--[[------------------------------
			Lower Right
		--------------------------------]]

		props = "Пропы",
		ammo = "Патрон",

		// VCMod / Simfphys
		engine = "Двигатель",
		fuel = "Топливо",
		your_car = "Ваше авто",


		--[[------------------------------
			Events
		--------------------------------]]

		lockdown = "Комендантский час",
		lockdown_init = "Мэр инициировал ком. час. Возвращайтесь домой.",

		wanted = "Розыск",
		wanted_cop = "Розыск %C за %R.",
		wanted_criminal = "Вы в розыске %C за: %R!",
		wanted_all = "%CR в розыске %C за: %R!",

		unwanted = "Unwanted",
		unwanted_cop = "Вы убрали розыск с %C's.",
		unwanted_criminal = "Вы больше не разыскиваетесь полицией.",
		unwanted_all = "%C больше не разыскивается полицией.",

		warranted = "Ордер",
		warranted_cop = "Теперь Вам разрешено обыскивать %C's.",
		warranted_criminal = "Вы получили ордер от %C на %R.",

		unwarranted = "Unwarranted",
		unwarranted_cop = "Вы удалили ордер с %C's.",
		unwarranted_criminal = "Срок действия вашего ордера истек.",
		unwarranted_all = "%C удалил ордер %S's.",

		arrested = "Арест",
		arrested_cop = "Вы арестовали %C за %T.",
		arrested_criminal = "Вы арестованы %C за %T.",

		unarrested = "Свобода",
		unarrested_cop = "Вы освободили %C.",
		unarrested_criminal = "Вы освобождены %C.",

		// Battery Alerts
		charger_connected = "Зарядка подключена",
		charging_started = "Теперь ваш компьютер заряжается.",

		charger_disconnected = "Зарядка отключена",
		charging_aborted = "Ваш компьютер больше не заряжается.",

		battery_status = "Состояние батареи",
		battery_info = "Сейчас у Вас %B% заряда батареи. Подключите зарядное устройство, чтобы продолжить игру.",


		--[[------------------------------
			Doors
		--------------------------------]]

		for_sale = "Продаётся",
		purchase_door = "F2, чтобы купить",

		sell_door = "Продать дверь",
		buy_door = "Купить дверь",

		sell_vehicle = "Продать авто",
		buy_vehicle = "Купить авто",
		add_owner = "Добавить владельца",
		remove_owner = "Удалить владельца",

		allow_ownership = "Разрешить владение",
		disallow_ownership = "Запретить владение",

		set_door_title = "Установить название двери",
		set_vehicle_title = "Установить название авто",

		edit_groups = "Править доступ групп",

		group_door = "Групповая дверь",
		group_door_access = "Доступ: %G",

		team_door = "Командная дверь",
		team_door_access = "Доступ: %J job(s)",

		owner_unknown = "Владелец: Неизвестен",

		door_coowners = "Совладельцы:",
		allowed_coowners = "Разрешенные Совладельцы:",


		--[[------------------------------
			Vehicle Info
		--------------------------------]]

		vehicle = "Т/С",

		owner = "Владелец",
		co_owners = "Совладелец: ",
		allowed_co_owners = "Доступные совладельцы: ",
		owner_unknown = "Неизвестно",

		vehicle_unowned = "Нет владельца",
		vehicle_not_ownable = "Нет собственника",
		vehicle_access_group = "Доступ: %G",
		vehicle_access_jobs = "Доступ: %J работа(ы)",


		--[[------------------------------
			Gestures
		--------------------------------]]

		gesture_bow = "Лук",
		gesture_sexydance = "Сексуальный танец",
		gesture_follow_me = "Следуй за мной",
		gesture_laugh = "Смеяться",
		gesture_lion_pose = "Поза льва",
		gesture_nonverbal_no = "Невербальное нет",
		gesture_thumbs_up = "Пальцы вверх",
		gesture_wave = "Волна",
		gesture_dance = "Танец",
		

		--[[------------------------------
			Other
		--------------------------------]]

		laws = "Законы",

		--[[------------------------------
			Crash Screen
		--------------------------------]]

		connection_lost = "Соединение потеряно",
		lost_connection = "Похоже, Вы потеряли соединение с сервером.",
		reconnected = "Если сервер не восстанавливается, просто нажмите кнопку 'Повторно подключиться', чтобы снова подключиться к серверу.",
	},



	RayBoard = {

		--[[------------------------------
			Main
		--------------------------------]]

		score = "Очки",
		deaths = "смерть",
		karma = "Карма",

		sort = "Сортировать",

		id_changer = "Изменение личности",

		incognito_mode = "Режим инкогнито",
		change_id = "Изменение личности",
		hide_yourself = "Скрыть себя",
		unhide_yourself = "Раскрыть себя",
		
		fake_nickname = "Установите свой поддельный ник",
		fake_usergroup = "Установите свою поддельную группу",
		fake_avatar = "Измените свой аватар - Вставьте URL-адрес в изображение jpg или png (или оставьте пустым, чтобы использовать свой аватар)",
		save_fakeid = "Сохранить FakeID",
		reset_fakeid = "Сбросить ID",
	}
}