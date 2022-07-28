--[[
    MGangs 2
    Developed by Zephruz
]]

mg2 = (mg2 or {})
mg2._version = "v2.8e"

function mg2:ConsoleMessage(...)
    MsgC(Color(125,255,0), "[MGangs] ", Color(255,255,255), ...)
    Msg("\n")
end

function mg2:Init()
    if (zlib) then
        zlib.util:IncludeByPath("sh_init.lua", "mg2/")

        mg2:ConsoleMessage("Loaded successfully!")
    end
end

--[[
    Includes
]]
local preReqs = {
    ["zlib"] = {
        autoRunFile = "autorun/zlib_auto.lua",
        notFoundMsg = "ZLib is not installed, please download it from here: https://github.com/zephruz/zlib/releases (Error: %s)",
        tbl = zlib,
        preventLoad = true
    },
    ["zdrm"] = {
        autoRunFile = "autorun/zdrm_auto.lua",
        notFoundMsg = "ZDRM not loaded, cannot load MGangs 2. (Error: %s)",
        tbl = zdrm,
        preventLoad = false
    }
}

local function loadAddon(name, autoRunFile, addonTable)
	if (addonTable == nil) then
		return pcall(include, autoRunFile) 
	end

	return true
end

for k,v in pairs(preReqs) do
    local res, errMsg = loadAddon(k, v.autoRunFile, v.tbl)

    if !(res) then
        mg2:ConsoleMessage(string.format(v.notFoundMsg, errMsg))

        if (v.preventLoad) then
            return
        end
    end
end

--[[
    ZLib Addon Registration
]]
local ZLIB_MG2ADDON = zlib.addons:Register("mg2")
ZLIB_MG2ADDON:SetName("mGangs 2")
ZLIB_MG2ADDON:SetDescription("Advanced gang addon.")
ZLIB_MG2ADDON:SetTable(mg2)
ZLIB_MG2ADDON:SetAddonID(5045)

--[[
    Initialize mG2
]]
mg2:Init()

hook.Add("zlib.Loaded", "mg2.zlib.Loaded", 
function() 
    mg2:Init() 
end)