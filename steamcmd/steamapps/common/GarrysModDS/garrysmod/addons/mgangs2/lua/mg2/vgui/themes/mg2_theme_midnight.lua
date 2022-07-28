--[[
    MGangs 2 - (SH) VGUI THEME - Midnight
    Developed by Zephruz
]]

local MIDNIGHT_THEME = mg2.vgui:RegisterTheme("Midnight")

--[[FRAME]]
MIDNIGHT_THEME:AddColor("frame.Background", Color(50,50,50,125))
MIDNIGHT_THEME:AddColor("frame.Title", Color(255,255,255))
MIDNIGHT_THEME:AddColor("frame.NavBar", Color(40,40,40))
MIDNIGHT_THEME:AddColor("frame.SideNav.Background", Color(55,55,55))

--[[NAVIGATION BUTTON]]
MIDNIGHT_THEME:AddColor("navButton.Background", Color(65,65,65))
MIDNIGHT_THEME:AddColor("navButton.Background.Hover", Color(60,60,60))
MIDNIGHT_THEME:AddColor("navButton.Active.Line", Color(54,100,139,150))
MIDNIGHT_THEME:AddColor("navButton.Active", Color(45,45,45))

--[[TEXT ENTRY]]
MIDNIGHT_THEME:AddColor("textentry.Background", Color(55,55,55))
MIDNIGHT_THEME:AddColor("textentry.Background.Active", Color(65,65,65))
MIDNIGHT_THEME:AddColor("textentry.Text", Color(255,255,255))
MIDNIGHT_THEME:AddColor("textentry.Warn", Color(225,85,85))

--[[DROPDOWN]]
MIDNIGHT_THEME:AddColor("dropdown.Background", Color(55,55,55))
MIDNIGHT_THEME:AddColor("dropdown.Background.Active", Color(65,65,65,245))
MIDNIGHT_THEME:AddColor("dropdown.Text", Color(255,255,255))

--[[BUTTON]]
MIDNIGHT_THEME:AddColor("button.Background", Color(55,55,55))
MIDNIGHT_THEME:AddColor("button.Background.Hover", Color(54,100,139,255))
MIDNIGHT_THEME:AddColor("button.Background.Disabled", Color(45,45,45))
MIDNIGHT_THEME:AddColor("button.Image", Color(255,255,255))

--[[CLOSE BUTTON]]
MIDNIGHT_THEME:AddColor("closeButton.Background", Color(55,55,55))
MIDNIGHT_THEME:AddColor("closeButton.Background.Hover", Color(54,100,139,150))
MIDNIGHT_THEME:AddColor("closeButton.Text", Color(255,255,255))

--[[CONTAINER]]
MIDNIGHT_THEME:AddColor("container.Background", Color(40,40,40,200))

--[[HEADER]]
MIDNIGHT_THEME:AddColor("header.Background", Color(40,40,40))
MIDNIGHT_THEME:AddColor("header.Text", Color(255,255,255))

--[[SCROLL PANEL]]
MIDNIGHT_THEME:AddColor("scrollPanel.Scrollbar.Grip", Color(54,100,139,225))

--[[SLIDER BAR]]
MIDNIGHT_THEME:AddColor("numSlider.Knob.Active", Color(55,55,55))
MIDNIGHT_THEME:AddColor("numSlider.Knob.Inactive", Color(65,65,65))

--[[PROGRESS BAR]]
MIDNIGHT_THEME:AddColor("progressBar.Bar", Color(84,130,169))
MIDNIGHT_THEME:AddColor("progressBar.Bar.Underline", Color(54,100,139))
MIDNIGHT_THEME:AddColor("progressBar.Background", Color(40,40,40,200))
MIDNIGHT_THEME:AddColor("progressBar.Text", Color(255,255,255))

--[[CHECK BOX]]
MIDNIGHT_THEME:AddColor("checkBox.Background", Color(55,55,55))
MIDNIGHT_THEME:AddColor("checkBox.Background.Active", Color(85,175,85))

--[[HINT PANEL]]
MIDNIGHT_THEME:AddColor("hintPanel.Background", Color(55,55,55))
MIDNIGHT_THEME:AddColor("hintPanel.Background.TimeSlider", Color(54,100,139))