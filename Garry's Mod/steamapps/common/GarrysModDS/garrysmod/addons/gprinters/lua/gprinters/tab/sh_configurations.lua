// Configurations Tab

gPrinters.tabs[ 1 ] = { loadPanels = function( parent )
	local selected = "General"
	local scrollPanel = vgui.Create( "gPrinters.Parent", parent )
	scrollPanel:SetSize( parent:GetWide(), parent:GetTall() )

	local panel = vgui.Create( "DPanel", scrollPanel )
	panel:SetSize( scrollPanel:GetWide(), scrollPanel:GetTall() )
	panel:SetPos( 0, 0 )
	panel.Paint = function( slf, w, h )

	end

	local scroll = vgui.Create( "DScrollPanel", panel )
	scroll:SetSize( scrollPanel:GetWide() - 7, 420 )
	scroll:SetPos( 0, 70 )
	scroll.Paint = function()
	end
	scroll:scrollPanel()

	scroll.settingPanels = {}
	scroll.List = function()
		local i = 0
		for setting, value in pairs( gPrinters.plugins[ selected ] ) do
			local settings = ""
			if gPrinters.lang[ selected ] then
				settings = gPrinters.lang[ selected ][ setting ] or setting
			end

			local settingName = vgui.Create( "DLabel", scroll )
			settingName:SetFont( "font20" )
			settingName:SetText( "" )
			settingName:SetSize( scroll:GetWide(), 40 )
			settingName:SetPos( 10, i * 35 )
			settingName.Paint = function( slf, w, h )
				gPrinters.drawText( 0, settings, 17, 10, 15, Color( 163, 163, 163, 150 ), TEXT_ALIGN_LEFT, 1 )
				gPrinters.drawBox( 0, 0, 0, w, 30, Color( 5, 5, 5, 100 ) )
			end

			if isbool( value ) then
				local valueMod = vgui.Create( "gprinters_switch_original", scroll )
				valueMod:SetPos( scroll:GetWide() - 60, 0 + i * 35 + 7.5 )
				valueMod.enabled = value
				valueMod.onOptionChanged = function()
					net.Start( "gPrinters.changeSetting" )
						net.WriteTable( { plugin = selected, setting = setting, value = valueMod.enabled } )
					net.SendToServer()
				end
				table.insert( scroll.settingPanels, valueMod )

			elseif isstring( value ) then
				local valueMod = vgui.Create( "gprinters_textinput", scroll )
				valueMod:SetPos( scroll:GetWide() - 360, -2 + i * 35 + 7.5 )
				valueMod:SetValue( value )
				valueMod:SetNumeric( false )
				valueMod.OnEnter = function()
					net.Start( "gPrinters.changeSetting" )
						net.WriteTable( { plugin = selected, setting = setting, value = valueMod:GetValue() } )
					net.SendToServer()
				end
				table.insert( scroll.settingPanels, valueMod )

			elseif isnumber( value ) && ( ( setting == "morePrint" ) or ( setting == "powerUpgrade" ) ) then
				local valueMod = vgui.Create( "gprinters_wang", scroll )
				valueMod:SetPos( scroll:GetWide() - 80, -2 + i * 35 + 7.5 )
				valueMod:SetValue( value )
				valueMod.OnValueChanged = function()
					net.Start( "gPrinters.changeSetting" )
						net.WriteTable( { plugin = selected, setting = setting, value = valueMod:GetValue() } )
					net.SendToServer()
				end
				table.insert( scroll.settingPanels, valueMod )

			elseif isnumber( value ) && ( ( setting != "morePrint" ) or ( setting != "powerUpgrade" ) ) then
				local valueMod = vgui.Create( "gprinters_textinput", scroll )
				valueMod:SetPos( scroll:GetWide() - 150, -2 + i * 35 + 7.5 )
				valueMod:SetSize( 130, 20 )
				valueMod:SetValue( value )
				valueMod:SetNumeric( true )
				valueMod.OnEnter = function()
					if tonumber( valueMod:GetValue() ) < 0 then
						valueMod:SetValue( -valueMod:GetValue() )
					end

					net.Start( "gPrinters.changeSetting" )
						net.WriteTable( { plugin = selected, setting = setting, value = tonumber( valueMod:GetValue() ) } )
					net.SendToServer()
				end
				table.insert( scroll.settingPanels, valueMod )
			end
			i = i + 1
		end
	end
	scroll.List()
end	}