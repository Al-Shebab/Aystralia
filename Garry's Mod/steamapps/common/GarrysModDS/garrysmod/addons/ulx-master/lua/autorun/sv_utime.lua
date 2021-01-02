-- Written by Team Ulysses, http://ulyssesmod.net/
module( "Utime", package.seeall )
if not SERVER then return end

utime_welcome = CreateConVar( "utime_welcome", "1", FCVAR_ARCHIVE )

if not sql.TableExists( "utime" ) then
	sql.Query( "CREATE TABLE IF NOT EXISTS utime ( id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, player INTEGER NOT NULL, totaltime INTEGER NOT NULL, lastvisit INTEGER NOT NULL );" )
	sql.Query( "CREATE INDEX IDX_UTIME_PLAYER ON utime ( player DESC );" )
end

hook.Add( "PlayerInitialSpawn", "UTimeInitialSpawn", onJoin )

function updatePlayer( ply )
	sql.Query( "UPDATE utime SET totaltime = " .. math.floor( ply:GetUTimeTotalTime() ) .. " WHERE player = " .. ply:UniqueID() .. ";" )
end
hook.Add( "PlayerDisconnected", "UTimeDisconnect", updatePlayer )

function updateAll()
	local players = player.GetAll()

	for _, ply in ipairs( players ) do
		if ply and ply:IsConnected() then
			updatePlayer( ply )
		end
	end
end
timer.Create( "UTimeTimer", 67, 0, updateAll )
