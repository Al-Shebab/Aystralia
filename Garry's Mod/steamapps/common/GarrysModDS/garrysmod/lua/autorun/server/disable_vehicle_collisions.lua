hook.Add("PlayerSpawnedVehicle","DisableCollisionVehicle", function(ply, ent)
    if IsValid(ent) then
     ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    end
    end)