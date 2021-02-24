-- RayHUD Owner: 76561198166995690
-- RayHUD Version: 1.1.3

local ply = LocalPlayer()

--[[-------------------------------------------------------------------------
Player overhead
---------------------------------------------------------------------------]]

local darkrpSpeachBubbleFunc
local hooksTbl = hook.GetTable()

if !hooksTbl["PostPlayerDraw"] or !hooksTbl["PostPlayerDraw"]["DarkRP_ChatIndicator"] then
	darkrpSpeachBubbleFunc = function(  ) end
else
	darkrpSpeachBubbleFunc = hooksTbl["PostPlayerDraw"]["DarkRP_ChatIndicator"]
end
hook.Remove("PostPlayerDraw", "DarkRP_ChatIndicator")

local playersToRender = {}

timer.Create("RayHUD:PlayerOverhead", 0.15, 0, function(  )
	playersToRender = {}
	local players = player.GetAll()

	for k,v in ipairs(players) do
		if !IsValid(v) or v == ply then continue end

		if ply:GetPos():DistToSqr( v:GetPos() ) < 300^2 or v:IsSpeaking() then
			table.insert(playersToRender, v)
		end
	end
end)

hook.Add("PostDrawTranslucentRenderables", "RayHUD:PostDrawTranslucentRenderables",function(  )
	for k,v in ipairs(playersToRender) do

		if !IsValid(v) or !v:Alive() or v:IsDormant() or (v:GetColor().a < 100 or v:GetNoDraw()) then continue end

		local eyeAngs = ply:EyeAngles()

		local name = v:Name()
		local jobname = "Unknown"
		local jobcolor = FlatUI.Colors.White
		local health = v:Health()
		local maxHealth = v:GetMaxHealth()
		local armor = v:Armor()
		local hasLicense = v:getDarkRPVar("HasGunlicense") or false
		local inVehicle = v:InVehicle()
		local eyePos = v:EyePos()

		jobname = v:getDarkRPVar("job") or "Unknown"
		jobcolor = team.GetColor(v:Team())

		surface.SetFont("RayHUD.2D3D:Name")
		local nameTextWidth = select(1, surface.GetTextSize(name))

		surface.SetFont("RayHUD.2D3D:Job")
		local jobTextWidth = select(1, surface.GetTextSize(jobname))

		cam.Start3D2D(Vector(eyePos.x, eyePos.y, v:GetPos().z) + (inVehicle and Vector(0,0,60) or Vector(0, 0, math.max(eyePos.z - v:GetPos().z + 27 * RayHUD.Scale, 55))), ply:InVehicle() and Angle(0,ply:GetVehicle():GetAngles().y + eyeAngs.y - 90,90) or Angle(0,eyeAngs.y - 90,90), 0.1)
			if !inVehicle then
				local ArmorMargin = -60

				local BarW = 180 * RayHUD.Scale
				local BarH = 16 * RayHUD.Scale

				local ArmorY = 166

				if v:Armor() > 0 then
					ArmorMargin = -10
					local ArmorVal = math.Clamp(armor, 1, 255) / 255

					surface.SetMaterial( FlatUI.Icons.Shield )
					surface.SetDrawColor( FlatUI.Colors.Armor )
					surface.DrawTexturedRect(-BarW / 2 - 42 * RayHUD.Scale / 2 - 3 * RayHUD.Scale, (ArmorY - 12) * RayHUD.Scale, 42 * RayHUD.Scale, 42 * RayHUD.Scale)

					draw.RoundedBox( 8, (-BarW + 42 * RayHUD.Scale) / 2, ArmorY * RayHUD.Scale, BarW, BarH, FlatUI.Colors.LightArmor )
					draw.RoundedBox( 8, (-BarW + 42 * RayHUD.Scale) / 2, ArmorY * RayHUD.Scale, BarW * ArmorVal, BarH, FlatUI.Colors.Armor )
				end

				surface.SetDrawColor(v:getDarkRPVar("Arrested") == true and FlatUI.Colors.HP or color_white)
				surface.SetMaterial(v:IsSpeaking() and !v:IsMuted() and FlatUI.Icons.Sound or v:IsTyping() and FlatUI.Icons.Message or (v:getDarkRPVar("wanted") == true or v:getDarkRPVar("Arrested") == true) and FlatUI.Icons.Handcuffs or hasLicense and FlatUI.Icons.Pistol or FlatUI.Icons.User)	
				surface.DrawTexturedRect(-nameTextWidth / 2 - 64 * RayHUD.Scale / 2 - 4 * RayHUD.Scale, -ArmorMargin - 5 * RayHUD.Scale, 64 * RayHUD.Scale, 64 * RayHUD.Scale)

				draw.SimpleText(name, "RayHUD.2D3D:Name", -nameTextWidth / 2 + 64 * RayHUD.Scale / 2 + 4, -ArmorMargin, color_white)
				draw.SimpleText(jobname , "RayHUD.2D3D:Job", -jobTextWidth / 2, 60 * RayHUD.Scale - ArmorMargin, jobcolor)

				local HealthY = 116 - ArmorMargin
				local hl = math.Clamp(health, 1, maxHealth) / maxHealth
				local Var = math.Clamp(  math.abs( math.sin( CurTime() * 5 ) ), 0.75, 1 )
				local HPColor = FlatUI.Colors.HP
				if health <= 20 then
					HPColor = Color( Var * 198, Var * 40, Var * 40 )
				end

				surface.SetMaterial( FlatUI.Icons.Heart )
				surface.SetDrawColor( HPColor )
				surface.DrawTexturedRect(-BarW / 2 - 42 * RayHUD.Scale / 2 - 3 * RayHUD.Scale, (HealthY - 12) * RayHUD.Scale, 42 * RayHUD.Scale, 42 * RayHUD.Scale)

				draw.RoundedBox( 8, (-BarW + 42 * RayHUD.Scale) / 2, HealthY * RayHUD.Scale, BarW, BarH, FlatUI.Colors.LightHP )
				draw.RoundedBox( 8, (-BarW + 42 * RayHUD.Scale) / 2, HealthY * RayHUD.Scale, BarW * hl, BarH, HPColor )
			end
		cam.End3D2D()
	end
end)

--[[------------------------------
    2D3D Doors
--------------------------------]]

local Cache = {}

local function Draw2D3DDoor( door )

	-- Door position and angles

	local DoorData = {}
	local DoorAngles = door:GetAngles()

	if Cache[door] then
		DoorData = Cache[door]
	else
		local OBBMaxs = door:OBBMaxs()
		local OBBMins = door:OBBMins()
		local OBBCenter = door:OBBCenter()

		local size = OBBMins - OBBMaxs
		size = Vector(math.abs(size.x), math.abs(size.y), math.abs(size.z))

		local OBBCenterToWorld = door:LocalToWorld(OBBCenter)

		local TraceTbl = {
			endpos = OBBCenterToWorld,
			filter = function( ent )
				return !(ent:IsPlayer() or ent:IsWorld())
			end
		}

		local WidthOffset
		local HeightOffset = Vector(0, 0, 16)
		local DrawAngles

		local scale = 0.1
		
		local CanvasPos
		local CanvasPosReverse
		local canvasWidth

		if size.x > size.y then
			DrawAngles = Angle(0, 0, 90)
			TraceTbl.start = OBBCenterToWorld + door:GetRight() * (size.y / 2)

			local thickness = util.TraceLine(TraceTbl).Fraction * (size.y / 2) + 0.5
			WidthOffset = Vector(size.x / 2, thickness, 0)

			canvasWidth = size.x / scale
		else
			DrawAngles = Angle(0, 90, 90)
			TraceTbl.start = OBBCenterToWorld + door:GetForward() * (size.x / 2)

			local thickness = (1 - util.TraceLine(TraceTbl).Fraction) * (size.x / 2) + 0.5
			WidthOffset = Vector(-thickness, size.y / 2, 0)

			canvasWidth = size.y / scale
		end

		CanvasPos = OBBCenter - WidthOffset + HeightOffset
		CanvasPosReverse = OBBCenter + WidthOffset + HeightOffset

		DoorData = {
			DrawAngles = DrawAngles,
			CanvasPos = CanvasPos,
			CanvasPosReverse = CanvasPosReverse,
			scale = scale,
			canvasWidth = canvasWidth,
			start = TraceTbl.start
		}

		Cache[door] = DoorData
	end

	-- Door info

	local doorData = door:getDoorData()
	local doorHeader = ""
	local doorSubHeader = ""
	local extraText = {}

	if table.Count( doorData ) > 0 then

		if doorData.groupOwn then

			doorHeader = doorData.title or RayHUD.GetPhrase("group_door")
			doorSubHeader = string.Replace(RayHUD.GetPhrase("group_door_access"), "%G", doorData.groupOwn)

		elseif doorData.nonOwnable then

			doorHeader = doorData.title or ""

		elseif doorData.teamOwn then

			doorHeader = doorData.title or RayHUD.GetPhrase("team_door")
			doorSubHeader = string.Replace(RayHUD.GetPhrase("team_door_access"), "%J", table.Count(doorData.teamOwn))

			for k,_ in ipairs(doorData.teamOwn) do
				table.insert(extraText, team.GetName(k))
			end
		elseif doorData.owner then

			doorHeader = doorData.title or "Purchased door"
			local doorOwner = Player(doorData.owner)

			if IsValid(doorOwner) then
				doorSubHeader = string.Replace("Owner: %N", "%N", doorOwner:Name())
			else
				doorSubHeader = RayHUD.GetPhrase("owner_unknown")
			end

			if doorData.allowedToOwn then
				for k,v in ipairs(doorData.allowedToOwn) do

					doorData.allowedToOwn[k] = Player(k)

					if !IsValid(doorData.allowedToOwn[k]) then
						doorData.allowedToOwn[k] = nil
					end
				end

				if table.Count(doorData.allowedToOwn) > 0 then

					table.insert(extraText, RayHUD.GetPhrase("allowed_coowners"))

					for k,v in ipairs(doorData.allowedToOwn) do
						table.insert(extraText, v:Name())
					end

					table.insert(extraText, "")
				end

			end

			if doorData.extraOwners then

				for k,v in ipairs(doorData.extraOwners) do
					doorData.extraOwners[k] = Player(k)

					if !IsValid(doorData.extraOwners[k]) then
						doorData.extraOwners[k] = nil
					end
				end

				if table.Count(doorData.extraOwners) > 0 then
					table.insert(extraText, RayHUD.GetPhrase("door_coowners"))

					for k,v in ipairs(doorData.extraOwners) do
						table.insert(extraText,v:Name())
					end
				end
			end
		end
	else
		doorHeader = RayHUD.GetPhrase("for_sale")
		doorSubHeader = RayHUD.GetPhrase("purchase_door")
	end

	doorHeader = string.Left(doorHeader, 26)
	doorSubHeader = string.Left(doorSubHeader, 35)

	local function drawDoor( )
		-- Header
		draw.SimpleText(doorHeader, "RayHUD.2D3D:DoorHeader", DoorData.canvasWidth / 2, 0, FlatUI.Colors.White, TEXT_ALIGN_CENTER)

		-- Sub-Header
		draw.SimpleText(doorSubHeader, "RayHUD.2D3D:DoorSubHeader", DoorData.canvasWidth / 2, 50 * RayHUD.Scale, FlatUI.Colors.White, TEXT_ALIGN_CENTER)

		for i = 1,#extraText do
			local text = extraText[i]

			-- Additional info
			draw.SimpleText(text,"RayHUD.2D3D:DoorSubHeader", DoorData.canvasWidth / 2, 90 * RayHUD.Scale + i * 20 * RayHUD.Scale, FlatUI.Colors.White, TEXT_ALIGN_CENTER)
		end
	end

	cam.Start3D()
		cam.Start3D2D(door:LocalToWorld(DoorData.CanvasPos), DoorData.DrawAngles + DoorAngles, DoorData.scale)
			drawDoor()
		cam.End3D2D()

		cam.Start3D2D(door:LocalToWorld(DoorData.CanvasPosReverse), DoorData.DrawAngles + DoorAngles + Angle(0, 180, 0), DoorData.scale)
			drawDoor()
		cam.End3D2D()
	cam.End3D()
end

hook.Add("RenderScreenspaceEffects", "RayHUD:Draw2D3DDoor",function(  )
	local entities = ents.FindInSphere(ply:EyePos(), 280)

	for i = 1,#entities do
		local curEnt = entities[i]

		if curEnt:isDoor() and curEnt:GetClass() != "prop_dynamic" and !curEnt:GetNoDraw() then
			Draw2D3DDoor( curEnt )
		end
	end
end)