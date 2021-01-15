zfs = zfs or {}
zfs.f = zfs.f or {}

// Sends a net msg to the server that the player has fully initialized and removes itself
hook.Add("HUDPaint", "a_zfs_PlayerInit_HUDPaint", function()
	zfs.f.Debug("zfs_PlayerInit_HUDPaint")

	net.Start("zfs_Player_Initialize")
	net.SendToServer()

	hook.Remove("HUDPaint", "a_zfs_PlayerInit_HUDPaint")
end)
