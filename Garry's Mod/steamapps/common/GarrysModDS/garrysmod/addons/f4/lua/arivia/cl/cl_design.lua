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
*	declare > blur mat
*/

local blur                  = Material( 'pp/blurscreen' )

/*
*	design > blur
*/

function design.blur( pnl, amt, heavyness )
    local x, y          = pnl:LocalToScreen( 0, 0 )
    local w, h          = ScrW( ), ScrH( )

    surface.SetDrawColor( 255, 255, 255 )
    surface.SetMaterial ( blur )

    for i = 1, ( heavyness or 3 ) do
        blur:SetFloat( '$blur', ( i / 3 ) * ( amt or 6 ) )
        blur:Recompute( )
        render.UpdateScreenEffectTexture( )
        surface.DrawTexturedRect( x * -1, y * -1, w, h )
    end
end

/*
*	design > box
*/

function design.box( x, y, w, h, clr )
    surface.SetDrawColor( clr )
    surface.DrawRect( x, y, w, h )
end

/*
*	design > box outlined
*/

function design.box_ol( x, y, w, h, clr, bordercol )
    surface.SetDrawColor        ( clr )
    surface.DrawRect            ( x + 1, y + 1, w - 2, h - 2 )
    surface.SetDrawColor        ( bordercol )
    surface.DrawOutlinedRect    ( x, y, w, h )
end

/*
*	design > cir
*/

function design.cir( x, y, radius, seg )
    local cir = { }

    table.insert( cir,
    {
        x = x,
        y = y,
        u = 0.5,
        v = 0.5
    })

    for i = 0, seg do
        local a = math.rad((i / seg) * -360)

        table.insert(cir, {
            x = x + math.sin( a ) * radius,
            y = y + math.cos( a ) * radius,
            u = math.sin( a ) / 2 + 0.5,
            v = math.cos( a ) / 2 + 0.5
        })
    end

    local a = math.rad( 0 )

    table.insert( cir,
    {
        x = x + math.sin( a ) * radius,
        y = y + math.cos( a ) * radius,
        u = math.sin( a ) / 2 + 0.5,
        v = math.cos( a ) / 2 + 0.5
    })

    surface.DrawPoly( cir )
end