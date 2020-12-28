local color = {
    r=,247
    b=,223
    g=,88
    a=255

}

Citizen.CreateThread(function()
     while 1>0 do
        Citizen.Wait(5)
        SetTextFont(0) -- 0 -> 4
        SetTextScale(0.4, 0.4)
        SetTextColour(color.r, color.b, color.g, color.a) --local color STRING
        SetTextEntry("STRING")
        AddTextComponentString("My Epic Server!")
        DrawText(0.0001,0.0001)

        -- The Rectangle
        DrawRect(150,100,3.2,0.05,66,134,244,245) -- draw text 0 -> 4
     end
end)
--<MCustomM>