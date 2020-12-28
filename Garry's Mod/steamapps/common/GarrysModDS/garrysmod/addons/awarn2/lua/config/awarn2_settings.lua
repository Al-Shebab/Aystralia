--[[------------------------------
  AWarn 2
----------------------------------]]
AWarn.Config = {}
AWarn.Config.PunishmentSequence = AWarn.Config.PunishmentSequence or {}


AWarn.MySQLConfig = {}

function AWarn.RegisterPunishment( TBL )
	AWarn.Config.PunishmentSequence[ TBL.NumberOfWarnings ] = TBL
end

AWarn.MySQLConfig.mysql_config = {
	EnableMySQL			=	false, 				--Change to true to enable MySQL. This requires you have MySQLOO installed and configured.
	Host				=	"127.0.0.1", 		--MySQL Server IP
	Username			=	"root", 			--MySQL User with access to the database for awarn2
	Password			=	"", 				--Password for the above user
	Database_name		=	"awarn2", 			--Existing database on the MYSQL server. IMPORTANT: AWarn2 WILL NOT Create a database, you need to create the database.
	Database_port		=	3306,
	Preferred_module	=	"mysqloo", 			--Only MySQLOO is supported.
	MultiStatements		=	false, 				--Keep this as false unless you know what you are doing.
}
AWarn.MySQLConfig.ServerKey	=	"Server 1"			--If you run multiple servers using the same database, this is how you can identify which warnings came from which server.

--Groups added to this blacklist can not be warned by anyone, ever.
AWarn.Config.groupBlacklist = {
	"superadmin",
}

--SteamID's added to this blacklist can not be warned by anyone, ever.
AWarn.Config.userBlacklist = {
	"STEAM_0:0:103364981",
}


AWarn.RegisterPunishment( {
	NumberOfWarnings 	=	3,
	PunishmentType 		=	"kick",
	PunishmentMessage	=	"AWarn: You have been kicked for exceeding the warning threshold",
	PunishmentLength 	=	nil,
} )


AWarn.RegisterPunishment( {
	NumberOfWarnings 	=	5,
	PunishmentType 		=	"ban",
	PunishmentMessage	=	"AWarn: You have been temporarily banned for exceeding the warning threshold",
	PunishmentLength 	=	120,
} )


AWarn.RegisterPunishment( {
	NumberOfWarnings 	=	10,
	PunishmentType 		=	"ban",
	PunishmentMessage	=	"AWarn: You have been temporarily banned for exceeding the warning threshold",
	PunishmentLength 	=	1440,
} )
