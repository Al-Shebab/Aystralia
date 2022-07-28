--[[
    MGangs 2 - NPC MANAGER - (SH) Admin Menu
    Developed by Zephruz
]]

if (CLIENT) then

surface.CreateFont("mg2.NPCMANAGERMENU.LARGE", {
    font = "Abel",
    size = 25,
})

surface.CreateFont("mg2.NPCMANAGERMENU.MEDIUM", {
    font = "Abel",
    size = 21,
})

surface.CreateFont("mg2.NPCMANAGERMENU.SMALL", {
    font = "Abel",
    size = 17,
})

end

local function openNPCOptions(npc)
    if !(npc) then return end

    local id = npc:GetID()

    local frame = vgui.Create("mg2.Frame")
    frame:SetSize(300,400)
    frame:SetTitle(mg2.lang:GetTranslation("options"))
    frame:SetBackgroundBlur(true)
    frame:Center()
    frame:MakePopup()

    local npcOptSPnl = vgui.Create("mg2.Scrollpanel", frame)
    npcOptSPnl:Dock(FILL)
    npcOptSPnl:DockMargin(3,3,3,3)

    -- NPC Options
    local npcOpts = mg2.admin:GetOptionsFor("npcmanager.EditNPC")

    for k,v in SortedPairsByMemberValue(npcOpts, "vguiIndex") do
        local name = v:GetName()
        
        if (v.loadVgui) then
            v:loadVgui(npcOptSPnl, id, npc)
        else
            local btn = vgui.Create("mg2.Button", npcOptSPnl)
            btn:Dock(TOP)
            btn:DockMargin(0,3,0,0)
            btn:SetText(name)
            btn.DoClick = function()
                v:onUserCall({id = id}, 
                function(res)
                    frame:Remove()
                end)
            end
        end
    end
end

local MENU_NPCMANAGER = {}

function MENU_NPCMANAGER:Open(pnl)
    local npcCont = vgui.Create("mg2.Container", pnl)
    npcCont:Dock(FILL)
    npcCont:DockMargin(5,5,5,5)
    npcCont:SetRounded(false)

    local header = vgui.Create("mg2.Header", npcCont)
    header:Dock(TOP)
    header:SetRounded(false)
    header:SetText(mg2.lang:GetTranslation("npcs"))

    // Top Nav
    local topNavBtns = {
        [mg2.lang:GetTranslation("create")] = {
            index = 1,
            doClick = function()
                mg2.admin:GetOption("npcmanager.Create"):onUserCall({},
                function(res)
                    if (res) then
                        self:LoadNPCs()
                    end

                    zlib.notifs:Create(mg2.lang:GetTranslation(res && "npcmanager.NPCCreated" || "npcmanager.NPCUnableToModify"))
                end)
            end,
        },
        [mg2.lang:GetTranslation("npcmanager.ReloadNPCs")] = {
            index = 2,
            doClick = function()
                mg2.admin:GetOption("npcmanager.ReloadAll"):onUserCall({},
                function(res)
                    if (res) then
                        self:LoadNPCs()
                    end
                end)
            end,
        },
    }

    for k,v in SortedPairsByMemberValue(topNavBtns, "index") do
        local tnavBtn = vgui.Create("mg2.Button", header)
        tnavBtn:Dock(RIGHT)
        tnavBtn:DockMargin(3,3,3,3)
        tnavBtn:SetText(k)
        tnavBtn.DoClick = function(s)
            if (v.doClick) then v.doClick() end
        end

        -- Set button W based on text W
        local tW, tH = zlib.util:GetTextSize(k, tnavBtn:GetFont())
        tnavBtn:SetWide(tW + 10)

        if (setVis != nil) then
            tnavBtn:SetVisible(setVis)
        end
    end

    // Load NPCs
    self.npcSPnl = vgui.Create("mg2.Scrollpanel", npcCont)
    self.npcSPnl:Dock(FILL)
    self.npcSPnl:DockMargin(5,5,5,5)

    self:LoadNPCs()
end

function MENU_NPCMANAGER:LoadNPCs()
    if !(IsValid(self.npcSPnl)) then return end
    
    self.npcSPnl:Clear()

    local npcs = MG2_NPCMANAGER:GetAll()

    for k,v in pairs(npcs) do
        self:CreateNPCPanel(v)
    end
end

function MENU_NPCMANAGER:CreateNPCPanel(npc)
    local spnl = self.npcSPnl

    if !(IsValid(spnl)) then return end

    local id, title, desc, col, mapName = npc:GetID(), npc:GetTitle(), npc:GetDescription(), npc:GetColor(), npc:GetMapName()
    local npcPnl = vgui.Create("mg2.Container", spnl)
    npcPnl:Dock(TOP)
    npcPnl:DockMargin(0,0,0,3)
    npcPnl:SetTall(40)
    npcPnl.PaintOver = function(s,w,h)
        draw.RoundedBoxEx(4, 0, 0, 10, h, col, true, false, true, false)
        draw.SimpleText(title,"mg2.NPCMANAGERMENU.MEDIUM",15,2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
        draw.SimpleText("ID: " .. id,"mg2.NPCMANAGERMENU.SMALL",15,h-2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM)
        draw.SimpleText(mapName,"mg2.NPCMANAGERMENU.SMALL",w/2,h/2,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end

    local optsBtn = vgui.Create("mg2.Button", npcPnl)
    optsBtn:Dock(RIGHT)
    optsBtn:DockMargin(3,3,3,3)
    optsBtn:SetText(mg2.lang:GetTranslation("options"))
    optsBtn.DoClick = function(s)
        openNPCOptions(npc)
    end
end

--[[ADMIN MENU BUTTON]]
local MENU_ADMIN = mg2.vgui:GetMenu("mg2.Admin")

if !(MENU_ADMIN) then return end

MENU_ADMIN:AddMenuButton(mg2.lang:GetTranslation("npcs"), {
    index = 3,
    menuHints = {
        "To move an NPC to a new position, just move the entity to a new spot and save the NPC."
    },
    doClick = function(btn, pnl)
        MENU_NPCMANAGER:Open(pnl)
    end,
})