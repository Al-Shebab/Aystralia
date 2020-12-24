if CLIENT then return end

zfs = zfs or {}
zfs.f = zfs.f or {}

///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
ZFS_NW_TIMEOUT = 0.1

function zfs.f.NW_Player_Timeout(ply)
    local Timeout = false

    if ply.zfs_NWTimeout and ply.zfs_NWTimeout > CurTime() then
        Timeout = true
    end

    ply.zfs_NWTimeout = CurTime() + ZFS_NW_TIMEOUT

    return Timeout
end
///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
if zfs_PlayerList == nil then
    zfs_PlayerList = {}
end

function zfs.f.Add_Player(ply)
    zfs.f.Debug("zfs.f.Add_Player: " .. tostring(ply))
    zfs_PlayerList[ply:SteamID()] = ply
end

util.AddNetworkString("zfs_Player_Initialize")
net.Receive("zfs_Player_Initialize", function(len, ply)

    if ply.zfs_HasInitialized then
        return
    else
        ply.zfs_HasInitialized = true
    end

    zfs.f.Debug("zfs_Player_Initialize Netlen: " .. len)

    if IsValid(ply) then
        zfs.f.Add_Player(ply)
    end
end)
///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////


gameevent.Listen("player_disconnect")
hook.Add("player_disconnect", "a_zfs_player_disconnect", function(data)
    local steamid = data.networkid

    zfs_PlayerList[steamid] = nil

    zfs.f.Player_CleanUp(steamid)

    local shop = zfs.Shop_Interactions[steamid]
    zfs.Shop_Interactions[steamid] = nil

    if IsValid(shop) then
        zfs.f.Shop_ForceReset(shop)
    end

    zfs.f.FruitCup_Interaction_Stop(steamid)
end)

hook.Add("PostPlayerDeath", "a_zfs_PostPlayerDeath", function(ply, text)
    if IsValid(ply) then
        if IsValid(zfs.Shop_Interactions[ply:SteamID()]) then
            zfs.f.Shop_ForceReset(zfs.Shop_Interactions[ply:SteamID()])
        end

        zfs.f.FruitCup_Interaction_Stop(ply:SteamID())
    end
end)

hook.Add("PlayerSilentDeath", "a_zfs_PlayerSilentDeath", function(ply, text)
    if IsValid(ply) then
        if IsValid(zfs.Shop_Interactions[ply:SteamID()]) then
            zfs.f.Shop_ForceReset(zfs.Shop_Interactions[ply:SteamID()])
        end

        zfs.f.FruitCup_Interaction_Stop(ply:SteamID())
    end
end)

hook.Add("PlayerDeath", "a_zfs_PlayerDeath", function(victim, inflictor, attacker)
    if IsValid(victim) then
        if IsValid(zfs.Shop_Interactions[victim:SteamID()]) then
            zfs.f.Shop_ForceReset(zfs.Shop_Interactions[victim:SteamID()])
        end

        zfs.f.FruitCup_Interaction_Stop(victim:SteamID())
    end
end)


local zfs_player_cleanupents = {}
zfs_player_cleanupents["zfs_shop"] = true
zfs_player_cleanupents["zfs_fruitbox"] = true
zfs_player_cleanupents["zfs_mixer"] = true
zfs_player_cleanupents["zfs_topping"] = true
zfs_player_cleanupents["zfs_sweetener_base"] = true

function zfs.f.Player_CleanUp(ply_id)
    for k, v in pairs(zfs.EntList) do
        if IsValid(v) and zfs_player_cleanupents[v:GetClass()] then
            local id = v:GetNWString("zfs_Owner", "nil")

            if ply_id == id then
                v:Remove()
            end
        end
    end
end

hook.Add("OnPlayerChangedTeam", "a_zfs_OnPlayerChangedTeam", function(ply, before, after)
    if zfs.config.Jobs[before] then
        zfs.f.Player_CleanUp(ply:SteamID())
    end
end)
