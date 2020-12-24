zfs = zfs or {}
zfs.f = zfs.f or {}
zfs.fruits = zfs.fruits or {}

zfs.fruits = {}
zfs.fruits["zfs_melon"] = true
zfs.fruits["zfs_banana"] = true
zfs.fruits["zfs_coconut"] = true
zfs.fruits["zfs_pomegranate"] = true
zfs.fruits["zfs_strawberry"] = true
zfs.fruits["zfs_kiwi"] = true
zfs.fruits["zfs_lemon"] = true
zfs.fruits["zfs_orange"] = true
zfs.fruits["zfs_apple"] = true

-- List of all the zfs Entities on the server
if zfs.EntList == nil then
	zfs.EntList = {}
end

function zfs.f.EntList_Add(ent)
	table.insert(zfs.EntList, ent)
end

if SERVER then


	concommand.Add("zfs_debug_EntList", function(ply, cmd, args)
		if IsValid(ply) and zfs.f.IsAdmin(ply) then
			PrintTable(zfs.EntList)
		end
	end)
end
