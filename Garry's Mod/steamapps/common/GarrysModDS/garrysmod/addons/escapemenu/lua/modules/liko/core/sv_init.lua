/*
*   @package        : rcore
*   @module         : liko
*   @author         : Richard [http://steamcommunity.com/profiles/76561198135875727]
*   @copyright      : (c) 2015 - 2020
*   @website        : https://rlib.io
*   @docs           : https://docs.rlib.io
*
*   LICENSOR HEREBY GRANTS LICENSEE PERMISSION TO MODIFY AND/OR CREATE DERIVATIVE WORKS BASED AROUND THE
*   SOFTWARE HEREIN, ALSO, AGREES AND UNDERSTANDS THAT THE LICENSEE DOES NOT HAVE PERMISSION TO SHARE,
*   DISTRIBUTE, PUBLISH, AND/OR SELL THE ORIGINAL SOFTWARE OR ANY DERIVATIVE WORKS. LICENSEE MUST ONLY
*   INSTALL AND USE THE SOFTWARE HEREIN AND/OR ANY DERIVATIVE WORKS ON PLATFORMS THAT ARE OWNED/OPERATED
*   BY ONLY THE LICENSEE.
*
*   YOU MAY REVIEW THE COMPLETE LICENSE FILE PROVIDED AND MARKED AS LICENSE.TXT
*
*   BY MODIFYING THIS FILE -- YOU UNDERSTAND THAT THE ABOVE MENTIONED AUTHORS CANNOT BE HELD RESPONSIBLE
*   FOR ANY ISSUES THAT ARISE FROM MAKING ANY ADJUSTMENTS TO THIS SCRIPT. YOU UNDERSTAND THAT THE ABOVE
*   MENTIONED AUTHOR CAN ALSO NOT BE HELD RESPONSIBLE FOR ANY DAMAGES THAT MAY OCCUR TO YOUR SERVER AS A
*   RESULT OF THIS SCRIPT AND ANY OTHER SCRIPT NOT BEING COMPATIBLE WITH ONE ANOTHER.
*/

/*
*   standard tables and localization
*/

local base                  = rlib
local helper                = base.h
local access                = base.a

/*
*   module calls
*/

local mod, pf       	    = base.modules:req( 'liko' )
local cfg               	= base.modules:cfg( mod )

/*
*   Localized translation func
*/

local function ln( ... )
    return base:translate( mod, ... )
end

/*
*	prefix ids
*/

local function pref( str, suffix )
    local state = not suffix and mod or isstring( suffix ) and suffix or false
    return base.get:pref( str, state )
end

/*
*	initialize
*
*	initial setup
*/

local function initialize( )
    if not cfg.initialize.motd_enabled or not ulx then return end

    local int_cvar  = GetConVar( 'ulx_showMotd' )
    int_cvar:SetInt ( 0 )

    base:log( 1, 'disabling ulx motd' )
end
rhook.new.gmod( 'Initialize', 'liko_init', initialize )

/*
*	pl > join
*
*	determines if the ui should load when a player connects to the server.
*
*	@param  : ply pl
*/

local function ips_initialize( pl )
    timex.create( pl:aid64( mod.id, 'onjoin', 'delay' ), 3, 1, function( )

        /*
        *	welcome messages
        */

        if cfg.welcome.enabled and isfunction( cfg.welcome.action ) then
            cfg.welcome.action( pl )
        end

        /*
        *	precache
        */

        if cfg.initialize.precache and not cfg.initialize.motd_enabled then
            rnet.send.player( pl, 'liko_pl_join_pc' )
        end

        /*
        *	initialize data
        *
        *   motd_enabled == false
        *   setup pl tables but do not open motd
        */

        if not cfg.initialize.motd_enabled then
            rnet.send.player( pl, 'liko_initialize', { bopen = false } )
            return
        end

        /*
        *	cfg.dev.perm_canignore_enabled AND liko_motd_canignore perm true
        *
        *   setup pl tables but do not open motd
        */

        if cfg.dev.perm_canignore_enabled and access:strict( pl, 'liko_motd_canignore', mod ) then
            base.msg:target( pl, 'MOTD', 'You have permission to ignore the MOTD on join' )
            rnet.send.player( pl, 'liko_initialize', { bopen = false } )
            return
        end

        /*
        *	normal open
        *
        *   motd_enabled == true
        */

        rnet.send.player( pl, 'liko_initialize', { bopen = true } )
    end )
end
rhook.new.gmod( 'PlayerInitialSpawn', 'liko_pl_join_init', ips_initialize )

/*
*	pl > toggle
*
*	toggles the interface
*
*	@param  : ply pl
*	@param  : str text
*/

local function pl_say_toggle( pl, text )
    if not helper.ok.ply( pl ) then return end
    text = text:lower( )
    if cfg.binds.chat.main[ text ] then
        pl:rcc( 'liko_toggle' )
        return false
    end
end
rhook.new.gmod( 'PlayerSay', 'liko_pl_say_toggle', pl_say_toggle )

/*
*	pl > toggle > motd
*
*	toggles the interface if motd mode enabled
*
*	@param  : ply pl
*	@param  : str text
*/

local function pl_say_motd( pl, text )
    if not helper.ok.ply( pl ) then return end
    text = text:lower( )
    if cfg.binds.chat.motd[ text ] and cfg.initialize.motd_enabled then
        pl:rcc( 'liko_toggle' )
        return false
    end
end
rhook.new.gmod( 'PlayerSay', 'liko_pl_say_motd', pl_say_motd )