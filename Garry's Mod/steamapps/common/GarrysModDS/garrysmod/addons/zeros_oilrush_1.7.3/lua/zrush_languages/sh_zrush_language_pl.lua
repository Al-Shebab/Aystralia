zrush = zrush || {}
zrush.language = zrush.language || {}
zrush.language.General = zrush.language.General || {}
zrush.language.NPC = zrush.language.NPC || {}
zrush.language.VCMOD = zrush.language.VCMOD || {}
zrush.language.DrillTower = zrush.language.DrillTower || {}
zrush.language.Pump = zrush.language.Pump || {}
zrush.language.Refinery = zrush.language.Refinery || {}
zrush.language.MachineCrate = zrush.language.MachineCrate || {}
zrush.language.VGUI = zrush.language.VGUI || {}
zrush.language.VGUI.DrillHole = zrush.language.VGUI.DrillHole || {}
zrush.language.VGUI.DrillTower = zrush.language.VGUI.DrillTower || {}
zrush.language.VGUI.Refinery = zrush.language.VGUI.Refinery || {}
zrush.language.VGUI.Burner = zrush.language.VGUI.Burner || {}
zrush.language.VGUI.Pump = zrush.language.VGUI.Pump || {}
zrush.language.VGUI.Barrel = zrush.language.VGUI.Barrel || {}
zrush.language.VGUI.NPC = zrush.language.VGUI.NPC || {}
zrush.language.Inv = zrush.language.Inv || {}
zrush.language.VGUI.MachineBuilder = zrush.language.VGUI.MachineBuilder || {}


if(zrush.config.selectedLanguage == "pl")then

    zrush.language.NPC["FuelBuyer"] = "Kupiec Paliwa"
    zrush.language.NPC["Profit"] = "Zysk:"
    zrush.language.NPC["YouSold"] = "Sprzedałeś, $Amount$UoM $Fuelname za $Earning$Currency"

    zrush.language.NPC["DialogTransactionComplete"] = "Dobrze jest robić z tobą interesy!"
    zrush.language.NPC["NoFuel"] = "Nie masz paliwa? To czemu zawracasz mi głowę?!"

    --Dopasuj sobie Dialogi NPC dla swoich potrzeb. Dialogi te pojawiają sie podczas sprzedawania paliwa u NPC
    zrush.language.NPC["Dialog00"] = "Sprawdzenie stanu domu jest ważne przed jego zakupem."
    zrush.language.NPC["Dialog01"] = "Mam w kieszeni kanapkę z pleśnią."
    zrush.language.NPC["Dialog02"] = "Choinki są przyczyną pleśni w domu."
    zrush.language.NPC["Dialog03"] = "Nie używaj wybielacza do usunięcia pleśni"
    zrush.language.NPC["Dialog04"] = "Chcesz zobaczyć moją kolekcje pleśni?"
    zrush.language.NPC["Dialog05"] = "Witamina D jest przydatna na alergie."
    zrush.language.NPC["Dialog06"] = "Pleśń powoduje choroby."
    zrush.language.NPC["Dialog07"] = "Pleśń nie osiądzie się na czystej powierzchni."
    zrush.language.NPC["Dialog08"] = "Martwe zarodniki pleśni są tak samo szkodliwe jak żywe."
    zrush.language.NPC["Dialog09"] = "Pleśń jest wykorzystywana w wojnie biologicznej."

    zrush.language.VCMOD["NeedMoreFuel"] = "Potrzebujesz co najmniej 20 litrów, aby napełnić kanister."

    zrush.language.General["AllreadyInUse"] = "Gotowy do użycia!"
    zrush.language.General["YouDontOwnThis"] = "Nie posiadasz tego przedmiotu!"
    zrush.language.General["NoDrillholeFound"] = "Nie znaleziono dziury do wykonania odwiertu"
    zrush.language.General["NoOilSpotFound"] = "Nie znaleziono beczki na rope!"
    zrush.language.General["OilSpotSpawner"] = "Ustaw źródło ropy"

    zrush.language.General["NoFreeSocketAvailable"] = "Brakuje tu miejsca!"

    zrush.language.DrillTower["AllreadyReachedOil"] = "Dokopałeś się do ropy!"
    zrush.language.DrillTower["DrillPipesMissing"] = "Brakuje rury wiertniczej!"

    zrush.language.Pump["OilSourceEmpty"] = "Źródło ropy naftowej jest puste!"
    zrush.language.Pump["MissingBarrel"] = "Brakuje beczki!"

    zrush.language.Refinery["MissingOilBarrel"] = "Brakuje beczki z ropą!"
    zrush.language.Refinery["MissingEmptyBarrel"] = "Brakuje pustej beczki!"
    zrush.language.VGUI.Refinery["IDLE"] = "Oczekiwanie"
    zrush.language.VGUI.Refinery["NEED_EMPTY_BARREL"] = "Brakuje pustej beczki na paliwo!"
    zrush.language.VGUI.Refinery["NEED_OIL_BARREL"] = "Potrzeba beczki z rope!"
    zrush.language.VGUI.Refinery["READY_FOR_WORK"] = "Gotowe do użycia"
    zrush.language.VGUI.Refinery["FUELBARREL_FULL"] = "Beczka z paliwem jest pełna!"
    zrush.language.VGUI.Refinery["REFINING"] = "Przetwarzanie ropy"
    zrush.language.VGUI.Refinery["OVERHEAT"] = "Rafineria się przegrzewa!"
    zrush.language.VGUI.Refinery["COOLED"] = "Rafineria została schłodzona!"

    zrush.language.MachineCrate["BuyMachine"] = "<Kup Przedmiot>"
    zrush.language.MachineCrate["Drill"] = "Wieża wiertnicza"
    zrush.language.MachineCrate["Burner"] = "Moduł wypalający"
    zrush.language.MachineCrate["Pump"] = "Pompa"
    zrush.language.MachineCrate["Refinery"] = "Rafineria"
    zrush.language.MachineCrate["Occupied"] = "Zajęte przez "

    zrush.language.VGUI.DrillHole["NEED_PIPES"] = "Musisz umieścić tu rure wiertniczą!"
    zrush.language.VGUI.DrillHole["NEED_BURNER"] = "Musisz tu umieścić moduł wypalajacy!"
    zrush.language.VGUI.DrillHole["HAS_BURNER"] = "Posiada moduł wypalajacy!"
    zrush.language.VGUI.DrillHole["NO_OIL"] = "Źródło ropy wyschło"

    zrush.language.VGUI.DrillTower["DrillTower"] = "Wierza wiertnicza"
    zrush.language.VGUI.DrillTower["NEED_PIPES"] = "Potrzeba rury wiertniczej!"
    zrush.language.VGUI.DrillTower["READY_FOR_WORK"] = "Gotowy do odwiertu"
    zrush.language.VGUI.DrillTower["IS_WORKING"] = "Wiercenie"
    zrush.language.VGUI.DrillTower["JAMMED"] = "Wiertło się zacięło!"
    zrush.language.VGUI.DrillTower["FINISHED_DRILLING"] = "Odwiert zakończony"

    zrush.language.VGUI.Burner["IDLE"] = "Oczekiwanie!"
    zrush.language.VGUI.Burner["BURNING_GAS"] = "Wypalanie gazu!"
    zrush.language.VGUI.Burner["OVERHEAT"] = "Moduł wypalajacy się przegrzewa!"
    zrush.language.VGUI.Burner["COOLED"] = "Moduł wypalajacy został schłodzony!"
    zrush.language.VGUI.Burner["NO_GAS_LEFT"] = "Brak gazu!"

    zrush.language.VGUI.Pump["NEED_BARREL"] = "Oczekiwanie na beczke"
    zrush.language.VGUI.Pump["PUMP_READY"] = "Gotowy do pompowania!"
    zrush.language.VGUI.Pump["PUMPING"] = "Pompowanie ropy"
    zrush.language.VGUI.Pump["BARREL_FULL"] = "Beczka z ropą jest pełna!"
    zrush.language.VGUI.Pump["JAMMED"] = "Pompa się zacieła!"
    zrush.language.VGUI.Pump["NO_OIL"] = "Źródło ropy jest puste"

    zrush.language.VGUI.Barrel["BarrelMenu"] = "Opcje beczki"
    zrush.language.VGUI.Barrel["BarrelMenuInfo"] = "*Możesz zatankować pojazd przy pomocy kanistra (VCMod)."
    zrush.language.VGUI.Barrel["BarrelFuelInfo"] = " Beczka"
    zrush.language.VGUI.Barrel["FuelAmount"] = "Ilość paliwa: "
    zrush.language.VGUI.Barrel["Collect"] = "Podnieś"
    zrush.language.VGUI.Barrel["SpawnVCModFuelCan"] = "Napełnij kanister $fueltype (VCMod)"

    zrush.language.VGUI.NPC["FuelBuyer"] = "Kupiec Paliwa "
    zrush.language.VGUI.NPC["Sell"] = "Sprzedaj"
    zrush.language.VGUI.NPC["SellAll"] = "Sprzedaj wszystko"
    zrush.language.VGUI.NPC["YourFuelInv"] = "Twój zapas Paliwa"
    zrush.language.VGUI.NPC["SaveInfo"] = "*Paliwo nie jest zapisywane po wyjściu z serwera! Upewnij się że sprzedałeś całe paliwo!"

    zrush.language.VGUI["TimeprePipe"] = "Czas przypadający na jedną rurę: "
    zrush.language.VGUI["PipesinQueue"] = "Oczekujące rury wiertnicze: "
    zrush.language.VGUI["NeededPipes"] = "Potrzeba rur wiertniczych: "
    zrush.language.VGUI["JamChance"] = "Szansa na popsucie maszyny: " // With Jam i mean like the machine breaking down

    zrush.language.VGUI["Speed"] = "Prędkość: "
    zrush.language.VGUI["BurnAmount"] = "Spalanie: "
    zrush.language.VGUI["RemainingGas"] = "Gaz: "
    zrush.language.VGUI["OverHeatChance"] =  "Szansa na przegrzanie: "

    zrush.language.VGUI["NA"] =  "NA" // This is the short version for "Not Available"

    zrush.language.VGUI["PumpAmount"] = "Cena pompy: "
    zrush.language.VGUI["BarrelOIL"] = "Beczka(Na rope): "
    zrush.language.VGUI["RemainingOil"] = "Ropa: "

    zrush.language.VGUI["Fuel"] = "Fuel: "
    zrush.language.VGUI["RefineAmount"] = "Rafinowanie: "
    zrush.language.VGUI["RefineOutput"] = "Rafinowanie wyjściowe: "
    zrush.language.VGUI["OverHeatChance"] = "Szansa przegrzania: "
    zrush.language.VGUI["BarrelFuel"] = "Beczka(Na paliwo): "

    zrush.language.VGUI["Status"] =  "Status: "
    zrush.language.VGUI["pipes"] =  "Dodatkowe rury: +"
    zrush.language.VGUI["BoostAmount"] =  "Zwiększona wydajność: "
    zrush.language.VGUI["FixMachinefirst"] = "Szybko napraw maszynę!"

    zrush.language.VGUI["Actions"] = "Akcje:"
    zrush.language.VGUI["Repair"] = "Napraw"
    zrush.language.VGUI["Stop"] = "Zatrzymaj"
    zrush.language.VGUI["Disassemble"] = "Zdemontuj"
    zrush.language.VGUI["Start"] = "Start"
    zrush.language.VGUI["CoolDown"] = "Chłodzenie"

    zrush.language.VGUI["ModuleShop"] = "Moduły"
    zrush.language.VGUI["Purchase"] = "Kup"
    zrush.language.VGUI["Sell"] = "Sprzedaj"
    zrush.language.VGUI["Locked"] = "Zablokowany"
    zrush.language.VGUI["NonSocketfound"] = "Nie znaleziono \nżadnych modułów !"
    zrush.language.VGUI["WrongUserGroup"] = "Zła grupa użytkownika! (UserGroup)"
    zrush.language.VGUI["WrongJob"] = "Zła praca!"
    zrush.language.VGUI["TooFarAway"] = "Jesteś za daleko!"
    zrush.language.VGUI["Youcannotafford"] = "Nie możesz wykonać tej czynności!"
    zrush.language.VGUI["allreadyinstalled"] = " zainstalowany!"
    zrush.language.VGUI["Youbougt"] =  "Kupiłeś $Name za $Price$Currency"
    zrush.language.VGUI["YouSold"] =  "Sprzedałeś $Name za $Price$Currency"

    zrush.language.VGUI["MachineShop"] = "Sklep z Maszynami"
    zrush.language.VGUI["Place"] = "Rozpakuj"

    zrush.language.VGUI.MachineBuilder["BuildEntity"] = " - Umieść przedmiot"
    zrush.language.VGUI.MachineBuilder["Cancel"] = " - Anuluj"
    zrush.language.VGUI.MachineBuilder["Needsdrilledfirst"]  = "Najpierw musisz to wywiercić!"
    zrush.language.VGUI.MachineBuilder["NeedsBurnerquick"]  = "Szybko! Potrzebujesz modułu wypalajacego!"
    zrush.language.VGUI.MachineBuilder["NeedsPump"]  = "Potrzebujesz Pompy!"
    zrush.language.VGUI.MachineBuilder["NotValidSpace"]  = "Brak dostępnej przestrzeni!"
    zrush.language.VGUI.MachineBuilder["ToocloseDrillHole"]  = "Zbyt blisko innego otworu wiertniczego!"
    zrush.language.VGUI.MachineBuilder["CanonlybuildGround"]  = "Umieść to na ziemi!"
    zrush.language.VGUI.MachineBuilder["CanonlybuildOilSpots"]  = "Możesz to postawić tylko na źródłach Ropy Naftowej!"
    zrush.language.VGUI.MachineBuilder["CanonlybuildDrillhole"]  = "Można to postawić tylko i wyłącznie na otworach wiertniczych!"
    zrush.language.VGUI.MachineBuilder["NotenoughSpace"]  = "Brak miejsca!"
    zrush.language.VGUI.MachineBuilder["ConnectionLost"]  = "Usunięto!"
    zrush.language.VGUI.MachineBuilder["ReachedMaxDrillhole"]  = "Osiągnięto limit!"

    zrush.language.Inv["InvEmpty"] = "Twój zapas paliwa jest pusty!"
    zrush.language.Inv["FuelInv"] = "Zapas Paliwa: "

    zrush.language.VGUI["speed"] = "Przyspieszenie prędkości"
    zrush.language.VGUI["production"] = "Zwiększenie produkcji"
    zrush.language.VGUI["antijam"] = "Moduł zapobiegający zacinaniu"
    zrush.language.VGUI["cooling"] = "Lepsze chłodzenie"
    zrush.language.VGUI["refining"] = "Zwiększenie wydajności"
    zrush.language.VGUI["pipes"] = "Dodatkowe rury"

    zrush.language.VGUI.MachineBuilder["MachineLimitReached"] = "Osiągnięto limit maszyny!"    
end
