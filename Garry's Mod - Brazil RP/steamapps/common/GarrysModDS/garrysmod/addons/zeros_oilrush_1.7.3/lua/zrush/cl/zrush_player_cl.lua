if not CLIENT then return end

zrush = zrush or {}
zrush.f = zrush.f or {}

CreateConVar("zrush_cl_vfx_updatedistance", "1000", {FCVAR_ARCHIVE})
CreateConVar("zrush_cl_vfx_particleeffects", "1", {FCVAR_ARCHIVE})
CreateConVar("zrush_cl_draw_ui", "1", {FCVAR_ARCHIVE})

function zrush.f.DrawUI()
	if GetConVar("zrush_cl_draw_ui"):GetInt() == 1  then
		return true
	else
		return false
	end
end


// Sends a net msg to the server that the player has fully initialized and removes itself
hook.Add("HUDPaint", "a.zrush.PlayerInit.HUDPaint", function()
	zrush.f.Debug("zrush_PlayerInit_HUDPaint")

	net.Start("zrush_Player_Initialize")
	net.SendToServer()

	hook.Remove("HUDPaint", "a.zrush.PlayerInit.HUDPaint")
end)
