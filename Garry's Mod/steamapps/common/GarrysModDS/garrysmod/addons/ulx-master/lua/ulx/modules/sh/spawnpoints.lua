local globalspawn
local playerspawns = {}
local jobSpawns = {}

local globalLocalFunctions = {}

if(SERVER) then
	local mapName = game.GetMap()

	if(!file.Exists("jobspawns", "DATA")) then
		file.CreateDir("jobspawns")
	end
	local function writeJobSpawnsFile()
		file.Write("jobspawns/" .. mapName .. ".txt", util.TableToJSON(jobSpawns, true))
	end
	local function readJobSpawnsFile()
		if(!file.Exists("jobspawns/" .. mapName .. ".txt", "DATA")) then
			writeJobSpawnsFile()
		end
		jobSpawns = util.JSONToTable(file.Read("jobspawns/" .. mapName .. ".txt"))
	end
	readJobSpawnsFile()
	
	if(!file.Exists("globalspawns", "DATA")) then
		file.CreateDir("globalspawns")
	end
	local function writeGlobalSpawnFile()
		if(globalspawn == nil) then
			if(file.Exists("globalspawns/" .. mapName .. ".txt")) then
				file.Delete("globalspawns/" .. mapName .. ".txt")
			end
			return
		end
		file.Write("globalspawns/" .. mapName .. ".txt", util.TableToJSON(globalspawn, true))
	end
	globalLocalFunctions.writeGlobalSpawn = writeGlobalSpawnFile
	local function readGlobalSpawnFile()
		if(!file.Exists("globalspawns/" .. mapName .. ".txt", "DATA")) then
			globalspawn = nil
			return
		end
		globalspawn = util.JSONToTable(file.Read("globalspawns/" .. mapName .. ".txt"))
	end
	readGlobalSpawnFile()

	util.AddNetworkString("DRPSP_OpenMenu")
	util.AddNetworkString("DRPSP_GetData")
	util.AddNetworkString("DRPSP_SetData")
	
	net.Receive("DRPSP_GetData", function(len, ply)
		if(!ply:query("ulx managedarkrpspawns")) then return end
	
		net.Start("DRPSP_GetData")
		net.WriteTable(jobSpawns)
		net.Send(ply)
	end)
	
	net.Receive("DRPSP_SetData", function(len, ply)
		if(!ply:query("ulx managedarkrpspawns")) then return end
	
		local type = net.ReadInt(32)
		if(type == 0) then --add new
			jobSpawns[net.ReadString()] = ply:GetPos()
		end
		if(type == 1) then --delete
			jobSpawns[net.ReadString()] = nil
		end
		if(type == 2) then --teleport, this should be its own net msg but fuck it
			ply:SetPos(jobSpawns[net.ReadString()])
		end
		
		writeJobSpawnsFile()
	end)
end

-- global spawn point code
function ulx.setglobalspawn( calling_ply, should_delete )
	if(!should_delete) then
		globalspawn = {
			pos = calling_ply:GetPos(),
			angle = calling_ply:EyeAngles(),
		}
		ulx.fancyLogAdmin( calling_ply, "#A set a global custom spawn point for everybody" )
	else
		if(globalspawn == nil) then
			calling_ply:ChatPrint("There isn't a global spawn yet!")
			return
		end
		globalspawn = nil
		ulx.fancyLogAdmin( calling_ply, "#A deleted the global custom spawn point" )
	end
	
	if(SERVER) then
		globalLocalFunctions.writeGlobalSpawn()
	end
end
local setglobalspawn = ulx.command( "Teleport", "ulx setglobalspawn", ulx.setglobalspawn, {"!setgspawn", "!setglobalspawn"} )
setglobalspawn:defaultAccess( ULib.ACCESS_SUPERADMIN )
setglobalspawn:addParam{ type=ULib.cmds.BoolArg, invisible=true }
setglobalspawn:help( "Sets the global spawnpoint for everybody." )
setglobalspawn:setOpposite( "ulx deleteglobalspawn", { _, true }, {"!deletegspawn", "!deleteglobalspawn"} )

--personal spawn points code
function ulx.setspawn( calling_ply, target_plys, should_delete )
	for k,v in pairs( target_plys ) do
		if(!should_delete) then
			playerspawns[v] = {
				pos = calling_ply:GetPos(),
				angle = calling_ply:EyeAngles(),
			}
		else
			if(playerspawns[v] == nil) then
				calling_ply:ChatPrint("That player doesn't have a spawn yet!")
				return
			end
			playerspawns[v] = nil
		end
	end
	
	if(!should_delete) then
		ulx.fancyLogAdmin( calling_ply, "#A set a custom spawn point for #T", target_plys )
	else
		ulx.fancyLogAdmin( calling_ply, "#A deleted #T's custom spawn point", target_plys )
	end
end
local setspawn = ulx.command( "Teleport", "ulx setspawn", ulx.setspawn, "!setspawn" )
setspawn:addParam{ type=ULib.cmds.PlayersArg, ULib.cmds.optional }
setspawn:addParam{ type=ULib.cmds.BoolArg, invisible=true }
setspawn:defaultAccess( ULib.ACCESS_ALL )
setspawn:help( "Set a player(s) spawn point." )
setspawn:setOpposite( "ulx deletespawn", { _, _, true }, "!deletespawn" )

--darkrp job based spawn points code
function ulx.managedarkrpspawns( calling_ply )
	if(DarkRP != nil) then
		net.Start("DRPSP_OpenMenu")
		net.Send(calling_ply)
	else
		calling_ply:PrintMessage(3, "DarkRP is not detected!")
	end
end
local setjobspawn = ulx.command( "Teleport", "ulx managedarkrpspawns", ulx.managedarkrpspawns, "!managedarkrpspawns" )
setjobspawn:defaultAccess( ULib.ACCESS_SUPERADMIN )
setjobspawn:help( "Manage DarkRP job spawns. If DarkRP is not running, does nothing." )

if(SERVER) then
	local arrestedPlayers = {}
	local deadPlayers = {}
	local recentlyChangedTeamPlayers = {}
	
	hook.Add("PlayerDeath", "customspawnpoints_playerdeath", function(victim, inflictor, attacker)
		deadPlayers[victim] = true
	end)
	
	local function onPlayerArrested(arrested, time, arrester)
		arrestedPlayers[arrested] = true
	end
	hook.Add("playerArrested", "customspawnpoints_playerarrested", onPlayerArrested)
	
	local function onPlayerUnArrested(arrested, unarrester)
		arrestedPlayers[arrested] = nil
	end
	hook.Add("playerUnArrested", "customspawnpoints_unplayerarrested", onPlayerUnArrested)

	--Ripped from ULX source code (https://github.com/TeamUlysses/ulx/blob/master/lua/ulx/modules/sh/teleport.lua). Modified to work with non-entity target
	-- Utility function for bring, goto, and send
	local function playerSend( from, to, force )
		if not util.IsInWorld(to) and not force then return false end -- No way we can do this one

		local yawForward = 0
		local directions = { -- Directions to try
			math.NormalizeAngle( yawForward - 180 ), -- Behind first
			math.NormalizeAngle( yawForward + 90 ), -- Right
			math.NormalizeAngle( yawForward - 90 ), -- Left
			yawForward,
		}

		local t = {}
		t.start = to + Vector( 0, 0, 32 ) -- Move them up a bit so they can travel across the ground
		t.filter = { to, from }

		local i = 1
		t.endpos = to + Angle( 0, directions[ i ], 0 ):Forward() * 47 -- (33 is player width, this is sqrt( 33^2 * 2 ))
		local tr = util.TraceEntity( t, from )
		while tr.Hit do -- While it's hitting something, check other angles
			i = i + 1
			if i > #directions then	 -- No place found
				if force then
					from.ulx_prevpos = from:GetPos()
					from.ulx_prevang = from:EyeAngles()
					return to + Angle( 0, directions[ 1 ], 0 ):Forward() * 47
				else
					return false
				end
			end

			t.endpos = to + Angle( 0, directions[ i ], 0 ):Forward() * 47

			tr = util.TraceEntity( t, from )
		end

		from.ulx_prevpos = from:GetPos()
		from.ulx_prevang = from:EyeAngles()
		return tr.HitPos
	end
	
	local function tryToTeleportPlayer(ply, target)
		timer.Simple(0.01, function()
			local newPos = playerSend(ply, target, true)
			
			if not newPos then -- new position was not found. Let's just teleport him and make him uncollidable for a bit and hope for the best.
				ply:SetPos(target)
				ply:SetMaterial("models/alyx/emptool_glow")
				ply:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
				timer.Simple(4, function()
					if(ply:Alive()) then
						ply:SetMaterial("")
						ply:SetCollisionGroup(0)
					end
				end)
			else
				ply:SetPos(newPos)
			end
		end)
	end
	
	hook.Add("PlayerChangedTeam", "customspawnpoints_changedteam", function(ply, oldTeam, newTeam)
		if(DarkRP != nil) then
			--recentlyChangedTeamPlayers[ply] = true
			local newTeamName = team.GetName(newTeam)
			if(jobSpawns[newTeamName]) then
				tryToTeleportPlayer(ply, jobSpawns[newTeamName])
			end
		end
	end)

	hook.Add("PlayerSpawn", "global_spawn_points_player_spawn", function(ply)
		if(deadPlayers[ply]) then
			deadPlayers[ply] = nil
		
			if(DarkRP != nil) then
				if(jobSpawns[ply:getJobTable().name] && arrestedPlayers[ply] == nil) then --if the player's job spawn is set and he is not arrested
					tryToTeleportPlayer(ply, jobSpawns[ply:getJobTable().name])
				end
				return
			end
			if(playerspawns[ply] != nil) then
				tryToTeleportPlayer(ply, playerspawns[ply].pos)
				return
			end
			if(globalspawn != nil) then
				tryToTeleportPlayer(ply, globalspawn.pos)
				return
			end
		end
	end)
	
	hook.Add("PlayerInitialSpawn", "global_spawn_points_player_initial_spawn", function(ply)
		if(globalspawn != nil) then
			tryToTeleportPlayer(ply, globalspawn.pos)
		end
	end)
end