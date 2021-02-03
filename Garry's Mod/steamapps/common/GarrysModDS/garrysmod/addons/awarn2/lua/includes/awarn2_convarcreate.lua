--[[------------------------------
  AWarn 2
----------------------------------]]
CreateConVar( "awarn_kick", "1", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED }, "Allow AWarn to kick players who reach the kick threshold. 1=Enabled 0=Disabled" )
CreateConVar( "awarn_ban", "1", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED }, "Allow AWarn to ban players who reach the ban threshold. 1=Enabled 0=Disabled" )
CreateConVar( "awarn_decay", "1", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED }, "If enabled, active warning acount will decay over time. 1=Enabled 0=Disabled" )
CreateConVar( "awarn_reasonrequired", "1", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED }, "If enabled, admins must supply a reason when warning someone. 1=Enabled 0=Disabled" )
CreateConVar( "awarn_decay_rate", "30", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED }, "Time (in minutes) a player needs to play for an active warning to decay." )
CreateConVar( "awarn_reset_warnings_after_ban", "0", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED }, "If enabled, active warning count is cleared after a player is banned by awarn. 1=Enabled 0=Disabled" )
CreateConVar( "awarn_logging", "0", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED }, "If enabled, AWarn will log actions to a data file. 1=Enabled 0=Disabled" )
CreateConVar( "awarn_allow_warnadmin", "1", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED }, "Disable to disallow the warning of other admins. 1=Enabled 0=Disabled" )