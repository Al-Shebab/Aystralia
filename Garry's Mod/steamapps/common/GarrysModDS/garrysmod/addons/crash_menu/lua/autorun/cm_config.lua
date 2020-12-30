CM = {}

//Increase this if the menu shows on map change.
CM.DelayTime = 30

//What's the title?
CM.Title = "Fuck Sake"

//What message do you want to display when the server has crashed?
CM.Message = "Looks like the server has crashed or been restarted, auto reconnecting in 90 seconds"

//What is the estimated time in seconds it takes for the server to restart after a crash?
CM.ServerRestartTime = 90

CM.BackgroundColor = Color(52, 152, 219)

CM.ButtonColor = Color(236, 240, 241)
CM.ButtonHoverColor = Color(41, 128, 185)

CM.TitleTextColor = Color(236, 240, 241)
CM.MessageTextColor = Color(236, 240, 241)
CM.ButtonTextColor = Color(52, 152, 219)

//Server buttons(Limit 3).
CM.ServerNameButtons = {
	"Server Discord",
	"Steam Group",
	"Manually Reconnect",
}

//Make sure it corresponds to the server names above!
//You can also do websites. Have it start with http://
CM.ServerIPButtons = {
	"https://discord.gg/hWN7zXtbQP",
	"https://steamcommunity.com/groups/Aystralia",
	"139.99.208.69:27015",
}

//Delete the code inside the brackets of both the ServerNameButtons and ServerIPButtons if you don't need server buttons.
