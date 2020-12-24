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


if(zrush.config.selectedLanguage == "de")then

    zrush.language.NPC["FuelBuyer"] = "Treibstoff Käufer"
    zrush.language.NPC["Profit"] = "Profit:"
    zrush.language.NPC["YouSold"] = "Du hast $Amount$UoM $Fuelname für $Earning$Currency verkauft!"

    zrush.language.NPC["DialogTransactionComplete"] = "Schön mit dir Geschäfte zu machen!"
    zrush.language.NPC["NoFuel"] = "Du hast gar keinen Treibstoff, wieso bist du hier?!"

    zrush.language.NPC["Dialog00"] = "Schimmelinspektionen sind wichtig beim Kauf eines Hauses."
    zrush.language.NPC["Dialog01"] = "Ich habe ein Sandwich in meiner Tasche, mit Schimmel drauf."
    zrush.language.NPC["Dialog02"] = "Weihnachtsbäume verursachen Allergien wegen Schimmel."
    zrush.language.NPC["Dialog03"] = "Bleichmittel auf Schimmel zu sprühen wird nicht empfohlen."
    zrush.language.NPC["Dialog04"] = "Ich habe eine Schimmel kollektion, willst du sie sehen?"
    zrush.language.NPC["Dialog05"] = "Vitamin D Supplements helfen Schimmelpilzallergien zu bekämpfen."
    zrush.language.NPC["Dialog06"] = "Schimmel verursacht Hautausschläge."
    zrush.language.NPC["Dialog07"] = "Schimmel kann nicht auf Happy Meals wachsen."
    zrush.language.NPC["Dialog08"] = "Tote Schimmelpilzsporen sind genauso schädlich wie lebende Sporen."
    zrush.language.NPC["Dialog09"] = "Schimmel wird in der biologischen Kriegsführung verwendet."

    zrush.language.VGUI.NPC["FuelBuyer"] = "Treibstoff Käufer "
    zrush.language.VGUI.NPC["Sell"] = "Verkaufe"
    zrush.language.VGUI.NPC["SellAll"] = "Alles Verkaufen"
    zrush.language.VGUI.NPC["YourFuelInv"] = "Dein Treibstoff Inventar"
    zrush.language.VGUI.NPC["SaveInfo"] = "*Dieses Inventar wird nicht gepeichert! Verkaufe deinen Treibstoff bevor du den Server verlässt!"

    zrush.language.VCMOD["NeedMoreFuel"] = "Du brauchst mindestdens 20l Treibstoff um ihn in ein Fass zu füllen!"

    zrush.language.General["AllreadyInUse"] = "Wird bereits von jemanden benutzt!"
    zrush.language.General["YouDontOwnThis"] = "Das gehört nicht dir!"
    zrush.language.General["NoDrillholeFound"] = "Kein freies Bohrloch gefunden!"
    zrush.language.General["NoOilSpotFound"] = "Keine Ölquelle gefunden!"
    zrush.language.General["OilSpotSpawner"] = "Ölquellen Spawner"

    zrush.language.General["NoFreeSocketAvailable"] = "Keinen freien Steckplatz gefunden!"

    zrush.language.DrillTower["AllreadyReachedOil"] = "Du hast bereits das Öl erreicht!"
    zrush.language.DrillTower["DrillPipesMissing"] = "Bohrrohre benötigt!"

    zrush.language.Pump["OilSourceEmpty"] = "Ölquelle ist verbraucht!"
    zrush.language.Pump["MissingBarrel"] = "Fass benötigt!"

    zrush.language.Refinery["MissingOilBarrel"] = "Ölfass benötigt!"
    zrush.language.Refinery["MissingEmptyBarrel"] = "Leeres Fass benötigt!"
    zrush.language.VGUI.Refinery["IDLE"] = "Warte"
    zrush.language.VGUI.Refinery["NEED_EMPTY_BARREL"] = "Leeres Fass für Treibstoff benötigt!"
    zrush.language.VGUI.Refinery["NEED_OIL_BARREL"] = "Öl Fass beötigt"
    zrush.language.VGUI.Refinery["READY_FOR_WORK"] = "Betriebsbereit"
    zrush.language.VGUI.Refinery["FUELBARREL_FULL"] = "Treibstoff Fass ist voll!"
    zrush.language.VGUI.Refinery["REFINING"] = "Verarbeite Öl"
    zrush.language.VGUI.Refinery["OVERHEAT"] = "Raffinerie ist am Überhitzen!"
    zrush.language.VGUI.Refinery["COOLED"] = "Raffinerie wurde gekühlt!"

    zrush.language.MachineCrate["BuyMachine"] = "<Maschine kaufen>"
    zrush.language.MachineCrate["Drill"] = "Bohrer"
    zrush.language.MachineCrate["Burner"] = "Gasbrenner"
    zrush.language.MachineCrate["Pump"] = "Pumpe"
    zrush.language.MachineCrate["Refinery"] = "Raffinerie"
    zrush.language.MachineCrate["Occupied"] = "Benutzt von "

    zrush.language.VGUI.DrillHole["NEED_PIPES"] = "Braucht einen Bohrer!"
    zrush.language.VGUI.DrillHole["NEED_BURNER"] = "Braucht einen Gasbrenner!"
    zrush.language.VGUI.DrillHole["HAS_BURNER"] = "Hat einen Gasbrenner!"
    zrush.language.VGUI.DrillHole["NO_OIL"] = "Ölquelle leer!"

    zrush.language.VGUI.DrillTower["DrillTower"] = "BohrTurm"
    zrush.language.VGUI.DrillTower["NEED_PIPES"] = "Bohrrohre benötigt!"
    zrush.language.VGUI.DrillTower["READY_FOR_WORK"] = "Bereit zum Bohren!"
    zrush.language.VGUI.DrillTower["IS_WORKING"] = "Bohre"
    zrush.language.VGUI.DrillTower["JAMMED"] = "Bohrer beschätigt!"
    zrush.language.VGUI.DrillTower["FINISHED_DRILLING"] = "Bohrung beendet"

    zrush.language.VGUI.Burner["IDLE"] = "Warte"
    zrush.language.VGUI.Burner["BURNING_GAS"] = "Verbrenne Gas!"
    zrush.language.VGUI.Burner["OVERHEAT"] = "Gasbrenner ist am überhitzen!"
    zrush.language.VGUI.Burner["COOLED"] = "Gasbrenner wurde gekühlt!"
    zrush.language.VGUI.Burner["NO_GAS_LEFT"] = "Gas fertig gebrennt"

    zrush.language.VGUI.Pump["NEED_BARREL"] = "Fass benötigt!"
    zrush.language.VGUI.Pump["PUMP_READY"] = "Bereit zum pumpen!"
    zrush.language.VGUI.Pump["PUMPING"] = "Pumpe Öl"
    zrush.language.VGUI.Pump["BARREL_FULL"] = "Öl Fass ist Voll!"
    zrush.language.VGUI.Pump["JAMMED"] = "Pumpe ist beschädigt!"
    zrush.language.VGUI.Pump["NO_OIL"] = "Ölquelle leer!"

    zrush.language.VGUI.Barrel["BarrelMenu"] = "Fass Menü"
    zrush.language.VGUI.Barrel["BarrelMenuInfo"] = "*Treibstoff in VCMod Kanister füllen."
    zrush.language.VGUI.Barrel["BarrelFuelInfo"] = " Fass"
    zrush.language.VGUI.Barrel["FuelAmount"] = "Treibstoff Menge: "
    zrush.language.VGUI.Barrel["Collect"] = "Aufsammeln"
    zrush.language.VGUI.Barrel["SpawnVCModFuelCan"] = "Spawne VCMod $fueltype Kanister"

    zrush.language.VGUI["TimeprePipe"] = "Zeit pro Rohr: "
    zrush.language.VGUI["PipesinQueue"] = "Rohre in Warteschlange: "
    zrush.language.VGUI["NeededPipes"] = "Benötigte Rohre: "
    zrush.language.VGUI["JamChance"] = "Beschädigungs Chance: " // With Jam i mean like the machine breaking down

    zrush.language.VGUI["Speed"] = "Geschwindigkeit: "
    zrush.language.VGUI["BurnAmount"] = "Brenn Menge: "
    zrush.language.VGUI["RemainingGas"] = "Verbleibendes Gas: "
    zrush.language.VGUI["OverHeatChance"] =  "Überhitzungs Chance: "

    zrush.language.VGUI["NA"] =  "NA" // This is the short version for "Not Available"

    zrush.language.VGUI["PumpAmount"] = "Pump Menge: "
    zrush.language.VGUI["BarrelOIL"] = "Fass(Öl): "
    zrush.language.VGUI["RemainingOil"] = "Verbleibendes Öl: "

    zrush.language.VGUI["Fuel"] = "Treibstoff: "
    zrush.language.VGUI["RefineAmount"] = "Raffinierungs Menge: "
    zrush.language.VGUI["RefineOutput"] = "Raffinierungs Ausgabe: "
    zrush.language.VGUI["OverHeatChance"] = "Überhitzungs Chance: "
    zrush.language.VGUI["BarrelFuel"] = "Fass(Treibstoff): "

    zrush.language.VGUI["Status"] =  "Status: "
    zrush.language.VGUI["pipes"] =  "ExtraRohre: +"
    zrush.language.VGUI["BoostAmount"] =  "BoostMenge: "
    zrush.language.VGUI["FixMachinefirst"] = "Repariere die Maschine schnell!"

    zrush.language.VGUI["Actions"] = "Aktionen:"
    zrush.language.VGUI["Repair"] = "Reparieren"
    zrush.language.VGUI["Stop"] = "Stop"
    zrush.language.VGUI["Disassemble"] = "Abbauen"
    zrush.language.VGUI["Start"] = "Start"
    zrush.language.VGUI["CoolDown"] = "Abkühlen"

    zrush.language.VGUI["ModuleShop"] = "Modul Shop"
    zrush.language.VGUI["Purchase"] = "Kaufen"
    zrush.language.VGUI["Sell"] = "Verkaufen"
    zrush.language.VGUI["Locked"] = "Gesperrt"
    zrush.language.VGUI["NonSocketfound"] = "Kein freier \nPlatz gefunden!"
    zrush.language.VGUI["WrongUserGroup"] = "Falscher Rang!"
    zrush.language.VGUI["WrongJob"] = "Falscher Job!"
    zrush.language.VGUI["TooFarAway"] = "You are too far aways from the Entity!"
    zrush.language.VGUI["Youcannotafford"] = "Das kannst du dir nicht leisten!"
    zrush.language.VGUI["allreadyinstalled"] = " bereits installiert!"
    zrush.language.VGUI["Youbougt"] =  "Du hast ein $Name für $Price$Currency gekauft!"
    zrush.language.VGUI["YouSold"] =  "Du hast ein $Name für $Price$Currency verkauft!"

    zrush.language.VGUI["MachineShop"] = "Maschinen Shop"
    zrush.language.VGUI["Place"] = "Platzieren"

    zrush.language.VGUI.MachineBuilder["BuildEntity"] = " - Bauen"
    zrush.language.VGUI.MachineBuilder["Cancel"] = " - Abbrechen"
    zrush.language.VGUI.MachineBuilder["Needsdrilledfirst"]  = "Das muss zuerst gebohrt werden!"
    zrush.language.VGUI.MachineBuilder["NeedsBurnerquick"]  = "Gasbrenner benötigt!"
    zrush.language.VGUI.MachineBuilder["NeedsPump"]  = "Pumpe benötigt!"
    zrush.language.VGUI.MachineBuilder["NotValidSpace"]  = "Kein gültiger Bereich!"
    zrush.language.VGUI.MachineBuilder["ToocloseDrillHole"]  = "Zu nahe an einem anderen Bohrloch!"
    zrush.language.VGUI.MachineBuilder["CanonlybuildGround"]  = "Kann nur auf dem Boden gebaut werden!"
    zrush.language.VGUI.MachineBuilder["CanonlybuildOilSpots"]  = "Kann nur auf Ölquellen gebaut werden!"
    zrush.language.VGUI.MachineBuilder["CanonlybuildDrillhole"]  = "Kann nur auf Bohrlöcher gebaut werden!"
    zrush.language.VGUI.MachineBuilder["NotenoughSpace"]  = "Nicht genug Platz!"
    zrush.language.VGUI.MachineBuilder["ConnectionLost"]  = "Verbindung getrennt!"
    zrush.language.VGUI.MachineBuilder["ReachedMaxDrillhole"]  = "Max Bohrloch Anzahl erreicht!"

    zrush.language.Inv["InvEmpty"] = "Dein Treibstoff Inventar ist Leer!"
    zrush.language.Inv["FuelInv"] = "Treibstoff Inventar: "

    zrush.language.VGUI["speed"] = "Geschwindigkeits Boost"
    zrush.language.VGUI["production"] = "Produktions Boost"
    zrush.language.VGUI["antijam"] = "Schutz Boost"
    zrush.language.VGUI["cooling"] = "Kühlungs Boost"
    zrush.language.VGUI["refining"] = "Raffinerie Boost"
    zrush.language.VGUI["pipes"] = "Extra Rohre"

    zrush.language.VGUI.MachineBuilder["MachineLimitReached"] = "Maschinenlimit erreicht!"
end
