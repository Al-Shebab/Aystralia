------------------------------------------------------                                   
-- NO NOT TOUCH ANYTHING IN HERE!!!!!!!!!                                                  
------------------------------------------------------                  
              
eProtect = eProtect or {}

eProtect.BaseConfig = eProtect.BaseConfig or {}

eProtect.BaseConfig["disable-all-networking"] = {false, 1}

eProtect.BaseConfig["automatic-identifier"] = {true, 2}

eProtect.BaseConfig["notification-groups"] = {{["superadmin"] = true}, 3, CAMI and CAMI.GetUsergroups and function() local tbl = {} for k,v in pairs(CAMI.GetUsergroups()) do tbl[k] = true end return tbl end or {}}

eProtect.BaseConfig["ratelimit"] = {500, 4, {min = -1, max = 100000}}

eProtect.BaseConfig["timeout"] = {3, 5, {min = 0, max = 5000}}

eProtect.BaseConfig["overflowpunishment"] = {2, 6, {min = 0, max = 2}}

eProtect.BaseConfig["whitelistergroup"] = {{}, 7, function()
    local list = {}

    if CAMI and CAMI.GetUsergroups then
        for k,v in pairs(CAMI.GetUsergroups()) do
            list[k] = true
        end
    end

    return list
end}

eProtect.BaseConfig["bypassgroup"] = {{}, 8, function()
    local list = {
        ["superadmin"] = true,
        ["owner"] = true
    }

    if CAMI and CAMI.GetUsergroups then
        for k,v in pairs(CAMI.GetUsergroups()) do
            list[k] = true
        end
    end

    return list
end}

eProtect.BaseConfig["httpfocusedurlsisblacklist"] = {true, 9}

eProtect.BaseConfig["httpfocusedurls"] = {{}, 10, function()
    local list = {}

    if eProtect.data.httpLogging then
        for k,v in pairs(eProtect.data.httpLogging) do
            list[k] = true
        end
    end

    return list
end}

------------------------------------------------------           
-- NO NOT TOUCH ANYTHING IN HERE!!!!!!!!!                                                  
------------------------------------------------------76561198166995690