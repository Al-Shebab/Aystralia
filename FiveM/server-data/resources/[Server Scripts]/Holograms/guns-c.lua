RegisterCommand("deletegun", function()
   RemoveAllPedWeapons(GetPlayerPed(-1), true)
   notify("~r~Your weapons have been deleted!")
end)
    -- UNCOMMENT THIS SHIT BELOW

--local cars = {"adder", "comet", "cheetah", "zentorno", "hakuchou"}
--RegisterCommand("car", function()

    --local car = (cars[math.random(#cars)])
    --spawnCar(car)
    --notify("~r~Spawned car: ~h~~y~" .. car)

--end)


--RegisterCommand("die", function()
    --SetEntityHealth(PlayerPedId(), 0)
    --notify("~r~You died.")


--end)


-- Citizen.CreateThread(function()

    --local h_key = 74
    --local x_key = 73 
    --while true do
        --Citizen.Wait(1)
        --if IsControlJustReleased(1, 74) then
            --print("The key ".. 74 .. " was pressed")
            --giveWeapon("weapon_pistol")
            --giveWeapon("weapon_pumpshotgun")
            --weaponComponent("weapon_pumpshotgun", "COMPONENT_AT_AR_FLSH")
            --weaponComponent("weapon_pumpshotgun", "COMPONENT_AT_SR_SUPP")
            --giveWeapon("weapon_knife")
            --alert ("~r~Given Weapons with ~INPUT_VEH_HEADLIGHT~")
        --end
    --end

--end)

--<MCustomM>