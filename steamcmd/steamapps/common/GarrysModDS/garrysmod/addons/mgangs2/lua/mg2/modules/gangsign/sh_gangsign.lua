--[[
    MGangs 2 - GANGSIGN - (SH) Gang sign
    Developed by Zephruz
]]

--[[
    MG2_GANGSIGN:GetSigns(gangid [int])

    - Returns a table of a gangs signs
]]
function MG2_GANGSIGN:GetSigns(gangid)
    local signs = {}

    for k,v in pairs(ents.FindByClass("mg_sign")) do
        if (IsValid(v) && v:GetGangID() == gangid) then
            table.insert(signs, v)
        end
    end

    return signs
end

--[[
    Permissions
]]

--[[SPAWN GANG SIGN]]
local PERM_BUYGANGSIGN = mg2.gang:RegisterPermission("buysign")
PERM_BUYGANGSIGN:SetName(mg2.lang:GetTranslation("gangsign.Buy"))
PERM_BUYGANGSIGN:SetDescription(mg2.lang:GetTranslation("gangsign.BuyDesc"))

function PERM_BUYGANGSIGN:onCall(ply, cb, data)
    local gang = ply:GetGang()

    if !(gang) then return false end

    local gangid = gang:GetID()
    local signEnt, msg = MG2_GANGSIGN:SpawnSign(gangid)
    local result = (signEnt && IsValid(signEnt))

    -- Set sign position & owner
    if (result) then
        signEnt:SetPos(ply:GetShootPos() + (ply:GetForward() * 96))

        -- Set player as owner (if using FPP/CPPI)
        if (CPPI && signEnt.CPPISetOwner) then
            signEnt:CPPISetOwner(ply)
        end
    end
    
    -- Send notification/message
    if (msg) then
        mg2:SendNotification(ply, msg)
    end

    cb(result)

    return result
end