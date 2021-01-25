/*
*   @package        : rcore
*   @module         : liko
*	@extends		: ulx
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
*   require mod
*/

if not mod or not ulx then return end

/*
*   get access perm
*
*   @param  : str id
*	@return	: tbl
*/

local function perm( id )
    return access:getperm( id, mod )
end

/*
*   declare
*/

local CATEGORY              = perm( 'index' ).category
local MODULE                = perm( 'index' ).module

/*
*   declare perm ids
*/

local id_ui_open 	        = perm( 'liko_ui_open' )
local id_ui_rehash 	        = perm( 'liko_ui_rehash' )
local id_rnet_reload        = perm( 'liko_rnet_reload' )
local id_fonts_reload       = perm( 'liko_fonts_reload' )

/*
*   check dependency
*
*   @param  : ply pl
*/

local function checkDependency( pl )
    if not base or not base.modules:bInstalled( mod ) then
        base.msg:target( pl, MODULE, 'An error has occured with a required dependency. Contact the developer and we will summon the elves.' )
        return false
    end
    return true
end

/*
*   ulx > ui > open
*
*	opens interface
*
*   @param	: ply calling_pl
*	@param	: ply target_pl
*/

function ulx.liko_ui_open( calling_pl, target_pl )

    /*
    *	check dependency
    */

    if not checkDependency( calling_pl ) then return end

    /*
    *	validate ply
    */

    if not helper.ok.ply( target_pl ) then return end

    /*
    *	rnet
    */

    rnet.send.player( target_pl, 'liko_ui_init' )
end
local liko_ui_open                          = ulx.command( CATEGORY, id_ui_open.ulx_id, ulx.liko_ui_open )
liko_ui_open:addParam                       { type = ULib.cmds.PlayerArg }
liko_ui_open:defaultAccess                  ( access:ulx( id_ui_open, mod ) )
liko_ui_open:help                           ( id_ui_open.desc )

/*
*   ulx > ui > rehash
*
*	completely destroys interface and re-creates it. Useful if changing
*   config settings for the addon and need new changes to take affect
*   without a map change / restart
*
*   @param	: ply calling_pl
*	@param	: ply target_pl
*/

function ulx.liko_ui_rehash( calling_pl, target_pl )

    /*
    *	check dependency
    */

    if not checkDependency( calling_pl ) then return end

    /*
    *	validate ply
    */

    if not helper.ok.ply( target_pl ) then return end

    /*
    *	rnet
    */

    rnet.send.player( target_pl, 'liko_ui_rehash' )
end
local liko_ui_rehash                        = ulx.command( CATEGORY, id_ui_rehash.ulx_id, ulx.liko_ui_rehash )
liko_ui_rehash:addParam                     { type = ULib.cmds.PlayerArg }
liko_ui_rehash:defaultAccess                ( access:ulx( id_ui_rehash, mod ) )
liko_ui_rehash:help                         ( id_ui_rehash.desc )

/*
*   ulx > rnet > reload
*
*	registers all network entries for script. Developer purposes only
*
*   @param	: ply calling_pl
*/

function ulx.liko_rnet_reload( calling_pl )

    /*
    *	check dependency
    */

    if not checkDependency( calling_pl ) then return end

    /*
    *	hook
    */

    rhook.run.rlib( 'liko_rnet_register', calling_pl )
end
local liko_rnet_reload                      = ulx.command( CATEGORY, id_rnet_reload.ulx_id, ulx.liko_rnet_reload )
liko_rnet_reload:defaultAccess              ( access:ulx( id_rnet_reload, mod ) )
liko_rnet_reload:help                       ( id_rnet_reload.desc )

/*
*   ulx > fonts > reload
*
*	reloads all fonts registered with addon
*
*   @param	: ply calling_pl
*/

function ulx.liko_fonts_reload( calling_pl )

    /*
    *	check dependency
    */

    if not checkDependency( calling_pl ) then return end

    /*
    *	hook
    */

    rnet.send.player( calling_pl, 'liko_fonts_reload' )
end
local liko_fonts_reload                     = ulx.command( CATEGORY, id_fonts_reload.ulx_id, ulx.liko_fonts_reload )
liko_fonts_reload:defaultAccess             ( access:ulx( id_fonts_reload, mod ) )
liko_fonts_reload:help                      ( id_fonts_reload.desc )