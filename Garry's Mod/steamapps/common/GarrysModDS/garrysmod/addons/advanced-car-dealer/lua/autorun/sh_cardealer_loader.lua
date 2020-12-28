AdvCarDealer = AdvCarDealer or {}
AdvCarDealer.Config = {}
AdvCarDealer.Config.CarDealerSpawns = {}
AdvCarDealer.Config.GarageSpawns = {}
AdvCarDealer.Config.EntitiesSpawns = {}
AdvCarDealer.Config.GarageZones = {}
AdvCarDealer.Config.Vehicles = {}
AdvCarDealer.Config.JobGarage = {}
AdvCarDealer.Language = {}
AdvCarDealer.Language.Sentences = {}
AdvCarDealer.CustomChecks = {}

AdvCarDealer.DatabaseVersion = 1

-- do not touch this except if I explicitly tell you to.
AdvCarDealer.InternalGhosting = true

if SERVER then

AdvCarDealer.VehiclesOut = AdvCarDealer.VehiclesOut or {}
AdvCarDealer.SQL = {}
AdvCarDealer.SQL.Config = {}
AdvCarDealer.RentedVehicles = AdvCarDealer.RentedVehicles or {}
AdvCarDealer.CarDealerFactures = AdvCarDealer.CarDealerFactures or {}
AdvCarDealer.ListVehiclesSpawned = AdvCarDealer.ListVehiclesSpawned or {}

AdvCarDealer.NOTIFY_HINT = 0
AdvCarDealer.NOTIFY_ERROR = 1

elseif CLIENT then

AdvCarDealer.UIColors = {}
AdvCarDealer.UnderglowVehicles = AdvCarDealer.UnderglowVehicles or {}
AdvCarDealer.RentedVehicles = AdvCarDealer.RentedVehicles or {}
AdvCarDealer.ListVehiclesSpawned = AdvCarDealer.ListVehiclesSpawned or {}

end

local loadingFilesMessage = [[
-----------------------------------------
	Advanced Car Dealer :
	LOADING FILES
-----------------------------------------
]]

local finishedLoadingFilesMessage = [[
-----------------------------------------
	Advanced Car Dealer :
	FILES LOADED
-----------------------------------------
]]

function AdvCarDealer:LoadFiles()

	if SERVER then 
		Msg( loadingFilesMessage )
	end

	local sharedFiles = file.Find( "advancedcardealer/shared/*", "LUA" )
	for k, v in pairs( sharedFiles ) do
		include( "advancedcardealer/shared/" .. v )

		if SERVER then
			AddCSLuaFile( "advancedcardealer/shared/" .. v )
		end

		print( "[ Advanced Car Dealer ] Loaded " .. v )
	end

	local configFiles = file.Find( "advancedcardealer/*", "LUA" )
	for k, v in pairs( configFiles ) do
		include( "advancedcardealer/" .. v )

		if SERVER then
			AddCSLuaFile( "advancedcardealer/" .. v )
		end

		print( "[ Advanced Car Dealer ] Loaded " .. v )
	end

	if SERVER then
		local serverFiles = file.Find( "advancedcardealer/server/*", "LUA" )
		for k, v in pairs( serverFiles ) do
			include( "advancedcardealer/server/" .. v )
			
			print( "[ Advanced Car Dealer ] Loaded " .. v )
		end
	end

	local clientFiles = file.Find( "advancedcardealer/client/*", "LUA" )
	for k, v in pairs( clientFiles ) do
		if CLIENT then
			include( "advancedcardealer/client/" .. v )
		elseif SERVER then
			AddCSLuaFile( "advancedcardealer/client/" .. v )
		end

		print( "[ Advanced Car Dealer ] Loaded " .. v )
	end

	hook.Run( "AdvancedCarDealer.OnScriptLoaded" )

	if SERVER then 
		Msg( finishedLoadingFilesMessage )
	end
end

function AdvCarDealer.GetConfig()
	return AdvCarDealer.Config or {}
end

local filesLoaded
if KVS then
	AdvCarDealer:LoadFiles()
	filesLoaded = true
else
	hook.Add( 'KVS.OnKVSLoaded', 'KVS.OnKVSLoaded.CarDealer', function( )
		AdvCarDealer:LoadFiles()
		filesLoaded = true
	end )

	hook.Add( "PlayerInitialSpawn", "PlayerInitialSpawn.KVSNeeded", function( pPlayer )
		if filesLoaded then
			hook.Remove( "PlayerInitialSpawn", "PlayerInitialSpawn.KVSNeeded" )
			return
		end

		MsgC( Color( 255, 0, 0 ), "!!! Some scripts of this server need KVSLib to work !!!\n", Color( 255, 255, 255 ), "Add these contents to make sure everything will work well : https://steamcommunity.com/sharedfiles/filedetails/?id=2031595057")
	end )
end
