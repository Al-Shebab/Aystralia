--[[
     MGangs 2 - STASH - (SH) Menu
    Developed by Zephruz
]]

if (CLIENT) then

surface.CreateFont("mg2.STASHMENU.LARGE", {
    font = "Abel",
    size = 25,
})

surface.CreateFont("mg2.STASHMENU.MEDIUM", {
    font = "Abel",
    size = 21,
})

surface.CreateFont("mg2.STASHMENU.SMALL", {
    font = "Abel",
    size = 17,
})

end

local MENU_STASH = {}

function MENU_STASH:Open(pnl)
    local gangGroup = LocalPlayer():GetGangGroup()

    if !(gangGroup) then return end

    local achCont = vgui.Create("mg2.Container", pnl)
    achCont:Dock(FILL)
    achCont:DockMargin(5,5,5,5)
    achCont:SetRounded(false)

    local header = vgui.Create("mg2.Header", achCont)
    header:Dock(TOP)
    header:SetRounded(false)
    header:SetText("Stash")

    -- Deposit button
    local hasPerm = gangGroup:GetPermissions("stash.DepositItem")

    if (hasPerm) then
        local depositBtn = vgui.Create("mg2.Button", header)
        depositBtn:Dock(RIGHT)
        depositBtn:DockMargin(0,3,3,3)
        depositBtn:SetText("Deposit")
        depositBtn.DoClick = function()
            self:OpenDepositMenu()
        end
    end

    -- Load gang items
    self.stashSPnl = vgui.Create("mg2.Scrollpanel", achCont)
    self.stashSPnl:Dock(FILL)
    self.stashSPnl:DockMargin(5,5,5,5)
    self.stashSPnl.PaintOver = function(s,w,h)
        if (table.Count(s:GetCanvas():GetChildren()) <= 0) then
            draw.SimpleText(mg2.lang:GetTranslation("stash.NoItems"),"mg2.STASHMENU.MEDIUM",w/2,h/2,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end
    end

    self:LoadItems(self.stashSPnl)
end

function MENU_STASH:LoadItems(spnl)
    local gang = LocalPlayer():GetGang()

    if !(gang) then return end

    local gangGroup = LocalPlayer():GetGangGroup()
    local sItems = MG2_STASH:GetGangsItems(gang:GetID())

    spnl:Clear()

    for k,v in pairs(sItems) do
        local iName, iMdl, iid = v:GetName(), v:GetModel(), v:GetID()

        local item = vgui.Create("mg2.Container", spnl)
        item:Dock(TOP)
        item:DockMargin(0,0,0,3)
        item:SetTall(40)
        item.PaintOver = function(s,w,h)
            draw.SimpleText(iName,"mg2.STASHMENU.MEDIUM",w/2,h/2,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end

        local iModel = vgui.Create("mg2.ModelPanel", item)
        iModel:Dock(LEFT)
        iModel:SetWide(100)
        iModel:SetModel(iMdl)

        -- Withdraw
        local hasPerm = gangGroup:GetPermissions("stash.WithdrawItem")

        if (hasPerm) then
            local depBtn = vgui.Create("mg2.Button", item)
            depBtn:Dock(RIGHT)
            depBtn:DockMargin(3,3,3,3)
            depBtn:SetText("Withdraw")
            depBtn.DoClick = function(s)
                local perm = mg2.gang:GetPermission("stash.WithdrawItem")

                perm:onUserCall({ iid },
                function(res)
                    if (res && IsValid(item)) then item:Remove() end
                end)
            end
        end
    end
end

function MENU_STASH:OpenDepositMenu()
    local invType = MG2_STASH:GetInventoryType()
    
    if !(invType) then return end

    local frame = vgui.Create("mg2.Frame")
    frame:SetSize(500,400)
    frame:SetTitle(mg2.lang:GetTranslation("stash.DepositItem"))
    frame:SetBackgroundBlur(true)
    frame:MakePopup()
    frame:Center()

    local itemSPnl = vgui.Create("mg2.Scrollpanel", frame)
    itemSPnl:Dock(FILL)
    itemSPnl:DockMargin(3,3,3,3)
    itemSPnl.PaintOver = function(s,w,h)
        if (table.Count(s:GetCanvas():GetChildren()) <= 0) then
            draw.SimpleText(string.format("%s In '%s' Inventory", mg2.lang:GetTranslation("stash.NoItems"), invType:GetName()),"mg2.STASHMENU.MEDIUM",w/2,h/2,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end
    end

    local function loadItems(spnl)
        if (IsValid(spnl)) then spnl:Clear() end

        local invItems = invType:getUserItems(LocalPlayer())
        
        for k,v in pairs(invItems) do
            local id, class, model = v.id, v.class, v.model

            if (!id or !class or !model) then return end

            local item = vgui.Create("mg2.Container", spnl)
            item:Dock(TOP)
            item:DockMargin(0,0,0,3)
            item:SetTall(50)
            item.PaintOver = function(s,w,h)
                local amount = (v.amount or 1)
                local name = (v.printname or class)

                draw.SimpleText(name .. " (" .. amount .. ")","mg2.STASHMENU.MEDIUM",w/2,h/2,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
            end
            
            local iModel = vgui.Create("mg2.ModelPanel", item)
            iModel:Dock(LEFT)
            iModel:SetWide(100)
            iModel:SetModel(model)

            local depBtn = vgui.Create("mg2.Button", item)
            depBtn:Dock(RIGHT)
            depBtn:DockMargin(3,3,3,3)
            depBtn:SetText("Deposit")
            depBtn.DoClick = function(s)
                local perm = mg2.gang:GetPermission("stash.DepositItem")

                perm:onUserCall({ v },
                function(res)
                    loadItems(spnl)

                    if (istable(res)) then
                        local res, resMsg = unpack(res)

                        if !(res) then
                            zlib.notifs:Create(resMsg)
                        end
                    end

                    if (IsValid(self.stashSPnl)) then
                        self:LoadItems(self.stashSPnl)
                    end
                end)
            end
        end
    end

    -- Load inventory items
    loadItems(itemSPnl)
end

--[[STASH MENU BUTTON]]
local MENU_GANG = mg2.vgui:GetMenu("mg2.Gang")

if !(MENU_GANG) then return end

MENU_GANG:AddMenuButton("Stash", {
    index = 4,
    doClick = function(btn, pnl)
        MENU_STASH:Open(pnl)
    end,
})