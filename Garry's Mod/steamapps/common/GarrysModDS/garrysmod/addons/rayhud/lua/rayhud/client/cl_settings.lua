-- RayHUD Owner: 76561198166995690
-- RayHUD Version: 1.1.3

function RayHUD.ShowSettings()
	local Main = FlatUI.MakePanel(550, 618, "RayHUD Settings" .. (!RayHUD.Cfg.EditableForPlayers and RayHUD.GetPhrase("preview") or ""))
	Main:DockPadding( 0, 42 * RayHUD.Scale, 0, 0 )

	local CloseBut = vgui.Create("DButton", Main)
	CloseBut:SetText( "" )
	CloseBut:SetSize(41 * RayHUD.Scale, 41 * RayHUD.Scale)
	CloseBut:SetPos((550 - 41) * RayHUD.Scale, 0)
	CloseBut:DockMargin(0, 0, 10 * RayHUD.Scale, 0)
	CloseBut.DoClick = function()
		Main:Remove()
	end
	CloseBut.Paint = function( self, w, h )
		surface.SetMaterial( FlatUI.Icons.Close )
		surface.SetDrawColor( FlatUI.Colors.White )
		surface.DrawTexturedRect(8 * RayHUD.Scale, 8 * RayHUD.Scale, 24 * RayHUD.Scale, 24 * RayHUD.Scale)
	end

	Main.OnRemove = function()
		for k, v in ipairs(RayHUD.FlatPanels) do
			v:Remove()
		end

		include("autorun/rayhud_autorun.lua")
	end

	local Scroll = vgui.Create("DScrollPanel", Main)
	Scroll:Dock(FILL)
	Scroll.Paint = function( self, w, h )
		draw.RoundedBox(6, 0, 0, w, h, Color(255, 255, 255, 0))
	end
	Scroll:CustomScrollBar()

	FlatUI.MakeSlider(Scroll, "rayhud_scale", RayHUD.GetPhrase("hud_scale"), 10, 30, 0)
	FlatUI.MakeSlider(Scroll, "rayhud_rounding", RayHUD.GetPhrase("hud_rounding"), 0, 20, 0)
	FlatUI.MakeSlider(Scroll, "rayhud_opacity", RayHUD.GetPhrase("hud_opacity"), 0, 255, 0)

	cvars.AddChangeCallback("rayhud_opacity", function(name, old, new)
		RayHUD.Opacity = tonumber(new)
	end)

	cvars.AddChangeCallback("rayhud_rounding", function(name, old, new)
		RayHUD.Rounding = tonumber(new)
	end)

	cvars.AddChangeCallback("rayhud_role_color", function(name, old, new)
		RayHUD.TeamCol = tonumber(new)

		print(RayHUD.TeamCol)
	end)

	cvars.AddChangeCallback("rayhud_blur", function(name, old, new)
		RayHUD.Blur = tonumber(new)
	end)

	cvars.AddChangeCallback("flatui_col_r", function(name, old, new)
		RayHUD.ColorR = tonumber(new)
	end)

	cvars.AddChangeCallback("flatui_col_g", function(name, old, new)
		RayHUD.ColorG = tonumber(new)
	end)

	cvars.AddChangeCallback("flatui_col_b", function(name, old, new)
		RayHUD.ColorB = tonumber(new)
	end)

	cvars.AddChangeCallback("rayhud_level_mode", function(name, old, new)
		RayHUD.LevelPanel = tonumber(new)
	end)


	FlatUI.MakeCheckbox(Scroll, "rayhud_crashscreen", RayHUD.GetPhrase("hud_crashscreen"))
	FlatUI.MakeCheckbox(Scroll, "rayhud_minimal_mode", RayHUD.GetPhrase("hud_minimal"))
	FlatUI.MakeCheckbox(Scroll, "rayhud_role_color", RayHUD.GetPhrase("hud_rolecolor"))
	FlatUI.MakeCheckbox(Scroll, "rayhud_blur", RayHUD.GetPhrase("hud_blur"))

	FlatUI.MakeColorPanel(Scroll, "flatui_col_r", "flatui_col_g", "flatui_col_b")

	if LevelSystemConfiguration then
		local LevelPanel = FlatUI.MakeComboBox(Scroll, RayHUD.GetPhrase("level_mode"))
		LevelPanel:AddChoice( "Always show", "rayhud_level_mode 1" )
		LevelPanel:AddChoice( "Show with TAB", "rayhud_level_mode 2" )
		LevelPanel:AddChoice( "Hide", "rayhud_level_mode 3" )
		LevelPanel:AddChoice( "Show when getting XP", "rayhud_level_mode 4" )
		LevelPanel:SetValue( LevelPanel:GetSelected() or (GetConVar( "rayhud_level_mode" ):GetInt() == 1 and "Always show" or GetConVar( "rayhud_level_mode" ):GetInt() == 2 and "Show with TAB" or GetConVar( "rayhud_level_mode" ):GetInt() == 3 and "Hide" or GetConVar( "rayhud_level_mode" ):GetInt() == 4 and "Show when getting XP") )
	end

	local LawsPanel = FlatUI.MakeComboBox(Scroll, RayHUD.GetPhrase("laws_mode"))
	LawsPanel:AddChoice( "Always show", "rayhud_laws_mode 1" )
	LawsPanel:AddChoice( "Show with TAB", "rayhud_laws_mode 2" )
	LawsPanel:AddChoice( "Hide", "rayhud_laws_mode 3" )
	LawsPanel:SetValue( LawsPanel:GetSelected() or (GetConVar( "rayhud_laws_mode" ):GetInt() == 1 and "Always show" or GetConVar( "rayhud_laws_mode" ):GetInt() == 2 and "Show with TAB" or GetConVar( "rayhud_laws_mode" ):GetInt() == 3 and "Hide") )

	local WantedPanel = FlatUI.MakeComboBox(Scroll, RayHUD.GetPhrase("wantedlist_mode"))
	WantedPanel:AddChoice( "Always show", "rayhud_wantedlist_mode 1" )
	WantedPanel:AddChoice( "Show with TAB", "rayhud_wantedlist_mode 2" )
	WantedPanel:AddChoice( "Hide", "rayhud_wantedlist_mode 3" )
	WantedPanel:SetValue( WantedPanel:GetSelected() or (GetConVar( "rayhud_wantedlist_mode" ):GetInt() == 1 and "Always show" or GetConVar( "rayhud_wantedlist_mode" ):GetInt() == 2 and "Show with TAB" or GetConVar( "rayhud_wantedlist_mode" ):GetInt() == 3 and "Hide") )

	local ResetButton = FlatUI.CreateFlatButton(Main, RayHUD.GetPhrase("reset_settings"), FlatUI.Colors.HP, FlatUI.Colors.LightHP, function()
		local Scale = GetConVar( "rayhud_scale" )
		local Rounding = GetConVar( "rayhud_rounding" )
		local Opacity = GetConVar( "rayhud_opacity" )

		local Crashscreen = GetConVar( "rayhud_crashscreen" )
		local MinimalMode = GetConVar( "rayhud_minimal_mode" )
		local RoleColor = GetConVar( "rayhud_role_color" )
		local BlurMode = GetConVar( "rayhud_blur" )

		local ColR = GetConVar( "flatui_col_r" )
		local ColG = GetConVar( "flatui_col_g" )
		local ColB = GetConVar( "flatui_col_b" )

		local LevelMode = GetConVar( "rayhud_level_mode" )
		local LawsMode = GetConVar( "rayhud_laws_mode" )
		local WantedList = GetConVar( "rayhud_wantedlist_mode" )

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
	ResetButton:DockMargin(10, 0, 10, 12 * RayHUD.Scale)
	ResetButton:SetTall(30 * RayHUD.Scale)

	if LocalPlayer():IsSuperAdmin() then
		local CopySettings = FlatUI.CreateFlatButton(Main, RayHUD.GetPhrase("copy_settings"), FlatUI.Colors.Armor, FlatUI.Colors.LightArmor, function()
			SetClipboardText( "RayHUD.Cfg.Scale = " .. GetConVar( "rayhud_scale" ):GetInt() .. " 	-- value: 10 - 30\nRayHUD.Cfg.Rounding = " .. GetConVar( "rayhud_rounding" ):GetInt() .. "	-- value: 0 - 20\nRayHUD.Cfg.Opacity = " .. GetConVar( "rayhud_opacity" ):GetInt() .. "   -- value: 0 - 255\n\nRayHUD.Cfg.CrashScreen = " .. (GetConVar( "rayhud_crashscreen" ):GetInt() == 1 and "true" or "false") .. "\nRayHUD.Cfg.MiniMode = " .. (GetConVar( "rayhud_minimal_mode" ):GetInt() == 1 and "true" or "false") .. "\n\nRayHUD.Cfg.BlurMode = " .. (GetConVar( "rayhud_blur" ):GetInt() == 1 and "true" or "false") .. "\n\nRayHUD.Cfg.TeamColor = " .. (GetConVar( "rayhud_role_color" ):GetInt() == 1 and "true" or "false") .. "\nRayHUD.Cfg.CustomColor = Color(" .. GetConVar( "flatui_col_r" ):GetInt() .. ", " .. GetConVar( "flatui_col_g" ):GetInt() .. ", " .. GetConVar( "flatui_col_b" ):GetInt() .. ")\n\n-- 1 - Always Show, 2 - Show on TAB, 3 - Hide, 4 - Show when getting XP (LevelPanel ONLY!)\nRayHUD.Cfg.LawsPanel = " .. GetConVar( "rayhud_laws_mode" ):GetInt() .. "\nRayHUD.Cfg.WantedList = " .. GetConVar( "rayhud_wantedlist_mode" ):GetInt() .. "\nRayHUD.Cfg.LevelPanel = " .. GetConVar( "rayhud_level_mode" ):GetInt() .. "" )

			chat.AddText( Color( 255, 255, 255 ), RayHUD.GetPhrase("clipboard_info"), Color( 255, 120, 0 ), "rh_config.lua", Color( 255, 255, 255 ), "!")
		end)

		CopySettings:Dock(BOTTOM)
		CopySettings:DockMargin(10, 10 * RayHUD.Scale, 10, 12 * RayHUD.Scale)
		CopySettings:SetTall(30 * RayHUD.Scale)
	end
end

concommand.Add("rayhud", function( ply )
	if !RayHUD.Cfg.EditableForPlayers and !ply:IsSuperAdmin() then return end

	RayHUD.ShowSettings()
end)