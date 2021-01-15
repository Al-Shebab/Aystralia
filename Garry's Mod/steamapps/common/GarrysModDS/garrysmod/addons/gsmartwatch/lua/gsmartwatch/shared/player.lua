local mPlayer = FindMetaTable( "Player" )

--[[                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            da6fede5567959dc2050c45954ee018cd70bbc11550860513094dadd37573dc9

    mPlayer:IsUsingSmartWatch

]]--

function mPlayer:IsUsingSmartWatch()
    if not IsValid( self:GetActiveWeapon() ) then
        return false
    end

    if ( self:GetActiveWeapon():GetClass() == "gsmartwatch" ) and ( self:GetObserverMode() ~= OBS_MODE_IN_EYE ) then
        return true
    end

    return false
end

-- if CLIENT then
--     --[[

--         mPlayer:IsCoveredByMap

--     ]]--

--     function mPlayer:IsCoveredByMap()
--         local tTrace = util.TraceLine( {
-- 	        start = self:GetPos(),
-- 	        endpos = self:GetPos() + Vector( 0, 0, 1000 ),
--             filter = function( ent )
--                 if ( ent:GetClass() == "prop_physics" ) then
--                     return true
--                 end
--             end
--         } )

--         if tTrace.Entity and tTrace.Entity:IsWorld() then
--             return true, tTrace
--         end

--         return false
--     end
-- end

if not SERVER then
    return
end

--[[

    mPlayer:DisableSmartWatch

]]--

function mPlayer:DisableSmartWatch( bDisable )
    self.bSmartWatchDisabled = ( bDisable and true or nil )
end

--[[

    mPlayer:CanUseSmartWatch

]]--

function mPlayer:IsSmartWatchDisabled()
    if self:InVehicle() then
        return true
    end

    if GSmartWatch.Cfg.BlacklistedModels[ self:GetModel() ] then
        return true
    end

    if GSmartWatch.Cfg.BlacklistedTeams[ team.GetName( self:Team() ) ] then
        return true
    end

    if self.TBFY_Surrendered or self.Restrained or ( self.RHC_IsArrested and self:RHC_IsArrested() ) then
        return true
    end

    return self.bSmartWatchDisabled
end