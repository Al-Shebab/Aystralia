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
*   Localized call func
*
*   @source : lua\autorun\libs\_calls
*   @param  : str t
*   @param  : varg { ... }
*/

local function call( t, ... )
    return base:call( t, ... )
end

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
*   accessorfunc
*/

AccessorFunc( PANEL, 'm_bDraggable', 'Draggable',   FORCE_BOOL )
AccessorFunc( PANEL, 'itemName',     'MenuItem',    FORCE_STRING )

/*
*   initialize
*/

function PANEL:Init( )

    /*
    *   parent pnl
    */

    self                            = ui.get( self                          )
    :setup                          (                                       )
    :padding                        ( 2, 34, 2, 3                           )
    :shadow                         ( true                                  )
    :sz                             ( self.ui_w, self.ui_h                  )
    :wmin                           ( self.ui_w * 0.85                      )
    :hmin                           ( self.ui_h * 0.85                      )
    :popup                          (                                       )
    :notitle                        (                                       )
    :canresize                      ( false                                 )
    :showclose                      ( false                                 )
    :scrlock                        ( true                                  )

    /*
    *   display parent
    */

    ui.anim_fadein                  ( self, 0.2, 0                          )

    /*
    *   titlebar
    *
    *   to overwrite existing properties from the skin; do not change this
    *   labels name to anything other than lblTitle otherwise it wont
    *   inherit position/size properties
    */

    self.lblTitle                   = ui.new( 'lbl', self                   )
    :notext                         (                                       )
    :font                           ( pref( 'ibws_diag_hdr_title' )         )
    :clr                            ( self.cf_d.clrs.header_txt             )

                                    :draw( function( s, w, h )
                                        draw.SimpleText( helper.get:utf8( 'title' ), pref( 'ibws_diag_hdr_icon' ), 0, 8, self.cf_d.clrs.header_ico, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                                        draw.SimpleText( self:GetTitle( ), pref( 'ibws_diag_hdr_title' ), 25, h / 2, self.cf_d.clrs.header_txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                                    end )

    /*
    *   close button
    *
    *   to overwrite existing properties from the skin; do not change this
    *   buttons name to anything other than btnClose otherwise it wont
    *   inherit position/size properties
    */

    self.btnClose                   = ui.new( 'btn', self                   )
    :bsetup                         (                                       )
    :notext                         (                                       )
    :tooltip                        ( ln( 'tt_close_window' )               )
    :ocfo                           ( self, 0.2                             )

                                    :draw( function( s, w, h )
                                        local clr_txt = s.hover and self.cf_d.clrs.btn_exit_h or self.cf_d.clrs.btn_exit_n
                                        draw.SimpleText( helper.get:utf8( 'close' ), pref( 'ibws_diag_hdr_exit' ), w / 2 - 5, h / 2 + 4, clr_txt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                    end )

    /*
    *   pnl > sub
    */

    self.p_sub                      = ui.new( 'pnl', self, 1                )
    :fill                           ( 'm', 0, 10, 0                         )

    /*
    *   pnl > body
    */

    self.p_body                     = ui.new( 'pnl', self.p_sub, 1          )
    :fill                           ( 'm', 15, 0, 15, 0                     )

    /*
    *   pnl > bottom (footer)
    */

    self.p_btm                      = ui.new( 'pnl', self.p_sub, 1          )
    :bottom                         ( 'm', 10, 0, 10, 0                     )
    :tall                           ( 4                                     )

    /*
    *   dtxt > desc
    */

    local diag_desc                 = access:bIsRoot( LocalPlayer( ) ) and ln( 'ibws_diag_desc_admin' ) or ln( 'ibws_diag_desc_user' )
    local dt_default                = access:bIsRoot( LocalPlayer( ) ) and ln( 'ibws_diag_srcstr_admin', self:GetMenuItem( ) ) or ln(  'ibws_diag_srcstr_user' )

    self.dt_desc                    = ui.new( 'dt', self.p_body             )
    :fill                           ( 'p', 3                                )
    :tall                           ( 90                                    )
    :drawbg                         ( false                                 )
    :mline                          ( true                                  )
    :lbllock                        (                                       )
    :font                           ( pref( 'ibws_diag_desc' )              )
    :txt                            ( diag_desc                             )
    :drawentry                      ( self.cf_d.clrs.txt_default, self.cf_d.clrs.cur_default, self.cf_d.clrs.hli_default )

    /*
    *   pnl > btn > sub
    */

    self.p_btn_sub                  = ui.new( 'pnl', self.p_body            )
    :bottom                         ( 'p', 30, 3                            )
    :tall                           ( 32                                    )

                                    :draw( function( s, w, h )
                                        design.rbox( 6, 0, 0, w, h, self.cf_d.clrs.footer_box )
                                        draw.SimpleText( helper.get:utf8( 'dtxt' ), pref( 'cwserv_info_icon' ), 4, 15, self.cf_d.clrs.ico_bullet, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                                    end )

    /*
    *   pnl > btn > sub > spacer
    */

    self.p_btn_sub_sp               = ui.new( 'pnl', self.p_btn_sub, 1      )
    :right                          ( 'm', 0                                )
    :sz                             ( 100, 18                               )

    /*
    *   dtxt > server ip/port
    */

    self.dt_file                    = ui.new( 'dt', self.p_btn_sub          )
    :fill                           ( 'p', 0                                )
    :drawbg                         ( false                                 )
    :mline                          ( false                                 )
    :lbllock                        (                                       )
    :txt                            ( dt_default, self.cf_d.clrs.txt_default, pref( 'ibws_diag_txt_ack' ) )

    /*
    *   btn > connect confirm
    */

    self.b_conn_yes                 = ui.new( 'btn', self.p_btn_sub_sp      )
    :bsetup                         (                                       )
    :right                          ( 'm', 0, 0, 5, 0                       )
    :notext                         (                                       )
    :wide                           ( 28                                    )
    :tip                            ( ln( 'ibws_diag_ok_tip' )              )

                                    :draw( function( s, w, h )
                                        local clr_a     = math.abs( math.sin( CurTime( ) * 4 ) * 255 )
                                        clr_a	        = math.Clamp( clr_a, 100, 255 )

                                        local clr_box   = ColorAlpha( self.cf_d.clrs.opt_ok_btn_n, clr_a )

                                        design.rbox( 6, 0, 0, w, h, clr_box )

                                        if s.hover then
                                            design.rbox( 6, 0, 0, w, h, self.cf_d.clrs.opt_ok_btn_h )
                                        end

                                        draw.SimpleText( helper.get:utf8( 'check' ), pref( 'ibws_diag_btn_ack' ), w / 2, h / 2, self.cf_d.clrs.opt_ok_txt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                    end )

                                    :oc( function( s )
                                        ui:dispatch( self )
                                    end )

    /*
    *   load helper
    */

    timex.simple( 0.1, function( )
        local diag_src          = access:bIsRoot( LocalPlayer( ) ) and ln( 'ibws_diag_srcstr_admin', self:GetMenuItem( ) ) or ln(  'ibws_diag_srcstr_user' )
        self.dt_file:SetText    ( diag_src )
    end )

end

/*
*   Think
*/

function PANEL:Think( )
    self.BaseClass.Think( self )

    self:MoveToFront( )

    local mousex        = math.Clamp( gui.MouseX( ), 1, ScrW( ) - 1 )
    local mousey        = math.Clamp( gui.MouseY( ), 1, ScrH( ) - 1 )

    if self.Dragging then
        local x         = mousex - self.Dragging[ 1 ]
        local y         = mousey - self.Dragging[ 2 ]

        if self:GetScreenLock( ) then
            x           = math.Clamp( x, 0, ScrW( ) - self:GetWide( ) )
            y           = math.Clamp( y, 0, ScrH( ) - self:GetTall( ) )
        end

        self:SetPos     ( x, y )
    end

    if self.Sizing then
        local x         = mousex - self.Sizing[ 1 ]
        local y         = mousey - self.Sizing[ 2 ]
        local px, py    = self:GetPos( )

        if ( x < self.m_iMinWidth ) then x = self.m_iMinWidth elseif ( x > ScrW( ) - px and self:GetScreenLock( ) ) then x = ScrW( ) - px end
        if ( y < self.m_iMinHeight ) then y = self.m_iMinHeight elseif ( y > ScrH( ) - py and self:GetScreenLock( ) ) then y = ScrH( ) - py end

        self:SetSize    ( x, y )
        self:SetCursor  ( 'sizenwse' )
        return
    end

    if ( self.Hovered and self.m_bSizable and mousex > ( self.x + self:GetWide( ) - 20 ) and mousey > ( self.y + self:GetTall( ) - 20 ) ) then
        self:SetCursor  ( 'sizenwse' )
        return
    end

    if ( self.Hovered and self:GetDraggable( ) and mousey < ( self.y + 24 ) ) then
        self:SetCursor  ( 'sizeall' )
        return
    end

    self:SetCursor( 'arrow' )

    if self.y < 0 then self:SetPos( self.x, 0 ) end

end

/*
*   OnMousePressed
*/

function PANEL:OnMousePressed( )
    if ( self.m_bSizable and gui.MouseX( ) > ( self.x + self:GetWide( ) - 20 ) and gui.MouseY( ) > ( self.y + self:GetTall( ) - 20 ) ) then
        self.Sizing =
        {
            gui.MouseX( ) - self:GetWide( ),
            gui.MouseY( ) - self:GetTall( )
        }
        self:MouseCapture( true )
        return
    end

    if ( self:GetDraggable( ) and gui.MouseY( ) < ( self.y + 24 ) ) then
        self.Dragging =
        {
            gui.MouseX( ) - self.x,
            gui.MouseY( ) - self.y
        }
        self:MouseCapture( true )
        return
    end
end

/*
*   OnMouseReleased
*/

function PANEL:OnMouseReleased( )
    self.Dragging   = nil
    self.Sizing     = nil
    self:MouseCapture( false )
end

/*
*   PerformLayout
*/

function PANEL:PerformLayout( )
    local titlePush = 0
    self.BaseClass.PerformLayout( self )

    self.lblTitle:SetPos( 11 + titlePush, 7 )
    self.lblTitle:SetSize( self:GetWide( ) - 25 - titlePush, 20 )
end

/*
*   Paint
*/

function PANEL:Paint( w, h )
    design.rbox( 4, 0, 0, w, h, self.cf_d.clrs.body_box )
    design.rbox_adv( 4, 2, 2, w - 4, 34 - 4, self.cf_d.clrs.header_box, true, true, false, false )
end

/*
*   ActionShow
*/

function PANEL:ActionShow( )
    self:SetMouseInputEnabled( true )
    self:SetKeyboardInputEnabled( true )
end

/*
*   GetTitle
*
*   @return : str
*/

function PANEL:GetTitle( )
    return ln( 'ibws_title' )
end

/*
*   SetTitle
*
*   @param  : str title
*/

function PANEL:SetTitle( title )
    self.lblTitle:SetText( '' )
    self.ui_title = title
end

/*
*   Destroy
*/

function PANEL:Destroy( )
    ui:destroy( self, true, true )
end

/*
*   SetVisible
*
*   @param  : bool bVisible
*/

function PANEL:SetVisible( b )
    if b then
        ui:show( self, true )
    else
        ui:hide( self, true )
    end
end

/*
*   _Declare
*/

function PANEL:_Declare( )

    /*
    *   declare > configs
    */

    self.cf_d                       = cfg.dialogs

    /*
    *   declare > sizing
    */

    self.ui_w, self.ui_h            = 420, 190

end

/*
*   create
*/

ui:create( mod, 'diag_ibws_notice', PANEL )