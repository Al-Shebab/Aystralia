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

/*
*   module calls
*/

local mod, pf       	    = base.modules:req( 'liko' )
local cfg               	= base.modules:cfg( mod )

/*
*   SETTINGS > LANGUAGE
*/

    /*
    *	language
    *
    *	determines the language to use when translating particular strings.
    *	a list of available languages can be found in the addon MANIFEST / ENV file.
    *
    *	@type       : str
    *	@default    : 'en'
    */

        cfg.lang = 'en'

/*
*   SETTINGS > INITIALIZE
*/

    /*
    *	initialize > escape
    *
    *	determines if the interface will be activated if the ply presses esc
    *   will func as an escape screen
    *
    *	@type       : bool
    *	@default    : true
    */

        cfg.initialize.esc_enabled = true

    /*
    *	initialize > motd ( message of the day ) mode
    *
    *   >   true            : script will be displayed right when the player connects to the server.
    *                         they will need to close out of the interface in order to continue play.
    *
    *   >   false           : this script will only activate if the player uses the bind key [ default F9 ] or
    *                         types the assigned chat command [ see cfg.binds.chat.main setting ]
    *
    *   @type       : bool
    *   @default    : true
    */

        cfg.initialize.motd_enabled = false

    /*
    *	initialize > precache
    *
    *   : true      escape screen will be opened 'in the background' while the player is connecting
    *               to the server. This makes it so the player gets a quicker opening escape screen
    *               that doesnt take a few extra seconds to open the first time they do.
    *
    *   : false     no precaching will take place
    *
    *   @type       : bool
    *   @default    : false
    */

        cfg.initialize.precache = false