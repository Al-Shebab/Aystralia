if SERVER then
	util.AddNetworkString( "gPrinters.modifyPrinters" )
	net.Receive( "gPrinters.modifyPrinters", function( len, ply )
		if !ply:IsSuperAdmin() then return end
		local printer = net.ReadTable()

		for k, v in pairs( printer or {} ) do
			gPrinters.removePrinter( k )
			gPrinters.registerPrinter( "Printers", printer )
		end
	end )
end

if CLIENT then
	function gPrinters.notifyModification( msg, parent, r, g, b, img, color )
		local note = vgui.Create( "DPanel", parent )
		note:SetSize( 320, 15 )
		note:SetAlpha( 0 )
		note:AlphaTo( 255, 1, 0 )
		note:SetPos( 574, 98 )

		note.Paint = function( slf, w, h )
			gPrinters.drawBox( 0, 0, 0, w, h, Color( 5, 5, 5, 150 ) )
			gPrinters.drawText( 0, msg, 14, w / 2, h / 2, Color( r, g, b, 125 ), 1, 1 )
		end

		timer.Simple( 1, function()
			if IsValid( note ) then
				note:AlphaTo( 0, 1, 0, function() if note && note:IsValid() then note:Remove() end end )
			end
		end )
	end
end

gPrinters.tabs[ 4 ] = { loadPanels = function( parent )
	local editing = ""
	local scrollPanel = vgui.Create( "gPrinters.Parent", parent )
	scrollPanel:SetSize( parent:GetWide(), parent:GetTall() )

	local panel = vgui.Create( "DPanel", scrollPanel )

	panel:SetSize( scrollPanel:GetWide(), scrollPanel:GetTall() )
	panel:SetPos( 0, 0 )
	panel.Paint = function()
	end

	scrollPanel.Paint = function( slf, w, h )
		gPrinters.drawBox( 0, 7, 60, w - 14, 35, Color( 5, 5, 5, 100 ) )
		gPrinters.drawText( 0, "In order to continue select the printer you want to edit.", 16, scrollPanel:GetWide() / 2, 77, Color( 163, 163, 163, 150 ), 1 )
		gPrinters.drawPicture( 20, 60, 32, 32, "materials/f1menu/information.png", Color( 0, 163, 163, 200 ) )

		if ( string.len( editing ) >= 1 ) then
			gPrinters.drawBox( 0, 240, 115, 652, 1, Color( 57, 64, 77, 255 ) )
			gPrinters.drawBox( 0, 892, 115, 1, 375, Color( 57, 64, 77, 255 ) )
			gPrinters.drawBox( 0, 7, 489, 885, 1, Color( 57, 64, 77, 255 ) )
			gPrinters.drawBox( 0, 7, 140, 1, 350, Color( 57, 64, 77, 255 ) )

			gPrinters.drawText( 0, "Groups Setup", 16, 560, 140, Color( 255, 163, 0, 150 ), 0 )
			gPrinters.drawText( 0, "General Information", 16, 15, 140, Color( 255, 163, 0, 150 ), 0 )
			gPrinters.drawBox( 0, 645, 140, 240, 1, Color( 57, 64, 77, 255 ) )

			gPrinters.drawBox( 0, 135, 140, 400, 1, Color( 57, 64, 77, 255 ) )
			gPrinters.drawBox( 0, 535, 140, 1, 345, Color( 57, 64, 77, 255 ) )
			gPrinters.drawBox( 0, 550, 140, 1, 190, Color( 57, 64, 77, 255 ) )
			gPrinters.drawBox( 0, 550, 330, 342, 1, Color( 57, 64, 77, 255 ) )

			gPrinters.drawText( 0, "Sort Order", 17, 560, 340, Color( 255, 163, 0, 100 ), 0 )
			gPrinters.drawText( 0, "Donation System", 17, 735, 340, Color( 255, 163, 0, 100 ), 0 )
			gPrinters.drawText( 0, "Lower number means higher up.", 14, 560, 355, Color( 163, 163, 163, 100 ), 0 )
			gPrinters.drawText( 0, "Custom Donation System", 14, 735, 355, Color( 163, 163, 163, 100 ), 0 )

			gPrinters.drawBox( 0, 550, 340, 1, 50, Color( 57, 64, 77, 255 ) )
			gPrinters.drawBox( 0, 550, 390, 342, 1, Color( 57, 64, 77, 255 ) )
			gPrinters.drawBox( 0, 650, 340, 75, 1, Color( 57, 64, 77, 255 ) )
			gPrinters.drawBox( 0, 725, 340, 1, 50, Color( 57, 64, 77, 255 ) )
			gPrinters.drawBox( 0, 727, 340, 1, 50, Color( 57, 64, 77, 255 ) )
			gPrinters.drawBox( 0, 840, 340, 50, 1, Color( 57, 64, 77, 255 ) )

			gPrinters.drawText( 0, "Secondary Usergroups", 17, 560, 400, Color( 255, 163, 0, 100 ), 0 )
			gPrinters.drawBox( 0, 550, 405, 1, 50, Color( 57, 64, 77, 255 ) )
			gPrinters.drawBox( 0, 550, 455, 342, 1, Color( 57, 64, 77, 255 ) )
			gPrinters.drawBox( 0, 700, 400, 190, 1, Color( 57, 64, 77, 255 ) )
			gPrinters.drawBox( 0, 550, 390, 342, 1, Color( 57, 64, 77, 255 ) )
			//Information to edit
			gPrinters.drawText( 0, "Printer Color", 15, 20, 160, Color( 127, 127, 127, 255 ), 0 )
			gPrinters.drawText( 0, "Printer Print Delay", 15, 20, 200, Color( 127, 127, 127, 255 ), 0 )
			gPrinters.drawText( 0, "Printer Sound", 15, 20, 240, Color( 127, 127, 127, 255 ), 0 )

			gPrinters.drawText( 0, "Printer Max Amount", 15, 20, 280, Color( 127, 127, 127, 255 ), 0 )
			gPrinters.drawText( 0, "Printer Vrondakis Lvl	", 15, 135, 280, Color( 127, 127, 127, 255 ), 0 )


			gPrinters.drawText( 0, "Printer Price", 15, 20, 320, Color( 127, 127, 127, 255 ), 0 )

			gPrinters.drawText( 0, "Printer Overheat?", 15, 20, 360, Color( 127, 127, 127, 255 ), 0 )

			gPrinters.drawText( 0, "Printer Health", 15, 20, 400, Color( 127, 127, 127, 255 ), 0 )

			gPrinters.drawText( 0, "Printer Max-Hold", 15, 137, 400, Color( 127, 127, 127, 255 ), 0 )

			gPrinters.drawText( 0, "Remove by Cops?", 15, 300, 160, Color( 127, 127, 127, 255 ), 0 )
			gPrinters.drawText( 0, "Printer Overheat Chance ( 0 - 100 )", 15, 300, 200, Color( 127, 127, 127, 255 ), 0 )
			gPrinters.drawText( 0, "Printer Print Amount ( Per Cycle )", 15, 300, 240, Color( 127, 127, 127, 255 ), 0 )
			gPrinters.drawText( 0, "Printer Allow Attachments?", 15, 300, 280, Color( 127, 127, 127, 255 ), 0 )
			gPrinters.drawText( 0, "Printer Cops Remove Reward", 15, 300, 320, Color( 127, 127, 127, 255 ), 0 )
			gPrinters.drawText( 0, "Printer Category", 15, 300, 360, Color( 127, 127, 127, 255 ), 0 )
			gPrinters.drawText( 0, "Printer Jobs", 15, 300, 400, Color( 127, 127, 127, 255 ), 0 )
			gPrinters.drawBox( 0, 15, 440, 510, 35, Color( 5, 5, 5, 100 ) )
			gPrinters.drawPicture( 20, 440, 32, 32, "materials/f1menu/information.png", Color( 255, 163, 0, 200 ) )
			gPrinters.drawText( 0, "After modifying your printer, click the save button to store your modifications.", 16, 60, 457, Color( 163, 163, 163, 150 ), 0 )
			if SG == nil then
				gPrinters.drawText( 0, "This feature is only enabled while you use Secondary Groups", 15, 560, 430, Color( 127, 127, 127, 255 ), 0 )
			end
		else
			local y = 60
			gPrinters.drawBox( 0, 7, 170 + y, 885, 1, Color( 57, 64, 77, 255 ) )
			gPrinters.drawBox( 0, 27, 180 + y, 845, 1, Color( 57, 64, 77, 255 ) )
			gPrinters.drawText( 0, "Please select a printer in order to continue this process.", 16, slf:GetWide() / 2, 195 + y, Color( 163, 163, 163, 150 ), 1 )
			gPrinters.drawText( 0, "Changes will only take effect after restarting your server.", 16, slf:GetWide() / 2, 210 + y, Color( 255, 163, 0, 150 ), 1 )
			gPrinters.drawBox( 0, 27, 230 + y, 845, 1, Color( 57, 64, 77, 255 ) )
			gPrinters.drawBox( 0, 7, 240 + y, 885, 1, Color( 57, 64, 77, 255 ) )

		end
	end


	local infoFrame = vgui.Create( "DPanel", panel )
	infoFrame:SetSize( scrollPanel:GetWide(), scrollPanel:GetTall() )
	infoFrame.Paint = function()
	end

	local printers = vgui.Create( "gprinter_editmenu", panel )
	printers:SetPos( 7, 100 )
	printers:SetSize( 225, 30 )
	printers:SetText( "Choose Printer" )
	for _, printer in pairs( gPrinters.printers or {} ) do
		for k, v in pairs( gPrinters.printers[ "Printers" ][ printer ] or printer ) do
			printers:AddChoice( v.name )
		end
	end

	printers.OnSelect = function()
		if ( #infoFrame:GetChildren()  >= 1 ) then
			for _, pan in pairs ( infoFrame:GetChildren() ) do
				if IsValid( pan ) then
					pan:Remove()
				end
			end
		end

		if grptb then
			table.Empty( grptb )
		end

		editing = printers:GetValue()
		for _, printer in pairs( gPrinters.printers or {} ) do
	    	for k, v in pairs( gPrinters.printers[ "Printers" ][ printer ] or printer ) do
	    		if v.name == printers:GetValue() then
	    			local pjobs = vgui.Create( "gprinter_jobs", infoFrame )
					pjobs:SetPos( 300, 410 )
					pjobs:SetSize( 225, 20 )
					pjobs.jobs = v.jobs or {}

	    			local sortorder = vgui.Create( "gprinters_textinput", infoFrame )
					sortorder:SetPos( 560, 365 )
					sortorder:SetSize( 160, 20 )
					sortorder:SetValue( v.sortOrder or 0 )
					sortorder:SetNumeric( true )
					sortorder.OnEnter = function()
					end

	    			local donationgroup = vgui.Create( "gprinters_textinput", infoFrame )
					donationgroup:SetPos( 735, 365 )
					donationgroup:SetSize( 150, 20 )
					donationgroup:SetValue( v.donationrank or 0 )
					donationgroup:SetNumeric( true )
					donationgroup.OnEnter = function()
					end

					local psound = vgui.Create( "gprinter_comboinput", infoFrame )
					psound:SetPos( 20, 250 )
					psound:SetSize( 225, 20 )
					psound:SetValue( v.sound )

					local phealth = vgui.Create( "gprinters_textinput", infoFrame )
					phealth:SetPos( 20, 410 )
					phealth:SetSize( 110, 20 )
					phealth:SetValue( v.health )
					phealth:SetNumeric( true )
					phealth.OnEnter = function()
					end

					local phold = vgui.Create( "gprinters_textinput", infoFrame )
					phold:SetPos( 135, 410 )
					phold:SetSize( 110, 20 )
					phold:SetValue( v.pmaxamount )
					phold:SetNumeric( true )
					phold.OnEnter = function()
					end

					local f4price = vgui.Create( "gprinters_textinput", infoFrame )
					f4price:SetPos( 20, 330 )
					f4price:SetSize( 225, 20 )
					f4price:SetValue( v.f4price )

					local pcolor = vgui.Create( "gprinter_vector", infoFrame )
					pcolor:SetPos( 20, 170 )
					pcolor:SetSize( 225, 20 )
					pcolor.valor = Vector( v.color.r, v.color.g, v.color.b )

					local f4amount = vgui.Create( "gprinters_textinput", infoFrame )
					f4amount:SetPos( 20, 290 )
					f4amount:SetSize( 110, 20 )
					f4amount:SetValue( v.f4amount )

					local plevel = vgui.Create( "gprinters_textinput", infoFrame )
					plevel:SetPos( 135, 290 )
					plevel:SetSize( 110, 20 )
					plevel:SetValue( v.plevel )

					local poverh = vgui.Create( "gprinters_switch", infoFrame )
					poverh:SetPos( 20, 370 )
					poverh.enabled = v.poverh

					local cpremove = vgui.Create( "gprinters_switch", infoFrame )
					cpremove:SetPos( 300, 170 )
					cpremove.enabled = v.cpremove

					local attachments = vgui.Create( "gprinters_switch", infoFrame )
					attachments:SetPos( 300, 290 )
					attachments.enabled = v.attachment

					local pamount = vgui.Create( "gprinters_textinput", infoFrame )
					pamount:SetPos( 300, 250 )
					pamount:SetSize( 110, 20 )
					pamount:SetValue( v.pamount )
					pamount:SetNumeric( true )
					pamount.OnEnter = function()
					end

					local ptime = vgui.Create( "gprinters_textinput", infoFrame )
					ptime:SetPos( 20, 210 )
					ptime:SetSize( 225, 20 )
					ptime:SetValue( v.ptime )
					ptime:SetNumeric( true )
					ptime.OnEnter = function()
					end

					local remrew = vgui.Create( "gprinters_textinput", infoFrame )
					remrew:SetPos( 300, 330 )
					remrew:SetSize( 225, 20 )
					remrew:SetValue( v.remrew )
					remrew:SetNumeric( true )
					remrew.OnEnter = function()
					end

					local ochance = vgui.Create( "gprinters_wang_2", infoFrame )
					ochance:SetPos( 300, 210 )
					ochance:SetSize( 225, 20 )
					ochance:SetValue( v.ochance )
					ochance:SetNumeric( true )

					local category = vgui.Create( "gprinter_category", infoFrame )
					category:SetPos( 300, 370 )
					category:SetSize( 225, 20 )
					category:SetValue( v.category )

				    local secondary_group = {}
					local sgroup = vgui.Create( "DPanelList", infoFrame )
					sgroup:SetPos( 560, 410 )
					sgroup:SetSize( 330, 40 )
					sgroup:SetSpacing( 1 )
					sgroup:SetPadding( 1 )
				    sgroup:EnableVerticalScrollbar( true )
				    sgroup:EnableHorizontal( true )
				    sgroup:hideBar()

				    if SG && SG.Data.CurrentGroups then
					    for _, group in ipairs( SG.Data.CurrentGroups ) do
					    	local grp = vgui.Create( "DButton", panel )
							grp:SetSize( 160, 20 )
							grp:SetText( "" )
							grp.Paint = function( slf, w, h )
								gPrinters.drawBox( 0, 0, 0, slf:GetWide(), slf:GetTall(), Color( 0, 0, 0, 100 ) )
					        	gPrinters.drawText( 0, group, 16, slf:GetWide() / 2, slf:GetTall() / 2, Color( 163, 163, 163, 175 ), 1 )
							end

							local grpcheck = vgui.Create( "DCheckBox", grp )
					        grpcheck:SetSize( 16, 16 )
					        grpcheck:SetPos( 2, 2 )

					        if v.secondary_group && table.HasValue( v.secondary_group, group ) then
								table.insert( secondary_group, group )
								grpcheck:SetChecked( true )
							end

							grp.DoClick = function()
					            if !grpcheck:GetChecked() then
					                table.insert( secondary_group, group )
					                grpcheck:SetChecked( true )
					            else
					                table.RemoveByValue( secondary_group, group )
					                grpcheck:SetChecked( false )
					            end
					        end

					     	grpcheck.Paint = function( slf, w, h )
					            if slf:GetChecked() then
					                gPrinters.drawBox( 0, 0, 0, w, h, Color( 5, 5, 5, 100 ) )
					                gPrinters.drawBox( 0, 2, 2, w - 4, h - 4, Color( 50, 150, 50, 100 ) )
					            else
					                gPrinters.drawBox( 0, 0, 0, w, h, Color( 5, 5, 5, 100 ) )
					            end
					        end

					        grpcheck.DoClick = function()
					        	if !grpcheck:GetChecked() then
					                table.insert( secondary_group, group )
					                grpcheck:SetChecked( true )
					            else
					                table.RemoveByValue( secondary_group, group )
					                grpcheck:SetChecked( false )
					            end
					        end

					        sgroup:AddItem( grp )
						end
					end

					gPrinters.adminModes[ gPrinters.plugins[ "Other" ].adminSystem ].editFunction( infoFrame, v.ranks );

					local accept = vgui.Create( "DButton", infoFrame )
					accept:SetPos( 560, 465 )
					accept:SetSize( 320, 20 )
					accept:SetText( "" )

					accept.Paint = function( slf, w, h )
						if slf:IsHovered() then
							gPrinters.drawBox( 0, 0, 0, w, h, Color( 5, 5, 5, 150 ) )
						else
							gPrinters.drawBox( 0, 0, 0, w, h, Color( 5, 5, 5, 100 ) )
						end
						gPrinters.drawText( 0, "Save Modifications", 15, w / 2, h / 2, Color( 163, 163, 163, 100 ), 1 )
					end

					accept.DoClick = function( slf )
						if CurTime() < ( slf.cooldown or 0 ) then return end

						print( "Your current table has this values" )
						print( "=============================================")
						PrintTable( gPrinters.adminModes[ gPrinters.plugins[ "Other" ].adminSystem ].rankTable() )
						print( "=============================================")

						printer = {
								[ "gPrinters." .. v.name ] = {
								uid = "gPrinters." .. v.name,
								name = v.name,
								cmd = string.lower( "g" .. string.Replace( v.name, " ", "_" ) ),
								color = pcolor.valor,
								sound = psound:GetValue(),
								health = phealth:GetValue(),
								model = "models/gprinter/gprinter_base.mdl",
								pamount = pamount:GetValue(),
								ptime = ptime:GetValue(),
								ochance = ochance:GetValue(),
								poverh = poverh.enabled,
								cpremove = cpremove.enabled,
								remrew = remrew:GetValue(),
								f4price = f4price:GetValue(),
								f4amount = f4amount:GetValue(),
								attachment = attachments.enabled,
								ranks = gPrinters.adminModes[ gPrinters.plugins[ "Other" ].adminSystem ].rankTable(),
								category = category:GetValue(),
								rank = table.Count( gPrinters.adminModes[ gPrinters.plugins[ "Other" ].adminSystem ].rankTable() ),
								sortOrder = sortorder:GetValue(),
								jobs = pjobs.jobs,
								job = table.Count( pjobs.jobs ),
								pmaxamount = tonumber( phold:GetValue() ),
								plevel = plevel:GetValue(),
								donationrank = donationgroup:GetValue(),
								secondary_group = secondary_group or {}
							}
						}

						if gPrinters.checknBlank( printer, "gPrinters." .. v.name ) then
							gPrinters.notifyModification( "Please complete the form", scrollPanel, 150, 50, 50, "materials/f1menu/prohibited.png", Color( 255, 50, 50, 200 ) )
							slf.cooldown = CurTime() + 3
							return
						end

						if !LocalPlayer():IsSuperAdmin() then
							gPrinters.notifyModification( "You're not Super Admin", scrollPanel, 150, 50, 50, "materials/f1menu/prohibited.png", Color( 255, 50, 50, 200 ) )
							slf.cooldown = CurTime() + 3
							return
						end

						gPrinters.notifyModification( "Printer Modified", scrollPanel, 0, 255, 163, "materials/f1menu/tick.png", Color( 0, 255, 163, 200 ) )

						net.Start( "gPrinters.modifyPrinters" )
							net.WriteTable( printer )
						net.SendToServer()
						slf.cooldown = CurTime() + 3
						return
					end

					function gPrinters.checknBlank( printer, uid )
						if printer[ uid ].name == "" or printer[ uid ].color == "" or printer[ uid ].sound == "Choose your sound" or
							printer[ uid ].category == "Select Category" or printer[ uid ].attachment == "" or printer[ uid ].plevel == ""
							or printer[ uid ].pamount == "" or printer[ uid ].ptime == ""
							or printer[ uid ].ochhance == "" or printer[ uid ].poverh == "" or printer[ uid ].cpremove == ""
							or printer[ uid ].remrew == "" or printer[ uid ].f4price == "" or printer[ uid ].f4amount == "" or printer[ uid ].sortOrder == ""  then
							return true
						end
						return false
					end
				end
			end
		end
	end
end }