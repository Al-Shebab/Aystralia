RayUI.Lang.french = {

	RayUI = {
		--[[------------------------------
			Setings Panel
		--------------------------------]]

		// Main, RayUI
		rayui_settings = "RayUI Paramètres",

		config_access = "Groupes avec accès au panneau de configuration",
		ui_scale = "UI Scale",
		ui_rounding = "UI Arrondi",
		ui_opacity = "UI Opacité",
		blur_mode = "Activé le Mode Blur",
		job_color = "Utiliser la couleur du job pour l'en-tête UI",
		custom_color = "Couleur d'en-tête personnalisée",
		language = "Langue",

		save_settings = "Enregistrer les paramètres",
		reset_default = "Réinitialiser tous les réglages",

		// RayHUD Settings
		offset_x = "Décalage en X",
		offset_y = "Décalage en Y",
		mini_mode = "Mode Mini",
		vehicle_hud = "Activer le HUD du véhicule (VCMod / Simfphys)",
		vehicle_info = "Activer les informations sur le véhicule lorsque vous le regardez",
		door_hud = "Afficher le HUD sur les portes",
		door_menu = "Remplacer le menu des portes par défaut",
		crash_menu = "Activer l'écran de crash",
		hide_menu = "Masquer le HUD avec le menu des props ouvert",
		disable_killfeed = "Désactiver le killfeed",
		battery_alert = "Activer l'alerte de batterie",
		overhead_ui = "Au dessus des têtes UI",
		laws_panel = "Panel des Lois",
		wanted_list = "Liste des Recherchés",
		level_panel = "Panneau de Niveau",
		level_system = "Système de Niveau",

		// RayBoard Settings
		rayboard_width = "Largeur du scoreboard",
		rayboard_height = "Hauteur du scoreboard",
		rayboard_hide_hud = "Hide HUD when opening scoreboard",
		rayboard_title = "Titre de l'en-tête (laissez vide pour utiliser le nom du serveur)",
		rayboard_mode = "Scoreboard mode",
		rayboard_can_hide = "Groupes qui peuvent se cacher sur le scoreboard",
		rayboard_can_use_incognito = "Groupes pouvant utiliser le mode Incognito",
		rayboard_can_see_incognito = "Groupes qui peuvent voir, qui utilise le mode Incognito",

	},



	HUD = {

		--[[------------------------------
			Main Panel
		--------------------------------]]

		health = "Vie",
		armor = "Armure",
		hunger = "Faim",


		--[[------------------------------
			Lower Right
		--------------------------------]]

		props = "Props",
		ammo = "Munitions",

		// VCMod / Simfphys
		engine = "Moteur",
		fuel = "Carburant",
		your_car = "Votre voiture",


		--[[------------------------------
			Events
		--------------------------------]]

		lockdown = "Couvre-Feu",
		lockdown_init = "Le maire a lancé un Couvre-Feu. Retournez chez vous.",

		wanted = "Recherché",
		wanted_cop = "Vous avez rendu %C recherché pour %R.",
		wanted_criminal = "Vous êtes recherché par %C pour: %R!",
		wanted_all = "%CR est recherché par %C pour: %R!",

		unwanted = "Plus Recherché",
		unwanted_cop = "Vous avez supprimé le statut de recherche de %C.",
		unwanted_criminal = "Vous n'êtes plus recherché par la police.",
		unwanted_all = "%C n'est plus recherché par la police.",

		warranted = "Ajout du Mandat",
		warranted_cop = "Vous êtes maintenant autorisé à rechercher dans les bâtiments de %C.",
		warranted_criminal = "Vous avez reçu un mandat de %C pour %R.",

		unwarranted = "Retrait du Mandat",
		unwarranted_cop = "Vous avez supprimé le mandat de %C.",
		unwarranted_criminal = "Votre mandat a expiré.",
		unwarranted_all = "%C a retiré le mandat de %S.",

		arrested = "Arrêté",
		arrested_cop = "Vous avez arrêté %C pour %T.",
		arrested_criminal = "Vous avez été arrêté par %C pour %T.",

		unarrested = "Libéré",
		unarrested_cop = "Vous avez libéré %C.",
		unarrested_criminal = "Vous avez été libéré par %C.",

		// Battery Alerts
		charger_connected = "Chargeur connecté",
		charging_started = "Votre ordinateur est en cours de chargement.",

		charger_disconnected = "Chargeur déconnecté",
		charging_aborted = "Votre ordinateur ne se recharge plus.",

		battery_status = "État de la batterie",
		battery_info = "Il vous reste actuellement %B% de batterie. Connectez le chargeur pour continuer à jouer.",


		--[[------------------------------
			Doors
		--------------------------------]]

		for_sale = "À vendre",
		purchase_door = "Appuyez sur F2 pour acheter la porte",

		sell_door = "Vendre la porte",
		buy_door = "Acheter la porte",

		sell_vehicle = "Vendre le Véhicule",
		buy_vehicle = "Acheter le véhicule",
		add_owner = "Ajouter un propriétaire",
		remove_owner = "Supprimer le propriétaire",

		allow_ownership = "Autoriser la propriété",
		disallow_ownership = "Interdire la propriété",

		set_door_title = "Définir le titre de la porte",
		set_vehicle_title = "Définir le titre du véhicule",

		edit_groups = "Modifier l'accès au groupe",

		group_door = "Porte de Groupe",
		group_door_access = "Accès: %G",

		team_door = "Porte d'Équipe",
		team_door_access = "Accès: %J job(s)",

		owner_unknown = "Propriétaire: Inconnu",

		door_coowners = "Copropriétaires:",
		allowed_coowners = "Copropriétaires autorisés:",


		--[[------------------------------
			Vehicle Info
		--------------------------------]]

		vehicle = "Vehicule",

		owner = "Propriétaire",
		co_owners = "Copropriétaires: ",
		allowed_co_owners = "Copropriétaires autorisés: ",
		owner_unknown = "Inconnu",

		vehicle_unowned = "Sans propriétaire",
		vehicle_not_ownable = "Non possédable",
		vehicle_access_group = "Accès: %G",
		vehicle_access_jobs = "Accès: %J job(s)",


		--[[------------------------------
			Gestures
		--------------------------------]]

		gesture_bow = "Arc",
		gesture_sexydance = "Danse sexy",
		gesture_follow_me = "Suivez-moi",
		gesture_laugh = "Rire",
		gesture_lion_pose = "Pose du Lion",
		gesture_nonverbal_no = "Non-verbal non",
		gesture_thumbs_up = "Pouces vers le haut",
		gesture_wave = "Vague",
		gesture_dance = "Danse",
		

		--[[------------------------------
			Other
		--------------------------------]]

		laws = "Lois",

		--[[------------------------------
			Crash Screen
		--------------------------------]]

		connection_lost = "Connexion perdue",
		lost_connection = "Il semble que vous ayez perdu la connexion au serveur.",
		reconnected = "Si le serveur ne revient pas, appuyez simplement sur le bouton 'Reconnecter' pour vous reconnecter au serveur.",
	},



	RayBoard = {

		--[[------------------------------
			Main
		--------------------------------]]

		score = "Score",
		deaths = "Deaths",
		karma = "Karma",

		sort = "Sort",

		id_changer = "Changeur d'identité",

		incognito_mode = "Mode Incognito",
		change_id = "Changer d'Identité",
		hide_yourself = "Vous cacher",
		unhide_yourself = "Ne plus vous cacher",
		
		fake_nickname = "Définissez votre faux surnom",
		fake_usergroup = "Définissez votre faux groupe d'utilisateurs",
		fake_avatar = "Changez votre avatar - Collez l'URL en image jpg ou png (ou laissez vide pour utiliser votre avatar)",
		save_fakeid = "Enregistrer FakeID",
		reset_fakeid = "Réinitialiser l'ID",
	}
}