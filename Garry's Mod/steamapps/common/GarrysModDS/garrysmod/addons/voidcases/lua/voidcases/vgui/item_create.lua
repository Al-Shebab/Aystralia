
local L = VoidCases.Lang.GetPhrase
local sc = VoidUI.Scale

// Create Item panel

local PANEL = {}

function PANEL:Init()

    self:MakePopup()
    self:SetSize(ScrW() * 0.5, ScrH() * 0.6)
    self:Center()

    local frame = self:Add("VoidUI.Frame")
    frame:Dock(FILL)
    frame:MarginRight(30)


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

    local itemP = self.itemP

    self.currCategory = 1

    local itemObj = {
        name = "Item",
        type = VoidCases.ItemTypes.Unboxable,
        info = {
            shopCategory = self.currCategory,
            rarity = VoidCases.Rarities.Common,
            icon = nil,

            sellInShop = false,
            isMarketable = true,
            shopPrice = 0,

            actionType = "weapon",
            actionValue = "",

            weaponSkin = nil,
            isPermanent = false,

            autoEquip = false,

            cooldownType = 0,
            cooldownTime = 0,
        
            currency = table.GetKeys(VoidCases.Config.Currencies)[1]
        },
    }

    self.itemP:SetItem(itemObj)

    self.setCategory = function (cat)
        self.currCategory = cat
        itemObj.info.shopCategory = cat
    end

    frame:SetTitle(L"creating_item")

    self.isEditing = false
    self.editCrate = nil

    self.tabs = frame:Add("VoidUI.Tabs")
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
    entryPanel:DockMargin(18, 10, 0, 10)

    entryPanel:InvalidateParent(true)

    entryPanel:SetColumns(2)
    entryPanel:SetHorizontalMargin(45)
    entryPanel:SetVerticalMargin(40)

    // Name

    local nameEntry = vgui.Create("Panel")
    nameEntry:SSetWide(250)
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

    // Type choose

    local typeChooseEntry = vgui.Create("Panel")
    typeChooseEntry:SetWide(ScrW() * 0.124)
    typeChooseEntry:SetTall(sc(75))
    
    typeChooseEntry.Paint = function (self, w, h)
        draw.SimpleText(L"item_type", "VoidUI.B24", 0, sc(15), VoidUI.Colors.GrayTransparent, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    typeChooseEntry.input = typeChooseEntry:Add("VoidUI.Dropdown")
    typeChooseEntry.input:Dock(TOP)
    typeChooseEntry.input:DockMargin(0, sc(30), 0, 0)
    typeChooseEntry.input:SetTall(sc(45))

    local valuesIndex = {}

    for k, v in pairs(VoidCases.Config.Actions) do
        local index = typeChooseEntry.input:AddChoice(L(k))
        if (k == "weapon") then
            typeChooseEntry.input:ChooseOptionID(index)
        end

        valuesIndex[k] = index
    end

    local typeChooseValueEntry = vgui.Create("Panel")
    local skinChooseEntry = vgui.Create("Panel")
    local permaEntry = vgui.Create("Panel")
    local skinTypeChooseEntry = vgui.Create("Panel")

    -- local function createWepSelector(input)
    --     local selector = vgui.Create("VoidUI.SelectorButton")
        
    --     return selector
    -- end

    local function switchWepSelector(b)
        typeChooseValueEntry.inputWep:SetVisible(b)
        typeChooseValueEntry.input:SetVisible(!b)
    end

    function typeChooseEntry.input:OnSelect(index, val)

        itemObj.info.actionType = table.KeyFromValue(valuesIndex, index)

        typeChooseValueEntry.input.entry:SetValue("")

        if (index == valuesIndex["weapon"]) then
            switchWepSelector(true)
            permaEntry:SetVisible(true)
        else
            permaEntry:SetVisible(false)
        end

        if (index == valuesIndex["entity"]) then
            switchWepSelector(false)
            typeChooseValueEntry.input.entry:SetFont("VoidUI.R28")
            typeChooseValueEntry.input.entry:SetNumeric(false)
        end

        if (index == valuesIndex["concommand"]) then
            switchWepSelector(false)
            typeChooseValueEntry.input.entry:SetFont("VoidUI.R20")
            typeChooseValueEntry.input.entry:SetNumeric(false)
        end
        
        if (index == valuesIndex["money"]) then
            switchWepSelector(false)
            typeChooseValueEntry.input.entry:SetFont("VoidUI.R28")
            typeChooseValueEntry.input.entry:SetNumeric(true)
        end

        if (index == valuesIndex["pointshop2_item"]) then
            switchWepSelector(false)
            typeChooseValueEntry.input.entry:SetFont("VoidUI.R28")
            typeChooseValueEntry.input.entry:SetNumeric(false)
        end

        if (index == valuesIndex["pointshop_item"]) then
            switchWepSelector(false)
            typeChooseValueEntry.input.entry:SetFont("VoidUI.R28")
            typeChooseValueEntry.input.entry:SetNumeric(false)
        end

        if (index == valuesIndex["pointshopsh_item"]) then
            switchWepSelector(false)
            typeChooseValueEntry.input.entry:SetFont("VoidUI.R28")
            typeChooseValueEntry.input.entry:SetNumeric(false)
        end

        if (index == valuesIndex["weapon_skin"]) then
            skinChooseEntry:SetVisible(true)
            skinTypeChooseEntry:SetVisible(true)
            switchWepSelector(true)
            timer.Simple(0, skinChooseEntry.refreshSkins)
        elseif (index != valuesIndex["weapon"]) then
            skinChooseEntry:SetVisible(false)
            skinTypeChooseEntry:SetVisible(false)
            switchWepSelector(false)
        end

        
    end

    entryPanel:AddCell(typeChooseEntry)
    
    // Type choose value

    typeChooseValueEntry:SetWide(ScrW() * 0.124)
    typeChooseValueEntry:SetTall(sc(75))
    
    typeChooseValueEntry.Paint = function (self, w, h)
        if (typeChooseEntry.input:GetSelectedID() == valuesIndex["weapon"] or typeChooseEntry.input:GetSelectedID() == valuesIndex["weapon_skin"]) then
            draw.SimpleText(L"weapon":upper(), "VoidUI.B24", 0, sc(15), VoidUI.Colors.GrayTransparent, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        if (typeChooseEntry.input:GetSelectedID() == valuesIndex["entity"]) then
            draw.SimpleText(L"entity_class", "VoidUI.B24", 0, sc(15), VoidUI.Colors.GrayTransparent, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        if (typeChooseEntry.input:GetSelectedID() == valuesIndex["concommand"]) then
            draw.SimpleText(L"concommand_type", "VoidUI.B24", 0, sc(15), VoidUI.Colors.GrayTransparent, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        if (typeChooseEntry.input:GetSelectedID() == valuesIndex["money"]) then
            draw.SimpleText(L"money_type", "VoidUI.B24", 0, sc(15), VoidUI.Colors.GrayTransparent, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        if (typeChooseEntry.input:GetSelectedID() == valuesIndex["pointshop2_item"]) then
            draw.SimpleText(L"pointshop_name", "VoidUI.B24", 0, sc(15), VoidUI.Colors.GrayTransparent, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        if (typeChooseEntry.input:GetSelectedID() == valuesIndex["pointshop_item"]) then
            draw.SimpleText(L"pointshop_class", "VoidUI.B24", 0, sc(15), VoidUI.Colors.GrayTransparent, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        if (typeChooseEntry.input:GetSelectedID() == valuesIndex["pointshopsh_item"]) then
            draw.SimpleText(L"pointshop_class", "VoidUI.B24", 0, sc(15), VoidUI.Colors.GrayTransparent, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        
    end


    typeChooseValueEntry.input = typeChooseValueEntry:Add("VoidUI.TextInput")
    typeChooseValueEntry.input:Dock(TOP)
    typeChooseValueEntry.input:DockMargin(0, sc(30), 0, 0)
    typeChooseValueEntry.input:SetTall(sc(45))
    typeChooseValueEntry.input:SetVisible(false)

    typeChooseValueEntry.inputWep = typeChooseValueEntry:Add("VoidUI.SelectorButton")
    typeChooseValueEntry.inputWep:Dock(TOP)
    typeChooseValueEntry.inputWep:DockMargin(0, sc(30), 0, 0)
    typeChooseValueEntry.inputWep:SetTall(sc(45))
    typeChooseValueEntry.inputWep:SetVisible(true)

    local iconChooseEntry = vgui.Create("Panel")
    local iconValueEntry = vgui.Create("Panel")

    typeChooseValueEntry.inputWep.DoClick = function ()
        local selector = vgui.Create("VoidUI.ItemSelect")
        selector:SetParent(self)

        local weps = weapons.GetList()
        local wepTbl = {}
        for id, wep in ipairs(weps) do
            if (engine.ActiveGamemode() != "terrortown" and !wep.Spawnable) then continue end
            local isEmpty = wep.PrintName == nil or wep.PrintName == ""
            wepTbl[wep.ClassName] = isEmpty and wep.ClassName or wep.PrintName
        end

        selector.SearchFunc = function (item, str, name)
            return name:lower():find(str:lower(), 1, true) or item:find(str:lower(), 1, true)
        end

        selector:InitItems(wepTbl, function (id, v)
            typeChooseValueEntry.inputWep:Select(id, v)
            itemObj.info.actionValue = id

            if (typeChooseEntry.input:GetSelectedID() == valuesIndex["weapon_skin"]) then
                skinChooseEntry.refreshSkins()
            end

            local wep = weapons.Get(id)
            if (wep) then
                local model = wep.WorldModel or wep.WM
                local printName = wep.PrintName

                local concat = (typeChooseEntry.input:GetSelectedID() == valuesIndex["weapon_skin"] and " (Skin)") or ""
                nameEntry.input.entry:SetValue(printName .. concat)

                if (model and iconChooseEntry.input:GetSelectedID() == 2) then
                    iconValueEntry.input.entry:SetValue(model)
                end
            end
        end)
    end


    function typeChooseValueEntry.input.entry:OnValueChange(val)
		itemObj.info.actionValue = val

        // Easy entity adding (darkrp)
        local foundEntity = false
        if (DarkRP) then
            if (typeChooseEntry.input:GetSelectedID() == valuesIndex["entity"]) then
                local ent = nil 
                for k, v in pairs(DarkRPEntities) do
                    if (v.ent == val) then
                        ent = v
                    end
                end

                if (ent) then
                    local printName = ent.name
                    local model = ent.model

                    if (printName and nameEntry.input.entry:GetValue() == "") then
                        nameEntry.input.entry:SetValue(printName)
                    end

                    if (model and iconChooseEntry.input:GetSelectedID() == 2 and iconValueEntry.input.entry:GetValue() == "") then
                        iconValueEntry.input.entry:SetValue(model)
                    end
                    foundEntity = true
                end
            end
        end

        // Alternative method from the spawn menu
        if (!foundEntity) then
            if (typeChooseEntry.input:GetSelectedID() == valuesIndex["entity"]) then
                local SpawnableEntities = list.Get( "SpawnableEntities" )
                if (SpawnableEntities) then
                    for k, v in pairs(SpawnableEntities) do
                        if (v.ClassName == val) then
                            // Get the print name atleast

                            local printName = v.PrintName

                            if (printName and nameEntry.input.entry:GetValue() == "") then
                                nameEntry.input.entry:SetValue(printName)
                            end
                        end
                    end
                end
            end
        end


	end

    entryPanel:AddCell(typeChooseValueEntry)


    // Icon type

    
    iconChooseEntry:SetWide(ScrW() * 0.124)
    iconChooseEntry:SetTall(sc(75))
    
    iconChooseEntry.Paint = function (self, w, h)
        draw.SimpleText(L"item_icon", "VoidUI.B24", 0, sc(15), VoidUI.Colors.GrayTransparent, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    iconChooseEntry.input = iconChooseEntry:Add("VoidUI.Dropdown")
    iconChooseEntry.input:Dock(TOP)
    iconChooseEntry.input:DockMargin(0, sc(30), 0, 0)
    iconChooseEntry.input:SetTall(sc(45))

    iconChooseEntry.input:AddChoice("Imgur Image")
    iconChooseEntry.input:AddChoice("Model")

    iconChooseEntry.input:ChooseOptionID(2)


    


    local zoomEntry = vgui.Create("Panel")

    function iconChooseEntry.input:OnSelect(index, val)
        if (index == 1) then
            // Icon
            iconValueEntry.input.Paint = function (self, w, h)
                draw.RoundedBox(8, 0, 0, w, h, VoidUI.Colors.Gray)
                local text = VoidCases.ImageProvider
                text = string.Replace(text, ".png", "")
                text = string.Replace(text, "%s", "")
                text = string.Replace(text, "https://", "")
                text = string.Replace(text, "http://", "")

                draw.SimpleText(text, "VoidUI.R26", sc(10), h/2, VoidUI.Colors.TextGray, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end

            iconValueEntry.input:Remove()

            iconValueEntry.input = iconValueEntry:Add("VoidCases.TextInputLogo")
            iconValueEntry.input:Dock(TOP)
            iconValueEntry.input:DockMargin(0, sc(30), 0, 0)
            iconValueEntry.input:SetTall(sc(45))

            function iconValueEntry.input.entry:OnValueChange(val)
		        itemObj.info.icon = val
                itemP:SetItem(itemObj, iconChooseEntry.input:GetSelectedID() == 2 and "model" or "icon")
	        end

            
        else
            // Model
            iconValueEntry.input.Paint = function (self, w, h)
                draw.RoundedBox(8, 0, 0, w, h, VoidUI.Colors.White)
            end

            

            iconValueEntry.input:Remove()

            iconValueEntry.input = iconValueEntry:Add("VoidUI.TextInput")
            iconValueEntry.input:Dock(TOP)
            iconValueEntry.input:DockMargin(0, sc(30), 0, 0)
            iconValueEntry.input:SetTall(sc(45))

            iconValueEntry.input.entry:SetFont("VoidUI.R18")

            function iconValueEntry.input.entry:OnValueChange(val)
		        itemObj.info.icon = val
                itemP:SetItem(itemObj, iconChooseEntry.input:GetSelectedID() == 2 and "model" or "icon")
                
	        end
            
        end

        if (index == 2) then
            zoomEntry:SetVisible(true)
        else
            zoomEntry:SetVisible(false)
        end
    end

    entryPanel:AddCell(iconChooseEntry)

    // Icon value entry

    
    iconValueEntry:SetWide(ScrW() * 0.124)
    iconValueEntry:SetTall(sc(75))
    
    iconValueEntry.Paint = function (self, w, h)
        if (iconChooseEntry.input:GetSelectedID() == 1) then
            draw.SimpleText(L"custom_image_id", "VoidUI.B24", 0, sc(15), VoidUI.Colors.GrayTransparent, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText(L"model_path", "VoidUI.B24", 0, sc(15), VoidUI.Colors.GrayTransparent, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end

    iconValueEntry.input = iconValueEntry:Add("VoidUI.TextInput")
    iconValueEntry.input:Dock(TOP)
    iconValueEntry.input:DockMargin(0, sc(30), 0, 0)
    iconValueEntry.input:SetTall(sc(45))
 

    function iconValueEntry.input.entry:OnValueChange(val)
		itemObj.info.icon = val
        itemP:SetItem(itemObj, iconChooseEntry.input:GetSelectedID() == 2 and "model" or "icon")

    end

    entryPanel:AddCell(iconValueEntry)

    // Zoom entry
    
    zoomEntry:SetWide(ScrW() * 0.124)
    zoomEntry:SetTall(sc(75))
    
    zoomEntry.Paint = function (self, w, h)
        draw.SimpleText(L"item_fov", "VoidUI.B24", 0, sc(15), VoidUI.Colors.GrayTransparent, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end


    zoomEntry.input = zoomEntry:Add("VoidUI.TextInput")
    zoomEntry.input:Dock(TOP)
    zoomEntry.input:DockMargin(0, sc(30), 0, 0)
    zoomEntry.input:SetTall(sc(45))
    zoomEntry.input.entry:SetNumeric(true)

    zoomEntry.input.entry:SetValue(55)

    function zoomEntry.input.entry:OnValueChange(val)
        if (val and isnumber(tonumber(val)) and VoidCases.IsModel(itemObj.info.icon)) then
            itemObj.info.zoom = tonumber(val)
            itemP.icon:SetFOV(tonumber(val)) 
        end
	end

    //zoomEntry:SetVisible(false)


    entryPanel:AddCell(zoomEntry)

    //skinChooseEntry
    skinChooseEntry:SetWide(ScrW() * 0.124)
    skinChooseEntry:SetTall(sc(75))
    
    skinChooseEntry.Paint = function (self, w, h)
        draw.SimpleText(string.upper(L"weapon_skin"), "VoidUI.B24", 0, sc(15), VoidUI.Colors.GrayTransparent, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    skinChooseEntry.input = skinChooseEntry:Add("VoidUI.Dropdown")
    skinChooseEntry.input:Dock(TOP)
    skinChooseEntry.input:DockMargin(0, sc(30), 0, 0)
    skinChooseEntry.input:SetTall(sc(45))

    local skinValues = {}

    skinChooseEntry.refreshSkins = function (editing)
        table.Empty(skinValues)
        skinChooseEntry.input:Clear()
        if (!SH_EASYSKINS) then return end

        if (itemObj.info.skinsForAll) then
            for k, v in pairs(SH_EASYSKINS.GetSkins()) do
                local index = skinChooseEntry.input:AddChoice(v.dispName)
                skinValues[index] = v.id

                if (v.id == tonumber(itemObj.info.weaponSkin)) then
                    skinChooseEntry.input:ChooseOptionID(index)
                end
            end
        else
            for k, v in pairs(SH_EASYSKINS.GetSkins()) do
                if (table.HasValue(v.weaponTbl, itemObj.info.actionValue)) then
                    local index = skinChooseEntry.input:AddChoice(v.dispName)
                    skinValues[index] = v.id

                    if (v.id == tonumber(itemObj.info.weaponSkin)) then
                        skinChooseEntry.input:ChooseOptionID(index)
                    end
                end
            end
        end
    end

    skinChooseEntry.refreshSkins()

    skinChooseEntry:SetVisible(false)

    function skinChooseEntry.input:OnSelect(index, val)

        local easySkin = SH_EASYSKINS.GetSkin(skinValues[index])
        if (!easySkin) then
            VoidLib.Notify(L"error_occured", "Skin doesn't exist!", VoidUI.Colors.Red, 3)
            return
        end
        
        SH_EASYSKINS.ApplySkinToModel(itemP.icon.Entity, easySkin.material.path)
        itemObj.info.weaponSkin = skinValues[index]
    end

    entryPanel:AddCell(skinChooseEntry)

    --skin_type

    skinTypeChooseEntry:SetWide(ScrW() * 0.124)
    skinTypeChooseEntry:SetTall(sc(75))
    
    skinTypeChooseEntry.Paint = function (self, w, h)
        draw.SimpleText(string.upper(L"skin_type"), "VoidUI.B24", 0, sc(15), VoidUI.Colors.GrayTransparent, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    skinTypeChooseEntry.input = skinTypeChooseEntry:Add("VoidUI.Dropdown")
    skinTypeChooseEntry.input:Dock(TOP)
    skinTypeChooseEntry.input:DockMargin(0, sc(30), 0, 0)
    skinTypeChooseEntry.input:SetTall(sc(45))

    skinTypeChooseEntry.input:AddChoice("Yes")
    skinTypeChooseEntry.input:AddChoice("No")

    skinTypeChooseEntry.input:ChooseOptionID(2)

    skinTypeChooseEntry:SetVisible(false)

    function skinTypeChooseEntry.input:OnSelect(index, val)
        if (index == 2) then
            typeChooseValueEntry:SetVisible(true)
            itemObj.info.skinsForAll = false
        else
            typeChooseValueEntry:SetVisible(false)
            itemObj.info.skinsForAll = true
        end
        skinChooseEntry.refreshSkins()
    end

    entryPanel:AddCell(skinTypeChooseEntry)

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

    local priceEntry = vgui.Create("Panel")
    function sellShopEntry.input:OnSelect(index, val)
        if (index == 1) then
            priceEntry:SetVisible(true)
            itemObj.info.sellInShop = true
        else
            priceEntry:SetVisible(false)
            itemObj.info.shopPrice = 0
            itemObj.info.sellInShop = false
        end
    end

    entryLimitsPanel:AddCell(sellShopEntry)

    // Price (if sellinshop true)

    priceEntry:SetWide(ScrW() * 0.124)
    priceEntry:SetTall(sc(75))
    
    priceEntry.Paint = function (self, w, h)
        draw.SimpleText(L"price", "VoidUI.B24", 0, sc(15), VoidUI.Colors.GrayTransparent, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end


    priceEntry.input = priceEntry:Add("VoidUI.TextInput")
    priceEntry.input:Dock(TOP)
    priceEntry.input:DockMargin(0, sc(30), 0, 0)
    priceEntry.input:SetTall(sc(45))
    priceEntry.input.entry:SetNumeric(true)

    function priceEntry.input.entry:OnValueChange(val)
		itemObj.info.shopPrice = val   
	end

    priceEntry:SetVisible(false)

    entryLimitsPanel:AddCell(priceEntry)
    

    // Permanent Item

    permaEntry:SetWide(ScrW() * 0.124)
    permaEntry:SetTall(sc(75))
    
    permaEntry.Paint = function (self, w, h)
        draw.SimpleText(L"is_permanent", "VoidUI.B24", 0, sc(15), VoidUI.Colors.GrayTransparent, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    permaEntry.input = permaEntry:Add("VoidUI.Switch")
    permaEntry.input:Dock(TOP)
    permaEntry.input:DockMargin(0, sc(30), 0, 0)
    permaEntry.input:SetTall(sc(45))
    permaEntry.input:DropdownCompat()

    function permaEntry.input:OnSelect(index, val)
        if (index == 1) then
            itemObj.info.isPermanent = true
        else
            itemObj.info.isPermanent = false
        end
    end

    entryLimitsPanel:AddCell(permaEntry)

    // Auto equip item

    local autoEquip = vgui.Create("Panel")
    autoEquip:SetWide(ScrW() * 0.124)
    autoEquip:SetTall(sc(75))
    
    autoEquip.Paint = function (self, w, h)
        draw.SimpleText(L"auto_equip", "VoidUI.B24", 0, sc(15), VoidUI.Colors.GrayTransparent, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    autoEquip.input = autoEquip:Add("VoidUI.Switch")
    autoEquip.input:Dock(TOP)
    autoEquip.input:DockMargin(0, sc(30), 0, 0)
    autoEquip.input:SetTall(sc(45))
    autoEquip.input:DropdownCompat()


    function autoEquip.input:OnSelect(index, val)
        if (index == 1) then
            itemObj.info.autoEquip = true
        else
            itemObj.info.autoEquip = false
        end
    end

    entryLimitsPanel:AddCell(autoEquip)

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
    

    self.tabs:AddTab(L"item_details", self.itemDetails)
    self.tabs:AddTab(L"item_limitations", self.itemLimits)

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

        local actionValue = itemObj.info.actionValue

        

        nameEntry.input.entry:SetValue(item.name)
        rarityEntry.input:ChooseOptionID(item.info.rarity)
        typeChooseEntry.input:ChooseOptionID(valuesIndex[itemObj.info.actionType])

        iconChooseEntry.input:ChooseOptionID(VoidCases.IsModel(itemObj.info.icon) and 2 or 1)
        iconValueEntry.input.entry:SetValue(itemObj.info.icon)
        zoomEntry.input.entry:SetValue(itemObj.info.zoom or 55)
        sellShopEntry.input:ChooseOptionID(itemObj.info.sellInShop and 1 or 2)
        if (itemObj.info.sellInShop) then
            priceEntry.input.entry:SetValue(tonumber(itemObj.info.shopPrice))
        end

        if (itemObj.info.weaponSkin) then
            skinChooseEntry.refreshSkins(true)
        end

        skinTypeChooseEntry.input:ChooseOptionID(itemObj.info.skinsForAll and 1 or 2)

        typeChooseValueEntry.input.entry:SetValue(actionValue)
        permaEntry.input:ChooseOptionID(itemObj.info.isPermanent and 1 or 2)

        groupEntry.input.selectedItems = itemObj.info.requiredUsergroups or {}
        displayGroupEntry.input:ChooseOptionID(item.info.showIfCannotPurchase and 1 or 2)

        if (itemObj.info.actionType == "weapon") then
            switchWepSelector(true)

            local wep = weapons.Get(actionValue)
            if (wep) then
                typeChooseValueEntry.inputWep:Select(actionValue, wep.PrintName)
            end
        end

        local i = 0
        for k, v in pairs(VoidCases.Config.Currencies) do
            i = i + 1
            if (k == itemObj.info.currency) then
                currencyEntry.input:ChooseOptionID(i)
            end
        end
        

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

        autoEquip.input:ChooseOptionID(item.info.autoEquip and 1 or 2)
    end

end


function PANEL:Paint(w, h)
    
end

vgui.Register("VoidCases.ItemCreate", PANEL, "EditablePanel")
