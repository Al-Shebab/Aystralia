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

/*
*	declare > cfg
*/

local cfg                   = mod.cfg

/*
*	register > net
*/

util.AddNetworkString( 'AriviaSendTickerData' )

/*
*	ticker > setup
*/

local function ticker_setup( ply, cmd, args )
	local res 	= table.Random( cfg.ticker_msgs )
	local txt 	= res.textNews
	local clr 	= res.textColor or Color( 255, 255, 255 )

	arivia:SendTicker( txt, clr )
end
timer.Create( 'AriviaPrepareTickerData', 1, 0, ticker_setup )

/*
*	ticker > send
*/

function arivia:SendTicker( txt, clr )
	net.Start			( 'AriviaSendTickerData' )
	net.WriteVector		( Vector( clr.r, clr.g, clr.b ) )
	net.WriteString		( txt )
	net.Broadcast		( )
end