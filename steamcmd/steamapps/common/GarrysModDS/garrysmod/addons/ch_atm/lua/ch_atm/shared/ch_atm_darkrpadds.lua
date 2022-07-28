function CH_ATM.DarkRPAdds()
	DarkRP.createEntity("Credit Card Terminal", {
		ent = "ch_atm_card_scanner",
		model = "models/craphead_scripts/ch_atm/terminal.mdl",
		price = 250,
		max = 2,
		cmd = "buycreditcardterminal"
	})
end
hook.Add( "loadCustomDarkRPItems", "CH_ATM.DarkRPAdds", CH_ATM.DarkRPAdds )