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

local mod                   = arivia
local helper                = mod.helper
local design                = mod.design

/*
*	declare > cfg
*/

local cfg                   = mod.cfg

/*
*	SETTINGS > SERVERS
*/

    cfg.servers.enabled             = false                               -- Should server row even display?
    cfg.servers.clr_btn_n           = Color( 15, 15, 15, 0 )
    cfg.servers.clr_btn_h           = Color( 255, 255, 255, 220 )
    cfg.servers.clr_txt_n           = Color( 255, 255, 255, 255 )
    cfg.servers.clr_txt_h           = Color( 0, 0, 0, 255 )
    cfg.servers.bIconsText          = true                                  -- This shows the icons with text.
    cfg.servers.bIconsOnly          = false                                 -- This will show the icons only, without the text counterpart. The above option OVERRIDES this, so please turn that off first.

    cfg.servers.list =
    {
        {
            hostname                = 'TTT SERVER',
            icon                    = 'arivia/arivia_button_server.png',
            ip                      = '127.0.0.1:27015'
        },
        {
            hostname                = 'SANDBOX SERVER',
            icon                    = 'arivia/arivia_button_server.png',
            ip                      = '127.0.0.1:28015'
        }
    }