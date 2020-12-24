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


if(zrush.config.selectedLanguage == "hu")then

    zrush.language.NPC["FuelBuyer"] = "Üzemanyag vásárló"
    zrush.language.NPC["Profit"] = "Profit:"
    zrush.language.NPC["YouSold"] = "Eladtál $Amount$UoM értékben $Fuelname -t, $Earning$Currency -ért"

    zrush.language.NPC["DialogTransactionComplete"] = "Remek volt üzletet kötni!"
    zrush.language.NPC["NoFuel"] = "Nincs üzem anyagod, miért vagy még itt?!"

    zrush.language.NPC["Dialog00"] = "A penészgomba vizsgálatok fontosak otthon vásárlásakor."
    zrush.language.NPC["Dialog01"] = "Van egy penészgombás szendvics a zsebemben,"
    zrush.language.NPC["Dialog02"] = "A karácsonyfák allergiákat okoznak a penész miatt."
    zrush.language.NPC["Dialog03"] = "A fehérítőt spriccelni a penészre nem javasolt"
    zrush.language.NPC["Dialog04"] = "Van egy penészgomba gyűjteményem, akarod látni??"
    zrush.language.NPC["Dialog05"] = "Vitamin D étrendkiegészítők segítik a harcot a penészgomba allergia ellen."
    zrush.language.NPC["Dialog06"] = "A penész kiütéseket okoz."
    zrush.language.NPC["Dialog07"] = "A penész nem eszi meg a Happy Mealt."
    zrush.language.NPC["Dialog08"] = "A halott spórák ugyanolyan ártalmasak, mint az élő spórák."
    zrush.language.NPC["Dialog09"] = "A penész egy biológiai fegyver."

    zrush.language.VCMOD["NeedMoreFuel"] = "Legalább 20literre lesz szükséged hogy megtölsd a kannát!"

    zrush.language.General["AllreadyInUse"] = "Már használatban van!"
    zrush.language.General["YouDontOwnThis"] = "Ez nem a tiéd!"
    zrush.language.General["NoDrillholeFound"] = "Nincs szabad fúró lyuk!"
    zrush.language.General["NoOilSpotFound"] = "Nem található olaj terület."
    zrush.language.General["OilSpotSpawner"] = "Olajterület készítő"

    zrush.language.General["NoFreeSocketAvailable"] = "Nincs ingyenes csatlakozó!"

    zrush.language.DrillTower["AllreadyReachedOil"] = "Már elérted az olajat!"
    zrush.language.DrillTower["DrillPipesMissing"] = "Hiányzó Fúrócsövek!"

    zrush.language.Pump["OilSourceEmpty"] = "Az olajforrás üres!"
    zrush.language.Pump["MissingBarrel"] = "Hiányzó hordó!"

    zrush.language.Refinery["MissingOilBarrel"] = "Hiányzó olaj hordó!"
    zrush.language.Refinery["MissingEmptyBarrel"] = "Hiányzó üreshordó!"
    zrush.language.VGUI.Refinery["IDLE"] = "Várakozás"
    zrush.language.VGUI.Refinery["NEED_EMPTY_BARREL"] = "Hordó szükséges!"
    zrush.language.VGUI.Refinery["NEED_OIL_BARREL"] = "Olajhordó szükséges!"
    zrush.language.VGUI.Refinery["READY_FOR_WORK"] = "Készen áll a finomításra."
    zrush.language.VGUI.Refinery["FUELBARREL_FULL"] = "Üzemanyagtartály tele van!"
    zrush.language.VGUI.Refinery["REFINING"] = "Olajfinomítás."
    zrush.language.VGUI.Refinery["OVERHEAT"] = "A finomító túlmelegszik!"
    zrush.language.VGUI.Refinery["COOLED"] = "A finomító hűtött!"

    zrush.language.MachineCrate["BuyMachine"] = "<Gép vásárlása>"
    zrush.language.MachineCrate["Drill"] = "Fúró"
    zrush.language.MachineCrate["Burner"] = "Égető"
    zrush.language.MachineCrate["Pump"] = "Szivattyú"
    zrush.language.MachineCrate["Refinery"] = "Finomító"
    zrush.language.MachineCrate["Occupied"] = "Foglalt."

    zrush.language.VGUI.DrillHole["NEED_PIPES"] = "Szükség van egy fúróra!"
    zrush.language.VGUI.DrillHole["NEED_BURNER"] = "Szükség van égetőre!"
    zrush.language.VGUI.DrillHole["HAS_BURNER"] = "Már van égető!"
    zrush.language.VGUI.DrillHole["NO_OIL"] = "Olaj forrás üres"

    zrush.language.VGUI.DrillTower["DrillTower"] = "Fúró torony"
    zrush.language.VGUI.DrillTower["NEED_PIPES"] = "Nincsenek fúró cövek!"
    zrush.language.VGUI.DrillTower["READY_FOR_WORK"] = "Készenáll a fúrásra."
    zrush.language.VGUI.DrillTower["IS_WORKING"] = "Fúrás folyamatban."
    zrush.language.VGUI.DrillTower["JAMMED"] = "A fúró elakadt!"
    zrush.language.VGUI.DrillTower["FINISHED_DRILLING"] = "Kész fúrás."

    zrush.language.VGUI.Burner["IDLE"] = "Várj!"
    zrush.language.VGUI.Burner["BURNING_GAS"] = "Égő gáz!"
    zrush.language.VGUI.Burner["OVERHEAT"] = "Az égő túlmelegszik!"
    zrush.language.VGUI.Burner["COOLED"] = "Az égő hűtött!"
    zrush.language.VGUI.Burner["NO_GAS_LEFT"] = "Nem maradt gáz!"

    zrush.language.VGUI.Pump["NEED_BARREL"] = "Várakozás egy hordóra."
    zrush.language.VGUI.Pump["PUMP_READY"] = "Készen áll a szivattyúra!"
    zrush.language.VGUI.Pump["PUMPING"] = "Olaj szivattyúzása."
    zrush.language.VGUI.Pump["BARREL_FULL"] = "Az olajoshordó megtelt!"
    zrush.language.VGUI.Pump["JAMMED"] = "A szivattyú elakadt!"
    zrush.language.VGUI.Pump["NO_OIL"] = "Olaj forrás üres."

    zrush.language.VGUI.Barrel["BarrelMenu"] = "Hordó Menü"
    zrush.language.VGUI.Barrel["BarrelMenuInfo"] = "*Ez feltölti a VCMod kannát."
    zrush.language.VGUI.Barrel["BarrelFuelInfo"] = " Hordó"
    zrush.language.VGUI.Barrel["FuelAmount"] = "Mennyiség: "
    zrush.language.VGUI.Barrel["Collect"] = "Begyüjtés"
    zrush.language.VGUI.Barrel["SpawnVCModFuelCan"] = "VCMod $fueltype \nkanna létrehozása"

    zrush.language.VGUI.NPC["FuelBuyer"] = "Üzemanyag vásárló"
    zrush.language.VGUI.NPC["Sell"] = "Eladás."
    zrush.language.VGUI.NPC["SellAll"] = "Mind eladása."
    zrush.language.VGUI.NPC["YourFuelInv"] = "Üzemanyagkészlet"
    zrush.language.VGUI.NPC["SaveInfo"] = "*Ez nem kerül mentésre, mielőtt kilépnél add el az üzemanyagot!"

    zrush.language.VGUI["TimeprePipe"] = "Idő per szivattyú: "
    zrush.language.VGUI["PipesinQueue"] = "Szivattyúin sorba állítás: "
    zrush.language.VGUI["NeededPipes"] = "Szükséges szivattyúk : "
    zrush.language.VGUI["JamChance"] = "Meghibásodási arány: " // mint a gép tönkremegy

    zrush.language.VGUI["Speed"] = "Sebesség: "
    zrush.language.VGUI["BurnAmount"] = "Égés összege: "
    zrush.language.VGUI["RemainingGas"] = "Fennmaradó gáz: "
    zrush.language.VGUI["OverHeatChance"] =  "Túlmelegedés esély: "

    zrush.language.VGUI["NA"] =  "NA" // Rövídítés ha nem elérhető

    zrush.language.VGUI["PumpAmount"] = "Szivattyú mennyiség: "
    zrush.language.VGUI["BarrelOIL"] = "Hordó(OLAJ): "
    zrush.language.VGUI["RemainingOil"] = "Maradék olaj: "

    zrush.language.VGUI["Fuel"] = "Üzemanyag: "
    zrush.language.VGUI["RefineAmount"] = "Finomítás összeg: "
    zrush.language.VGUI["RefineOutput"] = "Finomítás kimenet: "
    zrush.language.VGUI["OverHeatChance"] = "Túlmelegedés esélye: "
    zrush.language.VGUI["BarrelFuel"] = "Hordó(ÜZEMANYAG): "

    zrush.language.VGUI["Status"] =  "Állapot: "
    zrush.language.VGUI["pipes"] =  "Extra szivattyúk: +"
    zrush.language.VGUI["BoostAmount"] =  "Túltöltés mennyisége: "
    zrush.language.VGUI["FixMachinefirst"] = "Javítsd ki először a gépet!"

    zrush.language.VGUI["Actions"] = "Műveletek:"
    zrush.language.VGUI["Repair"] = "Javítás"
    zrush.language.VGUI["Stop"] = "Leállítás"
    zrush.language.VGUI["Disassemble"] = "Szétszerelés"
    zrush.language.VGUI["Start"] = "Rajt"
    zrush.language.VGUI["CoolDown"] = "Lehűtés"

    zrush.language.VGUI["ModuleShop"] = "Kiegészítő bolt"
    zrush.language.VGUI["Purchase"] = "Vásárlás"
    zrush.language.VGUI["Sell"] = "Eladás"
    zrush.language.VGUI["Locked"] = "Zárva"
    zrush.language.VGUI["NonSocketfound"] = "Nem található \nszabad foglalat!"
    zrush.language.VGUI["WrongUserGroup"] = "Rossz felhasznló csoport!"
    zrush.language.VGUI["WrongJob"] = "Rossz munka!"
    zrush.language.VGUI["TooFarAway"] = "You are too far aways from the Entity!"
    zrush.language.VGUI["Youcannotafford"] = "Nem tudod megvenni!"
    zrush.language.VGUI["allreadyinstalled"] = " már telepítve!"
    zrush.language.VGUI["Youbougt"] =  "Vettél $Name -t $Price$Currency -ért!"
    zrush.language.VGUI["YouSold"] =  "Eladtál $Name -t $Price$Currency -ért!"

    zrush.language.VGUI["MachineShop"] = "Gép Bolt"
    zrush.language.VGUI["Place"] = "Hely"

    zrush.language.VGUI.MachineBuilder["BuildEntity"] = " - Megépítés"
    zrush.language.VGUI.MachineBuilder["Cancel"] = " - Mégse"
    zrush.language.VGUI.MachineBuilder["Needsdrilledfirst"]  = "Először ki kell fúrni!"
    zrush.language.VGUI.MachineBuilder["NeedsBurnerquick"]  = "Az égõre van gyorsan szükség!"
    zrush.language.VGUI.MachineBuilder["NeedsPump"]  = "Szivattyúra van szükség!"
    zrush.language.VGUI.MachineBuilder["NotValidSpace"]  = "Nem megfelelő hely"
    zrush.language.VGUI.MachineBuilder["ToocloseDrillHole"]  = "Túl közel van egy másik lyukhoz!"
    zrush.language.VGUI.MachineBuilder["CanonlybuildGround"]  = "Csak földre építheted!"
    zrush.language.VGUI.MachineBuilder["CanonlybuildOilSpots"]  = "Csak olaj lelő helyre építheted!"
    zrush.language.VGUI.MachineBuilder["CanonlybuildDrillhole"]  = "Csak fúrólyukra építhető!"
    zrush.language.VGUI.MachineBuilder["NotenoughSpace"]  = "Nincs elég hely!"
    zrush.language.VGUI.MachineBuilder["ConnectionLost"]  = "Elvesztett kapcsolat!"
    zrush.language.VGUI.MachineBuilder["ReachedMaxDrillhole"]  = "Elérted a maximális lyukak számát!"

    zrush.language.Inv["InvEmpty"] = "Az üzemanyag-készlet megtelt!"
    zrush.language.Inv["FuelInv"] = "Üzemanyag-készlet: "

    zrush.language.VGUI["speed"] = "Gyorsítás"
    zrush.language.VGUI["production"] = "Termelés túltöltés"
    zrush.language.VGUI["antijam"] = "Meghibásodás gátló"
    zrush.language.VGUI["cooling"] = "Hűtési túltöltés"
    zrush.language.VGUI["refining"] = "Finomítás túltöltés"
    zrush.language.VGUI["pipes"] = "Extra szivattyúk"

    zrush.language.VGUI.MachineBuilder["MachineLimitReached"] = "A gép korlátja elérte!"

end
