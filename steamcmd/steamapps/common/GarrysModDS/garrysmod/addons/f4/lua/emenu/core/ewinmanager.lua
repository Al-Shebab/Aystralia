emenu.windows = emenu.windows or {}
local win = emenu.windows
win.list = win.list or {}
win.seqlist = win.seqlist or {}
win.active = {}

win.widgets = win.widgets or {}

-----------------------
/// WINDOWS MANAGER ///
-----------------------
-- Name: unique name
-- Desc: Button Hover Text
-- Icon: Button icon
-- Func: Function performed when the button is pressed. IMPORTANT: Should return "emenu.window" vgui element!!!
-- Pos:  Position
function win:Register(Name,Desc,Icon,Func,Pos)
	local Name = Name or "None"
	local Desc = Desc or "..."
	local Icon = Icon or emenu.Materials["unknown"]
	local Pos = Pos or #self.seqlist+1

	if not Func then 
		MsgC(emenu.colors.default.red,emenu.config.tag..' [ERROR] Window "'..Name..'" did not return a function!\n')
		return "error"
	end
	if self.list[string.lower(Name)] then
		MsgC(emenu.colors.default.orange,emenu.config.tag..' [WARN] Window "'..Name..'" already exists. Rewriting.\n')
		if emenu.Remove then emenu:Remove() end
	end
	self.list[string.lower(Name)] = {
		name = Name,
		description=Desc,
		icon=Icon,
		func=function(bg)
			local pnl = Func(bg)
			if not ispanel(pnl) then return end

			pnl:SetZPos(2)
			if not ispanel(pnl) then
				return pnl 
			else
				if pnl.state ~= "minimized" then
					pnl.state = "opening"
					pnl:SetAlpha(1)
					pnl:AlphaTo(255,emenu.config.animtime,0,function()
						pnl.id = string.lower(Name)
						pnl.state = "normal"
					end)
					local oldfunc = pnl.OnClose
					function pnl:OnClose()
						win.active[self.id] = nil
						oldfunc()
					end

					local oldfunc = pnl.OnPress
					function pnl:OnPress()
						self:SetZPos(2)
						oldfunc()
					end

					local oldfunc = pnl.OnUnpress
					function pnl:OnUnpress()
						self:SetZPos(1)
						oldfunc()
					end

					self.active[string.lower(Name)] = pnl
				else
					pnl:Maximize()
				end
			end
			return pnl
		end
	}

	for k,v in ipairs(self.seqlist) do
		if v[1] == string.lower(Name) then
			self.seqlist[k] = nil
		end
	end

	table.insert(self.seqlist, Pos, {string.lower(Name)})
	self.seqlist = table.ClearKeys(table.Copy(self.seqlist), true)
end

function win:GetCount()
	return table.Count(self.list) or 0
end

function win:Get(Name)
	return self.list[string.lower(Name)]
end

function win:GetAll()
	return self.list
end

function win:GetSeqAll()
	return self.seqlist
end

function win:GetActive(Name)
	return self.active[string.lower(Name)]
end

function win:IsActive(Name)
	return IsValid(self.active[string.lower(Name)])
end

function win:GetAllActive()
	return self.active
end

function win:HideAll(...)
	local except = ... or {}
    for name,wind in pairs(self:GetAllActive()) do
        if IsValid(wind) then
        	if not except[name] then
            	wind:Minimize(false)
            end
        else
        	self:GetAllActive()[name] = nil
        end
    end
end

---------------
/// WIDGETS ///
---------------
-- Used for example for custom panels or functions 
-- that run before the opening animation or after

-- Name: unique name
-- Type: panel / function
-- Func: called function. As an argument comes the background panel or localplayer, depending on the type
-- After: loading order
function win:AddWidget(Name,Type,Func,After)
	if not Name then Name = "None" end
	if After == nil then After = true end 
	if not isfunction(Func) then 
		MsgC(emenu.colors.default.red, emenu.config.tag..' [ERROR] "'..Name..'" not a function!\n')
		return "error"
	end
	if self.widgets[string.lower(Name)] then
		MsgC(emenu.colors.default.orange,emenu.config.tag..' [WARN] "'..Name..'" already exists. Rewriting.\n')
		emenu:Remove()
	end
	self.widgets[string.lower(Name)] = {
		name = Name,
		type = Type,
		loadafter = After,
		func = function(toret)
			return Func(toret)
		end,
	}
end

function win:GetWidget(name)
	return self.widgets[string.lower(Name)]
end

function win:GetWidgets()
	return self.widgets
end



---------------------
/// OTHER WINDOWS ///
---------------------
--NOTIFY
function emenu:Notify(text,time,etype)
	if not etype then etype = NOTIFY_GENERIC end

    local bg = self.bg
    if IsValid(bg) then
        if IsValid(bg.notifypanel) then 
            bg.notifypanel:Remove()
            if timer.Exists("emenuNotify") then
                timer.Remove("emenuNotify")
            end
        end

        bg.notifypanel = vgui.Create("DPanel",bg)
        local notify = bg.notifypanel
        notify:SetMouseInputEnabled(false)

        if text then
            local font = "emenu_24_500"
            surface.SetFont(font)
            local wx,hy = surface.GetTextSize(text)

            local endtime = CurTime()+time
            notify:SetSize(wx+40,hy+10)
            notify:SetPos(bg:GetWide(),bg:GetTall()-notify:GetTall()-20)
            notify:MoveTo(bg:GetWide()-notify:GetWide()-10,notify:GetY(),emenu.config.animtime)


            local col = Color(232, 230, 228)

            if etype == NOTIFY_ERROR then
            	col = Color(252, 29, 59)
            elseif etype == NOTIFY_GENERIC then
            	col = Color(30, 215, 96)
            elseif etype == NOTIFY_UNDO then
            	col = Color(3, 115, 166)
            elseif etype == NOTIFY_HINT then
            	col = Color(30, 215, 96)
            elseif etype == NOTIFY_CLEANUP then
            	col = Color(252, 29, 59)
            end

            function notify:Paint(w,h)
                local ost = (endtime-CurTime())
                draw.RoundedBox(0,0,0,w,h,emenu.colors.notify.bg)
                draw.RoundedBox(0,0,h-3,w*(ost/time),3,col)
                draw.SimpleText(text,font,w*0.5,h*0.5,emenu.colors.notify.text,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
            end
            if bg:IsVisible() then
                surface.PlaySound("ambient/water/rain_drip1.wav")
            end
        end

        timer.Create("emenuNotify",time,1,function()
            local pnl = bg.notifypanel
            if IsValid(pnl) then
                pnl:MoveTo(pnl:GetX(),bg:GetTall(),emenu.config.animtime,0,-1,function()
                    if IsValid(pnl) then pnl:Remove() end
                end)
            end
        end)
    end
end

--HINT TEXT
function emenu:AddHelpText(pnl,text,font,offset,align)
    if not font then font = "emenu_24_500" end
    if not offset then offset = 5 end
    if not align then align = "bottom" end
    local function HelpText(pnl,text,font,offset)
        if IsValid(emenu.bg) then
            if isfunction(text) then text=text() end
            local lbl = vgui.Create("DPanel",emenu.bg)
                surface.SetFont(font)
                local tx, ty = surface.GetTextSize(text)
                lbl:SetSize(tx+40,ty+20)
                lbl:SetMouseInputEnabled(false)
                local posx,posy = pnl:LocalToScreen()
                local x,y = 0,0
                if align == "top" then
                    x = posx+pnl:GetWide()*0.5-lbl:GetWide()*0.5
                    y = posy-lbl:GetTall()-offset
                elseif align == "right" then
                    x = posx+pnl:GetWide()+offset
                    y = posy+pnl:GetTall()*0.5-lbl:GetTall()*0.5
                else -- bottom
                    x = posx+pnl:GetWide()*0.5-lbl:GetWide()*0.5
                    y = posy+pnl:GetTall()+offset
                end
                x = math.Clamp( x, 0, ScrW() - lbl:GetWide() )
                y = math.Clamp( y, 0, ScrH() - lbl:GetTall() )
                lbl:SetPos(x,y)
                lbl:SetZPos(9)
                function lbl:Paint(w,h)
                    if isfunction(text) then text=text() end
                    draw.RoundedBox(8,2,2,w-4,h-4,emenu.colors.notify.hoverbg)
                    draw.SimpleText(text,font,w*0.5,h*0.5,emenu.colors.notify.text,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
                end
                function lbl:Think()
                    if not IsValid(pnl) then
                        self:Remove()
                    else
                        if not pnl:IsVisible() then
                            self:Remove()
                        end
                    end
                end
            return lbl
        end
    end

    local oldfunc = pnl.OnCursorEntered
    function pnl:OnCursorEntered()
        if IsValid(self.helptext) then self.helptext:Remove() end
        self.helptext = HelpText(pnl,text,font,offset)
        oldfunc(self)
    end
    local oldfunc2 = pnl.OnCursorExited
    function pnl:OnCursorExited()
        if IsValid(self.helptext) then self.helptext:Remove() end
        oldfunc2(self)
    end
end

function emenu:GeneratePopWindow(key_input,hide_emenu)
	self.ready2close = false

	if hide_emenu then
		self:Hide()
	end

	local scrw,scrh = ScrW(),ScrH()
	local bg = vgui.Create("EditablePanel")
	bg:SetSize(scrw,scrh)
	bg:MakePopup()
	bg:SetKeyboardInputEnabled(key_input or false)
	bg:SetZPos(102)
	function bg:Paint(w,h)
		surface.SetDrawColor(emenu.colors.main.bg:Unpack())
		surface.DrawRect(0,0,w,h)
	end

	local pnl = vgui.Create("emenu.window",bg)
	pnl.bg = bg
	pnl:SetSize(scrw*0.3, scrh*0.2)
	pnl:EnableMinimizeButton(false)
	pnl:Center()
	function pnl:OnRemove()
		bg:Remove()
	end

	function pnl:Close()
		bg:AlphaTo(1,emenu.config.animtime,0,function()
			bg:Remove()
		end)
	end

	function bg:OnMousePressed(key)
		pnl:Close()
	end

	function bg:OnKeyCodePressed(key)
		if key == KEY_F4 then
			pnl:Close()
		end
	end

	function bg:OnRemove()
		emenu.ready2close = true
	end

	return pnl
end

function emenu:TextInputWindow(title, text, numeric, callback)
	local pnl = self:GeneratePopWindow(true)
	pnl:SetTitle(title)
	pnl:SetSize(500,200)
	pnl:Center()
	pnl:SetRoundSize(0)
	local content = pnl:GetContent()

	local lbl = content:Add("DPanel")
	lbl:SetSize(content:GetWide(),content:GetTall()*0.3)
	function lbl:Paint(w,h)
		draw.SimpleText(text,"emenu_24_500",w*0.5,h*0.5,emenu.colors.windows.text,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end

	local textinput = content:Add("DTextEntry")
	local offset = 10
	textinput:SetSize(content:GetWide()-offset*2,40)
	textinput:CenterHorizontal()
	textinput:CenterVertical(0.45)
	textinput:SetFont("emenu_20_500")
	textinput:SetTextColor(emenu.colors.windows.text)

	if numeric then 
		textinput:SetPlaceholderText( "500" )
		function textinput:AllowInput(str)
			if string.find(str,"%d") == nil then
				return true
			end
		end
	end

	function textinput:Paint(w,h)
		draw.RoundedBox(16,0,0,w,h,emenu.colors.windows.accent)

		local textcol = self:GetTextColor()
		self:DrawTextEntryText( textcol, emenu.colors.text.hover, textcol )
	end

	function textinput:OnEnter(tex)
		if numeric then
			callback(self:GetInt())
		else
			callback(tex)
		end
		pnl:Close()
	end

	local buttonlist = content:Add("DPanel")
	buttonlist:SetSize(content:GetWide(), content:GetTall()*0.2)
	buttonlist:SetY(content:GetTall()-buttonlist:GetTall()-offset)
	buttonlist.Paint = nil

	local border = 25
	local confirm = buttonlist:Add("DButton")
	confirm:SetSize(buttonlist:GetWide()*0.5-border*2,buttonlist:GetTall())
	confirm:SetX(border)
	confirm:SetText("")
	local hovcol = emenu.util.color:Adjust(emenu.colors.default.green,20)
	function confirm:Paint(w,h)
		draw.RoundedBox(16,0,0,w,h,self:IsHovered() and hovcol or emenu.colors.default.green)
		draw.SimpleText(emenu.text["confirm"],"emenu_20_500",w*0.5,h*0.5,emenu.colors.default.black,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
	function confirm:DoClick()
		if numeric then
			callback(textinput:GetInt())
		else
			callback(textinput:GetValue())
		end
		pnl:Close()
	end

	local revert = buttonlist:Add("DButton")
	revert:SetText("")
	revert:SetSize( confirm:GetWide(), confirm:GetTall() )
	revert:SetX(confirm:GetX() + confirm:GetWide() + border*2)
	local hovcol = emenu.util.color:Adjust(emenu.colors.default.red,20)
	function revert:Paint(w,h)
		draw.RoundedBox(16,0,0,w,h,self:IsHovered() and hovcol or emenu.colors.default.red)
		draw.SimpleText(emenu.text["cancel"],"emenu_20_500",w*0.5,h*0.5,emenu.colors.default.black,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
	function revert:DoClick()
		pnl:Close()
	end
end

function emenu:ConfirmWindow(title, text, callback)
	local pnl = self:GeneratePopWindow(true)
	pnl:SetTitle(title)
	pnl:SetSize(400,125)
	pnl:Center()
	pnl:SetRoundSize(0)
	local content = pnl:GetContent()

	local lbl = content:Add("DPanel")
	lbl:SetSize(content:GetWide(),content:GetTall()*0.5)
	function lbl:Paint(w,h)
		draw.SimpleText(text,"emenu_24_500",w*0.5,h*0.5,emenu.colors.windows.text,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end

	local buttonlist = content:Add("DPanel")
	buttonlist:SetSize(content:GetWide(), content:GetTall()*0.4)
	buttonlist:SetY(content:GetTall()-buttonlist:GetTall()-10)
	buttonlist.Paint = nil

	local border = 25
	local confirm = buttonlist:Add("DButton")
	confirm:SetSize(buttonlist:GetWide()*0.5-border*2,buttonlist:GetTall())
	confirm:SetX(border)
	confirm:SetText("")
	local hovcol = emenu.util.color:Adjust(emenu.colors.default.green,20)
	function confirm:Paint(w,h)
		draw.RoundedBox(16,0,0,w,h,self:IsHovered() and hovcol or emenu.colors.default.green)
		draw.SimpleText(emenu.text["confirm"],"emenu_20_500",w*0.5,h*0.5,emenu.colors.default.black,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
	function confirm:DoClick()
		callback(true)
		pnl:Close()
	end

	local revert = buttonlist:Add("DButton")
	revert:SetText("")
	revert:SetSize( confirm:GetWide(), confirm:GetTall() )
	revert:SetX(confirm:GetX() + confirm:GetWide() + border*2)
	local hovcol = emenu.util.color:Adjust(emenu.colors.default.red,20)
	function revert:Paint(w,h)
		draw.RoundedBox(16,0,0,w,h,self:IsHovered() and hovcol or emenu.colors.default.red)
		draw.SimpleText(emenu.text["cancel"],"emenu_20_500",w*0.5,h*0.5,emenu.colors.default.black,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
	function revert:DoClick()
		callback(false)
		pnl:Close()
	end
end



local function strfind(what,where)
	return string.find(string.lower(where), string.lower(what)) and true or false
end

emenu.players = {}

function emenu.players:GenerateList(search)
	local playerlist = table.Copy(player.GetAll())
	self.list = {}
	self.colorlist = {}

	local teams = team.GetAllTeams()
	for id,ply in ipairs(playerlist) do
		if IsValid(ply) then
			local check = false
			if search then
				if (strfind(search,ply:Nick())) then
					check = true
				end
				if (strfind(search,ply:GetUserGroup())) then
					check = true
				end
				if (strfind(search,ply:SteamID())) then
					check = true
				end
			else
				check = true
			end

			if check then
				local job = ply:getDarkRPVar("job") or "?"

				if self.list[job] == nil then
					self.list[job] = {}
				end

				table.insert(self.list[job],ply)
				self.colorlist[job] = teams[ply:Team()].Color or Color(255,255,255)
			end
		end
	end

end


function emenu.players:SelectWindow(callback)
	local localplayer = LocalPlayer()

	local pnl = emenu:GeneratePopWindow(true)
	self.panel = pnl
	pnl:SetTitle(emenu.text["select_player"])
	pnl:SetSize(ScrW()*0.5,ScrH()*0.9)
	pnl:Center()
	pnl:SetRoundSize(0)
	local content = pnl:GetContent()

	local scroll = content:Add("emenu.scrollpanel")
	scroll:GetVBar():SetSpeed(20)

	local text = emenu.text["search"]
	local font = "emenu_24_500"
	local textsize = emenu.util.GetTextSize(text,font)
	local searchp = scroll:Add("DPanel")
	searchp:SetSize(content:GetWide(),content:GetTall()*0.06)
	function searchp:Paint(w,h)
		draw.SimpleText(text,font,20,h*0.5,emenu.colors.windows.text,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	end

	scroll:SetSize(pnl:GetWide(),pnl:GetTall()-searchp:GetTall())

	local textinput = searchp:Add("DTextEntry")
	local offset = textsize.w+50
	textinput:SetSize(searchp:GetWide()-offset*2,searchp:GetTall()-10)
	textinput:Center()
	textinput:SetFont("emenu_20_500")
	textinput:SetTextColor(emenu.colors.windows.text)
	function textinput:Paint(w,h)
		draw.RoundedBox(16,0,0,w,h,emenu.colors.windows.accent)

		local textcol = self:GetTextColor()
		self:DrawTextEntryText( textcol, emenu.colors.text.hover, textcol )

		draw.SimpleText("[Enter]","emenu_24_500",w-20,h*0.5,emenu.colors.text.darken,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
	end

	function textinput.OnEnter(pnl,tex)
		self:GenerateList(tex)
		self:RefreshPanels()
	end


	self:GenerateList()

	function self:RefreshPanels()
		if IsValid(scroll.list) then
			self.oldscroll = scroll:GetVBar():GetScroll()
			scroll.list:Remove()
		end

		local list = scroll:Add("DIconLayout")
		scroll.list = list
		list:SetWide(scroll:GetWide())
		list:SetStretchHeight(true)
		list:SetY(searchp:GetTall())
		list:SetSpaceY(5)

		for category,players in pairs(self.list) do

			local categlist = list:Add("DIconLayout")
			categlist:SetWide(list:GetWide())
			categlist:SetStretchHeight(true)
			categlist:SetSpaceY(1)

			local catpnl = categlist:Add("DPanel")
			catpnl:SetSize(content:GetWide(),content:GetTall()*0.06)
			local catcolor = self.colorlist[category]


			function catpnl:Paint(w,h)
				surface.SetDrawColor(emenu.colors.windows.accent:Unpack())
				surface.DrawRect(0,0,w,h)

				surface.SetDrawColor(catcolor:Unpack())
				surface.DrawRect(0,0,5,h)

				draw.SimpleText(category,"emenu_24_500",20,h*0.5,emenu.colors.windows.text,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			end

			for id,ply in ipairs(players) do

				local plypan = categlist:Add("DButton")
				plypan:SetText("")
				plypan:SetSize(content:GetWide(),content:GetTall()*0.06)

				local Avatar = vgui.Create( "AvatarImage", plypan )
				Avatar:SetSize(plypan:GetTall(), plypan:GetTall())
				Avatar:SetPos(5,0)
				Avatar:SetPlayer( ply, 64 )
				Avatar:SetMouseInputEnabled( false )


				local hovercol = emenu.util.color:Adjust(emenu.colors.windows.accent,20)
				function plypan:Paint(w,h)
					local hovered = self:IsHovered()

					draw.RoundedBox(0,0,0,w,h,hovered and hovercol or emenu.colors.windows.accent)

					surface.SetDrawColor(catcolor:Unpack())
					surface.DrawRect(0,0,5,h)

					if not IsValid(ply) then
						draw.SimpleText(emenu.text["disconnected"],"emenu_24_500",Avatar:GetWide()+20,h*0.5,emenu.colors.windows.text,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
						return 
					end

					draw.SimpleText(ply:Nick(),"emenu_24_500",Avatar:GetWide()+20,h*0.5,emenu.colors.windows.text,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
					draw.SimpleText(ply:getDarkRPVar("job"),"emenu_20_500",w*0.5,h*0.5,catcolor,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

					if localplayer:isCP() then
						draw.SimpleText(ply:isWanted() and emenu.text["wanted"] or "","emenu_20_500",w-20,h*0.5,emenu.colors.default.red,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
					else
						draw.SimpleText(ply:GetUserGroup(),"emenu_20_500",w-20,h*0.5,emenu.colors.windows.text,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
					end
				end

				function plypan:DoClick()
					if not IsValid(ply) then return end

					callback(ply)
					pnl:Close()
				end
			end
		end
		scroll:Rebuild()
		if self.oldscroll then scroll:GetVBar():SetScroll(self.oldscroll) end
	end

	self:RefreshPanels()

end

hook.Add("emenu_OnPlayerChangedTeam","emenu_playerselect_update",function()
	if IsValid(emenu.players.panel) then
		emenu.players:RefreshPanels()
	end
end)