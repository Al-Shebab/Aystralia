if not CLIENT then return end

local wMod = ScrW() / 1920
local hMod = ScrH() / 1080

zrush = zrush or {}
zrush.VGUI = zrush.VGUI or {}
zrush.VGUI.NPC = zrush.VGUI.NPC or {}

local zrush_FuelBuyerMenu = {}
local zrush_FuelBuyerMain = {}

local zrush_PlayerFuelInv
local zrush_FuelBuyerEntity
local zrush_LastHoverdElement

/////////// General
local s_pos = Vector(0, 0, 22)
function zrush.VGUI.NPC.FuelInfo(parent)
	if (zrush_FuelBuyerMain and IsValid(zrush_FuelBuyerMain.InfoPanel)) then
		zrush_FuelBuyerMain.InfoPanel:Remove()
	end

	zrush_FuelBuyerMain.InfoPanel = vgui.Create("Panel", parent)
	zrush_FuelBuyerMain.InfoPanel:SetPos(387 * wMod, 62 * hMod)
	zrush_FuelBuyerMain.InfoPanel:SetSize(400 * wMod, 460 * hMod)
	zrush_FuelBuyerMain.InfoPanel.Paint = function(self, w, h)
		surface.SetDrawColor(0, 0, 0, 0)
		surface.SetMaterial(zrush.default_materials["square"])
		surface.DrawTexturedRect(0, 0, w, h)
	end

	zrush_FuelBuyerMain.ModelPanel = vgui.Create("Panel", zrush_FuelBuyerMain.InfoPanel)
	zrush_FuelBuyerMain.ModelPanel:SetPos(25 * wMod, 25 * hMod)
	zrush_FuelBuyerMain.ModelPanel:SetSize(350 * wMod, 350 * hMod)
	zrush_FuelBuyerMain.ModelPanel:SetAutoDelete(true)
	zrush_FuelBuyerMain.ModelPanel.Paint = function(self, w, h)
		surface.SetDrawColor(zrush.default_colors["black02"])
		surface.SetMaterial(zrush.default_materials["square"])
		surface.DrawTexturedRect(0, 0, w, h)
	end

	local fuelInfoTable = {}

	if (zrush_player_SELECTED_FUEL) then
		zrush_FuelBuyerMain.model = vgui.Create("DModelPanel", zrush_FuelBuyerMain.ModelPanel)
		zrush_FuelBuyerMain.model:SetSize(zrush_FuelBuyerMain.ModelPanel:GetWide(), zrush_FuelBuyerMain.ModelPanel:GetTall())
		zrush_FuelBuyerMain.model:SetPos(0, 0)
		zrush_FuelBuyerMain.model:SetModel("models/zerochain/props_oilrush/zor_barrel.mdl")
		zrush_FuelBuyerMain.model:SetAutoDelete(true)
		zrush_FuelBuyerMain.model:SetColor(zrush.Fuel[zrush_player_SELECTED_FUEL].color)

		zrush_FuelBuyerMain.model.LayoutEntity = function(self)
			self.Entity:SetAngles(Angle(0, RealTime() * 30, 0))
			local size1, size2 = self.Entity:GetRenderBounds()
			local size = (-size1 + size2):Length()
			self:SetFOV(25)
			self:SetCamPos(Vector(size * 2, size * 1, size * 1))
			self:SetLookAt(self.Entity:GetPos() + s_pos)
		end

		local playerFuelTable = zrush_PlayerFuelInv
		local fuelAmount = math.Round(playerFuelTable[zrush_player_SELECTED_FUEL])
		local sellAmount = 0

		if (fuelAmount >= zrush.config.FuelBuyer.SellAmount) then
			sellAmount = zrush.config.FuelBuyer.SellAmount
		else
			sellAmount = fuelAmount
		end

		local fuelBuyer = zrush_FuelBuyerEntity
		local SellPrice = zrush.Fuel[zrush_player_SELECTED_FUEL].price * (fuelBuyer:GetPrice_Mul() / 100)
		fuelInfoTable[1] = zrush.Fuel[zrush_player_SELECTED_FUEL].name
		fuelInfoTable[2] = zrush.config.Currency .. tostring(SellPrice) .. " / " .. zrush.config.UoM .. " (" .. zrush.config.Currency .. tostring(SellPrice * sellAmount) .. ")"
	else
		fuelInfoTable[1] = " "
		fuelInfoTable[2] = " "
	end

	for i = 1, table.Count(fuelInfoTable) do
		zrush_FuelBuyerMain[i] = vgui.Create("DLabel", zrush_FuelBuyerMain.InfoPanel)
		zrush_FuelBuyerMain[i]:SetPos(25 * wMod, (360 + (25 * i)) * hMod)
		zrush_FuelBuyerMain[i]:SetSize(550 * wMod, 300 * hMod)
		zrush_FuelBuyerMain[i]:SetFont("zrush_vgui_font02")
		zrush_FuelBuyerMain[i]:SetColor(zrush.default_colors["white01"])
		zrush_FuelBuyerMain[i]:SetText(fuelInfoTable[i])
		zrush_FuelBuyerMain[i]:SetAutoStretchVertical(true)
		zrush_FuelBuyerMain[i]:SetAutoDelete(true)
	end
end

function zrush.VGUI.NPC.PlayerFuelInvField(parent)
	if (zrush_PlayerFuelList and IsValid(zrush_PlayerFuelList.Panel)) then
		zrush_PlayerFuelList.Panel:Remove()
	end

	zrush_PlayerFuelList = {}
	zrush_PlayerFuelList.Panel = vgui.Create("Panel", parent)
	zrush_PlayerFuelList.Panel:SetPos(12 * wMod, 62 * hMod)
	zrush_PlayerFuelList.Panel:SetSize(362 * wMod, 525 * hMod)
	zrush_PlayerFuelList.Panel:SetContentAlignment(7)

	zrush_PlayerFuelList.Panel.Paint = function(self, w, h)
		surface.SetDrawColor(zrush.default_colors["black02"])
		surface.SetMaterial(zrush.default_materials["square"])
		surface.DrawTexturedRect(0, 0, w, h)
	end

	zrush_PlayerFuelList.Title = vgui.Create("DLabel", zrush_PlayerFuelList.Panel)
	zrush_PlayerFuelList.Title:SetPos(15 * wMod, -30 * hMod)
	zrush_PlayerFuelList.Title:SetSize(600 * wMod, 125 * hMod)
	zrush_PlayerFuelList.Title:SetFont("zrush_vgui_font03")
	zrush_PlayerFuelList.Title:SetText(zrush.language.VGUI.NPC["YourFuelInv"])
	zrush_PlayerFuelList.Title:SetColor(zrush.default_colors["white01"])

	zrush_PlayerFuelList.Info = vgui.Create("DLabel", zrush_PlayerFuelList.Panel)
	zrush_PlayerFuelList.Info:SetPos(10 * wMod, 425 * hMod)
	zrush_PlayerFuelList.Info:SetSize(350 * wMod, 125 * hMod)
	zrush_PlayerFuelList.Info:SetFont("zrush_vgui_font04")
	zrush_PlayerFuelList.Info:SetText(zrush.language.VGUI.NPC["SaveInfo"])
	zrush_PlayerFuelList.Info:SetColor(zrush.default_colors["white01"])
	zrush_PlayerFuelList.Info:SetWrap(true)

	zrush_PlayerFuelList.scrollpanel = vgui.Create("DScrollPanel", zrush_PlayerFuelList.Panel)
	zrush_PlayerFuelList.scrollpanel:DockMargin(0 * wMod, 0 * hMod, 15 * wMod, 0 * hMod)
	zrush_PlayerFuelList.scrollpanel:SetAutoDelete(true)
	zrush_PlayerFuelList.scrollpanel:Dock(FILL)
	zrush_PlayerFuelList.scrollpanel:GetVBar().Paint = function() return true end
	zrush_PlayerFuelList.scrollpanel:GetVBar().btnUp.Paint = function() return true end
	zrush_PlayerFuelList.scrollpanel:GetVBar().btnDown.Paint = function() return true end

	zrush_PlayerFuelList.scrollpanel.Paint = function(self, w, h)
		surface.SetDrawColor(0, 0, 0, 0)
		surface.SetMaterial(zrush.default_materials["square"])
		surface.DrawTexturedRect(0, 0, w, h)
	end

	// Here we create the Fuel items that can be selected
	if (zrush_FuelItems and IsValid(zrush_FuelItems.list)) then
		zrush_FuelItems.list:Remove()
	end

	zrush_FuelItems = {}
	zrush_FuelItems.list = vgui.Create("DIconLayout", zrush_PlayerFuelList.scrollpanel)
	zrush_FuelItems.list:SetSize(450 * wMod, 200 * hMod)
	zrush_FuelItems.list:SetPos(15 * wMod, 75 * hMod)
	zrush_FuelItems.list:SetSpaceY(10)
	zrush_FuelItems.list:SetAutoDelete(true)
	local playerFuels = zrush_PlayerFuelInv

	for k, v in pairs(playerFuels) do
		if (v > 0) then
			local fuelData = zrush.Fuel[k]
			zrush_FuelItems[k] = zrush_FuelItems.list:Add("DPanel")
			zrush_FuelItems[k]:SetSize(zrush_FuelItems.list:GetWide(), 40 * hMod)
			zrush_FuelItems[k]:SetAutoDelete(true)

			zrush_FuelItems[k].Paint = function(self, w, h)
				if zrush_FuelItems[k]:IsHovered() and zrush_LastHoverdElement ~= k then
					zrush_LastHoverdElement = k
					surface.PlaySound("zrush/zrush_ui_hover.wav")
				end

				surface.SetDrawColor(0, 0, 0, 0)
				surface.SetMaterial(zrush.default_materials["square"])
				surface.DrawTexturedRect(0, 0, w, h)
			end

			zrush_FuelItems[k].button = vgui.Create("DButton", zrush_FuelItems[k])
			zrush_FuelItems[k].button:SetPos(0 * wMod, 0 * hMod)
			zrush_FuelItems[k].button:SetSize(zrush_FuelItems.list:GetWide(), 40 * hMod)
			zrush_FuelItems[k].button:SetText("")
			zrush_FuelItems[k].button:SetAutoDelete(true)
			zrush_FuelItems[k].button.Paint = function(self, w, h)
				local panelcolor = zrush.default_colors["black02"]

				if (k == zrush_player_SELECTED_FUEL) then
					surface.SetDrawColor(zrush.default_colors["grey04"])
				else
					if (zrush_FuelItems[k].button:IsHovered()) then
						if (zrush_LastHoverdElement ~= k) then
							zrush_LastHoverdElement = k
							surface.PlaySound("zrush/zrush_ui_hover.wav")
						end

						surface.SetDrawColor(zrush.default_colors["grey04"])
					else
						surface.SetDrawColor(panelcolor.r, panelcolor.g, panelcolor.b, panelcolor.a)
					end
				end

				surface.SetMaterial(zrush.default_materials["square"])
				surface.DrawTexturedRect(0, 0, w, h)
			end
			zrush_FuelItems[k].button.DoClick = function()
				zrush_player_SELECTED_FUEL = k
				zrush_FuelBuyerMain.Sell:SetEnabled(true)
				zrush_FuelBuyerMain.SellAll:SetEnabled(true)

				if zrush_player_SELECTED_FUEL then
					zrush.VGUI.NPC.FuelInfo(zrush_FuelBuyerMenu_panel)

					for i, w in pairs(zrush_FuelItems) do
						if (i ~= zrush_player_SELECTED_FUEL) then
							if (IsValid(w.FuelName)) then
								w.FuelName:SetColor(zrush.default_colors["white04"])
							end

							if (IsValid(w.FuelAmount)) then
								w.FuelAmount:SetColor(zrush.default_colors["white04"])
							end
						end
					end
				end

				surface.PlaySound("zrush/zrush_command.wav")
			end

			zrush_FuelItems[k].FuelName = vgui.Create("DLabel", zrush_FuelItems[k].button)
			zrush_FuelItems[k].FuelName:SetPos(10 * wMod, 10 * hMod)
			zrush_FuelItems[k].FuelName:SetSize(300 * wMod, 125 * hMod)
			zrush_FuelItems[k].FuelName:SetFont("zrush_vgui_fuelitem")
			zrush_FuelItems[k].FuelName:SetText(fuelData.name)
			zrush_FuelItems[k].FuelName:SetColor(zrush.default_colors["white01"])
			zrush_FuelItems[k].FuelName:SetAutoDelete(true)
			zrush_FuelItems[k].FuelName:SetContentAlignment(7)

			zrush_FuelItems[k].FuelAmount = vgui.Create("DLabel", zrush_FuelItems[k].button)
			zrush_FuelItems[k].FuelAmount:SetPos(240 * wMod, 10 * hMod)
			zrush_FuelItems[k].FuelAmount:SetSize(300 * wMod, 125 * hMod)
			zrush_FuelItems[k].FuelAmount:SetFont("zrush_vgui_fuelitem")
			zrush_FuelItems[k].FuelAmount:SetText(math.Round(playerFuels[k]) .. zrush.config.UoM)
			zrush_FuelItems[k].FuelAmount:SetColor(zrush.default_colors["white01"])
			zrush_FuelItems[k].FuelAmount:SetAutoDelete(true)
			zrush_FuelItems[k].FuelAmount:SetContentAlignment(7)

			zrush_FuelItems[k].ImageBG = vgui.Create("DImage", zrush_FuelItems[k].button)
			zrush_FuelItems[k].ImageBG:SetPos(185 * wMod, 2.5 * hMod)
			zrush_FuelItems[k].ImageBG:SetSize(35 * wMod, 35 * hMod)
			zrush_FuelItems[k].ImageBG:SetAutoDelete(true)
			zrush_FuelItems[k].ImageBG.Paint = function(self, w, h)
				local panelcolor = fuelData.color
				surface.SetDrawColor(panelcolor.r, panelcolor.g, panelcolor.b, panelcolor.a * 0.75)
				surface.SetMaterial(zrush.default_materials["barrel_icon"])
				surface.DrawTexturedRect(0, 0, w, h)
			end
		end
	end
end

function zrush.VGUI.NPC.UpdateUI()
	if IsValid(zrush_FuelBuyerMenu_panel) then
		local playerFuels = zrush_PlayerFuelInv

		if (zrush_player_SELECTED_FUEL and playerFuels[zrush_player_SELECTED_FUEL] <= 0) then
			zrush_FuelBuyerMain.Sell:SetEnabled(false)
			zrush_FuelBuyerMain.SellAll:SetEnabled(false)
			zrush_player_SELECTED_FUEL = nil
		end

		zrush.VGUI.NPC.PlayerFuelInvField(zrush_FuelBuyerMenu_panel)
		zrush.VGUI.NPC.FuelInfo(zrush_FuelBuyerMenu_panel)

		if (IsValid(zrush_FuelBuyerMain) and IsValid(zrush_FuelBuyerMain.Title)) then
			local fuelbuyer = zrush_FuelBuyerEntity
			zrush_FuelBuyerMain.Title:SetText(zrush.language.VGUI.NPC["FuelBuyer"] .. "(" .. fuelbuyer:GetNPCName() .. ")")
		end
	end
end

local function zrush_OpenUI()
	// Here me create the notification
	local fuelbuyer = zrush_FuelBuyerEntity
	local plyFuelInv = zrush_PlayerFuelInv
	local hasBarrels = false

	for k, v in pairs(plyFuelInv) do
		if (v > 0) then
			hasBarrels = true
			break
		end
	end

	if (hasBarrels) then
		zrush.f.FuelBuyerNotify(fuelbuyer, zrush.language.NPC["Dialog0" .. math.random(0, 9)], 4)
	else
		zrush.f.FuelBuyerNotify(fuelbuyer, zrush.language.NPC["NoFuel"], 3)
	end

	if IsValid(zrush_FuelBuyerMenu_panel) then
		zrush_FuelBuyerMenu_panel:SetVisible(true)
		zrush.VGUI.NPC.UpdateUI()
	else
		zrush_FuelBuyerMenu_panel = vgui.Create("zrush_vgui_FuelBuyerMenu")
	end
end

local function zrush_CloseUI()
	zrush.f.FuelBuyerNotify_RemoveAll()
	zrush_player_SELECTED_FUEL = nil

	if IsValid(zrush_FuelBuyerMenu_panel) then
		if (IsValid(zrush_FuelBuyerMain.Sell)) then
			zrush_FuelBuyerMain.Sell:SetEnabled(false)
		end

		if (IsValid(zrush_FuelBuyerMain.SellAll)) then
			zrush_FuelBuyerMain.SellAll:SetEnabled(false)
		end

		if (zrush.config.Debug) then
			zrush_FuelBuyerMenu_panel:Remove()
		else
			zrush_FuelBuyerMenu_panel:SetVisible(false)
		end
	end
end

local function zrush_SellFuel(SellAll)
	local fuelbuyerNPC01 = zrush_FuelBuyerEntity
	net.Start("zrush_SellFuel_net")
	net.WriteEntity(fuelbuyerNPC01)
	net.WriteInt(zrush_player_SELECTED_FUEL, 16)
	net.WriteBool(SellAll) // SellAll ?
	net.SendToServer()
	local fuelbuyer = zrush_FuelBuyerEntity
	// Creates a welcome notification
	zrush.f.FuelBuyerNotify(fuelbuyer, zrush.language.NPC["DialogTransactionComplete"], 2)
end

///////////
/////////// Init
function zrush_FuelBuyerMenu:Init()
	self:SetSize(800 * wMod, 600 * hMod)
	self:Center()
	self:MakePopup()

	zrush_FuelBuyerMain.Title = vgui.Create("DLabel", self)
	zrush_FuelBuyerMain.Title:SetPos(15 * wMod, -30 * hMod)
	zrush_FuelBuyerMain.Title:SetSize(750 * wMod, 125 * hMod)
	zrush_FuelBuyerMain.Title:SetFont("zrush_vgui_font01")
	zrush_FuelBuyerMain.Title:SetText(zrush.language.VGUI.NPC["FuelBuyer"])
	zrush_FuelBuyerMain.Title:SetColor(zrush.default_colors["white01"])

	zrush_FuelBuyerMain.close = vgui.Create("DButton", self)
	zrush_FuelBuyerMain.close:SetText("")
	zrush_FuelBuyerMain.close:SetPos(750 * wMod, 0 * hMod)
	zrush_FuelBuyerMain.close:SetSize(50 * wMod, 50 * hMod)
	zrush_FuelBuyerMain.close.DoClick = function()
		zrush_CloseUI()
	end
	zrush_FuelBuyerMain.close.Paint = function(s,w, h)
		if zrush_FuelBuyerMain.close:IsHovered() then
			surface.SetDrawColor(zrush.default_colors["red02_highlight"])
		else
			surface.SetDrawColor(zrush.default_colors["red02"])
		end

		surface.SetMaterial(zrush.default_materials["button02"])
		surface.DrawTexturedRect(0, 0, w, h)

		draw.DrawText("X", "zrush_vgui_font03",25 * wMod, 7 * hMod, Color(255, 255, 255), TEXT_ALIGN_CENTER)
		/*
		surface.SetFont("zrush_vgui_font03")
		surface.SetTextColor(zrush.default_colors["white01"])
		surface.SetTextPos(17 * wMod, 11 * hMod)
		surface.DrawText("X")
		*/
	end

	zrush.VGUI.NPC.PlayerFuelInvField(self)
	zrush.VGUI.NPC.FuelInfo(self)

	zrush_FuelBuyerMain.InfoButtonPanel = vgui.Create("Panel", self)
	zrush_FuelBuyerMain.InfoButtonPanel:SetPos(387 * wMod, 62 * hMod)
	zrush_FuelBuyerMain.InfoButtonPanel:SetSize(400 * wMod, 525 * hMod)

	zrush_FuelBuyerMain.InfoButtonPanel.Paint = function(s,w, h)
		surface.SetDrawColor(zrush.default_colors["black02"])
		surface.SetMaterial(zrush.default_materials["square"])
		surface.DrawTexturedRect(0, 0, w, h)
	end

	zrush_FuelBuyerMain.Sell = vgui.Create("DButton", zrush_FuelBuyerMain.InfoButtonPanel)
	zrush_FuelBuyerMain.Sell:SetText("")
	zrush_FuelBuyerMain.Sell:SetPos(22 * wMod, 470 * hMod)
	zrush_FuelBuyerMain.Sell:SetSize(150 * wMod, 40 * hMod)
	zrush_FuelBuyerMain.Sell:SetEnabled(false)
	zrush_FuelBuyerMain.Sell:SetContentAlignment(5)
	zrush_FuelBuyerMain.Sell.DoClick = function()
		if (zrush_player_SELECTED_FUEL) then
			zrush_SellFuel(false)
		end
	end
	zrush_FuelBuyerMain.Sell.Paint = function(s,w, h)
		if (zrush_FuelBuyerMain.Sell:IsEnabled()) then
			if zrush_FuelBuyerMain.Sell:IsHovered() then
				surface.SetDrawColor(zrush.default_colors["red02"])
			else
				surface.SetDrawColor(200, 125, 125, 255)
			end
		else
			surface.SetDrawColor(75, 60, 60, 255)
		end

		surface.SetMaterial(zrush.default_materials["button"])
		surface.DrawTexturedRect(0, 0, w, h)

		draw.SimpleText(zrush.language.VGUI.NPC["Sell"] .. " " .. zrush.config.FuelBuyer.SellAmount .. zrush.config.UoM, "zrush_vgui_font08", 75 * wMod, 20 * hMod, zrush.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	zrush_FuelBuyerMain.SellAll = vgui.Create("DButton", zrush_FuelBuyerMain.InfoButtonPanel)
	zrush_FuelBuyerMain.SellAll:SetText("")
	zrush_FuelBuyerMain.SellAll:SetPos(225 * wMod, 470 * hMod)
	zrush_FuelBuyerMain.SellAll:SetSize(150 * wMod, 40 * hMod)
	zrush_FuelBuyerMain.SellAll:SetEnabled(false)
	zrush_FuelBuyerMain.SellAll:SetContentAlignment(5)
	zrush_FuelBuyerMain.SellAll.DoClick = function()
		if (zrush_player_SELECTED_FUEL) then
			zrush_SellFuel(true)
		end
	end
	zrush_FuelBuyerMain.SellAll.Paint = function(s,w, h)
		if (zrush_FuelBuyerMain.SellAll:IsEnabled()) then
			if zrush_FuelBuyerMain.SellAll:IsHovered() then
				surface.SetDrawColor(zrush.default_colors["red02"])
			else
				surface.SetDrawColor(200, 125, 125, 255)
			end
		else
			surface.SetDrawColor(75, 60, 60, 255)
		end

		surface.SetMaterial(zrush.default_materials["button"])
		surface.DrawTexturedRect(0, 0, w, h)

		draw.SimpleText(zrush.language.VGUI.NPC["SellAll"], "zrush_vgui_font08", 75 * wMod, 20 * hMod, zrush.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

function zrush_FuelBuyerMenu:Paint(w, h)
	surface.SetDrawColor(125, 125, 125, 255)
	surface.SetMaterial(zrush.default_materials["ui_machineshop_panel"])
	surface.DrawTexturedRect(0, 0, w, h)
end

///////////
vgui.Register("zrush_vgui_FuelBuyerMenu", zrush_FuelBuyerMenu, "Panel")

// This opens the machine ui for a user
net.Receive("zrush_OpenSellFuelUI_net", function(len)
	zrush_FuelBuyerEntity = net.ReadEntity()
	zrush_PlayerFuelInv = net.ReadTable()
	zrush_OpenUI()
end)

// This updates the machine ui for a user
net.Receive("zrush_UpdateSellFuelUI_net", function(len)
	zrush_FuelBuyerEntity = net.ReadEntity()
	zrush_PlayerFuelInv = net.ReadTable()
	zrush.VGUI.NPC.UpdateUI()
end)

// Gets called if the server wants do close the ui
net.Receive("zrush_CloseSellFuelUI_net", function(len)
	zrush_CloseUI()
end)
