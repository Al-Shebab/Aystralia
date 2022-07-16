--LUA REFRESH HANDLE
if emenu then
    if IsValid(emenu.bg) then emenu:Remove() end
end

--CURSOR POS SAVE
local cursorpos = {
    x = ScrW() * 0.5,
    y = ScrH() * 0.5
}



---------------------------
/// MAIN BUILD FUNCTION ///
---------------------------
function emenu:Build()
    local scrw, scrh = ScrW(), ScrH()
    local ply = LocalPlayer()

    local bg = vgui.Create("emenu.background")
    self.bg = bg
    bg:MakePopup()
    bg:SetKeyboardInputEnabled(false)
    bg:SetAlpha(1)
    bg:SetSize(scrw,scrh)
    bg:AlphaTo(255,emenu.config.animtime,0,function()
        emenu.ready2close = true
    end)

    function bg:OnKeyCodePressed(keycode)
        if self:IsKeyboardInputEnabled() then
            if keycode == KEY_F4 and emenu.ready2close then
                emenu:Hide()
            end
        end
    end

    local bg_interact = bg:Add("DButton")
    bg_interact:SetSize(bg:GetWide(), bg:GetTall())
    bg_interact:SetText("")
    bg_interact.Paint = nil
    bg_interact:SetCursor("arrow")

    function bg_interact:DoClick()
        local active = emenu.windows:GetAllActive()
        if istable(active) then
            local visible = true
            if table.Count(active) > 0 then

                for k,v in pairs(active) do
                    if IsValid(v) then
                        visible = v:IsVisible()
                        if visible then 
                            emenu.windows:HideAll()
                            return
                        end
                    end
                end
            end

            emenu:Hide()
        end
    end

    --EFFECTS
    bg:SetPhysics(emenu.config.effectPhysics)
    bg:SetSpeed(emenu.config.effect_speed)
    bg:SetEffectEnabled(GetConVar("emenu_effect"):GetBool())
    bg:SetEffect(emenu.config.effect)
    bg:SetColor(emenu.colors.main.bg)
    --Blur effect
    local blur = math.Clamp(emenu.config.blurStrength,0,1000)
    if blur ~= 0 then
        bg:SetBlur(true, emenu.config.blurStrength)
    end

    --GREETING
    local greet = vgui.Create("DPanel",bg)
    greet:SetMouseInputEnabled(false)
    greet:SetSize(bg:GetWide(),bg:GetTall()*0.3)
    greet:Center()
    function greet:Paint(w,h)
        draw.SimpleText(string.format(emenu.text["greet"],ply:Nick()),"emenu_60_500",w*0.5,h*0.5,emenu.colors.text.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end
    timer.Simple(emenu.config.greettime,function()
        if IsValid(greet) then
            greet:AlphaTo(0,emenu.config.animtime,0,function()
                greet:Remove()
                emenu:ContinueBuild()
            end)
        end
    end)

    -------------------------------
    /// FUNCTIONS LOAD (BEFORE) ///
    -------------------------------
    for name,functbl in pairs(emenu.windows:GetWidgets()) do
        if not functbl.loadafter then
            if functbl.type == "panel" then
                functbl.func(bg)
            elseif functbl.type == "function" then
                functbl.func(ply)
            end
        end
    end

    function self:ContinueBuild()
        if not self:IsValid() then return end

        local font = "emenu_20_500"
        local maxtext = {}
        for k,seq in ipairs(emenu.windows:GetSeqAll()) do
            local name = seq[1]
            local textsize = emenu.util.GetTextSize(seq[1],font)
            table.insert(maxtext,textsize.w+20)
        end

        local bwide = math.max(unpack(maxtext))
        local bheight = bg:GetTall()*0.1
        local botpan = vgui.Create("DPanel",bg)
        local count = emenu.windows:GetCount()
        local boffset = 3
        if count == 0 then count = 6 end
        botpan:SetSize((bwide*count)+(boffset*count)-boffset ,bheight)
        botpan:CenterHorizontal()
        local toposx,toposy = botpan:GetX(),bg:GetTall()-botpan:GetTall()-20
        botpan:SetPos(toposx,bg:GetTall())
        function botpan:Paint(w,h)
            draw.RoundedBox(16,0,0,w,h,emenu.colors.main.main)
        end
        botpan:MoveTo(toposx,toposy,emenu.config.animtime)

        local lefttop = vgui.Create("DPanel",bg)
        lefttop:SetSize(bg:GetWide()*0.3,bg:GetTall()*0.15)
        lefttop:SetMouseInputEnabled(false)
        lefttop:SetPos(0,-lefttop:GetTall())
        lefttop:MoveTo(0,0,emenu.config.animtime)

        local avatar = vgui.Create( "AvatarImage", lefttop )
        avatar:SetSize( 64, 64 )
        avatar:SetPos( 20, 20 )
        avatar:SetPlayer( LocalPlayer(), 128 )

        local font = "emenu_30_1000"
        local font2 = "emenu_18_500"
        local posx = 25+avatar:GetWide()
        function lefttop:Paint(w,h)
            emenu.util:DrawShadowText(ply:Nick(),font,posx,20,emenu.colors.text.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT)
            local col = team.GetColor( ply:Team() )
            emenu.util:DrawShadowText(ply:getDarkRPVar("job"),font2,posx,48, col,TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT)
            emenu.util:DrawShadowText(ply:GetUserGroup(),font2,posx,65,emenu.colors.text.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT)
        end



        ------------------------------
        /// FUNCTIONS LOAD (AFTER) ///
        ------------------------------
        for name,functbl in pairs(emenu.windows:GetWidgets()) do
            if functbl.loadafter then
                if functbl.type == "panel" then
                    functbl.func(bg)
                elseif functbl.type == "function" then
                    functbl.func(ply)
                end
            end
        end

        local botlist = vgui.Create("DIconLayout",botpan)
        botlist:Dock(FILL)
        botlist:InvalidateParent(true)
        botlist:SetLayoutDir( TOP )
        botlist:SetSpaceX(boffset)

        ---------------
        /// BUTTONS ///
        ---------------
        for id,seq in ipairs(emenu.windows:GetSeqAll()) do
            local name = seq[1]
            local window = emenu.windows:GetAll()[name]

            local button = vgui.Create("DButton",botlist)
            button:SetSize(bwide,bheight)
            button:SetText("")
            function button:Paint(w,h)
                local offset = w*0.3
                local hover = self:IsHovered()
                local isactive = emenu.windows:IsActive(name)
                if isactive then
                    local panel = emenu.windows:GetActive(name)
                    local state = panel:GetState()
                    if state == "normal" then
                        draw.RoundedBox(8,offset,h-4,w-offset*2,2,emenu.colors.windows.active)
                    end
                end
            end
            function button:DoClick()
                if emenu.windows:IsActive(name) then
                    local panel = emenu.windows:GetActive(name)
                    local state = panel:GetState()
                    if state == "minimized" then
                        panel:ChangeMode()
                    elseif state == "normal" then
                        panel:ChangeMode()
                    end
                else
                    --Open
                    local wind = window.func(bg)
                end

                if emenu.config.hide_other then
                    emenu.windows:HideAll({[name]=true})
                end
            end

            if emenu.config.auto_open[window.name or ""] then
                button:DoClick()
            end

            ------------------------------
            /// CONTEXT MENU (buttons) ///
            ------------------------------
            function button:DoRightClick()
                local context = vgui.Create("emenu.contextmenu",bg)
                context:SetWide(bg:GetWide()*0.1)
                context:AddHeader(emenu.text["actions"])

                local active = emenu.windows:IsActive(name)
                if active then
                    local win = emenu.windows:GetActive(name)
                    local state = win:GetState()
                    local button = context:AddButton(emenu.text["close"],function() win:Remove() end, emenu.Materials["close"])
                    button:SetTextColor(emenu.colors.default.red)
                    local text = "none"
                    local mat = emenu.Materials["unknown"]
                    if state == "normal" then
                        text = emenu.text["minimize"]
                        mat = emenu.Materials["hide"]
                    elseif state == "minimized" then
                        text = emenu.text["maximize"]
                        mat = emenu.Materials["show"]
                    end
                    if text ~= "none" then
                        context:AddButton(text,function() win:ChangeMode() end, mat)
                    end
                else
                    local button = context:AddButton(
                        emenu.text["open"],
                        function()
                            local wind = window.func(bg)
                        end,
                        emenu.Materials["next"]
                    )
                    button:SetTextColor(emenu.colors.default.green)

                    if emenu.config.hide_other then
                        emenu.windows:HideAll({[name]=true})
                    end
                end

                local px,py = self:LocalToScreen(self:GetWide()*0.5,self:GetTall())
                context:SetPosClamped(px-context:GetWide()*0.5,py-self:GetTall()-context:GetTall()-5)
            end

            ------------
            /// ICON ///
            ------------

            local font = "emenu_20_500"
            local iconsize = button:GetTall()*0.5
            local fontsize = draw.GetFontHeight(font)
            local iconx,icony = button:GetWide()*0.5, button:GetTall()*0.5-fontsize*0.5

            local list = button:Add("DPanel")
            list.Paint = nil
            list:SetMouseInputEnabled(false)

            local icon = list:Add("DPanel")
            icon:SetSize(iconsize,iconsize)
            icon:SetY(0)
            icon:SetMouseInputEnabled(false)

            local lbl = list:Add("DPanel")
            lbl:SetSize(button:GetWide(),fontsize)
            function lbl:Paint(w,h)
                local hover = button:IsHovered()
                local col = hover and emenu.colors.main.iconhover or emenu.colors.main.icon
                draw.SimpleText(window.name,font, w*0.5, 0, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            end

            if type(window.icon) == "IMaterial" then
                function icon:Paint(w,h)
                    local hover = button:IsHovered()

                    local col = hover and emenu.colors.main.iconhover or emenu.colors.main.icon
                    emenu.util:DrawMaterial(0, 0, w, h, col, window.icon)
                end
            elseif isstring(window.icon) then
                icon.Paint = nil
                local html = icon:Add("HTML")
                html:Dock(FILL)
                html:SetHTML(string.format( [[ <body style="overflow: hidden; display:block; margin:auto;"><img src="%s" width ="%s" height="%s"></body> ]], window.icon , icon:GetWide(), icon:GetTall()))
            end

            list:SetSize(math.max(lbl:GetWide(),icon:GetWide()),lbl:GetTall()+icon:GetTall()+5)
            list:Center()
            icon:CenterHorizontal()
            lbl:SetY(icon:GetTall()+5)

            self:AddHelpText(button,window.description,nil,5,"top")

        end
    end

    return bg
end



-------------
/// LINKS ///
-------------
for id,link in ipairs(emenu.config.links) do
    if link.type == "browser" then
        emenu.windows:Register(link.name, link.helptext, link.icon, function(bg)
            local pnl = vgui.Create("emenu.window",bg)
            pnl:SetTitle(emenu.text["browser"])
            pnl:SetSize(bg:GetWide()*0.6,bg:GetTall()*0.8)
            pnl:CenterHorizontal()
            pnl:CenterVertical(0.45)
            local content = pnl:GetContent()
            function content:Paint(w,h)
                draw.SimpleText(emenu.text["loading"].."...","emenu_60_500",w*0.5,h*0.5,emenu.colors.windows.text,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
            end

            local page = content:Add("HTML")
            page:Dock(FILL)
            page:OpenURL(link.url)

            if link.keyboardinput then
                bg:SetKeyboardInputEnabled(true)
                function pnl:OnClose()
                    bg:SetKeyboardInputEnabled(false)
                end
                function pnl:OnMinimize()
                    bg:SetKeyboardInputEnabled(false)
                end
                function pnl:OnMaximize()
                    bg:SetKeyboardInputEnabled(true)
                end
            end

            return pnl
        end, 
        10+id)
    else
        emenu.windows:Register(link.name, link.helptext, link.icon, function() gui.OpenURL( link.url ) end, 10+id)
    end
end


--------------------
/// OPEN / CLOSE ///
--------------------
function emenu:IsValid()
    return IsValid(self.bg)
end

function emenu:IsActive()
    if self:IsValid() then
        return self.bg:IsVisible()
    else 
        return
    end
end

function emenu:Show()
    if self:IsValid() then
        if not self.bg:IsVisible() then
            --Showing
            self.bg:SetVisible(true)
            self.bg:SetAlpha(1)
            self.bg:AlphaTo(255, emenu.config.animtime, 0, function()
                self.ready2close = true
            end)
            input.SetCursorPos(cursorpos.x, cursorpos.y)
            hook.Run("OnEMenuShow",bg)
        end
    end
end

function emenu:Hide()
    if self:IsValid() then
        if self.bg:IsVisible() then
            if self.ready2close then
                if IsValid(self.bg.contextbg) then self.bg.contextbg:Remove() end
                cursorpos.x, cursorpos.y = input.GetCursorPos()
                self.bg:AlphaTo(0, emenu.config.animtime, 0, function()
                    self.bg:SetVisible(false)
                end)
                hook.Run("OnEMenuHide",bg)
            end
        end
    end
end

function emenu:Open()
    if self:IsValid() then
        if not self.bg:IsVisible() then
            self:Show()
        else
            self:Hide()
        end
    else
        self:Build()
    end
end

function emenu:Remove()
    if self:IsValid() then self.bg:Remove() end
end

function emenu:Override()
    GAMEMODE.ShowSpare2 = function()
        self:Open()
    end
end


----------------
/// COMMANDS ///
----------------
concommand.Add("emenu_override", function()
    emenu:Override()
end)

concommand.Add("emenu_open", function()
    emenu:Open()
end)

concommand.Add("emenu_reload", function()
    emenu:RefreshButtons()
end)

concommand.Add("emenu_close", function()
    if IsValid(emenu.bg) then emenu.bg:Remove() end
end)


-------------
/// HOOKS ///
-------------
-- Open/Close hooks:
-- • OnEMenuShow
-- • OnEMenuHide

--OVERRIDE
hook.Add("InitPostEntity", "emenu.f4override", function()
    emenu:Override()
end)

--ON CLIENT RESOLUTION CHANGE
hook.Add("OnScreenSizeChanged", "emenu.onscreenchange", function()
    emenu:Remove()
end)

--GAMEMODE LUA REFRESH
hook.Add("OnReloaded","emenu.ongamemodereload",function()
    timer.Simple(1,function() emenu:Override() end)
end)

--TEAM CHANGE HOOK
net.Receive( "emenu.player_changed_job", function( len )
    local old = net.ReadUInt(12)
    local new = net.ReadUInt(12)
    local ply = net.ReadEntity()
    if (old == nil or new == nil) or not IsValid(ply) then return end

    --returns player, oldjob, newjob
    hook.Run( "emenu_OnPlayerChangedTeam", ply, old, new)
end)

--NOTIFY OVERRIDE
if emenu.config.override_notify then
    hook.Add("DarkRPFinishedLoading","emenu.notify.replacement",function()
        local gm = GM or GAMEMODE
        function gm:AddNotify( str, type, length )
            if emenu then
                if IsValid(emenu.bg) then
                    if emenu.bg:IsVisible() then
                        emenu:Notify(str or "nil", length or 3, type)
                        return
                    end
                end
            end
            notification.AddLegacy( str, type, length )
        end
    end)
end