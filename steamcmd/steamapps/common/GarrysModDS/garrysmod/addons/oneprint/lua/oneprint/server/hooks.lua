local tHook = {}

if DarkRP then
    tHook[ "playerBoughtCustomEntity" ] = function( pPlayer, tEntTable, eEntity, iPrice )
        if ( eEntity:GetClass() == "oneprint" ) then
            eEntity:SetOwnerObject( pPlayer )
            eEntity:CPPISetOwner( pPlayer )

            pPlayer.tOwnedPrinters = ( pPlayer.tOwnedPrinters or {} )
            table.insert( pPlayer.tOwnedPrinters, eEntity )

            if GSmartWatch then
                OnePrint:UpdateGSmartWatch( pPlayer )
            end            
        end
    end
end

tHook[ "PlayerSpawnedSENT" ] = function( pPlayer, eEntity )
    if ( eEntity:GetClass() == "oneprint" ) then
        eEntity:SetOwnerObject( pPlayer )

        pPlayer.tOwnedPrinters = ( pPlayer.tOwnedPrinters or {} )
        table.insert( pPlayer.tOwnedPrinters, eEntity )

        if GSmartWatch then
            OnePrint:UpdateGSmartWatch( pPlayer )
        end
    end
end

for k, v in pairs( tHook ) do
    hook.Add( k, "OnePrint_" .. k, v )
end