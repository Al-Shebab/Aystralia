-- Navigation menu settings
-- You can add external links to donation pages, websites, etc.
F4Menu.Links = {
	-- Example:
	 ['------ Server Links ------'] = '',
	 ['Discord'] = '',
	 ['Workshop Collection'] = '',
	 ['Steam Group'] = '',
	 ['Rules'] = '',
}

-- Advanced configuration
-- Change to 'true' if you want to hide shipments that are not for your job
F4Menu.HideOtherShipments = true

-- Change to 'true' if you want to close menu after choosing job
F4Menu.CloseOnJobChange = true

-- Theme configuration
-- You can switch light theme to the dark one, by replacing F4Menu.Colors parameters, that you can find in dark_theme.txt file.
F4Menu.Colors = {

	-- Border radius of frame
	BorderRadius = 8,

	-- Text color
	Text = Color(173, 173, 173),

	-- Small text color
	TextSmall = Color(98, 99, 102),

	-- Background color
	Background = Color(31, 32, 35),

	-- Button color
	Button = Color(42, 232, 70),

	-- Negative button color
	ButtonNegative = Color(255, 50, 70),

	-- Context menu arrow color
	Arrow = Color(88, 88, 92),

	-- Job overlay color
	OverlayColor = Color(33, 34, 37, 186),

	-- Selected item color
	ItemSelected = Color(42, 44, 51),

	-- Title bar color 
	TitleBar = Color(33, 34, 37),

	-- Title bar border color
	TitleBorder = Color(29, 29, 29),

	-- Border color
	Border = Color(28, 28, 30),

	-- Navigation menu item color
	NavItem = Color(229, 59, 106),

	-- Navigation menu hover color
	AcceptButtonHover = Color(229, 80, 106),

	-- Navigation menu text color
	NavItemText = Color(255, 255, 255),

	-- Context menu hover
	ContextMenuSelected = Color(1, 93, 202),

	-- String request menu bottom bar
	RequestBottomBar = Color(33, 34, 37),

	-- Text entry caret color
	CaretColor = Color(63, 75, 95),

	-- Scroll bar color
	ScrollBar = Color(44, 45, 47)

}

-- Translation 
F4Menu.Translation = {
	['submit'] = 'Submit',
	['cancel'] = 'Cancel',
	-- ['weapons'] = 'Weapons',
	['drop_money'] = 'Drop money',
	['amount'] = 'Amount',
	['how_much_money'] = 'How much money do you want to drop?',
	['drop_weapon'] = 'Drop weapon',
	['change_name'] = 'Change name',
	['nickname'] = 'Nickname',
	['change_job'] = 'Change job',
	['job'] = 'Job',
	['sleep'] = 'Sleep/Wake up',
	['request_license'] = 'Request license',
	['advert'] = 'Advert',
	['lockdown'] = 'Lockdown/Unlockdown',
	['weapons'] = 'Weapons',
	['set_agenda'] = 'Set agenda',
	['agenda'] = 'Agenda'
}
