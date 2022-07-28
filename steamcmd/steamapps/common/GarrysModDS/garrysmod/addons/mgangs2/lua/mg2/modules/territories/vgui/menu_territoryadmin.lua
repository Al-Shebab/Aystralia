--[[
    MGangs 2 - TERRITORIES - (SH) Admin Menu
    Developed by Zephruz
]]

if (CLIENT) then

surface.CreateFont("mg2.TERRITORYADMINMENU.LARGE", {
    font = "Abel",
    size = 25,
})

surface.CreateFont("mg2.TERRITORYADMINMENU.MEDIUM", {
    font = "Abel",
    size = 21,
})

surface.CreateFont("mg2.TERRITORYADMINMENU.SMALL", {
    font = "Abel",
    size = 17,
})

end

local MENU_ADMINTERRITORIES = {}

local function openTerritoryOptions(terr)
    if !(terr) then return end

    local terrid = terr:GetID()

    local frame = vgui.Create("mg2.Frame")
    frame:SetSize(300,400)
    frame:SetTitle(mg2.lang:GetTranslation("territory.Options"))
    frame:SetBackgroundBlur(true)
    frame:Center()
    frame:MakePopup()

    local terrOptSPnl = vgui.Create("mg2.Scrollpanel", frame)
    terrOptSPnl:Dock(FILL)
    terrOptSPnl:DockMargin(3,3,3,3)

    -- Territory Options
    local terrOpts = mg2.admin:GetOptionsFor("territory")

    for k,v in SortedPairsByMemberValue(terrOpts, "vguiIndex") do
        local name = v:GetName()
        
        if (v.loadVgui) then
            v:loadVgui(terrOptSPnl, terrid, terr)
        else
            local btn = vgui.Create("mg2.Button", terrOptSPnl)
            btn:Dock(TOP)
            btn:DockMargin(0,3,0,0)
            btn:SetText(name)
            btn.DoClick = function()
                v:onUserCall({terrid = terrid}, 
                function()
                    frame:Remove()
                end)
            end
        end
    end
end

function MENU_ADMINTERRITORIES:Open(pnl)
    local terrCont = vgui.Create("mg2.Container", pnl)
    terrCont:Dock(FILL)
    terrCont:DockMargin(5,5,5,5)
    terrCont:SetRounded(false)

    local header = vgui.Create("mg2.Header", terrCont)
    header:Dock(TOP)
    header:SetRounded(false)
    header:SetText(mg2.lang:GetTranslation("territories"))

    -- Reload territories
    local reloadTerrsTxt = mg2.lang:GetTranslation("territory.Reload")
    local reloadTerrsBtn = vgui.Create("mg2.Button", header)
    reloadTerrsBtn:Dock(RIGHT)
    reloadTerrsBtn:DockMargin(0,3,3,3)
    reloadTerrsBtn:SetText(reloadTerrsTxt)
    reloadTerrsBtn:SetWide(100)
    reloadTerrsBtn.DoClick = function()
        zlib.network:CallAction("mg2.territories.adminRequest", {
            reqName = "reloadAllTerritories",
        },
        function(res)
            if (res) then
                mg2:Notification("Reloaded all territories!") -- @TODO; Language implementation
            end
        end)
    end

    -- Set button W based on text W
    local tW, tH = zlib.util:GetTextSize(reloadTerrsTxt, reloadTerrsBtn:GetFont())
    reloadTerrsBtn:SetWide(tW + 20)

    -- Territories List
    local terrSPnl = vgui.Create("mg2.Scrollpanel", terrCont)
    terrSPnl:Dock(FILL)
    terrSPnl:DockMargin(5,5,5,5)

    self:LoadTerritories(terrSPnl)
end

function MENU_ADMINTERRITORIES:LoadTerritories(spnl)
    local terrs = MG2_TERRITORIES:GetAll()

    for k,v in pairs(terrs) do
        local tName, tDesc, tCol = v:GetName(), v:GetDescription(), v:GetColor()
        local tClaim = v:GetClaimed()

        local terr = vgui.Create("mg2.Container", spnl)
        terr:Dock(TOP)
        terr:DockMargin(0,0,0,3)
        terr:SetTall(40)
        terr.PaintOver = function(s,w,h)
            draw.RoundedBoxEx(4, 0, 0, 10, h, tCol, true, false, true, false)
            draw.SimpleText(tName,"mg2.TERRITORIESMENU.MEDIUM",15,2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
            draw.SimpleText(tDesc,"mg2.TERRITORIESMENU.SMALL",15,h-2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM)
        end

        -- Options button
        local optionsTxt = mg2.lang:GetTranslation("options")
        local tOptBtn = vgui.Create("mg2.Button", terr)
        tOptBtn:Dock(RIGHT)
        tOptBtn:DockMargin(3,3,3,3)
        tOptBtn:SetText(optionsTxt)
        tOptBtn.DoClick = function()
            openTerritoryOptions(v)
        end

        -- Set button W based on text W
        local tW, tH = zlib.util:GetTextSize(optionsTxt, tOptBtn:GetFont())
        tOptBtn:SetWide(tW + 20)
    end

    spnl.PaintOver = function(s,w,h)
        if (table.Count(terrs) <= 0) then
            draw.SimpleText(mg2.lang:GetTranslation("noterritories"),"mg2.TERRITORIESMENU.SMALL",w/2,h/2,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end
    end
end

--[[ADMIN MENU BUTTON]]
local MENU_ADMIN = mg2.vgui:GetMenu("mg2.Admin")

if !(MENU_ADMIN) then return end

MENU_ADMIN:AddMenuButton(mg2.lang:GetTranslation("territories"), {
    index = 4,
    menuHints = {
        "To create a new territory use the 'Territory Marker' found in the spawn menu!",
        "Did you know you can set rewards for claiming territories in the config?"
    },
    doClick = function(btn, pnl)
        MENU_ADMINTERRITORIES:Open(pnl)
    end,
})