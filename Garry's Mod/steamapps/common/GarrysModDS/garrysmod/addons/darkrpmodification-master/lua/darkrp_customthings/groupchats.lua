--[[---------------------------------------------------------------------------
Group chats
---------------------------------------------------------------------------
Team chat for when you have a certain job.
e.g. with the default police group chat, police officers, chiefs and mayors can
talk to one another through /g or team chat.

HOW TO MAKE A GROUP CHAT:
Simple method:
GAMEMODE:AddGroupChat(List of team variables separated by comma)

Advanced method:
GAMEMODE:AddGroupChat(a function with ply as argument that returns whether a random player is in one chat group)
This is for people who know how to script Lua.

---------------------------------------------------------------------------]]
GAMEMODE:AddGroupChat(EAM_MAFIA_LEADER, TEAM_MAFIA)
GAMEMODE:AddGroupChat(TEAM_CRIP_LEADER, TEAM_CRIP)
GAMEMODE:AddGroupChat(TEAM_BLOOD_LEADER, TEAM_BLOOD)
GAMEMODE:AddGroupChat(TEAM_MAYOR, TEAM_POLICE_OFFICER, TEAM_POLICE_CHIEF, TEAM_SWAT, TEAM_SWAT_HEAVY, TEAM_SWAT_MARKSMAN, TEAM_SWAT_MEDIC, TEAM_SWAT_LEADER, TEAM_UNDERCOVER_COP)
