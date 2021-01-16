eProtect = eProtect or {}
eProtect.data = eProtect.data or {}
eProtect.data.ipLogging = eProtect.data.ipLogging or {}

local function logIP(ply, ip, contryCode)
    if !ply or !ply:IsPlayer() then return end
    file.CreateDir("eprotect/ips")
    local data = {}
    local filename = "eprotect/ips/"..ply:SteamID64()..".json"

    if file.Exists(filename, "DATA") then
        data = file.Read(filename, "DATA")
        data = util.JSONToTable(data)
    end

    if !data[ip] then
        eProtect.queueNetworking(nil, "ipLogging")
    end

    data[ip] = {contryCode, os.time()}

    file.Write(filename, util.TableToJSON(data))

    eProtect.data.ipLogging[ply:SteamID()] = data
end

local function handleIPLoggin(ply, ip)
    http.Fetch("http://ip-api.com/json/"..ip, function(json)
        json = util.JSONToTable(json)
        local result = json["countryCode"]

        if !result then result = "N/A" end

        logIP(ply, ip, result)
    end, function()
        logIP(ply, ip, "N/A")
    end)
end

hook.Add("PlayerInitialSpawn", "eP:IPLogging", function(ply)
    local ip = ply:IPAddress()
    
    local tblstr = string.ToTable(ip)

    ip = ""
    for k,v in pairs(tblstr) do
        if v == ":" then break end

        ip = ip..v
    end

    handleIPLoggin(ply, ip)
end)

if eProtect.queueNetworking then
    eProtect.queueNetworking(nil, "ipLogging")
end