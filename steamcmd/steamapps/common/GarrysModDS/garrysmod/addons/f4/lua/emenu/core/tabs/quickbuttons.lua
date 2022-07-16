emenu.quick = {}
emenu.quick.cmds = {}
function emenu.quick.cmds:Generate()
    local ply = LocalPlayer()
    self.list = {}

    ---------------
    /// GENERAL ///
    ---------------
    table.insert(self.list,{
        title = emenu.text["general_tab"]
    })

    table.insert(self.list,{
        title = emenu.text["request_license"],
        --customCheck = function(ply) end,
        func = function(ply)
            ply:ConCommand("say /requestlicense")
        end
    })

    table.insert(self.list,{
        title = emenu.text["drop_weapon"],
        func = function(ply)
            ply:ConCommand("say /drop")
        end
    })

    table.insert(self.list,{
        title = emenu.text["change_name"],
        func = function(ply)
            emenu:TextInputWindow("",emenu.text["change_name"],false,function(val)
                ply:ConCommand("say /rpname " .. val)
            end)
        end
    })

    table.insert(self.list,{
        title = emenu.text["change_job_title"],
        func = function(ply)
            emenu:TextInputWindow("",emenu.text["change_job_title"],false,function(val)
                ply:ConCommand("say /job " .. val)
            end)
        end
    })

    local cv = GetConVar("emenu_effect")
    if cv ~= nil then
        local cvbool = cv:GetBool()
        table.insert(self.list,{
            title = cvbool and emenu.text["off_effect"] or emenu.text["on_effect"],
            func = function(ply)
                cv:SetBool(not cvbool)
                emenu.bg:SetEffectEnabled(cv:GetBool())
            end
        })
    end

    -------------
    /// MONEY ///
    -------------
    table.insert(self.list,{
        title = emenu.text["money_tab"],
        color = emenu.colors.default.green,
    })

    table.insert(self.list,{
        title = emenu.text["drop_money"],
        func = function(ply)
            emenu:TextInputWindow(emenu.text["drop_money"],emenu.text["amount"].."?",true,function(val)
                if not isnumber(val) then return end
                if val < 1 then return end

                if ply:canAfford(val) then
                    emenu:Notify(emenu.text["drop_money"].." "..DarkRP.formatMoney(val) , 3)
                    ply:ConCommand("say /dropmoney "..val)
                else
                    emenu:Notify(emenu.text["cantafford"], 3)
                end
            end)
        end
    })

    table.insert(self.list,{
        title = emenu.text["give_money"],
        func = function(ply)
            emenu:TextInputWindow("",emenu.text["amount"].."?",true,function(val)
                if not isnumber(val) then return end
                if val < 1 then return end

                if ply:canAfford(val) then
                    emenu:Notify(emenu.text["give_money"].." "..DarkRP.formatMoney(val) , 3)
                    ply:ConCommand("say /give " .. val)
                else
                    emenu:Notify(emenu.text["cantafford"], 3)
                end
            end)
        end
    })

    table.insert(self.list,{
        title = emenu.text["sell_doors"],
        func = function(ply)
            emenu:ConfirmWindow("",emenu.text["sure_phrase"],function(bool)
                if not bool then return end
                emenu:Notify(emenu.text["sell_doors"],3)
                ply:ConCommand("say /sellalldoors")
            end)
        end
    })

    --------------
    /// POLICE ///
    --------------
    if ply:isCP() then
        table.insert(self.list,{title = emenu.text["police_tab"],color = Color(3, 115, 206)})

        table.insert(self.list,{
            title = emenu.text["wanted"],
            func = function(ply)
                emenu.players:SelectWindow(function(sel_ply)
                    emenu:TextInputWindow(sel_ply:Nick(), emenu.text["enter_reason"].."...",false,function(val)
                        if not IsValid(sel_ply) then return end
                        if not LocalPlayer():isCP() then return end

                        if (sel_ply == LocalPlayer()) or sel_ply:isCP() or sel_ply:isWanted() then
                            emenu:Notify(emenu.text["err_cant_do"], 3)
                            return
                        end

                        ply:ConCommand("say /wanted \"" .. sel_ply:Nick() .. "\" " .. val)
                    end)
                end)
            end
        })

        table.insert(self.list,{
            title = emenu.text["un_wanted"],
            func = function(ply)
                emenu.players:SelectWindow(function(sel_ply)
                    if not IsValid(sel_ply) then return end
                    ply:ConCommand("say /unwanted \"" .. sel_ply:Nick())
                end)
            end
        })

        table.insert(self.list,{
            title = emenu.text["warrant"],
            func = function(ply)
                emenu.players:SelectWindow(function(sel_ply)
                    emenu:TextInputWindow(sel_ply:Nick(), emenu.text["enter_reason"].."...",false,function(val)
                        if not IsValid(sel_ply) then return end
                        if not LocalPlayer():isCP() then return end

                        if (sel_ply == LocalPlayer()) or sel_ply:isCP() or sel_ply:isWanted() then
                            emenu:Notify(emenu.text["err_cant_do"], 3)
                            return
                        end

                        ply:ConCommand("say /warrant \"" .. sel_ply:Nick() .. "\" " .. val)
                    end)
                end)
            end
        })
    end

    -------------
    /// MAYOR ///
    -------------
    if ply:getJobTable().mayor then
        table.insert(self.list,{title = emenu.text["mayor_tab"], color = Color(252, 29, 59)})

        table.insert(self.list,{
            title = emenu.text["broadcast"],
            func = function(ply)
                emenu:TextInputWindow("", emenu.text["broadcast"].."...",false,function(val)
                    ply:ConCommand("say /broadcast ".. val)
                end)
            end
        })

        table.insert(self.list,{
            title = emenu.text["give_license"],
            func = function(ply)
                ply:ConCommand("say /givelicense")
            end
        })

        table.insert(self.list,{
            title = emenu.text["start_lottery"],
            func = function(ply)
                emenu:TextInputWindow("", emenu.text["start_lottery"].."...",true,function(val)
                    ply:ConCommand("say /lottery ".. val)
                end)
            end
        })

        table.insert(self.list,{
            title = emenu.text["lockdown"],
            func = function(ply)
                emenu:ConfirmWindow("",emenu.text["sure_phrase"],function(bool)
                    if bool then ply:ConCommand("say /lockdown") end
                end)
            end
        })

        table.insert(self.list,{
            title = emenu.text["un_lockdown"],
            func = function(ply)
                ply:ConCommand("say /unlockdown")
            end
        })

        table.insert(self.list,{
            title = emenu.text["add_law"],
            func = function(ply)
                emenu:TextInputWindow("", emenu.text["add_law"].."...",false,function(val)
                    ply:ConCommand("say /addlaw ".. val)
                end)
            end
        })

        table.insert(self.list,{
            title = emenu.text["remove_law"],
            func = function(ply)
                emenu:TextInputWindow("", emenu.text["remove_law"].." ("..emenu.text["number"]..")", true, function(val)
                    ply:ConCommand("say /removelaw ".. val)
                end)
            end
        })

        table.insert(self.list,{
            title = emenu.text["place_laws"],
            func = function(ply)
                ply:ConCommand("say /placelaws ")
            end
        })
    end
end


------------
/// MENU ///
------------
function emenu.quick:GenQuickButtons(bg)
    self.cmds:Generate()
    local ply = LocalPlayer()

    local leftpnl = vgui.Create("DButton",bg)
    leftpnl:SetSize(20,bg:GetTall()*0.15)
    leftpnl:SetZPos(10)
    leftpnl:SetText("")
    leftpnl:CenterVertical()
    leftpnl.state = "closed"
    local offset = 15
    function leftpnl:Paint(w,h)
        surface.SetDrawColor( emenu.colors.quickpanel.bg:Unpack() )
        draw.NoTexture()
        surface.DrawPoly( {
            {x = 0, y = 0},
            {x = w, y = offset},
            {x = w, y = h-offset},
            {x = 0, y = h}
        } )
        draw.SimpleText(IsValid(self.menu) and "<" or ">","emenu_20_500",w*0.5,h*0.47,emenu.colors.quickpanel.text,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end
    emenu:AddHelpText(leftpnl,"Quick action",nil,5,"right")
    function leftpnl:DoClick()
        emenu.quick.cmds:Generate()

        if not IsValid(self.menu) then
            self.menu = vgui.Create("emenu.contextmenu",bg)
            local menu = self.menu
            emenu.quick.panel = menu
            menu = self.menu
            menu:SetZPos(10)
            menu:SetWide(200)
            menu:SetParent(bg)
            bg.contextbg:Remove()

            for _,cmd in ipairs(emenu.quick.cmds.list) do
                local check = true
                if isfunction(cmd.customCheck) then
                    check = cmd.customCheck(ply)
                end
                if check then
                    if isfunction(cmd.func) then
                        local pnl = menu:AddButton(cmd.title,function()
                            cmd.func(ply)
                        end, cmd.icon)
                        if IsColor(cmd.color) then
                            pnl:SetTextColor(cmd.color)
                        end
                    else
                        local pnl = menu:AddHeader(cmd.title)
                        if IsColor(cmd.color) then
                            pnl:SetTextColor(cmd.color)
                        end
                    end
                end
            end

            menu:CenterVertical()
            self.state = "opening"
            menu:SetPos(-menu:GetWide(),menu:GetY())
            menu:MoveTo(self:GetWide()+5,menu:GetY(),emenu.config.animtime,0,-1,function()
                self.state = "opened"
            end)
        else
            self.state = "closing"

            local menu = self.menu
            menu:MoveTo(-menu:GetWide(),menu:GetY(),emenu.config.animtime,0,-1,function()
                if not IsValid(menu) then return end
                menu:Remove()
                self.state = "closed"
            end)
        end
    end
end

hook.Add("OnEMenuHide","emenu_hidequickbuttons",function()
    if IsValid(emenu.quick.panel) then
        emenu.quick.panel:Remove()
    end
end)



emenu.windows:AddWidget("Quickpanel","panel", function(bg) return emenu.quick:GenQuickButtons(bg) end , true)