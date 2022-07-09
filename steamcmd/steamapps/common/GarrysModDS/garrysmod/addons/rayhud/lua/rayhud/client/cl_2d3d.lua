-- RayHUD Owner: 76561198166995690
-- RayHUD Version: 1.2.5

local ply = LocalPlayer()

--[[-------------------------------------------------------------------------
Player overhead
---------------------------------------------------------------------------]]

local OverheadSettings = RayUI.Configuration.GetConfig( "OverheadHUD" )
local OverheadNumbers = RayUI.Configuration.GetConfig( "OverheadHUDNum" )


local darkrpSpeachBubbleFunc
local hooksTbl = hook.GetTable()

if !hooksTbl["PostPlayerDraw"] or !hooksTbl["PostPlayerDraw"]["DarkRP_ChatIndicator"] then
	darkrpSpeachBubbleFunc = function(  ) end
else
	darkrpSpeachBubbleFunc = hooksTbl["PostPlayerDraw"]["DarkRP_ChatIndicator"]
end
hook.Remove("PostPlayerDraw", "DarkRP_ChatIndicator")

if OverheadSettings != "Hide everything" then
	local playersToRender = {}

	timer.Create("RayHUD:PlayerOverhead", 0.15, 0, function()
		playersToRender = {}
		local players = player.GetAll()

		for k,v in ipairs(players) do
			if !IsValid(v) then continue end

			if ply:GetPos():DistToSqr( v:GetPos() ) < 300^2 or v:IsSpeaking() then
				table.insert(playersToRender, v)
			end
		end
	end)

	hook.Add("PostDrawTranslucentRenderables", "RayHUD:PostDrawTranslucentRenderables",function()
		for k,v in ipairs(playersToRender) do

			if !IsValid(v) or !v:Alive() or v:IsDormant() or (v:GetColor().a < 100 or v:GetNoDraw()) then continue end

			local eyeAngs = ply:EyeAngles()

			local name = (RayBoard and RayBoard:GetNick(v) or v:Name())
			local jobname = "Unknown"
			local jobcolor = RayUI.Colors.White
			local health = v:Health()
			local maxHealth = v:GetMaxHealth()
			local armor = v:Armor()
			local hasLicense = v:getDarkRPVar("HasGunlicense") or false
			local inVehicle = v:InVehicle()
			local eyePos = v:EyePos()

			jobname = v:getDarkRPVar("job") or "Unknown"
			jobcolor = team.GetColor(v:Team())

			surface.SetFont("RayUI:Largest5")
			local nameTextWidth = select(1, surface.GetTextSize(name))

			surface.SetFont("RayUI:Largest6")
			local jobTextWidth = select(1, surface.GetTextSize(jobname))


			local playerHOffset = 0

			if !inVehicle then
				playerHOffset = eyePos.z - v:GetPos().z
			end

			local NumOffset = 20 * RayUI.Scale

			if OverheadNumbers then
				NumOffset = 0
			end

			cam.Start3D2D(Vector(eyePos.x, eyePos.y, v:GetPos().z) + (inVehicle and Vector(0, 0, 60) or Vector(0, 0, math.max(playerHOffset + 18, 72 * RayUI.Scale))), ply:InVehicle() and Angle(0, ply:GetVehicle():GetAngles().y + eyeAngs.y - 90, 90) or Angle(0, eyeAngs.y - 90, 90), 0.1)
				if !inVehicle then
					local ArmorMargin = -20 * RayUI.Scale

					local BarW = 130 * RayUI.Scale
					local BarH = 10 * RayUI.Scale

					local ArmorY = 110 * RayUI.Scale

					if v:Armor() > 0 and OverheadSettings != "Hide HP and Armor" and OverheadSettings != "Show name only" then
						ArmorMargin = 10 * RayUI.Scale
						local ArmorVal = math.Clamp(armor, 1, 255) / 255
						local ArmorText = ""

						if OverheadNumbers then
							ArmorText = v:Armor() .. " / 255"
						end

						RayUI:CreateBar( (-BarW + 22 * RayUI.Scale) / 2, ArmorY, BarW, BarH, RayUI.Colors.LightArmor, RayUI.Colors.Armor, ArmorVal, ArmorText, RayUI.Icons.Shield )
					end

					if OverheadSettings != "Hide RP Name" then
						surface.SetMaterial(v:IsSpeaking() and !v:IsMuted() and RayUI.Icons.Sound or v:IsTyping() and RayUI.Icons.Message or (v:getDarkRPVar("wanted") == true or v:getDarkRPVar("Arrested") == true) and RayUI.Icons.Handcuffs or hasLicense and RayUI.Icons.Pistol or RayUI.Icons.User)	
						surface.SetDrawColor(color_black)
						surface.DrawTexturedRect(-nameTextWidth / 2 - 50 * RayUI.Scale / 2 - 4 * RayUI.Scale + 1, (-20 * RayUI.Scale - ArmorMargin) + 1 + NumOffset, 50 * RayUI.Scale, 50 * RayUI.Scale)

						surface.SetDrawColor(v:getDarkRPVar("Arrested") == true and RayUI.Colors.HP or color_white)
						surface.DrawTexturedRect(-nameTextWidth / 2 - 50 * RayUI.Scale / 2 - 4 * RayUI.Scale, (-20 * RayUI.Scale - ArmorMargin) + NumOffset, 50 * RayUI.Scale, 50 * RayUI.Scale)

						draw.SimpleText(name, "RayUI:Largest5", -nameTextWidth / 2 + 50 * RayUI.Scale / 2 + 1, (-20 * RayUI.Scale - ArmorMargin) + 1 + NumOffset, color_black)
						draw.SimpleText(name, "RayUI:Largest5", -nameTextWidth / 2 + 50 * RayUI.Scale / 2, (-20 * RayUI.Scale - ArmorMargin) + NumOffset, color_white)
					end

					if OverheadSettings != "Show name only" then
						draw.SimpleText(jobname , "RayUI:Largest6", -jobTextWidth / 2, (20 * RayUI.Scale - ArmorMargin) + 1 + NumOffset, color_black)
						draw.SimpleText(jobname , "RayUI:Largest6", -jobTextWidth / 2, (20 * RayUI.Scale - ArmorMargin) + NumOffset, jobcolor)
					end

					if OverheadSettings != "Hide HP and Armor" and OverheadSettings != "Show name only" then
						local HealthY = 80 * RayUI.Scale - ArmorMargin + NumOffset / 2
						local hl = math.Clamp(health, 1, maxHealth) / maxHealth
						local Var = math.Clamp(  math.abs( math.sin( CurTime() * 5 ) ), 0.75, 1 )
						local HPColor = RayUI.Colors.HP
						if health <= 20 then
							HPColor = Color( Var * 198, Var * 40, Var * 40 )
						end

						local HPText = ""

						if OverheadNumbers then
							HPText = RayUI.GetPhrase("hud", "health") .. ": " .. math.Clamp(v:Health(), 0, v:Health()) .. " / " .. v:GetMaxHealth()
						end

						RayUI:CreateBar( (-BarW + 22 * RayUI.Scale) / 2, HealthY, BarW, BarH, RayUI.Colors.LightHP, HPColor, hl, HPText, RayUI.Icons.Heart )
					end
				end
			cam.End3D2D()
		end
	end)

	hook.Add("RayHUD:Reload", "RayHUD:UnloadOverhead", function()
		hook.Remove("PostDrawTranslucentRenderables", "RayHUD:PostDrawTranslucentRenderables")
		timer.Remove("RayHUD:PlayerOverhead")
	end)
end

--[[------------------------------
    2D3D Doors
--------------------------------]]

local Cache = {}

local function Draw2D3DDoor( door )

	// Door position and angles
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

	// Door info
	local doorData = door:getDoorData()
	local doorHeader = ""
	local doorSubHeader = ""
	local extraText = {}

	if table.Count( doorData ) > 0 then

		if doorData.groupOwn then

			doorHeader = doorData.title or RayUI.GetPhrase("hud", "group_door")
			doorSubHeader = string.Replace(RayUI.GetPhrase("hud", "group_door_access"), "%G", doorData.groupOwn)

		elseif doorData.nonOwnable then

			doorHeader = doorData.title or ""

		elseif doorData.teamOwn then

			doorHeader = doorData.title or RayUI.GetPhrase("hud", "team_door")
			doorSubHeader = string.Replace(RayUI.GetPhrase("hud", "team_door_access"), "%J", table.Count(doorData.teamOwn))

			for k,_ in ipairs(doorData.teamOwn) do
				table.insert(extraText, team.GetName(k))
			end
		elseif doorData.owner then

			doorHeader = doorData.title or "Purchased door"
			local doorOwner = Player(doorData.owner)

			if IsValid(doorOwner) then
				doorSubHeader = string.Replace("Owner: %N", "%N", (RayBoard and RayBoard:GetNick(doorOwner) or doorOwner:Name()))
			else
				doorSubHeader = RayUI.GetPhrase("hud", "owner_unknown")
			end

			if doorData.allowedToOwn then
				for k,v in ipairs(doorData.allowedToOwn) do

					doorData.allowedToOwn[k] = Player(k)

					if !IsValid(doorData.allowedToOwn[k]) then
						doorData.allowedToOwn[k] = nil
					end
				end

				if table.Count(doorData.allowedToOwn) > 0 then

					table.insert(extraText, RayUI.GetPhrase("hud", "allowed_coowners"))

					for k,v in ipairs(doorData.allowedToOwn) do
						table.insert(extraText, (RayBoard and RayBoard:GetNick(v) or v:Name()))
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
					table.insert(extraText, RayUI.GetPhrase("hud", "door_coowners"))

					for k,v in ipairs(doorData.extraOwners) do
						table.insert(extraText, (RayBoard and RayBoard:GetNick(v) or v:Name()))
					end
				end
			end
		end
	else
		doorHeader = RayUI.GetPhrase("hud", "for_sale")
		doorSubHeader = RayUI.GetPhrase("hud", "purchase_door")
	end

	doorHeader = string.Left(doorHeader, 26)
	doorSubHeader = string.Left(doorSubHeader, 35)

	local function drawDoor( )
		// Header
		draw.SimpleText(doorHeader, "RayUI:Largest5", DoorData.canvasWidth / 2, 0, RayUI.Colors.White, TEXT_ALIGN_CENTER)

		// Sub-Header
		draw.SimpleText(doorSubHeader, "RayUI:Largest4", DoorData.canvasWidth / 2, 50 * RayUI.Scale, RayUI.Colors.White, TEXT_ALIGN_CENTER)

		for i = 1,#extraText do
			local text = extraText[i]

			// Additional info
			draw.SimpleText(text,"RayUI:Largest4", DoorData.canvasWidth / 2, 90 * RayUI.Scale + i * 20 * RayUI.Scale, RayUI.Colors.White, TEXT_ALIGN_CENTER)
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

		if curEnt:isDoor() and curEnt:GetClass() != "prop_dynamic" and !curEnt:GetNoDraw() and RayUI.Configuration.GetConfig( "DoorHUD" ) then
			Draw2D3DDoor( curEnt )
		end
	end
end)

hook.Add("RayHUD:Reload", "RayHUD:Unload2D3DDoor", function()
	hook.Remove("RenderScreenspaceEffects", "RayHUD:Draw2D3DDoor")
end)