--[[
	SLib - Szymekk's Library 
	
	A library that does everything for me (Don't repeat yourself).
	
	config.luaa
	17.04.2016 10:18:10
	Compiled using LuaAdvanced
	This file should not be modified.
	
	Copyright © 2016 Szymon (Szymekk) Jankowski
	All Rights Reserved
	Steam: https://steamcommunity.com/id/szymski
]]

file.CreateDir("slib_configs")
SLib.Config.All = { }
local values = { }

-- SLib_Config class metatable
CSLib_Config = { }
CSLib_Config.__index = CSLib_Config
CSLib_Config.__type = "SLib_Config"
CSLib_Config.__baseclasses = { }
CSLib_Config.__initializers = { }
luaa.Inherit(CSLib_Config, CLUAA_Object)

function CSLib_Config:RegisterValue(name, type, value, description)
	self.DefaultValues[#self.DefaultValues + 1] = { ["Name"] = name, ["Type"] = type, ["Value"] = value, ["Description"] = description, }
	self:SetValue(name, value)
end
function CSLib_Config:SetValue(name, value)
	self.Values[name] = value
end
function CSLib_Config:GetValue(name, value)
	return self.Values[name]
end
function CSLib_Config:Save()
	local built = self:Build()
	hook.Call("SLib_ConfigReloaded", nil, self.AddonId, built)
	file.Write("slib_configs/" .. self.AddonId .. ".txt", util.TableToJSON(self.Values))
end
function CSLib_Config:LoadFromFile()
	if(not (file.Exists("slib_configs/" .. self.AddonId .. ".txt", "DATA"))) then
		return
	end
	
	print(self.AddonNiceName .. " configuration has been loaded from file")
	local data = util.JSONToTable(file.Read("slib_configs/" .. self.AddonId .. ".txt"))
	self.Values = data
end
function CSLib_Config:Finish()
	self:LoadFromFile()
end
function CSLib_Config:Build()
	local tbl = { }
	
	for k, v in pairs(self.Values) do
			tbl[k] = v
	
	
	end
	
	return tbl
end

CSLib_Config.__initializers[#CSLib_Config.__initializers + 1] = function(self)
    	self.AddonId = nil
	self.AddonNiceName = nil
	self.DefaultValues = { }
	self.Values = { }

end

function CSLib_Config:__new(...)
    for k, v in pairs(self.__initializers) do
        v(self)
    end
    
end
function SLib_Config(...)
    local tbl = { }
    setmetatable(tbl, CSLib_Config)
    tbl:__new(...);
    return tbl
end

function SLib.Config.Create(addonId, addonNiceName)
	local config = SLib_Config()
	config.AddonId = addonId
	config.AddonNiceName = addonNiceName
	SLib.Config.All[addonId] = config
	return config

end

