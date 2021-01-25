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
*   SETTINGS > USER GROUPS
*/

    /*
    *   list of user groups to be recognized by the script.
    *
    *   will display these at the bottom left of the motd under the players
    *   username
    *
    *   because different networks setup group names differently;
    *   please do the following when providing a group:
    *
    *       :   make all letters lowercase
    *       :   replace spaces with underscores
    *
    *   @ex :   SuperAdmin      =>      superadmin
    *           Trial Mod       =>      trial_mod
    */

        cfg.ugroups.titles =
        {
            [ 'user' ] 			= 'User'
            [ 'trusted' ] 			= 'Trusted'
            [ 'perth' ] 			= 'Perth'
            [ 'brisbane' ] 			= 'Brisbane'
            [ 'melbourne' ] 			= 'Melbourne'
            [ 'sydney' ] 			= 'Sydney'
            [ 'trial-moderator' ] 			= 'Trial Moderator'
            [ 'moderator' ] 			= 'Moderator'
            [ 'senior-moderator' ] 			= 'Senior Moderator'
            [ 'admin' ] 			= 'Admin'
            [ 'senior-admin' ] 			= 'Senior Admin'
            [ 'staff-manager' ] 			= 'Staff Manager'
            [ 'superadmin' ] 			= 'User'
            [ 'donator-trial-moderator' ] 			= 'Trial Moderator'
            [ 'donator-moderator' ] 			= 'Moderator'
            [ 'donator-senior-moderator' ] 			= 'Senior Moderator'
            [ 'donator-admin' ] 			= 'Admin'
        }

    /*
    *   associated with the ugroup titles above.
    *
    *   this will determine what color the text is that displays
    *   depending on what the players usergroup is
    *
    *   will display these at the bottom left of the motd under the players
    *   username
    *
    *   because different networks setup group names differently;
    *   please do the following when providing a group:
    *
    *       :   make all letters lowercase
    *       :   replace spaces with underscores
    *
    *   @ex :   SuperAdmin      =>      superadmin
    *           Trial Mod       =>      trial_mod
    */

        cfg.ugroups.clrs =
        {
            [ 'user' ] = Color(93, 24, 255, 220)
            [ 'trusted' ] = Color(132, 81, 252, 220)
            [ 'perth' ] = Color(0, 183, 212, 220)
            [ 'brisbane' ] = Color(61, 229, 255, 220)
            [ 'melbourne' ] = Color(61, 255, 213, 220)
            [ 'sydney' ] = Color(61, 255, 154, 220)
            [ 'trial-moderator' ] = Color(24, 249, 255, 220)
            [ 'moderator' ] = Color(74, 255, 121, 220)
            [ 'senior-moderator' ] = Color(148, 255, 87, 220)
            [ 'admin' ] = Color(226, 255, 68, 220)
            [ 'senior-admin' ] = Color(255, 180, 0, 220)
            [ 'staff-manager' ] = Color(255, 101, 101, 220)
            [ 'superadmin' ] = Color(93, 24, 255, 220)
            [ 'donator-trial-moderator' ] = Color(24, 249, 255, 220)
            [ 'donator-moderator' ] = Color(74, 255, 121, 220)
            [ 'donator-senior-moderator' ] = Color(148, 255, 87, 220)
            [ 'donator-admin' ] = Color(226, 255, 68, 220)
        }