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
*	localized glua
*/

local _f                    = surface.CreateFont

/*
*	fonts
*/

_f( 'AriviaFontTicker',             { size = 27, weight = 200,blursize = 0,scanlines = 0,antialias = true,font = 'Teko Light' } )
_f( 'AriviaFontCloseGUI',           { size = 14, weight = 700, antialias = true, shadow = false, font = 'Roboto' } )
_f( 'arivia_sel_btn_select',        { size = 19, weight = 600, antialias = true, shadow = false, font = 'Segoe UI Light' } )
_f( 'AriviaFontObjectMinMax',       { size = 12, weight = 700, antialias = true, shadow = false, font = 'Roboto' } )
_f( 'AriviaFontBrowserTitle',       { size = 26, weight = 100, antialias = true, shadow = false, font = 'Teko Light' } )
_f( 'AriviaFontPlayerWalletTitle',  { size = 14, weight = 400, antialias = true, shadow = false, font = 'Roboto' } )
_f( 'AriviaFontPlayerWallet',       { size = 24, weight = 400, antialias = true, shadow = false, font = 'Advent Pro Light' } )
_f( 'AriviaFontOnlineStaff',        { size = 34, weight = 400, antialias = true, shadow = false, font = 'Advent Pro Light' } )
_f( 'AriviaFontCategoryName',       { size = 16, weight = 600, antialias = true, shadow = false, font = 'Roboto' } )
_f( 'AriviaFontObjectListName',     { size = 15, weight = 400, antialias = true, shadow = false, font = 'Roboto' } )
_f( 'AriviaFontObjectPrice',        { size = 20, weight = 300, antialias = true, shadow = true, font = 'Oswald Light' } )
_f( 'AriviaFontObjectLevel',        { size = 15, weight = 300, antialias = true, shadow = true, font = 'Roboto' } )
_f( 'AriviaFontServerInfo',         { size = 22, weight = 300, antialias = true, shadow = false, font = 'Oswald Light' } )
_f( 'AriviaFontStandardText',       { size = 16, weight = 400, antialias = true, shadow = false, font = 'Roboto' } )
_f( 'AriviaFontCardPlayerName',     { size = 26, weight = 300, antialias = true, shadow = false, font = 'Oswald Light' } )
_f( 'AriviaFontCardRank',           { size = 22, weight = 300, antialias = true, shadow = false, font = 'Oswald Light' } )
_f( 'AriviaFontClock',              { size = 34, weight = 100, antialias = true, shadow = false, font = 'Teko Light' } )
_f( 'AriviaFontMenuItem',           { size = 25, weight = 400, antialias = true, shadow = false, font = 'Oswald Light' } )
_f( 'AriviaFontButtonItem',         { size = 18, weight = 200, antialias = true, shadow = false, font = 'Oswald Light' } )
_f( 'AriviaFontMenuSubinfo',        { size = 16, weight = 300, antialias = true, shadow = false, font = 'Oswald Light' } )
_f( 'AriviaFontItemInformation',    { size = 14, weight = 700, antialias = true, shadow = false, font = 'Roboto' } )
_f( 'AriviaFontname',               { size = 34, weight = 400, antialias = true, shadow = false, font = 'Advent Pro Light' } )