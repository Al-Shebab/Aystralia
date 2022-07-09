surface.CreateFont('OSXItem', {
	size = 26,
	weight = 400,
	font = 'Helvetica',
	extended = true
})

surface.CreateFont('OSXBigTitle', {
	size = 36,
	weight = 400,
	font = 'Helvetica',
	extended = true
})

surface.CreateFont('OSXTitle', {
	size = 23,
	weight = 400,
	font = 'Helvetica',
	extended = true
})

surface.CreateFont('OSXButton', {
	size = 20,
	weight = 400,
	font = 'Helvetica',
	extended = true
})

surface.CreateFont('OSXPlaceholder', {
	size = 20,
	weight = 400,
	font = 'Helvetica',
	extended = true,
	italic = true
})

surface.CreateFont('OSXContextMenu', {
	size = 17,
	weight = 400,
	font = 'Helvetica',
	extended = true
})

surface.CreateFont('OSXSmall', {
	size = 16,
	weight = 400,
	font = 'Roboto Bold',
	extended = true
})

local L = F4Menu.GetTranslation

if ValidPanel(f4Frame) then f4Frame:Remove() end

function DarkRP.openF4Menu()
	if ValidPanel(f4Frame) then
		f4Frame:Show()
		f4Frame:InvalidateLayout()
	else
		f4Frame = vgui.Create('OSXFrame')
		DarkRP.hooks.F4MenuTabs()
		hook.Call('F4MenuTabs')
	end
end

function DarkRP.closeF4Menu()
	if f4Frame then
		f4Frame:Hide()
	end
end

function DarkRP.toggleF4Menu()
	if not ValidPanel(f4Frame) or not f4Frame:IsVisible() then
		DarkRP.openF4Menu()
	else
		DarkRP.closeF4Menu()
	end
end

function DarkRP.getF4MenuPanel()
	return f4Frame
end

function DarkRP.addF4MenuTab(name, panel)
	if not f4Frame then DarkRP.error('DarkRP.addF4MenuTab called at the wrong time. Please call in the F4MenuTabs hook.', 2) end

	return f4Frame:CreateTab(name, panel)
end

function DarkRP.addF4MenuSpacer()
	if not f4Frame then DarkRP.error('DarkRP.addF4MenuTab called at the wrong time. Please call in the F4MenuTabs hook.', 2) end

	return f4Frame:AddSpacer()
end

function DarkRP.removeF4MenuTab(name)
	if not f4Frame then DarkRP.error('DarkRP.addF4MenuTab called at the wrong time. Please call in the F4MenuTabs hook.', 2) end

	f4Frame:RemoveTab(name)
end

function DarkRP.switchTabOrder(tab1, tab2)
	if not f4Frame then DarkRP.error('DarkRP.addF4MenuTab called at the wrong time. Please call in the F4MenuTabs hook.', 2) end

	f4Frame:switchTabOrder(tab1, tab2)
end

function DarkRP.addURL(name, url)
	if not f4Frame then DarkRP.error('DarkRP.addURL called at the wrong time. Please call in the F4MenuTabs hook.', 2) end
	local button = vgui.Create('OSXTabButton')
	button:SetText(name)
	button.DoClick = function()
		gui.OpenURL(url)
	end
	f4Frame:AddButton(button)
end

function DarkRP.hooks.F4MenuTabs()
	DarkRP.addF4MenuTab(DarkRP.getPhrase('jobs'), vgui.Create('OSXJobs'))
	DarkRP.addF4MenuTab(DarkRP.getPhrase('F4entities'), vgui.Create('OSXEntities'))

	local shipments = fn.Filter(fn.Compose{fn.Not, fn.Curry(fn.GetValue, 2)('noship')}, CustomShipments)
	if table.Count(shipments) > 0 then
		DarkRP.addF4MenuTab(DarkRP.getPhrase('Shipments'), vgui.Create('OSXShipments'))
	end

	local guns = fn.Filter(fn.Curry(fn.GetValue, 2)('separate'), CustomShipments)
	if table.Count(guns) > 0 then
		DarkRP.addF4MenuTab(DarkRP.getPhrase('F4guns'), vgui.Create('OSXGuns'))
	end

	if table.Count(GAMEMODE.AmmoTypes) > 0 then
		DarkRP.addF4MenuTab(DarkRP.getPhrase('F4ammo'), vgui.Create('OSXAmmo'))
	end

	 if table.Count(CustomVehicles) > 0 then
        DarkRP.addF4MenuTab(DarkRP.getPhrase("F4vehicles"), vgui.Create("OSXVehicles"))
    end
end

hook.Add('F4MenuTabs', 'ExternalLinks', function()
	if table.Count(F4Menu.Links) == 0 then return end

	DarkRP.addF4MenuSpacer()

	for name, url in pairs(F4Menu.Links) do
		DarkRP.addURL(name, url)
	end
end)

hook.Add('F4MenuCommands', 'Config', function(self)
	local localPlayer = LocalPlayer()
	local commandMenu = OSXMenu()

	commandMenu:AddOption(L'drop_money', function()
		self:StringRequest(L'how_much_money', L'amount', function(value)
			LocalPlayer():ConCommand('darkrp dropmoney ' .. tostring(value))
		end, true)
	end)

	commandMenu:AddOption(L'drop_weapon', function()
		LocalPlayer():ConCommand('darkrp drop')
	end)

	commandMenu:AddOption(L'change_name', function()
		self:StringRequest(LocalPlayer():Nick(), L'nickname', function(value)
			LocalPlayer():ConCommand('darkrp name ' .. tostring(value))
		end)
	end)

	commandMenu:AddOption(L'change_job', function()
		self:StringRequest(team.GetName(LocalPlayer():Team()), L'job', function(value)
			LocalPlayer():ConCommand('darkrp job ' .. tostring(value))
		end)
	end)

	commandMenu:AddOption(L'sleep', function()
		LocalPlayer():ConCommand('darkrp sleep')
	end)

	commandMenu:AddOption(L'request_license', function()
		LocalPlayer():ConCommand('darkrp requestlicense')
	end)

	commandMenu:AddOption(L'advert', function()
		self:StringRequest('', L'advert', function(value)
			LocalPlayer():ConCommand('say /advert ' .. tostring(value) .. '')
		end)
	end)

	local agenda = localPlayer:getAgendaTable()
    local plyTeam = localPlayer:Team()
	local canAgenda = agenda and agenda.ManagersByKey[plyTeam]
	local canLockdown = localPlayer:isMayor()

	if canAgenda or canLockdown then
		commandMenu:AddSpacer()
	end

	if canLockdown then
		commandMenu:AddOption(L'lockdown', function()
			local lockdown = GetGlobalBool('DarkRP_LockDown')
			LocalPlayer():ConCommand(lockdown and 'darkrp unlockdown' or 'darkrp lockdown')
		end)
	end

	if canAgenda then
		commandMenu:AddOption(L'set_agenda', function()
			self:StringRequest('', L'agenda', function(value)
				LocalPlayer():ConCommand('darkrp agenda ' .. tostring(value))
			end)
		end)
	end

	commandMenu:Open()
end)

hook.Add('DarkRPVarChanged', 'RefreshF4Menu', function(ply, varname)
	if ply ~= LocalPlayer() then return end
	timer.Simple(1, function()
		if varname ~= 'money' or not ValidPanel(f4Frame) then return end
		f4Frame:Refresh()
	end)
end)

hook.Add('OnPlayerChangedTeam', 'RefreshF4Menu', function(ply)
	if ply ~= LocalPlayer() then return end
	timer.Simple(1, function()
		if not ValidPanel(f4Frame) then return end
		f4Frame:Refresh()
	end)
end)
