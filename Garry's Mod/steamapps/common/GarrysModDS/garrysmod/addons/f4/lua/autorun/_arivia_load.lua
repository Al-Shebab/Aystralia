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

arivia                      = arivia or { }
arivia.core                 = arivia.core or { }
arivia.core.name            = 'Arivia'
arivia.core.folder          = 'arivia'
arivia.core.id              = '1679'
arivia.core.owner           = '76561198066940821'
arivia.core.author          = 'Richard'
arivia.core.build           = '2.1.0'
arivia.core.released        = 'Dec 22, 2020'
arivia.core.site            = 'https://gmodstore.com/scripts/view/' .. arivia.core.id .. '/'
arivia.core.docs            = 'http://arivia.rlib.io/'

/*
*   workshops
*/

arivia.core.workshops =
{
    '2330310887',
}

/*
*   fonts
*/

arivia.core.fonts =
{
    'oswald_light.ttf',
    'adventpro_light.ttf',
    'teko_light.ttf',
}

/*
*   base tables
*/

arivia.pnl                  = arivia.pnl or { }
arivia.tab                  = arivia.tab or { }
arivia.lng                  = arivia.lng or { }
arivia.helper               = arivia.helper or { }
arivia.design               = arivia.design or { }
arivia.history              = arivia.history or { }
arivia.history.jobs         = arivia.history.jobs or { }

arivia.cfg                  = arivia.cfg or { }
arivia.cfg.nav              = arivia.cfg.nav or { }
arivia.cfg.info             = arivia.cfg.info or { }
arivia.cfg.desc             = arivia.cfg.desc or { }
arivia.cfg.servers          = arivia.cfg.servers or { }

arivia.cfg.bg               = arivia.cfg.bg or { }
arivia.cfg.bg.static        = arivia.cfg.bg.static or { }
arivia.cfg.bg.live          = arivia.cfg.bg.live or { }

/*
*   output > header
*/

local resp_hdr =
{
    '\n\n',
    [[.................................................................... ]],
}

/*
*   output > body
*/

local resp_body =
{
    [[[title]........... ]] .. arivia.core.name .. [[ ]],
    [[[build]........... v]] .. arivia.core.build .. [[ ]],
    [[[released]........ ]] .. arivia.core.released .. [[ ]],
    [[[author].......... ]] .. arivia.core.author .. [[ ]],
    [[[website]......... ]] .. arivia.core.site .. [[ ]],
    [[[documentation]... ]] .. arivia.core.docs .. [[ ]],
    [[[owner]........... ]] .. arivia.core.owner .. [[ ]],
}

/*
*   output > footer
*/

local resp_ftr =
{
    [[.................................................................... ]],
}

/*
*   autoloader > server
*/

if SERVER then

    local fol               = arivia.core.folder .. '/'
    local files, folders    = file.Find( fol .. '*', 'LUA' )

    for k, v in pairs( files ) do
        include( fol .. v )
    end

    for _, folder in SortedPairs( folders, true ) do
        if folder == '.' or folder == '..' then continue end

        for _, File in SortedPairs( file.Find( fol .. folder .. '/sh_*.lua', 'LUA' ), true ) do
            AddCSLuaFile( fol .. folder .. '/' .. File )
            include( fol .. folder .. '/' .. File )
            if arivia.cfg.DebugEnabled then
                MsgC( Color( 255, 255, 0 ), '[' .. arivia.core.name .. '] Loading sh: ' .. File .. '\n' )
            end
        end
    end

    for _, folder in SortedPairs( folders, true ) do
        if folder == '.' or folder == '..' then continue end

        for _, File in SortedPairs( file.Find( fol .. folder .. '/sv_*.lua', 'LUA' ), true ) do
            include( fol .. folder .. '/' .. File )
            if arivia.cfg.DebugEnabled then
                MsgC( Color( 255, 255, 0 ), '[' .. arivia.core.name .. '] Loading sv: ' .. File .. '\n' )
            end
        end
    end

    for _, folder in SortedPairs( folders, true ) do
        if folder == '.' or folder == '..' then continue end

        for _, File in SortedPairs( file.Find( fol .. folder .. '/cl_*.lua', 'LUA' ), true ) do
            AddCSLuaFile( fol .. folder .. '/' .. File )
            if arivia.cfg.DebugEnabled then
                MsgC( Color( 255, 255, 0), '[' .. arivia.core.name .. '] Loading cl: ' .. File .. '\n' )
            end
        end
    end

    for _, folder in SortedPairs( folders, true ) do
        if folder == '.' or folder == '..' then continue end

        for _, File in SortedPairs( file.Find( fol .. folder .. '/vgui_*.lua', 'LUA'), true ) do
            AddCSLuaFile( fol .. folder .. '/' .. File )
            if arivia.cfg.DebugEnabled then
                MsgC( Color( 255, 255, 0), '[' .. arivia.core.name .. '] Loading cl: ' .. File .. '\n' )
            end
        end
    end

end

/*
*   autoloader > client
*/

if CLIENT then

    local root              = arivia.core.folder .. '/'
    local _, folders        = file.Find( root .. '*', 'LUA' )

    for _, folder in SortedPairs( folders, true ) do
        if folder == '.' or folder == '..' then continue end

        for _, File in SortedPairs( file.Find( root .. folder .. '/sh_*.lua', 'LUA' ), true ) do
            include( root .. folder .. '/' .. File )
            if arivia.cfg.DebugEnabled then
                MsgC( Color( 255, 255, 0 ), '[' .. arivia.core.name .. '] Loading sh: ' .. File .. '\n' )
            end
        end
    end

    for _, folder in SortedPairs( folders, true ) do
        for _, File in SortedPairs( file.Find( root .. folder .. '/cl_*.lua', 'LUA' ), true ) do
            include( root .. folder .. '/' .. File )
            if arivia.cfg.DebugEnabled then
                MsgC( Color( 255, 255, 0 ), '[' .. arivia.core.name .. '] Loading cl: ' .. File .. '\n' )
            end
        end
    end

    for _, folder in SortedPairs( folders, true ) do
        for _, File in SortedPairs( file.Find( root .. folder .. '/vgui_*.lua', 'LUA' ), true ) do
            include( root .. folder .. '/' .. File )
            if arivia.cfg.DebugEnabled then
                MsgC( Color( 255, 255, 0 ), '[' .. arivia.core.name .. '] Loading VGUI: ' .. File .. '\n' )
            end
        end
    end

end

/*
*   resources > fastdl
*/

if arivia.cfg.fastdl_enabled then

    local sfolder = arivia.core.folder or ''

    local materials = file.Find( 'materials/' .. sfolder .. '/*', 'GAME' )
    if #materials > 0 then
        for _, m in pairs( materials ) do
            resource.AddFile( 'materials/' .. sfolder .. '/' .. m )
            if arivia.cfg.DebugEnabled then
                MsgC( Color( 255, 255, 0 ), '[' .. arivia.core.name .. '] Loading Material: ' .. m .. '\n' )
            end
        end
    end

    local sounds = file.Find( 'sound/' .. sfolder .. '/*', 'GAME' )
    if #sounds > 0 then
        for _, m in pairs( sounds ) do
            resource.AddFile( 'sound/' .. sfolder .. '/' .. m )
            if arivia.cfg.DebugEnabled then
                MsgC( Color( 255, 255, 0 ), '[' .. arivia.core.name .. '] Loading Sounds: ' .. m .. '\n' )
            end
        end
    end

    local fonts = file.Find( 'resource/fonts/*', 'GAME' )
    if #fonts > 0 then
        for _, f in pairs( fonts ) do
            if table.HasValue( arivia.core.fonts, f ) then
                resource.AddFile( 'resource/fonts/' .. f )
                if arivia.cfg.DebugEnabled then
                    MsgC( Color( 255, 255, 0 ), '[' .. arivia.core.name .. '] Loading Font: ' .. f .. '\n' )
                end
            end
        end
    end

end

/*
*   resources > workshop
*/

if arivia.cfg.ws_enabled and arivia.core.workshops then
    for k, v in pairs( arivia.core.workshops ) do
        if not arivia.cfg.ws_mount_enabled and SERVER then
            resource.AddWorkshop( v )
            if arivia.cfg.DebugEnabled then
                MsgC( Color( 0, 255, 255 ), '[' .. arivia.core.name .. '] Mounting Workshop: ' .. v .. '\n' )
            end
        elseif arivia.cfg.ws_mount_enabled and CLIENT then
            if CLIENT then
                steamworks.FileInfo( v, function( res )
                    steamworks.Download( res.fileid, true, function( name )
                        game.MountGMA( name )
                        if arivia.cfg.DebugEnabled then
                            local size = res.size / 1024
                            MsgC( Color( 0, 255, 255 ), '[' .. arivia.core.name .. '] Mounting Workshop: ' .. res.title .. ' ( ' .. math.Round( size ) .. 'KB )\n' )
                        end
                    end )
                end )
            end
        end
    end
end

/*
*   output
*/

for k, i in ipairs( resp_hdr ) do
    MsgC( Color( 255, 255, 0 ), i .. '\n' )
end

for k, i in ipairs( resp_body ) do
    MsgC( Color( 255, 255, 255 ), i .. '\n' )
end

for k, i in ipairs( resp_ftr ) do
    MsgC( Color( 255, 255, 0 ), i .. '\n\n' )
end