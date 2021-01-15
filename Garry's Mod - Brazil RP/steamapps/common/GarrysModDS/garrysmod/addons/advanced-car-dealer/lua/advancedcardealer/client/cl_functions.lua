local CFG = AdvCarDealer.GetConfig

function AdvCarDealer.Speed( speed )
	local unit
	speed = speed or 0

	if CFG().TypeOfSpeed == 0 then -- MPH
		unit = "MPH"
	elseif CFG().TypeOfSpeed == 1 then -- KMH
		speed = speed * 1.60934
		unit = "KMH"
	end

	return speed, speed .. unit
end

function AdvCarDealer:ChatMessage( msg )
	chat.AddText( Color( 255, 140, 0, 255 ), "[Advanced Car Dealer] ", Color( 255, 255, 255, 255 ), msg )
end

--[[
	I let this global so it can be used by other scripts if they want to
]]

local metaPlayer = FindMetaTable( "Player" )

function metaPlayer:Lock()
	self.IsLocked = true
end

function metaPlayer:UnLock()
	self.IsLocked = false
end

hook.Add( "CreateMove", "PlayerLock.CreateMove", function( oCmd )
	if LocalPlayer().IsLocked then
		oCmd:ClearButtons()
		oCmd:ClearMovement()

		oCmd:SetMouseX( 0 )
		oCmd:SetMouseY( 0 )
	end
end )

hook.Add( "InputMouseApply", "PlayerLock.InputMouseApply", function( oCmd )
	if LocalPlayer().IsLocked then
		oCmd:SetMouseX( 0 )
		oCmd:SetMouseY( 0 )
		return true
	end
end )
