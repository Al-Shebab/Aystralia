fcd.cfg = {}

fcd.cfg.notifyType = 'chat' -- Type of notifications players receive.  Set to 'chat' for chat notifications, 'default' for default darkrp notifications, or 'both' for both types.
fcd.cfg.font = 'Bebas Neue Bold' -- Change this to the font you want (But make sure the font is added to the server's download list. Bebas Neue Bold already is.)

fcd.cfg.underLights = true -- Allow lights to be spawned under the vehicle (Beautiful look)
fcd.cfg.spawnFee = 750 -- Amount player is charged for each car spawn. Set to false to disable

fcd.cfg.entOverheadColor = Color( 25, 255, 25 ) -- Entities overhead text color
fcd.cfg.entDisplayDistance = 500 -- How far a player can be to show the overhead text

fcd.cfg.defaultSellPrice = 50000 -- Default sell vehicle price, just incase the vehicle is not registered anymore
fcd.cfg.sellPercentage = 0.4 -- What percentage of the money is returned to the player when they sell a vehicle
fcd.cfg.vehicleReturnDistance = 400 -- Max distance a vehicle can be to return a vehicle

fcd.cfg.adminRanks = { -- These are the ranks that have access to the admin menu, dealer admin menu, etc...
	'superadmin',
	'admin'
}

fcd.cfg.Modules = {}
fcd.cfg.Modules[ 'vehicleModifications' ] = true -- Allow vehicles to be modified via the menu?
fcd.cfg.Modules[ 'admin' ] = true -- Not sure why you would disable the admin system. Added this so it can load effeciently
fcd.cfg.Modules[ 'chop' ] = true -- Chop Shop

fcd.cfg.Translate = {}
fcd.cfg.Translate[ 'purchased' ] = 'You have purchased %name for %price' -- Message to the player when they purchase a vehicle. %name is the vehicle name and %price is the pirce (required)
fcd.cfg.Translate[ 'sold' ] = 'You have sold %name for %price' -- Message to the player when they sell a vehicle. %name is the vehicle name and %price is the amount rewarded (required)
fcd.cfg.Translate[ 'alreadyOwned' ] = 'You already own the vehicle %name!' -- Message to the player when they attempt to purchase a vehicle they already own. %name is replaced with the vehicle name (required)
fcd.cfg.Translate[ 'notOwned' ] = 'You do not own this vehicle!' -- Message to the player when they attempt to sell a vehicle they don't own
fcd.cfg.Translate[ 'notAffordable' ] = 'You can not afford to purchase a %name!' -- Message to the player when they attempt to purchase a vehicle they can't afford. %name is replaced with the vehicle name (required)
fcd.cfg.Translate[ 'rankRestricted' ] = 'You can not access this vehicle as your current rank!' -- Default message to the player when they attempt to purchase a vehicle without the proper rank. (Will be overridden if specified for the vehicle)
fcd.cfg.Translate[ 'jobRestricted' ] = 'You can not access this vehicle as your current job!' -- Default message to the player when they attempt to purchase a vehicle without the proper job. (Will be overridden if specified for the vehicle)
fcd.cfg.Translate[ 'vehiclesLoaded' ] = 'A total of %amount vehicles have been loaded.' -- Message to the player when their vehicle has been loaded. %amount is the amount of vehicles loaded (required)
fcd.cfg.Translate[ 'dealerNotFound' ] = 'Error finding the dealer specified. Please try again.' -- Message to the player when finding a dealer to spawn a vehicle is unsuccessfull.
fcd.cfg.Translate[ 'vehicleSpawned' ] = 'Your vehicle has been spawned! Look around for it.' -- Message to the player when they spawn a vehicle
fcd.cfg.Translate[ 'alreadySpawned' ] = 'You already have a vehicle spawned! Return it before trying to spawn another one.' -- Message to the player when they try spawning a vehicle whilst having one spawned.
fcd.cfg.Translate[ 'tooFarFromDealer' ] = 'Your vehicle is too far from the car dealer!' -- Message to the player when they try returning a vehicle that's too far from the dealer
fcd.cfg.Translate[ 'vehicleReturned' ] = 'Your vehicle has been returned!' -- Message to the player when they return a vehicle

fcd.cfg.Client = {}
fcd.cfg.Client[ 'bgColor' ] = Color( 0, 0, 0, 115 ) -- Main background color
fcd.cfg.Client[ 'secondaryBgColor' ] = Color( 15, 15, 15, 140 ) -- Secondary background color
fcd.cfg.Client[ 'lineColors' ] = Color( 50, 50, 50, 200 ) -- Color of all lines
fcd.cfg.Client[ 'mainTextColor' ] = Color( 255, 255, 255 ) -- Color of all/most text in the menu(s)
fcd.cfg.Client[ 'titleBgColor' ] = Color( 25, 200, 25, 255 ) -- Color of all panel title backgrounds
fcd.cfg.Client[ 'secondaryTitleBgColor' ] = Color( 25, 175, 25, 255 ) -- Color of all panel title backgrounds
fcd.cfg.Client[ 'closeButtonColor' ] = Color( 25, 150, 25, 255 ) -- Color of all close buttons
fcd.cfg.Client[ 'normalButtonColor' ] = Color( 0, 0, 0, 150 ) -- Normal color of buttons
fcd.cfg.Client[ 'animationSpeed' ] = 0.3 -- Speed of menu animations. 0 being the fastest, and 1 being the slowest
fcd.cfg.Client[ 'textEntryColor' ] = Color( 20, 20, 20, 155 )

fcd.cfg.adminCommands = {}
fcd.cfg.adminCommands[ 'saveDealers' ] = '!savedealers' -- Command to save all dealers in the map
fcd.cfg.adminCommands[ 'initDealers' ] = '!resetdealers' -- Command to remove and spawn saved dealers
fcd.cfg.adminCommands[ 'dealerAdmin' ] = '!dealeradmin' -- Command to open the admin menu for a specific dealer
fcd.cfg.adminCommands[ 'adminMenu' ] = '!fcdadmin' -- Command to open the admin menu that edits vehicles, manages players, etc...
fcd.cfg.adminCommands[ 'togglePlatforms' ] = '!toggleplatforms' -- Command to toggle platforms (hide/show)

fcd.cfg.adminTranslate = {}
fcd.cfg.adminTranslate[ 'adminOnly' ] = 'This command is for admins only!' -- Message to the player when they try using an admin command as a non-admin
fcd.cfg.adminTranslate[ 'dealersSaved' ] = 'All dealers have been saved!' -- Message to the admin when they save all dealers
fcd.cfg.adminTranslate[ 'dealersReset' ] = 'All dealers have been reset!' -- Message to the admin when they reset all dealers
fcd.cfg.adminTranslate[ 'notLookingAtDealer' ] = 'You must be looking at a dealer!' -- Message to the admin when they try opening the dealer admin menu whilst not looking at the dealer
fcd.cfg.adminTranslate[ 'registeredVehicle' ] = 'Vehicle has been registered!'
fcd.cfg.adminTranslate[ 'removedVehicle' ] = 'Vehicle has been removed from all dealers!'

fcd.cfg.chopShopTranslate = {}
fcd.cfg.chopShopTranslate[ 'YourVehicleWasStolen' ] = 'Your vehicle has been stolen!' -- Message to the car owner when someone claims their car
fcd.cfg.chopShopTranslate[ 'Successfull' ] = 'You successfully stole this vehicle! Take it to the chop shop and sell it!' -- Message to the player when they claim a vehicle
fcd.cfg.chopShopTranslate['noStolenVehicle'] = 'You have not claimed a vehicle as stolen!' -- Message to the player when they try using the NPC without claiming a vehicle as stolen!
fcd.cfg.chopShopTranslate[ 'vehicleTooFar' ] = 'The vehicle you are trying to chop is too far from the NPC!' -- Message to the player when they try chopping a vehicle while it's too far
fcd.cfg.chopShopTranslate[ 'vehicleSold' ] = 'The vehicle has been sold for %amount!' -- Message to the player when they chop a vehicle (%amount = price, required!)
fcd.cfg.chopShopTranslate[ 'npcMenuTitle' ] = 'Chop Shop'
fcd.cfg.chopShopTranslate[ 'wrongTeam' ] = 'You are not the correct job to use this NPC!' -- Message to the player when they try to use the NPC while being in the wrong job

fcd.cfg.chopShop = {}
fcd.cfg.chopShop[ 'restrictTeams' ] = true -- Set to true if you want the chop shop to only be available to certain jobs, if true, add the jobs to the table below
fcd.cfg.chopShop[ 'allowedTeams' ] = {
	'Thief',
	'Gangster'
}
fcd.cfg.chopShop[ 'saveNPCsCommand' ] = '!savechop'

fcd.cfg.chopShop[ 'sellDistance' ] = 350 -- Distance a vehicle has to be from the NPC to be able to be chopped  at the chop shop
fcd.cfg.chopShop['SellPercentage'] = 0.05 -- Percentage of the cars price a player receives when chopping a vehicle ( I recommend keeping it below 0.1 )
fcd.cfg.chopShop['defaultSellPrice'] = 750 -- Amount given to the player if the vehicle being chopped is not registered ( for whatever reason, very rare )
fcd.cfg.chopShop[ 'npcModel' ] = 'models/humans/group01/male_01.mdl'
