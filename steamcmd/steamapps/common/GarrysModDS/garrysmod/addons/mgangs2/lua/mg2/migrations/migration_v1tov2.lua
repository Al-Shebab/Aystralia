--[[
    MGangs 2 - (SV) MIGRATION : V1ToV2
    Developed by Zephruz
]]

local V1TOV2_MIGRATION = zlib.data:CreateMigration("mg2.V1ToV2")
V1TOV2_MIGRATION:SetDescription("Migrates (mGangs 2) V1 data to V2.")

--[[
    V1TOV2_MIGRATION:onRun()
]]
function V1TOV2_MIGRATION:onRun()
    self:SetActiveConnection(zlib.data:LoadType("sqlite")) // Set active/current connection

    // Core migration
    self:MigrateGangs() // Migrate gangs (and groups)
    self:MigratePlayers() // Migrate players (and invites)

    // Module migration
    self:MigrateTerritories() // Migrate territories
    self:MigrateAssocations() // Migrate associations
    self:MigrateStashes() // Migrate stashes
end

--[[
    V1TOV2_MIGRATION:MigrateGangs()

    - Migrates all gang data
]]
function V1TOV2_MIGRATION:MigrateGangs()
    local dType = zlib.data:GetConnection("mg2.Main")

    -- Backup & migrate gang groups
    self:backupTable("mg2_ganggroups",
    function(data)
        local groups = {}

        -- Sort groups by gang ID
        for k,v in pairs(data) do
            if !(istable(v)) then continue end

            local id, gid = v.id, v.gangid

            groups[gid] = (groups[gid] or {})
            groups[gid][id] = v
        end

        -- Backup & migrate gangs
        self:backupTable("mg2_gangdata",
        function(data)
            for k,v in pairs(data) do
                local id = (istable(v) && v.id)
    
                if !(id) then return end
    
                -- Migrate gang
                local tempGang = mg2.gang:SetupTemporary({
                    ID = id,
                    Name = (v.name || "ERR"),
                    Level = (v.level || 1),
                    EXP = (v.exp || 0),
                    Balance = (v.balance || 0),
                    Icon = (v.icon_url || "https://zephruz.net/img/mgangs2_logo.png")
                })
                
                if !(tempGang) then continue end
                
                local tgData = tempGang:getValidatedData()
                local gData = zlib.util:Serialize(istable(tgData) && tgData || {})

                dType:Query(string.format("INSERT INTO mg2_gangs (id, data) VALUES (%s, '%s')", dType:EscapeString(v.id), gData),
                nil, function(err)
                    if !(err) then err = "Unknown" end

                    mg2:ConsoleMessage("Error migrating gang : " .. err)
                end)

                -- Migrate groups
                local gGroups = groups[id]
                    
                if !(gGroups) then return end

                for k,v in pairs(gGroups) do
                    if !(istable(v)) then continue end
                    
                    local id, gid = v.id, v.gangid

                    if (!id or !gid) then continue end
                    
                    local tempGroup = mg2.gang:SetupTemporaryGroup({
                        ID = id,
                        GangID = gid,
                        IsLeader = (v.grouptype && v.grouptype == 2),
                        IsRecruit = (v.grouptype && v.grouptype == 1),
                        Name = (v.name || "ERR"),
                        Icon = (v.icon || "icon16/user.png"),
                        Priority = (v.priority || 0)
                    })

                    if !(tempGroup) then continue end

                    local gData = (tempGroup:getValidatedData() || {})

                    dType:Query(string.format("INSERT INTO mg2_groups (id, gang_id, data) VALUES (%s, %s, '%s')", dType:EscapeString(id), dType:EscapeString(gid), gData))
                end
            end
        end)
    end)
end

--[[
    V1TOV2_MIGRATION:MigratePlayers()

    - Migrates all player data
]]
function V1TOV2_MIGRATION:MigratePlayers()
    local dType = zlib.data:GetConnection("mg2.Main")

    -- Backup & migrate gang groups
    self:backupTable("mg2_playerinvites",
    function(data)
        local gInvites = {}

        for k,v in pairs(data) do
            if !(istable(v)) then continue end

            local id, stid = v.id, v.steamid

            gInvites[stid] = (gInvites[stid] or {})
            gInvites[stid][id] = v
        end

        self:backupTable("mg2_playerdata",
        function(data)
            for k,v in pairs(data) do
                if !(istable(v)) then continue end
    
                local stid, gid, grpid = v.steamid, v.gangid, v.group
    
                if (!stid or !(gid && grpid)) then continue end
    
                -- Add into users
                local data = (({name = (v.name || "ERR")}) || "")

                dType:Query(string.format("INSERT INTO mg2_users (steamid, gang_id, group_id, data) VALUES (%s,%s,%s,'%s')", 
                    dType:EscapeString(stid), dType:EscapeString(gid), dType:EscapeString(grpid), data),
                nil,
                function(err)
                    if (#({string.match(err, "duplicate")}) > 0) then
                        dType:Query(string.format("UPDATE mg2_users SET gang_id = %s, group_id = %s, data = %s WHERE steamid = %s", 
                            dType:EscapeString(gid), dType:EscapeString(grpid), data, dType:EscapeString(stid)))
                    end
                end)

                -- Migrate gang invites
                local invites = gInvites[stid]

                if (invites) then
                    for _,v in pairs(invites) do
                        if !(istable(v)) then continue end

                        local gid, oData = v.gangid, (v.data && zlib.util:Deserialize(v.data) || {})
                        local data = (({ date = os.time(), name = (oData.gang_name || "ERR") }) || "")

                        dType:Query(string.format("INSERT INTO mg2_invites (invitee_steamid, inviter_steamid, gang_id, data) VALUES (%s, %s, %s, '%s')", 
                            dType:EscapeString(stid), dType:EscapeString(oData.inv_stid || ""), dType:EscapeString(gid), data))
                    end
                end
            end
        end)
    end)
end

--[[
    V1TOV2_MIGRATION:MigrateAssocations()

    - Migrates all gangs associations
]]
function V1TOV2_MIGRATION:MigrateAssocations()
    if !(MG2_ASSOCIATIONS) then return end

    local dType = zlib.data:GetConnection("mg2.Main")

    -- Backup & migrate gang associations
    self:backupTable("mg2_gangassociations",
    function(data)
        for k,v in pairs(data) do
            if !(istable(v)) then continue end

            local types = {"Neutral", "Allies", "Enemies"}
            local gid1, gid2, aType, oData = v.gid1, v.gid2, v.type, (zlib.util:Deserialize(v.data) || {})
            
            if (!gid1 or !gid2) then return end
            
            local tempAssoc = MG2_ASSOCIATIONS:SetupTemporary({
                Name = "Association #" .. (k || 0),
                Association = (aType && types[atype] || "Neutral"),
                WarStatus = (v.atWar && v.atWar == "true"),
                Gangs = {[gid1] = true, [gid2] = true}
            })

            local taData = zlib.util:Serialize(tempAssoc && tempAssoc:getValidatedData() || {}, nil, false, true)

            dType:Query(string.format("INSERT INTO mg2_associations (gang_id1, gang_id2, data) VALUES (%s, %s, '%s')",
                dType:EscapeString(gid1), dType:EscapeString(gid2), taData))
        end
    end)
end

--[[
    V1TOV2_MIGRATION:MigrateTerritories()

    - Migrates all territories
]]
function V1TOV2_MIGRATION:MigrateTerritories()
    if !(MG2_TERRITORIES) then return end

    -- Read old territories
    local fData = zlib.data:LoadType("file"):Read("mgangs/territories/saved_terrs.txt")
    fData = (fData && zlib.util:Deserialize(fData) || {})

    for k,v in pairs(fData) do
        if !(istable(v)) then continue end

        local col = (v.color || {r = 255, g = 255, b = 255, a = 255})
        col = Color(col.r || 255, col.g || 255, col.b || 255, col.a || 255)

        MG2_TERRITORIES:Create({
            Name = (v.name || "ERR"),
            Description = (v.desc || "ERR"),
            Color = col,
            Position = (v.flag && v.flag.pos || Vector(0,0,0)),
            Bounds =  (v.boxPos || {Vector(0,0,0), Vector(0,0,0)})
        })
    end
end

--[[
    V1TOV2_MIGRATION:MigrateStashes()

    - Migrates all gang stashes
]]
function V1TOV2_MIGRATION:MigrateStashes()
    if !(MG2_STASH) then return end

    -- Backup & migrate gang associations
    self:backupTable("mg2_gangstashitems",
    function(data)
        for k,v in pairs(data) do
            if !(istable(v)) then continue end

            local gid, class, model, data = v.gangid, v.class, v.model, (v.data && zlib.util:Deserialize(v.data) || {})

            if !(gid) then continue end

            MG2_STASH:DepositItem(gid, {
                ItemData = data,
                Model = model,
                Class = class,
                Name = class
            })
        end
    end)
end

--[[
    V1TOV2_MIGRATION:onReverse()
]]
function V1TOV2_MIGRATION:onReverse() 
end