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

    /*
    *   pnl > left > col
    */

    self.p_left_col_1               = ui.new( 'pnl', self, 1                )
    :fill                           ( 'm', 0                                )

    /*
    *   pnl > servers
    */

    self.p_servers                  = ui.rlib( mod, 'servers', self.p_left_col_1, 1 )
    :fill                           ( 'm', 0                                )
    :register                       ( 'pnl_servers', mod                    )

    /*
    *   pnl > ply count
    */

    self.p_cnt_online               = ui.new( 'pnl', self                   )
    :right                          ( 'm', 0, 2, 0, 2                       )
    :size                           ( self.cp_sizex + 3                     )

                                    :draw( function( s, w, h )
                                        design.rbox( 0, 0, 0, w, h, self.cf_h.clrs.online_box )
                                        draw.DrawText( ln( 'online_title' ), pref( 'pl_online_text' ), w / 2, 6, self.cf_h.clrs.online_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                        draw.DrawText( self.i_pl, pref( 'pl_online_data' ), w / 2, 20, self.cf_h.clrs.online_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                    end )

    /*
    *   pnl > col > right
    */

    self.p_left_col_r               = ui.new( 'pnl', self, 1                )
    :right                          ( 'm', 0, 2, 0, 2                       )
    :wide                           ( self.sn_sizex                         )

    /*
    *   pnl > server name
    */

    self.p_srv_name                 = ui.new( 'pnl', self.p_left_col_r      )
    :fill                           ( 'm', 0                                )
    :wide                           ( self.sn_sizex                         )

                                    :draw( function( s, w, h )
                                        draw.DrawText( self.cf_g.network_name:upper( ), pref( 'g_section_title' ), s:GetWide( ) - 10, 7, self.cf_h.clrs.servname_text, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
                                    end )

end

/*
*   Paint
*
*   @param  : int w
*   @param  : int h
*/

function PANEL:Paint( w, h )
    design.box( 0, 0, w, h, self.clr_box )
    design.box( 0, 0, w, 2, self.clr_bar )
    design.box( 0, h - 2, w, 2, self.clr_bar )
end

/*
*   Think
*/

function PANEL:Think( )
    if not cfg.footer.enabled then
        self:Destroy( )
    end
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
    self.cf_h                       = cfg.header
    self.cf_f                       = cfg.footer

    /*
    *   declare > demo mode
    */

    self.bDemoMode                  = rcore:bInDemoMode( mod ) or false

    /*
    *   declare > misc
    */

    self.sn_sizex                   = helper.str:len( self.cf_g.network_name:upper( ), pref( 'g_section_title' ), 20 )
    self.i_pl                       = ( not self.bDemoMode and player.GetCount( ) ) or cfg.dev.demo.online
    self.cp_sizex                   = 50

    /*
    *   declare > colors
    */

    self.clr_box                    = self.cf_f.clrs.box
    self.clr_bar                    = self.cf_f.clrs.bar

end

/*
*   assign
*/

ui:create( mod, 'footer', PANEL, 'pnl' )