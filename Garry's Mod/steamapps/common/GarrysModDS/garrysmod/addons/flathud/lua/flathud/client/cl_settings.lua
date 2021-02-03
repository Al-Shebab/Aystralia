-- FlatHUD Owner: 76561198166995690
-- FlatHUD Version: 1.1.1

function FlatHUD.ShowSettings()
	local Main = FlatUI.MakePanel(550, 618, "FlatHUD Settings" .. (!FlatHUD.Cfg.EditableForPlayers and FlatHUD.GetPhrase("preview") or ""))
	Main:DockPadding( 0, 42 * FlatHUD.Scale, 0, 0 )

	local CloseBut = vgui.Create("DButton", Main)
	CloseBut:SetText( "" )
	CloseBut:SetSize(41 * FlatHUD.Scale, 41 * FlatHUD.Scale)
	CloseBut:SetPos((550 - 41) * FlatHUD.Scale, 0)
	CloseBut:DockMargin(0, 0, 10 * FlatHUD.Scale, 0)
	CloseBut.DoClick = function()
		Main:Remove()
	end
	CloseBut.Paint = function( self, w, h )
		surface.SetMaterial( FlatUI.Icons.Close )
		surface.SetDrawColor( FlatUI.Colors.White )
		surface.DrawTexturedRect(8 * FlatHUD.Scale, 8 * FlatHUD.Scale, 24 * FlatHUD.Scale, 24 * FlatHUD.Scale)
	end

	Main.OnRemove = function()
		for k, v in ipairs(FlatHUD.FlatPanels) do
			v:Remove()
		end

		include("autorun/rflathud_autorun.lua")
	end

	local Scroll = vgui.Create("DScrollPanel", Main)
	Scroll:Dock(FILL)
	Scroll.Paint = function( self, w, h )
		draw.RoundedBox(6, 0, 0, w, h, Color(255, 255, 255, 0))
	end
	Scroll:CustomScrollBar()

	FlatUI.MakeSlider(Scroll, "flathud_scale", FlatHUD.GetPhrase("hud_scale"), 10, 30, 0)
	FlatUI.MakeSlider(Scroll, "flathud_rounding", FlatHUD.GetPhrase("hud_rounding"), 0, 20, 0)
	FlatUI.MakeSlider(Scroll, "flathud_opacity", FlatHUD.GetPhrase("hud_opacity"), 0, 255, 0)

	cvars.AddChangeCallback("flathud_opacity", function(name, old, new)
		FlatHUD.Opacity = tonumber(new)
	end)

	cvars.AddChangeCallback("flathud_rounding", function(name, old, new)
		FlatHUD.Rounding = tonumber(new)
	end)

	cvars.AddChangeCallback("flathud_role_color", function(name, old, new)
		FlatHUD.TeamCol = tonumber(new)

		print(FlatHUD.TeamCol)
	end)

	cvars.AddChangeCallback("flathud_blur", function(name, old, new)
		FlatHUD.Blur = tonumber(new)
	end)

	cvars.AddChangeCallback("flatui_col_r", function(name, old, new)
		FlatHUD.ColorR = tonumber(new)
	end)

	cvars.AddChangeCallback("flatui_col_g", function(name, old, new)
		FlatHUD.ColorG = tonumber(new)
	end)

	cvars.AddChangeCallback("flatui_col_b", function(name, old, new)
		FlatHUD.ColorB = tonumber(new)
	end)

	cvars.AddChangeCallback("flathud_level_mode", function(name, old, new)
		FlatHUD.LevelPanel = tonumber(new)
	end)


	FlatUI.MakeCheckbox(Scroll, "flathud_crashscreen", FlatHUD.GetPhrase("hud_crashscreen"))
	FlatUI.MakeCheckbox(Scroll, "flathud_minimal_mode", FlatHUD.GetPhrase("hud_minimal"))
	FlatUI.MakeCheckbox(Scroll, "flathud_role_color", FlatHUD.GetPhrase("hud_rolecolor"))
	FlatUI.MakeCheckbox(Scroll, "flathud_blur", FlatHUD.GetPhrase("hud_blur"))

	FlatUI.MakeColorPanel(Scroll, "flatui_col_r", "flatui_col_g", "flatui_col_b")

	if LevelSystemConfiguration then
		local LevelPanel = FlatUI.MakeComboBox(Scroll, FlatHUD.GetPhrase("level_mode"))
		LevelPanel:AddChoice( "Always show", "flathud_level_mode 1" )
		LevelPanel:AddChoice( "Show with TAB", "flathud_level_mode 2" )
		LevelPanel:AddChoice( "Hide", "flathud_level_mode 3" )
		LevelPanel:AddChoice( "Show when getting XP", "flathud_level_mode 4" )
		LevelPanel:SetValue( LevelPanel:GetSelected() or (GetConVar( "flathud_level_mode" ):GetInt() == 1 and "Always show" or GetConVar( "flathud_level_mode" ):GetInt() == 2 and "Show with TAB" or GetConVar( "flathud_level_mode" ):GetInt() == 3 and "Hide" or GetConVar( "flathud_level_mode" ):GetInt() == 4 and "Show when getting XP") )
	end

	local LawsPanel = FlatUI.MakeComboBox(Scroll, FlatHUD.GetPhrase("laws_mode"))
	LawsPanel:AddChoice( "Always show", "flathud_laws_mode 1" )
	LawsPanel:AddChoice( "Show with TAB", "flathud_laws_mode 2" )
	LawsPanel:AddChoice( "Hide", "flathud_laws_mode 3" )
	LawsPanel:SetValue( LawsPanel:GetSelected() or (GetConVar( "flathud_laws_mode" ):GetInt() == 1 and "Always show" or GetConVar( "flathud_laws_mode" ):GetInt() == 2 and "Show with TAB" or GetConVar( "flathud_laws_mode" ):GetInt() == 3 and "Hide") )

	local WantedPanel = FlatUI.MakeComboBox(Scroll, FlatHUD.GetPhrase("wantedlist_mode"))
	WantedPanel:AddChoice( "Always show", "flathud_wantedlist_mode 1" )
	WantedPanel:AddChoice( "Show with TAB", "flathud_wantedlist_mode 2" )
	WantedPanel:AddChoice( "Hide", "flathud_wantedlist_mode 3" )
	WantedPanel:SetValue( WantedPanel:GetSelected() or (GetConVar( "flathud_wantedlist_mode" ):GetInt() == 1 and "Always show" or GetConVar( "flathud_wantedlist_mode" ):GetInt() == 2 and "Show with TAB" or GetConVar( "flathud_wantedlist_mode" ):GetInt() == 3 and "Hide") )

	local ResetButton = FlatUI.CreateFlatButton(Main, FlatHUD.GetPhrase("reset_settings"), FlatUI.Colors.HP, FlatUI.Colors.LightHP, function()
		local Scale = GetConVar( "flathud_scale" )
		local Rounding = GetConVar( "flathud_rounding" )
		local Opacity = GetConVar( "flathud_opacity" )

		local Crashscreen = GetConVar( "flathud_crashscreen" )
		local MinimalMode = GetConVar( "flathud_minimal_mode" )
		local RoleColor = GetConVar( "flathud_role_color" )
		local BlurMode = GetConVar( "flathud_blur" )

		local ColR = GetConVar( "flatui_col_r" )
		local ColG = GetConVar( "flatui_col_g" )
		local ColB = GetConVar( "flatui_col_b" )

		local LevelMode = GetConVar( "flathud_level_mode" )
		local LawsMode = GetConVar( "flathud_laws_mode" )
		local WantedList = GetConVar( "flathud_wantedlist_mode" )

		Scale:SetInt(Scale:GetDefault())
		Rounding:SetInt(Rounding:GetDefault())
		Opacity:SetInt(Opacity:GetDefault())

		Crashscreen:SetInt(Crashscreen:GetDefault())
		MinimalMode:SetFloat(MinimalMode:GetDefault())
		RoleColor:SetInt(RoleColor:GetDefault())
		BlurMode:SetInt(BlurMode:GetDefault())

		ColR:SetInt(ColR:GetDefault())
		ColG:SetInt(ColG:GetDefault())
		ColB:SetInt(ColB:GetDefault())

		LevelMode:SetInt(LevelMode:GetDefault())
		LawsMode:SetInt(LawsMode:GetDefault())
		WantedList:SetInt(WantedList:GetDefault())
	end)

	ResetButton:Dock(BOTTOM)
	ResetButton:DockMargin(10, 0, 10, 12 * FlatHUD.Scale)
	ResetButton:SetTall(30 * FlatHUD.Scale)

	if LocalPlayer():IsSuperAdmin() then
		local CopySettings = FlatUI.CreateFlatButton(Main, FlatHUD.GetPhrase("copy_settings"), FlatUI.Colors.Armor, FlatUI.Colors.LightArmor, function()
			SetClipboardText( "FlatHUD.Cfg.Scale = " .. GetConVar( "flathud_scale" ):GetInt() .. " 	-- value: 10 - 30\nFlatHUD.Cfg.Rounding = " .. GetConVar( "flathud_rounding" ):GetInt() .. "	-- value: 0 - 20\nFlatHUD.Cfg.Opacity = " .. GetConVar( "flathud_opacity" ):GetInt() .. "   -- value: 0 - 255\n\nFlatHUD.Cfg.CrashScreen = " .. (GetConVar( "flathud_crashscreen" ):GetInt() == 1 and "true" or "false") .. "\nFlatHUD.Cfg.MiniMode = " .. (GetConVar( "flathud_minimal_mode" ):GetInt() == 1 and "true" or "false") .. "\n\nFlatHUD.Cfg.BlurMode = " .. (GetConVar( "flathud_blur" ):GetInt() == 1 and "true" or "false") .. "\n\nFlatHUD.Cfg.TeamColor = " .. (GetConVar( "flathud_role_color" ):GetInt() == 1 and "true" or "false") .. "\nFlatHUD.Cfg.CustomColor = Color(" .. GetConVar( "flatui_col_r" ):GetInt() .. ", " .. GetConVar( "flatui_col_g" ):GetInt() .. ", " .. GetConVar( "flatui_col_b" ):GetInt() .. ")\n\n-- 1 - Always Show, 2 - Show on TAB, 3 - Hide, 4 - Show when getting XP (LevelPanel ONLY!)\nFlatHUD.Cfg.LawsPanel = " .. GetConVar( "flathud_laws_mode" ):GetInt() .. "\nFlatHUD.Cfg.WantedList = " .. GetConVar( "flathud_wantedlist_mode" ):GetInt() .. "\nFlatHUD.Cfg.LevelPanel = " .. GetConVar( "flathud_level_mode" ):GetInt() .. "" )

			chat.AddText( Color( 255, 255, 255 ), FlatHUD.GetPhrase("clipboard_info"), Color( 255, 120, 0 ), "fh_config.lua", Color( 255, 255, 255 ), "!")
		end)

		CopySettings:Dock(BOTTOM)
		CopySettings:DockMargin(10, 10 * FlatHUD.Scale, 10, 12 * FlatHUD.Scale)
		CopySettings:SetTall(30 * FlatHUD.Scale)
	end
end

concommand.Add("flathud", function( ply )
	if !FlatHUD.Cfg.EditableForPlayers and !ply:IsSuperAdmin() then return end

	FlatHUD.ShowSettings()
end)