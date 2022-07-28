--[[
    MGangs 2 - (SH) VGUI MENU - Gang Creation
    Developed by Zephruz
]]

if (CLIENT) then

surface.CreateFont("mg2.CREATIONMENU.SMALL", {
    font = "Abel",
    size = 17,
})

end

local MENU_GANGCREATION = mg2.vgui:RegisterMenu("mg2.GangCreation")
MENU_GANGCREATION:SetConsoleCommands({"gangcreate", "creategang", "mg2_creategang"})
MENU_GANGCREATION:SetChatCommands({"!gangcreate", "!creategang", "!mg2creategang"})

function MENU_GANGCREATION:Init()
    if (IsValid(self.frame)) then self.frame:Remove() end
    if (LocalPlayer():GetGang()) then return end

    self:setData("Groups", {})
    self:setData("Gang", {})

    self.frame = vgui.Create("mg2.Frame")
    self.frame:SetSize(850,500)
    self.frame:Center()
    self.frame:MakePopup()
    self.frame:SetTitle(mg2.lang:GetTranslation("gangcreation"))

    -- Create gang button
    local createGang = vgui.Create("mg2.Button", self.frame)
    createGang:Dock(BOTTOM)
    createGang:DockMargin(5,0,5,5)
    createGang:SetText(mg2.lang:GetTranslation("creategang") .. (mg2.config.gangCost > 0 && " (" .. mg2.gang:FormatCurrency(mg2.config.gangCost) .. ")" || ""))
    createGang.DoClick = function(s)
        local gpsData, groups = {}, self:GetGroups()

        for k,v in pairs(groups) do
            gpsData[k] = v:getValidatedData()
        end

        local gang = self:GetGang()
        gang = (gang && gang:getValidatedData() || {})

        zlib.network:CallAction("mg2.gang.userRequest", {
            reqName = "createGang", 
            gang = gang,
            groups = gpsData,
        },
        function(data)
            local res, msg = data.res, data.msg

            self.frame:Remove()

            if (msg) then
                mg2:Notification(mg2.lang:GetCurrent():getTranslation(msg))
            end
        end)
    end
    
    self:LoadCreationOptions()
    self:LoadGroupCreation()
end

function MENU_GANGCREATION:LoadCreationOptions()
    if !(IsValid(self.frame)) then return end

    local coptsCont = vgui.Create("mg2.Container", self.frame)
    coptsCont:Dock(TOP)
    coptsCont:DockMargin(5,5,5,0)
    coptsCont:SetTall(210)

    local header = vgui.Create("mg2.Header", coptsCont)
    header:Dock(TOP)
    header:SetRounded(false)
    header:SetText(mg2.lang:GetTranslation("generalinfo"))

    --[[Creation Options]]
    local coptsSPnl = vgui.Create("mg2.Scrollpanel", coptsCont)
    coptsSPnl:Dock(FILL)
    coptsSPnl:DockMargin(5,5,5,5)

    local tempGang = self:SetGang(mg2.gang:SetupTemporary())
    local gangOpts = mg2.vgui:GetMetatableOptions("mg2.Gang", "gang.Create")

    -- Load creation options
    for k,v in SortedPairsByMemberValue(gangOpts, "index") do
        local ele = (v.createEle && v.createEle(v, coptsSPnl, tempGang))
        
        if (IsValid(ele)) then
            ele:SetParent(coptsSPnl)
        end
    end

    coptsCont:InvalidateLayout(true)

    timer.Simple(0.3,
    function()
        coptsCont:SizeToChildren(false, true)
    end)
end

function MENU_GANGCREATION:LoadGroupCreation()
    if !(IsValid(self.frame)) then return end

    local groups = {}

    local function modifyGroup(group)
        local frame = vgui.Create("mg2.Frame")
        frame:SetSize(500,400)
        frame:Center()
        frame:MakePopup()
        frame:SetTitle(mg2.lang:GetTranslation("modifyinggroup") .. " (" .. (group:GetName() or "NIL") .. ")")
        frame:SetBackgroundBlur(true)

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

        self:SetGroups(groups)

        for k,v in pairs(groups) do
            local icon = v:GetIcon()
            local mat = Material(icon)

            local defGrp = vgui.Create("DPanel", pnl)
            defGrp:Dock(TOP)
            defGrp:DockMargin(5,5,5,0)
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

            if !(v.isDefault) then
                local deleteBtn = vgui.Create("mg2.Button", defGrp)
                deleteBtn:Dock(RIGHT)
                deleteBtn:DockMargin(3,3,3,3)
                deleteBtn:SetText(mg2.lang:GetTranslation("remove"))
                deleteBtn.DoClick = function(s)
                    table.remove(groups, k)

                    defGrp:Remove()

                    self:SetGroups(groups)
                end
            end
        end
    end

    local goptsCont = vgui.Create("mg2.Container", self.frame)
    goptsCont:Dock(FILL)
    goptsCont:DockMargin(5,5,5,5)
    goptsCont:SetRounded(false)

    local header = vgui.Create("mg2.Header", goptsCont)
    header:Dock(TOP)
    header:SetRounded(false)
    header:SetText(mg2.lang:GetTranslation("modifygroups"))

    --[[Group List]]
    local goptsSPnl = vgui.Create("mg2.Scrollpanel", goptsCont)
    goptsSPnl:Dock(FILL)

    -- Default groups
    for k,v in pairs(mg2.config.defaultGroups) do
        v.Name = k

        local group = mg2.gang:SetupTemporaryGroup(v)
        group.isDefault = true

        table.insert(groups, group)
    end

    -- Create group
    local createGroupTxt = mg2.lang:GetTranslation("creategroup")
    local createGroup = vgui.Create("mg2.Button", header)
    createGroup:Dock(RIGHT)
    createGroup:DockMargin(3,3,3,3)
    createGroup:SetText(createGroupTxt)
    createGroup.DoClick = function()
        table.insert(groups, mg2.gang:SetupTemporaryGroup({Name = mg2.lang:GetTranslation("newgroup")}))

        loadGroups(goptsSPnl)
    end

    -- Set button W based on text W
    local tW, tH = zlib.util:GetTextSize(createGroupTxt, createGroup:GetFont())
    createGroup:SetWide(tW + 20)

    loadGroups(goptsSPnl)
end