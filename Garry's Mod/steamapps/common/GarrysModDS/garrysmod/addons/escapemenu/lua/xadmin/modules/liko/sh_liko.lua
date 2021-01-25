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
*   require mod
*/

if not mod or not xAdmin then return end

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
*   module functionality
*/

local CATEGORY              = perm( 'index' ).category
local MODULE                = perm( 'index' ).module

/*
*   xadmin
*/

xAdmin.liko                 = xAdmin.liko or { }
local CATEGORY_NAME         = MODULE

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
*   xadmin > cmd > liko_ui_open
*
*   @param	: ply admin
*   @param  : tbl args
*/

function xAdmin.liko.ui_open( admin, args )

    /*
    *	check dependency
    */

    if not checkDependency( admin ) then return end

    /*
    *	target
    */

    local targs = xAdmin.GetTargetsFromArg( admin, id_ui_open.xam_id, args[ 1 ] )

    for k, v in ipairs( targs ) do
        local target = isstring( v ) and player.GetBySteamID( v ) or v

        if helper.ok.ply( target ) then
            rnet.send.player( target, 'liko_ui_init' )
        end
    end

end
xAdmin.RegisterCommand( id_ui_open.xam_id, id_ui_open.name, id_ui_open.desc, id_ui_open.notify, CATEGORY_NAME, xAdmin.liko.ui_open, { { xAdmin.ARG_PLAYER, xAdmin.GetLanguageString( 'target' ) } } )

/*
*   xadmin > cmd > liko_ui_rehash
*
*   @param	: ply admin
*   @param  : tbl args
*/

function xAdmin.liko.ui_rehash( admin, args )

    /*
    *	check dependency
    */

    if not checkDependency( admin ) then return end

    /*
    *	target
    */

    local targs = xAdmin.GetTargetsFromArg( admin, id_ui_rehash.xam_id, args[ 1 ] )

    for k, v in ipairs( targs ) do
        local target = isstring( v ) and player.GetBySteamID( v ) or v

        if helper.ok.ply( target ) then
            rnet.send.player( target, 'liko_ui_rehash' )
        end
    end

end
xAdmin.RegisterCommand( id_ui_rehash.xam_id, id_ui_rehash.name, id_ui_rehash.desc, id_ui_rehash.notify, CATEGORY_NAME, xAdmin.liko.ui_rehash, { { xAdmin.ARG_PLAYER, xAdmin.GetLanguageString( 'target' ) } } )

/*
*   xadmin > cmd > liko_rnet_reload
*
*   @param	: ply admin
*   @param  : tbl args
*/

function xAdmin.liko.rnet_reload( admin, args )

    /*
    *	check dependency
    */

    if not checkDependency( admin ) then return end

    /*
    *	rhook
    */

    rhook.run.rlib( 'liko_rnet_register', admin )

end
xAdmin.RegisterCommand( id_rnet_reload.xam_id, id_rnet_reload.name, id_rnet_reload.desc, id_rnet_reload.notify, CATEGORY_NAME, xAdmin.liko.rnet_reload, { } )

/*
*   xadmin > cmd > liko_fonts_reload
*
*   @param  : pl admin
*   @param  : tbl args
*/

function xAdmin.liko.fonts_reload( admin, args )

    /*
    *	check dependency
    */

    if not checkDependency( admin ) then return end

    /*
    *	rhook
    */

    rnet.send.player( admin, 'liko_fonts_reload' )

end
xAdmin.RegisterCommand( id_fonts_reload.xam_id, id_fonts_reload.name, id_fonts_reload.desc, id_fonts_reload.notify, CATEGORY_NAME, xAdmin.liko.fonts_reload, { } )