include( "shared.lua" )

local attachments = {
	[1] = { model = "antenna", visible = 0 },
	[2] = { model = "armour", visible = 0 },
	[3] = { model = "block_fan", visible = 0 },
	[4] = { model = "block_moreprint", visible = 0 },
	[5] = { model = "block_silencer", visible = 0 },
	[6] = { model = "pipes", visible = 0 },
	[7] = { model = "scanner", visible = 0 }
}

function ENT:Draw()
	self:SetupBones()
	self:DrawModel()

	local vector = Vector( 12.5, -16, 5 )
	local pos = self:LocalToWorld( vector )
	local ang = self:LocalToWorldAngles( Angle( 0, 90, 0 ) )
	local x, y, w, h, scale = 0, 0, 160, 35, 0.10
	local inPosition = util.IntersectRayWithPlane( LocalPlayer():GetShootPos(), LocalPlayer():GetAimVector(), pos, ang:Up() )
	local alpha = ( LocalPlayer():GetPos():Distance( self:GetPos() ) / 200.0 )
	alpha = math.Clamp( 1 - alpha, 0 ,1 )

	if inPosition then
		local hitpos = self:WorldToLocal( inPosition ) - vector
		cx = hitpos.y * (1 / scale)
		cy = hitpos.x * (1 / scale)
		activePanel = true
	end

	cam.Start3D2D( pos, ang, scale )
		local inrad = LocalPlayer():GetShootPos():Distance( self:GetPos() ) < 1000
		local panel_selected = activePanel and inrad and cx >= x and cx <= x + w and cy >= y and cy <= y + h

		if panel_selected then
			col = Color( 32, 32, 32, 200 * alpha )
			self.boton = 1
		else
			col = Color( 32, 32, 32, 100 * alpha )
			self.boton = 0
		end

		gPrinters.drawBox( 0, x, y, w, h, col )
		gPrinters.drawBox( 0, x + 2, y + 2, w - 4, h - 4, col )
		gPrinters.drawText( 0, "Panel Access", 15, x + 80, y / 2 + 8, Color( 163, 163, 163, 150 * alpha ), 1 )
		gPrinters.drawText( 0, "Enter Now!", 14, x + 80, y / 2 + 20, Color( 163, 163, 163, 150 * alpha ), 1 )
	cam.End3D2D()

	if ( ( input.IsButtonDown( MOUSE_LEFT ) or input.IsButtonDown( MOUSE_RIGHT ) ) and panel_selected ) then
		net.Start( "gPrinters.sendID" )
			net.WriteEntity( self )
			net.WriteUInt( self.boton, 8 )
		net.SendToServer()
	end


	if ( gPrinters.plugins[ "General" ].armour == true ) then
		attachments[ 2 ].enabled = 1
		if self:Getarmour() == 1 then
			attachments[ 2 ].visible = 1
		else
			attachments[ 2 ].visible = 0
		end
	else
		attachments[ 2 ].visible = 0
		attachments[ 2 ].enabled = 0
	end

	//Attachments names
	attachments[ 1 ].display = "Antenna"
	attachments[ 2 ].display = "Armour"
	attachments[ 3 ].display = "Cooler"
	attachments[ 4 ].display = "More Print"
	attachments[ 5 ].display = "Silencer"
	attachments[ 6 ].display = "Fast Print"
	attachments[ 7 ].display = "Scanner"


	if ( gPrinters.plugins[ "General" ].cooler == true ) then
		attachments[ 3 ].enabled = 1
	else
		attachments[ 3 ].enabled = 0
	end

	if ( gPrinters.plugins[ "General" ].antenna == true ) then
		attachments[ 1 ].enabled = 1
		if self:Getantenna() == 1 then
			attachments[ 1 ].visible = 1
		else
			attachments[ 1 ].visible = 0
		end
	else
		attachments[ 1 ].visible = 0
		attachments[ 1 ].enabled = 0
	end

	if ( gPrinters.plugins[ "General" ].moreprint == true ) then
		attachments[ 4 ].enabled = 1
		if self:Getmoreprint() == 1 then
			attachments[ 4 ].visible = 1
		else
			attachments[ 4 ].visible = 0
		end
	else
		attachments[ 4 ].visible = 0
		attachments[ 4 ].enabled = 0
	end

	if ( gPrinters.plugins[ "General" ].silencer == true ) then
		attachments[ 5 ].enabled = 1
		if self:Getsilencer() == 1 then
			attachments[ 5 ].visible = 1
		else
			attachments[ 5 ].visible = 0
		end
	else
		attachments[ 5 ].visible = 0
		attachments[ 5 ].enabled = 0
	end

	if ( gPrinters.plugins[ "General" ].fastprint == true ) then
		attachments[ 6 ].enabled = 1
		if self:Getpipes() == 1 then
			attachments[ 6 ].visible = 1
		else
			attachments[ 6 ].visible = 0
		end
	else
		attachments[ 6 ].visible = 0
		attachments[ 6 ].enabled = 0
	end

	if ( gPrinters.plugins[ "General" ].scanner == true ) then
		attachments[ 7 ].enabled = 1
		if self:Getscanner() == 1 then
			attachments[ 7 ].visible = 1
		else
			attachments[ 7 ].visible = 0
		end
	else
		attachments[ 7 ].visible = 0
		attachments[ 7 ].enabled = 0
	end

	local angle = self:GetAngles()
	local position = self:GetPos()
	angle:RotateAroundAxis( angle:Up(), 90 )

	local alpha = ( LocalPlayer():GetPos():Distance( self:GetPos() ) / 200.0 )
	alpha = math.Clamp( 1 - alpha, 0 ,1 )

	cam.Start3D2D( position + angle:Up() * 5, angle, 0.11 )

		//Display Printer Information
		gPrinters.drawBox( 0, -145, -140, 145, 25, Color( 32, 32, 32, 150 * alpha ) )
		gPrinters.drawBox( 0, -145, -114, 145, 4, Color( 32, 32, 32, 150 * alpha ) )
		gPrinters.drawBox( 0, -145, -140, 145, 2, Color( self.data.color.r, self.data.color.g, self.data.color.b, 150 * alpha ) )
		gPrinters.drawText( 0, self.data.name or "Money Printer", 15, -72.5, -127.5, Color( self.data.color.r, self.data.color.g, self.data.color.b, 150 * alpha ), 1 )


		//Attachments Area

		if ( self.data.attachment == true ) then
			gPrinters.drawBox( 0, -145, -105, 145, 135, Color( 32, 32, 32, 150 * alpha ) )

			local separator = 0
			for i = 1, 7 do
				if ( attachments[ i ].enabled == 1 ) then
					separator = separator + 1
					if i != 3 then
						gPrinters.drawText( 0, attachments[ i ].display, 15, -140, -90 + separator * 15, Color( 163, 163, 163, 150 * alpha ), 0 )
						if ( attachments[ i ].visible == 1 ) then
							gPrinters.drawBox( 0, -50, -95 + separator * 15, 50, 13, Color( 32, 32, 32, 150 * alpha ) )
							gPrinters.drawText( 0, "Installed", 15, -3, -90 + separator * 15, Color( 120, 255, 120, 25 * alpha ), TEXT_ALIGN_RIGHT )
						else
							gPrinters.drawBox( 0, -20, -95 + separator * 15, 20, 13, Color( 32, 32, 32, 150 * alpha ) )
							gPrinters.drawText( 0, "No", 15, -3, -90 + separator * 15, Color( 163, 0, 0, 150 * alpha ), TEXT_ALIGN_RIGHT )
						end
					else
						gPrinters.drawText( 0, attachments[ i ].display, 15, -140, -90 + separator * 15, Color( 163, 163, 163, 150 * alpha ), 0 )
						if ( self:Getfan() == 1 ) then
							gPrinters.drawBox( 0, -50, -95 + separator * 15, 50, 13, Color( 32, 32, 32, 150 * alpha ) )
							gPrinters.drawText( 0, "Installed", 15, -3, -90 + separator * 15, Color( 120, 255, 120, 25 * alpha ), TEXT_ALIGN_RIGHT )
						else
							gPrinters.drawBox( 0, -20, -95 + separator * 15, 20, 13, Color( 32, 32, 32, 150 * alpha ) )
							gPrinters.drawText( 0, "No", 15, -3, -90 + separator * 15, Color( 163, 0, 0, 150 * alpha ), TEXT_ALIGN_RIGHT )
						end
					end
				end
			end

			if ( gPrinters.plugins[ "General" ].displayBorders == true ) then
				gPrinters.drawBox( 0, -147, -140, 2, 287, Color( 0, 0, 0, 255 * alpha ) )
				gPrinters.drawBox( 0, 0, -140, 2, 287, Color( 0, 0, 0, 255 * alpha ) )
				gPrinters.drawBox( 0, -145, -114, 145, 4, Color( 0, 0, 0, 255 * alpha ) )
				gPrinters.drawBox( 0, -145, -105, 145, 2, Color( 0, 0, 0, 255 * alpha ) )
				gPrinters.drawBox( 0, -145, -85, 145, 2, Color( 0, 0, 0, 255 * alpha ) )
				gPrinters.drawBox( 0, -145, 28, 145, 2, Color( 0, 0, 0, 255 * alpha ) )
				gPrinters.drawBox( 0, -145, 85, 145, 2, Color( 0, 0, 0, 255 * alpha ) )
				gPrinters.drawBox( 0, -145, 35, 145, 2, Color( 0, 0, 0, 255 * alpha ) )
				gPrinters.drawBox( 0, -145, 65, 145, 2, Color( 0, 0, 0, 255 * alpha ) )
				gPrinters.drawBox( 0, -145, 60, 145, 2, Color( 0, 0, 0, 255 * alpha ) )
				gPrinters.drawBox( 0, -145, 145, 145, 2, Color( 0, 0, 0, 255 * alpha ) )
			end

			gPrinters.drawBox( 0, -145, -105, 145, 20, Color( 32, 32, 32, 150 * alpha ) )

			gPrinters.drawText( 0, "Printer Upgrades", 15, -72.5, -95, Color( 163, 163, 163, 150 * alpha ), 1 )

		end

		//Display Money
		gPrinters.drawBox( 0, -145, 35, 145, 25, Color( 32, 32, 32, 150 * alpha ) )
		if ( self.data.pmaxamount < 1000000) then
			gPrinters.drawText( 0, "Money", 17, -140, 47.5, Color( 163, 163, 163, 150 * alpha ), 0 )
		end

		if self.data.pmaxamount then
			if ( self.data.pmaxamount != 0 ) then
				if ( ( self:Getstoredmoney() + self.data.pamount ) >= self.data.pmaxamount ) then
					gPrinters.drawText( 0, "FULL $" .. gPrinters.moneyFormat( self:Getstoredmoney() ), 17, -3, 47.5, Color( 255, 0, 0, 150 * alpha ), TEXT_ALIGN_RIGHT )
				else
					if ( self.data.pmaxamount >= 1000000) then
						if ( self:Getstoredmoney() >= self.data.pmaxamount ) then
							gPrinters.drawPicture( -30, 32, 32, 32, "materials/f1menu/prohibited.png", Color( 255, 50, 50, 100 ) )
							gPrinters.drawPicture( -149, 32, 32, 32, "materials/f1menu/prohibited.png", Color( 255, 50, 50, 100 ) )
						end
						gPrinters.drawText( 0, "$" .. gPrinters.moneyFormat( self:Getstoredmoney() ), 17, -70, 47.5, Color( 163, 163, 163, 150 * alpha ), TEXT_ALIGN_CENTER )
					else
						gPrinters.drawText( 0, "$" .. gPrinters.moneyFormat( self:Getstoredmoney() ) .. " / $" .. gPrinters.moneyFormat( self.data.pmaxamount ), 17, -3, 47.5, Color( 163, 163, 163, 150 * alpha ), TEXT_ALIGN_RIGHT )
					end
				end
			else
				gPrinters.drawText( 0, "$" .. gPrinters.moneyFormat( self:Getstoredmoney() ), 17, -3, 47.5, Color( 163, 163, 163, 150 * alpha ), TEXT_ALIGN_RIGHT )
			end
		else
			gPrinters.drawText( 0, "$" .. gPrinters.moneyFormat( self:Getstoredmoney() ), 17, -3, 47.5, Color( 163, 163, 163, 150 * alpha ), TEXT_ALIGN_RIGHT )
		end

		gPrinters.drawBox( 0, -145, 65, 145, 20, Color( 32, 32, 32, 150 * alpha ) )
		if IsValid( self:Getowning_ent() ) then
			gPrinters.drawText( 0, self:Getowning_ent():Nick(), 15, -72.5, 73.5, Color( 163, 163, 163, 150 * alpha ), 1 )
		else
			gPrinters.drawText( 0, "Unknown", 15, -72.5, 73.5, Color( 163, 163, 163, 150 * alpha ), 1 )
		end

		//Health & Armor
		gPrinters.drawBox( 0, -145, 90, 145, 22, Color( 32, 32, 32, 150 * alpha ) )

		//LifeBar
		local lifevar = math.Clamp( 141 * self:Gethealth() / self.data.health, 0, 141 )
		local lifevard = math.Clamp( 255 * self:Gethealth() / self.data.health, 0, 255 )
		//Life Bar
		gPrinters.drawBox( 0, -143, 92, lifevar, 18, Color( 255 - lifevard, lifevard, 0, 100 * alpha ) )

		//Armour bar
		if self:Getarmor() > 0 then
			gPrinters.drawBox( 0, -143, 92, math.Clamp( 141 * self:Getarmor() / tonumber( gPrinters.plugins[ "General" ].armorUpgrade ), 0, 141 ), 18, Color( 125,125,255, 125 * alpha ) )
			gPrinters.drawPicture( -145, 85, 32, 32, "materials/f1menu/diamond.png", Color( 0, 0, 0, 255 * alpha ) )
			gPrinters.drawText( 0, self:Getarmor() .. " + " .. self:Gethealth(), 17, -3, 100, Color( 163, 163, 163, 150 * alpha ), TEXT_ALIGN_RIGHT )
		else
			gPrinters.drawText( 0, self:Gethealth(), 17, -3, 100, Color( 200, 200, 200, 150 * alpha ), TEXT_ALIGN_RIGHT )
		end
	cam.End3D2D()
end

function ENT:Think()
	self:NextThink( CurTime() + 0.4 )
	if self.boton == self.anterior then return end
	self.anterior = self.boton
	net.Start( "gPrinters.sendID" )
		net.WriteEntity( self )
		net.WriteUInt( self.boton, 8 )
	net.SendToServer()
end
