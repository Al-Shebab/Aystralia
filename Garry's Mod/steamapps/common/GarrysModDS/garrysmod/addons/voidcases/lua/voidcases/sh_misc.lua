
VoidCases.CachedMaterials = {}
VoidCases.ImageProvider = "https://i.imgur.com/%s.png" // Change to imgur later.

file.CreateDir("voidcases")

hook.Add("InitPostEntity", "VoidCases.InitLogoLoad", function ()
    local files = file.Find("voidcases/*.png", "DATA")

    for k, v in pairs(files) do
        local str = string.Replace(v, ".png", "")
        VoidCases.CachedMaterials[str] = Material("data/voidcases/"..str..".png", "noclamp smooth")
    end
end)



if (CLIENT) then
    net.Receive("VoidCases_BroadcastLogoDL", function ()
        local id = net.ReadString()

        VoidCases.FetchImage(id, function ()

        end)
    end)
end

function VoidCases.FetchImage(id, callback)

    if (VoidCases.CachedMaterials[id]) then
        callback(VoidCases.CachedMaterials[id])
    else
        if (file.Exists("voidcases/" .. id .. ".png", "DATA")) then
            VoidCases.CachedMaterials[id] = Material("data/voidcases/"..id..".png", "noclamp smooth")
            callback(VoidCases.CachedMaterials[id])
        else
            http.Fetch(string.format(VoidCases.ImageProvider, id), function (body, size, headers, code)

                if (code != 200) then
                    callback(false)
                    return
                end
                
                if (!body or body == "") then 
                    callback(false)
                    return 
                end

                file.Write("voidcases/"..id..".png", body)
                VoidCases.CachedMaterials[id] = Material("data/voidcases/"..id..".png", "noclamp smooth")
                callback(VoidCases.CachedMaterials[id])
            end, function ()
                // Failure
                callback(false)
            end)
        end
    end
    
end
