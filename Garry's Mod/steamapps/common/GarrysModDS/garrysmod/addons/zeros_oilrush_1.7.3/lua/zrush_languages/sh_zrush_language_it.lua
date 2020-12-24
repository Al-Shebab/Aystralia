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


if(zrush.config.selectedLanguage == "it")then

    zrush.language.NPC["FuelBuyer"] = "Acquirente di carburante"
    zrush.language.NPC["Profit"] = "Profitto:"
    zrush.language.NPC["YouSold"] = "Hai venduto$Quantità$UoM$Nome carburante per$Guadagnare$Valuta"

    zrush.language.NPC["DialogTransactionComplete"] = "Ottimo per fare affari con te!"
    zrush.language.NPC["NoFuel"] = "Non hai carburante, perché sei qui?!"

    zrush.language.NPC["Dialog00"] = "Le ispezioni dello stampo sono importanti quando si acquista una casa."
    zrush.language.NPC["Dialog01"] = "Ho un sandwich in tasca, con muffa su di esso."
    zrush.language.NPC["Dialog02"] = "Gli alberi di Natale causano allergie a causa della muffa."
    zrush.language.NPC["Dialog03"] = "Spruzzare la candeggina sulla muffa non è raccomandato."
    zrush.language.NPC["Dialog04"] = "Ho una collezione di stampi, vuoi vederla?"
    zrush.language.NPC["Dialog05"] = "Supplementi di vitamina D aiutano a combattere le allergie alle muffe."
    zrush.language.NPC["Dialog06"] = "La muffa provoca eruzioni cutanee."
    zrush.language.NPC["Dialog07"] = "La muffa non mangia un pasto felice."
    zrush.language.NPC["Dialog08"] = "Le spore di muffa morte sono dannose come le spore vive."
    zrush.language.NPC["Dialog09"] = "La muffa è usata in guerra biologica."

    zrush.language.VCMOD["NeedMoreFuel"] = "Hai bisogno di almeno 20 litri per riempirlo in una lattina!"

    zrush.language.General["AllreadyInUse"] = "Già in uso!"
    zrush.language.General["YouDontOwnThis"] = "Tu non possiedi questo!"
    zrush.language.General["NoDrillholeFound"] = "Nessun  Foro gratuito trovato!"
    zrush.language.General["NoOilSpotFound"] = "Nessun Oilspot trovato!"
    zrush.language.General["OilSpotSpawner"] = "Spawner di OilSpot"

    zrush.language.General["NoFreeSocketAvailable"] = "Non c'è presa disponibile!"

    zrush.language.DrillTower["AllreadyReachedOil"] = "Hai già raggiunto l'olio!"
    zrush.language.DrillTower["DrillPipesMissing"] = "Tubi di perforazione mancanti!"

    zrush.language.Pump["OilSourceEmpty"] = "La fonte di petrolio è vuota!"
    zrush.language.Pump["MissingBarrel"] = "Barile mancante!"

    zrush.language.Refinery["MissingOilBarrel"] = "Barile di petrolio mancante!"
    zrush.language.Refinery["MissingEmptyBarrel"] = "Barile vuoto mancante!"
    zrush.language.VGUI.Refinery["IDLE"] = "Aspettando"
    zrush.language.VGUI.Refinery["NEED_EMPTY_BARREL"] = "Hai bisogno di botte vuota per il carburante!"
    zrush.language.VGUI.Refinery["NEED_OIL_BARREL"] = "Hai bisogno di barile di petrolio"
    zrush.language.VGUI.Refinery["READY_FOR_WORK"] = "Pronto per la raffinazione"
    zrush.language.VGUI.Refinery["FUELBARREL_FULL"] = "Carbone di carburante è pieno!"
    zrush.language.VGUI.Refinery["REFINING"] = "Olio di raffinazione"
    zrush.language.VGUI.Refinery["OVERHEAT"] = "La raffineria è surriscaldata!"
    zrush.language.VGUI.Refinery["COOLED"] = "Raffineria raffinata!"

    zrush.language.MachineCrate["BuyMachine"] = "<Acquista macchina>"
    zrush.language.MachineCrate["Drill"] = "Trapano Torre"
    zrush.language.MachineCrate["Burner"] = "Bruciatore"
    zrush.language.MachineCrate["Pump"] = "Pompa"
    zrush.language.MachineCrate["Refinery"] = "Raffineria"
    zrush.language.MachineCrate["Occupied"] = "Occupato da"

    zrush.language.VGUI.DrillHole["NEED_PIPES"] = "Serve un trapano!"
    zrush.language.VGUI.DrillHole["NEED_BURNER"] = "Ha bisogno di un bruciatore!"
    zrush.language.VGUI.DrillHole["HAS_BURNER"] = "Ha un bruciatore!"
    zrush.language.VGUI.DrillHole["NO_OIL"] = "Fonte olio Vuoto"

    zrush.language.VGUI.DrillTower["DrillTower"] = "Trapano Torre"
    zrush.language.VGUI.DrillTower["NEED_PIPES"] = "Bisogno di tubi di perforazione!"
    zrush.language.VGUI.DrillTower["READY_FOR_WORK"] = "Pronto per la perforazione"
    zrush.language.VGUI.DrillTower["IS_WORKING"] = "Perforazione"
    zrush.language.VGUI.DrillTower["JAMMED"] = "Il trapano è inceppato!"
    zrush.language.VGUI.DrillTower["FINISHED_DRILLING"] = "Foratura finita"

    zrush.language.VGUI.Burner["IDLE"] = "Aspettando!"
    zrush.language.VGUI.Burner["BURNING_GAS"] = "Bruciando gas!"
    zrush.language.VGUI.Burner["OVERHEAT"] = "Il bruciatore è surriscaldato!"
    zrush.language.VGUI.Burner["COOLED"] = "Il bruciatore si è raffreddato!"
    zrush.language.VGUI.Burner["NO_GAS_LEFT"] = "Non c'è più benzina!"

    zrush.language.VGUI.Pump["NEED_BARREL"] = "Aspettando un barile"
    zrush.language.VGUI.Pump["PUMP_READY"] = "Pronti per la pompa!"
    zrush.language.VGUI.Pump["PUMPING"] = "Pompaggio dell'olio"
    zrush.language.VGUI.Pump["BARREL_FULL"] = "Il barile dell'olio è pieno!"
    zrush.language.VGUI.Pump["JAMMED"] = "La pompa è inceppata!"
    zrush.language.VGUI.Pump["NO_OIL"] = "Fonte olio Vuoto"

    zrush.language.VGUI.Barrel["BarrelMenu"] = "Menu Barile"
    zrush.language.VGUI.Barrel["BarrelMenuInfo"] = "*Questo riempirà di carburante in una lattina di Jerry Can VCMod."
    zrush.language.VGUI.Barrel["BarrelFuelInfo"] = "Barile"
    zrush.language.VGUI.Barrel["FuelAmount"] = "Quantità di carburante: "
    zrush.language.VGUI.Barrel["Collect"] = "Pick-up "
    zrush.language.VGUI.Barrel["SpawnVCModFuelCan"] = "VCMod di ricambio VCMod $fueltype Can"

    zrush.language.VGUI.NPC["FuelBuyer"] = "Acquirente di carburante"
    zrush.language.VGUI.NPC["Sell"] = "Vendere "
    zrush.language.VGUI.NPC["SellAll"] = "Vendere tutti"
    zrush.language.VGUI.NPC["YourFuelInv"] = "Il tuo inventario di carburante"
    zrush.language.VGUI.NPC["SaveInfo"] = "*Questo inventario non viene salvato, quindi assicurati di vendere tutto il carburante prima di lasciare il server!"

    zrush.language.VGUI["TimeprePipe"] = "Tempo per tubo: "
    zrush.language.VGUI["PipesinQueue"] = "Tubi in coda: "
    zrush.language.VGUI["NeededPipes"] = "Aveva bisogno di tubi: "
    zrush.language.VGUI["JamChance"] = "Possibilità di Jam: " // Con Jam intendo come la macchina che si guasta.

    zrush.language.VGUI["Speed"] = "Velocità: "
    zrush.language.VGUI["BurnAmount"] = "Quantità di masterizzazione "
    zrush.language.VGUI["RemainingGas"] = "Gas rimanente: "
    zrush.language.VGUI["OverHeatChance"] =  "Sopra la Heat Chance: "

    zrush.language.VGUI["NA"] =  "NA" // Questa è la versione breve di non disponibile

    zrush.language.VGUI["PumpAmount"] = "Pompa Importo: "
    zrush.language.VGUI["BarrelOIL"] = "Barile (olio): "
    zrush.language.VGUI["RemainingOil"] = "Olio rimanente: "

    zrush.language.VGUI["Fuel"] = "Carburante: "
    zrush.language.VGUI["RefineAmount"] = "Perfezionare la quantità: "
    zrush.language.VGUI["RefineOutput"] = "Perfezionare l'output: "
    zrush.language.VGUI["OverHeatChance"] = "Possibilità di surriscaldamento: "
    zrush.language.VGUI["BarrelFuel"] = "Barile(carburante) "

    zrush.language.VGUI["Status"] =  "Situazione: "
    zrush.language.VGUI["pipes"] =  "Tubi extra: +"
    zrush.language.VGUI["BoostAmount"] =  "Aumentare l'importo: "
    zrush.language.VGUI["FixMachinefirst"] = "Fissare la macchina veloce!"

    zrush.language.VGUI["Actions"] = "Azioni:"
    zrush.language.VGUI["Repair"] = "Riparare"
    zrush.language.VGUI["Stop"] = "Pausa"
    zrush.language.VGUI["Disassemble"] = "Smontare"
    zrush.language.VGUI["Start"] = "START"
    zrush.language.VGUI["CoolDown"] = "Calmati"

    zrush.language.VGUI["ModuleShop"] = "Negozio di moduli"
    zrush.language.VGUI["Purchase"] = "Acquista"
    zrush.language.VGUI["Sell"] = "Vendere"
    zrush.language.VGUI["Locked"] = "Bloccato"
    zrush.language.VGUI["NonSocketfound"] = "Nessun \nSocket trovato trovato!"
    zrush.language.VGUI["WrongUserGroup"] = "Gruppo utenti errato!"
    zrush.language.VGUI["WrongJob"] = "Lavoro sbagliato!"
    zrush.language.VGUI["TooFarAway"] = "Sei troppo lontano dall'Entità!"
    zrush.language.VGUI["Youcannotafford"] = "Non puoi permetterti questo!"
    zrush.language.VGUI["allreadyinstalled"] = " già installato!"
    zrush.language.VGUI["Youbougt"] =  "Hai comprato un $Nome per $Prezzo$Moneta"
    zrush.language.VGUI["YouSold"] =  "Hai venduto un $Nome per $Prezzo$Moneta"

    zrush.language.VGUI["MachineShop"] = "Officina"
    zrush.language.VGUI["Place"] = "Posto"

    zrush.language.VGUI.MachineBuilder["BuildEntity"] = " - Crea entità"
    zrush.language.VGUI.MachineBuilder["Cancel"] = " - Annulla"
    zrush.language.VGUI.MachineBuilder["Needsdrilledfirst"]  = "Ha bisogno di essere perforato prima!"
    zrush.language.VGUI.MachineBuilder["NeedsBurnerquick"]  = "Ha bisogno di un masterizzatore veloce!"
    zrush.language.VGUI.MachineBuilder["NeedsPump"]  = "Ha bisogno di una pompa!"
    zrush.language.VGUI.MachineBuilder["NotValidSpace"]  = "Non è uno spazio valido"
    zrush.language.VGUI.MachineBuilder["ToocloseDrillHole"]  = " Troppo vicino a un altro Foro"
    zrush.language.VGUI.MachineBuilder["CanonlybuildGround"]  = "Può essere costruito solo a terra!"
    zrush.language.VGUI.MachineBuilder["CanonlybuildOilSpots"]  = "Può essere costruito solo su Macchie d'olio!"
    zrush.language.VGUI.MachineBuilder["CanonlybuildDrillhole"]  = "Può essere costruito solo su fori di perforazione!"
    zrush.language.VGUI.MachineBuilder["NotenoughSpace"]  = "Non abbastanza spazio!"
    zrush.language.VGUI.MachineBuilder["ConnectionLost"]  = "Collegamento perso!"
    zrush.language.VGUI.MachineBuilder["ReachedMaxDrillhole"]  = "Raggiunto numero massimo di fori di foratura!"

    zrush.language.Inv["InvEmpty"] = "Il tuo inventario di carburante è vuoto!"
    zrush.language.Inv["FuelInv"] = "Inventario di carburante: "

    zrush.language.VGUI["speed"] = "Aumento di velocità"
    zrush.language.VGUI["production"] = "Boost di produzione"
    zrush.language.VGUI["antijam"] = "Anti marmellata Boost"
    zrush.language.VGUI["cooling"] = "Raffreddamento Boost"
    zrush.language.VGUI["refining"] = "Raffinare Boost"
    zrush.language.VGUI["pipes"] = "Tubi extra"

    zrush.language.VGUI.MachineBuilder["MachineLimitReached"] = "Limite macchina raggiunto!"
end
