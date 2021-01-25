-- ╔═══╗───╔╗──────╔╗─╔╗────╔╗--
-- ║╔═╗║───║║──────║║─║║────║║--
-- ║║─╚╬╗─╔╣╚═╦══╦═╣╚═╝╠╗╔╦═╝║--
-- ║║─╔╣║─║║╔╗║║═╣╔╣╔═╗║║║║╔╗║--
-- ║╚═╝║╚═╝║╚╝║║═╣║║║─║║╚╝║╚╝║--
-- ╚═══╩═╗╔╩══╩══╩╝╚╝─╚╩══╩══╝--
-- ────╔═╝║──── By Mactavish ─--
-- ────╚══╝───────────────────--
-- ───────────────────────────--

local CyberUI = {}

function CyberUI.MainButton(parent, text, w, h, func, x, y)
	
	local fade, alpha, size = 0, 0, 0
	
	local button = vgui.Create( "DButton" )
	button:SetSize( w, h )
	if x then
		button:SetPos( x, y )
		button:SetParent(parent)
	end
	button:SetText( "" )
	button.text = text
	button.Paint = function( self, w, h )
			
			if fade < 255 then
				fade = Lerp(FrameTime() * 3, fade, 255)
			end
			
			if self.hover then
				alpha = Lerp(FrameTime() * 8, alpha, 255)
				size = Lerp(FrameTime() * 8, size, w)
			else
				alpha = Lerp(FrameTime() * 12, alpha, 0)
				size = Lerp(FrameTime() * 8, size, 0)
			end
			
			CyberHud.DrawCyberBoards(w/2-size/2,0,size,h,alpha)
			
			CyberHud.DrawBloomLines(0, h/2-15, w, 30, CyberHud.Alpha(CyberHud.Patern["main_l"], math.Clamp(fade,0,25)), "gr")
			draw.SimpleTextOutlined( text ,"CyberHud.Main24", w/2,h/2,CyberHud.Alpha(CyberHud.Patern["main_l"], fade), TEXT_ALIGN_CENTER, 1, 1, Color(0, 0, 0, math.Clamp(fade,0,50)) )
			
		end
	button.DoClick = function(self) 
		func(self)
	end
	button.DoRightClick = function(self) 
		func(self)
	end
	button.OnCursorEntered = function( self ) self.hover = true end
	button.OnCursorExited = function( self ) self.hover = false end
	
	if !x then
		parent:AddItem(button)
	end

	return button
	
end

function CyberUI.Button(parent, text, w, h, func)
	
	local fade, alpha = 0, 0
	
	local button = vgui.Create( "DButton" )
	button:SetSize( w, h )
	button:SetText( "" )
	button.text = text
	button.Paint = function( self, w, h )
			
			if fade < 255 then
				fade = Lerp(FrameTime() * 3, fade, 255)
			end
			
			if self.hover then
				alpha = Lerp(FrameTime() * 8, alpha, 255)
			else
				alpha = Lerp(FrameTime() * 8, alpha, 0)
			end
			
			CyberHud.DrawBloomLines(0, 0, w, 22, CyberHud.Alpha(CyberHud.Patern["main_l"], alpha-100), "gr")
	
			draw.SimpleTextOutlined(text, "CyberHud.Main18", 10, 10,CyberHud.Patern["main_l"],TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, CyberHud.Alpha(CyberHud.Patern["shadow"], 100))
			
		end
	button.DoClick = function(self) 
		func(self)
	end
	button.DoRightClick = function(self) 
		func(self)
	end
	button.OnCursorEntered = function( self ) self.hover = true end
	button.OnCursorExited = function( self ) self.hover = false end
	
	parent:AddItem(button)
	
	return button
	
end

function CyberUI.Selector(parent, text, w, h, var, func)
	
	local poser
	local alf, alpha = 0, 0
	local var = var
	
	local button = vgui.Create("DButton")
	button:SetText("")
	button:SetSize(w, h)
	button.Paint = function( self, w, h )
		
		if self.hover then
			alpha = Lerp(FrameTime() * 8, alpha, 255)
		else
			alpha = Lerp(FrameTime() * 8, alpha, 0)
		end
		
		CyberHud.DrawBloomLines(0, 0, w, 22, CyberHud.Alpha(CyberHud.Patern["main_l"], alpha-100), "gr")
		draw.SimpleTextOutlined(text, "CyberHud.Main18", 5, 10,CyberHud.Alpha(CyberHud.Patern["main_l"], 255),TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, CyberHud.Alpha(CyberHud.Patern["shadow"], 100))
		if !poser then if var then poser = w-18 alf = 255 else poser = w-35 end end
		
		if var then
			poser = Lerp(0.1, poser, w-18)
			alf = Lerp(0.1, alf, 255)
		else
			poser = Lerp(0.1, poser, w-35)
			alf = Lerp(0.1, alf, 0)
		end

		draw.RoundedBox( 6, w-35, 4, 30, 12, Color( 125,125,125, 100-alf) )
		draw.RoundedBox( 6, w-35, 4, 30, 12, CyberHud.Alpha(CyberHud.Patern["main_l"], alf) )
		draw.RoundedBox( 8, poser, 2, 16, 16, Color(200, 200, 200, 255) )
		
	end
	button.DoClick = function() var = !var func(var) end
	button.OnCursorEntered = function( self ) self.hover = true end
	button.OnCursorExited = function( self ) self.hover = false end
	
	parent:AddItem(button)
	
	return button
	
end

function CyberUI.InfoPanel(parent, text)
	
	local panel = vgui.Create( "RichText" )
	panel:SetPos( 20,20)
	panel.StartFrame = 0
	panel.Paint = function(self, w, h)
		if panel.StartFrame and panel.StartFrame < 3 then
			self:SetFontInternal( "CyberHud.Main18"  )
			self:SetFGColor( Color(255,255,255,200) )
			self:SetToFullHeight()
			panel.StartFrame = panel.StartFrame + 1
		else
			if panel.StartFrame then panel.StartFrame = false end
		end
	end
	panel:SetText(text)
	panel:GetChildren()[1]:Hide()
	
	parent:AddItem(panel)
	
	
	
	return panel
	
end

function CyberHud.OpenConfig(ply, cmd, args)
	
	if CyberHud.LockedConfig then return end
	
	if !ply:IsSuperAdmin() then return end
	
	local LocalCongig = table.Copy(CyberHud.Config)
	
	local menu = vgui.Create( "DFrame" )
	menu:SetSize( ScrW()-ScrW()/1.5, ScrH() )
	menu:Center()
	menu:MakePopup()
	menu:SetDraggable( false )
	menu:ShowCloseButton( false )
	menu:SetTitle( "" )
	menu.Paint = function(self, w, h)
		Derma_DrawBackgroundBlur( self )
		CyberHud.DrawCyberBoards(0,0,w,h,255)
		CyberHud.TitleBox(20, 20, 10, "CyberHUD Config", "align_left")
		
		CyberHud.TextBox(15, 60, 10, "This is server configuration, changes will affect all players!", "align_left")
	end
	
	local cb = vgui.Create("DButton", menu)
	cb:SetSize( 75, 25 )
	cb:SetPos( menu:GetWide()-100, 25 )
	cb:SetText( "" )	
	cb.Paint = function(self, w, h)
		if self.hover then
			CyberHud.TitleBox(0, 0, 10, "CLOSE", "align_left")
		else
			CyberHud.TextBox(0, 0, 10, "CLOSE", "align_left")
		end
	end
	cb.DoClick = function()
		menu:Close()
	end
	cb.OnCursorEntered = function(self) self.hover = true end
	cb.OnCursorExited = function(self) self.hover = false end
	
	local panel = vgui.Create("DPanelList", menu)
	panel:SetSize(menu:GetWide()-30, menu:GetTall()-210)
	panel:SetPos( 15, 100 )
	panel:EnableHorizontal( false )
	panel:EnableVerticalScrollbar( true )
	panel:SetSpacing(5)
	panel.Paint = function() end
	panel.VBar.Paint = function(s,w,h) draw.RoundedBox( 4, 3, 13, 8, h-24, Color(0,0,0,70)) end
	panel.VBar.btnUp.Paint = function() end
	panel.VBar.btnDown.Paint = function() end
	panel.VBar.btnGrip.Paint = function(s,w,h)draw.RoundedBox( 4, 5, 0, 4, h+22, Color(0,0,0,70)) end
	
	CyberUI.InfoPanel(panel, "Enable HUD glitching effect when player got damaged or player's health is less than 60%")
	CyberUI.Selector(panel, "Glitch effect", 500, 30, LocalCongig.GlitchEffect, function(var) LocalCongig.GlitchEffect = var end)
	CyberUI.InfoPanel(panel, "Enable color correction when player's health gets lower")
	CyberUI.Selector(panel, "Color correction", 500, 30, LocalCongig.ColorCor, function(var) LocalCongig.ColorCor = var end)
	CyberUI.InfoPanel(panel, "Enable blood stains on the screen when player's health is low")
	CyberUI.Selector(panel, "Blood stains", 500, 30, LocalCongig.BloodStains, function(var) LocalCongig.BloodStains = var end)
	CyberUI.InfoPanel(panel, "Enable heart beating sound when player's health is low")
	CyberUI.Selector(panel, "Heart beating sound", 500, 30, LocalCongig.HeartBeat, function(var) LocalCongig.HeartBeat = var end)
	CyberUI.InfoPanel(panel, "Draw notifications with the same color as a hud")
	CyberUI.Selector(panel, "Main color based notifications", 500, 30, LocalCongig.MainColorBased, function(var) LocalCongig.MainColorBased = var end)
	CyberUI.InfoPanel(panel, "Enable flash on alert notifications (middle screen notifications)")
	CyberUI.Selector(panel, "Enable flash on alert", 500, 30, LocalCongig.EnableFlash, function(var) LocalCongig.EnableFlash = var end)
	CyberUI.InfoPanel(panel, "Show player's wallet only if it was changed (when player drops/gets money or salary)")
	CyberUI.Selector(panel, "Hide wallet", 500, 30, LocalCongig.HiddenWallet, function(var) LocalCongig.HiddenWallet = var end)
	CyberUI.InfoPanel(panel, "Draw halo around players when they are close to you")
	CyberUI.Selector(panel, "Draw halo around players", 500, 30, LocalCongig.DrawPlayerHalo, function(var) LocalCongig.DrawPlayerHalo = var end)
	CyberUI.InfoPanel(panel, "Enable overhead hud information above other players")
	CyberUI.Selector(panel, "Enable overhead hud", 500, 30, LocalCongig.EnablePlayerInfo, function(var) LocalCongig.EnablePlayerInfo = var end)
	CyberUI.InfoPanel(panel, "Display player's overhead job title")
	CyberUI.Selector(panel, "Display job title", 500, 30, LocalCongig.ShowPlayerJob or false, function(var) LocalCongig.ShowPlayerJob = var end)
	CyberUI.InfoPanel(panel, "Use team colors for overhead hud information")
	CyberUI.Selector(panel, "Use team colors", 500, 30, LocalCongig.UseTeamColors or false, function(var) LocalCongig.UseTeamColors = var end)
	CyberUI.InfoPanel(panel, "Weapon selection and information hud")
	CyberUI.Selector(panel, "Enable weapon selection ", 500, 30, LocalCongig.WeaponSelectionHud, function(var) LocalCongig.WeaponSelectionHud = var end)
	CyberUI.Selector(panel, "Enable weapon information ", 500, 30, LocalCongig.WeaponInfo, function(var) LocalCongig.WeaponInfo = var end)
	CyberUI.InfoPanel(panel, "Draw halo around entities (doors and cars) when you are close and looking at them")
	CyberUI.Selector(panel, "Draw halo around entities", 500, 30, LocalCongig.DrawDoorHalo, function(var) LocalCongig.DrawDoorHalo = var end)

	CyberUI.MainButton(menu, "Save and Exit", menu:GetWide()-30, 100, function() 
		net.Start("CyberHud.SaveConfig")
			net.WriteTable(LocalCongig)
		net.SendToServer()
		menu:Close()
	end, 15, menu:GetTall()-110)
	
	
end
concommand.Add("ch_config", CyberHud.OpenConfig)