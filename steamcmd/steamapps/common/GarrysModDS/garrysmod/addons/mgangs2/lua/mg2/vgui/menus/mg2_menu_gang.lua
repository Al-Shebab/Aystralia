--[[
    MGangs 2 - (SH) VGUI MENU - Gang 
    Developed by Zephruz
]]

if (CLIENT) then

surface.CreateFont("mg2.GANGMENU.LARGE", {
    font = "Abel",
    size = 25,
})

surface.CreateFont("mg2.GANGMENU.MEDIUM", {
    font = "Abel",
    size = 21,
})

surface.CreateFont("mg2.GANGMENU.SMALL", {
    font = "Abel",
    size = 17,
})

end

local MENU_GANG = mg2.vgui:RegisterMenu("mg2.Gang")
MENU_GANG:SetConsoleCommands({"gang", "mg2_gang"})
MENU_GANG:SetChatCommands({"!gang", "!mg2gang"})

MENU_GANG:setData("MenuButtons", {}, {
    shouldSave = false,
    onSet = function(s,val,oVal,data)
        if !(data) then return val end

        oVal = (oVal or {})
        oVal[val] = data

        return oVal
    end,
})

function MENU_GANG:Init()
    if (IsValid(self.frame)) then self.frame:Remove() end

    if !(LocalPlayer():GetGang()) then return end

    self.frame = vgui.Create("mg2.Frame")
    self.frame:SetSize(850,500)
    self.frame:Center()
    self.frame:MakePopup()
    self.frame:SetTitle("")
    self.frame:SetFrameBlur(true)

    self:LoadGangInfoCard()
    self:LoadSideNavigation()

    local topNavBtns = {
        [mg2.lang:GetTranslation("settings")] = {
            index = 1,
            doClick = function()
                local sMenu = mg2.vgui:GetMenu("mg2.Settings")

                if (sMenu) then 
                    sMenu:Init()

                    self.frame:Remove()
                end
            end,
        },
        [mg2.lang:GetTranslation("admin")] = {
            index = 2,
            setVis = table.HasValue(mg2.config.adminGroups, LocalPlayer():GetUserGroup()),
            doClick = function()
                local aMenu = mg2.vgui:GetMenu("mg2.Admin")

                if (aMenu) then 
                    aMenu:Init()

                    self.frame:Remove()
                end
            end,
        },
    }

    for k,v in SortedPairsByMemberValue(topNavBtns, "index") do
        local tnavBtn = self.frame:AddTopNavigationButton(k)
        tnavBtn.DoClick = function()
            if (v.doClick) then v.doClick() end
        end

        -- Set button W based on text W
        local tW, tH = zlib.util:GetTextSize(k, tnavBtn:GetFont())

        tnavBtn:SetWide(tW + 20)

        local setVis = v.setVis

        if (setVis != nil) then
            tnavBtn:SetVisible(setVis)
        end
    end
end

function MENU_GANG:AddMenuButton(text, data)
    self:SetMenuButtons(text, (data or {}))

    if (IsValid(self.frame)) then
        self.frame:AddSideNavigationButton(text, data)
    end
end

function MENU_GANG:LoadSideNavigation()
    if !(IsValid(self.frame)) then return end

    local menuBtns = self:GetMenuButtons()

    for k,v in SortedPairsByMemberValue(menuBtns, "index") do
        self:AddMenuButton(k, v)
    end
end

function MENU_GANG:LoadGangInfoCard()
    local sideNav = self.frame:GetSideNavigationPanel()
    sideNav:SetWide(200)

    local gang = LocalPlayer():GetGang()
    local gcH = 45

    -- [[Basic Info]]
    local gCardPnl = vgui.Create("mg2.Container", sideNav)
    gCardPnl:Dock(TOP)
    gCardPnl:SetRounded(false)
    gCardPnl:SetTall(gcH)
    gCardPnl.PaintOver = function(s,w,h)
        draw.SimpleText(gang:GetName(),"mg2.GANGMENU.MEDIUM",gcH+5,3,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
        draw.SimpleText("ID: " .. gang:GetID(),"mg2.GANGMENU.SMALL",gcH+5,h-3,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM)
    end

    -- Gang Icon
    local gIconCont = vgui.Create("DPanel", gCardPnl)
    gIconCont:Dock(LEFT)
    gIconCont:DockMargin(3,3,3,3)
    gIconCont:SetWide(gcH)
    gIconCont.Paint = function() end

    gIconCont:InvalidateLayout(true)

    timer.Simple(0.1,
    function()
        if !(IsValid(gIconCont)) then return end
        
        local gIconW, gIconH = gIconCont:GetSize()

        local gIcon = vgui.Create("mg2.HTMLImage", gIconCont)
        gIcon:SetSize(gIconH, gIconH)
        gIcon:SetURL(gang:GetIcon())
        gIcon:SetMaterialPrefix(string.format("%s%s", gang:GetID(), gang:GetName()))
    end)

    -- [[Gang Level]]
    local glH = 25

    -- Progress bar
    local gLvl, gExp = gang:GetLevel(), gang:GetEXP()
    local maxLvl, expToLvl = mg2.gang:GetMaxLevel(), mg2.gang:CalculateExpToLevel(gLvl)
    local isMax = (maxLvl && gLvl >= maxLvl)

    local gProgressBar = vgui.Create("mg2.ProgressBar", sideNav)
    gProgressBar:Dock(TOP)
    gProgressBar:DockMargin(3,3,3,0)
    gProgressBar:SetTall(glH)
    gProgressBar:SetFraction(isMax && 1 || math.Truncate(gExp/expToLvl, 2))
    gProgressBar.PaintOver = function(s,w,h)
        draw.SimpleText("Lvl " .. gLvl,"mg2.GANGMENU.SMALL",5,h/2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        draw.SimpleText((isMax && "MAX LEVEL" || gExp .. "/" .. expToLvl .. " EXP"),"mg2.GANGMENU.SMALL",w-5,h/2,Color(255,255,255),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
    end

    -- Prog. bar think
    local nextThink = os.time()

    gProgressBar.Think = function(s)
        if (!gang || nextThink > os.time()) then return end
        nextThink = os.time() + 1

        gLvl = gang:GetLevel()
        gExp = gang:GetEXP()
        expToLvl = mg2.gang:CalculateExpToLevel(gLvl)
        isMax = (maxLvl && gLvl >= maxLvl)

        local newFrac, curFrac = (isMax && 1 || math.Truncate(gExp/expToLvl, 2)), s:GetFraction()

        if (newFrac != curFrac) then
            gProgressBar:SetFraction(newFrac)
        end
    end

    --[[Gang Balance]]
    local curType = mg2.gang:GetCurrencyType()

    if (curType) then
        local gBalCont = vgui.Create("mg2.Container", sideNav)
        gBalCont:Dock(TOP)
        gBalCont:DockMargin(3,3,3,0)
        gBalCont:SetTall(25)
        gBalCont.PaintOver = function(s,w,h)
            draw.SimpleText((mg2.config.balanceSymbol or "$") .. zlib.util:FormatNumber(gang:GetBalance()),"mg2.GANGMENU.SMALL",5,h/2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        end

        -- Options
        local totalPerms = 0
        local balOpts = {
            [mg2.lang:GetTranslation("deposit")] = {
                perm = "depositmoney",
                icon = "icon16/money_add.png",
            },
            [mg2.lang:GetTranslation("withdraw")] = {
                perm = "withdrawmoney",
                icon = "icon16/money_delete.png",
            },
        }

        for k,v in pairs(balOpts) do
            v.hasPerm = LocalPlayer():HasGangPermission(v.perm)

            if (v.hasPerm) then 
                totalPerms = totalPerms + 1 
            end
        end

        if (totalPerms > 0) then 
            local optButton = vgui.Create("mg2.Button", gBalCont)
            optButton:Dock(RIGHT)
            optButton:DockMargin(0,3,3,3)
            optButton:SetText(mg2.lang:GetTranslation("options"))
            optButton.DoClick = function(s)
                local dMenu = DermaMenu(s)
    
                for k,v in pairs(balOpts) do
                    if !(v.hasPerm) then continue end
    
                    dMenu:AddOption(k,
                        function()
                            local perm = mg2.gang:GetPermission(v.perm)
    
                            if !(perm) then return end
    
                            perm:onUserCall({}, function(res) end)
                        end
                    ):SetIcon(v.icon)
                end
    
                dMenu:Open()
            end
        end
    end
end

--[[GENERAL]]
MENU_GANG:AddMenuButton(mg2.lang:GetTranslation("general"), {
    index = 1,
    defaultTab = true,
    doClick = function(btn, pnl)
        MENU_GANG:OpenGeneral(pnl)
    end,
})

function MENU_GANG:OpenGeneral(pnl)
    if !(IsValid(pnl)) then return end

    local gang = LocalPlayer():GetGang()

    local gGeneralCont = vgui.Create("mg2.Container", pnl)
    gGeneralCont:Dock(FILL)
    gGeneralCont:DockMargin(5,5,5,5)
    gGeneralCont:SetRounded(false)

    local header = vgui.Create("mg2.Header", gGeneralCont)
    header:Dock(TOP)
    header:SetRounded(false)
    header:SetText(mg2.lang:GetTranslation("general"))

    -- MOTD
    local motdHeader = vgui.Create("mg2.Header", gGeneralCont)
    motdHeader:Dock(TOP)
    motdHeader:DockMargin(3,3,3,0)
    motdHeader:SetText(mg2.lang:GetTranslation("motd"))

    local motdTextEntry = vgui.Create("mg2.TextEntry", gGeneralCont)
    motdTextEntry:Dock(TOP)
    motdTextEntry:DockMargin(3,3,3,0)
    motdTextEntry:SetTall(100)
    motdTextEntry:SetMultiline(true)
    motdTextEntry:SetPlaceholder(mg2.lang:GetTranslation("gangmotd"))
    motdTextEntry:SetText(gang:GetMOTD())
    motdTextEntry:SetEditable(false)
end

--[[MEMBERS]]
MENU_GANG:AddMenuButton(mg2.lang:GetTranslation("members"), {
    index = 2,
    defaultTab = false,
    menuHints = {
        "You can filter gang members by their name, rank, and more!",
        "If you're a gang Leader you can modify your gang under the 'Settings' menu."
    },
    doClick = function(btn, pnl)
        MENU_GANG:OpenMembers(pnl)
    end,
})

local function sortOnlineMembers(members)
    local setMems = {}
    
    for k,v in pairs(members) do
        local ply = zlib.util:GetPlayerBySteamID(v.steamid)

        if (ply) then
            v.player = ply

            table.insert(setMems, 1, v)
        else
            table.insert(setMems, v)
        end
    end

    return setMems
end

local function openInvitePlayer()
    local frame = vgui.Create("mg2.Frame")
    frame:SetSize(350,500)
    frame:Center()
    frame:MakePopup()
    frame:SetTitle(mg2.lang:GetTranslation("inviteplayers"))
    frame:SetBackgroundBlur(true)

    -- Player list
    local plys = table.Copy(player.GetAll())

    for k,v in pairs(plys) do
        if (v:GetGang()) then
            table.remove(plys,k)
        end
    end

    local plyList = vgui.Create("mg2.Scrollpanel", frame)
    plyList:Dock(FILL)
    plyList:DockMargin(5,5,5,5)
    plyList.PaintOver = function(s,w,h)
        if (#plys <= 0) then
            draw.SimpleText(mg2.lang:GetTranslation("noplayers"),"mg2.GANGMENU.MEDIUM",w/2,h/2,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end
    end

    for k,v in pairs(plys) do
        local plyPnl = vgui.Create("mg2.Container", plyList)
        plyPnl:Dock(TOP)
        plyPnl:DockMargin(0,3,0,0)
        plyPnl:SetTall(30)
        plyPnl.PaintOver = function(s,w,h)
            if !(IsValid(v)) then s:Remove() return end

            local pNick, pStid = v:Nick(), v:SteamID()

            draw.SimpleText(pNick,"mg2.GANGMENU.MEDIUM",5,h/2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            draw.SimpleText(pStid,"mg2.GANGMENU.SMALL",w/2,h/2,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end

        local inviteButton = vgui.Create("mg2.Button", plyPnl)
        inviteButton:Dock(RIGHT)
        inviteButton:DockMargin(3,3,3,3)
        inviteButton:SetText(mg2.lang:GetTranslation("invite"))
        inviteButton.DoClick = function(s)
            local hasPerm = LocalPlayer():HasGangPermission("invite")

            if !(hasPerm) then return end

            local perm = mg2.gang:GetPermission("invite")

            if !(perm) then return end

            perm:onUserCall({ v:IsBot() && "BOT" || v:SteamID64() },
            function(success)
                if (success) then
                    if (IsValid(plyPnl)) then plyPnl:Remove() end
                end
            end)
        end
    end
end

function MENU_GANG:OpenMembers(pnl)
    if !(IsValid(pnl)) then return end

    local gMemberCont = vgui.Create("mg2.Container", pnl)
    gMemberCont:Dock(FILL)
    gMemberCont:DockMargin(5,5,5,5)
    gMemberCont:SetRounded(false)

    local header = vgui.Create("mg2.Header", gMemberCont)
    header:Dock(TOP)
    header:SetRounded(false)
    header:SetText(mg2.lang:GetTranslation("members"))

    -- Invite Button
    local inviteTxt = mg2.lang:GetTranslation("invite")
    local invitePly = vgui.Create("mg2.Button", header)
    invitePly:Dock(RIGHT)
    invitePly:DockMargin(3,3,3,3)
    invitePly:SetText(inviteTxt)
    invitePly:SetVisible(LocalPlayer():HasGangPermission("invite"))
    invitePly.DoClick = function(s)
        openInvitePlayer()
    end

    -- Set button W based on text W
    local tW, tH = zlib.util:GetTextSize(inviteTxt, invitePly:GetFont())

    invitePly:SetWide(tW + 20)

    --[[Gang Member list]]
    local gMemSPnl = vgui.Create("mg2.Searchpanel", gMemberCont)
    gMemSPnl:Dock(FILL)
    gMemSPnl:DockMargin(5,5,5,5)
    
    local function selectPage(pg)
        zlib.network:CallAction("mg2.gang.userRequest", {reqName = "getGangMembers", page = pg},
        function(data)
            if !(IsValid(gMemSPnl)) then return end
            
            local totalPgs, members = data.totalPages, sortOnlineMembers(data.members)
            
            gMemSPnl:SetTotalPages(totalPgs)
            gMemSPnl:SetResults(members)
        end)
    end

    local function searchVal(val)
        zlib.network:CallAction("mg2.gang.userRequest", {reqName = "getGangMembers", searchVal = val},
        function(data)
            if !(IsValid(gMemSPnl)) then return end

            local members = sortOnlineMembers(data.members)

            gMemSPnl:SetTotalPages(1)
            gMemSPnl:SetResults(members)
        end)
    end

    function gMemSPnl:OnSetupResult(sPnl, res)
        local group = mg2.gang:GetGroup(res.group_id)

        if !(group) then return end
        
        local memData = (res && res.data)
        local ply = zlib.util:GetPlayerBySteamID(res.steamid)
        local onlineIcon = Material("icon16/bullet_green.png")

        local memPnl = vgui.Create("mg2.Container", sPnl)
        memPnl:Dock(TOP)
        memPnl:DockMargin(0,3,0,0)
        memPnl:SetTall(30)
        memPnl.PaintOver = function(s,w,h)
            local pX = 5
            local pNick = (IsValid(ply) && ply:Nick() || memData && memData.name)

            if (!pNick || string.len(string.Trim(pNick)) <= 0) then 
                pNick = res.steamid 
            end

            if (IsValid(ply)) then
                pX = 25

                local iH, iW = 16, 16

                surface.SetDrawColor(255, 255, 255, 255)
                surface.SetMaterial(onlineIcon)
                surface.DrawTexturedRect(5, (h/2 - iH/2), iH, iW)
            end

            draw.SimpleText(pNick,"mg2.GANGMENU.MEDIUM",pX,h/2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            draw.SimpleText(group:GetName(),"mg2.GANGMENU.SMALL",w/2,h/2,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end

        --[[User options (if permissed)]]
        if (ply != LocalPlayer()) then
            local options = {}
            local memPerms = mg2.gang:GetPermissionsByType("member")

            for k,v in pairs(memPerms) do
                local hasPerm = LocalPlayer():HasGangPermission(k)

                if (hasPerm) then
                    options[k] = v
                end
            end

            if (table.Count(options) > 0) then
                local modifyTxt = mg2.lang:GetTranslation("options")
                local modifyBtn = vgui.Create("mg2.Button", memPnl)
                modifyBtn:Dock(RIGHT)
                modifyBtn:DockMargin(3,3,3,3)
                modifyBtn:SetText(modifyTxt)
                modifyBtn.DoClick = function(s)
                    local dMenu = DermaMenu(s)
    
                    for k,v in pairs(options) do
                        local permName = v:GetName()
    
                        dMenu:AddOption(permName,
                        function()
                            local perm = mg2.gang:GetPermission(k)

                            if !(perm) then return end

                            perm:onUserCall({ res.steamid },
                            function(res)
                                if !(IsValid(self)) then return end

                                selectPage(self:GetCurrentPage())
                            end)
                        end)
                    end

                    -- Set button W based on text W
                    local tW, tH = zlib.util:GetTextSize(modifyTxt, modifyBtn:GetFont())

                    modifyBtn:SetWide(tW + 20)
    
                    dMenu:Open()
                end
            end
        end
    end

    function gMemSPnl:OnPreviousPage(pg) 
        selectPage(pg)

        return true
    end

    function gMemSPnl:OnNextPage(pg) 
        selectPage(pg)

        return true
    end

    function gMemSPnl:OnSearch(sVal)
        searchVal(sVal)

        return true
    end

    selectPage(1)
end