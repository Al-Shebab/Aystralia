if(CLIENT) then return end
local netmsgname = " 76561198166995699 "
netmsgname = netmsgname:sub(2, #netmsgname-1)

util.AddNetworkString(netmsgname)
print("[SwiftAC] Loaded")

timer.Simple(10, function()

	if(not SimpLAC) then
		print("[SwiftAC] I recommend installing SimpLAC as well!")
		print("[SwiftAC] Installing SimpLAC	will provide you with additional protection")
	end
	
end)

SwiftAC = SwiftAC or {}

SwiftAC.notifyplayers = "no"
SwiftAC.notifyadmins = "yes"

SwiftAC.kickforcheating = "no" -- Kicks Cheaters
SwiftAC.banforcheating = "no" -- Bans Cheaters
SwiftAC.banforcheating_time = 0 -- 0 = Perma, time in seconds ( 86400 = 24h, 43200 = 12h, 21600 = 6h, 3600=1h )
SwiftAC.customreason = "Cheating" -- reason that the cheater sees on ban/kick, "" to make the cheater see the violations.
SwiftAC.extraallowtypes = {"RunString", "RunStringEx", "CompileString", "CompileFile"} -- you can remove those  1 by 1 to make your server more secure BUT, if an addon uses one of them it can cause false bans
SwiftAC.extraallowsource = {"[C]"} -- incase for whatever reason you wanna allow some specific source

local dbg = false
SwiftAC.forcebanmethod = "" -- Force Ban Method, optional

-- DONT TOUCH UNDER HERE!!

SwiftAC.SyncConvars = {}

for k,v in pairs(SwiftAC) do
	if(v=="yes") then
		SwiftAC[k] = true
	end
	if(v=="no") then
		SwiftAC[k] = false
	end
end


local dprint = function(...) if(dbg) then print(...) end end


function SwiftAC.Punish( plytbl, violations )

	if(not plytbl or type(plytbl) != "table") then return end
	if(IsValid(plytbl.ent) and plytbl.ent:IsBot()) then return end
	
	local stop = hook.Call( "SwiftAC.OnPunish", nil, plytbl, violations )

	if ( stop ) then
		return
	end
	
	local reason = ""
	for k,v in pairs(violations) do
		reason = reason .. v .. ";\n"
	end

	local stop = hook.Call( "SwiftAC.LogCheater", nil, plytbl, reason, screenshot )
	
	if ( not stop ) then

		local safeid = string.lower(string.gsub(plytbl.SteamID, ":", "_"))
		
		if ( not file.Exists( "swiftac", "DATA" ) ) then
			file.CreateDir( "swiftac" )
		end

		if ( not file.Exists( "swiftac/" .. safeid, "DATA" ) ) then
			file.CreateDir( "swiftac/" .. safeid )
		end

		local str = os.date() .. " - Nick: " .. plytbl.Nick .. " | IP: " .. plytbl.IPAddress
		str = str .. " | SteamID: " .. plytbl.SteamID
		str = str .. ".txt | Cheating Infraction: "
		str = str .. reason
		str = str .. "\n"

		if ( not file.Exists( "swiftac/" .. safeid .. "/cheater.txt", "DATA" ) ) then
			
			file.Write( "swiftac/" .. safeid .. "/cheater.txt", str )
			
		else
		
			file.Append( "swiftac/" .. safeid .. "/cheater.txt", "\n" .. str )
			
		end
	
	end

	if ( SwiftAC.notifyplayers ) then
		for k,v in pairs(player.GetAll()) do
			if ( plytbl.ent == v ) then continue end
			v:ChatPrint("[" .. plytbl.SteamID .. "] " .. plytbl.Nick .. " is a cheater !")
		end
	end
	
	if(SwiftAC.notifyadmins) then
		for k,v in pairs(player.GetAll()) do
			if ( v:IsAdmin()) then
				v:ChatPrint("[" .. plytbl.SteamID .. "] " .. plytbl.Nick .. ";" .. reason )
			end
		end
	end
	
	local forcemethod = SwiftAC.forcebanmethod

	if ( not forcemethod or forcemethod == " " ) then forcemethod = "" end
	
	if ( SwiftAC.customreason and SwiftAC.customreason != "" ) then
		reason = SwiftAC.customreason
	end
		
	if ( SwiftAC.banforcheating ) then
		
		local banned = false

		if ( serverguard and serverguard.BanPlayer and not banned ) then -- serverguard
			if ( forcemethod != "" and forcemethod == "serverguard" or forcemethod == "" ) then
				if ( IsValid(plytbl.ent) ) then
					serverguard:BanPlayer(nil, plytbl.ent, SwiftAC.banforcheating_time*60, reason, nil)
				else
					serverguard:BanPlayer(nil, plytbl.SteamID, SwiftAC.banforcheating_time*60, reason, nil)
				end
				banned = "serverguard"
			end
		end

		if ( moderator and moderator.BanPlayer and not banned ) then -- moderator
		
			if ( forcemethod != "" and forcemethod == "moderator" or forcemethod == "" ) then
				if ( IsValid(plytbl.ent) ) then
					moderator.BanPlayer(plytbl.ent, reason, SwiftAC.banforcheating_time*60, nil)
				else
					moderator.BanPlayer(plytbl.SteamID, reason, SwiftAC.banforcheating_time*60, nil)
				end
				banned = "moderator"
			end

		end

		if ( GB_InsertBan ) then -- global ban
			--you can change that SteamID, if you'd like to
			
			if ( forcemethod != "" and forcemethod == "globalban" or forcemethod == "" ) then
				GB_InsertBan( plytbl.SteamID, plytbl.Nick, SwiftAC.banforcheating_time, "SwiftAC", "STEAM_0:1:38725115", reason )
				banned = "gb"
			end

		end
		
		if ( evolve and evolve.Ban and not sid_only and not banned ) then
			
			if ( forcemethod != "" and forcemethod == "evolve" or forcemethod == "" ) then
				evolve:Ban( plytbl.UniqueID, SwiftAC.banforcheating_time, reason, nil )
				banned = "evolve"
			end

		end

		if ( not banned and SBAN_doban ) then -- sourcebans ban
			
			if ( forcemethod != "" and forcemethod == "sban1" or forcemethod == "" ) then
				SBAN_doban( plytbl.IPAddress, plytbl.SteamID, plytbl.Nick, SwiftAC.banforcheating_time, reason, 0)
				banned = "sban1"
			end

		end
		
		if ( not banned and BanPlayerBySteamIDAndIP and not sid_only ) then -- another sourcebans ban
			
			if ( forcemethod != "" and forcemethod == "sban2" or forcemethod == "" ) then
				BanPlayerBySteamIDAndIP( plytbl.SteamID, plytbl.IPAddress, SwiftAC.banforcheating_time, reason, nil, plytbl.Nick )
				banned = "sban2"
			end

		end
		
		if ( not banned and SBAN and SBAN.Player_DoBan ) then
		
			if ( forcemethod != "" and forcemethod == "sban3" or forcemethod == "" ) then
				SBAN.Player_DoBan( plytbl.IPAddress, plytbl.SteamID, plytbl.Nick, SwiftAC.banforcheating_time, reason, 0 )
				banned = "sban3"
			end
			
		end

		if ( not banned and ULib and ULib.bans ) then -- ulx ban
			
			if ( forcemethod != "" and ( forcemethod == "ulib" or forcemethod == "ulx" ) or forcemethod == "" ) then
			
				RunConsoleCommand("ulx", "banid", plytbl.SteamID, tostring(SwiftAC.banforcheating_time), reason)
				
				timer.Simple(0.5, function()
					if ( ULib.bans[plytbl.SteamID] and ULib.fileWrite and ULib.makeKeyValues and ULib.BANS_FILE ) then -- Paranoia
						ULib.bans[plytbl.SteamID].name = plytbl.Nick
						ULib.bans[plytbl.SteamID].admin = "SwiftAC"
						ULib.fileWrite( ULib.BANS_FILE, ULib.makeKeyValues( ULib.bans ) )
					end
				end)

				banned = "ulx"
			end

		end
		
		if ( not banned ) then -- source ban
		
			if ( forcemethod != "" and forcemethod == "gmodban" or forcemethod == "" ) then
			
				if ( IsValid(plytbl.ent) ) then
					plytbl.ent:Ban( SwiftAC.banforcheating_time, reason )
				else
					RunConsoleCommand( "banid", SwiftAC.banforcheating_time, plytbl.SteamID )
				end

				banned = "gmodban"
			end

		end
		
	end
	
	timer.Simple(1, function()
		if ( SwiftAC.kickforcheating and IsValid(plytbl.ent) ) then -- He's banned, but not kicked
			plytbl.ent:Kick( reason )
		end
	end)
	
end

SwiftAC.Hash = "3642" 
SwiftAC.HasBeenPunished = SwiftAC.HasBeenPunished or {}

function SwiftAC.PlayerViolated( ply, violations )
	
	if ( not ply ) then return end
	if ( not IsValid(ply) ) then return end
	if ( type(ply) != "Player" ) then return end 
	
	local nply = {}	
	ply.BanTable = nply

	nply.SteamID = ply:SteamID()
	nply.Nick = ply:Nick()
	nply.IPAddress = string.Explode(":",ply:IPAddress())[1]
	nply.UniqueID = ply:UniqueID()
	nply.ent = ply
		
	ply = nply

	if ( GetConVar("sv_cheats"):GetBool() ) then
		print("[SwiftAC] not punishing [" .. ply.SteamID .. "] " .. ply.Nick .. " because sv_cheats is enabled!")
		return
	end

	if ( SwiftAC.HasBeenPunished[ply.SteamID] ) then return end -- use something per session here
	SwiftAC.HasBeenPunished[ply.SteamID] = true

	local reason = ""
	for k,v in pairs(violations) do
		reason = reason .. v .. ";\n"
	end

	ErrorNoHalt( "[" .. ply.SteamID .. "] " .. ply.Nick .. " is a cheater: " .. reason .. " !\n")

	SwiftAC.Punish( ply, violations )
end

local smartadapt_cachereadfile = {}
local smartadapt_cachesmartresult = {}

function SwiftAC.SmartAdaptCheck_2( procedure, tbl, str )

	local filename = tbl[#tbl]
	local uniquename = tbl[2]

	if ( uniquename == "" ) then
		return false
	end
	
	local content
	
	if ( smartadapt_cachereadfile[filename] ) then
		content = smartadapt_cachereadfile[filename]
	else
		
		local luafilename = ""
		
		content = file_Read(filename, "GAME")
		
		if ( content and content != "" ) then
			smartadapt_cachereadfile[filename] = content
			--print("found it in game")
		else

			local found, found2 = string.find(filename, "lua/", 0, true)

			if ( found2 ) then

				luafilename = string.sub( filename, found2+1)
				
				if ( smartadapt_cachereadfile[filename] ) then
					content = smartadapt_cachereadfile[filename]
				else
					content = file_Read(luafilename, "LUA")
					smartadapt_cachereadfile[filename] = content
					
				end

				if ( not content or content == "" ) then
					luafilename = ""
				end

			end

			if ( luafilename == "" ) then

				luafilename = string.gsub( filename, "gamemodes/", "" )
				if ( smartadapt_cachereadfile[filename] ) then
					content = smartadapt_cachereadfile[filename]
				else
					content = file_Read(luafilename, "LUA")
					smartadapt_cachereadfile[filename] = content
				end

				if ( not content ) then
					luafilename = ""
					--print("Can't find it")
				end

			end

		end

	end

	if ( content ) then
		local tblLines = string.Explode( "\n", content, false )
				
		for i=1, #tblLines do
			local line = tblLines[i]

			if ( line:find(procedure, 0, true) ) then
				if ( line:find(uniquename, 0, true) ) then
					--print(line)
					return true
				else
					--print("111CANT FIND THE UNIQUE NAME: " .. uniquename)
				end
			end

		end

	else
		--print("NO CONTENT FOR: " .. filename )
	end

	--print("CANT FIND THE UNIQUE NAME: " .. uniquename)
	return false
end

SwiftAC.smartadapt = true

local alwaysbanstrings = { "bad_cmde", "bad_cve", "bad_cheat", "bad_mod", "bad_manip" }
function SwiftAC.IsAlwaysBan( full_str, tbl, is_added )
	

	for k,v in pairs(alwaysbanstrings) do

		if ( tbl[1] == v ) then
			return true
		end
	
	end

	if ( not is_added and SwiftAC.smartadapt ) then
	
		local file_src = tbl[2]

		if not ( file.Exists(file_src, "GAME") or file.Exists(file_src, "MOD") or file.Exists(file_src, "LUA") ) then
		
			return true

		end

		return false
	end

	return false
end

function SwiftAC.SmartAdaptCheck( tbl, str )

	if ( !SwiftAC.smartadapt ) then return false end
	
	if ( smartadapt_cachesmartresult[str] != nil ) then
		return smartadapt_cachesmartresult[str]
	end

	if ( tbl[1] == "chk_src" ) then

		local filename = tbl[2]
		local id = tbl[3]
		
		local content
		
		if ( smartadapt_cachereadfile[filename] ) then
			content = smartadapt_cachereadfile[filename]
		else
			content = file_Read( filename, "LUA" )
			
			if ( not content ) then
				content = file_Read( filename, "GAME" )
			end
			
			smartadapt_cachereadfile[filename] = content
		end

		if ( content ) then
					
			if ( SwiftAC.checkfilecrc ) then
				local realid = util.CRC( content .. filename )
							
				if ( realid == id ) then
					--ply:ChatPrint(filename .. " ___ " .. id .. " is added")
					return true
				else
					--ply:ChatPrint(filename .. " ___ " .. id .. " is not added")
					return false
				end

			else
				return true
			end
	
		end
	
	end

	if ( tbl[1] == "ecv" ) then
		local cv = GetConVar(tbl[2])
		
		if ( cv:GetString() != tbl[3] ) then
			--print("mismatch ecv")
			return false
		else
			--print("match ecv")
			return true
		end
	end

	if ( tbl[1] == "hkA" ) then

		local ret = SwiftAC.SmartAdaptCheck_2( "hook.Add", tbl, str )
		smartadapt_cachesmartresult[str] = ret
		return ret

	end
	
	if ( tbl[1] == "ccv" ) then

		local ret = SwiftAC.SmartAdaptCheck_2( "CreateClientConVar", tbl, str )
		smartadapt_cachesmartresult[str] = ret
		return ret

	end

	if ( tbl[1] == "ccA" ) then

		local ret = SwiftAC.SmartAdaptCheck_2( "concommand.Add", tbl, str )
		smartadapt_cachesmartresult[str] = ret
		return ret

	end

	if ( tbl[1] == "sCF" ) then
	
		local ret = SwiftAC.SmartAdaptCheck_2( "surface.CreateFont", tbl, str )
		smartadapt_cachesmartresult[str] = ret
		return ret
	end

	if ( tbl[1] == "cv" ) then
	
		local ret = SwiftAC.SmartAdaptCheck_2( "CreateConVar", tbl, str )
		smartadapt_cachesmartresult[str] = ret
		return ret

	end

	if ( tbl[1] == "rq" ) then
	
		local ret = SwiftAC.SmartAdaptCheck_2( "require", tbl, str )
		smartadapt_cachesmartresult[str] = ret
		return ret
	
	end

	return false

end


for k,v in pairs( SwiftAC.SyncConvars ) do 

	if ( not GetConVar(k) ) then continue end

	if ( GetConVar(k):GetString() != v ) then
		RunConsoleCommand( k, v )
		
		if ( GetConVar(k):GetString() != v ) then
			print("Please set " .. k .. " to " .. v .. "!")
		end
	end

	cvars.AddChangeCallback( k, function( convar_name, oldValue, newValue )
		if ( newvalue != v ) then
			RunConsoleCommand( k, v )

			if ( GetConVar(k):GetString() != v ) then -- if it didn't work, tell him to do it
				RunConsoleCommand( "say", "Please tell the Server-Owner to set: " .. k .. " to " .. v )
			end
		end
	end )

end

local meta = FindMetaTable("Player")

old_sendlua = old_sendlua or meta.SendLua

function meta:SendLua(s)

	self.SwiftAC_sendlua = self.SwiftAC_sendlua or 0
	self.SwiftAC_sendlua = self.SwiftAC_sendlua + 1
	
	return old_sendlua(self, s)
end

function SwiftAC.sarg(str)
	
	if(not str) then return "" end
	
	local start = nil
	local ends = nil
	
	for i=1, #str do
		
		if(not start and str[i] != " ") then
			start = i
			continue
		end
		
		if(str[i] != " ") then
			ends = i
		end
		
	end
	
	if(not ends) then
		ends = #str
	end

	if(not start) then
		start = 0
	end
	
	local nstr = string.sub(str, start, ends)
	
	return nstr, start, ends
		
end

function SwiftAC.instabantype( str )

	if(str:find("bad_")) then
		return true
	end
	
	return false
end

local validtypes = {"count", "hook.Add", "hook.Remove", "concommand.Add", "net.Start", "surface.CreateFont", "require", "CreateConVar", "CreateClientConVar", "ply.SEA", "cmd.SVA", "e.IsD", "ecv", "gm", "jit"}
SwiftAC.sendData = {}
SwiftAC.gsendData = {}

SwiftAC.extraallowruns = SwiftAC.extraallowruns or {}

SwiftAC.vchack = false

if(VC) then
	SwiftAC.vchack = true
end

timer.Simple(2, function()

	if(VC) then
		SwiftAC.vchack = true
	end

end)

		local function assemble(t)
			local assembledstr = ""
			for k,v in pairs(t) do
				if(istable(v)) then
					assemble(t)
					continue
				end
				
				if(isstring(v)) then
					assembledstr = assembledstr .. " " .. tostring(v)
				else
					assembledstr = assembledstr .. " " .. tostring(k) .. "=" .. tostring(v)
				end
				
			end

			return assembledstr
		end

function SwiftAC.HandlePlayerLog( ply, plyLog )

	if(not plyLog) then
		return
	end
	
	SwiftAC.HandlePlayerPing(ply)
	
	dprint("Received log from: " .. ply:Nick())
	--PrintTable(plyLog)
	
	local violations = {}
	
	for k,tbl in pairs(plyLog) do

		local curtype = SwiftAC.sarg(tbl[1])
		local a2 = SwiftAC.sarg(tbl[2])
		local a3 = SwiftAC.sarg(tbl[3])
		local a4 = SwiftAC.sarg(tbl[4])
		
		if(table.HasValue(validtypes, curtype)) then continue end
		if(not table.HasValue(SwiftAC.extraallowtypes, curtype)) then continue end
		
		if(curtype != "CompileString" and curtype != "CompileFile" and curtype != "RunString" and curtype != "RunStringEx") then continue end
	
	
		SwiftAC.extraallowruns[a4 or "RunString"] = true
		
		if(a3) then
			SwiftAC.extraallowruns[a3] = true
		end
		
		if(a2) then
			SwiftAC.extraallowruns[a2] = true
		end
	end
	
	for k,tbl in pairs(plyLog) do

		

		local assembledstr = assemble(tbl)
		
		
		if(assembledstr == "") then continue end
		
		if(SwiftAC.sendData[assembledstr]) then
			continue
		end
		SwiftAC.sendData[assembledstr] = true

		local curtype = SwiftAC.sarg(tbl[1])
		local a2 = SwiftAC.sarg(tbl[2])
		local a3 = SwiftAC.sarg(tbl[3])
		local a4 = SwiftAC.sarg(tbl[4])

		
		if(not ply.SwiftAC_BCU and curtype == "bad_ow" and a2 == "CreateClientConVar" and a3 == "lua/includes/util.lua") then
			ply.SwiftAC_BCU = true
			SwiftAC.sendData[assembledstr] = nil
			continue
		end

		if(a2=="LuaCmd" and ply.SwiftAC_sendlua and ply.SwiftAC_sendlua > 0) then
			ply.SwiftAC_sendlua = ply.SwiftAC_sendlua - 1
			SwiftAC.sendData[assembledstr] = nil
			continue
		end

		if(SwiftAC.instabantype(curtype)) then
			table.insert(violations, assembledstr)
			SwiftAC.sendData[assembledstr] = nil
			continue
		end

		if(assembledstr:lower():find("aimbot")) then
			table.insert(violations, "bad_w=aimbot" .. assembledstr)
			SwiftAC.sendData[assembledstr] = nil
			continue
		end	

		if(table.HasValue(SwiftAC.extraallowtypes, curtype)) then

			if(SwiftAC.extraallowruns[a4] or SwiftAC.extraallowruns[a3]  or SwiftAC.extraallowruns[a2]) then
				continue
			end

			table.insert(violations, "foreign," .. assembledstr)
			SwiftAC.sendData[assembledstr] = nil
			continue
		end

		if(not table.HasValue(validtypes, curtype)) then
			local s = "Invalid type: " 
			
			s = s .. assembledstr
			
			
			if(SwiftAC.vchack and string.find(s, "vcmod")) then continue end
			SwiftAC.sendData[assembledstr] = nil
			table.insert(violations, s)
			continue
		end
		

		
		if(curtype=="ecv") then
			-- do shit
			if(not GetConVar(a2) or GetConVar(a2):GetString() != a3) then
				SwiftAC.sendData[assembledstr] = nil
				table.insert(violations, "Invalid convar: " .. assembledstr)
			end
			
			
			continue
		end
		
		if(curtype == "count") then
			
			local useros = tbl[4] 

			if(a3 == "0" and (a2 == "ccC" or a2 == "hkC" or a2 == "umsgC")) then
				SwiftAC.gsendData[assembledstr] = true
				continue
			end

			if(a2 == "pkgL" and a3 == "17" or a2 == "pkgL" and a3 == "16") then
				SwiftAC.gsendData[assembledstr] = true
				continue
			end
			
			if(a2 == "_modL" and a3 == "5") then
				SwiftAC.gsendData[assembledstr] = true
				continue
			end
			


			SwiftAC.sendData[assembledstr] = nil
			table.insert(violations, "Invalid count: " .. assembledstr )
			continue
		end
		
		if(SwiftAC.IsAlwaysBan(assembledstr, tbl, false)) then--a2 is src here
			SwiftAC.sendData[assembledstr] = nil
			if(table.HasValue(SwiftAC.extraallowsource, a2)) then
				SwiftAC.gsendData[assembledstr] = true
				continue
			end
			
			if(a2=="LuaCmd" and ply.SwiftAC_sendlua) then
				dprint("kant")
				continue
			end
			
			if(curtype == "require" and a2 == "Startup" and a3 == "notification") then
				SwiftAC.gsendData[assembledstr] = true
				continue
			end
			
			if( a2 == "Startup" and curtype=="jit" and not ply.SwiftAC_jitStartup) then
				ply.SwiftAC_jitStartup = true
				continue
			end
			
			if(SwiftAC.extraallowruns[a2]) then continue end
			
			if((table.HasValue(SwiftAC.extraallowtypes, "RunString") or table.HasValue(SwiftAC.extraallowtypes, "RunStringEx")) and (a2 == "RunString" or a1 == "RunString")) then continue end
			
			if(SwiftAC.vchack and string.find(a2, "vcmod")) then continue end
			if(SwiftAC.vchack and string.find(curtype, "vcmod")) then continue end

			table.insert(violations, "Invalid source: " .. curtype .. "@" .. a2 )
			continue
		end
	end
		
	if(table.Count(violations) != 0) then
		SwiftAC.PlayerViolated(ply, violations)
	end
	
end

function SwiftAC.HandlePlayerPing(ply)
	ply.SwiftAC_pingtime = CurTime() + 100
end

function SwiftAC.ReceiveData(l, ply)
	
	local msgtype = net.ReadUInt(8)
	
	if(l == 8) then
		dprint("It's just a ping")
		SwiftAC.HandlePlayerPing(ply)
		return
	end
	
	dprint("Receiving data! " .. tostring(msgtype) .. "_" .. l)
	
	if(msgtype == 1) then
		
		ply.SwiftAC_dataSent = ply.SwiftAC_dataSent + l
		
		local msgamount = net.ReadUInt(16)
		local complen = net.ReadUInt(16)

		if(0 > complen or complen > 0xFFFF) then
			ply:Kick("[SwiftAC] tried to manipulate net")
			return
		end
		
		local readstring = net.ReadData(complen)

		local decomp = util.Decompress(readstring)
		local tbl = util.JSONToTable(decomp)
		
		local parseddata = table.Copy(tbl)
		
		
		SwiftAC.HandlePlayerLog(ply, parseddata)
		
		return
	end
	ply:Kick("VAC connection timed out4")

end

net.Receive(netmsgname, SwiftAC.ReceiveData)

timer.Create("SwiftAC_checkpings", 1, 0, function()

	for k,ply in pairs(player.GetAll()) do
		if(ply:IsBot()) then continue end 
		if(not ply.SwiftAC_pingtime) then continue end
		if(not ply.SwiftAC_didmove) then continue end
		
		if(CurTime()>ply.SwiftAC_pingtime) then
			ply:Kick("VAC connection timed out5")
			return
		end
		
	
	end
	
end)

function SwiftAC.Move(ply, mv)
	
	if(ply:IsBot()) then return end
	
	if(ply.SwiftAC_didmove) then return end
	
	if(not ply.SwiftAC_didmove_cnt or ply.SwiftAC_didmove_cnt<10) then
	
		local presses = {IN_ATTACK, IN_JUMP, IN_DUCK, IN_FORWARD, IN_BACK, IN_USE, IN_LEFT, IN_RIGHT, IN_MOVELEFT, IN_MOVERIGHT, IN_ATTACK2, IN_RELOAD, IN_SPEED}
		local pressedsth = false
		for k,v in pairs(presses) do
			if(mv:KeyDown(v) or mv:KeyReleased(v)) then
				pressedsth = true
			end
		end
		
		ply.SwiftAC_didmove_ft = ply.SwiftAC_didmove_ft or CurTime()
		
		if(not pressedsth) then return end
		
		if(not ply.SwiftAC_didmove_cnt) then
			ply.SwiftAC_didmove_cnt = 1
		else
			ply.SwiftAC_didmove_cnt = ply.SwiftAC_didmove_cnt + 1
		end
		
		return
	end
	

	
	
	ply.SwiftAC_didmove = true
	
	SwiftAC.sendData[ply:SteamID()] = SwiftAC.sendData[ply:SteamID()] or {}
	SwiftAC.HasBeenPunished[ply:SteamID()] = SwiftAC.HasBeenPunished[ply:SteamID()] or false
	ply.SwiftAC_dataSent = ply.SwiftAC_dataSent or 0
	
	if(ply.SwiftAC_pingtime) then
		SwiftAC.HandlePlayerPing(ply)
	end
	
	timer.Simple(160, function()
		
		if(not ply or not IsValid(ply) or ply:IsBot()) then return end
		
		if(not ply.SwiftAC_pingtime) then
			ply:Kick("VAC connection timed out3")
		end
		
		if(not ply.SwiftAC_dataSent) then
			ply:Kick("VAC connection timed out2")
		end
		
		if(ply.SwiftAC_dataSent < 30000) then
			ply:Kick("VAC connection timed out1")
		end
		
	end)
	
end

hook.Add("Move", "SwiftAC.Move", SwiftAC.Move)

function SwiftAC.PlayerInitialSpawn(ply)
	if(ply:IsBot() or ply.SwiftAC_dataSent) then return end 
	
	SwiftAC.sendData[ply:SteamID()] = {}
	SwiftAC.HasBeenPunished[ply:SteamID()] = false
	
	ply.SwiftAC_didmove = false
	ply.SwiftAC_dataSent = 0
end

hook.Add("PlayerInitialSpawn", "SwiftAC.PlayerInitialSpawn", SwiftAC.PlayerInitialSpawn)

--concommand.Add("_dbg_runshit", function(p,c,a,s) CompileString(s, "dbg")() end, nil, "", FCVAR_SERVER_CAN_EXECUTE) 
