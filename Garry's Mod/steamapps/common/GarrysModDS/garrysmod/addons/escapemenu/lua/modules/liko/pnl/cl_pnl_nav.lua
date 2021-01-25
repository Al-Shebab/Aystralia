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
    :setup                          (                                       )

    /*
    *   navmenu
    */

    local i = 0
    for v in helper.get.data( cfg.nav.list ) do
        if not v.enabled then continue end

        if v.bSpacer then
            local scale_tall        = ui:SmartScaleH( false, 0, 5, 20, 55, 65, 90, 80, 80 )

            local spacer            = ui.new( 'pnl', self, 1                )
            :top                    ( 'm', 0                                )
            :tall                   ( scale_tall                            )

            continue
        end

        local b_mat                             = false
        local bTextOnly                         = cfg.nav.general.btn_use_textonly or false
        local mat_grad                          = mat( 'pattern_hdiag' )

        local clr_text, clr_text_h              = v.clrs and v.clrs.text or cfg.nav.general.clrs.text, v.clrs and v.clrs.text_hover or cfg.nav.general.clrs.text_hover
        local clr_textsub, clr_textsub_h        = v.clrs and v.clrs.textsub or cfg.nav.general.clrs.textsub, v.clrs and v.clrs.textsub_hover or cfg.nav.general.clrs.textsub_hover
        local clr_icon, clr_icon_h              = v.clrs and v.clrs.icon or cfg.nav.general.clrs.icon, v.clrs and v.clrs.icon_hover or cfg.nav.general.clrs.icon_hover
        local clr_lines                         = v.clrs and v.clrs.box_lines or cfg.nav.general.clrs.box_lines
        local clr_lines_corner                  = v.clrs and v.clrs.box_lines_corner or cfg.nav.general.clrs.box_lines_corner
        local clr_box                           = v.clrs and v.clrs.box or cfg.nav.general.clrs.box
        local clr_box_ico, clr_box_ico_h        = cfg.nav.general.clrs.box_icon, cfg.nav.general.clrs.box_icon_hover
        local pattern_enabled, clr_pattern      = cfg.nav.general.btn_pattern_enabled, v.clrs and v.clrs.pattern or cfg.nav.general.clrs.pattern
        local sz_min, sz_h, sz_ico              = cfg.nav.general.btn_sz_w, cfg.nav.general.btn_sz_h, 26
        local sz_lpnl                           = 60

        local b_item                = ui.new( 'btn', self                   )
        :top                        ( 'm', 0, 0, 0, 3                       )
        :size                       ( sz_min - 32, sz_h                     )
        :notext                     (                                       )
        :onhover                    (                                       )
        :setupanim                  ( 'OnHoverFade', 4, rlib.i.OnHover      )

                                    :oc( function( s )
                                        if v.action then v.action( ) end
                                    end )

                                    :draw( function( s, w, h )
                                        local clr_text_n        = ( s.hover and clr_text_h ) or clr_text
                                        local clr_textsub_n     = ( s.hover and clr_textsub_h ) or clr_textsub
                                        local clr_icon_n        = ( s.hover and clr_icon_h ) or clr_icon

                                        if not bTextOnly then
                                            design.box( 0, 0, sz_lpnl, h, clr_box )
                                            if pattern_enabled then
                                                design.mat( -sz_lpnl, 0, sz_lpnl * 2.6, h, mat_grad, clr_pattern )
                                            end

                                            design.box( sz_lpnl, 0, w, h, clr_box )
                                            design.box( 0, 0, sz_lpnl, h, clr_box_ico )
                                            design.box( sz_lpnl, 1, 1, h - 2, clr_lines )

                                            if s.hover then
                                                design.box( 0, 0, sz_lpnl, h, clr_box_ico_h )
                                            end
                                        end

                                        /*
                                        *	hover > fade
                                        */

                                        if s.hover then
                                            self:HoverFade( s, w, h, Color( 0, 0, 0, 140 ) )
                                        end

                                        /*
                                        *	enabled corners
                                        */

                                        if cfg.nav.general.btn_lines_corner_enabled then
                                            -- top left
                                            surface.SetDrawColor    ( clr_lines_corner )
                                            surface.DrawLine        ( 0, 15, 0, 0 )
                                            surface.DrawLine        ( 15, 0, 0, 0 )

                                            -- top right
                                            surface.SetDrawColor    ( clr_lines_corner )
                                            surface.DrawLine        ( sz_lpnl, 0, sz_lpnl, 15 )
                                            surface.DrawLine        ( sz_lpnl, 0, sz_lpnl - 15, 0 )

                                            -- bottom left
                                            surface.SetDrawColor    ( clr_lines_corner )
                                            surface.DrawLine        ( 15, sz_h - 1, 0, sz_h - 1 )
                                            surface.DrawLine        ( 0, sz_h, 0, sz_h - 15 )

                                            -- bottom right
                                            surface.SetDrawColor    ( clr_lines_corner )
                                            surface.DrawLine        ( sz_lpnl, sz_h - 1, sz_lpnl - 15, sz_h - 1 )
                                            surface.DrawLine        ( sz_lpnl, sz_h - 15, sz_lpnl, sz_h )
                                        end

                                        local btn_name          = v.name and ln( v.name ) or ( not btn_name or btn_name == '' and ln( 'sys_btn_noname' ) )
                                        btn_name                = helper.str:truncate( btn_name, isnumber( v.truncate_len_name ) and v.truncate_len_name or cfg.nav.general.truncate_len_name ) or ln( 'sys_btn_noname' )

                                        local btn_desc          = v.desc and ln( v.desc ) or ( not btn_desc or btn_desc == '' and ln( 'sys_btn_noname' ) )
                                        btn_desc                = helper.str:truncate( btn_desc, isnumber( v.truncate_len_desc ) and v.truncate_len_desc or cfg.nav.general.truncate_len_desc ) or ln( 'sys_btn_noname' )

                                        local i_pos             = ( not bTextOnly and ( sz_lpnl + 10 ) ) or 15
                                        local i_rotate          = ( cfg.general.anim_rotate_enabled and ( s.hover and ( CurTime( ) % 360 * cfg.general.anim_rotate_speed ) ) ) or 0
                                        if not bTextOnly and v.icon then
                                            design.mat_r( sz_lpnl / 2, 14 + ( sz_h / 2 ) - ( sz_ico / 2 ), sz_ico, sz_ico, i_rotate, b_mat, clr_icon_n )
                                        end

                                        local pos_title, font_title = .33, pref( 'nav_item_title' )
                                        if cfg.nav.general.btn_hide_desc then
                                            pos_title, font_title   = .50, pref( 'nav_item_title_lg' )
                                        end

                                        draw.SimpleText( btn_name:upper( ), font_title, i_pos, s:GetTall( ) * pos_title, clr_text_n, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

                                        if not cfg.nav.general.btn_hide_desc then
                                            draw.SimpleText( btn_desc:upper( ), pref( 'nav_item_desc' ), i_pos, s:GetTall( ) * .71, clr_textsub_n, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                                        end
                                    end )

                                    :logic( function( s )

                                        /*
                                        *	sfx > open
                                        */

                                        if s.hover then
                                            if not s.bSndHover and cfg.general.sounds_enabled then
                                                local snd       = CreateSound( LocalPlayer( ), resources( 'snd', 'mouseover_02' ) )
                                                snd:PlayEx      ( 0.1, 100 )
                                                s.bSndHover     = true
                                            end
                                        else
                                            s.bSndHover     = false
                                        end

                                    end )

        if ( v.icon and not bTextOnly ) then
            b_mat = mat( v.icon )
            b_item:SetSize( b_item:GetWide( ) + 32, b_item:GetTall( ) )
        end

        i = i + sz_h + 2
    end

end

/*
*   HoverFade
*
*   animation for fading effect
*
*   @param  : pnl s
*   @param  : int w
*   @param  : int h
*   @param  : clr clr
*/

function PANEL:HoverFade( s, w, h, clr )
    local da = ColorAlpha( clr, clr.a * s.OnHoverFade )
    design.box( 0, 0, w, h, da )
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
*	_Call
*/

function PANEL:_Call( )
    mod.breadcrumb:Set( true )
end

/*
*   assign
*/

ui:create( mod, 'nav', PANEL, 'pnl' )