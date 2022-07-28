--[[
    MGangs 2 - GANGSIGN - (SV) Init
    Developed by Zephruz
]]

--[[
    MG2_GANGSIGN:SpawnSign(gangid [int], forceSpawn [bool = false])

    - Spawns a gang sign
    - If forceSpawn = true; it will ignore the max sign limit in the config and not charge the gang
]]
function MG2_GANGSIGN:SpawnSign(gangid, forceSpawn)
    local gang = mg2.gang:Get(gangid)

    if !(gang) then return false end

    local maxSigns, signCost = self.config.maxSigns, self.config.signCost
    local isForced = (forceSpawn == true)
    local gangBal, gangSigns = gang:GetBalance(), table.Count(self:GetSigns(gangid))

    -- Check if it's a forceSpawn
    if !(isForced) then
        -- Check if gang has max signs spawned
        if (maxSigns > 0 && gangSigns >= maxSigns) then return false, mg2.lang:GetTranslation("gangsign.MaxLimit") end

        -- Check if gang can afford
        if (signCost > 0 && gangBal < signCost) then return false, mg2.lang:GetTranslation("gangsign.CantAfford") end
    end

    -- Spawn entity
    local signEnt = ents.Create("mg_sign")
    signEnt:SetGangID(gangid)
    signEnt:Spawn()
    signEnt:Activate()

    if (IsValid(signEnt)) then
        if (!isForced && signCost > 0) then gang:SetBalance(gangBal - signCost) end -- Deduct cost from balance

        return signEnt, mg2.lang:GetTranslation("gangsign.Spawned")
    end

    return false
end

--[[
    Chat commands
]]

--[[
    Chat Command: !buygangsign, !gangsign

    - Used to purchase a gang sign
    - NOTICE: Will likely be moved to a menu in the future
]]
zlib.cmds:RegisterChat({"!buygangsign", "!gangsign"}, nil,
function(ply, cmd, args)
    local gang, gangGroup = ply:GetGang(), ply:GetGangGroup()
    local hasPerm = (gangGroup && gangGroup:GetPermissions("buysign"))

    if (gang && hasPerm) then
        local signEnt, msg = MG2_GANGSIGN:SpawnSign(gang:GetID())

        -- Set sign position & owner
        if (signEnt && IsValid(signEnt)) then
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
    end
end)