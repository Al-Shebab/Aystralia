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
*   module data
*/

    MODULE                  = { }
    MODULE.calls            = { }
    MODULE.resources        = { }

    MODULE.enabled          = true
    MODULE.parent		    = liko or { }
    MODULE.demo             = false
    MODULE.name             = 'Liko'
    MODULE.id               = 'liko'
    MODULE.author           = 'Richard'
    MODULE.desc             = 'escape screen and motd'
    MODULE.docs             = 'https://liko.rlib.io/'
    MODULE.url              = 'https://gmodstore.com/scripts/view/1632/'
    MODULE.icon             = 'https://cdn.rlib.io/gms/1632/env.png'
    MODULE.script_id	    = '1632'
    MODULE.owner		    = '76561198066940821'
    MODULE.version          = { 2, 2, 0, 0 }
    MODULE.libreq           = { 3, 2, 0, 0 }
    MODULE.released		    = 1607850986

/*
*   workshops
*/

    MODULE.fastdl           = true
    MODULE.precache         = true
    MODULE.ws_enabled       = true
    MODULE.ws_lst           = '2313877844'

/*
*   fonts
*/

    MODULE.fonts = { }

/*
*   logging
*/

    MODULE.logging = true

/*
*   translations
*/

    MODULE.language = { }

/*
*   materials
*/

    MODULE.mats =
    {
        [ 'btn_close_1' ]           = { 'rlib/modules/liko/v2/btn_close_1.png' },
        [ 'btn_close_2' ]           = { 'rlib/modules/liko/v2/btn_close_2.png' },
        [ 'btn_connect_1' ]         = { 'rlib/modules/liko/v2/btn_connect_1.png' },
        [ 'btn_console_1' ]         = { 'rlib/modules/liko/v2/btn_console_1.png' },
        [ 'btn_console_2' ]         = { 'rlib/modules/liko/v2/btn_console_2.png' },
        [ 'btn_disconnect_1' ]      = { 'rlib/modules/liko/v2/btn_disconnect_1.png' },
        [ 'btn_disconnect_2' ]      = { 'rlib/modules/liko/v2/btn_disconnect_2.png' },
        [ 'btn_discord_1' ]         = { 'rlib/modules/liko/v2/btn_discord_1.png' },
        [ 'btn_discord_2' ]         = { 'rlib/modules/liko/v2/btn_discord_2.png' },
        [ 'btn_donate_1' ]          = { 'rlib/modules/liko/v2/btn_donate_1.png' },
        [ 'btn_donate_2' ]          = { 'rlib/modules/liko/v2/btn_donate_2.png' },
        [ 'btn_forums_1' ]          = { 'rlib/modules/liko/v2/btn_forums_1.png' },
        [ 'btn_main_1' ]            = { 'rlib/modules/liko/v2/btn_main_1.png' },
        [ 'btn_resume_1' ]          = { 'rlib/modules/liko/v2/btn_resume_1.png' },
        [ 'btn_resume_2' ]          = { 'rlib/modules/liko/v2/btn_resume_2.png' },
        [ 'btn_rules_1' ]           = { 'rlib/modules/liko/v2/btn_rules_1.png' },
        [ 'btn_rules_2' ]           = { 'rlib/modules/liko/v2/btn_rules_2.png' },
        [ 'btn_server_1' ]          = { 'rlib/modules/liko/v2/btn_server_1.png' },
        [ 'btn_settings_1' ]        = { 'rlib/modules/liko/v2/btn_settings_1.png' },
        [ 'btn_settings_2' ]        = { 'rlib/modules/liko/v2/btn_settings_2.png' },
        [ 'btn_steam_1' ]           = { 'rlib/modules/liko/v2/btn_steam_1.png' },
        [ 'btn_steam_2' ]           = { 'rlib/modules/liko/v2/btn_steam_2.png' },
        [ 'btn_website_1' ]         = { 'rlib/modules/liko/v2/btn_website_1.png' },
        [ 'btn_website_2' ]         = { 'rlib/modules/liko/v2/btn_website_2.png' },
        [ 'btn_website_3' ]         = { 'rlib/modules/liko/v2/btn_website_3.png' },
        [ 'btn_workshop_1' ]        = { 'rlib/modules/liko/v2/btn_workshop_1.png' },
        [ 'btn_gmod_menu_1' ]       = { 'rlib/modules/liko/v2/ico/gmod_logo_1.png' },
        [ 'btn_gmod_menu_2' ]       = { 'rlib/modules/liko/v2/ico/gmod_menu_1.png' },
        [ 'pattern_hdiag' ]         = { 'rlib/modules/liko/v2/fx/hdiag_pattern.png' },
    }

/*
*   permissions
*/

    MODULE.permissions =
    {
        [ 'index' ] =
        {
            category                = 'RLib » Liko',
            module                  = 'Liko',
        },
        [ 'liko_motd_canignore' ] =
        {
            id                      = 'liko_motd_canignore',
            desc                    = 'Allows a group to not see the MOTD at all when they join the server',
            usrlvl                  = 'superadmin',
        },
        [ 'liko_ui_open' ] =
        {
            id                      = 'liko_ui_open',
            name                    = 'UI: Open',
            ulx_id                  = 'ulx liko_ui_open',
            sam_id                  = 'esc_ui_open',
            xam_id                  = 'esc_ui_open',
            desc                    = 'Opens escape screen',
            notify                  = '%s forced interface open on %s',
            usrlvl                  = 'superadmin',
            bExt                    = true,
        },
        [ 'liko_ui_rehash' ] =
        {
            id                      = 'liko_ui_rehash',
            name                    = 'UI: Rehash',
            ulx_id                  = 'ulx liko_ui_rehash',
            sam_id                  = 'esc_ui_rehash',
            xam_id                  = 'esc_ui_rehash',
            desc                    = 'Destroys and re-creates interface. Useful for forcing new settings',
            notify                  = '%s forced interface rehash on %s',
            usrlvl                  = 'superadmin',
            bExt                    = true,
        },
        [ 'liko_rnet_reload' ] =
        {
            id                      = 'liko_rnet_reload',
            name                    = 'Reload RNet',
            ulx_id                  = 'ulx liko_rnet_reload',
            sam_id                  = 'esc_rnet_reload',
            xam_id                  = 'esc_rnet_reload',
            desc                    = 'Registers all network entries for script. Developer purposes only.',
            notify                  = '%s successfully reloaded rnet',
            usrlvl                  = 'superadmin',
            bExt                    = true,
        },
        [ 'liko_fonts_reload' ] =
        {
            id                      = 'liko_fonts_reload',
            name                    = 'Reload Fonts',
            ulx_id                  = 'ulx liko_fonts_reload',
            sam_id                  = 'esc_fonts_reload',
            xam_id                  = 'esc_fonts_reload',
            desc                    = 'Reloads all registered fonts.',
            notify                  = '%s successfully reloaded fonts',
            usrlvl                  = 'superadmin',
            bExt                    = true,
        },
    }

/*
*   storage > sh
*/

    MODULE.storage =
    {
        breadcrumb          = { },
        ticker              = { },
        web                 = { },
        rules               = { },
        settings =
        {
            servers         = { },
            slider          = { },
            ticker          = { },
            ugroups         = { },
            header          = { },
            footer          = { },
            welcome         = { },
        }
    }

/*
*   storage > sv
*/

    MODULE.storage_sv = { }

/*
*   storage > cl
*/

    MODULE.storage_cl = { }

/*
*   datafolder
*/

    MODULE.datafolder = { }

/*
*   calls > net
*/

    MODULE.calls.net =
    {
        [ 'liko_initialize' ]                   = { 'liko.initialize' },
        [ 'liko_ui_init' ]                      = { 'liko.ui.init' },
        [ 'liko_ui_rehash' ]                    = { 'liko.ui.rehash' },
        [ 'liko_pl_join_pc' ]                   = { 'liko.pl.join.pc' },
        [ 'liko_fonts_reload' ]                 = { 'liko.fonts.reload' },
    }

/*
*   calls > hooks
*/

    MODULE.calls.hooks =
    {
        [ 'liko_init' ]                         = { 'liko_init' },
        [ 'liko_ipe_cl' ]                       = { 'liko.ipe.cl' },
        [ 'liko_pl_join_init' ]                 = { 'liko.pl.join.init' },
        [ 'liko_pl_say_toggle' ]                = { 'liko.pl.say.toggle' },
        [ 'liko_pl_say_motd' ]                  = { 'liko.pl.say.motd' },
        [ 'liko_binds_esc_prender' ]            = { 'liko.binds.esc.prender' },
        [ 'liko_th_general' ]                   = { 'liko.th.general' },
        [ 'liko_th_keybind' ]                   = { 'liko.th.keybind' },
        [ 'liko_th_ui' ]                        = { 'liko_th_ui' },
        [ 'liko_rnet_register' ]                = { 'liko.rnet.register' },
        [ 'liko_fonts_register' ]               = { 'liko.fonts.register' },
        [ 'liko_overlay_copy' ]                 = { 'liko.overlay.copy' },
        [ 'liko_usrdef_setup_think' ]           = { 'liko.usrdef.setup.think' },
        [ 'liko_usrdef_res_change' ]            = { 'liko.usrdef.res.change' },
    }

/*
*   calls > timers
*/

    MODULE.calls.timers =
    {
        [ 'liko_pl_join_delay' ]                = { 'liko.pl.join.delay' },
        [ 'liko_pl_join_pc' ]                   = { 'liko.pl.join.pc' },
        [ 'liko_slider_sw' ]                    = { 'liko.slider.sw' },
        [ 'liko_slider_sw_pause' ]              = { 'liko.slider.sw.pause' },
        [ 'liko_refresh' ]                      = { 'liko.refresh' },
        [ 'liko_copy_anim' ]                    = { 'liko.copy.anim' },
    }

/*
*   calls > commands
*/

    MODULE.calls.commands =
    {
        [ 'liko_toggle' ] =
        {
            id                      = 'liko',
            desc                    = 'opens escape screen',
            scope                   = 3
        },
        [ 'liko_ui_rehash' ] =
        {
            id                      = 'liko.ui.rehash',
            desc                    = 'completely destroys all pnls and re-creates them',
            scope                   = 3
        },
        [ 'liko_rnet_reload' ] =
        {
            id                      = 'liko.rnet.reload',
            desc                    = 'reloads module rnet module',
            is_hidden               = true,
            scope                   = 1,
        },
        [ 'liko_fonts_reload' ] =
        {
            id                      = 'liko.fonts.reload',
            desc                    = 'reloads all fonts',
            is_hidden               = true,
            scope                   = 2,
        },
    }

/*
*   resources > particles
*/

    MODULE.resources.ptc = { }

/*
*   resources > sounds
*/

    MODULE.resources.snd =
    {
        [ 'mouseover_01' ]          = { 'rlib/general/actions/mo_1.mp3' },
        [ 'mouseover_02' ]          = { 'rlib/general/actions/mo_2.mp3' },
        [ 'swipe_01' ]              = { 'rlib/general/actions/sw_1.mp3' },
    }

/*
*   resources > models
*/

    MODULE.resources.mdl = { }

/*
*   resources > panels
*/

    MODULE.resources.pnl =
    {
        [ 'announce' ]                  = { 'liko.pnl.announce' },
        [ 'bg' ]                        = { 'liko.pnl.bg' },
        [ 'confl' ]                     = { 'liko.pnl.confl' },
        [ 'footer' ]                    = { 'liko.pnl.footer' },
        [ 'header' ]                    = { 'liko.pnl.header' },
        [ 'nav' ]                       = { 'liko.pnl.nav' },
        [ 'news' ]                      = { 'liko.pnl.news' },
        [ 'news_item' ]                 = { 'liko.pnl.news.item' },
        [ 'rules' ]                     = { 'liko.pnl.rules' },
        [ 'rules_web' ]                 = { 'liko.pnl.rules.web' },
        [ 'servers' ]                   = { 'liko.pnl.servers' },
        [ 'ticker' ]                    = { 'liko.pnl.ticker' },
        [ 'ibws' ]                      = { 'liko.pnl.ibws' },
        [ 'diag_cwserv' ]               = { 'liko.diag.cwserv' },
        [ 'diag_ibws_notice' ]          = { 'liko.diag.ibws.notice' },
    }

/*
*   doclick
*/

    MODULE.doclick = function( ) end

/*
*   dependencies
*/

    MODULE.dependencies =
    {

    }