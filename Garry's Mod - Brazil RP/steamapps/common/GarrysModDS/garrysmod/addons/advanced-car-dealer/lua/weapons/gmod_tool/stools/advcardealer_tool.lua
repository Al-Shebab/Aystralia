-- a part of this is inspired from the code of Rubat, https://steamcommunity.com/sharedfiles/filedetails/?id=195065185
-- Thanks to him.

local CFG = AdvCarDealer.GetConfig
local font = KVS.GetFont
local config = KVS.GetConfig
local tCubes = {}

TOOL.Category = "Advanced Car Dealer"
TOOL.Name = "Advanced Car Dealer Tool"

if CLIENT then
	TOOL.Information = {
		{ name = "left" },
		{ name = "right" },
		{ name = "reload" },
		{ name = "reload_use", icon2 = "gui/e.png" },
		{ name = "use" }
	}
	language.Add( "tool.advcardealer_tool.name", "Advanced Car Dealer" )
	language.Add( "tool.advcardealer_tool.desc", "Configuration tool" )

	language.Add( "tool.advcardealer_tool.left", "Left click to place entity" )
	language.Add( "tool.advcardealer_tool.right", "Right click to remove entity" )
	language.Add( "tool.advcardealer_tool.use", "Rotate" )
	language.Add( "tool.advcardealer_tool.reload", "Next tool" )
	language.Add( "tool.advcardealer_tool.reload_use", "Previous tool" )

end

local function CheckAdmin( ply )
	if SERVER and not CFG().AdminUserGroups[ ply:GetUserGroup() ] then
		AdvCarDealer:ChatMessage( "You're not admin.", ply )
	end
	return CFG().AdminUserGroups[ ply:GetUserGroup() ]
end

local function CalculateCorners( max, min )
	local size = max - min 
	local x, y, z = size.x, size.y, size.z 
	return {
		max, 
		max - Vector(0,0,z),
		max - Vector(0,y,0),
		max - Vector(x,0,0),
		min + Vector(0,0,z),
		min + Vector(0,y,0),
		min + Vector(x,0,0),
		min
	}
end 

local function b_tonumber( bool )
	return (bool == true) and 1 or -1
end 

local function DrawCube( min, max )
	if not min or not max then return end

	local corners = CalculateCorners( max, min )
	local color = Color( 0, 255, 0 )

	cam.Start3D2D( max, Angle( 0, 0, 0 ), 1 ) 
		local x = ( b_tonumber( max.x < corners[4].x) * max:Distance(corners[4]) )
		local y = ( b_tonumber( max.y > corners[3].y) * max:Distance(corners[3]) )

		surface.SetDrawColor( Color(color.r, color.g, color.b, 100) )
		surface.DrawRect( 0, 0, x, y )
		surface.SetDrawColor( Color(color.r, color.g, color.b, 255) )
		surface.DrawOutlinedRect( 0, 0, x, y )
	cam.End3D2D()

	cam.Start3D2D( max, Angle( 0, 0, 90 ), 1 )
		local x = ( b_tonumber( max.x < corners[4].x ) * max:Distance(corners[4]) )
		local y = ( b_tonumber( max.z > corners[2].z ) * max:Distance(corners[2]) )

		surface.SetDrawColor( Color(color.r, color.g, color.b, 100) )
		surface.DrawRect( 0, 0, x, y )
		surface.SetDrawColor( Color(color.r, color.g, color.b, 255) )
		surface.DrawOutlinedRect( 0, 0, x, y )
	cam.End3D2D()

	cam.Start3D2D( max, Angle(90,0,0), 1 )
		local x = ( b_tonumber( max.z > corners[2].z) * max:Distance(corners[2]) )
		local y = ( b_tonumber( max.y > corners[3].y) * max:Distance(corners[3]) )

		surface.SetDrawColor( Color(color.r, color.g, color.b, 100) )
		surface.DrawRect( 0, 0, x, y )
		surface.SetDrawColor( Color(color.r, color.g, color.b, 255) )
		surface.DrawOutlinedRect( 0, 0, x, y )
	cam.End3D2D()

	cam.Start3D2D( min, Angle(0,0,0), 1 ) 
		local x = ( b_tonumber( min.x < corners[7].x) * min:Distance(corners[7]) )
		local y = ( b_tonumber( min.y > corners[6].y) * min:Distance(corners[6]) )

		surface.SetDrawColor( Color(color.r, color.g, color.b, 100) )
		surface.DrawRect( 0, 0, x, y )
		surface.SetDrawColor( Color(color.r, color.g, color.b, 255) )
		surface.DrawOutlinedRect( 0, 0, x, y )
	cam.End3D2D()

	cam.Start3D2D( min, Angle( 0, 0, 90 ), 1 ) 
		local x = ( b_tonumber( min.x < corners[7].x) * min:Distance(corners[7]) )
		local y = ( b_tonumber( min.z > corners[5].z) * min:Distance(corners[5]) )

		surface.SetDrawColor( Color(color.r, color.g, color.b, 100) )
		surface.DrawRect( 0, 0, x, y )
		surface.SetDrawColor( Color(color.r, color.g, color.b, 255) )
		surface.DrawOutlinedRect( 0, 0, x, y )
	cam.End3D2D()

	cam.Start3D2D( min, Angle(90,0,0), 1 ) 
		local x = ( b_tonumber( min.z > corners[5].z) * min:Distance(corners[5]) )
		local y = ( b_tonumber( min.y > corners[6].y) * min:Distance(corners[6]) )

		surface.SetDrawColor( Color(color.r, color.g, color.b, 100) )
		surface.DrawRect( 0, 0, x, y )
		surface.SetDrawColor( Color(color.r, color.g, color.b, 255) )
		surface.DrawOutlinedRect( 0, 0, x, y )
	cam.End3D2D()
end 

if CLIENT then
	hook.Add( "PostDrawOpaqueRenderables", "PostDrawOpaqueRenderables.ACD.Admintool", function()
		for _, tData in pairs( tCubes or {} ) do
			DrawCube( tData[1] or Vector(), tData[2] or Vector() )
		end
	end )
end 

local tToolEntitiesSaved = {
	[ "cardealer_garage" ] = {
		name = "Garage NPC",
		model = "models/gman.mdl",
	},
	[ "cardealer_printer" ] = {
		name = "Invoice printer",
		model = "models/stim/venatuss/car_dealer/ticket_printer.mdl",		
	},
	[ "cardealer_stand" ] = {
		name = "Stand",
		model = "models/stim/venatuss/car_dealer/stand.mdl",
	},
	[ "cardealer_tablet_ent" ] = {
		name = "Tablet",
		model = "models/stim/venatuss/car_dealer/tablet/tablet.mdl",
	},
	[ "cardealer_reseller" ] = {
		name = "Chop shop",
		model = "models/eli.mdl",
		dlc = true
	},
	[ "cardealer_custom_visual" ] = {
		name = "Customization zone",
		model = "models/hunter/blocks/cube4x8x025.mdl",
		dlc = true
	},
}

AdvCarDealer.ListOfTools = { 
	{
		name = "Job Car Dealer",
		onSelectTool = function( tool, tTool )
			if SERVER then return end
			if IsValid( tTool.Preview ) then tTool.Preview:Remove() end
			for _, eProp in pairs( tTool.Previews or {} ) do
				if IsValid( eProp ) then eProp:Remove() end
			end 

			tTool.Preview = ents.CreateClientProp()
			tTool.Preview:SetModel( "models/barney.mdl" )
			tTool.Preview:SetRenderMode( RENDERMODE_TRANSALPHA )
			tTool.Preview:SetColor( Color( 0, 255, 0, 150 ) )
			tTool.Preview:Spawn()
		end,
		onLeftClick = function( tool, tTool )
			if CLIENT then
				if not IsValid( tTool.Preview ) then return end

				if not tTool.NPCInfos then
					tTool.NPCInfos = {
						pos = tTool.Preview:GetPos(),
						ang = tTool.Preview:GetAngles(),
						preview = tTool.Preview
					}

					tTool.Preview = ents.CreateClientProp()
					tTool.Preview:SetModel( "models/hunter/blocks/cube4x8x025.mdl" )
					tTool.Preview:SetRenderMode( RENDERMODE_TRANSALPHA )
					tTool.Preview:SetColor( Color( 0, 255, 0, 150 ) )
					tTool.Preview:Spawn()
				else
					net.Start( "AdvCarDealer.EditConfig" )
						net.WriteUInt( 15, 8 )
						net.WriteVector( tTool.NPCInfos.pos or Vector() )
						net.WriteAngle( tTool.NPCInfos.ang or Angle() )
						net.WriteVector( tTool.Preview:GetPos() or Vector() )
						net.WriteAngle( tTool.Preview:GetAngles() or Angle() )
					net.SendToServer()
					
					if IsValid( tTool.NPCInfos.preview ) then
						tTool.NPCInfos.preview:Remove()
					end
					tTool.NPCInfos = nil
					tTool.Preview:SetModel( "models/barney.mdl" )
				end
			end
		end,
		onRightClick = function( tool, tTool )
			if SERVER then return end
	
			if tTool.NPCInfos and IsValid( tTool.NPCInfos.preview ) then
				tTool.NPCInfos.preview:Remove()
			end
			tTool.NPCInfos = nil
			tTool.Preview:SetModel( "models/barney.mdl" )
		end,
		onDeselectTool = function( tool, tTool )
			if SERVER then return end
		
			if IsValid( tTool.Preview ) then tTool.Preview:Remove() end
			if tTool.NPCInfos and IsValid( tTool.NPCInfos.preview ) then tTool.NPCInfos.preview:Remove() end

			tTool.NPCInfos = nil
		end,
		think = function( tool, tTool )
			if IsValid( tTool.Preview ) then
				if input.IsKeyDown( KEY_E ) then
					tTool.Preview.AngleAdded = ( tTool.Preview.AngleAdded or 0 ) + 1
				elseif input.IsMouseDown( MOUSE_RIGHT ) then
					if vgui.CursorVisible() then return end
					if CurTime() < ( tTool.LastMouse or CurTime() ) then return end

					tTool.LastMouse = CurTime() + 1

					local eEnt = LocalPlayer():GetEyeTrace().Entity

					if not IsValid( eEnt ) then return end

					if eEnt:GetClass() == "cardealer_garage_job" then
						local dPopup = vgui.Create( 'KVS.Popup' )
							:SetTitle( "Confirmation" )
							:SetContent( "Are you sure you want to do this? You will this Job car dealer." )
							:SetMainColor( config('vgui.color.dark_red') )
							:SetIcon( font( 'FAS', 50, 'extended' ), 0xf05a )
							:SetSize( 400, 200 )
							:SetBlur( true )
							:SetAcceptText( "Yes" )
							:SetDenyText( "No" )
							:MakePopup()
							:Center()
							:SetAnimation( true )
							:SetAnimationDelay( 0.2 )
						function dPopup:OnAccept()
							net.Start( "AdvCarDealer.EditConfig" )
								net.WriteUInt( 13, 8 )
								net.WriteUInt( eEnt.GetID and eEnt:GetID() or 0, 12)
							net.SendToServer()
							
							for _, eProp in pairs( tTool.Previews or {} ) do
								if IsValid( eProp ) then eProp:Remove() end
							end
						end
					end
				elseif input.IsMouseDown( MOUSE_LEFT ) then
					if vgui.CursorVisible() then return end
					if CurTime() < ( tTool.LastMouse or CurTime() ) then return end

					tTool.LastMouse = CurTime() + 1

					local eEnt = LocalPlayer():GetEyeTrace().Entity

					if not IsValid( eEnt ) then return end

					if eEnt:GetClass() == "cardealer_garage_job" then
						eEnt:OpenEditionMenu()
					end					
				end

				local tTrace = LocalPlayer():GetEyeTrace()

				tTool.Preview:SetPos( tTrace.HitPos )
				tTool.Preview:SetAngles( tTrace.HitNormal:Angle() + Angle( 90, 0, 0 ) + Angle( 0, tTool.Preview.AngleAdded or 0, 0 ) )
			end
		end,
		hud = function( tool, tTool )
			local eEnt = LocalPlayer():GetEyeTrace().Entity

			if not IsValid( eEnt ) then return end

			if eEnt:GetClass() == "cardealer_garage_job" then
				draw.SimpleText( "+ Left clic to edit", font( "Montserrat Bold", 18 ), ScrW() / 2, ScrH() / 2 - 12.5, AdvCarDealer.UIColors.light_blue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				draw.SimpleText( "- Right clic to remove", font( "Montserrat Bold", 18 ), ScrW() / 2, ScrH() / 2 + 12.5, AdvCarDealer.UIColors.light_orange, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		end
	},
	{
		name = "User management",
		onSelectTool = function( tool, tTool )
			
		end,
		onLeftClick = function( tool, tTool )
			if CLIENT then 
				tTool:OpenAdminMenu()
			end
		end,
		onRightClick = function( tool, tTool )
		end
	},
	{
		name = "Vehicles management",
		onSelectTool = function( tool, tTool )
			
		end,
		onLeftClick = function( tool, tTool )
			if CLIENT then 
				AdvCarDealer.AdminVehiclesMenu()
			end
		end,
		onRightClick = function( tool, tTool )
		end
	},
	{
		name = "Car Dealer's spawn point",
		onSelectTool = function( tool, tTool )
			if SERVER then return end
			if IsValid( tTool.Preview ) then tTool.Preview:Remove() end
			for _, eProp in pairs( tTool.Previews or {} ) do
				if IsValid( eProp ) then eProp:Remove() end
			end 

			tTool.Preview = ents.CreateClientProp()
			tTool.Preview:SetModel( "models/hunter/plates/plate3x7.mdl" )
			tTool.Preview:SetRenderMode( RENDERMODE_TRANSALPHA )
			tTool.Preview:SetColor( Color( 0, 255, 0, 150 ) )
			tTool.Preview:Spawn()

			if not CFG().CarDealerSpawns or not CFG().CarDealerSpawns[ game.GetMap() ] then return end

			tTool.Previews = {}

			local ePreview = ents.CreateClientProp()
			ePreview:SetModel( "models/hunter/plates/plate3x7.mdl" )
			ePreview:SetColor( Color( 0, 255, 0, 255 ) )
			ePreview:SetPos( CFG().CarDealerSpawns[ game.GetMap() ].pos )
			ePreview:SetAngles( CFG().CarDealerSpawns[ game.GetMap() ].ang )
			ePreview:Spawn()

			table.insert( tTool.Previews, ePreview )

		end,
		onLeftClick = function( tool, tTool )
			if CLIENT then
				if not IsValid( tTool.Preview ) then return end

				net.Start( "AdvCarDealer.EditConfig" )
					net.WriteUInt( 2, 8 )
					net.WriteVector( tTool.Preview:GetPos() )
					net.WriteAngle( tTool.Preview:GetAngles() )
				net.SendToServer()
			end

			tTool:NextToolFunction( 1 )
		end,
		onRightClick = function( tool, tTool )
			if CLIENT then
				local dPopup = vgui.Create( 'KVS.Popup' )
					:SetTitle( "Confirmation" )
					:SetContent( "Are you sure you want to do this? You will remove the spawn point you've placed before." )
					:SetMainColor( config('vgui.color.dark_red') )
					:SetIcon( font( 'FAS', 50, 'extended' ), 0xf05a )
					:SetSize( 400, 200 )
					:SetBlur( true )
					:SetAcceptText( "Yes" )
					:SetDenyText( "No" )
					:MakePopup()
					:Center()
					:SetAnimation( true )
					:SetAnimationDelay( 0.2 )
				function dPopup:OnAccept()
					net.Start( "AdvCarDealer.EditConfig" )
						net.WriteUInt( 10, 8 )
					net.SendToServer()
					
					for _, eProp in pairs( tTool.Previews or {} ) do
						if IsValid( eProp ) then eProp:Remove() end
					end
				end
			end
		end,
		onDeselectTool = function( tool, tTool )
			if IsValid( tTool.Preview ) then tTool.Preview:Remove() end

			for _, eProp in pairs( tTool.Previews or {} ) do
				if IsValid( eProp ) then eProp:Remove() end
			end
		end,
		think = function( tool, tTool )
			if IsValid( tTool.Preview ) then
				if input.IsKeyDown( KEY_E ) then
					tTool.Preview.AngleAdded = ( tTool.Preview.AngleAdded or 0 ) + 1
				end

				local tTrace = LocalPlayer():GetEyeTrace()

				tTool.Preview:SetPos( tTrace.HitPos )
				tTool.Preview:SetAngles( tTrace.HitNormal:Angle() + Angle( 90, 0, 0 ) + Angle( 0, tTool.Preview.AngleAdded or 0, 0 ) )
			end
		end,
	},
	{
		name = "Garage spawn points",
		onSelectTool = function( tool, tTool )
			if SERVER then return end
			if IsValid( tTool.Preview ) then tTool.Preview:Remove() end
			for _, eProp in pairs( tTool.Previews or {} ) do
				if IsValid( eProp ) then eProp:Remove() end
			end 

			tTool.Preview = ents.CreateClientProp()
			tTool.Preview:SetModel( "models/hunter/plates/plate3x7.mdl" )
			tTool.Preview:SetRenderMode( RENDERMODE_TRANSALPHA )
			tTool.Preview:SetColor( Color( 0, 255, 0, 150 ) )
			tTool.Preview:Spawn()

			if not CFG().GarageSpawns or not CFG().GarageSpawns[ game.GetMap() ] then return end

			tTool.Previews = {}

			for _, tData in pairs( CFG().GarageSpawns[ game.GetMap() ] or {} ) do
				local ePreview = ents.CreateClientProp()
				ePreview:SetModel( "models/hunter/plates/plate3x7.mdl" )
				ePreview:SetColor( Color( 0, 255, 0, 255 ) )
				ePreview:SetPos( tData.pos )
				ePreview:SetAngles( tData.ang )
				ePreview:Spawn()

				table.insert( tTool.Previews, ePreview )
			end

		end,
		onLeftClick = function( tool, tTool )
			if CLIENT then
				if not IsValid( tTool.Preview ) then return end

				net.Start( "AdvCarDealer.EditConfig" )
					net.WriteUInt( 3, 8 )
					net.WriteVector( tTool.Preview:GetPos() )
					net.WriteAngle( tTool.Preview:GetAngles() )
				net.SendToServer()

				local ePreview = ents.CreateClientProp()
				ePreview:SetModel( "models/hunter/plates/plate3x7.mdl" )
				ePreview:SetColor( Color( 0, 255, 0, 255 ) )
				ePreview:SetPos( tTool.Preview:GetPos() )
				ePreview:SetAngles( tTool.Preview:GetAngles() )
				ePreview:Spawn()

				table.insert( tTool.Previews, ePreview )
			end
		end,
		onRightClick = function( tool, tTool )
			if CLIENT then
				local dPopup = vgui.Create( 'KVS.Popup' )
					:SetTitle( "Confirmation" )
					:SetContent( "Are you sure you want to do this? You will remove every spawn points you've placed before." )
					:SetMainColor( config('vgui.color.dark_red') )
					:SetIcon( font( 'FAS', 50, 'extended' ), 0xf05a )
					:SetSize( 400, 200 )
					:SetBlur( true )
					:SetAcceptText( "Yes" )
					:SetDenyText( "No" )
					:MakePopup()
					:Center()
					:SetAnimation( true )
					:SetAnimationDelay( 0.2 )
				function dPopup:OnAccept()
					net.Start( "AdvCarDealer.EditConfig" )
						net.WriteUInt( 11, 8 )
					net.SendToServer()
					
					for _, eProp in pairs( tTool.Previews or {} ) do
						if IsValid( eProp ) then eProp:Remove() end
					end
				end
			end
		end,
		onDeselectTool = function( tool, tTool )
			if SERVER then return end
		
			if IsValid( tTool.Preview ) then tTool.Preview:Remove() end

			for _, eProp in pairs( tTool.Previews or {} ) do
				if IsValid( eProp ) then eProp:Remove() end
			end
		end,
		think = function( tool, tTool )
			if IsValid( tTool.Preview ) then
				if input.IsKeyDown( KEY_E ) then
					tTool.Preview.AngleAdded = ( tTool.Preview.AngleAdded or 0 ) + 1
				end

				local tTrace = LocalPlayer():GetEyeTrace()

				tTool.Preview:SetPos( tTrace.HitPos )
				tTool.Preview:SetAngles( tTrace.HitNormal:Angle() + Angle( 90, 0, 0 ) + Angle( 0, tTool.Preview.AngleAdded or 0, 0 ) )
			end
		end,
	},
	{
		name = "Garage zones",
		onSelectTool = function( tool, tTool )
			if SERVER then return end
			if IsValid( tTool.Preview ) then tTool.Preview:Remove() end
			for _, eProp in pairs( tTool.Previews or {} ) do
				if IsValid( eProp ) then eProp:Remove() end
			end 

			tTool.Preview = ents.CreateClientProp()
			tTool.Preview:SetModel( "models/hunter/blocks/cube025x025x025.mdl" )
			tTool.Preview:SetRenderMode( RENDERMODE_TRANSALPHA )
			tTool.Preview:SetColor( Color( 0, 255, 0, 150 ) )
			tTool.Preview:Spawn()

			if not CFG().GarageZones or not CFG().GarageZones[ game.GetMap() ] then return end

			for _, tData in pairs( CFG().GarageZones[ game.GetMap() ] or {} ) do
				table.insert( tCubes, { tData.pointA, tData.pointB } )
			end 
		end,
		onLeftClick = function( tool, tTool )
			if CLIENT then
				local tTrace = LocalPlayer():GetEyeTrace()
				if not tTool.Preview.ZoneA then
					tTool.Preview.ZoneA = tTrace.HitPos
				else
					net.Start( "AdvCarDealer.EditConfig" )
						net.WriteUInt( 4, 8 )
						net.WriteVector( tTool.Preview.ZoneA or Vector() )
						net.WriteVector( tTrace.HitPos + tTrace.HitNormal * 200 or Vector() )
					net.SendToServer()

					tCubes[ 0 ] = nil
					table.insert( tCubes, { tTool.Preview.ZoneA or Vector(), tTrace.HitPos + tTrace.HitNormal * 200 or Vector() } )
					tTool.Preview.ZoneA = nil
				end 
			end
		end,
		onRightClick = function( tool, tTool )
			if SERVER then return end

			if tTool and tTool.Preview and tTool.Preview.ZoneA then
				tTool.Preview.ZoneA = nil

				tCubes[ 0 ] = nil
			else
				local dPopup = vgui.Create( 'KVS.Popup' )
					:SetTitle( "Confirmation" )
					:SetContent( "Are you sure you want to do this? You will remove every zones you've placed before." )
					:SetMainColor( config('vgui.color.dark_red') )
					:SetIcon( font( 'FAS', 50, 'extended' ), 0xf05a )
					:SetSize( 400, 200 )
					:SetBlur( true )
					:SetAcceptText( "Yes" )
					:SetDenyText( "No" )
					:MakePopup()
					:Center()
					:SetAnimation( true )
					:SetAnimationDelay( 0.2 )
				function dPopup:OnAccept()
					net.Start( "AdvCarDealer.EditConfig" )
						net.WriteUInt( 5, 8 )
					net.SendToServer()

					tCubes = {}
				end
			end
		end,
		onDeselectTool = function( tool, tTool )
			if IsValid( tTool.Preview ) then tTool.Preview:Remove() end

			tCubes = {}
		end,
		think = function( tool, tTool )
			if IsValid( tTool.Preview ) then
				local tTrace = LocalPlayer():GetEyeTrace()

				if tTool.Preview.ZoneA then
					tCubes[0] = { tTool.Preview.ZoneA, tTrace.HitPos + tTrace.HitNormal * 200 }
					tTool.Preview:SetPos( tTrace.HitPos + tTrace.HitNormal * 200 )
				else
					tTool.Preview:SetPos( tTrace.HitPos )
				end
			end
		end,
	},
}

if SERVER then

util.AddNetworkString( "AdvCarDealer.EditConfig" )

net.Receive( "AdvCarDealer.EditConfig", function( len, pPlayer )
	if not CheckAdmin( pPlayer ) then return end

	local iType = net.ReadUInt( 8 )
	if iType == 1 then 
		local sClass = net.ReadString()
		local vPos, aAngle = net.ReadVector(), net.ReadAngle()

		CFG().EntitiesSpawns = CFG().EntitiesSpawns or {}
		CFG().EntitiesSpawns[ game.GetMap() ] = CFG().EntitiesSpawns[ game.GetMap() ] or {}
		CFG().EntitiesSpawns[ game.GetMap() ][ sClass ] = CFG().EntitiesSpawns[ game.GetMap() ][ sClass ] or {}
		table.insert( CFG().EntitiesSpawns[ game.GetMap() ][ sClass ], { pos = vPos, ang = aAngle } )

		AdvCarDealer:SaveConfiguration()

		local eEntity = ents.Create( sClass )
		if not IsValid( eEntity ) then return end
		eEntity:SetPos( vPos )
		eEntity:SetAngles( aAngle )
		eEntity:Spawn()
		
		local phys = eEntity:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion( false )
		end
		
		AdvCarDealer.EntitiesSpawned = AdvCarDealer.EntitiesSpawned or {}
		AdvCarDealer.EntitiesSpawned[ sClass ] = AdvCarDealer.EntitiesSpawned[ sClass ] or {}
		table.insert( AdvCarDealer.EntitiesSpawned[ sClass ], eEntity )
	elseif iType == 2 then
		local vPos, aAngle = net.ReadVector(), net.ReadAngle()

		CFG().CarDealerSpawns = CFG().CarDealerSpawns or {}
		CFG().CarDealerSpawns[ game.GetMap() ] = {
			pos = vPos,
			ang = aAngle
		}

		AdvCarDealer:SaveConfiguration()

	elseif iType == 3 then
		local vPos, aAngle = net.ReadVector(), net.ReadAngle()

		CFG().GarageSpawns = CFG().GarageSpawns or {}
		CFG().GarageSpawns[ game.GetMap() ] = CFG().GarageSpawns[ game.GetMap() ] or {}
		
		table.insert( CFG().GarageSpawns[ game.GetMap() ], {
			pos = vPos,
			ang = aAngle
		} )

		AdvCarDealer:SaveConfiguration()		
	elseif iType == 4 then
		local pointA, pointB = net.ReadVector(), net.ReadVector()

		CFG().GarageZones = CFG().GarageZones or {}
		CFG().GarageZones[ game.GetMap() ] = CFG().GarageZones[ game.GetMap() ] or {}
		
		table.insert( CFG().GarageZones[ game.GetMap() ], {
			pointA = pointA,
			pointB = pointB
		} )

		AdvCarDealer:SaveConfiguration()
	elseif iType == 5 then
		CFG().GarageZones = CFG().GarageZones or {}
		CFG().GarageZones[ game.GetMap() ] = {}

		AdvCarDealer:SaveConfiguration()
	elseif iType == 6 then
		local sBrand = net.ReadString()

		CFG().Vehicles = CFG().Vehicles or {}
		CFG().Vehicles[ sBrand ] = nil
		
		AdvCarDealer:SaveConfiguration()	
	elseif iType == 7 then
		local sBrand = net.ReadString()
		local sClass = net.ReadString()

		CFG().Vehicles = CFG().Vehicles or {}
		CFG().Vehicles[ sBrand ] = CFG().Vehicles[ sBrand ] or {}
		CFG().Vehicles[ sBrand ][ sClass ] = nil
		
		AdvCarDealer:SaveConfiguration()		
	elseif iType == 8 then
		local sBrand = net.ReadString()
		local sOldBrand = net.ReadString()

		CFG().Vehicles = CFG().Vehicles or {}
		CFG().Vehicles[ sBrand ] = CFG().Vehicles[ sBrand ] or {}

		if sOldBrand and CFG().Vehicles[ sOldBrand ] then
			CFG().Vehicles[ sBrand ] = CFG().Vehicles[ sOldBrand ]
			CFG().Vehicles[ sOldBrand ] = nil
		end
		
		AdvCarDealer:SaveConfiguration()	
	elseif iType == 9 then
		local sBrand = net.ReadString()
		local sClass = net.ReadString()
		local tInfos = net.ReadTable()

		if not sBrand or not sClass or not tInfos then return end

		CFG().Vehicles = CFG().Vehicles or {}
		CFG().Vehicles[ sBrand ] = CFG().Vehicles[ sBrand ] or {}

		CFG().Vehicles[ sBrand ][ sClass ] = tInfos or {}

	
		AdvCarDealer:SaveConfiguration()	
	elseif iType == 10 then
		CFG().CarDealerSpawns = CFG().CarDealerSpawns or {}
		CFG().CarDealerSpawns[ game.GetMap() ] = nil

		AdvCarDealer:SaveConfiguration()
	elseif iType == 11 then
		CFG().GarageSpawns = CFG().GarageSpawns or {}
		CFG().GarageSpawns[ game.GetMap() ] = nil

		AdvCarDealer:SaveConfiguration()
	elseif iType == 12 then
		local sClass = net.ReadString()

		CFG().EntitiesSpawns = CFG().EntitiesSpawns or {}
		CFG().EntitiesSpawns[ game.GetMap() ] = CFG().EntitiesSpawns[ game.GetMap() ] or {}
		CFG().EntitiesSpawns[ game.GetMap() ][ sClass ] = {}
		
		if  AdvCarDealer.EntitiesSpawned and  AdvCarDealer.EntitiesSpawned[ sClass ] then
			for _, eEnt in pairs( AdvCarDealer.EntitiesSpawned[ sClass ] or {} ) do
				if IsValid( eEnt ) then 
					eEnt:Remove()
				end 
			end 
		end

		AdvCarDealer:SaveConfiguration()
	elseif iType == 13 then
		local iID = net.ReadUInt( 12 )

		CFG().JobGarage = CFG().JobGarage or {}
		CFG().JobGarage[ game.GetMap() ] = CFG().JobGarage[ game.GetMap() ] or {}
		CFG().JobGarage[ game.GetMap() ][ iID ] = nil
		
		if  AdvCarDealer.JobGarageNPC and  AdvCarDealer.JobGarageNPC then
			for _, eEnt in pairs( AdvCarDealer.JobGarageNPC or {} ) do
				if IsValid( eEnt ) and isfunction( eEnt.GetID ) and eEnt:GetID() == iID then 
					eEnt:Remove()
				end 
			end 
		end

		AdvCarDealer:SaveConfiguration()
	elseif iType == 14 then
		local iID = net.ReadUInt( 12 ) or -1
		local tInfos = net.ReadTable() or {}

		CFG().JobGarage = CFG().JobGarage or {}
		CFG().JobGarage[ game.GetMap() ] = CFG().JobGarage[ game.GetMap() ] or {}
		CFG().JobGarage[ game.GetMap() ][ iID ] = tInfos or {}

		AdvCarDealer:SaveConfiguration()
	elseif iType == 15 then
		local vNPC = net.ReadVector()
		local aNPC = net.ReadAngle()
		local vGarage = net.ReadVector()
		local aGarage = net.ReadAngle()

		CFG().JobGarage = CFG().JobGarage or {}
		CFG().JobGarage[ game.GetMap() ] = CFG().JobGarage[ game.GetMap() ] or {}
		table.insert( CFG().JobGarage[ game.GetMap() ], {
			Jobs = {},
			NPC = {
				ang = aNPC,
				model = "models/barney.mdl",
				name = "Job Car Dealer",
				pos = vNPC
			},
			SpawnGarage = {
				ang = aGarage,
				pos = vGarage,
			},
			Vehicles = {}
		} )

		for _, eEnt in pairs( AdvCarDealer.JobGarageNPC or {} ) do
			if IsValid( eEnt ) then 
				eEnt:Remove()
			end
		end
		for iId, tInfos in pairs( CFG().JobGarage[ game.GetMap() ] ) do
			if not tInfos.NPC then continue end
			if not tInfos.SpawnGarage then continue end

			local ent = ents.Create( "cardealer_garage_job" )
			if not IsValid( ent ) then continue end
			ent:SetPos( tInfos.NPC.pos )
			ent:SetAngles( tInfos.NPC.ang )
			ent:Spawn()
			ent:SetModel( tInfos.NPC.model or "models/barney.mdl" )
			ent:SetGName( tInfos.NPC.name or "Job Garage" )
			ent:SetID( iId )
			ent.GarageSpawn = tInfos.SpawnGarage

			AdvCarDealer.JobGarageNPC = AdvCarDealer.JobGarageNPC or {}
			table.insert( AdvCarDealer.JobGarageNPC, ent )
		end

		AdvCarDealer:SaveConfiguration()
	end
end )

end

--[[---------------------------------------------------------
	Automatically load the tool to save entities
-----------------------------------------------------------]]
hook.Add( "Initialize", "Initialize.AdvCarDealer.Tool", function()
	for sClass, tInfos in pairs( tToolEntitiesSaved or {} ) do
		if tInfos.dlc and not AdvCarDealer.DLC1 then
			continue
		end

		table.insert( AdvCarDealer.ListOfTools, {
			name = tInfos.name or "",
			onSelectTool = function( tool, tTool )
				if SERVER then return end
				if IsValid( tTool.Preview ) then tTool.Preview:Remove() end
				for _, eProp in pairs( tTool.Previews or {} ) do
					if IsValid( eProp ) then eProp:Remove() end
				end 

				tTool.Preview = ents.CreateClientProp()
				tTool.Preview:SetModel( tInfos.model )
				tTool.Preview:SetRenderMode( RENDERMODE_TRANSALPHA )
				tTool.Preview:SetColor( Color( 0, 255, 0, 150 ) )
				tTool.Preview:Spawn()
			end,
			onLeftClick = function( tool, tTool )
				if SERVER then return end

				net.Start( "AdvCarDealer.EditConfig" )
					net.WriteUInt( 1, 8 )
					net.WriteString( sClass )
					net.WriteVector( tTool.Preview:GetPos() )
					net.WriteAngle( tTool.Preview:GetAngles() )
				net.SendToServer()
			end,
			onRightClick = function( tool, tTool )
				if CLIENT then
					local dPopup = vgui.Create( 'KVS.Popup' )
						:SetTitle( "Confirmation" )
						:SetContent( "Are you sure you want to do this? You will remove every " .. sClass .. " you've placed before." )
						:SetMainColor( config('vgui.color.dark_red') )
						:SetIcon( font( 'FAS', 50, 'extended' ), 0xf05a )
						:SetSize( 400, 200 )
						:SetBlur( true )
						:SetAcceptText( "Yes" )
						:SetDenyText( "No" )
						:MakePopup()
						:Center()
						:SetAnimation( true )
						:SetAnimationDelay( 0.2 )
					function dPopup:OnAccept()
						net.Start( "AdvCarDealer.EditConfig" )
							net.WriteUInt( 12, 8 )
							net.WriteString( sClass )
						net.SendToServer()
					end
				end
			end,
			onDeselectTool = function( tool, tTool )
				if IsValid( tTool.Preview ) then tTool.Preview:Remove() end
			end,
			think = function( tool, tTool )
				if IsValid( tTool.Preview ) then
					if input.IsKeyDown( KEY_E ) then
						tTool.Preview.AngleAdded = ( tTool.Preview.AngleAdded or 0 ) + 1
					end

					local tTrace = LocalPlayer():GetEyeTrace()

					tTool.Preview:SetPos( tTrace.HitPos )
					tTool.Preview:SetAngles( tTrace.HitNormal:Angle() + Angle( 90, 0, 0 ) + Angle( 0, tTool.Preview.AngleAdded or 0, 0 ) )
				end
			end,
		} )
	end
end )

local ListOfTools = AdvCarDealer.ListOfTools or {}

local tWeap

function TOOL:LeftClick()
	if not CheckAdmin( self:GetOwner() ) then self:Remove() AdvCarDealer:ChatMessage( "You're not admin." ) return end
	
	if ( self.nextLeftClick or 0 ) >= CurTime() then return end
	self.nextLeftClick = CurTime() + 0.5 

	local fCurrentTool = self:GetSelectedTool()
	if ListOfTools[ fCurrentTool ] and ListOfTools[ fCurrentTool ].onLeftClick and isfunction( ListOfTools[ fCurrentTool ].onLeftClick ) then
		ListOfTools[ fCurrentTool ].onLeftClick( self.Weapon, self )
	end
end

function TOOL:RightClick()
	if not CheckAdmin( self:GetOwner() ) then self:Remove() return end

	if ( self.nextRightClick or 0 ) >= CurTime() then return end
	self.nextRightClick = CurTime() + 0.5

	local fCurrentTool = self:GetSelectedTool()
	if ListOfTools[ fCurrentTool ] and ListOfTools[ fCurrentTool ].onRightClick and isfunction( ListOfTools[ fCurrentTool ].onRightClick ) then
		ListOfTools[ fCurrentTool ].onRightClick( self.Weapon, self )
	end
end

function TOOL:NextToolFunction( add )
	if not CheckAdmin( self:GetOwner() ) then self:Remove() AdvCarDealer:ChatMessage( "You're not admin." ) return end

	local fCurrentTool = self:GetWeapon():GetNWInt( "AdvCarDealer.Tool", 1 )
	if not ListOfTools or not fCurrentTool or not ListOfTools[ fCurrentTool ] then return end

	if ListOfTools[ fCurrentTool ].onDeselectTool and isfunction( ListOfTools[ fCurrentTool ].onDeselectTool ) then
		ListOfTools[ fCurrentTool ].onDeselectTool( self.Weapon, self )
	end

	if ( fCurrentTool + add > #ListOfTools ) then fCurrentTool = 0 end
	if ( fCurrentTool + add < 1 ) then fCurrentTool = #ListOfTools + 1 end
	
	local fNewTool = fCurrentTool + add

	if ListOfTools[ fNewTool ] and ListOfTools[ fNewTool ].onSelectTool and isfunction( ListOfTools[ fNewTool ].onSelectTool ) then
		ListOfTools[ fNewTool ].onSelectTool( self.Weapon, self )
	end

	if SERVER then
		self:GetWeapon():SetNWInt( "AdvCarDealer.Tool", fNewTool )
	end
end

function TOOL:GetSelectedTool()
	return self:GetWeapon():GetNWInt( "AdvCarDealer.Tool", 1 )
end

function TOOL:Reload( tr )
	if not CheckAdmin( self:GetOwner() ) then self:Remove() AdvCarDealer:ChatMessage( "You're not admin." ) return end

	if ( self.nextReloadClick or 0 ) >= CurTime() then return end
	self.nextReloadClick = CurTime() + 0.1 

	if ( self:GetOwner():KeyDown( IN_USE ) ) then 
		self:NextToolFunction( -1 ) 
	else
		self:NextToolFunction( 1 )
	end

	self:GetWeapon():EmitSound( "weapons/pistol/pistol_empty.wav", 100, math.random( 50, 150 ) ) -- YOOOOY
	return false
end

function TOOL:Clear()
	local fCurrentTool = self:GetSelectedTool()
	if ListOfTools[ fCurrentTool ] and ListOfTools[ fCurrentTool ].onDeselectTool and isfunction( ListOfTools[ fCurrentTool ].onDeselectTool ) then
		ListOfTools[ fCurrentTool ].onDeselectTool( self.Weapon, self )
	end
end

function TOOL:Holster()
	self:Clear()
	
	tWeap = self
	self.bIsFirstUse = false
end

function TOOL:OnRemove()
	self:Clear()
end

local LastDown
function TOOL:Think()
	if not self.bIsFirstUse then
		self:NextToolFunction( 0 )
		self.bIsFirstUse = true
		tWeap = self
	end

	local fCurrentTool = self:GetSelectedTool()
	if ListOfTools[ fCurrentTool ] and ListOfTools[ fCurrentTool ].think and isfunction( ListOfTools[ fCurrentTool ].think ) then
		ListOfTools[ fCurrentTool ].think( self.Weapon, self )
	end
end

if SERVER then return end

local dAdminMainFrame

function TOOL:OpenAdminMenu()
	dAdminMainFrame = vgui.Create( "KVS.Frame" )
	dAdminMainFrame:SetDraggable( false )
	dAdminMainFrame:SetSize( 500, 330 )
	dAdminMainFrame:Center()
    dAdminMainFrame:SetFont("Montserrat")
    dAdminMainFrame:SetTitle( "Administration" )
	dAdminMainFrame:SetSubTitle( "User management" )
    dAdminMainFrame:SetFrameIcon( font("FAS", 15, "extended"), 0xf494, color_white )
	dAdminMainFrame:MakePopup()
	
	local dContentPanel = vgui.Create( "KVS.ScrollPanel", dAdminMainFrame )
	dContentPanel:Dock( FILL )

	dAdminMainFrame.dContentPanel = dContentPanel

	local dSteamIDLabel = vgui.Create( "DLabel", dContentPanel )
	dSteamIDLabel:Dock( TOP )
	dSteamIDLabel:DockMargin( 5, 0, 5, 0 )
	dSteamIDLabel:SetContentAlignment( 4 )
	dSteamIDLabel:SetFont( font( "Montserrat", 25 ) )
	dSteamIDLabel:SetText( "SteamID of the player :" )
	dSteamIDLabel:SetTall( 30 )
	dSteamIDLabel:SetWrap( true )
	dSteamIDLabel:SetTextColor( color_white )
	
	local dSteamIDEntry = vgui.Create( "KVS.Input", dContentPanel )
	dSteamIDEntry:Dock( TOP )
	dSteamIDEntry:DockMargin( 5, 5, 5, 0 )
	dSteamIDEntry:SetTall( 25 )
	dSteamIDEntry:SetNumeric( false )
	dSteamIDEntry:SetPlaceholderText( "SteamID..." )
	function dSteamIDEntry:OnEnter( sValue )
		net.Start( "AdvCarDealer.AskPlayerInformations" )
			net.WriteString( sValue )
		net.SendToServer()
	end

	local dButtonGeneral = vgui.Create( "KVS.Button", dContentPanel )
	dButtonGeneral:Dock( TOP )
	dButtonGeneral:DockMargin( 5, 5, 5, 0 )
	dButtonGeneral:SetFont( font( "Montserrat Bold", 20 ) )
	dButtonGeneral:SetTall( 25 )
	dButtonGeneral:SetText( "Search" )
	function dButtonGeneral:DoClick()
		net.Start( "AdvCarDealer.AskPlayerInformations" )
			net.WriteString( dSteamIDEntry:GetValue() )
		net.SendToServer()
	end
end

net.Receive( "AdvCarDealer.ReceivePlayerInformations", function()
	local tListInfos = net.ReadTable()
	local SteamID = net.ReadString()

	if IsValid( dAdminMainFrame ) and IsValid( dAdminMainFrame.dContentPanel ) then
	print("here")
		if IsValid( dAdminMainFrame.List ) then dAdminMainFrame.List:Remove() end

		local dCollapsibleVehicles = vgui.Create( "DCollapsibleCategory", dAdminMainFrame.dContentPanel )
		dCollapsibleVehicles:Dock( TOP )
		dCollapsibleVehicles:DockMargin( 5, 5, 5, 5 )
		dCollapsibleVehicles:SetExpanded( 1 )
		dCollapsibleVehicles:SetLabel( "List of vehicles" )

		local dListVehicles = vgui.Create( "DListView", dCollapsibleVehicles )
		dListVehicles:Dock( FILL )
		dListVehicles:SetMultiSelect( false )
		dListVehicles:AddColumn( "ID" )
		dListVehicles:AddColumn( "Name" )
		dListVehicles:AddColumn( "Class" )
		dListVehicles:AddColumn( "Color" )
		dListVehicles:AddColumn( "Underglow" )


		for _, tInfos in pairs( tListInfos ) do
			dListVehicles:AddLine( tInfos.id, ( AdvCarDealer.GetCarInformations( tInfos.vehicle ) and AdvCarDealer.GetCarInformations( tInfos.vehicle ).name ) or "Not available", tInfos.vehicle, tInfos.color, tInfos.underglow or "" )
		end

		dCollapsibleVehicles:SetContents( dListVehicles )

		function dListVehicles:OnRowRightClick( lineID, line )
			local menu = DermaMenu()
			menu:AddOption( "Remove", function() 
				dListVehicles:RemoveLine( lineID )
				net.Start( "AdvCarDealer.AdminRemoveVehicle" )
					net.WriteString( SteamID )
					net.WriteInt( tonumber( line:GetColumnText( 1 ) ), 32 )
				net.SendToServer()
			end )
			menu:Open()
		end

		dAdminMainFrame.List = dCollapsibleVehicles
	end
end )

function TOOL:DrawHUD()
	local fCurrentTool = self:GetSelectedTool()
	if ListOfTools[ fCurrentTool ] and ListOfTools[ fCurrentTool ].hud and isfunction( ListOfTools[ fCurrentTool ].hud ) then
		ListOfTools[ fCurrentTool ].hud( self.Weapon, self )
	end
end

function TOOL:DrawToolScreen( sw, sh )
	local w = 10
	local h = 10
	local lineH = 0

	for id, t in pairs( ListOfTools ) do
		surface.SetFont( font( "Rajdhani Bold", 40 ) )
		local tw, th = surface.GetTextSize( t.name )
		w = math.max( tw + 10, w )
		h = h + th
		lineH = th
	end

	local x = 0
	local y = 0
	local y = ( sh - h ) / 2 + math.cos( self:GetSelectedTool() / #ListOfTools * math.pi ) * ( h - sh ) / 2

	draw.RoundedBox( 4, 0, 0, sw, sh, Color( 0, 0, 0, 255 ) )

	for id, t in pairs( ListOfTools ) do
		if ( id == self:GetSelectedTool() ) then
			local clr = HSVToColor( 0, 0, 0.4 + math.sin( CurTime() * 4 ) * 0.1 )
			draw.RoundedBox( 0, 0, y + 5 + ( id - 1 ) * lineH, sw, lineH, clr )

			local a = surface.GetTextSize( t.name )
			if ( a > ( sw - 10 ) ) then
				x = -a + math.fmod( CurTime() * sw, sw + a )
			end
		else
			x = 0
		end
		draw.SimpleText( t.name, font( "Rajdhani Bold", 40 ), x + 5, y + 5 + ( id - 1 ) * lineH, Color( 255, 255, 255 ) )
	end
end
