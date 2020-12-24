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


if(zrush.config.selectedLanguage == "es")then

    zrush.language.NPC["FuelBuyer"] = "Comprador de Combustible"
    zrush.language.NPC["Profit"] = "Ganancias:"
    zrush.language.NPC["YouSold"] = "Has vendido $Amount$UoM $Fuelname por $Earning$Currency"

    zrush.language.NPC["DialogTransactionComplete"] = "Ha sido un gusto hacer negocios contigo!"
    zrush.language.NPC["NoFuel"] = "No tienes nada de combustible, por qué estas aquí?!"

    zrush.language.NPC["Dialog00"] = "Las inspecciones de moho son importantes al comprar una casa."
    zrush.language.NPC["Dialog01"] = "Tengo un sándwich en mi bolsillo, con moho en el."
    zrush.language.NPC["Dialog02"] = "Los arboles de navidad causan alergias, por el moho en ellos."
    zrush.language.NPC["Dialog03"] = "No es recomendado rociar blanqueador en moho."
    zrush.language.NPC["Dialog04"] = "Tengo una colección de moho, ¿quieres verla?"
    zrush.language.NPC["Dialog05"] = "Los suplementos de la vitamina D te ayudan a combatir las alergias al moho."
    zrush.language.NPC["Dialog06"] = "El moho causa erupciones."
    zrush.language.NPC["Dialog07"] = "El moho no tendrá una comida feliz."
    zrush.language.NPC["Dialog08"] = "Las esporas del moho muerto son tan dañinas como las esporas con vida."
    zrush.language.NPC["Dialog09"] = "El moho es usado en guerras biologicas."

    zrush.language.VCMOD["NeedMoreFuel"] = "Necesitas al menos 20L para llenar una lata!"

    zrush.language.General["AllreadyInUse"] = "Actualmente en uso!"
    zrush.language.General["YouDontOwnThis"] = "Esto no es tuyo!"
    zrush.language.General["NoDrillholeFound"] = "No se han encontrado perforaciones gratuitas!"
    zrush.language.General["NoOilSpotFound"] = "No se ha encontrado ningún punto de petróleo!"
    zrush.language.General["OilSpotSpawner"] = "Creador de puntos de petróleo"

    zrush.language.General["NoFreeSocketAvailable"] = "No hay un socket gratis disponible!"

    zrush.language.DrillTower["AllreadyReachedOil"] = "Ya has alcanzado el petróleo!"
    zrush.language.DrillTower["DrillPipesMissing"] = "Faltan los tubos de perforación!"

    zrush.language.Pump["OilSourceEmpty"] = "La fuente de petróleo está vacía!"
    zrush.language.Pump["MissingBarrel"] = "Falta un barril!"

    zrush.language.Refinery["MissingOilBarrel"] = "Falta un barril de petróleo!"
    zrush.language.Refinery["MissingEmptyBarrel"] = "Falta un barril vacío!"
    zrush.language.VGUI.Refinery["IDLE"] = "Esperando"
    zrush.language.VGUI.Refinery["NEED_EMPTY_BARREL"] = "Necesita barril vacío!"
    zrush.language.VGUI.Refinery["NEED_OIL_BARREL"] = "Necesita barril de aceite!"
    zrush.language.VGUI.Refinery["READY_FOR_WORK"] = "Listo para refinar"
    zrush.language.VGUI.Refinery["FUELBARREL_FULL"] = "El barril lleno!"
    zrush.language.VGUI.Refinery["REFINING"] = "Refinando petróleo"
    zrush.language.VGUI.Refinery["OVERHEAT"] = "La refinería se esta sobrecalentando!"
    zrush.language.VGUI.Refinery["COOLED"] = "La refinería se ha enfriado!"

    zrush.language.MachineCrate["BuyMachine"] = "<Comprar Maquina>"
    zrush.language.MachineCrate["Drill"] = "Taladro"
    zrush.language.MachineCrate["Burner"] = "Quemador"
    zrush.language.MachineCrate["Pump"] = "Bomba"
    zrush.language.MachineCrate["Refinery"] = "Refinería"
    zrush.language.MachineCrate["Occupied"] = "Ocupada por "

    zrush.language.VGUI.DrillHole["NEED_PIPES"] = "Necesita un taladro!"
    zrush.language.VGUI.DrillHole["NEED_BURNER"] = "Necesita un quemador!"
    zrush.language.VGUI.DrillHole["HAS_BURNER"] = "Tiene un quemador!"
    zrush.language.VGUI.DrillHole["NO_OIL"] = "La fuente de petróleo está vacía!"

    zrush.language.VGUI.DrillTower["DrillTower"] = "Torre de perforación"
    zrush.language.VGUI.DrillTower["NEED_PIPES"] = "Se necesitan tuberías de perforación!"
    zrush.language.VGUI.DrillTower["READY_FOR_WORK"] = "Listo para la perforación"
    zrush.language.VGUI.DrillTower["IS_WORKING"] = "Perforando"
    zrush.language.VGUI.DrillTower["JAMMED"] = "La perforadora se ha atascado!"
    zrush.language.VGUI.DrillTower["FINISHED_DRILLING"] = "La perforación ha terminado"

    zrush.language.VGUI.Burner["IDLE"] = "Esperando!"
    zrush.language.VGUI.Burner["BURNING_GAS"] = "Quemando gas!"
    zrush.language.VGUI.Burner["OVERHEAT"] = "El quemador se esta sobrecalentando!"
    zrush.language.VGUI.Burner["COOLED"] = "El quemador se ha enfriado!"
    zrush.language.VGUI.Burner["NO_GAS_LEFT"] = "Se ha agotado el gas!"

    zrush.language.VGUI.Pump["NEED_BARREL"] = "Esperando por un barril"
    zrush.language.VGUI.Pump["PUMP_READY"] = "La bomba está lista!"
    zrush.language.VGUI.Pump["PUMPING"] = "Bombeando el petróleo"
    zrush.language.VGUI.Pump["BARREL_FULL"] = "El barril de petróleo está lleno!"
    zrush.language.VGUI.Pump["JAMMED"] = "La bomba se ha atascado!"
    zrush.language.VGUI.Pump["NO_OIL"] = "La fuente de petróleo está vacía!"

    zrush.language.VGUI.Barrel["BarrelMenu"] = "Menú de Barriles"
    zrush.language.VGUI.Barrel["BarrelMenuInfo"] = "*Esto verterá combustible en un bidón de combustible de VCMod."
    zrush.language.VGUI.Barrel["BarrelFuelInfo"] = " Barril"
    zrush.language.VGUI.Barrel["FuelAmount"] = "Cantidad: "
    zrush.language.VGUI.Barrel["Collect"] = "Recoger"
    zrush.language.VGUI.Barrel["SpawnVCModFuelCan"] = "Extraer $fueltype para VCMod"

    zrush.language.VGUI.NPC["FuelBuyer"] = "Comprador de Combustible "
    zrush.language.VGUI.NPC["Sell"] = "Vender"
    zrush.language.VGUI.NPC["SellAll"] = "Vender todo"
    zrush.language.VGUI.NPC["YourFuelInv"] = "Tu inventario de combustible"
    zrush.language.VGUI.NPC["SaveInfo"] = "*Este inventario no es guardado, así que asegúrate de vender todo antes de abandonar el servidor!"

    zrush.language.VGUI["TimeprePipe"] = "Tiempo por tubería: "
    zrush.language.VGUI["PipesinQueue"] = "Tuberías en cola: "
    zrush.language.VGUI["NeededPipes"] = "Tuberías necesarias: "
    zrush.language.VGUI["JamChance"] = "Probabilidad de atasco: " // With Jam i mean like the machine breaking down

    zrush.language.VGUI["Speed"] = "Velocidad: "
    zrush.language.VGUI["BurnAmount"] = "Cantidad de quema: "
    zrush.language.VGUI["RemainingGas"] = "Gas restante: "
    zrush.language.VGUI["OverHeatChance"] =  "Posibilidad de calor: "

    zrush.language.VGUI["NA"] =  "N.D." // This is the short version for "Not Available"

    zrush.language.VGUI["PumpAmount"] = "Cantidad de bombas: "
    zrush.language.VGUI["BarrelOIL"] = "Barril(petróleo): "
    zrush.language.VGUI["RemainingOil"] = "Petróleo restante: "

    zrush.language.VGUI["Fuel"] = "Combustible: "
    zrush.language.VGUI["RefineAmount"] = "Cantidad a refinar: "
    zrush.language.VGUI["RefineOutput"] = "Salida del refinador: "
    zrush.language.VGUI["OverHeatChance"] = "Posibilidad de calor: "
    zrush.language.VGUI["BarrelFuel"] = "Barril(COMBUSTIBLE): "

    zrush.language.VGUI["Status"] =  "Estado: "
    zrush.language.VGUI["pipes"] =  "Tuberías extra: +"
    zrush.language.VGUI["BoostAmount"] =  "Cantidad de Aumento: "
    zrush.language.VGUI["FixMachinefirst"] = "Repara las maquinas rápido!"

    zrush.language.VGUI["Actions"] = "Acciones:"
    zrush.language.VGUI["Repair"] = "Reparar"
    zrush.language.VGUI["Stop"] = "Detener"
    zrush.language.VGUI["Disassemble"] = "Desmontar"
    zrush.language.VGUI["Start"] = "Iniciar"
    zrush.language.VGUI["CoolDown"] = "Enfriar"

    zrush.language.VGUI["ModuleShop"] = "Tienda de Modulos"
    zrush.language.VGUI["Purchase"] = "Comprar"
    zrush.language.VGUI["Sell"] = "Vender"
    zrush.language.VGUI["Locked"] = "Bloqueado"
    zrush.language.VGUI["NonSocketfound"] = "No se ha\nencontrado \nningún\nenchufe!"
    zrush.language.VGUI["WrongUserGroup"] = "Grupo de Usuario incorrecto!"
    zrush.language.VGUI["WrongJob"] = "¡Trabajo equivocado!"
    zrush.language.VGUI["TooFarAway"] = "Estás demasiado lejos de la entidad!"
    zrush.language.VGUI["Youcannotafford"] = "No tienes suficiente dinero!"
    zrush.language.VGUI["allreadyinstalled"] = " ya se encuentra instalado!"
    zrush.language.VGUI["Youbougt"] =  "Has comprado $Name por $Price$Currency"
    zrush.language.VGUI["YouSold"] =  "Has vendido un(a) $Name por $Price$Currency"

    zrush.language.VGUI["MachineShop"] = "Tienda de Máquinas"
    zrush.language.VGUI["Place"] = "Lugar"

    zrush.language.VGUI.MachineBuilder["BuildEntity"] = " - Construir Entidad"
    zrush.language.VGUI.MachineBuilder["Cancel"] = " - Cancelar"
    zrush.language.VGUI.MachineBuilder["Needsdrilledfirst"]  = "Necesita ser perforado antes!"
    zrush.language.VGUI.MachineBuilder["NeedsBurnerquick"]  = "Necesita un quemador rápido!"
    zrush.language.VGUI.MachineBuilder["NeedsPump"]  = "Necesita una bomba!"
    zrush.language.VGUI.MachineBuilder["NotValidSpace"]  = "No es un espacio válido"
    zrush.language.VGUI.MachineBuilder["ToocloseDrillHole"]  = "Demasiado cerca a otro agujero de perforación!"
    zrush.language.VGUI.MachineBuilder["CanonlybuildGround"]  = "Solo puede ser construido en el suelo!"
    zrush.language.VGUI.MachineBuilder["CanonlybuildOilSpots"]  = "Solo puede ser construido en puntos de petróleo!"
    zrush.language.VGUI.MachineBuilder["CanonlybuildDrillhole"]  = "Solo se puede construir en agujeros de taladro!"
    zrush.language.VGUI.MachineBuilder["NotenoughSpace"]  = "No hay espacio suficiente!"
    zrush.language.VGUI.MachineBuilder["ConnectionLost"]  = "Conexión perdida!"
    zrush.language.VGUI.MachineBuilder["ReachedMaxDrillhole"]  = "Se ha alcanzado el punto máximo de agujeros de perforación!"

    zrush.language.Inv["InvEmpty"] = "Tu inventario de combustible está vacío!"
    zrush.language.Inv["FuelInv"] = "Inventario de combustible: "

    zrush.language.VGUI["speed"] = "Aumento de velocidad"
    zrush.language.VGUI["production"] = "Aumento de producción"
    zrush.language.VGUI["antijam"] = "Aumento anti-atascos"
    zrush.language.VGUI["cooling"] = "Aumento de refrigeración"
    zrush.language.VGUI["refining"] = "Aumento de refinería"
    zrush.language.VGUI["pipes"] = "Tuberías extra"

    zrush.language.VGUI.MachineBuilder["MachineLimitReached"] = "¡Límite de máquina alcanzado!"
end
