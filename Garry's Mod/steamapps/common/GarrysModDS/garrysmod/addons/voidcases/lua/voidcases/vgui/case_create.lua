local L = VoidCases.Lang.GetPhrase
local sc = VoidUI.Scale

// Create Case panel

local PANEL = {}

function PANEL:Init()

    self:MakePopup()
    self:SetSize(ScrW() * 0.5, ScrH() * 0.6)
    self:Center()

    self.currCategory = 1

    local itemObj = {
        name = "Case",
        type = VoidCases.ItemTypes.Case,
        info = {
            rarity = VoidCases.Rarities.Common,
            icon = "models/voidcases/plastic_crate.mdl",
            shopPrice = 200,
            caseColor = Color(255,255,255),
            requiresKey = true,

            caseIcon = "qFmcbT0", // transparent icon

            shopCategory = self.currCategory,
            isMarketable = true,
            sellInShop = true,

            worldOpening = true,
            forceUnboxing = false,

            unboxableItems = {},
            mysteryItems = {},

            cooldownType = 0,
            cooldownTime = 0,

            requiredUsergroups = {},
        
            currency = table.GetKeys(VoidCases.Config.Currencies)[1]
        },
    }


    self.setCategory = function (cat)
        self.currCategory = cat
        itemObj.info.shopCategory = cat
    end

    
    local frame = self:Add("VoidUI.Frame")
    frame:Dock(FILL)
    frame:MarginRight(30)

    frame:SetTitle(L"creating_item")

    self.itemPreview = self:Add("Panel")
    self.itemPreview:Dock(RIGHT)
    self.itemPreview:SSetWide(290)

    self.itemPreview.Paint = function (self, w, h)
        local x, y = self:LocalToScreen(0, 0)

        BSHADOWS.BeginShadow()
            draw.RoundedBox(0, x, y, w, sc(350), VoidUI.Colors.Primary)
        BSHADOWS.EndShadow(1, 1, 1, 150, 0, 0)

        draw.SimpleText(L"item_preview", "VoidUI.B28", w/2, sc(35), VoidUI.Colors.GrayTransparent, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    function frame:OnRemove()
        self:GetParent():Remove()
    end

    self.itemP = self.itemPreview:Add("VoidCases.Item")
    self.itemP:Dock(TOP)
    self.itemP:MarginSides(15)
    self.itemP:MarginTops(15)
    self.itemP:MarginTop(60)

    self.itemP:SSetTall(260)

    self.itemP:SetItem(itemObj)

    local itemP = self.itemP

    self.tabs = frame:Add("VoidUI.Tabs")
    self.tabs:Dock(FILL)
    self.tabs:SetAccentColor(VoidCases.AccentColor)

    local buttonContainer = frame:Add("Panel")
    buttonContainer:Dock(BOTTOM)
    buttonContainer:SSetTall(100)
    buttonContainer:SDockPadding(100,30,100,30)

    self.create = buttonContainer:Add("VoidUI.Button")
    self.create.text = L"save"
    self.create:Dock(LEFT)
    self.create:SSetWide(200)
    self.create:SetColor(VoidUI.Colors.Green, VoidUI.Colors.Background)

    self.create.DoClick = function ()

        if (!VoidCases.IsItemValid(itemObj)) then return end

        if (self.isEditing) then
            net.Start("VoidCases_ModifyItem")
                net.WriteUInt(self.editID, 32)
                net.WriteTable(itemObj)
            net.SendToServer()
        else
            net.Start("VoidCases_CreateItem")
                net.WriteTable(itemObj)
            net.SendToServer()
        end

        for k, v in pairs(self:GetParent().modelsToHide or {}) do
            if (IsValid(v) and v.icon) then
                v.icon:SetVisible(true)
            end
        end

        self:Remove()
    end

    self.itemDetails = self.tabs:Add("Panel")
    self.itemDetails:Dock(LEFT)
    self.itemDetails:SetWide(ScrW() * 0.315)
    self.itemDetails:DockMargin(0, 0, 0, 0)

    local entryPanel = self.itemDetails:Add("VoidUI.Grid")
    entryPanel:Dock(FILL)
    entryPanel:DockMargin(sc(18), sc(8), 0, 0)
    
    entryPanel:InvalidateParent(true)

    entryPanel:SetColumns(2)
    entryPanel:SetHorizontalMargin(ScrW() * 0.023)
    entryPanel:SetVerticalMargin(ScrH() * 0.037)

    // Name

    local nameEntry = vgui.Create("Panel")
    nameEntry:SetWide(ScrW() * 0.124)
    nameEntry:SetTall(sc(75))
    
    nameEntry.Paint = function (self, w, h)
        draw.SimpleText(L"name", "VoidUI.B24", 0, sc(15), VoidUI.Colors.GrayTransparent, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    

    nameEntry.input = nameEntry:Add("VoidUI.TextInput")
    nameEntry.input:Dock(TOP)
    nameEntry.input:DockMargin(0, sc(30), 0, 0)
    nameEntry.input:SetTall(sc(45))

    function nameEntry.input.entry:OnValueChange(val)
		itemObj.name = val   
	end

    entryPanel:AddCell(nameEntry)

    // Price

    local priceEntry = vgui.Create("Panel")
    priceEntry:SetWide(ScrW() * 0.124)
    priceEntry:SetTall(sc(75))
    
    priceEntry.Paint = function (self, w, h)
        draw.SimpleText(L"price", "VoidUI.B24", 0, sc(15), VoidUI.Colors.GrayTransparent, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    priceEntry.input = priceEntry:Add("VoidUI.TextInput")
    priceEntry.input:Dock(TOP)
    priceEntry.input:DockMargin(0, sc(30), 0, 0)
    priceEntry.input:SetTall(sc(45))

    function priceEntry.input.entry:OnValueChange(val)
		itemObj.info.shopPrice = val   
	end

    entryPanel:AddCell(priceEntry)

    // Case skin

    local caseEntry = vgui.Create("Panel")
    caseEntry:SetWide(ScrW() * 0.124)
    caseEntry:SetTall(sc(75))
    
    caseEntry.Paint = function (self, w, h)
        draw.SimpleText(L"case_skin", "VoidUI.B24", 0, sc(15), VoidUI.Colors.GrayTransparent, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    caseEntry.input = caseEntry:Add("VoidUI.Dropdown")
    caseEntry.input:Dock(TOP)
    caseEntry.input:DockMargin(0, sc(30), 0, 0)
    caseEntry.input:SetTall(sc(45))

    caseEntry.input:AddChoice(L"plastic_crate")
    caseEntry.input:AddChoice(L"wooden_crate")
    caseEntry.input:AddChoice(L"scifi_crate")

    caseEntry.input:ChooseOptionID(1)

    local models = {
        [1] = "models/voidcases/plastic_crate.mdl",
        [2] = "models/voidcases/wooden_crate.mdl",
        [3] = "models/voidcases/scifi_crate.mdl"
    }

    function caseEntry.input:OnSelect(index, val)
        itemObj.info.icon = models[index]

        local caseIcon = itemP.icon.Entity:GetNWString("CrateLogo", nil)
        local caseColor = itemP.icon.Entity:GetNWString("CrateColor", nil)

        itemP:SetItem(itemObj)

        if (caseIcon) then
            itemP.icon.Entity:SetNWString("CrateLogo", itemObj.info.caseIcon)
        end

        if (caseColor and IsColor(itemObj.info.caseColor)) then
            itemP.icon.Entity:SetNWString("CrateColor", itemObj.info.caseColor:ToVector())
        end

    end


    entryPanel:AddCell(caseEntry)

    // Rarity

    local rarityEntry = vgui.Create("Panel")
    rarityEntry:SetWide(ScrW() * 0.124)
    rarityEntry:SetTall(sc(75))
    
    rarityEntry.Paint = function (self, w, h)
        draw.SimpleText(L"rarity", "VoidUI.B24", 0, sc(15), VoidUI.Colors.GrayTransparent, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    rarityEntry.input = rarityEntry:Add("VoidUI.Dropdown")
    rarityEntry.input:Dock(TOP)
    rarityEntry.input:DockMargin(0, sc(30), 0, 0)
    rarityEntry.input:SetTall(sc(45))

    rarityEntry.input:SetValue("Select rarity")

    for k, v in SortedPairsByValue(VoidCases.Rarities) do
        rarityEntry.input:AddChoice(k)
        if (v == 1) then
            rarityEntry.input:ChooseOption(k)
        end
    end

    function rarityEntry.input:OnSelect(index, val)
        itemObj.info.rarity = index
    end


    entryPanel:AddCell(rarityEntry)


    // Image

    local imageEntry = vgui.Create("Panel")
    imageEntry:SetWide(ScrW() * 0.124)
    imageEntry:SetTall(sc(75))
    
    imageEntry.Paint = function (self, w, h)
        draw.SimpleText(L"custom_image_id", "VoidUI.B24", 0, sc(15), VoidUI.Colors.GrayTransparent, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    imageEntry.input = imageEntry:Add("VoidCases.TextInputLogo")
    imageEntry.input:Dock(TOP)
    imageEntry.input:DockMargin(0, sc(30), 0, 0)
    imageEntry.input:SetTall(sc(45))

    //
    function imageEntry.input.entry:OnValueChange(val)
        if (#val > 3) then
            itemObj.info.caseIcon = val

            VoidLib.FetchImage(val, function (mat)
                itemP.icon.Entity:SetNWString("CrateLogo", val)
            end)
        end 
	end


    entryPanel:AddCell(imageEntry)


    // Color mixer

    local colorEntry = vgui.Create("Panel")
    colorEntry:SetWide(ScrW() * 0.124)
    colorEntry:SetTall(200)
    
    colorEntry.Paint = function (self, w, h)
        draw.SimpleText(L"case_color", "VoidUI.B24", 0, sc(15), VoidUI.Colors.GrayTransparent, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    colorEntry.input = colorEntry:Add("VoidUI.ColorMixer")
    colorEntry.input:Dock(TOP)
    colorEntry.input:DockMargin(5, 35, 5, 0)
    colorEntry.input:SetTall(150)

    function colorEntry.input.colorMixer:ValueChanged(color)
        color = Color(color.r, color.g, color.b, 255)

        itemObj.info.caseColor = color

        itemP.icon.Entity:SetNWString("CrateColor", color:ToVector())
    end



    entryPanel:AddCell(colorEntry)


    self.caseItems = {}
    self.mysteryItems = {}


    self.itemLimits = self.tabs:Add("Panel")
    self.itemLimits:Dock(LEFT)
    self.itemLimits:SetWide(ScrW() * 0.315)
    self.itemLimits:DockMargin(0, 0, 0, 0)

    self.itemLimits:SetVisible(false)


    local entryLimitsPanel = self.itemLimits:Add("VoidUI.Grid")
    entryLimitsPanel:Dock(FILL)
    entryLimitsPanel:DockMargin(18, 24, 0, 18)

    entryLimitsPanel:InvalidateParent(true)

    entryLimitsPanel:SetColumns(2)
    entryLimitsPanel:SetHorizontalMargin(45)
    entryLimitsPanel:SetVerticalMargin(35)

    // Sell in shop

    local sellShopEntry = vgui.Create("Panel")
    sellShopEntry:SetWide(ScrW() * 0.124)
    sellShopEntry:SetTall(sc(75))
    
    sellShopEntry.Paint = function (self, w, h)
        draw.SimpleText(L"sell_in_shop", "VoidUI.B24", 0, sc(15), VoidUI.Colors.GrayTransparent, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    sellShopEntry.input = sellShopEntry:Add("VoidUI.Switch")
    sellShopEntry.input:Dock(TOP)
    sellShopEntry.input:DockMargin(0, sc(30), 0, 0)
    sellShopEntry.input:SetTall(sc(45))
    sellShopEntry.input:DropdownCompat()

    function sellShopEntry.input:OnSelect(index, val)
        if (index == 1) then
            itemObj.info.sellInShop = true
        else
            itemObj.info.sellInShop = false
        end
    end

    entryLimitsPanel:AddCell(sellShopEntry)

    // Requires key

    local requiresKeyEntry = vgui.Create("Panel")
    requiresKeyEntry:SetWide(ScrW() * 0.124)
    requiresKeyEntry:SetTall(sc(75))
    
    requiresKeyEntry.Paint = function (self, w, h)
        draw.SimpleText(L"requires_key", "VoidUI.B24", 0, sc(15), VoidUI.Colors.GrayTransparent, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    requiresKeyEntry.input = requiresKeyEntry:Add("VoidUI.Switch")
    requiresKeyEntry.input:Dock(TOP)
    requiresKeyEntry.input:DockMargin(0, sc(30), 0, 0)
    requiresKeyEntry.input:SetTall(sc(45))
    requiresKeyEntry.input:DropdownCompat()

    function requiresKeyEntry.input:OnSelect(index, val)
        if (index == 1) then
            itemObj.info.requiresKey = true
        else
            itemObj.info.requiresKey = false
        end
    end

    entryLimitsPanel:AddCell(requiresKeyEntry)

    // Inworld opening

    local wolrdOpeningEntry = vgui.Create("Panel")
    wolrdOpeningEntry:SetWide(ScrW() * 0.124)
    wolrdOpeningEntry:SetTall(sc(75))
    
    wolrdOpeningEntry.Paint = function (self, w, h)
        draw.SimpleText(L("force_unbox_type"):upper(), "VoidUI.B24", 0, sc(15), VoidUI.Colors.GrayTransparent, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    wolrdOpeningEntry.input = wolrdOpeningEntry:Add("VoidUI.Dropdown")
    wolrdOpeningEntry.input:Dock(TOP)
    wolrdOpeningEntry.input:DockMargin(0, sc(30), 0, 0)
    wolrdOpeningEntry.input:SetTall(sc(45))

    wolrdOpeningEntry.input:AddChoice(L"any")
    wolrdOpeningEntry.input:AddChoice(L"csgo_unboxing")
    wolrdOpeningEntry.input:AddChoice(L"world_unboxing")

    wolrdOpeningEntry.input:ChooseOptionID(1)

    function wolrdOpeningEntry.input:OnSelect(index, val)
        if (index == 1) then
            itemObj.info.forceUnboxing = false
        elseif (index == 2) then
            itemObj.info.forceUnboxing = "csgo"
        else
            itemObj.info.forceUnboxing = "world"
        end
    end

    entryLimitsPanel:AddCell(wolrdOpeningEntry)

    entryLimitsPanel:Skip()

    // Usergroup restriction

    local groupEntry = vgui.Create("Panel")
    groupEntry:SetWide(ScrW() * 0.124)
    groupEntry:SetTall(sc(75))
    
    groupEntry.Paint = function (self, w, h)
        draw.SimpleText(L"usergroups", "VoidUI.B24", 0, sc(15), VoidUI.Colors.GrayTransparent, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    groupEntry.input = groupEntry:Add("VoidUI.Dropdown")
    groupEntry.input:Dock(TOP)
    groupEntry.input:DockMargin(0, sc(30), 0, 0)
    groupEntry.input:SetTall(sc(45))

    groupEntry.input.multiple = true
    groupEntry.input.selectedItems = {}
    groupEntry.input:SetText("...")

    for k, v in pairs(CAMI.GetUsergroups()) do
        groupEntry.input:AddChoice(v.Name)
    end

    function groupEntry.input:OnSelect( index, val ) 
        if (self.selectedItems[val]) then
            self.selectedItems[val] = nil
        else
            self.selectedItems[val] = true
        end

        itemObj.info.requiredUsergroups = self.selectedItems

    end 
    
    entryLimitsPanel:AddCell(groupEntry)

    // Display if not correct usergroup

    local displayGroupEntry = vgui.Create("Panel")
    displayGroupEntry:SetWide(ScrW() * 0.124)
    displayGroupEntry:SetTall(sc(75))
    
    displayGroupEntry.Paint = function (self, w, h)
        draw.SimpleText(L"show_if_cant_purchase", "VoidUI.B24", 0, sc(15), VoidUI.Colors.GrayTransparent, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    displayGroupEntry.input = displayGroupEntry:Add("VoidUI.Switch")
    displayGroupEntry.input:Dock(TOP)
    displayGroupEntry.input:DockMargin(0, sc(30), 0, 0)
    displayGroupEntry.input:SetTall(sc(45))
    displayGroupEntry.input:DropdownCompat()

    function displayGroupEntry.input:OnSelect(index, val)
        if (index == 1) then
            itemObj.info.showIfCannotPurchase = true
        else
            itemObj.info.showIfCannotPurchase = false
        end
    end

    entryLimitsPanel:AddCell(displayGroupEntry)


    // Limits per x

    local purchaseCooldownEntry = vgui.Create("Panel")
    purchaseCooldownEntry:SetWide(ScrW() * 0.124)
    purchaseCooldownEntry:SetTall(sc(75))
    
    purchaseCooldownEntry.Paint = function (self, w, h)
        draw.SimpleText(L"purchase_cooldown", "VoidUI.B24", 0, sc(15), VoidUI.Colors.GrayTransparent, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    purchaseCooldownEntry.input = purchaseCooldownEntry:Add("VoidUI.Dropdown")
    purchaseCooldownEntry.input:Dock(TOP)
    purchaseCooldownEntry.input:DockMargin(0, sc(30), 0, 0)
    purchaseCooldownEntry.input:SetTall(sc(45))

    local intervals = {
        ["none"] = 0,
        ["minute"] = 60,
        ["hour"] = 3600,
        ["day"] = 86400,
        ["week"] = 604800,
        ["month"] = 2628000
    }



    for k, v in SortedPairsByValue(intervals) do
        purchaseCooldownEntry.input:AddChoice(L(k), v)
    end
    
    purchaseCooldownEntry.input:ChooseOptionID(1)

    function purchaseCooldownEntry.input:OnSelect(index, val, data)
        itemObj.info.cooldownType = data
    end

    entryLimitsPanel:AddCell(purchaseCooldownEntry)


    // Item limits per x value
    local purchaseCooldownTimeEntry = vgui.Create("Panel")
    purchaseCooldownTimeEntry:SetWide(ScrW() * 0.124)
    purchaseCooldownTimeEntry:SetTall(sc(75))
    
    purchaseCooldownTimeEntry.Paint = function (self, w, h)
        draw.SimpleText(L"purchase_cooldown_time", "VoidUI.B24", 0, sc(15), VoidUI.Colors.GrayTransparent, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end


    purchaseCooldownTimeEntry.input = purchaseCooldownTimeEntry:Add("VoidUI.TextInput")
    purchaseCooldownTimeEntry.input:Dock(TOP)
    purchaseCooldownTimeEntry.input:DockMargin(0, sc(30), 0, 0)
    purchaseCooldownTimeEntry.input:SetTall(sc(45))
    purchaseCooldownTimeEntry.input.entry:SetNumeric(true)


    function purchaseCooldownTimeEntry.input.entry:OnValueChange(val)
        if (val and isnumber(tonumber(val))) then
            itemObj.info.cooldownTime = tonumber(val)
        end
	end


    entryLimitsPanel:AddCell(purchaseCooldownTimeEntry)


    // Currency
    local currencyEntry = vgui.Create("Panel")
    currencyEntry:SetWide(ScrW() * 0.124)
    currencyEntry:SetTall(sc(75))
    
    currencyEntry.Paint = function (self, w, h)
        draw.SimpleText(string.upper(L"settings_currency"), "VoidUI.B24", 0, sc(15), VoidUI.Colors.GrayTransparent, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end


    currencyEntry.input = currencyEntry:Add("VoidUI.Dropdown")
    currencyEntry.input:Dock(TOP)
    currencyEntry.input:DockMargin(0, sc(30), 0, 0)
    currencyEntry.input:SetTall(sc(45))

    local currencyIndex = 0
    for k, v in pairs(VoidCases.Config.Currencies) do
        currencyIndex = currencyIndex + 1
        currencyEntry.input:AddChoice(k)
        if (VoidCases.Config.Currency and k == VoidCases.Config.Currency) then
            currencyEntry.input:ChooseOptionID(currencyIndex)
        end
    end

    if (!VoidCases.Config.Currency) then
        currencyEntry.input:ChooseOptionID(1)
    end
    

    function currencyEntry.input:OnSelect(index, val)
        itemObj.info.currency = val
    end
    
    entryLimitsPanel:AddCell(currencyEntry)

    

    self.items = self.tabs:Add("Panel")
    self.items:Dock(LEFT)
    self.items:SetWide(ScrW() * 0.315)
    self.items:DockMargin(0, 0, 0, 0)

    self.items:SetVisible(false)


    local itemsPanel = self.items:Add("VoidUI.Grid")
    itemsPanel:Dock(FILL)
    itemsPanel:DockMargin(18, 24, 0, 18)

    itemsPanel:InvalidateParent(true)

    itemsPanel:SetColumns(4)
    itemsPanel:SetHorizontalMargin(15)
    itemsPanel:SetVerticalMargin(15)


    -- items start


    self.refreshCaseItems = function ()

        itemsPanel:Clear()

        local caseItems = table.Copy(self.caseItems)
        local mysteryItems = table.Copy(self.mysteryItems)

        itemObj.info.unboxableItems = caseItems
        itemObj.info.mysteryItems = mysteryItems


        local chanceSum = 0
        for k, v in pairs(caseItems) do
            if (!isstring(v)) then
                chanceSum = chanceSum + v
            end
        end

        for k, v in SortedPairsByValue(caseItems, true) do

            local it = VoidCases.Config.Items[k]
            if (!it) then continue end

            local itemPercentage = math.Round((100 / chanceSum) * self.caseItems[k], 1)

            // Existing
            local item = vgui.Create("VoidCases.Item")
            item:SSetTall(140)
            item.isShowcase = true
            item.showMoney = false
            item.statusText = itemPercentage .. "%"
            item.statusColor = VoidUI.Colors.Green

            item:SetItem(it)

            local itemB = item:Add("DButton")
            itemB:SetZPos(30)
            itemB:Dock(FILL)
            itemB:SetText("")
            itemB.Paint = function (self, w, h)

            end

            itemB.DoClick = function ()
                local panel = vgui.Create("VoidCases.AddCaseItem")
				panel:SSetSize(380, 350)
				panel:MakePopup()

				panel:Center()

				panel:SetParent(self)

				panel:SetItem(it, k, self, true, self.caseItems[k], self.mysteryItems[k])
            end

            itemsPanel:AddCell(item)
        end

        local addItem = vgui.Create("DButton")
        addItem:SSetSize(140, 140)
        addItem:SetText("")
        addItem.Paint = function (self, w, h)
            draw.RoundedBox(8, 0, 0, w, h, VoidUI.Colors.White)

            // plus icon
            surface.SetMaterial(VoidCases.Icons.PlusSmall)
            surface.SetDrawColor(VoidUI.Colors.White)
            surface.DrawTexturedRect(w/2-sc(25), h/2-sc(25), sc(50), sc(50))
        end

        addItem.DoClick = function ()
            local panel = vgui.Create("VoidCases.ItemSelection")
            panel:SSetSize(278,335)
            panel:MakePopup()

            local cx, cy = input.GetCursorPos()

            panel:SetPos(cx-sc(80), cy)

            panel:SetParent(self)
                
            panel:InitItems()
        end

        itemsPanel:AddCell(addItem, sc(140), sc(140))

    end

    self.refreshCaseItems()


    -- items end


    self.tabs:AddTab(L"item_details", self.itemDetails)
    self.tabs:AddTab(L"item_limitations", self.itemLimits)
    self.tabs:AddTab(L("items"):upper(), self.items)
    

    local caseModels = {
        ["models/voidcases/plastic_crate.mdl"] = 1,
        ["models/voidcases/wooden_crate.mdl"] = 2,
        ["models/voidcases/scifi_crate.mdl"] = 3
    }

    self.setEditing = function (item, id)
        self.isEditing = true
        self.editCrate = item
        self.editID = id

        frame:SetTitle(string.format(L"editing", self.editCrate.name) .. " (" .. self.editID .. ")")

        self.delete = buttonContainer:Add("VoidUI.Button")
        self.delete.text = L"delete"
        self.delete:Dock(RIGHT)
        self.delete:SSetWide(200)

        self.delete:SetColor(VoidUI.Colors.Red, VoidUI.Colors.Background)

        self.delete.DoClick = function ()
            Derma_Query(string.format(L"delete_confirmation", item.name), string.format(L"delete_confirm_title", item.name), L"delete", function ()
                net.Start("VoidCases_DeleteItem")
                    net.WriteUInt(self.editID, 32)
                net.SendToServer()

                for k, v in pairs(self:GetParent().modelsToHide or {}) do
                    if (IsValid(v) and v.icon) then
                        v.icon:SetVisible(true)
                    end
                end

                self:Remove()
            end, L"cancel")
        end

        itemObj = table.Copy(item)
        itemP:SetItem(itemObj)

        self.caseItems = itemObj.info.unboxableItems or {}
        self.mysteryItems = itemObj.info.mysteryItems or {}
        self.refreshCaseItems()

        nameEntry.input.entry:SetValue(item.name)
        priceEntry.input.entry:SetValue(item.info.shopPrice)
        caseEntry.input:ChooseOptionID(caseModels[item.info.icon] or 1)
        rarityEntry.input:ChooseOptionID(item.info.rarity)
        imageEntry.input.entry:SetValue(item.info.caseIcon)
        colorEntry.input.colorMixer:SetColor(item.info.caseColor)

        sellShopEntry.input:ChooseOptionID(item.info.sellInShop and 1 or 2)
        requiresKeyEntry.input:ChooseOptionID(item.info.requiresKey and 1 or 2)

        local optionForce = 1
        if (item.info.forceUnboxing == "csgo") then
            optionForce = 2
        elseif (item.info.forceUnboxing == "world") then
            optionForce = 3
        end
        wolrdOpeningEntry.input:ChooseOptionID(optionForce)

        groupEntry.input.selectedItems = itemObj.info.requiredUsergroups or {}
        displayGroupEntry.input:ChooseOptionID(item.info.showIfCannotPurchase and 1 or 2)

        local intervalIDs = {
            [0] = 1,
            [60] = 2,
            [3600] = 3,
            [86400] = 4,
            [604800] = 5,
            [2628000] = 6
        }

        purchaseCooldownEntry.input:ChooseOptionID(intervalIDs[itemObj.info.cooldownType or 0] or 1)
        purchaseCooldownTimeEntry.input.entry:SetValue(itemObj.info.cooldownTime or "")

        local i = 0
        for k, v in pairs(VoidCases.Config.Currencies) do
            i = i + 1
            if (k == itemObj.info.currency) then
                currencyEntry.input:ChooseOptionID(i)
            end
        end
    end

end


function PANEL:Paint(w, h)
    
end

vgui.Register("VoidCases.CaseCreate", PANEL, "EditablePanel")