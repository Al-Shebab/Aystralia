zrush = zrush || {}
zrush.language = zrush.language || {}

if (zrush.config.selectedLanguage == "pl") then
    zrush.language["Profit"] = "Zysk:"
    zrush.language["YouSoldFuel"] = "Sprzedałeś, $Amount$UoM $Fuelname za $Earning$Currency"
    zrush.language["DialogTransactionComplete"] = "Dobrze jest robić z tobą interesy!"
    zrush.language["NoFuel"] = "Nie masz paliwa? To czemu zawracasz mi głowę?!"
    zrush.language["Dialog00"] = "Sprawdzenie stanu domu jest ważne przed jego zakupem."
    zrush.language["Dialog01"] = "Mam w kieszeni kanapkę z pleśnią."
    zrush.language["Dialog02"] = "Choinki są przyczyną pleśni w domu."
    zrush.language["Dialog03"] = "Nie używaj wybielacza do usunięcia pleśni"
    zrush.language["Dialog04"] = "Chcesz zobaczyć moją kolekcje pleśni?"
    zrush.language["Dialog05"] = "Witamina D jest przydatna na alergie."
    zrush.language["Dialog06"] = "Pleśń powoduje choroby."
    zrush.language["Dialog07"] = "Pleśń nie osiądzie się na czystej powierzchni."
    zrush.language["Dialog08"] = "Martwe zarodniki pleśni są tak samo szkodliwe jak żywe."
    zrush.language["Dialog09"] = "Pleśń jest wykorzystywana w wojnie biologicznej."
    zrush.language["NeedMoreFuel"] = "Potrzebujesz co najmniej 20 litrów, aby napełnić kanister."
    zrush.language["AllreadyInUse"] = "Gotowy do użycia!"
    zrush.language["YouDontOwnThis"] = "Nie posiadasz tego przedmiotu!"
    zrush.language["NoDrillholeFound"] = "Nie znaleziono dziury do wykonania odwiertu"
    zrush.language["NoOilSpotFound"] = "Nie znaleziono beczki na rope!"
    zrush.language["OilSpotSpawner"] = "Ustaw źródło ropy"
    zrush.language["NoFreeSocketAvailable"] = "Brakuje tu miejsca!"
    zrush.language["AllreadyReachedOil"] = "Dokopałeś się do ropy!"
    zrush.language["DrillPipesMissing"] = "Brakuje rury wiertniczej!"
    zrush.language["OilSourceEmpty"] = "Źródło ropy naftowej jest puste!"
    zrush.language["MissingBarrel"] = "Brakuje beczki!"
    zrush.language["MissingOilBarrel"] = "Brakuje beczki z ropą!"
    zrush.language["MissingEmptyBarrel"] = "Brakuje pustej beczki!"
    zrush.language["BuyMachine"] = "<Kup Przedmiot>"
    zrush.language["Drill"] = "Wieża wiertnicza"
    zrush.language["Burner"] = "Moduł wypalający"
    zrush.language["Pump"] = "Pompa"
    zrush.language["Refinery"] = "Rafineria"

    zrush.language["IDLE"] = "Oczekiwanie"
    zrush.language["NEED_EMPTY_BARREL"] = "Brakuje pustej beczki na paliwo!"
    zrush.language["NEED_OIL_BARREL"] = "Potrzeba beczki z rope!"
    zrush.language["FUELBARREL_FULL"] = "Beczka z paliwem jest pełna!"
    zrush.language["IS_REFINING"] = "Przetwarzanie ropy"
    zrush.language["NEED_BURNER"] = "Musisz tu umieścić moduł wypalajacy!"
    zrush.language["HAS_BURNER"] = "Posiada moduł wypalajacy!"
    zrush.language["NO_OIL"] = "Źródło ropy wyschło"
    zrush.language["DrillTower"] = "Wierza wiertnicza"
    zrush.language["NEED_PIPES"] = "Potrzeba rury wiertniczej!"
    zrush.language["IS_DRILLING"] = "Wiercenie"
    zrush.language["FINISHED_DRILLING"] = "Odwiert zakończony"
    zrush.language["BURNING_GAS"] = "Wypalanie gazu!"
    zrush.language["NO_GAS_LEFT"] = "Brak gazu!"
    zrush.language["NEED_BARREL"] = "Oczekiwanie na beczke"
    zrush.language["PUMP_READY"] = "Gotowy do pompowania!"
    zrush.language["PUMPING"] = "Pompowanie ropy"
    zrush.language["BARREL_FULL"] = "Beczka z ropą jest pełna!"
    zrush.language["BarrelMenu"] = "Opcje beczki"
    zrush.language["BarrelMenuInfo"] = "*Możesz zatankować pojazd przy pomocy kanistra (VCMod)."

    zrush.language["FuelAmount"] = "Ilość paliwa: "
    zrush.language["Collect"] = "Podnieś"
    zrush.language["SpawnVCModFuelCan"] = "Napełnij kanister $fueltype (VCMod)"
    zrush.language["FuelBuyer"] = "Kupiec Paliwa "
    zrush.language["Sell"] = "Sprzedaj"
    zrush.language["YourFuelInv"] = "Twój zapas Paliwa"
    zrush.language["SaveInfo"] = "*Paliwo nie jest zapisywane po wyjściu z serwera! Upewnij się że sprzedałeś całe paliwo!"
    zrush.language["TimeprePipe"] = "Czas przypadający na jedną rurę: "
    zrush.language["PipesinQueue"] = "Oczekujące rury wiertnicze: "
    zrush.language["NeededPipes"] = "Potrzeba rur wiertniczych: "
    zrush.language["JamChance"] = "Szansa na popsucie maszyny: " // With Jam i mean like the machine breaking down
    zrush.language["Speed"] = "Prędkość: "
    zrush.language["BurnAmount"] = "Spalanie: "
    zrush.language["RemainingGas"] = "Gaz: "
    zrush.language["OverHeatChance"] =  "Szansa na przegrzanie: "
    zrush.language["NA"] =  "NA" // This is the short version for "Not Available"
    zrush.language["PumpAmount"] = "Cena pompy: "
    zrush.language["BarrelOIL"] = "Beczka(Na rope): "
    zrush.language["RemainingOil"] = "Ropa: "
    zrush.language["Fuel"] = "Fuel: "
    zrush.language["RefineAmount"] = "Rafinowanie: "
    zrush.language["RefineOutput"] = "Rafinowanie wyjściowe: "
    zrush.language["BarrelFuel"] = "Beczka(Na paliwo): "
    zrush.language["Status"] =  "Status: "
    zrush.language["FixMachinefirst"] = "Szybko napraw maszynę!"

    zrush.language["Actions"] = "Akcje:"
    zrush.language["Repair"] = "Napraw"
    zrush.language["Stop"] = "Zatrzymaj"
    zrush.language["Disassemble"] = "Zdemontuj"
    zrush.language["Start"] = "Start"
    zrush.language["CoolDown"] = "Chłodzenie"
    zrush.language["ModuleShop"] = "Moduły"
    zrush.language["Purchase"] = "Kup"
    zrush.language["Locked"] = "Zablokowany"
    zrush.language["NonSocketfound"] = "Nie znaleziono \nżadnych modułów !"
    zrush.language["WrongUserGroup"] = "Zła grupa użytkownika! (UserGroup)"
    zrush.language["WrongJob"] = "Zła praca!"
    zrush.language["TooFarAway"] = "Jesteś za daleko!"
    zrush.language["Youcannotafford"] = "Nie możesz wykonać tej czynności!"
    zrush.language["allreadyinstalled"] = " zainstalowany!"
    zrush.language["Youbougt"] =  "Kupiłeś $Name za $Price$Currency"
    zrush.language["YouSold"] =  "Sprzedałeś $Name za $Price$Currency"
    zrush.language["MachineShop"] = "Sklep z Maszynami"
    zrush.language["Place"] = "Rozpakuj"
    zrush.language["BuildEntity"] = "Umieść przedmiot"
    zrush.language["Cancel"] = "Anuluj"

    zrush.language["Needsdrilledfirst"]  = "Najpierw musisz to wywiercić!"
    zrush.language["NeedsBurnerquick"]  = "Szybko! Potrzebujesz modułu wypalajacego!"
    zrush.language["NeedsPump"]  = "Potrzebujesz Pompy!"
    zrush.language["NotValidSpace"]  = "Brak dostępnej przestrzeni!"
    zrush.language["ToocloseDrillHole"]  = "Zbyt blisko innego otworu wiertniczego!"
    zrush.language["CanonlybuildGround"]  = "Umieść to na ziemi!"
    zrush.language["CanonlybuildOilSpots"]  = "Możesz to postawić tylko na źródłach Ropy Naftowej!"
    zrush.language["CanonlybuildDrillhole"]  = "Można to postawić tylko i wyłącznie na otworach wiertniczych!"
    zrush.language["NotenoughSpace"]  = "Brak miejsca!"
    zrush.language["ConnectionLost"]  = "Usunięto!"
    zrush.language["ReachedMaxDrillhole"]  = "Osiągnięto limit!"
    zrush.language["InvEmpty"] = "Twój zapas paliwa jest pusty!"
    zrush.language["FuelInv"] = "Zapas Paliwa: "

    zrush.language["speed"] = "Przyspieszenie prędkości"
    zrush.language["production"] = "Zwiększenie produkcji"
    zrush.language["antijam"] = "Moduł zapobiegający zacinaniu"
    zrush.language["cooling"] = "Lepsze chłodzenie"
    zrush.language["refining"] = "Zwiększenie wydajności"
    zrush.language["pipes"] = "Dodatkowe rury"

    zrush.language["MachineLimitReached"] = "Osiągnięto limit maszyny!"

    // UPDATE 2.0.0
    zrush.language["Restriction"] = "Ograniczenie:"
    zrush.language["InventoryFull"] = "Pełny magazyn!"
    zrush.language["READY_FOR_WORK"] = "Maszyna gotowa!"
    zrush.language["OVERHEAT"] = "Maszyna się przegrzewa!"
    zrush.language["COOLED"] = "Maszyna została schłodzona!"
    zrush.language["JAMMED"] = "Maszyna się zacięła!"
end
