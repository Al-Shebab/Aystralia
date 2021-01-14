//////////////////////
///    WARNING    ////
//////////////////////

-- This file is not supposed to be edited.
-- Use the in-game configuration instead.
-- No support will be provided if you modify this file.

VoidCases.Debug = false -- Enable this only if you know what are you doing.

VoidCases.IGConfig = {}
VoidCases.IGConfigCategories = {}
VoidCases.IGConfigPanels = {}


VoidCases.ItemTypes = {
    ["Unboxable"] = 1,
    ["Case"] = 2,
    ["Key"] = 3
}

VoidCases.Rarities = VoidCases.Rarities or {
    ["Common"] = 1,
    ["Uncommon"] = 2,
    ["Rare"] = 3,
    ["Epic"] = 4,
    ["Legendary"] = 5
}


VoidCases.RarityColors = VoidCases.RarityColors or {
    [5] = Color(201, 145, 48),
    [4] = Color(177, 71, 197),
    [3] = Color(68, 172, 199),
    [2] = Color(74, 198, 82),
    [1] = Color(126, 126, 126)
}

VoidCases.UnlockSounds = {
    ["models/voidcases/wooden_crate.mdl"] = "voidcases/wooden_open.wav",
    ["models/voidcases/plastic_crate.mdl"] = "voidcases/plastic_open.wav",
    ["models/voidcases/scifi_crate.mdl"] = "voidcases/scifi1_open.wav",
}

VoidCases.RaritySounds = {
    [1] = "voidcases/item_drop1_common.wav",
    [2] = "voidcases/item_drop2_uncommon.wav",
    [3] = "voidcases/item_drop3_rare.wav",
    [4] = "voidcases/item_drop4_mythical.wav",
    [5] = "voidcases/item_drop5_legendary.wav",
}


VoidCases.Config.CustomRarities = VoidCases.Config.CustomRarities or {}
VoidCases.Config.Items = VoidCases.Config.Items or {}
VoidCases.Config.Categories = VoidCases.Config.Categories or {}
VoidCases.Config.FeaturedItems = VoidCases.Config.FeaturedItems or {} -- these are actually best sellers
VoidCases.Config.HomeFeaturedItems = VoidCases.Config.HomeFeaturedItems or {
    [1] = {
        name = "First",
        items = {}
    },
    [2] = {
        name = "Second",
        items = {}
    }
} 
-- structure of HomeFeaturedItems:
/*
    [key (1 or 2)]
    {
        name = "the name of the category",
        items = {
            [1] = nil,
            [2] = 5
        }, "array of item ids in that category", key is slot id
    }
*/

VoidCases.Config.Currencies = VoidCases.Config.Currencies or {}

VoidCases.Config.Actions = VoidCases.Config.Actions or {}

local L = VoidCases.Lang.GetPhrase

function VoidCases.SetFeaturedItem(key, slot, item)
    VoidCases.Config.HomeFeaturedItems[key].items[slot] = item
    VoidCases.SaveConfig()
end

function VoidCases.SetFeaturedItemName(key, name)
    VoidCases.Config.HomeFeaturedItems[key].name = name
    VoidCases.SaveConfig()
end

local sortOrder = 0
function VoidCases.CreateConfigEntry(id, tbl)
    if (!tbl.category) then
        tbl.category = "Other"
    end
    VoidCases.IGConfig[id] = {name = tbl.name, description = tbl.description, type = tbl.type, default = tbl.default, category = tbl.category, inputWidth = tbl.inputWidth, ddOptions = tbl.ddOptions, percentage = tbl.percentage, sortOrder = sortOrder}
    sortOrder = sortOrder + 1
end

function VoidCases.CreateConfigCategory(id, sortOrder, panel)
    VoidCases.IGConfigCategories[id] = sortOrder
    if (panel) then
		VoidCases.IGConfigPanels[id] = panel
	end
end

function VoidCases.IsItemValid(item)
    if (!item or !item.name or !item.info or !item.type or !item.info.rarity or !table.HasValue(VoidCases.Rarities, tonumber(item.info.rarity)) or !item.info.icon or !item.info.shopPrice) then return false end
    return true
end

function VoidCases.CreateAction(name, func)
    VoidCases.Config.Actions[name] = {
        action = func
    }
end

function VoidCases.AddCurrency(name, getFunc, addFunc)
    VoidCases.Config.Currencies[name] = {
        getFunc = getFunc,
        addFunc = addFunc,
    }
end



-- Item table structure
/*
    [itemID (number)] = {
        name = "Print name",
        type = VoidCases.ItemTypes.Unboxable, // (item type from VoidCases.ItemTypes table)
        info = { // this will be different with all different types
            // Shared (for all types)
            sellInShop = true,
            shopPrice = 110488718263627204,
            shopCategory = 5, // the id of the category 

            isMarketable = false, // can be sold on the community market?

            rarity = VoidCases.Rarities.Common, // a rarity from VoidCases.Rarities

            icon = "models/props_borealis/bluebarrel001.mdl", // can be a model or Imgur ID

            requiredUsergroups = {"vip"}, // a table of required usergroups
            showIfCannotPurchase = true, // should the case be shown if the usergroup/money requirement isnt met?

            currency = "DarkRP", // string of the currency (if no currency, defaults to first available)

            // Item
            isPermanent = false, // is permanent

            // Unboxable
            actionType = "weapon",
            actionValue = "cw_ak74",

            // Case
            caseIcon = "", // URL to the image source, if nil then no icon
            requiresKey = true, // bool if requires key (keys are created as a seperate item)

            worldOpening = true, // open in world or in UI?

            caseColor = Color(255,255,255), // Case Color
            
            unboxableItems = { // table with the item id as the key and the percentage as the value
                [4] = 20,
                [8] = 80
            },

            mysteryItems = {4}, // table of mystery items

            // Key
            unlocks = { // table of case ids the key opens
                [4] = true,
                [5] = true
            }, 
            
        },
    }
*/

function VoidCases.EditRarity(name, color, oldRarity) -- create and edit is the same
    if (CLIENT) then return end

    local id = oldRarity and VoidCases.Rarities[oldRarity] or (table.Count(VoidCases.Config.CustomRarities) + 1)

    if (oldRarity) then
        VoidCases.Rarities[oldRarity] = nil
        VoidCases.Config.CustomRarities[oldRarity] = nil
    end
    
    VoidCases.Config.CustomRarities[name] = {color, id}
    VoidCases.Rarities[name] = id
    VoidCases.RarityColors[id] = color

    VoidCases.RefreshWinRarityConfig()

    VoidCases.SaveConfig()
end

function VoidCases.DeleteRarity(name)
    if (CLIENT) then return end

    VoidCases.Config.CustomRarities[name] = nil

    local id = VoidCases.Rarities[name]
    VoidCases.Rarities[name] = nil
    VoidCases.RarityColors[id] = nil

    VoidCases.RefreshWinRarityConfig()

    VoidCases.SaveConfig()
end


function VoidCases.CreateItem(name, type, tbl)
    if (CLIENT) then return end
    local id = table.Count(VoidCases.Config.Items)
    id = id + 1

    local idFound = false
    while (!idFound) do
        if (!VoidCases.Config.Items[id]) then
            idFound = true
            break
        else
            id = id + 1
        end
    end

    local itemTable = {
        name = name,
        type = type,
        id = id,
        info = tbl
    }

    VoidCases.Config.Items[id] = itemTable

    VoidCases.SaveConfig()

    return itemTable
end

function VoidCases.ModifyItem(id, tbl)
    if (CLIENT) then return end
    if (!VoidCases.Config.Items[id]) then return end

    VoidCases.Config.Items[id] = tbl
    VoidCases.SaveConfig()
    return tbl
end

function VoidCases.DeleteItem(id)
    if (CLIENT) then return end
    if (!VoidCases.Config.Items[id]) then return end

    VoidCases.Config.Items[id] = nil
    VoidCases.SaveConfig()

    // Take item from player inventories
    local query = VoidLib.SQL:Delete("voidcases_inventory")
        query:Where("item", id)
    query:Execute()

    return tbl
end

function VoidCases.CreateCategory(name)
    if (CLIENT) then return end
    local id = table.Count(VoidCases.Config.Categories)
    id = id + 1

    local idFound = false
    while (!idFound) do
        if (!VoidCases.Config.Categories[id]) then
            idFound = true
            break
        else
            id = id + 1
        end
    end

    VoidCases.Config.Categories[id] = name
    VoidCases.SaveConfig()

    return id
end

function VoidCases.ModifyCategory(id, name)
    if (CLIENT) then return end

    if (!VoidCases.Config.Categories[id]) then return false end
    VoidCases.Config.Categories[id] = name
    VoidCases.SaveConfig()

    return true
end

function VoidCases.DeleteCategory(id)
    if (CLIENT) then return end

    if (!VoidCases.Config.Categories[id]) then return false end
    VoidCases.Config.Categories[id] = nil
    VoidCases.SaveConfig()

    return true
end



////////////
//  CAMI  //
////////////

CAMI.RegisterPrivilege({
    Name = "VoidCases_CreateItems",
    MinAccess = "superadmin",
    Description = "Can the player create VoidCases items?",
})

CAMI.RegisterPrivilege({
    Name = "VoidCases_EditSettings",
    MinAccess = "superadmin",
    Description = "Can the player modify VoidCases settings?",
})

CAMI.RegisterPrivilege({
    Name = "VoidCases_EditInventories",
    MinAccess = "superadmin",
    Description = "Can the player edit VoidCases inventories?",
})

///////////////////////
// Server networking //
///////////////////////



if (SERVER) then
    util.AddNetworkString("VoidCases_SendConfigData")
    util.AddNetworkString("VoidCases_RequestConfigData")
    util.AddNetworkString("VoidCases_ModifyConfig")
    util.AddNetworkString("VoidCases_UpdateFeaturedItems")

    function VoidCases.UpdateConfig(len, ply)
        // Has access to modify config?
        if (!CAMI.PlayerHasAccess(ply, "VoidCases_EditSettings")) then return end

        local len = net.ReadUInt(32)
	    local data = net.ReadData(len)

        data = util.Decompress(data)
	    data = util.JSONToTable(data)

        if (VoidCases.IGConfig[data.key]) then
            VoidCases.Config[data.key] = data.value
        end

        VoidCases.SaveConfig()
    end
    net.Receive("VoidCases_ModifyConfig", VoidCases.UpdateConfig)

    net.Receive("VoidCases_UpdateFeaturedItems", function (len, ply)
        if (!CAMI.PlayerHasAccess(ply, "VoidCases_CreateItems")) then return end
        
        local updateNames = net.ReadBool()
        local id = net.ReadUInt(2)

        if (updateNames) then
            local name = net.ReadString()

            VoidCases.SetFeaturedItemName(id, name)
        else
            local slot = net.ReadUInt(2)
            local item = net.ReadUInt(20)

            VoidCases.SetFeaturedItem(id, slot, item)
        end
    end)

    function VoidCases.SendConfigData(len, ply)


        local config = VoidCases.Config

        config = util.TableToJSON(config)
        config = util.Compress(config)

        net.Start("VoidCases_SendConfigData")
            net.WriteUInt(#config, 32)
            net.WriteData(config, #config)
        net.Send(ply)

    end 

    local function netHandleRequestConfig(len, ply)
        if (ply.vc_requestedConfig) then return end // Prevent flooding net messages
        ply.vc_requestedConfig = true

        VoidCases.SendConfigData(len, ply)
    end

    net.Receive("VoidCases_RequestConfigData", netHandleRequestConfig)

    function VoidCases.BroadcastConfigData(config)

        config = util.TableToJSON(config)
        config = util.Compress(config)

        net.Start("VoidCases_SendConfigData")
            net.WriteUInt(#config, 32)
            net.WriteData(config, #config)
        net.Broadcast()

    end
    

    function VoidCases.LoadConfig()
        local text = file.Read("voidcases_config.txt")
        if (!text or #text < 1) then
            VoidCases.Print("In-game config initialization..")

            VoidCases.SaveConfig(true) // Initialize config
            
            return
        end


        local config = util.JSONToTable(text)

        for key, v in pairs(VoidCases.IGConfig) do
            if (config[key] == nil) then
                config[key] = v.default
            end
        end


        VoidCases.Config = config

        VoidCases.Config.HomeFeaturedItems = VoidCases.Config.HomeFeaturedItems or {
            [1] = {
                name = "First",
                items = {}
            },
            [2] = {
                name = "Second",
                items = {}
            }
        } 

        VoidCases.Config.Currencies = {}
        VoidCases.Config.Actions = {}

        VoidCases.LoadActions()
        VoidCases.LoadCurrencies()

        if (table.Count(VoidCases.Config.CustomRarities or {}) < 1) then
            VoidCases.Config.CustomRarities = {}
            for k, v in pairs(VoidCases.Rarities) do
                local color = VoidCases.RarityColors[v]
                color = Color(color.r, color.g, color.b, color.a)

                VoidCases.Config.CustomRarities[k] = {color, v}
            end
        else
            VoidCases.Rarities = {}
            VoidCases.RarityColors = {}

            for k, v in pairs(VoidCases.Config.CustomRarities or {}) do
                local id = v[2]
                local color = Color(v[1].r, v[1].g, v[1].b, v[1].a)

                VoidCases.Rarities[k] = id
                VoidCases.RarityColors[id] = color
            end
        end

        VoidCases.PrintDebug("Loaded config!")

        hook.Run("VoidCases_ConfigLoaded")
    end


    function VoidCases.WriteSave(config)

        config = table.Copy(config)

        -- Dont save actions and currencies
        config.Actions = nil
        config.Currencies = nil

        local json = util.TableToJSON(config)
        file.Write("voidcases_config.txt", json)
    end

    function VoidCases.SaveConfig(init)
        local config = VoidCases.Config or {}
        for k, v in pairs(VoidCases.IGConfig) do
            if (!config[k]) then
                config[k] = v.default
            end
        end

        if (init) then

            VoidCases.LoadActions()
            VoidCases.LoadCurrencies()

            VoidCases.Config = config
        end

        VoidCases.BroadcastConfigData(config)
        VoidCases.WriteSave(config)
    end

end

if (CLIENT) then

    function VoidCases.UpdateConfig(key, value)
        if (VoidCases.Config[key] == value) then return end

        local data = {key = key, value = value}

        data = util.TableToJSON(data)
        data = util.Compress(data)

        net.Start("VoidCases_ModifyConfig")
            net.WriteUInt(#data, 32)
            net.WriteData(data, #data)
        net.SendToServer()
    end

    function VoidCases.RequestConfigData()
        VoidCases.PrintDebug("Requesting config data")

        net.Start("VoidCases_RequestConfigData")
        net.SendToServer()
    end

    function VoidCases.ReceiveConfigData()
        local len = net.ReadUInt(32)
	    local config = net.ReadData(len)

        config = util.Decompress(config)
	    config = util.JSONToTable(config)

        VoidCases.Config = config
        VoidCases.PrintDebug("Received config data")

        VoidCases.LoadCurrencies()

        if (table.Count(VoidCases.Config.CustomRarities) > 0) then
            VoidCases.Rarities = {}
            VoidCases.RarityColors = {}
            for k, v in pairs(VoidCases.Config.CustomRarities or {}) do
                local id = v[2]
                local color = Color(v[1].r, v[1].g, v[1].b, v[1].a)

                VoidCases.Rarities[k] = id
                VoidCases.RarityColors[id] = color
            end
        end

        hook.Run("VoidCases_ConfigDataReceived")
    end

    net.Receive("VoidCases_SendConfigData", VoidCases.ReceiveConfigData)

end

////////////////////////
///  In-Game Config  ///
////////////////////////



function VoidCases.LoadCurrencies()

-- Currencies

-- DarkRP
if (DarkRP) then
    VoidCases.AddCurrency("DarkRP", function (ply)
        return ply:getDarkRPVar("money")
    end, function (ply, money)
        ply:addMoney(money)
    end)
end

-- BaseWars
if (BaseWars or Basewars or basewars) then
    VoidCases.AddCurrency("Basewars", function (ply)
        return ply:GetMoney()
    end, function (ply, money)
        ply:GiveMoney(money)
    end)
end

-- Nutscript currency
if (nut and nut.currency) then
    VoidCases.AddCurrency("NutScript", function (ply)
        return ply:getChar():getMoney()
    end, function (ply, money)
        ply:getChar():giveMoney(money)
    end)
end

-- Helix currency
if (ix and ix.currency) then
    VoidCases.AddCurrency("Helix", function (ply)
        return ply:GetCharacter():GetMoney()
    end, function (ply, money)
        ply:GetCharacter():GiveMoney(money)
    end)
end

-- xStore
if (xStore) then
    VoidCases.AddCurrency("xStore", function (ply)
        return (xStore.Users[tostring(ply:SteamID64())] and xStore.Users[tostring(ply:SteamID64())].Points) or 0
    end, function (ply, money)
        xStore.AddPoints(ply, money)
    end)
end

-- Pointshop 1
if (PS) then
    VoidCases.AddCurrency("Pointshop 1", function (ply)
        return ply:PS_GetPoints()
    end, function (ply, money)
        ply:PS_GivePoints(money)
    end)
end

-- Pointshop 2
if (Pointshop2) then
    VoidCases.AddCurrency("Pointshop 2 (Standard)", function (ply)
        return (ply:PS2_GetWallet() and ply:PS2_GetWallet().points ) or 0
    end, function (ply, money)
        ply:PS2_AddStandardPoints( money )
    end)

    VoidCases.AddCurrency("Pointshop 2 (Premium)", function (ply)
        return (ply:PS2_GetWallet() and ply:PS2_GetWallet().premiumPoints ) or 0
    end, function (ply, money)
        ply:PS2_AddPremiumPoints( money )
    end)
end

-- mTokens
if (mTokens) then
    VoidCases.AddCurrency("mTokens", function (ply)
        return mTokens.GetPlayerTokens(ply)
    end, function (ply, money)
        mTokens.AddPlayerTokens(ply, money)
    end)
end

					
-- Bricks Credit Store
if (BRICKSCREDITSTORE) then
    VoidCases.AddCurrency("Bricks Credits", function (ply)
        return ply:GetBRCS_Credits()
    end, function(ply, money)
        ply:AddBRCS_Credits(money)
    end)
end					
						


end


-- Actions


function VoidCases.LoadActions()



    VoidCases.CreateAction("weapon", function (ply, value)
        ply:Give(value)
    end)

    VoidCases.CreateAction("entity", function (ply, value)
        local ent = ents.Create(value)
        ent:SetPos(ply:GetPos() + ply:GetForward() * 35)
        ent:Spawn()
    end)

    if (DarkRP) then
        VoidCases.CreateAction("money", function (ply, value)
            ply:addMoney(value)
        end)
    end

    if (Pointshop2) then
        VoidCases.CreateAction(L("pointshop_money", "2 (Standard)"), function (ply, value)
            ply:PS2_AddStandardPoints(value)
        end)

        VoidCases.CreateAction(L("pointshop_money", "2 (Premium)"), function (ply, value)
            ply:PS2_AddPremiumPoints(value)
        end)
    end

    if (PS) then
        VoidCases.CreateAction(L("pointshop_money", "1"), function (ply, value)
            ply:PS_GivePoints(value)
        end)
    end

    if (PS) then
        VoidCases.CreateAction("pointshop_item", function (ply, value)
            ply:PS_GiveItem(value)
        end)
    end

    if (Pointshop2) then
        //pointshop_name
        VoidCases.CreateAction("pointshop2_item", function (ply, value)
            local itemClass = Pointshop2.GetItemClassByPrintName(value)
            if (!itemClass) then
                VoidLib.Notify(ply, L"error_occured", L"does_not_exist", Color(206, 83, 83), 4)
                return
            end
            return ply:PS2_EasyAddItem(itemClass.className)
        end)
    end

    if (SH_POINTSHOP) then
        VoidCases.CreateAction("pointshopsh_item", function (ply, value)
            ply:SH_AddItem(value)
        end)
    end

    VoidCases.CreateAction("concommand", function (ply, value)
        value = string.Replace(value, "%sid64", ply:SteamID64())
        value = string.Replace(value, "%sid", ply:SteamID())
        value = string.Replace(value, "%nick", ply:Nick())

        game.ConsoleCommand(value .. "\n")
    end)

    if (SH_EASYSKINS) then
        VoidCases.CreateAction("weapon_skin", function (ply, value, item)
            if (item.info.skinsForAll) then
                local skinInfo = SH_EASYSKINS.GetSkin(item.info.weaponSkin)
                value = skinInfo.weaponTbl
            else
                value = {value}
            end
            SV_EASYSKINS.GiveSkinToPlayer( ply:SteamID64(), item.info.weaponSkin, value )
        end)
    end

end

-- Categories

VoidCases.CreateConfigCategory("general", 5)
VoidCases.CreateConfigCategory("unboxing", 15)
VoidCases.CreateConfigCategory("annouce", 20)
VoidCases.CreateConfigCategory("trading", 21)
VoidCases.CreateConfigCategory("items", 22)
VoidCases.CreateConfigCategory("marketplace", 25)
VoidCases.CreateConfigCategory("rarities", 30, "VoidCases.Rarities")


-- Settings

VoidCases.CreateConfigEntry("MenuCommand", {
    name = "settings_command",
    description = "settings_command_desc",
    type = "string",
    default = "!unbox",
    category = "general"
})

--settings_menubind
VoidCases.CreateConfigEntry("MenuBind", {
    name = "settings_menubind",
    description = "settings_menubind_desc",
    type = "keybind",
    default = false,
    category = "general"
})

VoidCases.CreateConfigEntry("UnboxDespawn", {
    name = "settings_despawn",
    description = "settings_despawn_desc",
    type = "number",
    category = "unboxing",
    default = 15,
})

VoidCases.CreateConfigEntry("MaxCasesAtOnce", {
    name = "settings_casesatonce",
    description = "settings_casesatonce_desc",
    type = "number",
    category = "unboxing",
    default = 3,
})

VoidCases.CreateConfigEntry("AnnouceWin", {
    name = "settings_annoucewin",
    description = "settings_annoucewin_desc",
    type = "bool",
    category = "annouce",
    default = true,
})

function VoidCases.RefreshWinRarityConfig()
    VoidCases.CreateConfigEntry("AnnouceWinRarity", {
        name = "settings_annoucewinr",
        description = "settings_annoucewinr_desc",
        type = "dropdown",
        category = "annouce",
        default = "Legendary",
        ddOptions = table.GetKeys(VoidCases.Rarities)
    })
end

VoidCases.RefreshWinRarityConfig()

VoidCases.CreateConfigEntry("DisableUnboxCollision", {
    name = "settings_boxcollision",
    description = "settings_boxcollision_desc",
    type = "bool",
    category = "unboxing",
    default = false,
})

VoidCases.CreateConfigEntry("DisableInfobox3D2D", {
    name = "settings_3d2dinfo",
    description = "settings_3d2dinfo_desc",
    type = "bool",
    category = "unboxing",
    default = false,
})

VoidCases.CreateConfigEntry("MaxMarketplaceListings", {
    name = "settings_maxmarketplacelistings",
    description = "settings_maxmarketplacelistings_desc",
    type = "number",
    category = "marketplace",
    default = 10
})

-- VoidCases.CreateConfigEntry("InWorldCSGOUnbox", {
--     name = "settings_3dspinunbox",
--     description = "settings_3dspinunbox_desc",
--     type = "bool",
--     category = "unboxing",
--     default = true,
-- })

VoidCases.CreateConfigEntry("UseInheritance", {
    name = "settings_useinheritance",
    description = "settings_useinheritance_desc",
    type = "bool",
    category = "items",
    default = true,
})

VoidCases.CreateConfigEntry("MaxEquipped", {
    name = "settings_maxequipped",
    description = "settings_maxequipped_desc",
    type = "number",
    category = "items",
    default = 0,
})

hook.Add("VoidCases.Lang.LanguagesLoaded", "VoidCases.Settings.CreateLangEntry", function ()

	-- Make all the first letters uppercase
	local langTbl = table.GetKeys(VoidCases.Lang.Langs)
	for k, v in ipairs(langTbl) do
		langTbl[k] = (v:gsub("^%l", string.upper))
	end

	VoidCases.CreateConfigEntry("Language", {
		name = "settings_language",
		description = "settings_language_desc",
		type = "dropdown",
		category = "general",
		ddOptions = langTbl,
		default = "English",
	})
end)

VoidCases.CreateConfigEntry("ListingTime", {
    name = "settings_marketplace_lifetime",
    description = "settings_marketplace_lifetime_desc",
    type = "number",
    category = "marketplace",
    default = 240, // 10 days
})

VoidCases.CreateConfigEntry("DisableMarketplace", {
    name = "settings_disablemarketplace",
    description = "settings_disablemarketplace_desc",
    type = "bool",
    category = "marketplace",
    default = false,
})

VoidCases.CreateConfigEntry("TradeRequestExpiration", {
    name = "settings_tradetime",
    description = "settings_tradetime_desc",
    type = "number",
    category = "trading",
    default = 60,
})

VoidCases.CreateConfigEntry("DisableTrading", {
    name = "settings_disabletrading",
    description = "settings_disabletrading_desc",
    type = "bool",
    category = "trading",
    default = false,
})


-- Load the config!
if (SERVER) then
    timer.Simple(10, function ()
        VoidCases.LoadConfig()
    end)
end
