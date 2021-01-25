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
local access                = base.a
local helper                = base.h

/*
*   module calls
*/

local mod, pf       	    = base.modules:req( 'liko' )
local cfg               	= base.modules:cfg( mod )

/*
*	prefix ids
*/

local function pref( str, suffix )
    local state = not suffix and mod or isstring( suffix ) and suffix or false
    return base.get:pref( str, state )
end

/*
*   misc localization
*/

local _f = surface.CreateFont

/*
*   fonts > primary
*/

local function fonts_register( pl )

    /*
    *	perm > reload
    */

        if ( ( helper.ok.ply( pl ) or base.con:Is( pl ) ) and not access:allow_throwExcept( pl, 'rlib_root' ) ) then return end

    /*
    *   general
    */

        _f( pref( 'g_ticker' ),                     { size = 18, weight = 200, antialias = true, font = 'Roboto Lt' } )
        _f( pref( 'g_confl_icon' ),                 { size = 60, weight = 400, antialias = true, font = 'Roboto' } )
        _f( pref( 'g_confl_title' ),                { size = 18, weight = 400, antialias = true, font = 'Roboto' } )
        _f( pref( 'g_confl_msg' ),                  { size = 16, weight = 100, antialias = true, font = 'Roboto Lt' } )
        _f( pref( 'g_section_title' ),              { size = 32, weight = 200, antialias = true, shadow = false, font = 'Advent Pro Light' } )

    /*
    *   servers
    */

        _f( pref( 'serv_btn_name' ),                { size = 25, weight = 400, antialias = true, font = 'Oswald Light' } )

    /*
    *   pl info
    */

        _f( pref( 'pl_online_text' ),               { size = 14, weight = 300, antialias = true, shadow = false, font = 'Advent Pro Light' } )
        _f( pref( 'pl_online_data' ),               { size = 22, weight = 200, antialias = true, shadow = false, font = 'Roboto Lt' } )

    /*
    *   nav menu
    */

        _f( pref( 'nav_item_title' ),               { size = 28, weight = 300, antialias = true, shadow = false, font = 'Oswald Light' } )
        _f( pref( 'nav_item_title_lg' ),            { size = 30, weight = 300, antialias = true, shadow = false, font = 'Oswald Light' } )
        _f( pref( 'nav_item_desc' ),                { size = 16, weight = 500, antialias = true, shadow = false, font = 'Open Sans' } )

    /*
    *   switch server dialog
    */

        _f( pref( 'cwserv_hdr_icon' ),              { size = 24, weight = 100, antialias = true, font = 'Roboto Light' } )
        _f( pref( 'cwserv_hdr_title' ),             { size = 16, weight = 600, antialias = true, font = 'Roboto Light' } )
        _f( pref( 'cwserv_hdr_exit' ),              { size = 40, weight = 800, antialias = true, font = 'Roboto' } )
        _f( pref( 'cwserv_btn_clr' ),               { size = 41, weight = 800, antialias = true, font = 'Roboto' } )
        _f( pref( 'cwserv_btn_copy' ),              { size = 18, weight = 800, antialias = true, font = 'Roboto' } )
        _f( pref( 'cwserv_btn_confirm' ),           { size = 18, weight = 800, antialias = true, font = 'Roboto' } )
        _f( pref( 'cwserv_err' ),                   { size = 14, weight = 800, antialias = true, font = 'Roboto' } )
        _f( pref( 'cwserv_desc' ),                  { size = 16, weight = 400, antialias = true, font = 'Roboto Light' } )
        _f( pref( 'cwserv_info' ),                  { size = 16, weight = 400, antialias = true, font = 'Roboto Light' } )
        _f( pref( 'cwserv_info_icon' ),             { size = 31, weight = 100, antialias = true, font = 'Roboto Light' } )
        _f( pref( 'cwserv_copyclip' ),              { size = 14, weight = 100, antialias = true, shadow = true, font = 'Roboto Light' } )

    /*
    *   news
    */

        _f( pref( 'news_res_title' ),               { size = 24, weight = 400, antialias = true, shadow = true, font = 'Roboto' } )
        _f( pref( 'news_res_text' ),                { size = 17, weight = 200, antialias = true, shadow = false, font = 'Roboto Light' } )
        _f( pref( 'news_res_btn_settings' ),        { size = 18, weight = 200, antialias = true, shadow = false, font = 'Roboto Light' } )

    /*
    *   sliders
    */

        _f( pref( 'slider_header' ),                { size = 28, weight = 200, antialias = true, shadow = false, font = 'Roboto' } )
        _f( pref( 'slider_header_sub' ),            { size = 18, weight = 200, antialias = true, shadow = false, font = 'Roboto' } )
        _f( pref( 'slider_body_title' ),            { size = 28, weight = 200, antialias = true, shadow = false, font = 'Roboto Lt' } )
        _f( pref( 'slider_body_msg' ),              { size = 20, weight = 100, antialias = true, shadow = false, font = 'Segoe UI Light' } )

    /*
    *   ibws > main
    */

        _f( pref( 'ibws_exit' ),                    { size = 40, weight = 800, antialias = true, font = 'Roboto' } )
        _f( pref( 'ibws_icon' ),                    { size = 34, weight = 100, antialias = true, font = 'Roboto Light' } )
        _f( pref( 'ibws_title' ),                   { size = 16, weight = 600, antialias = true, font = 'Roboto Light' } )
        _f( pref( 'ibws_resizer' ),                 { size = 24, weight = 100, antialias = true, font = 'Roboto Light' } )

    /*
    *   ibws > diag
    */

        _f( pref( 'ibws_diag_hdr_icon' ),           { size = 24, weight = 100, antialias = true, font = 'Roboto Light' } )
        _f( pref( 'ibws_diag_hdr_title' ),          { size = 16, weight = 600, antialias = true, font = 'Roboto Light' } )
        _f( pref( 'ibws_diag_hdr_exit' ),           { size = 40, weight = 800, antialias = true, font = 'Roboto' } )
        _f( pref( 'ibws_diag_desc' ),               { size = 16, weight = 400, antialias = true, font = 'Roboto Light' } )
        _f( pref( 'ibws_diag_txt_ack' ),            { size = 16, weight = 400, antialias = true, font = 'Roboto Light' } )
        _f( pref( 'ibws_diag_btn_ack' ),            { size = 18, weight = 800, antialias = true, font = 'Roboto' } )
        _f( pref( 'ibws_diag_ico_hint' ),           { size = 14, weight = 800, antialias = true, font = 'GSym Solid', extended = true } )

    /*
    *   rules
    */

        _f( pref( 'rules_exit' ),                   { size = 40, weight = 800, antialias = true, font = 'Roboto' } )
        _f( pref( 'rules_resizer' ),                { size = 24, weight = 100, antialias = true, font = 'Roboto Light' } )
        _f( pref( 'rules_btn_confirm' ),            { size = 16, weight = 100, antialias = true, font = 'Roboto' } )
        _f( pref( 'rules_icon' ),                   { size = 34, weight = 100, antialias = true, font = 'Roboto Light' } )
        _f( pref( 'rules_title' ),                  { size = 16, weight = 600, antialias = true, font = 'Roboto Light' } )
        _f( pref( 'rules_text' ),                   { size = 16, weight = 400, antialias = true, font = 'Roboto Light' } )

    /*
    *   announcements
    */

        _f( pref( 'ann_icon' ),                     { size = 50, weight = 400, antialias = true, font = 'Roboto' } )
        _f( pref( 'ann_title' ),                    { size = 34, weight = 400, antialias = true, font = 'Advent Pro Light' } )
        _f( pref( 'ann_msg' ),                      { size = 16, weight = 400, antialias = true, font = 'Roboto' } )

    /*
    *   footer
    */

        _f( pref( 'footer_pl_name' ),               { size = 24, weight = 200, antialias = true, font = 'Roboto Condensed' } )
        _f( pref( 'footer_pl_group' ),              { size = 17, weight = 100, antialias = true, font = 'Roboto Condensed' } )

    /*
    *   concommand > reload
    */

        if helper.ok.ply( pl ) or base.con:Is( pl ) then
            base:log( 4, '[ %s ] reloaded fonts', mod.name )
            if not base.con.Is( pl ) then
                base.msg:target( pl, mod.name, 'reloaded fonts' )
            end
        end

end
rhook.new.rlib( 'liko_fonts_register', fonts_register )
rcc.new.rlib( 'liko_fonts_reload', fonts_register )

/*
*   fonts > rnet > reload
*/

local function fonts_rnet_reload( data )
    fonts_register( LocalPlayer( ) )
end
rnet.call( 'liko_fonts_reload', fonts_rnet_reload )