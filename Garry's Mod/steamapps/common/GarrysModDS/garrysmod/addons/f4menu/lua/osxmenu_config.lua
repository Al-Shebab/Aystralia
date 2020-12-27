-- Navigation menu settings
-- You can add external links to donation pages, websites, etc.
F4Menu.Links = {
	-- Example:
	-- ['Donate'] = 'http://google.com',
}

-- Advanced configuration
-- Change to 'true' if you want to hide shipments that are not for your job
F4Menu.HideOtherShipments = false

-- Change to 'true' if you want to close menu after choosing job
F4Menu.CloseOnJobChange = false

-- Theme configuration
-- You can switch light theme to the dark one, by replacing F4Menu.Colors parameters, that you can find in dark_theme.txt file.
F4Menu.Colors = {

	-- Border radius of frame
	BorderRadius = 8,

	-- Text color
	Text = Color(89, 96, 102),

	-- Small text color
	TextSmall = Color(167, 167, 167),

	-- Background color
	Background = Color(255, 255, 255),

	-- Button color
	Button = Color(44, 161, 44),

	-- Negative button color
	ButtonNegative = Color(253, 100, 95),

	-- Context menu arrow color
	Arrow = Color(161, 161, 161),

	-- Job overlay color
	OverlayColor = Color(255, 255, 255, 186),

	-- Selected item color
	ItemSelected = Color(237, 238, 241),

	-- Title bar color 
	TitleBar = Color(248, 247, 247),

	-- Title bar border color
	TitleBorder = Color(225, 225, 225),

	-- Border color
	Border = Color(237, 237, 242),

	-- Navigation menu item color
	NavItem = Color(93, 172, 223),

	-- Navigation menu hover color
	NavItemHover = Color(48, 144, 198),

	-- Navigation menu text color
	NavItemText = Color(255, 255, 255),

	-- Context menu hover
	ContextMenuSelected = Color(1, 93, 202),

	-- String request menu bottom bar
	RequestBottomBar = Color(249, 249, 249),

	-- Text entry caret color
	CaretColor = Color(63, 75, 95),

	-- Scroll bar color
	ScrollBar = Color(200, 200, 200, 180)

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
