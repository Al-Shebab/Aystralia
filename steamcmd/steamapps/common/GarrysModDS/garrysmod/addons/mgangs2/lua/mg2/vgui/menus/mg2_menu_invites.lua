--[[
    MGangs 2 - (SH) VGUI MENU - Invites
    Developed by Zephruz
]]

if (CLIENT) then

surface.CreateFont("mg2.INVITEMENU.LARGE", {
    font = "Abel",
    size = 25,
})

surface.CreateFont("mg2.INVITEMENU.MEDIUM", {
    font = "Abel",
    size = 21,
})

surface.CreateFont("mg2.INVITEMENU.SMALL", {
    font = "Abel",
    size = 17,
})

end

local MENU_GANGINVITES = mg2.vgui:RegisterMenu("mg2.Invites")
MENU_GANGINVITES:SetConsoleCommands({"ganginvites", "mg2_invites"})
MENU_GANGINVITES:SetChatCommands({"!ganginvites", "!mg2ganginvites"})

function MENU_GANGINVITES:Init()
    if (IsValid(self.frame)) then self.frame:Remove() end
    if (LocalPlayer():GetGang()) then return end

    self.frame = vgui.Create("mg2.Frame")
    self.frame:SetSize(500,500)
    self.frame:Center()
    self.frame:MakePopup()
    self.frame:SetTitle(mg2.lang:GetTranslation("ganginvites"))
    self.frame:SetFrameBlur(true)

    zlib.network:CallAction("mg2.gang.userRequest", {reqName = "getInvites"},
    function(invites)
        self:LoadInvites(invites)
    end)
end

function MENU_GANGINVITES:LoadInvites(invites)
    if (!IsValid(self.frame) or !invites) then return end

    local invListCont = vgui.Create("mg2.Container", self.frame)
    invListCont:Dock(FILL)
    invListCont:Dock(FILL)
    invListCont:DockMargin(5,5,5,5)
    invListCont:SetRounded(false)

    local invListSPnl = vgui.Create("mg2.Scrollpanel", invListCont)
    invListSPnl:Dock(FILL)
    invListSPnl:DockMargin(5,5,5,5)
    invListSPnl.PaintOver = function(s,w,h)
        if (table.Count(invites) <= 0) then
            draw.SimpleText(mg2.lang:GetTranslation("noinvites"),"mg2.GANGMENU.MEDIUM",w/2,h/2,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end
    end

    for k,v in pairs(invites) do
        local invData = v.data
        local gName, invDate = (invData && invData.name || "UNKNOWN"), (invData && os.date("%m/%d/%Y", invData.date) || "UNKNOWN")

        local invPnl = vgui.Create("mg2.Container", invListSPnl)
        invPnl:Dock(TOP)
        invPnl:DockMargin(0,0,0,3)
        invPnl:SetTall(30)
        invPnl.PaintOver = function(s,w,h)
            draw.SimpleText(gName, "mg2.INVITEMENU.SMALL",5,h/2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            draw.SimpleText(invDate, "mg2.INVITEMENU.SMALL",w/2,h/2,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end

        local respondBtn = vgui.Create("mg2.Button", invPnl)
        respondBtn:Dock(RIGHT)
        respondBtn:DockMargin(3,3,3,3)
        respondBtn:SetText(mg2.lang:GetTranslation("respond"))
        respondBtn.DoClick = function(s)
            local dMenu = DermaMenu()

            local opts = {[mg2.lang:GetTranslation("join")] = true, [mg2.lang:GetTranslation("deny")] = false}

            for optTxt,optVal in pairs(opts) do
                dMenu:AddOption(optTxt,
                function()
                    zlib.network:CallAction("mg2.gang.userRequest", {reqName = "respondToInvite", inviteid = v.id, response = optVal},
                    function(res)
                        if (res && IsValid(self.frame)) then
                            self.frame:Remove()
                        end
                    end)
                end)
            end

            dMenu:Open()
        end
    end
end