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
*	descriptions > enabled
*
*   if enabled, entities with entries in the list sub-table will override the default
*   entity description.
*/

    cfg.desc.enabled                    = true

/*
*	descriptions > list > weapons
*/

    cfg.desc.list                       = { }
    cfg.desc.list[ 'weapon_ak472' ]     = 'This is the Ak47\nClick to purchase!'
    cfg.desc.list[ 'weapon_deagle2' ]   = 'A semi-automatic handgun notable for chambering the largest centerfire cartridge of any magazine fed, self loading pistol. It has a relatively unique design with a triangular barrel and large muzzle.'


/*
*	descriptions > list > food
*/

    cfg.desc.list[ 'Banana' ]            = 'This is a banana. Oh how wonderful it is.'
    cfg.desc.list[ 'Bunch of bananas' ]  = 'This is a bundle of bananas straight from Africa - ensuring you get the best in quality.'
    cfg.desc.list[ 'Melon' ]             = 'A giant melon, who doesn\'t like melons?'
    cfg.desc.list[ 'Glass bottle' ]      = 'The same bottle you use at a bar fight - now gives energy.'
    cfg.desc.list[ 'Pop can' ]           = 'High in sugar, this is sure to give you an energetic jolt.'
    cfg.desc.list[ 'Plastic bottle' ]    = 'This plastic bottle is full of... well... a liquid.'
    cfg.desc.list[ 'Milk' ]              = 'It\'s only three days past expired -- still healthy for you.'
    cfg.desc.list[ 'Bottle 1' ]          = 'A nice beverage from the tropics. It contains cherries, oranges, and some type of vodka.'
    cfg.desc.list[ 'Bottle 2' ]          = 'A strange bottle that was located next to a bum.'
    cfg.desc.list[ 'Bottle 3' ]          = 'It smells cheap, but it will still keep you hydrated.'
    cfg.desc.list[ 'Orange' ]            = 'A ripe firm orange.'