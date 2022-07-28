--[[
     MGangs 2 - UPGRADES - (SH) Menu
    Developed by Zephruz
]]

if (CLIENT) then

surface.CreateFont("mg2.UPGRADESMENU.LARGE", {
    font = "Abel",
    size = 25,
})

surface.CreateFont("mg2.UPGRADESMENU.MEDIUM", {
    font = "Abel",
    size = 21,
})

surface.CreateFont("mg2.UPGRADESMENU.SMALL", {
    font = "Abel",
    size = 17,
})

end

local MENU_UPGRADES = {}

function MENU_UPGRADES:Open(pnl)
    local gang = LocalPlayer():GetGang()

    if !(gang) then return end

    local gangGrp = LocalPlayer():GetGangGroup()
    local hasPerm = (gangGrp && gangGrp:GetPermissions("upgrades.Purchase"))
    local perm = mg2.gang:GetPermission("upgrades.Purchase")    

    local upgCont = vgui.Create("mg2.Container", pnl)
    upgCont:Dock(FILL)
    upgCont:DockMargin(5,5,5,5)
    upgCont:SetRounded(false)

    local header = vgui.Create("mg2.Header", upgCont)
    header:Dock(TOP)
    header:SetText(mg2.lang:GetTranslation("upgrades"))
    header:SetRounded(false)

    -- Load upgrades
    local upgSPnl = vgui.Create("mg2.Scrollpanel", upgCont)
    upgSPnl:Dock(FILL)
    upgSPnl:DockMargin(5,5,5,5)

    local upgTbl = MG2_UPGRADES:GetAll()
    local upgTblCat = {}

    -- Categorize upgrades
    for k,v in pairs(upgTbl) do
        local category = v:GetCategory()

        if !(upgTblCat[category]) then upgTblCat[category] = {} end

        table.insert(upgTblCat[category], v)
    end

    -- Display upgrades by category
    for k,upgs in pairs(upgTblCat) do
        local catHeader = vgui.Create("mg2.Header", upgSPnl)
        catHeader:Dock(TOP)
        catHeader:DockMargin(0,0,0,3)
        catHeader:SetText(k)

        -- Load upgrades
        for _,upg in pairs(upgs) do
            local curTierData = gang:GetUpgrades(upg:GetUniqueName())
            local upgPnl = vgui.Create("mg2.Container", upgSPnl)
            upgPnl:Dock(TOP)
            upgPnl:DockMargin(0,0,0,3)
            upgPnl:SetTall(54)
            upgPnl.PaintOver = function(s,w,h)
                local upgData = gang:GetUpgrades(upg:GetUniqueName())
                local upgName, upgDesc, upgVal, upgValType = upg:GetName(), upg:GetDescription(), upg:formatTierValue(upgData.value), upg:GetValueType()

                if (upgValType == MG2_UPGRADES.upgradeValueTypes.INTEGER) then
                elseif (upgValType == MG2_UPGRADES.upgradeValueTypes.BOOLEAN) then
                    upgVal = (upgVal == true && "ENABLED" || "DISABLED")
                end

                draw.SimpleText(upgName,"mg2.UPGRADESMENU.MEDIUM",5,2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
                draw.SimpleText(upgDesc,"mg2.UPGRADESMENU.SMALL",5,h/2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
                draw.SimpleText(mg2.lang:GetTranslation("current") .. ": " .. upgVal,"mg2.UPGRADESMENU.SMALL",5,h-2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM)
            end

            if (hasPerm) then
                self:LoadUpgradeButton(upgPnl, perm, upg, curTierData)
            end
        end
    end
end

function MENU_UPGRADES:LoadUpgradeButton(upgPnl, perm, upg, curTierData)
    local nextTierData, isMaxTier

    for i,j in pairs(upg:GetTiers()) do
        if (curTierData.id + 1 != i) then continue end

        j.id = i
        nextTierData = j

        break
    end

    isMaxTier = (nextTierData == nil)

    -- Upgrade to next tier button
    local upgTierTxt = ""
    local upgTiersBtn = vgui.Create("mg2.Button", upgPnl)
    upgTiersBtn:Dock(RIGHT)
    upgTiersBtn:DockMargin(3,3,3,3)

    if (isMaxTier) then
        upgTierTxt = mg2.lang:GetTranslation("maxTier")

        upgTiersBtn:SetDisabled(true)
    else
        upgTierTxt = mg2.lang:GetTranslation("upgrade") .. string.format(" (%s)", mg2.gang:FormatCurrency(nextTierData.cost))

        upgTiersBtn.DoClick = function(s)
            perm:onUserCall({ upg:GetUniqueName(), nextTierData.id }, 
            function(res)
                if !(res) then return end

                local succ, msg = res.res, res.msg
                
                if (msg) then zlib.notifs:Create(msg) end
                if (succ) then
                    upgTiersBtn:Remove()
                    self:LoadUpgradeButton(upgPnl, perm, upg, nextTierData)
                end
            end)
        end
    end

    upgTiersBtn:SetText(upgTierTxt)

    -- Set button W based on text W
    local tW, tH = zlib.util:GetTextSize(upgTierTxt, upgTiersBtn:GetFont())
    upgTiersBtn:SetWide(tW + 20)
end

--[[GANG MENU BUTTON]]
local MENU_GANG = mg2.vgui:GetMenu("mg2.Gang")

if !(MENU_GANG) then return end

MENU_GANG:AddMenuButton(mg2.lang:GetTranslation("upgrades"), {
    index = 6,
    doClick = function(btn, pnl)
        MENU_UPGRADES:Open(pnl)
    end,
})