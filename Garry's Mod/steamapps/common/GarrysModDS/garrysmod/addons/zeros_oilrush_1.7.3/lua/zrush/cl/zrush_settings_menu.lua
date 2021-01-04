if (not CLIENT) then return end
local Created = false


local function zrush_OptionPanel(name, CPanel, cmds)
	local panel = vgui.Create("DPanel")
	panel:SetSize(250 , 40 + (35 * table.Count(cmds)))
	panel.Paint = function(s, w, h)
		draw.RoundedBox(4, 0, 0, w, h, zrush.default_colors["grey07"])
	end

	local title = vgui.Create("DLabel", panel)
	title:SetPos(10, 2.5)
	title:SetText(name)
	title:SetFont("zrush_settings_font01")
	title:SetSize(panel:GetWide(), 30)
	title:SetTextColor(zrush.default_colors["red05"])

	for k, v in pairs(cmds) do
		if v.class == "DNumSlider" then

			local item = vgui.Create("DNumSlider", panel)
			item:SetPos(10, 35 * k)
			item:SetSize(panel:GetWide(), 30)
			item:SetText(v.name)
			item:SetMin(v.min)
			item:SetMax(v.max)
			item:SetDecimals(v.decimal)
			item:SetDefaultValue(math.Clamp(math.Round(GetConVar(v.cmd):GetFloat(),v.decimal),v.min,v.max))
			item:ResetToDefaultValue()

			item.OnValueChanged = function(self, val)

				if (not Created) then
					RunConsoleCommand(v.cmd, tostring(val))
				end
			end

			timer.Simple(0.1, function()
				if (item) then
					item:SetValue(math.Clamp(math.Round(GetConVar(v.cmd):GetFloat(),v.decimal),v.min,v.max))
				end
			end)
		elseif v.class == "DCheckBoxLabel" then

			local item = vgui.Create("DCheckBoxLabel", panel)
			item:SetPos(10, 35 * k)
			item:SetSize(panel:GetWide(), 30)
			item:SetText( v.name )
			item:SetConVar( v.cmd )
			item:SetValue(0)
			item.OnChange = function(self, val)

				if (not Created) then
					if ((val and 1 or 0) == cvars.Number(v.cmd)) then return end
					RunConsoleCommand(v.cmd, tostring(val))
				end
			end

			timer.Simple(0.1, function()
				if (item) then
					item:SetValue(GetConVar(v.cmd):GetInt())
				end
			end)
		elseif v.class == "DButton" then
			local item = vgui.Create("DButton", panel)
			item:SetPos(10, 35 * k)
			item:SetSize(panel:GetWide(), 30)
			item:SetText( "" )
			item.Paint = function(s, w, h)
				draw.RoundedBox(5, 0, 0, w, h, zrush.default_colors["grey02"])
				draw.SimpleText(v.name, "zrush_settings_font02", w / 2, h / 2, zrush.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

				if s.Hovered then
					draw.RoundedBox(5, 0, 0, w, h, zrush.default_colors["white05"])
				end
			end
			item.DoClick = function()

				if zrush.f.IsAdmin(LocalPlayer()) == false then return end

				LocalPlayer():EmitSound("zrush_ui_click")

				if v.notify then

					notification.AddLegacy(  v.notify, NOTIFY_GENERIC, 2 )
				end
				LocalPlayer():ConCommand( v.cmd )
			end
		end
	end

	CPanel:AddPanel(panel)
end


local function oilrushssettings(CPanel)
	Created = true
	zrush_OptionPanel("VFX",CPanel,{
		[1] = {name = "Render Distance",class = "DNumSlider", cmd = "zrush_cl_vfx_updatedistance",min = 100,max = 10000,decimal = 0},
	})
	timer.Simple(0.1, function()

		Created = false
	end)
end

local function admin_oilrushssettings(CPanel)
	zrush_OptionPanel("NPC / OilSpots",CPanel,{
		[1] = {name = "Save",class = "DButton", cmd = "zrush_publicents_save"},
		[2] = {name = "Remove",class = "DButton", cmd = "zrush_publicents_remove"},
	})

	zrush_OptionPanel("Commands",CPanel,{
		[1] = {name = "Random Fuel Barrel",class = "DButton", cmd = "zrush_debug_spawn_fuel"},
		[2] = {name = "Oil Barrel",class = "DButton", cmd = "zrush_debug_spawn_oil"},
	})

end

hook.Add( "AddToolMenuCategories", "a.zrush.AddToolMenuCategories", function()
	spawnmenu.AddToolCategory( "Options", "OilRush", "OilRush" );
end )

hook.Add( "PopulateToolMenu", "a.zrush.PopulateToolMenu", function()
	spawnmenu.AddToolMenuOption( "Options", "OilRush", "zrushSettings", "Client Settings", "", "", oilrushssettings )
	spawnmenu.AddToolMenuOption("Options", "OilRush", "zrush_Admin_Settings", "Admin Settings", "", "", admin_oilrushssettings)
end )
