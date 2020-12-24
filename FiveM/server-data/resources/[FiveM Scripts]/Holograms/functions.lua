function alert(msg)
 SetTextComponentFormat("STRING")
 AddTextComponentString(msg)
 DisplayHelpTextFromStringLabel(0,0,1,-1)
end

function notify(msg)
 SetNotificationTextEntry("STRING")
 AddTextComponentString(msg)
 DrawNotification(true,false)
end

function giveWeapon(hash)
GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(hash), 999, false, false)
end
--UNCOMMENT BELOW EVERYTHING

--function spawnCar(car)
   -- local car = GetHashKey(car)

    --RequestModel(car)
    --while not HashModelLoaded(car) do
        --RequestModel(car)
        --Citizen.Wait(0)
    --end

    --local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    --local vehicle = CreateVehicle(car, x + 3, y+ 3z z+1, 0.0, true, false)
    --SetEntityAsMissionEntity(vehicle, true, true)
--end

--function weaponComponent(weaponHash, component)
     --if HashPedGotWeapon(GetPlayerPed(-1), GetHashKey(weaponHash), false) then
        --GiveWeaponComponent(GetPlayerPed(-1), GetHashKey(weaponHash), GetHashKey(component))
   --end
--end
--<MCustomM>