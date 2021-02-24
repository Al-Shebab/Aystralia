-- RayHUD Owner: 76561198166995690
-- RayHUD Version: 1.1.3

local ply = LocalPlayer()

local spawnMenuOpen = false

hook.Add("OnSpawnMenuOpen", "RayHUD:SpawnMenuOpen", function()
	spawnMenuOpen = true
	RayHUD.RunVisibilityCheck()
end)

hook.Add("OnSpawnMenuClose", "RayHUD:SpawnMenuClose", function()
	spawnMenuOpen = false
	RayHUD.RunVisibilityCheck()
end)

local nextTimerCheck = 0
RayHUD.shouldDraw = true

function RayHUD.RunVisibilityCheck()
	nextTimerCheck = os.time() + 1

	if GetConVar("cl_drawhud"):GetInt() == 0 or gui.IsGameUIVisible() or RayHUD.Disconnected == true or spawnMenuOpen then
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

		if v.OnTab == true then
			 if ply:KeyDown( IN_SCORE ) then
			 	v:AlphaTo(255, 0.2)
			else
				v:AlphaTo(0, 0.2)
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

--[[------------------------------
    Door Menu
--------------------------------]]

local buttonInfo = {
	[DarkRP.getPhrase("buy_x", DarkRP.getPhrase("door"))] = {FlatUI.Icons.Money, RayHUD.GetPhrase("buy_door"), FlatUI.Colors.Green},
	[DarkRP.getPhrase("sell_x", DarkRP.getPhrase("door"))] = {FlatUI.Icons.Money, RayHUD.GetPhrase("sell_door"), FlatUI.Colors.Green},

	[DarkRP.getPhrase("buy_x", DarkRP.getPhrase("vehicle"))] = {FlatUI.Icons.Money, RayHUD.GetPhrase("buy_vehicle"), FlatUI.Colors.Green},
	[DarkRP.getPhrase("sell_x", DarkRP.getPhrase("vehicle"))] = {FlatUI.Icons.Money, RayHUD.GetPhrase("sell_vehicle"), FlatUI.Colors.Green},

	[DarkRP.getPhrase("add_owner")] = {FlatUI.Icons.AddUser, RayHUD.GetPhrase("add_owner"), FlatUI.Colors.Green},
	[DarkRP.getPhrase("remove_owner")] = {FlatUI.Icons.RemoveUser, RayHUD.GetPhrase("remove_owner"), FlatUI.Colors.HP},

	[DarkRP.getPhrase("allow_ownership")] = {FlatUI.Icons.AddUser, RayHUD.GetPhrase("allow_ownership"), FlatUI.Colors.Green},
	[DarkRP.getPhrase("disallow_ownership")] = {FlatUI.Icons.BanUser, RayHUD.GetPhrase("disallow_ownership"), FlatUI.Colors.HP},

	[DarkRP.getPhrase("set_x_title", DarkRP.getPhrase("door"))] = {FlatUI.Icons.Text, RayHUD.GetPhrase("set_door_title"), FlatUI.Colors.Orange},
	[DarkRP.getPhrase("set_x_title", DarkRP.getPhrase("vehicle"))] = {FlatUI.Icons.Text, RayHUD.GetPhrase("set_vehicle_title"), FlatUI.Colors.Orange},

	[DarkRP.getPhrase("edit_door_group")] = {FlatUI.Icons.Cog, RayHUD.GetPhrase("edit_groups"), FlatUI.Colors.Armor},
}

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
	frame:SetSize(450 * RayHUD.Scale, 49 * RayHUD.Scale + 44 * RayHUD.Scale * math.ceil(PanelsCount / 2))

	frame.Paint = function (self, w, h)
		FlatUI.DrawMaterialBox("Door options", 0, 0, w, h, FlatUI.Icons.Door)
	end

	local PosData = {}
	local x = 10 * RayHUD.Scale

	for i = 1, PanelsCount do
		if (i % 2 == 0) then x = 230 * RayHUD.Scale else x = 10 * RayHUD.Scale end
		table.insert( PosData, { x = x, y = 44 * RayHUD.Scale * math.ceil(i / 2) + 6 * RayHUD.Scale} )
	end

	for k, v in ipairs(panels) do
		v:SetFont("RayHUD.Main:Small")
		v:SetSize(210 * RayHUD.Scale, 34 * RayHUD.Scale)
		v:SetPos(PosData[k].x, PosData[k].y)

		local icon = buttonInfo[v:GetValue()] and buttonInfo[v:GetValue()][1]
		local but_color = buttonInfo[v:GetValue()] and buttonInfo[v:GetValue()][3]

		v.Paint = function( s, w, h )
			draw.RoundedBox(6, 0, 0, w, h, FlatUI.Colors.DarkGray5)

			if v:IsHovered() then
				surface.SetDrawColor(but_color)
				v:SetTextColor(but_color)
			else
				surface.SetDrawColor(color_white)
				v:SetTextColor(color_white)
			end

			surface.SetMaterial(icon or FlatUI.Icons.Cog)
			surface.DrawTexturedRect(w - 30 * RayHUD.Scale, h * 0.15 * RayHUD.Scale, 24 * RayHUD.Scale, 24 * RayHUD.Scale)
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
		surface.SetMaterial( FlatUI.Icons.Close )
		surface.SetDrawColor( FlatUI.Colors.White )
		surface.DrawTexturedRect(0, 8 * RayHUD.Scale, 24 * RayHUD.Scale, 24 * RayHUD.Scale)
	end
end)

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
		[ACT_GMOD_GESTURE_BOW] = RayHUD.GetPhrase("gesture_bow"),
		[ACT_GMOD_TAUNT_MUSCLE] = RayHUD.GetPhrase("gesture_sexydance"),
		[ACT_GMOD_GESTURE_BECON] = RayHUD.GetPhrase("gesture_follow_me"),
		[ACT_GMOD_TAUNT_LAUGH] = RayHUD.GetPhrase("gesture_laugh"),
		[ACT_GMOD_TAUNT_PERSISTENCE] = RayHUD.GetPhrase("gesture_lion_pose"),
		[ACT_GMOD_GESTURE_DISAGREE] = RayHUD.GetPhrase("gesture_nonverbal_no"),
		[ACT_GMOD_GESTURE_AGREE] = RayHUD.GetPhrase("gesture_thumbs_up"),
		[ACT_GMOD_GESTURE_WAVE] = RayHUD.GetPhrase("gesture_wave"),
		[ACT_GMOD_TAUNT_DANCE] = RayHUD.GetPhrase("gesture_dance"),
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

	gestureFrame:SetSize(450 * RayHUD.Scale, 49 * RayHUD.Scale + 44 * RayHUD.Scale * math.ceil(#gesturePanels / 2))
	gestureFrame:Center()
	gestureFrame:MakePopup()
	gestureFrame.Paint = function(s, w, h)
		FlatUI.DrawMaterialBox("Gestures", 0, 0, w, h, FlatUI.Icons.Gesture)
	end

	local PosData = {}
	local x = 10 * RayHUD.Scale

	for i = 1, #gesturePanels do
		if (i % 2 == 0) then x = 230 * RayHUD.Scale else x = 10 * RayHUD.Scale end
		table.insert( PosData, { x = x, y = 44 * RayHUD.Scale * math.ceil(i / 2) + 6} )
	end

	for k,v in ipairs(gesturePanels) do
		if PosData[k] then
			v:SetSize(210 * RayHUD.Scale, 34 * RayHUD.Scale)
			v:SetPos(PosData[k].x, PosData[k].y)
			v:SetFont("RayHUD.Main:Small")

			v.Paint = function( s, w, h )
				draw.RoundedBox(6, 0, 0, w, h, FlatUI.Colors.DarkGray5)

				if v:IsHovered() then
					v:SetTextColor(FlatUI.Colors.Armor)
				else
					v:SetTextColor(color_white)
				end
			end
		end
	end

	local CloseBut = vgui.Create("DButton", gestureFrame)
	CloseBut:SetText( "" )
	CloseBut:SetSize(41 * RayHUD.Scale, 41 * RayHUD.Scale)
	CloseBut:SetPos(gestureFrame:GetWide() - 32 * RayHUD.Scale, 2 * RayHUD.Scale)
	CloseBut.DoClick = function()
		gestureFrame:Remove()
	end
	CloseBut.Paint = function( s, w, h )
		surface.SetMaterial( FlatUI.Icons.Close )
		surface.SetDrawColor( FlatUI.Colors.White )
		surface.DrawTexturedRect(0, 8 * RayHUD.Scale, 24 * RayHUD.Scale, 24 * RayHUD.Scale)
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

local itemHeight = 24 * RayHUD.Scale
local itemMargin = 8

local itemPickupHeight = itemHeight * 10 + itemMargin * 9

local items = {}

local PistolIcon = FlatUI.Icons.Pistol
local ItemIcon = FlatUI.Icons.Cube

local function addNewItem( text, color, icon )
	surface.SetFont("RayHUD.Main:Small")
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
itemPickupFrame:SetPos(ScrW() - 12 - itemPickupFrame:GetWide(), screenHeight * 0.35)
itemPickupFrame:ParentToHUD()
-- 76561198166995699
itemPickupFrame.Paint = function(s, w, h)
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

		draw.RoundedBox(6, math.Round(v.lerpedXPos), math.Round(v.lerpedYPos), v.itemWidth, itemHeight, Color(66, 66, 66, 255 * v.alpha))
		draw.RoundedBox(6, math.Round(v.lerpedXPos), math.Round(v.lerpedYPos), itemHeight, itemHeight, Color(v.color.r, v.color.g, v.color.b, 255 * v.alpha))

		surface.SetMaterial( v.icon )
		surface.SetDrawColor( Color(255, 255, 255, 255 * v.alpha) )
		surface.DrawTexturedRect(math.Round(v.lerpedXPos) + itemHeight * .11, math.Round(v.lerpedYPos) + itemHeight * .11 , itemHeight * .8, itemHeight * .8)

		draw.SimpleText( v.text, "RayHUD.Main:Small", math.Round(v.lerpedXPos) + v.itemWidth / 2 + itemHeight / 2, math.Round(v.lerpedYPos) + itemHeight / 2, Color(255, 255, 255, 255 * v.alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

hook.Add("HUDItemPickedUp","RayHUD:HUDItemPickedUp", function( itemName )
	if !IsValid(ply) or !ply:Alive() then return end

	addNewItem(language.GetPhrase("#" .. itemName), FlatUI.Colors.HP, ItemIcon)
end)

hook.Add("HUDWeaponPickedUp","RayHUD:HUDWeaponPickedUp", function( wep )
	if !IsValid(ply) or !ply:Alive() then return end
	if !IsValid(wep) then return end
	if !isfunction(wep.GetPrintName) then return end

	addNewItem(wep:GetPrintName(), FlatUI.Colors.Orange, PistolIcon)
end)

hook.Add("HUDAmmoPickedUp", "RayHUD:HUDWeaponPickedUp", function( itemname, amount )
	if !IsValid(ply) or !ply:Alive() then return end

	addNewItem(language.GetPhrase( "#" .. itemname .. "_Ammo" ) .. " +" .. amount, FlatUI.Colors.Green, FlatUI.Icons.Ammo)
end)

timer.Create("RayHUD:Remove_DrawPickupHistory", 0, 0, function(  )
	GAMEMODE.HUDDrawPickupHistory = function()  end
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
Background.Paint = function( s, w, h )
	draw.RoundedBox(0, 0, 0, w, h, BackgroundCol)
end

local CrashTall = 625 * RayHUD.Scale
local SepWide = 2 * RayHUD.Scale

local SepPosX = (Background:GetWide() - 600 * RayHUD.Scale)
local SepPosY = Background:GetTall() / 2 - CrashTall / 2

local RightWide = ScrW() - SepPosX - SepWide
local LeftWide = ScrW() - RightWide - SepWide

local IconSize = 180 * RayHUD.Scale

local Separator = vgui.Create("DPanel", Background)
Separator:SetSize(SepWide, 0)
Separator:SetPos(SepPosX, SepPosY)
Separator.Paint = function( s, w, h )
	draw.RoundedBox(0, 0, 0, w, h, FlatUI.Colors.White)
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
	surface.SetMaterial( FlatUI.Icons.ConnectionLost )
	surface.SetDrawColor( FlatUI.Colors.White )
	surface.DrawTexturedRect(LeftWide / 2 - IconSize / 2, 100 * RayHUD.Scale, IconSize, IconSize)

	draw.SimpleText("Connection Lost", "RayHUD.CrashScreen:Big", w / 2, 250 * RayHUD.Scale, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	draw.SimpleText("It looks like you've lost connection to the server.", "RayHUD.CrashScreen:Small", w / 2, 380 * RayHUD.Scale, FlatUI.Colors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	draw.SimpleText("If the server doesn’t recover, you will be reconnected in a few seconds.", "RayHUD.CrashScreen:Small", w / 2, 420 * RayHUD.Scale, FlatUI.Colors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
end

local ButW = 250 * RayHUD.Scale
local ButH = 80 * RayHUD.Scale

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
	if i == 2 then ButtonColor = FlatUI.Colors.HP end

	local Button = FlatUI.CreateFlatButton(RightPanel, but.Name, FlatUI.Colors.Gray2, i == 1 and FlatUI.Colors.Green or FlatUI.Colors.HP, function()
		Main:Remove()
	end)
	Button:SetFont("RayHUD.CrashScreen:Small")
	Button:SetSize(ButW, ButH)
	Button:SetPos(RightWide / 2 - ButW / 2, RightPanel:GetTall() / 2 - ButH / 2 + (ButH + 20) * i - (ButH - 20) * #Buttons)
	Button.DoClick = function()
		but.func()
	end
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
	if !GetConVar( "rayhud_crashscreen" ):GetBool() then return end

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

--[[------------------------------
	Voice Panel
--------------------------------]]

timer.Remove("RayHUD:LoadVoice")

local function LoadVoice()
	g_VoicePanelList:SetPos( ScrW() - 250 * RayHUD.Scale - 12, 0 )
	g_VoicePanelList:SetSize( 250 * RayHUD.Scale, ScrH() - 300 * RayHUD.Scale )

	VoiceNotify.Init = function( self )
		self.Avatar = vgui.Create( "AvatarCircleMask", self )
		self.Avatar:Dock( LEFT )
		self.Avatar:SetSize( 34 * RayHUD.Scale, 34 * RayHUD.Scale )
		self.Avatar:SetMaskSize(20 * RayHUD.Scale)

		self.LabelName = vgui.Create( "DLabel", self )
		self.LabelName:SetFont( "RayHUD:VoiceVisualiser" )
		self.LabelName:Dock( LEFT )
		self.LabelName:DockMargin( 13 * RayHUD.Scale, 0, 0, 0 )
		self.LabelName:SetTextColor( FlatUI.Colors.White )
		self.LabelName:SetWide((250 - 54) * RayHUD.Scale)

		self:SetSize( 250 * RayHUD.Scale, 46 * RayHUD.Scale )
		self:DockPadding( 6 * RayHUD.Scale, 6 * RayHUD.Scale, 6 * RayHUD.Scale, 6 * RayHUD.Scale )
		self:DockMargin( 0, 0, 0, 6 )
		self:Dock( BOTTOM )
	end

	VoiceNotify.Paint = function( self, w, h )
		if !IsValid(self.ply) then return end

		draw.RoundedBox( 8, 0, 0, w, h, FlatUI.Colors.Gray)
		draw.RoundedBox( 8, 0, 0, w, h, Color(140, 140, 140, 255 * self.ply:VoiceVolume()))
		draw.RoundedBox( 8, 0, 0, h, h, FlatUI.Colors.DarkGray3)
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
	Vrondakis Levelling System
--------------------------------]]
CreateClientConVar("rayhud_level_mode", RayHUD.Cfg.LevelPanel, true, false)
RayHUD.LevelPanel = (!RayHUD.Cfg.EditableForPlayers and RayHUD.Cfg.LevelPanel or GetConVar( "rayhud_level_mode" ):GetInt())

if LevelSystemConfiguration then
	local SmoothLevel = 0

	-- Remove default HUD
	hook.Remove("HUDPaint", "manolis:MVLevels:HUDPaintA")

	local width = 390 * RayHUD.Scale
	local height = 90 * RayHUD.Scale

	if GetConVar( "rayhud_minimal_mode" ):GetBool() then width = 230 * RayHUD.Scale end

	local WidgetPanel = vgui.Create("RayHUD:DPanel")
	WidgetPanel:SetSize(width, height)
	WidgetPanel:SetPos(12 * RayHUD.Scale, ScrH() - 12 * RayHUD.Scale - (200 * RayHUD.Scale) - 12 * RayHUD.Scale - height)
	WidgetPanel:SetVisible(true)
	WidgetPanel:ParentToHUD()
	WidgetPanel.Paint = function(self, w, h)
		FlatUI.DrawMaterialBox("Level: " .. (ply:getDarkRPVar("level") or 0), 0, 0, w, h, FlatUI.Icons.Level)

		local level = ply:getDarkRPVar("level") or 0
		local xp = ply:getDarkRPVar("xp") or 0
		local maxXP = math.Round(10 + (level * (level + 1) * 90) * LevelSystemConfiguration.XPMult)
		local LevelText = "XP: " .. xp .. " / " .. maxXP

		SmoothLevel = Lerp(5 * FrameTime(), SmoothLevel, xp / maxXP)
		FlatUI.CreateBar( 20, 65, width - 40 * RayHUD.Scale, 10, FlatUI.Colors.LightGreen, FlatUI.Colors.Green, SmoothLevel, LevelText )
	end

	if RayHUD.LevelPanel == 2 then
		WidgetPanel.OnTab = true
	elseif RayHUD.LevelPanel == 3 then
		WidgetPanel:SetVisible(false)
	elseif RayHUD.LevelPanel == 4 then
		WidgetPanel.custom = true
		WidgetPanel:SetAlpha(0)

		WidgetPanel:SetWide(0)
	end

	local level = ply:getDarkRPVar("level") or 0
	local xp = ply:getDarkRPVar("xp") or 0

	local nextClose = 0

	timer.Create("RayHUD:UpdateLevel", 1, 0, function()

		local newLevel = ply:getDarkRPVar("level")
		local newXP = ply:getDarkRPVar("xp")

		if newLevel != level or newXP != xp then
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

	if GetConVar( "rayhud_level_mode" ):GetInt() != 4 then
		timer.Remove("RayHUD:UpdateLevel")
	end
end