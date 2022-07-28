--[[
    MGangs 2 - (SH) Permissions
    Developed by Zephruz
]]

--[[
    mg2.gang:RegisterPermission(name [string], data [table = null])

    - Registers a permission
]]
function mg2.gang:RegisterPermission(name, data)
    local perm = {}

    zlib.object:SetMetatable("mg2.Permission", perm)

    perm:SetUniqueName(name)

    if (data) then
        for k,v in pairs(data) do
            perm:setData(k,v)
        end
    end

    -- Add to cache
    local cache = zlib.cache:Get("mg2.Permissions")

    if (cache) then
        cache:addEntry(perm, name)

        return cache:getEntry(name)
    end

    return perm
end

--[[
    mg2.gang:GetPermission(name [string])

    - Returns a permission or nil
]]
function mg2.gang:GetPermission(name)
    local cache = zlib.cache:Get("mg2.Permissions")

    if !(cache) then return end
    
    return cache:getEntry(name)
end

--[[
    mg2.gang:GetAllPermissions()

    - Returns all permissions
]]
function mg2.gang:GetAllPermissions()
    local cache = zlib.cache:Get("mg2.Permissions")

    if !(cache) then return {} end

    return cache:GetEntries()
end

--[[
    mg2.gang:GetPermissionsByType(typeName [string])

    - Returns permission set with the typeName via perm:SetPermissionType()
]]
function mg2.gang:GetPermissionsByType(typeName)
    local perms = {}
    local allPerms = self:GetAllPermissions()

    for k,v in pairs(allPerms) do
        if (v:GetPermissionType() == typeName) then
            perms[k] = v
        end
    end

    return perms
end

--[[
    Player meta
]]
local pMeta = FindMetaTable("Player")

function pMeta:HasGangPermission(perm)
    local lPlyGrp = self:GetGangGroup()
    
    return (lPlyGrp && lPlyGrp:GetPermissions(perm))
end

--[[
    Permission Cache
]]
zlib.cache:Register("mg2.Permissions")

--[[
    Permission metastructure
]]
local permMtbl = zlib.object:Create("mg2.Permission")

permMtbl:setData("UniqueName", nil, {shouldSave = false})
permMtbl:setData("Name", "PERM.NAME", {shouldSave = false})
permMtbl:setData("Description", "PERM.DESCRIPTION", {shouldSave = false})
permMtbl:setData("Category", "Misc.", {shouldSave = false})
permMtbl:setData("PermissionType", "misc", {shouldSave = false})

function permMtbl:onCall(...) return false end
function permMtbl:onUserCall(data, cb)
    zlib.network:CallAction("mg2.gang.userRequest", {
        reqName = "setPermission",
        permName = self:GetUniqueName(),
        permData = data,
    },
    function(res)
        if (cb) then 
            cb(istable(res) && unpack(res) || res) 
        end
    end)
end

--[[
    Default permissions
]]

-- DEPOSIT MONEY
local PERM_DEPOSITMONEY = mg2.gang:RegisterPermission("depositmoney")
PERM_DEPOSITMONEY:SetName(mg2.lang:GetTranslation("depositmoney"))
PERM_DEPOSITMONEY:SetCategory(mg2.lang:GetTranslation("balance"))
PERM_DEPOSITMONEY:SetDescription(mg2.lang:GetTranslation("perm.DepositMoneyDesc"))

PERM_DEPOSITMONEY.oldUserCall = (PERM_DEPOSITMONEY.oldUserCall or PERM_DEPOSITMONEY.onUserCall)

function PERM_DEPOSITMONEY:onCall(ply, cb, value)
    local curType = mg2.gang:GetCurrencyType()
    local gang = ply:GetGang()

    if (!curType or !gang or !value or value <= 0) then return false end

    value = math.Round(value, 0)

    local curVal = gang:GetBalance()
    local postVal = (curVal + value)
    local canDeposit = (hook.Run("mg2.balance.Deposit", ply, gang, postVal) != false)

    if (!canDeposit or !curType.canAfford(ply, value)) then return false end

    curType.takeMoney(ply, value)

    local val = gang:SetBalance(math.floor(postVal))

    cb(val)

    if (val) then
        mg2:SendNotification(ply, mg2.lang:GetTranslation("perm.YouHaveDeposited", mg2.gang:FormatCurrency(value)))
    end
end

function PERM_DEPOSITMONEY:onUserCall(data, cb)
    local gang = LocalPlayer():GetGang()
    local curType = mg2.gang:GetCurrencyType()

    if (!gang or !curType) then return end

    local frame = vgui.Create("mg2.Frame")
    frame:SetSize(300,85)
    frame:SetTitle(mg2.lang:GetTranslation("deposit"))
    frame:Center()
    frame:MakePopup()
    frame:SetBackgroundBlur(true)

    local slider = vgui.Create("mg2.NumSlider", frame)
    slider:Dock(TOP)
    slider:DockMargin(3,3,3,3)
    slider:SetMin(0)
    slider:SetMax(curType.getMoney(LocalPlayer()))
    slider:SetValue(0)
    slider:SetDecimals(0)
    slider:SetText(mg2.lang:GetTranslation("amount"))

    local btn = vgui.Create("mg2.Button", frame)
    btn:Dock(FILL)
    btn:DockMargin(3,0,3,3)
    btn:SetText(mg2.lang:GetTranslation("deposit"))
    btn.DoClick = function(s)
        local val = slider:GetValue()

        self:oldUserCall({val}, 
        function(res)
            cb(res)

            if !(IsValid(frame)) then return end
            
            frame:Remove()
        end)
    end
end

-- WITHDRAW MONEY
local PERM_WITHDRAWMONEY = mg2.gang:RegisterPermission("withdrawmoney")
PERM_WITHDRAWMONEY:SetName(mg2.lang:GetTranslation("withdrawmoney"))
PERM_WITHDRAWMONEY:SetCategory(mg2.lang:GetTranslation("balance"))
PERM_WITHDRAWMONEY:SetDescription(mg2.lang:GetTranslation("perm.WithdrawMoneyDesc"))

PERM_WITHDRAWMONEY.oldUserCall = (PERM_WITHDRAWMONEY.oldUserCall or PERM_WITHDRAWMONEY.onUserCall)

function PERM_WITHDRAWMONEY:onCall(ply, cb, value)
    local curType = mg2.gang:GetCurrencyType()
    local gang = ply:GetGang()

    if (!curType or !gang or !value or value <= 0) then return false end

    value = math.Round(value, 0)

    local curVal = gang:GetBalance()
    local postVal = (curVal - value)

    if (postVal < 0) then return false end

    local val = gang:SetBalance(math.floor(postVal))

    curType.giveMoney(ply, value)

    if (val) then
        mg2:SendNotification(ply, mg2.lang:GetTranslation("perm.YouHaveWithdrawn", mg2.gang:FormatCurrency(value)))
    end
end

function PERM_WITHDRAWMONEY:onUserCall(data, cb)
    local gang = LocalPlayer():GetGang()

    if !(gang) then return end

    local frame = vgui.Create("mg2.Frame")
    frame:SetSize(300,85)
    frame:SetTitle("Withdraw")
    frame:Center()
    frame:MakePopup()
    frame:SetBackgroundBlur(true)

    local slider = vgui.Create("mg2.NumSlider", frame)
    slider:Dock(TOP)
    slider:DockMargin(3,3,3,3)
    slider:SetMin(0)
    slider:SetMax(gang:GetBalance())
    slider:SetValue(0)
    slider:SetDecimals(0)
    slider:SetText("Amount")

    local btn = vgui.Create("mg2.Button", frame)
    btn:Dock(FILL)
    btn:DockMargin(3,0,3,3)
    btn:SetText("Withdraw")
    btn.DoClick = function(s)
        local val = slider:GetValue()

        self:oldUserCall({val}, 
        function(res)
            cb(res)

            if !(IsValid(frame)) then return end
            
            frame:Remove()
        end)
    end
end

-- SET NAME
local PERM_SETNAME = mg2.gang:RegisterPermission("setname")
PERM_SETNAME:SetName(mg2.lang:GetTranslation("gang.SetName"))
PERM_SETNAME:SetCategory(mg2.lang:GetTranslation("general"))
PERM_SETNAME:SetDescription(mg2.lang:GetTranslation("perm.SetNameDesc"))

function PERM_SETNAME:onCall(ply, cb, value)
    local gang = ply:GetGang()
    
    if (!gang or !value) then return false end

    local curVal = gang:GetName()

    if (curVal == value) then return end

    if (string.len(value) > mg2.config.maxGangNameSize) then
        mg2:SendNotification(ply, mg2.lang:GetTranslation("gang.NameTooLong", val))

        cb(false)

        return
    end

    local val = gang:SetName(value)

    cb(val)

    if (val) then
        mg2:SendNotification(ply, mg2.lang:GetTranslation("perm.YouHaveSetName", val))
    end
end

-- SET ICON
local PERM_SETICON = mg2.gang:RegisterPermission("seticon")
PERM_SETICON:SetName(mg2.lang:GetTranslation("gang.SetIcon"))
PERM_SETICON:SetCategory(mg2.lang:GetTranslation("general"))
PERM_SETICON:SetDescription(mg2.lang:GetTranslation("perm.SetIconDesc"))

function PERM_SETICON:onCall(ply, cb, value)
    local gang = ply:GetGang()
    
    if (!gang or !value) then return false end

    local curVal = gang:GetIcon()

    if (curVal == value) then return end

    local val = gang:SetIcon(value)

    cb(val)

    if (val) then
        mg2:SendNotification(ply, mg2.lang:GetTranslation("perm.YouHaveSetIcon"))
    end
end

-- SET COLOR
local PERM_SETCOLOR = mg2.gang:RegisterPermission("setcolor")
PERM_SETCOLOR:SetName(mg2.lang:GetTranslation("gang.SetColor"))
PERM_SETCOLOR:SetCategory(mg2.lang:GetTranslation("general"))
PERM_SETCOLOR:SetDescription(mg2.lang:GetTranslation("perm.SetColorDesc"))

function PERM_SETCOLOR:onCall(ply, cb, value)
    local gang = ply:GetGang()

    if (!gang or !value) then return false end

    local curVal = gang:GetColor()

    if (curVal == value) then return end

    local val = gang:SetColor(value)

    cb(val)

    if (val) then
        mg2:SendNotification(ply, mg2.lang:GetTranslation("perm.YouHaveSetColor"))
    end
end

-- SET MOTD
local PERM_SETMOTD = mg2.gang:RegisterPermission("setmotd")
PERM_SETMOTD:SetName(mg2.lang:GetTranslation("gang.SetMOTD"))
PERM_SETMOTD:SetCategory(mg2.lang:GetTranslation("general"))
PERM_SETMOTD:SetDescription(mg2.lang:GetTranslation("perm.SetMOTDDesc"))

function PERM_SETMOTD:onCall(ply, cb, value)
    local gang = ply:GetGang()
    
    if (!gang or !value) then return false end

    local curVal = gang:GetMOTD()

    if (curVal == value) then return end

    if (string.len(value) > mg2.config.maxGangMOTDSize) then
        mg2:SendNotification(ply, mg2.lang:GetTranslation("gang.MOTDTooLong", val))

        cb(false)

        return
    end

    local val = gang:SetMOTD(value)

    cb(val)

    if (val) then
        mg2:SendNotification(ply, mg2.lang:GetTranslation("perm.YouHaveSetMOTD", val))
    end
end

-- MODIFY GROUP
local PERM_MODIFYGROUP = mg2.gang:RegisterPermission("modifygroup")
PERM_MODIFYGROUP:SetName(mg2.lang:GetTranslation("modifygroup"))
PERM_MODIFYGROUP:SetCategory(mg2.lang:GetTranslation("management"))
PERM_MODIFYGROUP:SetDescription(mg2.lang:GetTranslation("perm.ModifyGroupDesc"))

function PERM_MODIFYGROUP:onCall(ply, cb, gid, gData)
    local gang = ply:GetGang()
    
    if (!gang or !gData) then return false end

    local group, gangid = mg2.gang:GetGroup(gid), gang:GetID()

    if (!group or group:GetGangID() != gangid) then return end

    local tempGroup = mg2.gang:SetupTemporaryGroup(gData)
    gData = tempGroup:getValidatedData()

    if !(gData) then return end

    for k,v in pairs(gData) do
        local gData = group:getData(k)

        if (v != gData) then
            group:setData(k,v)
        end
    end

    mg2:SendNotification(ply, mg2.lang:GetTranslation("perm.YouHaveModifiedGroup", group:GetName()))
end

-- CREATE GROUP
local PERM_CREATEGROUP = mg2.gang:RegisterPermission("creategroup")
PERM_CREATEGROUP:SetName(mg2.lang:GetTranslation("creategroup"))
PERM_CREATEGROUP:SetCategory(mg2.lang:GetTranslation("management"))
PERM_CREATEGROUP:SetDescription(mg2.lang:GetTranslation("perm.CreateGroupDesc"))

function PERM_CREATEGROUP:onCall(ply, cb, gData)
    local gang = ply:GetGang()
    
    if (!gang or !gData) then return false end

    local tempGroup = mg2.gang:SetupTemporaryGroup(gData)

    gData = (tempGroup:getValidatedData() or {})

    mg2.gang:CreateGroup(gang:GetID(), gData, 
    function(gang, group)
        if (gang && group) then
            cb(group:GetID())

            mg2:SendNotification(ply, mg2.lang:GetTranslation("perm.YouHaveCreatedGroup", group:GetName()))
        else
            cb(false)
        end
    end)
end

-- REMOVE GROUP
local PERM_REMOVEGROUP = mg2.gang:RegisterPermission("removegroup")
PERM_REMOVEGROUP:SetName(mg2.lang:GetTranslation("removegroup"))
PERM_REMOVEGROUP:SetCategory(mg2.lang:GetTranslation("management"))
PERM_REMOVEGROUP:SetDescription(mg2.lang:GetTranslation("perm.RemoveGroupDesc"))

function PERM_REMOVEGROUP:onCall(ply, cb, groupid)
    local gangid = ply:GetGangID()
    
    if (!gangid or !groupid) then return false end

    local group = mg2.gang:GetGroup(groupid)

    if (!group or group:GetGangID() != gangid) then return false end

    mg2.gang:DeleteGroup(groupid, 
    function(res)
        if !(res) then return end

        cb(true)

        mg2:SendNotification(ply, mg2.lang:GetTranslation("perm.YouHaveRemovedGroup", group:GetName()))
    end)
end

-- INVITE
local PERM_INVITE = mg2.gang:RegisterPermission("invite")
PERM_INVITE:SetName(mg2.lang:GetTranslation("inviteplayer"))
PERM_INVITE:SetCategory(mg2.lang:GetTranslation("usermanagement"))
PERM_INVITE:SetDescription(mg2.lang:GetTranslation("perm.InvitePlayersDesc"))

function PERM_INVITE:onCall(ply, cb, inviteeID)
    local gang = ply:GetGang()
    local inviteePly
    
    if (inviteeID == "BOT") then
        local bots = player.GetBots()
        local botCt = #bots

        inviteePly = botCt > 0 && bots[1] || nil
    else
        inviteePly = inviteeID && player.GetBySteamID64(inviteeID)
    end

    if (!gang or !inviteePly) then return end

    mg2.gang:SendInvite(inviteePly, (ply or nil), gang:GetID(),
    function(res)
        cb(res)

        // Send notification
        if (res) then
            mg2:SendNotification(ply, mg2.lang:GetTranslation("perm.YouHaveInvited", (IsValid(inviteePly) && inviteePly:Nick() || "(INVALID)")))
            mg2:SendNotification(inviteePly, mg2.lang:GetTranslation("perm.YouHaveBeenInvited", gang:GetName()))
        end
    end)
end

-- KICK
local PERM_KICK = mg2.gang:RegisterPermission("kick")
PERM_KICK:SetName(mg2.lang:GetTranslation("kickplayer"))
PERM_KICK:SetCategory(mg2.lang:GetTranslation("usermanagement"))
PERM_KICK:SetDescription(mg2.lang:GetTranslation("perm.KickPlayersDesc"))
PERM_KICK:SetPermissionType("member")

function PERM_KICK:onCall(ply, cb, steamid)
    local gang = ply:GetGang()

    if (!gang or !steamid) then return end

    if (ply:SteamID() == steamid) then
        cb(false)

        return
    end

    mg2.gang:GetPlayer(steamid,
    function(pData)
        local gid = pData.gang_id

        if (gid && gid == gang:GetID()) then
            mg2.gang:RemovePlayer(steamid,
            function(res)
                if (res) then 
                    cb(true)

                    local kickedPly = zlib.util:GetPlayerBySteamID(steamid)

                    // Send notification
                    mg2:SendNotification(ply, mg2.lang:GetTranslation("perm.YouHaveKicked", (IsValid(kickedPly) && kickedPly:Nick() || steamid)))
                    mg2:SendNotification(kickedPly, mg2.lang:GetTranslation("perm.YouHaveBeenKicked"))
                end
            end)
        end

        cb(false)
    end)
end

-- SET GROUP
local PERM_SETGROUP = mg2.gang:RegisterPermission("setgroup")
PERM_SETGROUP:SetName(mg2.lang:GetTranslation("setplayergroup"))
PERM_SETGROUP:SetCategory(mg2.lang:GetTranslation("usermanagement"))
PERM_SETGROUP:SetDescription(mg2.lang:GetTranslation("perm.SetGroupDesc"))
PERM_SETGROUP:SetPermissionType("member")

PERM_SETGROUP.oldUserCall = (PERM_SETGROUP.oldUserCall or PERM_SETGROUP.onUserCall)

function PERM_SETGROUP:onUserCall(data, cb)
    local gang = LocalPlayer():GetGang()
    local stid = (data && data[1])

    if (!gang or !stid) then return end

    local frame = vgui.Create("mg2.Frame")
    frame:SetSize(250,100)
    frame:SetTitle(mg2.lang:GetTranslation("setgroup"))
    frame:Center()
    frame:MakePopup()
    frame:SetBackgroundBlur(true)

    local grpDropDown = vgui.Create("mg2.Dropdown", frame)
    grpDropDown:Dock(FILL)
    grpDropDown:DockMargin(3,3,3,3)
    grpDropDown:SetText(mg2.lang:GetTranslation("selectgroup"))

    local groups = mg2.gang:GetGroups(gang:GetID())

    if !(groups) then frame:Remove() return end

    for k,v in pairs(groups) do
        grpDropDown:AddChoice(v:GetName(), v:GetID())
    end

    -- Set group
    local setGrpBtn = vgui.Create("mg2.Button", frame)
    setGrpBtn:Dock(BOTTOM)
    setGrpBtn:DockMargin(3,0,3,3)
    setGrpBtn:SetText(mg2.lang:GetTranslation("setgroup"))
    setGrpBtn:SetTall(30)
    setGrpBtn.DoClick = function(s)
        local selid = grpDropDown:GetSelectedID()
        local gid = grpDropDown:GetOptionData(selid)

        if (gid) then
            self:oldUserCall({stid, gid}, 
            function(res)
                cb(res)

                if !(IsValid(frame)) then return end
                
                frame:Remove()
            end)
        end
    end
end

function PERM_SETGROUP:onCall(ply, cb, steamid, groupid)
    local gang = ply:GetGang()
    
    if (!gang or !steamid or !groupid) then return end

    mg2.gang:SetPlayerGroup(steamid, groupid,
    function(group)
        if !(group) then cb(false) return end

        cb(group:GetID())

        local setPly = zlib.util:GetPlayerBySteamID(steamid)

        mg2:SendNotification(ply, mg2.lang:GetTranslation("perm.YouHaveSetGroup", (IsValid(setPly) && setPly:Nick() || steamid), group:GetName()))
    end)
end
