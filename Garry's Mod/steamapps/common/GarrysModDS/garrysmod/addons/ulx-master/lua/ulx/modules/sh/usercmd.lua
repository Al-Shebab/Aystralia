-------------------------------------------------------
-- Made By: XxLMM13xXgaming
-------------------------------------------------------

addonurl = "https://steamcommunity.com/sharedfiles/filedetails/?id=2332062788"
discordurl = "https://discord.gg/hWN7zXtbQP"
rulesurl = "https://bit.ly/3mQVodO"
reporturl = "https://forms.gle/pjxfwF9QdkdwMsj57"
bugsurl = "https://bit.ly/2WKFtDB"
applyurl = "https://forms.gle/xugZ5v1Xqy4m2tpr9"

addoncommand = "!addons"
workshopcommand = "!workshop"
discordcommand = "!discord"
rulescommand = "!rules"
reportcommand = "!report"
bugscommand = "!bugs"
applycommand = "!apply"


local CATEGORY_NAME = "Chat"

function ulx.addons( calling_ply )
	calling_ply:SendLua([[gui.OpenURL(addonurl)]])
end
local addons = ulx.command( CATEGORY_NAME, "ulx addons", ulx.addons, addoncommand )
addons:defaultAccess( ULib.ACCESS_ALL )
addons:help( "Opens the collection for the server." )

function ulx.workshop( calling_ply )
	calling_ply:SendLua([[gui.OpenURL(addonurl)]])
end
local workshop = ulx.command( CATEGORY_NAME, "ulx workshop", ulx.workshop, workshopcommand )
workshop:defaultAccess( ULib.ACCESS_ALL )
workshop:help( "Opens the workshop for the server." )

function ulx.discord( calling_ply )
	calling_ply:SendLua([[gui.OpenURL(discordurl)]])
end
local discord = ulx.command( CATEGORY_NAME, "ulx discord", ulx.discord, discordcommand )
discord:defaultAccess( ULib.ACCESS_ALL )
discord:help( "Opens the discord for the server." )

function ulx.rules( calling_ply )
	calling_ply:SendLua([[gui.OpenURL(rulesurl)]])
end
local rules = ulx.command( CATEGORY_NAME, "ulx rules", ulx.rules, rulescommand ) 
rules:defaultAccess( ULib.ACCESS_ALL )
rules:help( "Opens the rules for the server." )

function ulx.report( calling_ply )
	calling_ply:SendLua([[gui.OpenURL(reporturl)]])
end
local report = ulx.command( CATEGORY_NAME, "ulx report", ulx.report, reportcommand )
report:defaultAccess( ULib.ACCESS_ALL )
report:help( "Create a player report!" )

function ulx.bugs( calling_ply )
	calling_ply:SendLua([[gui.OpenURL(bugsurl)]])
end
local bugs = ulx.command( CATEGORY_NAME, "ulx bugs", ulx.bugs, bugscommand )
bugs:defaultAccess( ULib.ACCESS_ALL )
bugs:help( "Report a bug!" )

function ulx.apply( calling_ply )
	calling_ply:SendLua([[gui.OpenURL(applyurl)]])
end
local apply = ulx.command( CATEGORY_NAME, "ulx apply", ulx.apply, applycommand )
apply:defaultAccess( ULib.ACCESS_ALL )
apply:help( "Apply for staff!" )

