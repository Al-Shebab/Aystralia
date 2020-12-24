local color = {r = 29, g = 90, b = 245, alpha = 255} -- Color of the text 
local font = 0 -- Font of the text
local time = 500 -- Duration of the display of the text : 500 ~= 13sec

RegisterCommand('me', function(source, args)
    local text = ''
    for i = 1,#args do
        text = text .. ' ' .. args[i]
    end
    text = text .. ' '
	DisplayMeOnly(-1, text)
    TriggerServerEvent('3dme:shareDisplay', text)
end)

RegisterNetEvent('3dme:triggerDisplay')
AddEventHandler('3dme:triggerDisplay', function(text, source)
    if GetPlayerFromServerId(source) ~= -1 then 
        Display(GetPlayerFromServerId(source), text)
    end
end)

function Display(mePlayer, text)
	print("Calling Display: " .. tostring(mePlayer))
	print("Calling GetPlayerPed(mePlayer): " .. tostring(GetPlayerPed(mePlayer)))
    local timer = 0
    while timer < time do
        Wait(0)
        timer = timer + 1
		if mePlayer ~= -1 then
			local coords = GetEntityCoords(GetPlayerPed(mePlayer), false)
			DrawText3DMe(coords['x'], coords['y'], coords['z']+1, text)
		end
    end
end

function DisplayMeOnly(mePlayer, text)
    local timer = 0
    while timer < time do
        Wait(0)
        timer = timer + 1
        local coords = GetEntityCoords(GetPlayerPed(mePlayer), false)
        DrawText3DMe(coords['x'], coords['y'], coords['z']+1, text)
    end
end

function DrawText3DMe(x,y,z, text)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    local dist = #(vector3(px,py,pz)-vector3(x,y,z))
 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(font)
        SetTextProportional(1)
        SetTextColour(color.r, color.g, color.b, color.alpha)
        SetTextDropshadow(1, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        EndTextCommandDisplayText(_x, _y)
    end
end

--<MCustomM>