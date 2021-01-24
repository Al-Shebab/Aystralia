gProtect = gProtect or {}
gProtect.TouchPermission = gProtect.TouchPermission or {}

if(file.Exists( "gp_buddies.txt", "DATA" )) then
	local data = file.Read( "gp_buddies.txt")
	data = util.JSONToTable(data)

	gProtect.TouchPermission = data
end

local classtoInt = {
	["weapon_physcannon"] = 1,
	["weapon_physgun"] = 2,
	["gmod_tool"] = 3,
	["canProperty"] = 4
}

local permissions = {
	[1] = {title = slib.getLang("gprotect", gProtect.config.SelectedLanguage, "toolgun"), classname = "gmod_tool", int = 3},
	[2] = {title = slib.getLang("gprotect", gProtect.config.SelectedLanguage, "gravity-gun"), classname = "weapon_physcannon", int = 1},
	[3] = {title = slib.getLang("gprotect", gProtect.config.SelectedLanguage, "physgun"), classname = "weapon_physgun", int = 2},
	[4] = {title = slib.getLang("gprotect", gProtect.config.SelectedLanguage, "canproperty"), classname = "canProperty", int = 4}
}

local function handleBuddies(ply, weapon, int, forced)
	if !IsValid(ply) or !weapon then return end

	local sid = ply:SteamID()
	local lsid = LocalPlayer():SteamID()

	gProtect.TouchPermission[lsid] = gProtect.TouchPermission[lsid] or {}
	gProtect.TouchPermission[lsid][weapon] = gProtect.TouchPermission[lsid][weapon] or {}

	local isBuddy = forced and forced or !gProtect.TouchPermission[lsid][weapon][sid]

	net.Start("gP:Buddies")
	net.WriteInt(ply:EntIndex(), 15)
	net.WriteUInt(int, 3)
	net.WriteBool(isBuddy)
	net.SendToServer()

	if !isBuddy then isBuddy = nil end

	gProtect.TouchPermission[lsid][weapon][sid] = isBuddy

	if(file.Exists( "gp_buddies.txt", "DATA" )) then
		local data = file.Read( "gp_buddies.txt")
		data = util.JSONToTable(data)

		data[lsid] = data[lsid] or {}
		data[lsid][weapon] = data[lsid][weapon] or {}
		data[lsid][weapon][sid] = isBuddy
		
		file.Write("gp_buddies.txt", util.TableToJSON(data))
	else
		local data = {[lsid] = {[weapon] = {[sid] = isBuddy}}}
		file.Write("gp_buddies.txt", util.TableToJSON(data))
	end
end

local function openBuddies()
	local buddies = vgui.Create("SFrame")
    buddies:SetSize(slib.getScaledSize(400, "x"),slib.getScaledSize(370, "y"))
    :setTitle(slib.getLang("gprotect", gProtect.config.SelectedLanguage, "buddies-title"))
    :Center()
    :addCloseButton()
    :MakePopup()

	local player_list = vgui.Create("SListPanel", buddies.frame)
    player_list:setTitle(slib.getLang("gprotect", gProtect.config.SelectedLanguage, "player-list"))
	:addSearchbar()
	:Dock(FILL)
	:DockMargin(slib.getTheme("margin"),slib.getTheme("margin"),slib.getTheme("margin"),slib.getTheme("margin"))

    for k,v in pairs(player.GetAll()) do
        if v:IsBot() or v == LocalPlayer() then continue end
		local _, entry = player_list:addEntry(v)
		if v:GetFriendStatus() == "friend" then entry:SetZPos(-10) end
	end
	
	for k,v in ipairs(permissions) do
		local _, bttn = player_list:addButton(v.title, function() handleBuddies(player_list.selected, v.classname, v.int) end)
		bttn:setToggleable(true)

		bttn.toggleCheck = function()
			local lply = LocalPlayer()
			local ply = player_list.selected

			if !ply or !lply then return slib.getTheme("maincolor", 20) end

			local lsid = lply:SteamID()
			local sid = ply:SteamID()

			return (gProtect.TouchPermission[lsid] and gProtect.TouchPermission[lsid][v.classname] and gProtect.TouchPermission[lsid][v.classname][sid] and true or false)
		end
	end
end

local networkedFriends = {}
local registeredFriends = {}

timer.Create("gP:QueueFriends", 20, 0, function()
	for k,v in pairs(player.GetAll()) do
		if !IsValid(v) or v:GetFriendStatus() ~= "friend" then continue end
		registeredFriends[v] = true
	end
end)

timer.Create("gP:NetworkFriends", .05, 0, function()
	for k,v in pairs(registeredFriends) do
		if !IsValid(k) or networkedFriends[k] then continue end
		networkedFriends[k] = true

		local sid = k:SteamID()
		local lsid = LocalPlayer():SteamID()
		
		if gProtect.TouchPermission[lsid] then
			for weapon, v in pairs(gProtect.TouchPermission[lsid]) do
				for ply, k in pairs(v) do
					local ply = player.GetBySteamID(tostring(ply))
					if !IsValid(ply) then continue end
					handleBuddies(ply, weapon, classtoInt[weapon], true)
				end
			end
		end
	end
end)

timer.Create("gP:RegisterFriends", 1, 0, function()
	local lply = LocalPlayer()
	if !IsValid(lply) then return end
	local lsid = lply:SteamID()

	if gProtect.TouchPermission[lsid] then
		for weapon, v in pairs(gProtect.TouchPermission[lsid]) do
			for ply, k in pairs(v) do
				local ply = player.GetBySteamID(tostring(ply))
				if !IsValid(ply) then continue end
				networkedFriends[ply] = true
				handleBuddies(ply, weapon, classtoInt[weapon], true)
			end
		end
	end

	timer.Remove("gP:RegisterFriends")
end)

list.Set(
    "DesktopWindows", "buddies",
    {
        title = "gP: Buddies",
        icon = "gProtect/buddies.png",
        onewindow = false,
        init = function(icn, pnl)
            openBuddies()
        end
    }
)

timer.Simple(1, function()
	net.Start("gP:Buddies")
	net.SendToServer()
end)

concommand.Add("buddies", function( ply, cmd, args )
    openBuddies()
end)