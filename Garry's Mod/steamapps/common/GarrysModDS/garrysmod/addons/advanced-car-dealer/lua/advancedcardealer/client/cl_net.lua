local CFG = AdvCarDealer.GetConfig

net.Receive( "AdvCarDealer.OpenTablet", function()
	AdvCarDealer.OpenTablet( net.ReadEntity() )
end )

net.Receive( "AdvCarDealer.OpenGarage", function()
	AdvCarDealer.OpenGarage( net.ReadEntity(), net.ReadTable(), net.ReadBool() )
end )

net.Receive( "AdvCarDealer.OpenFacture", function()
	AdvCarDealer.OpenFacture( net.ReadEntity() )
end )

net.Receive( "AdvCarDealer.OpenStandMenu", function()
	AdvCarDealer.OpenStandMenu( net.ReadEntity() )
end )

net.Receive( "AdvCarDealer.SendCar", function()
	local iID = net.ReadInt( 32 )
	local Underglow = net.ReadString()
	local IsRented = net.ReadBool()

	if Underglow and Underglow ~= "" then
		AdvCarDealer.UnderglowVehicles[ iID ] = Underglow
	else
		AdvCarDealer.UnderglowVehicles[ iID ] = nil
	end

	if IsRented then
		AdvCarDealer.RentedVehicles[ iID ] = true
	end
end )

net.Receive( "AdvCarDealer.SelectCarStandToClient", function()
	local iIndex = net.ReadInt( 32 )
	local tVehicle = net.ReadTable() or {}

	AdvCarDealer.StandList = AdvCarDealer.StandList or {}
	local eStand = AdvCarDealer.StandList[ iIndex ]
	if IsValid( eStand ) then 
		if tVehicle and istable( tVehicle ) and not table.IsEmpty( tVehicle ) then
			eStand:DrawMenu( tVehicle )
		else
			eStand:ClearMenu()
		end
	else
		AdvCarDealer.StandInfos = AdvCarDealer.StandInfos or {}
		AdvCarDealer.StandInfos[ iIndex ] = tVehicle
	end

end )

net.Receive( "AdvCarDealer.OpenSwitchMenu", function()
	local cardealers = net.ReadTable()
	AdvCarDealer.OpenSwitchingMenu( cardealers or {} )
end )

net.Receive( "AdvCarDealer.ChatMessage", function()
	local msg = net.ReadString() or ""
	AdvCarDealer:ChatMessage( msg )
end )