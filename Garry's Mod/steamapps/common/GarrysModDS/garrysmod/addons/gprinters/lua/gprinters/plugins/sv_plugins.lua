if CLIENT then return end

util.AddNetworkString( "gPrinters.changeSetting" )
util.AddNetworkString( "gPrinters.syncSettings" )
util.AddNetworkString( "gPrinters.sncPrinters" )

function gPrinters.changeSetting( plugin, setting, value )
	gPrinters.plugins[ plugin ][ setting ] = value
	file.Write( "gprinters/settings/" .. string.lower( string.Replace( plugin, " ", "_" ) ) .. ".txt", util.TableToJSON( gPrinters.plugins[ plugin ] ) )
	for k, v in pairs( player.GetAll() ) do
		if v:IsSuperAdmin() then
			gPrinters.syncPlugins( v, plugin )
		end
	end
end

net.Receive( "gPrinters.changeSetting", function( len, ply )
	if not ply:IsSuperAdmin() then return end
	local data = net.ReadTable()
	gPrinters.changeSetting( data.plugin, data.setting, data.value )
end )

function gPrinters.registerPlugin( name, settings )
	gPrinters.plugins[ name ] = settings

	if not file.Exists( "gprinters/settings/" .. string.lower( string.Replace( name, " ", "_" ) ) .. ".txt", "DATA" ) then
		file.Write( "gprinters/settings/" .. string.lower( string.Replace( name, " ", "_" ) ) .. ".txt", util.TableToJSON( settings ) )
	else
		plugins = gPrinters.plugins[ name ]
		local currentTable = util.JSONToTable( file.Read( "gprinters/settings/" .. string.lower( string.Replace( name, " ", "_" ) ) .. ".txt" ) )


		for k, v in pairs( plugins ) do
			for _, v2 in pairs( currentTable ) do
				if k == _ then
					plugins[ k ] = nil
				end
			end
		end

		table.Merge( currentTable, plugins )
		file.Write( "gprinters/settings/" .. string.lower( string.Replace( name, " ", "_" ) ) .. ".txt", util.TableToJSON( currentTable ) )
		gPrinters.plugins[ name ] = util.JSONToTable( file.Read( "gprinters/settings/" .. string.lower( string.Replace( name, " ", "_" ) ) .. ".txt" ) )
	end
end

function gPrinters.registerPrinter( name, settings )
	gPrinters.printers[ name ] = settings

	if not file.Exists( "gprinters/printers/" .. string.lower( string.Replace( name, " ", "_" ) ) .. ".txt", "DATA" ) then
		file.Write( "gprinters/printers/" .. string.lower( string.Replace( name, " ", "_" ) ) .. ".txt", util.TableToJSON( settings ) )
	else
		local oldTable = {}
		oldTable = util.JSONToTable( file.Read( "gprinters/printers/" .. string.lower( string.Replace( name, " ", "_" ) ) .. ".txt" ) )
		table.Merge( oldTable, gPrinters.printers[ name ] )
		file.Write( "gprinters/printers/" .. string.lower( string.Replace( name, " ", "_" ) ) .. ".txt", util.TableToJSON( oldTable ) )
		gPrinters.printers[ name ] = util.JSONToTable( file.Read( "gprinters/printers/" .. string.lower( string.Replace( name, " ", "_" ) ) .. ".txt" ) )
	end

	for k, v in pairs( player.GetAll() ) do
		gPrinters.syncPrinters( v, "Printers" )
	end

	for k, v in pairs( gPrinters.printers[ name ] ) do
		gPrinters.addPrinter( v.name, {
			model = v.model,
			name = v.name,
			color = v.color,
			health = v.health,
			sound = v.sound,
			attachment = v.attachment,
			gcolor = v.gcolor,
			pamount = v.pamount,
			ptime = v.ptime,
			ochance = v.ochance,
			poverh = v.poverh,
			cpremove = v.cpremove,
			remrew = v.remrew,
			category = v.category,
			rank = v.rank,
			sortOrder = v.sortOrder,
			pmaxamount = v.pmaxamount,
			plevel = v.plevel,
			donationrank = v.donationrank
		}, v.cmd )
	end
end

function gPrinters.removePrinter( key )
	local oldTable = util.JSONToTable( file.Read( "gprinters/printers/printers.txt" ) )
	if table.HasValue( oldTable, oldTable[ key ] ) then
		oldTable[ key ] = nil
		file.Write( "gprinters/printers/printers.txt", util.TableToJSON( oldTable ) )
		gPrinters.printers[ "Printers" ] = util.JSONToTable( file.Read( "gprinters/printers/printers.txt" ) )
		for k, v in pairs( player.GetAll() ) do
			gPrinters.syncPrinters( v, "Printers" )
		end
	end
end


function gPrinters.syncPlugins( ply, plugin )
	if plugin then
		net.Start( "gPrinters.syncSettings" ) net.WriteString( plugin ) net.WriteTable( gPrinters.plugins[ plugin ] ) net.Send( ply )
	else
		for pg, data in pairs( gPrinters.plugins ) do
			net.Start( "gPrinters.syncSettings" ) net.WriteString( pg ) net.WriteTable( data ) net.Send( ply )
		end
	end
end

function gPrinters.syncPrinters( ply, plugin )
	if plugin then
		net.Start( "gPrinters.sncPrinters" )
		net.WriteString( plugin )
		net.WriteTable( gPrinters.printers[ plugin ] )
		net.Send( ply )
	else
		for pg, data in pairs( gPrinters.printers ) do
			net.Start( "gPrinters.sncPrinters" )
			net.WriteString( pg )
			net.WriteTable( data )
			net.Send( ply )
		end
	end
end


hook.Add( "PlayerInitialSpawn", "gPrinters.syncSystem", function( ply )
	gPrinters.syncPlugins( ply )
	gPrinters.syncPrinters( ply )

	if SG && ply:IsSuperAdmin() then
		net.Start "SG.SendGroups"
		net.WriteTable( SG.Save.CurrentGroups )
		net.Send( ply )
	end
end )

function gPrinters.createFolders()
	file.CreateDir( "gprinters/settings/" )
	file.CreateDir( "gprinters/printers/" )
end

gPrinters.createFolders()