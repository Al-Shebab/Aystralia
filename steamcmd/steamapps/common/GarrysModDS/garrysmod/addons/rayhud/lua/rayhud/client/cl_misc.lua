-- RayHUD Owner: 76561198166995690
-- RayHUD Version: 1.2.5

local ply = LocalPlayer()

local spawnMenuOpen = false

hook.Add("OnSpawnMenuOpen", "RayHUD:SpawnMenuOpen", function()
	if !RayUI.Configuration.GetConfig( "HideOnSpawnMenu" ) then return end
	spawnMenuOpen = true
	RayHUD.RunVisibilityCheck()
end)

hook.Add("OnSpawnMenuClose", "RayHUD:SpawnMenuClose", function()
	if !RayUI.Configuration.GetConfig( "HideOnSpawnMenu" ) then return end
	spawnMenuOpen = false
	RayHUD.RunVisibilityCheck()
end)

local nextTimerCheck = 0
RayHUD.shouldDraw = true
RayHUD.DrawOnSB = false

function RayHUD.RunVisibilityCheck()
	nextTimerCheck = os.time() + 1

	if GetConVar("cl_drawhud"):GetInt() == 0 or gui.IsGameUIVisible() or RayHUD.Disconnected == true or spawnMenuOpen or RayHUD.DrawOnSB then
		RayHUD.shouldDraw = false
	else
		local wep = ply:GetActiveWeapon()

		if IsValid(wep) then
			if wep:GetClass() == "gmod_camera" then
				RayHUD.shouldDraw = false
			else
				RayHUD.shouldDraw = true
			end
		else
			RayHUD.shouldDraw = true
		end
	end

	for k, v in ipairs(RayHUD.FlatPanels) do
		if !IsValid(v) or v.custom then continue end

		local Alpha = v:GetAlpha()

		if v.OnTab then
			if ply:KeyDown( IN_SCORE ) then
			 	v:AlphaTo(255, 0.1)
			else
				v:AlphaTo(0, 0.1)
			end
		else
			if RayHUD.shouldDraw == true and Alpha == 0 then
				v:AlphaTo(255, 0.1)
			elseif RayHUD.shouldDraw == false and Alpha == 255 then
				v:AlphaTo(0, 0.1)
			end
		end
	end
end

hook.Add("Think","RayHUD:ShouldDrawHUD",function()
	if nextTimerCheck > os.time() then return end
	RayHUD.RunVisibilityCheck()
end)

hook.Add("RayHUD:Reload", "RayHUD:UnloadVisibilityCheck", function()
	hook.Remove("OnSpawnMenuOpen", "RayHUD:SpawnMenuOpen")
	hook.Remove("OnSpawnMenuClose", "RayHUD:SpawnMenuClose")
	hook.Remove("Think","RayHUD:ShouldDrawHUD")
end)

--[[------------------------------
    Door Menu
--------------------------------]]

if RayUI.Configuration.GetConfig( "DoorMenu" ) then
	local buttonInfo = {
		[DarkRP.getPhrase("buy_x", DarkRP.getPhrase("door"))] = {RayUI.Icons.Money, RayUI.GetPhrase("hud", "buy_door"), RayUI.Colors.Green},
		[DarkRP.getPhrase("sell_x", DarkRP.getPhrase("door"))] = {RayUI.Icons.Money, RayUI.GetPhrase("hud", "sell_door"), RayUI.Colors.Green},

		[DarkRP.getPhrase("buy_x", DarkRP.getPhrase("vehicle"))] = {RayUI.Icons.Money, RayUI.GetPhrase("hud", "buy_vehicle"), RayUI.Colors.Green},
		[DarkRP.getPhrase("sell_x", DarkRP.getPhrase("vehicle"))] = {RayUI.Icons.Money, RayUI.GetPhrase("hud", "sell_vehicle"), RayUI.Colors.Green},

		[DarkRP.getPhrase("add_owner")] = {RayUI.Icons.AddUser, RayUI.GetPhrase("hud", "add_owner"), RayUI.Colors.Green},
		[DarkRP.getPhrase("remove_owner")] = {RayUI.Icons.RemoveUser, RayUI.GetPhrase("hud", "remove_owner"), RayUI.Colors.HP},

		[DarkRP.getPhrase("allow_ownership")] = {RayUI.Icons.AddUser, RayUI.GetPhrase("hud", "allow_ownership"), RayUI.Colors.Green},
		[DarkRP.getPhrase("disallow_ownership")] = {RayUI.Icons.BanUser, RayUI.GetPhrase("hud", "disallow_ownership"), RayUI.Colors.HP},

		[DarkRP.getPhrase("set_x_title", DarkRP.getPhrase("door"))] = {RayUI.Icons.Text, RayUI.GetPhrase("hud", "set_door_title"), RayUI.Colors.Orange},
		[DarkRP.getPhrase("set_x_title", DarkRP.getPhrase("vehicle"))] = {RayUI.Icons.Text, RayUI.GetPhrase("hud", "set_vehicle_title"), RayUI.Colors.Orange},

		[DarkRP.getPhrase("edit_door_group")] = {RayUI.Icons.Cog, RayUI.GetPhrase("hud", "edit_groups"), RayUI.Colors.Armor},
	}

	if lockpeek and lockpeek.L then
		local LockPeekTBL = {[lockpeek.L"upgrade"] = {RayUI.Icons.Lock, RayUI.GetPhrase("hud", "upgrade_lock"), RayUI.Colors.Yellow}}
		table.Merge(buttonInfo, LockPeekTBL)
	end

	if DOORSKIN then
		local DoorSkinTBL = {["Edit Door Appearance"] = {RayUI.Icons.Gesture, RayUI.GetPhrase("hud", "edit_door_appearance"), RayUI.Colors.Blue}}
		table.Merge(buttonInfo, DoorSkinTBL)
	end

	hook.Add("onKeysMenuOpened", "RayHUD:DoorMenu", function( ent, frame )
		hook.Add("HUDShouldDraw", "RayHUD:RemoveCrosshair_DoorMenu",function( name )
			if name == "CHudCrosshair" then return false end
		end)

		local oldFunc = frame.OnRemove or function(  ) end

		frame.OnRemove = function( ... )
			hook.Remove("HUDShouldDraw","RayHUD:RemoveCrosshair_DoorMenu")
			return oldFunc(...)
		end

		local panels = frame:GetChildren()

		for i = 1,4 do
			panels[i]:Remove()
			panels[i] = nil
		end

		panels = table.ClearKeys(panels)
		local PanelsCount = #panels


		frame.PerformLayout = function() end
		frame:SetSize(450 * RayUI.Scale, 49 * RayUI.Scale + 44 * RayUI.Scale * math.ceil(PanelsCount / 2))

		frame.Paint = function (self, w, h)
			RayUI:DrawBlur(self)
			RayUI:DrawMaterialBox("Door options", 0, 0, w, h, RayUI.Icons.Door)
		end

		local PosData = {}
		local x = 10 * RayUI.Scale

		for i = 1, PanelsCount do
			if (i % 2 == 0) then x = 230 * RayUI.Scale else x = 10 * RayUI.Scale end
			table.insert( PosData, { x = x, y = 44 * RayUI.Scale * math.ceil(i / 2) + 6 * RayUI.Scale} )
		end

		for k, v in ipairs(panels) do
			v:SetFont("RayUI:Medium2")
			v:SetSize(210 * RayUI.Scale, 34 * RayUI.Scale)
			v:SetPos(PosData[k].x, PosData[k].y)

			local icon = buttonInfo[v:GetValue()] and buttonInfo[v:GetValue()][1]
			local but_color = buttonInfo[v:GetValue()] and buttonInfo[v:GetValue()][3]

			v.Paint = function( s, w, h )
				draw.RoundedBox(6, 0, 0, w, h, RayUI.Colors.DarkGray5)

				if v:IsHovered() then
					surface.SetDrawColor(but_color)
					v:SetTextColor(but_color)
				else
					surface.SetDrawColor(color_white)
					v:SetTextColor(color_white)
				end

				surface.SetMaterial(icon or RayUI.Icons.Cog)
				surface.DrawTexturedRect(w - 30 * RayUI.Scale, h * 0.15 * RayUI.Scale, 24 * RayUI.Scale, 24 * RayUI.Scale)
			end

			v:SetText(buttonInfo[v:GetValue()] and buttonInfo[v:GetValue()][2])
		end

		local closeCooldown = CurTime() + 0.2
		local allowClose = false

		frame.Think = function()
			if input.IsKeyDown(KEY_F2) then
				if closeCooldown > CurTime() or !allowClose then return end
				frame:Close()
			else
				allowClose = true
			end
		end

		local CloseBut = vgui.Create("DButton", frame)
		CloseBut:SetText( "" )
		CloseBut:SetSize(41, 41)
		CloseBut:SetPos(frame:GetWide() - 41, 2)
		CloseBut.DoClick = function()
			frame:Close()
		end
		CloseBut.Paint = function( s, w, h )
			surface.SetMaterial( RayUI.Icons.Close )
			surface.SetDrawColor( RayUI.Colors.White )
			surface.DrawTexturedRect(0, 8 * RayUI.Scale, 24 * RayUI.Scale, 24 * RayUI.Scale)
		end
	end)

	hook.Add("RayHUD:Reload", "RayHUD:UnloadDoorMenu", function()
		hook.Remove("onKeysMenuOpened", "RayHUD:DoorMenu")
		hook.Remove("HUDShouldDraw", "RayHUD:RemoveCrosshair_DoorMenu")
	end)
else
	hook.Remove("onKeysMenuOpened", "RayHUD:DoorMenu")
	hook.Remove("HUDShouldDraw", "RayHUD:RemoveCrosshair_DoorMenu")
end

--[[------------------------------
    Gesture Menu
--------------------------------]]

local open

concommand.Add("_darkrp_animationmenu", function(  )
	if open then return end

	gesturePanels = {}

	hook.Add("HUDShouldDraw","RayHUD:RemoveCrosshair_GestureMenu",function( name )
		if name == "CHudCrosshair" then return false end
	end)

	local animations = {
		[ACT_GMOD_GESTURE_BOW] = RayUI.GetPhrase("hud", "gesture_bow"),
		[ACT_GMOD_TAUNT_MUSCLE] = RayUI.GetPhrase("hud", "gesture_sexydance"),
		[ACT_GMOD_GESTURE_BECON] = RayUI.GetPhrase("hud", "gesture_follow_me"),
		[ACT_GMOD_TAUNT_LAUGH] = RayUI.GetPhrase("hud", "gesture_laugh"),
		[ACT_GMOD_TAUNT_PERSISTENCE] = RayUI.GetPhrase("hud", "gesture_lion_pose"),
		[ACT_GMOD_GESTURE_DISAGREE] = RayUI.GetPhrase("hud", "gesture_nonverbal_no"),
		[ACT_GMOD_GESTURE_AGREE] = RayUI.GetPhrase("hud", "gesture_thumbs_up"),
		[ACT_GMOD_GESTURE_WAVE] = RayUI.GetPhrase("hud", "gesture_wave"),
		[ACT_GMOD_TAUNT_DANCE] = RayUI.GetPhrase("hud", "gesture_dance"),
	}

	local gestureFrame = vgui.Create("DPanel")

	for k, v in pairs(animations) do
		local gestureButton = vgui.Create("DButton", gestureFrame)
		gestureButton:SetText(v)

		gestureButton.DoClick = function(  )
			RunConsoleCommand("_DarkRP_DoAnimation", k)
			gestureFrame:Remove()
		end

		table.insert(gesturePanels, gestureButton)
	end

	gestureFrame:SetSize(450 * RayUI.Scale, 49 * RayUI.Scale + 44 * RayUI.Scale * math.ceil(#gesturePanels / 2))
	gestureFrame:Center()
	gestureFrame:MakePopup()
	gestureFrame.Paint = function(self, w, h)
		RayUI:DrawBlur(self)
		RayUI:DrawMaterialBox("Gestures", 0, 0, w, h, RayUI.Icons.Gesture)
	end

	local PosData = {}
	local x = 10 * RayUI.Scale

	for i = 1, #gesturePanels do
		if (i % 2 == 0) then x = 230 * RayUI.Scale else x = 10 * RayUI.Scale end
		table.insert( PosData, { x = x, y = 44 * RayUI.Scale * math.ceil(i / 2) + 6} )
	end

	for k,v in ipairs(gesturePanels) do
		if PosData[k] then
			v:SetSize(210 * RayUI.Scale, 34 * RayUI.Scale)
			v:SetPos(PosData[k].x, PosData[k].y)
			v:SetFont("RayUI:Medium2")

			v.Paint = function( s, w, h )
				draw.RoundedBox(6, 0, 0, w, h, RayUI.Colors.DarkGray5)

				if v:IsHovered() then
					v:SetTextColor(RayUI.Colors.Armor)
				else
					v:SetTextColor(color_white)
				end
			end
		end
	end

	local CloseBut = vgui.Create("DButton", gestureFrame)
	CloseBut:SetText( "" )
	CloseBut:SetSize(41 * RayUI.Scale, 41 * RayUI.Scale)
	CloseBut:SetPos(gestureFrame:GetWide() - 32 * RayUI.Scale, 2 * RayUI.Scale)
	CloseBut.DoClick = function()
		gestureFrame:Remove()
	end
	CloseBut.Paint = function( s, w, h )
		surface.SetMaterial( RayUI.Icons.Close )
		surface.SetDrawColor( RayUI.Colors.White )
		surface.DrawTexturedRect(0, 8 * RayUI.Scale, 24 * RayUI.Scale, 24 * RayUI.Scale)
	end

	gestureFrame.OnRemove = function()
		open = false
	end

	open = true
end)

--[[------------------------------
    HUDPickup
--------------------------------]]

local screenHeight = ScrH()

local itemPickupWidth = math.floor(screenHeight * 0.35)
local minItemPickupWidth = math.floor(screenHeight * 0.18)

local itemHeight = 24 * RayUI.Scale
local itemMargin = 8

local itemPickupHeight = itemHeight * 10 + itemMargin * 9

local items = {}

local PistolIcon = RayUI.Icons.Pistol
local ItemIcon = RayUI.Icons.Cube

local function addNewItem( text, color, icon )
	surface.SetFont("RayUI:Medium2")
	local textWidth = surface.GetTextSize(text)

	local item = {}
	item.text = text
	item.curTime = CurTime() + 5
	item.itemWidth = math.Clamp(textWidth + screenHeight * 0.02, minItemPickupWidth, itemPickupWidth)
	item.color = color
	item.icon = icon

	table.insert(items, item)
end

local itemPickupFrame = vgui.Create("DPanel")
itemPickupFrame:SetSize(itemPickupWidth, itemPickupHeight)
itemPickupFrame:SetPos(ScrW() - RayHUD.OffsetX - itemPickupFrame:GetWide(), screenHeight * 0.35)
itemPickupFrame:ParentToHUD()
-- 76561198166995699
itemPickupFrame.Paint = function(self, w, h)
	for k,v in ipairs(items) do

		v.destination = (itemHeight + itemMargin) * k

		if !v.lerpedYPos then
			v.lerpedYPos = v.destination
			v.lerpedXPos = itemPickupWidth
			v.alpha = 1
		end

		if v.curTime < CurTime() then
			v.alpha = Lerp(FrameTime() * 6.5, v.alpha, 0)
			v.lerpedXPos = Lerp(FrameTime() * 6.5, v.lerpedXPos, w)
		else
			v.lerpedYPos = Lerp(FrameTime() * 8, v.lerpedYPos, v.destination)
			v.lerpedXPos = Lerp(FrameTime() * 12, v.lerpedXPos, itemPickupWidth - v.itemWidth)
		end

		if v.alpha < 0.05 then
			items[k] = nil
			items = table.ClearKeys(items)
			continue
		end

		RayUI:DrawBlur(self, ScrW() - RayHUD.OffsetX - itemPickupFrame:GetWide() + math.Round(v.lerpedXPos), v.itemWidth, screenHeight * 0.35 +  math.Round(v.lerpedYPos),  itemHeight)  

		draw.RoundedBox(6, math.Round(v.lerpedXPos), math.Round(v.lerpedYPos), v.itemWidth, itemHeight, Color(66, 66, 66, RayUI.Opacity * v.alpha))
		draw.RoundedBox(6, math.Round(v.lerpedXPos), math.Round(v.lerpedYPos), itemHeight, itemHeight, Color(v.color.r, v.color.g, v.color.b, 255 * v.alpha))

		surface.SetMaterial( v.icon )
		surface.SetDrawColor( Color(255, 255, 255, 255 * v.alpha) )
		surface.DrawTexturedRect(math.Round(v.lerpedXPos) + itemHeight * .11, math.Round(v.lerpedYPos) + itemHeight * .11 , itemHeight * .8, itemHeight * .8)

		draw.SimpleText( v.text, "RayUI:Medium2", math.Round(v.lerpedXPos) + v.itemWidth / 2 + itemHeight / 2, math.Round(v.lerpedYPos) + itemHeight / 2, Color(255, 255, 255, 255 * v.alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

hook.Add("HUDItemPickedUp","RayHUD:HUDItemPickedUp", function( itemName )
	if !IsValid(ply) or !ply:Alive() then return end

	addNewItem(language.GetPhrase("#" .. itemName), RayUI.Colors.HP, ItemIcon)
end)

hook.Add("HUDWeaponPickedUp","RayHUD:HUDWeaponPickedUp", function( wep )
	if !IsValid(ply) or !ply:Alive() then return end
	if !IsValid(wep) then return end
	if !isfunction(wep.GetPrintName) then return end

	addNewItem(wep:GetPrintName(), RayUI.Colors.Orange, PistolIcon)
end)

hook.Add("HUDAmmoPickedUp", "RayHUD:HUDWeaponPickedUp", function( itemname, amount )
	if !IsValid(ply) or !ply:Alive() then return end

	addNewItem(language.GetPhrase( "#" .. itemname .. "_Ammo" ) .. " +" .. amount, RayUI.Colors.Green, RayUI.Icons.Ammo)
end)

timer.Create("RayHUD:Remove_DrawPickupHistory", 0, 0, function(  )
	GAMEMODE.HUDDrawPickupHistory = function()  end
end)

hook.Add("RayHUD:Reload", "RayHUD:UnloadHUDPickup", function()
	hook.Remove("HUDItemPickedUp","RayHUD:HUDItemPickedUp")
	hook.Remove("HUDWeaponPickedUp","RayHUD:HUDWeaponPickedUp")
	hook.Remove("HUDAmmoPickedUp", "RayHUD:HUDWeaponPickedUp")
	timer.Remove("RayHUD:Remove_DrawPickupHistory")
end)

--[[------------------------------
    Crash Screen
--------------------------------]]

RunConsoleCommand("cl_timeout", 100)

local BackgroundCol = Color(34, 34, 34, 250)

local Background = vgui.Create("DPanel")
Background:SetSize(ScrW(), ScrH())
Background:SetAlpha(0)
Background:SetVisible(false)
Background.Paint = function( self, w, h )
	RayUI:DrawBlur(self)
	draw.RoundedBox(0, 0, 0, w, h, BackgroundCol)
end

local CrashTall = 625 * RayUI.Scale
local SepWide = 2 * RayUI.Scale

local SepPosX = (Background:GetWide() - 600 * RayUI.Scale)
local SepPosY = Background:GetTall() / 2 - CrashTall / 2

local RightWide = ScrW() - SepPosX - SepWide
local LeftWide = ScrW() - RightWide - SepWide

local IconSize = 180 * RayUI.Scale

local Separator = vgui.Create("DPanel", Background)
Separator:SetSize(SepWide, 0)
Separator:SetPos(SepPosX, SepPosY)
Separator.Paint = function( s, w, h )
	draw.RoundedBox(0, 0, 0, w, h, RayUI.Colors.White)
end

local LeftPanel = vgui.Create("DPanel", Background)
LeftPanel:SetSize(LeftWide, CrashTall)
LeftPanel:SetPos(0, SepPosY)
LeftPanel.Paint = function( s, w, h )
end

local InnerLeftPanel = vgui.Create("DPanel", LeftPanel)
InnerLeftPanel:SetSize(LeftWide, CrashTall)
InnerLeftPanel:SetPos(LeftWide, 0)
InnerLeftPanel.Paint = function( s, w, h )
	surface.SetMaterial( RayUI.Icons.ConnectionLost )
	surface.SetDrawColor( RayUI.Colors.White )
	surface.DrawTexturedRect(LeftWide / 2 - IconSize / 2, 100 * RayUI.Scale, IconSize, IconSize)

	draw.SimpleText(RayUI.GetPhrase("hud", "connection_lost"), "RayUI:Largest7", w / 2, 250 * RayUI.Scale, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	draw.SimpleText(RayUI.GetPhrase("hud", "lost_connection"), "RayUI:Largest6", w / 2, 380 * RayUI.Scale, RayUI.Colors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	draw.SimpleText(RayUI.GetPhrase("hud", "reconnected"), "RayUI:Largest6", w / 2, 420 * RayUI.Scale, RayUI.Colors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
end

local ButW = 250 * RayUI.Scale
local ButH = 80 * RayUI.Scale

local RightPanel = vgui.Create("DPanel", Background)
RightPanel:SetSize(0, CrashTall)
RightPanel:SetPos( SepPosX + SepWide, SepPosY)
RightPanel:SetPaintBackground( false )

local Buttons = {
	{
		Name = "Reconnect",
		func = function() return RunConsoleCommand("retry") end
	},
	{
		Name = "Leave",
		func = function() return RunConsoleCommand("disconnect") end
	},
}

for i = 1, #Buttons do
	local but = Buttons[i]
	if i == 2 then ButtonColor = RayUI.Colors.HP end

	local Button = vgui.Create("DButton", RightPanel)
	Button:SetSize(ButW, ButH)
	Button:SetPos(RightWide / 2 - ButW / 2, RightPanel:GetTall() / 2 - ButH / 2 + (ButH + 20) * i - (ButH - 20) * #Buttons)
	Button.DoClick = function()
		but.func()
	end
	Button:FormatRayButton(but.Name, RayUI.Colors.Gray2, i == 1 and RayUI.Colors.Green or RayUI.Colors.HP)
	Button:SetFont("RayUI:Largest6")
end
-- 76561198166995699
local lastPing = os.time()
RayHUD.Disconnected = false

net.Receive("RayHUD:UpdateConnectonStatus", function()
	lastPing = os.time()

	if Background:IsVisible() and IsValid(Background) and RayHUD.Disconnected == false then
		InnerLeftPanel:MoveTo(LeftWide, 0, 0.6)
		RightPanel:SizeTo(0, CrashTall, 0., 0, -1, function()
			Separator:SizeTo(SepWide, 0, 0.6)
			Background:AlphaTo(0, 0.6, 0, function()
				Background:SetVisible(false)
				gui.EnableScreenClicker(false)
			end)
		end)
	end
	RayHUD.Disconnected = false
end)

local nextCheck = 0
hook.Add("Think", "RayHUD:CheckConnectonStatus", function()
	if !RayUI.Configuration.GetConfig( "CrashScreen" ) then return end

	if nextCheck <= CurTime() then
		nextCheck = CurTime() + 2

		if os.time() - lastPing > 5 and RayHUD.Disconnected == false then
			RayHUD.Disconnected = true

			Background:SetVisible(true)
			Background:AlphaTo(255, 0.6, 0)
			Separator:SizeTo(SepWide, CrashTall, 0.6, 0, -1, function()
				InnerLeftPanel:MoveTo(0, 0, 1)
				RightPanel:SizeTo(RightWide, CrashTall, 1)

				gui.EnableScreenClicker(true)
			end)
		end
	end
end)

hook.Add("RayHUD:Reload", "RayHUD:UnloadCrashScreen", function()
	hook.Remove("Think", "RayHUD:CheckConnectonStatus")
end)

--[[------------------------------
	Voice Panel
--------------------------------]]

timer.Remove("RayHUD:LoadVoice")

local function LoadVoice()
	g_VoicePanelList:SetPos( ScrW() - 250 * RayUI.Scale - 12, 0 )
	g_VoicePanelList:SetSize( 250 * RayUI.Scale, ScrH() - 300 * RayUI.Scale )

	VoiceNotify.Init = function( self )
		self.Avatar = vgui.Create( "RoundedAvatar", self )
		self.Avatar:Dock( LEFT )
		self.Avatar:SetSize( 34 * RayUI.Scale, 34 * RayUI.Scale )
		self.Avatar:SetMaskSize(20 * RayUI.Scale)

		self.LabelName = vgui.Create( "DLabel", self )
		self.LabelName:SetFont( "RayUI:Large2" )
		self.LabelName:Dock( LEFT )
		self.LabelName:DockMargin( 13 * RayUI.Scale, 0, 0, 0 )
		self.LabelName:SetTextColor( RayUI.Colors.White )
		self.LabelName:SetWide((250 - 54) * RayUI.Scale)

		self:SetSize( 250 * RayUI.Scale, 46 * RayUI.Scale )
		self:DockPadding( 6 * RayUI.Scale, 6 * RayUI.Scale, 6 * RayUI.Scale, 6 * RayUI.Scale )
		self:DockMargin( 0, 0, 0, 6 )
		self:Dock( BOTTOM )
	end

	VoiceNotify.Paint = function( self, w, h )
		if !IsValid(self.ply) then return end

		draw.RoundedBox( 8, 0, 0, w, h, RayUI.Colors.Gray)
		draw.RoundedBox( 8, 0, 0, w, h, Color(140, 140, 140, 255 * self.ply:VoiceVolume()))
		draw.RoundedBox( 8, 0, 0, h, h, RayUI.Colors.DarkGray3)
	end

	hook.Remove("StartChat", "DarkRP_StartFindChatReceivers")
	hook.Remove("PlayerStartVoice", "DarkRP_VoiceChatReceiverFinder")
end

if !IsValid(g_VoicePanelList) then
	timer.Create("RayHUD:LoadVoice", 1, 60, function()
		if IsValid(g_VoicePanelList) then
			LoadVoice()
			timer.Remove("RayHUD:LoadVoice")
		end
	end)
else
	LoadVoice()
end

--[[------------------------------
	Disable killfeed
--------------------------------]]

if RayUI.Configuration.GetConfig( "DisableKillfeed" ) then
	function GAMEMODE.DrawDeathNotice() end
end

--[[------------------------------
Vehicle Info
--------------------------------]]

if RayUI.Configuration.GetConfig( "VehicleInfo" ) then

	net.Receive("RayHUD:UpdateLockStatus",function(  )
		local isLocked = net.ReadBool()
		local ent = net.ReadEntity()

		if !IsValid(ent) then return end

		ent.RayHUDLocked = isLocked
	end)

	local vehicleList
	local VehName = ""
	local LockIcon = RayUI.Icons.Lock

	local allowedCoOwners = {}
	local coOwners = {}

	local VehicleInfo = vgui.Create("RayHUD:DPanel")
	VehicleInfo:SetSize(390 * RayUI.Scale, 84 * RayUI.Scale)
	VehicleInfo:SetPos(ScrW() / 2 - VehicleInfo:GetWide() / 2, ScrH() * 0.8 - VehicleInfo:GetTall() / 2 )
	VehicleInfo:ParentToHUD()
	VehicleInfo.Paint = function (self, w, h)
		RayUI:DrawBlur(self)

		RayUI:DrawMaterialBox(VehName, 0, 0, w, h, LockIcon)
	end

	VehicleInfo:SetVisible(false)

	local OwnerName = RayUI:MakeLabel("", "RayUI:Large3", color_white, VehicleInfo)
	OwnerName:SetPos(12 * RayUI.Scale, 48 * RayUI.Scale)

	local CoOwnerName = RayUI:MakeLabel("", "RayUI:Large2", color_white, VehicleInfo)
	CoOwnerName:SetPos(12 * RayUI.Scale, 82 * RayUI.Scale)

	local AllowedCoOwnerName = RayUI:MakeLabel("", "RayUI:Large2", color_white, VehicleInfo)
	AllowedCoOwnerName:SetPos(12 * RayUI.Scale, 112 * RayUI.Scale)

	local VehWide = 0
	local VehTall = 0

	local CoOwnersSetTall = false
	local AllowedCoOwnersSetTall = false

	VehicleInfo.SetData = function( title, owner, coOwners, allowedCoOwners, lockstatus )

		VehName = title
		OwnerName:SetText( owner )
		OwnerName:SizeToContents()

		if lockstatus then
			LockIcon = RayUI.Icons.Lock
		else
			LockIcon = RayUI.Icons.Unlock
		end

		if coOwners and coOwners[1] != nil and !CoOwnersSetTall then
			CoOwnerName:SetText(RayUI.GetPhrase("hud", "co_owners") .. table.concat(coOwners, ", "))
			CoOwnerName:SizeToContents()

			VehTall = VehTall + 1
			CoOwnersSetTall = true
		end

		if allowedCoOwners and allowedCoOwners[1] != nil and !AllowedCoOwnersSetTall then
			AllowedCoOwnerName:SetText(RayUI.GetPhrase("hud", "allowed_co_owners") .. table.concat(allowedCoOwners, ", "))
			AllowedCoOwnerName:SizeToContents()

			VehTall = VehTall + 1
			AllowedCoOwnersSetTall = true

			if coOwners[1] == nil then
				AllowedCoOwnerName:SetPos(12 * RayUI.Scale, 82 * RayUI.Scale)
			else
				AllowedCoOwnerName:SetPos(12 * RayUI.Scale, 112 * RayUI.Scale)
			end
		end

		surface.SetFont("RayUI:Largest2")
		VehWide = math.max(OwnerName:GetWide(), CoOwnerName:GetWide(), AllowedCoOwnerName:GetWide(), 48 * RayUI.Scale + select(1, surface.GetTextSize( VehName ))    )

		VehicleInfo:SetWide(24 * RayUI.Scale + VehWide)
		VehicleInfo:SetTall(86 * RayUI.Scale + (34 * VehTall) * RayUI.Scale)
		VehicleInfo:SetPos(ScrW() / 2 - VehicleInfo:GetWide() / 2, ScrH() * 0.8 - VehicleInfo:GetTall() / 2 )

		VehicleInfo:SetVisible(true)

	end

	VehicleInfo.Hide = function()
		VehicleInfo:SetVisible(false)

		allowedCoOwners = {}
		coOwners = {}
		VehTall = 0

		CoOwnersSetTall = false
		AllowedCoOwnersSetTall = false
	end

	timer.Create("RayHUD:CheckVehicleInfo", 0.1, 0, function(  )

		if !IsValid(VehicleInfo) then VehicleInfo.Hide() return end
		if ply:InVehicle() then VehicleInfo.Hide() return end

		local eyeTrace = ply:GetEyeTrace()
		local vehicle = eyeTrace.Entity

		if !vehicle:IsVehicle() then VehicleInfo.Hide() return end

		local vehicleData = vehicle:getDoorData()
		local vehicleClass = vehicle:GetVehicleClass()
		local class = vehicle:GetClass()

		if class == "prop_vehicle_prisoner_pod" then VehicleInfo.Hide() return end
		if ply:GetPos():DistToSqr( vehicle:GetPos() ) > 200^2 then VehicleInfo.Hide() return end

		vehicleList = vehicleList or list.Get("Vehicles")

		if vehicleData.title then
			name = vehicleData.title
		elseif vehicleClass and vehicleList[vehicleClass] then
			name = vehicleList[vehicleClass].Name
		else
			name = RayUI.GetPhrase("hud", "vehicle")
		end

		if vehicleData.groupOwn then
			owner = string.Replace(RayUI.GetPhrase("hud", "vehicle_access_group"), "%G", vehicleData.groupOwn)
		elseif vehicleData.nonOwnable then
			owner = RayUI.GetPhrase("hud", "vehicle_not_ownable")
		elseif vehicleData.teamOwn then
			owner = string.Replace(RayUI.GetPhrase("hud", "vehicle_access_jobs"), "%J", table.Count(vehicleData.teamOwn))
		elseif vehicleData.owner then

			local vehicleOwner = Player(vehicleData.owner)

			if IsValid(vehicleOwner) then
				owner =  RayUI.GetPhrase("hud", "owner") .. ": " .. vehicleOwner:Name()
			else
				owner = RayUI.GetPhrase("hud", "owner") .. ": " .. RayUI.GetPhrase("hud", "owner_unknown")
			end

			if vehicleData.allowedToOwn then
				for k,v in pairs(vehicleData.allowedToOwn) do

					local allowedCoOwner = Player(k)

					if !IsValid(allowedCoOwner) then continue end

					table.insert(allowedCoOwners, allowedCoOwner:Name())
				end
			end

			if vehicleData.extraOwners then
				for k,v in pairs(vehicleData.extraOwners) do

					local CoOwner = Player(k)

					if !IsValid(CoOwner) then continue end

					table.insert(coOwners, CoOwner:Name())
				end
			end

		else
			owner = RayUI.GetPhrase("hud", "vehicle_unowned")
		end

		local lockStatus = false

		if vehicle.RayHUDLocked == nil and (vehicle.RayHUDDataRequest == nil or vehicle.RayHUDDataRequest != nil and vehicle.RayHUDDataRequest + 5 < os.time()) then

			vehicle.RayHUDDataRequest = os.time()

			net.Start("RayHUD:RequestLockUpdate")
				net.WriteEntity(vehicle)
			net.SendToServer()

		else
			lockStatus = vehicle.RayHUDLocked
		end

		VehicleInfo.SetData(name, owner, coOwners, allowedCoOwners, lockStatus)
	end)

	hook.Add("RayHUD:Reload","RayHUD:UnloadVehicleInfo",function(  )
		if IsValid(VehicleInfo) then
			VehicleInfo:Remove()
		end

		timer.Remove("RayHUD:CheckVehicleInfo")
	end)

end

--[[------------------------------
	Levelling System

	Supported:
		- Vrondakis Levelling System
		- Sublime Levels
		- GlorifiedLeveling
--------------------------------]]

RayHUD.LevelPanel = RayUI.Configuration.GetConfig( "LevelPanel" )

local CurLevel = -1
local CurXP = -1
local MaxXP = -1

local newLevel = -1
local newXP = -1

local LevelSystem = RayUI.Configuration.GetConfig( "LevelSystem" )

if LevelSystem != "None" then
	local SmoothLevel = 0

	local width = 390 * RayUI.Scale
	local height = 90 * RayUI.Scale

	if RayUI.Configuration.GetConfig( "MiniMode" ) then width = 230 * RayUI.Scale else width = 390 * RayUI.Scale end

	local WidgetPanel = vgui.Create("RayHUD:DPanel")
	WidgetPanel:SetSize(width, height)
	WidgetPanel:SetPos(RayHUD.OffsetX, ScrH() - 12 * RayUI.Scale - (200 * RayUI.Scale) - RayHUD.OffsetY - height)
	WidgetPanel:SetVisible(true)
	WidgetPanel:ParentToHUD()
	WidgetPanel.Paint = function(self, w, h)
		RayUI:DrawBlur(self)

		if LevelSystem == "Vrondakis Level System" and LevelSystemConfiguration then
			CurLevel = ply:getDarkRPVar("level") or 0
			CurXP = ply:getDarkRPVar("xp") or 0
			MaxXP = math.Round(10 + (CurLevel * (CurLevel + 1) * 90) * LevelSystemConfiguration.XPMult)

			hook.Remove("HUDPaint", "manolis:MVLevels:HUDPaintA")

		elseif LevelSystem == "Sublime Levels" then
			CurLevel = ply:SL_GetLevel() or 0
			CurXP = ply:SL_GetExperience() or 0
			MaxXP = ply:SL_GetNeededExperience()

		elseif LevelSystem == "GlorifiedLeveling" and GlorifiedLeveling then
			CurLevel = GlorifiedLeveling.GetPlayerLevel() or 0
			CurXP = GlorifiedLeveling.GetPlayerXP() or 0
			MaxXP = GlorifiedLeveling.GetPlayerMaxXP()
		else
			return
		end

		RayUI:DrawMaterialBox("Level: " .. CurLevel, 0, 0, w, h, RayUI.Icons.Level)

		SmoothLevel = Lerp(5 * FrameTime(), SmoothLevel, CurXP / MaxXP)
		RayUI:CreateBar( 20, 65 * RayUI.Scale, width - 40 * RayUI.Scale, 10 * RayUI.Scale, RayUI.Colors.LightGreen, RayUI.Colors.Green, SmoothLevel, "XP: " .. CurXP .. " / " .. MaxXP )
	end

	if RayHUD.LevelPanel == "Always Show" then
		WidgetPanel:SetAlpha(255)
	elseif RayHUD.LevelPanel == "Show when opening scoreboard" then
		WidgetPanel.OnTab = true
	elseif RayHUD.LevelPanel == "Hide" then
		WidgetPanel:SetVisible(false)
	elseif RayHUD.LevelPanel == "Show when getting XP" then
		WidgetPanel.custom = true
		WidgetPanel:SetAlpha(0)

		WidgetPanel:SetWide(0)
	end

	local nextClose = 0

	timer.Create("RayHUD:UpdateLevel", 1, 0, function()

		if !IsValid(WidgetPanel) then return end

		if LevelSystem == "Vrondakis Level System" and LevelSystemConfiguration then
			newLevel = ply:getDarkRPVar("level") or 0
			newXP = ply:getDarkRPVar("xp") or 0
		elseif LevelSystem == "Sublime Levels" then
			newLevel = ply:SL_GetLevel() or 0
			newXP = ply:SL_GetExperience() or 0
		elseif LevelSystem == "GlorifiedLeveling" then
			newLevel = GlorifiedLeveling.GetPlayerLevel() or 0
			newXP = GlorifiedLeveling.GetPlayerXP() or 0
		end

		if newLevel != CurLevel or newXP != CurXP then
			nextClose = CurTime() + 3
			WidgetPanel:AlphaTo(255, 0.4)
			WidgetPanel:SizeTo(width, -1, 0.4)

			timer.Simple(0.8, function()
				level = newLevel
				xp = newXP
			end)
		end

		if nextClose < CurTime() and WidgetPanel:GetAlpha() == 255 and nextClose != -1 then
			WidgetPanel:AlphaTo(0, 0.4)

			WidgetPanel:SizeTo(0, -1, 0.4)
		end
	end)

	if RayHUD.LevelPanel != "Show when getting XP" or LevelSystem == "None" then
		timer.Remove("RayHUD:UpdateLevel")
	end

	hook.Add("RayHUD:Reload", "RayHUD:UnloadLevelPanel", function()
		timer.Remove("RayHUD:UpdateLevel")
	end)
end