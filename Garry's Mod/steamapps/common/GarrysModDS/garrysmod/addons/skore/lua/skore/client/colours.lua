
function sKore.isColour(object)
	return istable(object) and object.r != nil and object.g != nil
		   and object.b != nil and object.a != nil
end

local validHexadecimalSizes = {[4] = true, [5] = true, [7] = true, [9] = true}

function sKore.isHex(object)
	return isstring(object)
		   and validHexadecimalSizes[#object]
		   and string.StartWith(object, "#")
		   and string.gsub(object, "[%dabcdefABCDEF]", "") == "#"
end

function sKore.hexToColour(hexadecimal)
	if sKore.isHex(hexadecimal) then
		if #hexadecimal == 4 or #hexadecimal == 5 then
			return Color(
				tonumber("0x" .. string.sub(hexadecimal, 2, 2)) * 17,
				tonumber("0x" .. string.sub(hexadecimal, 3, 3)) * 17,
				tonumber("0x" .. string.sub(hexadecimal, 4, 4)) * 17,
				#hexadecimal == 5 and tonumber("0x" .. string.sub(hexadecimal, 5, 5)) * 17 or 255
			)
		else
			return Color(
				tonumber("0x" .. string.sub(hexadecimal, 2, 3)),
				tonumber("0x" .. string.sub(hexadecimal, 4, 5)),
				tonumber("0x" .. string.sub(hexadecimal, 6, 7)),
				#hexadecimal == 9 and tonumber("0x" .. string.sub(hexadecimal, 8, 9)) or 255
			)
		end
	end
	return nil
end

function sKore.colourToHex(colour)
	if sKore.isColour(colour) then
		local hexadecimal = "#"

		for key, value in ipairs({colour.r, colour.g, colour.b, colour.a != 255 and colour.a or nil}) do
			local hex = "00"
			while value > 0 do
				local index = math.fmod(value, 16) + 1
				value = math.floor(value / 16)
				hex = string.sub("0123456789ABCDEF", index, index) .. hex
			end
			hexadecimal = hexadecimal .. string.sub(hex, 1, 2)
		end

		return hexadecimal
	end
	return nil
end

function sKore.hexToColourTable(tab)
	if !istable(tab) then error("'tab' argument is not a table!", 2) end
	for key, value in pairs(tab) do
		tab[key] = istable(value) and sKore.hexToColourTable(value)
				   or sKore.hexToColour(value) or value
	end
	return tab
end

function sKore.colourToHexTable(tab)
	if !istable(tab) then error("'tab' argument is not a table!", 2) end
	for key, value in pairs(tab) do
		tab[key] = istable(value) and sKore.colourToHexTable(value)
				   or sKore.colourToHex(value) or value
	end
	return tab
end

sKore.LIGHT = false
sKore.DARK = true
sKore.HIGH_EMPHASIS = 1
sKore.MEDIUM_EMPHASIS = 2
sKore.DISABLED_EMPHASIS = 3
sKore.PRIMARY_DARK = 1
sKore.PRIMARY = 2
sKore.PRIMARY_LIGHT = 3
sKore.BACKGROUND_DARK = 1
sKore.BACKGROUND = 2
sKore.BACKGROUND_LIGHT = 3

sKore.backgroundColours = sKore.hexToColourTable({
	[sKore.LIGHT] = {
		["colours"] = {
			[sKore.BACKGROUND_DARK] = "#c7c7c7",
			[sKore.BACKGROUND] = "#e0e0e0",
			[sKore.BACKGROUND_LIGHT] = "#fafafa"
		},
		["shadow"] = "#00000064"
	},
	[sKore.DARK] = {
		["colours"] = {
			[sKore.BACKGROUND_DARK] = "#212121",
			[sKore.BACKGROUND] = "#303030",
			[sKore.BACKGROUND_LIGHT] = "#424242"
		},
		["shadow"] = "#00000064"
	}
})

sKore.textColours = sKore.hexToColourTable({
	[sKore.LIGHT] = {
		[sKore.HIGH_EMPHASIS] = Color(255, 255, 255, 222),
		[sKore.MEDIUM_EMPHASIS] = Color(255, 255, 255, 153),
		[sKore.DISABLED_EMPHASIS] = Color(255, 255, 255, 96)
	},
	[sKore.DARK] = {
		[sKore.HIGH_EMPHASIS] = Color(0, 0, 0, 222),
		[sKore.MEDIUM_EMPHASIS] = Color(0, 0, 0, 153),
		[sKore.DISABLED_EMPHASIS] = Color(0, 0, 0, 96)
	}
})

sKore.materials = {
	[sKore.LIGHT] = {},
	[sKore.DARK] = {}
}

local lightIcons = file.Find("materials/skore/light/*", "GAME")
for _, fileName in pairs(lightIcons) do
	local name = string.Explode(".", fileName)
	table.remove(name)
	name = table.concat(name, "."):lower()
	sKore.materials[sKore.LIGHT][name] = Material("materials/skore/light/" .. fileName, "smooth")
end

local darkIcons = file.Find("materials/skore/dark/*", "GAME")
for _, fileName in pairs(darkIcons) do
	local name = string.Explode(".", fileName)
	table.remove(name)
	name = table.concat(name, "."):lower()
	sKore.materials[sKore.DARK][name] = Material("materials/skore/dark/" .. fileName, "smooth")
end

local function levelCheck(level)
	return level == sKore.PRIMARY_DARK
		   or level == sKore.PRIMARY
		   or level == sKore.PRIMARY_LIGHT
end

local function emphasisCheck(object)
	return object == sKore.HIGH_EMPHASIS
		   or object == sKore.MEDIUM_EMPHASIS
		   or object == sKore.DISABLED_EMPHASIS
end

local themeMetaTable = {}
themeMetaTable.__index = themeMetaTable

function sKore.Theme(themeName)
	if !isstring(themeName) then error("'themeName' argument is not a string!", 2) end
	if string.Trim(themeName) == "" then error("'themeName' argument is either an empty string or just whitespace!", 2) end

	local newTheme = {
		["colours"] = {},
		["textColours"] = {}
	}
	newTheme.name = themeName
	newTheme.id = string.Replace(themeName:lower(), " ", "_")
	--if sKore.themes[newTheme.name] != nil then error("'themeName' argument is a name of an already existant theme!", 2) end -- 76561198166995690
	--if sKore.themesID[newTheme.id] != nil then error("'themeName' argument has an id of an already existant theme! Use other name.", 2) end
	setmetatable(newTheme, themeMetaTable)
	sKore.themes[newTheme.name] = newTheme
	sKore.themesID[newTheme.id] = newTheme
	return newTheme
end

function themeMetaTable:GetName()
	local placeholder = Format("theme_%s", self.id)
	local translated = sKore.getPhrase(placeholder)
	return translated != placeholder and translated or self.name
end

function themeMetaTable:GetID()
	return self.id
end

function themeMetaTable:SetBackgroundColour(dark)
	--##if !isbool(dark) then error("'dark' argument is not a boolean!", 2) end
	self.darkBackground = dark
end

function themeMetaTable:IsDarkBackground()
	return self.darkBackground == sKore.DARK
end

function themeMetaTable:IsLightBackground()
	return self.darkBackground != sKore.DARK
end

function themeMetaTable:GetBackgroundColour(level)
	--##if !levelCheck(level) then error("'level' argument is not a valid level enum!", 2) end
	return self:IsDarkBackground()
		   and sKore.backgroundColours[sKore.DARK]["colours"][level]
		   or sKore.backgroundColours[sKore.LIGHT]["colours"][level]
end

function themeMetaTable:GetBackgroundColourInverted(level)
	--##if !levelCheck(level) then error("'level' argument is not a valid level enum!", 2) end
	return self:IsDarkBackground()
		   and sKore.backgroundColours[sKore.LIGHT]["colours"][level]
		   or sKore.backgroundColours[sKore.DARK]["colours"][level]
end

function themeMetaTable:IsBackgroundTextBlack()
	return self:IsLightBackground()
end

function themeMetaTable:IsBackgroundTextWhite()
	return self:IsDarkBackground()
end

function themeMetaTable:GetBackgroundTextColour(emphasis)
	--##if !emphasisCheck(emphasis) then error("'emphasis' argument is not a valid emphasis enum!", 2) end
	return self:IsBackgroundTextBlack()
		   and sKore.textColours[sKore.DARK][emphasis]
		   or sKore.textColours[sKore.LIGHT][emphasis]
end

function themeMetaTable:GetBackgroundTextColourInverted(emphasis)
	--##if !emphasisCheck(emphasis) then error("'emphasis' argument is not a valid emphasis enum!", 2) end
	return self:IsBackgroundTextBlack()
		   and sKore.textColours[sKore.LIGHT][emphasis]
		   or sKore.textColours[sKore.DARK][emphasis]
end

function themeMetaTable:GetBackgroundMaterial(name)
	--##if !isstring(name) then error("'name' argument is not a string!", 2) end
	return self:IsBackgroundTextBlack()
		   and sKore.materials[sKore.DARK][name]
		   or sKore.materials[sKore.LIGHT][name]
		   or sKore.materials[sKore.DARK][name]
		   or Material(name)
end

function themeMetaTable:GetBackgroundMaterialInverted(name)
	--##if !isstring(name) then error("'name' argument is not a string!", 2) end
	return self:IsBackgroundTextBlack()
		   and sKore.materials[sKore.LIGHT][name]
		   or sKore.materials[sKore.DARK][name]
		   or sKore.materials[sKore.LIGHT][name]
		   or Material(name)
end

function themeMetaTable:GetShadowColour()
	return self:IsDarkBackground()
		   and sKore.backgroundColours[sKore.LIGHT]["shadow"]
		   or sKore.backgroundColours[sKore.DARK]["shadow"]
end

function themeMetaTable:RestrictToUsergroups(...)
	local usergroups = {...}
	local efficientTable = {}
	for key, usergroup in ipairs(usergroups) do
		if !isstring(usergroup) then error("Argument #" .. key .. " is not a string!", 2) end
		efficientTable[usergroup] = true
	end
	self.permissions = efficientTable
end

function themeMetaTable:HasPermission()
	return self.permissions == nil
		   or table.Count(self.permissions) == 0
		   or self.permissions[LocalPlayer():GetUserGroup()]
		   or false
end

function themeMetaTable:SetFailMessage(message)
	if !isstring(message) then error("'message' argument is not a string!", 2) end
	self.failMessage = message
end

function themeMetaTable:GetFailMessage()
	return sKore.getPhrase(self.failMessage or "#default_fail_message", self:GetName())
end

function themeMetaTable:SetPrimaryColours(primaryDark, primary, primaryLight)
	primaryDark = sKore.hexToColour(primaryDark) or primaryDark
	primary = sKore.hexToColour(primary) or primary
	primaryLight = sKore.hexToColour(primaryLight) or primaryLight
	if !sKore.isColour(primaryDark) then error("'primaryDark' argument is not a valid colour (first argument)!", 2) end
	if !sKore.isColour(primary) then error("'primary' argument is not a valid colour (second argument)!", 2) end
	if !sKore.isColour(primaryLight) then error("'primaryLight' argument is not a valid colour (third argument)!", 2) end
	self.colours[sKore.PRIMARY_DARK] = primaryDark
	self.colours[sKore.PRIMARY] = primary
	self.colours[sKore.PRIMARY_LIGHT] = primaryLight
end

function themeMetaTable:SetPrimaryColour(level, colour)
	if !levelCheck(level) then error("'level' argument is not a valid level enum!", 2) end
	colour = sKore.hexToColour(colour) or colour
	if !sKore.isColour(colour) then error("'colour' argument is not a valid colour!", 2) end
	self.colours[level] = colour
end

function themeMetaTable:GetPrimaryColour(level)
	--##if !levelCheck(level) then error("'level' argument is not a valid level enum!", 2) end
	return self.colours[level] or Color(255, 255, 255)
end

function themeMetaTable:SetPrimaryTextColours(primaryDark, primary, primaryLight)
	if !isbool(primaryDark) then error("'primaryDark' argument is not a boolean!", 2) end
	if !isbool(primary) then error("'primary' argument is not a boolean!", 2) end
	if !isbool(primaryLight) then error("'primaryLight' argument is not a boolean!", 2) end
	self.textColours[sKore.PRIMARY_DARK] = primaryDark
	self.textColours[sKore.PRIMARY] = primary
	self.textColours[sKore.PRIMARY_LIGHT] = primaryLight
end

function themeMetaTable:SetPrimaryTextColour(level, colour)
	if !levelCheck(level) then error("'level' argument is not a valid level enum!", 2) end
	if !isbool(colour) then error("'colour' argument is not a boolean!", 2) end
	self.textColours[level] = colour
end

function themeMetaTable:IsDarkPrimary(level)
	--##if !levelCheck(level) then error("'level' argument is not a valid level enum!", 2) end
	return self.textColours[level] == sKore.LIGHT or false
end

function themeMetaTable:IsLightPrimary(level)
	--##if !levelCheck(level) then error("'level' argument is not a valid level enum!", 2) end
	return !self:IsDarkPrimary(level)
end

function themeMetaTable:IsPrimaryTextBlack(level)
	--##if !levelCheck(level) then error("'level' argument is not a valid level enum!", 2) end
	return self:IsLightPrimary(level)
end

function themeMetaTable:IsPrimaryTextWhite(level)
	--##if !levelCheck(level) then error("'level' argument is not a valid level enum!", 2) end
	return self:IsDarkPrimary(level)
end

function themeMetaTable:GetPrimaryTextColour(level, emphasis)
	--##if !levelCheck(level) then error("'level' argument is not a valid level enum!", 2) end
	--##if !emphasisCheck(emphasis) then error("'emphasis' argument is not a valid emphasis enum!", 2) end
	return self:IsPrimaryTextBlack(level)
		   and sKore.textColours[sKore.DARK][emphasis]
		   or sKore.textColours[sKore.LIGHT][emphasis]
end

function themeMetaTable:GetPrimaryTextColourInverted(level, emphasis)
	--##if !levelCheck(level) then error("'level' argument is not a valid level enum!", 2) end
	--##if !emphasisCheck(emphasis) then error("'emphasis' argument is not a valid emphasis enum!", 2) end
	return self:IsPrimaryTextBlack(level)
		   and sKore.textColours[sKore.LIGHT][emphasis]
		   or sKore.textColours[sKore.DARK][emphasis]
end

function themeMetaTable:GetPrimaryMaterial(level, name)
	--##if !levelCheck(level) then error("'level' argument is not a valid level enum!", 2) end
	--##if !isstring(name) then error("'name' argument is not a string!", 2) end
	return self:IsPrimaryTextBlack(level)
		   and sKore.materials[sKore.DARK][name]
		   or sKore.materials[sKore.LIGHT][name]
		   or sKore.materials[sKore.DARK][name]
		   or Material(name)
end

function themeMetaTable:GetPrimaryMaterialInverted(level, name)
	--##if !levelCheck(level) then error("'level' argument is not a valid level enum!", 2) end
	--##if !isstring(name) then error("'name' argument is not a string!", 2) end
	return self:IsPrimaryTextBlack(level)
		   and sKore.materials[sKore.LIGHT][name]
		   or sKore.materials[sKore.DARK][name]
		   or sKore.materials[sKore.LIGHT][name]
		   or Material(name)
end

function sKore.isDarkBackground()
	return sKore.getActiveTheme():IsDarkBackground()
end

function sKore.isLightBackground()
	return sKore.getActiveTheme():IsLightBackground()
end

function sKore.getBackgroundColour(level)
	--##if !levelCheck(level) then error("'level' argument is not a valid level enum!", 2) end
	return sKore.getActiveTheme():GetBackgroundColour(level)
end

function sKore.getBackgroundColourInverted(level)
	--##if !levelCheck(level) then error("'level' argument is not a valid level enum!", 2) end
	return sKore.getActiveTheme():GetBackgroundColourInverted(level)
end

function sKore.isBackgroundTextBlack()
	return sKore.getActiveTheme():IsBackgroundTextBlack()
end

function sKore.isBackgroundTextWhite()
	return sKore.getActiveTheme():IsBackgroundTextWhite()
end

function sKore.getBackgroundTextColour(emphasis)
	--##if !emphasisCheck(emphasis) then error("'emphasis' argument is not a valid emphasis enum!", 2) end
	return sKore.getActiveTheme():GetBackgroundTextColour(emphasis)
end

function sKore.getBackgroundTextColourInverted(emphasis)
	--##if !emphasisCheck(emphasis) then error("'emphasis' argument is not a valid emphasis enum!", 2) end
	return sKore.getActiveTheme():GetBackgroundTextColourInverted(emphasis)
end

function sKore.getBackgroundMaterial(name)
	--##if !isstring(name) then error("'name' argument is not a string!", 2) end
	return sKore.getActiveTheme():GetBackgroundMaterial(name)
end

function sKore.getBackgroundMaterialInverted(name)
	--##if !isstring(name) then error("'name' argument is not a string!", 2) end
	return sKore.getActiveTheme():GetBackgroundMaterialInverted(name)
end

function sKore.getShadowColour()
	return sKore.getActiveTheme():GetShadowColour()
end

function sKore.getPrimaryColour(level)
	--##if !levelCheck(level) then error("'level' argument is not a valid level enum!", 2) end
	return sKore.getActiveTheme():GetPrimaryColour(level)
end

function sKore.getPrimaryTextColour(level, emphasis)
	--##if !levelCheck(level) then error("'level' argument is not a valid level enum!", 2) end
	--##if !emphasisCheck(emphasis) then error("'emphasis' argument is not a valid emphasis enum!", 2) end
	return sKore.getActiveTheme():GetPrimaryTextColour(level, emphasis)
end

function sKore.getPrimaryTextColourInverted(level, emphasis)
	--##if !levelCheck(level) then error("'level' argument is not a valid level enum!", 2) end
	--##if !emphasisCheck(emphasis) then error("'emphasis' argument is not a valid emphasis enum!", 2) end
	return sKore.getActiveTheme():GetPrimaryTextColourInverted(level, emphasis)
end

function sKore.isDarkPrimary(level)
	--##if !levelCheck(level) then error("'level' argument is not a valid level enum!", 2) end
	return sKore.getActiveTheme():IsDarkPrimary(level)
end

function sKore.isLightPrimary(level)
	--##if !levelCheck(level) then error("'level' argument is not a valid level enum!", 2) end
	return sKore.getActiveTheme():IsLightPrimary(level)
end

function sKore.isPrimaryTextBlack(level)
	--##if !levelCheck(level) then error("'level' argument is not a valid level enum!", 2) end
	return sKore.getActiveTheme():IsPrimaryTextBlack(level)
end

function sKore.isPrimaryTextWhite(level)
	--##if !levelCheck(level) then error("'level' argument is not a valid level enum!", 2) end
	return sKore.getActiveTheme():IsPrimaryTextWhite(level)
end

function sKore.getPrimaryMaterial(level, name)
	--##if !levelCheck(level) then error("'level' argument is not a valid level enum!", 2) end
	--##if !isstring(name) then error("'name' argument is not a string!", 2) end
	return sKore.getActiveTheme():GetPrimaryMaterial(level, name)
end

function sKore.getPrimaryMaterialInverted(level, name)
	--##if !levelCheck(level) then error("'level' argument is not a valid level enum!", 2) end
	--##if !isstring(name) then error("'name' argument is not a string!", 2) end
	return sKore.getActiveTheme():GetPrimaryMaterialInverted(level, name)
end

function sKore.isValidThemeID(id)
	return isstring(id) and sKore.themesID[id] != nil
end

function sKore.isValidThemeName(name)
	return isstring(name) and sKore.themes[name] != nil
end

function sKore.getThemeByID(id)
	--##if !sKore.isValidThemeID(id) then error("'id' argument is not a valid theme id!", 2) end
	return sKore.themesID[id] or nil
end

function sKore.getThemeByName(name)
	--##if !sKore.isValidThemeName(name) then error("'name' argument is not a valid theme name!", 2) end
	return sKore.themes[name]
end

function sKore.getDefaultThemeID()
	return sKore.getDefaultTheme():GetID()
end

function sKore.getDefaultThemeName()
	return sKore.config["defaultThemes"][LocalPlayer():GetUserGroup()]
		   or sKore.config["defaultThemes"]["default"]
end

function sKore.getDefaultTheme()
	return sKore.getThemeByName(sKore.getDefaultThemeName())
end

function sKore.updateThemeConvar()
	if sKore.themeConvar != nil then
		sKore.themeConvar:SetString(sKore.themeConvar:GetString())
		return
	end

	local help = "Available themes: " .. (sKore.listToString(table.GetKeys(sKore.themesID)) or "NONE") .. ". Case-sensitive!"

	sKore.themeConvar = CreateClientConVar(sKore.config["themeConvar"], sKore.getDefaultThemeID(), false, false, help)
	cvars.RemoveChangeCallback(sKore.config["themeConvar"], "sKoreThemeCallback")
	cvars.AddChangeCallback(sKore.config["themeConvar"], function(convar, oldValue, newValue)
		if !sKore.config["allowThemeSelection"] then
			sKore.activeTheme = sKore.getDefaultTheme()
			return
		elseif !sKore.isValidThemeID(newValue) or !sKore.getThemeByID(newValue):HasPermission() then
			sKore.themeConvar:SetString(
				sKore.isValidThemeID(oldValue) and sKore.getThemeByID(oldValue):HasPermission() and oldValue
				or sKore.getDefaultThemeID()
			)
		elseif newValue != oldValue or sKore.activeTheme == nil then
			newValue = newValue:lower()
			sKore.activeTheme = sKore.getThemeByID(newValue)
			sKore.fileTable["theme"] = newValue
			file.Write(sKore.filePath, util.TableToJSON(sKore.fileTable))
			hook.Run("sKoreThemeUpdated")
		end
	end, "sKoreThemeCallback")

	sKore.themeConvar:SetString(sKore.fileTable["theme"] or sKore.getDefaultThemeID())
end

function sKore.getActiveThemeID()
	return sKore.getActiveTheme():GetID()
end

function sKore.getActiveThemeName()
	return sKore.getActiveTheme().name
end

function sKore.getActiveThemeFancyName()
	return sKore.getActiveTheme():GetName()
end

function sKore.getActiveTheme()
	return sKore.activeTheme or sKore.getDefaultTheme()
end

function sKore.testThemeConfig()
	local fileName = "skore/config/themes.lua"

	assert(isbool(sKore.config["allowThemeSelection"]), Format("The '%s' setting on '%s' is not a boolean!", "allowThemeSelection", fileName))

	assert(isstring(sKore.config["themeConvar"]), Format("The '%s' setting on '%s' is not a string!", "themeConvar", fileName))
	assert(string.Trim(sKore.config["themeConvar"]) != "", Format("The '%s' setting on '%s' is either an empty string or just whitespace!", "themeConvar", fileName))

	assert(istable(sKore.config["themeSelectionMenuChat"]), Format("The '%s' setting on '%s' is not a table!", "themeSelectionMenuChat", fileName))
	assert(table.IsSequential(sKore.config["themeSelectionMenuChat"]), Format("The '%s' setting on '%s' is not a sequential table!", "themeSelectionMenuChat", fileName))
	local optimizedTable = {}
	for key, value in pairs(sKore.config["themeSelectionMenuChat"]) do
		assert(isstring(value), Format("The key #%s of the '%s' setting on '%s' is not a string!", key, "themeSelectionMenuChat", fileName))
		assert(string.Trim(value) != "", Format("The key #%s of the '%s' setting on '%s' is either an empty string or just whitespace!", key, "themeSelectionMenuChat", fileName))
		optimizedTable[value:lower()] = true
	end
	sKore.config["themeSelectionMenuChat"] = optimizedTable

	assert(istable(sKore.config["themeSelectionMenuConsole"]), Format("The '%s' setting on '%s' is not a table!", "themeSelectionMenuConsole", fileName))
	assert(table.IsSequential(sKore.config["themeSelectionMenuConsole"]), Format("The '%s' setting on '%s' is not a sequential table!", "themeSelectionMenuConsole", fileName))
	for key, value in pairs(sKore.config["themeSelectionMenuConsole"]) do
		assert(isstring(value), Format("The key #%s of the '%s' setting on '%s' is not a string!", key, "themeSelectionMenuConsole", fileName))
		assert(string.Trim(value) != "", Format("The key #%s of the '%s' setting on '%s' is either an empty string or just whitespace!", key, "themeSelectionMenuConsole", fileName))
	end

	assert(istable(sKore.config["defaultThemes"]), Format("The '%s' setting on '%s' is not a table!", "defaultThemes", fileName))
	for key, value in pairs(sKore.config["defaultThemes"]) do
		assert(isstring(key), Format("One of the keys of the '%s' setting on '%s' is not a string!", "defaultThemes", fileName))
		assert(sKore.isValidThemeName(value), Format("The key '%s' of the '%s' setting on '%s' is not a valid theme name! Theme names are case-sensitive!", key, "defaultThemes", fileName))
	end
	assert(sKore.config["defaultThemes"]["default"] != nil, Format("The key 'default' is missing in the '%s' setting on '%s'!", "defaultThemes", fileName))

	assert(istable(sKore.config["lightThemeWheel"]), Format("The '%s' setting on '%s' is not a table!", "lightThemeWheel", fileName))
	assert(table.IsSequential(sKore.config["lightThemeWheel"]), Format("The '%s' setting on '%s' is not a sequential table!", "lightThemeWheel", fileName))
	for key, value in pairs(sKore.config["lightThemeWheel"]) do
		assert(sKore.isValidThemeName(value), Format("The key #%s of the '%s' setting on '%s' is not a valid theme name!", key, "lightThemeWheel", fileName))
	end

	assert(istable(sKore.config["darkThemeWheel"]), Format("The '%s' setting on '%s' is not a table!", "darkThemeWheel", fileName))
	assert(table.IsSequential(sKore.config["darkThemeWheel"]), Format("The '%s' setting on '%s' is not a sequential table!", "darkThemeWheel", fileName))
	for key, value in pairs(sKore.config["darkThemeWheel"]) do
		assert(sKore.isValidThemeName(value), Format("The key #%s of the '%s' setting on '%s' is not a valid theme name!", key, "darkThemeWheel", fileName))
	end
end

function sKore.loadThemes()
	if sKore.loadingThemes then return end
	sKore.loadingThemes = true
	sKore.themes = {}
	sKore.themesID = {}
	include("skore/config/themes.lua")
	sKore.testThemeConfig()
	sKore.updateThemeConvar()
	sKore.loadingThemes = nil
end

function sKore.reloadThemes()
	if sKore.loadingThemes then return end
	sKore.loadThemes()
	hook.Run("sKoreThemeReloaded")
end

sKore.loadThemes()
