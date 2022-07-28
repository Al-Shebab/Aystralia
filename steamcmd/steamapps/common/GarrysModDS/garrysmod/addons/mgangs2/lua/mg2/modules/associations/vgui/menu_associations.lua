--[[
     MGangs 2 - ASSOCIATIONS - (SH) Menu
    Developed by Zephruz
]]

if (CLIENT) then

surface.CreateFont("mg2.ASSOCIATIONMENU.LARGE", {
    font = "Abel",
    size = 25,
})

surface.CreateFont("mg2.ASSOCIATIONMENU.MEDIUM", {
    font = "Abel",
    size = 21,
})

surface.CreateFont("mg2.ASSOCIATIONMENU.SMALL", {
    font = "Abel",
    size = 17,
})

end

local MENU_ASSOCIATIONS = {}

--[[Send requests]]
local function requestAssociationMenu()
    local gang = LocalPlayer():GetGang()

    if !(gang) then return end

    local frame = vgui.Create("mg2.Frame")
    frame:SetSize(400,350)
    frame:SetTitle(mg2.lang:GetTranslation("associations.Request"))
    frame:Center()
    frame:MakePopup()
    frame:SetBackgroundBlur(true)

    -- Gangs
    local gangSPnl = vgui.Create("mg2.Scrollpanel", frame)
    gangSPnl:Dock(FILL)
    gangSPnl:DockMargin(5,5,5,5)

    for k,v in pairs(mg2.gang:GetAll()) do
        local gName, gid = v:GetName(), v:GetID()

        if (gid != gang:GetID()) then
            local pnlH = 42

            local gangPnl = vgui.Create("mg2.Container", gangSPnl)
            gangPnl:Dock(TOP)
            gangPnl:DockMargin(0,0,0,3)
            gangPnl:SetTall(pnlH)
            gangPnl.PaintOver = function(s,w,h)
                draw.SimpleText(gName,"mg2.ACHIEVEMENTMENU.MEDIUM",pnlH + 3,h/2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            end

            -- Gang Icon
            local gIconCont = vgui.Create("DPanel", gangPnl)
            gIconCont:Dock(LEFT)
            gIconCont:DockMargin(3,3,3,3)
            gIconCont:SetWide(pnlH)
            gIconCont.Paint = function() end

            gIconCont:InvalidateLayout(true)

            timer.Simple(0.1,
            function()
                if !(IsValid(gIconCont)) then return end
                
                local gIconW, gIconH = gIconCont:GetSize()

                local gIcon = vgui.Create("mg2.HTMLImage", gIconCont)
                gIcon:SetSize(gIconH, gIconH)
                gIcon:SetURL(v:GetIcon())
                gIcon:SetMaterialPrefix(string.format("%s%s", v:GetID(), v:GetName()))
            end)

            -- Set association
            local setAssocBtn = vgui.Create("mg2.Button", gangPnl)
            setAssocBtn:Dock(RIGHT)
            setAssocBtn:DockMargin(3,3,3,3)
            setAssocBtn:SetText(mg2.lang:GetTranslation("associations.Request"))
            setAssocBtn:SetWide(125)
            setAssocBtn.DoClick = function(s)
                local assocTypes = MG2_ASSOCIATIONS:GetAssociationTypes()
                local perm = mg2.gang:GetPermission("associations.RequestAssociation")
                
                local dMenu = DermaMenu(s)

                for k,v in pairs(assocTypes) do
                    local opt = dMenu:AddOption(k,
                    function()
                        perm:onUserCall({gid, k}, 
                        function(res)
                            if !(IsValid(frame)) then return end
                            
                            frame:Remove()
                        end)
                    end)

                    if (v.icon) then
                        opt:SetIcon(v.icon)
                    end
                end

                dMenu:Open()
            end
        end
    end
end

--[[View sent & received requests]]
local function viewRequestsMenu()
    local gang = LocalPlayer():GetGang()

    if !(gang) then return end

    local frame = vgui.Create("mg2.Frame")
    frame:SetSize(700, 500)
    frame:SetTitle(mg2.lang:GetTranslation("associations.Requests"))
    frame:Center()
    frame:MakePopup()
    frame:SetBackgroundBlur(true)

    local gnavBtn = frame:AddTopNavigationButton(mg2.lang:GetTranslation("back"))
    gnavBtn:SetWide(60)
    gnavBtn.DoClick = function()
        local gMenu = mg2.vgui:GetMenu("mg2.Gang")

        if (gMenu) then 
            gMenu:Init()

            frame:Remove()
        end
    end

    -- Requests
    local reqCont = vgui.Create("mg2.Container", frame)
    reqCont:Dock(FILL)
    reqCont:DockMargin(5,5,5,5)
    reqCont:SetRounded(false)

    local reqSPnl = vgui.Create("mg2.Scrollpanel", reqCont)
    reqSPnl:Dock(FILL)
    reqSPnl:DockMargin(3,3,3,3)

    -- Get Requests
    zlib.network:CallAction("mg2.achievements.userRequest", {reqName = "getRequests"},
    function(reqs)
        if !(IsValid(reqSPnl)) then return end

        reqSPnl:Clear()

        -- Sort received/sent requests
        local sent, received = {}, {}

        for k,v in pairs(reqs) do
            if (v.req_gangid == gang:GetID()) then
                sent[k] = v
            else
                received[k] = v
            end
        end

        local reqTypes = {
            --[[["Sent"] = {
                tbl = sent,
                loadCont = function(cont,data)
                    cont.PaintOver = function(s,w,h)

                    end
                end,
            },]]
            [mg2.lang:GetTranslation("received")] = {
                tbl = received,
                loadCont = function(cont,reqData)
                    if !(reqData) then return end
                    
                    local rData, reqid = reqData.data, reqData.id
                    
                    local assocType = MG2_ASSOCIATIONS:GetAssociationTypes(reqData.association_type)
                    local icon = (assocType && assocType.icon)
                    icon = (icon && Material(icon))

                    cont.PaintOver = function(s,w,h)
                        local tX = 5

                        if (icon) then
                            tX = 25

                            local iH, iW = 16, 16

                            surface.SetDrawColor(Color(255,255,255))
                            surface.SetMaterial(icon)
                            surface.DrawTexturedRect(5, (h/2 - iH/2), iH, iW)
                        end

                        draw.SimpleText((rData && rData.name || "INVALID"),"mg2.ACHIEVEMENTMENU.MEDIUM",tX,h/2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
                    end

                    -- Response
                    local perm = mg2.gang:GetPermission("associations.RequestRespond")

                    if !(perm) then return end
                    
                    local respBtn = vgui.Create("mg2.Button", cont)
                    respBtn:Dock(RIGHT)
                    respBtn:DockMargin(3,3,3,3)
                    respBtn:SetText(mg2.lang:GetTranslation("received"))
                    respBtn.DoClick = function(s)
                        local respTypes = {[mg2.lang:GetTranslation("accept")] = true, [mg2.lang:GetTranslation("decline")] = false}

                        local dMenu = DermaMenu(s)

                        for k,v in pairs(respTypes) do
                            dMenu:AddOption(k,
                            function()
                                perm:onUserCall({ reqid, v },
                                function(res)
                                    if !(res) then return end

                                    if (IsValid(cont)) then cont:Remove() end
                                end)
                            end)
                        end

                        dMenu:Open()
                    end
                end,
            }, 
        }

        for rName,rType in pairs(reqTypes) do
            local tbl = rType.tbl
            local header = vgui.Create("mg2.Header", reqSPnl)
            header:Dock(TOP)
            header:DockMargin(0,0,0,0)
            header:SetText("(" .. table.Count(tbl) .. ") " .. rName)

            for k,v in pairs(tbl) do
                local reqCont = vgui.Create("mg2.Container", reqSPnl)
                reqCont:Dock(TOP)
                reqCont:DockMargin(0,3,0,0)
                reqCont:SetTall(35)
                
                rType.loadCont(reqCont, v)
            end
        end
    end)
end

function MENU_ASSOCIATIONS:Open(pnl)
    local gang, gGroup = LocalPlayer():GetGang(), LocalPlayer():GetGangGroup()

    if (!gang or !gGroup) then return end

    local assocCont = vgui.Create("mg2.Container", pnl)
    assocCont:Dock(FILL)
    assocCont:DockMargin(5,5,5,5)
    assocCont:SetRounded(false)

    local header = vgui.Create("mg2.Header", assocCont)
    header:Dock(TOP)
    header:SetRounded(false)
    header:SetText(mg2.lang:GetTranslation("associations"))

    -- Load associations
    local assocSPnl = vgui.Create("mg2.Scrollpanel", assocCont)
    assocSPnl:Dock(FILL)
    assocSPnl:DockMargin(5,5,5,5)

    -- Request association
    local hdrBtns = {
        [mg2.lang:GetTranslation("request")] = {
            canSee = gGroup:GetPermissions("associations.RequestAssociation"),
            doClick = function()
                requestAssociationMenu()
            end,
        },
        [mg2.lang:GetTranslation("viewrequests")] = {
            canSee = gGroup:GetPermissions("associations.RequestRespond"),
            width = 85,
            doClick = function()
                local gMenu = mg2.vgui:GetMenu("mg2.Gang")

                if (gMenu && IsValid(gMenu.frame)) then gMenu.frame:Remove() end

                viewRequestsMenu()
            end,
        },
    }

    for k,v in pairs(hdrBtns) do
        if (v.canSee) then
            local hdrBtn = vgui.Create("mg2.Button", header)
            hdrBtn:Dock(RIGHT)
            hdrBtn:DockMargin(0,3,3,3)
            hdrBtn:SetText(k)
            hdrBtn:SetWide(v.width or 50)
            hdrBtn.DoClick = function()
                v.doClick()
            end
        end
    end

    self:LoadAssociations(assocSPnl)
end

-- View association gangs menu
local function viewAssociationGangs(assoc)
    if !(assoc) then return end

    local id = assoc:GetID()

    local frame = vgui.Create("mg2.Frame")
    frame:SetSize(400,350)
    frame:SetTitle(mg2.lang:GetTranslation("associations.ViewingAssociationGangs") .. " (ID: " .. (id or "INVALID") .. ")")
    frame:Center()
    frame:MakePopup()
    frame:SetBackgroundBlur(true)

    -- Association gangs
    local assocSPnl = vgui.Create("mg2.Scrollpanel", frame)
    assocSPnl:Dock(FILL)
    assocSPnl:DockMargin(3,3,3,3)

    for k,v in pairs(assoc:GetGangs()) do
        local gang = mg2.gang:Get(k)

        if (gang) then
            local gName = gang:GetName()

            local pnlH = 42

            local assoc = vgui.Create("mg2.Container", assocSPnl)
            assoc:Dock(TOP)
            assoc:DockMargin(0,0,0,3)
            assoc:SetTall(pnlH)
            assoc.PaintOver = function(s,w,h)
                draw.SimpleText(gName,"mg2.ACHIEVEMENTMENU.MEDIUM",pnlH + 3,h/2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            end

            -- Gang Icon
            local gIconCont = vgui.Create("DPanel", assoc)
            gIconCont:Dock(LEFT)
            gIconCont:DockMargin(3,3,3,3)
            gIconCont:SetWide(pnlH)
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
        end
    end
end

--[[Load Associations]]
function MENU_ASSOCIATIONS:LoadAssociations(assocSPnl)
    assocSPnl:Clear()

    local gang, gGroup = LocalPlayer():GetGang(), LocalPlayer():GetGangGroup()

    if !(gang) then return end

    local assocs = MG2_ASSOCIATIONS:GetGangs(gang:GetID())

    assocSPnl.PaintOver = function(s,w,h)
        if (table.Count(assocs) <= 0) then
            draw.SimpleText(mg2.lang:GetTranslation("noassociations"),"mg2.ACHIEVEMENTMENU.MEDIUM",w/2,h/2,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end
    end
    
    for k,v in pairs(assocs) do
        local name, id, assocStatus = v:GetName(), v:GetID(), v:GetAssociation()
        local assocType = MG2_ASSOCIATIONS:GetAssociationTypes(assocStatus)
        local icon = (assocType && assocType.icon)
        icon = (icon && Material(icon))
        
        local assoc = vgui.Create("mg2.Container", assocSPnl)
        assoc:Dock(TOP)
        assoc:DockMargin(0,0,0,3)
        assoc:SetTall(42)
        assoc.PaintOver = function(s,w,h)
            local tX = 5

            if (icon) then
                tX = 25

                local iH, iW = 16, 16

                surface.SetDrawColor(Color(255,255,255))
                surface.SetMaterial(icon)
                surface.DrawTexturedRect(5, 5, iH, iW)
            end

            draw.SimpleText(name,"mg2.ACHIEVEMENTMENU.MEDIUM",tX,3,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
            draw.SimpleText("ID: " .. (id or "INVALID"),"mg2.ACHIEVEMENTMENU.SMALL",5,h-3,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM)
        end

        -- Permission Options
        local optBtn = vgui.Create("mg2.Button", assoc)
        optBtn:Dock(RIGHT)
        optBtn:DockMargin(3,3,3,3)
        optBtn:SetText(mg2.lang:GetTranslation("options"))
        optBtn:SetWide(65)
        optBtn.DoClick = function(s)
            local dMenu = DermaMenu(s)

            -- Permissions
            local perms = mg2.gang:GetPermissionsByType("association")

            for k,v in pairs(perms) do
                local permName, hasPerm = v:GetName(), gGroup:GetPermissions(k)

                if (hasPerm) then
                    dMenu:AddOption(permName,
                    function()
                        local perm = mg2.gang:GetPermission(k)

                        if !(perm) then return end

                        perm:onUserCall({ id },
                        function(res)
                            if !(res) then return end

                            self:LoadAssociations(assocSPnl)
                        end)
                    end)
                end
            end

            dMenu:Open()
        end

        -- View gangs
        local viewGangsBtn = vgui.Create("mg2.Button", assoc)
        viewGangsBtn:Dock(RIGHT)
        viewGangsBtn:DockMargin(3,3,0,3)
        viewGangsBtn:SetText(mg2.lang:GetTranslation("viewgangs"))
        viewGangsBtn:SetWide(70)
        viewGangsBtn.DoClick = function()
            viewAssociationGangs(v)
        end
    end
end

--[[GANG MENU BUTTON]]
local MENU_GANG = mg2.vgui:GetMenu("mg2.Gang")

if !(MENU_GANG) then return end

MENU_GANG:AddMenuButton(mg2.lang:GetTranslation("associations"), {
    index = 3,
    doClick = function(btn, pnl)
        MENU_ASSOCIATIONS:Open(pnl)
    end,
})