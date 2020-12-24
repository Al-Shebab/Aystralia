if(!bLogs) then return end

local MODULE = TDW.CreateModule()

MODULE.Name = "bLogs"
MODULE.Description = "Support for bLogs - relays everything to Discord."

TDW.OldBLogs = TDW.OldBLogs || bLogs.Log

function bLogs.Log(self, module, log)
	if(!MODULE:IsDisabled()) then
		local embed = TDW.RichEmbed()

		local str = self:PlainTextLog(log)
		local mod = bLogs.Modules[module]

		embed:SetTitle(mod.Category.." - "..mod.Name)
		embed:SetDescription(str)
		embed:SetColor(mod.Colour)
		embed:SetTimestamp()
		embed:SetFooter(mod.Name)

		TDW.SendEmbed(embed)
	end

	return TDW.OldBLogs(self, module, log)
end

TDW.RegisterModule(MODULE)