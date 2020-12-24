if CLIENT then
	function gPrinters.checkDatabase( table )
		for k, v in pairs( table or {} ) do
			for key, value in pairs( gPrinters.printers or {} ) do
				for k3, v3 in pairs( gPrinters.printers[ "Printers" ][ value ] or value ) do
					if ( v.cmd == v3.cmd ) then
						return true
					end
				end
			end
		end
		return false
	end

	function gPrinters.notifyCreation( msg, parent, r, g, b, img, color )
		local note = vgui.Create( "DPanel", parent )
		note:SetSize( 320, 30 )
		note:SetAlpha( 0 )
		note:AlphaTo( 255, 1, 0 )
		note:SetPos( 620, parent:GetTall() - 75 )

		note.Paint = function( slf, w, h )
			gPrinters.drawText( 0, msg, 14, w / 2, h / 2, Color( r, g, b, 125 ), 1, 1 )
		end

		timer.Simple( 1, function()
			if IsValid( note ) then
				note:AlphaTo( 0, 1, 0, function() if note && note:IsValid() then note:Remove() end end )
			end
		end )
	end
end

if SERVER then
	util.AddNetworkString( "gPrinters.rrnow" )
	net.Receive( "gPrinters.rrnow", function( len, ply )
		if !ply:IsSuperAdmin() then return end
		game.ConsoleCommand( "changelevel " .. game.GetMap() .. "\n" )
	end )

	util.AddNetworkString( "gPrinters.registerPrinters" )
	net.Receive( "gPrinters.registerPrinters", function( len, ply )
		if !ply:IsSuperAdmin() then return end
		local printer = net.ReadTable()

		for k, v in pairs( printer or {} ) do
			for key, value in pairs( gPrinters.printers or {} ) do
				for k3, v3 in pairs( gPrinters.printers[ "Printers" ][ value ] or value ) do
					if ( v.cmd == v3.cmd ) then
						ply:ChatPrint( "Printer already exist in our database" )
						return
					end
				end
			end
		end

		for k, v in pairs( printer or {} ) do
			gPrinters.registerPrinter( "Printers", printer )
		end
	end )
end

gPrinters.tabs[ 3 ] = { loadPanels = function( parent )
	local scrollPanel = vgui.Create( "gPrinters.Parent", parent )
	scrollPanel:SetSize( parent:GetWide(), parent:GetTall() )

	local panel = vgui.Create( "DPanel", scrollPanel )
	panel:SetSize( scrollPanel:GetWide(), scrollPanel:GetTall() )
	panel:SetPos( 0, 0 )
	panel.Paint = function( slf, w, h )
	end

	scrollPanel.PaintOver = function( slf, w, h )

		gPrinters.drawText( 0, "General Information", 17, 20, 80, Color( 255, 163, 0, 100 ), 0 )
		gPrinters.drawText( 0, "Printer Name", 15, 20, 100, Color( 127, 127, 127, 255 ), 0 )
		gPrinters.drawText( 0, "Printer Color", 15, 20, 140, Color( 127, 127, 127, 255 ), 0 )
		gPrinters.drawText( 0, "Printer Print Delay", 15, 20, 180, Color( 127, 127, 127, 255 ), 0 )
		gPrinters.drawText( 0, "Printer Sound", 15, 20, 220, Color( 127, 127, 127, 255 ), 0 )
		gPrinters.drawBox( 0, 150, 82, 100, 1, Color( 57, 64, 77, 255 ) )
		gPrinters.drawBox( 0, 250, 82, 1, 180, Color( 57, 64, 77, 255 ) )
		gPrinters.drawBox( 0, 10, 82, 1, 180, Color( 57, 64, 77, 255 ) )
		gPrinters.drawBox( 0, 10, 261, 240, 1, Color( 57, 64, 77, 255 ) )


		gPrinters.drawText( 0, "F4 Menu Information", 17, 300, 80, Color( 255, 163, 0, 100 ), 0 )

		gPrinters.drawText( 0, "Printer Max Amount", 15, 300, 100, Color( 127, 127, 127, 255 ), 0 )

		gPrinters.drawText( 0, "Printer Lv Req", 15, 417, 100, Color( 127, 127, 127, 255 ), 0 )
		gPrinters.drawText( 0, "Printer Price", 15, 300, 140, Color( 127, 127, 127, 255 ), 0 )

		gPrinters.drawText( 0, "Printer Overheat?", 15, 300, 180, Color( 127, 127, 127, 255 ), 0 )
		gPrinters.drawText( 0, "Remove by Cops?", 15, 300, 220, Color( 127, 127, 127, 255 ), 0 )

		gPrinters.drawBox( 0, 290, 82, 1, 180, Color( 57, 64, 77, 255 ) )
		gPrinters.drawBox( 0, 430, 82, 100, 1, Color( 57, 64, 77, 255 ) )
		gPrinters.drawBox( 0, 530, 82, 1, 180, Color( 57, 64, 77, 255 ) )
		gPrinters.drawBox( 0, 290, 261, 240, 1, Color( 57, 64, 77, 255 ) )


		gPrinters.drawText( 0, "Other Information", 17, 20, 290, Color( 255, 163, 0, 100 ), 0 )
		gPrinters.drawBox( 0, 10, 290, 1, 200, Color( 57, 64, 77, 255 ) )
		gPrinters.drawBox( 0, 530, 290, 1, 200, Color( 57, 64, 77, 255 ) )
		gPrinters.drawBox( 0, 10, 490, 521, 1, Color( 57, 64, 77, 255 ) )
		gPrinters.drawBox( 0, 140, 290, 390, 1, Color( 57, 64, 77, 255 ) )



		gPrinters.drawText( 0, "Groups Setup", 17, 560, 80, Color( 255, 163, 0, 100 ), 0 )
		gPrinters.drawBox( 0, 550, 82, 1, 204, Color( 57, 64, 77, 255 ) )
		gPrinters.drawBox( 0, 550, 285, 341, 1, Color( 57, 64, 77, 255 ) )
		gPrinters.drawBox( 0, 890, 82, 1, 204, Color( 57, 64, 77, 255 ) )

		gPrinters.drawBox( 0, 650, 82, 240, 1, Color( 57, 64, 77, 255 ) )

		gPrinters.drawText( 0, "Donation Group", 17, 560, 300, Color( 255, 163, 0, 100 ), 0 )

		gPrinters.drawBox( 0, 550, 300, 1, 40, Color( 57, 64, 77, 255 ) )

		gPrinters.drawBox( 0, 550, 340, 341, 1, Color( 57, 64, 77, 255 ) )

		gPrinters.drawBox( 0, 890, 300, 1, 40, Color( 57, 64, 77, 255 ) )

		gPrinters.drawBox( 0, 660, 300, 230, 1, Color( 57, 64, 77, 255 ) )

		gPrinters.drawText( 0, "Secondary Groups", 17, 560, 360, Color( 255, 163, 0, 100 ), 0 )


		gPrinters.drawBox( 0, 550, 360, 1, 60, Color( 57, 64, 77, 255 ) )

		gPrinters.drawBox( 0, 550, 420, 341, 1, Color( 57, 64, 77, 255 ) )

		gPrinters.drawBox( 0, 890, 360, 1, 60, Color( 57, 64, 77, 255 ) )

		gPrinters.drawBox( 0, 660, 360, 230, 1, Color( 57, 64, 77, 255 ) )

		gPrinters.drawText( 0, "Review Information", 17, 560, 430, Color( 255, 163, 0, 100 ), 0 )
		gPrinters.drawBox( 0, 550, 430, 1, 60, Color( 57, 64, 77, 255 ) )
		gPrinters.drawBox( 0, 550, 490, 340, 1, Color( 57, 64, 77, 255 ) )
		gPrinters.drawBox( 0, 685, 430, 205, 1, Color( 57, 64, 77, 255 ) )
		gPrinters.drawBox( 0, 890, 430, 1, 61, Color( 57, 64, 77, 255 ) )

		gPrinters.drawText( 0, "Printer Overheat Chance ( 0 - 100 )", 15, 20, 310, Color( 127, 127, 127, 255 ), 0 )
		gPrinters.drawText( 0, "Printer Print Amount ( Per Cycle )", 15, 20, 350, Color( 127, 127, 127, 255 ), 0 )
		gPrinters.drawText( 0, "Printer Allow Attachments?", 15, 20, 390, Color( 127, 127, 127, 255 ), 0 )
		gPrinters.drawText( 0, "Printer sortOrder", 15, 20, 430, Color( 127, 127, 127, 255 ), 0 )
		gPrinters.drawText( 0, "Printer Cops Remove Reward", 15, 300, 350, Color( 127, 127, 127, 255 ), 0 )
		gPrinters.drawText( 0, "Printer Category", 15, 300, 390, Color( 127, 127, 127, 255 ), 0 )
		gPrinters.drawText( 0, "Printer Jobs", 15, 300, 430, Color( 127, 127, 127, 255 ), 0 )

		gPrinters.drawText( 0, "Printer Health", 15, 300, 310, Color( 127, 127, 127, 255 ), 0 )
		gPrinters.drawText( 0, "Printer Max-Hold", 15, 415, 310, Color( 127, 127, 127, 255 ), 0 )
		gPrinters.drawPicture( 20, 460, 32, 32, "materials/f1menu/alert.png", Color( 255, 163, 0, 200 ) )
		gPrinters.drawText( 0, "You must restart your server to implement this to F4.", 15, 50, 475, Color( 127, 127, 127, 255 ), 0 )

		if SG == nil then
			gPrinters.drawText( 0, "This feature is only enabled while you use Secondary Groups", 15, 560, 390, Color( 127, 127, 127, 255 ), 0 )
		end

	end

	gPrinters.adminModes[ gPrinters.plugins[ "Other" ].adminSystem ].addFunction( panel );
	local secondary_group = {}

	local sgroup = vgui.Create( "DPanelList", panel )
	sgroup:SetPos( 560, 375 )
	sgroup:SetSize( 330, 40 )
	sgroup:SetSpacing( 1 )
	sgroup:SetPadding( 1 )
	sgroup:EnableVerticalScrollbar( true )
	sgroup:EnableHorizontal( true )
	sgroup:hideBar()

	if SG then
		for _, grop in ipairs( SG.Data.CurrentGroups ) do
			local grp = vgui.Create( "DButton", panel )
			grp:SetSize( 160, 20 )
			grp:SetText( "" )
			grp.Paint = function( slf, w, h )
				gPrinters.drawBox( 0, 0, 0, slf:GetWide(), slf:GetTall(), Color( 0, 0, 0, 100 ) )
				gPrinters.drawText( 0, grop, 16, slf:GetWide() / 2, slf:GetTall() / 2, Color( 163, 163, 163, 175 ), 1 )
			end

			local grpcheck = vgui.Create( "DCheckBox", grp )
			grpcheck:SetSize( 16, 16 )
			grpcheck:SetPos( 2, 2 )


			grp.DoClick = function()
				if !grpcheck:GetChecked() then
					table.insert( secondary_group, grop )
					grpcheck:SetChecked( true )
				else
					table.RemoveByValue( secondary_group, grop )
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
					table.insert( secondary_group, grop )
					grpcheck:SetChecked( true )
				else
					table.RemoveByValue( secondary_group, grop )
					grpcheck:SetChecked( false )
				end
			end

			sgroup:AddItem( grp )
		end
	end

	local pname = vgui.Create( "gprinters_textinput", panel )
	pname:SetPos( 20, 110 )
	pname:SetSize( 225, 20 )
	pname:SetValue( "" )

	local pcolor = vgui.Create( "gprinter_vector", panel )
	pcolor:SetPos( 20, 150 )
	pcolor:SetSize( 225, 20 )
	pcolor.valor = Vector( 163, 163, 163 )

	local psound = vgui.Create( "gprinter_comboinput", panel )
	psound:SetPos( 20, 230 )
	psound:SetSize( 225, 20 )

	local f4price = vgui.Create( "gprinters_textinput", panel )
	f4price:SetPos( 300, 150 )
	f4price:SetSize( 225, 20 )
	f4price:SetValue( 1500 )



	local f4amount = vgui.Create( "gprinters_textinput", panel )
	f4amount:SetPos( 300, 110 )
	f4amount:SetSize( 110, 20 )
	f4amount:SetValue( 1 )

	local plevel = vgui.Create( "gprinters_textinput", panel )
	plevel:SetPos( 415, 110 )
	plevel:SetSize( 110, 20 )
	plevel:SetValue( 0 )
	plevel:SetTooltip( "If you're using Vrondakis Leveling System, Set This different to 0" )

	local poverh = vgui.Create( "gprinters_switch", panel )
	poverh:SetPos( 300, 190 )
	poverh.enabled = true

	local cpremove = vgui.Create( "gprinters_switch", panel )
	cpremove:SetPos( 300, 230 )
	cpremove.enabled = true

	local attachments = vgui.Create( "gprinters_switch", panel )
	attachments:SetPos( 20, 400 )
	attachments.enabled = true

	local sortorder = vgui.Create( "gprinters_textinput", panel )
	sortorder:SetPos( 20, 440 )
	sortorder:SetSize( 225, 20 )
	sortorder:SetValue( 250 )
	sortorder:SetNumeric( true )
	sortorder.OnEnter = function()
	end

	local pamount = vgui.Create( "gprinters_textinput", panel )
	pamount:SetPos( 20, 360 )
	pamount:SetSize( 225, 20 )
	pamount:SetValue( 250 )
	pamount:SetNumeric( true )
	pamount.OnEnter = function()
	end

	local ptime = vgui.Create( "gprinters_textinput", panel )
	ptime:SetPos( 20, 190 )
	ptime:SetSize( 225, 20 )
	ptime:SetValue( 120 )
	ptime:SetNumeric( true )
	ptime.OnEnter = function()
	end

	local remrew = vgui.Create( "gprinters_textinput", panel )
	remrew:SetPos( 300, 360 )
	remrew:SetSize( 225, 20 )
	remrew:SetValue( 200 )
	remrew:SetNumeric( true )
	remrew.OnEnter = function()
	end



	local dongroup = vgui.Create( "gprinters_textinput", panel )
	dongroup:SetPos( 560, 315 )
	dongroup:SetSize( 320, 20 )
	dongroup:SetValue( 0 )
	dongroup:SetNumeric( true )
	dongroup.OnEnter = function()
	end

	local category = vgui.Create( "gprinter_category", panel )
	category:SetPos( 300, 400 )
	category:SetSize( 225, 20 )

	local pjobs = vgui.Create( "gprinter_jobs", panel )
	pjobs:SetPos( 300, 440 )
	pjobs:SetSize( 225, 20 )
	pjobs.jobs = {}

	local ochance = vgui.Create( "gprinters_wang_2", panel )
	ochance:SetPos( 20, 320 )
	ochance:SetSize( 225, 20 )
	ochance:SetValue( 25 )
	ochance:SetNumeric( true )

	local phealth = vgui.Create( "gprinters_textinput", panel )
	phealth:SetPos( 300, 320 )
	phealth:SetSize( 110, 20 )
	phealth:SetValue( 100 )
	phealth:SetNumeric( true )
	phealth.OnEnter = function()
	end

	local pmaxamount = vgui.Create( "gprinters_textinput", panel )
	pmaxamount:SetPos( 415, 320 )
	pmaxamount:SetSize( 110, 20 )
	pmaxamount:SetValue( 10000 )
	pmaxamount:SetNumeric( true )
	pmaxamount.OnEnter = function()
	end

	local rrnow = vgui.Create( "DButton", panel )
	rrnow:SetPos( 350, 465 )
	rrnow:SetSize( 150, 20 )
	rrnow:SetText( "" )

	rrnow.Paint = function( self, w, h )
		if !self:IsHovered() then
			gPrinters.drawBox( 0, 0, 0, w, h, Color( 5, 5, 5, 100 ) )
			gPrinters.drawText( 0, "Restart Now", 14, w / 2, h / 2, Color( 163, 163, 163, 100 ), 1 )
		else
			gPrinters.drawBox( 0, 0, 0, w, h, Color( 5, 5, 5, 150 ) )
			gPrinters.drawText( 0, "Restart Now", 14, w / 2, h / 2, Color( 163, 163, 163, 150 ), 1 )
		end
	end

	rrnow.DoClick = function()
		net.Start( "gPrinters.rrnow" )
		net.SendToServer()
	end

	local prints = {}

	function gPrinters.checkBlank( printer, uid )
		if printer[ uid ].name == "" or printer[ uid ].color == "" or printer[ uid ].sound == "Choose your sound" or
			printer[ uid ].category == "Select Category" or printer[ uid ].attachment == "" or printer[ uid ].pmaxamount == "" or printer[ uid ].plevel == ""
			or printer[ uid ].health == "" or printer[ uid ].pamount == "" or printer[ uid ].ptime == ""
			or printer[ uid ].ochhance == "" or printer[ uid ].poverh == "" or printer[ uid ].cpremove == ""
			or printer[ uid ].remrew == "" or printer[ uid ].f4price == "" or printer[ uid ].f4amount == "" or printer[ uid ].sortorder == "" then
			return true
		end
		return false
	end

	local accept = vgui.Create( "DButton", panel )
	accept:SetPos( 560, 450 )
	accept:SetSize( 320, 30 )
	accept:SetText( "" )
	accept.Paint = function( slf, w, h )
		if slf:IsHovered() then
			gPrinters.drawBox( 0, 0, 0, w, h, Color( 5, 5, 5, 150 ) )
		else
			gPrinters.drawBox( 0, 0, 0, w, h, Color( 5, 5, 5, 100 ) )
		end
		gPrinters.drawText( 0, "Implement Printer", 15, w / 2, h / 2, Color( 163, 163, 163, 100 ), 1 )
	end

	accept.DoClick = function( slf )
		if CurTime() < ( slf.cooldown or 0 ) then return end

		prints = {
			[ "gPrinters." .. pname:GetValue() ] = {
				uid = "gPrinters." .. pname:GetValue(),
				name = pname:GetValue(),
				cmd = string.lower( "g" .. string.Replace( pname:GetValue(), " ", "_" ) ),
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
				pmaxamount = tonumber( pmaxamount:GetValue() ),
				plevel = plevel:GetValue(),
				donationrank = dongroup:GetValue() or nil,
				secondary_group = secondary_group or {}
			}
		}

		if gPrinters.checkDatabase( prints ) then
			gPrinters.notifyCreation( "Printer already exist in our database", scrollPanel, 150, 50, 50, "materials/f1menu/prohibited.png", Color( 255, 50, 50, 200 ) )
			slf.cooldown = CurTime() + 3
			return
		end

		if gPrinters.checkBlank( prints, "gPrinters." .. pname:GetValue() ) then
			gPrinters.notifyCreation( "Please complete the form", scrollPanel, 0, 163, 255, "materials/f1menu/information.png", Color( 0, 163, 255, 200 ) )
			slf.cooldown = CurTime() + 3
			return
		end

		if !LocalPlayer():IsSuperAdmin() then
			gPrinters.notifyCreation( "You're not Super Admin", scrollPanel, 150, 50, 50, "materials/f1menu/prohibited.png", Color( 255, 50, 50, 200 ) )
			slf.cooldown = CurTime() + 3
			return
		end
		gPrinters.notifyCreation( "Printer Added Successfully", scrollPanel, 0, 255, 163, "materials/f1menu/tick.png", Color( 0, 255, 163, 200 ) )

		net.Start( "gPrinters.registerPrinters" )
			net.WriteTable( prints )
		net.SendToServer()
		slf.cooldown = CurTime() + 3
		return
	end
end	}