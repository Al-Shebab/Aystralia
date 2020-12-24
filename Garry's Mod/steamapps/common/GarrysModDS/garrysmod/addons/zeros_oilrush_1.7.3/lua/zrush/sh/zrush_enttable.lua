AddCSLuaFile()
zrush = zrush or {}
zrush.f = zrush.f or {}


// List of all the zrush Entities on the server
if zrush.EntList == nil then
	zrush.EntList = {}
end

function zrush.f.EntList_Add(ent)
	table.insert(zrush.EntList, ent)
end

function zrush.f.EntList_Remove(ent)
	table.RemoveByValue(zrush.EntList,ent)
end

if SERVER then
	concommand.Add("zrush_debug_EntList", function(ply, cmd, args)
		if zrush.f.IsAdmin(ply) then
			PrintTable(zrush.EntList)
		end
	end)
end
