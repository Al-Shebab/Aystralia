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
*   Localized res func
*/

local function resources( t, ... )
    return base:resource( mod, t, ... )
end

/*
*	localized mat func
*/

local function mat( id )
    return mats:call( mod, id )
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
*   Init
*/

function PANEL:Init( )

    /*
    *   parent
    */

    self                            = ui.get( self                          )
    :onload                         (                                       )
    :fill                           (                                       )
    :tall                           ( 50                                    )

    /*
    *   sub
    */

    self.sub                        = ui.new( 'pnl', self, 1                )
    :fill                           ( 'm', 0                                )

    /*
    *   btn > exit
    */

    self.b_exit                     = ui.new( 'btn', self.sub               )
    :bsetup                         (                                       )
    :right                          ( 'm', 2, 0, 0, 0                       )
    :tooltip                        ( ln( 'tooltip_close_window' )          )
    :size                           ( self.sz_ico                           )

                                    :draw( function( s, w, h )
                                        local clr_btn           = self.cf_g.clrs.btn_exit
                                        if s.hover then
                                            local calc_pulse    = math.abs( math.sin( CurTime( ) * 4 ) * 255 )
                                            calc_pulse          = math.Clamp( calc_pulse, 150, 255 )
                                            clr_btn             = Color( calc_pulse, calc_pulse, calc_pulse, calc_pulse )
                                        end

                                        local i_rotate          = ( self.cf_g.anim_rotate_enabled and ( s.hover and ( CurTime( ) % 360 * self.cf_g.anim_rotate_speed ) ) ) or 0
                                        design.mat_r( ( w / 2 ), ( h / 2 ), self.sz_ico - 2, self.sz_ico - 2, i_rotate, self.m_close, clr_btn )
                                    end )

                                    :oc( function( s )
                                        mod.ui:Hide( )
                                    end )

    /*
    *   btn > origmenu
    */

    self.b_gmenu                    = ui.new( 'btn', self.sub               )
    :bsetup                         (                                       )
    :right                          ( 'm', 2, 0, 0, 0                       )
    :tooltip                        ( ln( 'tooltip_origmenu_window' )       )
    :size                           ( self.sz_ico                           )

                                    :draw( function( s, w, h )
                                        local clr_btn           = self.cf_g.clrs.btn_origmenu
                                        if s.hover then
                                            local calc_pulse    = math.abs( math.sin( CurTime( ) * 4 ) * 255 )
                                            calc_pulse          = math.Clamp( calc_pulse, 150, 244 )
                                            clr_btn             = Color( calc_pulse, calc_pulse, calc_pulse, calc_pulse )
                                        end

                                        local i_rotate          = ( self.cf_g.anim_rotate_enabled and ( s.hover and ( CurTime( ) % 360 * self.cf_g.anim_rotate_speed ) ) ) or 0
                                        design.mat_r( ( w / 2 ), ( h / 2 ), self.sz_ico, self.sz_ico, i_rotate, self.m_gmenu, clr_btn )
                                    end )

                                    :oc( function( s )
                                        mod.ui:Hide( )
                                        gui.ActivateGameUI( )
                                    end )

                                    :logic( function( s )

                                        /*
                                        *	sfx > open
                                        */

                                        if s.hover then
                                            if not s.bSndHover and self.cf_g.sounds_enabled then
                                                local snd       = CreateSound( LocalPlayer( ), resources( 'snd', 'mouseover_01' ) )
                                                snd:PlayEx      ( 0.1, 100 )
                                                s.bSndHover     = true
                                            end
                                        else
                                            s.bSndHover     = false
                                        end

                                    end )

    /*
    *   btn > console
    */

    self.b_console                  = ui.new( 'btn', self.sub               )
    :bsetup                         (                                       )
    :right                          ( 'm', 0, 0, 0, 0                       )
    :tooltip                        ( ln( 'tooltip_console_window' )        )
    :size                           ( self.sz_ico                           )

                                    :draw( function( s, w, h )
                                        local clr_btn           = self.cf_g.clrs.btn_console
                                        if s.hover then
                                            local calc_pulse    = math.abs( math.sin( CurTime( ) * 4 ) * 255 )
                                            calc_pulse          = math.Clamp( calc_pulse, 150, 244 )
                                            clr_btn             = Color( calc_pulse, calc_pulse, calc_pulse, calc_pulse )
                                        end

                                        local i_rotate          = ( self.cf_g.anim_rotate_enabled and ( s.hover and ( CurTime( ) % 360 * self.cf_g.anim_rotate_speed ) ) ) or 0
                                        design.mat_r( ( w / 2 ), ( h / 2 ), self.sz_ico, self.sz_ico, i_rotate, self.m_console, clr_btn )
                                    end )

                                    :logic( function( s )

                                        /*
                                        *	sfx > open
                                        */

                                        if s.hover then
                                            if not s.bSndHover and self.cf_g.sounds_enabled then
                                                local snd       = CreateSound( LocalPlayer( ), resources( 'snd', 'mouseover_01' ) )
                                                snd:PlayEx      ( 0.1, 100 )
                                                s.bSndHover     = true
                                            end
                                        else
                                            s.bSndHover     = false
                                        end

                                    end )

                                    :oc( function( s )
                                        rcc.run.gmod( 'showconsole' )
                                        timex.simple( 0, function( ) rcc.run.gmod( 'gameui_activate' ) end )
                                    end )

end

/*
*   Think
*/

function PANEL:Think( )
    if not self.cf_h.enabled then
        self:Destroy( )
        return
    end

    if not self.cf_h.qmenu_enabled and ui:visible( self.b_gmenu ) then
        ui:unstage( self.b_gmenu )
        ui:unstage( self.b_console )
    elseif self.cf_h.qmenu_enabled and not ui:visible( self.b_gmenu ) then
        ui:stage( self.b_gmenu )
        ui:stage( self.b_console )
    end
end

/*
*   Paint
*
*   @param  : int w
*   @param  : int h
*/

function PANEL:Paint( w, h ) end

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
    self.cf_n                       = cfg.nav
    self.cf_h                       = cfg.header

    /*
    *   declare > mats
    */

    self.m_close                    = mat( 'btn_close_2' )
    self.m_console                  = mat( 'btn_console_2' )
    self.m_gmenu                    = mat( 'btn_gmod_menu_1' )

    /*
    *   declare > misc
    */

    self.sz_ico                     = self.cf_n.general.header_sz_ico

end

/*
*   assign
*/

ui:create( mod, 'header', PANEL, 'pnl' )