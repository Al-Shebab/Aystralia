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


if(zrush.config.selectedLanguage == "en")then

    zrush.language.NPC["FuelBuyer"] = "Fuel Buyer"
    zrush.language.NPC["Profit"] = "Profit:"
    zrush.language.NPC["YouSold"] = "You Sold $Amount$UoM $Fuelname for $Earning$Currency"

    zrush.language.NPC["DialogTransactionComplete"] = "Great to do business with you!"
    zrush.language.NPC["NoFuel"] = "You dont have any Fuel, why are you here?!"

    zrush.language.NPC["Dialog00"] = "Mold Inspections Are Important When Buying a Home."
    zrush.language.NPC["Dialog01"] = "I have a Sandwich in my pocket, with Mold on it."
    zrush.language.NPC["Dialog02"] = "Christmas Trees Cause Allergies Because of Mold."
    zrush.language.NPC["Dialog03"] = "Spraying Bleach on Mold is not Recommended."
    zrush.language.NPC["Dialog04"] = "I have a Mold Collection, do you wanna see it?"
    zrush.language.NPC["Dialog05"] = "Vitamin D Supplements Help Fight Mold Allergies."
    zrush.language.NPC["Dialog06"] = "Mold Causes Rashes."
    zrush.language.NPC["Dialog07"] = "Mold Will Not Eat a Happy Meal."
    zrush.language.NPC["Dialog08"] = "Dead Mold Spores Are Just As Harmful as Live Spores."
    zrush.language.NPC["Dialog09"] = "Mold is Used in Biological Warfare."

    zrush.language.VCMOD["NeedMoreFuel"] = "You need at least 20l to fill it in a Can!"

    zrush.language.General["AllreadyInUse"] = "Already in Use!"
    zrush.language.General["YouDontOwnThis"] = "You dont own this!"
    zrush.language.General["NoDrillholeFound"] = "No free DrillHole Found!"
    zrush.language.General["NoOilSpotFound"] = "No Oilspot found!"
    zrush.language.General["OilSpotSpawner"] = "OilSpot Spawner"

    zrush.language.General["NoFreeSocketAvailable"] = "There is no free socket available!"

    zrush.language.DrillTower["AllreadyReachedOil"] = "You already reached the Oil!"
    zrush.language.DrillTower["DrillPipesMissing"] = "Missing DrillPipes!"

    zrush.language.Pump["OilSourceEmpty"] = "Oil Source is Empty!"
    zrush.language.Pump["MissingBarrel"] = "Missing Barrel!"

    zrush.language.Refinery["MissingOilBarrel"] = "Missing Oil Barrel!"
    zrush.language.Refinery["MissingEmptyBarrel"] = "Missing Empty Barrel!"
    zrush.language.VGUI.Refinery["IDLE"] = "Waiting"
    zrush.language.VGUI.Refinery["NEED_EMPTY_BARREL"] = "Need Empty Barrel for Fuel!"
    zrush.language.VGUI.Refinery["NEED_OIL_BARREL"] = "Need Oil Barrel"
    zrush.language.VGUI.Refinery["READY_FOR_WORK"] = "Ready for Refining"
    zrush.language.VGUI.Refinery["FUELBARREL_FULL"] = "Fuel Barrel is Full!"
    zrush.language.VGUI.Refinery["REFINING"] = "Refining Oil"
    zrush.language.VGUI.Refinery["OVERHEAT"] = "Refinery is OverHeating!"
    zrush.language.VGUI.Refinery["COOLED"] = "Refinery got Cooled!"

    zrush.language.MachineCrate["BuyMachine"] = "<Buy Machine>"
    zrush.language.MachineCrate["Drill"] = "Drill Tower"
    zrush.language.MachineCrate["Burner"] = "Burner"
    zrush.language.MachineCrate["Pump"] = "Pump"
    zrush.language.MachineCrate["Refinery"] = "Refinery"
    zrush.language.MachineCrate["Occupied"] = "Occupied by "

    zrush.language.VGUI.DrillHole["NEED_PIPES"] = "Needs a Drill!"
    zrush.language.VGUI.DrillHole["NEED_BURNER"] = "Needs a Burner!"
    zrush.language.VGUI.DrillHole["HAS_BURNER"] = "Has a Burner!"
    zrush.language.VGUI.DrillHole["NO_OIL"] = "Oil Source Empty"

    zrush.language.VGUI.DrillTower["DrillTower"] = "DrillTower"
    zrush.language.VGUI.DrillTower["NEED_PIPES"] = "Need Drill Pipes!"
    zrush.language.VGUI.DrillTower["READY_FOR_WORK"] = "Ready for Drilling"
    zrush.language.VGUI.DrillTower["IS_WORKING"] = "Drilling"
    zrush.language.VGUI.DrillTower["JAMMED"] = "Drill is Jammed!"
    zrush.language.VGUI.DrillTower["FINISHED_DRILLING"] = "Finished Drilling"

    zrush.language.VGUI.Burner["IDLE"] = "Waiting!"
    zrush.language.VGUI.Burner["BURNING_GAS"] = "Burning Gas!"
    zrush.language.VGUI.Burner["OVERHEAT"] = "Burner is OverHeating!"
    zrush.language.VGUI.Burner["COOLED"] = "Burner got Cooled!"
    zrush.language.VGUI.Burner["NO_GAS_LEFT"] = "No Gas left!"

    zrush.language.VGUI.Pump["NEED_BARREL"] = "Waiting for a Barrel"
    zrush.language.VGUI.Pump["PUMP_READY"] = "Ready for Pump!"
    zrush.language.VGUI.Pump["PUMPING"] = "Pumping Oil"
    zrush.language.VGUI.Pump["BARREL_FULL"] = "Oil Barrel is Full!"
    zrush.language.VGUI.Pump["JAMMED"] = "Pump is Jammed!"
    zrush.language.VGUI.Pump["NO_OIL"] = "Oil Source Empty"

    zrush.language.VGUI.Barrel["BarrelMenu"] = "Barrel Menu"
    zrush.language.VGUI.Barrel["BarrelMenuInfo"] = "*This will fill Fuel in a VCMod Jerry Can."
    zrush.language.VGUI.Barrel["BarrelFuelInfo"] = " Barrel"
    zrush.language.VGUI.Barrel["FuelAmount"] = "Fuel Amount: "
    zrush.language.VGUI.Barrel["Collect"] = "Pickup"
    zrush.language.VGUI.Barrel["SpawnVCModFuelCan"] = "Spawn VCMod $fueltype Can"

    zrush.language.VGUI.NPC["FuelBuyer"] = "Fuel Buyer "
    zrush.language.VGUI.NPC["Sell"] = "Sell"
    zrush.language.VGUI.NPC["SellAll"] = "Sell All"
    zrush.language.VGUI.NPC["YourFuelInv"] = "Your Fuel Inventory"
    zrush.language.VGUI.NPC["SaveInfo"] = "*This Inventory does not get saved so make sure you sell all your Fuel before leaving the Server!"

    zrush.language.VGUI["TimeprePipe"] = "Time per Pipe: "
    zrush.language.VGUI["PipesinQueue"] = "Pipes in Queue: "
    zrush.language.VGUI["NeededPipes"] = "Needed Pipes: "
    zrush.language.VGUI["JamChance"] = "Jam Chance: " // With Jam i mean like the machine breaking down

    zrush.language.VGUI["Speed"] = "Speed: "
    zrush.language.VGUI["BurnAmount"] = "Burn Amount: "
    zrush.language.VGUI["RemainingGas"] = "Remaining Gas: "
    zrush.language.VGUI["OverHeatChance"] =  "OverHeat Chance: "

    zrush.language.VGUI["NA"] =  "NA" // This is the short version for "Not Available"

    zrush.language.VGUI["PumpAmount"] = "Pump Amount: "
    zrush.language.VGUI["BarrelOIL"] = "Barrel(OIL): "
    zrush.language.VGUI["RemainingOil"] = "Remaining Oil: "

    zrush.language.VGUI["Fuel"] = "Fuel: "
    zrush.language.VGUI["RefineAmount"] = "Refine Amount: "
    zrush.language.VGUI["RefineOutput"] = "Refine Output: "
    zrush.language.VGUI["OverHeatChance"] = "OverHeat Chance: "
    zrush.language.VGUI["BarrelFuel"] = "Barrel(FUEL): "

    zrush.language.VGUI["Status"] =  "Status: "
    zrush.language.VGUI["pipes"] =  "ExtraPipes: +"
    zrush.language.VGUI["BoostAmount"] =  "BoostAmount: "
    zrush.language.VGUI["FixMachinefirst"] = "Fix the Machine fast!"

    zrush.language.VGUI["Actions"] = "Actions:"
    zrush.language.VGUI["Repair"] = "Repair"
    zrush.language.VGUI["Stop"] = "Stop"
    zrush.language.VGUI["Disassemble"] = "Disassemble"
    zrush.language.VGUI["Start"] = "Start"
    zrush.language.VGUI["CoolDown"] = "CoolDown"

    zrush.language.VGUI["ModuleShop"] = "Module Shop"
    zrush.language.VGUI["Purchase"] = "Purchase"
    zrush.language.VGUI["Sell"] = "Sell"
    zrush.language.VGUI["Locked"] = "Locked"
    zrush.language.VGUI["NonSocketfound"] = "No free \nSocket found!"
    zrush.language.VGUI["WrongUserGroup"] = "Wrong UserGroup!"
    zrush.language.VGUI["WrongJob"] = "Wrong Job!"
    zrush.language.VGUI["TooFarAway"] = "You are too far aways from the Entity!"
    zrush.language.VGUI["Youcannotafford"] = "You cannot afford this!"
    zrush.language.VGUI["allreadyinstalled"] = " already installed!"
    zrush.language.VGUI["Youbougt"] =  "You bougt a $Name for $Price$Currency"
    zrush.language.VGUI["YouSold"] =  "You sold a $Name for $Price$Currency"

    zrush.language.VGUI["MachineShop"] = "Machine Shop"
    zrush.language.VGUI["Place"] = "Place"

    zrush.language.VGUI.MachineBuilder["BuildEntity"] = " - Build Entity"
    zrush.language.VGUI.MachineBuilder["Cancel"] = " - Cancel"
    zrush.language.VGUI.MachineBuilder["Needsdrilledfirst"]  = "Needs to be drilled first!"
    zrush.language.VGUI.MachineBuilder["NeedsBurnerquick"]  = "Needs a Burner quick!"
    zrush.language.VGUI.MachineBuilder["NeedsPump"]  = "Needs a Pump!"
    zrush.language.VGUI.MachineBuilder["NotValidSpace"]  = "Not a Valid Space"
    zrush.language.VGUI.MachineBuilder["ToocloseDrillHole"]  = "Too close to another DrillHole!"
    zrush.language.VGUI.MachineBuilder["CanonlybuildGround"]  = "Can only be built on the Ground!"
    zrush.language.VGUI.MachineBuilder["CanonlybuildOilSpots"]  = "Can only be built on OilSpots!"
    zrush.language.VGUI.MachineBuilder["CanonlybuildDrillhole"]  = "Can only be built on Drillholes!"
    zrush.language.VGUI.MachineBuilder["NotenoughSpace"]  = "Not enough Space!"
    zrush.language.VGUI.MachineBuilder["ConnectionLost"]  = "Connection Lost!"
    zrush.language.VGUI.MachineBuilder["ReachedMaxDrillhole"]  = "Reached Max Drillhole Count!"

    zrush.language.Inv["InvEmpty"] = "Your Fuel Inventory is Empty!"
    zrush.language.Inv["FuelInv"] = "Fuel Inventory: "

    zrush.language.VGUI["speed"] = "Speed Boost"
    zrush.language.VGUI["production"] = "Production Boost"
    zrush.language.VGUI["antijam"] = "AntiJam Boost"
    zrush.language.VGUI["cooling"] = "Cooling Boost"
    zrush.language.VGUI["refining"] = "Refine Boost"
    zrush.language.VGUI["pipes"] = "Extra Pipes"

    zrush.language.VGUI.MachineBuilder["MachineLimitReached"] = "Machine limit reached!"
end
