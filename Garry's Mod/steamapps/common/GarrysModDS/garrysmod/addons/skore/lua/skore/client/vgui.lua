
sKore.elevationGAS = {
	["SetElevation"] = function(self, elevation)
		if !isnumber(elevation) then error("'elevation' argument is not a number!", 2) end
		self.elevation = elevation
	end,
	["GetElevation"] = function(self)
		local parent = self:GetParent()
		return parent.GetElevation and parent:GetElevation() + self.elevation
			   or self.elevation or 0
	end
}

sKore.shadowGAS = {
	["AddShadow"] = function(self, panel)
		if !ispanel(panel) then error("'panel' argument is not a panel!", 2) end
		self.shadows = self.shadows or {}
		table.insert(self.shadows, panel)
	end,
	["RemoveShadow"] = function(self, panel)
		if !ispanel(panel) then error("'panel' argument is not a panel!", 2) end
		table.RemoveByValue(self.shadows or {}, panel)
	end,
	["ClearShadows"] = function(self)
		self.shadows = nil
	end
}
sKore.AccessorFunc(sKore.shadowGAS, "shadowOffsetX", "ShadowOffsetX", sKore.FORCE_NUMBER)
sKore.AccessorFunc(sKore.shadowGAS, "shadowOffsetY", "ShadowOffsetY", sKore.FORCE_NUMBER)
sKore.AccessorFunc(sKore.shadowGAS, "paintShadow", "PaintShadow", sKore.FORCE_BOOL)
sKore.AccessorFunc(sKore.shadowGAS, "drawShadows", "DrawShadows", sKore.FORCE_BOOL)
sKore.AccessorFunc(sKore.shadowGAS, "drawGlobalShadows", "DrawGlobalShadows", sKore.FORCE_BOOL)
sKore.AccessorFunc(sKore.shadowGAS, "globalShadow", "GlobalShadow", sKore.FORCE_BOOL, function(self, globalShadow)
	if self.frame != nil and self.frame.globalShadows then
		if globalShadow then
			self.frame.globalShadows[self] = true
		else
			self.frame.globalShadows[self] = nil
		end
	end
end)

sKore.enabledGAS = {
	["SetEnabled"] = function(self, enabled, ...)
		if isfunction(enabled) then
			self.enabled = {enabled, {...}}
		elseif isbool(enabled) then
			self.enabled = enabled
		else
			error("'enabled' argument is neither a boolean nor a function!", 2)
		end
		self:InvalidateLayout()
	end,
	["GetEnabled"] = function(self)
		return isfunction(self.enabled)
			   and self.enabled[1](unpack(self.enabled[2]))
			   or self.enabled
			   or false
	end,
	["SetDisabled"] = function(self, disabled, ...)
		if isfunction(disabled) then
			local arguments = {...}
			self.enabled = {function()
				return !disabled(unpack(arguments))
			end, {}}
		elseif isbool(disabled) then
			self.enabled = !disabled
		else
			error("'disabled' argument is neither a boolean nor a function!", 2)
		end
		self:InvalidateLayout()
	end,
	["GetDisabled"] = function(self)
		return !self:GetEnabled()
	end
}
sKore.enabledGAS["IsEnabled"] = sKore.enabledGAS["GetEnabled"]
sKore.enabledGAS["IsDisabled"] = sKore.enabledGAS["GetDisabled"]
