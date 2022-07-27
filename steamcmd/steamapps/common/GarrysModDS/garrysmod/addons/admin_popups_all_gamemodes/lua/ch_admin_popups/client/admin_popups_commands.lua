CH_AdminPopups.Commands = CH_AdminPopups.Commands or {}

--[[
	ULX
	https://github.com/TeamUlysses/ulib
	https://github.com/TeamUlysses/ulx
--]]
CH_AdminPopups.Commands["ulx"] = {}
CH_AdminPopups.Commands["ulx"].Goto = function( ply )
	RunConsoleCommand( "ulx", "goto", ply:Nick() )
end

CH_AdminPopups.Commands["ulx"].Bring = function( ply )
	RunConsoleCommand( "ulx", "bring", ply:Nick() )
end

CH_AdminPopups.Commands["ulx"].Freeze = function( ply )
	RunConsoleCommand( "ulx", "freeze", ply:Nick() )
end

CH_AdminPopups.Commands["ulx"].Unfreeze = function( ply )
	RunConsoleCommand( "ulx", "unfreeze", ply:Nick() )
end

CH_AdminPopups.Commands["ulx"].Return = function( ply )
	RunConsoleCommand( "ulx", "return", ply:Nick() )
end

CH_AdminPopups.Commands["ulx"].Spectate = function( ply )
	RunConsoleCommand( "ulx", "spectate", ply:Nick() )
end

CH_AdminPopups.Commands["ulx"].Kick = function( ply )
	RunConsoleCommand( "ulx", "kick", ply:Nick(), CH_AdminPopups.Config.KickMessage )
end

--[[
	SAM
	https://www.gmodstore.com/market/view/6650
--]]

CH_AdminPopups.Commands["sam"] = {}
CH_AdminPopups.Commands["sam"].Goto = function( ply )
	RunConsoleCommand( "sam", "goto", ply:Nick() )
end

CH_AdminPopups.Commands["sam"].Bring = function( ply )
	RunConsoleCommand( "sam", "bring", ply:Nick() )
end

CH_AdminPopups.Commands["sam"].Freeze = function( ply )
	RunConsoleCommand( "sam", "freeze", ply:Nick() )
end

CH_AdminPopups.Commands["sam"].Unfreeze = function( ply )
	RunConsoleCommand( "sam", "unfreeze", ply:Nick() )
end

CH_AdminPopups.Commands["sam"].Return = function( ply )
	RunConsoleCommand( "sam", "return", ply:Nick() )
end

CH_AdminPopups.Commands["sam"].Spectate = function( ply )
	RunConsoleCommand( "sam", "spectate", ply:Nick() )
end

CH_AdminPopups.Commands["sam"].Kick = function( ply )
	RunConsoleCommand( "sam", "kick", ply:Nick(), CH_AdminPopups.Config.KickMessage )
end

--[[
	XADMIN 1
	https://www.gmodstore.com/market/view/6310
--]]

CH_AdminPopups.Commands["xadmin"] = {}
CH_AdminPopups.Commands["xadmin"].Goto = function( ply )
	RunConsoleCommand( "xadmin_goto", "goto", ply:Nick() )
end

CH_AdminPopups.Commands["xadmin"].Bring = function( ply )
	RunConsoleCommand( "xadmin_bring", "bring", ply:Nick() )
end

CH_AdminPopups.Commands["xadmin"].Freeze = function( ply )
	RunConsoleCommand( "xadmin_freeze", "freeze", ply:Nick() )
end

CH_AdminPopups.Commands["xadmin"].Unfreeze = function( ply )
	RunConsoleCommand( "xadmin_unfreeze", "unfreeze", ply:Nick() )
end

CH_AdminPopups.Commands["xadmin"].Return = function( ply )
	RunConsoleCommand( "xadmin_return", "return", ply:Nick() )
end

CH_AdminPopups.Commands["xadmin"].Spectate = function( ply )
	RunConsoleCommand( "xadmin_spectate", "spectate", ply:Nick() )
end

CH_AdminPopups.Commands["xadmin"].Kick = function( ply )
	RunConsoleCommand( "xadmin_kick", "kick", ply:Nick(), CH_AdminPopups.Config.KickMessage )
end

--[[
	XADMIN 2
	https://www.gmodstore.com/market/view/6941
--]]

CH_AdminPopups.Commands["xadmin2"] = {}
CH_AdminPopups.Commands["xadmin2"].Goto = function( ply )
	RunConsoleCommand( "xadmin", "goto", ply:Nick() )
end

CH_AdminPopups.Commands["xadmin2"].Bring = function( ply )
	RunConsoleCommand( "xadmin", "bring", ply:Nick() )
end

CH_AdminPopups.Commands["xadmin2"].Freeze = function( ply )
	RunConsoleCommand( "xadmin", "freeze", ply:Nick() )
end

CH_AdminPopups.Commands["xadmin2"].Unfreeze = function( ply )
	RunConsoleCommand( "xadmin", "unfreeze", ply:Nick() )
end

CH_AdminPopups.Commands["xadmin2"].Return = function( ply )
	RunConsoleCommand( "xadmin", "return", ply:Nick() )
end

CH_AdminPopups.Commands["xadmin2"].Spectate = function( ply )
	RunConsoleCommand( "xadmin", "spectate", ply:Nick() )
end

CH_AdminPopups.Commands["xadmin2"].Kick = function( ply )
	RunConsoleCommand( "xadmin", "kick", ply:Nick(), CH_AdminPopups.Config.KickMessage )
end

--[[
	SADMIN
	https://www.gmodstore.com/market/view/7590
--]]

CH_AdminPopups.Commands["sadmin"] = {}
CH_AdminPopups.Commands["sadmin"].Goto = function( ply )
	RunConsoleCommand( "sa", "goto", ply:Nick() )
end

CH_AdminPopups.Commands["sadmin"].Bring = function( ply )
	RunConsoleCommand( "sa", "bring", ply:Nick() )
end

CH_AdminPopups.Commands["sadmin"].Freeze = function( ply )
	RunConsoleCommand( "sa", "freeze", ply:Nick() )
end

CH_AdminPopups.Commands["sadmin"].Unfreeze = function( ply )
	RunConsoleCommand( "sa", "unfreeze", ply:Nick() )
end

CH_AdminPopups.Commands["sadmin"].Return = function( ply )
	RunConsoleCommand( "sa", "return", ply:Nick() )
end

CH_AdminPopups.Commands["sadmin"].Kick = function( ply )
	RunConsoleCommand( "sa", "kick", ply:Nick(), CH_AdminPopups.Config.KickMessage )
end

--[[
	FADMIN
--]]

CH_AdminPopups.Commands["fadmin"] = {}
CH_AdminPopups.Commands["fadmin"].Goto = function( ply )
	RunConsoleCommand( "fadmin", "goto", ply:UserID() )
end

CH_AdminPopups.Commands["fadmin"].Bring = function( ply )
	RunConsoleCommand( "fadmin", "bring", ply:UserID() )
end

CH_AdminPopups.Commands["fadmin"].Freeze = function( ply )
	RunConsoleCommand( "fadmin", "freeze", ply:UserID() )
end

CH_AdminPopups.Commands["fadmin"].Unfreeze = function( ply )
	RunConsoleCommand( "fadmin", "unfreeze", ply:UserID() )
end

CH_AdminPopups.Commands["fadmin"].Spectate = function( ply )
	RunConsoleCommand( "FSpectate", ply:UserID() )
end

CH_AdminPopups.Commands["fadmin"].Return = function( ply )
	RunConsoleCommand( "fadmin", "return", ply:UserID() )
end

CH_AdminPopups.Commands["fadmin"].Kick = function( ply )
	RunConsoleCommand( "fadmin", "kick", ply:UserID(), CH_AdminPopups.Config.KickMessage )
end

--[[
	SERVERGUARD
	https://www.gmodstore.com/market/view/1847
--]]

CH_AdminPopups.Commands["serverguard"] = {}
CH_AdminPopups.Commands["serverguard"].Goto = function( ply )
	RunConsoleCommand( "sg", "goto", ply:Nick() )
end

CH_AdminPopups.Commands["serverguard"].Bring = function( ply )
	RunConsoleCommand( "sg", "bring", ply:Nick() )
end

CH_AdminPopups.Commands["serverguard"].Freeze = function( ply )
	RunConsoleCommand( "sg", "freeze", ply:Nick() )
end

CH_AdminPopups.Commands["serverguard"].Unfreeze = function( ply )
	RunConsoleCommand( "sg", "unfreeze", ply:Nick() )
end

CH_AdminPopups.Commands["serverguard"].Return = function( ply )
	RunConsoleCommand( "sg", "return", ply:Nick() )
end

CH_AdminPopups.Commands["serverguard"].Spectate = function( ply )
	RunConsoleCommand( "sg", "spectate", ply:Nick() )
end

CH_AdminPopups.Commands["serverguard"].Kick = function( ply )
	RunConsoleCommand( "sg", "kick", ply:Nick(), CH_AdminPopups.Config.KickMessage )
end