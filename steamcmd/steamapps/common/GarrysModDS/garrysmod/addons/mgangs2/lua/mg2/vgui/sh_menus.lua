--[[
    MGangs 2 - (SH) MENUS
    Developed by Zephruz
]]

mg2.vgui.menus = (mg2.vgui.menus or {})

--[[
    mg2.vgui:RegisterMenu(name [string], data [table])
]]
function mg2.vgui:RegisterMenu(name, data)
    local menuTbl = {}

    zlib.object:SetMetatable("mg2.Menu", menuTbl)

    menuTbl:SetName(name)

    if (data) then
        for k,v in pairs(data) do
            menuTbl:setData(k,v)
        end
    end

    self.menus[name] = menuTbl

    return self.menus[name]
end

--[[
    mg2.vgui:GetMenu(name [string])
]]
function mg2.vgui:GetMenu(name)
    return self.menus[name]
end

--[[
    mg2.vgui:OpenMenu(ply [player], menuName [string], data [optional])
]]
function mg2.vgui:OpenMenu(ply, menuName, data)
    local menuTbl = self:GetMenu(menuName)

    if (!IsValid(ply) or !menuTbl) then return end

    local sendTbl = {menuName = menuName}

    if (data != nil) then sendTbl.data = data end

    netPoint:SendCompressedNetMessage("mg2.vgui.OpenMenu", ply, sendTbl)
end

--[[
    Menu Metastructure
]]
local menuMeta = zlib.object:Create("mg2.Menu", {})

menuMeta:setData("Name", "MENU.NAME", {})
menuMeta:setData("ChatCommands", {}, {
    postSet = function(s,val,oldVal)
        zlib.cmds:RegisterChat(val, nil,
        function(ply)
            mg2.vgui:OpenMenu(ply, s:GetName())
        end)
    end,
})
menuMeta:setData("ConsoleCommands", {}, {
    postSet = function(s,val,oldVal)
        zlib.cmds:RegisterConsole(val, function()
            s:Init()
        end)
    end,
})

function menuMeta:Init() end

function menuMeta:forceOpen(ply)
    mg2.vgui:ForceOpenMenu(ply, self:GetName())
end

--[[
    Includes
]]

-- Menus
local files, dirs = file.Find("mg2/vgui/menus/mg2_menu_*", "LUA")

for k,v in pairs(files) do
    zlib.util:IncludeByPath(v, "menus/")
end

--[[
    Networking
]]
if (SERVER) then
    util.AddNetworkString("mg2.vgui.OpenMenu")
end

if (CLIENT) then
    net.Receive("mg2.vgui.OpenMenu",
    function()
        local data, dataBInt = netPoint:DecompressNetData()

        if !(data) then return end

        local menuTbl = mg2.vgui:GetMenu(data.menuName)

        if (menuTbl) then
            if (data.data != nil && istable(data.data)) then
                for k,v in pairs(data.data) do
                    menuTbl:setRawData(k, v)
                end
            end

            menuTbl:Init()
        end
    end)
end