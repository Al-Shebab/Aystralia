--[[
    MGangs 2 - NPC MANAGER - (SH)
    Developed by Zephruz
]]

--[[
    MG2_NPCMANAGER:SetupTemporary(data [table])

    - Sets a temporary npc up
]]
function MG2_NPCMANAGER:SetupTemporary(data)
    local terr = {}

    zlib.object:SetMetatable("mg2.NPCManager", terr)

    if (data) then
        for k,v in pairs(data) do
            terr:setRawData(k,v)
        end
    end

    return terr
end

--[[
    MG2_NPCMANAGER:Setup(id [int], data [table])

    - Sets a npc up with the specified data
]]
function MG2_NPCMANAGER:Setup(id, data)
    if !(id) then return end

    -- Remove previous NPC entity
    local prevNPC = self:Get(id)
    local tEnt = (prevNPC && prevNPC:GetEntity())

    if (SERVER && IsValid(tEnt)) then
        tEnt:Remove()
    end

    -- Load NPC
    local npc = self:SetupTemporary(data)
    npc:SetID(id)

    -- Add it to the cache
    local cache = zlib.cache:Get("mg2.NPCManager")

    if (cache) then 
        local id, entry = cache:addEntry(npc, id)

        if (SERVER && entry) then
            self:SetupNPCEntity(entry)

            mg2.gang:SendCacheToPlayer("mg2.NPCManager", player.GetAll(),
            function(entries)
                return {[id] = entry:getDataTable()}
            end)
        end
        
        return entry
    end

    return npc
end

--[[
    MG2_NPCMANAGER:Get(id [int])

    - Returns a cached npc
]]
function MG2_NPCMANAGER:Get(id)
    if !(id) then return end

    local cache = zlib.cache:Get("mg2.NPCManager")

    if !(cache) then return end

    return cache:getEntry(id)
end

--[[
    MG2_NPCMANAGER:GetAll()

    - Returns all cached npcs
]]
function MG2_NPCMANAGER:GetAll()
    local cache = zlib.cache:Get("mg2.NPCManager")

    if !(cache) then return {} end

    return cache:GetEntries()
end


--[[
    NPC Cache(s)
]]
local npcCache = zlib.cache:Register("mg2.NPCManager")
npcCache.onPlayerReceive = function(s,data)
    for k,v in pairs(data) do
        local npc = MG2_NPCMANAGER:Get(k)

        if (!v && npc) then
            // remove npc
            npc:remove()
        elseif (npc) then
            // update npc data
            for i,d in pairs(v) do
                npc:setRawData(i, d)
            end
        else 
            // setup npc
            MG2_NPCMANAGER:Setup(k, v)
        end
    end
end

--[[
    NPC Metastructure
]]
local npcMtbl = zlib.object:Create("mg2.NPCManager")

npcMtbl:setData("ID", false, {shouldSave = false})

npcMtbl:setData("Title", mg2.lang:GetTranslation("npc.Title"), {})
npcMtbl:setData("Description", mg2.lang:GetTranslation("npc.Description"), {})
npcMtbl:setData("Color", Color(255,255,255), {})
npcMtbl:setData("Position", Vector(0,0,0), {
    onGet = function(s,pos)
        if (!isvector(pos) && istable(pos)) then
            return Vector(pos[1], pos[2], pos[3])
        end

        return pos
    end
})

npcMtbl:setData("Angles", Angle(0,0,0), {
    onGet = function(s,ang)
        if (!isangle(ang) && istable(ang)) then
            return Angle(ang[1], ang[2], ang[3])
        end

        return ang
    end
})

npcMtbl:setData("Entity", nil, {
    shouldSave = false,
    onGet = function(s,val)
        if (isentity(val)) then return val end
        if !(isnumber(val)) then return nil end

        return ents.GetByIndex(val)
    end,
    onSet = function(s,val,oVal)
        // Get index
        if (isentity(val)) then
            val = val:EntIndex()
        end

        // Get entity
        local ent = ents.GetByIndex(val)

        if (IsValid(ent)) then
            ent:SetPos(s:GetPosition())
            ent:SetAngles(s:GetAngles())
    
            return ent:EntIndex()
        end

        return (isentity(oVal) && oVal:EntIndex() || oVal)
    end
})

npcMtbl:setData("MapName", nil, {
    onGet = function(s,val)
        if (!isstring(val) || string.len(val) <= 0) then
            return game.GetMap()
        end

        return val
    end,
    onSet = function(s,val,oVal)
        if (!isstring(val) || string.len(val) <= 0) then
            return (oVal || game.GetMap())
        end
    end,
})

function npcMtbl:remove()
    local id, ent = self:GetID(), self:GetEntity()

    if !(id) then return end

    local cache = zlib.cache:Get("mg2.NPCManager")
    cache:removeEntry(id)

    if (SERVER) then
        if (IsValid(ent)) then
            ent:Remove()
        end

        mg2.gang:SendCacheToPlayer("mg2.NPCManager", player.GetAll(),
        function(entries)
            return {[id] = false}
        end)
    end
end

function npcMtbl:onSave(data, cb)
    if (!SERVER or !data) then return end

    local id, mapName = self:GetID(), self:GetMapName()
    local dtype = zlib.data:GetConnection("mg2.Main")

    if (!id or !dtype) then return end

    dtype:Query("UPDATE `mg2_npcs` SET `map_name` = " .. dtype:EscapeString(mapName) .. ", `data`=" .. data .. " WHERE `id`=" .. id,
    function()
        mg2.gang:SendCacheToPlayer("mg2.NPCManager", player.GetAll(), 
        function(entries)
            return {[id] = self:getDataTable()}
        end)

        if (cb) then cb(self) end
    end)
end

--[[
    Admin Permissions
]]
local function loadSimpleValVgui(self, pnl, id, npc, valName)
    npc = (npc or MG2_NPCMANAGER:Get(id))

    if !(npc) then return end

    local npcVal = npc:getData(valName)

    local cont = vgui.Create("mg2.Container", pnl)
    cont:Dock(TOP)
    cont:DockMargin(0,3,0,0)
    cont:SetTall(55)
    
    local header = vgui.Create("mg2.Header", cont)
    header:Dock(TOP)
    header:SetText(mg2.lang:GetTranslation("npcmanager.SetNPC", valName:lower()))
    header:SetRounded(false)

    local textEntry = vgui.Create("mg2.TextEntry", cont)
    textEntry:Dock(FILL)
    textEntry:DockMargin(3,3,3,3)
    textEntry:SetPlaceholder(mg2.lang:GetTranslation("npcmanager.NPCName", valName))
    textEntry:SetText(npcVal)
    textEntry.OnEnter = function(s)
        local val = s:GetValue()

        self:onUserCall({
            id = id,
            value = val,
        }, function(res)
            if (res) then npc:setData(valName, val) end
        end)
    end
end

/*
    Admin Perms - General
*/
--[[CREATE NPC]]
local ADMIN_CREATENPC = mg2.admin:RegisterOption("npcmanager.Create")
ADMIN_CREATENPC:SetName(mg2.lang:GetTranslation("create"))
ADMIN_CREATENPC:SetDescription(mg2.lang:GetTranslation("npcmanager.CreateDesc"))
ADMIN_CREATENPC:SetFor("npcmanager")
ADMIN_CREATENPC.vguiIndex = 1

function ADMIN_CREATENPC:onCall(admin, data, cb)
    data.Position = admin:GetPos()
    data.Angles = admin:GetAngles()

    MG2_NPCMANAGER:Create(data, 
    function(npc)
        cb(npc != nil)
        zlib.notifs:Send(admin, mg2.lang:GetTranslation("npcmanager.NPCCreated"))
    end)
end

--[[RELOAD NPCS]]
local ADMIN_RELOADNPC = mg2.admin:RegisterOption("npcmanager.ReloadAll")
ADMIN_RELOADNPC:SetName(mg2.lang:GetTranslation("npcmanager.ReloadNPCs"))
ADMIN_RELOADNPC:SetDescription(mg2.lang:GetTranslation("npcmanager.ReloadNPCs"))
ADMIN_RELOADNPC:SetFor("npcmanager")
ADMIN_RELOADNPC.vguiIndex = 2

function ADMIN_RELOADNPC:onCall(admin, data, cb)
    MG2_NPCMANAGER:Load("*", 
    function(res)
        cb(true)
        zlib.notifs:Send(admin, mg2.lang:GetTranslation("npcmanager.ReloadedAll"))
    end)
end

/*
    Admin Perms - Edit NPC
*/
--[[SET NPC TITLE]]
local ADMIN_NPCSETTITLE = mg2.admin:RegisterOption("npcmanager.SetTitle")
ADMIN_NPCSETTITLE:SetName(mg2.lang:GetTranslation("npcmanager.SetTitle"))
ADMIN_NPCSETTITLE:SetDescription(mg2.lang:GetTranslation("npcmanager.SetTitle"))
ADMIN_NPCSETTITLE:SetFor("npcmanager.EditNPC")
ADMIN_NPCSETTITLE.vguiIndex = 3

function ADMIN_NPCSETTITLE:onCall(admin, data, cb)
    local id, title = data.id, data.value

    if (!id or !title) then return end

    local npc = MG2_NPCMANAGER:Get(id)
    
    if !(id) then return end

    npc:SetTitle(title)

    cb(true)

    zlib.notifs:Send(admin, mg2.lang:GetTranslation("npcmanager.SentToNPC"))
end

function ADMIN_NPCSETTITLE:loadVgui(pnl, id, npc)
    loadSimpleValVgui(self, pnl, id, npc, "Title")
end

--[[SET NPC DESCRIPTION]]
local ADMIN_NPCSETDESC = mg2.admin:RegisterOption("npcmanager.SetDescription")
ADMIN_NPCSETDESC:SetName(mg2.lang:GetTranslation("npcmanager.SetDescription"))
ADMIN_NPCSETDESC:SetDescription(mg2.lang:GetTranslation("npcmanager.SetDescription"))
ADMIN_NPCSETDESC:SetFor("npcmanager.EditNPC")
ADMIN_NPCSETDESC.vguiIndex = 4

function ADMIN_NPCSETDESC:onCall(admin, data, cb)
    local id, title = data.id, data.value

    if (!id or !title) then return end

    local npc = MG2_NPCMANAGER:Get(id)
    
    if !(id) then return end

    npc:SetDescription(title)

    cb(true)

    zlib.notifs:Send(admin, mg2.lang:GetTranslation("npcmanager.SentToNPC"))
end

function ADMIN_NPCSETDESC:loadVgui(pnl, id, npc)
    loadSimpleValVgui(self, pnl, id, npc, "Description")
end

--[[GOTO NPC]]
local ADMIN_GOTONPC = mg2.admin:RegisterOption("npcmanager.GoToNPC")
ADMIN_GOTONPC:SetName(mg2.lang:GetTranslation("npcmanager.GoToNPC"))
ADMIN_GOTONPC:SetDescription(mg2.lang:GetTranslation("npcmanager.GoToNPC"))
ADMIN_GOTONPC:SetFor("npcmanager.EditNPC")
ADMIN_GOTONPC.vguiIndex = 5

function ADMIN_GOTONPC:onCall(admin, data, cb)
    if (!data || !data.id) then cb(false) return end

    local npc = MG2_NPCMANAGER:Get(data.id)

    if !(npc) then
        cb(false)

        return
    end

    local npcEnt = npc:GetEntity()
    
    admin:SetPos(IsValid(npcEnt) && npcEnt:GetPos() || npc:GetPosition())

    cb(true)
    zlib.notifs:Send(admin, mg2.lang:GetTranslation("npcmanager.SentToNPC"))
end

--[[SAVE NPC]]
local ADMIN_SAVENPC = mg2.admin:RegisterOption("npcmanager.Save")
ADMIN_SAVENPC:SetName(mg2.lang:GetTranslation("save"))
ADMIN_SAVENPC:SetDescription(mg2.lang:GetTranslation("npcmanager.SaveDesc"))
ADMIN_SAVENPC:SetFor("npcmanager.EditNPC")
ADMIN_SAVENPC.vguiIndex = 6

function ADMIN_SAVENPC:onCall(admin, data, cb)
    if (!data || !data.id) then cb(false) return end

    local npc = MG2_NPCMANAGER:Get(data.id)

    if !(npc) then
        cb(false)

        return
    end

    -- Update the position & angles to current position & angles
    local ent = npc:GetEntity()

    npc:SetPosition(ent && ent:GetPos() || data.Position)
    npc:SetAngles(ent && ent:GetAngles() || data.Angles)

    cb(true)
    zlib.notifs:Send(admin, mg2.lang:GetTranslation("npcmanager.NPCSaved"))
end

--[[DELETE NPC]]
local ADMIN_DELETENPC = mg2.admin:RegisterOption("npcmanager.Delete")
ADMIN_DELETENPC:SetName(mg2.lang:GetTranslation("delete"))
ADMIN_DELETENPC:SetDescription(mg2.lang:GetTranslation("npcmanager.DeleteDesc"))
ADMIN_DELETENPC:SetFor("npcmanager.EditNPC")
ADMIN_DELETENPC.vguiIndex = 7

function ADMIN_DELETENPC:onCall(admin, data, cb)
    if (!data || !data.id) then cb(false) return end

    MG2_NPCMANAGER:Delete(data.id, cb)

    cb(true)
    zlib.notifs:Send(admin, mg2.lang:GetTranslation("npcmanager.NPCDeleted"))
end
