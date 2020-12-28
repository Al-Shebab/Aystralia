include("shared.lua")

local speed_f = AdvCarDealer.Speed
local sentences = AdvCarDealer.Language.Sentences[ AdvCarDealer.Language.Lang ]
local config = KVS.GetConfig
local font = KVS.GetFont

function ENT:Draw()

    self:DrawModel()

	local dist = LocalPlayer():GetPos():DistToSqr( self:GetPos() )
	
	if dist > 250000 then return end

	local angle = self:GetAngles()	
	local position = self:GetPos() + angle:Up() * 59.05 + angle:Right() * 9.3 + angle:Forward() * 8.1
	
	angle:RotateAroundAxis(angle:Forward(), -45 )
	angle:RotateAroundAxis(angle:Right(), 0 )
	angle:RotateAroundAxis(angle:Up(), 180 )

	local size_x, size_y = 162, 262

	cam.Start3D2D( position, angle, 0.1 )
		if IsValid( self.Menu ) then
			self.Menu:PaintManual()
		else
			draw.RoundedBox( 0, 0, 0, size_x, size_y, Color( 60, 60, 60, 255 ) )
			draw.SimpleText( sentences[ 62 ], "CarDealer.Rajdhani15", size_x / 2, size_y / 2 + math.sin( CurTime() * 3 ) * 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	cam.End3D2D()

end

function ENT:Initialize()
	sentences = sentences or AdvCarDealer.Language.Sentences[ AdvCarDealer.Language.Lang ]
	
	AdvCarDealer.StandList = AdvCarDealer.StandList or {}
	AdvCarDealer.StandList[ self:EntIndex() ] = self

	AdvCarDealer.StandInfos = AdvCarDealer.StandInfos or {}
	if AdvCarDealer.StandInfos[ self:EntIndex() ] then
		self:DrawMenu( AdvCarDealer.StandInfos[ self:EntIndex() ] )
	end
end

function ENT:OnRemove()
	AdvCarDealer.StandList = AdvCarDealer.StandList or {}
	AdvCarDealer.StandList[ self:EntIndex() ] = nil

	AdvCarDealer.StandInfos = AdvCarDealer.StandInfos or {}
	AdvCarDealer.StandInfos[ self:EntIndex() ]  = nil
end

function ENT:DrawMenu( vehicleInfos )
	if IsValid( self.Menu ) then
		self.Menu:Remove()
	end

	local vehicleInternalInformations = AdvCarDealer.GetCarInformations( vehicleInfos.className or vehicleInfos.model )

	if not vehicleInternalInformations or not istable( vehicleInternalInformations ) or table.IsEmpty( vehicleInternalInformations ) then return end

	local size_x, size_y = 162, 262

	local MainFrame = vgui.Create( "DFrame" )
	MainFrame:SetTitle( "" )
	MainFrame:SetSize( size_x, size_y )
	MainFrame:SetPaintedManually( true )
	MainFrame:ShowCloseButton( false )
	function MainFrame:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 200, 200, 255 ) )
	end

	local VehicleModel = vgui.Create( "SpawnIcon", MainFrame )
	VehicleModel:SetPos( 0, 0 )
	VehicleModel:SetSize( size_x, size_x )
	VehicleModel:SetModel( vehicleInfos.model, vehicleInfos.skin, vehicleInfos.bodygroup )
	local color = string.ToColor( vehicleInfos.color )
	VehicleModel:SetColor( Color( color.r, color.g, color.b, 255 ) ) -- TODO ca marche pas
	
	local titleMessage = vgui.Create( "DPanel", MainFrame )
	titleMessage:SetPos( 0, size_x )
	titleMessage:SetSize( size_x, 25 )
	function titleMessage:Paint( w, h )
		draw.SimpleText( vehicleInternalInformations.name, "CarDealer.Rajdhani15", w / 2, 0, AdvCarDealer.UIColors.text_grey, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	--local speed, speed_text = speed_f( vehicleInternalInformations.maxspeed )

	local contentInfos = vgui.Create( "DPanel", MainFrame )
	contentInfos:SetPos( 0, size_x + 25 )
	contentInfos:SetSize( size_x, size_y - ( size_x + 25 ) - 5 )
	function contentInfos:Paint( w, h )
		-- draw.SimpleText( utf8.char( 0xf3fd ) .. " " .. sentences[ 25 ] .. " : " .. speed_text, "CarDealer.Rajdhani10", 5, 0, AdvCarDealer.UIColors.text_grey, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		-- draw.SimpleText( utf8.char( 0xf63b ) .. " " .. sentences[ 26 ] .. " : " .. ( vehicleInternalInformations.maxrpm or 0 ), "CarDealer.Rajdhani10", 5, h / 2, AdvCarDealer.UIColors.text_grey, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		-- draw.SimpleText( utf8.char( 0xf6f0 ) .. " " .. sentences[ 27 ] .. " : " .. ( vehicleInternalInformations.horsepower or 0 ), "CarDealer.Rajdhani10", 5, h, AdvCarDealer.UIColors.text_grey, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
	end
	
	local leftBar = vgui.Create( "DPanel", contentInfos )
	leftBar:Dock( LEFT )
	leftBar:DockMargin( 20, 0, 0, 0 )
	leftBar:SetWide( ( contentInfos:GetWide() - 40 ) / 3 )
	function leftBar:Paint( w, h )
		local wi, ta = draw.SimpleText( utf8.char( 0xf3fd ), "CarDealer.FAS10", w / 2, h, AdvCarDealer.UIColors.text_grey, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
	
		local barTall = h - 13

		draw.RoundedBox( 3, w / 2 - 5, barTall * ( 1 - ( ( math.Clamp( vehicleInternalInformations.maxspeed or 0, 0, 150 ) ) / 150 ) ), 10, barTall * ( ( math.Clamp( vehicleInternalInformations.maxspeed or 0, 0, 150 ) ) / 150 ), AdvCarDealer.UIColors.text_red )
	
	end
	
	local centerBar = vgui.Create( "DPanel", contentInfos )
	centerBar:Dock( FILL )
	centerBar:DockMargin( 0, 0, 0, 0 )
	centerBar:SetWide( ( contentInfos:GetWide() - 40 ) / 3 )
	function centerBar:Paint( w, h )
		local wi, ta = draw.SimpleText( utf8.char( 0xf63b ), "CarDealer.FAS10", w / 2, h, AdvCarDealer.UIColors.text_grey, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
	
		local barTall = h - 13

		draw.RoundedBox( 3, w / 2 - 5, barTall * ( 1 - ( ( math.Clamp( vehicleInternalInformations.maxrpm or 0, 0, 7000 ) ) / 7000 ) ), 10, barTall * ( math.Clamp( vehicleInternalInformations.maxrpm or 0, 0, 7000 ) / 7000 ), AdvCarDealer.UIColors.light_blue )
	end
	
	local rightBar = vgui.Create( "DPanel", contentInfos )
	rightBar:Dock( RIGHT )
	rightBar:DockMargin( 0, 0, 20, 0 )
	rightBar:SetWide( ( contentInfos:GetWide() - 40 ) / 3 )
	function rightBar:Paint( w, h )
		local wi, ta = draw.SimpleText( utf8.char( 0xf6f0 ), "CarDealer.FAS10", w / 2, h, AdvCarDealer.UIColors.text_grey, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
	
		local barTall = h - 13

		draw.RoundedBox( 3, w / 2 - 5, barTall * ( 1 - ( ( math.Clamp( vehicleInternalInformations.horsepower or 0, 0, 1200 ) ) / 1200 ) ), 10, barTall * ( math.Clamp( vehicleInternalInformations.horsepower or 0, 0, 1200 ) / 1200 ), AdvCarDealer.UIColors.light_orange )
	end

	self.Menu = MainFrame 
end

function ENT:ClearMenu()
	if IsValid( self.Menu ) then
		self.Menu:Remove()
	end
end

function AdvCarDealer.OpenStandMenu( eStand )
	local size_x, size_y = 400, 150

	local dFrame = vgui.Create( "KVS.Frame" )
	dFrame:SetDraggable( false )
	dFrame:SetPos( ( ScrW() - size_x ) / 2, ScrH() )
	dFrame:MoveTo( ( ScrW() - size_x ) / 2, ( ScrH() - size_y ) / 2, 0.5 )
	dFrame:SetSize( size_x, size_y )
	dFrame:SetFont( "Montserrat" )
    dFrame:SetTitle( sentences[ 53 ] )
    dFrame:SetFrameIcon( font("FAS", 15, "extended"), 0xf108, color_white )
	dFrame:MakePopup()
	function dFrame:Paint( w, h )
	end

	local dBody = vgui.Create( "DPanel", dFrame )
	dBody:Dock( FILL )
	function dBody:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, AdvCarDealer.UIColors.background_tablet )
	end

	local selectedVehicle = NULL

	local dChooseVehicle = vgui.Create( "KVS.ComboBox", dBody )
	dChooseVehicle:SetSize( size_x * 0.8, size_y * 0.2 )
	dChooseVehicle:SetPos( size_x * 0.1, ( size_y - 80 ) / 2 - ( size_y * 0.2 / 2 ) )

	for _, eVehicle in pairs ( AdvCarDealer.ListVehiclesSpawned ) do
		if not IsValid( eVehicle ) then AdvCarDealer.ListVehiclesSpawned[ _ ] = nil continue end

		if not AdvCarDealer.RentedVehicles[ eVehicle:GetNWInt( "CreationID" ) ] then continue end

		local sData = eVehicle:GetVehicleClass() or eVehicle:GetModel()
		local tInfos = AdvCarDealer.GetCarInformations( sData )

		if not tInfos then continue end
		dChooseVehicle:AddChoice( tInfos.name, eVehicle )
	end

	dChooseVehicle:AddChoice( sentences[ 55 ] )
	dChooseVehicle:SetValue( sentences[ 55 ] )

	dChooseVehicle.OnSelect = function( self, index, value, data )
		selectedVehicle = data
	end

	local dSelect = vgui.Create( "KVS.Button", dFrame )
	dSelect:Dock( BOTTOM )
	dSelect:SetTall( 25 )
	dSelect:SetText( sentences[ 54 ] )
	dSelect:SetFont( font( "Montserrat Bold", 15 ) )
	function dSelect:DoClick()
		net.Start( "AdvCarDealer.SelectCarStand" )
			net.WriteEntity( eStand )
			net.WriteEntity( selectedVehicle )
		net.SendToServer()

		if IsValid( dFrame ) then
			dFrame:Close() 
		end
	end
end