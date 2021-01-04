zfs = zfs or {}
zfs.f = zfs.f or {}


// Used for Debug
function zfs.f.Debug(mgs)
	if (zfs.config.Debug) then
		if istable(mgs) then
			print("[    DEBUG    ] Table Start >")
			PrintTable(mgs)
			print("[    DEBUG    ] Table End <")
		else
			print("[    DEBUG    ] " .. mgs)
		end
	end
end

if SERVER then

	util.AddNetworkString("zfs_Debug")
	function zfs.f.Debug_Sphere(pos,size,lifetime,color,ignorez)
		if zfs.config.Debug then
			debugoverlay.Sphere( pos, size, lifetime, color, ignorez )

			net.Start("zfs_Debug")
			net.WriteVector(pos)
			net.WriteColor(color)
			net.Broadcast()
		end
	end

end

if CLIENT then

	CreateConVar("zfs_cl_drawui", "1", {FCVAR_ARCHIVE})

	// Debug
	net.Receive("zfs_Debug", function(len, ply)
		local pos = net.ReadVector()
		local size = Vector(25, 25, 25)
		size:Mul(0.07)
		debugoverlay.Sphere(pos, 1, 15, zfs.default_colors["red07"], true)
	end)
end
