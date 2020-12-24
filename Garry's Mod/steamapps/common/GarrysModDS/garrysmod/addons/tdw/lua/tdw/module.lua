/*---------------------------------------------------------------------------
	Basic module library
---------------------------------------------------------------------------*/
moduleMeta = {}
moduleMeta.__index = moduleMeta
moduleMeta.Hooks = {}


/*---------------------------------------------------------------------------
	Registering a hook
---------------------------------------------------------------------------*/
moduleMeta.AddHook = function(self, name, fn)
	if(self.Hooks[name]) then return end
	if(self:IsDisabled()) then return end
	
	hook.Add(name, "TDW:"..self.Name..":"..name, function(...)
		if(self:IsDisabled(name)) then return end
	
		local output = fn(...)
		if(output != nil) then return output end
	end)

	self.Hooks[name] = {
		fn = fn
	}
end

moduleMeta.IsDisabled = function(self, name)
	local disabled = TDW.Config.DisabledModules[self.Name]

	if(istable(disabled)) then
		if(name) then
			return disabled[name]
		else return false end
	else
		return disabled
	end
end


/*---------------------------------------------------------------------------
	Creating a new module
---------------------------------------------------------------------------*/
function TDW.CreateModule()
	return setmetatable({}, moduleMeta)
end


/*---------------------------------------------------------------------------
	Registering a previously created module
---------------------------------------------------------------------------*/
function TDW.RegisterModule(tbl)
	TDW.Modules[tbl.Name] = tbl
end


/*---------------------------------------------------------------------------
	Module loading
---------------------------------------------------------------------------*/
function TDW.LoadModules()
	local files = file.Find("tdw/modules/*", "LUA")

	for k, v in pairs(files) do
		include("tdw/modules/"..v)
	end
end

TDW.LoadModules()
concommand.Add("tdw_reload",  TDW.LoadModules)