--[[ZDRM Developed by Zephruz]]
zdrm = (zdrm or {})
zdrm._version = "1.2"
zdrm.url = "https://zephruz.net/api/drm/"

function zdrm:Load()
    hook.Run("zdrm.Loaded", self)
end

if (SERVER) then 
    include("zdrm/sv_init.lua") 

    zdrm:Load()
end