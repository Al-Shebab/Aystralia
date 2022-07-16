---------------------
/// ALL LANGUAGES ///
---------------------
-- Selecting the language in the file: emenu/lua/emenu/config/econfig.lua

--case sensitive!
emenu.langs = {
	---------------
	/// ENGLISH ///
	---------------
	["english"] = {
		// Main
		["greet"] = "Welcome back, %s", -- %s = nickname

		// Windows
		["win_title"] = "Window",
		["loading"] = "Loading",
		["actions"]  = "Actions",
		["minimize"] = "Hide",
		["maximize"] = "Show",
		["open"] = "Open",
		["close"] = "Close",
		["pin"] = "Pin",
		["unpin"] = "Unpin",
		["browser"] = "Browser",

		// Other
		["favorite"] = "Favorite",
		["confirm"] = "Confirm",
		["cancel"] = "Cancel",
		["sure_phrase"] = "You are sure?",
		["cantafford"] = "You don't have enough money",
		["weapons"] = "Weapons",
		["search"] = "Search",
		["disconnected"] = "Disconnected",
		["number"] = "number",
		["on_effect"] = "On effects",
		["off_effect"] = "Off effects",

		// Jobs Tab
		["jobs"] = "Jobs",
		["job"]  = "job",
		["jobs_phrase"] = "Choose your profession",
		["salary"] = "Salary",
		["recent"] = "Recent",
		["unfavorite"] = "Unfavorite",
		["become"] = "Become",
		["tags"]   = "Tags",
		["level"]  = "Level",
		["admin"]  = "Admin",
		["unknown"] = "Unknown",
		["description"] = "Description",
		["need_vote"] = "Vote",
		["err_norights"] = "Not enough rights",
		["err_noslots"] = "Maximum players",
		["err_already"] = "You are already playing this profession",


		// Shop Tab
		["shop"] = "Shop",
		["shop_phrase"] = "Buy whatever you want :)",
		["buy"] = "Buy",
		["max"] = "Max",
		["ents"] = "Entities",
		["shipments"] = "Shipments",
		["ammo"] = "Ammo",
		["food"] = "Food",

		// Quick Actions
		--tabs
		["general_tab"] = "General",
		["money_tab"] = "Money",
		["police_tab"] = "Police",
		["mayor_tab"] = "Mayor",

		["amount"] = "Amount",
		["sell_doors"] = "Sell all doors",
		["drop_money"] = "Drop money",
		["give_money"] = "Give money",
		["request_license"] = "Request license",
		["drop_weapon"] = "Drop weapon",
		["change_job_title"] = "Change job title",
		["change_name"] = "Change nickname",
		--police
		["wanted"] = "Wanted",
		["un_wanted"] = "Remove wanted",
		["warrant"] = "Warrant",
		--mayor
		["lockdown"] = "Start lockdown",
		["un_lockdown"] = "Stop lockdown",
		["give_license"] = "Give license",
		["add_law"] = "Add law",
		["remove_law"] = "Remove law",
		["place_laws"] = "Place laws",
		["broadcast"] = "Broadcast",
		["start_lottery"] = "Start lottery",

		["select_player"] = "Select player",
		["enter_reason"] = "Enter the reason",
		["err_cant_do"] = "You can't do it with this person",
	},


	---------------
	/// RUSSIAN ///
	---------------
	["russian"] = {
		// Main
		["greet"] = "Привет, %s", -- %s = nickname

		// Windows
		["win_title"] = "Окно",
		["loading"] = "Загрузка",
		["actions"]  = "Действия",
		["minimize"] = "Скрыть",
		["maximize"] = "Показать",
		["open"] = "Открыть",
		["close"] = "Закрыть",
		["pin"] = "Закрепить",
		["unpin"] = "Открепить",
		["browser"] = "Браузер",

		// Other
		["favorite"] = "Избранное",
		["confirm"] = "Подтвердить",
		["cancel"] = "Отменить",
		["sure_phrase"] = "Вы уверены?",
		["cantafford"] = "У вас недостаточно денег",
		["weapons"] = "Оружие",
		["search"] = "Поиск",
		["disconnected"] = "Вышел",
		["number"] = "число",
		["on_effect"] = "Включить эффекты",
		["off_effect"] = "Выключить эффекты",

		// Jobs Tab
		["jobs"] = "Работы",
		["job"]  = "работа",
		["jobs_phrase"] = "Выберите вашу профессию.",
		["salary"] = "Зарплата",
		["recent"] = "Недавнее",
		["unfavorite"] = "Убрать из избранных",
		["become"] = "Стать",
		["tags"]   = "Тэги",
		["level"]  = "Уровень",
		["admin"]  = "Админ",
		["unknown"] = "Неизвестно",
		["description"] = "Описание",
		["need_vote"] = "Голосование",
		["err_norights"] = "Не хватает прав",
		["err_noslots"] = "Максимально игроков",
		["err_already"] = "Вы уже играете за эту профессию",

		// Shop Tab
		["shop"] = "Магазин",
		["shop_phrase"] = "Купите что вам нужно",
		["buy"] = "Купить",
		["max"] = "Максимум",
		["ents"] = "Энтити",
		["shipments"] = "Коробки",
		["ammo"] = "Патроны",
		["food"] = "Еда",

		// Quick Actions
		--tabs
		["general_tab"] = "Основное",
		["money_tab"] = "Деньги",
		["police_tab"] = "Полиция",
		["mayor_tab"] = "Мэр",

		["amount"] = "Число",
		["sell_doors"] = "Продать все двери",
		["drop_money"] = "Выбросить деньги",
		["give_money"] = "Дать деньги",
		["request_license"] = "Запросить лицензию",
		["drop_weapon"] = "Выбросить оружие",
		["change_job_title"] = "Изменить имя профессии",
		["change_name"] = "Изменить имя",
		--police
		["wanted"] = "Розыск",
		["un_wanted"] = "Убрать розыск",
		["warrant"] = "Ордер",
		--mayor
		["lockdown"] = "Начать ком-час",
		["un_lockdown"] = "Остановить ком-час",
		["give_license"] = "Выдать лицензию",
		["add_law"] = "Добавить правило",
		["remove_law"] = "Удалить правило",
		["place_laws"] = "Поставить доску с правилами",
		["broadcast"] = "Обьявление",
		["start_lottery"] = "Запустить лотерею",

		["select_player"] = "Выберите игрока",
		["enter_reason"] = "Напишите причину",
		["err_cant_do"] = "Вы не можете этого сделать с этим человеком",
	},


	--------------
	/// FRENCH ///
	--------------
	["french"] = {
		// Main
		["greet"] = "Bienvenue à nouveau, %s", -- %s = nickname
	 
		// Windows
		["win_title"] = "Fenêtres",
		["loading"] = "Chargement",
		["actions"]  = "Actions",
		["minimize"] = "Cacher",
		["maximize"] = "Afficher",
		["open"] = "Ouvrir",
		["close"] = "Fermer",
		["pin"] = "Epingle",
		["unpin"] = "Décrocher",
		["browser"] = "Navigateur",
	 
		// Other
		["favorite"] = "Favoris",
		["confirm"] = "Confirmer",
		["cancel"] = "Annuler",
		["sure_phrase"] = "Vous êtes sûr ?",
		["cantafford"] = "Vous n'avez pas assez d'argent",
		["weapons"] = "Armes",
		["search"] = "Rechercher",
		["disconnected"] = "Déconnecté",
		["number"] = "numéro",
		["on_effect"] = "Effets Activés",
		["off_effect"] = "Effets Désactivés",
	 
		// Jobs Tab
		["jobs"] = "Metiers",
		["job"]  = "Metier",
		["jobs_phrase"] = "Choisissez votre profession",
		["salary"] = "Salaire",
		["recent"] = "Récent",
		["unfavorite"] = "Défavoriser",
		["become"] = "Devenir",
		["tags"]   = "Mots clés",
		["level"]  = "Niveau",
		["admin"]  = "Admin",
		["unknown"] = "Inconnu",
		["description"] = "Description",
		["need_vote"] = "Vote",
		["err_norights"] = "Pas assez de droits",
		["err_noslots"] = "Nombre maximal de joueurs",
		["err_already"] = "Vous jouez déjà cette profession",
	 
		// Shop Tab
		["shop"] = "Boutique",
		["shop_phrase"] = "Achetez ce que vous voulez :)",
		["buy"] = "Acheter",
		["max"] = "Maximum",
		["ents"] = "Entités",
		["shipments"] = "Expéditions",
		["ammo"] = "Munitions",
		["food"] = "Nourriture",
	 
		// Quick Actions
		--tabs
		["general_tab"] = "Général",
		["money_tab"] = "Argent",
		["police_tab"] = "Police",
		["mayor_tab"] = "Maire",
	 
		["amount"] = "Montant",
		["sell_doors"] = "Vendre toutes les portes",
		["drop_money"] = "Laissez tomber l'argent",
		["give_money"] = "Donner de l'argent",
		["request_license"] = "Demander une licence",
		["drop_weapon"] = "Lâchez l'arme",
		["change_job_title"] = "Changer le du métier",
		["change_name"] = "Changer de nom",
		--police
		["wanted"] = "Recherché",
		["un_wanted"] = "Suppression de la recherche",
		["warrant"] = "Mandat",
		--mayor
		["lockdown"] = "Début du couvre feu",
		["un_lockdown"] = "Arrêter le couvre feu",
		["give_license"] = "Donner une licence",
		["add_law"] = "Ajouter une loi",
		["remove_law"] = "Supprimer la loi",
		["place_laws"] = "Placer tableau des lois",
		["broadcast"] = "Diffusion",
		["start_lottery"] = "Lancement de la loterie",
	 
		["select_player"] = "Sélectionnez un joueur",
		["enter_reason"] = "Entrez la raison",
		["err_cant_do"] = "Tu ne peux pas le faire avec cette personne",
	},


	--------------
	/// GERMAN ///
	--------------
	["german"] = {
		// Main
		["greet"] = "Willkommen zurück, %s", -- %s = nickname

		// Windows
		["win_title"] = "Fenster",
		["loading"] = "Lädt",
		["actions"]  = "Aktionen",
		["minimize"] = "Vertsecken",
		["maximize"] = "Zeigen",
		["open"] = "Öffnen",
		["close"] = "Schließen",
		["pin"] = "Anpinnen",
		["unpin"] = "Lösen",
		["browser"] = "Browser",

		// Other
		["favorite"] = "Favorit",
		["confirm"] = "Bestätigen",
		["cancel"] = "Abbrechen",
		["sure_phrase"] = "Bist du dir sicher?",
		["cantafford"] = "Du hast nicht genug Geld",
		["weapons"] = "Waffen",
		["search"] = "Suchen",
		["disconnected"] = "Disconnected",
		["number"] = "zahl",
		["on_effect"] = "On effects",
		["off_effect"] = "Off effects",

		// Jobs Tab
		["jobs"] = "Berufe",
		["job"]  = "beruf",
		["jobs_phrase"] = "Wähle deinen Beruf",
		["salary"] = "Gehalt",
		["recent"] = "Jüngste",
		["unfavorite"] = "Entfavorisieren",
		["become"] = "Werden",
		["tags"]   = "Stichworte",
		["level"]  = "Level",
		["admin"]  = "Admin",
		["unknown"] = "Unbekannt",
		["description"] = "Beschreibunt",
		["need_vote"] = "Abstimmung",
		["err_norights"] = "Nicht genug Rechte",
		["err_noslots"] = "Maximale Anzahl an Spielern",
		["err_already"] = "Du spielst bereits den Beruf",

		// Shop Tab
		["shop"] = "Shop",
		["shop_phrase"] = "Kaufe was du möchtest :)",
		["buy"] = "Kaufen",
		["max"] = "Max",
		["ents"] = "Entities",
		["shipments"] = "Shipments",
		["ammo"] = "Munition",
		["food"] = "Essen",

		// Quick Actions
		--tabs
		["general_tab"] = "Generell",
		["money_tab"] = "Geld",
		["police_tab"] = "Polizei",
		["mayor_tab"] = "Bürgermeister",

		["amount"] = "Anzahl",
		["sell_doors"] = "Verkaufe alle Türen",
		["drop_money"] = "Geld fallen lassen",
		["give_money"] = "Geld geben",
		["request_license"] = "Lizenz anfragen",
		["drop_weapon"] = "Waffe fallen lassen",
		["change_job_title"] = "Jobnamen ändern",
		["change_name"] = "Namen ändern",
		--police
		["wanted"] = "Gesucht",
		["un_wanted"] = "Gesucht-Status entfernen",
		["warrant"] = "Durchsuchungsbefehl",
		--mayor
		["lockdown"] = "Ausgangssperre veranlassen",
		["un_lockdown"] = "Ausgangssperre beednen",
		["give_license"] = "Lizenz geben",
		["add_law"] = "Gesetz hinzufügen",
		["remove_law"] = "Gesetz entfernen",
		["place_laws"] = "Gesetzestafel plazieren",
		["broadcast"] = "Broadcast",
		["start_lottery"] = "Lotterie starten",

		["select_player"] = "Spieler auswählen",
		["enter_reason"] = "Grund eingeben",
		["err_cant_do"] = "Das kannst du nicht mit dieser Person machen",
	},

	["turkish"] = {
		// Main
		["greet"] = "Tekrardan hoş geldiniz, %s", -- %s = nickname

		// Windows
		["win_title"] = "Pencere",
		["loading"] = "Yükleniyor",
		["actions"] = "Eylemler",
		["minimize"] = "Gizle",
		["maximize"] = "Göster",
		["open"] = "Aç",
		["close"] = "Kapat",
		["pin"] = "Sabitle",
		["unpin"] = "Sabitlemeyi kaldır",
		["browser"] = "Tarayıcı",

		// Other
		["favorite"] = "Favori",
		["confirm"] = "Onayla",
		["cancel"] = "İptal",
		["sure_phrase"] = "Emin misiniz?",
		["cantafford"] = "Yeterli Paranız yok",
		["weapons"] = "Silahlar",
		["search"] = "Ara",
		["disconnected"] = "Bağlantı kesildi",
		["number"] = "sayı",
		["on_effect"] = "Efektler açık",
		["off_effect"] = "Efektler kapalı",

		// Jobs Tab
		["jobs"] = "Meslekler",
		["job"] = "Meslek",
		["jobs_phrase"] = "Mesleğini seç",
		["salary"] = "Maaş",
		["recent"] = "Son",
		["unfavorite"] = "Favori olmayan",
		["become"] = "Ol",
		["tags"]  = "Etiketler",
		["level"] = "Seviye",
		["admin"] = "Yetkili",
		["unknown"] = "Bilinmeyen",
		["description"] = "Açıklama",
		["need_vote"] = "Oy",
		["err_norights"] = "Yetkiniz yok",
		["err_noslots"] = "Maksimum Oyuncu",
		["err_already"] = "Zaten bu meslektesiniz",

		// Shop Tab
		["shop"] = "Market",
		["shop_phrase"] = "Ne istersen alabilirsin :)",
		["buy"] = "Satın al",
		["max"] = "Maks.",
		["ents"] = "Varlıklar",
		["shipments"] = "Gönderiler",
		["ammo"] = "Cephanelik",
		["food"] = "Yemek",

		// Quick Actions
		--tabs
		["general_tab"] = "Genel",
		["money_tab"] = "Ekonomi",
		["police_tab"] = "Polis",
		["mayor_tab"] = "Belediye",

		["amount"] = "Miktar",
		["sell_doors"] = "Tüm Kapıları sat",
		["drop_money"] = "Yere para bırak",
		["give_money"] = "Para ver",
		["request_license"] = "Lisans isteğinde bulun",
		["drop_weapon"] = "Silahını bırak",
		["change_job_title"] = "Mesleğin İsmini değiştir",
		["change_name"] = "İsmini değiştir",

		--police
		["wanted"] = "Aranıyor",
		["un_wanted"] = "Arama Kararını kaldır",
		["warrant"] = "Arama Kararı çıkart",

		--mayor
		["lockdown"] = "Sokağa çıkma yasağı başlat",
		["un_lockdown"] = "Sokağa çıkma yasağını bitir",
		["give_license"] = "Give license",
		["add_law"] = "Yasa ekle",
		["remove_law"] = "Yasa sil",
		["place_laws"] = "Yasalar",
		["broadcast"] = "Yayınla",
		["start_lottery"] = "Piyangoyu başlat",

		["select_player"] = "Oyuncuyu seç",
		["enter_reason"] = "Sebepini gir",
		["err_cant_do"] = "Bu oyuncuyla yapamazsın",
	},

	["polish"] = {
        // Main
        ["greet"] = "Witamy ponownie, %s", -- %s = nickname

        // Windows
        ["win_title"] = "Okno",
        ["loading"] = "Ładowanie",
        ["actions"]  = "Akcje",
        ["minimize"] = "Ukryj",
        ["maximize"] = "Pokaż",
        ["open"] = "Otwórz",
        ["close"] = "Zamknij",
        ["pin"] = "Pin",
        ["unpin"] = "Unpin",
        ["browser"] = "Przeglądarka",

        // Other
        ["favorite"] = "Ulubione",
        ["confirm"] = "Potwierdź",
        ["cancel"] = "Anuluj",
        ["sure_phrase"] = "Jesteś pewien?",
        ["cantafford"] = "Nie masz wystarczająco dużo pieniędzy",
        ["weapons"] = "Bronie",
        ["search"] = "Szukaj",
        ["disconnected"] = "Disconnected",
        ["number"] = "numer",
        ["on_effect"] = "Włączone efekty",
        ["off_effect"] = "Wyłączone efekty",

        // Jobs Tab
        ["jobs"] = "Prace",
        ["job"]  = "Praca",
        ["jobs_phrase"] = "Wybierz swoją pracę",
        ["salary"] = "Wypłata",
        ["recent"] = "Ostatnie",
        ["unfavorite"] = "Usuń z ulubionych",
        ["become"] = "Zostań",
        ["tags"]   = "Tagi",
        ["level"]  = "Level",
        ["admin"]  = "Admin",
        ["unknown"] = "Nieznany",
        ["description"] = "Opis",
        ["need_vote"] = "Głosowanie",
        ["err_norights"] = "Za mało praw",
        ["err_noslots"] = "Maksymalna liczba graczy",
        ["err_already"] = "Jesteś już w tej pracy",


        // Shop Tab
        ["shop"] = "Sklep",
        ["shop_phrase"] = "Kup co chcesz :)",
        ["buy"] = "Kup",
        ["max"] = "Max",
        ["ents"] = "Entities",
        ["shipments"] = "Shipments",
        ["ammo"] = "Ammo",
        ["food"] = "Jedzenie",

        // Quick Actions
        --tabs
        ["general_tab"] = "Generalne",
        ["money_tab"] = "Pieniądze",
        ["police_tab"] = "Policja",
        ["mayor_tab"] = "Burmistrz",

        ["amount"] = "Ilość",
        ["sell_doors"] = "Sprzedaj wszystkie drzwi",
        ["drop_money"] = "Drop money",
        ["give_money"] = "Upuść pieniądze",
        ["request_license"] = "Poproś o licencję",
        ["drop_weapon"] = "Rzuć broń",
        ["change_job_title"] = "Zmień nazwę pracy",
        ["change_name"] = "Zmień pseudonim",
        --police
        ["wanted"] = "Poszukiwania",
        ["un_wanted"] = "Usuwanie poszukiwania",
        ["warrant"] = "Nakazy",
        --mayor
        ["lockdown"] = "Uruchom godzinę policyjną",
        ["un_lockdown"] = "Zatrzymaj godzinę policyjną",
        ["give_license"] = "Daj licencję",
        ["add_law"] = "Dodaj prawo",
        ["remove_law"] = "Usuń prawo",
        ["place_laws"] = "Postaw prawa",
        ["broadcast"] = "Broadcast",
        ["start_lottery"] = "Rozpocznij loterię",

        ["select_player"] = "Wybierz gracza",
        ["enter_reason"] = "Podaj powód",
        ["err_cant_do"] = "Nie możesz tego zrobić z tą osobą",
    },

    ---------------
	/// SPANISH ///
	---------------
	["spanish"] = {
		// Main
		["greet"] = "Bienvenido de vuelta, %s", -- %s = nickname


		// Windows
		["win_title"] = "Ventana",
		["loading"] = "Cargando",
		["actions"] = "Acciones",
		["minimize"] = "Ocultar",
		["maximize"] = "Mostrar",
		["open"] = "Abrir",
		["close"] = "Cerrar",
		["pin"] = "Fijar",
		["unpin"] = "No fijar",
		["browser"] = "Buscador",


		// Other
		["favorite"] = "Favorito",
		["confirm"] = "Confirmar",
		["cancel"] = "Cancelar",
		["sure_phrase"] = "¿Estás seguro?",
		["cantafford"] = "No tienes el dinero suficiente",
		["weapons"] = "Armas",
		["search"] = "Buscar",
		["disconnected"] = "Desconectado",
		["number"] = "número",
		["on_effect"] = "Efectos activados",
		["off_effect"] = "Efectos desactivados",


		// Jobs Tab
		["jobs"] = "Trabajos",
		["job"] = "trabajo",
		["jobs_phrase"] = "Escoge tu profesión",
		["salary"] = "Salario",
		["recent"] = "Reciente",
		["unfavorite"] = "Remover de favoritos",
		["become"] = "Tomar puesto",
		["tags"]  = "Etiquetas",
		["level"] = "Nivel",
		["admin"] = "Admin",
		["unknown"] = "Desconocido",
		["description"] = "Descripción",
		["need_vote"] = "Votar",
		["err_norights"] = "Privilegios insuficientes",
		["err_noslots"] = "Jugadores máximos",
		["err_already"] = "Ya cuentas con esta profesión",




		// Shop Tab
		["shop"] = "Tienda",
		["shop_phrase"] = "Compra lo que desees :)",
		["buy"] = "Comprar",
		["max"] = "Máximo",
		["ents"] = "Entidades",
		["shipments"] = "Cargamentos",
		["ammo"] = "Munición",
		["food"] = "Comida",


		// Quick Actions
		--tabs
		["general_tab"] = "General",
		["money_tab"] = "Dinero",
		["police_tab"] = "Policía",
		["mayor_tab"] = "Alcalde",


		["amount"] = "Cantidad",
		["sell_doors"] = "Vender todas las puertas",
		["drop_money"] = "Soltar dinero",
		["give_money"] = "Dar dinero",
		["request_license"] = "Solicitar licencia",
		["drop_weapon"] = "Soltar arma",
		["change_job_title"] = "Cambiar título del trabajo",
		["change_name"] = "Cambiar nombre",
		--police
		["wanted"] = "Buscado",
		["un_wanted"] = "Remover búsqueda",
		["warrant"] = "Allanamiento",
		--mayor
		["lockdown"] = "Iniciar toque de queda",
		["un_lockdown"] = "Detener toque de queda",
		["give_license"] = "Otorgar licencia",
		["add_law"] = "Añadir ley",
		["remove_law"] = "Remover ley",
		["place_laws"] = "Colocar leyes",
		["broadcast"] = "Emisión",
		["start_lottery"] = "Iniciar lotería",


		["select_player"] = "Selecciona un jugador",
		["enter_reason"] = "Ingresa la razón",
		["err_cant_do"] = "No puedes realizar esa acción sobre esa persona",
	},
}