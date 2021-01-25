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
*	register net libraries
*/

local function rnet_register( pl )

    /*
    *	permission > rnet refresh
    */

    if ( ( helper.ok.ply( pl ) or base.con:Is( pl ) ) and not access:allow_throwExcept( pl, 'rlib_root' ) ) then return end

    /*
    *   rnet > liko_initialize
    *
    *   called when script is initialized
    */

    rnet.new		( 'liko_initialize'         )
    rnet.add        ( 'bopen',      RNET_BOOL   )
    rnet.run	    (                           )

    /*
    *   rnet > liko_ui_init
    *
    *   opens the mod main interface
    */

    rnet.new		( 'liko_ui_init'            )
    rnet.run	    (                           )

    /*
    *   rnet > liko_ui_rehash
    *
    *   destroys and recreates addons entire interface
    *   useful for debugging / modifying interface
    */

    rnet.new		( 'liko_ui_rehash'          )
    rnet.run	    (                           )

    /*
    *   rnet > liko_pl_join_pc
    *
    *   called when player requests interface to be precached
    */

    rnet.new		( 'liko_pl_join_pc'         )
    rnet.run	    (                           )

    /*
    *   rnet > fonts > reload
    */

    rnet.new        ( 'liko_fonts_reload'       )
    rnet.run        ( 						    )

    /*
    *   concommand > reload
    */

    if helper.ok.ply( pl ) or base.con:Is( pl ) then
        base:log( 4, '[ %s ] rnet reloaded', mod.name )
        if not base.con.Is( pl ) then
            base.msg:target( pl, mod.name, 'rnet module successfully rehashed.' )
        end
    end

end
rhook.new.rlib( 'liko_rnet_register', rnet_register )
rcc.new.rlib( 'liko_rnet_reload', rnet_register )