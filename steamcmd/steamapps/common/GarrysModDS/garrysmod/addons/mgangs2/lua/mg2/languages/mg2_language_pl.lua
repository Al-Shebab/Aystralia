--[[
    MGangs 2 - (SH) LANGUAGE - Polish
    Developed by Zephruz
    Translated by Foxie
]]
 
-- Don't replace %s they are for replacement values.
-- WARNING: If you're translating, this is extremely long and may take you a while.
 
local LANG_PL = mg2.lang:Register("pl")
 
--[[---------
  WORDS
-----------]]
LANG_PL:addTranslation("yes", "Tak")
LANG_PL:addTranslation("no", "Nie")
LANG_PL:addTranslation("to", "Do")
LANG_PL:addTranslation("from", "Od")
LANG_PL:addTranslation("other", "Inne")
LANG_PL:addTranslation("name", "Nazwa")
LANG_PL:addTranslation("page", "Strona")
LANG_PL:addTranslation("set", "Ustaw")
LANG_PL:addTranslation("save", "Zapisz")
LANG_PL:addTranslation("settings", "Ustaw.")
LANG_PL:addTranslation("delete", "Usuń")
LANG_PL:addTranslation("submit", "Zatwierdź")
LANG_PL:addTranslation("admin", "Admin")
LANG_PL:addTranslation("edit", "Edytuj")
LANG_PL:addTranslation("cancel", "Anuluj")
LANG_PL:addTranslation("leader", "Przywódca")
LANG_PL:addTranslation("gang", "Gang")
LANG_PL:addTranslation("gangs", "Gangi")
LANG_PL:addTranslation("invite", "Zaproś")
LANG_PL:addTranslation("general", "Ogólne")
LANG_PL:addTranslation("permissions", "Zezwolenia")
LANG_PL:addTranslation("page", "Strona")
LANG_PL:addTranslation("deny", "Odrzuć")
LANG_PL:addTranslation("join", "Dołącz")
LANG_PL:addTranslation("accept", "Akceptuj")
LANG_PL:addTranslation("decline", "Odmów")
LANG_PL:addTranslation("deposit", "Wpłać")
LANG_PL:addTranslation("withdraw", "Wypłać")
LANG_PL:addTranslation("options", "Opcje")
LANG_PL:addTranslation("priority", "Priorytet")
LANG_PL:addTranslation("description", "Opis")
LANG_PL:addTranslation("motd", "Wiadomość dnia")
LANG_PL:addTranslation("icon", "Ikonka")
LANG_PL:addTranslation("color", "Kolor")
LANG_PL:addTranslation("level", "Poziom")
LANG_PL:addTranslation("balance", "Saldo konta")
LANG_PL:addTranslation("management", "Zarządzanie")
LANG_PL:addTranslation("user", "Użytkownik")
LANG_PL:addTranslation("users", "Użytkownicy")
LANG_PL:addTranslation("member", "Członek")
LANG_PL:addTranslation("members", "Członkowie")
LANG_PL:addTranslation("respond", "Odpowiedz")
LANG_PL:addTranslation("back", "Powrót")
LANG_PL:addTranslation("received", "Otrzymano")
LANG_PL:addTranslation("request", "Prośba")
LANG_PL:addTranslation("item", "Przedmiot")
LANG_PL:addTranslation("items", "Przedmioty")
LANG_PL:addTranslation("unclaimed", " Nieodebrane")
LANG_PL:addTranslation("current", "Obecnie")
LANG_PL:addTranslation("cost", "Koszt")
LANG_PL:addTranslation("npc", "NPC")
LANG_PL:addTranslation("npcs", "NPCs")
LANG_PL:addTranslation("modify", "Modyfikować")
LANG_PL:addTranslation("create", "Stwórz")
 
--[[---------
  PHRASES
-----------]]
LANG_PL:addTranslation("ganginfo", "Informacje o gangu")
LANG_PL:addTranslation("gangname", "Nazwa gangu")
LANG_PL:addTranslation("gangmotd", "Wiadomość dnia gangu")
LANG_PL:addTranslation("ganginvites", "Zaproszenia do gangu")
LANG_PL:addTranslation("gangcreation", "Tworzenie gangu")
LANG_PL:addTranslation("gangsettings", "Ustawienia gangu")
LANG_PL:addTranslation("creategang", "Stwórz gang")
LANG_PL:addTranslation("viewgang", "Zobacz gang")
LANG_PL:addTranslation("iconmustbeurl", "Ikonka (musi być URL)")
LANG_PL:addTranslation("selectcolor", "Wybierz kolor")
LANG_PL:addTranslation("selecticon", "Wybierz ikonkę")
LANG_PL:addTranslation("depositmoney", "Wpłać pieniądze")
LANG_PL:addTranslation("leavegang", "Opuść gang")
LANG_PL:addTranslation("modifygang", "Modyfikacja gangu")
LANG_PL:addTranslation("modifygroup", "Modyfikacja grupy")
LANG_PL:addTranslation("modifygroups", "Modyfikacja grup")
LANG_PL:addTranslation("modifyuser", "Modyfikacja użytkownika")
LANG_PL:addTranslation("modifyinguser", "Modyfikowanie użytkowników")
LANG_PL:addTranslation("modifyinggroup", "Modyfikowanie grup")
LANG_PL:addTranslation("creategroup", "Stworzyć grupę")
LANG_PL:addTranslation("removegroup", "Usuń grupę")
LANG_PL:addTranslation("newgroup", "Nowa grupa")
LANG_PL:addTranslation("usermanagement", "Zarządzanie użytkownikami")
LANG_PL:addTranslation("inviteplayer", "Zaproś gracza")
LANG_PL:addTranslation("inviteplayers", "Zaproś graczy")
LANG_PL:addTranslation("kickplayer", "Wyrzuć gracza")
LANG_PL:addTranslation("setplayergroup", "Ustaw grupę dla gracza")
LANG_PL:addTranslation("setgroup", "Ustaw grupę")
LANG_PL:addTranslation("selectgroup", "Wybierz grupę")
LANG_PL:addTranslation("nooptions", "Brak opcji")
LANG_PL:addTranslation("noplayers", "Brak graczy")
LANG_PL:addTranslation("noinvites", "Brak zaproszeń")
LANG_PL:addTranslation("generalinfo", "Ogólne informacje")
LANG_PL:addTranslation("usersettings", "Ustawienia gracza")
LANG_PL:addTranslation("nousersettings", "Brak ustawień użytkownika")
LANG_PL:addTranslation("nogangsettings", "Brak ustawień gangu")
LANG_PL:addTranslation("viewrequests", "Zobacz prośby")
LANG_PL:addTranslation("generaloptions", "Ogólne opcje")
LANG_PL:addTranslation("cantafford", "Nie stać cię")
 
--[[---------
  NPC SPECIFIC
-----------]]
LANG_PL:addTranslation("npc.Title", "Zarządca gangów")
LANG_PL:addTranslation("npc.Description", "Stwórz, zarządzaj lub dołącz do gangu!")
 
--[[---------
  GANG SPECIFIC
-----------]]
LANG_PL:addTranslation("gang.Created", "Gang został stworzony!")
LANG_PL:addTranslation("gang.AlreadyInGang", "Jesteś już w gangu.")
LANG_PL:addTranslation("gang.SetName", "Ustaw nazwę gangu")
LANG_PL:addTranslation("gang.SetNameDesc", "Ustawia nazwę gangu.")
LANG_PL:addTranslation("gang.SetLevel", "Ustaw poziom gangu")
LANG_PL:addTranslation("gang.SetLevelDesc", "Ustawia poziom gangu.")
LANG_PL:addTranslation("gang.SetIcon", "Ustaw ikonkę gangu")
LANG_PL:addTranslation("gang.SetIconDesc", "Ustawia ikonkę gangu.")
LANG_PL:addTranslation("gang.Delete", "Usuń gang")
LANG_PL:addTranslation("gang.DeleteDesc", "Usuwa gang.")
LANG_PL:addTranslation("gang.SetColor", "Ustaw kolor gangu")
LANG_PL:addTranslation("gang.SetColorDesc", "Ustawia kolor gangu.")
LANG_PL:addTranslation("gang.SetColor", "Ustaw kolor gangu")
LANG_PL:addTranslation("gang.SetMOTD", "Ustaw wiadmość dnia gangu")
LANG_PL:addTranslation("gang.NameTooLong", "Nazwa gangu jest zbyt długa.")
LANG_PL:addTranslation("gang.MOTDTooLong", "Wiadomość dnia gangu jest zbyt długa.")
 
--[[---------
  USER SPECIFIC
-----------]]
LANG_PL:addTranslation("user.SetGang", "Ustaw gang")
LANG_PL:addTranslation("user.SetGangDesc", "Przypisuje gracza do gangu.")
LANG_PL:addTranslation("user.SetGangGroup", "Ustaw grupę gangu")
LANG_PL:addTranslation("user.SetGangGroupDesc", "Przypisuje gracza do grupy gangu.")
LANG_PL:addTranslation("user.KickFromGang", "Wyrzuć z gangu")
LANG_PL:addTranslation("user.KickFromGangDesc", "Wyrzuca członka z gangu.")
 
--[[---------
  PERMISSION SPECIFIC
-----------]]
LANG_PL:addTranslation("perm.DepositMoneyDesc", "Możliwość wpłacenia pieniędzy do salda gangu")
LANG_PL:addTranslation("perm.WithdrawMoneyDesc", "Możliwość wypłacenia pieniędzy z salda gangu.")
LANG_PL:addTranslation("perm.SetNameDesc", "Ustawienie nazwy gangu.")
LANG_PL:addTranslation("perm.SetIconDesc", "Ustawienie ikonki gangu.")
LANG_PL:addTranslation("perm.SetColorDesc", "Ustawienie koloru gangu.")
LANG_PL:addTranslation("perm.SetGroupDesc", "Ustawienie grupy członków.")
LANG_PL:addTranslation("perm.SetMOTDDesc", "Ustawienie wiadomości dnia gangu.")
LANG_PL:addTranslation("perm.CreateGroupDesc", "Tworzenie grup gangu.")
LANG_PL:addTranslation("perm.RemoveGroupDesc", "Usuwanie grup gangu.")
LANG_PL:addTranslation("perm.InvitePlayersDesc", "Zapraszanie graczy do gangu.")
LANG_PL:addTranslation("perm.KickPlayersDesc", "Usunięcie członków gangu.")
LANG_PL:addTranslation("perm.ModifyGroupDesc", "Modyfikacja grup gangu.")
LANG_PL:addTranslation("perm.YouHaveDeposited", "Zdepozytowałeś %s.")
LANG_PL:addTranslation("perm.YouHaveSetIcon", "Zaktualizowałeś ikonkę gangu.")
LANG_PL:addTranslation("perm.YouHaveSetColor", "Zaktualizowałeś kolor gangu.")
LANG_PL:addTranslation("perm.YouHaveSetName", "Zaktualizowałeś nazwę gangu.")
LANG_PL:addTranslation("perm.YouHaveSetMOTD", "Zaktualizowałeś wiadomość dnia gangu.")
LANG_PL:addTranslation("perm.YouHaveModifiedGroup", "Zmodyfikowałeś grupę - %s.")
LANG_PL:addTranslation("perm.YouHaveCreatedGroup", "Stworzyłeś grupę - %s.")
LANG_PL:addTranslation("perm.YouHaveRemovedGroup", "Usunąłeś grupę - %s.")
LANG_PL:addTranslation("perm.YouHaveInvited", "Zaprosiłeś gracza %s.")
LANG_PL:addTranslation("perm.YouHaveBeenInvited", "Zostałeś zaproszony do gangu %s.")
LANG_PL:addTranslation("perm.YouHaveKicked", "Wyrzuciłeś gracza %s z gangu.")
LANG_PL:addTranslation("perm.YouHaveBeenKicked", "Zostałeś wyrzucony z gangu.")
LANG_PL:addTranslation("perm.YouHaveSetGroup", "Ustawiłeś grupę gracza %s na %s.")
 
--[[---------
  TERRITORIES
-----------]]
LANG_PL:addTranslation("territory", "Terytorium")
LANG_PL:addTranslation("territories", "Terytoria")
LANG_PL:addTranslation("noterritories", "Brak terytorium")
LANG_PL:addTranslation("territory.flag.CreatorInfo", "[Lewy przycisk] Postaw flagę")
LANG_PL:addTranslation("territory.CreatorInfo1", "[Lewy przycisk + przytrzymanie] Wybierz obszar")
LANG_PL:addTranslation("territory.CreatorInfo2", "[Prawy przycisk] Zapisz obszar")
LANG_PL:addTranslation("territory.CreatorInfo3", "[Przeładowanie] Zresetuj obszar")
LANG_PL:addTranslation("territory.ControlledBy", "Kontrolowane przez %s")
LANG_PL:addTranslation("territory.BeingClaimedBy", "Zajmowane przez %s.")
LANG_PL:addTranslation("territory.CurrentlyUncontrolled", "Niekontrolowane")
LANG_PL:addTranslation("territory.YoureNotInAGang", "Nie jesteś w gangu.")
LANG_PL:addTranslation("territory.SomeoneElseClaiming", "Ktoś inny zajmuje te terrytorium.")
LANG_PL:addTranslation("territory.AlreadyClaiming", "Już zajmujesz te terytorium.")
LANG_PL:addTranslation("territory.CantClaimOwn", "Nie możesz zająć posiadanych terytorium gangu.")
LANG_PL:addTranslation("territory.TerritoryClaimedFor", "Terytorium zajęte na %s.")
LANG_PL:addTranslation("territory.BeingClaimed", "Terytorium '%s' jest zajmowane!")
LANG_PL:addTranslation("territory.MustWait", "Musisz odczekać %s sekund.")
LANG_PL:addTranslation("territory.NotClaiming.NoGang", "Nie możesz zająć tego terytorium, ponieważ nie jesteś w gangu!")
LANG_PL:addTranslation("territory.NotClaiming.Dead", "Zatrzymano dalsze przejmowanie terytorium, ponieważ jesteś martwy.")
LANG_PL:addTranslation("territory.NotClaiming.TooFar", "Zatrzymano dalsze przejmowanie terytorium, ponieważ jesteś zbyt daleko flagi.")
LANG_PL:addTranslation("territory.Reload", "Zreset. teryt.")
LANG_PL:addTranslation("territory.Options", "Opcje terytorium")
LANG_PL:addTranslation("territory.Create", "Tworzenie terytorium")
LANG_PL:addTranslation("territory.YouAreIn", "Jesteś na terytorium")
LANG_PL:addTranslation("territory.SetTerritory", "Ustaw terytorium %s")
LANG_PL:addTranslation("territory.TerritoryName", "Terytorium %s")
LANG_PL:addTranslation("territory.SetName", "Ustaw nazwę terytorium")
LANG_PL:addTranslation("territory.SetNameDesc", "Ustawia nazwę terytorium.")
LANG_PL:addTranslation("territory.SetDescription", "Ustaw opis terytorium.")
LANG_PL:addTranslation("territory.SetDescriptionDesc", "Ustawia opis terytorium.")
LANG_PL:addTranslation("territory.Delete", "Usuń terytorium")
LANG_PL:addTranslation("territory.DeleteDesc", "Usuwa terytorium.")
 
--[[---------
  ACHIEVEMENTS
-----------]]
LANG_PL:addTranslation("achievements", "Osiągnięcia")
LANG_PL:addTranslation("achieved", "Osiągnięto")
LANG_PL:addTranslation("achievements.Balance", "Osiągnięcia salda konta")
LANG_PL:addTranslation("achievements.BalanceDesc", "Osiągnięcia za osiągnięcie wymaganej liczby salda konta.")
LANG_PL:addTranslation("achievements.Members", "Osiągnięcia członków")
LANG_PL:addTranslation("achievements.MembersDesc", "Osiągnięcia za osiągnięcie wymaganej liczby członków.")
 
--[[---------
  ASSOCIATIONS
-----------]]
LANG_PL:addTranslation("association", "Sojusz")
LANG_PL:addTranslation("associations", "Sojusze")
LANG_PL:addTranslation("associations.Request", "Poproś o sojusz")
LANG_PL:addTranslation("associations.Requests", "Prośba o sojusz")
LANG_PL:addTranslation("associations.ViewingAssociationGangs", "Przeglądanie sojuszy z gangami")
LANG_PL:addTranslation("associations.RequestRespond", "Odpowiedz na prośbę")
LANG_PL:addTranslation("associations.RequestRespondDesc", "Odpowiedz na prośbę.")
LANG_PL:addTranslation("associations.Request", "Poproś o sojusz")
LANG_PL:addTranslation("associations.RequestDesc", "Możliwość poproszenia o sojusz z innym gangiem.")
LANG_PL:addTranslation("associations.SetAssociation", "Ustaw sojusz")
LANG_PL:addTranslation("associations.SetAssociationDesc", "Możliwość ustawienia statusu sojuszu.")
LANG_PL:addTranslation("associations.SetNameDesc", "Możliwość zmiany nazwy sojuszu.")
LANG_PL:addTranslation("associations.VoidAssociation", "Anuluj sojusz")
LANG_PL:addTranslation("associations.VoidAssociationDesc", "Możliwość anulowania sojuszu z innym gangiem.")
LANG_PL:addTranslation("noassociations", "Brak sojuszy")
LANG_PL:addTranslation("selectassociation", "Wybierz sojusz...")
LANG_PL:addTranslation("setassociationname", "Ustaw nazwę sojuszu")
LANG_PL:addTranslation("enterassociationname", "Wprowadź nazwę sojuszu...")
 
--[[---------
  GANG SIGN
-----------]]
LANG_PL:addTranslation("gangsign.Buy", "Kup znak gangu")
LANG_PL:addTranslation("gangsign.BuyDesc", "Możliwość kupna znaku gangu.")
LANG_PL:addTranslation("gangsign.MaxLimit",  "Osiągnięto maksymalny limit znaków.")
LANG_PL:addTranslation("gangsign.CantAfford", "Nie stać cię na znak.")
LANG_PL:addTranslation("gangsign.Spawned", "Znak gangu się pojawił!")
 
--[[---------
  HISCORES
-----------]]
LANG_PL:addTranslation("hiscore", "Osiągnięcie")
LANG_PL:addTranslation("hiscores", "Osiągnięcia")
LANG_PL:addTranslation("hiscores.MostAssociations", "Najwięcej sojuszy")
LANG_PL:addTranslation("hiscores.MostMembers", "Najwięcej członków")
LANG_PL:addTranslation("hiscores.MostStashItems", "Najwięcej zdepozytowanych przedmiotów")
 
--[[---------
  STASH
-----------]]
LANG_PL:addTranslation("stash", "Schowek")
LANG_PL:addTranslation("stash.DepositItem", "Zdepozytuj przedmiot")
LANG_PL:addTranslation("stash.DepositItemDesc", "Możliwość zdeponowania przedmiotów.")
LANG_PL:addTranslation("stash.WithdrawItem", "Wyciągnij przedmiot")
LANG_PL:addTranslation("stash.WithrdawItemDesc", "Możliwość wyciągnięcia przedmiotów.")
 
--[[---------
  UPGRADES
-----------]]
LANG_PL:addTranslation("upgrade", "Ulepszenie")
LANG_PL:addTranslation("upgrades", "Ulepszenia")
LANG_PL:addTranslation("buytier", "Kup")
LANG_PL:addTranslation("viewtiers", "Sprawdź")
LANG_PL:addTranslation("tier", "Poziom")
LANG_PL:addTranslation("obtained", "Odebrano")
LANG_PL:addTranslation("upgradeto", "Ulepsz do %s")
LANG_PL:addTranslation("upgrades.Purchase", "Kup ulepszenia")
LANG_PL:addTranslation("upgrades.PurchaseDesc", "Można kupić ulepszenia.")
LANG_PL:addTranslation("upgrades.CantAfford", "Twojego gangu nie stać na ulepszenie!")
LANG_PL:addTranslation("upgrades.TierPurchased", "Kupiono poziom.")
LANG_PL:addTranslation("upgrades.MustPurchasePriorTier", "Trzeba kupić wcześniejszy poziom.")
LANG_PL:addTranslation("upgrades.MaxAssociations", "Maks. sojusze")
LANG_PL:addTranslation("upgrades.MaxAssociationsDesc", "Maks. liczba sojuszy na raz.")
LANG_PL:addTranslation("upgrades.AssociationsMax", "Osiągnąłeś maks. limit sojuszy, ulepsz by zwiększyć limit! (%s)")
LANG_PL:addTranslation("upgrades.MaxBalance", "Maks. limit salda konta")
LANG_PL:addTranslation("upgrades.MaxBalanceDesc", "Maks. dopuszczalny limit salda.")
LANG_PL:addTranslation("upgrades.BalanceMax", "Osiągnąłeś maks. limit salda, ulepsz by zwiększyć limit! (%s)")
LANG_PL:addTranslation("upgrades.MaxStash", "Maks. pojemność schowka")
LANG_PL:addTranslation("upgrades.MaxStashDesc", "Maks. dopuszczalny limit pojemności schowka.")
LANG_PL:addTranslation("upgrades.StashMax", "Osiągnąłeś maks. limit schowka, ulepsz by zwięszyć limit! (%s)")
LANG_PL:addTranslation("upgrades.MaxTerritories", "Maks. liczba terytorium")
LANG_PL:addTranslation("upgrades.MaxTerritoriesDesc", "Maks. liczba terytorium, która może być przejęta na raz.")
LANG_PL:addTranslation("upgrades.TerritoryMax", "Osiągnąłeś maks. liczbę terytorium, ulepsz by zwiększyć liczbę! (%s)")