local PANEL = {}

function PANEL:Init()
	self:SetTall(144)
	self:DockPadding(40, 40, 40, 40)

	self.Model = vgui.Create('ModelImage', self)
	self.Model:Dock(LEFT)

	self.Title = vgui.Create('DLabel', self)
	self.Title:Dock(LEFT)
	self.Title:DockMargin(20, 0, 0, 0)
	self.Title:SetFont('OSXItem')
	self.Title:SetColor(F4Menu.Colors.Text)
	self.Title:SetText('')
	self.Title:SizeToContents()

	self.Buy = vgui.Create('OSXButton', self)
	self.Buy:Dock(RIGHT)
	self.Buy:DockMargin(0, 20, 0, 0)
	self.Buy:SetText('')
	self.Buy:SetWide(111)

	self:SetIsLast(false)
end

function PANEL:SetIsLast(isLast)
	self.Last = isLast
end

function PANEL:IsLast()
	return self.Last
end

function PANEL:SetItem(item, isShipment)
	self.Item = item

	self.Model:SetModel(item.model)

	self.Title:SetText(item.label or item.name)
	self.Title:SizeToContents()

	local price = item.getPrice and item.getPrice(ply, item.pricesep) or item.pricesep

	if not price or isShipment then
		price = item.getPrice and item.getPrice(LocalPlayer(), item.price) or item.price
	end

	self.Buy:SetText((price or 0) .. '$')
end

function PANEL:SetBuyFunction(buyFunction)
	self.BuyFunction = buyFunction
end

function PANEL:Refresh()
	local parent = self:GetParent():GetParent()

	if not parent.CanBuy then
		parent = parent:GetParent():GetParent() -- Categories
	end

	local canBuy, jobOnly = parent:CanBuy(self.Item)

	if F4Menu.HideOtherShipments then
		if jobOnly then
			self:SetTall(0)
      self:Hide()
		else
			self:SetTall(144)
			self:Show()
		end
	end

	if not canBuy then
		self.Buy.DoClick = function() end
		self.Buy:SetLabelColor(F4Menu.Colors.ButtonNegative)
		self.Buy:InvalidateLayout()
	else
		self.Buy.DoClick = function() self.BuyFunction(self.Item) end
		self.Buy:SetLabelColor(F4Menu.Colors.Button)
		self.Buy:InvalidateLayout()
	end
end

function PANEL:Paint(w, h)
	if self:IsLast() then return end
	draw.RoundedBox(0, 20, h - 1, w - 40, 1, F4Menu.Colors.Border)
end

vgui.Register('OSXItem', PANEL, 'Panel')

local PANEL = {}

function PANEL:Init()
	self:EnableVerticalScrollbar()
	self:GenerateContent()
	self:ShouldDisable()
end

function PANEL:GenerateContent()
end

function PANEL:ShouldDisable()
	for k,v in pairs(self.Items) do
		if v:IsVisible() then return end
	end
	if ValidPanel(self.tab) then
		self.tab:SetDisabled(true)
	end
end

function PANEL:Refresh()
	for k,v in pairs(self.Items) do
		v:Refresh()
	end
	self:ShouldDisable()
	self:InvalidateLayout()
end

function PANEL:Paint(w, h)
	draw.RoundedBoxEx(8, 0, 0, w, h, F4Menu.Colors.Background, false, false, false, true)
end

vgui.Register('OSXContentBase', PANEL, 'OSXPanelList')

local function isSingleCategory(list)
  return #list <= 1 
end

local function createCategories(self, categories, buyFunction, isShipment)
	local function createItem(member, parent, isLast)
		local panel = vgui.Create('OSXItem')
		panel:SetItem(member, isShipment)
		panel:SetBuyFunction(buyFunction)
		panel:SetIsLast(isLast)
		parent:AddItem(panel)
		return panel
	end

	local function createCategoryPanel(name, parent)
		local categoryPanel = vgui.Create('OSXCategory')
		categoryPanel:SetName(name)
		self:AddItem(categoryPanel)
		return categoryPanel
	end

	local function isLastIteration(array, index)
		return next(array, index) == nil
	end
	if isSingleCategory(categories) then
		local category = categories[1]
		local members = category.members
		for index, member in pairs(members) do
			local isLast = isLastIteration(members, index)
			createItem(member, self, isLast)
		end
	else
		for index, category in pairs(categories) do
			local members = category.members
			if table.Count(members) == 0 then continue end
			local categoryPanel = createCategoryPanel(category.name, self)
			for index, member in pairs(members) do
				local isLast = isLastIteration(members, index)
				createItem(member, categoryPanel, isLast)
			end
		end
	end
end

local PANEL = {}

function PANEL:Init()
	self.BaseClass.Init(self)
end

function PANEL:GenerateContent()
	local categories = DarkRP.getCategories().entities
	createCategories(self, categories, function(item)
		RunConsoleCommand('DarkRP', item.cmd)
	end)
end

function PANEL:CanBuy(item)
    local ply = LocalPlayer()

    if istable(item.allowed) and not table.HasValue(item.allowed, ply:Team()) then return false, true end
    if item.customCheck and not item.customCheck(ply) then return false, true end

    local canbuy, suppress, message, price = hook.Call('canBuyCustomEntity', nil, ply, item)
    local cost = price or item.getPrice and item.getPrice(ply, item.price) or item.price
    if not ply:canAfford(cost) then return false, false, message, cost end

    if canbuy == false then
        return false, suppress, message, cost
    end

    return true, nil, message, cost
end

vgui.Register('OSXEntities', PANEL, 'OSXContentBase')

local PANEL = {}

function PANEL:Init()
	self.BaseClass.Init(self)
end

function PANEL:GenerateContent()
	local categories = DarkRP.getCategories().shipments
	createCategories(self, categories, function(item)
		RunConsoleCommand('DarkRP', 'buyshipment', item.name)
	end, true)
end

function PANEL:CanBuy(ship)
    local ply = LocalPlayer()

    if not table.HasValue(ship.allowed, ply:Team()) then return false, true end
    if ship.customCheck and not ship.customCheck(ply) then return false, true end

    local canbuy, suppress, message, price = hook.Call('canBuyShipment', nil, ply, ship)
    local cost = price or ship.getPrice and ship.getPrice(ply, ship.price) or ship.price

    if not ply:canAfford(cost) then return false, false, message, cost end

    if canbuy == false then
        return false, suppress, message, cost
    end

    return true, nil, message, cost
end

vgui.Register('OSXShipments', PANEL, 'OSXContentBase')

local PANEL = {}

function PANEL:Init()
	self.BaseClass.Init(self)
end

function PANEL:GenerateContent()
	local categories = DarkRP.getCategories().weapons
	createCategories(self, categories, function(item)
		RunConsoleCommand('DarkRP', 'buy', item.name)
	end)
end

function PANEL:CanBuy(ship)
    local ply = LocalPlayer()

   	if GAMEMODE.Config.restrictbuypistol and not table.HasValue(ship.allowed, ply:Team()) then return false, true end
    if ship.customCheck and not ship.customCheck(ply) then return false, true end

    local canbuy, suppress, message, price = hook.Call('canBuyPistol', nil, ply, ship)
    local cost = price or ship.getPrice and ship.getPrice(ply, ship.pricesep) or ship.pricesep

    if not ply:canAfford(cost) then return false, false, message, cost end

    if canbuy == false then
        return false, suppress, message, cost
    end

    return true, nil, message, cost
end

vgui.Register('OSXGuns', PANEL, 'OSXContentBase')

local PANEL = {}

function PANEL:Init()
	self.BaseClass.Init(self)
end

function PANEL:GenerateContent()
	for index, item in pairs(FoodItems) do
		local panel = vgui.Create('OSXItem')
		panel:SetItem(item)
		panel:SetBuyFunction(function(item)
			RunConsoleCommand('DarkRP', 'buyfood', item.name)
		end)
		self:AddItem(panel)
	end
end

function PANEL:CanBuy(food)
	local ply = LocalPlayer()

	if (food.requiresCook == nil or food.requiresCook == true) and not ply:isCook() then return false, true end

	if food.customCheck and not food.customCheck(ply) then return false, true end

	if not ply:canAfford(food.price) then return false, false end

	return true
end

vgui.Register('OSXFood', PANEL, 'OSXContentBase')

hook.Add('F4MenuTabs', 'HungerMod_F4Tabs', function()
	if not FoodItems then return end
    if #FoodItems > 0 then
        DarkRP.addF4MenuTab(DarkRP.getPhrase('food'), vgui.Create('OSXFood'))
    end
end)

local PANEL = {}

function PANEL:Init()
	self.BaseClass.Init(self)
end

function PANEL:GenerateContent()
	local categories = DarkRP.getCategories().ammo
	createCategories(self, categories, function(item)
		RunConsoleCommand('DarkRP', 'buyammo', item.id)
	end)
end

function PANEL:CanBuy(item)
    local ply = LocalPlayer()

   	if item.customCheck and not item.customCheck(ply) then return false, true end

    local canbuy, suppress, message, price = hook.Call('canBuyAmmo', nil, ply, item)
    local cost = price or item.getPrice and item.getPrice(ply, item.price) or item.price
    if not ply:canAfford(cost) then return false, false, message, cost end

    if canbuy == false then
        return false, suppress, message, price
    end

    return true, nil, message, price
end

vgui.Register('OSXAmmo', PANEL, 'OSXContentBase')

local PANEL = {}

function PANEL:Init()
	self.BaseClass.Init(self)
end

function PANEL:GenerateContent()
	local categories = DarkRP.getCategories().vehicles
	createCategories(self, categories, function(item)
		RunConsoleCommand('DarkRP', 'buyvehicle', item.name)
	end)
end

function PANEL:CanBuy(item)
    local ply = LocalPlayer()
    local cost = item.getPrice and item.getPrice(ply, item.price) or item.price

    if istable(item.allowed) and not table.HasValue(item.allowed, ply:Team()) then return false, true end
    if item.customCheck and not item.customCheck(ply) then return false, true end

    local canbuy, suppress, message, price = hook.Call('canBuyVehicle', nil, ply, item)

    cost = price or cost

    if not ply:canAfford(cost) then return false, false, message, cost end

    if canbuy == false then
        return false, suppress, message, cost
    end

    return true, nil, message, cost
end

vgui.Register('OSXVehicles', PANEL, 'OSXContentBase')
