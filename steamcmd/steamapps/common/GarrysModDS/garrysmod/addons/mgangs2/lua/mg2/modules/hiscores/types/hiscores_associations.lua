--[[
    MGangs 2 - HISCORES - (SH) TYPE: Associations
    Developed by Zephruz
]]

--[[Most Associations]]
local HI_MOSTASSOCIATIONS = MG2_HISCORES:RegisterType("mg2.MostAssociations")
HI_MOSTASSOCIATIONS:SetName(mg2.lang:GetTranslation("hiscores.MostAssociations"))
HI_MOSTASSOCIATIONS:SetCategory(mg2.lang:GetTranslation("associations"))
HI_MOSTASSOCIATIONS:SetIcon("icon16/heart.png")
HI_MOSTASSOCIATIONS:SetEnabled(true)

function HI_MOSTASSOCIATIONS:hasRequirement()
    return (MG2_ASSOCIATIONS != nil)
end

function HI_MOSTASSOCIATIONS:onUserRequest(ply, cb) 
    if !(SERVER) then return end

    local dtype = zlib.data:GetConnection("mg2.Main")

    if !(dtype) then return end

    dtype:Query(
        [[SELECT 
            gangs.id AS gangid,
            gangs.data AS gangdata,
            COUNT(*) AS val
        FROM 
            mg2_gangs gangs
            JOIN mg2_associations assocs ON (assocs.gang_id1 = gangs.id OR assocs.gang_id2 = gangs.id)
        GROUP BY gangs.id 
        ORDER BY val DESC 
        LIMIT 3]],
        function(data)
            if !(data) then cb(false) return end

            local toSend = {}

            for k,v in pairs(data) do
                v.val = (v.val .. " " .. (v.val > 1 && mg2.lang:GetTranslation("associations") || mg2.lang:GetTranslation("association")))
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