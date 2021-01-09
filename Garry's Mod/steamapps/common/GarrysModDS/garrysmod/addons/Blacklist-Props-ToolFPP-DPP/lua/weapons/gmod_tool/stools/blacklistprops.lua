/*==========================================
    Blacklist Tool for FPP & BPP  
    Copyright Ossified Development 2017  
============================================*/

TOOL.Name								= "Blacklist Props"
TOOL.Category							= "Props Tool"
TOOL.Command 							= nil
TOOL.ConfigName 						= nil
TOOL.Information = {
	{ name = "left" },
	{ name = "right" },
	
}
/*==============================================================================================
	Server
==============================================================================================*/

if SERVER then
	
	function TOOL:LeftClick(Trace)
		
		if not IsValid(Trace.Entity) then return end
		
		RunConsoleCommand("FPP_AddBlockedModel", Trace.Entity:GetModel(), Trace.Entity:EntIndex())
		Trace.Entity:Remove()
		
		RunConsoleCommand("dpp_addblockedmodel ", Trace.Entity:GetModel(), Trace.Entity:EntIndex())
		Trace.Entity:Remove()
		
		return true
	end
	
	function TOOL:RightClick(Trace)
		
		if not IsValid(Trace.Entity) then return end
		
		RunConsoleCommand("FPP_RemoveBlockedModel", Trace.Entity:GetModel(), Trace.Entity:EntIndex())
		Trace.Entity:Remove()
		
		RunConsoleCommand("dpp_removeblockedmodel", Trace.Entity:GetModel(), Trace.Entity:EntIndex())
		Trace.Entity:Remove()
		
		return true
	end
	
end


/*==============================================================================================
	Client
==============================================================================================*/

if CLIENT then

--Add the Toolgun HUD at the top left	
	language.Add( "tool.blacklistprops.name", "Blacklist Props" )
	language.Add( "tool.blacklistprops.desc", "Blacklists a prop" )
	language.Add( "tool.blacklistprops.help", "Hit a prop with the tool." )
	language.Add( "tool.blacklistprops.left", "Blacklist a prop" )
	language.Add( "tool.blacklistprops.right", "UnBlacklists a prop")
	
	
	function TOOL.BuildCPanel(CPanel)
		
		CPanel:AddControl("Header", { Text = "Blacklist Tool for FPP & DPP", Description = "Blacklist Tool for FPP & DPP by Sad Taco\n\n" })
		CPanel:AddControl("Label", { Text = "Below Items are Coming Soon"})
		CPanel:AddControl("Button", { Label = "Download FPP", Command = ""})
		CPanel:AddControl("Button", { Label = "Download DPP(Recommended)", Command = ""})
		
	end
	--Add Console Commands for buttons
	
end