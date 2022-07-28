--[[
    MGangs 2 - NPC MANAGER - (SH) Selection
    Developed by Zephruz
]]

if (CLIENT) then

surface.CreateFont("mg2.SELECTIONMENU.LARGE", {
    font = "Abel",
    size = 25,
})

surface.CreateFont("mg2.SELECTIONMENU.MEDIUM", {
    font = "Abel",
    size = 21,
})

surface.CreateFont("mg2.SELECTIONMENU.SMALL", {
    font = "Abel",
    size = 17,
})

end

local MENU_SELECTION = mg2.vgui:RegisterMenu("npcmanager.Selection")
MENU_SELECTION:SetConsoleCommands({"mg2_selection"})
MENU_SELECTION:SetChatCommands({"!gangselection"})

MENU_SELECTION:setData("NPCID", nil, {shouldSave = false})

function MENU_SELECTION:Init()
    self.frame = vgui.Create("mg2.Frame")
    self.frame:SetSize(300,250)
    self.frame:Center()
    self.frame:MakePopup()
    self.frame:SetTitle("")
    self.frame:SetFrameBlur(true)

    self:LoadNPCDisplay()
    self:LoadOptions()
end

function MENU_SELECTION:LoadNPCDisplay()
    local dPnlH = 100
    local npc = MG2_NPCMANAGER:Get(self:GetNPCID())
    local npcEnt = (npc && npc:GetEntity())
    local npcMdl = (npcEnt && npcEnt:GetModel() || "models/breen.mdl")

    local npcDispPnl = vgui.Create("mg2.Container", self.frame)
    npcDispPnl:Dock(TOP)
    npcDispPnl:SetTall(dPnlH)
    npcDispPnl:SetRounded(false)

    -- NPC Display
    local npcMdlPnl = vgui.Create("DModelPanel", npcDispPnl)
    npcMdlPnl:SetWide(dPnlH - 6)
    npcMdlPnl:SetModel(npcMdl)
    npcMdlPnl:Dock(LEFT)
    npcMdlPnl:DockMargin(3,3,3,3)
    function npcMdlPnl:LayoutEntity(Entity) return end

    if (IsValid(npcMdlPnl) && IsValid(npcMdlPnl.Entity)) then
        local headpos = npcMdlPnl.Entity:GetBonePosition(npcMdlPnl.Entity:LookupBone("ValveBiped.Bip01_Head1"))
        npcMdlPnl:SetLookAt(headpos)
        npcMdlPnl:SetCamPos(headpos-Vector(-16, 0, 0))

        -- NPC Text
        local npcText = vgui.Create("mg2.TextEntry", npcDispPnl)
        npcText:Dock(FILL)
        npcText:DockMargin(0, 3, 3, 3)
        npcText:SetDisabled(true)
        npcText:SetText("Hello, please select an option below!")
    end
end

function MENU_SELECTION:LoadOptions()
    local optSPnl = vgui.Create("mg2.Scrollpanel", self.frame)
    optSPnl:Dock(FILL)
    optSPnl:DockMargin(3,3,3,3)
    optSPnl.PaintOver = function(s,w,h)
        if (table.Count(s:GetChildren()) <= 0) then
            draw.SimpleText(mg2.lang:GetTranslation("nooptions"),"mg2.SELECTIONMENU.MEDIUM",w/2,h/2,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end
    end

    -- Options
    local optBtns = {
        -- Gang
        [mg2.lang:GetTranslation("gang")] = {
            index = 1,
            setVis = (LocalPlayer():GetGang() != nil),
            doClick = function()
                local aMenu = mg2.vgui:GetMenu("mg2.Gang")

                if (aMenu) then 
                    aMenu:Init()

                    self.frame:Remove()
                end
            end,
        },
        [mg2.lang:GetTranslation("leavegang")] = {
            index = 2,
            setVis = (LocalPlayer():GetGang() != nil),
            reqConfirm = true,
            doClick = function()
                zlib.network:CallAction("mg2.gang.userRequest", {reqName = "leaveGang"},
                function(res)
                    local sFrame = self.frame

                    if (res && IsValid(sFrame)) then
                        sFrame:Remove()
                    end
                end)
            end,
        },
        -- No gang
        [mg2.lang:GetTranslation("creategang") .. (mg2.config.gangCost > 0 && " (" .. mg2.gang:FormatCurrency(mg2.config.gangCost) .. ")" || "")] = {
            index = 3,
            setVis = !LocalPlayer():GetGang(),
            doClick = function()
                local sMenu = mg2.vgui:GetMenu("mg2.GangCreation")

                if (sMenu) then 
                    sMenu:Init()

                    self.frame:Remove()
                end
            end,
        },
        [mg2.lang:GetTranslation("ganginvites")] = {
            index = 4,
            setVis = !LocalPlayer():GetGang(),
            doClick = function()
                local sMenu = mg2.vgui:GetMenu("mg2.Invites")

                if (sMenu) then 
                    sMenu:Init()

                    self.frame:Remove()
                end
            end,
        },
    }

    for k,v in SortedPairsByMemberValue(optBtns, "index") do
        local optBtn = vgui.Create("mg2.Button", optSPnl)
        optBtn:SetTall(v.height or 30)
        optBtn:Dock(TOP)
        optBtn:DockMargin(0,0,0,3)
        optBtn:SetText(k)

        -- DoClick/Confirmation
        local reqConfirm = v.reqConfirm

        if (reqConfirm) then
            optBtn:SetDoubleClickConfirm(v.reqConfirm != nil)
            optBtn.OnConfirm = function()
                if (v.doClick) then v.doClick() end
            end
        else
            optBtn.DoClick = function()
                if (v.doClick) then v.doClick() end
            end
        end

        -- Visibility
        local setVis = v.setVis

        if (setVis != nil) then
            optBtn:SetVisible(setVis)
        end
    end
end