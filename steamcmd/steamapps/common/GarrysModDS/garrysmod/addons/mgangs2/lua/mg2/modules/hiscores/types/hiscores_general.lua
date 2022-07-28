--[[
    MGangs 2 - HISCORES - (SH) TYPE: General
    Developed by Zephruz
]]


--[[Most Members]]
local HI_MOSTMEMBERS = MG2_HISCORES:RegisterType("mg2.MostMembers")
HI_MOSTMEMBERS:SetName(mg2.lang:GetTranslation("hiscores.MostMembers"))
HI_MOSTMEMBERS:SetIcon("icon16/group.png")
HI_MOSTMEMBERS:SetEnabled(true)

function HI_MOSTMEMBERS:onUserRequest(ply, cb) 
    if !(SERVER) then return end

    local dtype = zlib.data:GetConnection("mg2.Main")

    if !(dtype) then return end

    dtype:Query(
        [[SELECT 
            gang.id AS gangid,
            gang.data AS gangdata,
            COUNT(users.steamid) AS val
        FROM 
            mg2_users users
            JOIN mg2_gangs gang ON (gang.id = users.gang_id)
        GROUP BY gang.id 
        ORDER BY val DESC 
        LIMIT 3]],
        function(data)
            if !(data) then cb(false) return end

            local toSend = {}

            for k,v in pairs(data) do
                v.val = (v.val .. " " .. (v.val > 1 && mg2.lang:GetTranslation("members") || mg2.lang:GetTranslation("member")))
                v.gangdata = zlib.util:Deserialize(v.gangdata)

                if (v.gangdata) then
                    v.gangname = v.gangdata.Name || "UNKNOWN"
                end

                toSend[k] = v
            end

            cb(toSend)
        end
    )
end

--[[Most Stash Items]]
local HI_MOSTSTASHITEMS = MG2_HISCORES:RegisterType("mg2.MostStashItems")
HI_MOSTSTASHITEMS:SetName(mg2.lang:GetTranslation("hiscores.MostStashItems"))
HI_MOSTSTASHITEMS:SetIcon("icon16/briefcase.png")
HI_MOSTSTASHITEMS:SetEnabled(true)

function HI_MOSTSTASHITEMS:hasRequirement()
    return (MG2_STASH != nil)
end

function HI_MOSTSTASHITEMS:onUserRequest(ply, cb) 
    if !(SERVER) then return end

    local dtype = zlib.data:GetConnection("mg2.Main")

    if !(dtype) then return end

    dtype:Query(
        [[SELECT 
            gang.id AS gangid,
            gang.data AS gangdata,
            COUNT(items.id) AS val
        FROM mg2_stashitems items
        JOIN mg2_gangs gang ON (gang.id = items.gang_id)
        GROUP BY gang_id 
        ORDER BY val DESC 
        LIMIT 3]],
        function(data)
            if !(data) then cb(false) return end

            local toSend = {}

            for k,v in pairs(data) do
                v.val = (v.val .. " " .. (v.val > 1 && mg2.lang:GetTranslation("items") || mg2.lang:GetTranslation("item")))
                v.gangdata = zlib.util:Deserialize(v.gangdata)

                if (v.gangdata) then
                    v.gangname = v.gangdata.Name || "UNKNOWN"
                end

                toSend[k] = v
            end

            cb(toSend)
        end
    )
end