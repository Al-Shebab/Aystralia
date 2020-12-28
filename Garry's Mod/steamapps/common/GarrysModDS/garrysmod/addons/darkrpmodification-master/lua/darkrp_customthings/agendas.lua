--[[---------------------------------------------------------------------------
DarkRP Agenda's
---------------------------------------------------------------------------
Agenda's can be set by the agenda manager and read by both the agenda manager and the other teams connected to it.


HOW TO MAKE AN AGENDA:
AddAgenda(Title of the agenda, Manager (who edits it), {Listeners (the ones who just see and follow the agenda)})
---------------------------------------------------------------------------]]
-- Example: AddAgenda("Gangster's agenda", TEAM_MOB, {TEAM_GANG})
-- Example: AddAgenda("Police agenda", TEAM_MAYOR, {TEAM_CHIEF, TEAM_POLICE})
AddAgenda("Police agenda", TEAM_MAYOR, {TEAM_POLICE_OFFICER, TEAM_POLICE_CHIEF, TEAM_SWAT, TEAM_SWAT_HEAVY, TEAM_SWAT_MARKSMAN, TEAM_SWAT_MEDIC, TEAM_SWAT_LEADER, TEAM_UNDERCOVER_COP})
AddAgenda("Blood agenda", TEAM_BLOOD_LEADER, {TEAM_BLOOD})
AddAgenda("Crip agenda", TEAM_CRIP_LEADER, {TEAM_CRIP})
AddAgenda("Mafia agenda", TEAM_MAFIA_LEADER, {TEAM_MAFIA})
