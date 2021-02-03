-- FlatHUD Owner: 76561198166995690
-- FlatHUD Version: 1.1.1

local ply = LocalPlayer()

local spawnMenuOpen = false

hook.Add("OnSpawnMenuOpen", "FlatHUD:SpawnMenuOpen", function()
	spawnMenuOpen = true
	FlatHUD.RunVisibilityCheck()
end)

hook.Add("OnSpawnMenuClose", "FlatHUD:SpawnMenuClose", function()
	spawnMenuOpen = false
	FlatHUD.RunVisibilityCheck()
end)

local nextTimerCheck = 0
FlatHUD.shouldDraw = true

function FlatHUD.RunVisibilityCheck()
	nextTimerCheck = os.time() + 1

	if GetConVar("cl_drawhud"):GetInt() == 0 or gui.IsGameUIVisible() or FlatHUD.Disconnected == true or spawnMenuOpen then
		FlatHUD.shouldDraw = false
	else
		local wep = ply:GetActiveWeapon()

		if IsValid(wep) then
			if wep:GetClass() == "gmod_camera" then
				FlatHUD.shouldDraw = false
			else
				FlatHUD.shouldDraw = true
			end
		else
			FlatHUD.shouldDraw = true
		end
	end

	for k, v in ipairs(FlatHUD.FlatPanels) do
		if !IsValid(v) or v.custom then continue end

		local Alpha = v:GetAlpha()

		if v.OnTab == true then
			 if ply:KeyDown( IN_SCORE ) then
			 	v:AlphaTo(255, 0.2)
			else
				v:AlphaTo(0, 0.2)
			end
		else

			if FlatHUD.shouldDraw == true and Alpha == 0 then
				v:AlphaTo(255, 0.1)
			elseif FlatHUD.shouldDraw == false and Alpha == 255 then
				v:AlphaTo(0, 0.1)
			end

		end
	end
end

--hook.Add("Think","FlatHUD:ShouldDrawHUD",function()
--	if nextTimerCheck > os.time() then return end
--	FlatHUD.RunVisibilityCheck()
--end)

--[[------------------------------
    Door Menu
--------------------------------]]

local buttonInfo = {
	[DarkRP.getPhrase("buy_x", DarkRP.getPhrase("door"))] = {FlatUI.Icons.Money, FlatHUD.GetPhrase("buy_door"), FlatUI.Colors.Green},
	[DarkRP.getPhrase("sell_x", DarkRP.getPhrase("door"))] = {FlatUI.Icons.Money, FlatHUD.GetPhrase("sell_door"), FlatUI.Colors.Green},

	[DarkRP.getPhrase("buy_x", DarkRP.getPhrase("vehicle"))] = {FlatUI.Icons.Money, FlatHUD.GetPhrase("buy_vehicle"), FlatUI.Colors.Green},
	[DarkRP.getPhrase("sell_x", DarkRP.getPhrase("vehicle"))] = {FlatUI.Icons.Money, FlatHUD.GetPhrase("sell_vehicle"), FlatUI.Colors.Green},

	[DarkRP.getPhrase("add_owner")] = {FlatUI.Icons.AddUser, FlatHUD.GetPhrase("add_owner"), FlatUI.Colors.Green},
	[DarkRP.getPhrase("remove_owner")] = {FlatUI.Icons.RemoveUser, FlatHUD.GetPhrase("remove_owner"), FlatUI.Colors.HP},

	[DarkRP.getPhrase("allow_ownership")] = {FlatUI.Icons.AddUser, FlatHUD.GetPhrase("allow_ownership"), FlatUI.Colors.Green},
	[DarkRP.getPhrase("disallow_ownership")] = {FlatUI.Icons.BanUser, FlatHUD.GetPhrase("disallow_ownership"), FlatUI.Colors.HP},

	[DarkRP.getPhrase("set_x_title", DarkRP.getPhrase("door"))] = {FlatUI.Icons.Text, FlatHUD.GetPhrase("set_door_title"), FlatUI.Colors.Orange},
	[DarkRP.getPhrase("set_x_title", DarkRP.getPhrase("vehicle"))] = {FlatUI.Icons.Text, FlatHUD.GetPhrase("set_vehicle_title"), FlatUI.Colors.Orange},

	[DarkRP.getPhrase("edit_door_group")] = {FlatUI.Icons.Cog, FlatHUD.GetPhrase("edit_groups"), FlatUI.Colors.Armor},
}

hook.Add("onKeysMenuOpened", "FlatHUD:DoorMenu", function( ent, frame )
	hook.Add("HUDShouldDraw", "FlatHUD:RemoveCrosshair_DoorMenu",function( name )
		if name == "CHudCrosshair" then return false end
	end)

	local oldFunc = frame.OnRemove or function(  ) end

	frame.OnRemove = function( ... )
		hook.Remove("HUDShouldDraw","FlatHUD:RemoveCrosshair_DoorMenu")
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
	frame:SetSize(450 * FlatHUD.Scale, 49 * FlatHUD.Scale + 44 * FlatHUD.Scale * math.ceil(PanelsCount / 2))

	frame.Paint = function (self, w, h)
		FlatUI.DrawMaterialBox("Door options", 0, 0, w, h, FlatUI.Icons.Door)
	end

	local PosData = {}
	local x = 10 * FlatHUD.Scale

	for i = 1, PanelsCount do
		if (i % 2 == 0) then x = 230 * FlatHUD.Scale else x = 10 * FlatHUD.Scale end
		table.insert( PosData, { x = x, y = 44 * FlatHUD.Scale * math.ceil(i / 2) + 6 * FlatHUD.Scale} )
	end

	for k, v in ipairs(panels) do
		v:SetFont("FlatHUD.Main:Small")
		v:SetSize(210 * FlatHUD.Scale, 34 * FlatHUD.Scale)
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
			surface.DrawTexturedRect(w - 30 * FlatHUD.Scale, h * 0.15 * FlatHUD.Scale, 24 * FlatHUD.Scale, 24 * FlatHUD.Scale)
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
		surface.DrawTexturedRect(0, 8 * FlatHUD.Scale, 24 * FlatHUD.Scale, 24 * FlatHUD.Scale)
	end
end)

--[[------------------------------
    Gesture Menu
--------------------------------]]

local open

concommand.Add("_darkrp_animationmenu", function(  )
	if open then return end

	gesturePanels = {}

	hook.Add("HUDShouldDraw","FlatHUD:RemoveCrosshair_GestureMenu",function( name )
		if name == "CHudCrosshair" then return false end
	end)

	local animations = {
		[ACT_GMOD_GESTURE_BOW] = FlatHUD.GetPhrase("gesture_bow"),
		[ACT_GMOD_TAUNT_MUSCLE] = FlatHUD.GetPhrase("gesture_sexydance"),
		[ACT_GMOD_GESTURE_BECON] = FlatHUD.GetPhrase("gesture_follow_me"),
		[ACT_GMOD_TAUNT_LAUGH] = FlatHUD.GetPhrase("gesture_laugh"),
		[ACT_GMOD_TAUNT_PERSISTENCE] = FlatHUD.GetPhrase("gesture_lion_pose"),
		[ACT_GMOD_GESTURE_DISAGREE] = FlatHUD.GetPhrase("gesture_nonverbal_no"),
		[ACT_GMOD_GESTURE_AGREE] = FlatHUD.GetPhrase("gesture_thumbs_up"),
		[ACT_GMOD_GESTURE_WAVE] = FlatHUD.GetPhrase("gesture_wave"),
		[ACT_GMOD_TAUNT_DANCE] = FlatHUD.GetPhrase("gesture_dance"),
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

	gestureFrame:SetSize(450 * FlatHUD.Scale, 49 * FlatHUD.Scale + 44 * FlatHUD.Scale * math.ceil(#gesturePanels / 2))
	gestureFrame:Center()
	gestureFrame:MakePopup()
	gestureFrame.Paint = function(s, w, h)
		FlatUI.DrawMaterialBox("Gestures", 0, 0, w, h, FlatUI.Icons.Gesture)
	end

	local PosData = {}
	local x = 10 * FlatHUD.Scale

	for i = 1, #gesturePanels do
		if (i % 2 == 0) then x = 230 * FlatHUD.Scale else x = 10 * FlatHUD.Scale end
		table.insert( PosData, { x = x, y = 44 * FlatHUD.Scale * math.ceil(i / 2) + 6} )
	end

	for k,v in ipairs(gesturePanels) do
		if PosData[k] then
			v:SetSize(210 * FlatHUD.Scale, 34 * FlatHUD.Scale)
			v:SetPos(PosData[k].x, PosData[k].y)
			v:SetFont("FlatHUD.Main:Small")

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
	CloseBut:SetSize(41 * FlatHUD.Scale, 41 * FlatHUD.Scale)
	CloseBut:SetPos(gestureFrame:GetWide() - 32 * FlatHUD.Scale, 2 * FlatHUD.Scale)
	CloseBut.DoClick = function()
		gestureFrame:Remove()
	end
	CloseBut.Paint = function( s, w, h )
		surface.SetMaterial( FlatUI.Icons.Close )
		surface.SetDrawColor( FlatUI.Colors.White )
		surface.DrawTexturedRect(0, 8 * FlatHUD.Scale, 24 * FlatHUD.Scale, 24 * FlatHUD.Scale)
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

local itemHeight = 24 * FlatHUD.Scale
local itemMargin = 8

local itemPickupHeight = itemHeight * 10 + itemMargin * 9

local items = {}

local PistolIcon = FlatUI.Icons.Pistol
local ItemIcon = FlatUI.Icons.Cube

local function addNewItem( text, color, icon )
	surface.SetFont("FlatHUD.Main:Small")
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

		draw.SimpleText( v.text, "FlatHUD.Main:Small", math.Round(v.lerpedXPos) + v.itemWidth / 2 + itemHeight / 2, math.Round(v.lerpedYPos) + itemHeight / 2, Color(255, 255, 255, 255 * v.alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

hook.Add("HUDItemPickedUp","FlatHUD:HUDItemPickedUp", function( itemName )
	if !IsValid(ply) or !ply:Alive() then return end

	addNewItem(language.GetPhrase("#" .. itemName), FlatUI.Colors.HP, ItemIcon)
end)

hook.Add("HUDWeaponPickedUp","FlatHUD:HUDWeaponPickedUp", function( wep )
	if !IsValid(ply) or !ply:Alive() then return end
	if !IsValid(wep) then return end
	if !isfunction(wep.GetPrintName) then return end

	addNewItem(wep:GetPrintName(), FlatUI.Colors.Orange, PistolIcon)
end)

hook.Add("HUDAmmoPickedUp", "FlatHUD:HUDWeaponPickedUp", function( itemname, amount )
	if !IsValid(ply) or !ply:Alive() then return end

	addNewItem(language.GetPhrase( "#" .. itemname .. "_Ammo" ) .. " +" .. amount, FlatUI.Colors.Green, FlatUI.Icons.Ammo)
end)

timer.Create("FlatHUD:Remove_DrawPickupHistory", 0, 0, function(  )
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

local CrashTall = 625 * FlatHUD.Scale
local SepWide = 2 * FlatHUD.Scale

local SepPosX = (Background:GetWide() - 600 * FlatHUD.Scale)
local SepPosY = Background:GetTall() / 2 - CrashTall / 2

local RightWide = ScrW() - SepPosX - SepWide
local LeftWide = ScrW() - RightWide - SepWide

local IconSize = 180 * FlatHUD.Scale

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
	surface.DrawTexturedRect(LeftWide / 2 - IconSize / 2, 100 * FlatHUD.Scale, IconSize, IconSize)

	draw.SimpleText("Connection Lost", "FlatHUD.CrashScreen:Big", w / 2, 250 * FlatHUD.Scale, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	draw.SimpleText("It looks like you've lost connection to the server.", "FlatHUD.CrashScreen:Small", w / 2, 380 * FlatHUD.Scale, FlatUI.Colors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	draw.SimpleText("If the server doesn’t recover, you will be reconnected in a few seconds.", "FlatHUD.CrashScreen:Small", w / 2, 420 * FlatHUD.Scale, FlatUI.Colors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
end

local ButW = 250 * FlatHUD.Scale
local ButH = 80 * FlatHUD.Scale

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
	Button:SetFont("FlatHUD.CrashScreen:Small")
	Button:SetSize(ButW, ButH)
	Button:SetPos(RightWide / 2 - ButW / 2, RightPanel:GetTall() / 2 - ButH / 2 + (ButH + 20) * i - (ButH - 20) * #Buttons)
	Button.DoClick = function()
		but.func()
	end
end
-- 76561198166995699
local lastPing = os.time()
FlatHUD.Disconnected = false

net.Receive("FlatHUD:UpdateConnectonStatus", function()
	lastPing = os.time()

	if Background:IsVisible() and IsValid(Background) and FlatHUD.Disconnected == false then
		InnerLeftPanel:MoveTo(LeftWide, 0, 0.6)
		RightPanel:SizeTo(0, CrashTall, 0., 0, -1, function()
			Separator:SizeTo(SepWide, 0, 0.6)
			Background:AlphaTo(0, 0.6, 0, function()
				Background:SetVisible(false)
				gui.EnableScreenClicker(false)
			end)
		end)
	end
	FlatHUD.Disconnected = false
end)

local nextCheck = 0
hook.Add("Think", "FlatHUD:CheckConnectonStatus", function()
	if !GetConVar( "flathud_crashscreen" ):GetBool() then return end

	if nextCheck <= CurTime() then
		nextCheck = CurTime() + 2

		if os.time() - lastPing > 5 and FlatHUD.Disconnected == false then
			FlatHUD.Disconnected = true

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

timer.Remove("FlatHUD:LoadVoice")

local function LoadVoice()
	g_VoicePanelList:SetPos( ScrW() - 250 * FlatHUD.Scale - 12, 0 )
	g_VoicePanelList:SetSize( 250 * FlatHUD.Scale, ScrH() - 300 * FlatHUD.Scale )

	VoiceNotify.Init = function( self )
		self.Avatar = vgui.Create( "AvatarCircleMask", self )
		self.Avatar:Dock( LEFT )
		self.Avatar:SetSize( 34 * FlatHUD.Scale, 34 * FlatHUD.Scale )
		self.Avatar:SetMaskSize(20 * FlatHUD.Scale)

		self.LabelName = vgui.Create( "DLabel", self )
		self.LabelName:SetFont( "FlatHUD:VoiceVisualiser" )
		self.LabelName:Dock( LEFT )
		self.LabelName:DockMargin( 13 * FlatHUD.Scale, 0, 0, 0 )
		self.LabelName:SetTextColor( FlatUI.Colors.White )
		self.LabelName:SetWide((250 - 54) * FlatHUD.Scale)

		self:SetSize( 250 * FlatHUD.Scale, 46 * FlatHUD.Scale )
		self:DockPadding( 6 * FlatHUD.Scale, 6 * FlatHUD.Scale, 6 * FlatHUD.Scale, 6 * FlatHUD.Scale )
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
	timer.Create("FlatHUD:LoadVoice", 1, 60, function()
		if IsValid(g_VoicePanelList) then
			LoadVoice()
			timer.Remove("FlatHUD:LoadVoice")
		end
	end)
else
	LoadVoice()
end

--[[------------------------------
	Vrondakis Levelling System
--------------------------------]]
CreateClientConVar("flathud_level_mode", FlatHUD.Cfg.LevelPanel, true, false)
FlatHUD.LevelPanel = (!FlatHUD.Cfg.EditableForPlayers and FlatHUD.Cfg.LevelPanel or GetConVar( "flathud_level_mode" ):GetInt())

if LevelSystemConfiguration then
	local SmoothLevel = 0

	-- Remove default HUD
	hook.Remove("HUDPaint", "manolis:MVLevels:HUDPaintA")

	local width = 390 * FlatHUD.Scale
	local height = 90 * FlatHUD.Scale

	if GetConVar( "flathud_minimal_mode" ):GetBool() then width = 230 * FlatHUD.Scale end

	local WidgetPanel = vgui.Create("FlatHUD:DPanel")
	WidgetPanel:SetSize(width, height)
	WidgetPanel:SetPos(12 * FlatHUD.Scale, ScrH() - 12 * FlatHUD.Scale - (200 * FlatHUD.Scale) - 12 * FlatHUD.Scale - height)
	WidgetPanel:SetVisible(true)
	WidgetPanel:ParentToHUD()
	WidgetPanel.Paint = function(self, w, h)
		FlatUI.DrawMaterialBox("Level: " .. (ply:getDarkRPVar("level") or 0), 0, 0, w, h, FlatUI.Icons.Level)

		local level = ply:getDarkRPVar("level") or 0
		local xp = ply:getDarkRPVar("xp") or 0
		local maxXP = math.Round(10 + (level * (level + 1) * 90) * LevelSystemConfiguration.XPMult)
		local LevelText = "XP: " .. xp .. " / " .. maxXP

		SmoothLevel = Lerp(5 * FrameTime(), SmoothLevel, xp / maxXP)
		FlatUI.CreateBar( 20, 65, width - 40 * FlatHUD.Scale, 10, FlatUI.Colors.LightGreen, FlatUI.Colors.Green, SmoothLevel, LevelText )
	end

	if FlatHUD.LevelPanel == 2 then
		WidgetPanel.OnTab = true
	elseif FlatHUD.LevelPanel == 3 then
		WidgetPanel:SetVisible(false)
	elseif FlatHUD.LevelPanel == 4 then
		WidgetPanel.custom = true
		WidgetPanel:SetAlpha(0)

		WidgetPanel:SetWide(0)
	end

	local level = ply:getDarkRPVar("level") or 0
	local xp = ply:getDarkRPVar("xp") or 0

	local nextClose = 0

	timer.Create("FlatHUD:UpdateLevel", 1, 0, function()

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

	if GetConVar( "flathud_level_mode" ):GetInt() != 4 then
		timer.Remove("FlatHUD:UpdateLevel")
	end
end