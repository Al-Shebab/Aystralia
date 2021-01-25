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
*   ipe
*
*   init entity post
*/

local function ipe( )
    rhook.run.rlib( 'liko_fonts_register' )
end
rhook.new.gmod( 'InitPostEntity', 'liko_ipe_cl', ipe )

/*
*   Initialize
*/

function mod.ui:Initialize( )

    /*
    *   localize / validate ply
    */

    local pl = LocalPlayer( )
    if not helper.ok.ply( pl ) then return end

    /*
    *   font hook
    */

    rhook.run.rlib( 'liko_fonts_register' )

    /*
    *   root
    */

    mod.pnl.root                    = ui.new( 'pnl'                         )
    :nodraw                         (                                       )
    :size                           ( 'screen'                              )
    :popup                          (                                       )

    /*
    *   bg
    */

    local bg                        = ui.rlib( mod, 'bg', mod.pnl.root      )
    :fill                           ( 'm', 0                                )

    /*
    *   svg
    */

    local svg                       = ui.new( 'rlib.lo.svg', bg             )

    /*
    *   content
    */

    local sub                       = ui.new( 'pnl', bg, 1                  )
    :fill                           ( 'm', 0                                )

    /*
    *   header
    */

    local header                    = ui.rlib( mod, 'header', sub           )
    :top                            ( 'm', 0, 20, 55, 0                     )

    /*
    *   calc > nav menu contents
    *
    *   :   spacers that exist
    *   :   enabled nav items
    */

    local sz_h                      = mod.ui:GetNavTall( )
    local marg_t                    = ui:SmartScaleH( false, cfg.general.margin_top )

    /*
    *   nav menu
    */

    local nav                       = ui.rlib( mod, 'nav', sub              )
    :pos                            ( cfg.general.margin_left, marg_t       )
    :wide                           ( cfg.nav.general.btn_sz_w              )
    :tall                           ( sz_h                                  )
    :register                       ( 'pnl_navmenu', mod                    )

    /*
    *   slider
    */

    local sl_pad                    = cfg.slider.rounded_bg and cfg.slider.rounded_bg_amt or 0
    local slider                    = ui.rlib( mod, 'news', sub             )
    :padding                        ( sl_pad                                )
    :register                       ( 'pnl_slider', mod                     )

    /*
    *   declarations > announcements
    */

    local sz_calc_ann_w             = ui:cscale( false, 160, 160, 160, 160, 160, 160, 160 )
    local sz_calc_ann_h             = ui:cscale( false, 215, 215, 215, 215, 215, 215, 215 )

    /*
    *   pnl > announcements
    */

    local ct_ann                    = ui.rlib( mod, 'announce', sub         )
    :size                           ( sz_calc_ann_w, sz_calc_ann_h          )
    :pos                            ( ScrW( ) - sz_calc_ann_w - cfg.general.margin_left, ui:SmartScaleH( false, cfg.general.margin_top ) )
    :param                          ( 'SetOpacity', 255                     )
    :header                         ( ln( 'sec_announcements' )             )
    :hide                           (                                       )

    /*
    *   pnl > conflict notice
    */

    local ct_confl                  = ui.rlib( mod, 'confl', sub            )
    :hide                           (                                       )

    /*
    *   count > available servers
    */

    local i = 0
    for v in helper.get.data( cfg.servers.list ) do
        if not v.enabled then continue end
        i = i + 1
    end

    /*
    *   footer
    */

    local footer                    = ui.rlib( mod, 'footer', sub           )
    :bottom                         ( 'm', 0                                )
    :tall                           ( cfg.footer.height                     )
    :register                       ( 'pnl_footer', mod                     )

    /*
    *   ticker
    */

    local ticker                    = ui.rlib( mod, 'ticker', sub           )
    :bottom                         ( 'm', 0                                )
    :tall                           ( cfg.ticker.height                     )
    :register                       ( 'pnl_ticker', mod                     )

    /*
    *   slider setup
    */

    if cfg.slider.enabled and cfg.slider.host then
        local host                  = cfg.slider.host_define
        local bHasModule            = base.modules:bInstalled( host )
        if bHasModule then
            local cfg_mod           = base.modules:cfg( host )
            mod.settings.slider     = cfg_mod.slider
        end
    end

    /*
    *   count slides enabled
    */

    local slider_src    = ( cfg.slider.enabled and ( not cfg.slider.host and cfg.slider.list ) or ( cfg.slider.host and mod.settings.slider.list ) ) or { }
    local i_cnt         = 0
    for v in helper.get.data( slider_src ) do
        if not v.enabled then continue end
        i_cnt = i_cnt + 1
    end

    /*
    *   think
    */

    local function th_ui( )
        /*
        *   state > ticker
        */

        if not cfg.ticker.enabled then
            ui:unstage( ticker )
        end

        /*
        *   state > conflict interface
        */

        if ( cfg.announcements.enabled and cfg.slider.enabled ) and not ui:visible( p_conf ) then
            ui:stage( ct_confl )
        else
            ui:hide_visible( ct_confl )
        end

        /*
        *   state > slider
        */

        if ( not cfg.slider.enabled or i_cnt == 0 ) and ui:visible( slider ) then
            ui:unstage( slider )
        elseif cfg.slider.enabled and i_cnt > 0 and not ui:visible( slider ) and not slider.bStaged then
            ui:stage( slider )
        end

        /*
        *   state > announcements
        */

        if not cfg.slider.enabled then
            if cfg.announcements.enabled and not ui:visible( ct_ann ) then
                ui:stage( ct_ann )
            elseif not cfg.announcements.enabled and ui:visible( ct_ann ) then
                ui:unstage( ct_ann )
            elseif ( cfg.slider.enabled and cfg.announcements.enabled ) and ui:visible( ct_ann ) then
                ui:unstage( ct_ann )
            end
        end
    end
    rhook.new.gmod( 'Think', 'liko_th_ui', th_ui )

end

/*
*   ui > get nav size
*
*   returns various size portions to the nav menu
*
*   @param  : void
*   @return : ret
*/

function mod.ui:GetNavSize( )

    local i_mnu, i_spacer, i_tall = 0, 0, 0
    for v in helper.get.data( cfg.nav.list ) do
        if not v.enabled then continue end

        if v.bSpacer then
            i_spacer = i_spacer + 1
        end

        if v.tall then
            i_tall = i_tall + v.tall
        end

        i_mnu = i_mnu + 1
    end

    return i_mnu, i_spacer, i_tall

end

/*
*   ui > get nav tall
*
*   returns total height of nav menu
*
*   @param  : void
*   @return : int, int, int
*/

function mod.ui:GetNavTall( )
    local i_mnu, i_sp, i_tall   = self:GetNavSize( )
    local scale_tall            = ui:cscale( false, 25, 70, 100, 65, 65, 80, 80 )
    local sz_h                  = ( i_mnu * cfg.nav.general.btn_sz_h ) + scale_tall

    return sz_h
end

/*
*   ui > registered > toggle
*
*   toggles a pnl to set visibility and perform various other tasks
*
*   @param  : pnl pnl
*   @param  : bool b
*   @param  : bool ret
*   @param  : bool bBread
*   @param  : bool breadcrumb
*   @return : bool ret
*/

function mod.ui:ToggleRegistered( pnl, b, ret, bBread, breadcrumb )
    if not pnl then return end

    local pnl_target    = ui:call( pnl, mod )
                        if not ui:ok( pnl_target ) then return end

    if b then
        ui:stage( pnl_target )
        pnl_target.bStaged = true
    else
        ui:unstage( pnl_target )
    end

    if bBread then
        mod.breadcrumb:Set( breadcrumb )
    end

    if ret then
        return true
    end
end

/*
*   ui > registered > hide
*
*   hides all of the primary pnls so that we can call the proper one
*
*   @param  : void
*   @return : void
*/

function mod.ui:HideRegistered( )
    local pnl_browser       = ui:call( 'pnl_browser', mod )
                            if ui:ok( pnl_browser ) then
                                ui:dispatch( pnl_target )
                            end

    self:ToggleRegistered( 'pnl_slider',    false   )
    self:ToggleRegistered( 'pnl_navmenu',   false   )
    self:ToggleRegistered( 'pnl_footer',    false   )
end

/*
*   get parent pnl
*
*   @param  : void
*   @return : pnl
*/

function mod.ui:getparent( )
    return mod.pnl and ui:ok( mod.pnl.root ) and mod.pnl.root or nil
end

/*
*   breadcrumb > home
*
*   @param  : void
*   @return : pnl
*/

function mod.breadcrumb:Home( )
    return self.bIsMain or false
end

/*
*   breadcrumb > set
*
*   @param  : void
*   @return : pnl
*/

function mod.breadcrumb:Set( b )
    self.bIsMain = b or false
end

/*
*   rules > initialize
*
*   @param  : str uri
*   @param  : bool bUseIntweb
*   @param  : bool bStandalone
*   @return : void
*/

function mod.rules:Initialize( uri, bUseIntweb, bStandalone )
    ui:dispatch( mod.pnl.web )
    ui:dispatch( mod.pnl.rules )

    local par                   = not bStandalone and ui:ok( mod.pnl.root ) and mod.pnl.root or nil
    local elm                   = ( not cfg.rules.use_text and bUseIntweb and 'rules_web' ) or 'rules'

    mod.pnl.rules               = ui.rlib( mod, elm, par )
    :title                      ( ln( 'rules_title' )           )
    :param                      ( 'SetRules', cfg.rules.text or ln( 'rules_text_missing' ) )
    :param                      ( 'SetStandalone', bStandalone  )
    :param                      ( 'SetURL', uri                 )
end

/*
*   rules > open
*
*   determines what to do when a player clicks the rules button
*   has the ability to open up an external website or to use in-game text.
*
*   :   uri
*       link to external website (if text-based not used)
*
*   :   bUseIntweb
*       uses the integrated browser built into script
*
*   :   bStandalone
*       allows ui to open without parent pnl, good for opening rules / terms by themselves using
*       the concommand
*
*   @param  : str uri
*   @param  : bool bUseIntweb
*   @param  : bool bStandalone
*   @return : void
*/

function mod.rules:Open( uri, bUseIntweb, bStandalone )
    if bUseIntweb then
        self:Initialize( uri, bUseIntweb, bStandalone )
    else
        gui.OpenURL( uri or mod.url )
    end
end

/*
*   web > openurl
*
*   activates buttons pressed in header
*
*   @param  : str title
*   @param  : str uri
*   @param  : bool bIntegrated
*   @return : void
*/

function mod.web:OpenURL( title, uri, bIntegrated )
    title = isstring( title ) and title or ln( 'browser_untitled' )
    if not isstring( uri ) then return end

    if not bIntegrated then
        gui.OpenURL( uri or mod.url )
        return
    end

    mod.ui:HideRegistered( )

    self:Integrated( ln( title ), uri )
end

/*
*   web > integrated
*
*   opens a url using the integrated browser
*
*   @param  : str title
*   @param  : str uri
*   @return : void
*/

function mod.web:Integrated( name, uri )
    ui:dispatch( mod.pnl.web )
    ui:dispatch( mod.pnl.rules )

    mod.pnl.web                     = ui.rlib( mod, 'ibws', mod.pnl.root    )
    :show                           (                                       )
    :title                          ( name                                  )
    :param                          ( 'SetWebURL', uri                      )
    :param                          ( 'SetMenuItem', name                   )
end

/*
*   ui > show
*
*   shows / creates interface to display for ply
*
*   @param  : void
*   @return : void
*/

function mod.ui:Show( )
    local pnl = self:getparent( )

    if not ui:ok( pnl ) then
        self:Initialize( )
        return
    end

    ui:stage( pnl )
end

/*
*   ui > hide
*
*   hides / removes the interface from ply's view
*
*   @param  : void
*   @return : void
*/

function mod.ui:Hide( )
    if not self:getparent( ) then return end
    local pnl = self:getparent( )
    if cfg.dev.regeneration then
        ui:destroy( pnl )
    else
        ui:unstage( pnl )
    end
end

/*
*   ui > rehash
*
*   reloads the entire ui
*
*   @param  : void
*   @return : void
*/

function mod.ui:Rehash( )
    ui:destroy( mod.pnl.root )
    timex.simple( 'liko_refresh', 2, mod.ui:Show( ) )
end

/*
*   interface > toggle
*
*   determines if the parent pnl is valid or not and hides it
*   if parent pnl doesnt exist, will be created and shown
*
*   @param  : void
*   @return : void
*/

local function interface_toggle( )
    local pnl = mod.ui:getparent( )
    if not ui:ok( pnl ) then
        mod.ui:Initialize( )
        return
    end

    if ui:visible( pnl ) then
        if cfg.dev.regeneration then
            ui:destroy( pnl )
        else
            ui:unstage( pnl )
        end
    else
        ui:stage( pnl )
    end
end
rcc.new.rlib( 'liko_toggle', interface_toggle )

/*
*   interface > precache
*
*   attempts to preload the interface prior to the ply completely joining the server.
*   this helps get rid of the noticable delay when the esc menu is opened for the
*   first time.
*/

local function interface_pc( )
    local pnl = mod.ui:getparent( )
    if not ui:ok( pnl ) then
        mod.ui:Initialize( )
    end

    timex.create( 'liko_pl_join_pc', 3, 0, function( )
        pnl = mod.ui:getparent( )
        if not pnl then return end

        ui:unstage( pnl )
        timex.expire( 'liko_pl_join_pc' )
        return
    end )
end
rnet.call( 'liko_pl_join_pc', interface_pc )

/*
*   ( rnet ) > initialize
*
*   called from sv:PlayerInitialSpawn
*/

local function rnet_initialize( data )
    mod.usrdef:Setup    ( data  )
end
rnet.call( 'liko_initialize', rnet_initialize )

/*
*   rnet > ui > initialize
*
*   called from sv:PlayerInitialSpawn
*   executed if cfg.initialize.onjoin_enabled = true
*
*   @param  : tbl data
*/

local function rnet_ui_init( data )
    interface_toggle( )
end
rnet.call( 'liko_ui_init', rnet_ui_init )

/*
*   rnet > ui > rehash
*
*   completely destroys interface panels and recreates them.
*
*   @param  : tbl data
*/

local function rnet_ui_rehash( data )
    mod.ui:Rehash( data )
end
rnet.call( 'liko_ui_rehash', rnet_ui_rehash )

/*
*   think
*/

local g_dothink = 0
local function th_general( )
    if not mod.ui:getparent( ) or not ui:visible( mod.ui:getparent( ) ) then return end
    if ( not cfg.initialize.esc_enabled ) and ( input.IsKeyDown( KEY_ESCAPE ) or gui.IsGameUIVisible( ) ) then ui:destroy( mod.ui:getparent( ) ) end

    /*
    *   anything below this line set on delay
    */

    if g_dothink > CurTime( ) then return end

    /*
    *   monitor scaling check
    *
    *   rather than painting positions, just store the players old monitor resolution
    *   and rehash the script if the monitor resolution changes.
    */

    local pl = LocalPlayer( )
    if not helper.ok.ply( pl ) then return end

    if ( ui:ok( mod.ui:getparent( ) ) and pl.rlib and pl.rlib.liko ) and ( pl.rlib.liko.res_w ~= ScrW( ) or pl.rlib.liko.res_h ~= ScrH( ) ) then
        pl.rlib.liko.res_w, pl.rlib.liko.res_h = ScrW( ), ScrH( )
        mod.ui:Rehash( )
        design.rsay( { ln( 'sys_init_interface' ), ln( 'sys_mreschng' ) }, Color( 255, 255, 255 ), 5 )
    end

    g_dothink = CurTime( ) + 1
end
rhook.new.gmod( 'Think', 'liko_th_general', th_general )

/*
*   bindkey activation
*/

local k_dothink = 0
local function th_keybind( )
    if k_dothink > CurTime( ) then return end
    if not cfg.binds.key.enabled then return end

    if input.IsKeyDown( cfg.binds.key.main ) then
        interface_toggle( )
        k_dothink = CurTime( ) + ( cfg.binds.key.delay or 0.5 )
    end
end
rhook.new.gmod( 'Think', 'liko_th_keybind', th_keybind )

/*
*   esc > prerender
*
*   toggles the interface to display if ply presses esc
*/

local function render_esc_keybind( )
    if not cfg.initialize.esc_enabled then return end
    if LocalPlayer( ):IsTyping( ) then return end
    if not gui.IsGameUIVisible( ) or not input.IsKeyDown( KEY_ESCAPE ) then return end
    gui.HideGameUI( )
    interface_toggle( )
end
rhook.new.gmod( 'Think', 'liko_binds_esc_prender', render_esc_keybind )