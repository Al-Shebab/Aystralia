slib = slib or {}

slib.config = {scale = {x = 1, y = 1}}

slib.getStatement = function(val)
    if isbool(val) then return "bool" end
    if isnumber(val) then return "int" end
    if istable(val) and val.r and val.g and val.b then return "color" end
    if istable(val) then return "table" end
    if isfunction(val) then return "function" end

    return "bool"
end

local callNum = 1
local loadedCalls = {}

local function loadFile(folder, file)
    if string.StartWith(file, "sv_") or string.find(folder, "server") then
        if SERVER then
            include(folder .. file)
            loaded = true
        end
    elseif string.StartWith(file, "sh_") or string.find(folder, "shared") then
        AddCSLuaFile(folder .. file)
        include(folder .. file)
        loaded = true
    elseif string.StartWith(file, "cl_") or string.find(folder, "client") then
        AddCSLuaFile(folder .. file)
        if CLIENT then include(folder .. file) loaded = true end
    end

    if loaded then
        print("[slib] Loaded "..folder..file)

        return folder..file
    end
end

slib.loadFolder = function(folder, subdirectories, firstload, lastload, call)
    local files, directories = file.Find(folder .. "*", "LUA")
    loadedCalls[callNum] = loadedCalls[callNum] or {}

    if firstload then
        for k,v in pairs(firstload) do
            local result = loadFile(v[1], v[2])
            if !result then continue end
            loadedCalls[callNum][result] = true
        end
    end

    if lastload then
        for k,v in pairs(lastload) do
            loadedCalls[callNum][v[1]..v[2]] = true
        end
    end

    for k, v in pairs(files) do
        if loadedCalls[callNum][folder..v] then continue end
        loadFile(folder, v)
    end

    if subdirectories then
        for k,v in pairs(directories) do
            slib.loadFolder(folder..v.."/", true, nil, nil, call and call or callNum)
        end
    end

    if lastload then
        for k,v in pairs(lastload) do
            loadFile(v[1], v[2])
        end
    end

    if call then return end
    callNum = callNum + 1
end

slib.oldFunctions = {}

slib.wrapFunction = function(element, funcname, pre, post, returnresult)
    if !slib.oldFunctions[funcname.."Old"] then
        slib.oldFunctions[funcname.."Old"] = element[funcname]
    end

    element[funcname] = function(...)
        local result 
        
        if pre then
            local callback = pre(...)
            result = returnresult and callback or result
        end

        if isfunction(slib.oldFunctions[funcname.."Old"]) then
            result = slib.oldFunctions[funcname.."Old"](...) or result
        end 

        if post then
            local callback = post(...)
            result = returnresult and callback or result
        end

        return result
    end
end

slib.lang = slib.lang or {}

slib.setLang = function(addon, lang, id, str)
    slib.lang[addon] = slib.lang[addon] or {}
    slib.lang[addon][lang] = slib.lang[addon][lang] or {}

    slib.lang[addon][lang][id] = str
end

slib.getLang = function(addon, lang, id, ...)
    local args = {...}
    local unformatted = slib.lang[addon] and slib.lang[addon][lang] and slib.lang[addon][lang][id]

    if !unformatted then unformatted = slib.lang[addon] and slib.lang[addon]["en"] and slib.lang[addon]["en"][id] or "" end

    return string.format(unformatted, ...)
end

slib.notify = function(str, ply)
    str = tostring(str)
    if SERVER then
        net.Start("slib.handeler")
        net.WriteString(str)
        net.Send(ply)
    elseif CLIENT then
        print(str)
        notification.AddLegacy(str, 0, 5)
    end
end

local function differenciate(a, b)
    if !(isstring(a) == isstring(b)) or isbool(a) or isbool(b) then
        return tostring(a), tostring(b)
    end

    return a, b
end

slib.sortAlphabeticallyByKeyValues = function(tbl, ascending)
    local normaltable = {}
    local cleantable = {}
    
    for k,v in pairs(tbl) do
        table.insert(normaltable, k)
    end

    if ascending then
        table.sort(normaltable, function(a, b) a, b = differenciate(a, b) return a < b end)
    else
        table.sort(normaltable, function(a, b) a, b = differenciate(a, b) return a > b end)
    end

    for k,v in pairs(normaltable) do
        cleantable[v] = k
    end

    return cleantable
end

slib.sortAlphabeticallyByValue = function(tbl, ascending, keyvalue)
    if keyvalue then
        tbl = table.Copy(tbl)
    end

    if ascending then
        table.sort(tbl, function(a, b) a, b = differenciate(a, b) return a < b end)
    else
        table.sort(tbl, function(a, b) a, b = differenciate(a, b) return a > b end)
    end

    local cleantable = {}

    for k, v in pairs(tbl) do
        cleantable[v] = k
    end

    return keyvalue and cleantable or tbl
end

if SERVER then
    util.AddNetworkString("slib.handeler")
    
    local punished = {}
    slib.punish = function(ply, type, msg, duration)
        local sid = ply:SteamID()

        if punished[sid] then return end
        punished[sid] = true

        if type == 1 then
            ply:Kick(msg)
        elseif type == 2 then
            if duration == nil then duration = 0 end    
            if ulx then
                ULib.ban(ply, duration, msg)
            elseif sam then
                RunConsoleCommand("sam","banid", sid, duration, msg)
            elseif xAdmin then
                if xAdmin.Config then
                    if xAdmin.Config.MajorVersion == 1 then
                        RunConsoleCommand("xadmin_ban", sid, duration, msg)
                    elseif xAdmin.Config.MajorVersion == 2 then
                        RunConsoleCommand("xadmin","ban", sid, duration, msg)
                    end
                end
            elseif SERVERGUARD then
                RunConsoleCommand("serverguard","ban", sid, duration, msg)
            end
    
            ply:Ban(duration, true)
        end
    end

    hook.Add("PlayerInitialSpawn", "slib.reconnected", function(ply)
        local sid = ply:SteamID()
        if punished[sid] then
            punished[sid] = nil
        end
    end)

    hook.Add( "PlayerInitialSpawn", "slib.FullLoaded", function( ply )
        local id = ply:SteamID64().."_slib"
        hook.Add( "SetupMove", id, function( self, mv, cmd )
            if self == ply and not cmd:IsForced() then
                hook.Run( "slib.FullLoaded", ply )
                hook.Remove( "SetupMove", id )
            end
        end )
    end )
end

if CLIENT then
    local blur = Material("pp/blurscreen")

    slib.DrawBlur = function(panel, amount)
        local x, y = panel:LocalToScreen(0, 0)
        local scrW, scrH = ScrW(), ScrH()
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(blur)
        for i = 1, 3 do
            blur:SetFloat("$blur", (i / 3) * (amount or 6))
            blur:Recompute()
            render.UpdateScreenEffectTexture()
            surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
        end
    end

    slib.getScaledSize = function(num, axis, scale)
        scale = scale or {x = 1, y = 1}

        if axis == "x" then
            num = ScrW() * (num/1920)

            num = num * scale.x
        end
    
        if axis == "y" or axis == nil then
            num = ScrH() * (num/1080)

            num = num * scale.y
        end
        
        return math.Round(num)
    end

    slib.cachedFonts = slib.cachedFonts or {}

    slib.createFont = function(fontname, size, thickness, ignorescale)
        size = size or 13
        thickness = thickness or 500
        local identifier = string.gsub(fontname, " ", "_")

        if !fontname or !size or !thickness then return end

        local name = "slib."..identifier..size.."."..thickness
        
        if ignorescale then name = "real_"..name end
        
        if slib.cachedFonts[name] then return name end

        surface.CreateFont( name, {
            font = fontname,
            size = ignorescale and size or slib.getScaledSize(size, "y"),
            weight = thickness,
        })

        slib.cachedFonts[name] = true

        return name
    end

    slib.colorCached = {}

    slib.lerpColor = function(identifier, wantedcolor, multiplier, nolerp)
        wantedcolor = table.Copy(wantedcolor)
        slib.colorCached[identifier] = slib.colorCached[identifier] or wantedcolor
        multiplier = multiplier or 1
        local basespeed = (RealFrameTime() * 3)
        local speed = basespeed * multiplier

        if minspeed then speed = minspeed > speed and minspeed or speed end
        
        for k,v in pairs(slib.colorCached[identifier]) do
            local percentageleft = math.abs(wantedcolor[k] - v)

            slib.colorCached[identifier][k] = math.Approach(v, wantedcolor[k], speed * (nolerp and 100 or percentageleft))
        end

        return slib.colorCached[identifier]
    end

    slib.numCached = {}
    slib.lerpNum = function(identifier, wantednum, multiplier, nolerp)
        slib.numCached[identifier] = slib.numCached[identifier] or wantednum
        multiplier = multiplier or 1
        local basespeed = (RealFrameTime() * 3)
        local speed = basespeed * multiplier

        local percentageleft = math.abs(wantednum - slib.numCached[identifier])

        slib.numCached[identifier] = math.Approach(slib.numCached[identifier], wantednum, speed * (nolerp and 100 or percentageleft))

        return math.Round(slib.numCached[identifier])
    end

    slib.drawTooltip = function(str, parent, align)
        local font = slib.createFont("Roboto", 13)
        local cursortposx, cursortposy = input.GetCursorPos()
        cursortposx = cursortposx + 15
        local x, y = cursortposx, cursortposy
       
        surface.SetFont(font)
        local strw, strh = surface.GetTextSize(str)
       
        local w = strw + slib.getScaledSize(6, "x")

        if align == 1 then
            local parentparent = parent:GetParent()
            if !IsValid(parentparent) then return end
            local posx, posy = parent:GetPos()
            x, y = parentparent:LocalToScreen(posx, posy)
            y = y + parent:GetTall()

            x = x + parent:GetWide() * .5

            x = x - w * .5
        end

        local tooltip = vgui.Create("EditablePanel")
        tooltip:SetMouseInputEnabled(false)
        tooltip:SetPos(x, y)
        tooltip:SetSize(w, slib.getScaledSize(22, "y"))
        tooltip:MakePopup()
    
        tooltip.Paint = function(s,w,h)
            if !parent:IsHovered() and !s:IsHovered() or !s:HasFocus() then s:Remove() end
    
            surface.SetDrawColor(slib.getTheme("maincolor", 10))
            surface.DrawRect(0, 0, w, h)
    
            surface.SetDrawColor(120, 120, 120, 200)
            surface.DrawOutlinedRect(0, 0, w, h)
    
            draw.SimpleText(str, font, slib.getScaledSize(3, "x"), h * .5, slib.getTheme("textcolor"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        return tooltip
    end

    slib.createTooltip = function(str, parent)
        if !str or !parent then return end

        surface.SetFont(parent.font)
        local textw, texth = surface.GetTextSize(parent.name)


        local tooltipbutton = vgui.Create("DButton", parent)
		tooltipbutton:SetText("")
		tooltipbutton:Dock(LEFT)
		tooltipbutton:DockMargin(textw + slib.getScaledSize(6,"x"),slib.getScaledSize(5,"x"),0,slib.getScaledSize(5,"x"))
		tooltipbutton:SetWide(slib.getScaledSize(25, "y") - (slib.getScaledSize(5,"x") + slib.getScaledSize(5,"x")))

		tooltipbutton.Paint = function(s,w,h)
			draw.RoundedBox(h * .5, 0, 0, w, h, slib.getTheme("maincolor"))

			draw.SimpleText("?", slib.createFont("Roboto", 14), w * .5, h * .5, slib.getTheme("textcolor", -50), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			if s:IsHovered() and !IsValid(s.tooltip) then
				s.tooltip = slib.drawTooltip(str, tooltipbutton)
			end
		end
    end

    slib.theme = slib.theme or {}

    slib.setTheme = function(var, val)
        slib.theme[var] = val
    end

    slib.getTheme = function(var, offset)
        local val = slib.theme[var]

        if istable(val) then
            val = table.Copy(val)
            
            if offset then
                for k,v in pairs(val) do
                    val[k] = v + offset
                end

                if val.r and val.g and val.b and val.a then
                    for k,v in pairs(val) do
                        val[k] = math.Clamp(v, 0, 255)
                    end
                end
            end 
        end

        return val
    end

    local loading_ico = Material("slib/load.png", "smooth")


    local matCache = {}
    local fetched = {}
    
    file.CreateDir("slib")
    slib.ImgurGetMaterial = function(id) ---- RETURN THE LOADING MATERIAL UNTIL IT IS FOUND!!!
        if !matCache[id] then
            if file.Exists("slib/"..id..".png", "DATA") then
                matCache[id] = Material("data/slib/"..id..".png", "noclamp smooth")
            else
                local link = "https://i.imgur.com/"..id..".png"
                if fetched[link] then return loading_ico, true end
                fetched[link] = true
                http.Fetch(link,
                    function(body)
                        file.Write("slib/"..id..".png", body)
                        matCache[id] = Material("data/slib/"..id..".png", "noclamp smooth")
                    end
                )
            end
        else
            return matCache[id]
        end
        
        return loading_ico, true
    end

    local cachedNames = {}

    slib.findName = function(sid64)
        if cachedNames[sid64] then return cachedNames[sid64] end

        local servercheck = player.GetBySteamID64(sid64)
        local steamcheck = false

        if servercheck then
            cachedNames[sid64] = servercheck:Nick()
        else
            local start = "<title>Steam Community :: "
            local theEnd = '<link rel="shortcut icon" href="/favicon.ico" type="image/'

            http.Fetch( "http://steamcommunity.com/profiles/"..sid64,
                function(data)
                    local nameStart = select(1, string.find(data, start))
                    local nameEnd = select(1, string.find(data, theEnd))

                    if !nameStart or !nameEnd then return end

                    nameStart = nameStart + #start
                    nameEnd = nameEnd - 12

                    local nick = string.sub(data, nameStart, nameEnd)

                    cachedNames[sid64] = nick
                end
            )

            cachedNames[sid64] = "N/A"
        end

        return cachedNames[sid64]
    end

    net.Receive("slib.handeler", function(_, ply)
        slib.notify(net.ReadString())
    end)
end

timer.Simple(0, function()
    hook.Run("slib:loadedUtils") 
    if CLIENT then
        RunConsoleCommand("spawnmenu_reload")
    end
end)