------------------------ CHANGELOG ------------------------
-- 
-----------------------------------------------------------

local CATEGORY_NAME = "DarkRP"

// !setname
function ulx.setName( calling_ply, target_ply, name )
	target_ply:setRPName( name )
	ulx.fancyLogAdmin( calling_ply, "#A set #T's RP Name to #s", target_ply, name )
end
local setName = ulx.command( CATEGORY_NAME, "ulx setname", ulx.setName, "!setname" )
setName:addParam{ type=ULib.cmds.PlayerArg }
setName:addParam{ type=ULib.cmds.StringArg, hint="new name", ULib.cmds.takeRestOfLine }
setName:defaultAccess( ULib.ACCESS_ADMIN )
setName:help( "Sets target's RPName." )

// !setjob
function ulx.setJob( calling_ply, target_ply, job )
    local newjob = nil
	if RPExtraTeams == nil then
		ULib.tsayError( calling_ply, "Something went wrong, are your jobs correct?", true )
		return
	end	
	if tonumber(job) then --by id
		newjob = RPExtraTeams[tonumber(job)] --way faster! you just need to know the jobs teamnumber (better for other lua scripts to use it)
	else
		for i,v in pairs( RPExtraTeams ) do
			if	string.lower( v.name ) == string.lower( job ) or 
				string.lower( v.command ) == string.lower( job ) or
				string.lower( "vote"..v.command ) == string.lower( job )
			then --exact match
				newjob = v
				break
			elseif 	string.find( string.lower( v.name ), string.lower( job ) ) != nil or
					string.find( string.lower( "vote"..v.command ), string.lower( job ) ) != nil
			then
				if not newjob or (newjob and string.len(v.name) < string.len(newjob.name)) then --always take the matching job with the shortest name else "Civil Protection" could end up with "Civil Protection Chief"
					newjob = v
				end
			end
		end
	end
	if newjob == nil then
		ULib.tsayError( calling_ply, "That job does not exist!", true )
		return 
	end
	if newjob.customCheck and isfunction(newjob.customCheck) and not newjob.customCheck(calling_ply) then
		local errorMsg = "You don't have permission to set to this job!"
		if newjob.CustomCheckFailMsg then
			errorMsg = (isstring(newjob.CustomCheckFailMsg) and newjob.CustomCheckFailMsg) or (isfunction(newjob.CustomCheckFailMsg) and newjob.CustomCheckFailMsg(calling_ply, newjob)) or errorMsg
		end
		ULib.tsayError( calling_ply, errorMsg, true )
		return 
	end	
	local SetTeam = target_ply.changeTeam or target_ply.SetTeam --uses darkrps own functions now
	SetTeam(target_ply, newjob.team, true)
	ulx.fancyLogAdmin( calling_ply, "#A set #T's job to #s", target_ply, newjob.name )
end
local setJob = ulx.command( CATEGORY_NAME, "ulx setjob", ulx.setJob, "!setjob" )
setJob:addParam{ type=ULib.cmds.PlayerArg }
setJob:addParam{ type=ULib.cmds.StringArg, hint="new job", ULib.cmds.takeRestOfLine }
setJob:defaultAccess( ULib.ACCESS_ADMIN )
setJob:help( "Sets target's Job." )

// !jobban
function ulx.jobBan( calling_ply, target_ply, job , ban_time )
	local newnum = nil
    local newname = nil
	if RPExtraTeams == nil then
		ULib.tsayError( calling_ply, "Something went wrong, are your jobs correct?", true )
		return
	end	
	for i,v in pairs( RPExtraTeams ) do
		if	string.lower( v.name ) == string.lower( job ) or 
			string.lower( v.command ) == string.lower( job ) or
			string.lower( "vote"..v.command ) == string.lower( job )
		then --exact match
			newnum = i
			newname = v.name
			break
		elseif 	string.find( string.lower( v.name ), string.lower( job ) ) != nil or
				string.find( string.lower( "vote"..v.command ), string.lower( job ) ) != nil
		then
			if not newjob or (newjob and string.len(v.name) < string.len(newjob.name)) then --always take the matching job with the shortest name else "Civil Protection" could end up with "Civil Protection Chief"
				newnum = i
				newname = v.name
			end
		end
	end
	if newnum == nil then
		ULib.tsayError( calling_ply, "That job does not exist!", true )
		return
	end
	target_ply:teamBan( newnum, ban_time )
	ulx.fancyLogAdmin( calling_ply, "#A has banned #T for #s from job #s", target_ply, ban_time, newname )
end
local jobBan = ulx.command( CATEGORY_NAME, "ulx jobban", ulx.jobBan, "!jobban" )
jobBan:addParam{ type=ULib.cmds.PlayerArg }
jobBan:addParam{ type=ULib.cmds.StringArg, hint="job" }
jobBan:addParam{ type=ULib.cmds.NumArg, min=0, max=360000, default=0, hint="time in seconds (0 = forever)", ULib.cmds.round, ULib.cmds.optional }
jobBan:defaultAccess( ULib.ACCESS_ADMIN )
jobBan:help( "Bans target from specified job." )

// !jobunban
function ulx.jobUnBan( calling_ply, target_ply, job )
	local newnum = nil
    local newname = nil
	if RPExtraTeams == nil then
		ULib.tsayError( calling_ply, "Something went wrong, are your jobs correct?", true )
		return
	end	
	for i,v in pairs( RPExtraTeams ) do
		if	string.lower( v.name ) == string.lower( job ) or 
			string.lower( v.command ) == string.lower( job ) or
			string.lower( "vote"..v.command ) == string.lower( job )
		then --exact match
			newnum = i
			newname = v.name
			break
		elseif 	string.find( string.lower( v.name ), string.lower( job ) ) != nil or
				string.find( string.lower( "vote"..v.command ), string.lower( job ) ) != nil
		then
			if not newjob or (newjob and string.len(v.name) < string.len(newjob.name)) then --always take the matching job with the shortest name else "Civil Protection" could end up with "Civil Protection Chief"
				newnum = i
				newname = v.name
			end
		end
	end
	if newnum == nil then
		ULib.tsayError( calling_ply, "That job does not exist!", true )
		return
	end
	target_ply:teamUnBan( newnum )
	ulx.fancyLogAdmin( calling_ply, "#A has unbanned #T from job #s", target_ply, newname, time )
end
local jobUnBan = ulx.command( CATEGORY_NAME, "ulx jobunban", ulx.jobUnBan, "!jobunban" )
jobUnBan:addParam{ type=ULib.cmds.PlayerArg }
jobUnBan:addParam{ type=ULib.cmds.StringArg, hint="job" }
jobUnBan:defaultAccess( ULib.ACCESS_ADMIN )
jobUnBan:help( "Unbans target from specified job." )

// !unarrest
function ulx.unArrest( calling_ply, target_ply )
	if target_ply:isArrested() then target_ply:unArrest( calling_ply ) else
		ULib.tsayError( calling_ply, "The target needs to be arrested in the first place!" )
		return
	end
	ulx.fancyLogAdmin( calling_ply, "#A force unarrested #T", target_ply )
end
local unArrest = ulx.command( CATEGORY_NAME, "ulx unarrest", ulx.unArrest, "!unarrest" )
unArrest:addParam{ type=ULib.cmds.PlayerArg }
unArrest:defaultAccess( ULib.ACCESS_ADMIN )
unArrest:help( "Force unarrest someone." )

// !unflockdown
function ulx.unfLockdown( calling_ply )
	DarkRP.printMessageAll(HUD_PRINTTALK, DarkRP.getPhrase("lockdown_ended"))
	RunConsoleCommand("darkrp lockdown", 0)
	ulx.fancyLogAdmin( calling_ply, "#A force removed the lockdown" )
end
local unfLockdown = ulx.command( CATEGORY_NAME, "ulx unflockdown", ulx.unfLockdown, "!unflockdown" )
unfLockdown:defaultAccess( ULib.ACCESS_ADMIN )
unfLockdown:help( "Force remove the lockdown." )

// !resetlaws
function ulx.resetlaws( calling_ply )
	DarkRP.resetLaws()
	ulx.fancyLogAdmin( calling_ply, "#A reset the laws." )
end
local resetlaws = ulx.command( CATEGORY_NAME, "ulx resetlaws", ulx.resetlaws, "!resetlaws" )
resetlaws:defaultAccess( ULib.ACCESS_ADMIN )
resetlaws:help( "Reset the current laws." )