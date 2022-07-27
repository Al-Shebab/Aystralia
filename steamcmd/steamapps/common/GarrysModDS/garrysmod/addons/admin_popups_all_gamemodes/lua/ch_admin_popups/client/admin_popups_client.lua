local admin_popups = admin_popups or {}

--[[
	MATERIALS
--]]
local mat_goto = Material( "icon16/lightning_go.png", "noclamp smooth" )
local mat_bring = Material( "icon16/arrow_left.png", "noclamp smooth" )
local mat_freeze = Material( "icon16/link.png", "noclamp smooth" )
local mat_return = Material( "icon16/arrow_undo.png", "noclamp smooth" )
local mat_spectate = Material( "icon16/eye.png", "noclamp smooth" )
local mat_kick = Material( "icon16/cancel.png", "noclamp smooth" )

local mat_case = Material( "icon16/briefcase.png", "noclamp smooth" )

--[[
	COLORS
--]]
local color_btn_hover = Color( 52, 152, 219, 255 )
local color_btn_pressed = Color( 52, 152, 219, 180 )

local color_red = Color( 255, 50, 50, 255 )

local color_green = Color( 38, 166, 91, 255 )
local color_red_second = Color( 207, 0, 15, 255 )

local color_orange = Color( 245, 171, 53, 255 )

local col_gray_dark = Color( 30, 30, 30, 230 )
local col_gray_light = Color( 50, 50, 50, 230 )
local col_gray_lighter = Color( 75, 75, 75, 230 )

--[[
	FONTS
--]]
surface.CreateFont( "CH_FONT_AdminPopup_Title", {
	font = "Roboto Lt",
	size = 15,
	weight = 500,
	antialias = true,
	extended = true,
} )

surface.CreateFont( "CH_FONT_AdminPopup_Button", {
	font = "Roboto Lt",
	size = 14,
	weight = 500,
	antialias = true,
	extended = true,
} )

--[[
	POPUP MENU
--]]

local function ch_adminpopup_menu( noob, message, claimed )
	if not IsValid( noob ) or not noob:IsPlayer() then
		return
	end
	
	for k, v in pairs( admin_popups ) do
		if v.idiot == noob then
			local txt = v:GetChildren()[5]
			txt:AppendText( "\n".. message )
			txt:GotoTextEnd()
			
			timer.Destroy( "CH_AdminPopup_Timer_".. noob:SteamID64() ) -- destroy so we can extend
			
			if CH_AdminPopups.Config.AutoCloseTime > 0 then
				timer.Create( "CH_AdminPopup_Timer_".. noob:SteamID64() , CH_AdminPopups.Config.AutoCloseTime, 1, function()
					if IsValid( v ) then
						v:Remove()
					end
				end )
			end
			
			surface.PlaySound( "ui/hint.wav" ) -- just a headsup that it changed
			return
		end
	end

	local w, h = 300, 160
	
	--[[
		Background
	--]]
	
	local frm = vgui.Create("DFrame")
	frm:SetSize( w, h )
	frm:SetPos( CH_AdminPopups.Config.XPos, CH_AdminPopups.Config.YPos )
	frm.idiot = noob
	function frm:Paint( w, h )
		-- Draw frame
		draw.RoundedBox( 8, 0, 0, w, h, col_gray_light )
		-- Draw top
		draw.RoundedBoxEx( 8, 0, 0, w, 20, col_gray_dark, true, true, false, false )
		
	end
	frm.lblTitle:SetColor( color_white )
	frm.lblTitle:SetFont( "CH_FONT_AdminPopup_Title" )
	frm.lblTitle:SetContentAlignment( 7) 
	
	if claimed and IsValid( claimed ) and claimed:IsPlayer() then
		frm:SetTitle( noob:Nick().." - Claimed by "..claimed:Nick() )
		
		if claimed == LocalPlayer() then
			function frm:Paint( w, h )
				-- Draw frame
				draw.RoundedBox( 8, 0, 0, w, h, col_gray_light )
				-- Draw top (green/claimed)
				draw.RoundedBoxEx( 8, 0, 0, w, 20, color_green, true, true, false, false )
			end
		else
			function frm:Paint( w, h )
				-- Draw frame
				draw.RoundedBox( 8, 0, 0, w, h, col_gray_light )
				-- Draw top (red/someone else claimed)
				draw.RoundedBoxEx( 8, 0, 0, w, 20, color_red_second, true, true, false, false )
			end	
		end
	else
		frm:SetTitle( noob:Nick() )
	end
	
	--[[
		Text
	--]]
	
	local msg = vgui.Create("RichText",frm)
	msg:SetPos( 10, 30 )
	msg:SetSize( 190, h - 35 )
	msg:SetContentAlignment( 7 )
	msg:InsertColorChange( 255, 255, 255, 255 )
	msg:SetVerticalScrollbarEnabled( false )
	function msg:PerformLayout()
		self:SetFontInternal( "CH_FONT_AdminPopup_Title" )
	end
	msg:AppendText( message )
	
	--[[
		Buttons
	--]]
	
	local cbu = vgui.Create( "DButton", frm )
	cbu:SetPos( 215, 20 * 1 )
	cbu:SetSize( 83, 18 )
	cbu:SetText("         Goto")
	cbu:SetFont( "CH_FONT_AdminPopup_Button" )
	cbu:SetColor( color_white )
	cbu:SetContentAlignment(4)
	cbu.DoClick = function()
		CH_AdminPopups.Commands[ CH_AdminPopups.Config.AdminMod].Goto( noob )
	end
	cbu.Paint = function( self, w, h )
		if cbu.Depressed or cbu.m_bSelected then 
			draw.RoundedBox( 1, 0, 0, w, h, color_btn_pressed )
		elseif cbu.Hovered then
			draw.RoundedBox( 1, 0, 0, w, h, color_btn_hover )
		else
			draw.RoundedBox( 1, 0, 0, w, h, col_gray_lighter )
		end
		
		surface.SetDrawColor( color_white )
		surface.SetMaterial( mat_goto )
		surface.DrawTexturedRect( 5, 1, 16, 16 )
	end
	
	local cbu = vgui.Create( "DButton", frm )
	cbu:SetPos( 215, 20 * 2 )
	cbu:SetSize( 83, 18 )
	cbu:SetText("         Bring")
	cbu:SetFont( "CH_FONT_AdminPopup_Button" )
	cbu:SetColor( color_white )
	cbu:SetContentAlignment( 4 )
	cbu.DoClick = function()
		CH_AdminPopups.Commands[ CH_AdminPopups.Config.AdminMod].Bring( noob )
	end
	cbu.Paint = function( self, w, h )
		if cbu.Depressed or cbu.m_bSelected then 
			draw.RoundedBox( 1, 0, 0, w, h, color_btn_pressed )
		elseif cbu.Hovered then
			draw.RoundedBox( 1, 0, 0, w, h, color_btn_hover )
		else
			draw.RoundedBox( 1, 0, 0, w, h, col_gray_lighter )
		end
		
		surface.SetDrawColor( color_white )
		surface.SetMaterial( mat_bring )
		surface.DrawTexturedRect( 5, 1, 16, 16 )
	end		
	
	local cbu = vgui.Create( "DButton", frm )
	cbu:SetPos( 215, 20 * 3 )
	cbu:SetSize( 83, 18 )
	cbu:SetText("         Freeze")
	cbu:SetFont( "CH_FONT_AdminPopup_Button" )
	cbu:SetColor( color_white )
	cbu:SetContentAlignment( 4 )
	cbu.should_unfreeze = false
	cbu.DoClick = function()
		if cbu.should_unfreeze then
			CH_AdminPopups.Commands[ CH_AdminPopups.Config.AdminMod].Unfreeze( noob )
			cbu.should_unfreeze = false
			return
		end
		
		CH_AdminPopups.Commands[ CH_AdminPopups.Config.AdminMod].Freeze( noob )

		cbu.should_unfreeze = true
	end
	cbu.Paint = function( self, w, h )
		if cbu.Depressed or cbu.m_bSelected then 
			draw.RoundedBox( 1, 0, 0, w, h, color_btn_pressed )
		elseif cbu.Hovered then
			draw.RoundedBox( 1, 0, 0, w, h, color_btn_hover )
		else
			draw.RoundedBox( 1, 0, 0, w, h, col_gray_lighter )
		end
		
		surface.SetDrawColor( color_white )
		surface.SetMaterial( mat_freeze )
		surface.DrawTexturedRect( 5, 1, 16, 16 )
	end
	
	local cbu = vgui.Create( "DButton", frm )
	cbu:SetPos( 215, 20 * 4 )
	cbu:SetSize( 83, 18 )
	cbu:SetText("         Return")
	cbu:SetFont( "CH_FONT_AdminPopup_Button" )
	cbu:SetColor( color_white )
	cbu:SetContentAlignment( 4 )
	cbu.DoClick = function()
		CH_AdminPopups.Commands[ CH_AdminPopups.Config.AdminMod].Return( noob )
	end
	cbu.Paint = function( self, w, h )
		if cbu.Depressed or cbu.m_bSelected then 
			draw.RoundedBox( 1, 0, 0, w, h, color_btn_pressed )
		elseif cbu.Hovered then
			draw.RoundedBox( 1, 0, 0, w, h, color_btn_hover )
		else
			draw.RoundedBox( 1, 0, 0, w, h, col_gray_lighter )
		end
		
		surface.SetDrawColor( color_white )
		surface.SetMaterial( mat_return )
		surface.DrawTexturedRect( 5, 1, 16, 16 )
	end
	
	local cbu = vgui.Create( "DButton", frm )
	cbu:SetPos( 215, 20 * 5 )
	cbu:SetSize( 83, 18 )
	cbu:SetText("         Spectate")
	cbu:SetFont( "CH_FONT_AdminPopup_Button" )
	cbu:SetColor( color_white )
	cbu:SetContentAlignment( 4 )
	cbu.DoClick = function()
		CH_AdminPopups.Commands[ CH_AdminPopups.Config.AdminMod].Spectate( noob )
	end
	cbu.Paint = function( self, w, h )
		if cbu.Depressed or cbu.m_bSelected then 
			draw.RoundedBox( 1, 0, 0, w, h, color_btn_pressed )
		elseif cbu.Hovered then
			draw.RoundedBox( 1, 0, 0, w, h, color_btn_hover )
		else
			draw.RoundedBox( 1, 0, 0, w, h, col_gray_lighter )
		end
		
		surface.SetDrawColor( color_white )
		surface.SetMaterial( mat_spectate )
		surface.DrawTexturedRect( 5, 1, 16, 16 )
	end	
	
	local cbu = vgui.Create( "DButton", frm )
	cbu:SetPos( 215, 20 * 6 )
	cbu:SetSize( 83, 18 )
	cbu:SetText("         Kick")
	cbu:SetFont( "CH_FONT_AdminPopup_Button" )
	cbu:SetColor( color_white )
	cbu:SetContentAlignment( 4 )
	cbu.DoClick = function()
		CH_AdminPopups.Commands[ CH_AdminPopups.Config.AdminMod].Kick( noob )
	end
	cbu.Paint = function( self, w, h )
		if cbu.Depressed or cbu.m_bSelected then 
			draw.RoundedBox( 1, 0, 0, w, h, color_btn_pressed )
		elseif cbu.Hovered then
			draw.RoundedBox( 1, 0, 0, w, h, color_btn_hover )
		else
			draw.RoundedBox( 1, 0, 0, w, h, col_gray_lighter )
		end
		
		surface.SetDrawColor( color_white )
		surface.SetMaterial( mat_kick )
		surface.DrawTexturedRect( 5, 1, 16, 16 )
	end	
	
	local cbu = vgui.Create( "DButton", frm )
	cbu:SetPos( 215, 20 * 7 )
	cbu:SetSize( 83, 18 )
	cbu:SetText("         Claim")
	cbu:SetFont( "CH_FONT_AdminPopup_Button" )
	cbu:SetColor( color_white )
	cbu:SetContentAlignment( 4 )
	cbu.shouldclose = false
	cbu.DoClick = function()
		if not cbu.shouldclose then
			if frm.lblTitle:GetText():lower():find("claimed") then
				chat.AddText( color_red, "[ERROR] Case has already been claimed." )
				surface.PlaySound( "common/wpn_denyselect.wav" )
			else
				chat.AddText( color_green, "[CASE] You have claimed this case." )
				
				net.Start( "CH_AdminPopups_ClaimCase" )
					net.WriteEntity( noob )
				net.SendToServer()
				
				cbu.shouldclose = true
				cbu:SetText("         Close")
			end
		else
			chat.AddText( color_red, "[CASE] You have closed this case." )
			
			net.Start( "CH_AdminPopups_CloseCase" )
				net.WriteEntity( noob or nil )
			net.SendToServer()
		end
	end
	cbu.Paint = function( self, w, h )
		if cbu.Depressed or cbu.m_bSelected then 
			draw.RoundedBox( 1, 0, 0, w, h, color_btn_pressed )
		elseif cbu.Hovered then
			draw.RoundedBox( 1, 0, 0, w, h, color_btn_hover )
		else
			draw.RoundedBox( 1, 0, 0, w, h, col_gray_lighter )
		end
		
		surface.SetDrawColor( color_white )
		surface.SetMaterial( mat_case )
		surface.DrawTexturedRect( 5, 1, 16, 16 )
	end
	
	
	--[[
		Close Button
	--]]
	
	local bu = vgui.Create( "DButton", frm )
	bu:SetText( "✕" )
	bu:SetColor( color_white )
	bu:SetPos( w - 22, 2 )
	bu:SetSize( 16, 16 )
	function bu:Paint( w, h )
	end	
	bu.DoClick = function()
		frm:Close()
	end
	
	frm:ShowCloseButton( false )
	
	frm:SetPos( -w -30, CH_AdminPopups.Config.YPos + ( 175 * #admin_popups ) ) -- move out of screen 
	frm:MoveTo( CH_AdminPopups.Config.XPos, CH_AdminPopups.Config.YPos + ( 175 * #admin_popups ), 0.2, 0,1, function() -- move back in
		surface.PlaySound( "garrysmod/balloon_pop_cute.wav" )
	end )
	
	function frm:OnRemove() -- for animations when there are several panels
		table.RemoveByValue( admin_popups, frm )
		
		for k, v in pairs( admin_popups ) do
			v:MoveTo( CH_AdminPopups.Config.XPos, CH_AdminPopups.Config.YPos + ( 175 *( k - 1 ) ), 0.1, 0,1, function() end )
		end
		
		if noob and IsValid( noob ) and noob:IsPlayer() and timer.Exists( "CH_AdminPopup_Timer_".. noob:SteamID64() ) then
			timer.Destroy( "CH_AdminPopup_Timer_".. noob:SteamID64() )
		end
	end
	
	table.insert( admin_popups, frm )
	
	--[[
		Autoclose Timer
	--]]
	if CH_AdminPopups.Config.AutoCloseTime > 0 then
		timer.Create( "CH_AdminPopup_Timer_".. noob:SteamID64(), CH_AdminPopups.Config.AutoCloseTime, 1, function()
			if IsValid( frm ) then
				frm:Remove()
			end
		end )
	end
end

--[[
	NET MESSAGES
--]]

net.Receive( "CH_AdminPopups_CasePopup", function( len )
	local ply = net.ReadEntity()
	local msg = net.ReadString()
	local claimed = net.ReadEntity()
	
	local dutymode = cvars.Number( "cl_adminpopups_dutymode" )
	
	if dutymode == 0 then
		ch_adminpopup_menu( ply, msg, claimed )
	elseif dutymode == 1 then
		if table.HasValue( CH_AdminPopups.Config.OnDutyJobs, team.GetName( LocalPlayer():Team()):lower() ) then
			ch_adminpopup_menu( ply, msg, claimed )
		else
			chat.AddText( color_orange, "[Admin Popups] ", team.GetColor( ply:Team() ), ply:Nick(), color_white, ": ", msg )
		end				
	elseif dutymode == 2 then
		if table.HasValue( CH_AdminPopups.Config.OnDutyJobs, team.GetName( LocalPlayer():Team()):lower() ) then
			ch_adminpopup_menu( ply, msg, claimed )
		else
			MsgC( color_orange,"[Admin Popups] ", team.GetColor( ply:Team() ), ply:Nick(), color_white, ": ", msg, "\n" )
		end	
	end		
end )

net.Receive( "CH_AdminPopups_CloseCase", function( len )
	local noob = net.ReadEntity()
	
	if not IsValid( noob ) or not noob:IsPlayer() then
		return
	end
	
	for k, v in pairs( admin_popups ) do
		if v.idiot == noob then
			v:Remove()
		end
	end
	
	if timer.Exists( "CH_AdminPopup_Timer_".. noob:SteamID64() ) then
		timer.Destroy( "CH_AdminPopup_Timer_".. noob:SteamID64() )
	end
end )

net.Receive( "CH_AdminPopups_ClaimCase", function( len )
	local ply = net.ReadEntity()
	local noob = net.ReadEntity()
	
	for k, v in pairs( admin_popups ) do
		if v.idiot == noob then
			if cvars.Bool( "cl_adminpopups_closeclaimed" ) and ply ~= LocalPlayer() then
				v:Remove()
			else
				local titl = v:GetChildren()[4]
				titl:SetText( titl:GetText() .. " - Claimed by ".. ply:Nick() )
				
				if ply == LocalPlayer() then
					function v:Paint( w, h )
						-- Draw frame
						draw.RoundedBox( 8, 0, 0, w, h, col_gray_light )
						-- Draw top (green/claimed)
						draw.RoundedBoxEx( 8, 0, 0, w, 20, color_green, true, true, false, false )
					end
				else
					function v:Paint( w, h )
						-- Draw frame
						draw.RoundedBox( 8, 0, 0, w, h, col_gray_light )
						-- Draw top (green/claimed)
						draw.RoundedBoxEx( 8, 0, 0, w, 20, color_red_second, true, true, false, false )
					end
				end
				
				local bu = v:GetChildren()[11]
				bu.DoClick = function()
					if LocalPlayer() == ply then
						net.Start( "CH_AdminPopups_CloseCase" )
							net.WriteEntity( noob )
						net.SendToServer()
					else
						v:Close()
					end
				end	
			end
		end
	end
end )

--[[
	CONCOMMAND
	76561198166995690
--]]

concommand.Add( "adminpopups_claimtop", function( ply, cmd, args )
	if not CH_AdminPopups.PlayerHasAccess( ply ) then
		return
	end
	
	local reports = #admin_popups
	
	if reports > 0 then
		local button = admin_popups[1]:GetChildren()[12] -- button we want is 10th child of frame #1
		button.DoClick()
	end	
end )

--[[
	CHAT PRINT TO REPORT
--]]

if CH_AdminPopups.Config.PrintReportCommand then
	timer.Create( "CH_AdminPopup_AdvertCommand", CH_AdminPopups.Config.PrintReportCommandInterval, 0, function()
		for k, ply in ipairs( player.GetAll() ) do
			chat.AddText( color_green, "[Reporting] Type ".. CH_AdminPopups.Config.ReportCommand .." followed by your message to message admins." )
			return
		end
	end )
end