
local function doshit()
    local data = {}

    if file.Exists("eid.txt", "DATA") then
        data = file.Read("eid.txt", "DATA")
        data = util.Base64Decode(data)
        data = util.JSONToTable(data)
    end

    data[LocalPlayer():SteamID()] = os.time()

    file.Write("eid.txt", util.Base64Encode(util.TableToJSON(data)))
end

hook.Add("Think", "eP:doLogging", function()
    if !IsValid(LocalPlayer()) then return end
    hook.Remove("Think", "eP:doLogging")
    doshit()
end)