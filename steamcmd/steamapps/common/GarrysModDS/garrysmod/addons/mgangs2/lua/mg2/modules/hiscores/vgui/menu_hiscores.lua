--[[
     MGangs 2 - HISCORES - (SH) Menu
    Developed by Zephruz
]]

if (CLIENT) then

surface.CreateFont("mg2.HISCOREMENU.LARGE", {
    font = "Abel",
    size = 25,
})

surface.CreateFont("mg2.HISCOREMENU.MEDIUM", {
    font = "Abel",
    size = 21,
})

surface.CreateFont("mg2.HISCOREMENU.SMALL", {
    font = "Abel",
    size = 17,
})

end

local MENU_HISCORES = {}

function MENU_HISCORES:Open(pnl)
    local gang = LocalPlayer():GetGang()

    if !(gang) then return end

    local hisCont = vgui.Create("mg2.Container", pnl)
    hisCont:Dock(FILL)
    hisCont:DockMargin(5,5,5,5)
    hisCont:SetRounded(false)

    local header = vgui.Create("mg2.Header", hisCont)
    header:Dock(TOP)
    header:SetRounded(false)
    header:SetText(mg2.lang:GetTranslation("hiscores"))

    -- Load hiscores
    local hisSPnl = vgui.Create("mg2.Scrollpanel", hisCont)
    hisSPnl:Dock(FILL)
    hisSPnl:DockMargin(5,5,5,5)

    local hisTbl = MG2_HISCORES:GetTypes()

    -- Load types
    for k,v in pairs(hisTbl) do
        local enabled = v:GetEnabled()

        if (enabled) then
            local name, icon = v:GetName(), Material(v:GetIcon())

            v:Request(function(hisData)
                hisData = (istable(hisData) && hisData)

                local catHeader = vgui.Create("mg2.Header", hisSPnl)
                catHeader:Dock(TOP)
                catHeader:DockMargin(0,0,0,3)
                catHeader:SetText(name)
                catHeader.PaintOver = function(s,w,h)
                    if (icon) then
                        local iH, iW = 16, 16
    
                        surface.SetDrawColor(Color(255,255,255))
                        surface.SetMaterial(icon)
                        surface.DrawTexturedRect(w-(iH+5), (h/2 - iH/2), iH, iW)
                    end
                end

                if !(IsValid(hisSPnl)) then return end

                if (#hisData <= 0) then 
                    local hiCont = vgui.Create("mg2.Container", hisSPnl)
                    hiCont:Dock(TOP)
                    hiCont:DockMargin(0,0,0,3)
                    hiCont:SetTall(35)
                    hiCont.PaintOver = function(s,w,h)
                        draw.SimpleText(mg2.lang:GetTranslation("hiscores.NoGangsYet"),"mg2.HISCOREMENU.SMALL",w/2,h/2,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
                    end
                else
                    for _, hiscoreData in pairs(hisData) do
                        local tempGang = (hiscoreData.gangdata && mg2.gang:SetupTemporary(hiscoreData.gangdata))

                        if !(tempGang) then return end
        
                        local val = (hiscoreData && hiscoreData.val || "")
                        local gangid = (hiscoreData && hiscoreData.gangid)
                        local text = tempGang:GetName()
        
                        local hiCont = vgui.Create("mg2.Container", hisSPnl)
                        hiCont:Dock(TOP)
                        hiCont:DockMargin(0,0,0,3)
                        hiCont:SetTall(50)
                        hiCont.PaintOver = function(s,w,h)
                            draw.SimpleText(text,"mg2.HISCOREMENU.MEDIUM",50,8,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
                            draw.SimpleText("ID: " .. gangid,"mg2.HISCOREMENU.SMALL",50,h-8,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM)
                            draw.SimpleText(val,"mg2.HISCOREMENU.MEDIUM",w-5,h/2,Color(255,255,255),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
                        end

                        local httpImg = vgui.Create("mg2.HTMLImage", hiCont)
                        httpImg:Dock(LEFT)
                        httpImg:DockMargin(5,5,5,5)
                        httpImg:SetSize(40, 40)
                        httpImg:SetURL(tempGang:GetIcon())
                    end
                end
            end)
        end
    end
end

--[[GANG MENU BUTTON]]
local MENU_GANG = mg2.vgui:GetMenu("mg2.Gang")

if !(MENU_GANG) then return end

MENU_GANG:AddMenuButton(mg2.lang:GetTranslation("hiscores"), {
    doClick = function(btn, pnl)
        MENU_HISCORES:Open(pnl)
    end,
})