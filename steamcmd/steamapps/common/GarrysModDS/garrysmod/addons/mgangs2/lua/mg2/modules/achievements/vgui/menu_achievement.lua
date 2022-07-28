--[[
     MGangs 2 - ACHIEVEMENTS - (SH) Menu
    Developed by Zephruz
]]

if (CLIENT) then

surface.CreateFont("mg2.ACHIEVEMENTMENU.LARGE", {
    font = "Abel",
    size = 25,
})

surface.CreateFont("mg2.ACHIEVEMENTMENU.MEDIUM", {
    font = "Abel",
    size = 21,
})

surface.CreateFont("mg2.ACHIEVEMENTMENU.SMALL", {
    font = "Abel",
    size = 17,
})

end

local MENU_ACHIEVEMENTS = {}

function MENU_ACHIEVEMENTS:Open(pnl)
    local achCont = vgui.Create("mg2.Container", pnl)
    achCont:Dock(FILL)
    achCont:DockMargin(5,5,5,5)
    achCont:SetRounded(false)

    local header = vgui.Create("mg2.Header", achCont)
    header:Dock(TOP)
    header:SetRounded(false)
    header:SetText(mg2.lang:GetTranslation("achievements"))

    local achSPnl = vgui.Create("mg2.Scrollpanel", achCont)
    achSPnl:Dock(FILL)
    achSPnl:DockMargin(5,5,5,5)

    self:LoadAchievements(achSPnl)
end

--[[Load Achievements]]
function MENU_ACHIEVEMENTS:LoadAchievements(achSPnl)
    achSPnl:Clear()

    local gang = LocalPlayer():GetGang()

    if !(gang) then return end

    local achs, gAchs = MG2_GANGACHIEVEMENTS:GetAll(), gang:GetAchievements()

    for k,v in pairs(achs) do
        local icon = Material(v:GetIcon())

        local header = vgui.Create("mg2.Header", achSPnl)
        header:Dock(TOP)
        header:DockMargin(0,0,0,3)
        header:SetText(v:GetCategory())

        -- Tiers
        local tiers = v:GetTiers()

        for tVal,tRews in SortedPairs(tiers) do
            local hasAch = gang:GetAchievements(k,tVal)
            local ftVal, curVal = v:formatTierValue(tVal), v:getGangCurrentValue(gang)

            local ach = vgui.Create("mg2.Container", achSPnl)
            ach:Dock(TOP)
            ach:DockMargin(0,0,0,3)
            ach.PaintOver = function(s,w,h)
                local tX = 5

                if (icon) then
                    tX = 30

                    local iH, iW = 16, 16

                    surface.SetDrawColor(hasAch && Color(255,255,255) || Color(0,0,0,125))
                    surface.SetMaterial(icon)
                    surface.DrawTexturedRect(5, (h/2 - iH/2), iH, iW)
                end

                if (!curVal && hasAch) then
                    draw.SimpleText(mg2.lang:GetTranslation("achieved"),"mg2.ACHIEVEMENTMENU.SMALL",w-5,h/2,Color(255,255,255),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
                end

                draw.SimpleText(ftVal,"mg2.ACHIEVEMENTMENU.SMALL",tX,h/2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            end

            if (curVal) then
                local progBar = vgui.Create("mg2.ProgressBar", ach)
                progBar:Dock(RIGHT)
                progBar:DockMargin(3,3,3,3)
                progBar:SetWide(200)
                progBar:SetFraction(hasAch && 1 || math.min(1, math.floor(curVal / tVal)))
                progBar.PaintOver = function(s,w,h)
                    draw.SimpleText((hasAch && mg2.lang:GetTranslation("achieved") || v:formatTierValue(curVal) .. " / " .. ftVal),"mg2.ACHIEVEMENTMENU.SMALL",w/2,h/2,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
                end
            end
        end
    end
end

--[[GANG MENU BUTTON]]
local MENU_GANG = mg2.vgui:GetMenu("mg2.Gang")

if !(MENU_GANG) then return end

MENU_GANG:AddMenuButton(mg2.lang:GetTranslation("achievements"), {
    index = 2,
    doClick = function(btn, pnl)
        MENU_ACHIEVEMENTS:Open(pnl)
    end,
})