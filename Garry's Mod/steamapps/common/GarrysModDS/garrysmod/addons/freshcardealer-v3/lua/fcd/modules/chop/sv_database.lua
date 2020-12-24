local tr = 'tupacscripts/freshcardealer_revamped'

function fcd.chopShopInit()
    if !file.Exists( tr .. '/chop_shop_npcs_' .. game.GetMap(  ) .. '.txt', 'DATA' ) then
        file.Write( tr .. '/chop_shop_npcs_' .. game.GetMap(  ) .. '.txt', '[]' )
    end
end

hook.Add( 'DarkRPDBInitialized', 'fcd.chopShopInit', fcd.auctionInit )

function fcd.saveChopShopNPCs()
    local save = {}

    for i, v in pairs( ents.FindByClass( 'chopshop' ) ) do
        save[ i ] = {
            pos = v:GetPos(  ),
            ang = v:GetAngles(  ),
        }
    end

    save = util.TableToJSON( save )
    file.Write( tr .. '/chop_shop_npcs_' .. game.GetMap(  ) .. '.txt', save )

    fcd.initChopShopNPCs()
end

function fcd.initChopShopNPCs()
    for i, v in pairs( ents.FindByClass( 'chopshop' ) ) do
        v:Remove()
    end

    local saved = file.Read( tr .. '/chop_shop_npcs_' .. game.GetMap(  ) .. '.txt', 'DATA' )
    if not saved then return end
    if saved == '' then return end
    if string.len( saved ) <= 0 then return end

    saved = util.JSONToTable( saved )

    if !istable( saved ) then return end

    for i, v in pairs( saved ) do
        local ent = ents.Create( 'chopshop' )
        ent:SetPos( v.pos )
        ent:SetAngles( v.ang )
        ent:Spawn()
    end
end

hook.Add( 'InitPostEntity', 'fcd.initChopShopNPCs', fcd.initChopShopNPCs )
