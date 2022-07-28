--[[
    MGangs 2 - (SH) VGUI MENU - Admin
    Developed by Zephruz
]]

if (CLIENT) then

surface.CreateFont("mg2.ADMINMENU.LARGE", {
    font = "Abel",
    size = 25,
})

surface.CreateFont("mg2.ADMINMENU.MEDIUM", {
    font = "Abel",
    size = 21,
})

surface.CreateFont("mg2.ADMINMENU.SMALL", {
    font = "Abel",
    size = 17,
})

end

local MENU_ADMIN = mg2.vgui:RegisterMenu("mg2.Admin")
MENU_ADMIN:SetConsoleCommands({"gangadmin", "mg2_admin"})
MENU_ADMIN:SetChatCommands({"!gangadmin", "!mg2admin"})

MENU_ADMIN:setData("MenuButtons", {}, {
    shouldSave = false,
    onSet = function(s,val,oVal,data)
        if !(data) then return val end

        oVal = (oVal or {})
        oVal[val] = data

        return oVal
    end,
})

function MENU_ADMIN:Init()
    if (IsValid(self.frame)) then self.frame:Remove() end

    self.frame = vgui.Create("mg2.Frame")
    self.frame:SetSize(850,500)
    self.frame:Center()
    self.frame:MakePopup()
    self.frame:SetTitle(mg2.lang:GetTranslation("admin"))
    self.frame:SetFrameBlur(true)

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
        [mg2.lang:GetTranslation("gang")] = {
            index = 2,
            setVis = LocalPlayer():GetGang(),
            doClick = function()
                local aMenu = mg2.vgui:GetMenu("mg2.Gang")

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

    self:LoadSideNavigation()
end

function MENU_ADMIN:AddMenuButton(text, data)
    self:SetMenuButtons(text, (data or {}))

    if (IsValid(self.frame)) then
        self.frame:AddSideNavigationButton(text, data)
    end
end

function MENU_ADMIN:LoadSideNavigation()
    if !(IsValid(self.frame)) then return end

    local menuBtns = self:GetMenuButtons()

    for k,v in SortedPairsByMemberValue(menuBtns, "index") do
        self:AddMenuButton(k, v)
    end
end

--[[GANGS]]
MENU_ADMIN:AddMenuButton(mg2.lang:GetTranslation("gangs"), {
    index = 1,
    menuHints = {
        "Gangs not appearing? Type the command mg2_reload in your console and re-open the menu."
    },
    defaultTab = true,
    doClick = function(btn, pnl)
        MENU_ADMIN:OpenGangs(pnl)
    end,
})

local function openGangOptions(gang, res)
    local gangid, gData = res.id, res.data

    if !(gangid) then return end

    local frame = vgui.Create("mg2.Frame")
    frame:SetSize(350,500)
    frame:Center()
    frame:MakePopup()
    frame:SetTitle(mg2.lang:GetTranslation("modifygang"))
    frame:SetBackgroundBlur(true)

    -- Load Gang Options
    local gangOpts = mg2.admin:GetOptionsFor("gang")
    local noOptsText = mg2.lang:GetTranslation("nooptions")

    local gangOptSPnl = vgui.Create("mg2.Scrollpanel", frame)
    gangOptSPnl:Dock(FILL)
    gangOptSPnl:DockMargin(3,3,3,3)
    gangOptSPnl.PaintOver = function(s,w,h)
        if (table.Count(gangOpts) <= 0) then
            draw.SimpleText(noOptsText,"mg2.GANGMENU.MEDIUM",w/2,h/2,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end
    end

    for k,v in SortedPairsByMemberValue(gangOpts, "vguiIndex") do
        local uName, name = v:GetUniqueName(), v:GetName()
        
        if (v.loadVgui) then
            v:loadVgui(gangOptSPnl, gangid, gang)
        else
            local btn = vgui.Create("mg2.Button", gangOptSPnl)
            btn:Dock(TOP)
            btn:DockMargin(0,3,0,0)
            btn:SetText(name)
            btn.DoClick = function()
                v:onUserCall({gangid = gangid}, 
                function()
                    frame:Remove()
                end)
            end
        end
    end
end

function MENU_ADMIN:OpenGangs(pnl)
    local gGangCont = vgui.Create("mg2.Container", pnl)
    gGangCont:Dock(FILL)
    gGangCont:DockMargin(5,5,5,5)
    gGangCont:SetRounded(false)

    local header = vgui.Create("mg2.Header", gGangCont)
    header:Dock(TOP)
    header:SetRounded(false)
    header:SetText(mg2.lang:GetTranslation("gangs"))

    --[[Gang list]]
    local gGangSPnl = vgui.Create("mg2.Searchpanel", gGangCont)
    gGangSPnl:Dock(FILL)
    gGangSPnl:DockMargin(5,5,5,5)
    
    local function selectPage(pg)
        zlib.network:CallAction("mg2.gang.adminRequest", {reqName = "getGangs", page = pg},
        function(data)
            if !(IsValid(gGangSPnl)) then return end

            local totalPgs, gangs = data.totalPages, data.gangs

            gGangSPnl:SetTotalPages(totalPgs)
            gGangSPnl:SetResults(gangs)
        end)
    end

    local function searchVal(val)
        zlib.network:CallAction("mg2.gang.adminRequest", {reqName = "getGangs", searchVal = val},
        function(data)
            if !(IsValid(gGangSPnl)) then return end

            local gangs = data.gangs

            gGangSPnl:SetTotalPages(1)
            gGangSPnl:SetResults(gangs)
        end)
    end

    function gGangSPnl:OnSetupResult(sPnl, res)
        if !(res) then return end

        local gangid, gangData = res.id, (res.data || {})
        gangData.ID = gangid

        local tempGang = (mg2.gang:Get(gangid) || mg2.gang:SetupTemporary(gangData))

        if !(tempGang) then return end

        local gcH = 45

        local gangPnl = vgui.Create("mg2.Container", sPnl)
        gangPnl:Dock(TOP)
        gangPnl:DockMargin(0,3,0,0)
        gangPnl:SetTall(gcH)
        gangPnl.PaintOver = function(s,w,h)
            draw.SimpleText(tempGang:GetName(),"mg2.ADMINMENU.MEDIUM",gcH+3,3,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
            draw.SimpleText("ID: " .. (gangid or "?"),"mg2.ADMINMENU.SMALL",gcH+3,h-3,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM)
        end

        -- Gang Icon
        local gIconCont = vgui.Create("DPanel", gangPnl)
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
            gIcon:SetURL(tempGang:GetIcon())
            gIcon:SetMaterialPrefix(string.format("%s%s", tempGang:GetID(), tempGang:GetName()))
        end)

        -- Gang Modify
        local modifyTxt = mg2.lang:GetTranslation("modify")
        local gangModBtn = vgui.Create("mg2.Button", gangPnl)
        gangModBtn:Dock(RIGHT)
        gangModBtn:DockMargin(3,3,3,3)
        gangModBtn:SetText(modifyTxt)
        gangModBtn.DoClick = function(s)
            openGangOptions(tempGang, res)
        end

        -- Set button W based on text W
        local tW, tH = zlib.util:GetTextSize(modifyTxt, gangModBtn:GetFont())
        gangModBtn:SetWide(tW + 20)
    end

    function gGangSPnl:OnPreviousPage(pg) 
        selectPage(pg)

        return true
    end

    function gGangSPnl:OnNextPage(pg) 
        selectPage(pg)

        return true
    end

    function gGangSPnl:OnSearch(sVal)
        searchVal(sVal)

        return true
    end

    selectPage(1)
end

--[[USERS]]
MENU_ADMIN:AddMenuButton(mg2.lang:GetTranslation("users"), {
    index = 2,
    menuHints = {
        "A green dot next to a users name means they're on the server!",
        "Remember: You can only set a users gang with the gang ID."
    },
    doClick = function(btn, pnl)
        MENU_ADMIN:OpenUsers(pnl)
    end,
})

local function sortOnlineUsers(users)
    local setUsers = {}

    for k,v in pairs(users) do
        local ply = zlib.util:GetPlayerBySteamID(v.steamid)

        if (ply) then
            v.player = ply

            table.insert(setUsers, 1, v)
        else
            table.insert(setUsers, v)
        end
    end

    return setUsers
end

local function openUserOptions(res)
    local gangid, uData = (res.gangid), (res.data)

    if !(uData) then return end

    local steamid = res.steamid

    local frame = vgui.Create("mg2.Frame")
    frame:SetSize(350,500)
    frame:Center()
    frame:MakePopup()
    frame:SetTitle(mg2.lang:GetTranslation("modifyuser"))
    frame:SetBackgroundBlur(true)

    -- Load User Options
    local userOpts = mg2.admin:GetOptionsFor("user")

    local userOptSPnl = vgui.Create("mg2.Scrollpanel", frame)
    userOptSPnl:Dock(FILL)
    userOptSPnl:DockMargin(3,3,3,3)
    userOptSPnl.PaintOver = function(s,w,h)
        if (table.Count(userOpts) <= 0) then
            draw.SimpleText(mg2.lang:GetTranslation("nooptions"),"mg2.GANGMENU.MEDIUM",w/2,h/2,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end
    end

    for k,v in SortedPairsByMemberValue(userOpts, "vguiIndex") do
        local uName, name = v:GetUniqueName(), v:GetName()
        
        if (v.loadVgui) then
            v:loadVgui(userOptSPnl, steamid, gangid)
        else
            local btn = vgui.Create("mg2.Button", userOptSPnl)
            btn:Dock(TOP)
            btn:DockMargin(0,3,0,0)
            btn:SetText(name)
            btn.DoClick = function()
                v:onUserCall({steamid = steamid}, 
                function()
                    frame:Remove()
                end)
            end
        end
    end
end

function MENU_ADMIN:OpenUsers(pnl)
    local gPlayerCont = vgui.Create("mg2.Container", pnl)
    gPlayerCont:Dock(FILL)
    gPlayerCont:DockMargin(5,5,5,5)
    gPlayerCont:SetRounded(false)

    local header = vgui.Create("mg2.Header", gPlayerCont)
    header:Dock(TOP)
    header:SetRounded(false)
    header:SetText(mg2.lang:GetTranslation("users"))

    --[[Gang list]]
    local gPlayerSPnl = vgui.Create("mg2.Searchpanel", gPlayerCont)
    gPlayerSPnl:Dock(FILL)
    gPlayerSPnl:DockMargin(5,5,5,5)
    
    local function selectPage(pg)
        zlib.network:CallAction("mg2.gang.adminRequest", {reqName = "getUsers", page = pg},
        function(data)
            if !(IsValid(gPlayerSPnl)) then return end

            local totalPgs, users = data.totalPages, sortOnlineUsers(data.users)

            gPlayerSPnl:SetTotalPages(totalPgs)
            gPlayerSPnl:SetResults(users)
        end)
    end

    local function searchVal(val)
        zlib.network:CallAction("mg2.gang.adminRequest", {reqName = "getUsers", searchVal = val},
        function(data)
            if !(IsValid(gPlayerSPnl)) then return end

            local users = sortOnlineUsers(data.users)

            gPlayerSPnl:SetTotalPages(1)
            gPlayerSPnl:SetResults(users)
        end)
    end

    function gPlayerSPnl:OnSetupResult(sPnl, res)
        local group = res.group_id
        
        local userData = (res && res.data)
        local ply = zlib.util:GetPlayerBySteamID(res.steamid)
        local onlineIcon = Material("icon16/bullet_green.png")

        local userPnl = vgui.Create("mg2.Container", sPnl)
        userPnl:Dock(TOP)
        userPnl:DockMargin(0,3,0,0)
        userPnl:SetTall(30)
        userPnl.PaintOver = function(s,w,h)
            local pX = 5
            local pNick = (IsValid(ply) && ply:Nick() || userData && userData.name)

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

            draw.SimpleText(pNick,"mg2.ADMINMENU.MEDIUM",pX,h/2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        end

        -- User Modify
        local modifyTxt = mg2.lang:GetTranslation("modify")
        local userModBtn = vgui.Create("mg2.Button", userPnl)
        userModBtn:Dock(RIGHT)
        userModBtn:DockMargin(3,3,3,3)
        userModBtn:SetText(modifyTxt)
        userModBtn.DoClick = function(s)
            openUserOptions(res)
        end

        -- Set button W based on text W
        local tW, tH = zlib.util:GetTextSize(modifyTxt, userModBtn:GetFont())
        userModBtn:SetWide(tW + 20)
    end

    function gPlayerSPnl:OnPreviousPage(pg) 
        selectPage(pg)

        return true
    end

    function gPlayerSPnl:OnNextPage(pg) 
        selectPage(pg)

        return true
    end

    function gPlayerSPnl:OnSearch(sVal)
        searchVal(sVal)

        return true
    end

    selectPage(1)
end