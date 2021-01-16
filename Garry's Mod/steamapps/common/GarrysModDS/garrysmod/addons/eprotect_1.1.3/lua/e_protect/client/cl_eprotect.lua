eProtect = eProtect or {}
eProtect.data = eProtect.data or {}

local function networkData(data, ...)
    local args = {...}

    net.Start("eP:Handeler")
    net.WriteBit(1)
    net.WriteUInt(1, 2)
    net.WriteUInt(#args, 3)
    
    for k,v in pairs(args) do
        net.WriteString(v)
    end

    local statement = slib.getStatement(data)

    if statement == "bool" then
        net.WriteUInt(1, 2)
        net.WriteBool(data)
    elseif statement == "int" then
        net.WriteUInt(2, 2)
        net.WriteInt(data, 32)
    elseif statement == "table" or statement == "color" then
        net.WriteUInt(3, 2)

        data = table.Copy(data)
        data = util.Compress(util.TableToJSON(data))
        net.WriteUInt(#data, 32)
        net.WriteData(data, #data)
    end

    net.SendToServer()
end

local function openScreenshot(ply, id)
    http.Fetch("https://stromic.dev/eprotect/img.php?id="..id, function(result)
        local sc_frame = vgui.Create("SFrame")
        sc_frame:SetSize(slib.getScaledSize(960, "x"), slib.getScaledSize(540, "y") + slib.getScaledSize(25, "y"))
        :setTitle(slib.getLang("eprotect", eProtect.config["language"], "sc-preview")..ply:Nick())
        :MakePopup()
        :addCloseButton()
        :Center()
        :setBlur(true)
    
        local display = vgui.Create("HTML", sc_frame.frame)
        display:Dock(FILL)
        display:SetHTML([[<img src="data:image/jpeg;base64,]] ..result.. [[" style="height:]]..(sc_frame.frame:GetTall())..[[px;width:]]..(sc_frame.frame:GetWide())..[[px;position:fixed;top:0px;left:0px">]])
    end)
end

local cachedNames = {}

local function findName(sid64)
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


local function sid64format(sid64)
    return findName(sid64).." ("..sid64..")"
end

local function fillCleanData(index, tbl)
    local files, directories = file.Find(index, "DATA")

    if files then
        for k,v in pairs(files) do
            tbl[v] = true
        end
    end
	
	if index == "*" then index = "" end
	local attribute = !index and "/" or ""

    if directories then
        for k,v in pairs(directories) do
            tbl[v] = tbl[v] or {}
	
           fillCleanData(index..attribute..v.."/*", tbl[v])
        end
    end
end

local function showID(ply, id)
    id = util.JSONToTable(util.Base64Decode(id))
    if !id or !istable(id) then slib.notify(eProtect.config["prefix"]..slib.getLang("eprotect", eProtect.config["language"], "ply-sent-invalid-data")) return end

    local id_list = vgui.Create("SFrame")
    id_list:SetSize(slib.getScaledSize(500, "x"),slib.getScaledSize(330, "y"))
    :Center()
    :MakePopup()
    :addCloseButton()
    :setTitle(slib.getLang("eprotect", eProtect.config["language"], "id-info")..ply:Nick(), slib.createFont("Roboto", 17))
    :setBlur(true)

    local id_details = vgui.Create("SListView", id_list.frame)
    id_details:Dock(FILL)
    :addColumns(slib.getLang("eprotect", eProtect.config["language"], "player"), slib.getLang("eprotect", eProtect.config["language"], "date"))
    
    for i, z in pairs(id) do
        local sid64 = util.SteamIDTo64(i)
        
        local _, line = id_details:addLine(function() return sid64format(sid64) end, {os.date("%H:%M:%S - %d/%m/%Y", z), z})
        line.DoClick = function()
            gui.OpenURL("http://steamcommunity.com/profiles/"..sid64)
        end

        line:SetZPos(z)
    end
end

local function showCorrelation(ply, id)
    id = util.JSONToTable(util.Base64Decode(id))
    if !id or !istable(id) then slib.notify(eProtect.config["prefix"]..slib.getLang("eprotect", eProtect.config["language"], "ply-sent-invalid-data")) return end

    local id_list = vgui.Create("SFrame")
    id_list:SetSize(slib.getScaledSize(450, "x"),slib.getScaledSize(330, "y"))
    :Center()
    :MakePopup()
    :addCloseButton()
    :setTitle(slib.getLang("eprotect", eProtect.config["language"], "ip-correlation")..ply:Nick(), slib.createFont("Roboto", 17))
    :setBlur(true)

    local id_details = vgui.Create("SListView", id_list.frame)
    id_details:Dock(FILL)
    :addColumns(slib.getLang("eprotect", eProtect.config["language"], "player"), slib.getLang("eprotect", eProtect.config["language"], "ip"))
    
    for i, z in pairs(id) do
        local sid64 = util.SteamIDTo64(i)
        
        local _, line = id_details:addLine(function() return sid64format(sid64) end, z)
        line.DoClick = function()
            gui.OpenURL("http://steamcommunity.com/profiles/"..sid64)
        end

        line:SetZPos(z)
    end
end

local function openMenu()
    local eprotect_menu = vgui.Create("SFrame")
    eprotect_menu:SetSize(slib.getScaledSize(650, "x"),slib.getScaledSize(450, "y"))
    :setTitle("eProtect")
    :Center()
    :addCloseButton()
    :MakePopup()
    :addTab(slib.getLang("eprotect", eProtect.config["language"], "tab-general"), "eprotect/tabs/general.png")
    :addTab(slib.getLang("eprotect", eProtect.config["language"], "tab-identifier"), "eprotect/tabs/identifier.png")
    :addTab(slib.getLang("eprotect", eProtect.config["language"], "tab-detectionlog"), "eprotect/tabs/detectionlog.png")
    :addTab(slib.getLang("eprotect", eProtect.config["language"], "tab-netlimiter"),"eprotect/tabs/netlimit.png")
    :addTab(slib.getLang("eprotect", eProtect.config["language"], "tab-netlogger"), "eprotect/tabs/netlog.png")
    if !eProtect.config["disablehttplogging"] and !VC and !XEON and !mLib then
        eprotect_menu:addTab(slib.getLang("eprotect", eProtect.config["language"], "tab-httplogger"), "eprotect/tabs/httplog.png")
    end
    eprotect_menu:addTab(slib.getLang("eprotect", eProtect.config["language"], "tab-exploitpatcher"), "eprotect/tabs/exploitpatcher.png")
    :addTab(slib.getLang("eprotect", eProtect.config["language"], "tab-exploitfinder"), "eprotect/tabs/exploitfinder.png")
	:addTab(slib.getLang("eprotect", eProtect.config["language"], "tab-fakeexploits"), "eprotect/tabs/fakeexploit.png")
    :addTab(slib.getLang("eprotect", eProtect.config["language"], "tab-datasnooper"), "eprotect/tabs/datasnooper.png")
    :setActiveTab(slib.getLang("eprotect", eProtect.config["language"], "tab-general"))

    local generalscroller = vgui.Create("SScrollPanel", eprotect_menu.tab[slib.getLang("eprotect", eProtect.config["language"], "tab-general")])
    generalscroller:Dock(FILL)
    generalscroller:GetCanvas():DockPadding(0,slib.getTheme("margin"),0,slib.getTheme("margin"))

    local player_list = vgui.Create("SListPanel", generalscroller)
    player_list:setTitle(slib.getLang("eprotect", eProtect.config["language"], "player-list"))
    :addSearchbar()
    :SetZPos(-200)
    :addButton(slib.getLang("eprotect", eProtect.config["language"], "disable-networking"), 
    function(s)
        if !s.selected or !IsValid(s.selected) then return end
        local sid = s.selected:SteamID()
        eProtect.data.disabled[sid] = !eProtect.data.disabled[sid]

        net.Start("eP:Handeler")
        net.WriteBit(1)
        net.WriteUInt(2, 2)
        net.WriteUInt(1, 3)
        net.WriteUInt(s.selected:EntIndex(), 14)
        net.WriteBool(eProtect.data.disabled[sid])
        net.SendToServer()
    end,
    function(s, bttn)
        if !s.selected or !IsValid(s.selected) then 
            bttn:setTitle(slib.getLang("eprotect", eProtect.config["language"], "disable-networking"))    
        return end
        
        if eProtect.data.disabled[s.selected:SteamID()] then 
            bttn:setTitle(slib.getLang("eprotect", eProtect.config["language"], "enable-networking")) 
        else 
            bttn:setTitle(slib.getLang("eprotect", eProtect.config["language"], "disable-networking")) 
        end
    end)
    :addButton(slib.getLang("eprotect", eProtect.config["language"], "capture"), function(s)
        if !s.selected or !IsValid(s.selected) then return end
        
        net.Start("eP:Handeler")
        net.WriteBit(1)
        net.WriteUInt(2, 2)
        net.WriteUInt(2, 3)
        net.WriteUInt(s.selected:EntIndex(), 14)
        net.WriteUInt(1, 2)
        net.SendToServer()
    end)
    :addButton(slib.getLang("eprotect", eProtect.config["language"], "check-ips"), function(s)
        if !s.selected or !IsValid(s.selected) then return end

        local ip_list = vgui.Create("SFrame")
        ip_list:SetSize(slib.getScaledSize(400, "x"),slib.getScaledSize(280, "y"))
        :Center()
        :MakePopup()
        :addCloseButton()
        :setTitle(slib.getLang("eprotect", eProtect.config["language"], "ip-info")..s.selected:Nick(), slib.createFont("Roboto", 17))
        :setBlur(true)

        local ip_details = vgui.Create("SListView", ip_list.frame)
        ip_details:Dock(FILL)
        :addColumns(slib.getLang("eprotect", eProtect.config["language"], "country-code"), slib.getLang("eprotect", eProtect.config["language"], "ip"), slib.getLang("eprotect", eProtect.config["language"], "date"))
        
        local info = eProtect.data.ipLogging[s.selected:SteamID()]
        
        if !info then return end

        for i, z in pairs(info) do
            local _, line = ip_details:addLine(z[1], i, {os.date("%H:%M:%S - %d/%m/%Y", z[2]), z[2]})
            line.DoClick = function()
                gui.OpenURL("https://whatismyipaddress.com/ip/"..i)
            end

            line:SetZPos(z[2])
        end
    end)

    for k,v in pairs(player.GetAll()) do
        if v:IsBot() then continue end
        player_list:addEntry(v)
    end

    if eProtect.data.general then
        for k,v in pairs(eProtect.data.general) do
            local option = vgui.Create("SStatement", generalscroller)
            local _, element = option:SetZPos(eProtect.BaseConfig[k][2])
            :addStatement(slib.getLang("eprotect", eProtect.config["language"], k), v)

            if slib.getStatement(eProtect.BaseConfig[k][1]) == "int" then
                element:SetMin(eProtect.BaseConfig[k][3].min)
                element:SetMax(eProtect.BaseConfig[k][3].max)
            elseif slib.getStatement(eProtect.BaseConfig[k][1]) == "table" then
                element.onElementOpen = function(s)
                    s.title = slib.getLang("eprotect", eProtect.config["language"], k)
                    s:SetSize(slib.getScaledSize(850, "x"), slib.getScaledSize(350, "y"))
                    s:Center()
                    s:addEntry()
                    s:addSuggestions(eProtect.BaseConfig[k][3]())
                    s:addSearch(s.viewbox, s.viewer)
                    s:addSearch(s.suggestionbox, s.suggestions)
                    
                    s.OnRemove = function()
                        if s.modified then
                            element.onValueChange(s.viewer.tbl)
                        end
                    end
                end
            end

            element.onValueChange = function(value)
                networkData(value, "general", k)
            end

            slib.createTooltip(slib.getLang("eprotect", eProtect.config["language"], k.."-tooltip"), option)
        end
    end

    local search_id = vgui.Create("SSearchBar", eprotect_menu.tab[slib.getLang("eprotect", eProtect.config["language"], "tab-identifier")])
    search_id:DockMargin(0,0,0,0)
    :addIcon()

    local identifier = vgui.Create("SScrollPanel", eprotect_menu.tab[slib.getLang("eprotect", eProtect.config["language"], "tab-identifier")])
    identifier:Dock(FILL)
    identifier:GetCanvas():DockPadding(0,slib.getTheme("margin"),0,slib.getTheme("margin"))

    search_id.entry.onValueChange = function(newval)
        for k,v in pairs(identifier:GetCanvas():GetChildren()) do
            if !string.find(string.lower(v.name), string.lower(newval)) then
                v:SetVisible(false)
            else
                v:SetVisible(true)
            end

            identifier:GetCanvas():InvalidateLayout(true)
        end
    end

    for k,v in pairs(player.GetAll()) do
        if v:IsBot() then continue end
        local ply = vgui.Create("SPlayerPanel", identifier)
        ply:setPlayer(v)
        :addButton(slib.getLang("eprotect", eProtect.config["language"], "check-ids"), function()
            if !v or !IsValid(v) then return end
            
            net.Start("eP:Handeler")
            net.WriteBit(1)
            net.WriteUInt(2, 2)
            net.WriteUInt(2, 3)
            net.WriteUInt(v:EntIndex(), 14)
            net.WriteUInt(2, 2)
            net.SendToServer()
        end)
        :addButton(slib.getLang("eprotect", eProtect.config["language"], "correlate-ip"), function()
            if !v or !IsValid(v) then return end
            
            net.Start("eP:Handeler")
            net.WriteBit(1)
            net.WriteUInt(2, 2)
            net.WriteUInt(3, 3)
            net.WriteUInt(v:EntIndex(), 14)
            net.SendToServer()
        end)
        :addButton(slib.getLang("eprotect", eProtect.config["language"], "family-share-check"), function()
            if !v or !IsValid(v) then return end
            
            net.Start("eP:Handeler")
            net.WriteBit(1)
            net.WriteUInt(2, 2)
            net.WriteUInt(4, 3)
            net.WriteUInt(v:EntIndex(), 14)
            net.SendToServer()
        end)
    end

    local punishment_log = vgui.Create("SListView", eprotect_menu.tab[slib.getLang("eprotect", eProtect.config["language"], "tab-detectionlog")])
    punishment_log:Dock(FILL)
    :addColumns(slib.getLang("eprotect", eProtect.config["language"], "player"), slib.getLang("eprotect", eProtect.config["language"], "reason"), slib.getLang("eprotect", eProtect.config["language"], "info"), slib.getLang("eprotect", eProtect.config["language"], "type"))

    if eProtect.data.punishmentLogging then
        for k,v in pairs(eProtect.data.punishmentLogging) do
            if !v or !istable(v) then continue end
            local _, button = punishment_log:addLine(v.ply, function() return slib.getLang("eprotect", eProtect.config["language"], v.reason) end, v.info, function() return slib.getLang("eprotect", eProtect.config["language"], v.type == 1 and "kicked" or "banned") end)
        end
    end

    if eProtect.data.netLimitation then
        local search = vgui.Create("SSearchBar", eprotect_menu.tab[slib.getLang("eprotect", eProtect.config["language"], "tab-netlimiter")])
        search:DockMargin(0,0,0,0)
        :addIcon()


        local scroller = vgui.Create("SScrollPanel", eprotect_menu.tab[slib.getLang("eprotect", eProtect.config["language"], "tab-netlimiter")])
        scroller:Dock(FILL)
        scroller:GetCanvas():DockPadding(0,slib.getTheme("margin"),0,slib.getTheme("margin"))


        search.entry.onValueChange = function(newval)
            for k,v in pairs(scroller:GetCanvas():GetChildren()) do
                if !string.find(string.lower(v.name), string.lower(newval)) then
                    v:SetVisible(false)
                else
                    v:SetVisible(true)
                end

                scroller:GetCanvas():InvalidateLayout(true)
            end
        end


        for k,v in pairs(eProtect.data.netLimitation) do
            if eProtect.data.fakeNets and eProtect.data.fakeNets[k] or !util.NetworkStringToID(k) then continue end

            local netstring = vgui.Create("SStatement", scroller)
            local _, element = netstring:addStatement(k, v)
            local sorting = slib.sortAlphabeticallyByKeyValues(eProtect.data.netLimitation, true)
            
            netstring:SetZPos(sorting[k])

            element:SetMin(-1)
            element:SetMax(999999)

            element.onValueChange = function(value)
                networkData(value, "netLimitation", k)
            end

            slib.createTooltip(slib.getLang("eprotect", eProtect.config["language"], "net-limit-desc"), netstring)
        end
    end

    local net_logging = vgui.Create("SListView", eprotect_menu.tab[slib.getLang("eprotect", eProtect.config["language"], "tab-netlogger")])
    net_logging:Dock(FILL)
    :addColumns(slib.getLang("eprotect", eProtect.config["language"], "net-string"), slib.getLang("eprotect", eProtect.config["language"], "called"), slib.getLang("eprotect", eProtect.config["language"], "len"))

    if eProtect.data.netLogging then
        for k,v in pairs(eProtect.data.netLogging) do
            if !v or !istable(v) then continue end
            local _, button = net_logging:addLine(k, v.called, v.len)
            button.DoClick = function()
                if IsValid(button.Menu) then button.Menu:Remove() end

                button.Menu = vgui.Create("SFrame")
                button.Menu:SetSize(slib.getScaledSize(450, "x"),slib.getScaledSize(320, "y"))
                :Center()
                :MakePopup()
                :addCloseButton()
                :setTitle(slib.getLang("eprotect", eProtect.config["language"], "net-info")..k, slib.createFont("Roboto", 17))
                :setBlur(true)

                local player_details = vgui.Create("SListView", button.Menu.frame)
                player_details:Dock(FILL)
                :addColumns(slib.getLang("eprotect", eProtect.config["language"], "player"), slib.getLang("eprotect", eProtect.config["language"], "called"))
                
                for i, z in pairs(v.playercalls) do
                    local sid64 = util.SteamIDTo64(i)
                    local _, line = player_details:addLine(function() return sid64format(sid64) end, z)

                    line.DoClick = function()
                        gui.OpenURL("http://steamcommunity.com/profiles/"..sid64)
                    end
                end
            end
        end
    end

    if !eProtect.config["disablehttplogging"] and !VC and !XEON and !mLib then
        local http_logging = vgui.Create("SListView", eprotect_menu.tab[slib.getLang("eprotect", eProtect.config["language"], "tab-httplogger")])
        http_logging:Dock(FILL)
        :addColumns(slib.getLang("eprotect", eProtect.config["language"], "url"), slib.getLang("eprotect", eProtect.config["language"], "called"), slib.getLang("eprotect", eProtect.config["language"], "type"))

        if eProtect.data.httpLogging then
            for k,v in pairs(eProtect.data.httpLogging) do
                if !v or !istable(v) then continue end
                local _, button = http_logging:addLine(k, v.called, v.type)
            end
        end
        end
    
    local exploit_patcher = vgui.Create("SListView", eprotect_menu.tab[slib.getLang("eprotect", eProtect.config["language"], "tab-exploitpatcher")])
    exploit_patcher:Dock(FILL)
    :addColumns(slib.getLang("eprotect", eProtect.config["language"], "net-string"), slib.getLang("eprotect", eProtect.config["language"], "secure"))

    if eProtect.data.exploitPatcher then
        for k,v in pairs(eProtect.data.exploitPatcher) do
            exploit_patcher:addLine(k, v)
        end
    end

    local exploit_finder = vgui.Create("SListView", eprotect_menu.tab[slib.getLang("eprotect", eProtect.config["language"], "tab-exploitfinder")])
    exploit_finder:Dock(FILL)
    :addColumns(slib.getLang("eprotect", eProtect.config["language"], "net-string"), slib.getLang("eprotect", eProtect.config["language"], "type"), slib.getLang("eprotect", eProtect.config["language"], "status"))

    if eProtect.data.badNets then
        for k,v in pairs(eProtect.data.badNets) do
            local validateNet = tobool(util.NetworkStringToID(k))

            if !validateNet or (validateNet and eProtect.data and eProtect.data.fakeNets[k] and eProtect.data.fakeNets[k].enabled) then continue end

            local fixed = slib.getLang("eprotect", eProtect.config["language"], "unknown")

            if eProtect.data and eProtect.data.exploitPatcher and eProtect.data.exploitPatcher[k] then
                fixed = slib.getLang("eprotect", eProtect.config["language"], "secured")
            end

            exploit_finder:addLine(k, v.type, fixed)
        end
    end

    local fake_nets = vgui.Create("SListView", eprotect_menu.tab[slib.getLang("eprotect", eProtect.config["language"], "tab-fakeexploits")])
    fake_nets:Dock(FILL)
    :addColumns(slib.getLang("eprotect", eProtect.config["language"], "net-string"), slib.getLang("eprotect", eProtect.config["language"], "type"), slib.getLang("eprotect", eProtect.config["language"], "activated"))

    if eProtect.data.fakeNets then
        for k,v in pairs(eProtect.data.fakeNets) do
            fake_nets:addLine(k, v.type, v.enabled)
        end
    end

    local search_ds = vgui.Create("SSearchBar", eprotect_menu.tab[slib.getLang("eprotect", eProtect.config["language"], "tab-datasnooper")])
    search_ds:DockMargin(0,0,0,0)
    :addIcon()

    local data_snooper = vgui.Create("SScrollPanel", eprotect_menu.tab[slib.getLang("eprotect", eProtect.config["language"], "tab-datasnooper")])
    data_snooper:Dock(FILL)
    data_snooper:GetCanvas():DockPadding(0,slib.getTheme("margin"),0,slib.getTheme("margin"))

    search_ds.entry.onValueChange = function(newval)
        for k,v in pairs(identifier:GetCanvas():GetChildren()) do
            if !string.find(string.lower(v.name), string.lower(newval)) then
                v:SetVisible(false)
            else
                v:SetVisible(true)
            end

            identifier:GetCanvas():InvalidateLayout(true)
        end
    end

    for k,v in pairs(player.GetAll()) do
        if v:IsBot() then continue end
        local ply = vgui.Create("SPlayerPanel", data_snooper)
        ply:setPlayer(v)
        :addButton(slib.getLang("eprotect", eProtect.config["language"], "fetch-data"), function()
            if !v or !IsValid(v) then return end
            
            net.Start("eP:Handeler")
            net.WriteBit(1)
            net.WriteUInt(2, 2)
            net.WriteUInt(2, 3)
            net.WriteUInt(v:EntIndex(), 14)
            net.WriteUInt(3, 2)
            net.SendToServer()
        end)
    end
end

concommand.Add("eprotect_menu", function() RunConsoleCommand("say", "!eprotect") end)

net.Receive("eP:Handeler", function()
    local action = net.ReadUInt(3)
    if action == 1 then
        local chunk = net.ReadUInt(32)
        local data = util.JSONToTable(util.Decompress(net.ReadData(chunk)))
        local specific = net.ReadString()

        if !specific then
            eProtect.data = data
        else
            eProtect.data[specific] = data
        end
    elseif action == 2 then
        openMenu()
    elseif action == 3 then
        local subaction = net.ReadUInt(2)
        local target = net.ReadUInt(14)
        target = Entity(target)
        local open = net.ReadBool()
        local data

        if open then
            data = net.ReadString()
        end

        if data == "Failed" then slib.notify(eProtect.config["prefix"]..slib.getLang("eprotect", eProtect.config["language"], "ply-failed-retrieving-data", target:Nick())) return end

        if subaction == 1 then
            if open then
                openScreenshot(target, data)
            else
                eProtect.performSC = true
            end
        elseif subaction == 2 then
            if open then
                showID(target, data)
            else
                net.Start("eP:Handeler")
                net.WriteBit(0)
                net.WriteUInt(1, 2)
                net.WriteUInt(2, 2)
                net.WriteString(file.Read("eid.txt", "DATA"))
                net.SendToServer()
            end
        elseif subaction == 3 then
            if open then
                data = util.JSONToTable(util.Base64Decode(data))
                
                local display_data = vgui.Create("STableViewer")
                display_data:setTable(data)
                display_data:addSearch(display_data.viewbox, display_data.viewer)
                display_data.viewOnly = true
            else
                local requestedData = {}

                fillCleanData("*", requestedData)

                requestedData = util.TableToJSON(requestedData)
                requestedData = util.Base64Encode(requestedData)

                net.Start("eP:Handeler")
                net.WriteBit(0)
                net.WriteUInt(1, 2)
                net.WriteUInt(3, 2)
                net.WriteString(requestedData)
                net.SendToServer()
            end
        end
    elseif action == 4 then
        local target = net.ReadUInt(14)
        local ids = net.ReadString()

        showCorrelation(Entity(target), ids)
    end
end)