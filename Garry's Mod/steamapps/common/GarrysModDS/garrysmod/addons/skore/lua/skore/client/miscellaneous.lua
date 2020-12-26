
sKore.FORCE_STRING = 1
sKore.FORCE_BOOL = 2
sKore.FORCE_NUMBER = 3
sKore.FORCE_COLOUR = 4
sKore.FORCE_MATERIAL = 5
sKore.FORCE_STRING_NIL = -sKore.FORCE_STRING
sKore.FORCE_BOOL_NIL = -sKore.FORCE_BOOL
sKore.FORCE_NUMBER_NIL = -sKore.FORCE_NUMBER
sKore.FORCE_COLOUR_NIL = -sKore.FORCE_COLOUR
sKore.FORCE_MATERIAL_NIL = -sKore.FORCE_MATERIAL

sKore.FORCE_COLOR = sKore.FORCE_COLOUR
sKore.FORCE_COLOR_NIL = sKore.FORCE_COLOUR_NIL

local defaultValues = {
	[sKore.FORCE_STRING] = "",
	[sKore.FORCE_BOOL] = false,
	[sKore.FORCE_NUMBER] = 0,
	[sKore.FORCE_COLOR] = Color(255, 255, 255),
	[sKore.FORCE_MATERIAL] = Material("")
}

local newValueCheck = {
	[sKore.FORCE_STRING] = function(newValue)
		if !isstring(newValue) then error("The new value is not string!", 3) end
	end,
	[sKore.FORCE_BOOL] = function(newValue)
		if !isbool(newValue) then error("The new value is not a boolean!", 3) end
	end,
	[sKore.FORCE_NUMBER] = function(newValue)
		if !isnumber(newValue) then error("The new value is not a number!", 3) end
	end,
	[sKore.FORCE_COLOR] = function(newValue)
		if newValue.r == nil or newValue.g == nil or newValue.b == nil or newValue.a == nil then
			error("The new value is not a colour!", 3)
		end
	end,
	[sKore.FORCE_MATERIAL] = function(newValue)
		if TypeID(newValue) != TYPE_MATERIAL then error("The new value is not a material!", 3) end
	end,
	[sKore.FORCE_STRING_NIL] = function(newValue)
		if !isstring(newValue) and newValue != nil then error("The new value is neither a string nor nil!", 3) end
	end,
	[sKore.FORCE_BOOL_NIL] = function(newValue)
		if !isbool(newValue) and newValue != nil then error("The new value is neither a boolean nor nil!", 3) end -- 76561198166995690
	end,
	[sKore.FORCE_NUMBER_NIL] = function(newValue)
		if !isnumber(newValue) and newValue != nil then error("The new value argument is neither a number nor nil!", 3) end
	end,
	[sKore.FORCE_COLOR_NIL] = function(newValue)
		if (newValue.r == nil or newValue.g == nil or newValue.b == nil or newValue.a == nil) and newValue != nil then
			error("The new value is neither a colour nor nil!", 3)
		end
	end,
	[sKore.FORCE_MATERIAL_NIL] = function(newValue)
		if TypeID(newValue) != TYPE_MATERIAL and newValue != nil then error("The new value is neither a material nor nil!", 3) end
	end
}

function sKore.AccessorFunc(tab, key, name, force, callback)
	if !istable(tab) then error("'tab' argument is not a table!", 2) end
	if !isstring(key) then error("'key' argument is not a string!", 2) end
	if !isstring(name) then error("'name' argument is not a string!", 2) end
	if !isnumber(force) and force != nil then error("'force' argument is neither a number nor nil!", 2) end
	if !isfunction(callback) and callback != nil then error("'force' argument is neither a number nor nil!", 2) end

	local getter = function(self)
		if istable(self[key]) and #self[key] == 2 then
			return self[key][1](unpack(self[key][2]))
		else
			return self[key] or defaultValues[force] or nil
		end
	end

	local setter = function(self, newValue, ...)
		if isfunction(newValue) then
			local arguments = {...}
			local functionReturn = newValue(unpack(arguments))
			if newValueCheck[force] then newValueCheck[force](functionReturn) end
			self[key] = {newValue, arguments}
			if callback then callback(self, functionReturn) end
		else
			if newValueCheck[force] then newValueCheck[force](newValue) end
			self[key] = newValue
			if callback then callback(self, newValue) end
		end
	end

	local source = {
		["Get" .. name] = getter,
		["Set" .. name] = setter,
		["Is" .. name] = (force == sKore.FORCE_BOOL or force == sKore.FORCE_BOOL_NIL)
						 and !string.StartWith(name:lower(), "is") and getter or nil
	}

	table.Merge(tab, source)
end

function sKore.getFrame(panel)
	local parent = panel:GetParent()
	return IsValid(parent) and (parent:GetClassName() == "LuaEditablePanel" and parent
		   or sKore.getFrame(parent))
		   or nil
end

function sKore.invalidateLayoutNow(self)
	self:InvalidateLayout(true)
end

function sKore.invalidateLayout(self)
	self:InvalidateLayout()
end

function sKore.primaryTextColourAlgorithm()
	if sKore.getActiveThemeID() == "night" then
		return sKore.getPrimaryColour(1)
	elseif sKore.isBackgroundTextBlack() then
		if sKore.isDarkPrimary(2) then
			return sKore.getPrimaryColour(2)
		else
			return sKore.getPrimaryColour(1)
		end
	else
		return sKore.getPrimaryColour(3)
	end
end

function sKore.listToString(tab)
	if !istable(tab) then error("'tab' argument is not a table!", 2) end
	if !table.IsSequential(tab) then error("'tab' argument is not a sequential table!", 2) end

	for key, value in ipairs(tab) do tab[key] = Format("'%s'", value) end

	if #tab > 1 then
		return Format("%s and %s", table.concat(tab, ", ", 1, #tab - 1), tab[#tab])
	elseif #themesList == 1 then
		return tab[#tab]
	end

	return nil
end

