RegisterCommand("myid", function(source)
    chatMessage(GetPlayerServerId(source))
ReviveInjuredPed(player)


end)

function chatMessage(msg)
    TriggerEvent("chatMessage", "[Staff Bot #1]:", {255,20,239}, msg)

end

--<MCustomM>