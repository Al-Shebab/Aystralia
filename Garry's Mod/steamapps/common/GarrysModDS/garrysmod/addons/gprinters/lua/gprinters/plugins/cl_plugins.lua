--[[
	gPrinters Plugins
	Version 1.0.0
]]

net.Receive( "gPrinters.syncSettings", function( len )
	local settings = net.ReadString()
	gPrinters.plugins[ settings ] = net.ReadTable()
end )

net.Receive( "gPrinters.sncPrinters", function( len )
	local settings = net.ReadString()
	gPrinters.printers[ settings ] = net.ReadTable()

	for k, v in pairs( gPrinters.printers[ settings ] ) do
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
			pmaxamount = v.pmaxamount,
			plevel = v.plevel,
			sortOrder = v.sortOrder
		}, v.cmd )
	end

end )