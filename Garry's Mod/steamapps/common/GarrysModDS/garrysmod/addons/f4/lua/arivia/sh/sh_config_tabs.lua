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
*	tab > jobs
*/

    mod.tab.jobs =
    {
        enabled                 = true,
        name                    = 'Jobs',
        desc                    = 'Earning your paycheck',
        icon                    = 'arivia/arivia_button_jobs.png',
        clr_txt                 = Color( 255, 240, 244 ),
        clr_btn_n               = Color( 64, 105, 126, 190 ),
        clr_btn_h               = Color( 64, 105, 126, 240 ),
        clr_unavail             = Color( 20, 20, 20, 200 ),
        bShowUnavail            = true,
        bFadeUnavail            = true,
        bPrestigeEnabled        = false,
        bXpEnabled              = false,
    }

/*
*	tab > weapons
*/

    mod.tab.weps =
    {
        enabled                 = true,
        name                    = 'Weapons',
        desc                    = 'The beauty of the 2nd amendment',
        icon                    = 'arivia/arivia_button_weapons.png',
        clr_txt                 = Color( 255, 240, 244 ),
        clr_btn_n               = Color( 72, 112, 58, 190 ),
        clr_btn_h               = Color( 72, 112, 58, 240 ),
        clr_unavail             = Color( 20, 20, 20, 200 ),
        bFadeUnavail            = true,
        bPrestigeEnabled        = false,
        bXpEnabled              = false,
    }

/*
*	tab > ammo
*/

    mod.tab.ammo =
    {
        enabled                 = true,
        name                    = 'Ammo',
        desc                    = 'Keeping your guns ready',
        icon                    = 'arivia/arivia_button_ammo.png',
        clr_txt                 = Color( 255, 240, 244 ),
        clr_btn_n               = Color( 163, 135, 79, 190 ),
        clr_btn_h               = Color( 163, 135, 79, 240 ),
        clr_unavail             = Color( 20, 20, 20, 200 ),
        bFadeUnavail            = true,
        bPrestigeEnabled        = false,
        bXpEnabled              = false,
    }

/*
*	tab > entities
*/

    mod.tab.ents =
    {
        enabled                 = true,
        name                    = 'Entities',
        desc                    = 'Items for use in-world',
        icon                    = 'arivia/arivia_button_entities.png',
        clr_txt                 = Color( 255, 240, 244 ),
        clr_btn_n               = Color( 124, 51, 50, 190 ),
        clr_btn_h               = Color( 124, 51, 50, 240 ),
        clr_unavail             = Color( 20, 20, 20, 200 ),
        bFadeUnavail            = true,
        bPrestigeEnabled        = false,
        bXpEnabled              = false,
    }

/*
*	tab > vehicles
*/

    mod.tab.vehc =
    {
        enabled                 = true,
        name                    = 'Vehicles',
        desc                    = 'Getting your permit',
        icon                    = 'arivia/arivia_button_vehicles.png',
        clr_txt                 = Color( 255, 240, 244 ),
        clr_btn_n               = Color( 64, 105, 126, 190 ),
        clr_btn_h               = Color( 64, 105, 126, 240 ),
        clr_unavail             = Color( 20, 20, 20, 200 ),
        bFadeUnavail            = true,
        bPrestigeEnabled        = false,
        bXpEnabled              = false,
    }

/*
*	tab > shipments
*/

    mod.tab.ship =
    {
        enabled                 = true,
        name                    = 'Shipments',
        desc                    = 'Extra things to help out',
        icon                    = 'arivia/arivia_button_shipments.png',
        clr_txt                 = Color( 255, 240, 244 ),
        clr_btn_n               = Color( 145, 71, 101, 190 ),
        clr_btn_h               = Color( 145, 71, 101, 240 ),
        clr_unavail             = Color( 20, 20, 20, 200 ),
        bShowUnavail            = false,
        bFadeUnavail            = true,
        bPrestigeEnabled        = false,
        bXpEnabled              = false,
    }

/*
*	tab > food
*/

    mod.tab.food =
    {
        enabled                 = false,
        name                    = 'Food',
        desc                    = 'Yummy for the tummy',
        icon                    = 'arivia/arivia_button_food.png',
        clr_txt                 = Color( 255, 240, 244 ),
        clr_btn_n               = Color( 145, 71, 101, 190 ),
        clr_btn_h               = Color( 145, 71, 101, 240 ),
        clr_unavail             = Color( 20, 20, 20, 200 ),
        bFadeUnavail            = true,
        bPrestigeEnabled        = false,
        bXpEnabled              = false,
    }