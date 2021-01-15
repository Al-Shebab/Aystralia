
util.AddNetworkString("VoidLib.Tracker.Notify")
util.AddNetworkString("VoidLib.Tracker.SyncAddon")

VoidLib.Tracker = VoidLib.Tracker or {}

VoidLib.Tracker.Addons = VoidLib.Tracker.Addons or {}
VoidLib.Tracker.BlacklistedAddons = VoidLib.Tracker.BlacklistedAddons or {}

local ADDON_CLASS = {}
ADDON_CLASS.__index = ADDON_CLASS

function ADDON_CLASS:New(addonName, addonID, license)
	local newObject = setmetatable({}, ADDON_CLASS)
		newObject.name = addonName
        newObject.id = addonID
        newObject.license = license
        newObject.ownerNick = "Unknown"
	return newObject
end

function ADDON_CLASS:Track()
    local globalTable = _G[self.name]
    if (!globalTable) then return end

    local version = globalTable.CurrentVersion
    local config = globalTable.Config

    local addonName = self.name
    local addonID = self.id

    local license = self.license
    
    http.Post( "https://voidstudios.dev/tracker/poststatistics", {
        license = tostring(license), 
        ip = game.GetIPAddress(), 
        host = GetHostName(), 
        script = tostring(addonID), 
        version = version, 
        config = util.TableToJSON(config)
    }, function (responseText) 
        if (!responseText or responseText == "") then return end

        local json = util.JSONToTable(responseText) 
        if (!json or !json.status) then return end

        if (json.status == 400) then return end
        if (json.status == "ok") then return end 
        if (json.status == "blacklist") then 
            VoidLib.Tracker:MarkAsLeaked(addonName, json.msg, json.msgP)
        else
            if (!json.msg) then return end
            globalTable.Print(string.format(json.msg, addonName)) 
        end
    end)
end


function VoidLib.Tracker:RegisterAddon(addonName, addonID, license)
    addonID = tonumber(addonID) or 0 -- Test ID
    local addonObj = ADDON_CLASS:New(addonName, addonID, license)

    VoidLib.Tracker.Addons[addonName] = addonObj
    VoidLib.Lang:Init(addonName, license:sub(1, 1) == "{") -- serverside init

    -- steamworks.RequestPlayerInfo(license, function (nick)
    --     VoidLib.Tracker.Addons[addonName].ownerNick = nick
    -- end)

end

hook.Add("PlayerInitialSpawn", "VoidLib.Tracker.SyncClassPlayer", function (ply)
    timer.Simple(5, function ()
        for k, v in pairs(VoidLib.Tracker.Addons) do

            local gTable = _G[k]
            if (!gTable) then continue end

            net.Start("VoidLib.Tracker.SyncAddon")
                net.WriteString(k)
                net.WriteBool(v.license:sub(1, 1) == "{")
            net.Send(ply)

            if (gTable.Lang and gTable.Lang.LocalLanguages and table.Count(gTable.Lang.LocalLanguages) > 0) then
                VoidLib.Lang:NetworkLocalLanguages(k, gTable.Lang.LocalLanguages, ply)
            end
        end
    end)
end)

function VoidLib.Tracker:MarkAsLeaked(addonName, msg, msgPlayers)
    -- Show that the addon is leaked

    msg = msg or "Your server is using an illegal copy of %s. This contains backdoors which allow for remote code execution (RCE). Server and your personal information is at risk! Uninstall this copy as soon as possible and purchase a copy from GModStore!"
    msgPlayers = msgPlayers or "You are playing on a server with an illegal copy of %s. This copy contains malware (backdoors). It might harm your computer. Server and your personal information is at risk!"

    msg = string.format(msg, addonName)
    msgPlayers = string.format(msgPlayers, addonName)

    VoidLib.Tracker.BlacklistedAddons[addonName] = {
        msg = msg,
        msgPlayers = msgPlayers
    }

    VoidLib.Tracker:ShowLeakNotification(addonName, msg, msgPlayers)
end

function VoidLib.Tracker:ShowLeakNotification(addonName, msg, msgPlayers)
    local globalTable = _G[addonName]
    if (!globalTable) then return end

    globalTable.PrintError(msg)

    local license = "Modified copy"
    local licenseNick = "Unknown"

    local addonInfo = VoidLib.Tracker.Addons[addonName]
    if (addonInfo) then
        licenseNick = addonInfo.ownerNick
        license = addonInfo.license
    end

    net.Start("VoidLib.Tracker.Notify")
        net.WriteString(msgPlayers)
        net.WriteString(addonName)
        net.WriteString(license)
        net.WriteString(licenseNick)
    net.Broadcast()
end

function VoidLib.Tracker:PerformTracking()
    for id, addon in pairs(VoidLib.Tracker.Addons) do
        addon:Track()
    end

    for addonName, tbl in pairs(VoidLib.Tracker.BlacklistedAddons) do
        VoidLib.Tracker:ShowLeakNotification(addonName, tbl.msg, tbl.msgPlayers)
    end
end



function VoidLib.Tracker:IsTracked(addonID)
    return VoidLib.Tracker.Addons[addonID] and true or false
end

local ignoredAddons = {
    ["VoidCases"] = true,
    ["VoidChar"] = true
}

-- Is this even needed?
-- timer.Simple(20, function ()
--     -- Check for addons without a tracker

--     http.Fetch("https://m0uka.xyz/dashboard/trackeraddons", function (body, size, headers, code)
--         if (code == 200 and body) then
--             local tbl = util.JSONToTable(body)
--             local data = tbl.data

--             for _, v in pairs(data) do

--                 local teamName = string.lower(v.team.name)
--                 if (!string.find(teamName, "void")) then continue end -- Include only VoidTeam addons
                
--                 local isTracked = VoidLib.Tracker:IsTracked(v.id)
--                 if (!isTracked) then
--                     local nameTbl = string.Explode(" ", v.name)
--                     local addonName = nil
--                     local isVoid = false
--                     for k, word in pairs(nameTbl) do
--                         if (string.StartWith(word, "Void")) then
--                             isVoid = true
--                             addonName = word
--                         end
--                     end

--                     if (isVoid and !ignoredAddons[addonName]) then
--                         VoidLib.Tracker:MarkAsLeaked(addonName)
--                     end

--                 end
--             end
--         end
--     end)
-- end)

timer.Create("VoidLib.TrackAddons", 300, 0, function()
    VoidLib.Tracker:PerformTracking()
end)