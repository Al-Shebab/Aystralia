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
local design                = base.d
local ui                    = base.i
local mats                  = base.m
local cvar                  = base.v

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
*   panel
*/

local PANEL = { }

/*
*   initialize
*/

function PANEL:Init( )

    /*
    *   parent
    */

    self                            = ui.get( self                          )
    :onload                         (                                       )
    :sz                             ( self.sz_box_w, self.sz_box_h          )
    :pos                            ( ( ScrW( ) / 2 ) - ( self.sz_box_w / 2 ), ui:SmartScaleH( false, cfg.general.margin_top ) )

end

/*
*   Paint
*
*   @param  : int w
*   @param  : int h
*/

function PANEL:Paint( w, h )
    if not ( cfg.announcements.enabled and cfg.slider.enabled ) then return end

    local clr_r     = math.abs( math.sin( CurTime( ) * 4 ) * 255 )
    clr_r           = math.Clamp( clr_r, 100, 200 )

    design.rbox( 4, 0, 0, w, h, Color( clr_r, 40, 40, 255 ) )
    design.rbox( 4, 2, 2, w - 4, h - 4, self.clr_box )

    draw.SimpleText( utf8.char( 10731 ), pref( 'g_confl_icon' ), 10, h / 2 - 7, self.clr_ico, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    draw.SimpleText( self.t, pref( 'g_confl_title' ), self.sz_box_os, h / 2 - 7, self.clr_ico, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    draw.SimpleText( self.m, pref( 'g_confl_msg' ), self.sz_box_os, h / 2 + 8, self.clr_txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
end

/*
*   Destroy
*/

function PANEL:Destroy( )
    ui:destroy( self, true, true )
end

/*
*   _Declare
*/

function PANEL:_Declare( )

    /*
    *   declare > configs
    */

    self.cf_g                       = cfg.general

    /*
    *   declare > sizes
    */

    self.t, self.m                  = ln( 'sys_ann_sl_confl_title' ):upper( ), ln( 'sys_ann_sl_confl_msg' )
    self.sz_t_w, self.sz_t_h        = helper.str:len( self.t, pref( 'g_confl_title' ) )
    self.sz_m_w, self.sz_m_h        = helper.str:len( self.m, pref( 'g_confl_msg' ) )
    self.sz_w                       = self.sz_m_w > self.sz_t_w and self.sz_m_w or self.sz_t_w
    self.sz_box_os                  = cfg.header.height
    self.sz_box_w, self.sz_box_h    = self.sz_w + self.sz_box_os + 40, cfg.header.height

    /*
    *   declare > colors
    */

    self.clr_txt                    = self.cf_g.clrs.confl_n_txt
    self.clr_ico                    = self.cf_g.clrs.confl_n_ico
    self.clr_box                    = self.cf_g.clrs.confg_n_box

end

/*
*   assign
*/

ui:create( mod, 'confl', PANEL, 'pnl' )