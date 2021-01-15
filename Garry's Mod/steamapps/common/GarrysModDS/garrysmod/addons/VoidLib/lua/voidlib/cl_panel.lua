-- Showcase of VoidUI

concommand.Add("voidui", function ()
	local mainPanel = vgui.Create("VoidUI.Frame")
	mainPanel:SetSize(1100,670)
	mainPanel:MakePopup()
	mainPanel:SetTitle("VoidUI")
	mainPanel:AutoScale()
	mainPanel:Center()

	local sidebar = mainPanel:Add("VoidUI.Sidebar")

	sidebar:AddTab("Grids", VoidUI.Icons.Settings, "VoidUI.S.FirstPanel")
	sidebar:AddTab("Rows", VoidUI.Icons.Settings, "VoidUI.S.SecondPanel")
	sidebar:AddTab("Elements", VoidUI.Icons.Settings, "VoidUI.S.ThirdPanel")
	sidebar:AddTab("Tabs", VoidUI.Icons.Settings, "VoidUI.S.FourthPanel")
	
end)

-- First panel

local PANEL = {}

function PANEL:Init()
    local firstWrapper = self:Add("VoidUI.PanelContent")
	firstWrapper:SetCompact(true)
	firstWrapper:SetTitle("Grid")
	firstWrapper:SDockMargin(100, 100, 100, 20)

	local grid = firstWrapper:Add("VoidUI.Grid")
	grid:Dock(TOP)
	grid:MarginTop(30)
	grid:SetMaxHeight(400)

	grid:SetColumns(2)
	
	for i = 1, 10 do
		local gridPanel = vgui.Create("DPanel")
		gridPanel:SSetTall(80)
		grid:AddCell(gridPanel)
	end

	grid:AutoSize()
end

vgui.Register("VoidUI.S.FirstPanel", PANEL, "VoidUI.PanelContent")

-- Second panel

local PANEL = {}

function PANEL:Init()
    local secondWrapper = self:Add("VoidUI.PanelContent")
	secondWrapper:SetCompact(true)
	secondWrapper:SetTitle("Rows")
	secondWrapper:SDockMargin(100, 100, 100, 0)


	local rows = secondWrapper:Add("VoidUI.RowPanel")
	rows:Dock(TOP)
	rows:MarginTop(30)
	rows:SetSpacing(10)
	rows:SetMaxHeight(400)

	for i = 1, 20 do
		local rowPanel = vgui.Create("DPanel", rows)
		rows:AddRow(rowPanel)
	end

	rows:AutoSize()
end

vgui.Register("VoidUI.S.SecondPanel", PANEL, "VoidUI.PanelContent")

-- Third panel

local PANEL = {}

function PANEL:Init()
    local thirdWrapper = self:Add("VoidUI.PanelContent")
	thirdWrapper:Dock(TOP)
	thirdWrapper:MarginTop(100)
	thirdWrapper:MarginSides(100)
	thirdWrapper:SetCompact(true)
	thirdWrapper:SetTitle("Text Inputs")

	local grid = thirdWrapper:Add("VoidUI.Grid")
	grid:Dock(FILL)
	grid:MarginTop(30)

	grid:SetColumns(2)

	for i = 1, 4 do
		local textinput = grid:Add("VoidUI.TextInput")
		textinput:SSetTall(40)

		if (i % 2 == 0) then
			textinput:SetDark()
		end

		grid:AddCell(textinput)
	end

	grid:AutoSize()
end

vgui.Register("VoidUI.S.ThirdPanel", PANEL, "VoidUI.PanelContent")

-- Fourth panel

local PANEL = {}

function PANEL:Init()
	self:SetTitle("")
    local tabs = self:Add("VoidUI.Tabs")

	local tab1Content = tabs:Add("VoidUI.PanelContent")
	tab1Content:SetTitle("Tab 1")
	local tab2Content = tabs:Add("VoidUI.PanelContent")
	tab2Content:SetTitle("Tab 2")

	local thirdWrapper = tab1Content:Add("VoidUI.PanelContent")
	thirdWrapper:Dock(TOP)
	thirdWrapper:MarginTop(100)
	thirdWrapper:MarginSides(100)
	thirdWrapper:SetCompact(true)
	thirdWrapper:SetTitle("Text Inputs")

	local grid = thirdWrapper:Add("VoidUI.Grid")
	grid:Dock(FILL)
	grid:MarginTop(30)

	grid:SetColumns(2)

	for i = 1, 4 do
		local textinput = grid:Add("VoidUI.TextInput")
		textinput:SSetTall(40)

		if (i % 2 == 0) then
			textinput:SetDark()
		end

		grid:AddCell(textinput)
	end

	local colorpicker = grid:Add("VoidUI.ColorMixer")
	colorpicker:SSetTall(110)
	grid:AddCell(colorpicker)

	grid:AutoSize()

	local secondWrapper = tab2Content:Add("VoidUI.PanelContent")
	secondWrapper:SetCompact(true)
	secondWrapper:SetTitle("Rows")
	secondWrapper:SDockMargin(100, 100, 100, 0)


	local rows = secondWrapper:Add("VoidUI.RowPanel")
	rows:Dock(TOP)
	rows:MarginTop(30)
	rows:SetSpacing(10)
	rows:SetMaxHeight(400)

	for i = 1, 20 do
		local rowPanel = vgui.Create("DPanel", rows)
		rows:AddRow(rowPanel)
	end

	rows:AutoSize()

	local tab1 = tabs:AddTab("Tab 1", tab1Content)
	local tab2 = tabs:AddTab("Tab 2", tab2Content)
end

vgui.Register("VoidUI.S.FourthPanel", PANEL, "VoidUI.PanelContent")