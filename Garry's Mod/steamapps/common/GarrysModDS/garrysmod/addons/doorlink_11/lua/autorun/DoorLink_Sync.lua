DoorLink = DoorLink or {}
DoorLink.Category = DoorLink.Category or {}

function Door_HasLink(doorent)
	local Index = doorent:EntIndex()
	
	for k,v in pairs(DoorLink.Category) do
		for a,b in pairs(v.Items) do
			if b == Index then
				return v
			end
		end
	end
	return false
end

if SERVER then
	util.AddNetworkString( "Doorlink_Update_C2S" )
	util.AddNetworkString( "Doorlink_Broadcast_S2C" )
	
	net.Receive( "Doorlink_Update_C2S", function( len,ply )
		local DATA = net.ReadTable()
		
		DoorLink = DATA or {}
		DoorLink.Category = DoorLink.Category or {}
		
		net.Start( "Doorlink_Broadcast_S2C" )
			net.WriteTable( DoorLink )
		net.Broadcast()
		
		SaveDoorLinkData()
	end)
	
	hook.Add( "PlayerInitialSpawn", "DoorLink Sync Data", function(ply)
		timer.Simple(1,function()
			if !ply or !ply:IsValid() then return end
				net.Start( "Doorlink_Broadcast_S2C" )
					net.WriteTable( DoorLink )
				net.Send(ply)
		end)
	end)
end

if CLIENT then
	function UpdateLinkData_C2S()
		net.Start( "Doorlink_Update_C2S" )
			net.WriteTable( DoorLink )
		net.SendToServer()
	end
	net.Receive( "Doorlink_Broadcast_S2C", function( len,ply )
		local DATA = net.ReadTable()
		DoorLink = DATA
		
		if DoorLink_EditorP and DoorLink_EditorP:IsValid() then
			DoorLink_EditorP:RefreshList()
		end
	end)
end
if SERVER then
	function SaveDoorLinkData()
		local Map = string.lower(game.GetMap())
		file.Write("doorlink/" .. Map .. ".txt", util.TableToJSON(DoorLink))
	end
	hook.Add("Initialize", "DoorLink Dir Check", function()
		file.CreateDir("doorlink")
	end)
	hook.Add( "InitPostEntity", "DoorLink Load", function(ply)
		local Map = string.lower(game.GetMap())
		local Data = {}
		if file.Exists( "doorlink/" .. Map .. ".txt" ,"DATA") then
			Data = util.JSONToTable(file.Read( "doorlink/" .. Map .. ".txt" ))
		end
		DoorLink = Data
		DoorLink.Category = DoorLink.Category or {}
	end)
end