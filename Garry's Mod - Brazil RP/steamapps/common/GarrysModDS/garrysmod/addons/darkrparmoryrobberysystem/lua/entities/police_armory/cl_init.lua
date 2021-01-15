include( "shared.lua" )

net.Receive( "ARMORY_RestartCooldown", function( length, ply )
	local cooldowntime = net.ReadDouble()
	
	LocalPlayer().ArmoryCooldown = CurTime() + cooldowntime
end )

net.Receive( "ARMORY_KillCooldown", function( length, ply ) 
	LocalPlayer().ArmoryCooldown = 0
end )

net.Receive( "ARMORY_RestartCountdown", function( length, ply )
	local countdowntime = net.ReadDouble()
	
	LocalPlayer().ArmoryRobberyCountdown = CurTime() + countdowntime
end )

net.Receive( "ARMORY_KillCountdown", function( length, ply ) 
	LocalPlayer().ArmoryRobberyCountdown = 0
end )

function ENT:Initialize()
end

function ENT:Draw()
	self:DrawModel()
	
	local ARMORY_RequiredTeamsCount = 0
	local ARMORY_RequiredPlayersCounted = 0
	
	local pos = self:GetPos() + Vector(0, 0, 70)
	local PlayersAngle = LocalPlayer():GetAngles()
	local ang = Angle( 0, PlayersAngle.y - 180, 0 )
	
	ang:RotateAroundAxis(ang:Right(), -90)
	ang:RotateAroundAxis(ang:Up(), 90)
	
	cam.Start3D2D(pos, ang, 0.11)
		if LocalPlayer().ArmoryCooldown and LocalPlayer().ArmoryCooldown > CurTime() then
			draw.SimpleTextOutlined("Robbery Cooldown", "ARMORY_ScreenTextBig", 0, -115, CH_ArmoryRobbery.Design.CooldownTextColor, 1, 1, 2, CH_ArmoryRobbery.Design.CooldownTextBoarder)
			draw.SimpleTextOutlined(string.ToMinutesSeconds(math.Round(LocalPlayer().ArmoryCooldown - CurTime())), "ARMORY_ScreenText2", 0, -50, CH_ArmoryRobbery.Design.CooldownTimerTextColor, 1, 1, 2, CH_ArmoryRobbery.Design.CooldownTimerTextBoarder)
		elseif LocalPlayer().ArmoryRobberyCountdown and LocalPlayer().ArmoryRobberyCountdown > CurTime() then
			draw.SimpleTextOutlined("Robbery Countdown", "ARMORY_ScreenTextBig", 0, -115, CH_ArmoryRobbery.Design.CountdownTextColor, 1, 1, 2, CH_ArmoryRobbery.Design.CountdownTextBoarder)
			draw.SimpleTextOutlined(string.ToMinutesSeconds(math.Round(LocalPlayer().ArmoryRobberyCountdown - CurTime())), "ARMORY_ScreenText2", 0, -50, CH_ArmoryRobbery.Design.CountdownTimerTextColor, 1, 1, 2, CH_ArmoryRobbery.Design.CountdownTimerTextBoarder)
		else
			draw.SimpleTextOutlined("Police Armory", "ARMORY_ScreenTextHeader", 0, -120, CH_ArmoryRobbery.Design.ArmoryTextColor, 1, 1, 2, CH_ArmoryRobbery.Design.ArmoryTextBoarder)
			
			for k, v in pairs(player.GetAll()) do
				ARMORY_RequiredPlayersCounted = ARMORY_RequiredPlayersCounted + 1
				
				if table.HasValue( CH_ArmoryRobbery.Config.RequiredTeams, team.GetName(v:Team()) ) then
					ARMORY_RequiredTeamsCount = ARMORY_RequiredTeamsCount + 1
				end
				
				if ARMORY_RequiredPlayersCounted == #player.GetAll() then
					if ARMORY_RequiredTeamsCount >= CH_ArmoryRobbery.Config.PoliceRequired then
						draw.SimpleTextOutlined("Enough Police: Yes", "ARMORY_ScreenText", 0, -70, CH_ArmoryRobbery.Design.TheYes, 1, 1, 1, CH_ArmoryRobbery.Design.TheBoarder)
					else
						draw.SimpleTextOutlined("Enough Police: No ("..ARMORY_RequiredTeamsCount.."/".. CH_ArmoryRobbery.Config.PoliceRequired ..")", "ARMORY_ScreenText", 0, -70, CH_ArmoryRobbery.Design.TheNo, 1, 1, 1, CH_ArmoryRobbery.Design.TheBoarder)
					end
				end
			end
			if table.HasValue( CH_ArmoryRobbery.Config.AllowedTeams, team.GetName( LocalPlayer():Team() ) ) then
				draw.SimpleTextOutlined("Allowed Team: Yes", "ARMORY_ScreenText", 0, -40, CH_ArmoryRobbery.Design.TheYes, 1, 1, 1, CH_ArmoryRobbery.Design.TheBoarder)
			else
				draw.SimpleTextOutlined("Allowed Team: No", "ARMORY_ScreenText", 0, -40, CH_ArmoryRobbery.Design.TheNo, 1, 1, 1, CH_ArmoryRobbery.Design.TheBoarder)
			end
			if #player.GetAll() >= CH_ArmoryRobbery.Config.PlayerLimit then
				draw.SimpleTextOutlined("Enough Players: Yes", "ARMORY_ScreenText", 0, -10, CH_ArmoryRobbery.Design.TheYes, 1, 1, 1, CH_ArmoryRobbery.Design.TheBoarder)
			else
				draw.SimpleTextOutlined("Enough Players: No ("..#player.GetAll().."/"..CH_ArmoryRobbery.Config.PlayerLimit..")", "ARMORY_ScreenText", 0, -10, CH_ArmoryRobbery.Design.TheNo, 1, 1, 1, CH_ArmoryRobbery.Design.TheBoarder)
			end
		end
    cam.End3D2D()
end

local screenmodel = ClientsideModel("models/props/cs_office/TV_plasma.mdl", RENDERGROUP_TRANSLUCENT)
screenmodel:SetNoDraw(true)

local function DrawArmoryScreen() // front 1 back 2
	local armory = ents.FindByClass("police_armory")
	local scale = Vector( 1, 1, 1 )

	local mat = Matrix()
	mat:Scale(scale)
	screenmodel:EnableMatrix("RenderMultiply", mat)
	
	local eyePos = EyePos()
	
	local ArmoryMoneyAmount = GetGlobalInt( "ARMORY_MoneyAmount" )
	local ArmoryAmmoAmount = GetGlobalInt( "ARMORY_AmmoAmount" )
	local ArmoryShipmentAmount = GetGlobalInt( "ARMORY_ShipmentsAmount" )
	
	for i=1, #armory do
		if (armory[i]:GetPos()-eyePos):Length2DSqr() < 5923535 then
			
			local ang = armory[i]:GetAngles()
			ang:RotateAroundAxis(ang:Up(), 90)
			local textpos = armory[i]:GetPos() + ang:Right() * 15.2 + ang:Up() * 52
			local screenpos = armory[i]:GetPos() + ang:Right() * 10 + ang:Up() * 15

			ang:RotateAroundAxis(ang:Forward(), 90)

			local armoryangle = armory[i]:GetAngles()
			armoryangle:RotateAroundAxis(armoryangle:Forward(), 180)
			armoryangle:RotateAroundAxis(armoryangle:Forward(), 180)
			armoryangle:RotateAroundAxis(armoryangle:Right(), 90)
			
			local screenangle = armory[i]:GetAngles()
			screenmodel:SetRenderOrigin(screenpos)
			screenmodel:SetRenderAngles(screenangle)
			screenmodel:SetupBones()
			screenmodel:DrawModel()
			
			textpos = textpos + ang:Up()
			cam.Start3D2D(textpos, ang, 0.5)
				render.PushFilterMin(TEXFILTER.ANISOTROPIC)
					draw.RoundedBoxEx( 4, -60, 0, 117, 69, CH_ArmoryRobbery.Design.ScreenColor, false, false, false, false )
					-- boxes
					--                size, y, x, lenght, height
					draw.RoundedBoxEx( 4, -50, 10, 100, 25, CH_ArmoryRobbery.Design.ScreenBoxColor, false, false, false, false ) -- top left
					draw.RoundedBoxEx( 4, -50, 40, 50, 25, CH_ArmoryRobbery.Design.ScreenBoxColor, false, false, false, false ) -- bottom left
					draw.RoundedBoxEx( 4, 5, 40, 45, 25, CH_ArmoryRobbery.Design.ScreenBoxColor, false, false, false, false ) -- bottom right
				render.PopFilterMin()
			cam.End3D2D()
			
			cam.Start3D2D(textpos, ang, 0.11)
				render.PushFilterMin(TEXFILTER.ANISOTROPIC)
					draw.SimpleTextOutlined( "Money:", "ARMORY_ScreenText", 0, 70, CH_ArmoryRobbery.Design.MoneyTextColor, 1, 1, 1.4, CH_ArmoryRobbery.Design.MoneyTextBoarder)
					draw.SimpleTextOutlined( DarkRP.formatMoney( ArmoryMoneyAmount ), "ARMORY_ScreenTextBig", 0, 120, CH_ArmoryRobbery.Design.MoneyTextColor, 1, 1, 1, CH_ArmoryRobbery.Design.MoneyTextBoarder)
					
					draw.SimpleTextOutlined( "Ammo:", "ARMORY_ScreenText", -110, 205, CH_ArmoryRobbery.Design.AmmoTextColor, 1, 1, 1.4, CH_ArmoryRobbery.Design.AmmoTextBoarder)
					draw.SimpleTextOutlined( "x".. string.Comma( ArmoryAmmoAmount ), "ARMORY_ScreenTextBig", -110, 250, CH_ArmoryRobbery.Design.AmmoTextColor, 1, 1, 1, CH_ArmoryRobbery.Design.AmmoTextBoarder)
					
					draw.SimpleTextOutlined( "Shipments:", "ARMORY_ScreenText", 125, 205, CH_ArmoryRobbery.Design.ShipmentsTextColor, 1, 1, 1.4, CH_ArmoryRobbery.Design.ShipmentsTextBoarder)
					draw.SimpleTextOutlined( "x".. string.Comma( ArmoryShipmentAmount ), "ARMORY_ScreenTextBig", 125, 250, CH_ArmoryRobbery.Design.ShipmentsTextColor, 1, 1, 1, CH_ArmoryRobbery.Design.ShipmentsTextBoarder)
				render.PopFilterMin()
			cam.End3D2D()

		end
	end
end
hook.Add("PostDrawOpaqueRenderables", "DrawArmoryScreen", DrawArmoryScreen)