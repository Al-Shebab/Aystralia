net.Receive("DRPSP_OpenMenu", function()
	net.Start("DRPSP_GetData")
	net.SendToServer()
	
	net.Receive("DRPSP_GetData", function()
		local data = net.ReadTable()
	
		local window = vgui.Create( "DFrame" )
		if ScrW() > 640 then -- Make it larger if we can.
			window:SetSize( ScrW()*0.4, ScrH()*0.5 )
		else
			window:SetSize( 640, 480 )
		end
		window:Center()
		window:SetTitle( "Manage DarkRP Spawns" )
		window:SetVisible( true )
		window:MakePopup()
		
		local spawnsList = vgui.Create("DListView", window)
		spawnsList:SetPos(0, 23)
		spawnsList:SetSize(window:GetWide(), window:GetTall() * 0.8)
		spawnsList:SetMultiSelect(false)
		spawnsList:AddColumn("Job name")
		spawnsList:AddColumn("Position")
		
		local function constructList()
			spawnsList:Clear()
				for k,v in pairs(data) do
				spawnsList:AddLine(k, v)
			end
		end
		constructList()
		
		local addSpawnJob = vgui.Create("DComboBox", window)
		addSpawnJob:SetPos(130, window:GetTall() - 42.5)
		addSpawnJob:SetSize(150, addSpawnJob:GetTall())
		for k,v in pairs(RPExtraTeams) do
			addSpawnJob:AddChoice(v.name)
		end
		
		local addSpawnButton = vgui.Create("DButton", window)
		addSpawnButton:SetText("Add New")
		addSpawnButton:SizeToContents()
		addSpawnButton:SetSize(addSpawnButton:GetWide(), 22)
		addSpawnButton:SetPos(addSpawnButton:GetWide() * 1, window:GetTall() - 42.5)
		addSpawnButton.DoClick = function()
			if(addSpawnJob:GetSelected() != nil) then
				data[addSpawnJob:GetSelected()] = LocalPlayer():GetPos()
				constructList()
			
				net.Start("DRPSP_SetData")
				net.WriteInt(0, 32)
				net.WriteString(addSpawnJob:GetSelected())
				net.SendToServer()
			end
		end
		
		local deleteSpawn = vgui.Create("DButton", window)
		deleteSpawn:SetText("Delete Selected")
		deleteSpawn:SizeToContents()
		deleteSpawn:SetSize(deleteSpawn:GetWide(), 22)
		deleteSpawn:SetPos(window:GetWide() - deleteSpawn:GetWide() * 1.5, window:GetTall() - 42.5)
		deleteSpawn.DoClick = function()
			if(spawnsList:GetSelectedLine() == nil) then return end
			data[spawnsList:GetLine(spawnsList:GetSelectedLine()):GetValue(1)] = nil
			
			net.Start("DRPSP_SetData")
			net.WriteInt(1, 32)
			net.WriteString(spawnsList:GetLine(spawnsList:GetSelectedLine()):GetValue(1))
			net.SendToServer()
			
			constructList()
		end
		
		local teleportSpawn = vgui.Create("DButton", window)
		teleportSpawn:SetText("Teleport Selected")
		teleportSpawn:SizeToContents()
		teleportSpawn:SetSize(teleportSpawn:GetWide(), 22)
		teleportSpawn:SetPos(window:GetWide() - teleportSpawn:GetWide() * 2.5, window:GetTall() - 42.5)
		teleportSpawn.DoClick = function()
			if(spawnsList:GetSelectedLine() == nil) then return end
			
			net.Start("DRPSP_SetData")
			net.WriteInt(2, 32)
			net.WriteString(spawnsList:GetLine(spawnsList:GetSelectedLine()):GetValue(1))
			net.SendToServer()
		end
	end)
end)