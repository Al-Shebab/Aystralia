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
*	history > storage
*
*   returns tab history of player.
*   storage history saves data related to which tabs a player has expanded or collapsed
*
*   @param  : ply pl
*/

function mod.history:Storage( pl )
    pl                          = helper.plok( pl ) and pl or LocalPlayer( )

    pl.arivia                   = pl.arivia or { }
    pl.arivia.history           = pl.arivia.history or { }
    pl.arivia.history.expanded  = pl.arivia.history.expanded or { }

    return pl.arivia
end

/*
*	history > jobs > create id
*
*   @param  : str title
*/

function mod.history.jobs:CreateID( title )
    local cat   = title
    cat         = helper.strclean( cat )

    return cat
end

/*
*	history > jobs > registered
*
*   @param  : str id
*   @return : bool
*/

function mod.history.jobs:Registered( id )
    local pl        = LocalPlayer( )
    mod.history:Storage( pl )

    return pl.arivia.history.expanded[ id ] and true or false
end

/*
*	history > jobs > get state
*/

function mod.history.jobs:GetState( id )
    local pl        = LocalPlayer( )
    mod.history:Storage( pl )

    return pl.arivia.history.expanded[ id ]
end

/*
*	history > jobs > clear
*/

function mod.history.jobs:Clear( )
    local pl        = LocalPlayer( )
    mod.history:Storage( pl )

    pl.arivia.history.expanded = { }
end

/*
*	history > jobs > write expanded
*/

function mod.history.jobs:WriteExpanded( id, pnl, val )
    local pl        = LocalPlayer( )
    mod.history:Storage( pl )

    pl.arivia.history.expanded[ id ] = val
end