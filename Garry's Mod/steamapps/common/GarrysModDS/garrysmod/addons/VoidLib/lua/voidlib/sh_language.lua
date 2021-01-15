
local branch = "master"
local rawUrl = "https://raw.githubusercontent.com/VoidTeam1/VoidLanguages/"
local apiEndpoint = "https://api.github.com/repos/VoidTeam1/VoidLanguages/git/trees/master?recursive=1"

VoidLib.Lang = VoidLib.Lang or {}

if (SERVER) then
    util.AddNetworkString("VoidLib.Lang.NetworkLocalLanguages")

    concommand.Add("voidlib_reloadlangs", function (ply, cmd, args)

        for k, v in pairs(VoidLib.Tracker.Addons) do
            local gTable = _G[k]
            if (!gTable) then continue end

            VoidLib.Lang:LoadLocalLanguages(k, true)

            if (table.Count(gTable.Lang.LocalLanguages) > 0) then
                VoidLib.Lang:NetworkLocalLanguages(k, gTable.Lang.LocalLanguages)
            end
        end

        VoidLib.Print("Successfully reloaded local languages!")
    end)
end

if (CLIENT) then
    net.Receive("VoidLib.Lang.NetworkLocalLanguages", function ()
        local addon = net.ReadString()
        local tbl = VoidLib.ReadCompressedTable()

        local gTable = _G[addon]
        if (!gTable) then return end

        gTable.Lang.Langs = tbl

        gTable.Print("Received local languages from server!")
    end)
end

function VoidLib.Lang:Init(addon, onlyLocal)

    local gTable = _G[addon]
    if (!gTable) then return end

    if (!gTable.Print) then
        function gTable.PrintError(...)
            MsgC(Color(192, 57, 43), "[" .. addon .. "] (ERROR): ", Color(255, 255, 255), ..., "\n")
        end

        function gTable.PrintWarning(...)
            MsgC(Color(230, 126, 34), "[" .. addon .. "] (WARNING): ", Color(255, 255, 255), ..., "\n")
        end

        function gTable.PrintDebug(...)
            if (!gTable.Debug) then return end

            MsgC(Color(120, 255, 120), "[" .. addon .. "] (DEBUG): ", Color(255, 255, 255), ..., "\n")
        end

        function gTable.Print(...)
            -- MsgC(Color(87, 180, 242), "[" .. addon .. "]: ", Color(255, 255, 255), ..., "\n")
        end
    end

    gTable.Lang = gTable.Lang or {}
    gTable.Lang.Langs = gTable.Lang.Langs or {}
    gTable.Lang.AvailableLangs = gTable.Lang.AvailableLangs or {}

    function gTable.Lang.GetPhrase(phrase, x)
        return VoidLib.Lang:GetLangPhrase(addon, phrase, x)
    end

    -- We need to wait until first tick is called because of HTTP API not working yet
    hook.Add("Tick", "VoidLib.Lang.InitTick" .. addon, function ()
        
        hook.Remove("Tick", "VoidLib.Lang.InitTick" .. addon)

        if (onlyLocal) then
            gTable.Print("Dev environment detected, using only local languages!")
            VoidLib.Lang:LoadLanguages(addon)
        else
            VoidLib.Lang:DownloadLanguages(addon, function (failed)
                if (failed) then
                    gTable.PrintWarning("Failed to fetch available languages - using only local languages!")
                end

                timer.Simple(2, function () -- Wait until files are written
                    VoidLib.Lang:LoadLanguages(addon)
                end)
            end)
        end
    end)
end

function VoidLib.Lang:GetAvailableLanguages(addon, callback, failCallback)
    local gTable = _G[addon]
    if (!gTable) then return end
    local url = apiEndpoint
    http.Fetch(url, function (body, size, headers, code)
        -- Success
        if (code != 200 or !body or body == "") then
            gTable.PrintError("Couldn't get available languages - error code " .. code .. " (please try again later)")
            return
        end

        local tbl = util.JSONToTable(body)
        if (!tbl or table.Count(tbl) < 1) then
            gTable.PrintError("Couldn't parse available languages - no languages exist?")
            return
        end

        local langs = {}
        for k, fileTbl in pairs(tbl.tree) do
            if (!string.StartWith(fileTbl.path, addon) or addon == fileTbl.path) then continue end

            local fileName = string.Replace(fileTbl.path, addon .. "/")
            if (fileName == ".gitkeep") then continue end

            local name = string.Replace(fileName, ".json", "")
            langs[#langs + 1] = name
        end

        callback(langs)

    end, function (err)
        -- Failure
        gTable.PrintError("Couldn't get available languages - error: " .. err)
        failCallback()
    end)
end

function VoidLib.Lang:GetLangPhrase(addon, phrase, x)
    local gTable = _G[addon]
    if (!gTable) then return end

    local langRef = gTable.Config.Language
    if (!langRef) then
        gTable.PrintError("Tried to get langauge phrase, but no selected language!")
        return phrase
    end

    -- We don't want the reference
    local lang = string.lower(langRef)

    local langs = gTable.Lang.Langs
    if (!langs) then
        gTable.PrintError("Langs table not initialized yet!")
        return phrase
    end
    
    local returnVal = phrase
    if (langs[lang] and langs[lang][phrase]) then
        -- If the language has the phrase
        returnVal = langs[lang][phrase]
    elseif (langs["english"] and langs["english"][phrase]) then
        -- If not, fallback to english
        returnVal = langs["english"][phrase]
    end

    if (x) then
        returnVal = VoidLib.StringFormat(returnVal, x)
    end

    -- If no langauge has the phrase, return the phrase itself
    return returnVal
end

function VoidLib.Lang:IsLanguageInstalled(addon, lang)
    local langFile = "voidlanguages/" .. addon .. "/" .. lang .. ".json"
    return file.Exists(langFile, "DATA"), langFile
end

function VoidLib.Lang:IsLatest(addon, lang, newLang)
    local isInstalled, path = self:IsLanguageInstalled(addon, lang)
    if (!isInstalled) then return false, false end

    local langContent = file.Read(path)

    local existingLangCRC = util.CRC(langContent)
    local newLangCRC = util.CRC(newLang)

    return newLangCRC == existingLangCRC, true
end

function VoidLib.Lang:WriteLanguage(addon, lang, json)
    if (!file.Exists("voidlanguages", "DATA")) then
        file.CreateDir("voidlanguages")
    end

    if (!file.Exists("voidlanguages/" .. addon, "DATA")) then
        file.CreateDir("voidlanguages/" .. addon)
    end

    file.Write("voidlanguages/" .. addon .. "/" .. lang .. ".json", json)
end

function VoidLib.Lang:LoadLocalLanguages(addon, reload)

    if (!SERVER) then return end

    local gTable = _G[addon]
    if (!gTable) then return end

    local files = file.Find("voidlanguages/" .. addon .. "/*.json", "DATA")
    local langs = {}
    for k, v in pairs(files) do

        local langName = string.Replace(v, ".json", "")
        if (!reload) then
            if (gTable.Lang.Langs[langName]) then continue end
        end

        local json = file.Read("voidlanguages/" .. addon .. "/" .. v)

        local tbl = util.JSONToTable(json)
        local length = table.Count(tbl or {})
        if (!tbl or length < 1) then
            gTable.PrintError("Tried to load " .. v .. ", but langauge file is corrupt/empty!")
            continue
        end

        gTable.PrintDebug("Loaded " .. langName .. " local language! (" .. length .. " phrases)")

        langs[langName] = tbl
    end



    gTable.Lang.LocalLanguages = langs


    VoidLib.Lang:NetworkLocalLanguages(addon, langs)

    local totalLangs = table.Count(langs) 
    if (totalLangs > 0) then
        table.Merge(gTable.Lang.Langs, langs)

        gTable.Print("Loaded " .. totalLangs .. " local languages!")
    end
end

function VoidLib.Lang:NetworkLocalLanguages(addon, tbl, ply)
    if (!SERVER) then return end

    net.Start("VoidLib.Lang.NetworkLocalLanguages")
        net.WriteString(addon)
        VoidLib.WriteCompressedTable(tbl)
    if (ply) then
        net.Send(ply)
    else
        net.Broadcast()
    end
    
end

function VoidLib.Lang:LoadLanguages(addon)

    local gTable = _G[addon]
    if (!gTable) then return end

    for _, lang in pairs(gTable.Lang.AvailableLangs or {}) do
        local langExists, langFile = self:IsLanguageInstalled(addon, lang)
        if (!langExists) then
            gTable.PrintError("Tried to load " .. lang .. ", but langauge is not installed!")
            continue
        end

        local json = file.Read(langFile)
        if (!json or json == "") then
            gTable.PrintError("Tried to load " .. lang .. ", but langauge file is empty!")
            continue
        end
        
        local tbl = util.JSONToTable(json)
        if (!tbl or table.Count(tbl) < 1) then
            gTable.PrintError("Tried to load " .. lang .. ", but langauge file is corrupt/empty!")
            continue
        end

        gTable.Lang.Langs[lang] = tbl

    end

    VoidLib.Lang:LoadLocalLanguages(addon)

    if (table.Count(gTable.Lang.Langs) < 1) then
        gTable.PrintError("Tried to load languages, but none downloaded!")
        return
    end

    gTable.Print("Loaded " .. table.Count(gTable.Lang.Langs) .. " languages!")

    gTable.Lang.LanguagesLoaded = true
    hook.Run(addon .. ".Lang.LanguagesLoaded")
end

function VoidLib.Lang:DownloadLanguages(addon, callback)
    local gTable = _G[addon]
    if (!gTable) then return end


    self:GetAvailableLanguages(addon, function (languages)

        gTable.Lang.AvailableLangs = languages

        local callbacksDone = 0

        if (#languages == 0) then
            callback()
        end

        for _, lang in pairs(languages) do
            local formattedLangName = lang:gsub("^%l", string.upper)
            local url = rawUrl .. branch .. "/" .. addon .. "/" .. lang .. ".json"
            http.Fetch(url, function (body, size, headers, code)

                callbacksDone = callbacksDone + 1
            
                if (code != 200 or !body or body == "") then
                    gTable.PrintError("Couldn't get " .. lang .. " language: " .. code .. " (please try again later)")
                    if (callbacksDone == #languages) then
                        callback()
                    end
                    return
                end

                local tbl = util.JSONToTable(body)
                if (!tbl or table.Count(tbl) < 1) then
                    gTable.PrintError("Couldn't parse language " .. lang .. " - incorrect or empty JSON!")
                    if (callbacksDone == #languages) then
                        callback()
                    end
                    return
                end

                local isLatest, isUpdating = VoidLib.Lang:IsLatest(addon, lang, body)
                if (!isLatest) then
                    local operationString = isUpdating and "Updated" or "Downloaded"
                    gTable.Print(operationString .. " " .. formattedLangName .. " language")

                    self:WriteLanguage(addon, lang, body)
                elseif (gTable.Debug) then
                    gTable.PrintDebug(formattedLangName .. " language is up to date!")
                end

                if (callbacksDone == #languages) then
                    callback()
                end
                

            end, function (err)
                gTable.PrintError("Couldn't download " .. lang .. " language - error: " .. err)
            end)
        end

    end, function ()
        -- Failed
        callback(true)
    end)
end
