local old
local ownData = {}

function fcd.dealerAdmin()
	local dealerID = net.ReadString()
	local dealer = fcd.getDealerByID( dealerID )
	if not dealer then return end

	local data = {}

	local w, h = 375, 320
	local x, y = ScrW() / 2 - ( w / 2 ), ScrH() / 2 - ( h / 2 )

	local bg = vgui.Create( 'fcdDFrame' )
	bg:SetSize( w, h )
	bg:SetPos( x, y )
	bg:addCloseButton()
	bg.title = fcd.getDealerName( dealer ) .. ' - Admin Menu'

	function bg:PaintOver( w, h )
		local y = 30

		draw.SimpleText( 'Change Dealer ID:', 'fcd_font_18', w / 2, y, fcd.clientVal( 'mainTextColor' ), 1 )

		y = y + 18 + 35

		draw.SimpleText( 'Change Dealer Name:', 'fcd_font_18', w / 2, y, fcd.clientVal( 'mainTextColor' ), 1 )

		y = y + 18 + 35

		draw.SimpleText( 'Change Dealer Model:', 'fcd_font_18', w / 2, y, fcd.clientVal( 'mainTextColor' ), 1 )

		y = y + 18 + 35
	end

	y = 53

	local idText = bg:Add( 'fcdDTextEntry' )
	idText:SetSize( w - 10, 25 )
	idText:SetPos( 5, y )
	idText:SetText( dealerID )

	function idText:OnChange()
		data.dealerID = self:GetValue()
	end

	y = y + 53

	local nameText = bg:Add( 'fcdDTextEntry' )
	nameText:SetSize( w - 10, 25 )
	nameText:SetPos( 5, y )
	nameText:SetText( fcd.getDealerName( dealer ) )

	function nameText:OnChange()
		data.dealerName = self:GetValue()
	end

	y = y + 54

	local mdlText = bg:Add( 'fcdDTextEntry' )
	mdlText:SetSize( w - 10, 25 )
	mdlText:SetPos( 5, y )
	mdlText:SetText( dealer:GetModel() or '' )

	function mdlText:OnChange()
		data.dealerModel = self:GetValue()
	end

	y = y + 30

	local specific = bg:Add( 'DCheckBoxLabel' )
	specific:SetSize( 15, 15 )
	specific:SetPos( 5, y )
	specific:SetText( 'Specific vehicles dealer?' )
	specific:SetValue( dealer:GetisSpecific() and 1 or 0 )
	data.specificDealer = dealer:GetisSpecific()

	function specific:OnChange( val )
		data.specificDealer = val
	end

	y = y + 20

	local spawn = bg:Add( 'fcdDButton' )
	spawn:SetSize( w - 10, 50 )
	spawn:SetPos( 5, y )
	spawn.text = 'Spawn Platform'

	function spawn:DoClick()
		net.Start( 'fcd.spawnPlatform' )
			net.WriteString( dealerID )
		net.SendToServer()

		bg:Remove()
	end

	y = y + 55

	local apply = bg:Add( 'fcdDButton' )
	apply:SetSize( w - 10, 50 )
	apply:SetPos( 5, y )
	apply.text = 'Apply Changes'

	function apply:DoClick()
		bg:Remove()

		net.Start( 'fcd.applyChanges' )
			net.WriteTable( data )
			net.WriteString( dealerID )
		net.SendToServer()
	end
end

net.Receive( 'fcd.dealerAdminOpen', fcd.dealerAdmin )

local bg
local w, h = 375 , 130

function fcd.adminMenu()
	ownData = net.ReadTable()
	local x, y = ScrW() / 2 - ( w / 2 ), ScrH() / 2 - ( h / 2 )

	old = { x = x, y = y }

	if fcd.cfg.Modules[ 'auction' ] then
		h = 180
	end

	bg = vgui.Create( 'fcdDFrame' )
	bg:SetSize( w, h )
	bg:SetPos( x, y )
	bg:addCloseButton()
	bg.title = 'Fresh Car Dealer - Admin Menu'

	y = 30

	local plyManage = bg:Add( 'fcdDButton' )
	plyManage:SetSize( w - 10, 45 )
	plyManage:SetPos( 5, y )
	plyManage.text = 'Player Management'
	plyManage.textSize = 20

	function plyManage:DoClick()
		fcd.playerManagement()
	end

	y = y + 50

	local vehManage = bg:Add( 'fcdDButton' )
	vehManage:SetSize( w - 10, 45 )
	vehManage:SetPos( 5, y )
	vehManage.text = 'Vehicle Management'
	vehManage.textSize = 20

	function vehManage:DoClick()
		fcd.vehicleManagement()
	end

	y = y + 50

	if fcd.cfg.Modules[ 'auction' ] then 
		local aucManage = bg:Add( 'fcdDButton' )
		aucManage:SetSize( w - 10, 45 )
		aucManage:SetPos( 5, y )
		aucManage.text = 'Auction Management'
		aucManage.textSize = 20
	end
end

local plyPnl

function fcd.playerManagement()
	bg:MoveTo( -w, ScrH() / 2 - ( h / 2 ), fcd.clientVal( 'animationSpeed' ) )

	local w, h = 400, 235
	local x, y = ScrW() / 2 - ( w / 2 ), ScrH() / 2 - ( h / 2 )

	local plyManage = false

	local nbg = vgui.Create( 'fcdDFrame' )
	nbg:SetSize( w, h )
	nbg:SetPos( ScrW(), y )
	nbg:MoveTo( x, y, fcd.clientVal( 'animationSpeed' ) )
	nbg.title = 'Fresh Car Dealer - Player Management'

	local back = nbg:Add( 'fcdDButton' )
	back:SetSize( 50, 25 )
	back:SetPos( w - 50, 0 )
	back.text = 'Back'

	function back:DoClick()
		nbg:MoveTo( ScrW(), y, fcd.clientVal( 'animationSpeed' ) )
		timer.Simple( 0.3, function()
			nbg:Remove()
		end )

		bg:MoveTo( old.x, old.y, fcd.clientVal( 'animationSpeed' ) )
	end

	local pw, ph = w - 10, h - 35

	plyPnl = nbg:Add( 'fcdDPanel' )
	plyPnl:SetSize( pw, ph )
	plyPnl:SetPos( 5, 30 )

	local select = plyPnl:Add( 'fcdDComboBox' )
	select:SetSize( pw - 10, 25 )
	select:SetPos( 5, 5 )
	select:SetValue( 'Select a player' )

	for _, ply in pairs( player.GetAll() ) do
		select:AddChoice( ply:Name() .. ' | ' .. ply:SteamID() )
	end

	function select:OnSelect( int, val )
		for _, ply in pairs( player.GetAll() ) do
			if string.EndsWith( val, ply:SteamID() ) then
				plyManage = ply
				break
			end
		end

		if plyManage then
			fcd.managePlayer( plyManage )
		end
	end
end

local hPnl

function fcd.managePlayer( ply )
	if not ply then return end

	local w, h = plyPnl:GetSize()

	local toGive
	local toTake

	if ValidPanel( hPnl ) then
		hPnl:Remove()
	end

	hPnl = plyPnl:Add( 'fcdDPanel' )
	hPnl:SetSize( w, h - 35 )
	hPnl:SetPos( 0, 35 )

	function hPnl:Paint() end

	local vehSelect = hPnl:Add( 'fcdDComboBox' )
	vehSelect:SetSize( w - 10, 25 )
	vehSelect:SetPos( 5, 5 )
	vehSelect:SetValue( 'Select a vehicle to give' )

	for i, v in pairs( fcd.dataVehicles ) do
		for _, veh in pairs( ownData ) do
			if _ == ply:UniqueID() then
				if not table.HasValue( veh, i ) then
					vehSelect:AddChoice( i )
				end
			end
		end
	end

	local give = hPnl:Add( 'fcdDButton' )
	give:SetSize( w - 10, 45 )
	give:SetPos( 5, 35 )
	give.text = 'Give'
	give.textSize = 18
	give.clickable = false

	function give:DoClick()
		if self.clickable then
			net.Start( 'fcd.giveVehicle' )
				net.WriteString( toGive )
				net.WriteEntity( ply )
			net.SendToServer()
		end
	end

	function vehSelect:OnSelect( int, val )
		give.clickable = true
		toGive = val
	end

	local takeSelect = hPnl:Add( 'fcdDComboBox' )
	takeSelect:SetSize( w - 10, 25 )
	takeSelect:SetPos( 5, 85 )
	takeSelect:SetValue( 'Select a vehicle to take' )

	for _, veh in pairs( ownData[ ply:UniqueID() ] or {} ) do
		takeSelect:AddChoice( veh )
	end

	local take = hPnl:Add( 'fcdDButton' )
	take:SetSize( w - 10, 45 )
	take:SetPos( 5, 115 )
	take.text = 'Take'
	take.textSize = 18
	take.clickable = false

	function take:DoClick()
		if self.clickable then
			net.Start( 'fcd.takeVehicle' )
				net.WriteString( toTake )
				net.WriteEntity( ply )
			net.SendToServer()
		end
	end

	function takeSelect:OnSelect( int, val )
		take.clickable = true
		toTake = val
	end
end

local vehPnl

local w, h = 635, 475
local vW, vH = w - 10, h - 35

function fcd.vehicleManagement()
	bg:MoveTo( -w, ScrH() / 2 - ( h / 2 ), fcd.clientVal( 'animationSpeed' ) )

	local x, y = ScrW() / 2 - ( w / 2 ), ScrH() / 2 - ( h / 2 )

	local plyManage = false

	local nbg = vgui.Create( 'fcdDFrame' )
	nbg:SetSize( w, h )
	nbg:SetPos( ScrW(), y )
	nbg:MoveTo( x, y, fcd.clientVal( 'animationSpeed' ) )
	nbg.title = 'Fresh Car Dealer - Vehicle Management 					* = NEEDED'

	local back = nbg:Add( 'fcdDButton' )
	back:SetSize( 50, 25 )
	back:SetPos( w - 50, 0 )
	back.text = 'Back'

	function back:DoClick()
		nbg:MoveTo( ScrW(), y, fcd.clientVal( 'animationSpeed' ) )
		timer.Simple( 0.3, function()
			nbg:Remove()
		end )

		bg:MoveTo( old.x, old.y, fcd.clientVal( 'animationSpeed' ) )
	end

	vehPnl = nbg:Add( 'fcdDPanel' )
	vehPnl:SetSize( vW, vH )
	vehPnl:SetPos( 5, 30 )

	local vehSelect = vehPnl:Add( 'fcdDComboBox' )
	vehSelect:SetSize( vW - 10, 25 )
	vehSelect:SetPos( 5, 5 )
	vehSelect:SetValue( 'Select a vehicle to add/edit' )

	for _, v in pairs( list.Get( 'Vehicles' ) ) do
		vehSelect:AddChoice( _ )
	end

	function vehSelect:OnSelect( int, val )
		fcd.manageVehicle( val )
	end
end

local dataPnl

function fcd.manageVehicle( class )
	if not class then return end

	local data = fcd.getVehicleList( class )
	if not data then return end

	local toSend = {}

	if ValidPanel( dataPnl ) then
		dataPnl:Remove()
	end

	local dW, dH = vW - 10, vH - 40

	dataPnl = vehPnl:Add( 'fcdDPanel' )
	dataPnl:SetSize( dW, dH )
	dataPnl:SetPos( 5, 35 )

	local mdlPnl = dataPnl:Add( 'fcdDPanel' )
	mdlPnl:SetSize( dW / 2 - ( 5 / 2 ), dH / 2 )
	mdlPnl:SetPos( 0, 0 )

	local mdl = mdlPnl:Add( 'DModelPanel' )
	mdl:SetSize( mdlPnl:GetSize() )
	mdl:SetPos( 0, 0 )
	mdl:SetModel( data.Model or '' )

	fcd.fixMdlPos( mdl )

	local tW, tH = mdlPnl:GetSize()
	local y = 28

	local cfgPnl = dataPnl:Add( 'fcdDPanel' )
	cfgPnl:SetSize( tW, tH )
	cfgPnl:SetPos( dW / 2 + ( 5 / 2 ), 0 )

	function cfgPnl:PaintOver( w, h )
		local tY = 5
		draw.SimpleText( '* Price ( NUMBERS ONLY! )', 'fcd_font_18', w / 2, tY, fcd.clientVal( 'mainTextColor' ), 1 )

		tY = tY + 69
		draw.SimpleText( 'Rank Restrictions (Seperate with a "," only)', 'fcd_font_18', w / 2, tY, fcd.clientVal( 'mainTextColor' ), 1 )

		tY = tY + 69
		draw.SimpleText( 'Job Restrictions (Seperate with a "," only)', 'fcd_font_18', w / 2, tY, fcd.clientVal( 'mainTextColor' ), 1 )
	end

	local price = cfgPnl:Add( 'fcdDTextEntry' )
	price:SetSize( tW - 10, 25 )
	price:SetPos( 5, y )

	y = y + 69

	local rank = cfgPnl:Add( 'fcdDTextEntry' )
	rank:SetSize( tW - 10, 25 )
	rank:SetPos( 5, y )

	function rank:OnChange()
		if ( self:GetValue() == '' ) then  toSend.rankRestrict = nil return end

		local tbl = string.Explode( ',', self:GetValue() )
		toSend.rankRestrict = tbl
	end

	y = y + 69

	local job = cfgPnl:Add( 'fcdDTextEntry' )
	job:SetSize( tW - 10, 25 )
	job:SetPos( 5, y )

	function job:OnChange()
		if ( self:GetValue() == '' ) then  toSend.jobRestrict = nil return end

		local tbl = string.Explode( ',', self:GetValue() )
		toSend.jobRestrict = tbl
	end

	local otherPnl = dataPnl:Add( 'fcdDPanel' )
	otherPnl:SetSize( tW, tH - 5 )
	otherPnl:SetPos( 0, tH + 5 )

	function otherPnl:PaintOver( w, h )
		local tY = 5
		draw.SimpleText( 'Specific Dealers ( Dealer ID(s). Seperate with a "," )', 'fcd_font_18', w / 2, tY, fcd.clientVal( 'mainTextColor' ), 1 )

		tY = tY + 55
		draw.SimpleText( 'Restriction Fail Message', 'fcd_font_18', w / 2, tY, fcd.clientVal( 'mainTextColor' ), 1 )

		tY = tY + 55
		draw.SimpleText( 'Vehicle Category', 'fcd_font_18', w / 2, tY, fcd.clientVal( 'mainTextColor' ), 1 )
	end

	y = 28

	local specDealer = otherPnl:Add( 'fcdDTextEntry' )
	specDealer:SetSize( tW - 10, 25 )
	specDealer:SetPos( 5, y )

	function specDealer:OnChange()
		if ( self:GetValue() == '' ) then  toSend.specificDealer = nil return end

		local tbl = string.Explode( ',', self:GetValue() )
		toSend.specificDealer = tbl
	end

	y = y + 55

	local customFail = otherPnl:Add( 'fcdDTextEntry' )
	customFail:SetSize( tW - 10, 25 )
	customFail:SetPos( 5, y )

	function customFail:OnChange()
		if ( self:GetValue() == '' ) then toSend.failMsg = nil return end

		toSend.failMsg = self:GetValue()
	end

	y = y + 55

	local category = otherPnl:Add( 'fcdDTextEntry' )
	category:SetSize( tW - 10, 25 )
	category:SetPos( 5, y )

	function category:OnChange()
		if ( self:GetValue() == '' ) then toSend.category = nil return end

		toSend.category = self:GetValue()
	end

	y = y + 30

	local badge = otherPnl:Add( 'DCheckBoxLabel' )
	badge:SetSize( 15, 15 )
	badge:SetPos( 5, y )
	badge:SetText( 'VIP Only? (What displays on the menu)' )

	function badge:OnChange( val )

		toSend.isVip = val
	end

	if fcd.dataVehicles[ class ] then
		toSend.price = fcd.dataVehicles[ class ].price
		price:SetText( fcd.dataVehicles[ class ].price or 0 )

		if fcd.dataVehicles[ class ].rankRestrict then
			toSend.rankRestrict = fcd.dataVehicles[ class ].rankRestrict
			rank:SetText( string.Implode( ',', fcd.dataVehicles[ class ].rankRestrict ) )
		end

		if fcd.dataVehicles[ class ].jobRestrict then
			toSend.jobRestrict = fcd.dataVehicles[ class ].jobRestrict
			job:SetText( string.Implode( ',', fcd.dataVehicles[ class ].jobRestrict ) )
		end

		if fcd.dataVehicles[ class ].specificDealer then
			toSend.specificDealer = fcd.dataVehicles[ class ].specificDealer
			specDealer:SetText( string.Implode( ',', fcd.dataVehicles[ class ].specificDealer ) )
		end

		if fcd.dataVehicles[ class ].failMsg then
			toSend.failMsg = fcd.dataVehicles[ class ].failMsg
			customFail:SetText( fcd.dataVehicles[ class ].failMsg )
		end

		if fcd.dataVehicles[ class ].category then
			toSend.category = fcd.dataVehicles[ class ].category
			category:SetText( fcd.dataVehicles[ class ].category )
		end

		toSend.isVip = fcd.dataVehicles[ class ].isVip
		badge:SetValue( fcd.dataVehicles[ class ].isVip and 1 or 0 )
	end

	local managePnl = dataPnl:Add( 'fcdDPanel' )
	managePnl:SetSize( tW, tH - 5 )
	managePnl:SetPos( tW + 5, tH + 5 )

	local add = managePnl:Add( 'fcdDButton' )
	add:SetSize( tW - 10, tH / 2 - ( 15 / 2 ) - ( 5 / 2 ) )
	add:SetPos( 5, 5 )
	add.text = 'Add/Edit'
	add.textSize = 18
	add.clickable = false

	if price:GetValue() ~= '' then
		add.clickable = true
	end

	function price:OnChange()
		if ( self:GetValue() == '' ) then add.clickable = false return end

		toSend.price = tonumber( self:GetValue() )
		add.clickable = true
	end

	function add:DoClick()
		if not add.clickable then return end

		net.Start( 'fcd.addVehicle' )
			net.WriteTable( toSend )
			net.WriteString( class )
		net.SendToServer()
	end

	local delete = managePnl:Add( 'fcdDButton' )
	delete:SetSize( tW - 10, tH / 2 - ( 15 / 2 ) - ( 5 / 2 ) )
	delete:SetPos( 5, tH / 2 - ( 15 / 2 ) + 7.5 )
	delete.text = 'Delete'
	delete.textSize = 18
	delete.clickable = false

	if fcd.dataVehicles[ class ] then
		delete.clickable = true
	end

	function delete:DoClick()
		if not add.clickable then return end

		net.Start( 'fcd.removeVehicle' )
			net.WriteString( class )
		net.SendToServer()
	end
end

net.Receive( 'fcd.openAdmin', fcd.adminMenu )