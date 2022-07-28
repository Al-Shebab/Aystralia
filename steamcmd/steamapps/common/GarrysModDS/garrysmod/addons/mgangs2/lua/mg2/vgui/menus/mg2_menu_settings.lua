--[[
    --[[
    MGangs 2 - (SH) VGUI MENU - Settings
    Developed by Zephruz
]]

if (CLIENT) then

surface.CreateFont("mg2.SETTINGSMENU.LARGE", {
    font = "Abel",
    size = 25,
})

surface.CreateFont("mg2.SETTINGSMENU.MEDIUM", {
    font = "Abel",
    size = 21,
})

surface.CreateFont("mg2.SETTINGSMENU.SMALL", {
    font = "Abel",
    size = 17,
})

end

local MENU_SETTINGS = mg2.vgui:RegisterMenu("mg2.Settings")
MENU_SETTINGS:SetConsoleCommands({"gangsettings", "mg2_settings"})
MENU_SETTINGS:SetChatCommands({"!gangsettings", "!mg2settings"})

MENU_SETTINGS:setData("MenuButtons", {}, {
    shouldSave = false,
    onSet = function(s,val,oVal,data)
        if !(data) then return val end

        oVal = (oVal or {})
        oVal[val] = data

        return oVal
    end,
})

MENU_SETTINGS:setData("UserSettings", {}, {
    shouldSave = false,
    onSet = function(s,val,oVal,data)
        if !(data) then return val end

        oVal = (oVal or {})
        oVal[val] = data

        return oVal
    end,
})

function MENU_SETTINGS:Init()
    self.frame = vgui.Create("mg2.Frame")
    self.frame:SetSize(850,500)
    self.frame:Center()
    self.frame:MakePopup()
    self.frame:SetTitle("")
    self.frame:SetFrameBlur(true)

    self:LoadSideNavigation()

    local topNavBtns = {
        [mg2.lang:GetTranslation("gang")] = {
            index = 1,
            setVis = LocalPlayer():GetGang(),
            doClick = function()
                local gMenu = mg2.vgui:GetMenu("mg2.Gang")

                if (gMenu) then 
                    gMenu:Init()

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
        tnavBtn:SetWide(v.width or (tW + 20))

        local setVis = v.setVis

        if (setVis != nil) then
            tnavBtn:SetVisible(setVis)
        end
    end
end

function MENU_SETTINGS:LoadSideNavigation()
    if !(IsValid(self.frame)) then return end

    local menuBtns = self:GetMenuButtons()

    for k,v in SortedPairsByMemberValue(menuBtns, "index") do
        self:AddMenuButton(k, v)
    end
end

function MENU_SETTINGS:AddMenuButton(text, data)
    self:SetMenuButtons(text, (data or {}))

    if (IsValid(self.frame)) then
        self.frame:AddSideNavigationButton(text, data)
    end
end

--[[User Settings]]
MENU_SETTINGS:AddMenuButton(mg2.lang:GetTranslation("usersettings"), {
    index = 1,
    defaultTab = true,
    doClick = function(btn, pnl)
        MENU_SETTINGS:LoadUserSettings(pnl)
    end,
})

function MENU_SETTINGS:AddUserSetting(text, data)
    self:SetUserSettings(text, data)
end

function MENU_SETTINGS:LoadUserSettings(pnl)
    local pOverTxt = false

    pnl.PaintOver = function(s,w,h)
        if !(pOverTxt) then return end

        draw.SimpleText(pOverTxt,"mg2.SETTINGSMENU.MEDIUM",w/2,h/2,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end

    if !(IsValid(pnl)) then pOverTxt = mg2.lang:GetTranslation("nousersettings") return end

    local uSettingCont = vgui.Create("mg2.Container", pnl)
    uSettingCont:Dock(FILL)
    uSettingCont:DockMargin(5,5,5,5)
    uSettingCont:SetRounded(false)

    local header = vgui.Create("mg2.Header", uSettingCont)
    header:Dock(TOP)
    header:SetText(mg2.lang:GetTranslation("usersettings"))
    header:SetRounded(false)

    -- User settings
    local totalSettings = 0
    local uSettings = self:GetUserSettings()

    for k,v in pairs(uSettings) do
        local shouldShow = (!v.shouldShow or v.shouldShow())

        if (shouldShow && v.loadEle) then
            totalSettings = totalSettings + 1

            v.loadEle(uSettingCont)
        end
    end

    if (totalSettings <= 0) then
        pOverTxt = mg2.lang:GetTranslation("nousersettings")
    end
end

-- Default settings
MENU_SETTINGS:AddUserSetting(mg2.lang:GetTranslation("leavegang"), {
    shouldShow = function() return LocalPlayer():GetGang() end,
    loadEle = function(pnl)
        local lgBtn = vgui.Create("mg2.Button", pnl)
        lgBtn:Dock(TOP)
        lgBtn:DockMargin(3,3,3,0)
        lgBtn:SetText(mg2.lang:GetTranslation("leavegang"))
        lgBtn:SetDoubleClickConfirm(true)
        lgBtn.OnConfirm = function(s)
            zlib.network:CallAction("mg2.gang.userRequest", {reqName = "leaveGang"},
            function(res)
                if (res) then
                    s:Remove()
                end
            end)
        end
    end,
})

--[[Gang Settings]]
MENU_SETTINGS:AddMenuButton(mg2.lang:GetTranslation("gangsettings"), {
    index = 2,
    doClick = function(btn, pnl)
        MENU_SETTINGS:LoadGangSettings(pnl)
    end,
})

function MENU_SETTINGS:LoadGangSettings(pnl)
    local gang, gangGroup = LocalPlayer():GetGang(), LocalPlayer():GetGangGroup()

    local pOverTxt = false

    pnl.PaintOver = function(s,w,h)
        if !(pOverTxt) then return end

        draw.SimpleText(pOverTxt,"mg2.SETTINGSMENU.MEDIUM",w/2,h/2,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end

    if (!IsValid(pnl) or !gang or !gangGroup) then pOverTxt = mg2.lang:GetTranslation("nogangsettings") return end

    local gSettingCont = vgui.Create("mg2.Container", pnl)
    gSettingCont:Dock(FILL)
    gSettingCont:DockMargin(5,5,5,5)
    gSettingCont:SetRounded(false)

    local header = vgui.Create("mg2.Header", gSettingCont)
    header:Dock(TOP)
    header:SetText(mg2.lang:GetTranslation("gangsettings"))
    header:SetRounded(false)

    --[[Gang settings options]]
    local gSetSPnl = vgui.Create("mg2.Scrollpanel", gSettingCont)
    gSetSPnl:Dock(FILL)

    local gOpts = mg2.vgui:GetMetatableOptions("mg2.Gang", "gang.Settings")

    -- Load edit options
    local totalOpts = 0

    for k,v in SortedPairsByMemberValue(gOpts, "index") do
        local ele = (v.createEle && v.createEle(v, gSettingCont, gang))

        if (IsValid(ele)) then
            totalOpts = totalOpts + 1

            ele:SetParent(gSetSPnl)
        end
    end

    -- Load group options
    local hasPerm = (gangGroup:GetPermissions("removegroup") or gangGroup:GetPermissions("creategroup"))

    if (hasPerm) then
        self:LoadGroupModification(gSetSPnl)
    
        totalOpts = totalOpts + 1
    end

    if (totalOpts <= 0) then
        gSettingCont:Remove()

        pOverTxt = mg2.lang:GetTranslation("nogangsettings")
    end
end

function MENU_SETTINGS:LoadGroupModification(pnl)
    if !(IsValid(pnl)) then return end

    local gang, pGroup = LocalPlayer():GetGang(), LocalPlayer():GetGangGroup()

    if (!gang or !pGroup) then return end

    local groups = mg2.gang:GetGroups(gang:GetID())

    local function modifyGroup(group)
        local frame = vgui.Create("mg2.Frame")
        frame:SetSize(500,400)
        frame:Center()
        frame:MakePopup()
        frame:SetTitle(mg2.lang:GetTranslation("modifyinggroup") .. " (" .. (group:GetName() or "NIL") .. ")")
        frame:SetBackgroundBlur(true)
        frame.OnClose = function(s)
            local perm = mg2.gang:GetPermission("modifygroup")
            local gid, gData = group:GetID(), group:getValidatedData()

            perm:onUserCall({ gid, gData },
            function(success)
                if !(success) then return end

                s:Remove()
            end)
        end

        local modGroupCont = vgui.Create("mg2.Container", frame)
        modGroupCont:Dock(FILL)
        modGroupCont:DockMargin(5,5,5,5)

        --[[Group modify options]]
        local mGrpSPnl = vgui.Create("mg2.Scrollpanel", modGroupCont)
        mGrpSPnl:Dock(FILL)

        local grpOpts = mg2.vgui:GetMetatableOptions("mg2.GangGroup", "gang.GroupEdit")

        -- Load edit options
        for k,v in SortedPairsByMemberValue(grpOpts, "index") do
            local ele = (v.createEle && v.createEle(v, modGroupCont, group))

            if (IsValid(ele)) then
                ele:SetParent(mGrpSPnl)
            end
        end
    end

    local function loadGroups(pnl)
        pnl:Clear()

        for k,v in pairs(groups) do
            local icon = v:GetIcon()
            local mat = Material(icon)

            local defGrp = vgui.Create("DPanel", pnl)
            defGrp:Dock(TOP)
            defGrp:DockMargin(3,3,3,0)
            defGrp.Paint = function(s,w,h)
                if (v:GetIcon() != icon) then
                    icon = v:GetIcon()
                    mat = Material(icon)
                end

                draw.RoundedBoxEx(4,0,0,w,h,Color(45,45,45),true,true,true,true)
                
                local iW, iH = 16, 16

                surface.SetMaterial(mat)
                surface.SetDrawColor(255,255,255,255)
                surface.DrawTexturedRect(5, (h/2 - iH/2), iW, iH)

                -- Info
                draw.SimpleText(v:GetName(), "mg2.CREATIONMENU.SMALL", 25, h/2, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end

            -- Modify group
            if (pGroup && pGroup:GetPermissions("modifygroup")) then
                local modifyTxt = mg2.lang:GetTranslation("modify")
                local modifyBtn = vgui.Create("mg2.Button", defGrp)
                modifyBtn:Dock(RIGHT)
                modifyBtn:DockMargin(3,3,3,3)
                modifyBtn:SetText(modifyTxt)
                modifyBtn.DoClick = function()
                    modifyGroup(v)
                end

                -- Set button W based on text W
                local tW, tH = zlib.util:GetTextSize(modifyTxt, modifyBtn:GetFont())
                modifyBtn:SetWide(tW + 20)
            end

            -- Remove/delete group
            if (pGroup && pGroup:GetPermissions("removegroup")) then
                local groupid = v:GetID()

                if (groupid && !v:GetIsRecruit() && !v:GetIsLeader()) then
                    local deleteTxt =mg2.lang:GetTranslation("remove")
                    local deleteBtn = vgui.Create("mg2.Button", defGrp)
                    deleteBtn:Dock(RIGHT)
                    deleteBtn:DockMargin(3,3,3,3)
                    deleteBtn:SetText(deleteTxt)
                    deleteBtn.DoClick = function(s)
                        local perm = mg2.gang:GetPermission("removegroup")
                        
                        perm:onUserCall({ groupid },
                        function(success)
                            if !(success) then return end

                            table.remove(groups, k)

                            defGrp:Remove()
                        end)
                    end

                    -- Set button W based on text W
                    local tW, tH = zlib.util:GetTextSize(deleteTxt, deleteBtn:GetFont())
                    deleteBtn:SetWide(tW + 20)
                end
            end
        end
    end

    local goptsCont = vgui.Create("DPanel", pnl)
    goptsCont:Dock(TOP)
    goptsCont:DockMargin(3,3,3,0)
    goptsCont:SetTall(250)
    goptsCont.Paint = function(s,w,h) end

    local header = vgui.Create("mg2.Header", goptsCont)
    header:Dock(TOP)
    header:SetRounded(true)
    header:SetText(mg2.lang:GetTranslation("modifygroups"))

    --[[Group List]]
    local goptsSPnl = vgui.Create("mg2.Scrollpanel", goptsCont)
    goptsSPnl:Dock(FILL)

    -- Add/create group
    local perm = mg2.gang:GetPermission("creategroup")

    if (perm && pGroup && pGroup:GetPermissions("creategroup")) then
        local createGroupTxt = mg2.lang:GetTranslation("creategroup")
        local addGroup = vgui.Create("mg2.Button", header)
        addGroup:Dock(RIGHT)
        addGroup:DockMargin(3,3,3,3)
        addGroup:SetText(createGroupTxt)
        addGroup.DoClick = function()
            local group = mg2.gang:SetupTemporaryGroup({Name = mg2.lang:GetTranslation("newgroup")})

            perm:onUserCall({ group:getValidatedData() },
            function(groupid)
                local group = mg2.gang:GetGroup(groupid)

                if !(group) then return end

                table.insert(groups, group)

                loadGroups(goptsSPnl)
            end)
        end

        -- Set button W based on text W
        local tW, tH = zlib.util:GetTextSize(createGroupTxt, addGroup:GetFont())
        addGroup:SetWide(tW + 20)
    end

    loadGroups(goptsSPnl)
end