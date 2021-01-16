eProtect = eProtect or {}
eProtect.data = eProtect.data or {}
eProtect.data.netLogging = eProtect.data.netLogging or {}

hook.Add("eP:PostNetworking", "eP:LogNetworking", function(ply, net, len)
    if !net or len == nil then return end
    eProtect.data.netLogging[net] = eProtect.data.netLogging[net] or {called = 0, len = 0, playercalls = {}}

    eProtect.data.netLogging[net].called = eProtect.data.netLogging[net].called + 1
    eProtect.data.netLogging[net].len = eProtect.data.netLogging[net].len + len

    if IsValid(ply) and ply:IsPlayer() then
        local sid = ply:SteamID()
        eProtect.data.netLogging[net].playercalls[sid] = eProtect.data.netLogging[net].playercalls[sid] or 0
        eProtect.data.netLogging[net].playercalls[sid] = eProtect.data.netLogging[net].playercalls[sid] + 1
    end

    if eProtect.queueNetworking then
        eProtect.queueNetworking(nil, "netLogging")
    end
end)