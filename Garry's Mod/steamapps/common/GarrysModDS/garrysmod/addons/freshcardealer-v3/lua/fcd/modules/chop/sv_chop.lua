function fcd.openChopShopMenu(ply, id)
    if !ply then return end
    if !id then return end

    if fcd.hasStolenVehicle(ply) then
        net.Start('fcd_chopshopnpcmenu')
            net.WriteString(id)
            net.WriteEntity(ply.stolenVehicle)
        net.Send(ply)
    else
        fcd.notifyPlayer(ply, fcd.cfg.chopShopTranslate['noStolenVehicle'])
    end
end

function fcd.hasStolenVehicle(ply)
    if !ply then return end

    if ply.vehicleStolen then
        return true
    end

    return false
end

function fcd.stolenVehicleCheck(veh)
    if !veh then return end

    if veh.stolen then
        local stolenBy = veh.stolenBy

        if IsValid(stolenBy) then
            stolenBy.stolenVehicle = nil
            stolenBy.vehicleStolen = false
        end
    end
end

function fcd.stealVehicle(ply, veh)
    if !ply then return end
    if !veh then return end
    if !ply:GetVehicle() == veh then return end

    if veh:IsVehicle() then
        fcd.stolenVehicleCheck(veh)

        if !(veh:getDoorOwner() == ply) or !veh:getDoorOwner() then
            veh.stolenBy = ply
            veh.stolen = true

            ply.stolenVehicle = veh
            ply.vehicleStolen = true

            fcd.notifyPlayer(ply, fcd.cfg.chopShopTranslate[ 'Successfull' ])
        end
    end
end

function fcd.chopSellVehicle(ply, id)
    if !ply then return end
    if !id then return end
    if !fcd.hasStolenVehicle(ply) then return end

    local vehid = ply.stolenVehicle:GetVehicleClass()
    local price = fcd.cfg.chopShop['defaultSellPrice']

    if fcd.dataVehicles[ vehID ] then
          price = fcd.dataVehicles[vehid].price * fcd.cfg.chopShop['sellPercentage']
    end

    local found = false

    for i, v in pairs(ents.FindInSphere(fcd.getChopNPCById(id):GetPos(), fcd.cfg.chopShop['sellDistance'])) do
        if v == ply.stolenVehicle then
            found = true
            break
        end
    end

    if !found then
        fcd.notifyPlayer(ply, fcd.cfg.chopShopTranslate[ 'vehicleTooFar' ])
        return
    end

    ply.stolenVehicle:Remove()
    ply:addMoney(price)

    ply.stolenVehicle = nil
    ply.vehicleStolen = false

    local str = fcd.cfg.chopShopTranslate[ 'vehicleSold' ]
    str = string.Replace( str, '%amount', tostring( price ) )

    fcd.notifyPlayer(ply, str )
end

function fcd.chopShopPlyEnterVeh(ply, veh)
      if veh:GetClass() == "prop_vehicle_prisoner_pod" then return end

    if veh:IsVehicle() then
        fcd.stolenVehicleCheck(veh)

        if !(veh:getDoorOwner() == ply) or !veh:getDoorOwner() then
            if fcd.cfg.chopShop[ 'restrictTeams' ] then
                if not table.HasValue( fcd.cfg.chopShop[ 'allowedTeams' ], team.GetName( ply:Team() ) ) then
                    return
                end
            end

            net.Start('fcd_chopshopmenu')
            net.Send(ply)
        elseif veh:getDoorOwner() == ply then
            veh.stolenBy = nil
            veh.stolen = false
        end
    end
end

hook.Add('PlayerEnteredVehicle', 'fcd.chopShopPlyEnterVeh', fcd.chopShopPlyEnterVeh)

function fcd.chopVehicleRemoved(ent)
    if ent:IsVehicle() then
        fcd.stolenVehicleCheck(ent)
    end
end

hook.Add('EntityRemoved', 'fcd.chopVehicleRemoved', fcd.chopVehicleRemoved)
