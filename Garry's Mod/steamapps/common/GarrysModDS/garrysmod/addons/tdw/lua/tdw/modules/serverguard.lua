local MODULE = TDW.CreateModule()

/*---------------------------------------------------------------------------
	Basic module info
---------------------------------------------------------------------------*/
MODULE.Name = "Serverguard"
MODULE.Description = "Support for the Serverguard Admin Mod."

local function parseArg(arg)
	if(isentity(arg) && IsValid(arg) && arg:IsPlayer()) then return arg:DNick() end
	if(isstring(arg) || isnumber(arg)) then return arg end
end

/*---------------------------------------------------------------------------
	Helper functions
---------------------------------------------------------------------------*/
MODULE:AddHook("serverguard.RanCommand", function(ply, commandTable, silent, arguments)
	if(!IsValid(ply) || !ply:IsPlayer()) then return end

	TDW.Steam:GetPlayerInfo(ply, function(info)
		local embed = TDW.RichEmbed()

		embed:SetAuthor("Serverguard Command Ran", info.avatar, info.profileurl)
		embed:SetDescription(ply:DNick().." has ran the command `"..commandTable.command.."`.")

		local args = {}
		table.Add(args, commandTable.arguments)
		table.Add(args, commandTable.optionalArguments)

		for k, v in pairs(args) do
			if(!arguments[k]) then break end
			embed:AddField(string.Capitalize(v), parseArg(arguments[k]), true)
		end

		embed:SetTimestamp()
		embed:SetColor("serverguard")

		TDW.SendEmbed(embed)
	end)
end)

TDW.RegisterModule(MODULE)