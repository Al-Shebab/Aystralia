-- FlatHUD Owner: 76561198166995690
-- FlatHUD Version: 1.1.1

local ColorsTable = {
	Blue = Color(0, 150, 255),
	Red = Color(200, 40, 40),
}

--[[------------------------------
    Props Counter
--------------------------------]]

util.AddNetworkString("FlatHUD:UpdateProplimit")
util.AddNetworkString("FlatHUD:SendHUDPopup")

local PLAYER = FindMetaTable("Player")

PLAYER.AddCount_Old = PLAYER.AddCount_Old or PLAYER.AddCount

function PLAYER:AddCount( str, ent, ... )
	if IsValid(ent) and IsEntity(ent) and ent:GetClass() == "prop_physics" then
		self.FlatHUD_Props = self.FlatHUD_Props + 1
		ent.FlatHUD_Owner = self

		net.Start("FlatHUD:UpdateProplimit")
			net.WriteUInt(self.FlatHUD_Props, 11)
		net.Send(self)
	end

	return self:AddCount_Old(str, ent, ...)
end

hook.Add("PlayerInitialSpawn", "FlatHUD:SetProps",function( ply )
	ply.FlatHUD_Props = 0
end)

hook.Add("EntityRemoved", "FlatHUD:PropRemoved", function( ent )
	if ent.FlatHUD_Owner and IsValid(ent.FlatHUD_Owner) and ent.FlatHUD_Owner.FlatHUD_Props then

		ent.FlatHUD_Owner.FlatHUD_Props = math.max(ent.FlatHUD_Owner.FlatHUD_Props - 1, 0)

		net.Start("FlatHUD:UpdateProplimit")
			net.WriteUInt(ent.FlatHUD_Owner.FlatHUD_Props, 11)
		net.Send(ent.FlatHUD_Owner)
	end
end)

function FlatHUD.SendHUDPopup( color, title, message, rf, important )
	net.Start("FlatHUD:SendHUDPopup")
		net.WriteColor(color)
		net.WriteString(title)
		net.WriteString(message)
		net.WriteBool(important)
	net.Send(rf)
end

--[[------------------------------
    Events Hooks
--------------------------------]]

hook.Add("playerWanted", "FlatHUD:PlayerWanted", function( criminal, cop, reason )
	if !IsValid(criminal) then return end
	reason = reason or ""

	if IsValid(cop) then
		local cop_text = FlatHUD.GetPhrase("wanted_cop")
		cop_text = string.Replace( cop_text, "%C", criminal:Nick() )
		cop_text = string.Replace( cop_text, "%R", reason )

		FlatHUD.SendHUDPopup( ColorsTable.Blue, FlatHUD.GetPhrase("wanted"), cop_text, cop, true )
	end

	local text_criminal = FlatHUD.GetPhrase("wanted_criminal")
	text_criminal = string.Replace( text_criminal, "%R", reason )
	text_criminal = string.Replace( text_criminal, "%C", cop and cop:Nick() or "Unknown" )

	if cop != criminal then
		FlatHUD.SendHUDPopup( ColorsTable.Blue, FlatHUD.GetPhrase("wanted"), text_criminal, criminal, true )
	end

	local text_all = FlatHUD.GetPhrase("wanted_all")
	text_all = string.Replace( text_all, "%CR", criminal:Nick() )
	text_all = string.Replace( text_all, "%R", reason )
	text_all = string.Replace( text_all, "%C", cop and cop:Nick() or "Unknown" )

	for k,v in ipairs(player.GetAll()) do
		if v != cop and v != criminal then
			FlatHUD.SendHUDPopup( ColorsTable.Blue, FlatHUD.GetPhrase("wanted"), text_all, v, true )
		end
	end

	return true
end)

hook.Add("playerUnWanted", "FlatHUD:playerUnWanted", function( criminal, cop )
	if !IsValid(criminal) then return end

	if IsValid(cop) then
		local cop_text = FlatHUD.GetPhrase("unwanted_cop")
		cop_text = string.Replace( cop_text, "%C", criminal:Nick() )

		FlatHUD.SendHUDPopup( ColorsTable.Blue, FlatHUD.GetPhrase("unwanted"), cop_text, cop )
	end

	local text_criminal = FlatHUD.GetPhrase("unwanted_criminal")
	text_criminal = string.Replace( text_criminal, "%C", cop and cop:Nick() or "Unknown" )

	if cop != criminal then
		FlatHUD.SendHUDPopup( ColorsTable.Blue, FlatHUD.GetPhrase("unwanted"), text_criminal, criminal )
	end

	local text_all = FlatHUD.GetPhrase("unwanted_all")
	text_all = string.Replace( text_all, "%C", criminal:Nick() )

	for k,v in ipairs(player.GetAll()) do
		if v != cop and v != criminal then
			FlatHUD.SendHUDPopup( ColorsTable.Blue, FlatHUD.GetPhrase("unwanted"), text_all, v )
		end
	end

	return true
end)

hook.Add("playerWarranted", "FlatHUD:playerWarranted", function( criminal, cop, reason )
	if !IsValid(criminal) then return end
	reason = reason or ""

	local cop_text = FlatHUD.GetPhrase("warranted_cop")
	cop_text = string.Replace( cop_text, "%C", criminal:Nick() )

	for k,v in ipairs(player.GetAll()) do
		if v:getJobTable().category == "Civil Protection" or v:HasWeapon( "door_ram" ) then
			FlatHUD.SendHUDPopup( ColorsTable.Blue, FlatHUD.GetPhrase("warranted"), cop_text, v, true )
		end
	end

	local text_criminal = FlatHUD.GetPhrase("warranted_criminal")
	text_criminal = string.Replace( text_criminal, "%C", cop and cop:Nick() or "Unknown" )
	text_criminal = string.Replace( text_criminal, "%R", reason )

	if cop != criminal then
		FlatHUD.SendHUDPopup( ColorsTable.Blue, FlatHUD.GetPhrase("warranted"), text_criminal, criminal, true )
	end

	return true
end)

hook.Add("playerUnWarranted", "FlatHUD:playerUnWarranted", function( criminal, cop )
	if !IsValid(criminal) then return end

	local cop_text = FlatHUD.GetPhrase("unwarranted_cop")
	cop_text = string.Replace( cop_text, "%C", criminal:Nick() )

	FlatHUD.SendHUDPopup( ColorsTable.Blue, FlatHUD.GetPhrase("unwarranted"), cop_text, cop )

	local all_text = FlatHUD.GetPhrase("unwarranted_all")
	all_text = string.Replace( all_text, "%C", cop:Nick() )
	all_text = string.Replace( all_text, "%S", criminal:Nick() )

	for k,v in ipairs(player.GetAll()) do
		if v != cop and (v:getJobTable().category == "Civil Protection" or v:HasWeapon( "door_ram" )) then
			FlatHUD.SendHUDPopup( ColorsTable.Blue, FlatHUD.GetPhrase("unwarranted"), all_text, v )
		end
	end

	if cop != criminal then
		FlatHUD.SendHUDPopup( ColorsTable.Blue, FlatHUD.GetPhrase("unwarranted"), FlatHUD.GetPhrase("unwarranted_criminal"), criminal )
	end

	return true
end)

hook.Add("playerArrested", "FlatHUD:playerArrested", function( criminal, time, cop )
	if !IsValid(criminal) or !time then return end

	if IsValid(cop) then
		local cop_text = FlatHUD.GetPhrase("arrested_cop")
		cop_text = string.Replace( cop_text, "%C", criminal:Nick() )
		cop_text = string.Replace( cop_text, "%T", time )

		FlatHUD.SendHUDPopup( ColorsTable.Red, FlatHUD.GetPhrase("arrested"), cop_text, cop, true )
	end

	local text_criminal = FlatHUD.GetPhrase("arrested_criminal")
	text_criminal = string.Replace( text_criminal, "%C", cop and cop:Nick() or "Unknown" )
	text_criminal = string.Replace( text_criminal, "%T", time )

	FlatHUD.SendHUDPopup( ColorsTable.Red, FlatHUD.GetPhrase("arrested"), text_criminal, criminal, true )
end)

hook.Add("playerUnArrested","FlatHUD:PlayerUnArrested",function( criminal, cop )
	if !IsValid(criminal) then return end

	if IsValid(cop) then
		local cop_text = FlatHUD.GetPhrase( "unarrested_cop" )
		cop_text = string.Replace(cop_text, "%C", criminal:Name())

		FlatHUD.SendHUDPopup( ColorsTable.Red, FlatHUD.GetPhrase( "unarrested" ), cop_text, cop )
	end

	local text_criminal = FlatHUD.GetPhrase("unarrested_criminal")
	text_criminal = string.Replace( text_criminal, "%C", cop and cop:Nick() or "Unknown" )

	FlatHUD.SendHUDPopup( ColorsTable.Red, FlatHUD.GetPhrase( "unarrested" ), text_criminal, criminal )
end)
-- 76561198166995699
--[[------------------------------
    Crash Screen
--------------------------------]]

util.AddNetworkString("FlatHUD:UpdateConnectonStatus")

timer.Create("FlatHUD:CrashScreenUpdater", 2, 0, function()
	net.Start("FlatHUD:UpdateConnectonStatus")
	net.Broadcast()
end)

--[[------------------------------
    Job Voting
--------------------------------]]

util.AddNetworkString("FlatHUD:DarkRP_Vote")

--Add a hook for when a vote occurs.
hook.Add("onVoteStarted","FlatHUD:onVoteStarted",function( voteTbl )
	local rf = RecipientFilter()
	rf:AddAllPlayers()

	for k,v in ipairs(voteTbl.exclude) do
		rf:RemovePlayer(k)
	end

	net.Start("FlatHUD:DarkRP_Vote")
		net.WriteUInt(voteTbl.id,10)
		net.WriteString(voteTbl.question)
		net.WriteUInt(voteTbl.time,8)
	net.Send(rf)

end)