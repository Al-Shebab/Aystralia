CH_AdminPopups = CH_AdminPopups or {}
CH_AdminPopups.Config = CH_AdminPopups.Config or {}

-- Debug Mode
CH_AdminPopups.Config.Debug = false -- Debug mode allows admins to send popups too

-- Select Admin Mod
-- Available admin mods: ulx, sam, xadmin, xadmin2, sadmin, fadmin, serverguard, 
CH_AdminPopups.Config.AdminMod = "ulx"

-- Select Prefix
CH_AdminPopups.Config.ReportCommand = "!SBDFRivnasdyuvibnawiuvnws" -- Prefix to create admin popups. DO NOT CHANGE TO @ or //

-- Position
CH_AdminPopups.Config.XPos = 20 -- X cordinate of the popup. Can be changed in case it blocks something important
CH_AdminPopups.Config.YPos = 20 -- Y cordinate of the popup. Can be changed in case it blocks something important

-- General Configuration
CH_AdminPopups.Config.AutoCloseTime = 300 -- the case will auto close after this amount of seconds (SET TO 0 TO DISABLE) (300 = 5 minutes)
CH_AdminPopups.Config.KickMessage = "Kicked by an administrator."
CH_AdminPopups.Config.CaseUpdateOnly = true -- Once a case is claimed, only the claimer sees further updates (false if all should see updates on case (recommended))

CH_AdminPopups.Config.PrintReportCommand = false -- Should the report command be printed to the players in the chat?
CH_AdminPopups.Config.PrintReportCommandInterval = 600 -- How often should we print the command if enabled?

CH_AdminPopups.Config.PrintReportConfirmation = true -- Should players receive a message when their report has been sent?
CH_AdminPopups.Config.PrintReportText = "Your report has been sent to server staff." -- The text to print to the player

CH_AdminPopups.Config.OnDutyJobs = { -- These are the 'on duty' jobs. Clients can restrict notifications to these jobs only
	"Staff on Duty"
}

if CLIENT then
	-- Clients are able to configure these ingame with console, however you can set the default here. Only change the first number after the convar name
	CreateClientConVar( "cl_adminpopups_closeclaimed", 0, true, false ) -- This will autoclose cases claimed by others.
	CreateClientConVar( "cl_adminpopups_dutymode", 0, true, false ) -- see below
	-- 0 = Always show popups
	-- 1 = Show chat messages while on NOT duty
	-- 2 = Show console messages while NOT on duty
	-- 3 = Disable admin messages
end