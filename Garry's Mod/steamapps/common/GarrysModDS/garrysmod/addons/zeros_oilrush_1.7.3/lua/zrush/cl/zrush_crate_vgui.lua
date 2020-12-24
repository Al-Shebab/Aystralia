if not CLIENT then return end

local wMod = ScrW() / 1920
local hMod = ScrH() / 1080

local zrush_MachineCrateMenu = {}
local zrush_MachineCrateMain = {}

local zrush_MachineCrateEntity

/////////// General
local function zrush_MachineInfo(parent)
	if (zrush_MachineCrateMain and IsValid(zrush_MachineCrateMain.InfoPanel)) then
		zrush_MachineCrateMain.InfoPanel:Remove()
	end

	local machineInfoTable = {}

	if (zrush_player_SELECTED_MACHINE) then
		zrush_MachineCrateMain.InfoPanel = vgui.Create("Panel", parent)
		zrush_MachineCrateMain.InfoPanel:SetPos(387 * wMod, 62 * hMod)
		zrush_MachineCrateMain.InfoPanel:SetSize(400 * wMod, 460 * hMod)

		zrush_MachineCrateMain.InfoPanel.Paint = function(self, w, h)
			surface.SetDrawColor(0, 0, 0, 0)
			surface.SetMaterial(zrush.default_materials["square"])
			surface.DrawTexturedRect(0, 0, w, h)
		end

		zrush_MachineCrateMain.ModelPanel = vgui.Create("Panel", zrush_MachineCrateMain.InfoPanel)
		zrush_MachineCrateMain.ModelPanel:SetPos(25 * wMod, 25 * hMod)
		zrush_MachineCrateMain.ModelPanel:SetSize(350 * wMod, 350 * hMod)
		zrush_MachineCrateMain.ModelPanel:SetAutoDelete(true)

		zrush_MachineCrateMain.ModelPanel.Paint = function(self, w, h)
			surface.SetDrawColor(zrush.default_colors["black05"])
			surface.SetMaterial(zrush.default_materials["square"])
			surface.DrawTexturedRect(0, 0, w, h)
		end

		local machineData = zrush.MachineShop[zrush_player_SELECTED_MACHINE]
		zrush_MachineCrateMain.model = vgui.Create("DModelPanel", zrush_MachineCrateMain.ModelPanel)
		zrush_MachineCrateMain.model:SetSize(zrush_MachineCrateMain.ModelPanel:GetWide(), zrush_MachineCrateMain.ModelPanel:GetTall())
		zrush_MachineCrateMain.model:SetPos(0, 0)
		zrush_MachineCrateMain.model:SetModel(machineData.model)
		zrush_MachineCrateMain.model:SetAutoDelete(true)
		zrush_MachineCrateMain.model:SetColor(zrush.default_colors["white01"])

		zrush_MachineCrateMain.model.LayoutEntity = function(self)
			local offset = 1
			local ang = Angle(0, RealTime() * 30, 0)
			local sOffset = 1

			if (machineData.machineID == "Pump") then
				offset = 0.8
				sOffset = 0.5
				self.Entity:SetBodygroup(0, 1)
				self.Entity:SetBodygroup(1, 1)
				self.Entity:SetBodygroup(3, 1)
				self.Entity:SetBodygroup(5, 1)
				self.Entity:SetBodygroup(2, 1)
				self.Entity:SetBodygroup(4, 1)
			elseif (machineData.machineID == "Refinery") then
				offset = 0.8
				sOffset = 0.85
			elseif (machineData.machineID == "Drill") then
				sOffset = 1.2
			end

			self.Entity:SetAngles(ang)
			local size1, size2 = self.Entity:GetRenderBounds()
			local size = (-size1 + size2):Length()
			self:SetFOV(40 * offset)
			self:SetCamPos(Vector(size * 1, size * 1, size * 1))
			self:SetLookAt(self.Entity:GetPos() + Vector(0, 0, (0.4 * size) * sOffset))
		end

		machineInfoTable[1] = zrush.language.MachineCrate[zrush.MachineShop[zrush_player_SELECTED_MACHINE].machineID]
		machineInfoTable[2] = zrush.config.Currency .. zrush.MachineShop[zrush_player_SELECTED_MACHINE].price
	else
		machineInfoTable[1] = ""
		machineInfoTable[2] = ""
	end

	for i = 1, table.Count(machineInfoTable) do
		zrush_MachineCrateMain[i] = vgui.Create("DLabel", zrush_MachineCrateMain.InfoPanel)
		zrush_MachineCrateMain[i]:SetPos(25 * wMod, (360 + (25 * i)) * hMod)
		zrush_MachineCrateMain[i]:SetSize(550 * wMod, 300 * hMod)
		zrush_MachineCrateMain[i]:SetFont("zrush_vgui_font02")
		local col = zrush.default_colors["white01"]

		if (i == 2) then
			col = zrush.default_colors["green01"]
		end

		zrush_MachineCrateMain[i]:SetColor(col)
		zrush_MachineCrateMain[i]:SetText(machineInfoTable[i])
		zrush_MachineCrateMain[i]:SetAutoStretchVertical(true)
		zrush_MachineCrateMain[i]:SetAutoDelete(true)
	end
end

local function zrush_OpenUI()
	if IsValid(zrush_MachineCrateMenu_panel) then
		zrush_MachineCrateMenu_panel:SetVisible(true)
		zrush_MachineInfo(zrush_MachineCrateMenu_panel)
	else
		zrush_MachineCrateMenu_panel = vgui.Create("zrush_vgui_MachineCrateMenu")
	end
end

local function zrush_CloseUI(UnlockForPlayer)
	zrush_player_SELECTED_MACHINE = nil

	if (IsValid(zrush_MachineCrateMenu_panel) and zrush_MachineCrateMenu_panel:IsVisible() == true) then
		local ent = zrush_MachineCrateEntity

		if (UnlockForPlayer and IsValid(ent)) then

			// I add a delay here to make sure this doesent interfere with the Timeout
			timer.Simple(0.3, function()
				if IsValid(ent) then
					net.Start("zrush_MachineCrate_Close_cl")
					net.WriteEntity(ent)
					net.SendToServer()
				end
			end)

		end

		if (IsValid(zrush_MachineCrateMain.Buy)) then
			zrush_MachineCrateMain.Buy:SetVisible(false)
		end

		if (zrush.config.Debug) then
			zrush_MachineCrateMenu_panel:Remove()
		else
			zrush_MachineCrateMenu_panel:SetVisible(false)
		end

		zrush_MachineCrateEntity = nil
	end
end
///////////


/////////// Init
local function zrush_MachineShop(parent)
	if (zrush_MachineShopList and IsValid(zrush_MachineShopList.Panel)) then
		zrush_MachineShopList.Panel:Remove()
	end

	zrush_MachineShopList = {}
	zrush_MachineShopList.Panel = vgui.Create("Panel", parent)
	zrush_MachineShopList.Panel:SetPos(12 * wMod, 62 * hMod)
	zrush_MachineShopList.Panel:SetSize(362 * wMod, 525 * hMod)
	zrush_MachineShopList.Panel:SetContentAlignment(7)

	zrush_MachineShopList.Panel.Paint = function(self, w, h)
		surface.SetDrawColor(zrush.default_colors["black04"])
		surface.SetMaterial(zrush.default_materials["square"])
		surface.DrawTexturedRect(0, 0, w, h)
	end

	zrush_MachineShopList.scrollpanel = vgui.Create("DScrollPanel", zrush_MachineShopList.Panel)
	zrush_MachineShopList.scrollpanel:DockMargin(0 * wMod, 0 * hMod, 15 * wMod, 0 * hMod)
	zrush_MachineShopList.scrollpanel:Dock(FILL)
	zrush_MachineShopList.scrollpanel:GetVBar().Paint = function() return true end
	zrush_MachineShopList.scrollpanel:GetVBar().btnUp.Paint = function() return true end
	zrush_MachineShopList.scrollpanel:GetVBar().btnDown.Paint = function() return true end

	zrush_MachineShopList.scrollpanel.Paint = function(self, w, h)
		surface.SetDrawColor(0, 0, 0, 0)
		surface.SetMaterial(zrush.default_materials["square"])
		surface.DrawTexturedRect(0, 0, w, h)
	end

	// Here we create the Machine items that can be selected
	if (zrush_MachineItems and IsValid(zrush_MachineItems.list)) then
		zrush_MachineItems.list:Remove()
	end

	zrush_MachineItems = {}
	zrush_MachineItems.list = vgui.Create("DIconLayout", zrush_MachineShopList.scrollpanel)
	zrush_MachineItems.list:SetSize(450 * wMod, 200 * hMod)
	zrush_MachineItems.list:SetPos(15 * wMod, 15 * hMod)
	zrush_MachineItems.list:SetSpaceY(10)
	zrush_MachineItems.list:SetAutoDelete(true)

	for k, v in pairs(zrush.MachineShop) do
		zrush_MachineItems[k] = zrush_MachineItems.list:Add("DPanel")
		zrush_MachineItems[k]:SetSize(zrush_MachineItems.list:GetWide(), 50 * hMod)
		zrush_MachineItems[k]:SetAutoDelete(true)

		zrush_MachineItems[k].Paint = function(self, w, h)
			if zrush_MachineItems[k]:IsHovered() and LocalPlayer().zrush_LastHoverdElement ~= k then
				LocalPlayer().zrush_LastHoverdElement = k
				surface.PlaySound("zrush/zrush_ui_hover.wav")
			end

			surface.SetDrawColor(0, 0, 0, 0)
			surface.SetMaterial(zrush.default_materials["square"])
			surface.DrawTexturedRect(0, 0, w, h)
		end

		zrush_MachineItems[k].button = vgui.Create("DButton", zrush_MachineItems[k])
		zrush_MachineItems[k].button:SetPos(0 * wMod, 0 * hMod)
		zrush_MachineItems[k].button:SetSize(zrush_MachineItems.list:GetWide(), 50 * hMod)
		zrush_MachineItems[k].button:SetText("")
		zrush_MachineItems[k].button:SetAutoDelete(true)

		zrush_MachineItems[k].button.Paint = function(self, w, h)
			local panelcolor = zrush.default_colors["black04"]

			if (k == zrush_player_SELECTED_MACHINE) then
				surface.SetDrawColor(zrush.default_colors["green03"])
			else
				if (zrush_MachineItems[k].button:IsHovered()) then
					if (LocalPlayer().zrush_LastHoverdElement ~= k) then
						LocalPlayer().zrush_LastHoverdElement = k
						surface.PlaySound("zrush/zrush_ui_hover.wav")
					end

					surface.SetDrawColor(zrush.default_colors["grey04"])
				else
					surface.SetDrawColor(panelcolor.r, panelcolor.g, panelcolor.b, panelcolor.a)
				end
			end

			surface.SetMaterial(zrush.default_materials["ui_moduleshop_item"])
			surface.DrawTexturedRect(0, 0, w - 120 * wMod, h)
		end

		zrush_MachineItems[k].button.DoClick = function()
			zrush_player_SELECTED_MACHINE = k
			zrush_MachineCrateMain.Buy:SetVisible(true)

			if zrush_player_SELECTED_MACHINE then
				zrush_MachineInfo(zrush_MachineCrateMenu_panel)
			end

			surface.PlaySound("zrush/zrush_command.wav")
		end

		zrush_MachineItems[k].MachineName = vgui.Create("DLabel", zrush_MachineItems[k].button)
		zrush_MachineItems[k].MachineName:SetPos(10 * wMod, 10 * hMod)
		zrush_MachineItems[k].MachineName:SetSize(300 * wMod, 125 * hMod)
		zrush_MachineItems[k].MachineName:SetFont("zrush_vgui_fuelitem")
		zrush_MachineItems[k].MachineName:SetText(zrush.language.MachineCrate[v.machineID])
		zrush_MachineItems[k].MachineName:SetColor(zrush.default_colors["white01"])
		zrush_MachineItems[k].MachineName:SetAutoDelete(true)
		zrush_MachineItems[k].MachineName:SetContentAlignment(7)

		zrush_MachineItems[k].MachinePrice = vgui.Create("DLabel", zrush_MachineItems[k].button)
		zrush_MachineItems[k].MachinePrice:SetPos(240 * wMod, 10 * hMod)
		zrush_MachineItems[k].MachinePrice:SetSize(300 * wMod, 125 * hMod)
		zrush_MachineItems[k].MachinePrice:SetFont("zrush_vgui_fuelitem")
		zrush_MachineItems[k].MachinePrice:SetText(zrush.config.Currency .. v.price)
		zrush_MachineItems[k].MachinePrice:SetColor(Color(125, 255, 125, 255))
		zrush_MachineItems[k].MachinePrice:SetAutoDelete(true)
		zrush_MachineItems[k].MachinePrice:SetContentAlignment(7)
	end
end

function zrush_MachineCrateMenu:Init()
	self:SetSize(800 * wMod, 600 * hMod)
	self:Center()
	self:MakePopup()

	zrush_MachineCrateMain.Title = vgui.Create("DLabel", self)
	zrush_MachineCrateMain.Title:SetPos(15 * wMod, -30 * hMod)
	zrush_MachineCrateMain.Title:SetSize(600 * wMod, 125 * hMod)
	zrush_MachineCrateMain.Title:SetFont("zrush_vgui_font01")
	zrush_MachineCrateMain.Title:SetText(zrush.language.VGUI["MachineShop"])
	zrush_MachineCrateMain.Title:SetColor(zrush.default_colors["white01"])

	zrush_MachineCrateMain.close = vgui.Create("DButton", self)
	zrush_MachineCrateMain.close:SetText("")
	zrush_MachineCrateMain.close:SetPos(740 * wMod, 10 * hMod)
	zrush_MachineCrateMain.close:SetSize(50 * wMod, 50 * hMod)

	zrush_MachineCrateMain.close.DoClick = function()
		zrush_CloseUI(true)
	end

	zrush_MachineCrateMain.close.Paint = function(s,w, h)
		if zrush_MachineCrateMain.close:IsHovered() then
			surface.SetDrawColor(zrush.default_colors["red02_highlight"])
		else
			surface.SetDrawColor(zrush.default_colors["red02"])
		end

		surface.SetMaterial(zrush.default_materials["button02"])
		surface.DrawTexturedRect(0, 0, w, h)

		draw.SimpleText("X", "zrush_vgui_font03", 25 * wMod, 25 * hMod, zrush.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	zrush_MachineCrateMain.InfoButtonPanel = vgui.Create("Panel", self)
	zrush_MachineCrateMain.InfoButtonPanel:SetPos(387 * wMod, 62 * hMod)
	zrush_MachineCrateMain.InfoButtonPanel:SetSize(400 * wMod, 525 * hMod)

	zrush_MachineCrateMain.InfoButtonPanel.Paint = function(s,w, h)
		surface.SetDrawColor(zrush.default_colors["black02"])
		surface.SetMaterial(zrush.default_materials["square"])
		surface.DrawTexturedRect(0, 0, w, h)
	end

	zrush_MachineCrateMain.Buy = vgui.Create("DButton", zrush_MachineCrateMain.InfoButtonPanel)
	zrush_MachineCrateMain.Buy:SetText("")
	zrush_MachineCrateMain.Buy:SetPos(22 * wMod, 460 * hMod)
	zrush_MachineCrateMain.Buy:SetSize(150 * wMod, 40 * hMod)
	zrush_MachineCrateMain.Buy:SetVisible(false)
	zrush_MachineCrateMain.Buy.DoClick = function()
		if (zrush_player_SELECTED_MACHINE) then
			net.Start("zrush_MachineCrate_Buy_net")
			net.WriteEntity(zrush_MachineCrateEntity)
			net.WriteInt(zrush_player_SELECTED_MACHINE, 16)
			net.SendToServer()
			zrush_CloseUI(true)
		end
	end
	zrush_MachineCrateMain.Buy.Paint = function(s,w, h)
		if zrush_MachineCrateMain.Buy:IsHovered() then
			surface.SetDrawColor(125, 255, 125, 255)
		else
			surface.SetDrawColor(125, 200, 125, 255)
		end

		surface.SetMaterial(zrush.default_materials["button"])
		surface.DrawTexturedRect(0, 0, w, h)

		draw.SimpleText(zrush.language.VGUI["Purchase"], "zrush_vgui_purchase", 75 * wMod, 20 * hMod, zrush.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	zrush_MachineShop(self)
	zrush_MachineInfo(self)

	// Select the first item
	zrush_player_SELECTED_MACHINE = 1
	zrush_MachineCrateMain.Buy:SetVisible(true)
	if zrush_player_SELECTED_MACHINE then
		zrush_MachineInfo(self)
	end
end

function zrush_MachineCrateMenu:Paint(w, h)
	surface.SetDrawColor(150, 150, 150, 255)
	surface.SetMaterial(zrush.default_materials["ui_machineshop_panel"])
	surface.DrawTexturedRect(0, 0, w, h)
end
///////////


vgui.Register("zrush_vgui_MachineCrateMenu", zrush_MachineCrateMenu, "Panel")

// This opens the machine ui for a user
net.Receive("zrush_MachineCrate_Open_net", function(len)
	zrush_MachineCrateEntity = net.ReadEntity()

	if IsValid(zrush_MachineCrateEntity) then
		zrush_OpenUI()
	else
		zrush_CloseUI(true)
	end

end)

// This closes the machine ui for a user
net.Receive("zrush_MachineCrate_Close_net", function(len)
	if IsValid(zrush_MachineCrateMenu_panel and zrush_MachineCrateMenu_panel:IsVisible() == true) then
		zrush_CloseUI(true)
	end
end)

//////// The Option Box
local zrush_MachineCrateOptionBoxMenu = {}
local zrush_MachineCrateOptionBoxMain = {}

local function zrush_OB_CloseUI(UnlockForPlayer)
	if IsValid(zrush_MachineCrateOptionBoxMenu_panel) then
		local ent = zrush_MachineCrateEntity

		if (UnlockForPlayer and IsValid(ent)) then

			// I add a delay here to make sure this doesent interfere with the Timeout
			timer.Simple(0.3, function()
				if IsValid(ent) then
					net.Start("zrush_MachineCrate_Close_cl")
					net.WriteEntity(ent)
					net.SendToServer()
				end
			end)

		end

		zrush_MachineCrateEntity = nil
		zrush_MachineCrateOptionBoxMenu_panel:Remove()
	end
end

local function zrush_OB_UpdateUI()
	local ent = zrush_MachineCrateEntity
	local machineWorth = zrush.f.ReturnMachineCrateValue(ent, LocalPlayer().zrush_MachineCrateModules)
	zrush_MachineCrateOptionBoxMain.SellButton:SetText(zrush.language.VGUI["Sell"] .. " (" .. zrush.config.Currency .. tostring(machineWorth) .. ")")
end

function zrush_MachineCrateOptionBoxMenu:Init()
	self:SetSize(512 * wMod, 512 * hMod)
	self:Center()
	self:MakePopup()
	local ent = zrush_MachineCrateEntity
	zrush_MachineCrateOptionBoxMain.Title = vgui.Create("DLabel", self)
	zrush_MachineCrateOptionBoxMain.Title:SetPos(50 * wMod, 90 * hMod)
	zrush_MachineCrateOptionBoxMain.Title:SetSize(600 * wMod, 125 * hMod)
	zrush_MachineCrateOptionBoxMain.Title:SetFont("zrush_vgui_font01")
	zrush_MachineCrateOptionBoxMain.Title:SetText(zrush.language.MachineCrate[ent:GetMachineID()])
	zrush_MachineCrateOptionBoxMain.Title:SetColor(zrush.default_colors["white01"])

	zrush_MachineCrateOptionBoxMain.close = vgui.Create("DButton", self)
	zrush_MachineCrateOptionBoxMain.close:SetText("")
	zrush_MachineCrateOptionBoxMain.close:SetPos(423 * wMod, 125 * hMod)
	zrush_MachineCrateOptionBoxMain.close:SetSize(50 * wMod, 50 * hMod)
	zrush_MachineCrateOptionBoxMain.close.DoClick = function()
		zrush_OB_CloseUI(true)
	end
	zrush_MachineCrateOptionBoxMain.close.Paint = function(s,w, h)
		if zrush_MachineCrateOptionBoxMain.close:IsHovered() then
			surface.SetDrawColor(zrush.default_colors["red02_highlight"])
		else
			surface.SetDrawColor(zrush.default_colors["red02"])
		end

		surface.SetMaterial(zrush.default_materials["button02"])
		surface.DrawTexturedRect(0, 0, w, h)

		draw.SimpleText("X", "zrush_vgui_font03", 25 * wMod, 25 * hMod, zrush.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	zrush_MachineCrateOptionBoxMain.SellButton = vgui.Create("DButton", self)
	zrush_MachineCrateOptionBoxMain.SellButton:SetText(zrush.language.VGUI["Sell"])
	zrush_MachineCrateOptionBoxMain.SellButton:SetPos(156 * wMod, 315 * hMod)
	zrush_MachineCrateOptionBoxMain.SellButton:SetSize(200 * wMod, 50 * hMod)
	zrush_MachineCrateOptionBoxMain.SellButton:SetVisible(false)

	zrush_MachineCrateOptionBoxMain.SellButton.DoClick = function()
		net.Start("zrush_MachineCrate_Sell_net")
		net.WriteEntity(zrush_MachineCrateEntity)
		net.SendToServer()
		zrush_OB_CloseUI(true)
	end

	zrush_MachineCrateOptionBoxMain.PlaceButton = vgui.Create("DButton", self)
	zrush_MachineCrateOptionBoxMain.PlaceButton:SetText(zrush.language.VGUI["Place"])
	zrush_MachineCrateOptionBoxMain.PlaceButton:SetPos(156 * wMod, 230 * hMod)
	zrush_MachineCrateOptionBoxMain.PlaceButton:SetSize(200 * wMod, 50 * hMod)
	zrush_MachineCrateOptionBoxMain.PlaceButton:SetVisible(false)

	zrush_MachineCrateOptionBoxMain.PlaceButton.DoClick = function()
		net.Start("zrush_MachineCrateOB_Place_net")
		net.WriteEntity(zrush_MachineCrateEntity)
		net.SendToServer()
		zrush_OB_CloseUI(false)
	end
end

function zrush_MachineCrateOptionBoxMenu:Paint(w, h)
	surface.SetDrawColor(zrush.default_colors["white01"])
	surface.SetMaterial(zrush.default_materials["ui_machinecrate_panel"])
	surface.DrawTexturedRect(0, 0, w, h)
end

vgui.Register("zrush_vgui_MachineCrateOptionBox", zrush_MachineCrateOptionBoxMenu, "Panel")

// This opens the machine ui for a user
net.Receive("zrush_MachineCrateOB_Open_net", function(len)
	zrush_MachineCrateEntity = net.ReadEntity()
	LocalPlayer().zrush_MachineCrateModules = net.ReadTable()

	if IsValid(zrush_MachineCrateOptionBoxMenu_panel) then
		zrush_MachineCrateOptionBoxMenu_panel:SetVisible(true)
	else
		zrush_MachineCrateOptionBoxMenu_panel = vgui.Create("zrush_vgui_MachineCrateOptionBox")
	end

	if zrush.f.IsOwner(LocalPlayer(), zrush_MachineCrateEntity) then
		zrush_MachineCrateOptionBoxMain.SellButton:SetVisible(true)
		zrush_MachineCrateOptionBoxMain.PlaceButton:SetVisible(true)
	else
		if zrush.config.Machine["MachineCrate"].AllowSell == true then
			zrush_MachineCrateOptionBoxMain.SellButton:SetVisible(true)
			zrush_MachineCrateOptionBoxMain.PlaceButton:SetVisible(false)
		else
			zrush_MachineCrateOptionBoxMain.SellButton:SetVisible(false)
			zrush_MachineCrateOptionBoxMain.PlaceButton:SetVisible(false)
		end
	end

	zrush_OB_UpdateUI()
end)

// This closes the machineoptionbox ui for a user
net.Receive("zrush_MachineCrateOB_Close_net", function(len)
	zrush_OB_CloseUI(true)
end)
///////////
