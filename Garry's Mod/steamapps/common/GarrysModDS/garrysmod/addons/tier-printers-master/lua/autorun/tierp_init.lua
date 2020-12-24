TierPrinters = {}

print("Loading Tier Printers")
if SERVER then
	resource.AddWorkshop("955808182")
	include("sh_tierprinters_config.lua")
	AddCSLuaFile("sh_tierprinters_config.lua")


	hook.Add("bLogs_FullyLoaded", "tierprinters_load_blogs", function()
		TierPrinters.blogs = bLogs:Module()

		TierPrinters.blogs.Category = "Owain's Addons"
		TierPrinters.blogs.Name     = "Tier Printers"
		TierPrinters.blogs.Colour   = Color(200, 46, 46)
		
		bLogs:AddModule(TierPrinters.blogs)
	end)
end

if CLIENT then
	include("sh_tierprinters_config.lua")
end
print("Loaded Tier Printers")