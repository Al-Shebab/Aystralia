--[[
     MGangs 2 - TERRITORIES - (SH) Menu
    Developed by Zephruz
]]

if (CLIENT) then

surface.CreateFont("mg2.TERRITORIESMENU.LARGE", {
    font = "Abel",
    size = 25,
})

surface.CreateFont("mg2.TERRITORIESMENU.MEDIUM", {
    font = "Abel",
    size = 21,
})

surface.CreateFont("mg2.TERRITORIESMENU.SMALL", {
    font = "Abel",
    size = 17,
})

end

local MENU_TERRITORIES = {}

function MENU_TERRITORIES:Open(pnl)
    local achCont = vgui.Create("mg2.Container", pnl)
    achCont:Dock(FILL)
    achCont:DockMargin(5,5,5,5)
    achCont:SetRounded(false)

    local header = vgui.Create("mg2.Header", achCont)
    header:Dock(TOP)
    header:SetRounded(false)
    header:SetText(mg2.lang:GetTranslation("territories"))

    local terrSPnl = vgui.Create("mg2.Scrollpanel", achCont)
    terrSPnl:Dock(FILL)
    terrSPnl:DockMargin(5,5,5,5)

    self:LoadTerritories(terrSPnl)
end

function MENU_TERRITORIES:LoadTerritories(spnl)
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

            -- Claim info
            local cText = (tClaim && "Claimed by " .. (tClaim.gangName or "INVALID") || "Not claimed")
            local cAtText = (tClaim && "Since " .. os.date("%I:%M - %m/%d/%Y", tClaim.claimtime || 0) || "Claim to get rewards!")

            draw.SimpleText(cText,"mg2.TERRITORIESMENU.MEDIUM",w-5,2,Color(255,255,255),TEXT_ALIGN_RIGHT,TEXT_ALIGN_TOP)
            draw.SimpleText(cAtText,"mg2.TERRITORIESMENU.SMALL",w-5,h-2,Color(255,255,255),TEXT_ALIGN_RIGHT,TEXT_ALIGN_BOTTOM)
        end
    end

    spnl.PaintOver = function(s,w,h)
        if (table.Count(terrs) <= 0) then
            draw.SimpleText(mg2.lang:GetTranslation("noterritories"),"mg2.TERRITORIESMENU.MEDIUM",w/2,h/2,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end
    end
end

--[[GANG MENU BUTTON]]
local MENU_GANG = mg2.vgui:GetMenu("mg2.Gang")

if !(MENU_GANG) then return end

MENU_GANG:AddMenuButton(mg2.lang:GetTranslation("territories"), {
    index = 5,
    menuHints = {
        "Did you know your gang can receive rewards for claiming a territory?",
        "To claim a territory, search for one and press 'E' (use) on the flag pole."
    },
    doClick = function(btn, pnl)
        MENU_TERRITORIES:Open(pnl)
    end,
})