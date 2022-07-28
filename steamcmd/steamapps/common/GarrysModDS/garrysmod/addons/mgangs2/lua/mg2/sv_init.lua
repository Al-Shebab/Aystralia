--[[
    MGangs 2 - (SV) Init
    Developed by Zephruz
]]

--[[
    mg2:SendNotification(ply [player or table of players], msg [string], icon [string = null])

    - Sends a notification to the player
]]
function mg2:SendNotification(ply, msg, icon)
    if (!IsValid(ply) or !msg) then return end

    zlib.notifs:Send(ply, msg, (icon or false))
end

--[[
    Load Migrations
]]
local migFiles, migDirs = file.Find("mg2/migrations/migration_*", "LUA")

for k,v in pairs(migFiles) do
    zlib.util:IncludeByPath(v, "migrations/")
end

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            local function regAddon() zdrm:register('5045', '{"idkey":"bimwjVdmDuNl8td8vOWQORcsihEkBCR3OAQ4UEIQL5KyZmtPwN","script":"5045","steamid":"76561198166995690"}', function(result, scid) MsgC((result && Color(0,255,0) || Color(255,0,0)), "[ZDRM]", Color(255,255,255), (result && "Loaded script" || "Unable to load script") + " : " + scid) end) end if (zdrm && zdrm._loaded) then regAddon() else hook.Add("zdrm.init", "5045[zdrm.init]", regAddon) end
