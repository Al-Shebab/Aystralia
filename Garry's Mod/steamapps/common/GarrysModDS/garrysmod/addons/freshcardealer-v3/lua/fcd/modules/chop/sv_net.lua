util.AddNetworkString 'fcd_chopshopmenu'
util.AddNetworkString 'fcd_chopshopyes'
util.AddNetworkString 'fcd_chopshopnpcmenu'
util.AddNetworkString 'fcd_chopshopsellvehicle'

net.Receive('fcd_chopshopyes', function( len, ply )
    local veh = net.ReadEntity()

    fcd.stealVehicle(ply, veh)
--    ply:wanted(ply, 'Vehicle Theft')

    if veh:getDoorOwner() and IsValid(veh:getDoorOwner()) then
  	  fcd.notifyPlayer( veh:getDoorOwner(), fcd.cfg.chopShopTranslate[ 'YourVehicleWasStolen' ] )
    end
end)

net.Receive('fcd_chopshopsellvehicle', function( len, ply )
    local id = net.ReadString()

    fcd.chopSellVehicle(ply, id)
end)
