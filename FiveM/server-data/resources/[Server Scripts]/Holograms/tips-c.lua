RegisterCommand("help", function()
    notify("~g~Discord: ~n~discord.gg")
    notify("~r~TeamSpeak: ~n~teamspeak.com")
    notify("~p~Admin: ~n~You have called admin, please wait")


 end, false)
 
 function msg(text)
     TriggerEvent("chatMessage", "[EasyTips]", {255,0,0}, text)
 end

 --<MCustomM>