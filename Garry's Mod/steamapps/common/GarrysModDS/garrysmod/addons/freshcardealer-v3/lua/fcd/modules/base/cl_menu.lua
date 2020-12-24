fcd.categories = {}
fcd.modificationSaves = {}

local curDealer
local curDealerEnt
local rpnl
local rpnlList
local bg
local mbg
local w, h

local vipMat = Material( 'icon16/award_star_bronze_1.png', 'noclamp smooth' )

function fcd.clientInit()
	if not file.Exists( 'fcd_mods.txt', 'DATA' ) then
		file.Write( 'fcd_mods.txt', '' )
	end

	local data = file.Read( 'fcd_mods.txt', 'DATA' )
	if not data then return end
	if data == '' then return end

	data = util.JSONToTable( data )

	for class, mods in pairs( data ) do
		fcd.modificationSaves[ class ] = mods
	end
end

hook.Add( 'Initialize', 'fcd.clientInit', fcd.clientInit )

function fcd.saveModifications()
	file.Write( 'fcd_mods.txt', util.TableToJSON( fcd.modificationSaves ) )
end

function fcd.dealerMenu()
	curDealer = net.ReadString()
	if not fcd.getDealerByID( curDealer ) then return end

	curDealerEnt = fcd.getDealerByID( curDealer )

	local spawned = net.ReadBool() or false

	w, h = ScrW() * 0.95, ScrH() * 0.95

	if spawned then
		fcd.returnCheck()
	else
		fcd.openDealerMenu()
	end
end

function fcd.returnCheck()
	local bg = vgui.Create( 'fcdCheck' )
	bg.question = 'Return current vehicle?'

	bg.yes.onYesClicked = function()
		bg:Remove()

		net.Start( 'fcd.returnVehicle' )
			net.WriteString( curDealer )
		net.SendToServer()
	end
end

function fcd.openDealerMenu()
	local mw, mh = w / 10, h - 37

	local lw, lh = mw * 1.5, mh
	local lx, ly = 5, 30

	local rw, rh = mw * 8.5 - 15, mh
	local rx, ry = lx + lw + 5, 30

	bg = vgui.Create( 'fcdDFrame' )
	bg:SetSize( w, h )
	bg:SetPos( ScrW() / 2 - ( w / 2 ), ScrH() / 2 - ( h / 2 ) )
	bg.title =  fcd.getDealerName( curDealerEnt ) .. ' - Main Menu'

	mbg = bg:Add( 'fcdDPanel' )
	mbg:SetSize( w, h )
	mbg:SetPos( 0, 0 )

	bg:addCloseButton()

	function mbg:Paint( w, h )

	end

	local lpnl = mbg:Add( 'fcdDPanel' )
	lpnl:SetSize( lw, lh )
	lpnl:SetPos( lx, ly )
	lpnl.drawTitle = true
	lpnl.title = 'Categories'

	local lpnlList = lpnl:Add( 'DScrollPanel' )
	lpnlList:SetSize( lw, lh - 20 )
	lpnlList:SetPos( 0, 25 )
	lpnlList.VBar:SetWide( 0 )

	local yPos = 0

	local all = lpnlList:Add( 'fcdDButton' )
	all:SetSize( lw, 25 )
	all:SetPos( 0, yPos )
	all.text = 'Show all'
	all.id = 0

	function all:DoClick()
		if not self.clickable then return end

		fcd.displayCategory( self.id, curDealerEnt:GetisSpecific()  )
		rpnl.title = 'Vehicles'
	end

	yPos = yPos + 28

	for k, v in pairs( fcd.categories or {} ) do
		local cat = lpnlList:Add( 'fcdDButton' )
		cat:SetSize( lw, 25 )
		cat:SetPos( 0, yPos )
		cat.text = v
		cat.id = k

		function cat:DoClick()
			if not self.clickable then return end

			fcd.displayCategory( self.id, curDealerEnt:GetisSpecific() )
			rpnl.title = 'Vehicles ( ' .. v .. ' )'
		end

		yPos = yPos + 28
	end

	rpnl = mbg:Add( 'fcdDPanel' )
	rpnl:SetSize( rw, rh )
	rpnl:SetPos( rx, ry )
	rpnl.drawTitle = true
	rpnl.title = 'Vehicles'

	rpnlList = rpnl:Add( 'DScrollPanel' )
	rpnlList:SetSize( rw, rh - 25 )
	rpnlList:SetPos( 0, 25 )
	rpnlList.VBar:SetWide( 0 )

	if curDealerEnt:GetisSpecific() then
		fcd.displayCategory( 'curDealer' )
	else
		fcd.displayCategory( 0 )
	end
end

function fcd.displayCategory( id, specific )
	local data = {}

	local w, h = rpnl:GetWide() / 2 - 7.5, 100
	local x, y = 5, 0
	local count = 0

	if id == 0 then
		for k, v in pairs( fcd.dataVehicles or {} ) do

			if specific then
				if v.specificDealer then
					if table.HasValue( v.specificDealer, curDealer ) then
						table.insert( data, v )
					end
				end
			else
				if v.specificDealer then continue end
				table.insert( data, v )
			end
		end
	elseif id == 'curDealer' then
		for k, v in pairs( fcd.dataVehicles or {} ) do
			if v.specificDealer then
				if table.HasValue( v.specificDealer, curDealer ) then
					table.insert( data, v )
				end
			end
		end
	else
		local category = fcd.categories[ id ]
		if not category then category = fcd.dataVehicles end

		for k, v in pairs( fcd.dataVehicles or {} ) do
			if v.category then
				if v.category == category then
					if not specific then
						if v.specificDealer then continue end
					end

					if specific then
						if v.specificDealer then
							if table.HasValue( v.specificDealer, curDealer ) then
								table.insert( data, v )
							end
						end
					else
						table.insert( data, v )
					end
				end
			end
		end
	end

	rpnlList:Clear()

	for i, v in pairs( data or {} ) do
		v.owned = ( table.HasValue( fcd.owned, v.class ) ) and 1 or 0
	end

	for k, v in SortedPairsByMemberValue( data, 'owned', true ) do
		local purch = true

		count = count + 1

		local info = list.Get( 'Vehicles' )[ v.class ]
		if not info then continue end

		local reg = fcd.registeredVehicles[ v.class ]
		if not reg then return end

		if reg.rankRestrict then
			if reg.rankRestrict( LocalPlayer() ) then
				purch = true
			else
				purch = false
			end
		end

		if reg.jobRestrict then
			if reg.jobRestrict( LocalPlayer() ) then
				purch = true
			else
				purch = false
			end
		end

		v.owned = table.HasValue( fcd.owned, v.class )

		local pnl = rpnlList:Add( 'fcdDPanel' )
		pnl:SetSize( w, h )
		pnl:SetPos( x, y )
		pnl.title = info.Name or ''

		function pnl:PaintOver( w, h )
			draw.SimpleText( 'Price: ' .. DarkRP.formatMoney( v.price ) or 'nil', 'fcd_font_20', w / 4, 15, fcd.clientVal( 'mainTextColor' ) )

			if v.owned then
				draw.SimpleText( 'Owned: Yes', 'fcd_font_20', w / 4, 40, fcd.clientVal( 'mainTextColor' ) )
			else
				draw.SimpleText( 'Owned: No', 'fcd_font_20', w / 4, 40, fcd.clientVal( 'mainTextColor' ) )
			end

			if purch then
				draw.SimpleText( 'Purchasable: Yes', 'fcd_font_20', w / 4, 65, fcd.clientVal( 'mainTextColor' ) )
			else
				draw.SimpleText( 'Purchasable: No', 'fcd_font_20', w / 4, 65, fcd.clientVal( 'mainTextColor' ) )
			end

			if v.isVip then
				surface.SetDrawColor( Color( 255, 255, 255 ) )
				surface.SetMaterial( vipMat )
				surface.DrawTexturedRect( w - (  w * 0.3 ) - 5 - 25, 5, 20, 25 )
			end
		end

		local select = pnl:Add( 'fcdDButton' )
		select:SetSize( w * 0.3, h / 2 - 7.5 )
		select:SetPos( w - (  w * 0.3 ) - 5, 5 )
		select.text = 'Select'
		select.textSize = 20

		function select:DoClick()
			fcd.displayVehicle( v.class )
		end

		local quick = pnl:Add( 'fcdDButton' )
		quick:SetSize( w * 0.3, h / 2 - 7.5 )
		quick:SetPos( w - (  w * 0.3 ) - 5, 10 + h / 2 - 7.5 )
		quick.text = 'Quick Buy'
		quick.textSize = 20

		function quick:DoClick()
			net.Start( 'fcd.purchaseVehicle' )
				net.WriteString( v.class )
			net.SendToServer()

			bg:Remove()
		end

		if v.owned then
			quick.text = 'Quick Spawn'

			function quick:DoClick()
				net.Start( 'fcd.quickSpawnVehicle' )
					net.WriteString( v.class )
					net.WriteString( curDealer )
				net.SendToServer()

				bg:Remove()
			end
		end

		local mdl = pnl:Add( 'DModelPanel' )
		mdl:SetSize( w / 4, h )
		mdl:SetPos( 1, 1 )
		mdl:SetModel( info.Model )

		fcd.fixMdlPos( mdl )

		if count >= 2 then
			y = y + h + 5
			x = 5
			count = 0
		else
			x = x + w + 5
		end
	end
end

function fcd.displayVehicle( class )
	if not class then return end
	if not fcd.dataVehicles[ class ] then return end

	local vClr = Color( 255, 255, 255 )

	local nW, nH = w - 10, h - 37
	local mW, mH = nW / 2 - 10, nH / 2 - 10

	local sendData = {}
	sendData.dealerID = curDealer
	sendData.class = class

	local data = list.Get( 'Vehicles' )[ class ]
	if not data then return end

	mbg:SizeTo( 0, 0, fcd.clientVal( 'animationSpeed' ) )

	local nbg = bg:Add( 'fcdDPanel' )
	nbg:SetSize( 0, 0 )
	nbg:SetPos( 5, 30 )
	nbg.drawTitle = true
	nbg.title = data.Name or ''

	local back = nbg:Add( 'fcdDButton' )
	back:SetSize( 50, 20 )
	back:SetPos( nW - 50, 0 )
	back.text = 'Back'
	back.textSize = 18

	function back:DoClick()
		nbg:SizeTo( 0, 0, fcd.clientVal( 'animationSpeed' ) )

		timer.Simple( fcd.clientVal( 'animationSpeed' ), function()
			mbg:SizeTo( w, h, fcd.clientVal( 'animationSpeed' ) )
			nbg:Remove()
		end )
	end

	timer.Simple( fcd.clientVal( 'animationSpeed' ), function()
		nbg:SizeTo( nW, nH, fcd.clientVal( 'animationSpeed' ) )
	end )

	local mdlPnl = nbg:Add( 'fcdDPanel' )
	mdlPnl:SetSize( mW, mH )
	mdlPnl:SetPos( 5, 25 )
	mdlPnl.title = 'Model'

	local mdl = mdlPnl:Add( 'DModelPanel' )
	mdl:SetSize( mW, mH )
	mdl:SetPos( 0, 0 )
	mdl:SetModel( data.Model or '' )

	local mdlThink = true

	function mdl:Think()
		if mdlThink then
			self:SetColor( vClr )
		end
	end

	fcd.fixMdlPos( mdl )
	mdl:SetFOV( 60 )

	local modPnl = nbg:Add( 'fcdDPanel' )
	modPnl:SetSize( mW, mH )
	modPnl:SetPos( 15 + mW, 25 )
	modPnl.title = 'Modifications'

	local cW, cH = mW / 2 - 10, mH / 2 - 25

	local clr = modPnl:Add( 'DColorMixer' )
	clr:SetSize( cW, cH )
	clr:SetPos( 5, 20 )
	clr:SetWangs(false)
	clr:SetAlphaBar(false)
	clr:SetPalette(false)

	function clr:ValueChanged()
		vClr = self:GetColor()
		sendData.clr = self:GetColor()

		mdlThink = true
	end

	local check = modPnl:Add( 'DCheckBoxLabel' )
	check:SetPos( 5, 25 + cH)
	check:SetSize( 20, 20 )
	check:SetFont( 'fcd_font_18' )
	check:SetText( 'Enable vehicle under lights?' )

	if fcd.modificationSaves[ class ] then
		if fcd.modificationSaves[ class ].bGroups then
			for _, v in pairs( fcd.modificationSaves[ class ].bGroups ) do
				mdl.Entity:SetBodygroup( _, v )
			end
			sendData.bGroups = fcd.modificationSaves[ class ].bGroups
		end

		if fcd.modificationSaves[ class ].skin then
			mdl.Entity:SetSkin( fcd.modificationSaves[ class ].skin )
			sendData.skin = fcd.modificationSaves[ class ].skin
		end

		if fcd.modificationSaves[ class ].clr then
			local clr = fcd.modificationSaves[ class ].clr

			mdlThink = false

			mdl:SetColor( Color( clr.r, clr.g, clr.b ) )
			sendData.clr = fcd.modificationSaves[ class ].clr
		end

		if fcd.modificationSaves[ class ].underLightColor then
			check:SetValue( 1 )
			sendData.underLightColor = fcd.modificationSaves[ class ].underLightColor
			sendData.underLight = true
		end
	end

	local underClr = modPnl:Add( 'DColorMixer' )
	underClr:SetSize( cW, cH )
	underClr:SetPos( 5, 20 + cH + 25 )
	underClr:SetWangs(false)
	underClr:SetAlphaBar(false)
	underClr:SetPalette(false)

	function underClr:ValueChanged()
		sendData.underLightColor = self:GetColor()
	end

	function check:OnChange( bool )
		if bool then
			sendData.underLight = true
			sendData.underLightColor = underClr:GetColor()
		else
			sendData.underLight = false
		end
	end

	if not fcd.cfg.underLights then
		local coverPnl = modPnl:Add( 'fcdDPanel' )
		coverPnl:SetSize( cW, cH + 30 )
		coverPnl:SetPos( 5, 25 + cH )

		function coverPnl:Paint( w, h )
			fcd.drawBlur( self, 6 )

			draw.SimpleText( 'Under Lights Disabled', 'fcd_font_19', w / 2, h / 2, fcd.clientVal( 'mainTextColor' ), 1, 1 )
		end
	end

	local yPos = 20

	local skinChoose = modPnl:Add( 'fcdDComboBox' )
	skinChoose:SetSize( cW, 25 )
	skinChoose:SetPos( 15 + cW, yPos )
	skinChoose:SetValue( 'Set Skin' )

	for i = 0, mdl.Entity:SkinCount() do
		skinChoose:AddChoice( tostring( i ) )
	end

	function skinChoose:OnSelect()
		mdl.Entity:SetSkin( self:GetValue() )
		sendData.skin = tonumber( self:GetValue() )

		self:SetValue( 'Skin: ' .. self:GetValue() )
	end

	yPos = yPos + 25 + 5

	for _, bGroup in pairs( mdl.Entity:GetBodyGroups() ) do
		if not ( bGroup.num >= 2 ) then continue end

		local bMod = modPnl:Add( 'fcdDComboBox' )
		bMod:SetSize( cW, 25 )
		bMod:SetPos( 15 + cW, yPos )
		bMod:SetValue( bGroup.name or '' )

		for i = 0, bGroup.num - 1 do
			bMod:AddChoice( tostring( i ) )
		end

		function bMod:OnSelect()
			mdl.Entity:SetBodygroup( bGroup.id, tonumber( self:GetValue() ) )

			sendData.bGroups = sendData.bGroups or {}
			sendData.bGroups[ bGroup.id ] = tonumber( self:GetValue() )

			self:SetValue( ( bGroup.name or '' ) .. ': ' .. self:GetValue() )
		end

		yPos = yPos + 25 + 5
	end

	if not fcd.cfg.Modules[ 'vehicleModifications' ] then
		local modPnlHide = modPnl:Add( 'fcdDPanel' )
		modPnlHide:SetSize( mW, mH )
		modPnlHide:SetPos( 0, 0 )

		function modPnlHide:Paint( w, h )
			fcd.drawBlur( self, 6 )

			draw.SimpleText( 'Modifications Disabled', 'fcd_font_19', w / 2, h / 2, fcd.clientVal( 'mainTextColor' ), 1, 1 )
		end
	end

	local vehStats = nbg:Add( 'fcdDPanel' )
	vehStats:SetSize( mW, mH - 20 )
	vehStats:SetPos( 5, 35 + mH )
	vehStats.drawTitle = false
	vehStats.title = 'Data'

	local vehData = fcd.dataVehicles[ class ]

	local barAmt = mW / 25
	local barH = mH / 3 - 25 - 30

	local spdBar = 130 / barAmt
	local rpmBar = 5000 / barAmt
	local horseBar = 1200 / barAmt

	if vehData.maxSpeed and vehData.maxRPM and vehData.horsePower then
		local vehSpd = vehData.maxSpeed / spdBar
		local vehRPM = vehData.maxRPM / rpmBar
		local vehHorsePower = vehData.horsePower / horseBar

		function vehStats:PaintOver( w, h )
			local yPos = 25
			local xPos = 5

			local barX = 5

			draw.SimpleText( 'Max Speed: ', 'fcd_font_25', 5, yPos, fcd.clientVal( 'mainTextColor' ) )

			yPos = yPos + 30

			for i = 1, barAmt do

				local clr = Color( 10, 10, 10, 200 )

				if i <= vehSpd then
					clr = Color( 25, 255, 25 )
				end

				draw.RoundedBox( 0, barX, yPos, 15, barH, clr )
				barX = barX + 25
			end

			yPos = yPos + barH + 5

			draw.SimpleText( 'Max RPM: ', 'fcd_font_25', 5, yPos, fcd.clientVal( 'mainTextColor' ) )

			yPos = yPos + 30
			barX = 5

			for i = 1, barAmt do

				local clr = Color( 10, 10, 10, 200 )

				if i <= vehRPM then
					clr = Color( 25, 255, 25 )
				end

				draw.RoundedBox( 0, barX, yPos, 15, barH, clr )
				barX = barX + 25
			end

			yPos = yPos + barH + 5

			draw.SimpleText( 'Horse Power: ', 'fcd_font_25', 5, yPos, fcd.clientVal( 'mainTextColor' ) )

			yPos = yPos + 30
			barX = 5

			for i = 1, barAmt do

				local clr = Color( 10, 10, 10, 200 )

				if i <= vehHorsePower then
					clr = Color( 25, 255, 25 )
				end

				draw.RoundedBox( 0, barX, yPos, 15, barH, clr )
				barX = barX + 25
			end
		end
	else
		local vehStatsC = vehStats:Add( 'fcdDPanel' )
		vehStatsC:SetSize( mW, mH - 20 )
		vehStatsC:SetPos( 0, 0 )

		function vehStatsC:Paint( w, h )
			fcd.drawBlur( self, 6 )

			draw.SimpleText( 'Stats Not Available', 'fcd_font_19', w / 2, h / 2, fcd.clientVal( 'mainTextColor' ), 1, 1 )
		end
	end

	local manage = nbg:Add( 'fcdDPanel' )
	manage:SetSize( mW, mH - 20 )
	manage:SetPos( 15 + mW, 35 + mH )
	manage.drawTitle = false
	manage.title = 'Manage'

	local clicka = true
	if vehData.owned then
		clicka = false
	end

	local btns = {}

	btns[ 1 ] = {
		txt = 'Purchase',
		clickable = clicka,
		click = function()
			net.Start( 'fcd.purchaseVehicle' )
				net.WriteString( class )
			net.SendToServer()
		end
	}
	btns[ 2 ] = {
		txt = 'Sell',
		clickable = vehData.owned and true or false,
		click = function()
			net.Start( 'fcd.sellVehicle' )
				net.WriteString( class )
			net.SendToServer()
		end
	}
	btns[ 3 ] = {
		txt = 'Spawn',
		clickable = vehData.owned and true or false,
		click = function()
			net.Start( 'fcd.spawnVehicle' )
				net.WriteTable( sendData )
			net.SendToServer()

			fcd.modificationSaves[ class ] = sendData
			fcd.saveModifications()
		end
	}

	local yPos = 20

	for i = 1, #btns do
		local data = btns[ i ]

		local w, h = mW, ( mH - 15 ) / #btns - 7.5

		local btn = manage:Add( 'fcdDButton' )
		btn:SetSize( w, h )
		btn:SetPos( 5, yPos)
		btn.text = data.txt
		btn.textSize = 20
		btn.clickable = data.clickable

		function btn:DoClick()
			if not self.clickable then return end

			data.click()
			bg:Remove()
		end

		yPos = yPos + h + 5
	end
end
