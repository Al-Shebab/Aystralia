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


if(zrush.config.selectedLanguage == "fr")then

    zrush.language.NPC["FuelBuyer"] = "Acheteur de fioul"
    zrush.language.NPC["Profit"] = "Profit:"
    zrush.language.NPC["YouSold"] = "Vous avez vendu $Amount$UoM $Fuelname pour $Earning$Currency"

    zrush.language.NPC["DialogTransactionComplete"] = "Ravis de faire affaire avec vous !"
    zrush.language.NPC["NoFuel"] = "Si vous n'avez pas de fioul, pourquoi êtes vous ici ?!"

    zrush.language.NPC["Dialog00"] = "Quand t'achètes une maison, il faut bien faire attention à la moisissure."
    zrush.language.NPC["Dialog01"] = "J'ai un Sandwich dans ma poche, avec un peu de moisissure en prime."
    zrush.language.NPC["Dialog02"] = "Les arbres de noël causent des allergies, à cause de la moisissure."
    zrush.language.NPC["Dialog03"] = "Arroser la moisissure avec de la javel n'est pas recommandé !"
    zrush.language.NPC["Dialog04"] = "J'ai toute une collection de moisissure, tu veux la voir ?"
    zrush.language.NPC["Dialog05"] = "Les suppléments riches en Vitamine D aident à lutter contre les allergies de moisissure."
    zrush.language.NPC["Dialog06"] = "La moisissure provoque parfois des rougeurs."
    zrush.language.NPC["Dialog07"] = "Même la moisissure n'arrive pas à venir à bout d'un Happy Meal."
    zrush.language.NPC["Dialog08"] = "Les spores de moisissure sont tout aussi dangereux que les autres spores."
    zrush.language.NPC["Dialog09"] = "La moisissure est utilisée dans la guerre biologique."

    zrush.language.VCMOD["NeedMoreFuel"] = "Vous avez besoin d'au moins 20 litres pour remplir un tonneau!"

    zrush.language.General["AllreadyInUse"] = "Déjà en cours d'utilisation"
    zrush.language.General["YouDontOwnThis"] = "Ceci ne vous appartient pas !"
    zrush.language.General["NoDrillholeFound"] = "Aucun trou de forage trouvé"
    zrush.language.General["NoOilSpotFound"] = "Aucun pétrole trouvé"
    zrush.language.General["OilSpotSpawner"] = "Générateur de pétrole"

    zrush.language.General["NoFreeSocketAvailable"] = "Il n'y a pas de prise libre disponible!"


    zrush.language.DrillTower["AllreadyReachedOil"] = "Vous êtes déjà arrivé jusqu'au pétrole !"
    zrush.language.DrillTower["DrillPipesMissing"] = "Il manque les tubes de forage !"

    zrush.language.Pump["OilSourceEmpty"] = "On dirait qu'il n'y a pas de pétrole par ici"
    zrush.language.Pump["MissingBarrel"] = "Aucun tonneau trouvé!"

    zrush.language.Refinery["MissingOilBarrel"] = "Aucun tonneau de pétrole trouvé!"
    zrush.language.Refinery["MissingEmptyBarrel"] = "Aucun tonneau vide trouvé!"
    zrush.language.VGUI.Refinery["IDLE"] = "En attente"
    zrush.language.VGUI.Refinery["NEED_EMPTY_BARREL"] = "Besoin d'un baril vide!"
    zrush.language.VGUI.Refinery["NEED_OIL_BARREL"] = "Besoin d'huile Barrel!"
    zrush.language.VGUI.Refinery["READY_FOR_WORK"] = "Prêt au raffinage!"
    zrush.language.VGUI.Refinery["FUELBARREL_FULL"] = "Le tonneau de fioul est remplis!"
    zrush.language.VGUI.Refinery["REFINING"] = "Pétrole en raffinage"
    zrush.language.VGUI.Refinery["OVERHEAT"] = "Le raffinage est en surchauffe!"
    zrush.language.VGUI.Refinery["COOLED"] = "Le raffinage s'est refroidit."




    zrush.language.MachineCrate["BuyMachine"] = "<Acheter une machine>"
    zrush.language.MachineCrate["Drill"] = "Foreuse"
    zrush.language.MachineCrate["Burner"] = "Brûleur"
    zrush.language.MachineCrate["Pump"] = "Pompe"
    zrush.language.MachineCrate["Refinery"] = "Raffinerie"
    zrush.language.MachineCrate["Occupied"] = "Occupé par "

    zrush.language.VGUI.DrillHole["NEED_PIPES"] = "Une foreuse manque à l'appel!"
    zrush.language.VGUI.DrillHole["NEED_BURNER"] = "Un brûleur manque à l'appel!"
    zrush.language.VGUI.DrillHole["HAS_BURNER"] = "à un bruleur!"
    zrush.language.VGUI.DrillHole["NO_OIL"] = "La source de pétrole est vide"

    zrush.language.VGUI.DrillTower["DrillTower"] = "Foreuse"
    zrush.language.VGUI.DrillTower["NEED_PIPES"] = "Des tubes de forage sont manquants!"
    zrush.language.VGUI.DrillTower["READY_FOR_WORK"] = "Prêt pour le forage"
    zrush.language.VGUI.DrillTower["IS_WORKING"] = "Forage"
    zrush.language.VGUI.DrillTower["JAMMED"] = "La foreuse est coincée!"
    zrush.language.VGUI.DrillTower["FINISHED_DRILLING"] = "Forage terminé"

    zrush.language.VGUI.Burner["IDLE"] = "En attente!"
    zrush.language.VGUI.Burner["BURNING_GAS"] = "Le gaz brûle!"
    zrush.language.VGUI.Burner["OVERHEAT"] = "Le brûleur est en surchauffe"
    zrush.language.VGUI.Burner["COOLED"] = "Le brûleur est refroidit!"
    zrush.language.VGUI.Burner["NO_GAS_LEFT"] = "Il n'y a plus de gaz!"

    zrush.language.VGUI.Pump["NEED_BARREL"] = "En attente d'un tonneau"
    zrush.language.VGUI.Pump["PUMP_READY"] = "Prêt à pomper !" // (Comme J&M)
    zrush.language.VGUI.Pump["PUMPING"] = "Pompage du pétrole"
    zrush.language.VGUI.Pump["BARREL_FULL"] = "Le tonneau de pétrole est remplit!"
    zrush.language.VGUI.Pump["JAMMED"] = "La pompe est bloquée!"
    zrush.language.VGUI.Pump["NO_OIL"] = "La source de pétrole est vide"

    zrush.language.VGUI.Barrel["BarrelMenu"] = "Menu des tonneaux"
    zrush.language.VGUI.Barrel["BarrelMenuInfo"] = "*Ceci remplira un jerricane VCMod de fioul."
    zrush.language.VGUI.Barrel["BarrelFuelInfo"] = " Tonneau"
    zrush.language.VGUI.Barrel["FuelAmount"] = "Litres de fioul: "
    zrush.language.VGUI.Barrel["Collect"] = "Ramasser"
    zrush.language.VGUI.Barrel["SpawnVCModFuelCan"] = "Générer un tonneau\nVCMod $fueltype"

    zrush.language.VGUI.NPC["FuelBuyer"] = "Acheteur de fioul "
    zrush.language.VGUI.NPC["Sell"] = "Vendre"
    zrush.language.VGUI.NPC["SellAll"] = "Tout vendre" // Même ta mère
    zrush.language.VGUI.NPC["YourFuelInv"] = "Inventaire de fioul"
    zrush.language.VGUI.NPC["SaveInfo"] = "*Cet inventaire ne se sauvegarde PAS Soyez donc sur de vendre tout votre fioul avant de quitter le serveur !"

    zrush.language.VGUI["TimeprePipe"] = "Temps par tube: "
    zrush.language.VGUI["PipesinQueue"] = "Tubes en cours: "
    zrush.language.VGUI["NeededPipes"] = "Tubes nécessaires: "
    zrush.language.VGUI["JamChance"] = "Risque de casse: " // With Jam i mean like the machine breaking down

    zrush.language.VGUI["Speed"] = "Vitesse: "
    zrush.language.VGUI["BurnAmount"] = "Chaleur: "
    zrush.language.VGUI["RemainingGas"] = "Gaz restant: "
    zrush.language.VGUI["OverHeatChance"] =  "Risque de surchauffe: "

    zrush.language.VGUI["NA"] =  "ND" // This is the short version for "Not Available"
    // In french full version if needed: Non disponible

    zrush.language.VGUI["PumpAmount"] = "Nombre de pompes: "
    zrush.language.VGUI["BarrelOIL"] = "Tonneaux (Pétrole): "
    zrush.language.VGUI["RemainingOil"] = "Pétrole restant: "

    zrush.language.VGUI["Fuel"] = "Fioul: "
    zrush.language.VGUI["RefineAmount"] = "Nombre de raffinage: "
    zrush.language.VGUI["RefineOutput"] = "Rendement de raffinage: "
    zrush.language.VGUI["OverHeatChance"] = "Risque de surchauffe: "
    zrush.language.VGUI["BarrelFuel"] = "Tonneau (Fioul): "

    zrush.language.VGUI["Status"] =  "Status: "
    zrush.language.VGUI["pipes"] =  "Tubes supplémentaires: +"
    zrush.language.VGUI["BoostAmount"] =  "Nombre de stimulant: "
    zrush.language.VGUI["FixMachinefirst"] = "En premier temps, répare la machine!"

    zrush.language.VGUI["Actions"] = "Actions:"
    zrush.language.VGUI["Repair"] = "Réparer"
    zrush.language.VGUI["Stop"] = "Eteindre"
    zrush.language.VGUI["Disassemble"] = "Décomposer"
    zrush.language.VGUI["Start"] = "Allumer"
    zrush.language.VGUI["CoolDown"] = "Mettre en veille"

    zrush.language.VGUI["ModuleShop"] = "Magasins de Module"
    zrush.language.VGUI["Purchase"] = "Acheter"
    zrush.language.VGUI["Sell"] = "Vendre"
    zrush.language.VGUI["Locked"] = "Verouillé"
    zrush.language.VGUI["NonSocketfound"] = "Pas d'emplacement\nlibre!"
    zrush.language.VGUI["WrongUserGroup"] = "Mauvais groupe d'utilisateur!"
    zrush.language.VGUI["WrongJob"] = "Mauvais travail!"
    zrush.language.VGUI["TooFarAway"] = "Vous êtes trop eloigné de l'entité!"
    zrush.language.VGUI["Youcannotafford"] = "Vous ne pouvez pas vous payer ceci!"
    zrush.language.VGUI["allreadyinstalled"] = " est déjà installé(e)!"
    zrush.language.VGUI["Youbougt"] =  "Vous avez acheté un $Name pour $Price$Currency"
    zrush.language.VGUI["YouSold"] =  "Vous avez vendu un $Name pour $Price$Currency"

    zrush.language.VGUI["MachineShop"] = "Magasin de Machine"
    zrush.language.VGUI["Place"] = "Placer"

    zrush.language.VGUI.MachineBuilder["BuildEntity"] = " - Construire"
    zrush.language.VGUI.MachineBuilder["Cancel"] = " - Annuler"
    zrush.language.VGUI.MachineBuilder["Needsdrilledfirst"]  = "Nécessite un forage en premier temps!"
    zrush.language.VGUI.MachineBuilder["NeedsBurnerquick"]  = "Nécessite un brûleur rapidement!"
    zrush.language.VGUI.MachineBuilder["NeedsPump"]  = "Nécessite une pompe!"
    zrush.language.VGUI.MachineBuilder["NotValidSpace"]  = "Ceci n'est pas une place valide"
    zrush.language.VGUI.MachineBuilder["ToocloseDrillHole"]  = "Vous êtes trop près d'un autre forage!"
    zrush.language.VGUI.MachineBuilder["CanonlybuildGround"]  = "Ceci peut être seulement construit sur la terre"
    zrush.language.VGUI.MachineBuilder["CanonlybuildOilSpots"]  = "Ceci peut être seulement construit sur des emplacements de pétrole!"
    zrush.language.VGUI.MachineBuilder["CanonlybuildDrillhole"]  = "Ne peut être construit que sur des trous de forage!"
    zrush.language.VGUI.MachineBuilder["NotenoughSpace"]  = "Vous n'avez pas assez de place!"
    zrush.language.VGUI.MachineBuilder["ConnectionLost"]  = "Connexion perdue!"
    zrush.language.VGUI.MachineBuilder["ReachedMaxDrillhole"]  = "Quota de forage maximum atteint!"

    zrush.language.Inv["InvEmpty"] = "Votre inventaire de fioul est vide!"
    zrush.language.Inv["FuelInv"] = "Inventaire de fioul: "

    zrush.language.VGUI["speed"] = "Stimulant en vitesse"
    zrush.language.VGUI["production"] = "Stimulant en production"
    zrush.language.VGUI["antijam"] = "Pack Anti-casse"
    zrush.language.VGUI["cooling"] = "Pack de refroidissement"
    zrush.language.VGUI["refining"] = "Aide au raffinage"
    zrush.language.VGUI["pipes"] = "Tubes supplémentaires"

    zrush.language.VGUI.MachineBuilder["MachineLimitReached"] = "Limite machine atteinte!"
end
