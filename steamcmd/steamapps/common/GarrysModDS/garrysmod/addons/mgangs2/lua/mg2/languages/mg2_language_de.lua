--[[
    MGangs 2 - (SH) LANGUAGE - English
    Developed by Zephruz
]]

-- Don't replace %s they are for replacement values.
-- WARNING: If you're translating, this is extremely long and may take you a while.

local LANG_DE = mg2.lang:Register("de")

--[[---------
  WORDS
-----------]]
LANG_DE:addTranslation("yes", "Ja")
LANG_DE:addTranslation("no", "Nein")
LANG_DE:addTranslation("to", "zu")
LANG_DE:addTranslation("from", "von")
LANG_DE:addTranslation("other", "anderes")
LANG_DE:addTranslation("name", "Name")
LANG_DE:addTranslation("page", "Seite")
LANG_DE:addTranslation("set", "setzen")
LANG_DE:addTranslation("save", "speichern")
LANG_DE:addTranslation("settings", "Einstellungen")
LANG_DE:addTranslation("delete", "löschen")
LANG_DE:addTranslation("submit", "einreichen")
LANG_DE:addTranslation("admin", "Admin")
LANG_DE:addTranslation("edit", "editieren")
LANG_DE:addTranslation("cancel", "abbrechen")
LANG_DE:addTranslation("leader", "Anführer")
LANG_DE:addTranslation("gang", "Gang")
LANG_DE:addTranslation("gangs", "Gangs")
LANG_DE:addTranslation("invite", "einladen")
LANG_DE:addTranslation("general", "Allgemein")
LANG_DE:addTranslation("permissions", "Berechtigungen")
LANG_DE:addTranslation("page", "Seite")
LANG_DE:addTranslation("deny", "Verweigern")
LANG_DE:addTranslation("join", "Beitreten")
LANG_DE:addTranslation("accept", "Akzeptieren")
LANG_DE:addTranslation("decline", "Ablehnen")
LANG_DE:addTranslation("deposit", "Anzahlung")
LANG_DE:addTranslation("withdraw", "Abheben")
LANG_DE:addTranslation("options", "Optionen")
LANG_DE:addTranslation("priority", "Priorität")
LANG_DE:addTranslation("description", "Beschreibung")
LANG_DE:addTranslation("motd", "MOTD")
LANG_DE:addTranslation("icon", "Icon")
LANG_DE:addTranslation("color", "Farbe")
LANG_DE:addTranslation("level", "Level")
LANG_DE:addTranslation("balance", "Balance")
LANG_DE:addTranslation("management", "Verwaltung")
LANG_DE:addTranslation("user", "Benutzer")
LANG_DE:addTranslation("users", "Benutzer")
LANG_DE:addTranslation("member", "Mitglied")
LANG_DE:addTranslation("members", "Mitglieder")
LANG_DE:addTranslation("respond", "Antworten")
LANG_DE:addTranslation("back", "zurück")
LANG_DE:addTranslation("received", "Empfangen")
LANG_DE:addTranslation("request", "Anfordern")
LANG_DE:addTranslation("item", "Item")
LANG_DE:addTranslation("items", "Items")
LANG_DE:addTranslation("unclaimed", "Nicht abgeholt")
LANG_DE:addTranslation("current", "Aktuell")
LANG_DE:addTranslation("cost", "Kosten")
LANG_DE:addTranslation("npc", "NPC")
LANG_DE:addTranslation("npcs", "NPCs")

--[[---------
  PHRASES
-----------]]
LANG_DE:addTranslation("ganginfo", "Gang Info")
LANG_DE:addTranslation("gangname", "Gang Name")
LANG_DE:addTranslation("gangmotd", "Gang MOTD")
LANG_DE:addTranslation("ganginvites", "Gang Einladungen")
LANG_DE:addTranslation("gangcreation", "Gang Erstellungen")
LANG_DE:addTranslation("gangsettings", "Gang Einstellungen")
LANG_DE:addTranslation("creategang", "Gang erstellen")
LANG_DE:addTranslation("viewgang", "Gang ansehen")
LANG_DE:addTranslation("iconmustbeurl", "Icon (Muss URL sein)")
LANG_DE:addTranslation("selectcolor", "Wähle Farbe")
LANG_DE:addTranslation("selecticon", "Wähle Icon")
LANG_DE:addTranslation("depositmoney", "Geld einzahlen")
LANG_DE:addTranslation("leavegang", "Verlasse Gang")
LANG_DE:addTranslation("modifygang", "Gang ändern")
LANG_DE:addTranslation("modifygroup", "Gruppe ändern")
LANG_DE:addTranslation("modifygroups", "Gruppen ändern")
LANG_DE:addTranslation("modifyuser", "Benutzer ändern")
LANG_DE:addTranslation("modifyinguser", "Benutzer ändern")
LANG_DE:addTranslation("modifyinggroup", "Gruppe ändern")
LANG_DE:addTranslation("creategroup", "Gruppe erstellen")
LANG_DE:addTranslation("removegroup", "Gruppe entfernen")
LANG_DE:addTranslation("newgroup", "Neue Gruppe")
LANG_DE:addTranslation("usermanagement", "Benutzerverwaltung")
LANG_DE:addTranslation("inviteplayer", "Spieler einladen")
LANG_DE:addTranslation("inviteplayers", "Spieler einladen")
LANG_DE:addTranslation("kickplayer", "Spieler kicken")
LANG_DE:addTranslation("setplayergroup", "Spielergruppe festlegen")
LANG_DE:addTranslation("setgroup", "Gruppe einstellen")
LANG_DE:addTranslation("selectgroup", "Wähle die Gruppe")
LANG_DE:addTranslation("nooptions", "Keine Optionen")
LANG_DE:addTranslation("noplayers", "Keine Spieler")
LANG_DE:addTranslation("noinvites", "Keine Einladungen")
LANG_DE:addTranslation("generalinfo", "Allgemeine Information")
LANG_DE:addTranslation("usersettings", "Benutzereinstellungen")
LANG_DE:addTranslation("nousersettings", "Keine Benutzereinstellungen")
LANG_DE:addTranslation("nogangsettings", "Keine Gangeinstellungen")
LANG_DE:addTranslation("viewrequests", "Anfragen anzeigen")
LANG_DE:addTranslation("generaloptions", "Allgemeine Optionen")
LANG_DE:addTranslation("cantafford", "Kann mir es nicht leisten")

--[[---------
  NPC SPECIFIC
-----------]]
LANG_DE:addTranslation("npc.Title", "Gang Manager")
LANG_DE:addTranslation("npc.Description", "Verwalte, erstelle oder schließe dich einer Gang an!")

--[[---------
  GANG SPECIFIC
-----------]]
LANG_DE:addTranslation("gang.Created", "Gang erstellt")
LANG_DE:addTranslation("gang.AlreadyInGang", "Du bist schon in einer Gang.")
LANG_DE:addTranslation("gang.SetName", "Setze Gang Name")
LANG_DE:addTranslation("gang.SetNameDesc", "Setzt einen Bandennamen.")
LANG_DE:addTranslation("gang.SetLevel", "Gang Level einstellen")
LANG_DE:addTranslation("gang.SetLevelDesc", "Legt eine Gangstufe fest.")
LANG_DE:addTranslation("gang.SetIcon", "Setze Gang Icon")
LANG_DE:addTranslation("gang.SetIconDesc", "Legt ein Bandensymbol fest.")
LANG_DE:addTranslation("gang.Delete", "Gang löschen")
LANG_DE:addTranslation("gang.DeleteDesc", "Löscht eine Gang.")
LANG_DE:addTranslation("gang.SetColor", "Setzt Gang Farbe")
LANG_DE:addTranslation("gang.SetColorDesc", "Legt eine Bandenfarbe fest.")
LANG_DE:addTranslation("gang.SetColor", "Gruppenfarbe einstellen")
LANG_DE:addTranslation("gang.SetMOTD", "Setzte Gang MOTD")
LANG_DE:addTranslation("gang.NameTooLong", "Gruppenname ist zu lang.")
LANG_DE:addTranslation("gang.MOTDTooLong", "Gang MOTD ist zu lang.")

--[[---------
  USER SPECIFIC
-----------]]
LANG_DE:addTranslation("user.SetGang", "Gang setzen")
LANG_DE:addTranslation("user.SetGangDesc", "Setzt eine Benutzergruppe.")
LANG_DE:addTranslation("user.SetGangGroup", "Gruppengruppe einstellen")
LANG_DE:addTranslation("user.SetGangGroupDesc", "Legt eine Benutzergruppengruppe fest.")
LANG_DE:addTranslation("user.KickFromGang", "Kick von Gang")
LANG_DE:addTranslation("user.KickFromGangDesc", "Tritt einen User aus seiner Gang.")

--[[---------
  PERMISSION SPECIFIC
-----------]]
LANG_DE:addTranslation("perm.DepositMoneyDesc", "Kann Geld auf das Gruppenguthaben einzahlen.")
LANG_DE:addTranslation("perm.WithdrawMoneyDesc", "Kann Geld vom Gruppenguthaben abheben.")
LANG_DE:addTranslation("perm.SetNameDesc", "Setze den Gang Name")
LANG_DE:addTranslation("perm.SetIconDesc", "Setze das Bandensymbol.")
LANG_DE:addTranslation("perm.SetColorDesc", "Setze die Bandenfarbe")
LANG_DE:addTranslation("perm.SetGroupDesc", "Setzt eine Spielergruppe")
LANG_DE:addTranslation("perm.SetMOTDDesc", "Gang MOTD setzen")
LANG_DE:addTranslation("perm.CreateGroupDesc", "Eine Gruppengruppe erstellen")
LANG_DE:addTranslation("perm.RemoveGroupDesc", "Bandengruppe entfernen")
LANG_DE:addTranslation("perm.InvitePlayersDesc", "Spieler zur Gang einladen")
LANG_DE:addTranslation("perm.KickPlayersDesc", "Kick Benutzer von der Gang")
LANG_DE:addTranslation("perm.ModifyGroupDesc", "Ganggruppe ändern")
LANG_DE:addTranslation("perm.YouHaveDeposited", "Sie haben %s hinterlegt.")
LANG_DE:addTranslation("perm.YouHaveSetIcon", "Sie haben das Gangs-Symbol aktualisiert.")
LANG_DE:addTranslation("perm.YouHaveSetColor", "Sie haben die Bandenfarbe aktualisiert.")
LANG_DE:addTranslation("perm.YouHaveSetName", "Sie haben den Bandennamen aktualisiert.")
LANG_DE:addTranslation("perm.YouHaveSetMOTD", "Sie haben die Gangs MOTD aktualisiert.")
LANG_DE:addTranslation("perm.YouHaveModifiedGroup", "Sie haben die Gruppengruppe %s geändert.")
LANG_DE:addTranslation("perm.YouHaveCreatedGroup", "Sie haben die Gruppengruppe %s erstellt.")
LANG_DE:addTranslation("perm.YouHaveRemovedGroup", "Sie haben die Gruppengruppe %s gelöscht.")
LANG_DE:addTranslation("perm.YouHaveInvited", "Sie haben den Spieler %s eingeladen.")
LANG_DE:addTranslation("perm.YouHaveBeenInvited", "Sie wurden zur Gang %s eingeladen.")
LANG_DE:addTranslation("perm.YouHaveKicked", "Sie haben den Spieler %s aus der Gang geworfen.")
LANG_DE:addTranslation("perm.YouHaveBeenKicked", "Sie wurden aus Ihrer Gang ausgeschlossen.")
LANG_DE:addTranslation("perm.YouHaveSetGroup", "Sie haben die Gruppe des Benutzers %s auf %s gesetzt.")

--[[---------
  TERRITORIES
-----------]]
LANG_DE:addTranslation("territory", "Gebiet")
LANG_DE:addTranslation("territories", "Gebiete")
LANG_DE:addTranslation("noterritories", "Keine Gebiete")
LANG_DE:addTranslation("territory.flag.CreatorInfo"," [Linksklick] Flag platzieren")
LANG_DE:addTranslation("territory.CreatorInfo1", "[Linksklick + Halten] Zeichne den Bereich")
LANG_DE:addTranslation("territory.CreatorInfo2", "[Rechtsklick] Bereich speichern")
LANG_DE:addTranslation("territory.CreatorInfo3", "[Neu laden] Setzen Sie den Bereich zurück")
LANG_DE:addTranslation("territory.ControlledBy", "Gesteuert von %s")
LANG_DE:addTranslation("territory.BeingClaimedBy", "Wird von %s beansprucht.")
LANG_DE:addTranslation("territory.CurrentlyUncontrolled", "Derzeit unkontrolliert")
LANG_DE:addTranslation("territory.YoureNotInAGang", "Du bist nicht in einer Bande.")
LANG_DE:addTranslation("territory.SomeoneElseClaiming", "Jemand anderes beansprucht dieses Gebiet.")
LANG_DE:addTranslation("territory.AlreadyClaiming", "Sie beanspruchen dieses Gebiet bereits.")
LANG_DE:addTranslation("territory.CantClaimOwn"," Sie können Ihr eigenes Bandengebiet nicht beanspruchen.")
LANG_DE:addTranslation("territory.TerritoryClaimedFor", "Gebiet für %s beansprucht")
LANG_DE:addTranslation("territory.BeingClaimed", "Territory ' %s' wird beansprucht!")
LANG_DE:addTranslation("territory.MustWait", "Sie müssen %s Sekunden warten.")
LANG_DE:addTranslation("territory.NotClaiming.NoGang"," Das kann man nicht behaupten, nicht in einer Gang!")
LANG_DE:addTranslation("territory.NotClaiming.Dead", "Gebiet nicht mehr beansprucht, weil Sie tot sind.")
LANG_DE:addTranslation("territory.NotClaiming.TooFar", "Gebiet nicht mehr beansprucht, weil Sie zu weit entfernt sind.")
LANG_DE:addTranslation("territory.Reload", "Lade Gebiete neu")
LANG_DE:addTranslation("territory.Options", "Regionsoptionen")
LANG_DE:addTranslation("territory.Create", "Gebiet erstellen")
LANG_DE:addTranslation("territory.YouAreIn", "Sie befinden sich in dem Gebiet")
LANG_DE:addTranslation("territory.SetTerritory", "Gebiet %s festlegen")
LANG_DE:addTranslation("territory.TerritoryName", "Gebiet %s")
LANG_DE:addTranslation("territory.SetName", "Regionsname festlegen")
LANG_DE:addTranslation("territory.SetNameDesc", "Legt einen Regionsnamen fest.")
LANG_DE:addTranslation("territory.SetDescription", "Gebietsbeschreibung festlegen")
LANG_DE:addTranslation("territory.SetDescriptionDesc", "Legt eine Gebietsbeschreibung fest.")
LANG_DE:addTranslation("territory.Delete", "Gebiet löschen")
LANG_DE:addTranslation("territory.DeleteDesc", "Löscht ein Gebiet.")

--[[---------
  ACHIEVEMENTS
-----------]]
LANG_DE:addTranslation("achievements", "Erfolge")
LANG_DE:addTranslation("achieved", "Erreicht")
LANG_DE:addTranslation("achievements.Balance", "Balance Erfolge")
LANG_DE:addTranslation("achievements.BalanceDesc", "Erfolge für das Erreichen bestimmter Gleichgewichtssummen.")
LANG_DE:addTranslation("achievements.Members", "Erfolge der Mitglieder")
LANG_DE:addTranslation("achievements.MembersDesc", "Erfolge für das Erreichen bestimmter Mitgliederzahlen.")

--[[---------
  ASSOCIATIONS
-----------]]
LANG_DE:addTranslation("association", "Verein")
LANG_DE:addTranslation("associations", "Verbände")
LANG_DE:addTranslation("associations.Request", "Assoziation anfordern")
LANG_DE:addTranslation("associations.Requests", "Assoziierungsantrag")
LANG_DE:addTranslation("associations.ViewingAssociationGangs", "Anzeigen von Vereinigungsbanden")
LANG_DE:addTranslation("associations.RequestRespond", "Antwort auf Anfrage")
LANG_DE:addTranslation("associations.RequestRespondDesc", "Auf Anfrage antworten")
LANG_DE:addTranslation("associations.Request", "Request Association")
LANG_DE:addTranslation("associations.RequestDesc", "Kann eine Zuordnung zu einer anderen Gang anfordern.")
LANG_DE:addTranslation("associations.SetAssociation", "Set Association")
LANG_DE:addTranslation("associations.SetAssociationDesc", "Kann einen Zuordnungsstatus setzen.")
LANG_DE:addTranslation("associations.SetNameDesc", "Kann den Assoziationsnamen ändern.")
LANG_DE:addTranslation("associations.VoidAssociation", "Void Association")
LANG_DE:addTranslation("associations.VoidAssociationDesc", "Kann eine Zuordnung zu einer anderen Gang aufheben / löschen.")
LANG_DE:addTranslation("noassociations", "Keine Assoziationen")
LANG_DE:addTranslation("selectassociation", "Assoziation auswählen...")
LANG_DE:addTranslation("setassociationname", "Legen Sie den Assoziationsnamen fest")
LANG_DE:addTranslation("enterassociationname", "Vereinsname eingeben...")

--[[---------
  GANG SIGN
-----------]]
LANG_DE:addTranslation("gangsign.Buy", "Kaufen Sie Gang Schild")
LANG_DE:addTranslation("gangsign.BuyDesc", "Kann ein Bandenschild kaufen.")
LANG_DE:addTranslation("gangsign.MaxLimit",  "Maximales Vorzeichenlimit erreicht.")
LANG_DE:addTranslation("gangsign.CantAfford", "Ich kann mir kein Zeichen leisten.")
LANG_DE:addTranslation("gangsign.Spawned", "Gang Zeichen gespawnt!")

--[[---------
  HISCORES
-----------]]
LANG_DE:addTranslation("hiscore", "Hiscore")
LANG_DE:addTranslation("hiscores", "Hiscores")
LANG_DE:addTranslation("hiscores.MostAssociations", "Die meisten Verbände")
LANG_DE:addTranslation("hiscores.MostMembers", "Die meisten Mitglieder")
LANG_DE:addTranslation("hiscores.MostStashItems", "Die meisten Vorratsgegenstände")

--[[---------
  STASH
-----------]]
LANG_DE:addTranslation("stash", "Versteck")
LANG_DE:addTranslation("stash.DepositItem", "Artikel einzahlen")
LANG_DE:addTranslation("stash.DepositItemDesc", "Kann Gegenstände deponieren.")
LANG_DE:addTranslation("stash.WithdrawItem", "Artikel zurückziehen")
LANG_DE:addTranslation("stash.WithrdawItemDesc", "Kann Artikel zurückziehen.")

--[[---------
  UPGRADES
-----------]]
LANG_DE:addTranslation("upgrade", "Upgrade")
LANG_DE:addTranslation("upgrades", "Upgrades")
LANG_DE:addTranslation("buytier", "Tier kaufen")
LANG_DE:addTranslation("viewtiers", "Tiers ansehen")
LANG_DE:addTranslation("tier", "Tier")
LANG_DE:addTranslation("obtained", "Erhalten")
LANG_DE:addTranslation("upgrade to", "Upgrade zu %s")
LANG_DE:addTranslation("upgrades.Purchase", "Upgrades Kaufen")
LANG_DE:addTranslation("upgrades.PurchaseDesc", "Kann Upgrades erwerben.")
LANG_DE:addTranslation("upgrades.CantAfford", "Ihre Gang kann sich kein Upgrade leisten!")
LANG_DE:addTranslation("upgrades.TierPurchased", "Stufe gekauft")
LANG_DE:addTranslation("upgrades.MustPurchasePriorTier", "Muss eine frühere Stufe erwerben.")
LANG_DE:addTranslation("upgrades.MaxAssociations", "Max Associations")
LANG_DE:addTranslation("upgrades.MaxAssociationsDesc", "Maximale Anzahl von Assoziationen gleichzeitig")
LANG_DE:addTranslation("upgrades.AssociationsMax", "Sie haben die maximale Anzahl an Zuordnungen erreicht. Bitte aktualisieren Sie, um weitere hinzuzufügen! (%s)")
LANG_DE:addTranslation("upgrades.MaxBalance", "Max Balance")
LANG_DE:addTranslation("upgrades.MaxBalanceDesc", "Maximal zulässiger Kontostand")
LANG_DE:addTranslation("upgrades.BalanceMax", "Sie haben das maximale Guthaben erreicht. Bitte aktualisieren Sie, um mehr Speicherplatz hinzuzufügen! (%s)")
LANG_DE:addTranslation("upgrades.MaxStash", "Max Stash Items")
LANG_DE:addTranslation("upgrades.MaxStashDesc", "Maximal zulässiger Kontostand")
LANG_DE:addTranslation("upgrades.StashMax", "Sie haben die maximale Anzahl an Stash-Objekten erreicht. Bitte aktualisieren Sie, um mehr Speicherplatz hinzuzufügen! (%s)")
LANG_DE:addTranslation("upgrades.MaxTerritories", "Max Territories")
LANG_DE:addTranslation("upgrades.MaxTerritoriesDesc", "Maximale Anzahl von Gebieten, die gleichzeitig gehalten werden können")
LANG_DE:addTranslation("upgrades.TerritoryMax", "Sie haben die maximale Anzahl an Gebieten erreicht. Bitte aktualisieren Sie, um mehr Speicherplatz hinzuzufügen! (%s)")