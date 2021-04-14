local col_ui_bg_white = Color( 255, 255, 255, 150 )
local col_top_white = Color( 255, 255, 255, 200 )

local col_gray_text = Color( 50, 50, 50, 255 )
local col_gray_button = Color( 0, 0, 0, 150 )

local col_weapon_bg = Color( 20, 20, 20, 100 )

net.Receive( "CH_Armory_WeaponMenu", function(length, ply)

	local GUI_Armory_Frame = vgui.Create("DFrame")
	GUI_Armory_Frame:SetTitle("")
	GUI_Armory_Frame:SetSize(620,215)
	GUI_Armory_Frame:Center()
	GUI_Armory_Frame.Paint = function(CHPaint)
		-- Draw the menu background color.		
		draw.RoundedBox( 0, 0, 25, CHPaint:GetWide(), CHPaint:GetTall(), col_ui_bg_white )

		-- Draw the outline of the menu.
		surface.SetDrawColor( color_black )
		surface.DrawOutlinedRect(0, 0, CHPaint:GetWide(), CHPaint:GetTall())
	
		draw.RoundedBox( 0, 0, 0, CHPaint:GetWide(), 25, col_top_white )
		
		surface.SetDrawColor( color_black )
		surface.DrawOutlinedRect( 0, 0, CHPaint:GetWide(), 25 )

		-- Draw the top title.
		draw.SimpleText( "Weapon Armory", "CH_Armory_Font_UI_Small", 60, 12.5, col_gray_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_Armory_Frame:MakePopup()
	GUI_Armory_Frame:ShowCloseButton(false)
	
	local GUI_Main_Exit = vgui.Create("DButton")
	GUI_Main_Exit:SetParent(GUI_Armory_Frame)
	GUI_Main_Exit:SetSize(16,16)
	GUI_Main_Exit:SetPos(600,5)
	GUI_Main_Exit:SetText("")
	GUI_Main_Exit.Paint = function()
		surface.SetMaterial( Material( "icon16/cross.png" ) )
		surface.SetDrawColor( color_white )
		surface.DrawTexturedRect( 0,0,GUI_Main_Exit:GetWide(),GUI_Main_Exit:GetTall() )
	end
	GUI_Main_Exit.DoClick = function()
		GUI_Armory_Frame:Remove()
	end
	
	-- Panel 1
	local Weapon1Panel = vgui.Create( "DPanel", GUI_Armory_Frame )
	Weapon1Panel:SetSize( 200, 180 )
	Weapon1Panel:SetPos( 10, 30 )
	Weapon1Panel.Paint = function( self )
		draw.RoundedBox( 8, 1, 1, self:GetWide() - 2, self:GetTall() - 2, col_weapon_bg )
	end
	
	local Weapon1Display = vgui.Create("DModelPanel", Weapon1Panel)
	Weapon1Display:SetModel( CH_ArmoryRobbery.Weapons.Weapon1Model )
	Weapon1Display:SetPos( -500, -460 )
	Weapon1Display:SetSize( 1200, 1200 )
	Weapon1Display:GetEntity():SetAngles(Angle(255, 255, 255))
	Weapon1Display:SetCamPos( Vector( 255, 255, 80 ) )
	Weapon1Display:SetLookAt( Vector( 0, 0, 0 ) )
	
	local GUI_Weapon1Take = vgui.Create("DButton", Weapon1Panel)	
	GUI_Weapon1Take:SetSize(190,25)
	GUI_Weapon1Take:SetPos(5,125)
	GUI_Weapon1Take:SetText("")
	GUI_Weapon1Take.Paint = function( self )
		draw.RoundedBox( 8, 1, 1, self:GetWide()-2, self:GetTall()-2, col_gray_button )

		draw.SimpleText( "Retrieve ".. CH_ArmoryRobbery.Weapons.Weapon1Name , "CH_Armory_Font_UI_Small", self:GetWide() / 2, self:GetTall() / 2, col_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_Weapon1Take.DoClick = function()
		net.Start( "ARMORY_RetrieveWeapon" )
			net.WriteString("weapon1")
		net.SendToServer()
		
		GUI_Armory_Frame:Remove()
	end
	
	local GUI_Weapon1Deposit = vgui.Create("DButton", Weapon1Panel)	
	GUI_Weapon1Deposit:SetSize(190,25)
	GUI_Weapon1Deposit:SetPos(5,150)
	GUI_Weapon1Deposit:SetText("")
	GUI_Weapon1Deposit.Paint = function( self )
		draw.RoundedBox( 8, 1, 1, self:GetWide()-2, self:GetTall()-2, col_gray_button )

		draw.SimpleText( "Deposit ".. CH_ArmoryRobbery.Weapons.Weapon1Name , "CH_Armory_Font_UI_Small", self:GetWide() / 2, self:GetTall() / 2, col_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_Weapon1Deposit.DoClick = function()
		net.Start("ARMORY_StripWeapon")
			net.WriteString("weapon1")
		net.SendToServer()
		
		GUI_Armory_Frame:Remove()
	end
	
	-- Panel 2
	local Weapon2Panel = vgui.Create( "DPanel", GUI_Armory_Frame )
	Weapon2Panel:SetSize( 200, 180 )
	Weapon2Panel:SetPos( 210, 30 )
	Weapon2Panel.Paint = function( self )
		draw.RoundedBox( 8, 1, 1, self:GetWide() - 2, self:GetTall() - 2, col_weapon_bg )
	end
	
	local Weapon2Display = vgui.Create("DModelPanel", Weapon2Panel)
	Weapon2Display:SetModel( CH_ArmoryRobbery.Weapons.Weapon2Model )
	Weapon2Display:SetPos( -500, -460 )
	Weapon2Display:SetSize( 1200, 1200 )
	Weapon2Display:GetEntity():SetAngles(Angle(255, 255, 255))
	Weapon2Display:SetCamPos( Vector( 255, 255, 80 ) )
	Weapon2Display:SetLookAt( Vector( 0, 0, 0 ) )
	
	local GUI_Weapon2Take = vgui.Create("DButton", Weapon2Panel)	
	GUI_Weapon2Take:SetSize(190,25)
	GUI_Weapon2Take:SetPos(5,125)
	GUI_Weapon2Take:SetText("")
	GUI_Weapon2Take.Paint = function( self )
		draw.RoundedBox( 8, 1, 1, self:GetWide()-2, self:GetTall()-2, col_gray_button )
		
		draw.SimpleText( "Retrieve ".. CH_ArmoryRobbery.Weapons.Weapon2Name , "CH_Armory_Font_UI_Small", self:GetWide() / 2, self:GetTall() / 2, col_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_Weapon2Take.DoClick = function()
		net.Start("ARMORY_RetrieveWeapon")
			net.WriteString("weapon2")
		net.SendToServer()
		
		GUI_Armory_Frame:Remove()
	end
	
	local GUI_Weapon2Deposit = vgui.Create("DButton", Weapon2Panel)	
	GUI_Weapon2Deposit:SetSize(190,25)
	GUI_Weapon2Deposit:SetPos(5,150)
	GUI_Weapon2Deposit:SetText("")
	GUI_Weapon2Deposit.Paint = function( self )
		draw.RoundedBox( 8, 1, 1, self:GetWide()-2, self:GetTall()-2, col_gray_button )

		draw.SimpleText( "Deposit ".. CH_ArmoryRobbery.Weapons.Weapon2Name , "CH_Armory_Font_UI_Small", self:GetWide() / 2, self:GetTall() / 2, col_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_Weapon2Deposit.DoClick = function()
		net.Start("ARMORY_StripWeapon")
			net.WriteString("weapon2")
		net.SendToServer()
		
		GUI_Armory_Frame:Remove()
	end
	
	-- Panel 3
	local Weapon3Panel = vgui.Create( "DPanel", GUI_Armory_Frame )
	Weapon3Panel:SetSize( 200, 180 )
	Weapon3Panel:SetPos( 410, 30 )
	Weapon3Panel.Paint = function( self )
		draw.RoundedBox( 8, 1, 1, self:GetWide() - 2, self:GetTall() - 2, col_weapon_bg )
	end
	
	local Weapon3Display = vgui.Create("DModelPanel", Weapon3Panel)
	Weapon3Display:SetModel( CH_ArmoryRobbery.Weapons.Weapon3Model )
	Weapon3Display:SetPos( -500, -460 )
	Weapon3Display:SetSize( 1200, 1200 )
	Weapon3Display:GetEntity():SetAngles(Angle(255, 255, 255))
	Weapon3Display:SetCamPos( Vector( 255, 255, 80 ) )
	Weapon3Display:SetLookAt( Vector( 0, 0, 0 ) )
	
	local GUI_Weapon3Take = vgui.Create("DButton", Weapon3Panel)	
	GUI_Weapon3Take:SetSize(190,25)
	GUI_Weapon3Take:SetPos(5,125)
	GUI_Weapon3Take:SetText("")
	GUI_Weapon3Take.Paint = function( self )
		draw.RoundedBox( 8, 1, 1, self:GetWide()-2, self:GetTall()-2, col_gray_button )

		draw.SimpleText( "Retrieve ".. CH_ArmoryRobbery.Weapons.Weapon3Name , "CH_Armory_Font_UI_Small", self:GetWide() / 2, self:GetTall() / 2, col_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_Weapon3Take.DoClick = function()
		net.Start("ARMORY_RetrieveWeapon")
			net.WriteString("weapon3")
		net.SendToServer()
		
		GUI_Armory_Frame:Remove()
	end
	
	local GUI_Weapon3Deposit = vgui.Create("DButton", Weapon3Panel)	
	GUI_Weapon3Deposit:SetSize(190,25)
	GUI_Weapon3Deposit:SetPos(5,150)
	GUI_Weapon3Deposit:SetText("")
	GUI_Weapon3Deposit.Paint = function( self )
		draw.RoundedBox( 8, 1, 1, self:GetWide()-2, self:GetTall()-2, col_gray_button )

		draw.SimpleText( "Deposit ".. CH_ArmoryRobbery.Weapons.Weapon3Name , "CH_Armory_Font_UI_Small", self:GetWide() / 2, self:GetTall() / 2, col_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_Weapon3Deposit.DoClick = function()
		net.Start("ARMORY_StripWeapon")
			net.WriteString("weapon3")
		net.SendToServer()
		
		GUI_Armory_Frame:Remove()
	end
end )