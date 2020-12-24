net.Receive( 'fcd.notifyPlayer', function()
	local msg = net.ReadString() or ''

	chat.AddText( Color(25, 255, 25), 'FRESH CAR DEALER: ', color_white, msg )
end)

net.Receive( 'fcd.openMenu', function()
	fcd.dealerMenu()
end )

net.Receive( 'fcd.sendVehicles', function()
	local data = net.ReadTable()

	fcd.dataVehicles = data
	fcd.formatVehicles()
end )

net.Receive( 'fcd.sendOwned', function()
	local data = net.ReadTable()

	fcd.owned = data
	fcd.formatVehicles()
end )