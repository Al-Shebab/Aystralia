eProtect = eProtect or {}
eProtect.data = eProtect.data or {}
eProtect.data.punishmentLogging = eProtect.data.punishmentLogging or {}
local punished = {}

eProtect.logDetection = function(ply, reason, info, type)
    if eProtect.data.general["bypassgroup"][ply:GetUserGroup()] then return end
    if punished[ply] then return end
    punished[ply] = true
    eProtect.data.punishmentLogging[#eProtect.data.punishmentLogging + 1] = {ply = ply:Nick(), reason = reason, info = info, type = type}
    eProtect.queueNetworking(nil, "punishmentLogging")
end

if eProtect.queueNetworking then
    eProtect.queueNetworking(nil, "punishmentLogging")
end