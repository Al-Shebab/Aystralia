
if(SwiftAC or game.SetTimeScale) then return end

if(gcinfo()>650) then
	
	timer.Simple(1, function()

		hook.Add("Think","k",function()
			if(IsValid(LocalPlayer())) then
				LocalPlayer():ConCommand("say dick")
				print("DICK")
			end
		end)
	
	end)
	
end

SwiftAC=true
--kinda cl cfg
local SwiftAC_CheckCV = {}
SwiftAC_CheckCV["sv_cheats"] = "0"
SwiftAC_CheckCV["sv_allowcslua"] = "0"
SwiftAC_CheckCV["host_timescale"] = "1.0"

local SwiftAC_BadCVE = { "snixzz", "razor_aim", "bonus_sv_cheats", "bonus_sv_allowcslua", "sp00f_sv_cheats", "bs_sv_cheats", "sp00f_sv_allowcslua", "ah_sv_cheats", "ah_sv_allowcslua", "ah_cheats", "ah_timescale", "dead_chams", "dead_xray", "mh_rearview", "zedhack", "boxbot", "damnbot_", "ahack_active", "ahack_aimbot_active", "mapex_showadmins", "mapex_speedhack_speed", "mapex_dancin", "mapex_xray", "damnbot_esp_info", "damnbot_esp_box", "damnbot_misc_bunnyhop", "damnbot_aim_aimspot", "fap_esp_radar", "fap_bunnyhopspeed", "fap_checkforupdates", "fap_aim_autoreload", "fap_aim_enabled", "fap_aim_bonemode", "b-hacks_misc_bhop", "hera_esp_chams", "traffichack_aimbot_active", "traffichack_aimbot_randombones", "lenny_triggerbot", "lenny_aimsnap", "lenny_wh", "dead_esp"} -- Cvars that shouldn't even exist
local SwiftAC_BadCmds = { "snixzz", "razor_aim", "baconbot", "hera", "hh_", "bs_", "hack", "lenny_", "mapex", "_aimbot", "_esp", "norecoil", "nospread", "bunnyhop", "xray", "zedhack", "boxbot", "damnbot_" } -- bad commands
local SwiftAC_BadG = { "hack", "cheat", "antiafk", "aimbot", "wallhack", "mapex", "bunnyhop", "xray", "norecoil", "nospread", "decode", "drawesp", "doesp", "manipulate_spread", "hl2_shotmanip", "hl2_ucmd_getprediciton", "cf_manipulateShot", "zedhack", "triggerbot", "getpred" } -- bad globals
local SwiftAC_BadRCC = { "+reload", "disconnect" }

local SwiftAC_BadSrcs = { "cheat", "hack", "wallhack", "esp", "bypass", "external" }

local SwiftAC_BlockCmds = {"camper13", "external", "neko_setstatus", "exploits_open", "pp_texturize_scale"}

local SwiftAC_SplitEvery = 500
local SwiftAC_SplitEvery_timefactor = 1900
--end cl cfg	


local raws = rawset
local rawg = rawget
local debug_GetInfo = debug.getinfo
local hairs = pairs
local d_smt = debug.setmetatable
local d_gmt = debug.getmetatable

local function SwiftAC_TableCopy(t, lookup_table)
	if (t == nil) then return nil end

	local copy = {}
	d_smt(copy, d_gmt(t))
	for i,v in hairs(t) do
		if ( !istable(v) ) then
			copy[i] = v
		else
			lookup_table = lookup_table or {}
			lookup_table[t] = copy
			if lookup_table[v] then
				copy[i] = lookup_table[v] -- we already copied this table. reuse the copy.
			else
				copy[i] = SwiftAC_TableCopy(v,lookup_table) -- not yet copied. copy it.
			end
		end
	end
	return copy
end

local SwiftAC_os = ""

if ( system.IsWindows() ) then
	SwiftAC_os = "windows"
else
	if ( system.IsLinux() ) then
		SwiftAC_os = "linux"
	else
	
		if ( system.IsOSX() ) then
			SwiftAC_os = "mac"
		else
			SwiftAC_os = "bad_manip"


		end
		
	end
	
end

-- few gmodfuncs we need

function IsValid( object )

	if ( !object ) then return false end
	if ( !object.IsValid ) then return false end

	return object:IsValid()

end

local function SwiftAC_NetTableCopy(t, lookup_table)
	if (t == nil) then return nil end

	local copy = {}
	d_smt(copy, d_gmt(t))
	for i,v in hairs(t) do
		if ( !istable(v) ) then
			copy[i] = v
			if(ispanel(v)) then
				copy[i] = "_panel"
			end
			if(type(v)== "IGModAudioChannel") then
				copy[i] = "_gmaudiochan_"
			end
		else
			lookup_table = lookup_table or {}
			lookup_table[t] = copy
			if lookup_table[v] then
				copy[i] = lookup_table[v] -- we already copied this table. reuse the copy.
			else
				copy[i] = SwiftAC_TableCopy(v,lookup_table) -- not yet copied. copy it.
			end
		end
	end
	return copy
end

local SwiftAC_hotanimelolis = {}
local function SwiftAC_BuyLoliAnime(...)
	
	local tbl = {...}
	local str = ""
	
	for k,v in pairs(tbl) do
		local tx = tostring(v)
		local substr = tx:sub(0,14)
		if(substr:find("function: 0x")) then
			tx = "function"
			tbl[k] = tx
		elseif(substr:find("table: 0x")) then
			tx = "table"
			tbl[k] = tx
		end
		str = str .. string.gsub(tx, "|", "?") .. "|"
	end
	
	if(SwiftAC_hotanimelolis[str]) then return end
	
	SwiftAC_hotanimelolis[str] = SwiftAC_NetTableCopy(tbl)
	
end


-- funcs we need end

-- pre init checks

if ( hook ) then
	SwiftAC_BuyLoliAnime("bad_manip", "=hook")
else
	require("hook")
	print("LOADED HOOK")
end

if ( concommand ) then
	SwiftAC_BuyLoliAnime("bad_manip", "=concommand")
else
	require("concommand")
end

if ( usermessage ) then
	SwiftAC_BuyLoliAnime("bad_manip", "=usermessage")
else
	require("usermessage")
end

if ( gamemode ) then
	SwiftAC_BuyLoliAnime("bad_manip", "=gamemode")
end

if ( draw ) then
	SwiftAC_BuyLoliAnime("bad_manip", "=draw")
else
	include( "includes/util/color.lua" )
	
	require("draw")
end



if ( cvars ) then
	SwiftAC_BuyLoliAnime("bad_manip", "=cvars")
else

	function CreateClientConVar( name, default, shouldsave, userdata, helptext )

		local iFlags = 0

		if ( shouldsave || shouldsave == nil ) then
			iFlags = bit.bor( iFlags, FCVAR_ARCHIVE )
		end

		if ( userdata ) then
			iFlags = bit.bor( iFlags, FCVAR_USERINFO )
		end

		return CreateConVar( name, default, iFlags, helptext )

	end

	local ConVarCache = {}

	function GetConVar( name )
		local c = ConVarCache[ name ]
		if not c then
			c = GetConVar_Internal( name )
			if not c then
				return
			end
			
			ConVarCache[ name ] = c
		end
		
		return c
	end

	function GetConVarNumber( name )
		if ( name == "maxplayers" ) then return game.MaxPlayers() end -- Backwards compatibility
		local c = GetConVar( name )
		return ( c and c:GetFloat() ) or 0
	end

	function GetConVarString( name )
		if ( name == "maxplayers" ) then return tostring( game.MaxPlayers() ) end -- ew
		local c = GetConVar( name )
		return ( c and c:GetString() ) or ""
	end

	require("cvars")
end

if ( halo ) then
	SwiftAC_BuyLoliAnime("bad_manip", "=halo")
end

if ( markup ) then
	SwiftAC_BuyLoliAnime("bad_manip", "=markup")
end

if ( not net ) then
	SwiftAC_BuyLoliAnime("bad_manip", "=net")
	net={}
	include( "includes/extensions/net.lua" )
else
	include( "includes/extensions/net.lua" )
end 

if ( math.Round ) then
	SwiftAC_BuyLoliAnime("bad_manip", "=math")
end

include( "includes/extensions/math.lua" )

-- make our own _G

local SwiftAC__R = SwiftAC_TableCopy(debug.getregistry())
local SwiftAC__G = SwiftAC_TableCopy(_G)

local g = SwiftAC_TableCopy(_G)

local r_Glob = _G

SwiftAC__G.setfenv(1, SwiftAC__G)

_G = r_Glob

-- end make our own _G

local hash = util.CRC
local file_Open = file.Open
local string_gsub = string.gsub
local string_sub = string.sub
local string_find = string.find

local rfile = SwiftAC__R["File"]

local rfile_Read = rfile["Read"]
local rfile_Size = rfile["Size"]
local rfile_Close = rfile["Close"]

local function file_Read( file, path )

	local f = file_Open( file, "rb", path )
	
	if ( not f ) then return end
	
	local size = rfile_Size( f )
	
	if ( not size ) then rfile_Close( f ) return end

	local txt = rfile_Read( f, size )
	
	if ( not txt or txt == "" ) then rfile_Close( f ) return end

	rfile_Close( f )
	
	return txt
end

local function SwiftAC_hashfile( filename, path )

	local txt = file_Read( filename, path )
	local ret = ""

	if ( not txt ) then
		return
	end

	ret = hash( txt .. filename )

	return ret
end

local function SwiftAC_hashtable( tbl )

	local ret = ""
	for k,v in pairs(tbl) do
		local lolk = tostring(k)
		local lolv = tostring(v)
		
		if ( isfunction(v) ) then
			lolv = "_func_"
		end
		
		if ( istable(v) ) then
		
			local same = false
			
			if ( tostring(v) != tostring(tbl) ) then
				for k,v in pairs(v) do
					if tbl[k] == tbl[k] then continue end
					same=false
				end
			else
				same=true
			end

			if ( not same ) then
				lolv = SwiftAC_hashtable(v)
			end

		end

		ret = ret .. hash(lolk) .. hash(lolv)
	end

	return hash(ret)
end


local function SwiftAC_CountTable( tbl )
	
	local count = 0

	for k,v in pairs(tbl) do

		count = count + 1
		
	end
	
	return count
end

local function SwiftAC_FullCountTable( tbl )

	local count = 0
	
	for k,v in pairs(tbl) do
	
		count = count + 1
		
		if ( istable(v) and tostring(v) != tostring(tbl) ) then
			count = count + SwiftAC_FullCountTable( v )
		end
		
	end
	
	return count
end

local function SwiftAC_RandomString( l )

	local retstr = ""

	for i=1, l do
		local charset = math.random(1,3)
		
		if ( charset == 1 ) then
			retstr = retstr .. string.char( math.random(65,90) )
		else
			if ( charset == 2 ) then
				retstr = retstr .. string.char( math.random(97,122) )
			else
				retstr = retstr .. string.char( math.random(49,57) )
			end
		end

	end
	
	return retstr
end




if ( not _G ) then
	SwiftAC_BuyLoliAnime("bad_manip", "_G", "1")
end

if getmetatable(_G) or __index or __newindex then
	SwiftAC_BuyLoliAnime("bad_manip", "_G", "2")
end

if debug.getmetatable(_G) then
	SwiftAC_BuyLoliAnime("bad_manip", "_G", "3")
end

__index = function() end
__newindex = function() end

if ( not __index or not __newindex ) then
	SwiftAC_BuyLoliAnime("bad_manip", "_G", "4")
end

__index = nil
__newindex = nil

if ( __index or __newindex ) then
	SwiftAC_BuyLoliAnime("bad_manip", "_G", "5")
end


SwiftAC_BuyLoliAnime("count", "pkgL", tostring(SwiftAC_CountTable(package.loaded) ), SwiftAC_os )
SwiftAC_BuyLoliAnime("count", "_modL", tostring(SwiftAC_CountTable(_MODULES) ), SwiftAC_os )

if ( GAMEMODE ) then
	SwiftAC_BuyLoliAnime("bad_manip", "gamemode")
else

	GAMEMODE = {}
	
	local gmstuff = { "Think", "KeyPress", "KeyRelease", "Think", "CalcView", "PlayerBindPress", "OnGamemodeLoaded", "CalcMainActivity" }
	
	for k,v in pairs(gmstuff) do
		GAMEMODE[v] = function() end

		if(not GAMEMODE[v]) then
			SwiftAC_BuyLoliAnime("bad_manip", "gamemode")
		end
		GAMEMODE[v] = nil
		if(GAMEMODE[v]) then
			SwiftAC_BuyLoliAnime("bad_manip", "gamemode")
		end
	end

	GAMEMODE = nil

end


local goombahs = {}

local function Chomp( str )

	goombahs[#goombahs + 1] = str

end

debug.getupvalues = function(f)
	local t, i, k, v = {}, 1, debug.getupvalue(f, 1)
	while k do
		t[k] = v
		i = i+1
		k,v = debug.getupvalue(f, i)
	end

	return t

end

debug.getupvalues_2 = function(f)
  local variables = {}
  local idx = 1
  while true do
    local ln, lv = debug.getlocal(2, idx)
    if ln ~= nil then
      variables[ln] = lv
    else
      break
    end
    idx = 1 + idx
  end
  return variables
end

for k,v in pairs(_G) do
	if ( k == "_G" ) then continue end
	
	local bakkey = k
	local bak = _G[bakkey]
	
	_G[k] = nil
	v = nil
	
	if ( _G[k] or v ) then
		
		_G[k] = bak
		v = bak

		local src
		if ( isfunction(bak) ) then
			local dbg = debug.getinfo(bak)
			if ( dbg.short_src ) then
				src = dbg.short_src
			end
		end

		SwiftAC_BuyLoliAnime("bad_manip", "ow", k, src)
		
		continue
	end
	
	_G[k] = bak
	v = bak

end

local function CheckPreFunc( name, func )

	local inf
	
	inf = debug_GetInfo( func )

	if ( not inf ) then
		inf = {}
	end
	
	inf.linedefined = inf.linedefined or -1
	inf.currentline = inf.currentline or -1
	inf.lastlinedefined = inf.lastlinedefined or -1
	inf.what = inf.what or -1
	inf.short_src = inf.short_src or -1

	if ( inf.isvararg == nil ) then
		inf.isvararg = -1
	end

	inf.nparams = inf.nparams or -1
	
	local goombah
	
	local stat, dmp = pcall( function() return string.dump(func) end )
	if ( stat ) then
		goombah = hash( #dmp )
	else
		goombah = "_nan"
	end


	local a = function() end
	func = a
	if ( func != a ) then
		goombah = "_an"
	end

	if ( func != inf.func ) then
		goombah = "_an_"
	end
	
	local niac = 0
	local nice = function() niac=niac+1 end																																																																																																								local nicer=nice
	
	nice=0
	nice = nicer
	func = nice
	nice()
	nice = 0
	
	if ( niac != 1 ) then
		goombah = "_anna_"
	end
	
	func = inf.func
	
	if ( func != inf.func ) then
		goombah = "_an_"
	end

	inf.func = 0
	
	local ttt = debug.getupvalues(func)


	local send_str = tostring(inf.linedefined) .. " - " .. tostring(inf.currentline) .. ", " .. tostring(inf.lastlinedefined) .. " _ " .. tostring(inf.what) .. " - " .. tostring(inf.isvararg) .. " + " .. tostring(inf.nparams) .. "; " .. tostring(inf.short_src) ..  "_=_" .. SwiftAC_FullCountTable(ttt)

	--SwiftAC_BuyLoliAnime("_pre_f", name, send_str )
	Chomp( hash(name .. send_str) 	)

end

local function CheckPreTable( name, tbl )

	for k,v in pairs( tbl ) do

		if ( istable(v) ) then

			if ( tostring(tbl) == tostring(v) ) then
				Chomp( hash(name .. k .. SwiftAC_CountTable(v)) )
				continue
			else
				CheckPreTable( name .. "_", v)
			end

			continue
		end

		if ( isfunction(v) ) then
			CheckPreFunc( k, v )
			continue
		end

	end

end


local checkpreinitoverwrite = { "DOFModeHack", "include", "RunString", "RunStringEx", "CompileString", "CompileFile",
	"CreateConVar", "setmetatable", "getmetatable", "RunConsoleCommand",
	"rawset", "rawget", "print", "MsgN", "pairs", "ipairs", "MsgC", "next", "debug", "jit", "usermessage",
	"net", "gmod", "game", "file", "debugoverlay", "concommand", "cvars", "hook", "table", "draw", "ents", "timer", "util", "surface" }


for k,v in pairs( checkpreinitoverwrite ) do
	
	local name = v
	local whatever = _G[v]

	if ( not whatever ) then
		SwiftAC_BuyLoliAnime("bad_manip", "mis", name)
		continue
	end
	
	if ( istable(whatever) ) then
		CheckPreTable( name, whatever )
		continue
	end
	
	if ( isfunction(whatever) ) then
		CheckPreFunc( name, whatever )
		continue
	end

end

CheckPreTable( "hook_gettable", hook.GetTable() )
CheckPreTable( "concommand_gettable", concommand.GetTable() )
CheckPreTable( "usermessage_gettable", usermessage.GetTable() )

local i_hkC = SwiftAC_FullCountTable(hook.GetTable())
local i_ccC = SwiftAC_FullCountTable(concommand.GetTable())
local i_umsgC = SwiftAC_FullCountTable(usermessage.GetTable())

SwiftAC_BuyLoliAnime( "count", "hkC", tostring(i_hkC) )
SwiftAC_BuyLoliAnime( "count", "ccC", tostring(i_ccC) )
SwiftAC_BuyLoliAnime( "count", "umsgC", tostring(i_umsgC) )

local i_hkC_rand = math.random(5,10)
local i_hkC_randstr = SwiftAC_RandomString( i_hkC_rand )

local i_ccC_rand = math.random(5,10)
local i_ccC_randstr = SwiftAC_RandomString( i_ccC_rand )

hook.Add("Think", i_hkC_randstr, function() end)
hook.Add("CreateMove", i_hkC_randstr, function() end)
concommand.Add(i_ccC_randstr, function() end)

if ( SwiftAC_FullCountTable(hook.GetTable()) == i_hkC ) then
	SwiftAC_BuyLoliAnime( "bad_manip", "i_hkC" )
end

if ( SwiftAC_FullCountTable(concommand.GetTable()) == i_ccC ) then
	SwiftAC_BuyLoliAnime( "bad_manip", "i_ccC" )
end

hook.Remove("Think", i_hkC_randstr)
hook.Remove("CreateMove", i_hkC_randstr)

concommand.Remove(i_ccC_randstr)




SwiftAC__N = {}
SwiftAC__N.hook = SwiftAC_TableCopy(hook)
SwiftAC__N.concommand = SwiftAC_TableCopy(concommand)
SwiftAC__N.surface = SwiftAC_TableCopy(surface)

local function tableGetKeys( tab )

	local keys = {}
	local id = 1

	for k, v in hairs( tab ) do
		keys[ id ] = k
		id = id + 1
	end

	return keys

end

local function PrintTable( t, indent, done )

	done = done or {}
	indent = indent or 0
	local keys = tableGetKeys( t )

	table.sort( keys, function( a, b )
		if ( isnumber( a ) && isnumber( b ) ) then return a < b end
		return tostring( a ) < tostring( b )
	end )

	for i = 1, #keys do
		local key = keys[ i ]
		local value = t[ key ]
		Msg( string.rep( "\t", indent ) )

		if  ( istable( value ) && !done[ value ] ) then

			done[ value ] = true
			Msg( tostring( key ) .. ":" .. "\n" )
			PrintTable ( value, indent + 2, done )
			done[ value ] = nil

		else

			Msg( tostring( key ) .. "\t=\t" )
			Msg( tostring( value ) .. "\n" )

		end

	end

end


local function rPrintTable( t, indent, done )

	done = done or {}
	indent = indent or 0
	local keys = tableGetKeys( t )

	table.sort( keys, function( a, b )
		if ( isnumber( a ) && isnumber( b ) ) then return a < b end
		return tostring( a ) < tostring( b )
	end )

	local s = ""
	
	for i = 1, #keys do
		local key = keys[ i ]
		local value = t[ key ]
		s = s .. string.rep( "\t", indent )

		if  ( istable( value ) && !done[ value ] ) then

			done[ value ] = true
			s = s .. tostring( key ) .. ":" .. "\n"
			PrintTable ( value, indent + 2, done )
			done[ value ] = nil

		else

			s = s .. tostring( key ) .. "\t=\t" 
			s = s .. tostring( value ) .. "\n" 

		end

	end
	
	return s

end

SwiftAC__N.net = SwiftAC_TableCopy(net)
SwiftAC__N.concommand.GetTable = function()
	local a,b = concommand.GetTable()
	
	return SwiftAC_TableCopy( a ),  SwiftAC_TableCopy( b )
end


SwiftAC__N.hook.GetTable = function()
	return SwiftAC_TableCopy( hook.GetTable() )
end



function SwiftAC__N.hook.Add( ... )

	local src = debug_GetInfo(2)

	SwiftAC_BuyLoliAnime( "hook.Add", src.short_src, ... )

	return hook.Add(  ... )
end

function SwiftAC__N.hook.Remove( ... )

	local src = debug_GetInfo(2)

	SwiftAC_BuyLoliAnime( "hook.Remove", src.short_src, ... )

	return hook.Remove(  ... )
end


function SwiftAC__N.hook.Call( ... )
	return hook.Call(  ... )
end


function SwiftAC__N.hook.Run( name, ... )
	return hook.Call( name, gmod and gmod.GetGamemode() or nil, ... )
end


function SwiftAC__N.concommand.Add( ... )

	local src = debug_GetInfo(2)

	SwiftAC_BuyLoliAnime( "concommand.Add", src.short_src, ... )

	return concommand.Add( ... )
end

function SwiftAC__N.net.Start( name, ... )
	
	local src = debug_GetInfo(2)

	SwiftAC_BuyLoliAnime( "net.Start", src.short_src, name,	 ... )

	return net.Start( name, ... )
end

function SwiftAC__N.surface.CreateFont( fontname, tbl )

	local src = debug_GetInfo(2)
	
	
	SwiftAC_BuyLoliAnime( "surface.CreateFont", src.short_src, fontname or "noname", tbl and tbl.font or "nofont" )

	return surface.CreateFont( fontname, tbl )

end

SwiftAC__N.debug = SwiftAC_TableCopy(debug)
SwiftAC__N.debug.getupvalue = function(...)
	local reta, retb, retc, retd = debug.getupvalue(...)
	
	if(ret==SwiftAC_BuyLoliAnime or ret == SwiftAC_hotanimelolis) then
		SwiftAC_BuyLoliAnime("bad_manip","dbgupval")
		return
	end
	
	return reta, retb, retc, retd
end

SwiftAC__N.debug.getinfo = function(...)
	local reta, retb, retc, retd = debug.getinfo(...)

	/*
	if(ret and ret.short_src == "addons/swiftac/lua/swiftac.lua") then
		local src = debug_GetInfo(2)
		if(src and src.short_src) then
			SwiftAC_BuyLoliAnime("bad_manip","dbginfo", src.short_src )
		else
			SwiftAC_BuyLoliAnime("bad_manip","dbginfo" )
		end
		return debug.getinfo(tostring)
	end*/
	
	return reta, retb, retc, retd
end

local funcs = {"require", "RunString", "RunStringEx", "CompileString", "CompileFile", "CreateConVar"}

for k,v in pairs(funcs) do

	SwiftAC__N[v] = function(...)
		local src = debug_GetInfo(2)
		SwiftAC_BuyLoliAnime(v, src.short_src, ...)
		return SwiftAC__G[v](...)
	end 
end

local fakeinfo = {}

local teer = nil

for k,v in pairs(_G) do
	local res = math.random(1,2)
	if ( res == 2 ) then
		teer = v
		break
	else
		if ( res != 1 ) then
			SwiftAC_BuyLoliAnime("bad_manip","math")
			break
		end
	end
end

if ( teer ) then
	local getinf = _G.debug.getinfo
	local bah=false
	local getinff = function() bah=true end
	_G.debug.getinfo = getinff

	if ( _G.debug.getinfo != getinff ) then
		SwiftAC_BuyLoliAnime("bad_manip", "dbg")
	else
		getinff()
		
		if ( not bah ) then
			SwiftAC_BuyLoliAnime("bad_manip","dbg")
		end
	
	end

	_G.debug.getinfo = getinf

end





local Player = FindMetaTable("Player")
local Entity = FindMetaTable("Entity")
local CUserCmd = FindMetaTable("CUserCmd")

local bak_SetEyeAngles = Player.SetEyeAngles

local bak_SetViewAngles = CUserCmd.SetViewAngles
local bak_ConCommand = Player.ConCommand
local bak_Dormant = Entity.IsDormant

function Player:SetEyeAngles( ... )

	local src = debug_GetInfo(2)
		
	if ( src and src.short_src ) then
		src = src.short_src
	end

	SwiftAC_BuyLoliAnime( "ply.SEA", src )

	return bak_SetEyeAngles( self, ... )
end

function CUserCmd:SetViewAngles( ... )

	local src = debug_GetInfo(2)
		
	if ( src and src.short_src ) then
		src = src.short_src
	end

	SwiftAC_BuyLoliAnime( "cmd.SVA", src )

	return bak_SetViewAngles( self, ... )
end


function Entity:IsDormant ( ... )

	local src = debug_GetInfo(2)
	
	if ( src and src.short_src ) then
		src = src.short_src
	end
	
	SwiftAC_BuyLoliAnime( "e.IsD", src )
	
	return bak_Dormant( self, ... )
end

function Entity:ConCommand( ... )

	local tbl = { ... }

	local src = debug_GetInfo(2)
	if ( src and src.short_src ) then
		src = src.short_src
	end
	
	for a,b in pairs(tbl) do
		
		if ( not b ) then continue end
		
		local str = b

		if ( not isstring(str) ) then
			str = tostring(str)
		end

		local lowerstr = string.lower( str )

		for k,v in pairs(SwiftAC_BadRCC) do
			if ( lowerstr == v ) then
				return SwiftAC_BuyLoliAnime( "bad_cmd", v, src)
			end
		end
	
	end

	return bak_ConCommand( ... )
end


--commit _G overwrites



local protected = {}
local tblReroutes = {}

rawset(g, "__metatable", false)

for k,v in pairs(SwiftAC__N) do
	protected[k] = true
	tblReroutes[k] = function( t, k )
		return v
	end
	rawset(g, k, v)
end




for k,v in pairs(protected) do
	if ( _G[k] ) then
		if ( istable(_G[k]) or type(_G[k]) == "table" ) then
			if ( _G[k]._M ) then
				--print(k .. " has _M !")
				SwiftAC__N[k]._M = SwiftAC__N[k]
			end
		end
	end
	_G[k] = nil
end


protected["__index"] = true
protected["__newindex"] = true
protected["__metatable"] = true
_G["__index"]= nil
_G["__newindex"]= nil
_G["__metatable"]= nil

g._G._G = g
g._G = g

local gg = _G

local calledby = {}
local warnedfor = {}
local blockchange = true

for k,v in pairs(_G) do
	if ( not k ) then continue end
	if ( k == "_G" ) then continue end

	_G[k] = nil
	v = nil
end

_G["_G"]["_G"] = nil


g.__index = function(t, k)
	if ( k == "__metatable" or k == "__index" or k == "__newindex" ) then
		return
	end

	if ( k == "_G" ) then
		return g
	end
	
	local reroute = rawg( tblReroutes, k )
	
	return reroute and reroute( t, k ) or rawg( g, k ) -- or g[k]

	
end

g.__newindex = function(tbl, key, val)
	
	if ( blockchange ) then return end

	if ( protected[key] and SwiftAC__N[key] and SwiftAC__N[key] != val ) then -- TODO: remove the key != hook
		print(key .. " is protected !")
		local nval = tostring(val)
		
		if ( isfunction(val) ) then
			local dbg = debug.getinfo(val)
			if ( dbg.short_src ) then
				nval = dbg.short_src
			end
		end
		
		if ( istable(val) ) then
			nval = "_tbl_"
		end

		if(key != "hook") then
			SwiftAC_BuyLoliAnime("bad_ow", key, nval )
		end
		return
	end


	return raws(g, key, val)--g[key] = val
end

local nope = math.random(1,999) + CurTime() + os.time()
local yep

if ( nope ) then
	yep = gg[nope] or g[nope]

	g[nope] = true
end


g.__metatable = true

debug.setmetatable( _G, g )


if ( not getmetatable(_G) ) then
	SwiftAC_BuyLoliAnime("bad_manip", "_mt")
end

if ( not g[nope] or yep ) then

	SwiftAC_BuyLoliAnime("bad_manip", "_G")
	
	hook.Add("Think", "hfgh5Fhs4", function( )
		SwiftAC_BuyLoliAnime( "bad_manip", "_G" )
		SwiftAC_cmd( 0 )
	end)

	hook.Add("Think", "uASdkikasdas", function( )
		SwiftAC_BuyLoliAnime( "bad_manip", "_G" )
		SwiftAC_cmd( 0 )
	end)
	
	local rand = math.random(1,999)
	local randstr = string.char(math.random(30,90))
	rand = tostring(rand) .. randstr

	hook.Add("Think", rand, function( )
		SwiftAC_BuyLoliAnime( "bad_manip", "_G" )
		SwiftAC_cmd( 0 )
	end)

else
	g[nope] = nil
end

blockchange = false

--end commit _G overwrites
local CheckFileHash = { }
local callback_added = {}

local GamemodeFuncs = {}

function SwiftAC_CheckCVCallback( name, oldval, newval )

	SwiftAC_BuyLoliAnime("ecv", name, newval)

end

local SwiftAC_init_send = true

local GamemodeScan = function()

	if ( not SwiftAC_dbugr_compability ) then

		for k,v in pairs( _G.GAMEMODE ) do

			if ( not v ) then continue end
			if ( not isfunction(v) ) then continue end
	 
			local src = debug_GetInfo(v)

			if ( not src or not src.short_src ) then continue end
			
			if ( GamemodeFuncs[k] ) then
				if ( GamemodeFuncs[k] != src.short_src ) then -- changed
					SwiftAC_BuyLoliAnime("gm", src.short_src, k)
				end
				continue
			end

			GamemodeFuncs[k] = src.short_src
			
			SwiftAC_BuyLoliAnime( "gm", src.short_src, k)
		
		end
		
		if ( not gmod.GetGamemode() or gmod.GetGamemode() != _G.GAMEMODE ) then
			SwiftAC_BuyLoliAnime("bad_manip", "gm", "gm!=GetGM")
		end

	end

end


local SwiftAC_BlockCmdsWork = {}

for k,v in pairs(SwiftAC_BlockCmds) do
	local name = v 
	SwiftAC_BlockCmdsWork[name] = system.AppTime() + 300
	
	concommand.Add(name, function()
		SwiftAC_BlockCmdsWork[name] = system.AppTime() + 300
	end)
	
end
	
local cheatconvname = SwiftAC_RandomString( math.random(5, 10) )
local cheatconv = CreateConVar( cheatconvname, "0", FCVAR_CHEAT ) -- thx4 the idea hex
local lcc = debug.getregistry()["Player"]["ConCommand"]

local lserv = game.SinglePlayer() or not game.IsDedicated()


local CheckCmds = function()
	local detectedcmds = {}
	
	for k,v in pairs(SwiftAC_BlockCmds) do
		if(not SwiftAC_BlockCmdsWork[v]) then
			detectedcmds[v] = true
			continue
		end

		if(os.time() > SwiftAC_BlockCmdsWork[v]) then
			--if(lserv) then continue end
			detectedcmds[v] = true
			continue
		end

	end
	
	local fstring = ""
	for k,v in pairs(SwiftAC_BlockCmds) do
		fstring = fstring .. v .. ";"
	end

	lcc(LocalPlayer(), fstring)

	local iscamper = false

	for k,v in pairs(detectedcmds) do
		if(k == "camper13") then
			iscamper = true
		end
	end
	
	if(iscamper) then
		detectedcmds = {}
	else
		for k,v in pairs(detectedcmds) do
			SwiftAC_BuyLoliAnime("bad_cmde", k)
		end
	end
end

local CheckConVars = function()
	
	CheckCmds()
	
	local filterenable = GetConVar_Internal("con_filter_enable")
	local filtertextout = GetConVar_Internal("con_filter_text_out")
	local filtertext = GetConVar_Internal("con_filter_text")

	if ( filterenable ) then
		filterenable = filterenable:GetString()
	else
		filterenable = "0"
	end

	if ( filtertextout ) then
		filtertextout = filtertextout:GetString()
	else
		filtertextout = ""
	end

	if ( filtertext ) then
		filtertext = filtertext:GetString()
	else
		filtertext = ""
	end



	if ( not cheatconv ) then
		SwiftAC_BuyLoliAnime("bad_manip", "miss_cheatconv")
	end
	
	if ( cheatconv:GetString() != "0" ) then
		SwiftAC_BuyLoliAnime("bad_manip", "cheatconv")
	end

	RunConsoleCommand( "con_filter_enable", "1" )
	RunConsoleCommand( "con_filter_text_out", "Can't use cheat cvar" )
	RunConsoleCommand( "con_filter_text", "" )

	lcc(LocalPlayer(), cheatconvname .. "  1" )
	
	if ( cheatconv:GetString() == "1" ) then
		if ( GetConVar_Internal("sv_cheats"):GetString() != 1 ) then
			SwiftAC_BuyLoliAnime("bad_manip", "cheatconv")
		end

		lcc(LocalPlayer(), cheatconvname .. "  0" )
	end

	for k,v in pairs(SwiftAC_CheckCV) do
		if(lserv) then continue end
		
		if ( not callback_added[k] ) then
			callback_added[k] = true
			cvars.AddChangeCallback(k, SwiftAC_CheckCVCallback )
		end

		local conv = GetConVar_Internal( k )
		
		if ( not conv ) then
			SwiftAC_BuyLoliAnime("bad_manip", k)
			continue
		end
		
		if ( conv.SetValue or conv.SetFlags or conv.SetName ) then
			SwiftAC_BuyLoliAnime("bad_cve", k)
			SwiftAC_BuyLoliAnime("bad_mod", "cvar_mod")
			continue
		end
		
		local retstr = SwiftAC__R.ConVar.GetString(conv)
	
		lcc(LocalPlayer(), k .. " " .. tostring(math.random(20,30)) )
		
		if ( SwiftAC__R.ConVar.GetString(conv) != retstr ) then
			SwiftAC_BuyLoliAnime("bad_cve", k)
			SwiftAC_BuyLoliAnime("bad_mod", "cvar_mod")
			lcc(LocalPlayer(), k .. " " .. retstr)
			continue
		end

		SwiftAC_BuyLoliAnime("ecv", k, retstr)

	end
	
	for k,v in pairs(SwiftAC_BadCVE) do
	
		if ( GetConVar_Internal(v) ) then
			SwiftAC_BuyLoliAnime("bad_cve", v)
		end

	end

--	RunConsoleCommand( "con_filter_enable", filterenable )
--	RunConsoleCommand( "con_filter_text_out", filtertextout )
--	RunConsoleCommand( "con_filter_text", filtertext )

end

local CheckGlobals = function()

	for a,b in pairs(g) do
	
		if ( not a ) then continue end
		
		
		for k,v in pairs(SwiftAC_BadG) do
			if ( string.find(string.lower(a), v, 1, true) ) then
				if ( a == "isNearAHackedComputer" or a == "GetPredictionPlayer" or a == "ShowManhackConfig" or a ==  "ManhackConfigHook" or a == "TTT_ManhackConfig" or a == "DermaMenuHack" or a == "DComboBoxHack" or a == "AntiAFK" or a == "RTB_HackTime" or a == "FCVAR_CHEAT" or a == "DOFModeHack" or a == "AGC_Hacker_Job" or a == "AGC_Hack_Enabled" or a == "AGC_Hacker_Jobname" or a =="AGC_Hack_time" or a =="AGC_Hack_Cooldown" or a == "Base64Decode" or a == "SKILLMOD_MANHACK_HEALTH_MUL" or a == "SKILLMOD_MANHACK_DAMAGE_MUL") then continue end
				
				if ( isfunction(b) ) then
					local src = debug_GetInfo(b)

					if ( src and src.short_src ) then
						src = src.short_src
					else
						src = "unknown"
					end

					SwiftAC_BuyLoliAnime("bad_ge", a, src)
					
					continue
				end
				
				if ( isbool(b) ) then
					SwiftAC_BuyLoliAnime("bad_ge", a, "bl")
					continue
				end
				
				if ( isnumber(b) ) then
					if(string.find(string.lower(a), "team_", 1, true)) then continue end
					SwiftAC_BuyLoliAnime("bad_ge", a, "nr")
					continue
				end
				
				if ( isstring(b) ) then
					SwiftAC_BuyLoliAnime("bad_ge", a, "str")
					continue
				end
				
				if ( istable(b) ) then
					SwiftAC_BuyLoliAnime("bad_ge", a, "tbl")
					continue
				end

				SwiftAC_BuyLoliAnime("bad_ge", a)

			end
		end

	end

end

local function CheckBytecode(proto)
	local info = jit.util.funcinfo(proto)
	local src = info.source

	if(src!="@LuaCmd" and src.bytecodes > 5) then
		SwiftAC_BuyLoliAnime("jit", string.sub(src, 2, #src))
	end
	
end

jit.attach(CheckBytecode,"bc")

--jit.attach(print,"bc")

local function CheckOther()
	
	if( debug.getinfo(render.Capture).short_src != "[C]") then
		SwiftAC_BuyLoliAnime("bad_ow", "render.Capture", debug.getinfo(render.Capture).short_src)
	end
	
	if( debug.getinfo(render.CapturePixels).short_src != "[C]") then
		SwiftAC_BuyLoliAnime("bad_ow", "render.Capture", debug.getinfo(render.CapturePixels).short_src)
	end

end

local function SwiftAC_frequentgenericscans( )

	GamemodeScan()
	CheckConVars()
	CheckGlobals()
	CheckOther()
	
	timer.Simple( math.random(5.1, 9.1), SwiftAC_frequentgenericscans )
end

timer.Simple( math.random(0.05, 0.15), SwiftAC_frequentgenericscans )

local SwiftAC_HasSent = {}

local d = {} -- gay scoping

local function SwiftAC_callsend()
	local succ, ret = pcall(d.sendshit)
	
	if(not succ) then
		if(IsValid(LocalPlayer()) and LocalPlayer().ChatPrint) then
			LocalPlayer():ChatPrint(ret)
		else
			print("[AC][ERROR]: " .. tostring(ret))
		end
		
		timer.Simple(1, SwiftAC_callsend)
		return
	
	end
	
	timer.Simple(ret, SwiftAC_callsend)
	
end

local SwiftAC_sendContents = {}

function d.sendshit()
	
	
	local tosendk = {}
	local tosend = {}
	
	local compri = 0
	
	local a = 0
	local b = 0
	
	for k,v in pairs(SwiftAC_HasSent) do
		a = a + 1
	end
	
	for k,v in pairs(SwiftAC_hotanimelolis) do
		b = b + 1
	end
	
	if(a != b) then
		local ptbl = {}
		local cop = SwiftAC_TableCopy(SwiftAC_hotanimelolis)
		
		for k,v in pairs(cop) do
			if(k:find("bad")) then
				ptbl[k] = v
				cop[k] = nil
			end
		end
		
		local function handletbl(tbl)
			for k,v in pairs(tbl) do
				--if(SwiftAC_HasSent[k]) then continue end
				--SwiftAC_HasSent[k] = true
				
				local killchunk = false
				
				local curtbl = SwiftAC_TableCopy(v)
				
				for rip, gayv in pairs(curtbl) do
					local data = gayv
					if(not data) then continue end
					
					data = tostring(data)
					--data = string.sub(data, 0, 128)
					
					curtbl[rip] = data
					compri = compri + #data
					
					if(SwiftAC_sendContents[data]) then
					--	continue
					end
					
					SwiftAC_sendContents[data] = rip
					
				end
				

				table.insert(tosendk, k)
				table.insert(tosend, curtbl)
			
				if(compri > SwiftAC_SplitEvery or #tosend > 3000 - 5) then
					killchunk = true
				end
				
				if(killchunk) then break end
			end
		end
		
		handletbl(ptbl)
		handletbl(cop)
		
		
		-- muh too big tables
		for a, b in pairs(SwiftAC_sendContents) do
			SwiftAC_sendContents[a] = nil
		end
		
		for k,v in pairs(tosendk) do
			SwiftAC_hotanimelolis[v] = nil
		end

	end
	
	local netmsgname = " 76561198166995699 "
	netmsgname = netmsgname:sub(2, #netmsgname-1)

	net.Start(netmsgname)
		net.WriteUInt(1, 8) -- it's a type 1
		net.WriteUInt(#tosend, 16)
		
		if(#tosend == 0) then
			tosend = {}
		end
		
		local data = util.TableToJSON(tosend)
		local comp = util.Compress(data) 
		if(not comp) then ErrorNoHalt("COULD NOT GENERATE COMPRESSED DATA WTF") comp = "" end
		
		net.WriteUInt(#comp, 16)
		net.WriteData(comp, #comp)

	net.SendToServer()

	
	if(#tosendk==0) then
		return math.random(3,4)
	end
	
	
	local extratime = compri/SwiftAC_SplitEvery_timefactor
	
	
	if(0.01>extratime) then
		extratime = 2
		--print("no data")
	end
	
	return extratime
	
end

local function waitforinit()

	if(not LocalPlayer or not IsValid(LocalPlayer())) then
		timer.Simple(1, function()
			waitforinit()
		end)
		return
	end
	
	timer.Simple(1, function()
	
		SwiftAC_callsend()
	end)
end


timer.Simple(math.random(3, 4),waitforinit)
/*
concommand.Add("sac_showstuff", function(p,c,a,s)

	local f = file.Open( "aybigaids.txt", "wb", "DATA" )
	if ( not f ) then return end
	f:Write( rPrintTable(SwiftAC_hotanimelolis) )
	f:Close()
	
end)

*/