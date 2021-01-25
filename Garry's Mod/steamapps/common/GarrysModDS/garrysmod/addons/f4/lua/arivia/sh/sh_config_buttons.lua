/*
*   @module         : arivia
*   @author         : Richard [http://steamcommunity.com/profiles/76561198135875727]
*   @copyright      : (c) 2016 - 2020
*   @docs           : https://arivia.rlib.io
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
*	declare > module
*/

local base                  = arivia
local helper                = base.helper
local design                = base.design

/*
*	declare > cfg
*/

local cfg                   = base.cfg

/*
*	info buttons
*
*   these are the buttons that display your network links
*   ie: website, donations, forums, etc.
*/


cfg.nav.bIconsEnabled       = true   -- This shows the icons with text.

cfg.nav.TitleDonate         = 'Donate'
cfg.nav.LinkDonate          = 'https://aystralia-network.tebex.io'

cfg.nav.TitleWebsite        = 'Workshop'
cfg.nav.LinkWebsite         = 'https://steamcommunity.com/sharedfiles/filedetails/?id=2332062788'

cfg.nav.TitleWorkshop       = 'Discord'
cfg.nav.LinkWorkshop        = 'https://discord.gg/hWN7zXtbQP'

-----------------------------------------------------------------
-- [ RULES ]
-----------------------------------------------------------------

cfg.nav.TitleRules          = 'Rules'

cfg.RulesTextColor          = Color(  255, 255, 255, 255 )
cfg.RulesText =
[[

[x] Our rules can be found here [x]
     https://bit.ly/3mQVodO

]]

cfg.info =
{
    {
        enabled             = true,
        name                = 'Online Staff',
        desc                = 'Available to assist',
        icon                = 'arivia/arivia_button_staff.png',
        clr_btn_n           = Color( 64, 105, 126, 190 ),
        clr_btn_h           = Color( 64, 105, 126, 240 ),
        clr_txt_n           = Color( 255, 255, 255, 255 ),
        clr_txt_h           = Color( 255, 255, 255, 255 ),
        func                = function( )
                                base:OpenAdmins( )
                            end
    },
    {
        enabled             = true,
        name                = 'Rules',
        desc                = 'What you should know',
        icon                = 'arivia/arivia_button_rules.png',
        clr_btn_n           = Color(  163, 135, 79, 190  ),
        clr_btn_h           = Color(  163, 135, 79, 240  ),
        clr_txt_n           = Color ( 255, 255, 255, 255  ),
        clr_txt_h           = Color(  255, 255, 255, 255  ),
        func                = function( )
                                -- Internal
                                base:OpenExternal( cfg.nav.TitleRules, cfg.RulesText, true )
                            end
    },
    {
        enabled             = true,
        name                = 'Donate',
        desc                = 'Donate to help keep us running',
        icon                = 'arivia/arivia_button_donate.png',
        clr_btn_n           = Color(  145, 71, 101, 190  ),
        clr_btn_h           = Color(  145, 71, 101, 240  ),
        clr_txt_n           = Color ( 255, 255, 255, 255  ),
        clr_txt_h           = Color(  255, 255, 255, 255  ),
        func                = function( )
                                -- Internal
                                base:OpenExternal( cfg.nav.TitleDonate, cfg.nav.LinkDonate )

                                -- External
                                -- gui.OpenURL( cfg.nav.LinkDonate )
                            end
    },
    {
        enabled             = true,
        name                = 'Workshop',
        desc                = 'Download our addons here',
        icon                = 'arivia/arivia_button_steam.png',
        clr_btn_n           = Color(  72, 112, 58, 190  ),
        clr_btn_h           = Color(  72, 112, 58, 240  ),
        clr_txt_n           = Color ( 255, 255, 255, 255  ),
        clr_txt_h           = Color(  255, 255, 255, 255  ),
        func                = function( )
                                -- Internal
                                base:OpenExternal( cfg.nav.TitleWebsite, cfg.nav.LinkWebsite )

                                -- External
                                -- gui.OpenURL( cfg.nav.LinkWebsite )
                            end
    },
    {
        enabled             = true,
        name                = 'Discord',
        desc                = 'Join our Discord!',
        icon                = 'arivia/arivia_button_entities.png',
        clr_btn_n           = Color(  112, 87, 58, 190  ),
        clr_btn_h           = Color(  112, 87, 58, 220  ),
        clr_txt_n           = Color ( 255, 255, 255, 255  ),
        clr_txt_h           = Color(  255, 255, 255, 255  ),
        func                = function( )
                                -- Internal
                                base:OpenExternal( cfg.nav.TitleWorkshop, cfg.nav.LinkWorkshop )

                                -- External
                                -- gui.OpenURL( cfg.nav.LinkWorkshop )
                            end
    },
    {
        enabled             = true,
        name                = 'Disconnect',
        desc                = 'Disconnect from our server',
        icon                = 'arivia/arivia_button_disconnect.png',
        clr_btn_n           = Color( 124, 51, 50, 190 ),
        clr_btn_h           = Color( 124, 51, 50, 240 ),
        clr_txt_n           = Color( 255, 255, 255, 255 ),
        clr_txt_h           = Color( 255, 255, 255, 255 ),
        func                = function( )
                                RunConsoleCommand( 'disconnect' )
                            end
    }
}