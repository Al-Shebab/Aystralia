--[[
	gPrinters Plugins
	Version 1.0.0
]]

function gPrinters.addLang( plugin, variable, translation )
	gPrinters.lang[ plugin ] = gPrinters.lang[ plugin ] or {}
	gPrinters.lang[ plugin ][ variable ] = translation
end

if CLIENT then
	gPrinters.addLang( "General", "adminNotify", "Notify the owner about the command when he/she initial spawns" )
	gPrinters.addLang( "General", "displayBorders", "Display printers custom borders?" )
	gPrinters.addLang( "General", "showSparks", "Show printers sparks while printing?" )
	gPrinters.addLang( "General", "pickupNotification", "Enable money withdrawal notification?" )
	gPrinters.addLang( "General", "pickupNote", "Printer withdrawal notification" )
	gPrinters.addLang( "General", "waterDestroy", "Destroy printers under water?" )
	--
	gPrinters.addLang( "General", "cpNotification", "Enable notification when found by police?" )
	gPrinters.addLang( "General", "ownerNote", "Printer owner message when found" )
	gPrinters.addLang( "General", "Collisions", "Disable printer collisions with humans?" )

	gPrinters.addLang( "General", "destroyNotify", "Notify when the printer is destroyed?" )
	gPrinters.addLang( "General", "destroyMsg", "Notification when the printer is destroyed" )
	gPrinters.addLang( "General", "setwantedwhenfound", "Set the owner of the printer wanted when the printer is found by a cp" )

	--Upgrades Improvement

	gPrinters.addLang( "General", "morePrint", "How much % the printer will print extra?" )
	gPrinters.addLang( "General", "powerUpgrade", "How much time will be reduced the print-time in %?" )
	gPrinters.addLang( "General", "armorUpgrade", "How much armor will be added with the upgrade." )

	gPrinters.addLang( "General", "antenaRange", "Distance of response of your printer with antenna upgrade." )

	gPrinters.addLang( "General", "notifyOwner", "Notify the owner when someone's try to steal money when secured." )
	gPrinters.addLang( "General", "secureMsg", "Printer's message when it's secured." )
	gPrinters.addLang( "General", "stealerMsg", "Message to the stealer when he use the printer with security on." )

	gPrinters.addLang( "General", "oheatMsg", "Notify if the printer is overheating?" )
	gPrinters.addLang( "General", "overheatMsg", "Overheat message" )

	--Upgrade Prices
	gPrinters.addLang( "General", "antennaup", "Antenna upgrade cost" )
	gPrinters.addLang( "General", "armourup", "Armour upgrade cost" )
	gPrinters.addLang( "General", "fanup", "Fan upgrade cost" )
	gPrinters.addLang( "General", "moreprintup", "Extra print upgrade cost" )
	gPrinters.addLang( "General", "silencerup", "Silencer upgrade cost" )
	gPrinters.addLang( "General", "pipesup", "Printer speed boost cost" )
	gPrinters.addLang( "General", "scannerup", "Scanner upgrade cost" )
	gPrinters.addLang( "General", "printersCommand", "If you have antenna upgrade use this command to open the menu !printers or /printers" )
	gPrinters.addLang( "General", "adminCommand", "Admin menu command" )

	gPrinters.addLang( "General", "fireSystem", "Use DarkRP Fire System by Crap-Head" )

	gPrinters.addLang( "General", "antenna", "Enable antenna attachment? if attachments are enabled?" )
	gPrinters.addLang( "General", "armour", "Enable armour attachment? if attachments are enabled?" )
	gPrinters.addLang( "General", "cooler", "Enable cooler attachment? if attachments are enabled?" )
	gPrinters.addLang( "General", "moreprint", "Enable more print attachment? if attachments are enabled?" )
	gPrinters.addLang( "General", "silencer", "Enable silencer attachment? if attachments are enabled?" )
	gPrinters.addLang( "General", "fastprint", "Enable fast print attachment? if attachments are enabled?" )
	gPrinters.addLang( "General", "scanner", "Enable scanner attachment? if attachments are enabled?" )

	gPrinters.addLang( "General", "expsystem", "Using Vrondakis Leveling System? Enable this for exp" )
	gPrinters.addLang( "General", "exppercentage", "This is the % of money that will transform into experience. ( default 5% of the printer money )" )

	gPrinters.addLang( "General", "removeOwner", "Remove the printer if the owner is not valid." )

	gPrinters.addLang( "General", "canPocket", "Users can pocket gPrinters" )
	gPrinters.addLang( "Other", "adminSystem", "Choose your admin addon" )

end

if SERVER then
	--General Settings
	timer.Simple( 1, function()
	local settings = {}
	settings.adminNotify = true
	settings.displayBorders = true
	settings.showSparks = true
	settings.pickupNotification = true
	settings.pickupNote = "You've collected $%i"
	settings.waterDestroy = true
	settings.cpNotification = true
	settings.ownerNote = "Your printer has been found, be careful!"
	settings.destroyNotify = true
	settings.destroyMsg = "Your printer has exploded!"
	settings.oheatMsg = true
	settings.overheatMsg = "Your printer is overheating!"
	settings.Collisions = true
	settings.setwantedwhenfound = true
	settings.notifyOwner = true
	settings.secureMsg = "%s is trying to steal your money"
	settings.stealerMsg = "The printer is secured, you can destroy the scanner to take money."
	settings.morePrint = 25
	settings.powerUpgrade = 25
	settings.armorUpgrade = 100
	settings.antennaup = 10000
	settings.armourup = 10000
	settings.fanup = 10000
	settings.moreprintup = 10000
	settings.silencerup = 10000
	settings.pipesup = 10000
	settings.scannerup = 10000
	settings.antenaRange = 1000
	settings.printersCommand = "printers"
	settings.adminCommand = "gsettings"
	settings.removeOwner = true
	settings.antenna = true
	settings.armour = true
	settings.cooler = true
	settings.moreprint = true
	settings.silencer = true
	settings.fastprint = true
	settings.scanner = true
	settings.fireSystem = false
	settings.canPocket = true

	settings.expsystem = false
	settings.exppercentage = 5

	local admin = {}
	admin.adminSystem = ""
	gPrinters.registerPlugin( "Other", admin )
	gPrinters.registerPlugin( "General", settings )

	local printers = {}
	gPrinters.registerPrinter( "Printers", printers )

	end )
end

hook.Add( "canPocket", "gPrinters.restrictionPocket", function( ply, item )
	if ( item:GetClass() == "gattachment" ) then return false, DarkRP.getPhrase("cannot_pocket_x") end
	if ( gPrinters.plugins[ "General" ].canPocket == true ) && ( item.Base == "gprinter" ) then
		return true
	elseif ( item.Base == "gprinter" ) then
		return false, DarkRP.getPhrase("cannot_pocket_x")
	end
end )

timer.Simple( 5, function ()
	function gPrinters.loadCustom()
		for _, printer in pairs( gPrinters.printers or {} ) do
			for k, v in pairs( gPrinters.printers[ "Printers" ][ printer ] or printer ) do
				local tblEnt = {}
				tblEnt.name = v.name
				tblEnt.ent = v.cmd
				tblEnt.model = v.model
				tblEnt.price = tonumber( v.f4price )
				tblEnt.max = tonumber( v.f4amount )
				tblEnt.cmd = v.cmd

				if ( #v.jobs > 0 ) then
					tblEnt.allowed = v.jobs
				end


				tblEnt.customCheck = function( ply )
					if SG && v.secondary_group && table.HasValue( v.secondary_group, ply:GetSecondaryUserGroup() ) then
						return ply
					end
					if v.rank >= 1 then
						return table.HasValue( v.ranks, gPrinters.adminModes[ gPrinters.plugins[ "Other" ].adminSystem ].rankFunction( ply ) )
					end
				end

				tblEnt.CustomCheckFailMsg = function( ply )
					local var = 0
					if v.secondary_group then
						var = #v.secondary_group
					end

					if v.rank >= 1 or var >= 1 then
						return "You're not in the correct group!"
					else
						return ply
					end
				end

				tblEnt.category = v.category
				tblEnt.sortOrder = tonumber( v.sortOrder )
				tblEnt.level = tonumber( v.plevel )
				tblEnt.donationrank = tonumber( v.donationrank ) or nil
				DarkRP.createEntity(v.name, tblEnt )
			end
		end
	end
end )