--[[---------------------------------------------------------------------------
Door groups
---------------------------------------------------------------------------
The server owner can set certain doors as owned by a group of people, identified by their jobs.


HOW TO MAKE A DOOR GROUP:
AddDoorGroup("NAME OF THE GROUP HERE, you will see this when looking at a door", Team1, Team2, team3, team4, etc.)
---------------------------------------------------------------------------]]


-- Example: AddDoorGroup("Cops and Mayor only", TEAM_CHIEF, TEAM_POLICE, TEAM_MAYOR)
-- Example: AddDoorGroup("Gundealer only", TEAM_GUN)

AddDoorGroup("Government", TEAM_POLICE_OFFICER, TEAM_POLICE_CHIEF, TEAM_SWAT, TEAM_SWAT_HEAVY, TEAM_SWAT_MARKSMAN, TEAM_SWAT_MEDIC, TEAM_SWAT_LEADER, TEAM_UNDERCOVER_COP, TEAM_MAYOR, TEAM_AUTOBOT)
AddDoorGroup("Casino", JOB_CASINO_SECURITY, JOB_CASINO_MANAGER, TEAM_POLICE_OFFICER, TEAM_POLICE_CHIEF, TEAM_SWAT, TEAM_SWAT_HEAVY, TEAM_SWAT_MARKSMAN, TEAM_SWAT_MEDIC, TEAM_SWAT_LEADER, TEAM_UNDERCOVER_COP, TEAM_MAYOR, TEAM_AUTOBOT)
