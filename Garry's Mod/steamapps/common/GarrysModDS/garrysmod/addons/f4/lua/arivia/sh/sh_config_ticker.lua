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
*	ticker
*/

cfg.ticker_enabled          = false     -- Utilize the ticker?
cfg.ticker_speed            = 75        -- How fast you want the ticker to run across the screen.

cfg.ticker_msgs =
{
    {
        textNews = "Participate in our weekend Staff VS Players events - each Friday of every week from 7pm - 8pm PST.",
        textColor = Color(255, 255, 0)
    },
    {
        textNews = "Want to apply for staff? Type !application and fill in the required information.",
        textColor = Color(255, 255, 0)
    }
}