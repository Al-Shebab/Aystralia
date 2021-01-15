include("shared.lua")

local CFG = AdvCarDealer.GetConfig
local font = KVS.GetFont
local config = KVS.GetConfig 

function ENT:Initialize()
	if not KVS then
		return
	end
		
	KVS:SetNPCName( self, self:GetGName(), 0xf494 )
end

local preventUpdate
function ENT:OpenPopupVehicleEdit( dFrame, id )
	local this = self
	local iID = self:GetID()
	local tConfig = CFG().JobGarage[ game.GetMap() ][ iID ].Vehicles[ id ]
	if not tConfig then return end
	
	if not tConfig.vehicle then CFG().JobGarage[ game.GetMap() ][ iID ].Vehicles[ id ] = nil return end
	if not tConfig.model then CFG().JobGarage[ game.GetMap() ][ iID ].Vehicles[ id ] = nil return end

	tConfig.color = tConfig.color or "255 255 255 255"
	tConfig.bodygroup = tConfig.bodygroup or "[]"

	local dPopupFrame = vgui.Create( "KVS.Frame", dFrame )
	dPopupFrame:SetSize( 400, 400 )
	dPopupFrame:SetPos( ScrW() / 2 - 200, ScrH() / 2 - 200 )
	dPopupFrame:SetTitle( "Vehicle edition" )
	dPopupFrame:MakePopup()
	function dPopupFrame:OnRemove()
		if preventUpdate then preventUpdate = false return end

		dFrame:Remove()
		this:OpenEditionMenu()
	end
	function dPopupFrame:Paint(w, h)
		Derma_DrawBackgroundBlur( self, self.startTime )
		draw.RoundedBox(4, 0, 0, w, h, config( "vgui.color.black_rhard" ) )
	end

	local dContainerPopup = vgui.Create( "KVS.ScrollPanel", dPopupFrame )
	dContainerPopup:Dock( FILL )

	local dVehicleModel = vgui.Create( "DModelPanel", dContainerPopup )
	dVehicleModel:Dock( TOP )
	dVehicleModel:DockMargin( 100, 5, 100, 5 )
	dVehicleModel:SetTall( 200 )	
	dVehicleModel.OldSetModel = dVehicleModel.SetModel
	function dVehicleModel:SetModel( sModel )
		self:OldSetModel( sModel )
		local mn, mx = self.Entity:GetRenderBounds()
		local size = 0
		size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
		size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
		size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )
		self.LerpPos = 0
		function self:LayoutEntity(ent)
			if self:IsDown() then
				local xCursPos, yCursPos = self:CursorPos()
				if not self.xAng then self.xAng = xCursPos end

				self.LerpPos = Lerp(RealFrameTime()*4, self.LerpPos, xCursPos - 180)
				ent:SetAngles(Angle(0, self.LerpPos, 0))
			else
				self.xAng = nil
			end
		end
		self:SetFOV( 45 )
		self:SetCamPos( Vector( size, size, size ) )
		self:SetLookAt( ( mn + mx ) * 0.5 )
	end
	dVehicleModel:SetModel( tConfig.model )
	dVehicleModel:SetColor( string.ToColor( tConfig.color ) )
	
	local dInputName

	local dClassCombobox = vgui.Create( "KVS.ComboBox", dContainerPopup )
	dClassCombobox:Dock( TOP )
	dClassCombobox:DockMargin( 20, 5, 20, 5 )
	dClassCombobox:SetTall( 30 )
	dClassCombobox:SetValue( tConfig.vehicle or tConfig.model or "No class" )
	for sClass, tInfos in pairs( list.Get( "Vehicles" ) or {} ) do
		if not tInfos.Model or not tInfos.Name then continue end

		dClassCombobox:AddChoice( sClass )
	end	
	dClassCombobox.OnSelect = function( _, index, sValue, data )
		local tData = list.Get("Vehicles")[ sValue ]

		tConfig.vehicle = sValue
		tConfig.name = tData.Name or tConfig.name or "No name"
		tConfig.model = tData.Model or tConfig.model or "No name"
	
		if IsValid( self ) and self.OpenPopupVehicleEdit and IsValid( dFrame ) then
			self:OpenPopupVehicleEdit( dFrame, id )
		end

		preventUpdate = true
		dPopupFrame:Remove()
	end

	dInputName = vgui.Create( "KVS.Input", dContainerPopup )
	dInputName:Dock( TOP )
	dInputName:DockMargin( 20, 5, 20, 5 )
	dInputName:SetTall( 30 )
	dInputName:SetText( tConfig.name )
	dInputName.OnValueChange = function( self, sValue )
		tConfig.name = sValue 
	end

	local dVehicleColorInput = vgui.Create( "KVS.InputColor", dContainerPopup )
	dVehicleColorInput:Dock( TOP )
	dVehicleColorInput:DockMargin( 20, 5, 20, 10 )
	dVehicleColorInput:SetTall( 25 )
	dVehicleColorInput:SetColor( string.ToColor( tConfig.color ) )
	function dVehicleColorInput:OnValueChanged( color )
		tConfig.color = string.FromColor( color )
		if dVehicleModel then
			dVehicleModel:SetColor( color )
		end
	end

	if IsValid( dVehicleModel.Entity ) then
		local dSkinLabel = vgui.Create( "DLabel", dContainerPopup )
		dSkinLabel:Dock( TOP )
		dSkinLabel:DockMargin( 0, 2.5, 0, 0 )
		dSkinLabel:SetText( "Skin" )
		dSkinLabel:SetFont( font( "Montserrat Bold", 20 ) )
		dSkinLabel:SetContentAlignment( 8 )

		if tConfig.skin then
			dVehicleModel.Entity:SetSkin( tConfig.skin )
		end

		local dSkinCombobox = vgui.Create( "KVS.ComboBox", dContainerPopup )
		dSkinCombobox:Dock( TOP )
		dSkinCombobox:DockMargin( 20, 0, 20, 5 )
		dSkinCombobox:SetTall( 25 )
		dSkinCombobox:SetValue( dVehicleModel.Entity:GetSkin() or 1 )
		for i = 0, dVehicleModel.Entity:SkinCount() do
			dSkinCombobox:AddChoice( i )
		end
		dSkinCombobox.OnSelect = function( self, index, value )
			dVehicleModel.Entity:SetSkin( value )
			tConfig.skin = tonumber( value ) 
		end

		local oldBdgr = util.JSONToTable( tConfig.bodygroup )
		for k, v in pairs( dVehicleModel.Entity:GetBodyGroups() or {} ) do
			if v.id and oldBdgr[ v.id ] then 
				dVehicleModel.Entity:SetBodygroup( v.id, oldBdgr[ v.id ] )
			end
		end

		for _, tInfos in pairs( dVehicleModel.Entity:GetBodyGroups() ) do
			if not tInfos.submodels or not istable( tInfos.submodels ) or table.IsEmpty( tInfos.submodels ) then continue end
			if not tInfos.id then continue end
			if table.Count( tInfos.submodels ) < 2 then continue end

			local dBodygroupNameLabel = vgui.Create( "DLabel", dContainerPopup )
			dBodygroupNameLabel:Dock( TOP )
			dBodygroupNameLabel:DockMargin( 0, 2.5, 0, 0 )
			dBodygroupNameLabel:SetText( tInfos.name or "Bodygroup")
			dBodygroupNameLabel:SetFont( font( "Montserrat Bold", 20 ) )
			dBodygroupNameLabel:SetContentAlignment( 8 )

			local dBodygroupComobobox = vgui.Create( "KVS.ComboBox", dContainerPopup )
			dBodygroupComobobox:Dock( TOP )
			dBodygroupComobobox:DockMargin( 20, 0, 20, 5 )
			dBodygroupComobobox:SetTall( 25 )
			dBodygroupComobobox:SetValue( tInfos.submodels[ dVehicleModel.Entity:GetBodygroup( tInfos.id ) ] or dVehicleModel.Entity:GetBodygroup( tInfos.id ) )
			for iKey, sName in pairs( tInfos.submodels or {} ) do
				dBodygroupComobobox:AddChoice( sName, { id = iKey } )
			end
			dBodygroupComobobox.OnSelect = function( self, index, value, tData )
				dVehicleModel.Entity:SetBodygroup( tInfos.id, tData.id or 1 )
				local bdgr = {}

				for k, v in pairs( dVehicleModel.Entity:GetBodyGroups() ) do
					if not v.id then continue end

					bdgr[ v.id ] = dVehicleModel.Entity:GetBodygroup( v.id )
				end
				tConfig.bodygroup = util.TableToJSON( bdgr )
			end
		end
	end

	local dPriceLabel = vgui.Create( "DLabel", dContainerPopup )
	dPriceLabel:Dock( TOP )
	dPriceLabel:DockMargin( 0, 2.5, 0, 0 )
	dPriceLabel:SetText( "Price to take the car : " )
	dPriceLabel:SetFont( font( "Montserrat Bold", 20 ) )
	dPriceLabel:SetContentAlignment( 8 )

	local dPriceInput = vgui.Create( "KVS.Input", dContainerPopup )
	dPriceInput:Dock( TOP )
	dPriceInput:DockMargin( 20, 5, 20, 5 )
	dPriceInput:SetTall( 30 )
	dPriceInput:SetText( tConfig.price or 0 )
	dPriceInput:SetNumeric( true )
	dPriceInput.OnValueChange = function( self, value )
		tConfig.price = tonumber( value ) 
	end

	local dSave = vgui.Create( "KVS.Button", dPopupFrame )
	dSave:Dock( BOTTOM )
	dSave:DockMargin( 0, 0, 0, 0 )
	dSave:SetTall( 25 )
	dSave:SetText( "SAVE" )
	dSave:SetBorder( false, false, true, true )
	dSave:SetFont( font( "Montserrat Bold", 20 ) )
	function dSave:DoClick()
		dPopupFrame:Remove() 
	end
end

function ENT:OpenEditionMenu()
	local iID = self:GetID()
	if not iID then return end

	if not CFG().JobGarage or not CFG().JobGarage[ game.GetMap() ] or not CFG().JobGarage[ game.GetMap() ][ iID ] then return end

	local dFrame = vgui.Create( "KVS.Frame" )
	dFrame:SetSize( 450, 500 )
	dFrame:Center()
	dFrame:SetTitle( "Job car dealer" )
	dFrame:SetSubTitle( "Configuration" )
	dFrame:MakePopup()
	function dFrame:OnRemove()
		net.Start( "AdvCarDealer.EditConfig" )
			net.WriteUInt( 14, 8 )
			net.WriteUInt( iID, 12 )
			net.WriteTable( CFG().JobGarage[ game.GetMap() ][ iID ] )
		net.SendToServer()	
	end
	
	local dContainer = vgui.Create( "KVS.ScrollPanel", dFrame )
	dContainer:Dock( FILL )

	local dNameLabel = vgui.Create( "DLabel", dContainer )
	dNameLabel:Dock( TOP )
	dNameLabel:DockMargin( 5, 5, 5, 5 )
	dNameLabel:SetContentAlignment( 5 )
	dNameLabel:SetFont( font( "Montserrat Bold", 20 ) )
	dNameLabel:SetText( "NPC Name :" )
	dNameLabel:SetTall( 30 )

	local dNameInput = vgui.Create( "KVS.Input", dContainer )
	dNameInput:Dock( TOP )
	dNameInput:DockMargin( 20, 5, 20, 5 )
	dNameInput:SetNumeric( false )
	dNameInput:SetText( self:GetGName() )
	dNameInput.OnValueChange = function( _, value )
		CFG().JobGarage[ game.GetMap() ][ iID ].NPC.name = value
		KVS:SetNPCName( self, value, 0xf494 )
	end

	local dModelLabel = vgui.Create( "DLabel", dContainer )
	dModelLabel:Dock( TOP )
	dModelLabel:DockMargin( 5, 5, 5, 5 )
	dModelLabel:SetContentAlignment( 5 )
	dModelLabel:SetFont( font( "Montserrat Bold", 20 ) )
	dModelLabel:SetText( "NPC Model :" )
	dModelLabel:SetTall( 30 )

	local dModelInput = vgui.Create( "KVS.Input", dContainer )
	dModelInput:Dock( TOP )
	dModelInput:DockMargin( 20, 5, 20, 5 )
	dModelInput:SetNumeric( false )
	dModelInput:SetText( self:GetModel() )
	dModelInput.OnValueChange = function( _, value )
		CFG().JobGarage[ game.GetMap() ][ iID ].NPC.model = value
		self:SetModel( value )
	end

	CFG().JobGarage[ game.GetMap() ][ iID ].Jobs = CFG().JobGarage[ game.GetMap() ][ iID ].Jobs or {}

	local dJobsLabel = vgui.Create( "DLabel", dContainer )
	dJobsLabel:Dock( TOP )
	dJobsLabel:DockMargin( 5, 5, 5, 5 )
	dJobsLabel:SetContentAlignment( 5 )
	dJobsLabel:SetFont( font( "Montserrat Bold", 20 ) )
	dJobsLabel:SetText( "Job list :")
	dJobsLabel:SetTall( 30 )

	for k, v in pairs( CFG().JobGarage[ game.GetMap() ][ iID ].Jobs ) do
		local dJobComboBox = vgui.Create( "KVS.ComboBox", dContainer )
		dJobComboBox:Dock( TOP )
		dJobComboBox:DockMargin( 20, 5, 20, 0  )
		dJobComboBox:SetValue( v )
		for _, teamInfos in pairs( team.GetAllTeams() ) do
			dJobComboBox:AddChoice( teamInfos.Name )
		end 
		dJobComboBox.OnSelect = function( self, index, value )
			CFG().JobGarage[ game.GetMap() ][ iID ].Jobs[ k ] = value
		end

		local dRemoveButton = vgui.Create( "KVS.Button", dContainer )
		dRemoveButton:Dock( TOP )
		dRemoveButton:DockMargin( 20, 0, 20, 5 )
		dRemoveButton:SetTall( 20 )
		dRemoveButton:SetText( "REMOVE JOB" )
		dRemoveButton:SetBorder( false, false, true, true )
		dRemoveButton:SetColor( config( "vgui.color.refuse_red" ) )
		dRemoveButton:SetFont( font( "Montserrat Bold", 15 ) )
		dRemoveButton.DoClick = function()
			CFG().JobGarage[ game.GetMap() ][ iID ].Jobs[ k ] = nil
			dFrame:Remove()
			self:OpenEditionMenu()
		end
	end

	local dAddJobButton = vgui.Create( "KVS.Button", dContainer )
	dAddJobButton:Dock( TOP )
	dAddJobButton:DockMargin( 20, 5, 20, 5 )
	dAddJobButton:SetTall( 25 )
	dAddJobButton:SetText( "Add job" )
	dAddJobButton:SetFont( font( "Montserrat Bold", 15 ) )
	dAddJobButton.DoClick = function()
		CFG().JobGarage[ game.GetMap() ][ iID ].Jobs = CFG().JobGarage[ game.GetMap() ][ iID ].Jobs or {}
		table.insert( CFG().JobGarage[ game.GetMap() ][ iID ].Jobs, team.GetName( LocalPlayer():Team() ) )
		dFrame:Remove()
		self:OpenEditionMenu()
	end

	local dCollapsibleBrand = vgui.Create( "DCollapsibleCategory", dContainer )
	dCollapsibleBrand:Dock( TOP )
	dCollapsibleBrand:DockMargin( 20, 5, 20, 0 )
	dCollapsibleBrand:SetExpanded( 1 )
	dCollapsibleBrand:SetLabel( "Job vehicles" )

	local dBrandList = vgui.Create( "DListView", dCollapsibleBrand )
	dBrandList:Dock( FILL )
	dBrandList:SetMultiSelect( false )
	dBrandList:AddColumn( "ID" )
	dBrandList:AddColumn( "Name" )
	dBrandList:AddColumn( "Class" )

	for _, info in pairs( CFG().JobGarage[ game.GetMap() ][ iID ].Vehicles or {} ) do
		dBrandList:AddLine( _, info.name, info.vehicle )
	end

	dBrandList.OnRowRightClick = function( dBrandListPanel, lineID, line )
		local id_line = tonumber( line:GetColumnText( 1 ) )
		local menu = DermaMenu()
		menu:AddOption( "Remove", function() 
			CFG().JobGarage[ game.GetMap() ][ iID ].Vehicles = CFG().JobGarage[ game.GetMap() ][ iID ].Vehicles or {}
			CFG().JobGarage[ game.GetMap() ][ iID ].Vehicles[ id_line ] = nil 
			dBrandList:RemoveLine( lineID )
		end )
		menu:AddOption( "Edit", function() 
			self:OpenPopupVehicleEdit( dFrame, id_line )
		end )
		menu:Open()
	end

	local vehicleList = CFG().Vehicles

	local dAddVehicle = vgui.Create( "KVS.Button", dContainer )
	dAddVehicle:Dock( TOP )
	dAddVehicle:SetTall( 25 )
	dAddVehicle:SetText( "Add vehicle" )
	dAddVehicle:SetColor( config( "vgui.color.accept_green" ) )
	dAddVehicle:SetFont( font( "Montserrat Bold", 15 ) )
	dAddVehicle:SetBorder( false, false, true, true )
	dAddVehicle:DockMargin( 20, 0, 20, 0 )
	dAddVehicle.DoClick = function()
		for sClass, tInfos in pairs( list.Get( "Vehicles" ) or {} ) do
			if not sClass then continue end
			if not tInfos.Name or not tInfos.Model then continue end

			sClass = sClass
			CFG().JobGarage[ game.GetMap() ][ iID ].Vehicles = CFG().JobGarage[ game.GetMap() ][ iID ].Vehicles or {}
			local id = table.insert( CFG().JobGarage[ game.GetMap() ][ iID ].Vehicles, {
				bodygroup = "[]",
				color = "255 255 255 255",
				underglow = "",
				skin = 0,
				vehicle = sClass,
				model = tInfos.Model,
				price = 1000,
				name = tInfos.Name or "No name"
			} )
			
			if not id then return end

			self:OpenPopupVehicleEdit( dFrame, id )

			dCollapsibleBrand:SetContents( dBrandList )
			break
		end
	end

	dCollapsibleBrand:SetContents( dBrandList )

end