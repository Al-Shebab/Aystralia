--[[
     MGangs 2 - GANGCHAT - (SV) Init
    Developed by Zephruz
]]

--[[
    MG2_GANGCHAT:SendGangMessage(gangid [int], msg [string])

    - Sends a gang message to the online players
]]
function MG2_GANGCHAT:SendGangMessage(gangid, msg)
    local onlineMembers = mg2.gang:GetOnlineMembers(gangid)
    
    if (table.Count(onlineMembers) <= 0) then return end

    net.Start("mg2.gangChat.SendMessage")
        net.WriteString(msg)
    net.Send(onlineMembers)
end

--[[
    Chat commands
]]
zlib.cmds:RegisterChat({"!gangchat", "!gchat"}, nil,
function(ply, cmd, args)
    local gang = ply:GetGang()
    
    if (gang) then
        if (args[1] == cmd) then table.remove(args, 1) end

        local msgPfx = ply:Nick() .. ": "
        local msg = string.Trim(table.concat(args, " "))

        if (string.len(msg) > 0) then
            MG2_GANGCHAT:SendGangMessage(gang:GetID(), (msgPfx .. msg))
        end
    end
end)

--[[
    Networking
]]
util.AddNetworkString("mg2.gangChat.SendMessage")