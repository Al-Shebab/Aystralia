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


if (zrush.config.selectedLanguage == "dk") then

    zrush.language.NPC["FuelBuyer"] = "Brændstofs Køber"
    zrush.language.NPC["Profit"] = "Profit:"
    zrush.language.NPC["YouSold"] = "Du solgte $Amount$UoM $Fuelname for $Earning$Currency"

    zrush.language.NPC["DialogTransactionComplete"] = "Fornøjelse at lave forretninger med dig!"
    zrush.language.NPC["NoFuel"] = "Du har intet brændstof, Hvorfor er du her?!"

    zrush.language.NPC["Dialog00"] = "Skimmelsvamps inspektioner er vigtige, når du køber et hjem."
    zrush.language.NPC["Dialog01"] = "Jeg har en sandwich i lommen med mug på."
    zrush.language.NPC["Dialog02"] = "Juletræer forårsager allergi på grund af skimmel."
    zrush.language.NPC["Dialog03"] = "Sprøjte blegemiddel på skimmel anbefales ikke."
    zrush.language.NPC["Dialog04"] = "Jeg har en skimmelsvamps kollektion, vil du se den?"
    zrush.language.NPC["Dialog05"] = "D-vitamintilskud hjælper med at bekæmpe skimmel-allergier."
    zrush.language.NPC["Dialog06"] = "Skimmel forårsager udslæt."
    zrush.language.NPC["Dialog07"] = "Skimmelsvamp spiser ikke et godt måltid."
    zrush.language.NPC["Dialog08"] = "Døde skimmelsporer er lige så skadelige som levende sporer."
    zrush.language.NPC["Dialog09"] = "Skimmelsvamp bruges i biologisk krigsførelse."

    zrush.language.VCMOD["NeedMoreFuel"] = "Du skal bruge mindst 20l for fylde en dunk!"

    zrush.language.General["AllreadyInUse"] = "Allerede i brug!"
    zrush.language.General["YouDontOwnThis"] = "Du ejer ikke denne!"
    zrush.language.General["NoDrillholeFound"] = "Intet ledigt Borehul fundet!"
    zrush.language.General["NoOilSpotFound"] = "Ingen Olie kilde fundet!"
    zrush.language.General["OilSpotSpawner"] = "Oile Kilde Spawner"

    zrush.language.General["NoFreeSocketAvailable"] = "Der er ingen fatning tilgængelig!"

    zrush.language.DrillTower["AllreadyReachedOil"] = "Du er allerede nået ned til Oilen!"
    zrush.language.DrillTower["DrillPipesMissing"] = "Mangler Borrerør!"

    zrush.language.Pump["OilSourceEmpty"] = "Olie kilden er tømt!"
    zrush.language.Pump["MissingBarrel"] = "Mangler tønde!"

    zrush.language.Refinery["MissingOilBarrel"] = "Mangler Olie tønde!"
    zrush.language.Refinery["MissingEmptyBarrel"] = "Mangler tom tønde!"
    zrush.language.VGUI.Refinery["IDLE"] = "Venter"
    zrush.language.VGUI.Refinery["NEED_EMPTY_BARREL"] = "Mangler tom tønde til brændstof!"
    zrush.language.VGUI.Refinery["NEED_OIL_BARREL"] = "Mangler Olie tønde"
    zrush.language.VGUI.Refinery["READY_FOR_WORK"] = "Klar til raffinering"
    zrush.language.VGUI.Refinery["FUELBARREL_FULL"] = "Brændstofs tønde er fuld!"
    zrush.language.VGUI.Refinery["REFINING"] = "Raffinering af olie"
    zrush.language.VGUI.Refinery["OVERHEAT"] = "Raffinaderiet Overopheder!"
    zrush.language.VGUI.Refinery["COOLED"] = "Raffinaderiet blev afkølet!"

    zrush.language.MachineCrate["BuyMachine"] = "<Køb Maskine>"
    zrush.language.MachineCrate["Drill"] = "Borre Tårn"
    zrush.language.MachineCrate["Burner"] = "Brænder"
    zrush.language.MachineCrate["Pump"] = "Pumpe"
    zrush.language.MachineCrate["Refinery"] = "Raffinaderi"
    zrush.language.MachineCrate["Occupied"] = "Optaget af "

    zrush.language.VGUI.DrillHole["NEED_PIPES"] = "Mangler borre rør!"
    zrush.language.VGUI.DrillHole["NEED_BURNER"] = "Mangler en Brænder!"
    zrush.language.VGUI.DrillHole["HAS_BURNER"] = "Har en Brænder!"
    zrush.language.VGUI.DrillHole["NO_OIL"] = "Olie kilden er tømt!"

    zrush.language.VGUI.DrillTower["DrillTower"] = "Borre Tårn"
    zrush.language.VGUI.DrillTower["NEED_PIPES"] = "Mangler borre rør!"
    zrush.language.VGUI.DrillTower["READY_FOR_WORK"] = "Klar til at borre!"
    zrush.language.VGUI.DrillTower["IS_WORKING"] = "Borre"
    zrush.language.VGUI.DrillTower["JAMMED"] = "Bor er fastklemt!"
    zrush.language.VGUI.DrillTower["FINISHED_DRILLING"] = "Færdig med at borre!"

    zrush.language.VGUI.Burner["IDLE"] = "Venter!"
    zrush.language.VGUI.Burner["BURNING_GAS"] = "Brænder gas!"
    zrush.language.VGUI.Burner["OVERHEAT"] = "Brænderen er overophedet!"
    zrush.language.VGUI.Burner["COOLED"] = "Brænder blev afkølet!"
    zrush.language.VGUI.Burner["NO_GAS_LEFT"] = "Der er ingen gas tilbage!"

    zrush.language.VGUI.Pump["NEED_BARREL"] = "Venter på en tønde!"
    zrush.language.VGUI.Pump["PUMP_READY"] = "Klar til at pumpe!"
    zrush.language.VGUI.Pump["PUMPING"] = "Pumper Oile!"
    zrush.language.VGUI.Pump["BARREL_FULL"] = "Oile tønden er Fuld!"
    zrush.language.VGUI.Pump["JAMMED"] = "Pumpen sidder fast!"
    zrush.language.VGUI.Pump["NO_OIL"] = "Oliekilde tom!"

    zrush.language.VGUI.Barrel["BarrelMenu"] = "Tønde Menu"
    zrush.language.VGUI.Barrel["BarrelMenuInfo"] = "*Dette vil fylde brændstof på en VCMod benzindunk."
    zrush.language.VGUI.Barrel["BarrelFuelInfo"] = " Tønde"
    zrush.language.VGUI.Barrel["FuelAmount"] = "Brændstof Mængde: "
    zrush.language.VGUI.Barrel["Collect"] = "Saml"
    zrush.language.VGUI.Barrel["SpawnVCModFuelCan"] = "Spawn VCMod $fueltype dunk"

    zrush.language.VGUI.NPC["FuelBuyer"] = "Brændstofs Køber"
    zrush.language.VGUI.NPC["Sell"] = "Sælg"
    zrush.language.VGUI.NPC["SellAll"] = "Sælg Alt"
    zrush.language.VGUI.NPC["YourFuelInv"] = "Din Brændstofs Beholdning"
    zrush.language.VGUI.NPC["SaveInfo"] = "*Dit Brændstofs inventar gemmes ikke, så sørg for at sælge alt dit brændstof, før du forlader serveren!"

    zrush.language.VGUI["TimeprePipe"] = "Tid pr. Rør: "
    zrush.language.VGUI["PipesinQueue"] = "Rør i kø: "
    zrush.language.VGUI["NeededPipes"] = "Nødvendige rør: "
    zrush.language.VGUI["JamChance"] = "Nedbrydnings Chance: " // With Jam i mean like the machine breaking down

    zrush.language.VGUI["Speed"] = "Hastighed: "
    zrush.language.VGUI["BurnAmount"] = "Brænd mængde: "
    zrush.language.VGUI["RemainingGas"] = "Resterende Gas: "
    zrush.language.VGUI["OverHeatChance"] =  "Overophede Chance: "

    zrush.language.VGUI["NA"] =  "NA" // This is the short version for "Not Available"

    zrush.language.VGUI["PumpAmount"] = "Pumpe Mængde: "
    zrush.language.VGUI["BarrelOIL"] = "Tønde (OILE): "
    zrush.language.VGUI["RemainingOil"] = "Resterende Olie: "

    zrush.language.VGUI["Fuel"] = "Brændstof: "
    zrush.language.VGUI["RefineAmount"] = "Raffinere Mængde: "
    zrush.language.VGUI["RefineOutput"] = "Raffinere Produktion: "
    zrush.language.VGUI["OverHeatChance"] = "Overophede Chance: "
    zrush.language.VGUI["BarrelFuel"] = "Tønde (BRÆNDSTOF): "

    zrush.language.VGUI["Status"] =  "Status: "
    zrush.language.VGUI["pipes"] =  "EkstraRør: +"
    zrush.language.VGUI["BoostAmount"] =  "BoostMængde: "
    zrush.language.VGUI["FixMachinefirst"] = "Fix maskinen hurtigt!"

    zrush.language.VGUI["Actions"] = "Handlinger:"
    zrush.language.VGUI["Repair"] = "Reparere"
    zrush.language.VGUI["Stop"] = "Stop"
    zrush.language.VGUI["Disassemble"] = "Demontere"
    zrush.language.VGUI["Start"] = "Start"
    zrush.language.VGUI["CoolDown"] = "Nedkøling"

    zrush.language.VGUI["ModuleShop"] = "Modul Butik"
    zrush.language.VGUI["Purchase"] = "Køb"
    zrush.language.VGUI["Sell"] = "Sælg"
    zrush.language.VGUI["Locked"] = "Låst"
    zrush.language.VGUI["NonSocketfound"] = "Ingen ledig \nfatning fundet!"
    zrush.language.VGUI["WrongUserGroup"] = "Forkert Stilling!"
    zrush.language.VGUI["WrongJob"] = "Forkerte Arbejde!"
    zrush.language.VGUI["TooFarAway"] = "Du er for langt væk fra denne enhed!"
    zrush.language.VGUI["Youcannotafford"] = "Du har ikke råd til dette!"
    zrush.language.VGUI["allreadyinstalled"] = " Allerede Installeret!"
    zrush.language.VGUI["Youbougt"] =  "Du købte en $Name for $Price$Currency"
    zrush.language.VGUI["YouSold"] =  "Du soglte en $Name for $Price$Currency"

    zrush.language.VGUI["MachineShop"] = "Maskine Butik"
    zrush.language.VGUI["Place"] = "Sted"

    zrush.language.VGUI.MachineBuilder["BuildEntity"] = " - Byg enhed"
    zrush.language.VGUI.MachineBuilder["Cancel"] = " - Afbryd"
    zrush.language.VGUI.MachineBuilder["Needsdrilledfirst"]  = "Skal først bores!"
    zrush.language.VGUI.MachineBuilder["NeedsBurnerquick"]  = "Mangler en brænder hurtigt!"
    zrush.language.VGUI.MachineBuilder["NeedsPump"]  = "Mangler en Pumpe!"
    zrush.language.VGUI.MachineBuilder["NotValidSpace"]  = "Ikke et gyldigt sted"
    zrush.language.VGUI.MachineBuilder["ToocloseDrillHole"]  = "For tæt på et andet borehul!"
    zrush.language.VGUI.MachineBuilder["CanonlybuildGround"]  = "Kan kun bygges på jorden!"
    zrush.language.VGUI.MachineBuilder["CanonlybuildOilSpots"]  = "Kan kun bygges på Oile steder!"
    zrush.language.VGUI.MachineBuilder["CanonlybuildDrillhole"]  = "Kan kun bygges på borehuller!"
    zrush.language.VGUI.MachineBuilder["NotenoughSpace"]  = "Ikke nok plads!"
    zrush.language.VGUI.MachineBuilder["ConnectionLost"]  = "Forbindelse Mistet!"
    zrush.language.VGUI.MachineBuilder["ReachedMaxDrillhole"]  = "Nået maksimum antal borehuller!"

    zrush.language.Inv["InvEmpty"] = "Dit Brændstofs Inventar er tomt!"
    zrush.language.Inv["FuelInv"] = "Brændstof Inventar: "

    zrush.language.VGUI["speed"] = "Hastigheds Boost"
    zrush.language.VGUI["production"] = "Produktions Boost"
    zrush.language.VGUI["antijam"] = "AntiStop Boost"
    zrush.language.VGUI["cooling"] = "Cooling Boost"
    zrush.language.VGUI["refining"] = "Raffinerings Boost"
    zrush.language.VGUI["pipes"] = "Ekstra Rør"

    zrush.language.VGUI.MachineBuilder["MachineLimitReached"] = "Maskingrænse nået!"
end
