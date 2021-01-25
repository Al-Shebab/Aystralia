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
*   WORKSHOP / FASTDL
*
*   >   fastdl_enabled
*       set false if you do not wish for the server to force players to download the
*       resources/materials.
*
*   >   ws_mount_enabled
*       set false if you do not wish for the server to force clients to download the
*       resources from the workshop.
*
*   >   ws_enabled
*       set false if you do not wish for the server to force clients to download the
*       resources from the workshop.
*/

    cfg.fastdl_enabled              = true
    cfg.ws_enabled                  = true
    cfg.ws_mount_enabled            = false

/*
*   BACKGROUNDS > STATIC
*/

    cfg.bg.static.enabled           = true
    cfg.bg.static.blur_enabled      = true
    cfg.bg.static.list =
    {
        'http://cdn.rlib.io/wp/s/1.jpg',
        'http://cdn.rlib.io/wp/s/2.jpg',
        'http://cdn.rlib.io/wp/s/3.jpg',
        'http://cdn.rlib.io/wp/s/4.jpg',
        'http://cdn.rlib.io/wp/s/5.jpg',
        'http://cdn.rlib.io/wp/s/6.jpg',
        'http://cdn.rlib.io/wp/s/7.jpg',
        'http://cdn.rlib.io/wp/s/8.jpg',
        'http://cdn.rlib.io/wp/s/9.jpg',
    }

/*
*   BACKGROUNDS > LIVE
*/

    cfg.bg.live.enabled             = true
    cfg.bg.live.list =
    {
        'http://cdn.rlib.io/wp/l/index.php?id=default_1',
        'http://cdn.rlib.io/wp/l/index.php?id=default_2',
        'http://cdn.rlib.io/wp/l/index.php?id=default_3',
        'http://cdn.rlib.io/wp/l/index.php?id=default_4',
        'http://cdn.rlib.io/wp/l/index.php?id=default_5',
        'http://cdn.rlib.io/wp/l/index.php?id=default_6',
        'http://cdn.rlib.io/wp/l/index.php?id=default_7',
        'http://cdn.rlib.io/wp/l/index.php?id=default_8',
        'http://cdn.rlib.io/wp/l/index.php?id=default_9',
        'http://cdn.rlib.io/wp/l/index.php?id=default_10',
        'http://cdn.rlib.io/wp/l/index.php?id=default_11',
    }

/*
*   GENERAL
*/

    cfg.name_enabled                = true                              -- Display a network name on top of F4 menu?
    cfg.name                        = 'Aystralia Network'          -- Network name to display if above option enabled
    cfg.name_clr                    = Color( 255, 255, 255, 255 )       -- Color for network name text

    cfg.money_clr                   = Color( 255, 255, 255, 255 )       -- Color for player money
    cfg.job_clr                     = Color( 255, 255, 255, 255 )       -- Color for player job color

    cfg.pnl_mid_bg_clr              = Color( 16, 16, 16, 200 )          -- Middle panel background color
    cfg.pnl_left_bg_clr             = Color( 0, 0, 0, 250 ) 	        -- Left Panel Background Color

    cfg.pnl_left_top_bg_clr         = Color( 111, 39, 39, 255 )

    cfg.btn_close_clr               = Color( 255, 255, 255, 255 )       -- Color for the close button in the top right

/*
*	clock
*/

    cfg.clock_enabled               = false
    cfg.clock_format                = '%a, %I:%M:%S %p'
    cfg.clock_clr                   = Color( 255, 255, 255, 255 )
    cfg.clock_bg                    = Color( 111, 39, 39, 255 )

/*
*	staff panel > usergroups
*
*   these settings will determine which groups show in the 'staff' tab.
*   you may override the color for each group and the name
*/

    cfg.ugroup_clrs                         = { }
    cfg.ugroup_clrs[ 'user' ] = Color(93, 24, 255, 220)
    cfg.ugroup_clrs[ 'trusted' ] = Color(132, 81, 252, 220)
    cfg.ugroup_clrs[ 'perth' ] = Color(0, 183, 212, 220)
    cfg.ugroup_clrs[ 'brisbane' ] = Color(61, 229, 255, 220)
    cfg.ugroup_clrs[ 'melbourne' ] = Color(61, 255, 213, 220)
    cfg.ugroup_clrs[ 'sydney' ] = Color(61, 255, 154, 220)
    cfg.ugroup_clrs[ 'trial-moderator' ] = Color(24, 249, 255, 220)
    cfg.ugroup_clrs[ 'moderator' ] = Color(74, 255, 121, 220)
    cfg.ugroup_clrs[ 'senior-moderator' ] = Color(148, 255, 87, 220)
    cfg.ugroup_clrs[ 'admin' ] = Color(226, 255, 68, 220)
    cfg.ugroup_clrs[ 'senior-admin' ] = Color(255, 180, 0, 220)
    cfg.ugroup_clrs[ 'staff-manager' ] = Color(255, 101, 101, 220)
    cfg.ugroup_clrs[ 'superadmin' ] = Color(93, 24, 255, 220)
    cfg.ugroup_clrs[ 'donator-trial-moderator' ] = Color(24, 249, 255, 220)
    cfg.ugroup_clrs[ 'donator-moderator' ] = Color(74, 255, 121, 220)
    cfg.ugroup_clrs[ 'donator-senior-moderator' ] = Color(148, 255, 87, 220)
    cfg.ugroup_clrs[ 'donator-admin' ] = Color(226, 255, 68, 220)

    cfg.ugroup_titles                       = { }
    cfg.ugroup_clrs[ 'user' ] 			= 'User'
    cfg.ugroup_clrs[ 'trusted' ] 			= 'Trusted'
    cfg.ugroup_clrs[ 'perth' ] 			= 'Perth'
    cfg.ugroup_clrs[ 'brisbane' ] 			= 'Brisbane'
    cfg.ugroup_clrs[ 'melbourne' ] 			= 'Melbourne'
    cfg.ugroup_clrs[ 'sydney' ] 			= 'Sydney'
    cfg.ugroup_clrs[ 'trial-moderator' ] 			= 'Trial Moderator'
    cfg.ugroup_clrs[ 'moderator' ] 			= 'Moderator'
    cfg.ugroup_clrs[ 'senior-moderator' ] 			= 'Senior Moderator'
    cfg.ugroup_clrs[ 'admin' ] 			= 'Admin'
    cfg.ugroup_clrs[ 'senior-admin' ] 			= 'Senior Admin'
    cfg.ugroup_clrs[ 'staff-manager' ] 			= 'Staff Manager'
    cfg.ugroup_clrs[ 'superadmin' ] 			= 'User'
    cfg.ugroup_clrs[ 'donator-trial-moderator' ] 			= 'Trial Moderator'
    cfg.ugroup_clrs[ 'donator-moderator' ] 			= 'Moderator'
    cfg.ugroup_clrs[ 'donator-senior-moderator' ] 			= 'Senior Moderator'
    cfg.ugroup_clrs[ 'donator-admin' ] 			= 'Admin'

/*
*	staff panel > usergroups > staff
*
*   groups in this list will determine which particular groups show as 'staff' groups.
*/

    cfg.ugroups_staff =

    {
        'senior-admin',
        'staff-manager',
        'donator-admin',
        'donator-senior-moderator',
        'donator-moderator',
        'donator-trial-moderator',
        'admin',
        'senior-moderator',
        'moderator',
        'trial-moderator'
    }

/*
*	staff panel > cards
*
*   general settings for the staff cards
*/

    cfg.StaffCardBlur                           = false
    cfg.StaffCardBackgroundUseRankColor         = true                              -- Use rank color for staff card background color?
    cfg.StaffCardBackgroundColor                = Color( 0, 0, 0, 230 )             -- If arivia.StaffCardBackgroundUseRankColor is FALSE - what do you want the card color to be?
    cfg.StaffCardNameColor                      = Color( 255, 255, 255, 255 )       -- Text color for player name
    cfg.StaffCardRankColor                      = Color( 255, 255, 255, 255 )       -- Text color for rank name

/*
*	truncation
*
*   this will take long long names for jobs / entities and cut them off if they appear too long.
*   any characters after the specified limit amount will be removed and replaced with three dots ( ... )
*
*   @ex : Test Entity Name
*         Test Entit...
*/

    cfg.truncate_enabled            = true
    cfg.truncate_length             = 170

/*
*	integrated web browser
*/

    cfg.BrowserColor                = Color( 0, 0, 0, 240 )             -- Color to use for the custom browser window.
    cfg.BrowserTitleTextColor       = Color( 255, 255, 255, 255 )
    cfg.BrowserControlsEnabled      = true

/*
*	misc internal params
*
*   no need to mess with these
*/

    cfg.ItemAmountH                 = 20
    cfg.ItemnameH                   = 23

/*
*	dev > panel regeneration
*
*   >   true            : this will completely re-create the entire interface each time you close and re-open the ui.
*	                      this forces all panels to be freshly made.
*
*                         only set true if instructed to do so by the developer or if you know what you're doing
*
*   >   false           : the interface will be created only the first time and then each time called, interface will
*                         show and hide.
*
*   @type       : bool
*   @default    : false
*/

    cfg.regeneration                = false

/*
*   DEBUG MODE
*
*   this feature enables special actions on the server.
*   it should NOT be enabled unless you have been instructed to do so by the
*   developer.
*/

    cfg.DebugEnabled                = false