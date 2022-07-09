-- RayHUD Owner: 76561198166995690
-- RayHUD Version: 1.2.5

local ColorsTable = {
	Blue = Color(0, 150, 255),
	Red = Color(200, 40, 40),
}

--[[------------------------------
    Props Counter
--------------------------------]]

util.AddNetworkString("RayHUD:UpdateProplimit")
util.AddNetworkString("RayHUD:SendHUDPopup")

local PLAYER = FindMetaTable("Player")

PLAYER.AddCount_Old = PLAYER.AddCount_Old or PLAYER.AddCount

function PLAYER:AddCount( str, ent, ... )
	if IsValid(ent) and IsEntity(ent) and ent:GetClass() == "prop_physics" then
		self.RAYUI_Props = self.RAYUI_Props + 1
		ent.RAYUI_Owner = self

		net.Start("RayHUD:UpdateProplimit")
			net.WriteUInt(self.RAYUI_Props, 11)
		net.Send(self)
	end

	return self:AddCount_Old(str, ent, ...)
end

hook.Add("PlayerInitialSpawn", "RayHUD:SetProps",function( ply )
	ply.RAYUI_Props = 0
end)

hook.Add("EntityRemoved", "RayHUD:PropRemoved", function( ent )
	if ent.RAYUI_Owner and IsValid(ent.RAYUI_Owner) and ent.RAYUI_Owner.RAYUI_Props then

		ent.RAYUI_Owner.RAYUI_Props = math.max(ent.RAYUI_Owner.RAYUI_Props - 1, 0)

		net.Start("RayHUD:UpdateProplimit")
			net.WriteUInt(ent.RAYUI_Owner.RAYUI_Props, 11)
		net.Send(ent.RAYUI_Owner)
	end
end)

function RayHUD.SendHUDPopup( color, title, message, rf, important )
	net.Start("RayHUD:SendHUDPopup")
		net.WriteColor(color)
		net.WriteString(title)
		net.WriteString(message)
		net.WriteBool(important)
	net.Send(rf)
end

--[[------------------------------
    Events Hooks
--------------------------------]]

hook.Add("playerWanted", "RayHUD:PlayerWanted", function( criminal, cop, reason )
	if !IsValid(criminal) then return end
	reason = reason or ""

	if IsValid(cop) then
		local cop_text = RayUI.GetPhrase("hud", "wanted_cop")
		cop_text = string.Replace( cop_text, "%C", criminal:Nick() )
		cop_text = string.Replace( cop_text, "%R", reason )

		RayHUD.SendHUDPopup( ColorsTable.Blue, RayUI.GetPhrase("hud", "wanted"), cop_text, cop, true )
	end

	local text_criminal = RayUI.GetPhrase("hud", "wanted_criminal")
	text_criminal = string.Replace( text_criminal, "%R", reason )
	text_criminal = string.Replace( text_criminal, "%C", cop and cop:Nick() or "Unknown" )

	if cop != criminal then
		RayHUD.SendHUDPopup( ColorsTable.Blue, RayUI.GetPhrase("hud", "wanted"), text_criminal, criminal, true )
	end

	local text_all = RayUI.GetPhrase("hud", "wanted_all")
	text_all = string.Replace( text_all, "%CR", criminal:Nick() )
	text_all = string.Replace( text_all, "%R", reason )
	text_all = string.Replace( text_all, "%C", cop and cop:Nick() or "Unknown" )

	for k,v in ipairs(player.GetAll()) do
		if v != cop and v != criminal then
			RayHUD.SendHUDPopup( ColorsTable.Blue, RayUI.GetPhrase("hud", "wanted"), text_all, v, true )
		end
	end

	return true
end)

hook.Add("playerUnWanted", "RayHUD:playerUnWanted", function( criminal, cop )
	if !IsValid(criminal) then return end

	if IsValid(cop) then
		local cop_text = RayUI.GetPhrase("hud", "unwanted_cop")
		cop_text = string.Replace( cop_text, "%C", criminal:Nick() )

		RayHUD.SendHUDPopup( ColorsTable.Blue, RayUI.GetPhrase("hud", "unwanted"), cop_text, cop )
	end

	local text_criminal = RayUI.GetPhrase("hud", "unwanted_criminal")
	text_criminal = string.Replace( text_criminal, "%C", cop and cop:Nick() or "Unknown" )

	if cop != criminal then
		RayHUD.SendHUDPopup( ColorsTable.Blue, RayUI.GetPhrase("hud", "unwanted"), text_criminal, criminal )
	end

	local text_all = RayUI.GetPhrase("hud", "unwanted_all")
	text_all = string.Replace( text_all, "%C", criminal:Nick() )

	for k,v in ipairs(player.GetAll()) do
		if v != cop and v != criminal then
			RayHUD.SendHUDPopup( ColorsTable.Blue, RayUI.GetPhrase("hud", "unwanted"), text_all, v )
		end
	end

	return true
end)

hook.Add("playerWarranted", "RayHUD:playerWarranted", function( criminal, cop, reason )
	if !IsValid(criminal) then return end
	reason = reason or ""

	local cop_text = RayUI.GetPhrase("hud", "warranted_cop")
	cop_text = string.Replace( cop_text, "%C", criminal:Nick() )

	for k,v in ipairs(player.GetAll()) do
		if v:getJobTable().category == "Civil Protection" or v:HasWeapon( "door_ram" ) then
			RayHUD.SendHUDPopup( ColorsTable.Blue, RayUI.GetPhrase("hud", "warranted"), cop_text, v, true )
		end
	end

	local text_criminal = RayUI.GetPhrase("hud", "warranted_criminal")
	text_criminal = string.Replace( text_criminal, "%C", cop and cop:Nick() or "Unknown" )
	text_criminal = string.Replace( text_criminal, "%R", reason )

	if cop != criminal then
		RayHUD.SendHUDPopup( ColorsTable.Blue, RayUI.GetPhrase("hud", "warranted"), text_criminal, criminal, true )
	end

	return true
end)

hook.Add("playerUnWarranted", "RayHUD:playerUnWarranted", function( criminal, cop )
	if !IsValid(criminal) then return end

	local cop_text = RayUI.GetPhrase("hud", "unwarranted_cop")
	cop_text = string.Replace( cop_text, "%C", criminal:Nick() )

	RayHUD.SendHUDPopup( ColorsTable.Blue, RayUI.GetPhrase("hud", "unwarranted"), cop_text, cop )

	local all_text = RayUI.GetPhrase("hud", "unwarranted_all")
	all_text = string.Replace( all_text, "%C", cop:Nick() )
	all_text = string.Replace( all_text, "%S", criminal:Nick() )

	for k,v in ipairs(player.GetAll()) do
		if v != cop and (v:getJobTable().category == "Civil Protection" or v:HasWeapon( "door_ram" )) then
			RayHUD.SendHUDPopup( ColorsTable.Blue, RayUI.GetPhrase("hud", "unwarranted"), all_text, v )
		end
	end

	if cop != criminal then
		RayHUD.SendHUDPopup( ColorsTable.Blue, RayUI.GetPhrase("hud", "unwarranted"), RayUI.GetPhrase("hud", "unwarranted_criminal"), criminal )
	end

	return true
end)

hook.Add("playerArrested", "RayHUD:playerArrested", function( criminal, time, cop )
	if !IsValid(criminal) or !time then return end

	if IsValid(cop) then
		local cop_text = RayUI.GetPhrase("hud", "arrested_cop")
		cop_text = string.Replace( cop_text, "%C", criminal:Nick() )
		cop_text = string.Replace( cop_text, "%T", time )

		RayHUD.SendHUDPopup( ColorsTable.Red, RayUI.GetPhrase("hud", "arrested"), cop_text, cop, true )
	end

	local text_criminal = RayUI.GetPhrase("hud", "arrested_criminal")
	text_criminal = string.Replace( text_criminal, "%C", cop and cop:Nick() or "Unknown" )
	text_criminal = string.Replace( text_criminal, "%T", time )

	RayHUD.SendHUDPopup( ColorsTable.Red, RayUI.GetPhrase("hud", "arrested"), text_criminal, criminal, true )
end)

hook.Add("playerUnArrested","RayHUD:PlayerUnArrested",function( criminal, cop )
	if !IsValid(criminal) then return end

	if IsValid(cop) then
		local cop_text = RayUI.GetPhrase("hud",  "unarrested_cop" )
		cop_text = string.Replace(cop_text, "%C", criminal:Name())

		RayHUD.SendHUDPopup( ColorsTable.Red, RayUI.GetPhrase("hud",  "unarrested" ), cop_text, cop )
	end

	local text_criminal = RayUI.GetPhrase("hud", "unarrested_criminal")
	text_criminal = string.Replace( text_criminal, "%C", cop and cop:Nick() or "Unknown" )

	RayHUD.SendHUDPopup( ColorsTable.Red, RayUI.GetPhrase("hud",  "unarrested" ), text_criminal, criminal )
end)
-- 76561198166995699
--[[------------------------------
    Crash Screen
--------------------------------]]

util.AddNetworkString("RayHUD:UpdateConnectonStatus")

timer.Create("RayHUD:CrashScreenUpdater", 2, 0, function()
	net.Start("RayHUD:UpdateConnectonStatus")
	net.Broadcast()
end)

--[[------------------------------
    Job Voting
--------------------------------]]

util.AddNetworkString("RayHUD:DarkRP_Vote")

--Add a hook for when a vote occurs.
hook.Add("onVoteStarted", "RayHUD:onVoteStarted",function( voteTbl )
	local rf = RecipientFilter()
	rf:AddAllPlayers()

	for k,v in ipairs(voteTbl.exclude) do
		rf:RemovePlayer(k)
	end

	net.Start("RayHUD:DarkRP_Vote")
		net.WriteUInt(voteTbl.id,10)
		net.WriteString(voteTbl.question)
		net.WriteUInt(voteTbl.time,8)
	net.Send(rf)

end)

--[[------------------------------
Vehicle Locking
--------------------------------]]

util.AddNetworkString("RayHUD:RequestLockUpdate")
util.AddNetworkString("RayHUD:UpdateLockStatus")

local function updateLocked( ent )
	timer.Simple(0.1,function(  )

		if !IsValid(ent) then return end
		if !ent:IsVehicle() then return end

		net.Start("RayHUD:UpdateLockStatus")
			net.WriteBit(ent:GetSaveTable().VehicleLocked)
			net.WriteEntity(ent)
		net.Broadcast()

	end)
end

hook.Add("onKeysLocked", "RayHUD:UpdateLock", updateLocked)
hook.Add("onKeysUnlocked", "RayHUD:UpdateUnlocked", updateLocked)

net.Receive("RayHUD:RequestLockUpdate", function( _, ply )
	local ent = net.ReadEntity()

	if !IsValid(ent) then return end
	if !ent:IsVehicle() then return end

	net.Start("RayHUD:UpdateLockStatus")
		net.WriteBit(ent:GetSaveTable().VehicleLocked)
		net.WriteEntity(ent)
	net.Send(ply)
end)