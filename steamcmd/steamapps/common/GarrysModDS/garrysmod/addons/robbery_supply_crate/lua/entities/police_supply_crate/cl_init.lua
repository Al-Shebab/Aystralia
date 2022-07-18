include( "shared.lua" )

function ENT:Initialize()
	self.LapCounter = 0
	self.RandomizedNum = 0
end

local color_green = Color( 0, 200, 0, 255 )
local color_black = Color( 0, 0, 0, 250 )

net.Receive( "CRATE_RestartCooldown", function( length, ply )
	local cooldowntime = CH_SupplyCrate.Config.RobberyCooldownTime * 60
	LocalPlayer().SupplyCrateCooldown = CurTime() + cooldowntime
end )

net.Receive( "CRATE_StopCooldown", function( length, ply )
	LocalPlayer().SupplyCrateCooldown = 0
end )

net.Receive( "CRATE_RestartTimer", function( length, ply )
	local countdowntime = CH_SupplyCrate.Config.RobberyAliveTime * 60
	local crate_ent = net.ReadEntity()
	
	LocalPlayer().SupplyCrateCountdown = CurTime() + countdowntime
	
	crate_ent.LapCounter = CurTime() + 1
	crate_ent.RandomizedNum = math.random( 4000, 80000 )
end )

net.Receive( "CRATE_StopTimer", function( length, ply )
	LocalPlayer().SupplyCrateCountdown = 0
end )

net.Receive( "CRATE_UpdateContent", function( length, ply )
	local crate = net.ReadEntity()
	local crate_money = net.ReadDouble()
	local crate_shipment = net.ReadDouble()
	local crate_ammo = net.ReadDouble()
	
	crate.CrateMoney = crate_money or 0
	crate.CrateShipments = crate_shipment or 0
	crate.CrateAmmo = crate_ammo or 0
end )

function ENT:DrawTranslucent()
	self:DrawModel()
	
	if LocalPlayer():GetPos():DistToSqr( self:GetPos() ) >= CH_SupplyCrate.Design.DistanceTo3D2D then
		return
	end
	
	-- Crate cooldown overhead text
	local pos = self:GetPos() + Vector( 0, 0, 70 )
	local PlayersAngle = LocalPlayer():GetAngles()
	local ang = Angle( 0, PlayersAngle.y - 180, 0 )
	
	ang:RotateAroundAxis( ang:Right(), -90 )
	ang:RotateAroundAxis( ang:Up(), 90 )
	
	cam.Start3D2D( pos, ang, 0.11 )
		if LocalPlayer().SupplyCrateCooldown and LocalPlayer().SupplyCrateCooldown > CurTime() then
			draw.SimpleTextOutlined( CH_SupplyCrate.Config.Lang["Robbery Cooldown"][CH_SupplyCrate.Config.Language], "CRATE_OverheadTitle", 0, -90, CH_SupplyCrate.Design.CooldownTextColor, 1, 1, 3, CH_SupplyCrate.Design.CooldownTextBoarder )
			
			draw.SimpleTextOutlined( string.ToMinutesSeconds( math.Round( LocalPlayer().SupplyCrateCooldown - CurTime() ) ), "CRATE_OverheadTitle", 0, -10, CH_SupplyCrate.Design.CooldownTimerTextColor, 1, 1, 3, CH_SupplyCrate.Design.CooldownTimerTextBoarder )
		end
    cam.End3D2D()
	
	-- The front panel
	if not self:GetAttachment( 1 ) then
		return
	end
	
	local PanelPos = self:GetAttachment( 1 ).Pos
	local PanelAng = self:GetAngles()
	
	PanelAng:RotateAroundAxis( PanelAng:Up(), 90 )
	PanelAng:RotateAroundAxis( PanelAng:Forward(), 90 )

	cam.Start3D2D( PanelPos, PanelAng, 0.035 )
		if not self.CrateShipments or not CH_SupplyCrate.Config.EnableShipmentLoot then
			draw.SimpleText( "0 ".. CH_SupplyCrate.Config.Lang["SHIPMENTS"][CH_SupplyCrate.Config.Language], "CRATE_PaperFont", 5, 15, color_black )
		else
			draw.SimpleText( self.CrateShipments .." ".. CH_SupplyCrate.Config.Lang["SHIPMENTS"][CH_SupplyCrate.Config.Language], "CRATE_PaperFont", 5, 15, color_black )
		end
		
		if not self.CrateAmmo or not CH_SupplyCrate.Config.EnableAmmoLoot then
			draw.SimpleText( "0 ".. CH_SupplyCrate.Config.Lang["ROUNDS"][CH_SupplyCrate.Config.Language], "CRATE_PaperFont", 5, 115, color_black )
		else
			draw.SimpleText( self.CrateAmmo .." ".. CH_SupplyCrate.Config.Lang["ROUNDS"][CH_SupplyCrate.Config.Language], "CRATE_PaperFont", 5, 115, color_black )
		end
		if not self.CrateMoney or not CH_SupplyCrate.Config.EnableMoneyLoot then
			draw.SimpleText( DarkRP.formatMoney( 0 ), "CRATE_PaperFont", 5, 215, color_black )
		else
			draw.SimpleText( DarkRP.formatMoney( self.CrateMoney ), "CRATE_PaperFont", 5, 215, color_black )
		end
	cam.End3D2D()
	
	-- The computer panel
	local ComPos = self:GetAttachment( 2 ).Pos
	local ComAng = self:GetAttachment( 2 ).Ang
	
	cam.Start3D2D( ComPos, ComAng, 0.035 )
		if LocalPlayer().SupplyCrateCountdown and LocalPlayer().SupplyCrateCountdown > CurTime() then
			draw.SimpleText( "CRAP-OS ".. self.RandomizedNum .." [Version ".. CH_SupplyCrate.ScriptVersion .."]", "CRATE_HackFont", 5, 5, color_green )
			
			if self.LapCounter and ( self.LapCounter ) < CurTime() then
				draw.SimpleText( "> ".. CH_SupplyCrate.Config.Lang["Logging in..."][CH_SupplyCrate.Config.Language], "CRATE_HackFont", 5, 30, color_green )
			end
			if self.LapCounter and ( self.LapCounter + 2 ) < CurTime() then
				draw.SimpleText( "> ".. CH_SupplyCrate.Config.Lang["Initializing system"][CH_SupplyCrate.Config.Language], "CRATE_HackFont", 5, 55, color_green )
			end
			if self.LapCounter and ( self.LapCounter + 4 ) < CurTime() then
				draw.SimpleText( "> ".. CH_SupplyCrate.Config.Lang["Executing keypad_hack.exe"][CH_SupplyCrate.Config.Language], "CRATE_HackFont", 5, 80, color_green )
			end
			
			if self.LapCounter and ( self.LapCounter + 5 ) < CurTime() then
				draw.SimpleText( string.ToMinutesSeconds( math.Round( LocalPlayer().SupplyCrateCountdown - CurTime() ) ), "CRATE_HackCountdownFont", 35, 125, color_green )
			end
		end
	cam.End3D2D()
end