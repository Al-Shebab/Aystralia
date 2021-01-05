if SERVER then util.AddNetworkString("Slawer.Mayor") end

Slawer.Mayor.NetsList = Slawer.Mayor.NetsList or {}

function Slawer.Mayor:NetReceive(strName, fnCallback)
	Slawer.Mayor.NetsList[strName] = fnCallback
end

function Slawer.Mayor:NetStart(strName, tblToSend, pTo)
	net.Start("Slawer.Mayor")
		net.WriteString(strName)
		net.WriteTable(tblToSend or {})
	if SERVER then
		if pTo then
			net.Send(pTo)
		else
			net.Broadcast()
		end
	else
		net.SendToServer()
	end
end

net.Receive("Slawer.Mayor", function(_, pSender)
	-- net delay
	if SERVER then
		pSender.lastMayorNetSent = pSender.lastMayorNetSent or 0
		if pSender.lastMayorNetSent > CurTime() then return end
		pSender.lastMayorNetSent = CurTime() + 0.2
	end

	local strName = net.ReadString()
	local tblToSend = net.ReadTable() or {}

	if !Slawer.Mayor.NetsList[strName] then return end

	if SERVER then
		Slawer.Mayor.NetsList[strName](pSender, tblToSend)
	else
		Slawer.Mayor.NetsList[strName](tblToSend)
	end
end)

--[[
	Serverside:

	Slawer.Mayor:NetReceive(string UniqueName, function(player Sender, table Information)
	end)

	Slawer.Mayor:NetStart(string UniqueName, table Parameters, pTo)


	Clientside:

	Slawer.Mayor:NetReceive(string UniqueName, function(table Information)
	end)

	Slawer.Mayor:NetStart(string UniqueName, table Parameters)
]]--