--[[
     MGangs 2 - GANGCHAT - (CL) Init
    Developed by Zephruz
]]

function MG2_GANGCHAT:ReceiveMessage(msg)
    if !(msg) then return end
    
    local gang = LocalPlayer():GetGang()

    if !(gang) then return end

    local prefix = self:GetChatPrefix()

    chat.AddText(Color(255,255,100), prefix .. " ", Color(255,255,255), msg)
end

--[[
    Networking
]]
net.Receive("mg2.gangChat.SendMessage",
function()
    local msg = net.ReadString()

    if !(msg) then return end

    MG2_GANGCHAT:ReceiveMessage(msg)
end)