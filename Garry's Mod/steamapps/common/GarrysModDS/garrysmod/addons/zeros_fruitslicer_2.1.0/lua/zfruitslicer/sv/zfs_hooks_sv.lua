if not SERVER then return end
zfs = zfs or {}
zfs.f = zfs.f or {}

// Here are some Hooks you can use for Custom Code

// Called when a player makes a smoothie
hook.Add("zfs_OnSmoothieMade", "zfs_OnSmoothieMade_Test", function(ply, Smoothie, SmoothieID)
	/*
	print("zfs_OnSmoothieMade")
	print("Player who made the Smoothie: " .. tostring(ply))
	print("Smoothie: " .. tostring(Smoothie))
	print("SmoothieID: " .. SmoothieID)
	print("SmoothiePrice: " .. Smoothie:GetPrice())
	print("////////////////")
	*/
end)

// Called when a player buys a smoothie
hook.Add("zfs_OnSmoothieSold", "zfs_OnSmoothieSold_Test", function(ply, Price, Smoothie, SmoothieID)
	/*
	print("zfs_OnSmoothieSold")
	print("Player who bought the Smoothie: " .. tostring(ply))
	print("Smoothie: " .. tostring(Smoothie))
	print("SmoothieID: " .. SmoothieID)
	print("Price: " .. Price)
	print("////////////////")
	*/
end)
